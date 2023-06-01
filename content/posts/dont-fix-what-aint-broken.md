---
date: 2021-08-22 10:35:42
slug: dont-fix-what-aint-broken
title: "Don't Fix What Ain't Broken"
summary: |
  Tech debt is only debt if you have any intention of paying it off.  However, how we address legacy code can reveal growth paths for our engineers.
---
I've worked with a lot of engineers that create a lot of unnecessary work for themselves.  The behavior often follows a similar pattern:

* They are tasked with adding a feature or fixing a bug in an older piece of code.
* They identify the code that needs to be adjusted.
* It's older than three months and is therefore "legacy."
* Legacy code needs to be rewritten.
* We embark on a process of creating tickets to rewrite this previously invisible and completely untenable portion of the application.
* I mark all of those tickets as "Won't Do" and have a chat with the engineer.
* The engineer fixes the bug they were originally tasked with in an hour.

I observe this pattern several times a year.  I thought I'd work through a few different versions of it and how I typically address them.

# "It's (Objective-C) and not (Swift)."

First, let me just say that it's not just Objective-C and Swift.  This pattern can happen with Java/Kotlin for Android devs or Javascript/Typescript for web devs.  It can happen in any programming environment.  But holy heck do I seem to have iOS engineers that are alergic to Objective-C.  It's almost as if there's a generation of engineers that were trained to have a knee-jerk reaction to seeing a square bracket and demanding that we rewrite the entire application in Swift.

I could point these engineers to the seminal Spolsky article on [rewriting applications](https://www.joelonsoftware.com/2000/04/06/things-you-should-never-do-part-i/).  However, in my experience, that often doesn't quite ring with engineers.  There could be some high level agreement, but there's still that uneasiness under the surface that isn't addressed.

I typically get slightly better headway by using some of the items from Spolsky's article and pairing them with an appreciation of the older language.  Nearly every engineer that I've spoken with readily agree that rewriting an application (or portions of it) in a new language doesn't create more value.  At best, we can achieve equivalent value.  At worst, we introduce additional risk of missing requirements.  Sometimes, I get some hand waving around performance or other improvements, but those fall apart when I challenge them to prove it.

I often find that there's a knowledge gap at play as well.  There's little appreciation for the languages that have come before.  It's both antiquated and novel.  Objective-C in particular seems wholly off-putting due to the fact that the syntax departs significantly from other, similar languages.  Often, spending some time talking through the language, the problems that it solved, where it fits in the history of programming languages, and the things that it contributed to the zeitgeist and directly affected newer languages creates a bit of appreciation that makes working in it more palatable.  I can frequently find some kind of conceptual knowledge that I'd like to see an engineer develop that ties directly to modern concepts and practices.  Seeing the value in the older language often sublimates many of the objections to using it.

# "It's not testable"

By and large, this is the number one objection that I hear.  Someone sees an old function that's over 500 lines long and declares that they can't write a test case for their fix.  If they can't write a test case, then the code is obviously "legacy" and needs to be rewritten!

We can readily acknowledge when things are difficult to test and that by [some definitions](https://www.amazon.com/Working-Effectively-Legacy-Michael-Feathers/dp/0131177052/) this is the definition of legacy code (great book, by the way).  However, this often means that the engineer lacks the motivation or imagination to work effectively in that code.

I frequently work in code that has those massive functions, classes, and methods.  It's not uncommon to receive some code where a single method is over 1000 lines.  That's a lot to consume and understand.  However, that method is already written.  It is often ossified.  I sometimes drop in to make minor adjustments, but this is often "write once" code that doesn't require significant investments in refactoring.

This isn't to say that code couldn't be tested.  I often mentor my staff on how to expose bits of the code so that they are testable.  Those massive methods often have sections that can readily be pulled out into a static method or function that can be tested.  Usually, anywhere that there's bracing or indention is a candidate for consideration.  Making a minor change in the block of a "for" loop?  You might be able to pull that entire segment out into a static method that we could readily write some tests around.

# "It's too complex."

I'm a bit sympathetic to the complexity problem.  I have a sense that good programmers can manage complexity but great programmers manage simplicity.  However, when faced with complexity, rewritting is rarely the right answer.

Let's address the fact that complex code is so for a reason.  That may not be a good reason (i.e. the programmer didn't have a complete understanding of the problem space and the exploratory code wound up being the shipped code).  Other times, it may be a very good reason (the problem space is actually complex).  In any case, rewriting is a risk.

When one of my engineers wants to rewrite a complex component of the application, I often step in to verify the complexity.  Sometimes, there's just a kernel of complexity that we can unknot together.  This often takes the form of pairing on reading the code, adding explanatory comments on what we're looking at, leaving breadcrumps throughout the code, and rewriting small portions in our own words to aid legibility.  Few, if any, of these changes are ever committed to the codebase, but they can be valuable aids in understanding these bits.

Other times, a complex codebase is the result of systems of complexity.  It's not enough to tease apart some critical functions.  Instead, the entire system needs to be grokked.  In this case, we frequently need to acquire significant domain knowledge prior to addressing the code.  Once we have that, the original code often becomes significantly more legible.  Our task then is to diagram the relationships.  Sometimes, a dependency graph is just as confusing as the code.  However, in my experience, the task of manually creating that graph solidifies understanding of relationships in specific sections of a codebase.  When necessary, create those maps manually rather than rely on auto-generating tools.  The process is more valuable than the product.

# Learning to Live with Legacy Code

These are probably the three most common scenarios that I face when an engineer wants to rewrite some existing code.  I'm not going to say that we should never rewrite code.  I've been able to do it several times over my career, frequently with success.  However, it's my experience that software engineers often turn to rewriting code instead of developing other skills.  We should always take the time to evaluate whether a rewrite creates value or hides skill gaps.

As indicated above, the common skill gaps are knowledge of other programming languages, the lack of imagination when it comes to properly refactoring code into testable chunks, and the inability to effectively manage complexity.  These gaps can happen at any level of experience.  Once identified, though, we can actively work to address them.
