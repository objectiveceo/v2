---
date: 2021-03-07 19:01:03
slug: debugging-takes-us-to-strange-places
title: "Debugging takes us to strange places"
summary: |
  I was recently working on a production outage and utterly befuffled about my ability to make any meaningful changes that would improve our situation.  My team and I found ourselves surprised by the eventual resolution.
---
There's a certain fear that sets in when you've run out of ideas but a problem continues to exacerbate.  There's nothing else to do, but you feel the pressure to do *something*.  I had a situation this week where I felt absolutely stymied and ineffectual for most of the day, but my team and I kept gathering information and pushing forward until we found a solution.  We couldn't have predicted what the actual root cause would be.

# A case study

This week, I was working with a team that supported a product that involved mobile applications, an web admin portal, and a multi-tiered backend service environment.  We were having some hiccups and interruptions in service during the week, but they were mostly temporary.  At times, we restarted the services that we owned and monitored the performance.  We had determined that there wasn't much that we could do, but we proactively observed the system.

On Friday, we experienced something novel.  We had internal and external monitoring.  The internal monitoring was showing that our service was experiencing a very high number of errors.  Those errors were increasing.  That wasn't new, we've seen that before.  What was new, however, was in our external monitoring.

We had monitoring tools around the places where we communicated with other services that we didn't own.  For the most part, these were performance metrics that recorded how long it took to receive responses from these services.  We observed that the total connection times were growing at an unprecedented rate.  The average connection time to these services blew past our expected response times (of less than a few seconds) into concerning response times (of a minute or more).  As we followed our metrics, we noticed that those connection times continued to grow.  And grow.  And grow.

We explored our side of the problem.  We could restart our servers.  Those connections would reset and we'd see the average connection times reset and then grow again.  It seemed like we just weren't receiving data from the upstream servers.  At a certain point, I decided that there wasn't anything that we could do to resolve this issue.

Our users couldn't use our apps and I needed to find a solution, but there wasn't anything we could do.  So I started a call with the teams that owned the upstream servers.

## A baffling problem

The upstream teams were as baffled as we were by our situation.  They observed our monitoring tools and agreed that there was a problem.  Unfortunately, all of their tests and monitors were passing.  They didn't see any issues on their end.  We knew that there was a problem, but we didn't know where it was.  We didn't have anything actionable and there wasn't anything that we could immediately do.  So we kept spelunking.

We called in additional people and started to gain access to other systems.  At some point in the chain, we located a load balancer that was recording error responses.  The graph of those responses mirrored my graph of connection times.  We still didn't find the root cause, but we were getting closer.  Unfortunately, we were getting further away from the primary systems that we had confidence in managing and deeper into secondar and tertiary systems.

Eventually, we worked our way to a shared database.  Somewhere upstream, there was a database that was being used for multiple streams of work.  The content that we needed was stored in that database.  We realized that the node for that database was reporting 100% CPU utilization.  As we looked into it, we found that another department had started running an exceptionally expensive and long-running task.  With permission, we ended that task.

We then went back to our monitoring tools and breathed a huge sigh of relief.  Our growing mountains of errors and performance issues had peaked.  Our measurements were declining back towards acceptable levels.  Our applications were usable again.

## RCA

The root cause analysis for this specific piece identified that long running database query as the source of our problems.  There's no way that my team could have identified that from our vantage point.  There also wasn't any way for our cohorts on the other teams to have identified that issue.  This was one of those issues where we followed the breadcrumbs all the way to the end and was wholly surprised by what we found.

Now, arguably, we shouldn't be sharing databases with other departments or we should have failovers or some kind of monitoring to handle these issues.  I'm not interested in discussing preventatives in this review.  Sometimes, the pace of progress causes some items to fall through the cracks and I'm not assigning blame to anyone.  I can imagine how we'd get into this situation through good will and best intentations.

My point is rather to illustrate how the chain of events can lead us into unexpected places.  We observed that our mobile apps were failing.  Our monitoring was telling us that we had a lot of errors and that our upstream services weren't responding.  Our upstream servers were working as intended and didn't show any errors in their monitoring.  As we continued following the chain, we kept accumulating more information, more people, and more sides of the business.  We traced the error all the way through our systems and into other systems.  We looked up server logs, read network traces, worked through process information, and even explained some database queries.

Despite how resilient our processes were and the exceptional thought that we put into our systems, we were still taken down by someone in Finances.

Sometimes, you make all of the right moves and guard your systems against all of the potential threats.  You can add monitoring around all of your processes and even verify the performance of your peers.  You can design infrastructure that's fault tolerant and flexible.  In the end, you can still run afoul of that one shared resource that someone, somewhere, on another team forgot about and neglected to document.  Sometimes, that's life.
