---
title: "Understanding Hamt"
date: 2023-07-26T19:26:37-04:00
draft: false
summary: |
  I never had the benefit of a computer science degree.  So every so often, I
  take some time to learn something that I've heard about and maybe even used
  but didn't really take the time to understand well enough to appreciate.
  In the last couple of weeks, I've been picking at HAMT and trying to
  understand how that data type works.
---

Let me throw some additional reading up front.  These blog posts helped explain
HAMTs to me.  I'll try to re-explain in my own words and illustrations, but I
wanted to put these out there to show respect for other authors and also because
you might learn something different or better by hearing it multiple ways.

* [Wikipedia article](https://en.wikipedia.org/wiki/Hash_array_mapped_trie)
* [Horace Williams](https://worace.works/2016/05/24/hash-array-mapped-tries/)
* [Marek's totally not insane idea of the day](https://idea.popcount.org/2012-07-25-introduction-to-hamt/)
* [The Morning Paper](https://blog.acolyer.org/2015/11/27/hamt/)

***

Okay, so let's get the important questions out as well.

## What is a HAMT?

The acronym stands for "Hash Array Mapped Trie."  That's a lot of keywords all
at once.  That's a bit of the magic of the data type, but also what makes it a
little harder to immediately grok.  This post explores the high level concepts
of HAMT without addressing practical implementation concerns.  As a result,
we'll explore a very simple theoretical HAMT and make assumptions about memory
allocations and behaviors so that we avoid unnecessary complications while
building our mental model.

HAMT itself is built upon several other concepts.  Once you understand each of
these building blocks, the eventual insight that makes HAMT special is much more
appreciable.  Let's break it down.

### What is a Trie?

A [trie](https://en.wikipedia.org/wiki/Trie) is a data type that represents data
as a series of branches.

It may help to compare it visually against other common data types.  Imagine
that you have a value.  Doesn't matter what type, just that it's a value.  We'll
represent it with: &#9744;.  Any array would be a line of boxes.  Just a bunch
of memory addresses laid out sequentially in memory.  You might call this a 
"vector" in some languages:

<pre>&#9744;&#9744;&#9744;&#9744;&#9744;&#9744;&#9744;&#9744;</pre>

A linked list might be something like this (if we used arrows to represent
pointers or other ways to associate data):

<pre>&#9744; -> &#9744; -> &#9744; -> &#9744; -> &#9744;</pre>

The coding interview favorite, the doubly-linked list could be:

<pre> &#9744; <-> &#9744; <-> &#9744; <-> &#9744; <-> &#9744;</pre>

But a trie allows for a branching pattern between values.

<pre>
     &#9744;
    / \
   &#9744;   &#9744;
 /  \    \
&#9744;    &#9744;    &#9744;
    /
   &#9744;
</pre>

Tries have a lot of advantages.  Compared to other data structures, trie
implementations can be space efficient, easy to insert or delete, and feasibly
remain in sorted order.  They are also optimized for fast search behavior.

### What is an Array?

We saw it briefly in the discussion of the trie, but an array, in this case, is
just a linear collection of values.  Array implementations vary, but the
simplest is an allocation of memory that can hold multiple values in adjacent
addresses.  Think of it as a bunch of fillable boxes in a row.

<pre>&#9744;&#9744;&#9744;&#9744;&#9744;&#9744;&#9744;&#9744;</pre>

Arrays like this are among the simplest collection types.  They are not
necessarily sorted, retrieval is merely by index of the object in the
collection, and deletion could leave holes in the memory space unless the
implementation takes the effort to defrag and compact.

Arrays provide exceptionally fast retrieval of values in the collection, high
data locality (and therefore great cache optimizations), and can be readily
composed into other data types (such as strings if we restrict the content
expectations or matrices if we combine arrays).

### What is a Hash?

If you're familiar with hashes, you may think that a hash is defined as "a way
to convert a value into a number."  At least, the vast majority of hashing
programs, functions, or implementations produce some kind of number in practice.
However, the actual definition of a [hashing function](https://en.wikipedia.org/wiki/Hash_function)
is to convert some value that's an abitrary size into something that's a fixed
size.  In computing terms, that often means converting data into a fixed size
integer value.

There are a lot of different ways to calculate a hash at various sizes.  For the
purposes of the HAMT, we need to get an index into an array at some point, so we
can simplify and just say that hashes convert values into integral numbers.

## Putting it all together, defining the Mapped thing

The H, A, and T define the common data science pieces of this data type.  The M
is the part that brings it all together into something meaningful.  In effect,
the HAMT is a data type that is a trie containing nodes made of arrays and the
levels of the trie and index of the arrays is specified by the hash.  That's a
lot to unpack and the implementation is non-obvious from that description.
Let's start with a simple example.

Many explanations of HAMTs start with a value of `32`.  There's a reason for
that and we'll get to it later.  For now, I want to ignore that and think of the
simplest possible array: 2 elements.

<pre>&#9744;&#9744;</pre>

Okay.  So now, we just have two options.  Left and right.  If we have a value,
we need to decide if it goes into the left box or the right box.  We need to 
narrow an object of arbitrary size into a fixed size (1 bit).  Sounds like we
need a hashing function.  Luckily, by narrowing to just one bit, we have valid
indexes for a two-value array: 0 and 1.

```
hash("hello") == 0
hash("world") == 1

array: [hello][world]
```

Now, we have a bit of a problem.  We can only store *two* values.  How do we
store more?  Well, we can imagine a simple trie with two levels.

<pre>
     &#9744;&#9744;
    /  \
   &#9744;&#9744;   &#9744;&#9744;
</pre>

Now, our root level won't store any values.  Instead, it'll just point to the
next level.  With that, we need to figure out a way to generate multiple values
from our hash.

Here, I'm going to demonstrate with a real hashing function. That said, I'm
doing a lot of handwaving here and this isn't a real algorithm.  It's just
illustrative to help understand what decisions are being made.

Let's calculate hashes for a couple of popular video games:

```bash
➜  v2 git:(main) ✗ crc32 <(echo -n "earthbound") | xxd -b
00000000: 01100101 01100101 00111000 00110101 00110101 00110111  ee8557
00000006: 01100101 01100011 00001010                             ec.
➜  v2 git:(main) ✗ crc32 <(echo -n "fallout") | xxd -b   
00000000: 01100100 01100100 00110011 01100010 00110001 01100011  dd3b1c
00000006: 00110010 00110010 00001010                             22.
```

Oh.  That's a lot.  Let's just say that we're using [crc32](https://en.wikipedia.org/wiki/Computation_of_cyclic_redundancy_checks#CRC-32_algorithm)
to calculate the hash of some strings and piping it to an app that will give us
a binary representation.  To make things simpler, let's just take the first 8
bits of each.

```
earthbound: 01100101
fallout:    01100100
```

Okay.  We just need ones and zeroes for our simple, two-element array-based
trie.  Let's just take them from the right side one at a time.

* Earthbound: 0110010 **1** -> go right
* Fallout: 0110010 **0** -> go left

For our root level, we have directions!  Now, what index will we put them into?
We'll just shift to the next bit to the left.

* Earthbound: 011001 **0** 1 -> go left
* Fallout: 011001 **0** 0 -> go left

Now we know what slots those go into!

```
            [*][*]
            /    \
[earthbound][]   [fallout][]
```

Let's insert one more...

```
➜  v2 git:(main) ✗ crc32 <(echo -n "destiny") | xxd -b 
00000000: 00110111 00110101 00110010 00110010 01100110 01100010  7522fb
00000006: 01100001 01100010 00001010                             ab.

destiny: 00110111
              /  \
	right right

------------------------------------

            [*][*]
            /    \
[earthbound][]   [fallout][destiny]
```

If we wanted to add another level to the trie, we'd be able to store eight
values.  At that level, we'd just need to read the third bit to decide if we
should insert into the left or right side of the array.  This scales with the
number of bits available to us.  That said, each additional level requires
an additional round of pointer indirection and bit math, so there may be
performance concerns at large scales.  We'll see how to address that in a bit.

This is the crux of the insight that makes HAMTs work.  You can navigate a trie
using a hash if you have a way of parsing that hash into sub-pieces.
Subsequent pieces of that hash will index into increasing levels of the trie.
Efficient navigation of a trie using bits of the hash is the secret sauce of a
HAMT.

## Why real world implementations often use `32`

There are a few knobs you can adjust to tune a HAMT.  First, a data structure
that only holds four values isn't terribly useful.  You may have noticed that
each time we add a new level to the trie, we double our number of available
slots.  In the case of our two-element-array-trie, going three levels gives us
eight slots.  Going four will be sixteen.  If we decided to use has functions
that produced integer values that matched our CPU architecture, if we had a
64-bit chip, we could potentially store 18,446,744,073,709,551,616 unique keys
(2^64).  That's... a lot.

Note that this is *potential* unique values.  This would assume a
hashing function that had perfect distribution across your data corpus.  In
real life, there will be collisions and the actual used slots will be less (and
require the ability to detect collisions at the edges).

Note that if you used these two-value arrays, then we'll need *at least* 64
operations per hash to find the location in the trie.  At minimum, there'll be a
bitwise comparison to determine which path to take at every level of the trie.
In all liklihood, the algorithm will do bitwise shifts, too.  That's a lot of
comparisons.

For many documented HAMTs (see links at the top), there are 32 slots in each
array.  This isn't an arbitrarily chosen number.  First, when HAMTs were
defined, the 32-bit CPU architecture was the most common for general computer
tasks. Second, those CPUs have instruction sets that make working with 32-bit
values highly efficient.  Third, as a result of following the CPU size, the math
benefits from common [power of 2](https://en.wikipedia.org/wiki/Power_of_two)
maths.  So, 32-bits for the CPU leads to 32 slots at each array in the trie.

Just like with our two-element array above, we need to figure out how to parse
an integer value into smaller components to get the benefits of the trie
pattern.  To identify how many bits we should take, we use the [binary
logarithm](https://en.wikipedia.org/wiki/Binary_logarithm).  `log2(32) == 5`.
With this, we can take five bits and calculate an index for every index in the
array.  Indeed, `2^5 = 32`.  So the math works out in the reverse as we'd
expect.

You might be doing the math and realize that 32 is not evenly divisible by 5.
That's okay.  In practice, we stop at six levels to the trie and leave some bits
unused.  We could add another level and try to use those last two bits, but that
could create a lot of wasted space at those leaf nodes unless we added
complexity.

At this point, we've reduced our number of levels to 6 in order to store
1,073,741,824 elements (`32^6`).  That means that we can calculate our path
through the entire trie using only a dozen bit shifts and comparisons per key
comparison.  This is a pretty good tradeoff!

## Further optimizations (and one for next time)

At this point, we've described a very simple overview of how HAMTs work and why
certain values were chosen for most implementations.  However, you might notice
a couple of potential issues.

First, while being able to (theoretically) address over 1 billion unique keys in
a HAMT is a good start, some use cases might need a bit more.  That's fairly
readily fixed by using a hashing function that takes a seed.  Once you've
exhausted the number of usable bits in your hash, you can re-hash with a
different seed and get up to six more usable levels.

The second, bigger issue, is the sheer amount of wasted space.  If you were to
pre-allocate the entire HAMT at initialization, you'd have a lot of empty
memory.  If we assumed that we were using a 64-bit sized pointer (apologies for
shifting between 32-bit and 64-bit, but many modern general compute CPUs are
64-bit-addressable), then each *node* in the trie would be 8 bytes per pointer
and 32 slots in the array.  At `32^6` potential slots, there's 274,877,906,944
bytes used *just* in the last row of the trie.

Now, obviously allocating 275GB for a datatype to store the *extreme* use case
is inappropriate.  Because of this, HAMTs are often not completely allocated at
initialization.  There are various algorithms that offer just-in-time allocation
of slots for values that make HAMTs space efficient while still offering
constant (or near constant) time insertions and retrievals.  Some can offer
features such as re-packing on deletion or make it easier to implement
immutability.

The most common optimization is called CHAMP.  It builds on HAMT by adding a
clever use of bitmaps and CPU-optimized instructions (`popcount`) to aid in
compressibility while preserving high performance.  That algorithm also requires
a bit of explanation, so I may try to explain it at a later date.

# Summing up

I never took a data structures class.  I didn't major (or even minor) in
Computer Science.  Nearly all of my knowledge about data types was generated by
on-the-job learning or my own curiosity.  Learning about HAMTs was prompted by
the latter.  I heard about them and decided I wanted to know more.

I don't know that I'll immediately use this knowledge, but knowing it will make
me a better programmer.  The insights that lead to the generation of this data
type has really spurred my creative juices.  I remain appreciative of all of the
prior work and creativity that went into it and knowing it allows me to think of
data-related tasks in new ways.

I hope that I haven't made *too* many mistakes in my explanation of how HAMTs
work conceptually.  Refer to the articles that I linked at the top for more
practical implementation details.

If I've made any obvious or glaring errors, please leave a Github Issue
referring to the [raw
content](https://github.com/objectiveceo/v2/blob/main/content/posts/understanding-hamt.md)
of this post.  I would greatly appreciate it!

I hope this explanation helps you understand HAMTs a bit better.  That said, I
really hope that it spurs your curiosity about data type implementations and are
curious to learn more about how they work as well.
