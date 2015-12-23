---
layout: post
title: static 与链接
---

今天的 ics 习题课上有一道习题，题意大致如下：

{% highlight c %}
/* m1.c */
int p()
{
}

int main()
{
    p();
}
{% endhighlight %}

{% highlight c %}
/* m2.c */
int a[10] = {1,1,1,1,1,1,1,1,1,1};
static int p=1;
int p2()
{
    return p;
}
{% endhighlight %}

首先问 m1 里的 p 引用的是哪个定义，这一问没有太大问题， m2 里 p 是 static 的，因而是 local 的，m1 里自然不会用。
显然是用的 m1 里的 p 定义。

不过第二问就比较费解，问 m2 里 p 引用的是哪个定义。讲道理的话，m2 里 p 既可能引用自己里面 static 的 p 的local 符号，也可能引用 m1 中的 global 强符号。
所以，还是看看 gcc 的编译结果把。
{% highlight text %}
00000000 <p2>:
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	a1 28 00 00 00       	mov    0x28,%eax
			4: R_386_32	.data
   8:	5d                   	pop    %ebp
   9:	c3                   	ret    
{% endhighlight %}
结果是 relocation table 中的对应项的符号是 .data, 而不是 p. 所以问题是一个伪命题，linker 根本不需要解决 m2 里 p 的引用！
仔细查看汇编代码我们发现，编译器是把改static 变量距 .data section 首的偏移放进去占位，这样链接时把 .data 段的实际地址加上就得到了正确地址。
这应该就是编译器处理 static 变量的机制了。

