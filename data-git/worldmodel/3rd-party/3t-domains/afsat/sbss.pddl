;; -*- Mode: LISP; Syntax: ANSI-COMMON-LISP; Package: AP -*- 
(in-package :ap)
;;;
;;; Based on sat.pddl, but instead of an agent imaging land sites, it's imaging other satellites
;;; It slews and shoots while in goesynchronous orbit, and periodiclly downlinks the images
;;;

(define (domain sat-domain)
    (:requirements :durative-actions)
  (:extends physob Geography)
  (:types state - object	  
	  image - object
	  attitude - object
	  fuel - object
	  sat_tgt_name - object
	  down-link-loc - location
	  satellite - agent
	  camera shutter comms target frequency - object)
  (:constants 
   freq1 freq2 freq3 - frequency
   shutter1 - shutter
   imager1 - camera 
   comms1 - comms 
   SpaceSat - satellite
   opened closed on off done - state
   africa libya iraq iran afghan_pakistan_border china north_korea mozambique - location
   downlink1 downlink2 downlink3 - down-link-loc
   start_tgt GOES_3 TDRS_1 GALAXY_5 ASTRA_1C DIRECTV_2_[DBS_2] BRASILSAT_B1 INTELSAT_701_[IS-701] GALAXY_6 INMARSAT_2-F4 GOES_7
 ASIASAT_1 INMARSAT_2-F2 GOES_8 INTELSAT2 APSTAR_1 ESIAFI_1 GSTAR_4 - sat_tgt_name
      )
  (:predicates (sat-jobs-done ?s - satellite)
	       (downlink-ready-at ?s  - satellite ?dl - down-link-loc)
	       (downlink_frequency ?d - down-link-loc ?f - frequency)
	       ;;(tuned-to ?o - satellite ?d - down-link-loc)
	       (Delay_a ?s - sat_tgt_name)
	       (Delay_a2 ?s - sat_tgt_name)
	       (images_taken&downlinked  ?s  -  satellite ?img1 ?img2 ?img3 - sat_tgt_name)
	       (cluster3_taken ?sat -  satellite ?t - sat_tgt_name)
	       ;;(last-tgt ?sat - satellite ?t - sat_tgt_name)
	       (has-camera ?sat - satellite ?c - camera)
	       (has-shutter ?sat - satellite ?s - shutter)
	       (has-comms ?sat - satellite ?co - comms)
	       ;;(shutter-state ?sat - satellite ?s - state)
	       ;;(camera-state ?sat - satellite ?s - state)
	       ;;(comms-state ?sat - satellite ?s - state)
	       (downlink-location ?sat - satellite ?dloc - down-link-loc)
	       (image_taken ?s - satellite ?n - sat_tgt_name)
	       (images_taken ?mg1 ?ing2 ?img3 - sat_tgt_name)
	       (image_stored ?s - satellite ?name - sat_tgt_name)
	       (image_stored2 ?s - satellite ?name - sat_tgt_name)
	       (image_stored3 ?s - satellite ?name - sat_tgt_name)
	       (image_sent ?s ?name - sat_tgt_name)(cluster_sent ?s ?name - sat_tgt_name)
	       (image_downloaded ?s - satellite ?name - sat_tgt_name)
	       (images_downloaded ?s - satellite ?mg1 ?ing2 ?img3 - sat_tgt_name)
	       (processed ?loc1 ?loc2 ?loc3 - location)
	       (imaged ?loc1 ?loc2 ?loc3 - location)
	       (pointed_at ?s - satellite ?img - sat_tgt_name)
	       (pointed&imaged ?s - satellite ?img - sat_tgt_name)
	       (ready_for_loc ?loc - location)
	       (current-attitude ?s - satellite ?catt - attitude)
	       (location-attitude ?loc - location ?gatt - attitude)
	       (fuel-level ?s - satellite ?v - fuel)
	       (fuel-for ?loc - location ?f - fuel)
	       (opened - predicate ?o - object)
	       (on - predicate ?o - object)
	       (state ?item - object ?st - state)
	       )
  (:functions
   (shutter-state ?sat - satellite) - state
   (camera-state ?sat - satellite) - state
   (comms-state ?sat - satellite) - state
   (last-tgt ?sat - satellite) - sat_tgt_name
   (tuned-to ?o - satellite) - down-link-loc
  )
)
;;;(owl:Restriction 'camera-state 'owl:cardinality 1)
;;;(owl:Restriction 'shutter-state 'owl:cardinality 1)
;;;(owl:Restriction 'comms-state 'owl:cardinality 1)
;;;(owl:Restriction 'last-tgt 'owl:cardinality 1)
;;;(owl:Restriction 'tuned-to 'owl:cardinality 1)

(in-package :cl-user)
(defun fnum-to-accuracy (fnum &optional (num-dec-places 2))
"Used for keeping long irrationals from coming up."
  (/ (fround (* fnum (expt 10 num-dec-places))) 
     (expt 10.0 num-dec-places)))
(in-package :ap)

(define (durative-action open_shutter)
    :parameters (?o - satellite)
    :vars (?shutter - (has-shutter ?o))
    :duration 1.0 
    :effect (at end (shutter-state ?o opened))
    :comment "opens shutter.")
	
(define (durative-action close_shutter)
    :parameters (?o - satellite)
    :vars (?shutter - (has-shutter ?o))
    :duration 1.0 
    :effect (at end (shutter-state ?o closed))
    :comment "closes shutter.")


(define (durative-action turn-on-camera)
    :parameters (?o - satellite)
    :vars (?cam - (has-camera ?o))
    :duration 1.0 
    :effect (at end (camera-state ?o on))
    :comment "turns on camera.")
	
(define (durative-action turn-off-camera)
    :parameters (?o - satellite)
    :vars (?cam - (has-camera ?o))
    :duration 1.0 
    :effect (at end (camera-state ?o off))
    :comment "turns off camera.")

;;; These tgts com from the list of tgts MB emailed me.
(defparameter *target-sats*
'((0 start_tgt)(1 GOES_3) (2 TDRS_1) (3 GALAXY_5) (4 ASTRA_1C) (5 DIRECTV_2_[DBS_2]) (6 BRASILSAT_B1) (7 INTELSAT_701_[IS-701])
 (8 GALAXY_6) (9 INMARSAT_2-F4) (10 GOES_7) (11 ASIASAT_1) (12 INMARSAT_2-F2) (13 GOES_8) (14 INTELSAT2) (15 APSTAR_1)
 (16 ESIAFI_1) (17 GSTAR_4)))

;;; *slew-string* is from a slew table MB emailed me.  The numbers in brackets refer to the tgts."
(defparameter *slew-string*
    "    slewTimes[0][0] =  0;
    slewTimes[0][1] = 75;
    slewTimes[0][2] = 60;
    slewTimes[0][3] = 75;
    slewTimes[0][4] = 60;
    slewTimes[0][5] = 70;
    slewTimes[0][6] = 65;
    slewTimes[0][7] = 65;
    slewTimes[0][8] = 80;
    slewTimes[0][9] = 70;
    slewTimes[0][10] = 99;
    slewTimes[0][11] = 99;
    slewTimes[0][12] = 99;
    slewTimes[0][13] = 99;
    slewTimes[0][14] = 99;
    slewTimes[0][15] = 99;
    slewTimes[0][16] = 99;
    slewTimes[0][17] = 99;
    slewTimes [1][0] = 75;
    slewTimes [1][2] = 10;
    slewTimes [1][3] = 31;
    slewTimes [1][4] = 23;
    slewTimes [1][5] = 20;
    slewTimes [1][6] = 9;
    slewTimes [1][7] = 15;
    slewTimes [1][8] = 15;
    slewTimes [1][9] = 29;
    slewTimes [1][10] = 14;
    slewTimes [1][11] = 4;
    slewTimes [1][12] = 8;
    slewTimes [1][13] = 5;
    slewTimes [1][14] = 20;
    slewTimes [1][15] = 23;
    slewTimes [1][16] = 33;
    slewTimes [1][17] = 32;
    slewTimes [2][0] = 60;
    slewTimes [2][1] = 10;
    slewTimes [2][3] = 31;
    slewTimes [2][4] = 33;
    slewTimes [2][5] = 29;
    slewTimes [2][6] = 18;
    slewTimes [2][7] = 7;
    slewTimes [2][8] = 25;
    slewTimes [2][9] = 20;
    slewTimes [2][10] = 5;
    slewTimes [2][11] = 5;
    slewTimes [2][12] = 2;
    slewTimes [2][13] = 14;
    slewTimes [2][14] = 11;
    slewTimes [2][15] = 14;
    slewTimes [2][16] = 26;
    slewTimes [2][17] = 29;
    slewTimes [3][0] = 75;
    slewTimes [3][1] = 31;
    slewTimes [3][2] = 31;
    slewTimes [3][4] = 8;
    slewTimes [3][5] = 11;
    slewTimes [3][6] = 22;
    slewTimes [3][7] = 24;
    slewTimes [3][8] = 16;
    slewTimes [3][9] = 11;
    slewTimes [3][10] = 26;
    slewTimes [3][11] = 35;
    slewTimes [3][12] = 32;
    slewTimes [3][13] = 27;
    slewTimes [3][14] = 20;
    slewTimes [3][15] = 17;
    slewTimes [3][16] = 5;
    slewTimes [3][17] = 2;
    slewTimes [4][0] = 60;
    slewTimes [4][1] = 23;
    slewTimes [4][2] = 33;
    slewTimes [4][3] = 8;
    slewTimes [4][5] = 3;
    slewTimes [4][6] = 14;
    slewTimes [4][7] = 32;
    slewTimes [4][8] = 8;
    slewTimes [4][9] = 19;
    slewTimes [4][10] = 34;
    slewTimes [4][11] = 27;
    slewTimes [4][12] = 31;
    slewTimes [4][13] = 19;
    slewTimes [4][14] = 28;
    slewTimes [4][15] = 25;
    slewTimes [4][16] = 13;
    slewTimes [4][17] = 10;
    slewTimes [5][0] = 70;
    slewTimes [5][1] = 20;
    slewTimes [5][2] = 29;
    slewTimes [5][3] = 11;
    slewTimes [5][4] = 3;
    slewTimes [5][6] = 11;
    slewTimes [5][7] = 34;
    slewTimes [5][8] = 5;
    slewTimes [5][9] = 23;
    slewTimes [5][10] = 34;
    slewTimes [5][11] = 24;
    slewTimes [5][12] = 28;
    slewTimes [5][13] = 15;
    slewTimes [5][14] = 31;
    slewTimes [5][15] = 29;
    slewTimes [5][16] = 17;
    slewTimes [5][17] = 14;
    slewTimes [6][0] = 65;
    slewTimes [6][1] = 9;
    slewTimes [6][2] = 18;
    slewTimes [6][3] = 22;
    slewTimes [6][4] = 14;
    slewTimes [6][5] = 11;
    slewTimes [6][7] = 25;
    slewTimes [6][8] = 6;
    slewTimes [6][9] = 33;
    slewTimes [6][10] = 23;
    slewTimes [6][11] = 13;
    slewTimes [6][12] = 17;
    slewTimes [6][13] = 4;
    slewTimes [6][14] = 29;
    slewTimes [6][15] = 32;
    slewTimes [6][16] = 27;
    slewTimes [6][17] = 25;
    slewTimes [7][0] = 65;
    slewTimes [7][1] = 15;
    slewTimes [7][2] = 7;
    slewTimes [7][3] = 24;
    slewTimes [7][4] = 32;
    slewTimes [7][5] = 34;
    slewTimes [7][6] = 25;
    slewTimes [7][8] = 30;
    slewTimes [7][9] = 13;
    slewTimes [7][10] = 3;
    slewTimes [7][11] = 12;
    slewTimes [7][12] = 8;
    slewTimes [7][13] = 20;
    slewTimes [7][14] = 4;
    slewTimes [7][15] = 7;
    slewTimes [7][16] = 19;
    slewTimes [7][17] = 22;
    slewTimes [8][0] = 80;
    slewTimes [8][1] = 15;
    slewTimes [8][2] = 25;
    slewTimes [8][3] = 16;
    slewTimes [8][4] = 8;
    slewTimes [8][5] = 5;
    slewTimes [8][6] = 6;
    slewTimes [8][7] = 30;
    slewTimes [8][9] = 27;
    slewTimes [8][10] = 29;
    slewTimes [8][11] = 19;
    slewTimes [8][12] = 23;
    slewTimes [8][13] = 10;
    slewTimes [8][14] = 34;
    slewTimes [8][15] = 33;
    slewTimes [8][16] = 21;
    slewTimes [8][17] = 18;
    slewTimes [9][0] = 70;
    slewTimes [9][1] = 29;
    slewTimes [9][2] = 20;
    slewTimes [9][3] = 11;
    slewTimes [9][4] = 19;
    slewTimes [9][5] = 23;
    slewTimes [9][6] = 33;
    slewTimes [9][7] = 13;
    slewTimes [9][8] = 27;
    slewTimes [9][10] = 15;
    slewTimes [9][11] = 25;
    slewTimes [9][12] = 21;
    slewTimes [9][13] = 33;
    slewTimes [9][14] = 9;
    slewTimes [9][15] = 6;
    slewTimes [9][16] = 6;
    slewTimes [9][17] = 9;
    slewTimes [10][0] = 99;
    slewTimes [10][1] = 14;
    slewTimes [10][2] = 5;
    slewTimes [10][3] = 26;
    slewTimes [10][4] = 34;
    slewTimes [10][5] = 34;
    slewTimes [10][6] = 23;
    slewTimes [10][7] = 3;
    slewTimes [10][8] = 29;
    slewTimes [10][9] = 15;
    slewTimes [10][11] = 10;
    slewTimes [10][12] = 6;
    slewTimes [10][13] = 19;
    slewTimes [10][14] = 6;
    slewTimes [10][15] = 9;
    slewTimes [10][16] = 21;
    slewTimes [10][17] = 24;
    slewTimes [11][0] = 99;
    slewTimes [11][1] = 4;
    slewTimes [11][2] = 5;
    slewTimes [11][3] = 35;
    slewTimes [11][4] = 27;
    slewTimes [11][5] = 24;
    slewTimes [11][6] = 13;
    slewTimes [11][7] = 12;
    slewTimes [11][8] = 19;
    slewTimes [11][9] = 25;
    slewTimes [11][10] = 10;
    slewTimes [11][12] = 4;
    slewTimes [11][13] = 9;
    slewTimes [11][14] = 16;
    slewTimes [11][15] = 19;
    slewTimes [11][16] = 31;
    slewTimes [11][17] = 34;
    slewTimes [12][0] = 99;
    slewTimes [12][1] = 8;
    slewTimes [12][2] = 2;
    slewTimes [12][3] = 32;
    slewTimes [12][4] = 31;
    slewTimes [12][5] = 28;
    slewTimes [12][6] = 17;
    slewTimes [12][7] = 8;
    slewTimes [12][8] = 23;
    slewTimes [12][9] = 21;
    slewTimes [12][10] = 6;
    slewTimes [12][11] = 4;
    slewTimes [12][13] = 13;
    slewTimes [12][14] = 12;
    slewTimes [12][15] = 15;
    slewTimes [12][16] = 27;
    slewTimes [12][17] = 30;
    slewTimes [13][0] = 99;
    slewTimes [13][1] = 5;
    slewTimes [13][2] = 14;
    slewTimes [13][3] = 27;
    slewTimes [13][4] = 19;
    slewTimes [13][5] = 15;
    slewTimes [13][6] = 4;
    slewTimes [13][7] = 20;
    slewTimes [13][8] = 10;
    slewTimes [13][9] = 33;
    slewTimes [13][10] = 19;
    slewTimes [13][11] = 9;
    slewTimes [13][12] = 13;
    slewTimes [13][14] = 25;
    slewTimes [13][15] = 28;
    slewTimes [13][16] = 32;
    slewTimes [13][17] = 29;
    slewTimes [14][0] = 99;
    slewTimes [14][1] = 20;
    slewTimes [14][2] = 11;
    slewTimes [14][3] = 20;
    slewTimes [14][4] = 28;
    slewTimes [14][5] = 31;
    slewTimes [14][6] = 29;
    slewTimes [14][7] = 4;
    slewTimes [14][8] = 34;
    slewTimes [14][9] = 9;
    slewTimes [14][10] = 6;
    slewTimes [14][11] = 16;
    slewTimes [14][12] = 12;
    slewTimes [14][13] = 25;
    slewTimes [14][15] = 3;
    slewTimes [14][16] = 15;
    slewTimes [14][17] = 18;
    slewTimes [15][0] = 99;
    slewTimes [15][1] = 23;
    slewTimes [15][2] = 14;
    slewTimes [15][3] = 17;
    slewTimes [15][4] = 25;
    slewTimes [15][5] = 29;
    slewTimes [15][6] = 32;
    slewTimes [15][7] = 7;
    slewTimes [15][8] = 33;
    slewTimes [15][9] = 6;
    slewTimes [15][10] = 9;
    slewTimes [15][11] = 19;
    slewTimes [15][12] = 15;
    slewTimes [15][13] = 28;
    slewTimes [15][14] = 3;
    slewTimes [15][16] = 12;
    slewTimes [15][17] = 15;
    slewTimes [16][0] = 99;
    slewTimes [16][1] = 33;
    slewTimes [16][2] = 26;
    slewTimes [16][3] = 5;
    slewTimes [16][4] = 13;
    slewTimes [16][5] = 17;
    slewTimes [16][6] = 27;
    slewTimes [16][7] = 19;
    slewTimes [16][8] = 21;
    slewTimes [16][9] = 6;
    slewTimes [16][10] = 21;
    slewTimes [16][11] = 31;
    slewTimes [16][12] = 27;
    slewTimes [16][13] = 32;
    slewTimes [16][14] = 15;
    slewTimes [16][15] = 12;
    slewTimes [16][17] = 3;
    slewTimes [17][0] = 99;
    slewTimes [17][1] = 32;
    slewTimes [17][2] = 29;
    slewTimes [17][3] = 2;
    slewTimes [17][4] = 10;
    slewTimes [17][5] = 14;
    slewTimes [17][6] = 25;
    slewTimes [17][7] = 22;
    slewTimes [17][8] = 18;
    slewTimes [17][9] = 9;
    slewTimes [17][10] = 24;
    slewTimes [17][11] = 34;
    slewTimes [17][12] = 30;
    slewTimes [17][13] = 29;
    slewTimes [17][14] = 18;
    slewTimes [17][15] = 15;
    slewTimes [17][16] = 3;")

;;; Given a slew string, this function extracts the three numbers.
;;;(setf str "slewTimes[0][0] =  0")
(defun get-slew-time (my-str)
  (let* ((str my-str)
	 (s1pos1 (search "[" str))
	 (s1pos2 (search "]" str))
	 s1 s2 s3)
;;    (print (list s1pos1 s1pos2))
    (setf s1 (read-from-string (subseq str (1+ s1pos1) s1pos2)))
    (setf str (subseq str (1+ s1pos2)))
;;    (print (list s1 str))
    (setf s1pos1 (search "[" str))
    (setf s1pos2 (search "]" str))
;;    (print (list s1pos1 s1pos2))
    (setf s2 (read-from-string (subseq str (1+ s1pos1) s1pos2)))
    (setf str (subseq str (1+ s1pos2)))
;;    (print (list s1 s2 str))
    (setf s1pos1 (search "=" str))
    (setf s1pos2 (search ";" str))
;;    (print (list s1pos1 s1pos2))
    (setf s3 (read-from-string (subseq str (1+ s1pos1) s1pos2)))
    (list s1 s2 s3)))

;;; This gathers the slew numbers and creates *slew-times* from the *target-sats*
(defun collect-slew-times (&optional (slew-string *slew-string*))
  (loop for (from to time ) in 
	(loop with slews = slew-string
	    as spos = (search "slewTimes" slews)
	    as epos = (search ";" slews)
	    until (not spos)
	    collect
	      (prog1
		  (get-slew-time (subseq slews spos epos))
		(setf slews (subseq slews (1+ epos)))))
      collect (list
	       (second (assoc from *target-sats*))
	       (second (assoc to *target-sats*))
	       time)))
	
(defparameter *slew-times* ;;; seconds
    '((START_TGT START_TGT 0) (START_TGT GOES_3 75) (START_TGT TDRS_1 60) (START_TGT GALAXY_5 75) (START_TGT ASTRA_1C 60)
      (START_TGT DIRECTV_2_[DBS_2] 70) (START_TGT BRASILSAT_B1 65) (START_TGT INTELSAT_701_[IS-701] 65)
      (START_TGT GALAXY_6 80) (START_TGT INMARSAT_2-F4 70) (START_TGT GOES_7 99) (START_TGT ASIASAT_1 99)
      (START_TGT INMARSAT_2-F2 99) (START_TGT GOES_8 99) (START_TGT INTELSAT2 99) (START_TGT APSTAR_1 99)
      (START_TGT ESIAFI_1 99) (START_TGT GSTAR_4 99) (GOES_3 START_TGT 75) (GOES_3 TDRS_1 10) (GOES_3 GALAXY_5 31)
      (GOES_3 ASTRA_1C 23) (GOES_3 DIRECTV_2_[DBS_2] 20) (GOES_3 BRASILSAT_B1 9) (GOES_3 INTELSAT_701_[IS-701] 15)
      (GOES_3 GALAXY_6 15) (GOES_3 INMARSAT_2-F4 29) (GOES_3 GOES_7 14) (GOES_3 ASIASAT_1 4) (GOES_3 INMARSAT_2-F2 8)
      (GOES_3 GOES_8 5) (GOES_3 INTELSAT2 20) (GOES_3 APSTAR_1 23) (GOES_3 ESIAFI_1 33) (GOES_3 GSTAR_4 32)
      (TDRS_1 START_TGT 60) (TDRS_1 GOES_3 10) (TDRS_1 GALAXY_5 31) (TDRS_1 ASTRA_1C 33) (TDRS_1 DIRECTV_2_[DBS_2] 29)
      (TDRS_1 BRASILSAT_B1 18) (TDRS_1 INTELSAT_701_[IS-701] 7) (TDRS_1 GALAXY_6 25) (TDRS_1 INMARSAT_2-F4 20)
      (TDRS_1 GOES_7 5) (TDRS_1 ASIASAT_1 5) (TDRS_1 INMARSAT_2-F2 2) (TDRS_1 GOES_8 14) (TDRS_1 INTELSAT2 11)
      (TDRS_1 APSTAR_1 14) (TDRS_1 ESIAFI_1 26) (TDRS_1 GSTAR_4 29) (GALAXY_5 START_TGT 75) (GALAXY_5 GOES_3 31)
      (GALAXY_5 TDRS_1 31) (GALAXY_5 ASTRA_1C 8) (GALAXY_5 DIRECTV_2_[DBS_2] 11) (GALAXY_5 BRASILSAT_B1 22)
      (GALAXY_5 INTELSAT_701_[IS-701] 24) (GALAXY_5 GALAXY_6 16) (GALAXY_5 INMARSAT_2-F4 11) (GALAXY_5 GOES_7 26)
      (GALAXY_5 ASIASAT_1 35) (GALAXY_5 INMARSAT_2-F2 32) (GALAXY_5 GOES_8 27) (GALAXY_5 INTELSAT2 20)
      (GALAXY_5 APSTAR_1 17) (GALAXY_5 ESIAFI_1 5) (GALAXY_5 GSTAR_4 2) (ASTRA_1C START_TGT 60) (ASTRA_1C GOES_3 23)
      (ASTRA_1C TDRS_1 33) (ASTRA_1C GALAXY_5 8) (ASTRA_1C DIRECTV_2_[DBS_2] 3) (ASTRA_1C BRASILSAT_B1 14)
      (ASTRA_1C INTELSAT_701_[IS-701] 32) (ASTRA_1C GALAXY_6 8) (ASTRA_1C INMARSAT_2-F4 19) (ASTRA_1C GOES_7 34)
      (ASTRA_1C ASIASAT_1 27) (ASTRA_1C INMARSAT_2-F2 31) (ASTRA_1C GOES_8 19) (ASTRA_1C INTELSAT2 28)
      (ASTRA_1C APSTAR_1 25) (ASTRA_1C ESIAFI_1 13) (ASTRA_1C GSTAR_4 10) (DIRECTV_2_[DBS_2] START_TGT 70)
      (DIRECTV_2_[DBS_2] GOES_3 20) (DIRECTV_2_[DBS_2] TDRS_1 29) (DIRECTV_2_[DBS_2] GALAXY_5 11)
      (DIRECTV_2_[DBS_2] ASTRA_1C 3) (DIRECTV_2_[DBS_2] BRASILSAT_B1 11) (DIRECTV_2_[DBS_2] INTELSAT_701_[IS-701] 34)
      (DIRECTV_2_[DBS_2] GALAXY_6 5) (DIRECTV_2_[DBS_2] INMARSAT_2-F4 23) (DIRECTV_2_[DBS_2] GOES_7 34)
      (DIRECTV_2_[DBS_2] ASIASAT_1 24) (DIRECTV_2_[DBS_2] INMARSAT_2-F2 28) (DIRECTV_2_[DBS_2] GOES_8 15)
      (DIRECTV_2_[DBS_2] INTELSAT2 31) (DIRECTV_2_[DBS_2] APSTAR_1 29) (DIRECTV_2_[DBS_2] ESIAFI_1 17)
      (DIRECTV_2_[DBS_2] GSTAR_4 14) (BRASILSAT_B1 START_TGT 65) (BRASILSAT_B1 GOES_3 9) (BRASILSAT_B1 TDRS_1 18)
      (BRASILSAT_B1 GALAXY_5 22) (BRASILSAT_B1 ASTRA_1C 14) (BRASILSAT_B1 DIRECTV_2_[DBS_2] 11)
      (BRASILSAT_B1 INTELSAT_701_[IS-701] 25) (BRASILSAT_B1 GALAXY_6 6) (BRASILSAT_B1 INMARSAT_2-F4 33)
      (BRASILSAT_B1 GOES_7 23) (BRASILSAT_B1 ASIASAT_1 13) (BRASILSAT_B1 INMARSAT_2-F2 17) (BRASILSAT_B1 GOES_8 4)
      (BRASILSAT_B1 INTELSAT2 29) (BRASILSAT_B1 APSTAR_1 32) (BRASILSAT_B1 ESIAFI_1 27) (BRASILSAT_B1 GSTAR_4 25)
      (INTELSAT_701_[IS-701] START_TGT 65) (INTELSAT_701_[IS-701] GOES_3 15) (INTELSAT_701_[IS-701] TDRS_1 7)
      (INTELSAT_701_[IS-701] GALAXY_5 24) (INTELSAT_701_[IS-701] ASTRA_1C 32) (INTELSAT_701_[IS-701] DIRECTV_2_[DBS_2] 34)
      (INTELSAT_701_[IS-701] BRASILSAT_B1 25) (INTELSAT_701_[IS-701] GALAXY_6 30) (INTELSAT_701_[IS-701] INMARSAT_2-F4 13)
      (INTELSAT_701_[IS-701] GOES_7 3) (INTELSAT_701_[IS-701] ASIASAT_1 12) (INTELSAT_701_[IS-701] INMARSAT_2-F2 8)
      (INTELSAT_701_[IS-701] GOES_8 20) (INTELSAT_701_[IS-701] INTELSAT2 4) (INTELSAT_701_[IS-701] APSTAR_1 7)
      (INTELSAT_701_[IS-701] ESIAFI_1 19) (INTELSAT_701_[IS-701] GSTAR_4 22) (GALAXY_6 START_TGT 80) (GALAXY_6 GOES_3 15)
      (GALAXY_6 TDRS_1 25) (GALAXY_6 GALAXY_5 16) (GALAXY_6 ASTRA_1C 8) (GALAXY_6 DIRECTV_2_[DBS_2] 5)
      (GALAXY_6 BRASILSAT_B1 6) (GALAXY_6 INTELSAT_701_[IS-701] 30) (GALAXY_6 INMARSAT_2-F4 27) (GALAXY_6 GOES_7 29)
      (GALAXY_6 ASIASAT_1 19) (GALAXY_6 INMARSAT_2-F2 23) (GALAXY_6 GOES_8 10) (GALAXY_6 INTELSAT2 34)
      (GALAXY_6 APSTAR_1 33) (GALAXY_6 ESIAFI_1 21) (GALAXY_6 GSTAR_4 18) (INMARSAT_2-F4 START_TGT 70)
      (INMARSAT_2-F4 GOES_3 29) (INMARSAT_2-F4 TDRS_1 20) (INMARSAT_2-F4 GALAXY_5 11) (INMARSAT_2-F4 ASTRA_1C 19)
      (INMARSAT_2-F4 DIRECTV_2_[DBS_2] 23) (INMARSAT_2-F4 BRASILSAT_B1 33) (INMARSAT_2-F4 INTELSAT_701_[IS-701] 13)
      (INMARSAT_2-F4 GALAXY_6 27) (INMARSAT_2-F4 GOES_7 15) (INMARSAT_2-F4 ASIASAT_1 25) (INMARSAT_2-F4 INMARSAT_2-F2 21)
      (INMARSAT_2-F4 GOES_8 33) (INMARSAT_2-F4 INTELSAT2 9) (INMARSAT_2-F4 APSTAR_1 6) (INMARSAT_2-F4 ESIAFI_1 6)
      (INMARSAT_2-F4 GSTAR_4 9) (GOES_7 START_TGT 99) (GOES_7 GOES_3 14) (GOES_7 TDRS_1 5) (GOES_7 GALAXY_5 26)
      (GOES_7 ASTRA_1C 34) (GOES_7 DIRECTV_2_[DBS_2] 34) (GOES_7 BRASILSAT_B1 23) (GOES_7 INTELSAT_701_[IS-701] 3)
      (GOES_7 GALAXY_6 29) (GOES_7 INMARSAT_2-F4 15) (GOES_7 ASIASAT_1 10) (GOES_7 INMARSAT_2-F2 6) (GOES_7 GOES_8 19)
      (GOES_7 INTELSAT2 6) (GOES_7 APSTAR_1 9) (GOES_7 ESIAFI_1 21) (GOES_7 GSTAR_4 24) (ASIASAT_1 START_TGT 99)
      (ASIASAT_1 GOES_3 4) (ASIASAT_1 TDRS_1 5) (ASIASAT_1 GALAXY_5 35) (ASIASAT_1 ASTRA_1C 27)
      (ASIASAT_1 DIRECTV_2_[DBS_2] 24) (ASIASAT_1 BRASILSAT_B1 13) (ASIASAT_1 INTELSAT_701_[IS-701] 12)
      (ASIASAT_1 GALAXY_6 19) (ASIASAT_1 INMARSAT_2-F4 25) (ASIASAT_1 GOES_7 10) (ASIASAT_1 INMARSAT_2-F2 4)
      (ASIASAT_1 GOES_8 9) (ASIASAT_1 INTELSAT2 16) (ASIASAT_1 APSTAR_1 19) (ASIASAT_1 ESIAFI_1 31) (ASIASAT_1 GSTAR_4 34)
      (INMARSAT_2-F2 START_TGT 99) (INMARSAT_2-F2 GOES_3 8) (INMARSAT_2-F2 TDRS_1 2) (INMARSAT_2-F2 GALAXY_5 32)
      (INMARSAT_2-F2 ASTRA_1C 31) (INMARSAT_2-F2 DIRECTV_2_[DBS_2] 28) (INMARSAT_2-F2 BRASILSAT_B1 17)
      (INMARSAT_2-F2 INTELSAT_701_[IS-701] 8) (INMARSAT_2-F2 GALAXY_6 23) (INMARSAT_2-F2 INMARSAT_2-F4 21)
      (INMARSAT_2-F2 GOES_7 6) (INMARSAT_2-F2 ASIASAT_1 4) (INMARSAT_2-F2 GOES_8 13) (INMARSAT_2-F2 INTELSAT2 12)
      (INMARSAT_2-F2 APSTAR_1 15) (INMARSAT_2-F2 ESIAFI_1 27) (INMARSAT_2-F2 GSTAR_4 30) (GOES_8 START_TGT 99)
      (GOES_8 GOES_3 5) (GOES_8 TDRS_1 14) (GOES_8 GALAXY_5 27) (GOES_8 ASTRA_1C 19) (GOES_8 DIRECTV_2_[DBS_2] 15)
      (GOES_8 BRASILSAT_B1 4) (GOES_8 INTELSAT_701_[IS-701] 20) (GOES_8 GALAXY_6 10) (GOES_8 INMARSAT_2-F4 33)
      (GOES_8 GOES_7 19) (GOES_8 ASIASAT_1 9) (GOES_8 INMARSAT_2-F2 13) (GOES_8 INTELSAT2 25) (GOES_8 APSTAR_1 28)
      (GOES_8 ESIAFI_1 32) (GOES_8 GSTAR_4 29) (INTELSAT2 START_TGT 99) (INTELSAT2 GOES_3 20) (INTELSAT2 TDRS_1 11)
      (INTELSAT2 GALAXY_5 20) (INTELSAT2 ASTRA_1C 28) (INTELSAT2 DIRECTV_2_[DBS_2] 31) (INTELSAT2 BRASILSAT_B1 29)
      (INTELSAT2 INTELSAT_701_[IS-701] 4) (INTELSAT2 GALAXY_6 34) (INTELSAT2 INMARSAT_2-F4 9) (INTELSAT2 GOES_7 6)
      (INTELSAT2 ASIASAT_1 16) (INTELSAT2 INMARSAT_2-F2 12) (INTELSAT2 GOES_8 25) (INTELSAT2 APSTAR_1 3)
      (INTELSAT2 ESIAFI_1 15) (INTELSAT2 GSTAR_4 18) (APSTAR_1 START_TGT 99) (APSTAR_1 GOES_3 23) (APSTAR_1 TDRS_1 14)
      (APSTAR_1 GALAXY_5 17) (APSTAR_1 ASTRA_1C 25) (APSTAR_1 DIRECTV_2_[DBS_2] 29) (APSTAR_1 BRASILSAT_B1 32)
      (APSTAR_1 INTELSAT_701_[IS-701] 7) (APSTAR_1 GALAXY_6 33) (APSTAR_1 INMARSAT_2-F4 6) (APSTAR_1 GOES_7 9)
      (APSTAR_1 ASIASAT_1 19) (APSTAR_1 INMARSAT_2-F2 15) (APSTAR_1 GOES_8 28) (APSTAR_1 INTELSAT2 3) (APSTAR_1 ESIAFI_1 12)
      (APSTAR_1 GSTAR_4 15) (ESIAFI_1 START_TGT 99) (ESIAFI_1 GOES_3 33) (ESIAFI_1 TDRS_1 26) (ESIAFI_1 GALAXY_5 5)
      (ESIAFI_1 ASTRA_1C 13) (ESIAFI_1 DIRECTV_2_[DBS_2] 17) (ESIAFI_1 BRASILSAT_B1 27) (ESIAFI_1 INTELSAT_701_[IS-701] 19)
      (ESIAFI_1 GALAXY_6 21) (ESIAFI_1 INMARSAT_2-F4 6) (ESIAFI_1 GOES_7 21) (ESIAFI_1 ASIASAT_1 31)
      (ESIAFI_1 INMARSAT_2-F2 27) (ESIAFI_1 GOES_8 32) (ESIAFI_1 INTELSAT2 15) (ESIAFI_1 APSTAR_1 12) (ESIAFI_1 GSTAR_4 3)
      (GSTAR_4 START_TGT 99) (GSTAR_4 GOES_3 32) (GSTAR_4 TDRS_1 29) (GSTAR_4 GALAXY_5 2) (GSTAR_4 ASTRA_1C 10)
      (GSTAR_4 DIRECTV_2_[DBS_2] 14) (GSTAR_4 BRASILSAT_B1 25) (GSTAR_4 INTELSAT_701_[IS-701] 22) (GSTAR_4 GALAXY_6 18)
      (GSTAR_4 INMARSAT_2-F4 9) (GSTAR_4 GOES_7 24) (GSTAR_4 ASIASAT_1 34) (GSTAR_4 INMARSAT_2-F2 30) (GSTAR_4 GOES_8 29)
      (GSTAR_4 INTELSAT2 18) (GSTAR_4 APSTAR_1 15) (GSTAR_4 ESIAFI_1 3)))

;;; INMARSAT_2-F2*2 -> INMARSAT_2-F2
(defun get-table-tgt-from (tgt)
  (let* ((stgt (string tgt))
	 (pos (position #\* stgt)))
    (if pos
	(intern (read-from-string (subseq stgt 0 pos)) :ap)
      tgt)))

;;; (get-table-tgt-from 'INMARSAT_2-F2*2) => 
;;; 12/19/12 Need to take care of generated tgts
(defun get-slew-from-table (my-from my-to &optional (table *slew-times*))
  (loop for (start end time) in table
      with from = (get-table-tgt-from my-from)
      with to = (get-table-tgt-from my-to)
      if (eq from to)
      return 0.0
      else if (and (eq start from)
	      (eq end to))
      return time
      finally (print (list "!!!No slew time in table for " from to))))

;;; (get-slew-from-table 'INMARSAT_2-F2*2 'INMARSAT_2-F2)
(defun slew-time-from-tgt (action)
  (let* ((start-att (name (gsv action '?catt)))
	 (end-att (name (gsv action '?img)))
	 (slew-time (get-slew-from-table start-att end-att)))
    (format t "~%~%---------------------------------")
    (format t "~%~% start, end, diff = ~a(~a),~a(~a),~a." (name (gsv action '?catt)) start-att (name (gsv action '?img)) end-att slew-time)
    (format t "~%~% Value for ~a is ~a." (name action) (cl-user::fnum-to-accuracy (/ slew-time 60.0)))
    (format t "~%~%---------------------------------")
    ;;(cl-user::fnum-to-accuracy (/ slew-time 60.0))
    (max 1.0 (/ slew-time 10.0))
    ))

(define (durative-action point_at_image)
    :parameters (?s - satellite
		    ?img - sat_tgt_name)
    :vars (?catt - (last-tgt ?s)
	   )
    :duration  slew-time-from-tgt
    :effect (and (at end (pointed_at ?s ?img))
		 (at end (last-tgt ?s ?img))
		 )
    :comment "reorient the satellite from current attitude to attitude of the tgt.")

(define (durative-action store-an-image)
    :parameters (?s - satellite
		    ?name - sat_tgt_name)
    :duration  3.0	
    :condition (and (at start (camera-state ?s on))
		    (at start (shutter-state ?s opened)))
    :effect (at end (image_stored ?s ?name))
    :comment "take picture and store in recorder.")

(define (durative-action store-an-image2)
    :parameters (?s - satellite
		    ?name - sat_tgt_name)
    :duration  3.0	
    :condition (and (at start (camera-state ?s on))
		    (at start (shutter-state ?s opened)))
    :effect (at end (image_stored2 ?s ?name))
    :comment "take picture and store in recorder.")

(define (durative-action store-an-image3)
    :parameters (?s - satellite
		    ?name - sat_tgt_name)
    :duration  3.0	
    :condition (and (at start (camera-state ?s on))
		    (at start (shutter-state ?s opened)))
    :effect (at end (image_stored3 ?s ?name))
    :comment "take picture and store in recorder.")

(define (durative-action point&shoot)
    :parameters (?s - satellite
		    ?img - sat_tgt_name)
    :expansion (sequential
		(pointed_at ?s ?img)
		(camera-state ?s on)
		(shutter-state ?s opened)
		(image_stored ?s ?img)
		(shutter-state ?s closed)
		(camera-state ?s off))
    :effect (at end (image_taken ?s ?img))		 
    :comment "reorient the satellite and take a picture.")

 ;;; A delay action
(define (durative-action Delay15)
    :parameters (?img - sat_tgt_name)
    :duration 1.0
    :effect (at end (Delay_a ?img)))

(define (durative-action Delay15_2)
    :parameters (?img - sat_tgt_name)
    :duration 1.0
    :effect (at end (Delay_a2 ?img)))

(define (durative-action shoot_cluster3)
    :parameters (?s - satellite
		    ?img - sat_tgt_name)
    :expansion (sequential
		(pointed_at ?s ?img)
		(camera-state ?s on)
		(shutter-state ?s opened)
		(image_stored ?s ?img)
		(Delay_a ?img)
		(image_stored2 ?s ?img)
		(Delay_a2 ?img)
		(image_stored3 ?s ?img)
		(shutter-state ?s closed)
		(camera-state ?s off)
		)
    :effect (at end (cluster3_taken ?s ?img))		 
    :comment "reorient the satellite and take 3 pictures.")

(define (durative-action shoot_lots)
    :parameters (?s - satellite
		    ?img1 ?img2 ?img3 - sat_tgt_name)
    :expansion (sequential
		(image_taken ?s ?img1)
		(image_taken ?s ?img2)
		(image_taken ?s ?img3))
    :effect (at end (images_taken&downlinked ?s ?img1 ?img2 ?img3))
    :comment "shoot three different target images.")

(define (durative-action tune-to-downlink)
    :parameters (?o - satellite ?d -  down-link-loc)
    :vars (?f - frequency)
    :condition (at start (downlink_frequency ?d ?f))
    :duration 1.0 
    :effect (at end (tuned-to ?o ?d))
    :comment "tune to a downlink loc.")

(define (durative-action open-comms)
    :parameters (?o - satellite)
    :vars (?c - (has-comms ?o))
    :duration 1.0 
    :effect (at end (comms-state ?o opened))
    :comment "open a comms channel.")

(define (durative-action close-comms)
    :parameters (?o - satellite)
    :vars (?c - (has-comms ?o))
    :duration 1.0 
    :effect (at end (comms-state ?o closed))
    :comment "close a comms channel.")

(define (durative-action send-image)
    :parameters (?s - satellite
		    ?name - sat_tgt_name)
    :vars (?dl - down-link-loc
	      ?cam - (has-camera ?s))
    :duration 1.0 
    :condition (and (at start (downlink-ready-at ?s ?dl))
		    (at start (camera-state ?s off)))

    :effect (at end (image_sent ?s ?name))
    :comment "download a picture.")

(define (durative-action send-cluster)
    :parameters (?s - satellite
		    ?name - sat_tgt_name)
    :vars (?dl - down-link-loc
	      ?cam - (has-camera ?s))
    :duration 3.0
    :condition (and (at start (downlink-ready-at ?s ?dl))
		    (at start (camera-state ?s off)))
    :effect (at end (cluster_sent ?s ?name))
    :comment "download a picture.")

(define (durative-action downlink-at-location)
    :parameters (?s - satellite
		    ?dloc - down-link-loc)
    :effect (at end (downlink-location ?s ?dloc))
    :comment "used just to get the dloc passed to the maketasks functions.")

(define (durative-action setup-for-downlink)
    :parameters (?s - satellite
		    ?dl - down-link-loc)
    :expansion (sequential
		(camera-state ?s off)
		(tuned-to ?s ?dl)
		(comms-state ?s opened))
    :effect (at end (downlink-ready-at ?s ?dl))  
    :comment "get ready to downlink at ?dl.")
    
(define (durative-action download-image)
    :parameters (?s - satellite 
		    ?img - sat_tgt_name)
    :vars (?dloc - down-link-loc
		 ?c - (has-comms ?s))
    :expansion (sequential
		(downlink-ready-at ?s ?dloc)
		(image_sent ?s ?img)
		)
    :effect (at end (image_downloaded ?s ?img))
    :comment "set up and downlink an image.")

(define (durative-action download-images)
    :parameters (?s - satellite
		    ?img1 ?img2 ?img3 - sat_tgt_name)
    :vars (?dloc - down-link-loc
		 ?cam - (has-camera ?s)
		 ?c - (has-comms ?s))
    :expansion (sequential
		(image_downloaded ?s ?img1)
		(image_downloaded ?s ?img2)
		(image_downloaded ?s ?img3)
		(comms-state ?s closed))
    :effect (at end (images_downloaded ?s ?img1 ?img2 ?img3))
    :comment "downlink several images.")

(define (durative-action shoot_lots&downlink)
    :parameters (?s - satellite
		    ?img1 ?img2 ?img3 - sat_tgt_name)
    :expansion (sequential
		(image_taken ?s ?img1)
		(image_taken ?s ?img2)
		(image_taken ?s ?img3)
		(images_downloaded ?s ?img1 ?img2 ?img3)
		)
    :effect (at end (images_taken&downlinked ?s ?img1 ?img2 ?img3))
    :comment "shoot 3 images then downlink them.")

(define (situation for-afsat-1)
    (:domain sat-domain)
  (:init 
   (tuned-to SpaceSat freq1)
   (last-tgt SpaceSat start_tgt)
   (has-camera SpaceSat imager1)
   (has-shutter SpaceSat shutter1)
   (has-comms SpaceSat comms1)
   (camera-state SpaceSat off)
   (shutter-state SpaceSat closed)
   (comms-state SpaceSat closed)
   (downlink_frequency downlink1 freq1)
   (downlink_frequency downlink2 freq2)
   (downlink_frequency downlink3 freq3))
  )

(define (problem open-shutter)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (shutter-state SpaceSat opened)))

(define (problem close-shutter)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (shutter-state SpaceSat closed)))

(define (problem turn-on-camera)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (camera-state SpaceSat on)))

(define (problem turn-off-camera)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (camera-state SpaceSat off)))

(define (problem point-at-pic)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (pointed_at SpaceSat GALAXY_5)))

(define (problem store-image)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:init (CAMERA-STATE SPACESAT ON) (SHUTTER-STATE SPACESAT OPENED))
  (:deadline 400.0)
  (:goal (image_stored SpaceSat GALAXY_5)))

(define (problem p&s)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (image_taken SpaceSat APSTAR_1)))

(define (problem cluster3)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (cluster3_taken SpaceSat APSTAR_1)))

(define (problem take-iraq)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (sequential (image_taken SpaceSat INTELSAT2)
		     (image_taken SpaceSat ESIAFI_1)
		     (image_taken SpaceSat GOES_8))))

(define (problem take-mix1)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 600.0)
  (:goal (images_taken&downlinked SpaceSat ASIASAT_1 DIRECTV_2_[DBS_2] INMARSAT_2-F4)))

(define (problem take-mix2)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 600.0)
  (:goal (images_taken&downlinked SpaceSat APSTAR_1 ESIAFI_1 GOES_3)))

(define (problem send-one)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:init 
   (downlink-ready-at SpaceSat downlink1)
   ;;(opened comms)
   )
  (:deadline 400.0)
  (:goal (image_sent SpaceSat INTELSAT_701_[IS-701])))

(define (problem dlink-one)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 400.0)
  (:goal (image_downloaded SpaceSat ESIAFI_1)))

(define (problem dlink-all)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 600.0)
  (:goal (images_downloaded  SpaceSat ASIASAT_1 DIRECTV_2_[DBS_2] INMARSAT_2-F4)))

(define (problem take&downlink-all)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 600.0)
  (:goal (images_taken&downlinked SpaceSat ASIASAT_1 DIRECTV_2_[DBS_2] INMARSAT_2-F4)))

#|
 ;;; auto-gen'd stuff

 (DEFINE (DURATIVE-ACTION SHOOT_LOTS&STORE) 
 :PARAMETERS (?IMG1 - IMAGE_NAME) 
 :EXPANSION
 (SEQUENTIAL (IMAGE_TAKEN ?IMG1) 
             (STATE IMAGER OFF) 
	     (LOCATED AFSAT1 DOWNLINK1) 
	     (STATE COMMS OPENED) 
	     (IMAGE_SENT ?IMG1)
	     (STATE COMMS CLOSED))
 :EFFECT (AT END (IMAGES_TAKEN&STORED ?IMG1)))


(NEW-RELATION '(IMAGES_TAKEN&STORED ?IMG2 - IMAGE_NAME) SAT-DOMAIN)

(DEFINE (PROBLEM TAKE&STORE-ALL) 
    (:DOMAIN SAT-DOMAIN) 
  (:SITUATION FOR-AFSAT-1) 
  (:DEADLINE 390.0) 
  (:GOAL (IMAGES_TAKEN&STORED BAGHDADAIRPORT_IMG)))


(DEFINE (DURATIVE-ACTION SHOOT_LOTS&STORE) 
    :PARAMETERS (?IMG1 ?IMG2 ?IMG3 - IMAGE_NAME) 
    :EXPANSION
    (SEQUENTIAL 
     (IMAGE_TAKEN ?IMG1) 
     (IMAGE_TAKEN ?IMG2) 
     (IMAGE_TAKEN ?IMG3) 
     (NOT (ON IMAGER))
     (LOCATED AFSAT1 DOWNLINK2) 
     (OPENED COMMS) 
     (IMAGE_SENT ?IMG1) 
     (IMAGE_SENT ?IMG2) 
     (IMAGE_SENT ?IMG3)
     (NOT (OPENED COMMS)))
    :EFFECT (AT END (IMAGES_TAKEN&STORED ?IMG1 ?IMG2 ?IMG3)))

(NEW-RELATION '(IMAGES_TAKEN&STORED ?IMG1 ?IMG2 ?IMG3 - IMAGE_NAME) SAT-DOMAIN)
(DEFINE (PROBLEM TAKE&STORE-ALL) 
    (:DOMAIN *DOMAIN*) 
  (:SITUATION FOR-AFSAT-1) 
  (:DEADLINE 1000.0)
  (:GOAL (IMAGES_TAKEN&STORED BAGHDADAIRPORT_IMG CHINA_IMG NORTH_KOREA_IMG2)))

(define (problem take&store-all)
    (:domain sat-domain)
  (:situation for-afsat-1)
  (:deadline 600.0)
  (:goal (images_taken&stored BaghdadAirport_img north_korea_img2 china_img)))

(defun time-from-attitudes (action)
  (let* ((start-att (second (assoc (name (gsv action '?catt)) *attitudes*)))
	 (end-att (second (assoc (name (gsv action '?img)) *attitudes*)))
	 (diff (- end-att start-att)))
    (format t "~%~%---------------------------------")
    (format t "~%  ?catt = ~a  ?gatt = ~a" (gsv action '?catt)(gsv action '?gatt))
    (format t "~%~% start, end, diff = ~a(~a),~a(~a),~a." (name (gsv action '?catt)) start-att (name (gsv action '?img)) end-att diff)
    (format t "~%~% duration ~a = ~a." action (max 4.0 (/ (abs diff) 5.0)))
    (format t "~%~%---------------------------------")
    (max 1.0 (* (abs diff) (/ 2.0 60.0)))))


(AP:DEFINE (AP::DURATIVE-ACTION AP::DO-SAT-JOBS) :PARAMETERS (AP::?S - AP::SATELLITE) :EXPANSION
           (AP::SEQUENTIAL (AP::IMAGE_TAKEN AP::SPACESAT AP::TDRS_1)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::ASTRA_1C) (AP::CLUSTER3_TAKEN AP::SPACESAT AP::BRASILSAT_B1)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::INTELSAT_701_[IS-701])
            (AP::IMAGE_TAKEN AP::SPACESAT AP::DIRECTV_2_[DBS_2]) (AP::IMAGE_TAKEN AP::SPACESAT AP::GOES_3)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::GALAXY_5) (AP::DOWNLINK-READY-AT AP::SPACESAT AP::DOWNLINK1)
            (AP::IMAGE_SENT AP::SPACESAT AP::GALAXY_5) (AP::IMAGE_SENT AP::SPACESAT AP::GOES_3)
            (AP::IMAGE_SENT AP::SPACESAT AP::DIRECTV_2_[DBS_2])
            (AP::IMAGE_SENT AP::SPACESAT AP::INTELSAT_701_[IS-701])
            (AP::CLUSTER_SENT AP::SPACESAT AP::BRASILSAT_B1) (AP::IMAGE_SENT AP::SPACESAT AP::ASTRA_1C)
            (AP::IMAGE_SENT AP::SPACESAT AP::TDRS_1) (AP::COMMS-STATE AP::SPACESAT AP::CLOSED)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::GOES_7) (AP::IMAGE_TAKEN AP::SPACESAT AP::INTELSAT2)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::INMARSAT_2-F2) (AP::IMAGE_TAKEN AP::SPACESAT AP::ASIASAT_1)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::INMARSAT_2-F4) (AP::IMAGE_TAKEN AP::SPACESAT AP::GOES_8)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::GALAXY_6) (AP::DOWNLINK-READY-AT AP::SPACESAT AP::DOWNLINK1*2)
            (AP::IMAGE_SENT AP::SPACESAT AP::GALAXY_6) (AP::IMAGE_SENT AP::SPACESAT AP::GOES_8)
            (AP::IMAGE_SENT AP::SPACESAT AP::INMARSAT_2-F4) (AP::IMAGE_SENT AP::SPACESAT AP::ASIASAT_1)
            (AP::IMAGE_SENT AP::SPACESAT AP::INMARSAT_2-F2) (AP::IMAGE_SENT AP::SPACESAT AP::INTELSAT2)
            (AP::IMAGE_SENT AP::SPACESAT AP::GOES_7) (AP::COMMS-STATE AP::SPACESAT AP::CLOSED)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::APSTAR_1) (AP::IMAGE_TAKEN AP::SPACESAT AP::TDRS_1*3)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::ESIAFI_1) (AP::IMAGE_TAKEN AP::SPACESAT AP::GSTAR_4)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::GOES_3*4) (AP::IMAGE_TAKEN AP::SPACESAT AP::GALAXY_5*5)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::ASTRA_1C*6) (AP::DOWNLINK-READY-AT AP::SPACESAT AP::DOWNLINK1*7)
            (AP::IMAGE_SENT AP::SPACESAT AP::ASTRA_1C*6) (AP::IMAGE_SENT AP::SPACESAT AP::GALAXY_5*5)
            (AP::IMAGE_SENT AP::SPACESAT AP::GOES_3*4) (AP::IMAGE_SENT AP::SPACESAT AP::GSTAR_4)
            (AP::IMAGE_SENT AP::SPACESAT AP::ESIAFI_1) (AP::IMAGE_SENT AP::SPACESAT AP::TDRS_1*3)
            (AP::IMAGE_SENT AP::SPACESAT AP::APSTAR_1) (AP::COMMS-STATE AP::SPACESAT AP::CLOSED)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::DIRECTV_2_[DBS_2]*8)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::GALAXY_6*9) (AP::CLUSTER3_TAKEN AP::SPACESAT AP::BRASILSAT_B1*10)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::INMARSAT_2-F4*11) (AP::IMAGE_TAKEN AP::SPACESAT AP::ASIASAT_1*12)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::INTELSAT_701_[IS-701]*13)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::GOES_7*14) (AP::DOWNLINK-READY-AT AP::SPACESAT AP::DOWNLINK1*15)
            (AP::IMAGE_SENT AP::SPACESAT AP::GOES_7*14)
            (AP::IMAGE_SENT AP::SPACESAT AP::INTELSAT_701_[IS-701]*13)
            (AP::IMAGE_SENT AP::SPACESAT AP::ASIASAT_1*12) (AP::IMAGE_SENT AP::SPACESAT AP::INMARSAT_2-F4*11)
            (AP::CLUSTER_SENT AP::SPACESAT AP::BRASILSAT_B1*10) (AP::IMAGE_SENT AP::SPACESAT AP::GALAXY_6*9)
            (AP::IMAGE_SENT AP::SPACESAT AP::DIRECTV_2_[DBS_2]*8) (AP::COMMS-STATE AP::SPACESAT AP::CLOSED)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::INMARSAT_2-F2*16) (AP::IMAGE_TAKEN AP::SPACESAT AP::GOES_3*17)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::GOES_8*18) (AP::IMAGE_TAKEN AP::SPACESAT AP::INTELSAT2*19)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::APSTAR_1*20) (AP::IMAGE_TAKEN AP::SPACESAT AP::ESIAFI_1*21)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::GSTAR_4*22) (AP::DOWNLINK-READY-AT AP::SPACESAT AP::DOWNLINK1*23)
            (AP::IMAGE_SENT AP::SPACESAT AP::GSTAR_4*22) (AP::IMAGE_SENT AP::SPACESAT AP::ESIAFI_1*21)
            (AP::IMAGE_SENT AP::SPACESAT AP::APSTAR_1*20) (AP::IMAGE_SENT AP::SPACESAT AP::INTELSAT2*19)
            (AP::IMAGE_SENT AP::SPACESAT AP::GOES_8*18) (AP::IMAGE_SENT AP::SPACESAT AP::GOES_3*17)
            (AP::IMAGE_SENT AP::SPACESAT AP::INMARSAT_2-F2*16) (AP::COMMS-STATE AP::SPACESAT AP::CLOSED)
            (AP::CLUSTER3_TAKEN AP::SPACESAT AP::BRASILSAT_B1*24) (AP::IMAGE_TAKEN AP::SPACESAT AP::TDRS_1*25)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::INTELSAT_701_[IS-701]*26)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::GALAXY_6*27)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::DIRECTV_2_[DBS_2]*28)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::ASTRA_1C*29) (AP::IMAGE_TAKEN AP::SPACESAT AP::GALAXY_5*30)
            (AP::DOWNLINK-READY-AT AP::SPACESAT AP::DOWNLINK1*31) (AP::IMAGE_SENT AP::SPACESAT AP::GALAXY_5*30)
            (AP::IMAGE_SENT AP::SPACESAT AP::ASTRA_1C*29)
            (AP::IMAGE_SENT AP::SPACESAT AP::DIRECTV_2_[DBS_2]*28)
            (AP::IMAGE_SENT AP::SPACESAT AP::GALAXY_6*27)
            (AP::IMAGE_SENT AP::SPACESAT AP::INTELSAT_701_[IS-701]*26)
            (AP::IMAGE_SENT AP::SPACESAT AP::TDRS_1*25) (AP::CLUSTER_SENT AP::SPACESAT AP::BRASILSAT_B1*24)
            (AP::COMMS-STATE AP::SPACESAT AP::CLOSED) (AP::IMAGE_TAKEN AP::SPACESAT AP::GOES_8*32)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::ASIASAT_1*33) (AP::IMAGE_TAKEN AP::SPACESAT AP::INMARSAT_2-F2*34)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::INMARSAT_2-F4*35) (AP::IMAGE_TAKEN AP::SPACESAT AP::GOES_7*36)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::APSTAR_1*37) (AP::IMAGE_TAKEN AP::SPACESAT AP::INTELSAT2*38)
            (AP::DOWNLINK-READY-AT AP::SPACESAT AP::DOWNLINK1*39)
            (AP::IMAGE_SENT AP::SPACESAT AP::INTELSAT2*38) (AP::IMAGE_SENT AP::SPACESAT AP::APSTAR_1*37)
            (AP::IMAGE_SENT AP::SPACESAT AP::GOES_7*36) (AP::IMAGE_SENT AP::SPACESAT AP::INMARSAT_2-F4*35)
            (AP::IMAGE_SENT AP::SPACESAT AP::INMARSAT_2-F2*34) (AP::IMAGE_SENT AP::SPACESAT AP::ASIASAT_1*33)
            (AP::IMAGE_SENT AP::SPACESAT AP::GOES_8*32) (AP::COMMS-STATE AP::SPACESAT AP::CLOSED)
            (AP::IMAGE_TAKEN AP::SPACESAT AP::ESIAFI_1*40) (AP::IMAGE_TAKEN AP::SPACESAT AP::GSTAR_4*41)
            (AP::DOWNLINK-READY-AT AP::SPACESAT AP::DOWNLINK1*42) (AP::IMAGE_SENT AP::SPACESAT AP::GSTAR_4*41)
            (AP::IMAGE_SENT AP::SPACESAT AP::ESIAFI_1*40) (AP::COMMS-STATE AP::SPACESAT AP::CLOSED))
           :EFFECT (AP::AT AP::END (AP::SAT-JOBS-DONE AP::?S)))
(AP:DEFINE (AP::PROBLEM AP::TAKE&STORE-ALL) (:DOMAIN SAT-DOMAIN) (:SITUATION FOR-AFSAT-1) (:DEADLINE 390.0)
           (:GOAL (AP::SAT-JOBS-DONE AP::SPACESAT)))
|#
