---
date: 2021-05-09 14:10:43
slug: build-the-next-thing-next
title: "Build the next thing next"
summary: |
  I keep relearning the benefits of building the next thing instead of the whole team.  Whenever possible, bite off only as much as you need to make forward progress and leave the rest of the project to the project plan.
---
One of the principals of modern programming and project practices is that small, continuous progress will more consistently produce better software than writing large swaths of functionality and then attempting to integrate into the fuller whole.  In my experience, this is mostly true and I try to abide by it.  However, I am still surprised at how quickly things come together and how much better the quality is when small iterations drive development.

# You don't need it all now

There's a certain sense where we break software down into component parts.  This is the user system.  This is our data storage.  Here is our networking layer.  However, we don't always break that down into more discrete layers sensibly.

Imagine working out the networking layer for a small middleware server.  If we imagine how we'll communicate with another service (in this case, let's assume that we're fetching data from a content microservice), we might just write up a ticket that says, "Fetch data from Content Server."

That feels like a discrete task that can get done in a sprint.  But somewhere, in the back of someone's mind, there is a whole task list that's invisible to everyone else.

Imagine that the content server has certain rate limits.  Imagine that there's a performance cost to fetching data.  Imagine that the content is updated infrequently and the data could be readily cached.  Imagine that the content server may be unreliable from time to time and you'll need some fallback.

In this case, some senior engineer on the team may have an entire architecture developed based on these poorly documented requirements.  That architecture will require a caching layer with sensible defaults, some fault tolerance algorithms such as the circuit breaker pattern, decisions based on when to re-query the content server on cache misses, and, perhaps, even some webhook that could cache data proactively to keep the caching layer in sync with the content data.

Okay, so we've now gotten all of our tasks defined before we're done implementing "Fetch data from Content Server."  The next important thing is to determine the priority of items and what needs to be done next.  All of those things don't need to be done all at once.  It's entirely possible to do some things quickly to will enable other work.

In the above case, the next step is to mimic fetching data from the content server and present it to the callers.  This middleware layer will block work on clients until it can provide something that they can use.  Clients can mock it out, but allowing them to communicate with the server actively allows for iterative development as things progress and continual testing across the dev lifecycle.

Once the mock data is presented, the next task will be to fetch data from the content servers.  There's no need to implement caching or fault tolerance at this time.  You must walk before you can run.  With some real data communication in place, you can then start building out the other layers.

One of the only things that you can't punt on is security.  Good security practices must be baked into your services from the start.  You can use mock users or something until you get an actual user system in place, but it's very difficult to retroactively update services to use good security practices.  You must be thinking through that and incorporating it from day 1.  These practices also allow the clients to establish strong expectations for what the security model will be and grow their systems as well.

# You don't know it all now

You might think that you should build fault tolerance into your system ASAP.  It's my experience that I've never been able to confidently predict all of the ways that something could break.  Putting good logs into place around places where I expect breakage and monitoring any exceptions that weren't caught will give a lot of insight into what actually happens.

I can't tell you how often I've read through the documentation and was told that a valid XML document was a guaranteed response only to find that it *could* be malformed in practice.  That has also happened with JSON and YAML documents.  I've also been told that errors would produce a 200-level response with an error response object but wound up receiving a 500-level response.

I've seen services misconfigured so that one in three responses would be a server error due to a bad load balancer.  I've been caught in some A/B tests where the expected data payload was subtly, but meaningfully different.  I've also seen services that were otherwise rock solid start timing out during significant (and unpredictable) load periods.

There are a lot of potential errors and not all of them will affect all services.

I've also found that we made a lot of assumptions about intended usage in our apps and defined response objects that did not accurately match real world needs.  I've worked on services where real life data revealed lots of ways where we could streamline or optimize the data for our specific needs.  I've also been in situations where the real world data wasn't what we expected and found that we needed to revisit a feature and figure out what was actually needed.

This is a lot to say that you're in a constant state of discovery in the early days of active development.  The more layers that you add to your app, the more difficult it is to make appropriate adjustments.  Focus on building what you need first and add the additional layers in future iterations.

# You're not going to need it later

There's an incredible thing that happens when you've lived with a project long enough to have real context: you realize what the real needs are and de-emphasize the imagined needs.

At the start of a project, you are working with knowledge of the past projects and expectations for the current one.  However, each project may present novel twists or requirements even if the majority of the brief feels familiar.

The last project needed a cache to remain performant and you might already have that in your project roadmap.  However, it may come to light that the data is too dynamic to be effectively cached or that retrieval is so fast that caching it locally provides negligible benefits.  You might have built out a Kubernetes-based scalable architecture for a recent project but your current one has much more modest expectations and doesn't require scaling.  You could spin up an entire process for blue/green deployments but find out that you don't really need uptime guarantees as long as you don't deploy during certain time periods.

This is a very difficult habit to overcome.  We always want to put everything of ourselves into every project.  We want to do all the things that we know how to do.  However, that's not necessarily what is needed on every project.  If you focus on building the next thing, you'll build the context and insight that allows you to avoid building unnecessary things.

# Build next now

One of the great things about being hyper-focused on building the next thing is that you have likely already gathered the context you need on what that is.  As you work through your project needs, the insight into what is next should come through the organic revelation of the system.

In the beginning, you'll be exposing bits of behavior that meet requirements and enable future work.  In the middle, you'll be exposed to potential issues both in initial assumptions and limitations of the system that will need to be addressed.  By the end, you should have data to know where to focus on the portions that require performance optimizations or additional hardening.

You can readily keep a list of items that you think a project needs in the backlog.  You might brainstorm on everything that you can add to the system and keep notes on where and how it'll be effective.  It's entirely okay to put something into the backlog that you never get around to actually implementing.  That's the point of the backlog: to keep track of ideas so that you don't have to.

However, you should be actively prioritizing what you're working on so that you're always focused on the next necessary thing.  Build that thing, reflect on what you've built, and then aggressively prioritize the next thing to build.  Avoid unnecessary complexity until you absolutely need to add it.

Everyone is dismayed when their hastily-thrown-together prototype winds up getting shipped to production.  I don't think we take the time to appreciate how often that prototype is exactly what is needed at the time that it's available.  Many systems don't need more even though we want to build more.  From experience, the ways that systems break in production are often not what was predicated in the prototyping stage.  Sometimes, the fixes for things that are in production and could have been predicated at development time can be addressed retroactively much more cheaply as context and understanding around the system grow.

Value is generated when a project is actually used.  Focus on the next thing and not all of the things and you'll learn more in the interative process of building a project than on the anticipatory process of planning one.
