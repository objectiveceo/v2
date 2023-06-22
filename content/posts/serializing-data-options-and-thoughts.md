---
title: "Serializing data - options and thoughts"
slug: serializing-data-options-and-thoughts
date: 2023-06-10T14:54:25-04:00
summary: |
  I was working on a side project and had a need to serialize some data.  In
  the end, I wound up giving data serialization more thought and realizing
  that I needed to rethink my strategy.  I figured I'd walk through what data
  serialization is and what options are commonly available.
---

Serializing data used to be a headache of home-grown solutions that were filled
with inconsistencies and bugs.  Today, though, there are lots of great options.
They all solve a similar issue.  Software engineers design their data structures
for efficient usage of memory and CPU utilization.  They don't design them for
transmission or storage.  This, however, is a solved problem.

Back in the day, engineers would create their own algorithms and data structures
for efficiently packing data onto disk.  This was important way back in the days
when hard drives had mere megabytes (or less!) of storage data.  Most of the
time, this meant taking structured data and figuring out how to write it and the
necessary metadata linearly.

Imagine these structs:

```swift
struct Person {
	let name: String
	let age: Int
}

enum PetType {
	Dog,
	Cat
}

struct Pet {
	let name: String
	let age: Int
	let type: PetType
}
```

If you wanted to save it in a format that would let you recreate it together,
you'd need to have some scheme of identifying the type.  You could just have
each class represented by an integer.  So `Person` would be 1, `Pet` would be 2,
and so on.  Let's assume that there's a `Person` named "Tim" whose age is 42.
We have our first byte:

`01`

Now, we need to encode the `name`.  Strings typically vary in size.  Some data
formats decide to make them fixed.  That would work in this case, but let's just
go variable length here and encode the size before the data.  Note that we're
just using one byte, so the longest a name can be is 255 characters:

`01 03`

We can consult the [ASCII table](https://www.asciitable.com) and see that "Tim"
is `0x54 69 6D` in hexidecimal format.  Bytes are often encoded in hex format,
so we'll keep that up.  I mention because this is the first time we've had
numbers that weren't the same in decimal or hex.

`01 03 54 69 6D`

Tim's age is next.  We can confidently just encode it as a byte right after the
name.  42 is `0x2A` in hex:

`01 03 54 69 6D 2A`

Okay!  We've just encoded one entry to a serializable form!  What's next?  Well,
if we wanted to have *more* than one person, we'll need to find some way of
defining a collection type.  This "array of person" could be identified by the
integer `3`.  Then we'd need to encode how many people (in this case 1).  Then
we could just put Tim next in the list.  Prepending the collection data, we'd
get:

`03 01 01 03 54 69 6D 2A`

Then, if had another person named "Sally", we'd update the collection, add a
Person class identifier, add the length of the name, and...:

```
	03 02 01 03 54 69 6D 2A 01 05...
      /                    |      \
	2 people	   Tim ends here   Sally's info
```

Now, a problem starts to creep in.  We've just changed our data format.  If we
had some code that could read "Tim" earlier, it couldn't read this data.  We'd
need to find some way to version our data as we make changes.

Another problem that arises is that this just lays the data out serially.  What
if we wanted to say that Tim took care of one or more pets?  How do we create
that relationship?  We could either encode the Pet information *with* Tim's data
or we'd have to write it to another "collection of Pets" section.  If we had
that section, we'd have to have some identifier or pointer so that we could
associate Tim and his pet(s).  This problem is often solved with some sort of
preface table that described where different parts of the data would be located
within the file.

A third non-problem (but frequent concern) is that a reader often has to read
all of the data and de-serialize it before it can make sense of it.  If we just
wanted portions of the data, we'd have to return to the table idea mentioned
earlier and allow readers to seek to the specific portions they want.  Or we
could encode the length of data for each object so that a reader could skip the
parts they didn't care about easily.

This is starting to get complex.  There is a better way than creating your own
serialization format!

## Just use SQLite unless it's not the right tool

When issues of data serialization come up *for local storage* concerns, I
typically just recommend using [sqlite](https://www.sqlite.org/index.html).
It's a phenomenal library that solves the file format problem for you.  It also
gives you a robust set of SQL commands that lets you create highly efficient
programs.

SQLite is available everywhere and used by nearly everything.  There are
bindings for it for nearly every programming language.  Its ubiquity speaks to
its value: everyone uses it.

The one mistake that I often see is that people treat SQLite only as databases.
Sure, it can do that.  And it's very good at being a single-serve databaes
implementation.  But it's exceptionally good at being a file format as well.
You *could* define a scheme with tables and put *all* of your application data
into one file.  However, it may make more sense to create multiple files that
contain portions of the data.

An example: let's say that you're creating a notetaking application.  You have
multiple documents that store various bits of data, formatting information,
attached items, etc.  You *could* put data about each document into one SQLite
database.  Alternatively, you could make each document its own, separate SQLite
database.  This would mean that each document is a SQLite database that
described that one note file.  It could be passed to other devices or moved
around on disk easily.  You could easily backup or delete individual documents
using the file system.  Old documents could be compressed and archived readily.

Since SQLite offers so much power with so much ease of use, that's nearly always
my first instinct when it comes to serializing data locally.

## What are my other options?

I have a specific use case wherein I want to serialize data locally but then
blit it to a server.  I want to create a lightweight web application that will
load that data and work with it in the browser.  Unfortunately for me, that's
not a great use case for SQLite.

It would be a great use case for JSON.  That's another common serialization
technique.  JSON is excellent because of its ubiquity.  It's even better
integrated into common programming languages than SQLite.  Support for
conversions to and from JSON are native to most modern programming languages.
Unfortunately, JSON can be a bit slow and size-inefficient compared to other
options.  Still, it's mostly human-readable, kind of hand-editable, and
supported in nearly all common use cases.

[Protocol Buffers](https://protobuf.dev) (aka protobufs) are a serialization
format that comes from Google.  It solves a problem that they had with JSON.
JSON's inefficiencies really start to show at scale.  Having a serialization
technique that optimizes for speed and size is exceptionally useful when
optimizing large scale operations.  That said, protobufs are also really great
at creating document formats.  Some of the same techniques that make it such a
good data transfer format (see [gRPC](https://grpc.io)) also make it an
effective storage option.

XML, despite the backlash it back in the aughts, is actually a *decent* storage
medium as well.  This is not the most enthusiastic recommendation, but you could
do *worse*.  There are a lot of tools for interacting with XML.  So it may be a
desirable document type if you wanted to leverage an entire ecosystem of other
tooling that would help you manage complexity or understand your data.

There are other options such as [YAML](https://yaml.org) or
[TOML](https://toml.io/en/).  These two are often used for configuration file
formats.  They're nice because they're human-readable.  Some say that they're
human-writable, but I've found that it's very easy to violate their structure
accidentally, so they're... kind of human-friendly in that respect.  Like SQLite
but unlike JSON or protobufs, these are rarely used as a data transfer object
(DTO) and transmitted over a port.  So if you aren't sending your files over a
network connection and want something that's a little more humane, these are
great options.

Finally, you could always choose to make your own, bespoke serialization format.
I'm going to go ahead and say that you should never do that.  Until you have to.
There may be some use cases where it makes sense, either because of a business
need or other options introduce unacceptable inefficiencies for your specific
data.  Until you hit those scenarios, creating your own serialization format
will create a lot of opportunities for bugs and be a time sink as you find new
edge cases or business needs to patch into your file format.  Learning some SQL
or managing protobuf definitions will pay off massively in terms of time saved
and headaches avoided.
