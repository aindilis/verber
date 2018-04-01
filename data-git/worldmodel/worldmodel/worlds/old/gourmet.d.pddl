(define (domain gourmet)

 (:requirements :negative-preconditions :conditional-effects
  :equality :typing :fluents :durative-actions
  :derived-predicates)

 (:types 
  tool ingredient - object
  )

 (:predicates
  (checked ?i - ingredient)
  (initialized ?i - ingredient)
  (left_alone ?i - ingredient)
  (served ?i - ingredient)
  (in ?i - ingredient ?t - tool)
  (cooked_into ?i1 - ingredient ?t - tool ?i2 - ingredient)
  (cut_into ?i1 - ingredient ?t - tool ?i2 - ingredient)
  (done_into ?i1 - ingredient ?t - tool ?i2 - ingredient)
  (mixed_into ?i1 - ingredient ?t - tool ?i2 - ingredient)
  (combined_into_2 ?i ?i0 ?i1 - ingredient)
  (combined_into_3 ?i ?i0 ?i1 ?i2 - ingredient)
  (combined_into_4 ?i ?i0 ?i1 ?i2 ?i3 - ingredient)
;;   (combined_into_5 ?i ?i0 ?i1 ?i2 ?i3 ?i4 - ingredient)
;;   (combined_into_6 ?i ?i0 ?i1 ?i2 ?i3 ?i4 ?i5 - ingredient)
;;   (combined_into_7 ?i ?i0 ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 - ingredient)
;;   (combined_into_8 ?i ?i0 ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 - ingredient)
;;   (combined_into_9 ?i ?i0 ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 - ingredient)
;;   (combined_into_10 ?i ?i0 ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9 - ingredient)
;;   (combined_into_11 ?i ?i0 ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9 ?i10 - ingredient)
;;   (combined_into_12 ?i ?i0 ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9 ?i10 ?i11 - ingredient)
;;   (combined_into_13 ?i ?i0 ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9 ?i10 ?i11 ?i12 - ingredient)
;;   (combined_into_14 ?i ?i0 ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9 ?i10 ?i11 ?i12 ?i13 - ingredient)
;;   (combined_into_15 ?i ?i0 ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9 ?i10 ?i11 ?i12 ?i13 ?i14 - ingredient)
  )

 (:durative-action put
  :parameters (?i - ingredient ?t - tool)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (initialized ?i))
	      (at start (not (in ?i ?t)))
	      )
  :effect (and
	   (at end (in ?i ?t))
	   )
  )

 (:durative-action remove
  :parameters (?i - ingredient ?t - tool)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (initialized ?i))
	      (at start (in ?i ?t))
	      )
  :effect (and
	   (at end (not (in ?i ?t)))
	   )
  )

 (:durative-action check
  :parameters (?i - ingredient)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (initialized ?i))
	      (at start (not (checked ?i)))
	      )
  :effect (and
	   (at end (checked ?i))
	   )
  )

 (:durative-action serve
  :parameters (?i - ingredient)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (initialized ?i))
	      (at start (not (served ?i)))
	      )
  :effect (and
	   (at end (served ?i))
	   )
  )

 (:durative-action leave
  :parameters (?i - ingredient)
  :duration (= ?duration 15)
  :condition (and
	      (at start (initialized ?i))
	      (at start (not (left_alone ?i)))
	      )
  :effect (and
	   (at end (left_alone ?i))
	   )
  )

 (:durative-action cook
  :parameters (?i1 - ingredient ?t - tool ?i2 - ingredient)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (not (cooked_into ?i1 ?t ?i2)))
	      (at start (not (initialized ?i2)))
	      )
  :effect (and
	   (at end (cooked_into ?i1 ?t ?i2))
	   (at end (initialized ?i2))
	   )
  )

 (:durative-action mix
  :parameters (?i1 - ingredient ?t - tool ?i2 - ingredient)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (in ?i1 ?t))
	      (at start (not (mixed_into ?i1 ?t ?i2)))
	      (at start (initialized ?i1))
	      (at start (not (initialized ?i2)))
	      )
  :effect (and
	   (at end (mixed_into ?i1 ?t ?i2))
	   (at end (initialized ?i2))
	   )
  )

 (:durative-action cut
  :parameters (?i1 - ingredient ?t - tool ?i2 - ingredient)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (in ?i1 ?t))
	      (at start (not (cut_into ?i1 ?t ?i2)))
	      (at start (initialized ?i1))
	      (at start (not (initialized ?i2)))
	      )
  :effect (and
	   (at end (cut_into ?i1 ?t ?i2))
	   (at end (initialized ?i2))
	   )
  )

 (:durative-action do
  :parameters (?i1 - ingredient ?t - tool ?i2 - ingredient)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (in ?i1 ?t))
	      (at start (not (done_into ?i1 ?t ?i2)))
	      (at start (initialized ?i1))
	      (at start (not (initialized ?i2)))
	      )
  :effect (and
	   (at end (done_into ?i1 ?t ?i2))
	   (at end (initialized ?i2))
	   )
  )

 (:durative-action separate
  :parameters (?i ?i1 ?i2 - ingredient)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (not (initialized ?i1)))
	      (at start (not (initialized ?i2)))
	      ;; (at start (combined ?i ?i1 ?i2))
	      )
  :effect (and
	   (at end (initialized ?i1))
	   (at end (initialized ?i2))
	   (at end (not (combined_into_2 ?i ?i1 ?i2)))
	   )
  )


 (:durative-action combine_2
  :parameters (?i ?i1 ?i2 - ingredient)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (not (initialized ?i)))
	      (at start (not (combined_into_2 ?i ?i1 ?i2)))
	      )
  :effect (and
	   (at end (initialized ?i))
	   (at end (combined_into_2 ?i ?i1 ?i2))
	   )
  )

 (:durative-action combine_3
  :parameters (?i ?i1 ?i2 ?i3 - ingredient)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (not (initialized ?i)))
	      (at start (not (combined_into_3 ?i ?i1 ?i2 ?i3)))
	      )
  :effect (and
	   (at end (initialized ?i))
	   (at end (combined_into_3 ?i ?i1 ?i2 ?i3))
	   )
  )

 (:durative-action combine_4
  :parameters (?i ?i1 ?i2 ?i3 ?i4 - ingredient)
  :duration (= ?duration 0.1)
  :condition (and
	      (at start (not (initialized ?i)))
	      (at start (not (combined_into_4 ?i ?i1 ?i2 ?i3 ?i4)))
	      )
  :effect (and
	   (at end (initialized ?i))
	   (at end (combined_into_4 ?i ?i1 ?i2 ?i3 ?i4))
	   )
  )

;;  (:durative-action combine_5
;;   :parameters (?i ?i1 ?i2 ?i3 ?i4 ?i5 - ingredient)
;;   :duration (= ?duration 0.1)
;;   :condition (and
;; 	      (at start (not (initialized ?i)))
;; 	      (at start (not (combined ?i ?i1 ?i2 ?i3 ?i4 ?i5)))
;; 	      )
;;   :effect (and
;; 	   (at end (initialized ?i))
;; 	   (at end (combined ?i ?i1 ?i2 ?i3 ?i4 ?i5))
;; 	   )
;;   )

;;  (:durative-action combine_6
;;   :parameters (?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 - ingredient)
;;   :duration (= ?duration 0.1)
;;   :condition (and
;; 	      (at start (not (initialized ?i)))
;; 	      (at start (not (combined ?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6)))
;; 	      )
;;   :effect (and
;; 	   (at end (initialized ?i))
;; 	   (at end (combined ?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6))
;; 	   )
;;   )

;;  (:durative-action combine_7
;;   :parameters (?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 - ingredient)
;;   :duration (= ?duration 0.1)
;;   :condition (and
;; 	      (at start (not (initialized ?i)))
;; 	      (at start (not (combined ?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7)))
;; 	      )
;;   :effect (and
;; 	   (at end (initialized ?i))
;; 	   (at end (combined ?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7))
;; 	   )
;;   )

;;  (:durative-action combine_8
;;   :parameters (?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 - ingredient)
;;   :duration (= ?duration 0.1)
;;   :condition (and
;; 	      (at start (not (initialized ?i)))
;; 	      (at start (not (combined ?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8)))
;; 	      )
;;   :effect (and
;; 	   (at end (initialized ?i))
;; 	   (at end (combined ?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8))
;; 	   )
;;   )

;;  (:durative-action combine_9
;;   :parameters (?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9 - ingredient)
;;   :duration (= ?duration 0.1)
;;   :condition (and
;; 	      (at start (not (initialized ?i)))
;; 	      (at start (not (combined ?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9)))
;; 	      )
;;   :effect (and
;; 	   (at end (initialized ?i))
;; 	   (at end (combined ?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9))
;; 	   )
;;   )

;;  (:durative-action combine_10
;;   :parameters (?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9 ?i10 - ingredient)
;;   :duration (= ?duration 0.1)
;;   :condition (and
;; 	      (at start (not (initialized ?i)))
;; 	      (at start (not (combined ?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9 ?i10)))
;; 	      )
;;   :effect (and
;; 	   (at end (initialized ?i))
;; 	   (at end (combined ?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9 ?i10))
;; 	   )
;;   )

;;  (:durative-action combine_11
;;   :parameters (?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9 ?i10 ?i11 - ingredient)
;;   :duration (= ?duration 0.1)
;;   :condition (and
;; 	      (at start (not (initialized ?i)))
;; 	      (at start (not (combined ?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9 ?i10 ?i11)))
;; 	      )
;;   :effect (and
;; 	   (at end (initialized ?i))
;; 	   (at end (combined ?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9 ?i10 ?i11))
;; 	   )
;;   )

;;  (:durative-action combine_12
;;   :parameters (?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9 ?i10 ?i11 ?i12 - ingredient)
;;   :duration (= ?duration 0.1)
;;   :condition (and
;; 	      (at start (not (initialized ?i)))
;; 	      (at start (not (combined ?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9 ?i10 ?i11 ?i12)))
;; 	      )
;;   :effect (and
;; 	   (at end (initialized ?i))
;; 	   (at end (combined ?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9 ?i10 ?i11 ?i12))
;; 	   )
;;   )

;;  (:durative-action combine_13
;;   :parameters (?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9 ?i10 ?i11 ?i12 ?i13 - ingredient)
;;   :duration (= ?duration 0.1)
;;   :condition (and
;; 	      (at start (not (initialized ?i)))
;; 	      (at start (not (combined ?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9 ?i10 ?i11 ?i12 ?i13)))
;; 	      )
;;   :effect (and
;; 	   (at end (initialized ?i))
;; 	   (at end (combined ?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9 ?i10 ?i11 ?i12 ?i13))
;; 	   )
;;   )

;;  (:durative-action combine_14
;;   :parameters (?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9 ?i10 ?i11 ?i12 ?i13 ?i14 - ingredient)
;;   :duration (= ?duration 0.1)
;;   :condition (and
;; 	      (at start (not (initialized ?i)))
;; 	      (at start (not (combined ?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9 ?i10 ?i11 ?i12 ?i13 ?i14)))
;; 	      )
;;   :effect (and
;; 	   (at end (initialized ?i))
;; 	   (at end (combined ?i ?i1 ?i2 ?i3 ?i4 ?i5 ?i6 ?i7 ?i8 ?i9 ?i10 ?i11 ?i12 ?i13 ?i14))
;; 	   )
;;   )

 )
