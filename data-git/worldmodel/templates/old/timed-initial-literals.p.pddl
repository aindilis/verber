(define
 (problem TIMED-INITIAL-LITERALS)
 (:domain TIMED-INITIAL-LITERALS)
 (:init
  (not (present-and-future))
  (at 10
   (present-and-future))
  )
 (:goal
  (and
   (present-and-future))))
