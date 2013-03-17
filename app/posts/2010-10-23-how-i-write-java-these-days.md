<p>Over the last year, I&#8217;ve made an effort to better identify the styles, idioms, and smells I encounter when reading and writing new Java code. [And, already, a takeaway point! To some of my more successfully sheltered rubyist friends, it may be sorry news to hear that there continues to be new Java code written.]</p>
<p>In any case, I&#8217;ve made a concerted effort to internalize habits that I find valuable and to develop a reflex to resist those which I do not. This will be my first effort at documenting either, so I&#8217;ll just express them in terms of how my Java looks these days, replete with code snippets as needed.</p>
<p>My real goal in documenting any of this publicly is to have a page that I can easily cite whenever I begin working with a new colleague to develop software using Java. I presume it will either help him (or her) identify the path of least argumentation or, alternatively, provide a platform by which to scheme to the ends of changing my mind toward a better way of doing something. Either of those outcomes are welcome. To everyone else, you too may find something worth either adopting or <a href="http://twitter.com/searls" target="_blank">calling me out</a> on. </p>
<p>As if this post required fewer than a dozen other caveats, I will mention that much of what I say here may only apply to <a href="http://www.oracle.com/index.html" target="_blank">Java</a> development, and may even then only apply to <a href="http://en.wikipedia.org/wiki/Greenfield_project" target="_blank">greenfield</a> Java, as opposed to <a href="http://www.amazon.com/Working-Effectively-Legacy-Michael-Feathers/dp/0131177052" target="_blank">existing code without tests</a>.</p>
<h2>1. Achieve isolation with low-friction, generated test doubles</h2>
<p>My highest priorities when I write a unit test are achieving <a href="http://www.javaranch.com/journal/200603/EvilUnitTests.html" target="_blank">utter isolation</a>, testing <a href="http://xunitpatterns.com/Principles%20of%20Test%20Automation.html#Use%20the%20Front%20Door%20First" target="_blank">the front door first</a>, minimizing the cost of creation, maximizing readability, and ensuring that change remains cheap.</p>
<p>In response to the first of those priorities, my current mode of operation is to use <a href="http://code.google.com/p/mockito/" target="_blank">Mockito</a> to isolate my <a href="http://xunitpatterns.com/SUT.html" target="_blank">SUT</a>.</p>
<p>I&#8217;ve become more careful to use the term <a href="http://xunitpatterns.com/Test%20Double.html" target="_blank">test double</a> appropriately as opposed to calling every generated double a &#8220;mock&#8221;, as most early Java &#8220;mocking&#8221; frameworks were actually born from the school of <a href="http://connextra.com/aboutUs/mockobjects.pdf" target="_blank">endotesting</a> where they <em>actually mean for</em> <a href="http://xunitpatterns.com/Mock%20Object.html" target="_blank">mock objects</a> to blow up in your face every time your SUT interacts with them in a way not anticipated by your test. Tools that force developers to specify so much low-value setup for each test case has naturally led to a backlash in support of &#8220;<a href="http://martinfowler.com/articles/mocksArentStubs.html" target="_blank">classical TDD</a>&#8221; and witty presentations about how &#8220;<a target="_blank" href="http://www.codedexterity.com/presentations/mocks_suck_jruby">mocks suck</a>.&#8221; Mockito, despite its name, simply generates the tabula rasa of test doubles until you choose to <a href="http://xunitpatterns.com/Test%20Stub.html" target="_blank">stub</a> some behavior. I appreciate <a href="http://blog.dannorth.net/2008/09/14/the-end-of-endotesting/" target="_blank">Dan North&#8217;s take</a> on the issue.</p>
<p>Here&#8217;s an example of how some of my test setup might look if I were building a salesman selling <a href="http://www.shardsoglass.com/" target="_blank">shards &#8216;o&#8217; glass</a> pops, using Mockito: </p>

<script src="https://gist.github.com/642277.js?file=ShardsOGlassSalesmanTest.java"></script>

<p>What do I like about <a href="http://code.google.com/p/mockito/" target="_blank">Mockito</a> over <a href="http://www.jmock.org/" target="_blank">its</a> <a href="http://easymock.org/" target="_blank">alternatives</a>? Well,</p>
<ul><li>Its authors hold <a href="http://docs.mockito.googlecode.com/hg/org/mockito/Mockito.html" target="_blank">great opinions</a> that foster the user&#8217;s learning about isolation testing for <a href="http://en.wikipedia.org/wiki/Test-driven_development" target="_blank">TDD</a></li>
<li>Setup is minimal enough to make class creation cheap, but not so invisible as to be <a href="http://en.wikipedia.org/wiki/Clarke's_three_laws" target="_blank">indistinguishable from magic</a></li>
<li>No goofy <a href="http://stackoverflow.com/questions/650494/mocking-using-traditional-record-replay-vs-moq-model" target="_blank">record-playback</a> metaphor to inhibit arrange-act-assert</li>
<li>Even in large projects, custom test-scope classes are rarely necessary, keeping change cheap</li>
</ul><p>Another benefit: it discourages folks from wasting brain cycles determining whether to achieve isolation from every single <a href="http://xunitpatterns.com/DOC.html" target="_blank">depended-on-component</a> or settle for pseudo-<a href="http://c2.com/cgi/wiki?FunctionalTest" target="_blank">functional tests</a>, because Mockito&#8217;s annotation-based test setup is actually easier than instantiating all the SUT&#8217;s dependencies oneself.</p>
<h2>2. Test the front door first (and then nail all the other doors shut)</h2>
<p>I treat my test as the first customer of my class, and as a result I never-not-ever provide my test with a means of <a href="http://xunitpatterns.com/Back%20Door%20Manipulation.html" target="_blank">backdoor manipulation</a>. As a result, I always test-drive the responsibility of the class through its (often only one) public method(s).</p>
<p>An example smell I frequently see indicating that someone doesn&#8217;t recognize <a href="http://giorgiosironi.blogspot.com/2010/02/testing-private-members.html" target="_blank">this rule</a>, is to find a protected or package-private method in the SUT whose visibility was obviously only increased for the benefit of making a test easier to set up. Note the package-private helper method here:</p>

<script src="https://gist.github.com/642384.js?file=Wallet.java"></script>

<p>I&#8217;ve even seen code that apparently agrees that modifying a method&#8217;s visibility on the SUT for this purpose is a bad idea, but then takes a turn in an even harder-to-refactor direction by using <a href="http://stackoverflow.com/questions/34571/whats-the-best-way-of-unit-testing-private-methods" target="_blank">reflection to test a private method</a>. There simply aren&#8217;t <a href="http://twitter.com/joefiorini/status/26204347380" target="_blank">enough unicorns left in the world</a> to stand by and let that happen. </p>
<h2>3. Don&#8217;t write static methods</h2>
<p>The first day I worked with <a href="http://www.google.com/profiles/rdammkoehler" target="_blank">Rich Dammkoehler</a> earlier this year, he laid down the law: no static methods. I normally don&#8217;t appreciate broad dictates telling me not to use a major language construct, but this one makes sense to any practitioner of TDD that craves unit test isolation. It&#8217;s also an easier pill to swallow if you plan to lean on a <a href="http://en.wikipedia.org/wiki/Inversion_of_control" target="_blank">dependency injection</a> framework like <a href="http://code.google.com/p/google-guice/" target="_blank">Guice</a> or <a href="http://en.wikipedia.org/wiki/Spring_Framework" target="_blank">Spring</a>, since nabbing a singleton instance of a class isn&#8217;t much harder than referencing it statically.</p>
<p>Why are static methods bad? Google testing blog did a great job outlining why <a href="http://googletesting.blogspot.com/2008/12/static-methods-are-death-to-testability.html" target="_blank">static methods make isolation testing hard</a>.</p>
<h2>4. Wrap those static methods that you do need</h2>
<p>When I was writing the <a href="http://github.com/searls/jasmine-maven-plugin" target="_blank">jasmine-maven-plugin</a>, I started by failing to test(!) numerous methods that relied on static methods provided by a <a href="http://commons.apache.org/io/api-1.4/org/apache/commons/io/FileUtils.html" target="_blank">FileUtils</a> class. As my guilt increased, I moved onto using <a href="http://code.google.com/p/powermock/" target="_blank">PowerMock</a>, as <a href="http://twitter.com/pyruby/status/24031748553" target="_blank">icky an experience</a> as that can be.</p>
<p>If I had it to do again, I would have wrapped whatever I needed from the FileUtils class with plain ol&#8217; instance methods, so my PowerMock usage could have been limited to a single place, rather than spread like a plague along with my usage of the static method. I imagine that I&#8217;d specify such a wrapper as follows:</p>

<script src="https://gist.github.com/642467.js?file=FileUtilsWrapperTest.java"></script>

<h2>5. JavaScript is code too, so test-drive it</h2>
<p>I&#8217;ve been singing this song for a while, but at this point in history—where applications that differentiate themselves do so with an exemplary front-end user experience, as opposed to immaculate backend code—placing an emphasis on well-crafted JavaScript is critical to success.</p>
<p>To any web developer, I strongly recommend adopting <a href="http://pivotal.github.com/jasmine/" target="_blank">Jasmine</a>, which is delightfully expressive and is starting to reach critical mass. To Java web developers in particular, take a look at my <a href="http://github.com/searls/jasmine-maven-plugin" target="_blank">jasmine-maven-plugin</a>, which you can use to get started with JavaScript testing extraordinarily quickly (and if extraordinary isn&#8217;t fast enough, try playing with the plugin&#8217;s <a href="http://github.com/searls/jasmine-archetype" target="_blank">jasmine-archetype</a>). </p>
<p>If you require yet more exhortation to start testing-driving your JavaScript, check out my recent presentation on<a href="http://www.slideshare.net/searls/javascript-craftsmanship-why-javascript-is-worthy-of-tdd" target="_blank"> JavaScript Craftsmanship</a>.</p>
<h2>6. Convention &gt; Configuration (with annotations) &gt; Configuration (with XML)</h2>
<p>I almost hesitate to advocate using annotations, because the Java crowd still doesn&#8217;t seem to quite grok the lesson of <a href="http://en.wikipedia.org/wiki/Convention_over_configuration" target="_blank">convention over configuration</a>, but whenever the choice comes down to annotations or XML, I&#8217;ll choose the locality and readability of annotations every time.</p>
<p>The primary discomfort I&#8217;ve witnessed among developers regarding annotations is that they exist in this murky ether, halfway between code and configuration. That ambiguity led <a href="http://twitter.com/mikelikesbikes" target="_blank">Mike Busch</a> and I to test-driving the placement of Java annotations (and we had success writing <a href="http://code.google.com/p/hamcrest/wiki/Tutorial" target="_blank">custom Hamcrest matchers</a> to specify @Action and @Result in Struts apps). I&#8217;m thinking about publishing a library of annotation-based matchers for common situations; <a href="http://twitter.com/searls" target="_blank">let me know</a> if you&#8217;re interested in pairing with me to make that happen.</p>
<h2>7. I agree, getter/setter code sucks, but keep your members private anyway.</h2>
<p>Believe me, I understand the underlying sentiment when I see code that looks like this:</p>

<script src="https://gist.github.com/642489.js?file=BoxOfGlassPops.java"></script>

<p>I hesitate to abide this for a couple reasons. First, <a href="http://www.oracle.com/technetwork/java/codeconventions-137265.html#177" target="_blank">non-private members are usually counter-conventional</a>. Second, especially for classes intending to encapsulate the state of something, the ubiquity of the <a href="http://en.wikibooks.org/wiki/Java_Programming/Java_Beans" target="_blank">JavaBeans spec</a> has led numerous libraries to require your objects be JavaBeans compliant.</p>
<p>This is not to mention that raising the visibility of your member fields makes an even bigger mess of a class&#8217;s <a href="http://en.wikipedia.org/wiki/Encapsulation_(object-oriented_programming)" target="_blank">encapsulation</a> than blindly generating a getter &amp; setter for every field (an act that&#8217;s also usually unwarranted).</p>
<h2>8. Bury getters &amp; setters</h2>
<p>As alluded to above, accessor and mutator methods are perhaps the least informative code in any given class, so why place them prominently in your class&#8217;s listing, bogging down your reader?</p>

<script src="https://gist.github.com/642526.js?file=ShardsOGlassSalesman.java"></script>

<p>I regularly find myself moving them to the bottom of a class, getting them out of the way for the benefit of others.</p>
<h2>9. Never write another assertEquals()</h2>
<p>Vanilla JUnit assertions like this one are still nearly ubiquitous in new Java code:</p>

<script src="https://gist.github.com/642545.js?file=WalletTest.java"></script>

<p>How can you blame the author above for forgetting that the first parameter of assertEquals is supposed to be the expected (as opposed to actual) value? I certainly can&#8217;t. It&#8217;s hardly apparent that the correct ordering is this:</p>

<script src="https://gist.github.com/642548.js?file=AssertEquals.java"></script>

<p>Even if the above method signature were well known to all of us, it still wouldn&#8217;t be particularly expressive. <a href="http://code.google.com/p/hamcrest/" target="_blank">Hamcrest</a> offers a much more obvious, readable style of assertion&#8212;and manages to retain that style even for asserting arbitrarily complex facts by way of custom matchers. I struggle to imagine anyone finding assertEquals to be more clear than this:</p>

<script src="https://gist.github.com/642563.js?file=assertThat.java"></script>

<h2>10. Write readable tests that follow Arrange-Act-Assert</h2>
<p>The <a href="http://c2.com/cgi/wiki?ArrangeActAssert" target="_blank">arrange-act-assert</a> pattern is greatly helpful in encouraging minimal, readable test cases. I&#8217;ll typically try to minimize the number of &#8220;arrange&#8221; lines, keep my &#8220;act&#8221; to a single line, and limit myself to a single &#8220;assert&#8221; line when I can. I also separate each phase with a newline to make my intentions dead-obvious.</p>
<p>Using this as a convention leads to terrifically simple tests, like this one:</p>

<script src="https://gist.github.com/642586.js?file=arrangeActAssert.java"></script>

<p>In fact, I may find myself writing verbatim &#8220;assertThat(result,is(expected))&#8221; numerous times a day. It may be repetitive, but I&#8217;d take that over <a href="http://xunitpatterns.com/Obscure%20Test.html" target="_blank">obscure tests</a> any day.</p>
<h2>11. Write humane matchers to describe your most common assertions</h2>
<p>Say you&#8217;re testing a Struts application, and you very frequently find yourself testing that an action method has the side effect of adding an &#8220;action message&#8221; for the view. Sure, you could write something like this test, ad nauseam:</p>


<script src="https://gist.github.com/642596.js?file=NoMatcher.java"></script>

<p>Or, with the one-time cost of remembering how to create one, you could write a slightly more meaningful matcher like this:</p>

<script src="https://gist.github.com/642600.js?file=Matchers.java"></script>

<p>And each test case could become even more readable:</p>

<script src="https://gist.github.com/642602.js?file=CustomMatcher.java"></script>

<h2>12. Packages don&#8217;t really matter</h2>
<p>Spending significant time noodling about what belongs in which package is usually a low-value activity, and is more often mere friction getting in the way of my productivity (and happiness). If I put a class in a package and you don&#8217;t like it, move it. I mean no offense—you may just care more about this than I do.</p>
<h2>13. Even if packages matter to you, they shouldn&#8217;t matter to your code</h2>
<p>Code that breaks when it moves from one package to another is an obnoxious type of coupling enabled by the Java language, and is almost always the result of either aimless or too-clever designs.</p>
<p>I don&#8217;t mind at all if a project&#8217;s package naming &amp; hierarchy is your carefully-tended zen garden, but I have yet to witness a design benefit from restricting a member&#8217;s visibility to only classes with the same package name. As a result, I usually interpret package-private <em>anything</em> as a <a href="http://en.wikipedia.org/wiki/Code_smell" target="_blank">code smell</a> that something went wrong somewhere—most frequently, it will have been an attempt to provide a backdoor for a test, a malady discussed here elsewhere.</p>
<h2>14. No acronym is too good to be camelCased</h2>
<p>I&#8217;ll pick on the <a href="http://en.wikipedia.org/wiki/Data_Transfer_Object" target="_blank">DTO</a> moniker here, as it&#8217;s one of my least favorite vestiges of <a href="http://en.wikipedia.org/wiki/Enterprise_JavaBean" target="_blank">EJB</a>.</p>
<p>Even if I were to suffix a class with such an acronym, I&#8217;d name it in camelCase, like &#8220;GlassPopDto&#8221;.</p>
<p>Why? Because some future actor on that class always arrives later to the scene, and nobody wants to have to parse what a &#8220;GlassPopDTOBuilder&#8221; is supposed to do.</p>
<h2>15. Life is easier when you name each dependency after its class</h2>
<p>Note that I&#8217;d never advocate an honest-to-god variable be named something completely uninformative like:</p>

<script src="https://gist.github.com/642620.js?file=string.java"></script>

<p>However, I do always name my class&#8217;s dependencies after the class that represents its contract. This makes the code less surprising and <a href="http://en.wikipedia.org/wiki/Dependency_injection" target="_blank">DI</a> autowiring more idiot-proof. [I name the dependencies identically in my tests, too, so that I can refer to them without guessing or remembering some arbitrary prefix (like &#8220;mockedBoxOfGlassPops&#8221;).]</p>

<script src="https://gist.github.com/642631.js?file=InstanceNames.java"></script>

<h2>16. Ditch interfaces that will only ever have one implementation</h2>
<p>The Spring framework encouraged and really popularized coding to interfaces. That had its benefits at the time, but the lasting result was inevitable: a lonely debate over whether every single class on the planet should be named &#8220;DefaultInterfaceName&#8221; or &#8220;InterfaceNameImpl&#8221;. </p>
<p>I&#8217;ve come to believe that enforcing this platitude violates <a href="http://en.wikipedia.org/wiki/You_ain't_gonna_need_it" target="_blank">YAGNI</a>. Unless some really awesome framework requires you to do otherwise (and what awesome framework would?), test-drive a class first and extract interfaces only once they&#8217;ll facilitate some useful purpose. My experience tells me that they rarely will.</p>
<h2>17. Don&#8217;t override equals() &amp; hashCode() without reason</h2>
<p>I think it&#8217;s a natural reflex to look at a newly minted class and think to yourself, &#8220;now I&#8217;ll just override equals() and hashCode() and it will be all-grown-up.&#8221; I&#8217;ve learned to avoid this temptation, for a few reasons:</p>
<ul><li>Both methods inspire some really hard-to-read, error-prone code</li>
<li>It can be painful to test-drive all the edge cases of the contract without leaning on <a href="http://junit-addons.sourceforge.net/junitx/extensions/EqualsHashCodeTestCase.html" target="_blank">an</a> <a href="http://gsbase.sourceforge.net/apidocs/com/gargoylesoftware/base/testing/EqualsTester.html" target="_blank">external</a> <a href="http://code.google.com/p/equalsverifier/" target="_blank">library</a> to do it for you</li>
<li>It has to be maintained as the class changes</li>
<li>It&#8217;s probably not really necessary</li>
</ul><p>The last bullet—that overriding these methods is usually not necessary—is the best reason not to override them. I rarely find myself in situations where I have multiple instances of a class that are logically equivalent and also likely to bump into one another. And when I do find myself in such a situation, the objects probably have unique identifiers that I can compare, like when I&#8217;m sorting out who gets the nuts between these two squirrels:</p>

<script src="https://gist.github.com/642672.js?file=squirrel.java"></script>

<p>And even when I am in a situation where the logical equivalence of two objects matters, the means of determining that logical equivalence is often only relevant to a single user of the class, and therefore it wouldn&#8217;t be appropriate to universalize that logic by storing it in the class itself. A separate <a href="http://download.oracle.com/javase/6/docs/api/java/util/Comparator.html" target="_blank">Comparator</a> is often a better solution in these situations.</p>
<h2>18. The Statist vs. Behaviorist debate is a false dichotomy</h2>
<p>Too often I see a team room draw a line in the sand between advocates of <a href="http://xunitpatterns.com/State%20Verification.html" target="_blank">state</a> verification and those favoring <a href="http://xunitpatterns.com/Behavior%20Verification.html" target="_blank">behavior</a> verification. This strikes me as a bit of a <a href="http://en.wikipedia.org/wiki/The_Butter_Battle_Book" target="_blank">butter battle</a> sometimes, as both mechanisms are useful (necessary?) for facilitating clean production code.</p>
<p>I typically default to verifying state changes, but it&#8217;s often the case that a method is better specified via verification of its interactions with its dependencies. This is especially true when the side effect would be so hard to assert that you&#8217;re tempted to violate <a href="http://en.wikipedia.org/wiki/Command-query_separation" target="_blank">command-query separation</a> and make a command function return a value only for the benefit of a test, when the API otherwise wouldn&#8217;t benefit from it.</p>
<h2>19. Useless layers are useless</h2>
<p>If a Java project has a Widget model object, it&#8217;s a pretty safe bet that someone is going to create a WidgetService at some point. And what would be the WidgetService&#8217;s <a href="http://www.objectmentor.com/resources/articles/srp.pdf" target="_blank">single responsibility</a>? Its name certainly doesn&#8217;t do anything to tell us.</p>
<p>Having seen a few widget services in my time, all I can infer is that</p>
<ol><li>It&#8217;s likely to be annotated as <a href="http://static.springsource.org/spring/docs/3.0.x/javadoc-api/org/springframework/transaction/annotation/Transactional.html" target="_blank">@Transactional</a>, and </li>
<li>It will probably soon become a <a href="http://martinfowler.com/bliki/MinimalInterface.html" target="_blank">dumping ground</a> of numerous, unrelated responsibilities.</li>
</ol><p>I don&#8217;t know the cause for this. Whether it&#8217;s the proliferation of <a href="http://en.wikipedia.org/wiki/Multitier_architecture" target="_blank">dogma</a> in the Java community, a side effect of all the domain-knowledge-free <a href="http://en.wikipedia.org/wiki/Enterprise_JavaBean#Rapid_adoption_followed_by_criticism" target="_blank">cookie-cutter Java EE</a> projects, the <a href="http://en.wikipedia.org/wiki/Service-oriented_architecture" target="_blank">SOA buzzword</a>&#8217;s popularizing of the word &#8220;service&#8221;, or something else entirely, I would hope that any rational developer would agree that a class doesn&#8217;t need to come into existence until it has something to do. Making sure an arbitrary layer is sufficiently populated isn&#8217;t a nearly good enough reason.</p>
<h2>20. Class extension should not be used to mask complexity</h2>
<p>Even though few people&#8217;s code consistently adheres to the <a href="http://en.wikipedia.org/wiki/Single_responsibility_principle" target="_blank">single-responsibility principle</a>, most people do seem to have a natural aversion to excessively gargantuan classes. Unguided, this aversion results in class complexity being conveniently swept under the nearest rug. One such rug that is often used to fantastic effect is class extension.</p>
<p>I&#8217;ll keep picking on Struts here. Take this snippet from <a href="http://struts.apache.org/2.1.8/struts2-core/apidocs/com/opensymphony/xwork2/ActionSupport.html" target="_blank">ActionSupport</a>, from which Struts action classes <em>may</em> extend:</p>

<script src="https://gist.github.com/642767.js?file=ActionSupport.java"></script>

<p>Any time that your ActionSupport extension wants to resolve a message key for <a href="http://en.wikipedia.org/wiki/Internationalization_and_localization" target="_blank">i18n</a>, your test class is stuck dealing with the complexity of a real TextProvider instance provided by the TextProviderFactory. This is because no setter exists on ActionSupport, so you can&#8217;t easily replace it with a test double.</p>
<p>So in this case you&#8217;re left with one of several unsavory options, including (for the sake of making this point): negotiate with a real TextProvider instance or stub out the getText() methods by overriding the SUT.</p>
<p>In the case of the former, your test loses its isolation of the SUT. In the latter, you&#8217;re stuck dealing with instantiating the SUT with an anonymous override, like this one:</p>

<script src="https://gist.github.com/642773.js?file=FeelDirty.java"></script>

<p>So now, thanks to some convenience methods tucked away in a super class, we&#8217;re stuck resorting to a form of backdoor manipulation&#8212;and worse, by having overridden our SUT, we can never truly test the real thing. Our test starts its life out as a lie.</p>
<p>Hardly seems worth the convenience of sweeping the shared convenience methods under the rug of a super class.</p>
<h2>21. Static analysis can make a great WTF detector</h2>
<p>Static code analysis is no <a href="http://en.wikipedia.org/wiki/Law_of_the_instrument" target="_blank">golden hammer</a>, but using <a href="http://www.sonarsource.org/" target="_blank">Sonar</a> has demonstrated to me that it can have great benefits. If you&#8217;ve never seen Sonar, <a href="http://nemo.sonarsource.org/project/index/117804" target="_blank">here&#8217;s a public instance</a> analyzing <a href="http://cxf.apache.org/" target="_blank">Apache CXF</a>.</p>
<p>Of course, automated code analysis that yields no red flags does not necessarily indicate clean, quality, or even working code. However, properly tuned code analyses that yield a bevy of violations can certainly grab your attention and quickly place it on potential problem areas.</p>
<p>I view static analysis as a way to get fast feedback. It makes me aware of sore spots, usually before they lead to bugs or (depending on their underlying severity) spiral out of control. Even if the report is only used to facilitate the ongoing curation of code as it&#8217;s being developed, surely it stands to reason that generating and reading a Sonar dashboard report once a week would require less effort than scouring a team&#8217;s every commit by hand.</p>
<p>It&#8217;s with that last image (that of painstakingly auditing a team&#8217;s work) in mind that I can appreciate Sonar as a handy tool that supports a sort of <a href="http://en.wikipedia.org/wiki/Trust,_but_verify" target="_blank">trust, but verify</a> workflow.</p>
<hr><p>And there you have it! As I wrote this entry in a single straight pass, I&#8217;m sure there is still plenty of room for improvement. I hereby solicit your feedback and corrections, whether it&#8217;s by <a href="http://twitter.com/searls" target="_blank">tweeting at me</a> or <a href="http://www.google.com/profiles/searls/contactme?continue=http%3A%2F%2Fwww.google.com%2Fprofiles%2Fsearls" target="_blank">e-mailing me</a>.</p>
