---
date: 2021-04-26 06:42:09
slug: iac-joy
title: "IaC JoY"
summary: |
  "Infrastructure as Code" is a simple concept that provides expansive opportunities.  I've had the pleasure of setting up another project using the IaC model and was reminded of how much value it brings to modern web services.
---
If you're not aware of what Infrastructure as Code is, the [Wikipedia article](https://en.wikipedia.org/wiki/Infrastructure_as_code) is, as usual, a good general resource with links to several tools.  However, Microsoft publishes [a pretty good introduction](https://docs.microsoft.com/en-us/azure/devops/learn/what-is-infrastructure-as-code) as well.

In short, IaC describes some means of creating machine-readable documentation of the services that are required for running your application.  The "machine-readable" part is very important.  You could document the infrastructure of your service setup, but if it can't be read by some program or tool, then you've dropped the whole "as code" part.  The point of IaC is to make your service setup replication exceptionally cheap.  By describing it "as code," you're allow automated tooling to take care of everything.

# Ad Hoc and the old ways

Back when I deployed my first web application, the whole landscape of development was very different.  I didn't have a VM.  Instead, I had a user account on a Linux server.  I dropped Perl scripts into a cgi-bin folder configured by an Apache instance.  If I needed anything else, I had to download, compile, configure, and run everything myself.  My first app that required data persistence (a guest book, natch for the time) orginally wrote everything out to a file.  Eventually, I had to learn to install "mysqld" and how to connect to its socket.

As time went on, the ability to get things set up became much easier.  AWS and the advent of the "as a Service" model ([SaaS](https://en.wikipedia.org/wiki/Software_as_a_service), [PaaS](https://en.wikipedia.org/wiki/Platform_as_a_service), [IaaS](https://en.wikipedia.org/wiki/Infrastructure_as_a_service), etc.) allowed us to spin up whatever hardware and software that we needed.  It was an incredible boon to productivity.  Whenever I needed a database, I no longer had to compile and configure everything myself.  I could just go to a provider, click a few buttons, and have one spun up and ready for me in mere minutes.

This created a few issues.  It was wonderful for prototyping and getting things running, but it was poor for reproducing.  It wasn't uncommon to try to migrate something in the development environments into production and neglect something.  Even when you've done everything correctly, confidence could remain low with the back-of-head thought that some important configuration option was forgotten.

Deployments that introduced infrastructure changes were games of guess-and-check.  Hopefully, everything worked.  But sometimes, it didn't.  Sometimes, you'd play a game of Whack-a-Mole, discovering that multiple items were left undone.  They could be stressful.  "Don't deploy on Friday" was a common trope.

Many teams also just adopted a mindset of accreting costs over time.  The inability to readily assess the necessity of all running services meant that services that were spun up were rarely spun back down.  Even if you could determing that a service wasn't being used, there was low confidence that it could be turned off.  Occasionally, you'd attempt to turn something off only to find out that it was still significantly used.  It only takes a few instances to just leaving things running.  While there should be costs associated with growth, there were also unnecessary costs of "zombie services" that we should have died but we couldn't kill with confidence.

# IaC empowers you

Using an IaC tool for your services is greatly empowering.  You get the ability to spin up similar environments in the span of mere minutes.  Want to copy your changes from deployment to prod?  No problem!  Would your like your PR builder to also create a testable environment?  Go for it!  Find that your current services are being crushed under significant load?  Spin up another instance immediately to share the load!

The ability to replicate with confidence also frees you from the stress of deployments.  You can deploy on Fridays again!  You can deploy frequently and with great confidence!  You can readily create new environments for blue/green deployments.  You can provide uptime guarantees because you can spin up a new environment parallel to the current one and then just switch new traffic to the new instance.  Since your infrastructure is code, you can also check it into version control.  You can connect it to monitoring software that can automatically roll back to the last known "good" deployment if you find an increase in errors rates.

You also get to control the costs associated with your project.  You can more readily remove zombies from your costs.  You might forget to remove something from the code file that represents your infrastructure and have a service spun up unnecessarily.  But by documenting your needs as code, you're allowing yourself more confidence when you audit your systems.  You should be able to trace that need throughout your codebases without having to rely on institutional knowledge to let you know if it can be pulled.  If, for some reason, you can't follow it readily, you at least know that the cost of restoring a service is as cheap as reverting a commit.

I've found a lot of joy in managing complex services that have their needs clearly documented.  I found even more joy when those documents can be read by tools and have everything I need created for me.  That replication (a) creates options, (b) lowers costs, and (c) increases my confidence.  If you're not already documenting your infrastructure with code, I highly recommend that you explore moving in that direction.
