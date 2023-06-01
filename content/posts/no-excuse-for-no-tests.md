---
date: 2021-09-12 11:34:35
slug: no-excuse-for-no-tests
title: "No Excuse for No Tests"
summary: |
  I often have engineers complain to me that they can't write automated tests for a variety of reasons.  They're wrong.  Let's talk about the most common excuses and how to solve them.
---
Periodically, I like to go around the team and ask how many tests they are writing in our 1:1s.  I already know the answer since I review their PRs and can see how few they actually write.  I do this to set the expectation that they should be writing tests and nudge them towards *actually* following through.

I could mandate that they write tests and block PRs until they get tests in.  In truth, I'd like to do this.  However, I manage several legacy codebases that don't have unit tests or have very little test coverage (the definition of "legacy" for some peope).  Blocking PRs at this time would only prevent productive work from landing in the codebases and upset other product owners.

My engineers are generally on board with the notion of unit tests.  They readily agree that they should be writing tests.  However, I routinely need to nudge them to do so in order to actually see them.  Sometimes, my engineers give me some excuse when I nudge them.  Here are some common excuses and my most common response.

> The project doesn't have any test targets.

Occasionally, I'll get a project, set some engineers on it, and when I get a chance to return find out that they never created or ran any automated tests because the project was never set up to *have* tests.  Sometimes, there's a test target, but the project was improperly configured and the test target doesn't have the ability to actually exercise code from the primary codebase.

This is a poor excuse.  This is merely a configuration issue and can be readily resolved.  I don't accept this excuse at all, though I sometimes need to mentor someone through how to create test targets or configure them appropriately.  This is a great learning opportunity!  For many software developers, the tests have either already been set up by a senior engineer or they only setup test targets infrequently.

> The code isn't testable.

A lot of the legacy code that we have doesn't have many if any tests.  That usually means that the code wasn't designed to be testable.  The code has all kinds of assumptions encoded into it without any tests to formally define behavior.  Engineers look at this code and just assume that all is lost.

This is also a poor excuse.  For senior engineers, a careful refactoring of the code is possible.  It opens risk, but it's still possible.  For all engineers, we can assume that any *new* code should be testable and tested.

Imagine a bug fix that involves changing a single line in a 400 line method.  You may not want to refactor the whole method.  That's a prudent decision.  It would introduce a lot of risk and cost a lot of time for something that may be addressed very quickly.  The solution is to *not* fix the code inline for the method.  Instead, hoist the behavior into a new method (a static one is best!) that takes in all of the data necessary as parameters and returns a verifiable result.  That fix can now be formally verified by automated tests without changing the other 399 lines of code.  It's a small improvement, but small improvements add up over time.  A 0.2% increase in code coverage is much better than a 0% improvement.

> I don't have time to write tests.

Many of my engineers see their job as writing code that goes directly into the main codebase.  Anything that distracts from that mission is seen as unnecessary.  The test codebase isn't shipped to users and is therefore not valued.  Whenever we get into a time crunch (or often to create an artificial feeling of a fast cadence), they punt on writing tests.

You might think that I think all of these are poor excuses.  And you'd be right!  I haven't heard a good excuse for not writing tests yet!

The purpose of software developer is to ship code, yes.  But we need to create practices by which we can confidently *and* consistently ship software.  The primary task of engineers isn't development, it's maintenance.  Most software is shipped and then shipped again.  Very few pieces of software ship once and then is no longer tweaked.  Instead, the opposite is much more common.  Software is deployed to users and maintained far longer than the initial development time.  Even during initial development, new code is revisted and revised as the team learns more about the domain that they are working in.

If tests aren't written during development, then the maintenance phases take far longer and have more risk.  Writing tests early and often makes maintenance a lot easier and faster.

Good testable code also increases the cadence of making changes.  I've known a lot of developers who will build and run the app just so that they can navigate to a specific screen and click a particular button just to observe some data transformation happening under the hood.  They'll readily spend 10+ minutes at a time manually checking to see if a change that they made had the intended effect.  They'll then do it multiple more times as they tweak the code or find new edge cases or realize that they've introduced bugs.

Imagine how much time is lost building and running the application!  These are hidden time sinks on the scale of hours!  If the code is properly tested, then the engineer could readily make a change and run a single test that operates in the span of seconds (or less) to observe effectiveness.  Once the code has been polished and refactored to a state of acceptance, the engineer can then just run the test suite (usually on the scale of minutes) to ensure that no other issues were introduced.

It is much faster to maintain code by writing tests.  Maintenance is the default state for code.  Taking the time today will speed up your future and provide confidence that the changes you make don't have unintended consequences.
