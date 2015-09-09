---
layout: post
title: c++趣题一道
---

根据下面的声明回答有关问题。


{% highlight c++ %}
template<typename T> class Optional {
    public:
        //invalid
        Optional():valid(false) {}

        //valid value
        Optional(const T & value):valid(true), content(value) {}

        operator bool() { return valid; }

        const T & operator*();
};

Optional<Value> get(const char * key);

int t = db.get(input[i].c_str()); //为何可以通过编译？

{% endhighlight %}

<!-- more -->

答案是类型转换的问题，Optional\<Value\> 先通过 operator bool() 转换到 bool 后又被提升为 int.


感觉自动的类型转换并不是一个好的特性。有时候类型系统的束缚确实会带来不便，但它确实能避免很多问题。还是利大于弊的。