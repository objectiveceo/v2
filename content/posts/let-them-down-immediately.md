---
date: 2021-05-02 20:54:31
slug: let-them-down-immediately
title: "Let Them Down Immediately"
summary: |
  One of the hardest things about managing talented technical people 
  is telling them "no" when they have a high level of enthusiasm.
  Here is why it's necessary and one technique for doing so.
---
I had the wonderful and awful experience of working with a talented senior web engineer on an exceptionally modest web application last week.  It was wonderful in the sense that this individual was gasoline to our fire.  He was able to drop in and level up our project in a week what I had hoped we could grow to in a month or more.  However, it was awful in that he brought a career's worth of experience and opinions that were expressed without understanding or meeting the needs of the project.  While I typically value thoughts that push against mine, we burnt through several hours gaining alignment and pushing back against changes in scope rather than solving problems.

Here's some context: I'm managing a modest [middleware BFF](https://samnewman.io/patterns/architectural/bff/) for a couple of mobile apps.  I have two talented mobile developers who are growing into backend work as well to work on this service.  We need five new endpoints spun up with some light data storage and caching ready to go in six weeks.  Due to the time constraints and relative lack of experience writing web services, we made *every* decision with a bias towards simplicity and shipping immediately.

This was a double-edged sword.  We could keep things super-simple and meet the needs of the project within the time frame while also allowing for growth and knowledge acquisition in our staff.  However, the robustness of the application and the opportunities that we create for ourselves are limited by our ambitions.

We had the opportunity to add a senior engineer for a team for a week.  He was between projects and willing to aid our rag tag operation.  He could dive in and answer a lot of the questions that we had been actively deferring.  We were prepared to accept those answers.  However, we weren't prepared to engage in the scope creep that came with some of them.

# "We should use X"

One of the risks of bringing someone in mid-project is that they lack the experience of the decisions that led to the current moment in time.  They often view the project from the lens of their own knowledge and not through the lens of history.  There are times when this can be a very good thing.  Fresh eyes can reveal a lot of opportunities in a process.  However, there are times when it means having well-worn converstaions all over again.

In this case, the most common conversation was around proper authentication of users.  This was a bespoke situation for a specific flow and need.  However, my senior engineer recommended AWS Cognito as an authentication pipeline.  Repeatedly.  For various technical and practical reasons, this wouldn't be practical.  But my senior engineer brought experience of Cognito with him.  That felt like the logical solution to any user authentication problem to him.

Then there were discussions around branching strategies and data storage and... and... and...

# "This is what we're doing now..."

I have a friend that doesn't sit well with indecision.  He was great and cutting through it and having an opinion.  If you've ever had a group of friends that couldn't decide where to go for dinner, imagine having one friend that would stop everything and just say "This is what we're doing now..." and shortcircuiting that whole process.

As a leader, it's often your job to cut through the indecision and provide clarity for the team.  That clarity sometimes comes at a cost to enthusiasm.

There were multiple times when I had to pull my senior engineer into a side conversation or a 1:1 meeting and explain the decisions we were making.  Frequently, that engineer made an argument for their preference.  The argument was always well reasoned and quite inviting.  However, it's my job to put everything within the appropriate context.

Our context was a team that required simplicity over completeness.  We had stakeholders that needed immediacy rather than perfection.  I needed to focus my senior engineer on solving the problems with the greatest impact rather than the problems that he identified.

This is where you come in as a leader.  You carry the context and vision for a project.  You may be able to speak the entire history of a project or even just a partial history fo the immdiate problem that you're trying to solve.  But you should not let decisions and guidance wallow in the misery of indecision.

My senior engineer was disappointed with most of the decisions that I made in the short time he was on the project.  He saw a whole plethora of risks that we could mitigate with more code or more services or more commitments.  As the project's technical lead, I had to manage timeline and scope as well as technical debt and risk.  In the end, though, I believe that he was happy with his contributions and will leave the team with a great satisfaction in the work that was done.

That whole satisfaction is bound up in one very specific thing: he is able to look back on the week and have a specific understanding of how much he contribute to the project.  By making decisions and narrowing his focus so severely, we managed to get concrete work done with measurable contributions towards our ultimate goal.  That senior engineer may grumble that we're not building out the authentication framework that he had in his mind, but he can point to a week where we substantively contributed to a project that he may not have even known existed the week prior.

There may be times when you need to "pull rank."  If that happens, you can seed the conversation by explaining that there's a whole history and system to the work that you're doing.  If the individual has limited visibility into that system, that may work.  However, you must acknowledge that your decisions may negatively impact the enthusiasm that someone brings to a project.

That is okay if you manage it well.

You have the authority as a leader on a project to say "this is what we're doing now."  But you can only do so with the trust of your team.  If you haven't built that trust, then you should be doing the gruntwork of demonstrating how the fulfillment of your immediate vision builds towards the completion of the project.

I killed my senior engineer's plans multiple times this week.  But I also readily pointed out how much he grew the project with every commit and every bit of technical leadership that he brought.  In the end, he contributed greatly and even had a chance to learn some new information and skills in the brief span that he was on the team due to the focus that he was given.

Some projects require direction more than enthusiasm.  Most people respond well to recognizing the impact of their contributions.  You can recognize the good thoughts of an individual but cut straight through to the action phase with a "this is what we're doing now" and articulating the expective transformative effects of their actions.  You can say, "that's a good idea, but we're not doing that right now" and follow with the next thing that needs to get done.  Some individuals may balk, but your job as a leader is to set the priority.

If you can do that correctly more often than not and adequately recognize the contributions that people are making *during* the process, you'll find it easier to build trust and buy-in when you have to make similar decisions in the future.

Even if it's for a very short period of time, strong decision-making and recognition skills can make a deep impact for both projects and individuals.
