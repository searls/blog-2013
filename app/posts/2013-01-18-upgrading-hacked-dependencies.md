Today we set out to upgrade one of the third-party JavaScript dependencies on which our project relies and we inadvertently discovered that it had a number of custom hacks made against it. This blog post replays a similar experience and how we can reduce some of the risk in attempting to confidently upgrade the dependency with `git diff` and `patch`.

## introducing a new dependency

It starts when we add a [new 3rd party library](https://github.com/searls/jasmine-given) to our project. Everything is new and exciting!

    $ git add jasmine-stealth.js
    $ git commit -m 'Adding jasmine-stealth, a cool library I found!'

## hacking that dependency

Over time, we add some custom hacks to our dependency to suit the needs of our project. We know it's poor form to directly edit a dependency like this, but in the interest of expediency we did it anyway.

To see what our history after our hacks:

    $ git log --oneline jasmine-stealth.js

Which will summarize our commits like this:

    3be7a1c hack! add a default stubbing if none is given
    36df5a6 hack! in our project, every object responds to
    e19149f Adding jasmine-stealth, a cool library I found!

And we can see what the diff looks like, too:

    $ git diff e19149f..HEAD jasmine-stealth.js

Our diff looks like:

    diff --git a/jasmine-stealth.js b/jasmine-stealth.js
    index 31e7956..4216889 100644
    --- a/jasmine-stealth.js
    +++ b/jasmine-stealth.js
    @@ -37,7 +37,7 @@ site: https://github.com/searls/jasmine-stealth
       root.spyOnConstructor = function(owner, classToFake, methodsToSpy) {
         var fakeClass, spies;
         if (methodsToSpy == null) {
    -      methodsToSpy = [];
    +      methodsToSpy = ['render'];
         }
         if (_(methodsToSpy).isString()) {
           methodsToSpy = [methodsToSpy];
    @@ -86,14 +86,14 @@ site: https://github.com/searls/jasmine-stealth

       jasmine.createStub = jasmine.createSpy;

    -  jasmine.createStubObj = function(baseName, stubbings) {
    +  jasmine.createStubObj = function(baseName, stubbings, defaultStubbing) {
         var name, obj, stubbing;
         if (stubbings.constructor === Array) {
           return jasmine.createSpyObj(baseName, stubbings);
         } else {
           obj = {};
           for (name in stubbings) {
    -        stubbing = stubbings[name];
    +        stubbing = stubbings[name] || defaultStubbing;
             obj[name] = jasmine.createSpy(baseName + "." + name);
             if (_(stubbing).isFunction()) {
               obj[name].andCallFake(stubbing);


## An upgrade appears!

Just when we were enjoying our hacked-up dependency, a new version is released with critical bug fixes! We want to upgrade it, but neither do we want to lose our hacks nor do we want to imagine hand-merging the two.

To start, let's save off our customizations to a patch file:

    $ git diff --no-prefix e19149f..HEAD jasmine-stealth.js > hacks.patch

You may have noted that we also add the `--no-prefix` flag to make the diff easier to apply with the `patch` tool.

Next, commit the new (and yet-unmodified) upgrade.

    $ mv new-jasmine-stealth.js jasmine-stealth.js
    $ git add jasmine-stealth.js
    $ gc -am 'upgraded jasmine-stealth.js to 0.0.12'

Now, we want to apply our fixes from our saved patch:

    $ patch -p0 < hacks.patch

Which yields the happy output:

    patching file jasmine-stealth.js

And we can commit those hacks anew:

    $ git add jasmine-stealth.js
    $ git commit -m 'reapplied hacks'

## yay!

This isn't the only way to do this, and it's not the best (in many cases, rebase could be used to preserve the history of the hack commits), but it worked for me today and maybe this example will help you!

