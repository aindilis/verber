

(define
 (problem flpCausal1p1)
 (:domain flpCausal1)
 (:objects d c b a - event co - condition)
 (:init
  (at 2 (happened a))
  (directlyCauses a b)
  (directlyCauses b c)
  (directlyCauses c d))
 (:goal
  (and
   (happened d)))
 (:metric minimize
  (total-time)))