---
date: 2021-03-21 21:24:12
slug: performance-is-a-moral-imperative
title: "Performance is a Moral Imperative"
summary: |
  I made a mistake earlier in my career when I ignored an obvious performance concern in an application.  The engineer said the magic phrase "premature optimization" and I allowed the code to merge.  I learned a lot from that experience and now consider reasonable optimizations to not only be appropriate, but necessary to be responsible programmers.
---
A while back, I was just a couple of weeks in to a new job when I noticed a pull request that included a linear scan of an array.  Normally, this wouldn't be an issue, but I happened to have known that it was called in order to popular a list view.  We would be performing a linear scan for every item in the list.  I called it out as a performance liability in my review.  My developer dismissed it as "premature optimization" and merged the code.

I was new to the job and decided not to stand on principle that day.  I regret that decision.

During the development process, we didn't notice any adverse effects.  We populated that view with thousands of items.  It remained performant-enough, though we did notice that the scrolling became slightly choppier when we got to the bottom of the list.  Our products owners and other stakeholders found the behavior acceptable and we shipped the app with the linear scan in place.

Unbeknownst to us, some of our customers had larger data sets than we had artifically created.  I don't know what the breakpoint was, but there was a threshold at which the app became unresponsive for minutes at a time just scrolling the next item into view.  Given that users were often aggressively scrolling through the app to get the bottom of this long list, we were queueing many expensive linear scans and locking the app up for significant periods of time.

Until we shipped a fix, this was a minor annoyance to some customers.  For some other customers, however, this was an erosion of trust.  For all of our customers, we'd readily chew up as much CPU time as we could until the app was forcibly quit, either by the OS or the user.

There's this holistic understanding of the systems at work.  We, as software engineers, hold an ethical responsibility.  I've tried to consider how many CPU minutes per user I've wasted with inefficient code.  It's not that I tried to be inefficient, but I decided not to place any thought into what a more optimal design would be.  How much battery life was drained because of the inefficient algorithms?  How much additional energy was used to recharge that battery?  How many seconds or minutes of any given user's life did my apps steal and could never be returned?

Per user, it's probably that my direct contributions result in very little incurred costs.  But over the aggregate of every app that I've shipped and every user that's interacted with my code, it could be a significant amount.

I'm certain that this sounds overly dramatic.  We shouldn't be weighing ourselves down with the regrets of the past or inventing new burdens for ourselves.  There's no need to invent guilt.  But I'd like to make a very explicit plea to consider that even small performance concerns might be large problems in the sum total of all users and all devices.

I allowed my engineer to prematurely pessimize code.  We didn't anticipate that it'd become a problem in real world conditions, but it did.  We had to go back and reconsider that algorithm so that we could make it much more performant.  I doing so, we not only made the app usable for the handful of users with very large data sets, but we also fixed the mistake that was running on the device of every last user of our app.

I no longer allow the phrase "premature optimization" to override my code review objections.  It won't diminish valid criticisms of otherwise correct code.  I don't let my programmers commit code without at least one of us considering the performance implications.

There are two things that may not be apparent.  One is whether a potential performance problem will cause real world problems in actual use cases.  The other is how many additional resources your code will unnecessarily consume.  Your users expect that you will use their devices responsibly.  Earn that trust by living up to your obligations, considering the code that you put out into the world thoroughly and making all reasonable optimizations.
