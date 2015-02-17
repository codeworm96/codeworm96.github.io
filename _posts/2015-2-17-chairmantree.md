---
layout: post
title: 函数式二叉树
---

在搞 IO 时，曾听大神介绍主席树/函数式线段树/可持久化线段树，当时对要修改时另外开点不是很习惯，不过现在已经很自然了。

{% highlight racket %}
(define (make-tree entry lchild rchild)
  (list entry lchild rchild))
(define (entry tree)
  (car tree))
(define (lchild tree)
  (cadr tree))
(define (rchild tree)
  (caddr tree))

(define (insert x tree)
  (cond
    ((null? tree) (make-tree x '() '()))
    ((> x (entry tree)) (make-tree (entry tree) (lchild tree) (insert x (rchild tree))))
    ((< x (entry tree)) (make-tree (entry tree) (insert x (lchild tree)) (rchild tree)))
    (else tree)))


;;拍扁
(define (flatten tree)
  (define (flat tree res)
    (if (null? tree)
        res
        (flat (lchild tree)
              (cons (entry tree) (flat (rchild tree)
                                       res)))))
  (flat tree '()))

;;重建
(define (build list)
  (define (part-build len list)
    (if (= 0 len)
        (cons '() list)
        (let ((llen (quotient len 2)))
          (let ((lres (part-build llen list)))
            (let ((lc (car lres))
                  (rlist (cdr lres)))
              (let ((this (car rlist))
                    (rres (part-build (- len (+ llen 1)) (cdr rlist))))
                (let ((rc (car rres))
                      (left (cdr rres)))
                  (cons (make-tree this lc rc) left))))))))
  (car (part-build (length list) list)))
{% endhighlight %}
