---
title: "Fighting Deceleration"
date: 2023-07-27T19:19:24-04:00
draft: true
summary: |
  When your software gets bogged down by the weight of its own codebase, when
  the cadence of feature releases slows to a crawl, when it feels like nothing
  is getting done, you have to fix it.  Here are some thoughts on how to return
  to shipping software quickly.
---

I've had the pleasure of having a few conversations with various teams recently.
There was a specific topic of conversation that kept coming up.  Many teams seem
to have found that they no longer produce features as quickly as they once did.
Frequently, there's a general frustration around this specific issue and a wish
to "return" to a prior time when things were shipped more rapidly.

Before I give any advice, let me say that this is, frequently, a "good problem."
That is, it's a problem that indicates that things are moving in a positive
direction.  That doesn't mean that it's a good thing and shouldn't be fixed.  It
should be fixed.  But it indicates that your software and your teams are
*maturing*.

Small teams and small codebases enable fast iteration.  You get things out the
door quickly because, well, there's nothing stopping you.  Code review, if it
happens, is fast because everyone on the team knows *something* about the
codebase and feels empowered to approve.  Engineers ship freely because there
aren't enough customers to incur significant business risk.  The team hasn't
been bit by enough edge cases or unexpected interactions between components to
be afraid of making significant changes.  Often, the "utility" or "framework"
portions of the codebase are only used a few times, making it easy to make
significant architectural changes on a whim or as needed.

*If* the business survives long enough, codebases live long enough to generate
regrets.  These are natural.  Mistakes, unexpected edge cases, updated
requirements, and other regrets become more apparent.  This is the "good
problem."  Congratulations!  The codebase has lived long enough to have regrets!
That's a positive milestone!  Having technical debt means you haven't called
bankruptcy yet.  "Good problems" arise the natural progression of growth and are
indicators of continued success.  They are still problems and should be
addressed.

Scale slows down progress.  It's an unfortunate reality that's seen time and
time again.  Codebases grow and interactions become complex.  Teams multiply and
coordination between multiple projects consumes more time.  The user base
becomes so large that even small bugs become noticeable blips in metrics (and
sometimes revenue).

Eventually, features start spending more time "in progress."  Developers become
less confident in releasing.  Stakeholders start looking for more metrics to
make sure that they've made the right decisions.  Software development slows to
a crawl.

This can be fixed.

What I propose below isn't an exhaustive or foolproof set of concrete steps to
restore shipping cadence.  What it is, though, is a set of things you can look
into and evaluate how you might make changes in your own organization or team.
I'll focus on three primary areas:

* People
* Practice
* Process

## People

The single most important aspect of your organization affecting the ability to
deliver is its culture.  If you punish mistakes or otherwise disincentivize
shipping, you'll actively hinder progress.  If you want to ship faster, you'll
need to create a culture that feels confident that they can make mistakes freely
while realizing the benefits of getting things out the door.

Let me share an anecdote.

A long, long while back, I was interviewing with a company and taken out for a
mid-interview lunch.  I was joined by a couple of engineers from the company
just to keep me company (and I assume evaluate my "culture fit").  Well, I was
also evaluating them.  In the course of our conversation, I found out that one
of the engineers had created a situation wherein a customer requested a refund.
This customer was one of the larger individual  consumers of the software and
the refund was something like $100,000.

Now, to me at the time, that sounded like an incredible sum.  In retrospect, it
probably meant a little less to the business than it did to me as an individual.
But it was still significant. When I asked about the repurcussions, the engineer
stated that the CEO came down to attend the next scrum meeting and made a
statement that no one would be reprimanded.  It was an honest endeavor and the
engineer in particular (and the team in general) had just learned a $100k
lesson.  The CEO then thanked everyone for their attentiveness to the issue and
asked everyone to keep up the good work.  I later learned that the CEO also said
that firing anyone for the situation was foolish because then he'd be throwing
away the people who had just learned a $100k lesson.

In that organization, there were two viable states: success and learning.
Learning, however, was prioritized.  If you succeeded without learning, well,
that was okay but discouraged.  Failing and not learning wasn't allowed.
Failing and learning wasn't quite as good as succeeding and learning, but it was
far preferred to any situation that didn't involve learning.

People will naturally decelerate the cadence of shipping if failure causes a
fear response.  Fears of the unknown, of the unfound bug, of the unforeseen
consequences, or of the clever malicious user will cause individuals to become
highly conservative before sending any software out into the wild.

If the company punishes engineers for mistakes or tracks the number of
regressions directly attributable to them or otherwise threatens an individual's
career or career progression, then the staff will be afraid to ship anything.

In order to keep the cadence of shipping high, the cost of shipping bugs has to
drop to zero.  There has to be a high degree of psychological safety around
shipping to prod (and at all other times as well, but specifically for today's
discussion).  Some specific mottos that I like to use with my team are:

* "We make mistakes today to make better mistakes tomorrow."
* "Every bug is just something that we wished we'd noticed or knew ahead of
  time."
* "Ship early and ship often." (Why did so many teams drop this?)
* "Incomplete software ships earlier than perfect software."
* "If the users aren't finding bugs, then they aren't using our software.
  Expect bugs because we have users."
* "All software is created by individuals doing the best they can on things that
  they're learning about as they build while dealing with time constraints."

The most important aspect to keeping the cadence of software releases and
shipping features with frequency is to create a culture that prioritizes
shipping.  Cultures that prioritize shipping also prioritize iteration and fast
feedback cycles.  Individual engineers don't worry about bugs popping into the
queue.  They are normed to shipping the *best* that they can and revisiting when
we learn more about how users are actually using the software or to update
decisions that we made earlier in the process.

Most modern software 



People
- Culture
- Afraid to ship
- Afraid to make a mistake
- Psychological Safety

Practice
- Good CI/CD
- Shift left
- Functional systems

Process
- Small teams/small scope
- Blameless post-mortems
- Celebrate learning from mistakes
- Ship smaller/incomplete