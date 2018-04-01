(in-package :ap)

;;; delay
(define (problem delay-test)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (Delay10_a done)))

(define (problem delay-bob)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (Delay-action_a bob)))

;;;egress-inside-agent
(define (problem bob-out)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (located bob airlock)))

;;;egress-one-test
(define (problem one-outside)
    (:domain nasa-domain)    
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (one-crew airlock)))

;;; assisted-egress
(define (problem assist-sally)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:init (located bob airlock)
	 (open thermal-cover))
  (:deadline 100.0)
  (:goal (located sally AIRLOCK)))

;;;Assist-out-test
(define (problem assist-one)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:init (located bob airlock)
	 (open thermal-cover))
  (:deadline 100.0)
  (:goal (assist-done airlock)))

;;;Two-out-test
(define (problem get-two-out)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:init (located bob airlock))
  (:deadline 100.0)
  (:goal (two-out done)))

;;;Prepare-for-eva
(define (problem bob-ready)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (tethered_to ISS-safety-tether1 bob))
  (:goal (prepare-for-eva_a bob)))

;;;Crew-out
(define (problem two-out-prep)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (crew-moved-to AIRLOCK)))

;;; Stow-external
(define (problem bag-outside)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (open thermal-cover))
  (:goal (located ceta-light-bag2 AIRLOCK)))

(define (problem cbag-out)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (open thermal-cover))
  (:goal (located crew-lock-bag1 airlock)))

;;;*****************************
;;; simulate-execution breaks on this one
;;;******************************
 ;;;Egress-agents&tools
(define (problem all-outside)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (crew-and-tools airlock)))

;;; Agent-Egress-and-do
(define (problem bob-do-jobs)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 200.0)
  (:goal (crew-did-jobs bob)))

;;;*****************************
;;; simulate-execution breaks on this one
;;;******************************
;;;Egress-and-do-jobs
(define (problem do-jobs)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 200.0)
  (:goal (agent-egress&do-test done))
  )

;;; Assisted-ingress
(define (problem assist-sally-in)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:init (located bob airlock)
	 (located sally airlock)
	 (tethered_to ISS-safety-tether2 sally)
	 )
  (:deadline 100.0)
  (:goal (located sally INTRA-VEHICLE)))

;;;*****************************
;;; simulate-execution breaks on this one
;;;******************************
;;; Assist-in-test
(define (problem assist-one-in)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:init (located bob airlock)
	 (located sally airlock)
	 (tethered_to ISS-safety-tether2 sally)
	 )
  (:deadline 100.0)
  (:goal (assist-done intra-vehicle)))

 ;;; Ingress-outside-agent
(define (problem bob-inside)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:init (located bob airlock)
	 (tethered_to ISS-safety-tether1 bob)
	 (open thermal-cover))
  (:deadline 100.0)
  (:goal (located bob intra-vehicle)))

;;;*****************************
;;; simulate-execution breaks on this one
;;;******************************
;;; Ingress-one-test
(define (problem one-inside)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:init (located bob airlock)
	 (tethered_to ISS-safety-tether1 bob)
	 (open thermal-cover))
  (:deadline 100.0)
  (:goal (one-crew intra-vehicle)))

;;; Two-in-test
(define (problem get-two-in)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:init (located bob airlock)
	 (located sally airlock)
	 (tethered_to ISS-safety-tether2 sally)
	 (tethered_to ISS-safety-tether1 bob))
  (:deadline 100.0)
  (:goal (two-in done)))

;;; Close-hatch
(define (problem shut-hatch)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (locked HATCH)))

;;; Prepare-for-repress
(define (problem bob-prepped)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:init (locked HATCH))
  (:deadline 100.0)
  (:goal (prepare-for-repress_a bob)))

;;; Crew-in
(define (problem two-in&prep)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:init (located bob airlock)
	 (located sally airlock)
	 (tethered_to ISS-safety-tether2 sally)
	 (tethered_to ISS-safety-tether1 bob))
  (:deadline 100.0)
  (:goal (crew-moved-to intra-vehicle)))

;;; Stow-internal
(define (problem bag-inside)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (possesses bob ceta-light-bag2)
	 (open thermal-cover))
  (:goal (located ceta-light-bag2 intra-vehicle))
  )

;;; Ingress-agents&tools
(define (problem all-inside)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (located sally airlock)
	 (tethered_to ISS-safety-tether2 sally)
	 (tethered_to ISS-safety-tether1 bob)
	 (possesses bob ceta-light-bag2)
	 (open thermal-cover))
  (:goal (crew-and-tools intra-vehicle)))

(define (problem bob-do-jobs2)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 200.0)
  (:goal (crew-did-jobs2 bob)))

(define (problem do-jobs2)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 200.0)
  (:goal (all-jobs2 done)))

 ;;;Pick-up
(define (problem bob-pick-bag)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (possesses bob ceta-light-bag1))
  )

(define (problem bob-pick-apfr)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (possesses bob apfr2))
  )

;;; Pick-up-test
(define (problem go-get-bag)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob p1-ata-panel)
        (located ceta-light-bag1 airlock))
  (:goal (fetched bob  ceta-light-bag1))
  )

;;;Ingress-agents&tools2
(define (problem all-inside2)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (located sally airlock)
	 (located ceta-light-bag1 airlock)
	 (located crew-lock-bag1 airlock)
	 (tethered_to ISS-safety-tether2 sally)
	 (tethered_to ISS-safety-tether1 bob)
	 (open thermal-cover))
  (:goal (crew-and-tools2 intra-vehicle)))

;;; Extract-item-to-bag
(define (problem extract-light)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob lab-ceta-light-loc)
	 (located ceta-light1 lab-ceta-light-loc)
	 (possesses bob ceta-light-bag1))
  (:goal (contains ceta-light-bag1 ceta-light1))
  )

;;; Extract-item-to-fs 
(define (problem extract-pc)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob pwr-jumper-loc)
	 (located power-cable1 pwr-jumper-loc)
	 (possesses bob fish-stringer1)
	 (not (contains fish-stringer1 power-cable1)))
  (:goal (contains fish-stringer1 power-cable1))
  )

;;; Extract-apfr
(define (problem bob-extract-apfr)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob port-ceta-cart-loc))
  (:goal (possesses bob apfr3))
  )

;;; Extract-apfr-test
(define (problem one-extract-apfr)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob port-ceta-cart-loc))
  (:goal (item-extracted apfr3)))

;;; extract-ddcu-by-two
(define (problem bob-extract-ddcu)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob ddcus01a-loc)
	 (located sally ddcus01a-loc))
  (:goal (possesses bob ddcus01a))
  )

;;;extract-ddcu-test2
(define (problem two-extract-ddcu)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob ddcus01a-loc)
	 (located sally ddcus01a-loc))
  (:goal (ddcu-extracted2 ddcus01a))
  )

;;; extract-ddcu
;;; Need a square scoop (that is not #1) and a torque breaker.
;;; Bob has a ratchet wrench and square scoop 2
(define (problem bob-extract-ddcu)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob ddcus01a-loc)
	 )
  (:goal (possesses bob ddcus01a))
  )

;;; added while debugging the first demo plan
;;; Sally has a torque breaking pgt and square scoop 3
(define (problem sally-extract-ddcu2)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located sally ddcus01a-loc)
	 )
  (:goal (possesses sally ddcus01a))
  )

;;;extract-ddcu-test
(define (problem one-extract-ddcu)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob ddcus01a-loc)
	 )
  (:goal (ddcu-extracted ddcus01a))
  )

;;; extract-item-to-suit
(define (problem sally-extract-mut)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located sally p6-z-face1)
	 (located mut-ee2 p6-z-face1)
	 (not (possesses sally mut-ee2))
	(installed mut-ee2))
  (:goal (possesses sally mut-ee2))
  )

 ;;;Put-down
(define (problem bob-put-bag)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (possesses bob ceta-light-bag1)
	 (located bob airlock))
  (:goal (not (possesses bob ceta-light-bag1)))
  )

(define (problem bob-put-apfr)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (possesses bob apfr2))
  (:goal (not (possesses bob apfr2)))
  )

;;; install-item-from-container
(define (problem install-light)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob lab-ceta-light-loc)
	 (possesses bob ceta-light-bag1)
	 (contains ceta-light-bag1 ceta-light1))
  (:goal (installed ceta-light1))
  )

(define (problem install-pc)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob pwr-jumper-loc)
	 (possesses bob fish-stringer1)
	 (contains fish-stringer1 power-cable1))
  (:goal (installed power-cable1))
  )

;;; Install-fqd-in-place
(define (problem install-f)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob FQD-JUMPER-LOC)
	 (possesses bob fish-stringer1)
	 )
  (:goal (installed fqd-jumper1))
  )

(define (problem install-w)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob ssrms-loc1)
	 )
  (:goal  (installed wifa1))
  )

 ;;; Install-apfr
(define (problem install-a)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob ceta-cart-loc1)
	 (possesses bob apfr2)
	 )
  (:goal  (installed apfr2))
)

 ;;; Ingress-transport
(define (problem bob-on-cart)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob ceta-cart-loc1)
	 (contains wif2 apfr2)
	 )
  (:goal  (on bob ceta-cart1))
  )

(define (problem bob-on-arm)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob ssrms-loc1)
	 (contains ssrms wifa1)
	 (contains wifa1 apfr2)
	 )
  (:goal  (on bob ssrms))
  )

;;;Ingress-crew-test
(define (problem on-arm)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob ssrms-loc1)
	 (contains ssrms wifa1)
	 (contains wifa1 apfr2)
	 )
  (:goal  (transport-loaded ssrms))
  )

;;; ssrms-trans-test
(define (problem trans-arm)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob ssrms-loc1)
	 (contains ssrms wifa1)
	 (contains wifa1 apfr2)
	 )
  (:goal  (ssrms-trans bob ceta-cart-loc1))
  )

;;;Ingress-cart
(define (problem bob-on-cart2)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (possesses bob apfr2)
	 )
  (:goal  (ingressed bob ceta-cart1))
  )

;;; Ingress-arm
(define (problem bob-on-arm2)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (possesses bob apfr2)
	 (not (operator ssrms joe)))
  (:goal  (ingressed bob ssrms))
  )

;;; gca-arm
(define (problem bob-gca)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob ceta-cart-loc1))
  (:goal (located ssrms ceta-cart-loc1))
  )

;;; gca&ingress-arm
(define (problem bob-on-arm3)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (possesses bob apfr2)
	 )
  (:goal  (ingressed bob ssrms))
  )

 ;;;Translate-by-handrail
(define (problem bob-to-loc)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock))
  (:goal (located bob LAB-CETA-LIGHT-LOC))
  )

;;; Translate-by-handrail-test
(define (problem one-to-loc)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock))
  (:goal (crew-traveled-to LAB-CETA-LIGHT-LOC))
  )

;;; tether swap
(define (problem ts-bob)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob AIRLOCK)
	 (tethered_to ISS-safety-tether1 bob))	
  (:goal (tethered_to ISS-safety-tether2 bob))
  )

(define (problem ts-sally)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located sally P3-Z-FACE1)
	 (tethered_to ISS-safety-tether1 sally))	
  (:goal (tethered_to ISS-safety-tether4 sally))
  )

;;; Translate-by-hr (using swap)
(define (problem bob-to-p6)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (tethered_to ISS-safety-tether1 bob)
	 (located ISS-safety-tether2 P3-Z-FACE1)
	 )
  (:goal (located bob P6-Z-FACE1))
  )

(define (problem one-to-p6)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (tethered_to ISS-safety-tether1 bob)
	 (located ISS-safety-tether2 P3-Z-FACE1)
	 )
  (:goal (crew-traveled-to P6-Z-FACE1))
  )

(define (problem bob-to-al)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob P6-Z-FACE1)
	 (tethered_to ISS-safety-tether3 bob)
         (located ISS-safety-tether2 P3-Z-FACE1)
	 (tethered_to ISS-safety-tether2 bob)
	)
  (:goal (located bob AIRLOCK))
  )

;;;swap and swap back
(define (problem bob-round-trip)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (tethered_to ISS-safety-tether1 bob)
	 (located ISS-safety-tether2 P3-Z-FACE1)
	 )
  (:goal (sequential
          (located bob P6-Z-FACE1)
	  (located bob AIRLOCK)  ))
  )

(define (problem one-to-al)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob P6-Z-FACE1)
	 (tethered_to ISS-safety-tether3 bob)
         (located ISS-safety-tether2 P3-Z-FACE1)
	 (tethered_to ISS-safety-tether2 bob)
	)
  (:goal (crew-traveled-to AIRLOCK))
  )

(define (problem sally-to-p6)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located sally airlock)
	 (tethered_to ISS-safety-tether1 sally)
	 (possesses sally stp1))
  (:goal (located sally P6-Z-FACE1))
  )

(define (problem one-to-p6s)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located sally airlock)
	 (tethered_to ISS-safety-tether1 sally)
	 (possesses sally stp1))
  (:goal (crew-traveled-to P6-Z-FACE1))
  )

(define (problem sally-to-al)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located sally P6-Z-FACE1)
	 (possesses sally stp1)
	 (not (contains stp1 ISS-safety-tether3))
         (located ISS-safety-tether2 P3-Z-FACE1)
	 (tethered_to ISS-safety-tether3 sally)
	 (tethered_to ISS-safety-tether2 sally))
  (:goal (located sally AIRLOCK))
  )

(define (problem one-to-als)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located sally P6-Z-FACE1)
	(possesses sally stp1)
	(not (contains stp1 ISS-safety-tether3))
	(tethered_to ISS-safety-tether3 sally)
	)
  (:goal (crew-traveled-to AIRLOCK))
  )

;;;Retrieve-item
(define (problem get-light)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (tethered_to ISS-safety-tether1 bob)
	(located ceta-light-bag1 airlock)
	(located stp1 airlock))
  (:goal (retrieve-item_a bob ceta-light1))
  )

;; this one needs a tether swap
(define (problem get-light2)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (tethered_to ISS-safety-tether1 bob)
	 (located ceta-light-bag1 airlock)
	 (possesses bob stp1))
  (:goal (retrieve-item_a bob ceta-light3))
  )

;;; retrieve-item2
(define (problem ret&stow)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (open THERMAL-COVER)
         (tethered_to ISS-safety-tether1 bob)
	 (located ceta-light-bag1 airlock)
	 (located stp1 airlock))
  (:goal (retrieve-and-stow bob ceta-light1))
  )

#|;;;retrieve-install-item
(define (problem R&i-light)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (not (installed ceta-light1))	; added by chris 8/16/2016
	 (located bob airlock)(tethered_to ISS-safety-tether1 bob)
	 (located stp1 airlock)(located ceta-light-bag1 airlock))
  (:goal (retrieve-install-item_a bob ceta-light1))
  )
|#

(define (problem R&i-light)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)(tethered_to ISS-safety-tether1 bob)
	 (located stp1 airlock)(located ceta-light-bag1 airlock))
  (:goal (retrieve-install-item_a bob ceta-light1))
  )

(define (problem install-j)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (possesses bob fish-stringer1))
  (:goal (install-item_a bob power-cable1))
  )

(define (problem go-install-f)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (located fish-stringer1 airlock))
  (:goal (install-item_a bob fqd-jumper1))
  )

;;; position item
(define (problem position-ddcu)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (located stanchion-mount-cover1 airlock))
  (:goal (position-item_a bob stanchion-mount-cover1 ddcus01a-loc)
	 ;;;(located ddcu-spare1 ddcus01a-loc)
	 )
  )

(define (problem position-clb)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (located crew-lock-bag1 airlock))
  (:goal (position-item_a bob crew-lock-bag1 ddcus01a-loc)
	 ;;;(located crew-lock-bag1 ddcus01a-loc)
	 )
  )

(define (problem position-cover)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (located stanchion-mount-cover1 airlock))
  (:goal (position-item_a bob stanchion-mount-cover1 ddcus01a-loc)
	 )
  )

(define (problem position-test)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (located stanchion-mount-cover1 airlock))
  (:goal (position-item-test stanchion-mount-cover1 ddcus01a-loc)
	 )
  )
 ;;;Install-scoop
(define (problem install-sc) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (install-scoop_a bob  square-scoop2 ddcu-spare1)
	;;(contains ddcu-spare1 square-scoop2)
	)
  )

 ;;;Install-scoop-from-container
(define (problem install-sc-from-bag) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (possesses bob crew-lock-bag1)
	 (located stanchion-mount-cover1 airlock) )
  (:goal (contains ddcu-spare1 square-scoop1))
  )

(define (problem install-m) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock))
  (:goal (installed mut-ee1))
  )

;;;ddcu-r&r-prep
(define (problem ddcu-prep) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (possesses bob crew-lock-bag1)
	 (located stanchion-mount-cover1 airlock) )
  (:goal (site-prepped-for-r&r bob ddcus01a))
  )

(define (problem prep-test) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (possesses bob crew-lock-bag1)
	 (located stanchion-mount-cover1 airlock) )
  (:goal (site-prep-tested ddcus01a))
  )

;;;take-ddcu-off-cover
;;; AP says this is satisfied in the IS?
(define (problem take-off-cover) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (possesses bob stanchion-mount-cover1)
	 (contains ddcu-spare1 square-scoop1)
	 (located sally airlock))
  (:goal (possesses sally ddcu-spare1))
  )
;;;take-ddcu-off-test
(define (problem take-off-test) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (possesses bob stanchion-mount-cover1)
	 (contains ddcu-spare1 square-scoop1)
	 (located sally airlock))
  (:goal (take-off-cover-test ddcu-spare1))
  )

;;;put-cover-on-ddcu
(define (problem put-on-cover) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (possesses bob ddcus01a)
	 (contains ddcus01a square-scoop1)
	 (located sally airlock)
	 (possesses sally stanchion-mount-cover1))
  (:goal (put-cover-on-ddcu_a sally ddcus01a stanchion-mount-cover1)
         ;;(contains stanchion-mount-cover1 ddcus01a)
	 ;;(possesses sally ddcus01a)
	 )
  )

;;; added while debugging the first demo plan
;;; This one uses sally, not bob
(define (problem put-on-cover2) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (possesses sally ddcus01a)
	 (contains ddcus01a square-scoop1)
	 (located sally airlock)
	 (possesses bob stanchion-mount-cover1))
  (:goal (put-cover-on-ddcu_a bob ddcus01a stanchion-mount-cover1)
         ;;(contains stanchion-mount-cover1 ddcus01a)
	 ;;(possesses sally ddcus01a)
	 )
  )

;;; added while debugging the first demo plan
;;; This one uses sally, and does it at the ddcu site
(define (problem put-on-cover3) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init
         ;; both located at the same place
	 (located bob ddcus01a-loc)
	 (located sally ddcus01a-loc)
	 ;; the scoop is contained by the ddcu
	 (contains ddcus01a square-scoop1)
	 ;; the ddcu is possessed_by the presenter
	 (possesses sally ddcus01a)
	 ;; the receiver possesses the cover
	 (possesses bob stanchion-mount-cover1))
  (:goal (put-cover-on-ddcu_a bob ddcus01a stanchion-mount-cover1)
         ;;(contains stanchion-mount-cover1 ddcus01a)
	 ;;(possesses sally ddcus01a)
	 )
  )

;;;put-cover-on-test
(define (problem put-on-test) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (located ddcu-spare1 airlock)
	 (possesses bob ddcus01a)
	 (contains ddcus01a square-scoop1)
	 (located sally airlock)
	 (possesses sally stanchion-mount-cover1))
  (:goal (put-on-cover-test ddcus01a))
  )

 ;;;ddcu-change-out
(define (problem change-out-d) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob ddcus01a-loc)
	 (located sally ddcus01a-loc)
	 (possesses sally stanchion-mount-cover1)
	 (not (contains crew-lock-bag1 square-scoop1))
	 (contains ddcu-spare1 square-scoop1))
  (:goal (replaced bob ddcus01a))
  )

;;; This is the same as change-out-d except I switched bob and sally
(define (problem change-out-d3) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located sally ddcus01a-loc)
	 (located bob ddcus01a-loc)
	 (possesses bob stanchion-mount-cover1)
	 (not (contains crew-lock-bag1 square-scoop1))
	 (contains ddcu-spare1 square-scoop1)
	 )
  (:goal (replaced sally ddcus01a))
  )

;;;ddcu-change-out-test
(define (problem change-out-d2) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob ddcus01a-loc)
	 (located sally ddcus01a-loc)
	 (possesses sally stanchion-mount-cover1)
	 (not (contains crew-lock-bag1 square-scoop1))
	 (contains ddcu-spare1 square-scoop1))
  (:goal (ddcu-changed-out ddcus01a))
  )

(define (problem put-cover-on-ddcu-test)
    (:comment "test put-cover-on-ddcu for change-out-d2")
  (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob ddcus01a-loc)
	 (located sally ddcus01a-loc)
	 (possesses sally stanchion-mount-cover1)
	 (possesses bob ddcus01a)
	 (contains ddcus01a square-scoop1))
  (:goal (put-cover-on-ddcu_a sally ddcus01a stanchion-mount-cover1))
  )

;;;ddcu-r&r0
(define (problem r&r-d0) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (located sally airlock)
	 (possesses sally crew-lock-bag1)
	 (possesses sally stanchion-mount-cover1))
  (:goal (ddcu-replaced sally bob ddcus01a))
  )

;;;ddcu-r&r1
(define (problem r&r-d1) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (located sally airlock)
	 (possesses sally crew-lock-bag1)
	 (possesses sally stanchion-mount-cover1))
  (:goal (remove&replace_a bob ddcus01a))
  )

;;;ddcu-r&r2
;;; fails in the same place as r&r-prep
(define (problem r&r-d2) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located bob airlock)
	 (located sally airlock)
         (possesses sally crew-lock-bag1)
	 (possesses sally stanchion-mount-cover1))
  (:goal (ddcu-replaced2 ddcus01a))
  )

;;;ddcu-r&r
(define (problem crew-r&r-d) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 200.0)
  (:goal (did-ddcu bob sally ddcus01a))
  )

;;;(DEFINE (PROBLEM DONE-JOBS) (:DOMAIN NASA-DOMAIN) (:SITUATION PHALCON-EVA) (:DEADLINE 200.0)
;;;        (:GOAL (JOBS-DONE BOB SALLY ddcus01a)))

(AP:DEFINE (AP::PROBLEM AP::DONE-JOBS) 
           (:DOMAIN NASA-DOMAIN)
           (:SITUATION PHALCON-EVA) (:DEADLINE 390.0)
	(:GOAL (AP::JOBS-DONE AP::BOB AP::SALLY)))

;;;vent-tool-assemble
(define (problem vta) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 200.0)
  (:init (located bob p6-z-face1) ;;; where the vte bag is
	 (installed mut-ee1)) ;; bob has this one
(:goal (assembled bob vent-tool1))
  )

;;;vent-tool-setup
(define (problem vts) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 200.0)
  (:init (located bob airlock)
         (tethered_to ISS-safety-tether1 bob)
         (possesses bob stp1))
(:goal (vent-tool-setup_a bob vent-tool1))
  )

;;;vent-tool-clean-up
(define (problem vtc) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 200.0)
  (:init (located sally p6-z-face1)
         (located mut-ee2 p6-z-face1)
         (installed mut-ee2)
	 (mated vent-tool1 vt-adapter1))
(:goal (vent-tool-clean-up_a sally vent-tool1))
  )

;;; Egress-and-setup-vt2
(define (problem evts2) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 200.0)
(:goal (crew-setup-vt2_a bob vent-tool1))
  )

;;; Egress-and-setup-vt
(define (problem evts) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 200.0)
(:goal (crew-setup-vt_a vent-tool1))
  )

;;; p3-p4-nh3-jumper-reroute

(define (problem jrr) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:init (located bob p3-p4-juncture)
         (located sally p3-p4-juncture)
         )
(:deadline 200.0)
(:goal (rerouted bob nh3-jumper-p3-p4))
  )

(define (problem bob-do-rr)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 200.0)
  (:goal (crew-did-reroute bob)))

;;; p3-p4-nh3-jumper-stow

(define (problem jst) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:init (located bob p3-p4-juncture)
         (located sally p3-p4-juncture)
         )
(:deadline 200.0)
(:goal (stowed bob nh3-jumper-p3-p4))
  )

;;;nh3-jumper-stow-with-pickup
(define (problem jst2) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:init (located bob p3-p4-juncture)
         (located sally p3-p4-juncture)
         (located sarj-bag1 p3-p4-juncture))
(:deadline 200.0)
(:goal (stowed bob nh3-jumper-p3-p4))
  )

;;;open-final-nh3-qds

(define (problem bob-open-qds)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 200.0)
  (:init (installed nh3-jumper-p3-p4)
	 (located bob p5-p6-juncture)
         (located sally p1-ata-panel)
         )
(:goal (final-qds-opened bob nh3)))

;;; p6-radiator-fill

(define (problem bob-fillr)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 200.0)
  (:init (located bob p5-p6-juncture)
         (located sally p1-ata-panel)
         (installed nh3-jumper-p3-p4)
	(open qd15)(open qd14)(ata-configuration fill))
(:goal (p6-radiator-filled bob p6-radiator)))

;;; nh3-reroute&rad-fill
(define (problem bob-r&rf)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 300.0)
  (:goal (nh3-reroute&rad-fill_a bob)))

;;; vent-p6
(define (problem sally-vent-p6)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 300.0)
(:init (located sally p6-z-face1)
	(located vent-tool1 p6-z-face1)
	(installed vent-tool1))
(:goal (p6-lines-vented sally p6-radiator)))

;;;
;;; SARJ Lube tests
;;;

;;; Lube setup

(define (problem sally-setup-psarj)
    (:domain nasa-domain)
    (:situation phalcon-eva)
    (:deadline 300.0)
    (:init (located sarj-bag1 p3-p4-juncture)
           (located sally p3-p4-juncture))
(:goal (lube-setup-for sally sarj-port)))

(define (problem sally-setup-psarj2)
    (:domain nasa-domain)
    (:situation phalcon-eva)
    (:deadline 300.0)
    (:init (possesses sally sarj-bag1)
           (tethered_to ISS-safety-tether1 sally)
           (possesses sally stp1)
           (located sally airlock))
(:goal (sarj-lube-setup_a sally sarj-port)))

;;; sarj-cover-remove
(define (problem bob-rem-psarj)
    (:domain nasa-domain)
    (:situation phalcon-eva)
    (:deadline 300.0)
    (:init (located bob p3-p4-juncture)
           (located sarj-bag1 p3-p4-juncture)
	(adjustable-tethers-ready-at sarj-port))
(:goal (remove-covers_a bob sarj-port)))

;;;sarj-cover-removed-by-two
(define (problem bob-rem-psarj2)
    (:domain nasa-domain)
    (:situation phalcon-eva)
    (:deadline 300.0)
    (:init (located bob p3-p4-juncture)
           (located sally p3-p4-juncture)
	   (located sarj-bag1 p3-p4-juncture)
	   (adjustable-tethers-ready-at sarj-port))
(:goal (remove-covers-by-two_a bob sarj-port)))

;;; sarj-inspection
(define (problem bob-ins-psarj)
    (:domain nasa-domain)
    (:situation phalcon-eva)
    (:deadline 300.0)
    (:init (located bob p3-p4-juncture)
	(located sarj-bag1 p3-p4-juncture)
         (wipes-ready-at sarj-port)
	(covers-removed sarj-port))
(:goal (inspected bob sarj-port)))

;;; Sarj-cover-lube
(define (problem bob-lube-psarj)
    (:domain nasa-domain)
    (:situation phalcon-eva)
    (:deadline 300.0)
    (:init (located bob p3-p4-juncture)
	(located sarj-bag1 p3-p4-juncture)
	(grease-guns-ready-at sarj-port)
	(covers-removed sarj-port))
(:goal (lube-covers_a bob sarj-port)))

(define (problem bob-lube2-psarj)
    (:domain nasa-domain)
    (:situation phalcon-eva)
    (:deadline 300.0)
    (:init (located bob p3-p4-juncture)
	(located sarj-bag1 p3-p4-juncture)
	(grease-guns-ready-at sarj-port)
	(covers-removed sarj-port))
(:goal (lube-covers2_a bob sarj-port)))

;;; Sarj-cover-lube-by-two
(define (problem bob-lube-psarj2)
    (:domain nasa-domain)
    (:situation phalcon-eva)
    (:deadline 300.0)
    (:init (located bob p3-p4-juncture)
	(located sally p3-p4-juncture)
	(located sarj-bag1 p3-p4-juncture)
        (grease-guns-ready-at sarj-port)
	(covers-removed sarj-port))
(:goal (lube-covers-by-two_a bob sarj-port)))

(define (problem bob-lube2-psarj2)
    (:domain nasa-domain)
    (:situation phalcon-eva)
    (:deadline 300.0)
    (:init (located bob p3-p4-juncture)
	(located sally p3-p4-juncture)
	(located sarj-bag1 p3-p4-juncture)
        (grease-guns-ready-at sarj-port)
	(covers-removed sarj-port))
(:goal (lube-covers-by-two2_a bob sarj-port)))

;;; sarj-cover-install
(define (problem bob-inst-psarj)
    (:domain nasa-domain)
    (:situation phalcon-eva)
    (:deadline 300.0)
    (:init (located sarj-bag1 p3-p4-juncture)
     (located bob p3-p4-juncture)
	)
(:goal (install-covers_a bob sarj-port)))

(define (problem bob-inst-psarj2)
    (:domain nasa-domain)
    (:situation phalcon-eva)
    (:deadline 300.0)
    (:init (located sarj-bag1 p3-p4-juncture)
     (located bob p3-p4-juncture)
     (located sally p3-p4-juncture)
	)
(:goal (install-covers-by-two_a bob sarj-port)))

;; lube-sarj
(define (problem lube-psarj)
    (:domain nasa-domain)
    (:situation phalcon-eva)
    (:deadline 300.0)
    (:init (located sarj-bag1 p3-p4-juncture)
           (located bob p3-p4-juncture)
	)
(:goal (full-lube-done bob sarj-port)))

;;; fetch-apfr-to
(define (problem fetch-apfr)
    (:domain nasa-domain)
    (:situation phalcon-eva)
    (:deadline 300.0)
    (:init (located bob airlock)
	)
(:goal (fetched-to bob apfr3 p1-nadir-bay12)))

;;; return-apfr-to
(define (problem return-apfr)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 300.0)
  (:init (located bob p1-nadir-bay12)
	 (contains wif4 apfr3)
	 (available wif3)		; added 2/2/2016 by CE per Pete
	 )
  (:goal (returned-to bob apfr3 port-ceta-cart-loc)))

;;;setup-for-spdm-lube
(define (problem setup-spdm)
    (:domain nasa-domain)
    (:situation phalcon-eva)
    (:deadline 300.0)
    (:init (located bob airlock)
	(possesses bob sarj-bag1)
	)
	(:goal (ready-for-spdm-lube bob ssrms)))

;;;go-setup-for-spdm-lube
(define (problem go-setup-spdm)
    (:domain nasa-domain)
    (:situation phalcon-eva)
    (:deadline 300.0)
    (:init (located bob airlock)
	(tethered_to ISS-safety-tether1 bob)
        (located sarj-bag1 p3-p4-juncture)
	(possesses bob stp1))
	(:goal (ready-for-spdm-lube bob ssrms)))

;;; spdm-snare-lube
(define (problem spdm-lube)
    (:domain nasa-domain)
    (:situation phalcon-eva)
    (:deadline 300.0)
    (:init (located bob p1-nadir-bay12)
	   (located ssrms p1-nadir-bay12)
           (possesses bob sarj-bag1)
	   (contains wif4 apfr3)(ingressed bob apfr3))
	   (:goal (spdm-snares-lubed bob)))

;;;cleanup-for-spdm-lube
(define (problem cleanup-spdm)
    (:domain nasa-domain)
    (:situation phalcon-eva)
    (:deadline 300.0)
    (:init (located bob p1-nadir-bay12)
	(possesses bob sarj-bag1)
	(contains wif4 apfr3)
	(available wif3)
	(ingressed bob apfr3))
    (:goal (spdm-lube-cleanup_a bob ssrms)))

;;; complete-spdm-lube
(define (problem full-spdm)
    (:domain nasa-domain)
    (:situation phalcon-eva)
    (:deadline 300.0)
    (:init (located bob airlock)
		(tethered_to ISS-safety-tether1 bob)
        	(located sarj-bag1 p3-p4-juncture)
		(possesses bob stp1)(available wif3))
		(:goal (complete-spdm-lube_a bob ssrms)))

;;; install-s1-stow-beam
(define (problem install-beam)
    (:domain nasa-domain)
    (:situation phalcon-eva)
    (:deadline 300.0)
    (:init (located bob s1-stow-beam-loc)
	(possesses bob s1-beam-bag)
	)
	(:goal (installed-item bob s1-radiator-stow-beam)))

;;; fetch-and-install-s1-stow-beam
(define (problem install-beam2)
    (:domain nasa-domain)
    (:situation phalcon-eva)
    (:deadline 300.0)
    (:init (located bob p3-p4-juncture)
	(located s1-beam-bag airlock)
	)
	(:goal (installed-item bob s1-radiator-stow-beam)))

;;; nh3 decon
(define (problem decon-bob)
    (:domain nasa-domain)
    (:situation phalcon-eva)
    (:deadline 300.0)
    (:goal (decon-complete_a bob)))

(define (problem decon-one)
    (:domain nasa-domain)
    (:situation phalcon-eva)
    (:deadline 300.0)
    (:goal (nh3-decon_a)))

;;; New PHALCON Procs

(define (problem lock-sarjp)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (lock_sarj_a dave sarj-port)))

(define (problem recover-sarjp)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:init (previous-sarj-mode sarj-port directed-position)
	 (mode sarj-port shutdown))
  (:deadline 100.0)
  (:goal (recover-to-mode_a dave sarj-port)))

(define (problem d-ext)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (Deactivate-mdm_a jim ext-mdm1)))

(define (problem ritcs)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (Reconfigure-itcs_a nancy lab-itcs)))

;;;Prepare-for-ddcu-shutdown_a

(define (problem done-fc-jobs) 
	(:domain nasa-domain) 
	(:situation phalcon-eva) 
	(:deadline 390.0)
      	(:goal (ddcu-r&r-done ddcus01a)))

;;; Interesting swap problems. 4/21/13
;;; This uses tether-swap rather than install-tether&swap. Why?

(define (problem sally-to-p6)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:init (located sally airlock)
	 (tethered_to ISS-safety-tether1 sally)
	 (possesses sally stp1)
         (possesses sally ceta-light-bag2))
  (:goal (sequential
		(RETRIEVE-ITEM_A sally CETA-LIGHT3)
                (located sally airlock)))
  )

;;;But if we use this action and problem, it incorrectly re-uses the first tether swap to
;;;get sally back.
(NEW-PREDICATE '(JOBS-DONE ?AGENT1 - CREW) NASA-DOMAIN)
(DEFINE (DURATIVE-ACTION DO-JOBS) :PARAMETERS (?AGENT1 - CREW) :VARS
           (?AGENT2 - CREW ?ARM - ROBOTIC-ARM ?BAG - MEDIUM-ORU-BAG) :CONDITION
           (AND (AT START (NOT (= ?AGENT1 ?AGENT2))) (AT START (NOT (= (OPERATOR ?ARM) ?AGENT1)))
                (AT START (NOT (= (OPERATOR ?ARM) ?AGENT2)))
                (OVER ALL (BAG-SIZE-FOR CETA-LIGHT1 ?BAG)))
           :EXPANSION
           (SEQUENTIAL (LOCATED ?AGENT1 AIRLOCK) (LOCATED ?BAG AIRLOCK)
            (PREPARE-FOR-EVA_A ?AGENT1) (POSSESSES ?AGENT1 ?BAG) (RETRIEVE-ITEM_A ?AGENT1 CETA-LIGHT1)
            (LOCATED ?AGENT1 AIRLOCK) (LOCATED ?AGENT1 INTRA-VEHICLE) (LOCKED HATCH)
            (PREPARE-FOR-REPRESS_A ?AGENT1))
           :EFFECT (AT END (JOBS-DONE ?AGENT1)))
(DEFINE (PROBLEM DONE-JOBS) (:DOMAIN NASA-DOMAIN) (:SITUATION PHALCON-EVA)
           (:INIT (LOCATION-FOR DDCUS01A DDCUS01A-LOC) (POSSESSES SALLY S1-BEAM-BAG))
           (:DEADLINE 390.0) (:GOAL (JOBS-DONE SALLY)))

#|


#|
(DEFINE (DURATIVE-ACTION DO-JOBS) :PARAMETERS (?AGENT1 - CREW) :VARS
           (?AGENT2 - CREW ?ARM - ROBOTIC-ARM ?STP - SAFETY-TETHER-PACK ?BAG -
            MEDIUM-ORU-BAG)
           :CONDITION
           (AND (AT START (NOT (= ?AGENT1 ?AGENT2)))
                (AT START (NOT (= (OPERATOR ?ARM) ?AGENT1)))
                (AT START (NOT (= (OPERATOR ?ARM) ?AGENT2))) (POSSESSES ?AGENT1 ?STP)
                (OVER ALL (BAG-SIZE-FOR CETA-LIGHT3 ?BAG)))
           :EXPANSION
           (SEQUENTIAL (LOCATED ?AGENT1 AIRLOCK) (LOCATED ?BAG AIRLOCK)
            (PREPARE-FOR-EVA_A ?AGENT1) (POSSESSES ?AGENT1 ?BAG)
            (RETRIEVE-ITEM_A ?AGENT1 CETA-LIGHT3) (LOCATED ?AGENT1 AIRLOCK)
            (LOCATED ?BAG INTRA-VEHICLE) (LOCATED ?AGENT1 INTRA-VEHICLE) (LOCKED HATCH)
            (PREPARE-FOR-REPRESS_A ?AGENT1))
           :EFFECT (AT END (JOBS-DONE ?AGENT1)))

(DEFINE (PROBLEM DONE-JOBS) (:DOMAIN NASA-DOMAIN) (:SITUATION PHALCON-EVA)
           (:INIT (LOCATION-FOR DDCUS01A DDCUS01A-LOC) (POSSESSES SALLY S1-BEAM-BAG))
           (:DEADLINE 390.0) (:GOAL (JOBS-DONE SALLY)))
(DEFINE (DURATIVE-ACTION DO-JOBS) :PARAMETERS (?AGENT1 - CREW) :VARS
           (?AGENT2 - CREW ?ARM - ROBOTIC-ARM ?STP - SAFETY-TETHER-PACK ?BAG -
            MEDIUM-ORU-BAG)
           :CONDITION
           (AND (AT START (NOT (= ?AGENT1 ?AGENT2)))
                (AT START (NOT (= (OPERATOR ?ARM) ?AGENT1)))
                (AT START (NOT (= (OPERATOR ?ARM) ?AGENT2))) (POSSESSES ?AGENT1 ?STP)
                (OVER ALL (BAG-SIZE-FOR CETA-LIGHT3 ?BAG)))
           :EXPANSION
           (SEQUENTIAL (LOCATED ?AGENT1 AIRLOCK) (LOCATED ?BAG AIRLOCK)
            (PREPARE-FOR-EVA_A ?AGENT1) (POSSESSES ?AGENT1 ?BAG)
            (RETRIEVE-ITEM_A ?AGENT1 CETA-LIGHT3) (LOCATED ?AGENT1 AIRLOCK)
            (LOCATED ?BAG INTRA-VEHICLE) (LOCATED ?AGENT1 INTRA-VEHICLE) (LOCKED HATCH)
            (PREPARE-FOR-REPRESS_A ?AGENT1))
           :EFFECT (AT END (JOBS-DONE ?AGENT1)))

(DEFINE (PROBLEM DONE-JOBS) (:DOMAIN NASA-DOMAIN) (:SITUATION PHALCON-EVA)
           (:INIT (LOCATION-FOR DDCUS01A DDCUS01A-LOC) (POSSESSES SALLY S1-BEAM-BAG))
           (:DEADLINE 390.0) (:GOAL (JOBS-DONE SALLY)))

|#
;;; 4/12/2012
;;;special problem that breaks AP

(define (problem done-jobs) 
   (:domain nasa-domain) 
   (:situation phalcon-eva) 
   (:deadline 390.0) 
   (:init (located sally airlock) 
         (located ceta-light-bag1 airlock) 
         (located bob airlock)
         (located fish-stringer1 airlock))
   (:goal (jobs-done sally bob))
        )

;;; The 4 parallels kill this.
(define (durative-action do-jobs) 
        :parameters (?agent1 ?agent2 - crew) 
        :expansion
        (sequential 
         (parallel (prepare-for-eva_a ?agent1) (prepare-for-eva_a ?agent2))
         (parallel (possesses ?agent1 ceta-light-bag1) (possesses ?agent2 fish-stringer1))
         (parallel (retrieve-item_a ?agent1 ceta-light1) (install-item_a ?agent2 power-cable1))
         (parallel (located ?agent1 airlock) (located ?agent2 airlock)))
        :effect (at end (jobs-done ?agent1 ?agent2)))

check-preconditions TRANSLATE-BY-HANDRAIL: (NOT (TOO-FAR P5-P6-JUNCTURE-TO-AIRLOCK))
  failed because (TOO-FAR P5-P6-JUNCTURE-TO-AIRLOCK) holds

meu <sg 8 DO-JOBS106829 LOCATED>:  LOCATED(BOB)=AIRLOCK
  (DONE-JOBS_IS TRANSLATE-BY-HANDRAIL107669)
  => DONE-JOBS_IS
parallel-expand: <join107303 GO-INSTALL-ITEM107079_OUT RETRIEVE-ITEM106848_OUT> will not be joined
Error: No methods applicable for generic function #<STANDARD-GENERIC-FUNCTION NEXT-INPUT> with args
       (NIL <join107303 GO-INSTALL-ITEM107079_OUT RETRIEVE-ITEM106848_OUT>) of classes (NULL JOIN)
  [condition type: PROGRAM-ERROR]

Restart actions (select using :continue):
 0: Try calling it again
 1: Return to Top Level (an "abort" restart).
 2: Abort entirely from this (lisp) process.
[1c] AP(305): 

;;; This works but EM breaks on it
(define (durative-action do-jobs) 
        :parameters (?agent1 ?agent2 - crew) 
        :expansion
        (sequential 
         (parallel (prepare-for-eva_a ?agent1) (prepare-for-eva_a ?agent2))
         (parallel (possesses ?agent1 ceta-light-bag1) (possesses ?agent2 fish-stringer1))
         (parallel (retrieve-item_a ?agent1 ceta-light1) (install-item_a ?agent2 power-cable1))
         (located ?agent1 airlock) (located ?agent2 airlock))
        :effect (at end (jobs-done ?agent1 ?agent2)))

AP(351): :321
(SIMULATE-EXECUTION)

allow-to-proceed: PREPARE-FOR-EVA121066 BUSY
Error: Attempt to take the car of :BUSY which is not listp.
  [condition type: TYPE-ERROR]

Restart actions (select using :continue):
 0: Return to Top Level (an "abort" restart).
 1: Abort entirely from this (lisp) process.
[1] AP(352): 

;;; Same here
(define (durative-action do-jobs) 
        :parameters (?agent1 ?agent2 - crew) 
        :expansion
        (sequential 
         (parallel (prepare-for-eva_a ?agent1) (prepare-for-eva_a ?agent2))
         (parallel (possesses ?agent1 ceta-light-bag1) (possesses ?agent2 fish-stringer1))
         (parallel (sequential 
			(retrieve-item_a ?agent1 ceta-light1)
			(located ?agent1 airlock))
		   (sequential 
			(install-item_a ?agent2 power-cable1)
			(located ?agent2 airlock))))
        :effect (at end (jobs-done ?agent1 ?agent2)))

;;; The original prob and action that gets a plan but that EM hreaks on:
(define (problem done-jobs) 
	(:domain nasa-domain) 
	(:situation phalcon-eva) 
	(:deadline 390.0) 
	(:goal (jobs-done sally bob)))

(define (durative-action do-jobs) 
	:parameters (?agent1 ?agent2 - crew) 
	:vars (?arm - robotic-arm ?bag - medium-oru-bag)
        :condition
        (and (at start (not (= ?agent1 ?agent2))) (at start (not (= (operator ?arm) ?agent1)))
             (at start (not (= (operator ?arm) ?agent2))) (at start (located ?agent1 intra-vehicle))
             (at start (located ?agent2 intra-vehicle)) (over all (bag-size-for ceta-light1 ?bag)))
        :expansion
        (sequential 
		(located ?agent1 airlock) (located ?bag airlock) (located fish-stringer1 airlock)
         	(located ?agent2 airlock) 
		(parallel (prepare-for-eva_a ?agent1) (prepare-for-eva_a ?agent2))
         	(parallel (possesses ?agent1 ?bag) (possesses ?agent2 fish-stringer1))
         	(parallel (retrieve-item_a ?agent1 ceta-light1) (install-item_a ?agent2 power-cable1))
         	(parallel (located ?agent1 airlock) (located ?agent2 airlock)) (located ?agent2 intra-vehicle)
         	(located ?bag intra-vehicle))
       : effect (at end (jobs-done ?agent1 ?agent2)))


expand-plot DO-JOBS121981 failed on <sg 3 GO-INSTALL-ITEM124463 INSTALLED> in PHALCON-EVA

backtrack to <sg 3 RETRIEVE-ITEM124236 EXTRACTED-ITEM-TO>:
  delete-from-conflict-set EXTRACT-ITEM-TO-BAG124460 <sg 3 RETRIEVE-ITEM124236 EXTRACTED-ITEM-TO>
really-backtrack: possibly-expand-plot of RETRIEVE-ITEM124236 from <join124234 PICK-UP124233_OUT PICK-UP124231_OUT>

meu <sg 3 RETRIEVE-ITEM124236 EXTRACTED-ITEM-TO>:  EXTRACTED-ITEM-TO(SALLY,CETA-LIGHT1,CETA-LIGHT-BAG2)
  (EXTRACT-ITEM-TO-BAG124461 EXTRACT-ITEM-TO-BAG124462)
  => EXTRACT-ITEM-TO-BAG124461
   to replace EXTRACT-ITEM-TO-BAG124460
Warning: last-subactions DO-JOBS121981: subactions
         (EGRESS-INSIDE-AGENT123996 STOW-EXTERNAL123998 STOW-EXTERNAL124002 EGRESS-INSIDE-AGENT124220
          PREPARE-FOR-EVA124221 PREPARE-FOR-EVA124225 PICK-UP124231 PICK-UP124233 RETRIEVE-ITEM124236
          GO-INSTALL-ITEM124463 NIL NIL NIL NIL)
Error: DO-JOBS121981: NIL what should the split be? NIL

Restart actions (select using :continue):
 0: Return to Top Level (an "abort" restart).
 1: Abort entirely from this (lisp) process.
[1] AP(358): 

|#

#|
I use the following to load and run:

ap:  (load-a-domain)

this gives a numbered list of all .PDDL files in the directory =
AP:domains; you can load one by typing the number (<cr> to exit), or you =
can type a sequence of numbers, such as:  22,28,26=20
and it will load those in that order. =20

[BTW, if your <domain> in the file <domain>.pddl then it will be loaded =
automatically if not already done when it tries to load a situation with =
:domain <domain> in the PDDL.  I generally keep all my situations and =
the problems that reference them in a single file and the domain in a =
different one. then I only have to load the situation/problem file. Just =
one more (undocumented) feature]

ap:  (run-again)

this will put up a numbered list of the problems defined for *domain*. =
It has a keyword arg if you want a different domain.

or you can run them all:

ap:  (run-all-problems)

(define (problem pick-bag)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (item-picked ceta-light-bag1))
  )

(define (problem pick-cbag)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (item-picked crew-lock-bag1))
  )

(define (problem pick-apfr)
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 100.0)
  (:goal (item-picked apfr2))
  )

(define (problem crew-r&r-d1) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 200.0)
  (:goal (did-ddcu1 bob ddcus01a))
  )

(define (problem crew-r&r-d2) 
    (:domain nasa-domain)
  (:situation phalcon-eva)
  (:deadline 200.0)
  (:goal (did-ddcu2 ddcus01a))
  )


|#
