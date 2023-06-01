---
date: 2022-02-20 11:38:05
slug: in-progress-is-killing-your-project
title: '"In Progress" Is Killing Your Project'
summary: |
  A lot of projects get mired in a state where a lot is being done but nothing
  is being completed.  This creates both exhaustion and the sense of being
  overwhelmed.  You can fix it.
---
I'm currently advising on a project that has a very common process failure.  The
staff is working as hard as they can to open tickets.  A lot of important work
is currently "in progress."  However, when we get to the end of every sprint,
we're finding that we're not completing the number of story points that we had
estimated and our engineers appear to be working on the same things as they were
last week.  In a strong sense, the team feels like they're running fast but going nowhere.

This is causing a project spiral.  Tasks that should only take a day or two to
complete are now being estimated in terms of sprints.  Our project deadline 
feels completely blown and stress is high.

None of this is necesary and it doesn't accurately reflect the actual health of 
the project.

## Now is the Time for Leadership

As a leader of a team, it's very important to keep your head when those around
you are losing theirs.  When you're in the midst of a 
project, it can be difficult to pull back far enough to get a view of the whole
thing.  Unfortunately, this is the time when that's most necessary.

In this case, I have the benefit of being called in to advise on this
project, so I get to assess it holistically.  I can listen to everyone on the
team, but I also get to review things without the bias of history.  It's 
important to find this clarity when it's necessary.  I don't have any thoughts
about how a minor emergency threw the last sprint off track or how technical
decisions made in the first weeks are now coming back to bite us.  I just get to
assess where we're at and what needs to be done.

You absolutely must be able to remove the emotional response from your
assessment.  Now is not a time to fear a deadline or think about a prod failure
that's really someone else's fault or to blame someone for the current state of
the project.  Even if those things are valid, the current need is to assess and
adjust, not adjudicate.

## Start Closing Tickets

I've been in a lot of projects that seemed to get mired and stagnant in the 
middle of development.  The common theme that I've seen is that tickets get
caught in one of those middle to last half of ticket states, typically one 
similar to "In Progress." Sometimes, they start moving between the same two or
three states ("In Progress" -> "Ready for Test" -> "Selected for Development" ->
"In Progress"...).

You need to step in and start getting these tickets to a concluded state.

Here are some scenarios that I've run across:

* A separate QA team won't pass tickets

	This is a common one for some of my projects.  In many cases, there's an
	isolated team of individuals that have been given a strong mandate but 
	little trust.  These QA teams have their requirements and will match them
	precisely.  Minor deviations, even if benign or otherwise ignorable, will
	never be accepted.  The QA team is measured by how closely they catch items
	that don't match the spec.  They *should* be evaluated by how they 
	facilitate building and deploying good software, but they've been trapped by
	a legalistic measurement.

	In these cases, changes from the spec become impenetrable blockers.  I've
	often observed devs make certain changes based on practical experiences such
	as minor adjustments that ease implementation or realizations of 
	improvements that are only available once a feature is coming together.  
	Improved software doesn't matter if the spec wasn't updated, validated, and
	subsequently approved by a stakeholder to the QA team!

	I've also seen minor bugs or extreme edge cases that can only be present in
	pathological test scenarios block whole features.  There's no reason for 
	this!  Capture the details in a new ticket and toss it on the backlog.  The
	QA team should be empowered to talk to the dev team in order to make a value
	judgment if a bug feels significant or ignorable in the short term.

* A stakeholder won't stop making new decisions

	This is a difficult one because of how delicate communication may be.  In 
	some cases, we can run into issues where a feature is coming together.  As
	it's being brought to a close, a stakeholder plays around with the prototype
	and starts changing requirements.  The team gets new designs or requests.

	In every case, this is disruptive.  Sometimes, it's a minor disruption that
	barely adjusts the sprint cadence.  In other times, it can grow to push out
	any other effective work in that sprint.  In bad cases, cycles of
	prototype-test-change-repeat never quite finish.  In the worst cases, the
	work approaches finality but finds itself becoming an asymptote as a 
	constant stream requests prevent the feature from being closed.

	The solution here is to just close the original ticket and make stakeholders
	create new ones in requesting new work.  The original ticket may not have
	been completed, but you can (and should) leave remarks on the reason why
	it's closed.  The requirement to create new tickets will force stakeholders
	to be more methodical in their requests.  They'll be forced to go through
	the process.  You'll also be able to capture more discretely the amount of
	work that goes into each change.  Finally, you'll be able to assess these 
	changes in your sprint planning and compare them with other work in the 
	backlog.

* An unexpected technical challenge has been discovered

	There's a reason we call them "estimates" when we're doing story planning.
	There's no way to accurately account for every potential issue that might
	occur in the course of development.  Every so often, you come across a 
	situation where a technical issue has been discovered that puts the feature
	in jeopardy.

	Frequently, we just leave the ticket open and let a dev or several just beat
	their heads against the wall until they get to a breakthrough.  This creates
	a feeling like there isn't any progress on the ticket and doesn't account 
	for the real history and complexity of that feature.  The solution is a 
	little simplistic, but this is what works for me:

	First, take the original ticket and punt it back into the backlog.  It's 
	done for now and we won't pick it back up before resolving the current 
	issue is resolved.  Get it off of our mental plates.  Second, create a new
	umbrella ticket that describes the feature.  Assign the original ticket as
	a sub-ticket.  Create a new ticket that captures the current technical 
	problem as much as possible.  Assign it as a sub-ticket as well.  Evaluate
	whether to tackle this issue now or later.  Either move the new ticket into
	"In Progress" or move on to another ticket.

	I recommend the umbrella ticket simply because I find that there is seldom
	just one technical issue.  If we're able to scope our tickets small enough,
	we're generally able to predict what problems we'll need to solve to get it
	done.  However, when we have a ticket that produces an unanticipated issue,
	then there's also often the case that the ticket can (and will!) contain
	more unexpected items.  Creating the umbrella ticket prepares the team to
	get into the mindset of breaking the work into actionable pieces, creating
	tickets for proper tracking, and allowing us to evaluate cost-to-value.

## Less In Progress, More Getting Done

The above tactics give us the ability to move our open tasks into the Done 
column.  There will be times when a QA team comes back and shows that a feature
simply wasn't completed.  That happens.  There are times when business goals
change and a feature needs to be reworked in the final stages.  That happens,
too.  Discovering that a problem was much deeper than estimated definitely 
happens.

But, as a technical leader, it's your job to help the team make progress.  It's
also your job to be able to accurately reflect the real cost of development.
Open tickets that get stuck in the In Progress column for days (or weeks; or 
months!) are a sign of a disfunction.  Things aren't getting Done.  Often, this
isn't an accurate reflection of the actual cadence of the team.  But the effects
on morale and the ability to properly plan sprints are significant.

Do not let your staff get stuck in the quagmire of being perpetually In 
Progress.  Evaluate the tickets and train your staff to close them 
appropriately.  You have a lot of tools at your disposal.  Identify items that 
need to be completed as high priority Bugs or Tasks that can be tossed into the
backlog and triaged.  Make stakeholders acknowledge the costs of change by
having them engage in the process of intake and prioritization.  Capture the
real work that's being done by creating new tickets.

The ultimate goal is to realize the true cost of development and appreciate the
work that's being done.  By managing your tasks in these ways, you may not be
able to say that you've completed all of the story points that you expected to
in a sprint, but you can readily show a (near) equivalent amount of work to
stakeholders.  Your team may not have completed their features, but you can
reflect with them on the complexities and issues that they've faced along the 
way, showing how much effort and work actually goes into make quality software.

If your team feels like they are standing still, if your stakeholders are asking
about the preceived lack of progress, if you're unable to maintain morale in the
face of adverse development conditions, look to assess the work that's actually 
being done as accurately as possible.  It usually reveals a state of complexity
to the application or a breakdown in process that can be readily addressed.  If
your QA team is blocking good work, you now have some evidence to take to them
to start a discussion of how to deliver good software.  If your stakeholders
keep changing their minds, you have data on the costs of changes that might help
them be more resolute.

Who knows?  Improving the process by which you track work may help you identify
the very items that need your attention the most, improving the cadence of
development and moving even more items from In Progress to Done.
