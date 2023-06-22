---
title: "Introducing 1RM, a PWA journey"
date: 2023-06-22T10:42:14-04:00
draft: false
summary: |
  I released a new toy application yesterday.  In this post, I'll go through
  what I was exploring and what I learned in releasing a progressive web app.
---

* [App](https://grayson.github.io/1rm/)
* [Source](https://github.com/Grayson/1rm)

I got a notion earlier this week that I really wanted to ship something.
Shipping is a skill in tech and I wanted to get something out into the world.
This bug bites me from
[time](https://github.com/Grayson/code-clone-tool/releases/tag/1.0.0) to
[time](https://grayson.github.io/peasant-binary/).

I wanted to make a small mobile application.  However, going through the app
stores makes shipping quickly difficult, especially for an initial release.  I
decided that it may make sense to create a [progressive web
app](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps).  I'm
not the biggest fan of PWAs, but it felt like it would help me (a) build
something I could see on my phone and (b) I could ship it quickly.

At this point, I thought I'd see what the ecosystem for web technologies looked
like.  I'll have more opinions on this later.

I do powerlifting as a hobby, so it's not uncommon for me to be thinking about
how to progress my lifts and what my theoretical limits are.  The idea to create
a one rep max estimator popped into my head.  There are other estimators online,
but they are designed for the web.  There are also estimators for the phone, but
they often come with in-app purchases or other features that I didn't need.  In
any case, the algorithms for estimators are readily defined on
[Wikipedia](https://en.wikipedia.org/wiki/One-repetition_maximum) and wouldn't
require any other services running to support it.  It was small, well-defined,
and self-contained.  It was perfect to knocking this out quickly.

I don't like creating icons, so I used [DiffusionBee](https://diffusionbee.com)
to generate one for me.  It's not very good, but it's also not *bad*.  "Good
enough" was appropriate for this project, though I strongly advocate for hiring
and paying artists for quality art.  This project didn't require more than the
bare minimum and using generated art saved me a bit of time from drawing some
circles in [Acorn](https://flyingmeat.com/acorn/).

And with that, I had all of the things I needed to put together
[1RM](https://grayson.github.io/1rm/).  You can open it in Safari on iOS and
add it to your home screen.  I don't know why you would unless you're also a
strength athlete like me, but it's there!

***

## Technical details (or what PWAs lack)

Once I had decided to create a PWA, I decided to set certain limitations on
myself.  First, I wouldn't use any UI framework.  Second, I wouldn't engage in
the heinous mess that is the Javascript ecosystem.

In my experience, Javascript-based apps (both server and client) often find
themselves in a bit of a mess in terms of managing compilers, transpilers,
bundlers, and all kinds of other tools.  I wasn't about to do any of that for
this project.  Those are additional dependencies to maintain.  I also find most
of that configuration frustrating and headache-inducing.

I do, however, like [Typescript](https://www.typescriptlang.org) and decided
that I'd use `tsc` to help build my app.  This wound up being a bit of a help
and a hinderance.

I found that browsers now mostly support
[modules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules).
It felt like I was *pretty* close to avoiding any kind of bundler.  Bundlers
work by taking all of those `import` statements and concatenating them into one
file.  They have other features (such as "tree-shaking") that may be useful on
large or shared codebases.  I didn't need them.  I also wasn't interested in
obfuscating or minimizing.  Since Typescript could produce modules, I thought my
tooling concerns were solved.

Unfortunately, Typescript takes an *opinionated* approach to modules.  Whenever
it meets an `import <name> from '<module>'` statement, it simply... leaves it.
The browser, however, also chooses to do the simple thing and just attempts to
pull modules based on the name provided to them.  So if you have `foo.ts` and an
import that says `import * from 'foo'`, then, eventually, your browser will ask
for the file called "foo".  Which doesn't exist.

I decided to [hack around
this](https://github.com/Grayson/1rm/blob/eea87474e626c124d6c09eb18ab50f2677521dd4/Makefile#L5-L6)
and munge the built JS artifacts.  There may be a better way around this, but
this was a small, quick app that I just wanted to get out the door quickly.
This is good enough for today.

You might notice that I'm using a Makefile for this.  One might expect a
[`package.json`
file](https://docs.npmjs.com/cli/v9/configuring-npm/package-json).  However, I'm
explicitly trying to avoid the [Node ecosystem](https://nodejs.org/en).  I don't
hold any opinion here, just that the goals of this specific project were to
simplify the app as much as possible.  Rather than install Node just to install
Typescript and then create a package.json file to use it, I'd just install
Typescript and ignore everything else.  I already had `make` installed and,
frankly, I find that I'm using `make` more and more lately.

One of the great things about creating a PWA is how easy it is to ship.  With
Github Pages, all I need to do is [create my dist folder][1], [upload the
artifact][2], and then create a [deployment][3].  Just like that, every push to
`main` results in a new version of my app going live.

[1]:
    https://github.com/Grayson/1rm/blob/eea87474e626c124d6c09eb18ab50f2677521dd4/.github/workflows/deploy.yml#L14-L15
[2]:
    https://github.com/Grayson/1rm/blob/eea87474e626c124d6c09eb18ab50f2677521dd4/.github/workflows/deploy.yml#L16-L17C25
[3]:
    https://github.com/Grayson/1rm/blob/eea87474e626c124d6c09eb18ab50f2677521dd4/.github/workflows/deploy.yml#L29-L32

I can't say enough how making shipping easily improves the development
experience.  Having a strong CD phase of your CI/CD pipeline makes everything
feel so much better.  Shipping becomes addictive.  You can make small changes
and get them live immediately.  So you start shipping more small changes.  And
then the app comes together quickly because the cycle of iteration speeds up.
That "just one more thing" before I stop for another cup of coffee often meant
that I'd work straight through for a few hours and lose time.  That kind of flow
makes me very, very happy.

One thing that didn't make me happy was the web-based UI that you get out of the
box.  The first iterations of my PWA may have been for mobile devices, but it
certainly didn't look like a mobile app.

For sure, if I had chosen to use a UI tookit, this wouldn't have been a
headache.  But those UI toolkits are often (a) very large, (b) very opinionated
in how to build an app, and (c) require all kinds of additional tooling (often
including their own CLI!).  I certainly didn't want to go through the headache
of configuring them, Typescript, a bundler, et al.

So I did something that I probably shouldn't have done and just used CSS to
re-style everything.  Some things were fairly simple, such as setting background
colors and styling the table views.  However, there were some things that I had
to think creatively about.

Let me say now that I don't do a lot of front end web work.  I don't do a lot of
front end work anywhere at this point in my career.  Usually, I'm creating,
tweaking, reviewing, or implementing the architecture and systems for large
applications.  It's been *years* since I did significant work in CSS.  I might
have made this harder on myself than necessary, but it was *fun* to figure it
all out.

For instance, there's no iOS-style
[Switch](https://developer.apple.com/documentation/uikit/uiswitch) control.
There *were* HTML radio buttons.  Neither felt quite right for the lbs/kg
selector, but the switch felt *more* right.  I used an HTML checkbox and labels
and then used some CSS selectors to make something that felt closer to the
switch.  It's not perfect and doesn't feel native.  But it's a lot better than
radio buttons.  Again "good enough" is just right for this project.

I used the tricks that I learned implementing that Switch for the help button.
I wanted a modal popup, but didn't want to have to put it into the Typescript
layer.  That felt like a purely UI issue that I could figure out in HTML and
CSS.  It's still not perfect, but it's not an *awful* popup.  Again, just right
for this project.

In the end, I have a few summaries of what I learned/experienced in creating
this project:

* The Javascript ecosystem is still highly complex; configuring and managing
  project settings is almost its own technical skillset.  This is a dysfunction.
* PWAs are... fine.  The main advantages may be in shipping for all platforms
  simultaneously *and* working around the App Stores.  However, there's a huge
  cost to make things feel native, either in implementing it yourself or
  engaging with the above ecosystem complexity.
* Automating shipping to production creates a virtuous iteration loop that makes
  it easy and pleasurable to get into flow.
* Browser technologies have come a long way to bridging the gaps that bundlers
  and other tools were solving, but the experience is still lacking and requires
  fixes.
* I love shipping software.

I can't recommend creating PWAs for significant applications.  If I were to
advise someone who wanted to build their business around mobile apps or have
mobile apps that directly supported their main business goals, there are other
technologies that would serve them and their teams better.  PWAs perform best
when immediacy of shipping is the primary goal.  However, once one assumes the
cost of shipping to the stores, there are other options (even cross-platform
ones) that reduce complexity and make apps feel more native.

For toy apps or anciliary software, PWAs are much more compelling.  However,
there's a significant tradeoff.  At a certain level of complexity, apps may be
better served by other technologies.  By the time you've started to include
additional tooling and configuration to make those more native experiences, it
may be time to evaluate priorities and options.
