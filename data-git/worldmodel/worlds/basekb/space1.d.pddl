;; $VAR1 = {
;;           'Includes' => {
;;                           'BASEKB_SPACE1' => {}
;;                         },
;;           'Units' => undef
;;         };

(define
 (domain BASEKB_SPACE1)
 (:requirements :typing :derived-predicates)
 (:types stairwell room landing entry-way closet - space officeroom bathroom - room shower location laundry door - object space building - location perimeter-door - door laundry-washing-machine laundry-dryer-machine - container store - building)
 (:predicates
  (at-location ?ob - object ?l - location)
  (closed ?d - door)
  (connected-to ?s1 - space ?s2 - space)
  (has-door ?d - door ?l1 - location ?l2 - location)
  (inaccessible ?l - location)
  (isolated ?l - location))
 (:functions
  (quantity ?c - collection ?l - location))
 (:derived
  (connected-to ?space1 - space ?space2 - space)
  (connected-to ?space2 ?space1))
 (:derived
  (has-door ?door - door ?space1 - space ?space2 - space)
  (has-door ?door ?space2 ?space1)))