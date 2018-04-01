;; $VAR1 = {
;;           'Includes' => {
;;                           'BASEKB_ECONOMIC1' => {}
;;                         },
;;           'Units' => undef
;;         };

(define
 (domain BASEKB_ECONOMIC1)
 (:requirements :derived-predicates :typing)
 (:types)
 (:predicates
  (has-fee-for-use ?o - object))
 (:functions
  (cash ?p - person)
  (fee-for-use ?o - object)))