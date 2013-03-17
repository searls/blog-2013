We lack much of a vocabulary to describe *knowledge* and how code can succeed to or fail at codifying it. The points made in this post are so popular as to be self-evident, but it seems I can always use more practice in articulating them. I'll start with an example that many of us are familiar with and then swivel into an issue I ran into today.

# code comments

Inline comments in code are often maligned for two reasons: (1) well-factored code can be so expressive that additional comments shouldn't be too valuable, and (2) comments often fall out of sync with reality, as only the code *must* change to implement new behavior.

For example, we can probably all agree that there's a way to obviate the following comment:

    #go to the next candidate prime divisor
    n += 1

The problem above is that the meaning of `n` is nearly *implicit*, and certainly would be if the comment had existed only outside the code listing (or worse, only inside someone's brain). In this case, there's an obviously *better place* to store that knowledge, in this case, with a better name for the identifier.

    candidate_prime_divisor += 1

Now the knowledge and the function are one and the same. I would call this example's knowledge of a number tracking of a candidate prime divisor *explicit*, because it literally states it.

# arguments lacking context

The first example was quite contrived, but here's a method similar to one I ran into today. I struggled mightily to recall some of its intent:

    def report_on_payment(recipient, month, regions = [], types = [], save = true)
      save = false if month.current? || regions.any? || types.any?

      report = calculate_report(recipient, month, regions, types)
      save_report(report) if save
      report
    end

Regardless of any other issues, it's clear what the thrust of this method is: it generates a report for payments to a recipient for a given month, and *sometimes* it persists that report.

But upon reading it, two questions fluttered in my mind:

1. Why do `regions` and `types` default to blank? Shouldn't default behavior include *all* possible `regions` and `types`?
2. Why is the `save` flag tripped to `false` in the presence of any regions or types?

And try as I might, there is nothing *explicitly* written in that method that can be used to answer those questions. In fact, the only way I managed to figure it out was on account of the fact that I had a part in writing it.

So, what's the missing meaning behind these questions? The answer: there was a bit of implied knowledge floating in the brain of the author: **`regions` and `types` are used to *filter* the contents of the report, with an empty array meaning "don't filter".**

Prior to the introduction of those filter fields, the meaning of the method was more straightforward:

    def report_on_payment(recipient, month, save = true)
      save = false if month.current?

      report = calculate_report(recipient, month)
      save_report(report) if save
      report
    end

The basic logic is clearly "each report is calculated for a (recipient, month) tuple and is generally persisted, but never for reports on the current month". This isn't a perfectly simple method, but at least its motives are mostly clear.

Now, knowing that `regions` and `types` are meant as fields to filter the contents of the report, we might consider adding that knowledge to the method more explicitly, like so:

    def report_on_payment(recipient, month, filters = {:regions => [], :types => []}, save = true)
      save = false if month.current? || filters.values.flatten.any?

      report = calculate_report(recipient, month, filters)
      save_report(report) if save
      report
    end

This new implementation is certainly a tad longer, but at least it's now abundantly clear (a) that regions & types are fields by which a user may *filter* a report's contents, and (b) saving should be disallowed whenever there are any filter options provided.

In this example, it turns out that both of my points of confusion could be assuaged by making our intention more explicit with a single new identifier.

# more broadly

This is not to say that implicit knowledge is bad, but that—lest it impede the understanding of others—implicit  knowledge carries the hidden cost that it must be spread somehow. Rails, for example, is full of implicit knowledge in the form of conventions and methods missing that we share through documentation and tribal knowledge. Similarly, the design of most business applications is aided by a small lexicon of deeply meaningful nouns—even if that meaning is only shared by a small internal group.

I suppose we must be mindful of balancing knowledge conveyed explicitly in code with knowledge our code relies on implicitly and which must be conveyed by some other means.






