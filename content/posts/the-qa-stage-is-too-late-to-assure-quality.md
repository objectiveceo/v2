---
date: 2021-06-27 13:27:58
slug: the-qa-stage-is-too-late-to-assure-quality
title: "The QA Stage is Too Late to Assure Quality"
summary: |
   The company that I work with is moving to a "shift left" method of test assurance.  I believe that we have positioned our test engineers poorly and need to set new expectations to create better products in the future.
---
In many typical software development processes, test engineers or QA specialists verify changes *after* the code has been written.  This system allows for confidence that changes to the product do what is intended and do not introduce unintended results elsewhere.  Unfortunately, this process is pessimal in many ways.  It results in an "us-them" mentality between development and test, slows product development, and actually reduces the overall quality of a product compared to other processes.

The term [shift-left testing](https://en.wikipedia.org/wiki/Shift-left_testing) refers to a process in which testing is done early in the development lifecycle, maybe even concurrently with development.  The goal is make defect detection as immediate as possible.  The goal is to catch issues and refine expectations in the process of development so that there's a minimal amount of context switching.  Items spend less time in various stages and the cadence for delivering change is faster.

I've had some difficulty moving my teams towards a shift-left model.  I've found two primary problems:

1. Test engineers need to understand the new model.
2. The entire team needs to norm to new processes.

# Moving to shift-left testing mentally

The test engineers that I frequently work with have had a model in their head that put a hefty burden on them.  They were the arbiters of quality for the product.  They were the advocates for the user.  They were responsible for the ultimate state of the shipping product.  Since they were the last people on the team to get their hands on the product and run it through its paces before it was shipped to our clients and users, they had assumed this massive responsibility.

They were wrong.  But it was a common notion.  One that I believe was a natural product of the processes in place, the result of some poor management, and likely some internal self-aggrandizing.

When we place test engineers at the end of the product lifecycle, we're implicitly entrusting them to catch all of the things that weren't caught at earlier stages.  That includes decisions made about the product, assumptions about the user, decisions about implementation, and more.  This placement emphasizes trust.  My testers were in positions where they could pass final judgment on the ship-worthiness of our product.  This process fed into that mentality that they were the owners of product quality.

I've also heard from nearly every test engineer some dismay that a bug had escaped their attention.  Bugs happen.  Every bit of commercial software that I've seen or been a part of has had a bug or two (or many!) in them.  So I never blame a test engineer for bugs.  It doesn't make sense; bugs are just things that happen that we can address, prioritize, and fix in future releases.  However, every tester has assumed that burden of shipping bug-free software.  I'm sure that some manager, at some point in their career, has asked them, "How did you miss that?"  This is a bad question.  It assigns blame and creates a cycle of responsibility for the bugginess of a product centered in the individual.

It's also my experience that test engineers often have a bit of complex and concern for their position on teams.  That likely comes from the lack of respect or understanding that's afforded to them by the industry.  I've had many clients ask if they could just not have test engineers on products.  They see them as another item to budget for but one that feels easy to cut.  It is my experience that test engineers are vital and valuable team members.  But in that environment, test engineers often band together and define their own value.  They say things like "I fight for the user" or talk about how test engineering is the process by which diamonds in the rough are polished.  This establishes a communal valuation but misses the actual service of test engineering.

# Moving to shift-left testing in practice

You cannot make a whole-team process change by merely talking to test engineers.  However, I highly recommend getting the buy-in of test engineers *before* talking to the team about shifting left.  For the product ideation, software development, and team management side of things, life looks *mostly* the same.  However, this process may uproot the way that test engineers typically work or define their work.  I work on the principal of least surprise and changing how someone peforms his or her job can be *quite* surprising.

The first step is to get your team aligned whole team ownership of vague concepts like "quality" and "excellence."  No single person or role owns quality.  Neither the product owner, principal engineer, manager, nor the testers can claim that ownership.  It's something that the whole team needs to own.  We would hope that moving to this mindset can help some individuals invest more deeply in the product while also removing that burden from others.

The second step is to limit or discourage individual contributions to the product.  This sounds absurd, but it'll be helpful in moving towards a shift-left model.  If developers are expected to write code and then throw it over the wall to test engineers, remove that wall.  Strongly encourage pairing or mobbing on items.

What you're looking to do is eliminate the cycle of development -> defect discovery -> reprioritization -> development -> approval.  That's a very expensive cycle in terms of person hours, especially if the developer has already moved on and has to remember the context of initial development.  It may *feel* faster to have each person working on one thing, but it's often practically faster to have people pair.

The development cycle will have many fewer stages with the middle stage covering both development and testing.  Things move from "ready" to "in progress" to "done" without a lot of the stages that often come between "in progress" and "done."

Inviting test engineers to be part of the development stage allows them to view what assumptions the software developers are making.  This is a vital means of addressing decisions early and avoiding hidden pitfalls.  Test engineers will know what the developers are doing and can adjust their testing strategies closely.  Test engineers that are inclined to write code can also be proactively working on the appropriate automated tests or aiding in debugging or documentation as necessary.

Inviting development engineers to the test stage allows them to understand more about the code that they're writing and see more of the ultimate goal.  Test engineers can explain or show their methodology for testing.  This allows development engineers to proactively address potential issues or anticipate edge cases.  Understanding how test engineers determine approval or knowing what tests will be written up front allows development engineers to iterate on their implementation immediately and get to a final version rapidly.

The processes should be happening concurrently.  The only way to make them concurrent is to have development and testing working together.  This is something that often needs to be encouraged and practiced.  Software development often falls into cycles of individual contributors throwing code into a repo with formal verification happening at a later time.  Working simultaneously with peers is a skill that has to be developed deliberately until it comes naturally.

# Better teams, better products

One of the benefits of shifting left is that the quality and cadence of a product goes up.  My experience tells me that quality is often noticeably improved.  Putting test and development together allows them to ideate and iterate on the best possible product together.  Defects are detected and addressed immediately.

Cadence also moves more quickly, though not as obviously.  Individual tickets may spend longer in the "in progress" phase, but the total number of phases is reduced.  We may look at the time that two individuals spent on a ticket and see that the total hours of "development" is larger than the sum of an individual developing and another testing.  However, tickets often don't account for the amount of time leaked because of context switching or reminding research that happens prior to the ticket being pulled and the clock formally starting.  It also completely fails to account for instances where tickets are moved through the system and bugs are opened as new tickets.

I'm not claiming that doubling the time that we put into any given ticket by putting (at least) two people on it will halve the time of implementation.  But I will say I've experienced projects picking up momentum after pairing up.  Sometimes, the number of story points that we can address stays the same or even dips a bit, but the actual cadence is improved.  We generated fewer regressions and could work on net new features and requests rather than continually refine and prioritize bugs into our sprints.

The biggest benefit for my teams has come from the improved moral and sense of ownership from the members.  Close collaboration has been great for improving communication and creating the social connection that allows for trust.  They teach and learn from each other in every development cycle.  Substantive improvements to code are made more visible just by sharing with another person.  Even catching small bugs or ideating on tough problems with another person makes the amount of actual, meaningful work more appreciable.

By setting an expectation of shared quality and promoting the process to achieve it, I've allowed my team to invest themselves in the product and in each other.  I can show them metrics on how many fewer regressions are being found or how our user happiness metrics are improving, but the experience seems to be more rewarding.  They can *feel* how much quality is improved because they are working together to improve it in real time.  They *know* how much better the code is because someone else is actively engaging with them to make it so.

Shift-left testing requires deliberate processes and trusting teams.  But, if you have the capability and opportunity, shifting left can be a driving factor towards better products and happier teams.
