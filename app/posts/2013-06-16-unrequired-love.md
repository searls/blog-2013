This post presumes you're familiar with the concept of tools that introduce a module format (whether it's [Require.js](http://requirejs.org), [Browserify](http://browserify.org), or something else) to JavaScript code that runs in the browser. I'll arbitrarily refer to the over-arching meme as capital-R "Require" for the rest of this post.

Also, keep in mind that this post is only discussing "JavaScript that runs in browsers". It's not at all concerned with Node.js or npm or anything having to do with dependency management of JavaScript in that ecosystem.

# ground rule

Because lots of people use Require and report back that they're getting a lot of value out of it, I think it's important to lay down a quick ground rule before I dive into this post:

**There are are many ways to write working software.**

Arguments about some tool X that follow "X saved my life!", "I didn't have a need for X", or "X is bad and people who like it should feel bad" are generally *not constructive*, because—since there are so many ways to write working software—they're all unfalsifiable claims. That is to say, without knowing every detail of one's situation and experience, there's usually no reasonable way to disprove such a statement.

If you're using Require and it's helping you deliver great software, then rock on! That's fantastic. Please keep diving deeper into whatever you do that's working, and keep searching wider for even better methods.

# Require is not required

Given that there are many ways to write working software, it should be obvious that working JavaScript-heavy web applications *can and are* being written without adopting a 3rd-party dependency management system. In fact, I've written some of them!

Because Require seems to have gained so much mindshare this year, I want to spend a few paragraphs exploring my (Require-free) experience to help establish context, then ask some open questions about what value people see in Require, and finally spin a few of my own crackpot conspiracy theories about what's driving Require's success.

# my own experience

For some context before talking about Require, I'll talk about the basic structure of most of the JavaScript code I write. The punchline is that in spite of not using Require, I really love almost every aspect of my client-side application development. I simply don't find myself yearning for a third-party dependency management tool.

## tiny units

I write *really tiny units* (whether the unit being considered is a framework's pseudo-class, an anonymous object, or a bag of functions). Usually every method is less than five lines, every file is less than forty lines, and every unit has at most three or four dependencies on other units.

## namespaces

I build a namespace as I grow my code and attach it to the window. I usually use my little [extend.js](https://github.com/searls/extend.js/) library to build namespaces as I go. I pick some brief top-level namespace based on the app name (like "ou" for an app called "Oh, You!") and then I drill-down from there.

For instance, if I was going to declare a new calculator for an invoice report, I might do this:

``` coffeescript
extend('ou.reports.invoices.CalculatesTotals', function(){
  // imagine an awesome constructor function here
  // ...
})
```

When extend.js is invoked with a namespace, it will ensure that `window.ou.reports.invoices` is a JavaScript object, then it will set onto it a property named `CalculatesTotals` with the supplied function (which could just as well be an object, or CoffeeScript class, or arbitrary value). The important part is that it won't matter what order this file appears in the concatenated source; it should work so long as it's loaded after any 3rd-party vendor libs.

As a result, in a typical large application, the order that scripts are loaded in will usually only matter to two or three (non-third party) files.

Aside from defusing a lot of the risk that load order might otherwise pose, this (very simple and hardly novel) approach to namespacing has a few advantages:

* It's eminently greppable. If I want to access the `CalculatesTotals` function in the future, I'm probably going to use its fully-qualified name, and I'm *certainly* going to refer to it as `CalculatesTotals`. This means I'll always be able to find all references to it in my codebase. (I mention this because I've seen Require used to greatly decrease the greppability of code references because one could write `totalCalculator = require('path/to/calculates_totals')`, which would make refactoring more error-prone.)
* Files can be split up in a more granular fashion than individual objects. If I were to have one file add some functions to an object with `extend('uo.util.sigh', {add: function(){}})`, I could add more functions to the same namespace from some other file by calling `extend('uo.util.sigh', {subtract: function(){}})` (extend.js will just merge the objects). This is only of moderate utility, but can be really handy during extract & contract refactor operations where needing to keep units & files in lock-step is inconvenient.

## feedback-driven code design

I'm really mindful of how each unit depends on each other unit in the systems I write. Out-of-the-blue references to an object property-chain as lengthy as `uo.reports.invoices.CalculatesTotal` *feel weird* when they're littered all over a file listing. I appreciate that discomfort, because it forces me to be more thoughtful about my design (whether my reaction will be to decrease the unit's collaborator-count or to inject dependencies as opposed to always explicitly referencing them).

When a load-order bug arises that's above-and-beyond the namespacing strategy above, I know that means *I have a code design problem*, and I use that bug as feedback that I need to clean up how my units relate to one another at runtime. I'm very confident that this particular design pressure has resulted in better-factored code, particularly code concerned with application initialization that runs as the page finishes loading.

## minimal 3rd party dependencies

As I've grown more skilled with JavaScript, the number of tools I keep in my toolbox has gotten smaller, not bigger. I have a handful of libraries I typically reach for, but I've written large applications having only accumulated five or six 3rd party libraries over the course of months.

Not surprisingly, folks who are less proficient with JavaScript tend to grasp eagerly to third party libraries to solve the problems that they encounter, for lack of any alternative. If my app had dozens of uncontrolled third-party libraries all trampling on the global namespace, then a formal module system would probably appeal more to me. As it is, I actually consider as *healthy* the pressure to hesitate before adding third party libraries. (Besides, the best libraries have a no-conflict mode that yields the namespace control back to the user.)

## lots of tests

I love test-driving all those tiny JavaScript units. I personally use Jasmine and a concoction of Jasmine helpers I've written. I'm not even sure why this should be relevant to the discussion of Require, but for the fact I seem to get a lot of e-mail and Github Issues from people trying (and struggling) to use various testing and build tools in the context of apps that use Require.

## great build tools

At [test double](http://testdouble.com), we wrote [Lineman](http://www.linemanjs.com) to be a hassle-free way to write fat-client JavaScript apps. It finds and concatenates all of my source files, so I don't have to. I typically don't configure a thing, I just create files and keep working. Whenever I veer off the beaten path, I might have to configure a change in the load order, but it's usually only something I encounter once or twice a month (and hardly a big enough pain to warrant orienting my entire application around Require).

# open questions

I'm curious why so many folks adopt Require, especially when they do so on their first JavaScript rodeo.

## what value does it add for you?

Given everything I've said above, I'm really curious to know:

*What value does Require provide that isn't also met by the (pretty minimal) safeguards I put in place for myself, which I detailed above?*

I'd love to see a response post that specifically addresses what *someone like me* would get out of using Require that I'm currently not getting some other way. Whatever that benefit is, I've so far failed to find it.

## why break from the default?

A whole bunch of testing, productivity, build, and deploy tools don't work out-of-the-box with Require. I know, because I maintain a few of them! I feel nothing but sympathy for novice JavaScript developers that open issues while trying to figure out how to use a tool in conjunction with Require, but my more immediate impulse is to ask *why*?

*Why adopt a not-yet-standard approach to developing client-side apps, when every tool and morsel of information you seek will need to be framed within the constraints that Require places on you? Especially if you're new enough to JavaScript that you're not capable of working around the corner cases on your own, why make life more difficult for yourself?*

I think about this a lot, because I've found the easiest way to write great code in any given ecosystem is to choose my battles carefully. In general, going with the flow and following defaults & conventions frees me up to spend my intelligence capital on harder, more worthwhile questions.

As a result, if a true AMD standard were to emerge and browsers all incorporated it, I'd absolutely adopt it—even if it was crap! I've convinced myself to love JavaScript (well, CoffeeScript) in spite of its myriad flaws, because I know it's the only show in town if I want to build great experiences on the web. I'd do the same if a standard packaging & dependency management system were to emerge for the browser. (And I hope one does, because having a ubiquitous system for packaging, discovering, and resolving dependencies could drastically improve the infrastructure of the web.)

# conspiracy theories

All of my conspiracy theories as to why Require has become popular are rooted in a suspicion that folks are **cargo-culting** the dependency management systems from languages with which they're more familiar.

The reason I bring up cargo-culting is that most of the developers I see embracing Require are actually *novice* JavaScript developers coming from another programming ecosystem. This realization was the impetus of my concern that what Require actually addresses is a gap in the understanding of many inexperienced JavaScript developers.

## misunderstood weirdness

Everyone knows that JavaScript is weird in relation to other languages, but few can articulate clearly *how* it is weird. Without clearly understanding what makes JavaScript unusual, it's not surprising that folks exert a lot of effort to attempt to normalize it to meet their expectations.

In this instance, the oddity that Require attempts to normalize is that *a JavaScript application is equivalent to the concatenation of its source files*.

If you aren't fully cognizant of this aspect of JavaScript's relationship with the browser, then the prospect of going back to a more familiar code organization mechanism would certainly be appealing! That said, I've found this very simple rule to be a liberating constraint. I'm able to visualize front-end JavaScript applications much more efficiently from this frame of mind than I can of the import/require schemes made possible by Java's classpath and Ruby's load paths.

## tool envy

Another conspiracy theory of mine is that Require doesn't solve any "real" problem that can't also be solved with a better understanding of JavaScript, and that in general the masses would far prefer to be handed a tool than to be asked to think harder. In this case, that problem being how to design code that's load-order agnostic and doesn't abuse the global namespace.

In software, we see [convenience beat simplicity](http://www.infoq.com/presentations/Simple-Made-Easy) in mindshare all the time, so it's valuable to be mindful of which is being offered by any given tool or method.

In my own experience, any time I've been faced with solving a problem through either (a) "greater understanding" or (b) "adoption of a tool", the increased time investment required by the former has always paid off, whereas the initial convenience of the latter has always cost me down the road. As a result, unless Require solves a problem that's not also solved by "thinking harder about the design of my code", I wouldn't feel an urgency to adopt it.

## unabashed cargo-culting

While the previous two examples are derived from the impulse to carry our practices from one ecosystem to another (even if they don't jive with the standards and conventions of the target ecosystem), I think there's a nontrivial number of people who just hate JavaScript and will adopt anything that makes it feel less like JavaScript. I hereby dub this "unabashed" cargo-culting.

That is to say that such people are entirely aware that they're trying to impose their will on a foreign ecosystem and have made up their mind as to the appropriateness and effectiveness of such a strategy. Require definitely makes JavaScript feel more like (most) other environments, and if that's someone's chief consideration, they won't mind paying the price of either a higher cognitive load or tool compatibility issues.

There's really not much more to say about or to this group, as I doubt I'm going to convince them to spend time soaking in JavaScript and learning to love working in the browser.

# conclusion

One of the reasons this issue doesn't sit well with me is that I see a lot of people advocating Require to others, but for their own benefit and not for the benefit of the listener. It often feels like Require's fans push for greater adoption in hopes of more first-class support among third-party libraries or more AMD-awareness to be built-into front-end tooling. That wouldn't bother me so much if Require's value proposition was overwhelming and clear, but it really isn't for me.

All of the above said, I'm very much open to persuasion. Consider this post an open invitation to try to sway me on this issue. Feel free to shoot me an [e-mail](mailto:justin@testdouble.com), [tweet at me](http://twitter.com/searls), or author a response post and send me a link. If you do, I'll have been super grateful for your time and thoughts!
