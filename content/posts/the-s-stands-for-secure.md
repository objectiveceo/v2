---
date: 2021-02-05 07:11:00
slug: the-s-stands-for-secure
title: "The S Stands for Secure"
summary: |
  You may now connect to http://objectiveceo.com.
  This article explains some of the technical details
  with a step-by-step guide explanation of how I set it up.
---
I'm not one of those HTTPS Everywhere people, but I do appreciate having that option available for users that want it as well as available for when I'm ready to implement more admin features for this website.  Due to some interesting wrinkles in the configuration (which I might discuss more in the future), I had to jump through some hoops to make it happen.

Fortunately, the modern means of setting up SSL certificates is a lot easier than it used to be.  It is a lot cheaper as well.  If you use a platform as a service provider like Azure or AWS for load balancing, they can even auto-configure the certs for you.  However, I'm doing a much more "self-hosted" style of setup and had to do some manual work to get it set up.  This post should explain the bits and pieces of the process of setting it up.

I should mention right up front that I made ample use of the information in [this guide][guide].  I'm very grateful for the prior art that I could read, learn from, and even steal pieces.

# The basic setup and wrinkles

[Objective CEO] is hosted on a [Linode](http://linode.com) server.  I've decided on a deployment pattern that utilizes Docker images to allow a CI/CD process that covers two primary needs.  I want to readily be able to rollback to earlier versions of the website when I find bugs in the production version *and* I want to be able to debug the production-ready deployment locally when necessary.

I also have an [NGINX](https://www.nginx.com) gateway configured in front of my application code.  For reasons of ease and utility, NGINX is running inside of a Docker container.  This allows me a few affordances like being able to version my configuration changes and switch between them easily as well as abstract a good portion of my setup from the actual hardware.

"certbot" would let me use Linode's DNS services to automate the process, but I don't use Linode for my DNS registration.  I just wanted to mention that before there was any confusion.

The wrinkle today comes from interactions with "certbot".  I've chosen to acquire my SSL certificates from [Let's Encrypt](https://letsencrypt.org).  Let's Encrypt strongly encourages the use of certbot ([link to instructions](https://certbot.eff.org/lets-encrypt/ubuntubionic-nginx)).  "certbot" comes with some auto-configuration tools that *can* be very handy.  Unfortunately, due to the decision to run NGINX in a Docker container, we've disabled certbot's ability to everything for us.

Since I was (a) stubborn and (b) interested in learning more around this process, I worked through the issues and have a semi-bespoke certificate setup.

## Ingredients list

First things first, you need to accumulate the handful of items that you need.

* [NGINX running in Docker](https://hub.docker.com/_/nginx) - I'm currently using "nginx/alpine"
* A valid NGINX conf file - Here's the [objectiveceo.com configuration](https://github.com/objectiveceo/coordinator/blob/bc59ffe2a4156e98967811e071373eb18ebcb3c3/nginx/objectiveceo.conf) *prior* to our SSL changes
* "certbot" - Follow the [instructions for your platform](https://certbot.eff.org/instructions)

There's a whole learning curve around using NGINX.  This won't go into too many of those details, so there's an assumption that you will have some familiarity or can fill in the gaps.  There are also concepts here that are transferrable to other gateways (like Apache).  I will try to explain everything conceptually so that parts of this may be applied to other systems.

# The ACME Challenge

Let's explain a little bit about how Let's Encrypt works.

There's an essential need to establish trust between Let's Encrypt and objectiveceo.com.  LE wants to make sure that I actually own the domain that I want to encrypt.  This seems entirely reasonable.

LE specifies a handful of ways to do this.  We can assert that we own the DNS entry if our DNS provider is able to work with LE.  We can also assert that we own that DNS entry if it resolves to the appropriate address.  In order for it to do that, we'll need to negotiate a data exchange that lets LE "put" information on our server and then verify that it gets it back when querying for it.  This is basically the approach used by the [HTTP-01 Challenge](https://letsencrypt.org/docs/challenge-types/#http-01-challenge).

For clarity, Let's Encrypt doesn't actually need access to your server, it just needs to check that a request to your server resolves to (a) something that it can verify but (b) something that can't be predicted.

## Setting up for the challenge

First, we need to know that the "certbot" [command line options][certbot_userguide] includes the "--standalone" option.  This essentially allows "certbot" to act as its own server.  Now, that's only half of the equation.  The default documented port for "certbot" is 80.  NGINX is already running on 80.  So I need to specify a different port when running "certbox" as a standalone server.  Since it's arbitrary and most dev servers run "8000", I chose "8443", a combination of the fallback dev port and the HTTP default port.  I encoded that information in a [shell script](https://github.com/objectiveceo/devops/blob/main/host-bin/certbot-setup.sh#L4-L5).

With that done, we're part of the way to accepting ACME challenges.  The other part is that Let's Encrypt doesn't know about our "8443" port.  It doesn't know how to reach the "certbot" standalone server.  That's not a big deal, we'll just add a [block to our NGINX configuration](https://github.com/objectiveceo/coordinator/commit/26f658b6267cd7dff760650cf12c3a6817bd0cbb#diff-368c5721ce2622d7058edf46e4b7da9ac570e17e0097959fc88b9e83569aad38) that forwards that along.  Note that if you're on Linux, you'll need to make some special changes for the URL that we're forwarding to (read the ["Note" paragraph](https://github.com/objectiveceo/coordinator/tree/main/nginx#setup) and c.f. [this line of my script](https://github.com/objectiveceo/devops/blob/main/host-bin/rebuildNginx.sh#L10)).

With this done, "certbot" can community with the Let's Encrypt service, communicate our DNS entry to them, run a standalone server that's ready to verify information, and our NGINX configuration will forward requests to that server.  Our next step is to actually [run "certbot"](https://github.com/objectiveceo/devops/blob/efc52351e3d40ac564023eb4fa16275c215fe342/host-bin/certbot-setup.sh) and fetch our certs.

# A short diveration on DH Parameters

I was following the [guide][guide] that I mentioned earlier.  I saw that there was a recommendation of configuration Diffie-Hellman Parameters.  Here, I want to admit a certain ignorance: I have no idea if this is necessary.

The Let's Encrypt data comes with some parameters.  I didn't verify them, but I assume that they're ready for use.  I followed the guide... kinda.

Rather than burn the minutes of CPU time on my rented server, I went ahead and ran the command on my MacBook Pro.  I then used "scp" to copy it to my server and installed it into a folder that's injected into my NGINX Docker image as a volume.  There's nothing really interesting here except that I copied my "dhparam.pem" file into the "~/objectiveceo/ssl/" directory that's [used as a volume](https://github.com/objectiveceo/devops/blob/efc52351e3d40ac564023eb4fa16275c215fe342/host-bin/rebuildNginx.sh#L8) and [referenced in the conf file](https://github.com/objectiveceo/coordinator/commit/6ffcc4076bc7fd7ff1d869120926286838e375c1#diff-368c5721ce2622d7058edf46e4b7da9ac570e17e0097959fc88b9e83569aad38R12).

# Using Let's Encrypt SSL certs

First, let's address a certain concern about how "certbot" stores the certs: your user may not have access to them.

You might solve this using user groups and access rights based on group permissions.  This is likely a preferred way, but I took the quick method and just used "sudo chmod 755 /etc/letsencrypt".  This might be a security concern and I should evaluate other means, but it let me access them in my Docker image as a volume.

Now that I had my certs ready, I just had to update my NGINX configuration and Docker containers.  I stole the [NGINX conf file changes](https://github.com/objectiveceo/coordinator/commit/6ffcc4076bc7fd7ff1d869120926286838e375c1#diff-368c5721ce2622d7058edf46e4b7da9ac570e17e0097959fc88b9e83569aad38R7-R14) from the [guide][].  Notably, objectiveceo.com does not redirect you to HTTPS if you come in as HTTP.  In the future, there may be some sub-directories that would require that, but I don't have a compelling reason to force it at this time.

I just needed to get the certs into the Docker image.  That was easy enough by just [adding another volume flag](https://github.com/objectiveceo/devops/blob/efc52351e3d40ac564023eb4fa16275c215fe342/host-bin/rebuildNginx.sh#L9) to the container creation script.  You'll want to reference the root letsecncrypt directory.  The "live" folder inside of it merely contains symlinks to an "archive" folder.  I suppose you could expose multiple directories to the Docker container, but you should be aware that "certbot" generously uses symlinking and that you may not be exposing actual files to your container if you try to be precise, just references to files that the container won't know anything about.

I nearly forgot: I also had to [expose the default SSL port (443)](https://github.com/objectiveceo/devops/blob/efc52351e3d40ac564023eb4fa16275c215fe342/host-bin/rebuildNginx.sh#L7) on my Docker contaienr.

## Now with &#x1F512;

All in all, the process to set up HTTPS was fairly straight forward.  There was some learning around using "certbot" in standalone mode as well as how it organized the certs once it was all said and done.  The rest of the work was intuiting how to leverage the existing NGINX gateway to expose the right pieces to the world so that "certbot" can do its thing.  The crucial parts of the configuration and process was cribbed directly from the other [guide][] that I found.  I have great appreciation that it was published and available to me.

And with this done, you can add that crucial "s" to the URL and start reading "https://objectiveceo.com" with that lovely little padlock next to the URL.


[guide]: https://dev.to/joelaberger/no-magic-letsencrypt-certbot-and-nginx-configuration-recipe-3a97
[certbot_userguide]: https://certbot.eff.org/docs/using.html#certbot-command-line-options
[certbot_install]: https://certbot.eff.org/lets-encrypt/ubuntuxenial-nginx.html
