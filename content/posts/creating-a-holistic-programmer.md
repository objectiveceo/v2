---
date: 2021-04-11 06:33:40
slug: creating-a-holistic-programmer
title: "Creating a Holistic Programmer"
summary: |
  A member of my team has demonstrated exceptional technical proficiency and is motivated to learn as much as he can.  However, he's developed the awareness that he doesn't know quite all of what he needs to know.  This is an incomplete list of the things that I think makes for a stellar general purpose programmer.
---
Let me begin by saying that this list is not comprehensive.  There are a *lot* of programming subjects that I'm not going to touch on simply because (a) I forgot and (b) this is based on my experience.  I haven't experienced everything yet, so it's necessarily biased to what I know and can speak to.  I also say that this is intended to build up a specific kind of software developer.

My goal here is to describe the kind of computer programmer that can be dropped into any project.  This individual will have enough knowledge to sit on any team and provide nearly immediate positive value.  Projects that require specialized knowledge may require some time for training, but the individual's prior knowledge should shorten that period or allow them to come to a higher competency than another peer within the same amount of time.  This will be one of those Swiss Army Knife programmers that can and does get anything/everything done.

And lest I give the wrong impression, this individual will be highly talented and thoughtful.  The breadth of experience will give provide additional insights into specific problems.  This isn't a "Jack of All Trades" kind of thing where the individual is doomed to a field of mediocrity.  Instead, this is growth into the knowledge of computer programming as a holistic experience.  That kind of total knowledge makes for ideal leaders and architects.  This is evenmore pronounced if you have cross-functional teams.

I'm calling this role the "Holistic Programmer" position.  Individuals who wish to be holistic will be able to understand the intricacies of each individual component as well as have a broad enough well of knowledge to appreciate how they combine into a whole.

# Core Programming Knowledge

I expect that a fully realized holistic programmer to know multiple parts of the following:

* Competency at scripting in at least one interpreted language (such as Python, Ruby, or Lua)
* Competency as scripting in a scripting language (Bash or Powershell)
* High competency in at least one platform-level language (Swift, Kotlin, C#, Java, Objective-C, etc.)
* Ability to generally reason through at least one other platform-level language
	* If you already know Kotlin, reading Swift feels like reading someone else's drunken script.  If you know C#, Java is already pretty reasonable.  This is a fairly low bar, in reality, but it seems to give some people conniptions.  [Learn X in Y Minutes](https://learnxinyminutes.com) is a great resource to practice.
	* Javascript/Typescript isn't bad if you already know another platform language.  If JS or TS *is* your platform language, increase this to "low competency" in another language.
* Low competency at reading, navigating, and writing in a "native CPU" language (C, C++, Rust)
	* This is actually a reasonably difficult request if you choose to read C++ or Rust.  Some of that syntax is *heinous*.  They also ask a lot in terms of understanding their memory models and standard libraries.
* Understanding of the C memory model at a high conceptual level (heap, stack, malloc, free, etc.).
* Understanding of one automatic memory management model (garbage collection, automatic reference counting, ownership semantics)
	* This knowledge should include details about how they work without necessarily predicting operation in practice.  The idea here is that one should have a deep enough knowledge that they can diagnose and debug memory issues.
* Threading/Concurrency/Multi-tasking
	* Knowledge of how threads work at a the machine level
	* Understanding of how an abstraction (like Promises, Reactive Extensions, Actors, etc.) works
	* Understanding of how a platform-provided mechanism works (i.e. coroutines or GCD)
* The ability to muddle through basic assembly or your preferred VM's instructions
* Some basic knowledge of how ports work
	* Not a whole lot necessary here except that it's a fundamental component of interprocess communication technologies and a conceptual understanding of how data is shared is helpful.

# Code-Level Domain Experience

There are a handful of code-level domains that are common enough that knowing them is highly useful.  This are distinguished from Concept-Level Domains in that these are things that affect how we write code or contribute to code-level debugging.

* Basic competency with some flavor of SQL
* Basic competency with regular expressions
* Experience with localization and internationalization and the distinct actions they represent
* Understanding of dates/times, date formats, and knowledge of the complexities of combining dates with locations
* General understanding of the Unicode standard and how modern text is represented as data
* How representations of floating point decimals affect representation of common items like time and money
* Benefits and costs of cross-language integrations (e.g. how to integrate C/C++ libraries if you're not already working in C/C++)
	* Alternatively, just learn C and the C ABI *really* well and call it even.
	* The Dart language has some interesting bridges built into the language.  If you can learn how it marshalls memory and manages resources in addition to being able to set it all up, I'd consider that sufficient for having a conceptual knowledge of this area.

# Concept-Level Domain Experience

* How load balancers work and what they are used for
* How to set up a high-value CI/CD pipeline
* Reasoned opinions on software versioning systems
* Basic conceptual reasoning behind REST
* Some experience with another non-REST system (SOAP, GraphQL, etc.)
	* Not much is needed here except to provide a basis for comparative analysis with REST
* Competency using a relational database system
* Competency using a non-relational/document-based database
* Deployment and management of a network of computers
	* Setting up multiple server nodes along with databases or caches in AWS or Azure behind a load balancer may be sufficient, but this feels like a growing need in modern times.
* Basic understanding of Containerization software
* Knowledge of one or more UI technologies (Android, AppKit, XAML... even HTML!)
* Basic understanding of the principles of functional programming
* Understanding of how automated tests contribute to project health
* Familiarity with package management and modern forms of managing dependencies
* Ability to profile a running application and machine resources for CPU performance and memory utilization
* High competency using a debugger to effectively debug a multi-threaded application
* The value of logging in production systems with some insight into how to set up monitoring

# An Inexhasutive List

This is a partial list.  I'll likely return to it as I think of more items.  If there's anything you think should be added, we can continue the conversation on Twitter.  Just send a message [@objectiveceo](https://twitter.com/objectiveceo).
