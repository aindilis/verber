;; $VAR1 = {
;;           'Includes' => {
;;                           'BASEKB_DEONTIC1' => {}
;;                         },
;;           'Units' => undef
;;         };

(define
 (domain BASEKB_DEONTIC1)
 (:requirements :typing :derived-predicates)
 (:types)
 (:predicates
  (has-permission-to-use ?p - person ?o - object)))