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
