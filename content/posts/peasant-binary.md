---
date: 2021-10-17 17:54:49
slug: peasant-binary
title: "Peasant Binary"
summary: |
  I recently learned a new way for calculating the binary value of integers
  and wrote a small app to help me visualize it.
---
Earlier this week, [a tweet](https://twitter.com/buzz/status/1447968191523672067/)
popped into my timeline and demonstrated some binary math concepts that I'd
never seen before.  I was impressed that Frank Herbert, the author of Dune,
was the author.  But I was also impressed with seeing a new way of calculating
the binary value of decimal numbers.  I wasn't aware of the technique, so I
wrote up a small tool to visualize how it works for arbitrary positive
integers.

Introducing [Peasant Binary](https://grayson.github.io/peasant-binary/).  Input
any positive integer and it will demonstrate the stages that it takes to 
calculate a binary value.

The algorithm itself is pretty simple.  Effectively, you take any number and
start dividing it in half.  At every successive stage, you check whether the
value is even or odd.  If the value is odd, then you record a "1".  If the 
value is even, then you record a "0".  When you're done, you take all of those
values and reverse them.

For example, consider a number like 1110.  It's even, so we start with a "0".

"0"

Half of 1110 is 555.  That's odd, so we record a "1".

"01"

Now, dividing by half would have a fractional value (277.5), so we just round
down (drop the ".5") and record that it's odd.

"011"

We continue with 138 ("0"), 69 ("1"), 34 ("0"; again rounding down), 17 ("1"),
8 ("0"), 4 ("0"), 2 ("0"), and finally, 1 ("1").

"01101010001"

Now, we just need to reverse that value to get the actual binary representation:

"0b10001010110"

You can verify quickly with an [online binary to decimal](https://www.binaryhexconverter.com/binary-to-decimal-converter)
converter.

This feels like something that could be organically realized but I just never
thought too much about it.  The notion that binary numbers are representations
of powers of 2, or effectively doubling, of a decimal implies that the reverse
(halving) could be used to convert a decimal into a binary state.  Since I had
never had a reason to think about it, I never learned this technique.  I'm not
sure this will ever be more than a party trick for me, but I always enjoy
learning new ways to understand and appreciate what's happening in my computer
on a conceptual leve.
