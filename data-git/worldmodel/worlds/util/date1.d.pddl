;; $VAR1 = {
;;           'Includes' => {
;;                           'UTIL_DATE1' => {}
;;                         },
;;           'Units' => undef
;;         };

(define
 (domain UTIL_DATE1)
 (:requirements :typing)
 (:types day-of-week date - text-string)
 (:predicates
  (day-of-week ?date - date ?dow - day-of-week)
  (holiday ?date - date)
  (today ?date - date)
  (weekday ?date - date)
  (weekend ?date - date)
  (workday ?date - date))
 (:derived
  (weekday ?date - date)
  (or
   (day-of-week ?date Monday)
   (day-of-week ?date Tuesday)
   (day-of-week ?date Wednesday)
   (day-of-week ?date Thursday)
   (day-of-week ?date Friday)))
 (:derived
  (weekend ?date - date)
  (or
   (day-of-week ?date Sunday)
   (day-of-week ?date Saturday)))
 (:derived
  (workday ?d - date)
  (and
   (weekday ?d)
   (not
    (holiday ?d)))))