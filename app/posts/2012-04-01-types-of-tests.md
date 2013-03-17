I want to spend some time documenting the different types of automated tests I encounter most often, detailing each type's distinct characteristics, advantages, and challenges. This [is](http://www.amazon.com/The-RSpec-Book-Behaviour-Development/dp/1934356379/ref=sr_1_1?s=books&ie=UTF8&qid=1333215095&sr=1-1) [not](http://xunitpatterns.com) [a](http://www.amazon.com/Agile-Testing-Practical-Guide-Testers/dp/0321534468/ref=pd_sim_b_9) [novel](http://www.amazon.com/Test-Driven-Development-By-Example/dp/0321146530/ref=pd_bxgy_b_img_b) [concept](http://www.amazon.com/Growing-Object-Oriented-Software-Guided-Tests/dp/0321503627/ref=pd_sim_b_3), but since many developers I interact with continue to conflate, confuse, and generally stumble over this issue, I figured it [couldn't hurt](http://xkcd.com/927/) to share my perspective. I'll take a first swing at this post by using the terms	 I prefer, but I will gladly update it in response to your feedback—after all, any taxonomy is only useful if everyone in a given group can largely agree on it.

## why terminology matters

A common thread I've found among teams of rigorous developers is that clear and consistent terminologies are critical to fostering common understanding. That should make intuitive sense if one accepts that code is primarily a form of inter-personal communication (if so, then of course words matter!). As a team undergoes normalization—in which every member will independently arrive at increasingly similar solutions—any improvement to the quality of communication ought to reduce the pain of normalization. (I've recently come to refer to the pain of normalization as "the cost of consensus", and [in a recent talk](http://searls.testdouble.com/2012/03/10/the-mythical-team-month) concluded that team-based development isn't always worth that cost.)

## some prerequisite definitions

A few terms that I use liberally when talking about tests are below (and are similar to what you'd find in [XUnit Patterns](http://xunitpatterns.com)):

* **System under test (or "Subject" or "SUT") -** the code whose behavior is being specified by a test. It isn't enough to merely be executed by the test—as most tests will incidentally execute a bunch of code on which the subject depends. Code is only the subject "under test" when its behavior is expressly specified by the test's assertions.
* **Collaborator (or "depended-on-component") -** an object on which the SUT depends. For instance, if the subject instantiates or is given an instance of some other class, that class is a depended-on-component of the subject.
* **Coverage -** code can be considered "covered" when some automated test would fail if the code were to stop working. The definition of "working" is best left to the ultimate user of the software. Note that **most "code coverage" tools don't actually measure coverage**; typically, these tools merely measure the proportion of production code that is executed, not the proportion actually demanded by a test's assertions.
* **Fragile -** "Fragile" is often used as a pejorative in testing circles, but I prefer to use it to describe the number of factors by which a test could conceivably fail. By this definition, a unit test that only accesses a single object under test will inevitably be less fragile than a full-stack test that exercises hundreds of objects, depended-on frameworks, application containers, and remote services.
* **Test Double -** Any behavior provided by the test that's intended to stand-in for the real behavior of the subject's depended-on-components. I talk a little about the types of test doubles in [the beginning of another post](http://searls.testdouble.com/2011/06/03/whats-wrong-with-rubys-test-doubles/).

## the various types

Let's work outside-in, shall we? We'll start with the coarsest (most fragile) types of tests and finish with the most granular. We'll be discussing the following:

* [remote full-stack application tests](#remote-full-stack-application-tests)
* [local full-stack application tests](#local-full-stack-application-tests)
* [contract tests](#contract-tests)
* [below-the-UI tests](#below-the-ui-tests)
* [unit tests](#unit-tests)
* [isolation tests](#isolation-tests)

<a name="remote-full-stack-application-tests"></a>
### remote full-stack application tests

**What Distinguishes them?**

Remote full-stack tests assert the behavior of the entire application under real-world conditions. The tests share no meaningful system resources with the system under test—in particular, they lack access to the process of the system under test.

**Examples?**

* Tests are run on a separate machine (say, a workstation or [CI](http://www.extremeprogramming.org/rules/integrateoften.html)) and run against a deployed web application over a network connection
* A test and its subject are both run as separate processes, and the test exercises the subject indirectly via an application automation framework (like [UI Automation](http://developer.apple.com/library/ios/#documentation/DeveloperTools/Reference/UIAutomationRef/Introduction/Introduction.html) or [Selenium]([Selenium](http://seleniumhq.org)), or image-recognition scripting (like [Sikuli](http://sikuli.org))

**Advantages?**

* They are wholly independent from the underlying implementation. A well-crafted remote full-stack test should be able to be reused even if the entire system is completely reimplemented, provided that the new implementation does not change the application's observable behavior.
* Full-stack tests use the system in the same way a user would. Whether the application's "top layer" is a user interface or an API, full-stack tests can be a handy reference for how the system is typically used.
* Offers the highest confidence that the test doesn't "cheat" via [backdoor manipulation](http://xunitpatterns.com/Back%20Door%20Manipulation.html) or otherwise put the subject into a state that is unlike a real-world situation.
* Line-for-line, full-stack tests achieve higher effective coverage of subject behavior than more granular tests. If you can only write one test, it may as well be a test that ensures basic functionality of the fully-integrated application (by contrast, a lone unit test covering one out of a thousand objects in a system doesn't provide as valuable of feedback).
* By being entirely remote, these tests may be adapted to run against production environments and offer a first line of defense with respect to downtime and other operational concerns.

**What makes them hard?**

* Because the test runner doesn't share any resources with the system under test, controlling test data can range from difficult to impossible. Frequently, the test author is forced to:

	* Maintain separate pre-run and post-run processes that prime and clean the SUT's data store, respectively.
	* Craft each test to create and tear down test data via the application's own interface (i.e. in testing a blog's comments system, the test could first use the broader application's UI to create a new blog post, perform its comment-related tests, and finally use the application UI to delete the post and comments). Note that tests under this constraint are often orders of magnitude more expensive to build; moreover, entire categories of applications preclude this approach.
* Most applications are written with a human user in mind, so many full-stack testing tools have to be robust and clever enough to mimic the behavior of human users. As long as user interfaces keep advancing, it's unlikely UI automation tools will ever encompass the same range of expression possible to a human user. (Imagine being tasked with writing a suite of remote full-stack tests against [Siri](http://www.apple.com/iphone/features/siri.html), for instance.)
* Full-stack tests are inherently fragile. Any change to the behavior of the application or its depended-on services could (and often, should) cause a test to fail. As a result, discriminating false negatives vs. true negatives is often only apparent to the developer making the change. This is why mandating that separate QA personnel build and maintain full-stack tests is a special sort of organizational torture—if a separate QA individual owns the full-stack test
* In many environments, full-stack tests are orders of magnitude slower than more granular tests. This has two significant consequences:

	* The authors of the test may need to operate under a slow, inefficient feedback loop when writing them. Often, this means having to wait several minutes to validate whether each line of test code works as expected.
	* Continuous integration builds that run large suites of full-stack tests may require hours to run, often providing the team both late notice of failures and very little indication of which change caused a given failure (because the longer the suite takes to run, the broader the set of changes each test run will incorporate).

**When should I write them?**

* Remote, full-stack tests are most useful as "smoke tests", ensuring that the basic functionality of the application works under real-world situations. The phrase "smoke test" conveys a minimal, happy-path through the system (in contrast to exhaustive tests covering every path of execution). Smoke tests are seen as an appropriate compromise, because full-stack tests are more expensive to build, maintain, and execute than any other type of test.
* Full-stack tests make for excellent acceptance tests, because they achieve high confidence that a given feature works in a way that can be observed by even a non-technical customer.

<a name="local-full-stack-application-tests"></a>
### local full-stack application tests

**What Distinguishes them?**

Like remote full-stack tests, local full-stack tests assert the behavior of the fully-integrated application. Unlike remote full-stack tests, however, local tests share intimate system resources with the application under test (typically residing in the same process and with access to the application's object instances).

**Examples?**

* Most Rails apps' Cucumber tests are *local* full-stack tests because the Rails application and its objects are accessible to the test. (You can accomplish remote full-stack testing, however, by pointing [Capybara](https://github.com/jnicklas/capybara)'s `Capybara.app_host` variable to a separate server running the Rails application.)

**Advantages?**

* Typically, controlling test data is significantly easier because the subject application can be directly primed with test data using its own API or application database.
* System behavior that lacks easy-to-observe side effects can be asserted more easily by interrogating the system directly (however, I might argue that it is rarely important to invest in a full-stack test which verifies behavior that a user can't see).

**What makes them hard?**

* Local full-stack tests share most of the same burdens as remote tests.
* One additional concern with local full-stack tests is the risk of losing implementation independence. For example, a test could assert behavior by interrogating the system objects (e.g. asking Rails whether an e-mail delivery was made or inspecting the state of objects in a database). In so doing, the test would no longer be reusable by a wholly different implementation of the application.
* Per the above, each team will need to decide when and how they resort to taking advantage of their direct access to the application under test. Typically, I'd propose only allowing direct manipulation or interrogation of the application when indirect means are unreasonably difficult or impossible. In lieu of an agreed-upon rule-of-thumb, being forced to consciously decide whether each test setup and assertion should be accomplished directly or indirectly can slow teams down.

**When should I write them?**

* When controlling test data is so difficult that the cost of remote full-stack testing is prohibitively high.
* When it's necessary to assert application behavior that the user cannot directly observe. This situation occurs most often in applications where the user's actions ultimately affect some other application that is not under test.

<a name="contract-tests"></a>
### contract tests

**What Distinguishes them?**

Contract tests are written against third-party code, authored and maintained by someone else. (Contract tests are a special sort of test in that they aren't written against the application's own code, so they exist apart from the discussion of how real or isolated an application test should be.)

**Examples?**

* An application uses the Twitter API but generally does not call through to the actual Twitter API in its other tests. In order to codify the application's assumptions and demands regarding the API's behavior, contract tests are written against the API (not invoking the application code at all) that assert those assumptions.
* An application relies on a library dependency written by someone else and there's a high risk that changes to that dependency will break the application's behavior. If no other test covers every assumption made about the dependency's behavior, the team may decide to write a suite of tests that specify those assumptions, getting fast feedback if an upgrade violates them.

**Advantages?**

* Most external services and linked dependencies are—at best—only tested incidentally by tests specifying the application's own code. Contract tests can help developers prevent the application's own tests from concerning themselves too much with the behavior of the third party code, an anti-pattern known as "testing the framework".
* A test that's written explicitly and clearly with the third-party code as its subject can serve to document what the application is gaining by using that dependency, which might prove useful should the team ever consider replacing or removing it.

**What makes them hard?**

It's difficult to determine when and whether you need contract tests against a service or a dependency. Without any contract tests, it is possible that only manual inspection would catch a failure caused by a change to third-party code. With too many contract tests, you could end up with a test suite that fully covers the behavior of the dependency—something the dependency itself would hopefully already have.

**When should I write them?**

* Typically, I wait until I'm burned by a service change or a dependency upgrade to write a contract test to guard against future regressions.
* When you're adopting a brand-new or otherwise immature API (a lot of my friends like to point at Facebook's API here), codifying your assumptions with contract tests can provide fast failure when the third party's changes break your application.

<a name="below-the-ui-tests"></a>
### "below-the-UI" tests

**What Distinguishes them?**

Below-the-UI tests are intended to test the full application behavior, but use programmatic API hooks as opposed to manipulating  interfaces intended for users.

**Examples?**

* A team exposes additional API hooks that can exercise most of the application's behavior, then writes [Fitnesse](http://fitnesse.org) adapters that can be used to write acceptance tests as wiki pages.
* A team maintains a separate suite of integration tests, written with the same library as their unit and isolation tests, that put the behavior of their controller/service methods under test, exercising everything in their stack below the user interface.

**Advantages?**

* Avoids the volatility and shortcomings of tools that automate user interfaces.
* In some instances, they can be significantly faster than testing through the UI, sacrificing a little realism in exchange for faster feedback.

**What makes them hard?**

* Below-the-UI tests often require additional production code that exposes an API for the test to use. Often, a test cajoling us into changing our production code is a Good Thing&trade;, but only insofar as the change improves the production code's design. Poking holes in the production code to make non-UI testing possible isn't much different from increasing the visibility of private methods in order to test them discretely (which, apart from killing unicorns, ignores the healthy pressure to extract new first-class objects)
* The more integrated the test, the more closely it should resemble "real-world" usage of the application, but below-the-UI tests' access to the application is often an API contrived for only its use. A test isn't very realistic if it accesses the application in a way that no one else will.
* Maintaining an additional API for the sole purpose of testability can lead to prematurely complex designs. Commonly, a feature that would otherwise be used once (by the UI) may need to be eagerly abstracted to meet the needs of any corresponding below-the-UI tests.

**When should I write them?**

* If UI automation is tremendously difficult or impossible, then below-the-UI tests may be used as a replacement for the same situations you would otherwise write full-stack application tests.
* When your application already features a clear delineation between its user interface and other code, then it's possible that below-the-UI test coverage may provide more bang-for-the-buck than full-stack tests. [I once bisected a suite of full-stack tests into two distinct suites: one of backend services and one of the front-end UI with faked service responses. A single 30-minute suite eventually became two 4-minute suites without sacrificing much realism.]

<a name="unit-tests"></a>
### unit tests

**What Distinguishes them?**

[Michael Feathers](http://twitter.com/mfeathers) laid down [some great rules for unit tests](http://www.artima.com/weblogs/viewpost.jsp?thread=126923) in 2005:

> A test is not a unit test if:
>
>* It talks to the database
>* It communicates across the network
>* It touches the file system
>* It can't run at the same time as any of your other unit tests
>* You have to do special things to your environment (such as editing config files) to run it.

**Examples?**

* A test sets up its subject under test with real instances of collaborator dependencies, then exercises the subject, allowing calls through to its depended-on components.
* A test employs test doubles, but only at system boundaries; the SUT may have a collaborator that has a collaborator which, in turn, accesses a database. A unit test for the SUT may take it upon itself to fake the interaction between its very remote neighbor and the database.

**Advantages?**

* Unit tests provide faster feedback than coarser tests, which accelerates test-driven development and fail faster during builds.
* Unit tests typically call through to the actual collaborators, which can sometimes help catch bugs as they're introduced. Suppose Unit A calls through to Unit B. In changing Unit B's behavior, we may drive changes through Test B, but as we run our broader suite, Test A should fail if our change to Unit B violated the assumptions Unit A made of Unit B.

**What makes them hard?**

* Every unit test has to deal with the setup complexity of each of its subject's collaborators; ideally, each individual unit will only have a small number of collaborators, but even tests covering clean code can easily become bogged down by the concerns of collaborators-of-collaborators (like the second example above, where the unit test needs to concern itself with faking interactions with a database, even though it's not a direct concern of the subject).
* The value of unit tests as bug-catchers is usually overrated. In my own experience, it's rather rare for—given the example above—Test A to catch an unanticipated bug introduced by a change to Unit B. Additionally:
	* When Test A allows its SUT to call through to Unit B, the contract between them is usually implied and not abundantly clear. As a result, even in the rare event that Test A catches such a bug, the nature of the failure isn't necessarily apparent.
	* Coarser test types will more reliably catch bugs pertaining to the interaction between units. Moreover, I find that the nature of a coarser test's failure is usually more apparent than a culprit's collaborators' unit tests.

**When should I write them?**

* When the subject extends (or is otherwise inextricably linked to) a framework class and isolating the subject from the entirety of the framework is impractical.
* When writing a test for a unit that serves as an adapter between the application code and a third party library, I'll write a unit test that calls through to the third-party library (sort of like a contract-test, but against the application's adapter; not directly against the third-party code).
* When you're not equipped with a concise, intent-revealing way to manage test doubles. In most situations, however, a solid test double library ought to be available—and when one is, I prefer isolation tests over unit tests, which we'll discuss next.

<a name="isolation-tests"></a>
### isolation tests

**What Distinguishes them?**

Isolation tests are unit tests with the added constraint that the SUT is not allowed to call through to any *real* depended-on components. This is typically achieved by using test doubles to isolate the subject from its collaborators.

**Examples?**

* An object in a geolocation system is given a mailing address, leverages another component to look up the address's [ZIP+4](http://en.wikipedia.org/wiki/ZIP_code#ZIP.2B4), and finally persists the address to a repository. An isolation test would replace the ZIP+4 service and the repository components with test doubles, stub the response of the ZIP+4 lookup query for the given address, and verify that the SUT saves an address to the repository in such a way that the stubbed ZIP+4 code is incorporated properly.

**Advantages?**

* Like unit tests, isolation tests provide fast feedback.
* Good isolation tests fully describe the contract between the SUT and its collaborators, playing a role that's akin to language features like interfaces. An author should be able to write an alternative implementation of any collaborator by using a SUT's isolation tests as a guide.
* Per the above, I've found that isolation testing forces me to think harder about how my objects interact with each other. And there's no greater value I derive from test-driven-development than being forced to think hard about how code ought to work.
* While isolation tests are minimally realistic, they are maximally portable. It's incredibly easy to extract any number of objects *along with all of their isolation tests* and publish them as a fully-covered external library. In such a situation, the only costs of extracting a reusable library are a new suite of full-stack tests and documentation.

**What makes them hard?**

* Often, *absolute* isolation is tedious to attain and the sensible course of action is to allow some calls to real collaborators to be made by the subject. Most frequently, I'll allow the SUT to make calls through to very basic "utility" code, where the value of using a test double in place of, say, a utility that trims whitespace could actually decrease the clarity of the test code.
* When new to isolation testing, it's easy to lose sight of the maxim "specify behavior over implementation"; the challenge of any test is to specify how the SUT should behave under certain conditions to a *normal* observer. Related:
	* Using a test double to verify that a subject makes an interaction in a situation in which an observable side effect could also have been asserted is an example of specifying the subject's implementation over its behavior.
	* Though they're often seen as necessary compromises initially, the cognitive overhead of reading test code that employs [partial mocks](http://monkeyisland.pl/2009/01/13/subclass-and-override-vs-partial-mocking-vs-refactoring/) almost always results in tests that would be easier-to-maintain as regular unit tests.

**When should I write them?**

* When practicing test-driven design.

# in conclusion

It's important to note that these "types" are not wholly discrete entities, but should merely serve as signposts along a wide spectrum. One type of test is not universally "better" than another, as the peculiarities of each situation will usually demand pragmatic, contextual decisions about what blend of tests provide the best balance of realism and feedback speed.

It's also worth cautioning, however, that there's a dangerous, murky swamp representing many of the permutations that carelessly mix-and-match the characteristics of the above types. For example, a test author might decide to allow a subject to call through to an actual database but also replace some of the subject's depended-on-components with test doubles. It's likely that such a test would represent the worst of all worlds: it would likely be so convoluted that it would serve as poor documentation of the subject's behavior; its use of test doubles would sacrifice realism; and its invocation of potentially resource-intensive dependencies would sacrifice its speed.

Personally, I'm constantly trying to answer two questions when I think about my applications' tests:

 * How can I best ensure that my application is working under real-world conditions?
 * How can I maximize the speed of my feedback loops so that I can make more progress in less time?

The problem, of course, is that **no single type of test can answer both questions well**. Remote full-stack tests are undoubtedly the most realistic, but they're also sure to be the slowest. Meanwhile, unit and isolation tests certainly offer the fastest feedback, but they offer the least assurance that the broader application works.

As a result, I can't escape the solution of two concentric loops: one suite of maximally realistic tests, one suite of maximally isolated tests, and **very little in-between**.
