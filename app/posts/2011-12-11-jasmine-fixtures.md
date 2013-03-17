**Update** 2/5/2012: replaced the jasmine-fixture description with examples using the current "affix()" API method.

One of the questions I'm frequently asked about test-driven development with [Jasmine](https://github.com/pivotal/jasmine/wiki) is a variation of, "how do I get my specs to see my HTML?" It's a completely fair question: JavaScript very often inspects or manipulates the DOM, so having a way to arrange the DOM's state with HTML is critical to writing tests.

My goal this morning is to explain why exactly I recommend against loading HTML fixtures *from external files* when writing unit tests.

At the heart of this issue: Jasmine's familiar RSpec-like syntax belies the newness of other aspects of writing user interface code for a browser. Most RSpec users come from Rails, where a "view" is just a static HTML artifact, as opposed to a dynamic, stateful component that's central to the user's experience. Writing clean specs for situations like asynchronous event callbacks and DOM interactions takes some thoughtfulness and practice.

And so it is with this fixture problem.

When people ask me this question they usually come from one of two perspectives:

* How can my JavaScript specs share *exactly* the same JSP/ERB/ASP/PHP templates my server application uses?

* How can my specs see markup that I load from a test-specific HTML fixture file?

## loading server-side templates

The first question is a superset of the second, so I'll tackle it first: requiring a server runtime to run unit tests of your client-side code is not a good idea.

1. From the get-go, it would couple your client-side application code to the server. Well-crafted JavaScript should enable you to establish a healthy distance between the client and the server implementations, but coupling your specs to server-side template logic (much less its database) would hamper that goal from the start.

2. That approach sounds really slow. Jasmine specs are *fast* (and as browsers continue to optimize for JavaScript performance, they're only getting faster). I've been on several projects that have accumulated thousands of Jasmine specs, and I've never had a suite take longer than three or four seconds to run. Slowing feedback loops for convenience is exactly how we ended up with Rails "unit" tests that all require a server runtime and a connection to the database.

## loading *any* HTML files

So once I've shot down the dream of processing server-side templates for use in Jasmine specs, the next question I hear is usually "well, how do I load flat HTML files in my specs?"

At the risk of demoralizing the hypothetical question-asker, I don't like doing this either. Here's why:

1. If a spec references an external HTML file, I can't read the spec code and understand it entirely without also reading the external HTML file.

2. Gigantic HTML files don't inflict much pain. As long as I'm writing HTML into a separate file, it won't pain me to shamelessly rip my entire page from Chrome's Web Inspector and paste it into a flat HTML file. But if I'm in the habit of defining my HTML fixtures inline with my spec code, I'm under a *very healthy pressure* to keep that code to a minimum, because after a few lines it's just noisy and distracting.

3. Shared fixtures of any type usually represent a [tragedy of the commons](http://en.wikipedia.org/wiki/Tragedy_of_the_commons). Everyone is happy to add to the fixture as their spec needs, but no one feels empowered to tidy up the fixture. The size of shared fixtures only increases with time. So, per point #1 above, when a reader is trying to understand a spec, he's going to need to reference the shared fixture; but when he loads the shared fixture, it will be so complex and confusing that he'll have no hope of understanding its relationship to the spec. As a result, the *contract between the JavaScript code and the DOM will never be clear* to anyone.

4. Large, shared, external HTML fixtures only serve to encourage JavaScript specs (and source) to be tightly coupled to a very complex DOM. Clean JavaScript minimizes the number of assumptions it makes about the state of the DOM. Writing specs with lean, inline HTML fixtures are a *fantastic opportunity* to accomplish that goal, and loading external HTML fixture files actively work against it.

## inline fixtures

I define my HTML fixtures inline with the rest of my spec setup code. When I was first getting started with Jasmine, I used to do something like this:

    var $container;
    beforeEach(function(){
      $container = $('<div class="container"></div>').appendTo('body');
    });
    afterEach(function(){
      $container.remove();
    });

Yuck. That's pretty noisy. Nobody likes writing HTML inside of strings, and the afterEach is annoying to keep track of, as well.

So I wrote a little helper for myself called [jasmine-fixture](https://github.com/searls/jasmine-fixture), and it allows a much lighter-weight definition of fixtures:

    var $container;
    beforeEach(function(){
      $container = affix('.container');
    });

By default, jasmine-fixture's `affix` method takes a string, which it will use to go and create elements on the DOM such that the very same string could be used as a jQuery selector. The goal is to be as compact as possible without requiring a significant context switch for the user. After the spec runs, it'll clean out everything that's been added to the DOM.

It allows slightly more complex interactions, as well:

    var $input;
    beforeEach(function(){
      $input = affix('.container form[id=myForm] input[value=42]')
    });

The above will add elements that look something like this:

    <div class="container">
      <form id="myForm">
        <input value="42"/>
      </form>
    </div>

Obviously, the plugin allows for more terse fixture definition then pasting raw HTML into concatenated strings. What's more, it encourages simple contracts between markup and code. A class name is usually plenty to select on, and the fact that the spec isn't even specifying a `<div/>` sends the message that the JS may even work with other block element types. (For more complex situations, `affix()` can also be used as a jQuery plugin on existing jQuery objects, appending children beneath them.)

