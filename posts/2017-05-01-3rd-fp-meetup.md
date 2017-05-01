---
title: 蒟蒻所见的第三届函数式编程分享
tags: functional programming, meetup
---

\-- 简单记录下个人的理解，某些地方可能不对...

<!--more-->

这次分享正好在上海举行，本蒟蒻有幸在 @Ivan 巨巨与另一位大二巨巨的带领下，参加了此次活动。

开场的 talk 是关于 Haskell 性能调优，因为自己只写过玩具项目，感觉这个话题离自己还比较遥远。
优化嘛，首先还是要介绍 profiling 的方法。后面讲的很多 Tips 要么和 GHC 实现有关，要么没用过这方面，
如 FFI, 自己目前还没水平实践。现阶段自己学到的一是合理使用 strict, 二是手动 CPS
(1. 可以消除list构造 2. 解决判断再判断问题，如返回 Maybe 那么还要再判断是否为 Just,
这样少一次判断) 

第2场为从 Haskell 程序员的角度介绍 Elixir, 主要注重语言本身，因为自己最近刷过 Elixir
的教程，理解还是比较容易，没有涉及“building scalable and maintainable applications”
对个人而言有些遗憾。

第3场是主要有关 Javascript 的 Tail Call 支持，proper tail calls(Apple) VS
syntactic tail calls(Google, Mozilla, Microsoft) 陷入僵局，Javascript
的函数式编程支持现阶段还是堪忧。主讲使用的高桥流简报法给人的印象很深。

第4场为 ClojureScript 相关，因为本人不懂前端，听得很迷。印象比较深的是黑 JVM 启动速度
和交流时提到的《海洋之歌》 (每根头发都记载着一个故事 -> 都有自己的 timeline)

第5场为 Nix & NixOS 的简介。我的理解: NixOS 主要想搞一个"配置文件 -> 系统"的纯函数。
那么同一套配置文件就会产生同样的系统，那么就 reproducible, 实现上它把具体文件放在
nix store 里，然后再把本来应该在的位置的符号链接指过来，用类似 CSE 课上提到的
shadow copy 的方法实现了原子性，同时因为都在 nix store 里，那么可以不删旧版本，
方便回滚。当然也是有代价的，要学它这新的一套，目测学习成本较高，感觉对自己来说还不太划算。
看到讲座超时那么久直接被复杂度劝退...

最后一场为 Haskell 中的 Tensorflow, 主要是讲 Tensorflow 的 Haskell binding,
首先是分析其实现，这里就可以看出来实际的工程项目和教学用的玩具的复杂度区别之大，
不禁感慨自己的 naive, 之后还是要多学习一个。之后是演示了手写识别的官方样例。
虽然没搞过机器学习，但是为了写数据挖掘大作业，也乱改过某 python 的机器学习代码。
我感觉代码整体思路差别不是很大，特色不明显。
主讲最后对 [DeepDarkFantasy](https://github.com/ThoughtWorksInc/DeepDarkFantasy)
评价很高，那么有空看一下吧。
