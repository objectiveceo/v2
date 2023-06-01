---
date: 2021-07-11 11:18:26
slug: learn-a-new-programming-language-this-week
title: "Learn a New Programming Language This Week"
summary: |
  I "know" a lot of programming languages.  I'm proficient in some of them, highly competent in a few others, and have a baseline competency in many.  Here are some of my tricks to rapidly learning a new programming language.
---
I like to pretend that I know how to program in C, C++, C#, Objective-C, Swift, Kotlin, Java, PHP, Javascript, Typescript, Python, and Ruby.  I can also write scripts for Applescript and Bash.  I'm also not *awful* at writing complicated SQL queries.  There was a time when I could write passable BASIC and Pascal and I recently learned just enough Rust to feel okay with it.  I have deep knowledge in a handful of those languages but I can deliver code in all of them.

Some software programmers invest very deeply into one programming language.  Others know a small handful (usually dependent on career requirements).  I greatly value the ability to have that kind of expert level understanding of a programming language.  However, I often find that programmers are reticent or even intimidated at the prospect of learning a new programming language.

Learning a new programming language isn't as difficult as it may seem.  There's no reason to be intimidated.  If you're already competent in one modern mainstream programming language, you probably already know a lot more than you need to know.

# Bridging Gaps

I'm going to go out on a limb here and say that if you know one modern programming language that descends from the Algol family tree (C family of languages, Java, PHP, Swift, Kotlin, et al), you probably already know around 60-70% of another modern language (excluding functional programming languages or esoteric/exotic languages).  You have a fundamental knowledge of things like flow control statements, method/function calls, data structures (classes), and perhaps even some expectations about proper abstractions (subclassing, interface/protocol definitions, lambdas/closures).  You might not know how it's *spelled*, but you have a conceptual understanding of the fundamentals.

One tool that I like to use to bridge some of these knowledge gaps is [Learn X in Y Minutes](https://learnxinyminutes.com).  It's a phenomenal tool for telling me how something is spelled in a different language.  It's also a great tool for highlighting some of the unique behaviors or features of a programming language.

When you've reviewed cheat sheets like Learn X in Y Minutes, you then need a strategy for shoring up those missing bits of knowledge.  Many modern languages have websites that offer a "tour" or "get started" page of the language.  These are great resources for gathering information quickly.

Once you start getting a basic handle on the syntax of the language, you need to start thinking about how to use it idiomatically.  You might need some small exercises to reinforce your new knowledge.  Koans are a wonderful tool to illustrate or reinforce knowledge of something.  [Kotlin Koans](https://play.kotlinlang.org/koans/overview) are my favorite so far, but many are simply Github repos of examples and explanations.  Be careful, though.  Some koans exist to illustrate esoteric areas of the programming language or guide deeper understanding than you need at the starter level.  Choose your koans carefully to meet your needs.

In addition to koans, you might want to find some small tasks to reinforce your learning.  I find that collections of puzzles like [Advent of Code](https://adventofcode.com) are useful.  However, I'm a bigger fan of [Exercism](https://exercism.io).  Exercism offers a lot of puzzles for a lot of programming languages.  Each puzzle comes with a test suite.  Even if you don't want to run the tracks for a language, every puzzle is available via Github and solutions are visible on the website.  I find a lot of value in implementing my own solution and then going to the exercise solutions, sorting by most stars, and reading the comments.  I often get inspired by other solutions to write more idiomatic code and learn about potential pitfalls and unseen concerns when reading the comments.

# Leverage the Tooling

Modern programming has a lot of tooling built to aid us in writing better code.  Your new programming language may have an IDE built specifically for it.  [JetBrains](https://www.jetbrains.com) puts out a lot of high quality IDEs for common languages.  Your OS platform provider might also provide a good IDE (Visual Studio or Xcode).  Finally, there are a lot of great plugins for popular text editors like Visual Studio Code that will aid in auto-completion, library importing, and code navigation.

Once you've got an IDE or other assistive programming environment, you should look into tooling such as formatters and linters.  They won't help you write idiomatic code, but they will at least make it *look* like you're writing it.  Good linters also consistently nudge you towards best practices, both in following the larger community's practices and in alerting you to potentially major issues that aren't necessarily compiler errors (e.g. Javascript's "==" versus "===" operators come to mind).

Finally, you need to get that debugger.  Debuggers are excellent tools that let you navigate your code and better understand issues.  Good debuggers also include the ability to execute arbitrary code during a debugging session.  Having an "Immediate" window or being able to execute expressions in a command line allow you to explore ideas efficiently.  If you don't have a debugger handy and are investing time into learning it, you can expect to lose a lot of time and frustration to cycles of confusion, change, compiling, and testing.

# Bringing It Together

You should be about ready to write real code in your new programming language.  By now, you've reviewed the language spec or Learn X in Y Minutes and set yourself up to write small bits of code.  You should have kicked the tires of an IDE or a plugin for your text editor and might have written a few unit tests.  You need to bridge that last bit to create confidence that you can write code in your new language.

At this point, I like to engage in a personal project.  I typically do the same personal project for every language.  That way, I'm focusing *only* on how to use the language idiomatically and not having to learn a new domain at the same time.  Your personal project needs to be small enough that you could knock it out over a weekend or a few nights but large enough that you are forced to learn some of the standard libraries and how to use the debugger.

I've heard of personal projects that include writing your own "choose your adventure" text based game.  It's also very common to write your own todo list.  That's often associated with GUI toolkits, but you can easily write a command-line todo list as well.  Personally, I like to write a small command line application that can calculate the relative strengths of poker hands.

# The Last 10% Doesn't Matter

There's often a feeling that proficiency comes from knowing *everything* about a programming language.  That's an unfortunate fallacy.  Programming languages evolve and shift over time.  There's a lot of vestigial items left in them that cannot be removed.  Languages also often include constructs that are only really useful in niche settings.  You don't need to know them until you do.

I don't mean to sound facetious, but you really don't need to know everything about a programming language.  In the case that you *do* need to know more about a programming language, you'll have built up the knowledge and context that makes just-in-time learning feasible.  Once you have enough experience to be aware of the breadth of features of a new language, you're likely already accumulating resources that make investigation and discovery possible.

Let's say that you come to a language and feel about ~50-60% confidence just by reviewing the Learn X in Y Minutes.  I'm going to assume the position that the next 10% that you learn will be much more useful than the followign 10% by an order of magnitude.  Going from 60% knowledge to 70% is the difference between vaguely recognizing common concepts to actually being able to read, understand, and write code.  70% to 80% is that threshold where competency and confidence happens.  80-90% is where high competency is established.  This is sufficient for nearly every programming task that you're likely to encounter.  90-100% may be the range for mastery of a programming language, but very little of what's learned in this range will be useful for every day tasks.

Older languages like C++ are filled with cruft.  As a language, it's filled to the brim with nearly every possible programming idea that's been had.  As a result, modern C++ is a concerted attempt by the community to trim all of that back to something that's actually useful in day-to-day operations.  You can learn about how to allocate memory on the heap using "std::make_unique" and ignore the "new" keyword.  You can even further ignore the special case of "new" called "new in place."  This is just one example where knowing *everything* about a language isn't terribly useful for most use cases.  When you *need* "new" or "new in place", you probably already know about [CPP Reference](https://en.cppreference.com/w/) and how to navigate it.

## Learning New Things Reinforces Old Things

Learning a new programming language is a great way to grow as a software developer.  Some developers have a fear that their existing knowledge will atrophy when they learn something new.  This is horseshit.

To be sure, there's always a bit of "use it or lose it" when it comes to any language (programming or other).  However, there must be a good long while of non-use before any knowledge starts dropping.  Instead, learning a new programming language also illuminates choices that you've taken for granted in your existing knowledge.

Every programming language brings something unique with it.  They often have interesting new ideas that you can compare with other languages.  This comparison often illustrates how things work.  Knowing a language like Rust or C++ can help drive insights into how features in other languages are implemented.  Knowing a highly dynamic language like Ruby or Objective-C can drive curiosity about implementations of dynamism (or lack thereof) in other languages.

Knowing some idioms in one language can help you be a better programmer in other languages.  Once you recognize some basic concepts like pivots, rotates, and map/reduce idioms, you can compare them across languages.  Often, I find that one language does something in a way that I like and I find that there's an analogous or similar concept in another language.  You might find that learning a new programming language can help you bridge that last 10% in your primary language(s).

In any case, I strongly recommend expanding your knowledge and learning a new programming language.  We often get caught in cycles of reinforcing what we already know rather than learning new and novel things.  All knowledge is power and every programming language provides at least one thing that's interesting to learn.
