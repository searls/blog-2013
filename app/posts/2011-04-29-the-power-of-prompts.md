<p><em>This post is partly in response to to <a href="https://twitter.com/#!/chrisjpowers/status/53515639725375489" target="_blank">this tweet</a>, and partly a follow-up to a <a href="https://twitter.com/#!/searls/status/63437730268450817" target="_blank">teaser I tweeted</a> earlier this week.</em></p>
<p>We humans are suckers for suggestion. If you need evidence of this, consider something as seemingly innocuous as <a href="http://www.fivethirtyeight.com/2009/10/question-order-may-bias-fox-news-health.html" target="_blank">the order in which we ask people questions</a>.</p>
<p>If I were to ask you: </p>
<blockquote>
<p>1. Does the following web site load properly in your browser? Make sure all the pictures load: <a href="http://cuteoverload.com/tag/bunnies" target="_blank">cuteoverload.com</a></p>
<p>2. Do you support the euthanasia of stray bunnies brought to animal shelters?</p>
</blockquote>
<p>Mere intuition confirms that prompting respondents to peruse photos of adorable bunnies would influence the results of a question regarding the appropriate fate of stray bunnies. (I&#8217;m convinced that pollsters regularly do this intentionally to achieve a desired result for clients with seemingly-fair questions.)</p>
<p>In the field of software development, we have ample opportunity to prompt the behavior of others as well as ourselves. In this post, I&#8217;d like to briefly discuss a few. I&#8217;ll start with some negative consequences of inadvertent prompting, and pivot into some positive consequences of intentional, thoughtful prompting.</p>
<p><strong>Anchoring Estimates</strong></p>
<p>One well-established type of prompting on agile development teams is that of <a href="http://en.wikipedia.org/wiki/Planning_poker#Avoid_anchoring" target="_blank">estimate anchoring</a>—that is, one&#8217;s knowledge of what others have estimated as the size of a particular <a href="http://www.extremeprogramming.org/rules/userstories.html" target="_blank">story</a> will almost certainly affect one&#8217;s own estimate.</p>
<p>When anchoring occurs, an estimate that equally blends the perspectives of each team member is no longer attainable. What you get instead is a much less valuable <em>consensus reaction</em> to the first (or loudest) team member&#8217;s perspective. </p>
<p><strong>Pressuring Knowledge Workers</strong></p>
<p>I once saw a team&#8217;s <a href="http://www.pillartechnology.com/content/webinardetail/id/12" target="_blank">Product Owner</a> use the <a href="http://martinfowler.com/articles/itsNotJustStandingUp.html" target="_blank">morning standup</a> as an opportunity to actively manage the team&#8217;s developers. Each developer reporting anything short of unfettered success was interrupted and subsequently peppered with questions like, &#8220;Your story is easy right?&#8221;, &#8220;It&#8217;ll be done by 3 PM for the demo to the executive council, right?&#8221;, and &#8220;What&#8217;s taking you so long?&#8221;</p>
<p>That is to say, each developer&#8217;s morning got started with a prompt of, &#8220;you&#8217;re not going fast enough! What&#8217;s wrong with you?&#8221;</p>
<p>Needless to say, this prompt did not serve the product owner&#8217;s goal (which, and I&#8217;m being really generous here, was to accelerate the product&#8217;s development).</p>
<p>Instead, the team responded as anyone under pressure would: their brains turned off. From Andy Hunt&#8217;s absolutely incredible <a href="http://pragprog.com/titles/ahptl/pragmatic-thinking-and-learning" target="_blank">Pragmatic Thinking &amp; Learning</a>:</p>
<blockquote>
<p>But when the mind is pressured, it actively begins shutting things down. Your vision narrows—literally as well as figuratively. You no longer consider options.</p>
</blockquote>
<p>Corners got cut. Collaboration ceased. Creative and counter-intuitive solutions were no longer visible, so they couldn&#8217;t be considered. Instead, the team produced increasingly procedural, poorly-factored, and untested spaghetti code. And the deadlines were still missed.</p>
<p>Teams in low-pressure environments, on the other hand, may also not go as fast as their management would like them to; however, they&#8217;re far more likely to produce reusable, well-factored, and fully-tested clean code.</p>
<p>The difference, therefore, is that a team prompted with high-pressure demands will <em>decelerate</em> over time (as they cope with the mess they&#8217;ve made), while a low-pressure team will <em>accelerate</em> over time (as they expand on the clean code they&#8217;ve built).</p>
<p><strong>Behavior-Driven Development</strong></p>
<p>In my opinion, <a href="http://en.wikipedia.org/wiki/Behavior_Driven_Development" target="_blank">BDD</a> was born out of a respect for the power of prompts. From <a href="http://dannorth.net/introducing-bdd/" target="_blank">Dan North&#8217;s blog post</a> introducing the term:</p>
<blockquote>
<p>Then I came across the convention of starting test method names with the word “should.” This sentence template – The class should do something – means you can only define a test for the current class. This keeps you focused. If you find yourself writing a test whose name doesn’t fit this template, it suggests the behaviour may belong elsewhere.</p>
</blockquote>
<p>In that example, the developer follows a particular motion to prompt himself to focus on what he&#8217;s trying to specify.</p>
<p>The above approach addresses one of the shortcomings of &#8220;plain ol&#8217; <a href="http://jamesshore.com/Blog/Red-Green-Refactor.html" target="_blank">TDD</a>,&#8221; which is that it begs the question, &#8220;how do I know that I&#8217;ve written enough tests?&#8221; without giving a clear answer. In contrast, by talking about tests as a specification of behavior, it becomes abundantly obvious when you&#8217;ve written enough tests: in each relevant context, the thing you&#8217;re building does everything it apparently <strong>should</strong> do, and nothing more. Put another way: one knows they are done when they write the word &#8220;should&#8221; then, staring blankly at their monitor, finally realize that there&#8217;s nothing else the subject code should do.</p>
<p>This original observation has given birth to a veritable treasure trove of other practices, and as a result the BDD banner has expanded quite a lot since 2006. In fact, <a href="http://pragprog.com/titles/achbd/the-rspec-book" target="_blank">The RSpec Book</a> makes the case for BDD as a full-blown &#8220;second-generation Agile methodology.&#8221; Ultimately, they summarize BDD as a rhythm:</p>
<blockquote>
<p>The day-to-day rhythm of delivery involves decomposing requirements into features and then into stories and scenarios, which we automate to act as a guide to keep us focused on what we need to deliver. These automated scenarios become acceptance tests to ensure the application does everything we expect.</p>
</blockquote>
<p>The above acknowledges something that traditional software project management does not: that building software isn&#8217;t like working on a factory line. If I&#8217;m building a car and the chassis has everything but a door on it, I have a very clear prompt of what I need to do next. But the ephemeral nature of software is a double-edged sword—after finishing something, we can literally do anything we&#8217;d like to next! What <em>should</em> come next, however, is a question that doesn&#8217;t necessarily answer itself for a software developer.</p>
<p>Dan&#8217;s &#8220;should&#8221; prompt works at the object level, but what about after we&#8217;ve finished our object? What then?</p>
<p>The RSpec Book addresses this by zooming out, turning the problem on its head, and prescribing &#8220;outside-in&#8221; software development, which defines multiple layers of activities. This enables each team member to answer questions like &#8220;why am I doing what I&#8217;m doing?&#8221; and &#8220;what should I do next?&#8221; with the following traceable rhythm: </p>
<ol><li>Potential value that software could deliver on is identified, which prompts:</li>
<li>Stakeholders to identify a minimum feature set that could realize that value (at <a href="http://pillartechnology.com" target="_blank">Pillar</a>, we call these &#8220;Value Stories&#8221;), which prompts:</li>
<li>Each stakeholder to articulate each feature as a set of scenarios that serve as a sort of script for the behavior of the software, which prompts: </li>
<li>A developer to automate each step in a scenario with a tool like <a href="http://cukes.info/" target="_blank">Cucumber</a>; when the scenario fails (remember, the code doesn&#8217;t exist yet!), it prompts:</li>
<li>A developer to specify the behavior of application code with a tool like <a href="http://relishapp.com/rspec" target="_blank">RSpec</a> or <a href="http://pivotal.github.com/jasmine/" target="_blank">Jasmine</a>; when the spec fails, it prompts:</li>
<li>The developer to implement the code to make the spec pass, prompting them to <a href="http://en.wikipedia.org/wiki/Code_refactoring" target="_blank">refactor</a> the code and then either repeat Step #4 if the scenario now passes or Step #5 if it does not.</li>
</ol><p>So to <a href="https://twitter.com/#!/chrisjpowers" target="_blank">Chris Powers</a>&#8217; original statement, &#8220;I&#8217;ve chalked [BDD] up to semantics at this point,&#8221; my response is: &#8220;Indeed!&#8221; And what started with semantics for better-defining code behavior has organically evolved into a complete approach to delivering value to stakeholders.</p>
<p>The fact that BDD is fundamentally all about semantics does not trivialize it, because our susceptibility to semantics influences everything from what we build to how efficiently we build it. And once we recognize the power of semantics when prompting our own behavior, we can use it to our advantage! </p>
<p><strong>Verb-first Classes, or &#8220;Where does this code go?&#8221;</strong></p>
<p>After a very successful morning building a little Java framework for my client I <a href="https://twitter.com/#!/searls/status/63437730268450817" target="_blank">tweeted</a> the following, and I want to expand on it here as an example of using a rule-of-thumb to prompt myself to write cleaner code: </p>
<blockquote>
<p>Wrote a whole app using verb-noun class names (e.g. PerformsQuery) and it magically enforced SRP &amp; niladic/monadic methods! </p>
</blockquote>
<p>A question programmers ask themselves dozens of times a day is, &#8220;okay, the app needs to do _____ next; where should I put the code?&#8221;</p>
<p>Perhaps an existing component should be changed to incorporate the new functionality. Perhaps something entirely new should be built. What I&#8217;ve observed is that the names of things that already exist greatly influence how we answer that question. </p>
<p>In <a href="http://en.wikipedia.org/wiki/Object-oriented_programming" target="_blank">object-oriented programming</a>, names of objects are usually nouns. And traditional examples of OOP are often completely unmodified nouns meant to model some real-world analogue (like &#8220;Dog&#8221;, &#8220;Car&#8221;, etc.).</p>
<p>To illustrate, let&#8217;s say we name an object &#8220;Bunny&#8221;. Naïvely, I started describing bunnies in a Ruby file for about 45 seconds and came up with:</p>
<script src="https://gist.github.com/948558.js?file=bunny.rb"></script>
<p>45 seconds and already the Bunny class is a dumping ground of numerous responsibilities. This class obviously <a href="http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod" target="_blank">violates the SOLID &#8220;object-oriented-design&#8221; principles outlined by Uncle Bob</a>, especially the <a href="http://www.objectmentor.com/resources/articles/srp.pdf" target="_blank">Single Responsibility Principle</a>. </p>
<p>Most developers have a hard time consistently writing lean, mean code that adheres to the SRP. Why? Because they keep naming classes as nouns like Bunny!</p>
<p>How so? Because, like clockwork, this scenario unfolds:</p>
<ol><li>User story is written, &#8220;In order to survive, as a bunny, I want to eat carrots&#8221;</li>
<li>Create an object named &#8220;Bunny&#8221;</li>
<li>Implement the carrot-eating behavior in Bunny</li>
<li>&#8230;Time elapses&#8230;</li>
<li>User story is written, &#8220;In order for the species to survive, as a bunny, I want to make new bunnies&#8221;</li>
<li>Ask &#8220;where should the code about bunny mating go?&#8221;</li>
<li>Search existing components</li>
<li>Find a Bunny class</li>
<li>Think, &#8220;Aha, Bunny! It should go there!&#8221;</li>
<li>Implement the mating behavior in Bunny</li>
<li>The Universe, seeking equilibrium upon the introduction of this SRP violation, murders a bona fide real-world bunny.</li>
</ol><p>Now, one popular attempt to combat this pattern is to name objects as &#8220;noun-responsibility&#8221; phrases, but in my experience it has fallen short of solving the problem. In theory, the above stories may have resulted in separate &#8220;BunnyFeeder&#8221; and &#8220;BunnyMater&#8221; classes. In practice, however, I&#8217;ve seen this naming convention regularly result instead in &#8220;BunnyFeeder&#8221; being refactored into something more generic (like &#8220;BunnyManager&#8221;) just so that it can incorporate both behaviors.</p>
<p>At <a href="http://scna.softwarecraftsmanship.org/" target="_blank">SCNA 2010</a>, <a href="http://www.coreyhaines.com/" target="_blank">Corey Haines</a> turned me on to a verb-first naming pattern that I&#8217;ve since adopted and had a lot of success with—presumably because the responsibility of the class becomes its primary designation. Since the noun it acts on is only secondary, I&#8217;m less inclined to presume that new responsibilities belong in existing classes.</p>
<p>So, given a &#8220;FeedsBunnies&#8221; class, it wouldn&#8217;t even cross my mind to try sticking mating behavior in there. And upon not finding an existing component to incorporate mating behavior, I&#8217;d be more inclined to write a new &#8220;MatesWithBunnies&#8221; class.</p>
<p>This, even though nothing changed except the word order! It may only be semantics, but it seems to work well enough for me.</p>
<p>[Another bonus is that I&#8217;m no longer hung up a dozen times a day trying to think of a way to end a noun-responsibility name in &#8220;-er&#8221; that doesn&#8217;t sound awkward. I mean, &#8220;BunnyMater?&#8221; Really?]</p>
<p>Thoughts? Please, <a href="http://twitter.com/searls" target="_blank">Tweet&#8217;em</a>! (Or e-mail&#8217;em; it&#8217;s searls AT gmail.)</p>
