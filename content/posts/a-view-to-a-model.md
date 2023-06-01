---
date: 2021-09-26 12:33:30
slug: a-view-to-a-model
title: "A View to a Model"
summary: |
  A brief explanation of the importance of the "view model" pattern.
---
Earlier this week, I was working with an engineer on adding some new views to a C#-based ASP.Net app.  The prior engineers didn't follow the MVVM pattern, so I took this as an opportunity to introduce it to the codebase.  First, though, I had to introduce it to my engineer.  Here's a brief overview of what we were working on and the different layers that we're working in.

## DTOs

Our primary task in our stack is to connect to an external data source.  We don't own that service and we communicate with it over standard HTTP requests.  Conceptually, we (a) get back a blob of bytes that is (b) in the JSON format that we'll (c) de-serialize into (d) an in-memory object.

It's important to make a distinction at the B phase above.  JSON is a common data format for the modern web, but we could just as readily have received XML, another text-based format, or even some other compressed or optimized non-text format (such as protobuf).  Part C would change the means of deserialization, but parts A and D are typically unchanged.

The in-memory object at part D is commonly called a "data transfer object" or DTO.  DTOs are the result of receiving something from outside of your application's memory space.  It's important to acknowledge that the in-memory object at this point in the application is a reflection of the *external domain space*.

It also reflects the limitations of the originating format.  For example, JSON can't have 64-bit integers due to limitations of Javascript.  Therefore, numbers that need that kind of precision may be encoded as strings or broken into two 32-bit integers.  

While you can write code to coerce values of DTOs into the values that's appropriate for your domain, you shouldn't.  This makes working with third party services more difficult and introduces a maintenance task.  You'll need to do the appropriate coercions eventually, so you can just defer them until the...

## DO

The "domain object" is often called a DO or "model."  This is something that your application cares about and optimizes values for your domain.  The DTO is all about the *transfer* of data but the DO is about the correct represention for your uses.

The most common task when transfering data from a DTO to a DO is to simply map values.  A property of a DTO often has a parallel property on a DO.  That's why you're fetching that information, after all.

Another common task is to *throw away* information.  In some scenarios, an external service may be generalized to communicate with multiple clients.  As such, it likely has a lot more data than is actually necessary for your use case.  If you've used a fully-specified DTO, you may choose to just ignore certain properties that don't match your domain's needs.

A domain object may also collect data in ways that's most appropriate to the domain's use case.  You might have some data optimized for size for the purposes of transfer in the DTO but would be better suited for your use case by normalizing for cache-access.

The purpose of the DO is not to repeat the DTO but rather to model the actual needs of your domain.

## VM

Often, your domain needs to display data to the user.  There are many patterns to achieve this goal, but one common means is the MVVM pattern.  This stands for Model-View-View Model.  There are a lot of other blog posts and books written about MVVM, so I won't repeat it here.

For our purposes this week, we needed to coerce data from our third party service and display it to the user.  So we took the DTO, mapped it to a DO, and then to a view model (VM).  At this point, my engineer asked why we didn't just use to the DO.

Well, simply put, not everything is ready to be displayed to the user.  Many strings could have been shown in text UI widgets, but we had a lot of other properties that needed to be coerced into something ready for user visibility.  We often look at a number like "42" and think that's screen-ready, but we're looking at a *representation* of that number.  It's just bits to the computer.  Someone has to tell the computer what those bits should look like.

The data in our DO isn't ready for the UI.  Frequently, this is abstracted away from us entirely.  We have a number (64-bits of 1s and 0s) and we have a UI widget.  When we set a property of the UI widget to that number, we see it on screen and don't think about it any more.  But *something* had to decide what that number looked like.

Consider money.  Four dollars and seventy-five cents could be represented as a decimal number "4.33333333...".  Something decides to truncate those 3s.  Also, it needs the "$" to show that it's US currency.  So that decimal property can be *formatted* into a string representation that's appropriate to put into a UI: "$4.33".

Or consider a star rating.  You'd want to keep the property as a number because it'd be easier for the CPU to sort.  But you may not want to show that number.  The number might also be abstracted.  You could have a out-of-five-star system but the scale is 0-100 behind the scenes.  That way, a score of "82" might be rounded down and displayed as &starf;&starf;&starf;&starf;&star;.

The view model is the layer where you coerce the domain data into something that's ready for the user to see.

## Do we really need all of these?

At this point, we'd pulled back enough to realize all of the work that was going into getting the data from the backing service and putting it on screen.  The next question that invariably comes up is whether all of this is necessary.  Afterall, couldn't you just go DTO->VM or maybe DTO->view (since so many UI widgets abstract coercing data for us)?

Well, yes.  You could probably do a lot of things.  But this abstraction is useful practically.

Our third party service could change the requirements of their DTO.  It could change the format, or names of properties, or even provide a completely different representation.  Since the DTO is a formalized object and separate corner of our application, we've isolated those concerns from the rest of the code.  We can readily update our DTO and mapper but the DO and VM (usually) don't need to change.

If we decided to change the UI representation of data, we can update the VM and DO->VM mapper, but the DTO and DO don't need to change.  Alternatively, if we use the same DO in multiple places and need to update it because our domain needs change, we can make targetted adjustments to the DO and mappers without having to worry about our networking layers or the UI.

## Zooming in to appreciate all of the invisible work

There was a brief question of performance.  In the vast majority of use cases, having dedicated DTO, DO, and VM objects won't affect an application's performance.  Unless you're explicitly copying this data around multiple times, deserializing an object will likely be much more expensive than passing it through a few layers of abstraction.  You'll likely need to do all of that mapping, anyway, so formally doing it in separated layers of concern is appropriate.

That last bit was important.  As we looked into the prior code, we found that nearly all of the work was being done anyway.  In some places, the DTO was being passed directly into the UI layer where it was being automatically converted into UI-ready values by the UI widgets.  In other places, we were mapping data into UI-ready values immediately after deserializing the DTO.  In some places, because we didn't have a formal DO object, we were actually doing a lot of work coercing the same DTO data multiple times in different areas.

As we looked, we kept finding places where separating our network requests, our domain logic, and our UI representations would have improved the design, performance, and maintainability of the codebase.  They are separate concerns.  With a bit of care, we can keep them that way.
