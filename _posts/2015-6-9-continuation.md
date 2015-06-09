---
layout: post
title: 一些乱搞的产物
---

昨天，看了一些资料，感觉自己对 continuation 有了一些想法，感觉可以给之前的解释器加上，
于是迫不及待的行动了起来。

<!-- more -->

本来，程序的求值状态可以由(Expr, Env) 即正在求值的表达式和求值环境刻画，但这对 continuation 实现是不够的，
还要加上 continuation 一项，变为(Expr, Env, Kont).
continuation 以我现在的认识是表示之后要进行的计算。

以此思路，给求值用的函数，都加上 Kont 一个参数，然后都改写成 continuation passing style, 就改好了。
顺便可以实现 callcc.

然后突然发现，test 中 ackman function 有部分过不去了，因为实现时对参数求值的改动使得递归调用增多，stack overflow.
于是，只好实现了尾递归优化，即用循环把 eval 的主体包起来，有的情况直接更新状态即可，省去递归调用。

这样就把之前的坑稍稍填了一点。

在这个过程中，感觉写程序需要有东西提供对程序正确性的信心，比如测试和 type system 等。

感觉自己还是太不务正业了，期末还是要抓紧复习啊。

