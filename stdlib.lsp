(def (caar pair)   (car (car pair)))
(def (cadr pair)   (car (cdr pair)))
(def (cdar pair)   (cdr (car pair)))
(def (cddr pair)   (cdr (cdr pair)))
(def (caaar pair)  (car (car (car pair))))
(def (caadr pair)  (car (car (cdr pair))))
(def (cadar pair)  (car (cdr (car pair))))
(def (caddr pair)  (car (cdr (cdr pair))))
(def (cdaar pair)  (cdr (car (car pair))))
(def (cdadr pair)  (cdr (car (cdr pair))))
(def (cddar pair)  (cdr (cdr (car pair))))
(def (cdddr pair)  (cdr (cdr (cdr pair))))
(def (caaaar pair) (car (car (car (car pair)))))
(def (caaadr pair) (car (car (car (cdr pair)))))
(def (caadar pair) (car (car (cdr (car pair)))))
(def (caaddr pair) (car (car (cdr (cdr pair)))))
(def (cadaar pair) (car (cdr (car (car pair)))))
(def (cadadr pair) (car (cdr (car (cdr pair)))))
(def (caddar pair) (car (cdr (cdr (car pair)))))
(def (cadddr pair) (car (cdr (cdr (cdr pair)))))
(def (cdaaar pair) (cdr (car (car (car pair)))))
(def (cdaadr pair) (cdr (car (car (cdr pair)))))
(def (cdadar pair) (cdr (car (cdr (car pair)))))
(def (cdaddr pair) (cdr (car (cdr (cdr pair)))))
(def (cddaar pair) (cdr (cdr (car (car pair)))))
(def (cddadr pair) (cdr (cdr (car (cdr pair)))))
(def (cdddar pair) (cdr (cdr (cdr (car pair)))))
(def (cddddr pair) (cdr (cdr (cdr (cdr pair)))))

(def (not x)           (if x false true))
(def (null? obj)       (if (eq obj '()) true false))
(def (list . objs)      objs)
(def (id obj)           obj)

(def (flip func)    (lambda (a b) (func b a)))
(def (curry func a) (lambda (b) (apply func (cons a (list b)))))
(def (compose f g)  (lambda (a) (f apply g a)))
; (def (curry func arg1)  (lambda (arg) (func arg1 arg)))
; (def (compose f g)      (lambda (arg) (f (g arg))))

(def zero?              (curry = 0))
(def positive?          (curry < 0))
(def negative?          (curry > 0))
(def (odd? num)         (= (mod num 2) 1))
(def (even? num)        (= (mod num 2) 0))

(def (foldr func end lst)
  (if (null? lst)
    end
    (func (car lst) (foldr func end (cdr lst)))))

(def (foldl func accum lst)
  (if (null? lst)
    accum
    (foldl func (func accum (car lst)) (cdr lst))))

(def fold foldl)
(def reduce fold)

(def (unfold func init pred)
  (if (pred init)
    (cons init '())
    (cons init (unfold func (func init) pred))))

(def (sum . lst)         (fold + 0 lst))
(def (product . lst)     (fold * 1 lst))
(def (and . lst)         (fold && true lst))
(def (or . lst)          (fold || false lst))
(def (any? pred . lst)   (apply or (map pred lst)))
(def (every? pred . lst) (apply and (map pred lst)))

(def (max first . rest) (fold (lambda (old new) (if (> old new) old new)) first rest))
(def (min first . rest) (fold (lambda (old new) (if (< old new) old new)) first rest))

(def (length lst)       (fold (lambda (x y) (+ x 1)) 0 lst))
(def (reverse lst)      (fold (flip cons) '() lst))
(def count length)

(def (mem-helper pred op) (lambda (acc next) (if (and (not acc) (pred (op next))) next acc)))
(def (memq obj lst)       (fold (mem-helper (curry eq obj) id) false lst))
(def (memv obj lst)       (fold (mem-helper (curry eq obj) id) false lst))
(def (member obj lst)     (fold (mem-helper (curry eq obj) id) false lst))
(def (assq obj alist)     (fold (mem-helper (curry eq obj) car) false alist))
(def (assv obj alist)     (fold (mem-helper (curry eq obj) car) false alist))
(def (assoc obj alist)    (fold (mem-helper (curry eq obj) car) false alist))

(def (map func lst)       (foldr (lambda (x y) (cons (func x) y)) '() lst))
(def (filter pred lst)    (foldr (lambda (x y) (if (pred x) (cons x y) y)) '() lst))

(def (list-tail lst k)
  (if (zero? k)
      lst
      (list-tail (cdr lst) (- k 1))))

(def (list-ref lst k) (car (list-tail lst k)))

(def (append . lists) (foldr (lambda (x y) (foldr cons y x)) '() lists))
; (def (append lst . lsts) (foldr (flip (curry foldr cons)) lst lsts))

(def (list-last lst)
  (if (null? (cdr lst))
    (car lst)
    (list-last (cdr lst))))
(def (last . lst) (list-last lst))

(def (vector-copy v) (if (vector? v) v (error "vector-copy takes one vector")))
