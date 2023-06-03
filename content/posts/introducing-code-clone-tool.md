---
title: "Introducing Code Clone Tool"
date: 2023-06-03T12:48:10-04:00
draft: false
summary: |
  I created `code-clone-tool` so that I'd have a convenient tool for when when
  I working in orgs with lots of repositories.  I've been using it personally
  for a year but wanted to announce that it's now promoted to 1.0!
---

I've worked in a lot of orgs that create a lot of code repositories.  I've come
across the same need in every one: there are a lot of repos that I'm working in
concurrently and need to have some way of keeping my local copies up to date.
Since I'm a software engineer, I don't do it manually.  I write a small script
or tool to help me do it.  Over the course of my career, I've probably written
some variation of that script four or five times by now.  Each one solved a
specific problem for that role, but they all shared a common core.

Last year, I was starting in a new organization and found myself facing this
problem again.  They had an open source repository of over 200 projects.  I
wanted to cache all of that code locally so that I could easily work with them.
I wasn't planning on updating all 200.  Rather, I wanted to put them locally so
that I could get more insight into them.  I wanted to write scripts that could
aggregate data or give me some insight into what we actually had in our open
source community.  I wasn't about to do that manually, so I found that I was,
once again, solving the familiar problem: I want to clone multiple repos and
keep them up to date.

That's why I created [code-clone-tool][cct].

[cct]: https://github.com/Grayson/code-clone-tool

`code-clone-tool` starts with a very simple premise: rather than create a list
of all of the potential repos to follow, I could just fetch the relevant data
from GitHub.  GitHub has the opportunity for teams to group their code via
Organizations. For individuals, you can get a list of the repos that you own or
have forked.   If the code is already organized in GitHub, then all I need to do
is get that data and iterate through it.

And, with that, I put together an MVP about a year ago.  It did exactly what I 
needed.  New repositories were cloned and existing ones were updated with a `git
pull`.  I didn't have to maintain any lists or additional configuration since
everything else was stored in GitHub.  It made it easy for me to stay up to date
with my team across all of our projects and changes.

I quickly added a feature to mirror our repos just to make it easy to have a
backup.  Not that I expect anything would happen to GitHub, but having the repos
mirrored makes it easier to move code around and keep all of the branches and
other data that aren't stored with a simple clone.

Apart from that, `code-clone-tool` was "done" for my purposes.  There was more
that I thought about doing, but it served my needs.  I let it linger in my "code
graveyard" on GitHub.  Then, this week, I had some time to work on something
that I always wanted to do.

While `code-clone-tool` is competent at its task, the interface was very basic.
Some simple command-line flags and a file to save configuration between runs and
that's about it.  I had learned about [Bubble Tea][bt] and thought I'd make a
nicer interfaces for it.  I have a fondness for pretty TUIs and figured I now
had the opportunity to learn a new UI paradigm.

[bt]: https://github.com/charmbracelet/bubbletea

I have some thoughts about Bubble Tea, but the general implementation was very
easy and enabled some of the patterns that I like to use when I design
applications.  I'll readily recommend it for anyone else looking to build a TUI
in Go.

My last concern was about distribution.  My initial beta versions were released
with [Goreleaser](https://goreleaser.com).  That's a fantastic tool that greatly
simplifies getting my code live.  However, while I did see that it had 
[Homebrew](https://brew.sh) support, I never bothered to add it.  I figure if
I'm going to go ahead with a 1.0 release of the app, I should make it easier to
download and install.  Requiring users to install `go` just to install my little
tool feels rather user-hostile, so I didn't want to release my 1.0 version
without also making it easier for users to install.

So now it's "done."  Well, what software is really done?  It's at least at a
stopping point where I'm comfortable welcoming other people to use it.  I have a
lot of small things that I'd like to add or little additions that may make it
better.  Those will go in when I get some time or have an urge.  For now,
though, it's good enough.  I'm using and I hope someone else gets some utility
out of it, too.
