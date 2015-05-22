---
layout: post
title: 对红黑树的一种解释
---

> mjc同学，说说你的看法。 --Prof. qzw

红黑树的case非常之多，令我们这样的沙茶不能理解。或许只有mjc这样的大神才能理解吧。
虽然经过验证，其中的各种操作都能保证不变式始终成立，但总是感觉其中有着更深层的奥秘。

或许，要真正理解一个概念必须逆流而上，寻找其提出者当时的想法。今日阅读红黑树发明者之一 Robert Sedgewick 的 slide，受益匪浅，
结合自己的愚见，稍作记录。

# prerequisite
you should familiar with rotation

<!-- more -->

# 2-3-4树
2-3-4树可谓红黑树的前身，理解了它有助理解红黑树，其中有三类节点 2-node, 3-node & 4-node,他的条件是到所有叶节点的路径长度均相同。
![节点类型](/public/upload/rbt/234nodes.jpg)
![2-3-4树](/public/upload/rbt/234.png)

2-3-4树的插入很简单，若最后在2/3-node下只要把它并入那个节点，若是4-node，就把中间那个提到上一层，下面分裂为两个（Note：可能又会引起上一层的问题）
由上述思路即得 Button-up 算法。
![insert](/public/upload/rbt/insert.png)
我们发现4-node不利插入，于是可在向下查找时，遇到4-node便分裂（note： 因上一层由归纳假设无4-node,故无需递归），这就是 top-down 方法了。

# 从2-3-4树到红黑树
2-3-4树虽易于理解，可惜节点种类多实现不便，是否可用二叉树来表示？
![对应红黑树表示](/public/upload/rbt/nodes.png)
红色表示属于父节点表示的node
这样一搞，发现与红黑树性质等同（黑高度==对应2-3-4树高度）

# Button-up insert
那么对应的： 新节点默认红色 <-> 并入上层节点

分裂节点：![分裂节点](/public/upload/rbt/split.png)
(note:遇有些情况要化为标准型）
![标准化](/public/upload/rbt/standardize.png)

# Top-down insert
每次遇到两孩子均为红色（4-node）就分裂（可能要修正形式）
每次遇到一孩子为红色（3-node)(qzw:走到红色怎么办呢？）,其实什么都不用做，最后修正形式即可。
孩子双黑（2-node），无需操作。

恭喜你已经掌握了红黑树插入的的全部技术。

Happy Hacking!
