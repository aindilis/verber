;;
;;    
;;    -------------------------------------
;;    |                |                  |
;;    |                |      lab         |
;;    |                |                  |
;;    |      store     |-------   --------|
;;    |                                   |
;;    |                |      NE_room     |
;;    |                |                  |
;;    |------   ---------------   --------|
;;    |                |                  |
;;    |                |                  |
;;    |                                   |
;;    |    SW_room             dep        |
;;    |                |                  |
;;    |                |                  |
;;    -------------------------------------
;;
;;

(define (domain robot_navigation)
  (:types room)
  (:constants store lab NE_room SW_room dep - room)
  (:functions  (robot_position) - room)

  (:action move_robot_up
     :precondition (or (= (robot_position) SW_room ) 
                       (= (robot_position) dep     )
                       (= (robot_position) NE_room ))
     :effect (and
               (when (= (robot_position) SW_room ) (assign (robot_position) store   ))
               (when (= (robot_position) dep     ) (assign (robot_position) NE_room ))
               (when (= (robot_position) NE_room ) (assign (robot_position) lab     ))))

  (:action move_robot_down
     :precondition (or (= (robot_position) store   ) 
                       (= (robot_position) lab     )
                       (= (robot_position) NE_room ))
     :effect (and
               (when (= (robot_position) store   ) (assign (robot_position) SW_room ))
               (when (= (robot_position) lab     ) (assign (robot_position) NE_room ))
               (when (= (robot_position) NE_room ) (assign (robot_position) dep     ))))

  (:action move_robot_right
     :precondition (or (= (robot_position) SW_room ) 
                       (= (robot_position) store   ))
     :effect (and
               (when (= (robot_position) SW_room ) (assign (robot_position) dep))
               (when (= (robot_position) store   ) (assign (robot_position) NE_room))))

  (:action move_robot_left
     :precondition (or (= (robot_position) dep     ) 
                       (= (robot_position) NE_room ))
     :effect (and
               (when (= (robot_position) dep     ) (assign (robot_position) SW_room ))
               (when (= (robot_position) NE_room ) (assign (robot_position) store   ))))
)


