---
layout: post
title: Either 与异常处理的联系
---

在程序设计中，我们不可避免的会遇到错误的处理，在支持异常的语言中，我们会用异常来实现。如：

{% highlight python %}
try:
    do_something
except ErrorA:
    ...
except ErrorB:
    ...
{% endhighlight %}

在函数式的语言中，我们会用 Either 对程序正常和错误的结果进行抽象。上段程序就转化为：

{% highlight haskell %}
data Error = ErrorA | ErrorB

type Result a = Either Error a

do_something :: Result a

main = let res = do_something in
  case res of
    Right _ -> print "ok"
    Left ErrorA -> print "ErrorA"
    Left ErrorB -> print "ErrorB"
{% endhighlight %}

我们错误处理的需求是：当程序出错时，需要进入另外的执行流进行处理（可能要区分错误类型），这两段程序分别通过各自语言提供的特性，较为优雅的实现了这一点。
这两段程序虽然运用特性不同，但实现的功能相同，体现了两种编程范式的殊途同归。
