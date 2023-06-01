---
date: 2021-02-28 20:45:43
slug: please-stop-logging
title: "Please Stop Logging"
summary: |
  The vast majority of your "print" statements and "console.log" statements are useless.  Stop that.
---
Using "print" is one of my pet peeves.  It annoys me every time that it sneaks into a codebase.  I will block PRs just to remove "print".  I believe so whole heartedly that it is inappropriate that I challenge all of my peers to justify its use.

# The Vast Majority of Logging is Useless

The vast majority of logging statements that I've come across in my career don't mean anything.  They were put there by well-intentioned developers that were doing some debugging at some specific point in time and left to the ravages of time.  As such, they no longer represent any meaningful intention and merely waste CPU cycles.  As such, the "print(error)" statement should have *never* been committed to the commit history and should be excised.

Note: I have worked on at least one application in which there were "load bearing" print statements.  This was because of the multi-threaded nature of the application and those "print" statements slowed up one thread just long enough to avoid race conditions in other threads.  This frightened me and still haunts my dreams.

Now, it's not that these logging statements in and of themselves are useless for debugging purposes.  It's often very handy to perform "caveman debugging" and litter your code with some messages so that you can trace the values of certain variables or confirm the execution path.  It can be especially helpful when looking at multi-threaded code.  However, it's almost never helpful over the lifetime of the application and only helpful in the specific instance of debugging.

Your users aren't ever going to look at these log statements.  You won't capture meaningful information at runtime that can aid in understanding user issues.  Worse, you run the risk of logorrhea in which your application has so many statements being printed to the console that actually meaningful information is readily hidden in the constant stream of information appearing in your debugging window.

# You have Better Options

Let's be very clear here, if your first instinct in debugging is to write a "print" or "console.log" in your application, you need to learn how to debug.

Nearly every major modern programming language has a reasonably robust debugger available for it.  Some debuggers are better than others (especially those "old" debuggers like those for Java, C/C++/ObjC, and most Microsoft debuggers), but nearly every one offers some means to insert a print-like statement into your application *while it is running*.

That's the biggest strength here.  You don't need to plan your "print" statements in advanced.  You don't need to recompile your application in order to observe new values.  You can just drop in a breakpoint, configure it to log a message to the console instead of break, and keep running the application.  For many debugging tasks, you can just inspect the variables in frame to get a sense of what you need to fix and never need to think through logging statements.

Sometimes, though, you will want to preserve some information that was generated during the execution of your application.  In this case, you'll want to look into logging libraries.  These can provide a structured approach to recording information at runtime and should be preferred over other methods.  They often provide the ability to ignore low risk or informational logs, record moderately interesting information, and alert or send information to you on the high risk issues.

These options solve for two primary problems.  Debugging breakpoints are, by their nature, ephemeral.  They won't be committed to your repo and they certainly won't be executed on your user's devices or on your production servers.  Logging libraries let you configure your logs so that you can create structured data that's either automatically ignored when appropriate or available to you when necessary.

# Better Logging Leads to Better Options

Once you take control of your logging, you'll open yourself to novel means of understanding your application.  The use of "print" or other statements is useful only in the sense that it's convenience.  The cost to the CPU and application maintenance is small in the specific while potentially large in the aggregate.  The most immediate benefit is that once you change a mindset to avoid "print", you start solving for more interesting problems.

Let's say that you want more insight into the application of your application.  Once you start figuring out structured logging, you can start layer other information along with it.

Do you know what your users are actually doing with your application?  Do you have statistics that define the "golden path" that your users typically take?  If not, you can readily start to adding specialized logging statements to user interactions (often called "metrics").  From here, you can understand what will bring the most value to your users (and, with unfortunate frequency, illustrate which beloved features aren't actually used much).

Do you know the actual performance of your application in the real world?  You might have some specialized unit tests that validate and verify certain performance metrics, but how do you know how your application works in the wild?  You can start to add other specialized logging (often under the header of "APM") that traces the execution of your application and records the time to execute each execution frame.  You can then aggregate these statistics and have a data-drive approach to deciding which optimizations to make.

What will you do when an highly dangerous error occurs in production?  How will you know when it happens?  If you have a holistic logging methodology in place, you can add in a layer that fires off an alert when one of these showstopper errors occurs.  Even better, you might tie it into your CI/CD processes and automatically roll back to the last known "good" version of your application if timeliness is a concern.

# Stop Logging and Start Programming Better

 You might have gotten to here and think that I'm just ragging on common practices and really recommending some good ideas for structured logging.  I am, but don't get me confused: I don't let my programmers commit "print" statements without a very, very reason.  You should stop writing "print", or "console.log" or whatever your language provides.  You should even stop writing "echo" in your Bash scripts unless you're just providing information to the user (Bash has some nice [debugging commands](https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_02_03.html) that you might not be familiar with)!

 In all seriousness, stop treating error messages as something that just needs to be presented to the programmer.  Stop cluttering logs and wasting CPU cycles with ignored statements.  Start considering how you can use structured logging to create opportunities to actually understand your application and use your debugger to actively watch your application execution when debugging.
