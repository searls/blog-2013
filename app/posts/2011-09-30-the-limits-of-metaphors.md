All metaphors break down with sufficient mileage.

[And they often break down quite quickly, like that car metaphor I just made.]

Because metaphors break down, it's worth pondering the fact that most of humanity *only* comprehends software through the use of metaphors.

* The metaphors most users experience are graphical user interfaces (desktops, folders, round-rect app icons, back buttons, etc.)
* The metaphors our friends and family hear include our own attempts to describe how writing software is actually quite a lot like crafting sturdy Amish furniture
* The metaphors conveyed to business people—at least, the ones that pay to have software developed—are as boundless as they are inane (and they're usually quite inane)
* The metaphors that software developers *themselves* are steeped in are perhaps too complex to ever escape. We stand on the shoulders of giants: building domain-specific metaphors that rest atop dozens of other metaphoric layers. [If you're inclined to disagree, then I suppose that implies you can yet derive the 1's & 0's backing the software you use; or the logic gates; or the assembly operations.]

My proposal today is that we start treating software metaphors with greater skepticism.

Why? Because metaphors break down with mileage. And when people continue to rely on a metaphor beyond its breaking point, they risk reaching conclusions that are no longer rational outside the context of the metaphor.

## the "making stuff" metaphor

We often say we "build" software. As someone who writes about software, I use the verb "build" frequently without a second thought. And what harm is that? Anyone can plainly see that building software produces something digital as opposed to something physical. However, with enough extrapolation, the "build" metaphor will yield loads of bad advice.

[Perhaps this metaphor is why software procurement more closely resembles bidding to construct a highway than proposing to write a novel.]

As we explore the topic, let's keep playing with this "making stuff" metaphor:

> Software is an industry that makes stuff that people use, so it's similar to other industries that make stuff that people use.

### a naïve extrapolation

Most other industries that make stuff are optimized to minimize variation in the goods they produce. A farmer wants every Russet potato to have constant proportions. A manufacturer wants every potato slicer to exhibit constant behavior. A distributor wants every potato fry to present constant crispiness. So it follows that a software company wants every French Fry Simulator to have constant… wait, what?

Something's not quite right about this analogy.

A software company isn't concerned about the quality of *numerous* French Fry Simulators, because it needs to build and maintain only *one* French Fry Simulator. Software systems aren't fungible.

And yet, the software industry spends an inordinate amount of money attempting the same sort of optimizations that only make sense for producers of fungible goods. The [organizations](http://www.infosys.com), [processes](http://en.wikipedia.org/wiki/Capability_Maturity_Model_Integration), and [technologies](http://en.wikipedia.org/wiki/Java_Platform,_Enterprise_Edition) built on this fallacious premise are too numerous to bother citing as evidence.

### the disconnect

Let's visit the french fry example again. To get a physical french fry to market, one would need to:

1. Design the fry, experiment with ingredients, and settle on a recipe.
2. Grow some potatoes; slice, bag, and freeze them too
3. Transport the potatoes
4. Sell the potatoes
5. Fry and salt the potatoes
6. Profit

That's a lot of work! There are many discrete, effort-intensive steps involved in selling french fries. As a result, the workflow is rife with opportunities for optimization.

Changing gears, what sort of work would I need to do to write software that *simulates* selling french fries?

1. Write code that models fry recipes; potato agriculture; preparation and packaging; industrial transport; restaurant economics; and, of course, actually frying potatoes
2. Compile and package the app
3. Publish the app on the app store
4. Sell the app
5. Download and install the app
6. Profit

Before we dive into the (now clear) differences, it's worth noting that several comparisons of these two endeavors would be perfectly apt. The two scenarios follow the same six-step workflow: conceive, create, distribute, sell, deliver, profit. Additionally, both enterprises would clearly require intense focus on the business domain of selling french fries.

But when we consider the nature of the effort involved, we realize the two processes are fundamentally different. First, the physical nature of real french fries means that the expensive steps *need to be repeated* for each and every sale. Meanwhile, the ephemeral nature of digital fries means that the expensive steps *need only be performed once*, regardless of how many units are sold. If you were making real french fries, you could build a career optimizing steps 2-5; if you were writing software about french fries, those same steps are so straightforward that they ought to be automated.

The "making stuff" metaphor is perfectly valid in certain narrow contexts, but it breaks down when it's broadened to cover the entire cradle-to-grave process of taking something to market… oops!

### the consequences

In light of this, why does the industry perennially chase after the illusory goal of managing software as if it were a sort of manufacturing?

One theory: the people paying for software aren't equipped to recognize when the software metaphors they've been given have broken down. And because they keep signing the checks, no one is incentivized to correct them.

Meet Joe. He's an MBA with manufacturing experience, and he's been tasked with improving his company's software business. His understanding of software is limited, so everyone tries to do him a favor by crafting analogies to tie-back the details of the software business to his experiences in manufacturing.

Joe visits his software teams and observes the following: they all use different technologies, they all miss their deadlines, and certain individuals have become so critical that their departure would present substantial risk to the business.

In response, the manufacturing metaphor encourages Joe to mandate the following: standard tools and processes to reduce variability, key performance indicators to manage teams, and more narrowly defined, easy-to-replace roles to reduce risk. Even though none of these prescriptions is going to improve Joe's software business, his first google search yields a bunch of expensive [ALM](http://en.wikipedia.org/wiki/Application_lifecycle_management) tools that validate these approaches as appropriate for software teams. The fact that a software vendor is willing to sell him the type of solution he's imagining has the effect of positively reinforcing the metaphor in his mind.

Feel free to imagine your own ending to this story, because I'm sure you've seen it before. In your ending, Joe's probably not thrilled by the results, but he's probably still got a job. And why wouldn't he? His peers all seem to reach similar outcomes. Joe and his contemporaries will have probably also resigned themselves to the belief that all "business software" is inconvenient, insufficient, and expensive (the over-simplified metaphors through which they understand software having done them no favors).

## a way forward

So, as software craftspeople interested in improving how the world writes software, what can we do?

Here are two ideas.

### ship more frequently

If you're writing software, you have but one form of non-technical, non-metaphorical communication at your disposal: **working software**. (The Agile Manifesto certainly nailed that one.)

So if you're going to reduce metaphorical communication, one approach is to increase the frequency with which you ship working software.

Here's a rule of thumb: strive to ship as often as you ought to converse.

That means a weekly demo is probably insufficient.

Looking for an optimization that's not inspired by a fallible metaphor? Minimize the amount of time that can elapse before you're notified whenever you start heading in the wrong direction.

That strategy would suggest we ship code as frequently as we can, perhaps numerous times each day. Who we ship it to depends on who can provide the most valuable feedback.

* If a product owner's feedback is most valuable, then he should be living in and driving conversations from a development instance that's integrated *incessantly*.
* If real users' feedback is most valuable, then they should be interacting with new code in production as soon as it's written.

If you can figure out how to safely ship code many times a day, your users will let you know when you're on the wrong track so quickly that there won't be much opportunity for wasted effort.

That's the kind of optimization software teams need, not lessons derived from inapt metaphors.

### communicate more directly

Even if you manage to ship working software constantly, one still needs to have conversations about software, right? And how can we communicate with non-technical folk if not by relying on metaphors?

After all, when we use metaphors as a shortcut, we often oversimplify the complexity of a situation. That has the effect of giving others license to go forth and make decisions based on incomplete, unreliable information.

And that isn't very professional.

Instead, **go have conversations about writing code with people who don't write code**.

Too many IT vendors established hefty profit margins by convincing customers that writing software was an imperviously complex undertaking. Today, most non-developers know exactly two things about writing software: (1) it involves writing code, (2) code is too foreign to ever hope to understand. At some point, the zeitgeist seems to have whispered in the ear of most IT vendors, *as long as the customer doesn't understand how software is written, we can price it according to **their** need as opposed to **our** effort*.

Quoting [Noel Rappin](http://railsrx.com/2011/09/06/what-i-learned/):
> Because, ultimately, for a lot of our clients, working with developers is like going to the mechanic. When the mechanics say that the fitzelgurbber has been gazorgenplatzed, and it’s 500 bucks, do you trust them?

Mysticism has been great for the software business, but how well has it served the people buying and using software? Go spend a few months working with people trying to cope with the ecosystem of packaged software that companies like IBM and Oracle peddle—to the tune of billions of dollars a year—and ask yourself again.

In response, we ought to teach non-developers more about what it's really like to write software. Demystify it. They'll bristle at first. But if you're honest, genuine, and persistent, they'll eventually appreciate it. They'll be equipped to make wiser decisions. In the long-run, it will probably benefit everybody: them, their customers, and you.

Start by exposing others only to what they'll likely need to make informed decisions until the next time you'll see them. And  resist the urge to sate them with a metaphor about how integrating two systems is kinda sorta like building a highway. I know as well as anyone that conversations *feel great* for both parties when a seemingly apt metaphor is identified, but quit doing it anyway. Stop it for the sake of the conversations, thoughts, and decisions that will occur later—particularly the ones that you won't be party to.

That's all, folks. Metaphors are dangerous so instead we ought to ship more frequently and communicate more directly.
