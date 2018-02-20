(task do-job
      (task arrive nurse morning)
      (task leave nurse morning)
      (task arrive nurse evening)
      (task arrive nurse morning))

(event (arrive nurse morning))

(event (time 9:00 am)
       (and
	(task retrieve newspaper)
	(task retrieve mail)
	(task clock in)
	(task awaken patient)
	;; (required-task administer morning-medication)
	(as needed
	    (assist with dressing))
	(as needed
	    (task go-to-bathroom patient))
	(as needed
	    (task adjust heat thermostat))
	(as needed
	    (task assist patient moving-around-apartment))
	(if (has patient hearing-aid)
	    (task adjust hearing aid in left ear))
	;; (required-task cook-and-serve breakfast)
	(as needed
	    (task assist-with breakfast)
	    ;; Let patient do as much as possible.
	    )
	(required-task administer morning-exercises)
	(task wash breakfast-dishes)
	(as needed
	    (and
	     (task clean apartment, run sweeper when needed, dust)
	     (task pick up things from floor)
	     (task washing when needed)
	     ;; Washer/Dryer in basement.
	     (as needed (bath-or-shower patient))
	     ;; Ignore patient's objections.
	     )
	    )
	))

(event (leave nurse morning)
       (task blinds open in bedroom)
       (task check heat)
       (task check patient))

(depends
 (fix breakfast)
 (administer morning exercises))

(event (falls patient)
       (if (cannot-get-up patient) 
	   (assist nurse patient
		   (get-up patient))))

(event (leave nurse evening)
       (preconditions
	(if (going to storm before morning)
	    (shut windows))))

(rules
 (after (time 9:00 am)
	(not (ok (sleep patient in-bed))))
 (when (moving patient around apartment)
   (and
    (wear patient helmet)
    (use walker)))
 (when (sitting patient)
   (ok (not (wear patient helmet))))
 (when (before bedtime)
   (not 
    (and
     (lie patient bed)
     (sleep patient))))
 (when (has-freetime patient)
   (ok (sleep-doze patient living-room-chair)))
 (each (day)
       (as needed
	   (shower patient)))
 (at-least-once-each (week)
		     (shower patient)
		     ;; Despite his objections
		     )
 (drink patient (all lachulose))
 (ok (choose patient bedtime))
 (after (awaken patient)
	(change-into patient daytime-clothes))
 (before (going-to-bed patient)
   (change-into patient pajamas))
 (when (moving-around-apartment patient)
   (wearing patient helmet))
 (before (dinnertime)
	 (suggest-to patient
		     (do evening-exercises)
		     ;; he will stall and avoid after he eats
		     ))
 (if (no lachulose)
     (wash-down-with medication water)))


(task (awaken patient)
      (task nudge patient)
      (task open curtains and blinds in bedroom)
      (task open blinds in second bedroom)
      (task swing-over-edge-of-bed legs)
      (task hold-in-front-of patient medication)
      ;; patient  should take his medication  immediately after waking
      ;; and before eating. If left for later he avoids his meds and
      ;; stalls.
      )

(setq akahige-medication-list
      (list (REDACTED REDACTED mg)
	    (REDACTED REDACTED mg)
	    (REDACTED REDACTED mg)
	    (REDACTED REDACTED mg)
	    (REDACTED)))

(required-task administer evening-medication
      (and
       (take patient (pill REDACTED mg REDACTED))
       (take patient (pill REDACTED mg REDACTED))
       (take patient (pill REDACTED mg REDACTED))
       (take patient (pill REDACTED mg REDACTED))
       (take patient (pill REDACTED mg REDACTED))
       (take patient (fluid REDACTED cc REDACTED))
       )
      (execute 'query-bottle-counts))

(task query-bottle-counts ()
      "Determine how many pills remain.  Count if it is easy to count,
like under 15, otherwise give a guess range"
      ())

(required-task administer morning-medication
      (and
       (take patient (pill REDACTED mg REDACTED))
       (take patient (pill REDACTED mg REDACTED))
       (take patient (pill REDACTED mg REDACTED))
       (take patient (pill REDACTED mg REDACTED))
       (take patient (fluid REDACTED cc REDACTED))
       ))

(event (arrive nurse evening)
       (and
	(as needed
	    (task assist patient moving-around-apartment))
	(if (has patient hearing-aid)
	    (task adjust hearing aid in left ear))
	(required-task administer evening-exercises)
	(task set-table for dinner)
	(task assist with dinner)
	;; let patient do as much as possible
	((or (around (8:00 pm))
	    (after dinner))
	 (required-task administer evening-medication))
	(task (and 
	       (wash dishes)
	       (cleanup table)))
	(task
	     (task clean apartment, run sweeper when needed, dust)
	     (task clean-up floor)
	     (task washing when needed)
	     ;; Washer/Dryer in basement.
	     (as needed
		 (bath-or-shower patient))
	     ;; Ignore patient's objections.
	     )
	(event (leave nurse evening))
	)
       )

(event (leave nurse evening)
       (refill ice cubes)
       (task close bedroom-blinds)
       (task check heat)
       (task check patient)
       (task (and
	      (move trash-bag garbage-can)
	      (shut-lid garbage-can)))
       (task move recyclables blue-can)
)

(event (on (and
	    Thursday
	    Sunday)
	   ;; outside to do walking exercise.  Go around block or more
	   ;; if patient OK
	   (task trip patient around-the-block))
)

(event (occasionally)
       (or
	(task trip patient REDACTED)
	(task trip patient (or
			  Sunday-mass
			  evening-church))
	(task trip patient (or
			  other-meetings
			  social-events))))

(task (administer morning-exercises) 
      ;; prepare your flow, get him used to doing exercises right after breakfast?
      ;; move fan into kitchen
      ;; prepare water
      (execute 'akahige-walk-through-exercises)
      (put-into-proper-place description-of-exercise)
)


(task (administer evening-exercises) 
      (execute 'akahige-walk-through-exercises)
      (put-into-proper-place description-of-exercise)
)

(task (assist-with breakfast)
      (put-into-proper-place shaver breakfast-point)
      (after (sits-down patient breakfast-table)
	     (put-into-proper-place walker))
      (task ensure (shaved patient))
      (task ensure (not (moldy food)))
      (task do dishes))

(task (administer morning-medication)
      (task ensure (in-order medicine)))

(task (do-chores nurse)
      (categorize-new-ushell-entries))

(when (has-misplaced patient helmet)
  (put-into-proper-place helmet))

(if (spill nurse ?X)
    (clean-up nurse ?X))

(task clean-up apartment
      (task mop floor))

(put-into-proper-place laxative-measure-glass)
(put-into-proper-place medication-information-card)
