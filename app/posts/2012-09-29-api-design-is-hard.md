*[Note: this post covers unreleased features of gimme, which are unreleased because of the issues described in this post. They need more time in the oven. You can [peruse the feature branch](https://github.com/searls/gimme/tree/inarguable) on github]*

Working on [gimme](https://github.com/searls/gimme) with [Mr. Karns](http://twitter.com/jasonkarns) made me realize I'd painted myself into a corner on gimme's API design. I thought I'd share here, for hope that either (a) someone will respond with an approach I like better, or (b) the topic might prove independently useful, and some good will come of this after all.

## background

Gimme is a [test double](http://xunitpatterns.com/Test%20Double.html) library, which is a fancy way to say it makes fake objects for your tests.

Let's imagine an object we want to fake, like:

    class Police
      def radar(car)
      end

      def taze!(bro)
      end
    end

First, we'd need to ask gimme for a test double:

    cop = gimme(Police)

If we wanted to rig the radar reading to be a certain number, we could:

    give(cop).radar(my_car) { 90 }

And if we wanted to make sure our cop tazed my bro, we could:

    verify(cop).taze!(my_bro)

## the initial solution

But what if we don't care about `my_car`? What if we want the radar to only read 90? (This would be a very sensible desire if the radar was only loosely related to our test and a lot of cars needed to be scanned)

Well, Jason and I landed at an API like this one:

    give(cop).radar { 90 }.inarguably

That `inarguably` flag would basically set up an additional stubbing for the method that would always be satisfied, whether in the presence or absence of arguments.

Verification could work (sort of) similarly.

    verify(cop).inarguably.taze!

## bad

See the change in ordering? When stubbing, the `inarguably` configuration comes at the very end of the statement, but when verifying, `inarguably` is sandwiched in the beginning. *That's bound to confuse people.*, I thought.

Why was it done that way? Primarily, it was because a failed verification will immediate raise an error. Why not do this?

    verify(cop).taze!.inarguably

But, alas, a `verify` can't return an optional configuration object to be invoked after the command, simply because it needs to know whether to raise an error, and there's no way of immediately knowing whether someone will ever call `inarguably` later.

So we settled for the previous solution. But I still really hate that mismatch; that's exactly the kind of test double design that confuses and frustrates people already confused and frustrated by test doubles!

## worse

Then it gets worse! By adding an API like `inarguably` directly on the object returned by a `verify()` call, it means that **users could not longer verify a method that's actually named "inarguably"**. That's not cool.

I mean, sure, it's a goofy name. But rubyists love goofy names. And besides, Gimme is likely to accrue other configuration options in the future. I'd hate to set a precedent now that leads to a dozen "magical method names" that, upon being verified, for some reason silently pass. That'd surprise and confuse every user that might run into them.

## worst

In my finite wisdom, I decided to tweak `give` to work just like `verify`, anyway. So at the moment, you can do either of these things:

    give(cop).inarguably.radar { 90 }

Or

    verify(cop).inarguably.taze!

And now I have two problems! Users can now neither stub nor verify a method called "inarguably", and any remedy I can think to provide as the library's author (assuming this design stands) would require a user to first realize this limitation.

## halp?

So what would you do? I've thought of a couple silly ideas.

### a new arg

    give(cop, :inarguably).radar { 90 }

and

    verify(cop, :inarguably).taze!

Which would require a somewhat-cute implementation, since verify already supports a syntax like `verify(cop, 4.times).taze!(bro)`

### a catch-all config method

I've also thought about future-proofing the concern that we'd one day have a bunch of one-off configuration methods that don't work, by creating just *one* configuration method to which you'd supply an options hash:

    give(cop).configure(:inarguable => true).radar {90}

or

    verify(cop).configure(:inarguable => true).taze!

And perhaps both give & verify could simply remove that configuration method as soon as it is used, that way if someone wanted to stub or verify a method with the same name, they could, with something like `verify(cop).configure.configure(:foo)`. Alas, the user would still have to realize what's going on, which makes it a deal breaker.

## in conclusion

In conclusion, there is no conclusion. I'm not sure what I want to do. The safest way would be the "a new arg" approach, adding an arg to `give` and `verify`, but it's also the one my eyes and fingers like least.

Any feedback on this issue? I'd greatly appreciate it.
