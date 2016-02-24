---
layout: post
title: Notes on QuickCheck
---

QuickCheck is a testing library for Haskell, which is very interesting and convinent.
Unlike normal testing library, in which we run our code against some given input
and check if the result is expected, QuickCheck allows us to define `properties`
for our functions, and check them using randomly generated inputs.

# Install
    cabal install quickcheck

# Usage
import it first:
{% highlight haskell %}
import Test.QuickCheck
{% endhighlight %}

define properties:
{% highlight haskell %}
-- simple property
prop_reverseConcat xs ys = reverse (xs ++ ys) == reverse ys ++ reverse xs

-- (==>) implies - add condition for inputs
prop_headMin xs = not (null xs) ==> head (sort xs) == minimum xs
{% endhighlight %}

testing properties:
{% highlight haskell %}
quickCheck prop

-- more details
verboseCheck prop

-- specifying a type
quickCheck (prop :: SomeType -> Bool)
{% endhighlight %}

# Not Perfect
We have to notice that passing QuickCheck doesn't mean there isn't
any bug in our code. In fact, we can prove that no one can devise
a program which can verify, for any program, whether it behaves
as desired.(let \phi(x) = character function for some property,
the verify problem is equivalent to 1 - \phi(x) = 0(zero function),
which, according to computability theory is not decidable.)

