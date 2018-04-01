;; Planning out for todays tasks, so that I can figure out what I need
;; to do and when, given the constraints

(define (problem CLASSES)
  (:domain CLASSES)
  (:objects	
   AndrewDougherty - person
   <CLASS-OBJECTS>
   )

  (:init
   ;; class schedule information
   <CLASS-INIT>

   )

  (:goal 
   (and 	
    <CLASS-GOAL>
    )
   )

  )



<CLASS-OBJECTS>
class-such-and-such - class

<CLASS-INIT>
(= (class-length class-such-and-such) 0.86)
(held-in class-such-and-such room-such-and-such)
(at 14.0 (beginning-of class-such-and-such))
(at 14.1 (not (beginning-of class-such-and-such)))


<CLASS-GOAL>
(at end (attended AndrewDougherty class-such-and-such))