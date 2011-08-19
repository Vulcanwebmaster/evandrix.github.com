;;;; syntax-tests.scm - various macro tests


(use extras)


(define-syntax t
  (syntax-rules ()
    ((_ r x)
     (let ((tmp x))
       (if (not (equal? r tmp))
	   (error "test failed" r tmp 'x)
	   (pp tmp))))))

(define-syntax f
  (syntax-rules ()
    ((_ x)
     (let ((got-error #f))
      (handle-exceptions ex (set! got-error #t) x)
      (unless got-error
        (error "test returned, but should have failed" 'x) )))))

(t 3 3)

(f abc)
(f (t 3 4))

;; test syntax-rules

(define-syntax test
  (syntax-rules ()
    ((_ x form)
     (let ((tmp x))
       (if (number? tmp)
	   form
	   (error "not a number" tmp))))))

(t 100 (test 2 100))

;; some basic contrived testing

(define (fac n)
  (let-syntax ((m1 (lambda (n r c) 
		     (pp `(M1: ,n))
		     (list (r 'sub1) (cadr n)))))
    (define (sub1 . _)			; ref. transp.? (should not be used here)
      (error "argh.") )
    #;(print "fac: " n)		  
    (if (test n (zero? n))
	1
	(* n (fac (m1 n))))))

(t 3628800 (fac 10))

;; letrec-syntax

(t 34
(letrec-syntax ((foo (syntax-rules () ((_ x) (bar x))))
		(bar (syntax-rules () ((_ x) (+ x 1)))))
  (foo 33))
)

;; from r5rs:

(t 45
(let ((x 5))
  (define foo (lambda (y) (bar x y)))
  (define bar (lambda (a b) (+ (* a b) a)))
  (foo (+ x 3)))
)

;; an error, according to r5rs - here it treats foo as defining a toplevel binding

#;(let-syntax
  ((foo (syntax-rules ()
          ((foo (proc args ...) body ...)
           (define proc
             (lambda (args ...)
               body ...))))))
  (let ((x 3))
    (foo (plus x y) (+ x y))
    (define foo x)
    (print (plus foo x))))

(t 'now
(let-syntax ((when (syntax-rules ()
                     ((when test stmt1 stmt2 ...)
                      (if test
                          (begin stmt1
                                 stmt2 ...))))))
  (let ((if #t))
    (when if (set! if 'now))
    if))
)

(t 'outer
(let ((x 'outer))
  (let-syntax ((m (syntax-rules () ((m) x))))
    (let ((x 'inner))
      (m))))       
)

(t 7
(letrec-syntax
  ((my-or (syntax-rules ()
            ((my-or) #f)
            ((my-or e) e)
            ((my-or e1 e2 ...)
             (let ((temp e1))
               (if temp
                   temp
                   (my-or e2 ...)))))))
  (let ((x #f)
        (y 7)
        (temp 8)
        (let odd?)
        (if even?))
    (my-or x
           (let temp)
           (if y)
           y)))
)

;; From Al* Petrofsky's "An Advanced Syntax-Rules Primer for the Mildly Insane"
(let ((a 1))
  (letrec-syntax
      ((foo (syntax-rules ()
              ((_ b)
               (bar a b))))
       (bar (syntax-rules ()
              ((_ c d)
               (cons c (let ((c 3))
                         (list d c 'c)))))))
    (let ((a 2))
      (t '(1 2 3 a) (foo a)))))

;; ER equivalent
(let ((a 1))
  (letrec-syntax
      ((foo (er-macro-transformer
             (lambda (x r c)
               `(,(r 'bar) ,(r 'a) ,(cadr x)))))
       (bar (er-macro-transformer
             (lambda (x r c)
               (let ((c (cadr x))
                     (d (caddr x)))
                `(,(r 'cons) ,c
                  (,(r 'let) ((,c 3))
                   (,(r 'list) ,d ,c ',c))))))))
    (let ((a 2))
      (t '(1 2 3 a) (foo a)))))

;; IR equivalent
(let ((a 1))
  (letrec-syntax
      ((foo (ir-macro-transformer
             (lambda (x i c)
               `(bar a ,(cadr x)))))
       (bar (ir-macro-transformer
             (lambda (x i c)
               (let ((c (cadr x))
                     (d (caddr x)))
                 `(cons ,c
                        (let ((,c 3))
                          (list ,d ,c ',c))))))))
    (let ((a 2))
      (t '(1 2 3 a) (foo a)))))

;; Strip-syntax on vectors:
(let-syntax
    ((foo (syntax-rules ()
            ((_)
             '#(b)))))
  (t '#(b) (foo)))

(define-syntax kw
  (syntax-rules (baz)
    ((_ baz) "baz")
    ((_ any) "no baz")))

(t "baz" (kw baz))
(t "no baz" (kw xxx))

(let ((baz 100))
  (t "no baz" (kw baz)))

(t 'ok
(let ((=> #f))
  (cond (#t => 'ok)))
)

(t '(3 4)
(let ((foo 3))
  (let-syntax ((bar (syntax-rules () ((_ x) (list foo x)))))
    (let ((foo 4))
      (bar foo))))
)

;;; strip-syntax on renamed module identifiers, as well as core identifiers
(module foo (bar)
  (import chicken scheme)

  (define bar 1))

(import foo)

(define-syntax baz
  (er-macro-transformer
   (lambda (e r c)
     `',(strip-syntax (r 'bar)))))

(t "bar" (symbol->string (baz bar)))
(t "bar" (symbol->string (baz void)))

;; Fully qualified symbols are not mangled - these names are internal
;; and not documented, but shouldn't be messed with by the expander

(t "foo#bar" (symbol->string 'foo#bar))
(t "#%void" (symbol->string '#%void))

(t "foo#bar" (symbol->string (strip-syntax 'foo#bar)))
(t "#%void" (symbol->string (strip-syntax '#%void)))

;;; alternative ellipsis test (SRFI-46)

(define-syntax foo
  (syntax-rules 
      ___ () 
      ((_ vals ___) (list '... vals ___))))

(t '(... 1 2 3)
   (foo 1 2 3)
)

(define-syntax defalias
  (syntax-rules ___ ()
    ((_ new old)
     (define-syntax new
       (syntax-rules ()
	 ((_ args ...) (old args ...)))))))

(defalias inc add1)

(t 3 (inc 2))

;;; Rest patterns after ellipsis (SRFI-46)

(define-syntax foo
  (syntax-rules ()
    ((_ (a ... b) ... (c d))
     (list (list (list a ...) ... b ...) c d))
    ((_ #(a ... b) ... #(c d) #(e f))
     (list (list (vector a ...) ... b ...) c d e f))
    ((_ #(a ... b) ... #(c d))
     (list (list (vector a ...) ... b ...) c d))))

(t '(() 1 2)
   (foo (1 2)))

(t '(((1) 2) 3 4)
   (foo (1 2) (3 4)))

(t '(((1 2) (4) 3 5) 6 7)
   (foo (1 2 3) (4 5) (6 7)))

(t '(() 1 2)
   (foo #(1 2)))

(t '((#() 1) 2 3)
   (foo #(1) #(2 3)))

(t '((#(1 2) 3) 4 5)
   (foo #(1 2 3) #(4 5)))

(t '((#(1 2) 3) 4 5 6 7)
   (foo #(1 2 3) #(4 5) #(6 7)))

(t '(() 1 2 3 4)
   (foo #(1 2) #(3 4)))

(t '((#(1) 2) 3 4 5 6)
   (foo #(1 2) #(3 4) #(5 6)))

(t '((#(1 2) #(4) 3 5) 6 7 8 9)
   (foo #(1 2 3) #(4 5) #(6 7) #(8 9)))

;;; Bug discovered during implementation of SRFI-46 rest patterns:

(define-syntax foo
  (syntax-rules ()
    ((_ #((a) ...)) (list a ...))))

(t '(1)
   (foo #((1))))

;;;

(define-syntax usetmp
  (syntax-rules ()
    ((_ var) 
     (list var))))

(define-syntax withtmp
  (syntax-rules ()
    ((_ val exp)
     (let ((tmp val))
       (exp tmp)))))

(t '(99)
   (withtmp 99 usetmp)
)

(t 7
(letrec-syntax
    ((my-or (syntax-rules ()
	      ((my-or) #f)
	      ((my-or e) e)
	      ((my-or e1 e2 ...)
	       (let ((temp e1))
		 (if temp
		     temp
		     (my-or e2 ...)))))))
  (let ((x #f)
        (y 7)
        (temp 8)
        (let odd?)
        (if even?))
    (my-or x
           (let temp)
           (if y)
           y)))
)

(define-syntax foo
  (syntax-rules ()
    ((_ #(a ...)) (list a ...))))

(t '(1 2 3)
   (foo #(1 2 3))
)


(define-syntax loop
  (lambda (x r c)
    (let ((body (cdr x)))
      `(,(r 'call/cc)
	(,(r 'lambda) (exit)
	 (,(r 'let) ,(r 'f) () ,@body (,(r 'f))))))))

(let ((n 10))
  (loop
   (print* n " ") 
   (set! n (sub1 n))
   (when (zero? n) (exit #f)))
  (newline))

(define-syntax while0
  (syntax-rules ()
    ((_ t b ...)
     (loop (if (not t) (exit #f)) 
	   b ...))))

(f (while0 #f (print "no.")))

(define-syntax while
  (lambda (x r c)
    `(,(r 'loop) 
      (,(r 'if) (,(r 'not) ,(cadr x)) (exit #f))
      ,@(cddr x))))

(let ((n 10))
  (while (not (zero? n))
	 (print* n " ")
	 (set! n (- n 1)) )
  (newline))

;;; found by Jim Ursetto

(let ((lambda 0)) (define (foo) 1) (foo))


;;; define-macro implementation (only usable in a module-free environment)

(define-syntax define-macro
  (syntax-rules ()
    ((_ (name . llist) body ...)
     (define-syntax name
       (lambda (x r c)
	 (apply (lambda llist body ...) (strip-syntax (cdr x))))))))

(define-macro (loop . body)
  (let ((loop (gensym)))
    `(call/cc
      (lambda (exit)
	(let ,loop () ,@body (,loop))))))

(let ((i 1))
  (loop (when (> i 10) (exit #f))
	(print* i " ")
	(set! i (add1 i))))
(newline)


;;;; exported macro would override original name (fixed in rev. 13351)

(module xfoo (xbaz xbar)
  (import scheme)
  (define-syntax xbar
    (syntax-rules ()
      ((_ 1) (xbaz))
      ((_) 'xbar)))
  (define-syntax xbaz
    (syntax-rules ()
      ((_ 1) (xbar))
      ((_) 'xbazz))))

(import xfoo)
(assert (eq? 'xbar (xbaz 1)))
(assert (eq? 'xbazz (xbar 1)))
(assert (eq? 'xbar (xbar)))


;;;; ellipsis pattern element wasn't matched - reported by Jim Ursetto (fixed rev. 13582)

(define-syntax foo
  (syntax-rules ()
    ((_ (a b) ...)
     (list '(a b) ...))
    ((_ a ...)
     (list '(a) ...))))

(assert (equal? (foo (1 2) (3 4) (5 6)) '((1 2) (3 4) (5 6))))
(assert (equal? (foo (1 2) (3) (5 6)) '(((1 2)) ((3)) ((5 6))))) ; failed
(assert (equal? (foo 1) '((1))))


;;; incorrect lookup for keyword variables in DSSSL llists

(module broken-keyword-var ()
  (import scheme chicken)
  ((lambda (#!key string) (assert (not string))))) ; refered to R5RS `string'

;;; Missing check for keyword and optional variable types in DSSSL llists

(f (eval '(lambda (foo #!key (0 1)) x)))
(f (eval '(lambda (foo #!optional (0 1)) x)))

;;; compiler didn't resolve expansion into local variable
;;; (reported by Alex Shinn, #15)

(module unresolve-local (foo)
  (import scheme)
  (define (foo)
    (let ((qux 3))
      (let-syntax ((bar (syntax-rules () ((bar) qux))))
	(bar))))

  (display (foo))
  (newline)
)


;;; incorrect expansion when assigning to something marked '##core#primitive (rev. 14613)

(define x 99)

(module primitive-assign ()
  (import scheme chicken)
  (let ((x 100)) (set! x 20) (assert (= x 20)))
  (set! setter 123))

(assert (= x 99))
(assert (= 123 setter))


;;; prefixed import from `chicken' module with indirect reference to imported syntax
;;; (reported by Jack Trades)

(module prefixed-self-reference1 (a b c)
  (import scheme (prefix chicken c:))
  (c:define-values (a b c) (values 1 2 3)) )

(module prefixed-self-reference2 ()
  (import scheme (prefix chicken c:))
  (c:define-values (a b c) (values 1 2 3))
  (c:print "ok")
  (c:condition-case 
   (c:abort "ugh")
   (ex () (c:print "caught"))))

(module prefixed-self-reference3 (a)
  (import (prefix scheme s.) (prefix chicken c.))
  (s.define (a x y)
	    (c.condition-case (s.+ x y) ((exn) "not numbers")))
  )

(module prefixed-self-reference4 (a)
  (import (prefix scheme s.))
  (s.define (a x y) (s.and x y)))


;;; canonicalization of body captures 'begin (reported by Abdulaziz Ghuloum)

(let ((begin (lambda (x y) (bomb)))) 1 2)


;;; redefinition of defining forms

(module m0001 (foo bar)
  (import (prefix scheme s:))
  (s:define-syntax foo (syntax-rules () ((_ x) (s:list x))))
  (s:define bar 99))

(module m0002 ()
  (import scheme m0001 extras)
  (pp (foo bar)))


;;; renaming of arbitrary structures

(module m1 (s1 s2)

  (import scheme)

  (define-syntax s1 (syntax-rules () ((_ x) (list x))))

  (define-syntax s2
    (lambda (x r c)
      (r `(vector (s1 ,(cadr x)))))) )	; without renaming the local version of `s1'
					; below will be captured 

(import m1)

(let-syntax ((s1 (syntax-rules () ((_ x) x))))
  (assert (equal? '#((99)) (s2 99))))

;; IR macros

(define-syntax loop2
  (ir-macro-transformer
   (lambda (x i c)
     (let ((body (cdr x)))
       `(call/cc
         (lambda (,(i 'exit))
           (let f () ,@body (f))))))))

(let ((n 10))
  (loop2
   (print* n " ") 
   (set! n (sub1 n))
   (when (zero? n) (exit #f)))
  (newline))

(define-syntax while20
  (syntax-rules ()
    ((_ t b ...)
     (loop2 (if (not t) (exit #f)) 
	    b ...))))

(f (while20 #f (print "no.")))

(define-syntax while2
  (ir-macro-transformer
   (lambda (x i c)
     `(loop 
       (if (not ,(cadr x)) (,(i 'exit) #f))
       ,@(cddr x)))))

(let ((n 10))
  (while2 (not (zero? n))
          (print* n " ")
          (set! n (- n 1)) )
  (newline))

(module m2 (s3 s4)

  (import chicken scheme)

  (define-syntax s3 (syntax-rules () ((_ x) (list x))))

  (define-syntax s4
    (ir-macro-transformer
     (lambda (x r c)
       `(vector (s3 ,(cadr x)))))) ) ; without implicit renaming the local version
                                     ; of `s3' below would be captured 

(import m2)

(let-syntax ((s3 (syntax-rules () ((_ x) x))))
  (t '#((99)) (s4 99)))

(let ((vector list))
  (t '#((one)) (s4 'one)))

(define-syntax nest-me
  (ir-macro-transformer
   (lambda (x i c)
     `(let ((,(i 'captured) 1))
        ,@(cdr x)))))

(t '(1 #(1 #(1)))
   (nest-me (list captured
                  (let ((captured 2)
                        (let 'not-captured)
                        (list vector))
                    (nest-me (list captured
                                   (nest-me (list captured))))))))

(define-syntax cond-test
  (ir-macro-transformer
   (lambda (x i c)
     (let lp ((exprs (cdr x)))
       (cond
        ((null? exprs) '(void))
        ((c (caar exprs) 'else)
         `(begin ,@(cdar exprs)))
        ((c (cadar exprs) '=>)
         `(let ((tmp ,(caar exprs)))
            (if tmp
                (,(caddar exprs) tmp)
                ,(lp (cdr exprs)))))
        ((c (cadar exprs) (i '==>)) ;; ==> is an Unhygienic variant of =>
         `(let ((tmp ,(caar exprs)))
            (if tmp
                (,(caddar exprs) tmp)
                ,(lp (cdr exprs)))))
        (else
         `(if ,(caar exprs)
              (begin ,@(cdar exprs))
              ,(lp (cdr exprs)))))))))

(t 'yep
   (cond-test
    (#f 'false)
    (else 'yep)))

(t 1
   (cond-test
    (#f 'false)
    (1 => (lambda (x) x))
    (else 'yep)))

(let ((=> #f))
  (t 'a-procedure
     (cond-test
      (#f 'false)
      (1 => 'a-procedure)
      (else 'yep))))

(let ((else #f))
  (t (void)
     (cond-test
      (#f 'false)
      (else 'nope))))

(t 1
   (cond-test
    (#f 'false)
    (1 ==> (lambda (x) x))
    (else 'yep)))

(let ((==> #f))
  (t 1
     (cond-test
      (#f 'false)
      (1 ==> (lambda (x) x))
      (else 'yep))))

;; Literal quotation of a symbol, injected or not, should always result in that symbol
(module ir-se-test (run)
  (import chicken scheme)
  (define-syntax run
    (ir-macro-transformer
     (lambda (e i c)
       `(quote ,(i 'void))))))

(import ir-se-test)
(t 'void (run))

;;; local definitions

(define-syntax s2
  (syntax-rules ()
    ((_) 1)))

(define (f1) 3)
(define v1 9)
(define v2 10)

(let ()
  (define-syntax s2
    (syntax-rules ()
      ((_) 2)))
  42
  (define-values (v1 v2) (values 1 2))
  43
  (define (f1) 4)
  (define ((f2)) 4)
  (assert (= 4 (f1)))
  (assert (= 4 ((f2))))
  (assert (= 2 (s2)))
  (assert (= 1 v1))
  (assert (= 2 v2)))

(assert (= 1 (s2)))
(assert (= 3 (f1)))
(assert (= 9 v1))
(assert (= 10 v2))


;;; redefining definition forms (disabled, since we can not catch this error easily)

#|
(module m0a () (import chicken) (reexport (only scheme define)))
(module m0b () (import chicken) (reexport (only scheme define-syntax)))

(module m1 ()
(import (prefix scheme s:) (prefix m0b m:))
;(s:define m:define 1)
(s:define-syntax s:define-syntax (syntax-rules ()))
)
|#


;;; renaming of keyword argument (#277)

(define-syntax foo1
  (syntax-rules ()
    ((_ procname)
     (define (procname #!key (who "world"))
       (string-append "hello, " who)))))

(foo1 bar)

(assert (string=? "hello, XXX" (bar who: "XXX")))


;;; import not seen, if explicitly exported and renamed:

(module rfoo (rbar rbaz)
(import scheme chicken)

(define (rbaz x)
  (print x))

(define-syntax rbar
  (syntax-rules ()
    ((_ x) (rbaz x))))

)

(import (prefix rfoo f:))
(f:rbar 1)

;;; Internal hash-prefixed names shouldn't work within modules

(module one (always-one)
  (import scheme)
  (define (always-one) 1))

(f (eval '(module two ()
            (import scheme)
            (define (always-two) (+ (one#always-one) 1)))))

;;; SRFI-26

;; Cut
(t '() ((cut list)))
(t '() ((cut list <...>)))
(t '(1) ((cut list 1)))
(t '(1) ((cut list <>) 1))
(t '(1) ((cut list <...>) 1))
(t '(1 2) ((cut list 1 2)))
(t '(1 2) ((cut list 1 <>) 2))
(t '(1 2) ((cut list 1 <...>) 2))
(t '(1 2 3 4) ((cut list 1 <...>) 2 3 4))
(t '(1 2 3 4) ((cut list 1 <> 3 <>) 2 4))
(t '(1 2 3 4 5 6) ((cut list 1 <> 3 <...>) 2 4 5 6))
(t '(ok) (let* ((x 'wrong)
                (y (cut list x)))
           (set! x 'ok)
           (y)))
(t 2 (let ((a 0))
       (map (cut + (begin (set! a (+ a 1)) a) <>)
            '(1 2))
       a))
(f (eval '((cut + <...> 1) 1)))

;; Cute
(t '() ((cute list)))
(t '() ((cute list <...>)))
(t '(1) ((cute list 1)))
(t '(1) ((cute list <>) 1))
(t '(1) ((cute list <...>) 1))
(t '(1 2) ((cute list 1 2)))
(t '(1 2) ((cute list 1 <>) 2))
(t '(1 2) ((cute list 1 <...>) 2))
(t '(1 2 3 4) ((cute list 1 <...>) 2 3 4))
(t '(1 2 3 4) ((cute list 1 <> 3 <>) 2 4))
(t '(1 2 3 4 5 6) ((cute list 1 <> 3 <...>) 2 4 5 6))
(t 1 (let ((a 0))
       (map (cute + (begin (set! a (+ a 1)) a) <>)
            '(1 2))
       a))
(f (eval '((cute + <...> 1) 1)))

;;; (quasi-)quotation

(f (eval '(let ((a 1)) (unquote a))))
(t 'unquote (quasiquote unquote))
(f (eval '(quasiquote (a unquote . 1)))) ; "Bad syntax". Also ok: '(a unquote . 1)
(t 'a (quasiquote a))
(f (eval '(quasiquote a b)))
(f (eval '(quote a b)))
(f (eval '(quasiquote)))
(f (eval '(quote)))
(f (eval '(quasiquote . a)))
(f (eval '(quote . a)))
(t '(foo . 1) (let ((bar 1))
                (quasiquote (foo . (unquote bar)))))
(f (eval '(let ((a 1)
                (b 2))
            (quasiquote (unquote a b))))) ; > 1 arg

(t '(quasiquote (unquote a)) (quasiquote (quasiquote (unquote a))))
(t '(quasiquote x y) (quasiquote (quasiquote x y)))

(t '(unquote-splicing a) (quasiquote (unquote-splicing a)))
(t '(1 2) (let ((a (list 2))) (quasiquote (1 (unquote-splicing a)))))
(f (eval '(let ((a 1))                  ; a is not a list
            (quasiquote (1 (unquote-splicing a) 2)))))
(f (eval '(let ((a (list 1))
                (b (list 2)))
            (quasiquote (1 (unquote-splicing a b)))))) ; > 1 arg

;; level counting
(define x (list 1 2))

;; Testing R5RS-compliance:
(t '(quasiquote (unquote (1 2)))
   (quasiquote (quasiquote (unquote (unquote x)))))
(t '(quasiquote (unquote-splicing (1 2)))
   (quasiquote (quasiquote (unquote-splicing (unquote x)))))
(t '(quasiquote (unquote 1 2))
   (quasiquote (quasiquote (unquote (unquote-splicing x)))))
(t 'x
   (quasiquote (unquote (quasiquote x))))
(t '(quasiquote (unquote-splicing (quasiquote (unquote x))))
   (quasiquote (quasiquote (unquote-splicing (quasiquote (unquote x))))))
(t '(quasiquote (unquote (quasiquote (unquote-splicing x))))
   (quasiquote (quasiquote (unquote (quasiquote (unquote-splicing x))))))
(t '(quasiquote (unquote (quasiquote (unquote (1 2)))))
   (quasiquote (quasiquote (unquote (quasiquote (unquote (unquote x)))))))

;; The following are explicitly left undefined by R5RS. For consistency
;; we define any unquote-(splicing) or quasiquote that occurs in the CAR of
;; a pair to decrease, respectively increase the level count by one.
  
(t '(quasiquote . #(1 (unquote x) 3))   ; cdr is not a pair
   (quasiquote (quasiquote . #(1 (unquote x) 3))))
(t '(quasiquote #(1 (unquote x) 3))     ; cdr is a list of one
   (quasiquote (quasiquote #(1 (unquote x) 3))))
(t '(quasiquote a #(1 (unquote x) 3) b) ; cdr is longer
   (quasiquote (quasiquote a #(1 (unquote x) 3) b)))

(t '(quasiquote (unquote . #(1 (1 2) 3))) ; cdr is not a pair
   (quasiquote (quasiquote (unquote . #(1 (unquote x) 3)))))
(t '(quasiquote (unquote #(1 (1 2) 3))) ; cdr is a list of one
   (quasiquote (quasiquote (unquote #(1 (unquote x) 3)))))
(t '(quasiquote (unquote a #(1 (1 2) 3) b)) ; cdr is longer
   (quasiquote (quasiquote (unquote a #(1 (unquote x) 3) b))))

(t '(quasiquote (unquote-splicing . #(1 (1 2) 3))) ; cdr is not a pair
   (quasiquote (quasiquote (unquote-splicing . #(1 (unquote x) 3)))))
(t '(quasiquote (unquote-splicing #(1 (1 2) 3))) ; cdr is a list of one
   (quasiquote (quasiquote (unquote-splicing #(1 (unquote x) 3)))))
(t '(quasiquote (unquote-splicing a #(1 (1 2) 3) b)) ; cdr is longer
   (quasiquote (quasiquote (unquote-splicing a #(1 (unquote x) 3) b))))

(t 'quasiquote (quasiquote quasiquote))
(t 'unquote (quasiquote unquote))
(t 'unquote-splicing (quasiquote unquote-splicing))
(t '(x quasiquote) (quasiquote (x quasiquote)))
; (quasiquote (x unquote)) is identical to (quasiquote (x . (unquote)))....
;; It's either this (error) or make all calls to unquote with more or less
;; than one argument resolve to a literal unquote.
(f (eval '(quasiquote (x unquote))))
(t '(x unquote-splicing) (quasiquote (x unquote-splicing)))
;; Let's internal defines properly compared to core define procedure when renamed
(f (eval '(let-syntax ((foo (syntax-rules () ((_ x) (begin (define x 1))))))
            (let () (foo a))
            (print "1: " a))))

(t '(a 1) (letrec-syntax ((define (syntax-rules () ((_ x y) (list 'x y))))
                          (foo (syntax-rules () ((_ x) (define x 1)))))
            (let () (foo a))))

(t '(1) (let-syntax ((define (syntax-rules () ((_ x) (list x)))))
          (let () (define 1))))

;; Local override: not a macro
(t '(1) (let ((define list)) (define 1)))

;; Toplevel (no SE)
(define-syntax foo (syntax-rules () ((_ x) (begin (define x 1)))))
(foo a)
(t 1 a)


;; ,@ in tail pos with circular object - found in trav2 benchmark and
;; reported by syn:

(let ((a '(1)))
  (set-cdr! a a)
  `(1 ,@a))
