---
layout: post
title: 对红黑树的一种解释（删除篇）
---

(接上篇）

<!-- more -->

# 2-3-4树的删除（top-down）
为了理解红黑树删除，我们还是先回到2-3-4树。

(Note: 跟所有搜索树一样，我们总可以把删除化为删一个子树不满的节点）

我们发现对2-3-4树，删3-node，4-node都比较轻松愉快，而删2-node很麻烦。
所以在top-down的过程中我们要尽量排除2-node.
可分两种情况：

1. 若相邻兄弟节点也为2-node，可以从父节点拉下来一个进行合并。

2. 若相邻兄弟节点不为2-node，可经由父节点借来一个。

![234删除](/public/upload/rbt/234delete.png)

# 红黑树删除（top-down）
我们可以把上述方法迁移到红黑树。在2-3-4树中我们的不变式是当前节点不是2-node，而在红黑树中则为：

1. 当前节点cur 为红色

2. cur.left/cur.right 至少有一为红色

方法：

0. 若父节点为黑色可通过旋转化为父节点为红色情况
![转化](/public/upload/rbt/trans.png)

1. 若兄弟节点为2-node 则可合并
![合并](/public/upload/rbt/merge.png)

2. 若兄弟节点不为2-node 则通过父节点借
![借](/public/upload/rbt/borrow.png)

当然开始时也要能满足不变式，若不满足，则可直接把父节点变红，最后要把父节点恢复黑色。
![根的情况](/public/upload/rbt/root.png)

这就是红黑树的 top-down 删除的方法。

\[Update:2015/5/31
删除樊腿同样也给出了解决方案，不过较之插入，稍显混乱，考虑到本文以红黑树理解为主线，
在此不做展开，有兴趣的读者可以参考 <a href="http://user.qzone.qq.com/3101371795/blog/1432878594" target="_blank">樊腿巨作 基于3+4统一重构和统一重染色操作的红黑树归约实现</a>
\]

Happy Hacking!


