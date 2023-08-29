---
title: "Upgrading Ubuntu"
date: 2023-08-29T10:30:28-04:00
draft: true
summary: |
  My SSL cert for this website expired again.  This time, it was a combination
  of environment forces that required me to make some server-side upgrades.
  This post explores what went wrong, how it was fixed, and also explains the
  cons of owning your own "hardware."
---

Last week, I received an email from [Let's Encrypt][1] telling me that I had 7
days left on my current SSL certificate that provides the "S" in the https
portion of the URL.  That was curious.  I've configured `certbot` to
automatically renew my certs.  In any case, I made a mental note to come back to
it later.  I didn't come back...

[1]: https://letsencrypt.org

Instead, the cert failed over the weekend.  Let's Encrypt sent me other emails.
But I ignored them as well.  I knew I needed to fix the issue, but I had other
things on my plate.  It felt like a low priority and, I thought, a quick fix.
So it failed and requesting the secure version of objectiveceo.com gave that
lovely "this website is not secure" warning.

In short, `certbot` stopped working on my server.  Like, it just stopped.  So
the automatic updates stopped as well.  I tried to do the most obvious thing to
me and ran it manually to see what was happening.  I noticed that `certbot`
would crash during runtime.  It had trouble looking up a specific dynamic
library.

If you're not familiar with how (some) software works, the actual software may
be distributed in multiple pieces.  Instead of bundling everything up into one
binary (which is the default for languages like Go and Rust), applications made
with languages like C and C++ can create multiple binary files.  Some of these
will be "library" files that can be loaded *at runtime*.  The common reason is
that distributing these library files allows for multiple applications to link
to them, sharing the logic and reducing the total size of all of the binaries.

At some point, I had logged into my server and run some upgrade command (likely
using a package manager like `apt` or `snap`) that most likely make the relevant
change.  `certbot` was crashing while referencing a common system library that I
didn't have.  I don't know what happened to it.  I likely never had it and
accidentally updated `certbot` to a newer version that had updated library
expectations.

## The fix: Updating the OS

At this point, I had a few choices.  I could either find a way to compile and
install that library, find a way to downgrade `certbot`, or follow up on my
assumption that `certbot` was using updated requirements and the most correct
solution would be to update my OS.

It feels very weird to assume that changing the entire environment to fix one
tool is the most correct solution.  That said, I knew something very important:
I had never updated that server.  I purchased a shared node from [Linode][2]
many, many years ago for a different website.  When I opened objectiveceo.com, I
just repurposed that node.  I've never bothered to update the OS because, well,
everything ran without problem up until now.

My flavor of Linux was a version of Ubuntu that was well beyond the long term
support (LTS) cycle.  `certbot` was the first problem, but I assumed it was the
canary in the coal mine.  I expected other components to fail in unpredictable
fashions in the future.  Besides, there were likely many security, performance,
and feature benefits to updating.

I went to [Linode's upgrade documentation][3] and followed it.  If you're not
familiar with Linode's knowledgebase, let me introduce you.  Linode provides
some exceptional quality documentation for managing Linux and server
technologies.  That's distinct from using the Linode products, so you may want
to refer to it even if you're configuring something for another server provider.

In this case, I found something curious.  I ran my update by following that
documentation.  On reboot, I wasn't running Ubuntu 20 (Focal Fossa).  I was
running Ubuntu 16.  What?!

Today, I learned that that Ubuntu doesn't upgrade you to the latest LTS version
automatically.  Instead, it upgrades you to the LTS version that follows the one
that you're currently using.  So I had to run the updater *two* more times to
get up to 20.04 (Focal Fossa).

There's one more upgrade path (to Ubuntu 22).  I plan on doing that soon.
First, I want to put together a more cogent plan for how to handle these
upgrades.  Following reboots, I need to restart my nginx instances and make sure
certbot is running again.  I'd like to encode these as services that can be
automatically restarted after an upgrade.  So I'll implement those changes first
and then make that final jump to Ubuntu 22.

[2]: https://www.linode.com
[3]: https://www.linode.com/docs/guides/how-to-upgrade-to-ubuntu-22-04/

## The big takeaway: Try not to do this

Look, I love managing my own "hardware."  In this case, I have a shared node
from Linode that I only interact with via ssh.  It's not quite the same as back
in the day when I was installing server rack units and doing cabling.  But it
approximates a lot of the "feel" of using real hardware.

For this instance, I take ownership of how it operates.  From the software
that's installed to the OS that it's running.  That provides a lot of
flexibility and power.  However, it also creates a lot of additional work.

Today was one instance of that work.  These kinds of upgrades are often ignored
or invisible, but they are a significant amount of technical debt.  It takes
time and expertise to maintain these kinds of systems.

This technical debt is also potentially very costly.  In my case, I could
readily bring my server offline for an hour to apply the updates and restart my
services.  The cost was that the world was denied a vanity blog of marginal
information value for a brief period of time.  For commercial ventures, that
down time could result in the lost of significant amounts of revenue and/or
customer satisfaction.

For these reasons, many companies are willing to pay significant money for
service contracts that promise to allow software to run un-minded for long
periods of time.  The cost of continuous maintenance combined with SLAs
protecting against long term outages is worth it so that the org can free up
engineers to focus their talents on other activities.

While I appreciate the business cases for those kinds of support contracts (and,
surprise!, I used to be in that business in a sense), I typically recommend
avoiding that hassle in the first place.

Modern technology has advanced to a stage where sophisticated systems can run
without those maintenance burdens.  Containerization technologies abstract away
the OS and allow for services with names like "Serverless" or "Orchestration."
Those services abstract the hardware.

If you choose to use a service like [AWS Serverless][4], your software will run
in "firecracker" containers that are designed for fast startup.  AWS will keep
those containers up to date and automatically apply any necessary security or
performance patches for you.  You don't need to make any changes.  One day, your
instances will just start running on the updated containers.

[4]: https://aws.amazon.com/serverless/

In my case, I could readily choose to host my blog in an edge network storage
solution like AWS S3 or [Cloudflare CDN][5] or similar services.  I (currently)
have a static blog.  Moving to a CDN would likely be a lot cheaper, provide
faster delivery, and remove all of the environment-maintenance-related
headaches.  I choose not to make my life easier in this aspect because I do a
lot of tinkering and exploring on that node.  I'm actually inviting these kinds
of problems so that I can experience solving them and gaining knowledge and
perspective.

[5]: https://www.cloudflare.com/application-services/products/cdn/

The major point is that modern "cloud native" computing involves using
technologies that have already solved these pain points.  Choosing the right
technologies for your application can greatly lower the ongoing technical debt.
It'll never be nil, but you can bypass a lot of the headaches and costs that
were historically solved by purchasing support plans.
