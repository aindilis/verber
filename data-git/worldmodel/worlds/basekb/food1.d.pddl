;; $VAR1 = {
;;           'Includes' => {
;;                           'BASE_FOOD1' => {}
;;                         },
;;           'Units' => undef
;;         };

(define
 (domain BASE_FOOD1)
 (:requirements :typing :derived-predicates)
 (:types mealtype - collection)
 (:functions
  (food-ingested ?p - person)
  (how-filling ?m - mealtype ?p - person)
  (hunger-level ?p - person)
  (rate-of-eating ?p - person)))