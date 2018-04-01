

(define
 (problem flpCausal1)
 (:domain flpCausal)
 (:objects d c b a - event co - condition)
 (:init
  (at 2 (happened a))
  (directlyCauses a b)
  (directlyCauses b c)
  (directlyCauses c d))
 (:goal
  (and
   (aboutToHappen d)))
 (:metric minimize
  (total-time)))