---
date: 2022-01-02 16:57:03
slug: add-the-good-abstractions
title: "Add the Good Abstractions"
summary: |
  I was working recently with an engineer to solve some problems left by past
  programmers and had the opportunity to make some specific recommendations
  on making the code better.  These are common tasks that we see in several
  classes of software and the recommendations are valid in nearly every use
  case.
---
The situation is pretty common: A previous software developer had left us a 
gnarly landmine in the application.  We found it during debugging, but found
that we had a couple of other issues.  The specific bug isn't interesting for
our purposes today, but the other issues are.

It's a common task in software development to have to load data from an external
resource.  Unfortunately, many programmers don't apply much thought or planning
to the process.  I can't tell you how many times I've opened up some source code
and found raw networking calls in the UI layers of applications.

I get it.  Someone, at some point, needed to load some data.  That data lived
on an API server.  So that someone just wrote a network requests in a "view
load" event or on a button press or something and went on with life.

This situation leads to all kinds of future maintenance and refactoring
headaches.  It's not that it's one problem; it's actually two.  At least, I
recommended two separate refactorings to move the code into a much more
maintainable state.

## Abstract your network

You should never make direct network calls in any part of your application that
isn't the network abstraction.  I typically hesitate to use "always" and
"never," but I can't imagine a situation where I'd recommend something
different (or not recommend this).

None of the rest of your code cares about the network.  It's an
implementation detail.  Put everything behind an interface/protocol/abstract
class/whatever abstraction scheme your application uses.  Reference that layer
in the other parts of your code, not the network.  Also, maintain the
"network-ness" of that abstraction.  Don't try to convert those network objects
into domain objects.  The post [A View to a Model](./posts/a-view-to-a-model)
has more information on rationale.

Once you have the network abstracted behind an abstraction layer, you've 
effectively encapsulated those concerns.  Turn that into a separate library,
if you'd like!  Keep it away from the main source code, if you can!
Encapsulation provides a lot of benefits.  You can readily make changes without
affecting other areas of the application.

You can also readily provide "test" implementations of that abstraction when
and where necessary.  Your network doesn't need to be a global dependency on
the rest of your code.  You don't need to worry about internet connectivity or
network availability causing flakey automated tests.  With a proper abstraction,
you've hoisted that hidden dependency into something that you can readily think
around and plan for.

Once you've started abstracting your network, you can work in isolation
from tasks that depend on the network.  If you have some time when a dev network
is down or in a rapid change state, you can readily mock data in the abstraction
and continue working on the application code.  When the network returns to
stability, you can merely re-activate your network layer and reap the benefits
elsewhere.

Finally, those teams that are ready to implement integration tests have a ready
codebase that merely requires the addition of asserting expectations.

## Abstract your network, again

Okay, so you've got your "FooApi" written and all of your raw networking
requests are hidden from the application code.  You now need to abstract that.
I'm less "always" on this one compared to the above, but I still highly
recommend it.

As I mentioned before, your application doesn't care about the network.  At a
slightly higher level, it actually cares even less.  As an example, let's assume
that you need to fetch some data about books in your application.  You've
written your "BookApi" and are ready to load book data.  But the app doesn't
*really* care about the API.  It cares about the *data*.

This isn't a tedious distinction.  The book data should likely be represented
as an object that makes sense for your application domain.  It should be
specifically shaped to meet your app's needs.  The API, though, might need to
represent book data in a shape that's appropriate for multiple use cases.  Your
mobile application and your web application might call the same API, but have
different app needs.  Hoist those API concerns *out* of your application!

Now your application just needs a "BookDataRepository" abstraction.  For v1 of
your application, you can just write a simple shim layer that calls into
"BookApi" and maps the data into the correct shapes.  Your code remains testable
and it becomes more accurate in describing what it *actually needs* instead of
merely what it expects.

But you've now created a platform to build other things in the future.  Let's
say that you always wanted some local, on-disk caching to help speed up the UI
but that didn't make the MVP.  You can now created a
"CachingBookDataRespository" that implements "BookDataRepository".  You'd take 
the "ApiBackedBookDataRepository" in a constructor.  When there's a cache-miss,
you'd just call the API and then cache the returned data.  Congratulations,
you can now implement caching *and* keep the single-reponsibility pattern!

But wait!  You now need to consume data from a second backend API that will 
patch in data from the first API.  Let's say that it's a recommendation engine
or something.  You don't need it on every request, but you need to add a
"related titles" to certain requests.  You can now just created a 
"RecommendTitlesBookDataRepository" that takes in the "ApiBacked*"
implementation.  Most requests just forward to the original API but some fetch
additional information and patch it into the domain object as appropriate.  As 
long as the caching implementation takes in the abstract "BookDataRepository"
you can simply chain everything together without having to update any other
code!

## Just add more abstractions

There's a joke that the problem with and solution to all software development
problems is another layer of abstraction.  That's not wrong, but using them well
will lead to more solutions than problems.  Not using abstractions can make code
finicky and brittle.  Encapsulating behaviors appropriate can make them
consistent and predictable.

Nearly every modern application has to make some request for data that
originates outside of its memory space at some point in time.
Doubly-abstracting those requests solves a lot of problems and introduces a lot
of opportunity.  Being able to replace your networking stack without upsetting
your application, adding additional features without complicating layers of
code, patching data at runtime, and other common activities are much simpler to
implement and faster to complete when the network is properly abstracted.  You 
can also more readily answer common questions such as "What endpoints are being
called from the application?" or "What events cause us to disable caching?"
when these behaviors are properly encapsulated.

I run into these issues all of the time.  Honestly, I'd prefer not to.  So
please abstract your network requests.
