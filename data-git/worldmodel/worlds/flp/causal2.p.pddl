

(define
 (problem flpCausal2p1)
 (:domain flpCausal2)
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