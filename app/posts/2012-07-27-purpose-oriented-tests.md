Lately I've been thinking a lot about how we can improve our code by reflecting on our mindsets and motivations with respect to software testing. A while ago, I wrote about [the huge impact that prompts](/2011/04/29/the-power-of-prompts/) have on how we grow code (even the parts of speech we use to name objects). Later, I sat down to [illustrate a taxonomy](/2012/04/01/types-of-tests/) of the types of tests I tend to see in the wild. Recently, I wrote a bit about our natural tendency to [misplace blame](/2012/07/19/blame-the-code-not-the-test/) when testing gets hard.

All of this reflection has helped me draw this conclusion: **the best test suites serve exactly one purpose.**

## the word "test"

In the beginning of my career, I didn't write any automated tests. Nevertheless, "testing" held several important meanings to me, even when performed manually:

* I'd "test" that each bit of code was working as I wrote
* I'd "test" that I didn't obviously break major functionality before every deploy
* I'd "test" that my boss/customer/peers liked whatever I was building

The fact I could get away with using the word "test" just now to describe the above activities says more about the English language than it does about writing software.

And yet, even though now I leverage automation in the above activities, I still call them all "tests". Tests like the above often fall into buckets labeled something like "unit", "integration", and "end-to-end", respectively.

But "unit", "integration", and "end-to-end" don't really capture the essence of the above activities. At best, they describe the types of interactions those tests are allowed to encounter. (That is, a unit test should be relatively isolated; an end-to-end test should be relatively realistic.) The ratio of isolation-to-realism is a very important thing to understand and think about, certainly, but it's tangential to the *purpose* of each test.

## problems!

So slicing test suites by "degree of realism" has practical justifications. Each level-of-realism brings different automation tools into play. As realism increases, test execution slows down (as do our feedback loops), so cordoning fast tests into a separate suite can improve situations where the entire suite would be too slow to run locally.

But defining our tests by their integrated-ness has raised some problems, too. Problems I don't think we've done a good job addressing.

### arbitrariness

Learning automated testing is hard for most developers, but learning the initially-arbitrary-seeming distinctions between tests of one level of integration vs. another is even harder (perhaps because it seems so arbitrary at first).

This arbitrary feeling, I think, is the primary reason why people are so unsure about when using test doubles is appropriate; why teams allow fixtures & factories to become tragedies of the commons; and why so many cycles get wasted on the question "at what level-of-integration should I write this test?"

### lack of prompting

This method of test organization doesn't prompt developers at all with any information about *why* a test exists. Depending on the time of day, my mindset when I sit down to write a test can vary dramatically:

* I'm excited, because I'm writing brand new, unknown code

* I'm cautious, because I don't want future code changes to break this feature

* I'm a nervous wreck, because a bug I'm responsible for just exploded in production

Directory names like `faster_specs/`, `spec/`, and `features/` don't push me towards putting similarly-motivated tests nearby each other. As a result, some other factor will decide which directory the test goes in—sometimes it's convenience, sometimes it's habit, and sometimes it's even organizational culture.

It's worth noting that my `app/` directory *doesn't have this problem*. Every time I sit down to write code in `app`, my motivation is "write working code that works well."

### test conflation

The above issue, that of arbitrarily lumping differently-motivated tests together, leads to another problem: individual tests that represent numerous purposes.

Remember how terrible it was to see PHP/ASP/JSP/ERB templates like this?

    <html>
      <%= javascript_tag do %>
        $(function(){
          $(".<%= my_class_name %>").show()
        });
      <% end %>
      <stylesheet>
        .<%= my_class_name %> { background-color: red; }
      </stylesheet>
    </html>

The above example doesn't separate concerns. We've got numerous execution contexts all lumped in a single file. But considering that, a great many tests approached at different times with varying motivations will invariably end up looking similarly!

For example, say I start a test for a new class called `TakesOrder`. To figure out a design, I might use isolation testing to discover `TakesOrder`'s dependencies:

    describe TakesOrder do
      Given(:notifier) { gimme(NotifiesUser) }
      subject { TakesOrder.new(notifier) }
      When { subject.take }
      Then { verify(notifier).notify }
    end

Later on, we find a bug in this class and we yell, "Stupid mock! That test didn't give me any assurance at all!". So then we write a test for the bug with a dash of added realism:

    describe TakesOrder do
      Given(:notifier) { gimme(NotifiesUser) }
      Given(:user) { FactoryGirl.create(:user) }
      Given { give(notifier).user { user } }
      subject { TakesOrder.new(notifier) }
      When { subject.take }
      Then { verify(notifier).notify }
      Then { user.notifications.size.should == 1 }
    end

And now we have a test that both uses test doubles (to aid in design) and also integrates with the database (to guard against regression).

**That sucks**.

Now every time anyone cracks open the test, they're going to have to waste time deciding whether or not every additional collaborator should be fake or real.

## purpose-orientation

Okay, so slicing tests by degree-of-realism isn't perfect. Is there any other way?

Let's return to the various mindsets we adopt when we're writing tests. I'll rattle off off a handful for the sake of discussion:

* We write tests to demonstrate to others (and ourselves) that our software does roughly what we agreed it should do. Maybe we write these on a feature-by-feature basis to gain the approval of a product owner
* We write tests to gain confidence in the design of our code, and (particularly with TDD) we respond to pain caused by these tests by asking ourselves, "can we obviate this pain by improving the design of our production code?"
* We write tests in response to being burned by bugs. In order to ensure a bug doesn't return, we write an automated test that replicates the buggy behavior in order to protect us from future regressions
* We write tests that ensure the overall application is basically in a working state, either to increase our confidence that a build is stable or that our production environment is healthy.

The above motivations are really valuable and interesting, but nearly every application does little-to-nothing to promote the distinction.

What if we sliced our tests into suites based on their purpose instead? Maybe we'd end up with a directory structure like this?

		.
		├── app
		│   └── app_stuff...
		└── test
		    ├── acceptance
		    ├── design
		    ├── regression
		    └── smoke

### interesting consequences

If we were to actually do this, it would raise all sorts of interesting questions:

* Would it suck for a single unit to be covered to some degree by three or four different tests? What does it mean when that happens?
* Which of these are most important to run before check-in?
* Which of these are most important to run in CI?
* Would being forced to decide on the most appropriate level-of-integration for a given *purposeful* test be liberating or paralyzing, I wonder?

# conclusion

In any case, I wanted to raise the above issues, because I don't think we've yet arrived at the best way to organize our code in such a way that respects the myriad of reasons we write (and don't write) tests. How about you?
