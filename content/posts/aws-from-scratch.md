---
date: 2022-01-17 10:00:15
slug: aws-from-scratch
title: "AWS From Scratch"
summary: |
  The start of a multi-step tutorial for setting up a handful of AWS-based
  microservices.  This is an ambitious tutorial and this post explains the
  project and its goals.
---
One of the biggest headaches for me in modern computing is the lack of
comprehensive and digestable learning resources.  A lot of what's available is 
somewhere along the spectrum from "so simple as to be practically useless" and
"[draw the rest of the owl][owl]".  Since I'm currently working actively with 
AWS-based services, I thought I'd put together a small example of working,
multi-resource webservice a bit at a time, documenting each stage as I went.

[owl]: https://knowyourmeme.com/memes/how-to-draw-an-owl

# The Project

The Project itself is going to be a very basic web service that utilizes
multiple resources.  I'll leverage a basic microservice architecture as well as
build out necessary AWS resources like RDS and S3.  We'll discuss some basic
technologies like VPCs and IP masks and NAT Gateways and the like along the way.

The ultimate goal isn't to produce a production-ready webservice that'll be used
by millions.  The goal is to explain how modern webservices infrastructures can
be architected.  We'll also introduce items such as effective CI/CD-based
deployments and reasonable automated testing strategies.

As we go, the project files will be [updated on Github][gh].  We'll refer to
specific diffs and changes as we go.

[gh]: https://github.com/Grayson/aws-service-setup

# The Setup

There are a few requirements to following along as well as a handful of optional
installs.

First, you'll need to have an AWS account.  If you don't already have one, you
can readily [create one](https://portal.aws.amazon.com/billing/signup).  AWS has
relatively generous tiers of free support, but some of the changes that we make
may incur minor costs if you're following along.

Second, you'll need to download and use the [AWS command line interface][cli].
If you're comfortable with [Docker](https://www.docker.com), you can just use
the [Docker-based cli image][dcli].  For much of this project, we'll be using
that image with a [convenience shell script][css].  I find that Docker-based
tooling increases consistency in reproduction and reduces the likelihood of
conflicts with other tools.  I also run a lot of projects locally, so I might be
increasing the opportunity for tooling-based conflicts.

Third, I'll be using [VSCode][vsc] as my primary editing environment.  I'll try
to [include any extensions][vsext] that I'm using with the project.  VSCode is
pretty good and available on the major modern Desktop OSes.

[cli]: https://aws.amazon.com/cli/
[dcli]: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-docker.html
[css]: https://github.com/Grayson/aws-service-setup/blob/main/bin/aws-cli.sh
[vsc]: https://code.visualstudio.com
[vsext]: https://github.com/Grayson/aws-service-setup/blob/main/.vscode/extensions.json

# Next Steps

I'm currently poking and prodding a simple [CloudFormation][cf]-based setup.
We'll begin very simply with firing up an EC2 instance and then growing out from
there.  We'll make a lot of changes (and likely ditch the EC2 instance for AWS
Lambdas) along the way, but we'll start with basic concepts and build from
there.

[cf]: https://aws.amazon.com/cloudformation/
