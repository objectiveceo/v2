---
date: 2021-08-15 10:19:25
slug: a-malicious-reliability
title: "A Malicious Reliability: Or How to Hurt Yourself With Best Practices"
summary: |
  Writing robust failover behaviors is *usually* the right move for many websites.  This week, I found a case in which it actually caused an outage rather than save us from one.
---
Last Monday, around midday, a large, American fast casual restaurant chain experienced just shy of two hours of downtime.  I know because I'm the one that broke the website.  Not intentionally, of course, but I thought I'd explore how that happened and what I learned from it.

# The Setup

I manage multiple large American brands as part of the portfolio of clients that my team directly supports.  I recently took over this brand and did a review of the project.  As part of that review, I noticed some minor optimizations to the Dockerfile that represents the shipped application.  I assumed that (a) the changes were benign and (b) that we'd notice in our test environments if there were any problems before shipping to production.  I was wrong on both accounts.

Our application is an AWS Fargate service that is configured to scale across multiple metrics.  Some of those metrics include scaling up to meet the demands of traffic.  As a result, we also have some robust failover behaviors that allow us to maintain the service in the event that we run into unexpected runtime problems.  This latter situation gave us a lot of peace of mind when developing and shipping the application, but wound up being the cause of our probem this week.

## What Happened

In a bit of a perfect storm kind of deployment, we were debugging some issues that *could* have been affected by our code or could have been affected by interactions with a third party vendor.  Our deployment on Friday afternoon included my changes to the Dockerfile as well as some code changes that *might* have solved some issues that *might* have been resolved by other configuration changes in other systems.  When we shipped to our test environment, we noticed that the bugs we tried to address were fixed.  We saw what we expected to see and didn't investigate further.

We shipped to Production.

On Monday, we got an alert that the website was down.  We immediately dove in to see what was wrong.  Our first assumption was that there was a configuration issue in the middle layers.  We didn't ship on Monday, so we didn't suspect any issues with the code.  As we peeled back the layers, we eventually came to the realization that the changes I had made to the Dockerfile were causing this issue.  We reverted those changes and watched as the website came back to life.

## How Did It Happen

We were initially confused as to how the website went down on Monday and not when we shipped on Friday.  It turns out, our failover and scaling states were obscuring a real problem.  When we shipped on Friday, our deployment actually *failed* and we rolled back to the prior "good" deployment automatically.  We didn't have any alerting in place to bring it to our attention.  Coincidentally, the third party vendor updated their configuration that changed the behavior of the very bugs that we were trying to verify.  We didn't have a reason to believe that the deployment was broken because we observed the behavior change that we expected from our code changes.

All weekend long, the traffic to the website was well served and we didn't have any scaling events.

Then, on Monday, when the midday business lunch traffic picked up, we started scaling out our instances to match.  At some point, we experienced one of those unexpected runtime events in the last "good" deployment.  Our failover behavior got stuck in a loop of attempting to spin up a new instance of the broken build.  The broken build crashed at startup and so Fargate would immediately attempt to spin up another instance.

Our good efforts that ensuring reliability and uptime wound up becoming a timebomb.

## How We Are Fixing It

My team recently took over this product from another team.  We lacked some experience and knowledge of how it was architected.  We got a crash course in it and gained a lot of knowledge.  These events are always unfortunate, but they reveal a lot of important knowledge and unveils the areas where we need more visibility.

In the immediate term, we have defined a process by which we can manually verify which versions are shipping by looking at AWS CloudWatch and Cloudformation logs (in addition to following the trail from ECR to Cloudformation).  In the middle term, we want to set up some alerting that immediate emails us when one of our deployments fail.  In the slightly longer (but still near time frame), we'll set up some checks in our CI/CD pipeline that allow us to verify builds.

My team will now take this experience with us into the future.  We know that having a good failover plan is an important part of modern service architectures, but we also have the knowledge that it can obscure failure states until it's too late.  We should increase our visibility into these states and provide immediate feedback to the team.
