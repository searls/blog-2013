Today, I had the good fortune to visit my friends at [Sparkbox](http://seesparkbox.com), where they host a Dayton JavaScript user group called [Gem City JS](http://gemcityjs.com/). Today, I showed up to share some perspective on how to test JavaScript with Jasmine.

Folks have been asking me to share a screencast of how I write Jasmine tests for a few years, so I recorded the session and am providing it online, completely unedited:

<div class="hd-video">
<div class="video-container">
  <iframe width="1280" height="720" src="http://www.youtube.com/embed/PWHyE1Ru4X0?rel=0" frameborder="0" allowfullscreen></iframe>
</div>
</div>

This screencast ([YouTube](http://www.youtube.com/watch?v=PWHyE1Ru4X0)) is merely a conversation to provide an answer to the question, "Hey Justin, how would you write a test for ____ JavaScript code?" where that blank might be filled with "interacting with the DOM", or "binding user events", or "making AJAX requests". I cover each of those in a way that's similar to how I do it today; I trust that in six months, I'll have evolved and changed my tastes somewhat, but this reflects where I'm at right now.

It's a pretty thorough stream of consciousness—in fact, it's nearly **feature-length**. That's pretty long for a web video, but if you've struggled to figure out how to write tests for real-world JavaScript (or, if you're just interested in getting inside the head of someone else on the topic), then perhaps 75 minutes will be a reasonable investment of your time.

## overview

Now, a few brief notes on the presentation itself.

First, the sample code is hosted on Github at [searls/refactor-to-backbone-example](https://github.com/searls/refactor-to-backbone-example). The anonymous jQuery and the Backbone specs can be found on the `master-specs` and `backbone-specs` branches, respectively. The application is a Lineman app, and you can find out how to install and run it on [Lineman's README](https://github.com/testdouble/lineman).

Second, the presentation is not intended to discuss the values and virtues of either the broader topic of unit testing or these particular tests. Instead, my primary goal was to convey *specific testing tactics* that can be employed to write *unit* tests for common JavaScript patterns. It's absolutely the case that some of these tests aren't particularly valuable, but the skill to be able to write them absolutely is.

Finally, there's a logical division that isn't apparent as the video begins, so I'll provide some overview. The first half focuses on going through the *admittedly arduous* process of characterizing a big ball of anonymous JavaScript with Jasmine tests. The code under test is crufty, so the tests are naturally painful to write—even to me, with several years of daily experience writing Jasmine.

The second half of the presentation is intended to serve as a contrast, because here it's spent characterizing code that's at least been broken up into small(er) units with a named, usable API. In what should shock no one, slightly simpler units lead to slightly simpler tests. This codebase could use even more refactoring, but that's beyond the scope of this discussion.

## libraries

I used and described several libraries during the presentation, you can find them here:

* [jasmine-fixture](https://github.com/searls/jasmine-fixture)
* [jasmine-given](https://github.com/searls/jasmine-given)
* [jasmine-stealth](https://github.com/searls/jasmine-stealth)
* [Lineman](https://github.com/testdouble/lineman)
* included with Lineman, [testem](https://github.com/airportyh/testem)
