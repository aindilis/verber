;; $VAR1 = {
;;           'Units' => undef,
;;           'Includes' => {}
;;         };

(define
 (domain billeasy)
 (:requirements :typing :negative-preconditions :durative-actions :disjunctive-preconditions :conditional-effects :derived-predicates :timed-initial-literals :fluents :equality)
 (:types transactionType product accountHolder - object amount - number person corporation - accountHolder)
 (:predicates
  (own ?pe - person ?pr - product))
 (:functions
  (balance ?a - accountHolder)
  (cost ?pr - product)
  (promiseToPay ?a1 ?a2 - accountHolder))
 (:durative-action buy :parameters
  (?pe - person ?pr - product) :duration
  (= ?duration 0) :condition
  (and
   (at start (not (own ?pe ?pr)))
   (at start (>= (balance ?pe) (cost ?pr)))) :effect
  (and
   (at end (own ?pe ?pr))
   (at end (decrease (balance ?pe) (cost ?pr)))))
 (:durative-action pay :parameters
  (?a1 ?a2 - accountHolder) :duration
  (= ?duration 0) :condition
  (and
   (at start (>= (balance ?a1) (promiseToPay ?a1 ?a2)))) :effect
  (and
   (at end (and (decrease (balance ?a1) (promiseToPay ?a1 ?a2)) (increase (balance ?a2) (promiseToPay ?a1 ?a2)) (assign (promiseToPay ?a1 ?a2) 0))))))