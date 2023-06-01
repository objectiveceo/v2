---
date: 2021-05-30 11:24:37
slug: consider-your-choices
title: "Consider Your Choices"
summary: |
  I have a lot of conversations with my team about the choices that we make and challenge them to be thoughtful about them.
---
There are at least two things that I wish I could just remove from my team's minds:

* [Semantic Versioning](https://semver.org)
* [Git flow](https://nvie.com/posts/a-successful-git-branching-model/)

It's not that I disapprove of these items.  It's that the presence of these has a tendency to prevent any additional thoughts.  As the author of the git flow article notes in an addendum, usage of these items can become dogmatic.

# Why *not* just use them?

I typically do a lot of work on the terminal parts of the software process.  I manage many more final services and applications than I do intermediary libraries or frameworks.  With that in mind, whenever we have an opportunity to put a version number to something, my team almost always immediately chooses semver without a second thought.

This, while generally acceptable, avoids responsible versioning by defaulting to something that is only meaningful to dependency management.  It solves a problem that we don't have.

Our stakeholders are generally not library consumers.  The version numbers are generally meaningless until we imbue meaning into them.  Using semver makes it *harder* for them to understand changes over time.  Version 1.4.2 may not be appreciably different from 1.4.1 or 1.4.3 for our stakeholders.

Instead, I encourage my team to come up with appropriate version *names* for our releases.  We might lean into timeliness and tag our releases with the date or month.  We can then refer to them as the "May release" or "April release" to stakeholders.  We've can effectively communicate a sense of time that allows everyone to understand *when* something was put into production.

Occasionally, we get to describe our products by the features or major changes that we're putting in.  This is the important information for those products.  The timeline is less important than the *what* of the release.  My team understands things like "make-rendering-faster" or the "road trip" release.

Every so often, we have some stakeholders that like codenames.  Codenames for products and releases have a long history in software development.  Using them creates a kind of internal language that can bond teams by creating shared symbols.  One of my favorite systems was focused on Apple products and used apple varietals as names.  You can also indicate a sense of progression and relative age by doing something like encouraging alphabetical order (like Android used to use for their codenames).

In all of these cases, something like semver would have been *fine*.  But it would be fine merely in the instance in that it provides a name to the state of the product at a point in time.  That name would be effectively meaningless.  Semver solves a dependency problem very well.  The major/minor/patch rules convey important rules to the end users of those libraries.  However, a lot of software doesn't need it.  And using it impedes the ability to provide better information to the team and to stakeholders.

In many cases, for end products such as applications, merely using monotonically increasing numbers is as effective or more effective than using semver.  Many browsers do this now and avoids the marketing versioning schemes that many other products use.

# What's wrong with them existing?

To an extent, there's nothing wrong with semver or git flow.  I'm actually a huge fan of both.  But their presence prevents thought.

As with semver, my team often approaches every git problem as something that can be solved with git flow.  It's my job to make sure that we're making the right choices, but I'm surprised how often little to no thought is given to certain classes of choices.  When we think about how we manage our code, we give surprisingly little deliberate thought to something that we have to do multiple times a day.

In the presence of git flow, many just assume that this is the way and never stop to understand the problems that it attempts to solve or how they could be solved differently.  Perhaps worse, git flow is seen as a general solution for all code management and teams don't carefully think about the needs of their specific situation.  Worst of all (to me) is that many teams never re-evaluate their choice of how they manage their code.

I don't have anything against these tools or practices per se.  But I have strong objection to how often they are reach for before any additional thought is applied.  By providing highly popular systems, we're subtly communicating to our teams that "this is the way."  It's our job as leaders to make sure that we're choosing the right processes and communicating the reasons to our team.

If nothing else, I'm also tired of other people asking my teams why we're "not just using git flow."  We make choices based on our product needs and we attempt to communicate them.  But the presence of these items in our collective consciousnesses often leads other people to assume that we're making a mistake by not using them.  We need to normalize making deliberate and well-reasoned choices not only on our teams but across our organizations.

# This isn't really about semver and git flow

I've chosen semver and git flow as examples here because they are very popular.  I'm probably most frequently challenged when I've made decisions that go against these two systems.  I bring them up just because they're top of my mind, but I really want to illustrate that our job is to make better choices.

We should acknowledge that everything that we do is a choice.  Even when we're not actively making a choice, we've made a choice to follow that route.  When we say "eh, let's just use semver" rather than define our own versioning scheme, we're making a choice.  When setting up a new project and choosing how to work with each other, if we say "git flow" rather than discussing how we envision our collaborative processes to actually work, we're making a discussion.

The duty of leaders is to carefully make decisions based on the practical realities experienced by the team.  We also have to live with the consequences of our decisions.  Committing to any specific system provides certain advantages but also encodes certain behaviors.  This is my biggest issue with any system, even those that we create for ourselves.  When we begin living with our decisions, we often get into grooves where we continue and perpetuate those choices without any additional thought.

Regardless of which system we choose, we should be bold enough to constantly re-evaluate it and make better choices when situations changes or new opportunities arise.
