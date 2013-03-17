Funny how just this week I felt compelled to [blog about implicit knowlege](/2013/01/21/explicit-vs-implicit-knowledge), because a terrific example of the possible consequences of too much implicit knowledge came up yesterday.

Please forgive me for the length of this post, because this is a surprisingly subtle problem. As with most subtle problems, the context and relevant background knowledge are necessary to arrive at a clear understanding of both the problem itself and the causes.

# rails background

Ruby on Rails' applications are well-known for being addled with implicit knowledge. The framework itself aims to increase productivity and developer happiness by moving many pieces of knowledge out of the application's source code and into our collective consciousness. Much of this was made possible by Ruby's flexibility, by way of its introspection capabilities (like `define_method` and `method_missing`). Even more of this was made possible by establishing a conventional approach to most common tasks. Put another way, to most frameworks, writing no code results in no behavior; in frameworks like Rails, writing no code results in *default* behavior.

This high-implicit-knowledge environment becomes comfortable with time, and genuinely helps increase productivity (especially at the outset) by helping you to focus on how your application is unique, as opposed to rotely defining how it *is not*.

It's really quite delightful to become accustomed to the "magical" sensation of the power that negative space has in a Rails application. One becomes used to making significant changes to the appliction by invoking only a single method or adding just one extra entry to an options hash.

# falling into the trap

I'm hardly an ActiveRecord expert. I'm not terrifically familiar with its (most recent incarnation's) internals, so I often find myself stumbling around a bit to find a working solution.

This week we found a bug in a very complex chain of [Arel](https://github.com/rails/arel) scopes. We added a new scope to the chain and in some very narrow situation, we found that our scope wasn't successfully narrowing down the results.

Explaining the entire chain of scopes isn't worth your time, so I'll only give an example of the sort of scope we added. It originally looked like this:

    def self.with_unpaid_invoices
      joins(:invoices).
        where('invoices.paid = ?', false)
    end

But since that wasn't working in our case, we toyed around a bit and we found a quite easy fix. We just changed "joins" to "includes", like so:

    def self.with_unpaid_invoices
      includes(:invoices).
        where('invoices.paid = ?', false)
    end

This change fixed the immediate problem we were dealing with. It also turned out to be a bad idea, in no small part because we didn't understand the documented purpose of `includes` before we put it to use.

# joins vs. includes

I'm going to refer to the [Rails guide on ActiveRecord querying](http://guides.rubyonrails.org/active_record_querying.html) to shed a little light on the background of `joins` and `includes`.

* `joins` is provided for the purpose of adding `JOIN` clauses to the SQL that AR generates. This is most often used to narrow results based on some condition(s) of its associated models.
* `includes` is provided as a solution to the classic "N + 1" query problem that plagues most ORM libraries. Per the guide, "*Active Record lets you specify in advance all the associations that are going to be loaded. This is possible by specifying the `includes` method of the Model.find call.*"

As is patently obvious by juxtaposing the purpose of these two methods, it's clear that their motivations are entirely unrelated. The former seeks to improve the expressiveness of your queries, the latter seeks to improve the performance of your queries.

There's a lurking danger that users might conflate the two (as we did), in that these two features are both used in the same context (when finding records) and both use similar tools to accomplish their task (SQL's `INNER JOIN` and `LEFT OUTER JOIN`, respectively).

As is often the case, Rails provides us just enough rope with which to hang ourselves, as is suggested in this section of the guide that immediate follows its descriptions of `joins` and `includes`:

> ** 12.2 Specifying Conditions on Eager Loaded Associations **
>
> Even though Active Record lets you specify conditions on the eager loaded associations just like joins, the recommended way is to use `joins` instead.
>
> However if you must do this, you may use `where` as you would normally.

It warns against specifying conditions when using `includes`, but it doesn't go on to give a compelling reason. Let's continue, and discover why the guide warns us of specifying conditions when using `includes`.

# the includes() side effect

The two methods' apparent similarity begged the question "why, after all, did switching a `joins` to an `includes` fix our scope? That smells wrong."

It turned out that the pre-existing lengthy chain of scopes had been using `includes` and `where` *for their side effect*.

You see, because `includes` uses outer joins to grab your models' associated records in one big query, any conditions that you place on those associations will filter them down, too.

Here's our example domain: `Clients` have many `Invoices` which may or may not be `paid`. Pretend as well that our system has two clients: one with an unpaid invoice and one with no unpaid invoices.

To illustrate, here are some example queries:

    > Client.all
    => [#<Client id: 1>, #<Client id: 2>]
    > Client.joins(:invoices).where('invoices.paid = ?', false)
    => [#<Client id: 2>]
    > Client.includes(:invoices).where('invoices.paid = ?', false)
    => [#<Client id: 2>]

So, as we can see, `joins` and `includes` both filter the results as we would expect.

But there is an interesting, subtle difference between the nature of those `Client` instances.

First, here is what the `invoices` relationship looks like if we use `joins`, the recommended means of querying based on associations' criteria:

    > clients = Client.joins(:invoices).where('invoices.paid = ?', false)
    > clients.first.invoices
    => [#<Invoice id: 2, paid: true, client_id: 2>,
        #<Invoice id: 3, paid: false, client_id: 2>]

As you can see, we searched for "clients with unpaid invoices", and when we actually go look at the invoices of such a client, we get back both its paid and unpaid invoices. This makes sense because the client object is presented to us completely and accurately.

Second, let's look at how this differs when using `includes`:

    > clients = Client.includes(:invoices).where('invoices.paid = ?', false)
    => [#<Client id: 2>]
    > clients.first.invoices
    => [#<Invoice id: 3, paid: false, client_id: 2>]

When we use `includes`, we not only get the "clients with unpaid invoices", we also receive "only the unpaid invoices for each client". At first blush, that can seem pretty cool! If our true intent was to present a list of all of the unpaid invoices of all of our clients, this could actually be quite convenient. We'd fetch everything up front in one big query and the hydrated objects would allow us to present the results just as we wished without further modification.

Obviously, leveraging this side effect intentionally would bear with it a little extra implicit knowledge: the `clients` returned by such a query wouldn't be "real" clients per se, because their associations won't reflect reality. If we were to pass those clients to another object (or another developer) that was unaware of the nature of these filtered associations, difficult-to-discern bugs might emerge.

And apart from that caveat, there's a catch.

# the catch

If one decides to (or merely happens to) take advantage of this side effect, there's a worrisome catch: if the filtered association is subsequently scoped, all of the original filtering *disappears*.

Take the above example:

    > clients = Client.includes(:invoices).where('invoices.paid = ?', false)
    => [#<Client id: 2>]
    > invoices = clients.first.invoices
    => [#<Invoice id: 3, paid: false, client_id: 2>]

Next, suppose we want to filter `invoices` down *just a little bit more*, in this case we decide to exclude the invoices less than $50:

    > invoices.where('amount > ?', 50)
    => [#<Invoice id: 2, paid: true, amount: 100.0, client_id: 2>,
        #<Invoice id: 3, paid: false, amount: 100.0, client_id: 2>]

Woah, woah, woah. That paid invoice came back! That's not what we wanted at all!

As it turns out, by scoping on the filtered association we've lost any filtering-as-side-effect that we attained from `includes`. And it's not because of how we searched, either; invoking `scoped` or `count` on the associated array will have the same effect:

    > invoices.count
    => 2
    > invoices.scoped
    => [#<Invoice id: 2, paid: true, amount: 100.0, client_id: 2>,
        #<Invoice id: 3, paid: false, amount: 100.0, client_id: 2>]

Huh.

# conclusion

Obviously, there's nothing expressly *evil* about specifying conditions on an included assocation, but I now understand why the Rails Guides might recommend against it. As it turns out, relying on the filtering side effect of `includes` is quite fragile and error-prone.

As for the situation that led me to this realization, we decided to rework the existing code to eliminate its reliance on this filtering side effect. We went through each of the existing scopes and switched them from `includes` to `joins`, then we added (duplicatively) similar scopes to be used on the associated arrays of the results. The approach we landed on will result in more queries at runtime—if a performance problem emerges as a result, we'll tackle it then.

Huge thanks to [Angelo Lakra](https://twitter.com/angelolakra), [Jason Rush](https://twitter.com/diminish7), and [Mr. Todd Kaufman](https://twitter.com/toddkaufman) for working with me (and in most cases, teaching me) what was going on in this case. I also pushed the [repo that I used](https://github.com/searls/includes-vs-joins) to work out this post's example to github.
