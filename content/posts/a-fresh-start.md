---
title: "A Fresh Start"
date: 2023-05-31T20:12:48-04:00
draft: false
summary: Restarting the blog is a little stressful and a little exciting.
---

I used to have a blog from an old adventure (fromconcentratesoftware.com; don't 
bother, it doesn't resolve to anything today).  At the time, owning a blog was a
sense of identify on the indie web.

It gave me access to developers and software celebrities that I'd never get to
meet in person.  It gave me an option to engage with them in conversation.  They
could write something on their blog and I'd write something in response.  I
could send an email or they'd get a [Pingback][ping] and would see it
organically.  Sometimes, entire groups of people would join in and we'd see a
lot of discussion in generally mid- to long- form thoughtpieces written without
any expection of direct communication.

[ping]: https://en.wikipedia.org/wiki/Pingback

I learned so much from many in software development at the time.  Blogs were our
way of learning and sharing information.  Now, everything seems to be lost to
StackOverflow and other forms of chattier or less substantial communication
forms.  But there was a time when the quality of our blogs warranted attention.
We would give back to our community and create some small amount of recognition
for ourselves.  Quality was rewarded with a subscription in a newsreader.  We
took and we gave because we were a community that wanted to earn the respect of
our peers but also because we recognized how much we had learned from everyone
else and felt a desire to give back.

At the start of 2021, I had the idea that I wanted to get back into doing more
personal writing.  I wanted to restart a blog, but something happened along the
way.  Maybe it was the death of Google Reader.  Maybe it was the rise of
StackOverflow.  Maybe it was a general shift in how technical content was
consumed.  But blogs seemed to be more individual- and less community-focused.
This is to say: I didn't quite know what I was going to write about or who I was
writing to!

So I decided to just note some braindroppings of things that I've come across as
an engineering manager and technical lead.  There are a few items that discuss
managment or project planning or other things.  There are a few items that
discuss detailed technical issues.  Few of them were edited and even fewer
strongly considered.

Still, it was fun.  And it was a focusing activity.  It let me ruminate on some
ideas and thoughts and shape the by describing them.  When re-reading, there are
lots of things that I wished I'd had let sit while I refreshed my mind and took
a second pass.  Perhaps I will yet.

One of my failures, though, was going in with the hubris of a software engineer.
I was exploring Node and React and related technologies and thought I'd just
write my own blog engine.

I got something... workable.  Up and running.  It tickled my technical fancies
and used the technologies that I was infatuated with at the time.  I was doing
more Node and wanted to do server-side React (for curiosity reasons).  I wanted
to build on SQLite simply because I liked it.  I wanted my documents to be in
Markdown since, well, I've been using it since it was announced.

My ambitiion exceeded my time constraints, though.  While my initial enthusiasm
drove me to a working MVP, I simply never came back to make things better.  New
blog posts were implemented by adding entries to a SQLite database (really).  I
never added the taxonomy features that I wanted.  Nor implemented search, which
I felt blogs need.

So, today, I'm revisiting the blog and doing something better.  Well, different.
I have decided to scrap my custom blog engine and focus on my current language
du jour.  I've been enjoying Go for the last year or so and decided to move over
to [Hugo](https://gohugo.io) to generate my content.  I get to keep my Markdown
and simple, text-based websites are easy to deploy while being very fast for the
user.  It feels like the right choice for today.

I'll be iterating on a few things for the website.  Foremost, I'm using a stock
design.  It works, but I'd like something different.  I'd like to actually add
a search function.  Some of the links and images may be broken while I sort
things out.  I also need to actually add tags so that Hugo can generate that
taxonomy that I always wanted.

There'll be some changes to the site, but I also have a few things that I wanted
to drop from my head.  I feel like this is another fresh start for the blog.
Who knows, maybe I'll pull my old From Concentrate Software blog out of the
archive as a historical document.
