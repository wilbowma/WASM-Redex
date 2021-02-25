#lang racket

(require redex/reduction-semantics
         "../Syntax.rkt"
         "../Ints.rkt"
         "../Utilities.rkt"
         "SizedOps.rkt")

(provide (all-defined-out))

(define-metafunction WASMrt
  bool : boolean -> c
  [(bool #f) 0]
  [(bool #t) 1])

(define-metafunction WASMrt
  signed : t n -> integer
  [(signed i32 n) ,(to-signed-sized 32 (term n))]
  [(signed i64 n) ,(to-signed-sized 64 (term n))])

(define-metafunction WASMrt
  const->bstr : t c -> bstr
  [(const->bstr i32 c) ,(integer->integer-bytes (term c) 4 #f #f)]
  [(const->bstr i64 c) ,(integer->integer-bytes (term c) 8 #f #f)]
  [(const->bstr f32 c) ,(real->floating-point-bytes (term c) 4 #f)]
  [(const->bstr f64 c) ,(real->floating-point-bytes (term c) 8 #f)])

(define-metafunction WASMrt
  const->packed-bstr : t natural c -> bstr
  [(const->packed-bstr inn (name width natural) c)
   ,(integer->integer-bytes (modulo (term c) (expt 2 (term width))) (/ (term width) 8) #f #f)])

(define-metafunction WASMrt
  bstr->const : t bstr -> c
  [(bstr->const inn bstr) ,(integer-bytes->integer (term bstr) #f #f)]
  [(bstr->const f32 bstr) ,(real->single-flonum (floating-point-bytes->real (term bstr) #f))]
  [(bstr->const f64 bstr) ,(real->double-flonum (floating-point-bytes->real (term bstr) #f))])

(define-metafunction WASMrt
  packed-bstr->const : t sx bstr -> c
  [(packed-bstr->const inn signed bstr) ,(to-unsigned-sized (term (bit-width inn)) (integer-bytes->integer (term bstr) #t #f))]
  [(packed-bstr->const inn unsigned bstr) ,(integer-bytes->integer (term bstr) #f #f)])