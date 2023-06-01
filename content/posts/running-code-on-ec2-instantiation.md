---
date: 2022-01-31 06:32:32
slug: running-code-on-ec2-instantiation
title: "Running Code on EC2 Instantiation"
summary: |
  Following from the [last post](./basic-ec2-instance), we're going to
  demonstrate how to automatically start some software when the instance
  is created.
---
In our [last post](./basic-ec2-instance), we looked at the basic setup for 
creating an EC2 instance using CloudFormation.  That was a great first step,
but didn't really do much of anything.  We have some compute resources ready
and waiting, but mostly just *existing* out in the cloud, waiting for us to 
connect via SSH and tell it what to do.

While that's amazing (seriously, requisitioning a new computing resource in mere
seconds is a modern technical miracle), having to perform additional, manual
setup to make use of those resources is non-ideal.  We'd want our servers to be
instantiated and *automatically provisioned* to do what we want to do.

We have a couple of choices.  First, because we have the ability to "ssh" into
the instance, we could just write a script that creates the AWS stack, waits and
polls until the stack has been completely created, and then connect via "ssh" to
execute commands and install software (and, honestly, this isn't an *awful* 
idea).  Alternatively, we could just have all of that done by CloudFormation
and cut out the unnecessary moving parts.

CloudFormation allows us to specify a [UserData][userdata] block that will be
executed automatically after the server has been instantiated.  This allows us
to write scripts that provision the server with all of the software that we
need for it to be useful.

Note that the script needs to be [base64-encoded][b64] (ignore the "!Sub" for
now).  I'm also executing a [Bash script][bash].  The distro of Ubuntu that I'm
using also comes with "python3" (I'm not sure if that's by default or if it's
installed by Amazon to drive the other tools that Amazon uses when setting up
these instances), so I could have written a Python script.  Speaking of Python,
I'm using the built-in HTTP server as a [simple demonstration][demo] of running
software at launch.

If you wanted robust software that will automatically restart on failure or have
other behaviors, you will want to look into your distro's system services APIs.

Since I'm running an HTTP server on the instance, I'd probably like to actually
*see* it from the outside world.  In order to do that, I'll need to update the
security group and [expose port 80][port] (the default HTTP port).  With that
exposed, I can look up my IP address from the stack Outputs field, navigate to
that IP address in my web browser, and see my "hello, world!" message!

If you've left your AWS stack running since our last post, you might need to
[bring it down][down] and recreate it in order to have your UserData block
executed.

You might also note that I've set up a very simple [Makefile][] that
provides some convenient shortcuts to common commands.  This makes it easy to
create a stack using "make up" and then bring it down later with "make down".

[userdata]: https://github.com/Grayson/aws-service-setup/commit/aa2f2cb9af28408f7721ed5bc6897199199ece95
[b64]: https://github.com/Grayson/aws-service-setup/commit/aa2f2cb9af28408f7721ed5bc6897199199ece95#diff-1363ef5ce8886100842332c97163aad7934237e1fe49b5d40422b45fdc30f38eR13
[bash]: https://github.com/Grayson/aws-service-setup/commit/aa2f2cb9af28408f7721ed5bc6897199199ece95#diff-1363ef5ce8886100842332c97163aad7934237e1fe49b5d40422b45fdc30f38eR14
[demo]: https://github.com/Grayson/aws-service-setup/commit/aa2f2cb9af28408f7721ed5bc6897199199ece95#diff-1363ef5ce8886100842332c97163aad7934237e1fe49b5d40422b45fdc30f38eR17
[port]: https://github.com/Grayson/aws-service-setup/commit/9cfb441f4b738de10069ef946dc2123320118d56
[down]: https://github.com/Grayson/aws-service-setup/blob/cf99d8b1fa4f8f3cba403a943a9fbf77a63bcfae/Makefile#L8
[Makefile]: https://github.com/Grayson/aws-service-setup/blob/cf99d8b1fa4f8f3cba403a943a9fbf77a63bcfae/Makefile#L8
