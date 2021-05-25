#lang rosette

(require rackunit)

(provide (all-defined-out))

; Takes as input a propositional formula and returns
; * 'TAUTOLOGY if every interpretation I satisfies F;
; * 'CONTRADICTION if no interpretation I satisfies F;
; * 'CONTINGENCY if there are two interpretations I and I′ such that I satisfies F and I' does not.
(define (classify F)
  (cond
    ; If nothing causes F to fail, its a Tautology
    [(unsat? (verify (assert F)))
     'TAUTOLOGY]
    ; If nothing causes F to pass, its a Contradiction
    [(unsat? (solve (assert F)))
     'CONTRADICTION]
    ; Else it must be a contingency
    [else
     'CONTINGENCY]))


(define-symbolic* p q r boolean?)

; (p → (q → r)) → (¬r → (¬q → ¬p))
(define f0 (=> (=> p (=> q r)) (=> (! r) (=> (! q) (! p)))))

; (p ∧ q) → (p → q)
(define f1 (=> (&& p q) (=> p q)))

; (p ↔ q) ∧ (q → r) ∧ ¬(¬r → ¬p)
(define f2 (&& (<=> p q) (=> q r) (! (=> (! r) (! q)))))

(check-eq? (classify f0) 'CONTINGENCY)
(check-eq? (classify f1) 'TAUTOLOGY)
(check-eq? (classify f2) 'CONTRADICTION)

