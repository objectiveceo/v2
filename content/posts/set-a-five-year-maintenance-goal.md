---
date: 2021-07-25 20:19:49
slug: set-a-five-year-maintenance-goal
title: "Set a Five Year Maintenance Goal"
summary: |
  If you're a software developer and set your mind on one goal, this should be it.
---
I have a thought that focusing on a single goal can often be more impactful than assuming multiple objectives.  This frequently requires ignoring real world expectations.  That said, putting a concrete goal on a vague horizon and working towards it is often a better gameplan than working towards a mediocre, yet finite objective.

For my software engineers, I like to set this goal: Write code that someone else will debug five years from now.

# Code Quality

I'll admit that there's a bit here about pride.  It's easy to write code that you'll maintain.  You wrote it and the expectation is that you live with the consequences.  From my own experience, it's very easy for me to write and support code that I'm not sure about.  No one else will notice.  I can live with (and fix) my mistakes.  But working in a shared context is very different.  I cannot abide writing code that might be criticized by others!

I've found that many of my engineers feel the same way.  When working on a PR, there's the sense that someone might look over the code, but there's a wholely different mindset when assuming that someone will be *working* in the code.  Assuming that someone will need to read and update changes the dynamic.

There's a different state of mind between expecting someone to read the code and expecting someone to live with the code.  It seems like a minor change, but it's revelatory.  Don't write code for someone else to read.  Write code for someone, five years from now, to have to update.

# Make it obvious

One of the biggest shifts is that the focus on code goes from cleverness to obviousness.  There's a lot of code that's written based on what the engineer just learned.  Some clever technique or thing that was just learned becomes part of the codebase.  Some new pattern enters the repo.

When we set our sights on someone five years from now rather than five minutes from now, the whole gameplan changes.  Rather than do something that might be explained in a code review comment or in a quick in-person conversation, we start programming with a focus on making it obvious for maintainers.

Code that's written for the "now" comes closer to being unmaintainable. It's solving "now" problems.  Those problems include perceptions on performance.  Many of those "now" problems either go away with time (computers get better, compilers optimize more efficiently) or never existed (we didn't profile and assumed).

Code that's written for "five years from now" has a specific mandate.  Don't worry about performance.  Don't worry about optimization.  Worry about being (a) right and (b) legible.  In many, many cases, being correct is actually the optimal code.  We shouldn't assume a pessimal codebase is appropriate.  We should always be looking to align our coding techniques with appropriate methodologies.  But coding for "five years from now" means authoring good algorithms and creating appropriate data structures.  It means writing correctly the first time and making sure that it's legible in the long term.  No premature optimizations.

# Make it observable

One specific thing that I see a lot of engineers doing for the sake of brevity is to omit temporary variables.  A lot of the intervening data points or calculations are calculated inline.  This isn't a compiler optimization.  And it doesn't really aid in development.  It just means that a few fewer variables need names.

When one plans for the long term, I've observed that a lot of the intermediate calculates are expanded.  This has a lot of positive effects for a codebase.

One thing that I've noticed is that it brings more focus and attention on what every line of code does.  There are whole performance issues that can be encapsulated in one, overburdened line of code.  As soon as these get expanded, my engineers see some of the costs associated with these calculations.  In a very real way, hidden costs become obvious.

A second thing that I've noticed is that algorithms are sharpened.  The mere act of naming these temporary variables gives them increased meaning.  In many cases, this makes documentation less important.  A well-named variable can do wonders to increase the legibility of code.  Increased legibility is always paralleled with increased understanding.  Sometimes, even the original author finds new insights or greater depth of understanding when challenged to name things.

A final observation is that debuggability is greatly improved.  I can't tell you how often I've tried to use a debugger to inspect code only to find that all of the symbols have been obliterated by a compiler.  This is common for optimizing compilers.  However, for code that can be run in a "Debug" configuration, we don't need to pre-inline all of the items that we might care about.  In my experience, asking programmers to write code that can be read five years from now often correlates with code that is easier to debug.  Similar to the variable naming thing above, just the practice of writing code for the future leads to code that is also more debuggable.

# Make it bullet-proof

Nearly every modern language has some form of library consumption or package management.  This leads to cycles of development that focus on leveraging the best of the wider community with the specific needs of the project.  The top side of these cycles may experience the down sides: security issues and unmaintained dependencies.

One of the long term effects that I've seen on software with five year focus is that a lot of the minor libraries are eschewed.  There's no "leftpad" shenanigans.  There's little benefit on immediate, tiny libraries that *could* represent maintenance nightmares in the future.

These kinds of changes usually mean the creation of local utility frameworks.  These kinds of multi-purpose, common case libraries were all other the place in the aughts.  Nearly every software developer had some kind of public common code repo.  Now, it seems like we just keep inheriting these microframeworks that do obvious things.  This really changes the culture of programming.

By focusing on the "five years into the future," we often cut out the minor microframeworks that come and go out of fashion.  We avoid the potential headaches that come with security risk or general code rot.  We don't have to maintain an unfortunately long list of minor conveniences that might become future risk.

Instead, we start investing in longer term, internal frameworks that meet our actual needs rather than approximate needs.  A lot of code is modified to meet the APIs of microlibraries.  By punting on them, we are authoring our own code that meets our real needs.  The code that write more closely resembles our actual problem space because we aren't trying to bridge some gap with a third party that knows nothing about our projects.  In addition, we're putting a lot more effort into writing solid code that can be abstracted into multi-use libraries that we can share across project.

This latter bit is yet another mindshift that's a game changer.  Once you start writing code for a potential "five year plan," all of the surrounding code needs to match that expectation.  Anything that *could* be abstractable into general purpose code is typically moved in that direction.  Once you have general purpose code, it needs to not only survive five years, but also potentially multiple projects.  This creates a whole different mindset of correctness, maintainability, and legibility.

# Stop writing for today

You can easily set expectations across a lot of different metrics, but if you're not already asking your team to write code for the future, I think setting this one goal will be a singularly identifiable turning point for your team: Write code that someone else will debug in five years.

That one goal comes with a whole host of expectations and requirements.  Once you get good at identifying what code is maintainable in the future, you can readily mentor your team in this direction.  This is something that might require some time.  You might need at least five years of development experience to recognize it.  I expect that the general guidelines will be the same regardless of experience.  Code should be:

* Obvious
* Legible
* Maintainable
* Debuggable
* Timeless

In addition, we should be identifying code where our engineers could be leveraging existing microframeworks but instead writing bespoke, yet generalizable, solutions for common problems.  This is one of those seminal phases.  The items above should just be part of good engineering practices.  Once you have staff that are thinking about code that could be abstracted into 10, 15, 20 year codebases of shared libraries, you can rest assured that they're also thinking about maintaining apps for the next five years.

The challenge now is to plan around it.  You might see that the cadence of code changes has dimished.  This is a good thing.  Less churn and fewer bugs means a faster pace of quality software development and fewer commits fixing flaky dependencies or resolving ephemeral API contract issues.  More code is invested in long term strategy and less into maintaining a flimsy software stack.  Code change is slower but product change is quicker.  You'll be challenged to learn how to estimate progress of software with long term goals in mind.  This is a good problem to have.
