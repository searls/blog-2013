Many people who practice test-driven-development completely surrender the practice when they undertake writing code for user interfaces. It's something I observe often as I try to sell people on [TDD for JavaScript](http://tryjasmine.com/). The arguments I hear most often go something like, "testing DOM/jQuery/view code isn't *valuable*", or, "testing a view is a waste of time—I can see that it's working as quickly as I can run a test!" After all, it might take no longer to hit Cmd-R (or F5) in a browser than it takes to run a unit test.

When selling others on TDD, advocates tend to talk a lot about the fast feedback derived from its practice. The argument is easily made: say a unit's test can run in under a second; and suppose that launching the application to navigate to the feature that ultimately depends on that unit takes 30 seconds; therefore a developer could traverse 30 times as many feedback loops while writing this unit if they were to adopt TDD. Even as a theoretical upper bound, a factor of 30 is quite the productivity boost!

But there's some hand-waving required to justify TDD as a boon to productivity. This argument takes advantage of the fact that "feedback" is an overloaded term when described as a benefit in-and-of-itself. If I tell someone that I perform X activity to attain "faster feedback", it's probably not clear what information I'm seeking from that feedback. I might be looking for:

* feedback to tell me my code is working/broken (passing/failing tests)
* feedback to tell me my design is good/bad (easy/painful tests)
* feedback to tell me my interfaces are usable/confusing (positive/negative usability studies)
* feedback to tell me my application is a success/failure (high/low revenues)

TDD provides more than one type of feedback; of those listed above, it can tell whether each small unit of code is working and whether its design is especially bad. Feedback as to whether a bit of code works can hasten productivity, but only when it's the fastest way to find out. Feedback as to whether a design is well-factored can promote long-term maintainability, but only when the developer responds to the pain of a hard-to-write test by reworking the code's design.

My bet is that many people who practice TDD only ever consider feedback of the "does it work" sort. That statements like, "I don't need a test for that, because it's obvious whether the code is working," are commonplace seems to agree with this.

Anyway, I'd suggest this is a reason why—even among teams that practice (some amount of) TDD—I typically find projects with UI code that's poorly-factored relative to its model objects. With respect to the web, this problem is only going to get worse as web applications become increasingly dynamic and the role of JavaScript continues to increase.
