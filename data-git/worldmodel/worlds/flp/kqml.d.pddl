(define (domain kqml)

 (:requirements :negative-preconditions :conditional-effects
  :equality :typing :fluents :durative-actions
  :derived-predicates)

 (:types 
  person - intelligentAgent
  expression assertion - platonic-object
  )
 
 (:predicates
  (believe ?a - intelligentAgent ?x - assertion)
  (know ?a - intelligentAgent ?x - assertion)
  (want ?a - intelligentAgent ?x - assertion)
  (int ?a - intelligentAgent ?x - assertion)
  (equal ?e1 - expression ?e2 - expression)
  )

 (:functions
  (a ?a - x)
  )

 ;; tell(A,B,X) A states to B that A believes the content to be true.
 (:durative-action tell-a
  :parameters (?a ?b - intelligentAgent ?x - assertion)
  :duration (= ?duration 0)
  :condition (and
	      ;; Pre(A):
	      (at start
	       (believe ?a ?x))
	      (at start
	       (exists (?s)
		(know ?a (want ?b (know ?b ?s)))))
	      )
  :effect (and
	   ;; Post(A):
	   (at end
	    (know ?a
	     (know ?b
	      (believe ?a ?x))))
	   )
  )

 (:durative-action tell-b
  ;; tell(A,B,X) A states to B that A believes the content to be true.
  :parameters (?a ?b - intelligentAgent ?x - assertion)
  :duration (= ?duration 0)
  :condition (and
	      ;; Pre(B):
	      (at start
	       (exists (?s)
		(or
		 (equal ?s (believe ?b ?x))
		 (equal ?s (not (believe ?b ?x))))))
	      (at start
	       (exists (?s)
		(int ?b (know ?b ?s))))
	      )
  :effect (and
	   ;; Post(B):
	   (at end
	    (know ?b
	     (believe ?a ?x)))
	   )
  )
 )

