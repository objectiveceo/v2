---
date: 2022-01-23 09:52:11
slug: basic-ec2-instance
title: "Creating a Basic EC2 Instance"
summary: |
  A demonstration of one of the most basic CloudFormation tasks: Creating an
  EC2 instance.
---
One of the most basic tasks for web services is to just have a computer running
*somewhere* in the world.  That's a primary requirement for literally any 
computing that happens "in the cloud."  For some tasks, those computers are 
ephemeral (commonly called "serverless" because we're bad at naming things).
However, another very common task is to just have a computer running all the 
time and connected to a network (commonly called a "server").

In typical parlance, units of servers are called "instances" or "nodes."
Effectively, these are just opportunities to perform calculations (or
"compute").  That means that there has to be some ability to store data (a 
filesystem), move data into place for computation ("memory"), and the ability
to perform the calculations ("CPU").

I'm specifying these because we no longer live in a world where these terms map 
directly to physical computers.  There was a time when each instance of a server
meant that there was a physical computer *somewhere* in the world with a CPU,
memory sticks, actual hard drive.  However, nowadays, we don't have any
requirements for physical hardware.  Much more powerful hardware can allocate
resources in such a way as to emulate multiple, less powerful machines.  A 
single physical computer might be able to provide several virtual "instances."

[Amazon's EC2 service][ec2] takes advantage of this modern convenience to 
provide scales of compute resources in instantaneous time spans.  If you need
more compute capacity, you can rapidly create new instances.  This article
demonstrates an exceptionally basic means of allocating one of these resources
using [CloudFormation][cf].

[ec2]: https://aws.amazon.com/ec2/
[cf]: https://aws.amazon.com/cloudformation/

# Quick Configuration

Before you can create new objects in the AWS infrastructure, you need to 
authenticate yourself to the service.  You can do so fairly readily with the 
AWS CLI.  Here, I'll assume that you've already created your AWS account and 
have installed the AWS CLI (or will use the Docker image) as described in [my
introductory post](./aws-from-scratch).

With that installed, you can run the "configure" command (note that I'm using
a [convenience shell script][awscli] to call the Docker-based CLI tooling):

[awscli]: https://github.com/Grayson/aws-service-setup/blob/main/bin/aws-cli.sh

	➜  aws-service-setup git:(main) ✗ ./bin/aws-cli.sh configure
	AWS Access Key ID [None]: <Access Key>
	AWS Secret Access Key [None]: <Secret Key>
	Default region name [None]: us-east-1
	Default output format [None]: json

You might be wondering where you can get your access key and secret.  You can 
create a new access key from your [Security Credentials][sec] page.  Under the
"Access Keys" pane, click the "Create New Access Key" button and follow along.
You'll create a custom access key with "root" access.

[sec]: https://console.aws.amazon.com/iam/home?region=us-east-1#/security_credentials

Be warned that this gives you the ability to do anything in your account.  This
is a potential security issue if those credentials are shared or leaked to the
general public.  A much more secure approach is to use AWS IAM to create a 
custom user with limited rights.  We'll explore that approach in a future blog
post.

# Creating your Key Pair

Another pre-requisite before creating your EC2 instance is to generate an EC2
key pair.  This is a necessary means of identifying yourself to the EC2 instance
that you're creating.  AWS provides [good documentation][kp] with ways to create
a key pair in the Console or via the command line.

[kp]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html

Here, I'm creating a key pair called "my-key-pair" using the command line:

	➜  aws-service-setup git:(main) ✗ ./bin/aws-cli.sh ec2 create-key-pair --key-name my-key-pair --key-type rsa --query "KeyMaterial" --output text > my-key-pair.pem

# Creating the Instance

With our pre-requisites in place, we can now define our cloud infrastructure
using a CloudFormation template.  For our purposes, we'll use YAML since I find
it easier to read than the JSON format.

First, there's a general [preamble][].  We'll go ahead and define our first
[resource][resources], which is going to be a simple [EC2 instance][ec2].

[preamble]: https://github.com/Grayson/aws-service-setup/blob/ce9461252747455bf1a710bd5c094f330d2a0aae/template.yaml#L1-L2
[resources]: https://github.com/Grayson/aws-service-setup/blob/ce9461252747455bf1a710bd5c094f330d2a0aae/template.yaml#L3
[ec2]: https://github.com/Grayson/aws-service-setup/blob/ce9461252747455bf1a710bd5c094f330d2a0aae/template.yaml#L4-L5

We've got the *start* of something, but we haven't really given AWS enough 
information.  AWS needs to know what *size* to create the instance in terms of
compute resources.  That's easy enough to [define as a property][size].  These
map to well defined [instance types][type].  Just find the size that you need.
Sizing is its own skill, so that might take some prior knowledge of the 
application that you're creating and your intended user population.

[size]: https://github.com/Grayson/aws-service-setup/blob/ce9461252747455bf1a710bd5c094f330d2a0aae/template.yaml#L9
[type]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html

The next thing you'll need to do is specify the initial/base software set that
is loaded onto that instant.  This generally maps to a common operating system
paired with a CPU architecture expectation.  That is, you'll make a decision if
your instance will load Windows, macOS, or some flavor of Linux when it starts
up.  Sometimes, you can choose a software set that includes other applications,
like compilers or frequently used services.  This software package plus CPU
architecture combination is called an "image."

You can define the initial image for your EC2 instance by [specifying an
"imageId"][iid].  You can find these ids on the [EC2 Image Catalog][catalog].
They're the text that starts with "ami-" and has a bunch of numbers and letters
after.  The specific image used above is an Ubuntu 18 OS running on an x86 CPU.

Note that the EC2 Image Catalog is region-defined.  If you're not using
"us-east-1", you might find the Ubuntu image used has a different id.  You might
also not find certain images in your preferred region.

[iid]: https://github.com/Grayson/aws-service-setup/blob/ce9461252747455bf1a710bd5c094f330d2a0aae/template.yaml#L8
[catalog]: https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#AMICatalog:

## Actually *Accessing* the Instance

Now that we've got enough set up to specify the instance and have something
running, we're left the realization that it doesn't *do* anything.  There are
a lot of options, but let's focus on a basic need: getting access to the 
instance.

By default, the Ubuntu image that we've set up enables "ssh".  If you set up a
Windows box, you might have Remote Desktop enabled out of the box.  These are
handy technologies for logging in to your instance remotely.  Unfortunately,
it's not magic and you'll have to make a few additional changes.  Fortunately,
we've already set (nearly) everything up for success.

First, we need to specify how to identify ourselves to the instance.  AWS uses
Key Pairs for identify.  I created "my-key-pair" earlier, so we can [specify
it][kn] in our template.

[kn]: https://github.com/Grayson/aws-service-setup/blob/ce9461252747455bf1a710bd5c094f330d2a0aae/template.yaml#L7

Second, we need to open the SSH port so that we can connect to the instance.  By
default, AWS closes every port.  This is a security feature.  The default is to
keep everything closed and allow you to specify only what you need.  Well, in 
this case, we need to open the port that SSH communicates on.  That happens to 
be port 22 by default.

AWS uses the terminology of "security group" to define various rules concerning
port access (and other items).  Configuring security groups is its own thing,
but for our purposes, we can merely acknowledge that SSH operates via TCP, on
port 22, and that we'll want to allow access from any incoming IP address.
That last bit about IP addresses is encoded in what's called a CIDR block, which
is a topic for another day.  But we can [specify a security group][sg] that 
allows ssh access.  We then have to tell the template to [attach our
instance][sgid] to that security group.

[sg]: https://github.com/Grayson/aws-service-setup/blob/ce9461252747455bf1a710bd5c094f330d2a0aae/template.yaml#L12-L20
[sgid]: https://github.com/Grayson/aws-service-setup/blob/ce9461252747455bf1a710bd5c094f330d2a0aae/template.yaml#L10-L11

# Launch and Connect

Now that our template is ready, we can ask AWS to create it for us:

	➜  aws-service-setup git:(main) ✗ ./bin/aws-cli.sh cloudformation create-stack --stack-name example-stack --template-body file://template.yaml

This will create a new stack called "example-stack".  It also assumes that your
terminal's working directory is the parent directory of the template.yaml file
that we've been working on.  If not, you can specify a relative or absolute path
to the template file.

AWS will do its thing for a little bit.  You can watch the stack stages in the
AWS Console.  After a few seconds, you'll have a new instance provisioned and
running.  You can then *attempt* to connect to it.  You can get information
about your stack by using:

	➜  aws-service-setup git:(main) ✗ ./bin/aws-cli.sh cloudformation describe-stacks --stack-name example-stack

In my template, I specified a [request for the public ip address][out] for the
instance as an output.  That will show up in the description of the stack.

	...
	"Outputs": [
		{
			"OutputKey": "ExampleServerPublicIp",
			"OutputValue": "<public ip here>",
			"Description": "EC2 Public IP"
		}
	],
	...

[out]: https://github.com/Grayson/aws-service-setup/blob/ce9461252747455bf1a710bd5c094f330d2a0aae/template.yaml#L21-L24

I made an assumption that the default username for the Ubuntu image would be
"root", so I attempted to connect to it via ssh.

	➜  aws-service-setup git:(main) ✗ ssh -i ./my-key-pair.pem root@<ip address>
Please login as the user "ubuntu" rather than the user "root".
Connection to 34.204.8.196 closed.

Obviously, that was a poor assumption, so I took the suggestion and used 
"ubuntu" instead.

	➜  aws-service-setup git:(main) ✗ ssh -i ./my-key-pair.pem ubuntu@<ip address>

Success!  I was able to connect via ssh to my new EC2 Ubuntu instance running in
the AWS ecosystem.

# Shut It Down

While AWS offers exceptionally cheap compute resources at the lower end of the
need scale, it's not always free.  In order to make sure that you're not paying
for these resources, you can readily delete the stack.  You can do that via the
AWS Console or by specifying the stack by the name used when creating it (here,
"example-stack"):

	➜  aws-service-setup git:(main) ✗ ./bin/aws-cli.sh cloudformation delete-stack --stack-name example-stack

# Concluding

This was a lot of words to describe a bare 24 lines of a CloudFormation 
template, but it's all the ground work that's needed for a very basic setup.
From here, we can look into doing more interesting things like running things
in the instance automatically following a successful provisioning or connecting
to other services.  We'll explore those in future installments.
