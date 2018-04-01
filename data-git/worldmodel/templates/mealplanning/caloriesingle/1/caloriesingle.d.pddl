;; <domain-file>

(define (domain mealPlanningPantry)

 ;; (:timing
 ;;  (units 0000-00-00_01:00:00)
 ;;  )

 (:requirements
  :negative-preconditions :conditional-effects :equality :typing
  :fluents :durative-actions :derived-predicates
  :disjunctive-preconditions :timed-initial-literals
  )

 (:types
  LOCATION PRODUCT INSTANCE RECIPE INGREDIENT UNIT SUPPLIER - object
  )
 
 (:predicates
  (storage_location ?location - LOCATION)
  (instanceFn ?product - PRODUCT ?instance - INSTANCE)
  (discarded ?instance - INSTANCE)
  (hasIngredient ?recipe - RECIPE ?ingredient - INGREDIENT)
  (prepared ?recipe - RECIPE)
  )

 (:functions
  (hasIngredientAmount ?recipe - RECIPE ?ingredient - INGREDIENT ?unit - UNIT)
  (productContainsAmount ?product - PRODUCT ?ingredient - INGREDIENT ?unit - UNIT)
  (instanceContainsAmount ?instance - PRODUCT ?ingredient - INGREDIENT ?unit - UNIT)
  (costs ?product - PRODUCT ?supplier - SUPPLIER)
  )

 ;; DURATIVE ACTIONS
 (:durative-action PREPARE_RECIPE
  :parameters (?recipe - RECIPE)
  :duration (= ?duration 0.1)
  :condition (and
 	      (at start (forall (?ingredient - INGREDIENT)
 			 (when
			  (hasIngredient ?recipe ?ingredient)
 			  (and
			   (productContains ?product ?ingredient)
			   (instanceFn ?product ?instance)
			   (>=
			    (instanceRemainingAmount ?instance ?ingredient ?unit)
			    (hasIngredientAmount ?recipe ?ingredient ?unit)
			    )
			   )
			  )
			 )
	       )
	      )
  :effect (and 
	   (at end (forall (?ingredient - INGREDIENT)
		    (when
		     (hasIngredient ?recipe ?ingredient)
		     (and
		      (productContains ?product ?ingredient)
		      (instanceFn ?product ?instance)
		      (assign
		       (instanceRemainingAmount ?instance ?ingredient ?unit)
		       (-
			(instanceRemainingAmount ?instance ?ingredient ?unit)
			(hasIngredientAmount ?recipe ?ingredient ?unit)
			)
		       )
		      )
		     )
		    )
	    )
	   (prepared ?recipe)
	   (at end (assign (actions) (+ (actions) 1)))
 	   )
  )

 ;; (:durative-action DISCARD
 ;;  :parameters (?instance - INSTANCE)
 ;;  :duration (= ?duration 0.1)
 ;;  :condition (and
 ;; 	      (at start (at-location ?p ?l))
 ;; 	      )
 ;;  :effect (and 
 ;; 	   (at end (assign (actions) (+ (actions) 1)))
 ;; 	   )
 ;;  )
 )

;; </domain-file>
