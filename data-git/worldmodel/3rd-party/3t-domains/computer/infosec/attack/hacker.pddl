(in-package :ap)
#|
This demo is a computer hacker domain.

The main idea is to diagnose computer intrusions by generating
possible plans that could Account for the intrusion. These would
be used to guide a search for evidence in log files and such.

This domain demonstrates several features of AP, such as:
- generating multiple alternative plans for a given
  goal
- making Assumptions when a subgoal of an action can't be
  established with the current set of actions or when
  some preconditions are not known to hold.

You can exercise these features via global parameters which are
typically set using the menu that comes up when you click
Control>Generate Plan
on the AP GUI.
|#

(define (domain hacker)
    (:extends unix windows malware)
#|  (:predicates
   (identity ?u - User ?h - Host ?a - OnlineAccount))|#
  ;;==knowsPassword
#|  (:action crack
    :parameters (?user - User
		 ?host - Host
		 ?uid - OnlineAccount)
    :vars (?from - Host)
    :precondition (and (accountExists ?host ?uid)
		       (hasAccess ?from ?host shadow))
    :effect (knowsPassword ?user ?host ?uid)
    :probability 0.25
    :duration 10.0
    :documentation "access to shadow password file")
  (:action sniff
    :parameters (?from ?host - Host
		 ?uid - OnlineAccount
		 ?user - User)
    :vars (?from - Host
		 ;;?some-uid - OnlineAccount
		 )
    :precondition (and (connected ?from ?host)
		       (accountExists ?host ?uid)
		       (hasShell ?user ?from :ignore) ;;?some-uid)
		       (not (= ?from ?host)))
    :effect (knowsPassword ?user ?host ?uid)
    :probability 0.1
    :duration 24.0
    :documentation "access to local network")
  (:action guess-password
    :parameters (?host - Host
		 ?uid - OnlineAccount
		 ?user - User)
    :precondition (accountExists ?host ?uid)    
    :effect (knowsPassword ?user ?host ?uid)
    :probability 0.05
    :duration 0.5
    :documentation "social engineering--might also have asked")
  ;;---- hacker scripts ------
  (:action sniff-passwords
    :parameters (?host - Host
		 ?uid - OnlineAccount
		 ?user - User)
    :vars (?from - Host
	   ?some-uid - OnlineAccount)
    :precondition (and (accountExists ?host ?uid)
		       (not (connected ?from ?host))
		       (accountExists ?from ?some-uid)
		       (not (= ?from ?host)))
     :expansion (sequential 
		 (hasShell ?user ?from ?some-uid)
		 (connected ?from ?host))
     :effect (knowsPassword ?user ?host ?uid)
     :duration 24.0) 
  (:action crack-shadow
    :parameters (?host - Host
		 ?uid - OnlineAccount
		 ?user - User)
    :vars (?from - Host
	   ?some-uid - OnlineAccount)
    :precondition (and (accountExists ?host ?uid)
		       (connected ?from ?host)
		       (accountExists ?from ?some-uid)
		       (not (= ?from ?host)))
    :expansion (sequential 
		(hasShell ?user ?from ?some-uid)
		(hasAccess ?from ?host shadow))
    :effect (knowsPassword ?user ?host ?uid)
    :duration 24.0)|#
  (:action load-rootkit
   :parameters (?victim - Host
		?hacker-tool - ComputerFile	 
		?dir - Directory)
   :vars (?rootkit - TarFile
	  ?host - Host
	  ?hacker - User
	  ?uid - OnlineAccount
	  ?source-dir - Directory)
   :precondition (and (hasShell ?hacker ?victim ?uid)
		      (hasFile ?host ?source-dir ?rootkit)
		      (found ?host ?source-dir ?rootkit ?hacker-tool)
		      (not (= ?host ?victim)))
    :expansion (sequential
		(workingDirectory ?uid ?victim /tmp) ;; cd
		(hasFile ?victim /tmp ?dir) ;; mkdir
		(workingDirectory ?uid ?victim ?dir) ;; cd
		(hasFile ?victim ?dir ?rootkit) ;; ftp get
		(hasFile ?victim ?dir ?hacker-tool);; tar xvf
		(not (hasFile ?victim ?dir ?rootkit))) ;; rm
    :effect (hasFile ?victim ?dir ?hacker-tool))
  )

(define (action create-superuser)
    :parameters (?remote - Host
		 ?user - User
		 ?root - OnlineAccount)
    :vars (?existing-uid - OnlineAccount
	   ?local - Host
	   ?exposed-to - (either wildcard Host))
    :precondition (and (found ?remote /etc hosts.equiv ?exposed-to)
		       (hasAccess ?existing-uid ?remote /etc)
		       (accountExists ?local ?existing-uid)
		       (not (accountExists ?remote ?root))
		       (not (= ?root ?existing-uid))
		       (not (= ?remote ?local))
		       (not (= ?exposed-to ?remote)))
    :expansion (sequential
		(hasShell ?user ?local ?existing-uid)
		(hasAccount ?local ?root superuser /)
		(hasAccount ?remote ?root superuser /) ;; create OnlineAccount
		(hasShell ?user ?local ?root)
		(hasShell ?user ?remote ?root))
    :effect (hasShell ?user ?remote ?root))

#| new
(define (action rlogin-hack)
    :parameters (?user - User
		 ?victim - Host 
		 ?uid - OnlineAccount)
    :vars (?local - Host
	   ?root - OnlineAccount
	   ?home - Directory)
    :precondition (and (hasAccount ?local ?root superuser :ignore)
		       (homeDirectory ?victim ?uid ?home)
		       (found ?victim /etc sharetab ?home) ; exposure
		       (not (= ?victim ?local)))
    :expansion (sequential
		(hasShell ?user ?local ?root)
		(hasAccess ?local ?victim ?home)
		(accountExists ?local ?uid)
		(hasShell ?user ?local ?uid)
		(found ?victim ?home rhosts ?local)
		(hasShell ?user ?victim ?uid))
    :effect (hasShell ?user ?victim ?uid)
    :documentation "exposure: allow attacker to mount a Directory")
|#

;;; original
(define (action rlogin-hack)
    :parameters (?user - User
		 ?victim - Host 
		 ?uid - OnlineAccount)
    :vars (?local - Host
	   ?root - OnlineAccount
	   ?home - Directory)
    :precondition (and (hasAccount ?local ?root superuser :ignore)
		       (homeDirectory ?victim ?uid ?home)
		       ;;(found ?victim /etc sharetab ?home) wrong order 1/27/2016
		       (found ?victim ?home /etc sharetab) ; exposure
		       (not (= ?victim ?local)))
    :expansion (sequential
		(hasShell ?user ?local ?root)
		(hasAccess ?local ?victim ?home)
		(accountExists ?local ?uid)
		(hasShell ?user ?local ?uid)
		(found ?victim ?home rhosts ?local)
		(hasShell ?user ?victim ?uid))
    :effect (hasShell ?user ?victim ?uid)
    :documentation "exposure: allow attacker to mount a Directory")

;;;--- test problems ----

(define (situation red-hacker)
    (:domain hacker)
  (:objects eve butterfinger beetle - unixHost
	    eve-sa - User)
  (:init (hasAccount eve root superuser /)
	 (hasAccount eve guest user /export)
	 (knowsPassword eve-sa eve root)
	 (offersService eve r-commands)
	 (offersService eve ftp)
	 (offersService eve console)
	 ;;==enclave firewall
	 (hasAccount beetle root superuser /)
	 (offersService beetle r-commands)
	 (offersService beetle console)
	 ;;==target
	 (hasAccount butterfinger root superuser /)
	 (offersService butterfinger r-commands)
	 (offersService butterfinger console)
	 ))

;;; "+wildcard+" wildcard in Hosts.equiv: attack2
(define (problem unknown-superuser)
  (:situation red-hacker)
  (:objects bin toor - OnlineAccount)
  (:init (hasAccount beetle bin user /etc)
	 (hasFile beetle /etc passwd)
	 (hasFile beetle /etc shadow)
	 (hasAccount butterfinger bin user /etc)
	 (hasFile butterfinger /etc passwd)
	 (hasFile butterfinger /etc shadow)
	; (file-owner butterfinger /etc :all bin)
	 (found butterfinger /etc hosts.equiv +wildcard+)) ;; exposure!
  (:goal #|(and (group victim.disa.mil toor superuser)
	      (shell victim.disa.mil toor))|#
	 (hasShell eve-sa butterfinger toor))
  )

(define (problem load-rootkit)
  (:situation red-hacker)
  (:objects /toolz /kde - Directory
	    rootkit.tar - TarFile)
  (:init (offersService butterfinger ftp)
	 (hasShell eve-sa butterfinger guest)
	 (hasFile eve /toolz rootkit.tar)
	 (found eve /toolz rootkit.tar Trojan))
  (:goal (hasFile butterfinger /kde Trojan)))

;;;----

(define (situation red-hacker2)
    (:domain hacker)
  (:objects azrael.mil.foreign victim.disa.mil gateway.disa.mil - unixHost
	    black-hat - User)
  (:init (hasAccount azrael.mil.foreign root superuser /)
	 (knowsPassword black-hat azrael.mil.foreign root)
	 (offersService azrael.mil.foreign console)
	 ;;==enclave firewall
	 (hasAccount gateway.disa.mil root superuser /)
	 ;;==target
	 (hasAccount victim.disa.mil root superuser /)
	 ))

;;; "+wildcard+" wildcard in Hosts.equiv
;;; appears to be test of create-superuser
(define (problem unknown-superuser_2)	; ap will have to assume
    (:domain hacker)			; someone has logged in gateway
  (:situation red-hacker2)		; as bin
  (:objects bin toor - OnlineAccount)
  (:init 
   (hasShell black-hat gateway.disa.mil bin) ; added by CE 12/4/2016
   ;;(knowsPassword black-hat azrael.mil.foreign bin)
   (hasAccount gateway.disa.mil bin users /etc) 
   (hasAccount victim.disa.mil bin users /etc)
   (hasFile victim.disa.mil /etc passwd)
   (hasFile victim.disa.mil /etc shadow)
   (found victim.disa.mil /etc hosts.equiv +wildcard+)) ;; exposure!
  (:goal #|(and (group victim.disa.mil toor superuser)
	      (shell victim.disa.mil toor))|#
	 (hasShell black-hat victim.disa.mil toor))
  )

;; original
;;guest's home dir is exported to everyone ...
(define (problem rlogin-as-guest) 
    ;;(:requirements :assumptions)
  (:situation red-hacker2)
  (:init ;;==target
	 (hasAccount gateway.disa.mil guest user /export)
	 (hasFile gateway.disa.mil /export rhosts) ; stupid
	 (found gateway.disa.mil /export /etc sharetab) ; exposure
	 ;;==attacker
	 (homeDirectory azrael.mil.foreign guest /export))
  (:goal (hasShell black-hat gateway.disa.mil guest)))

;;;guest's home dir is exported to everyone ...
(define (problem rlogin-as-guest_2) 
    ;;(:requirements :assumptions)
  (:situation red-hacker2)
  (:init ;;==target
	 (hasAccount gateway.disa.mil guest user /export)
	 (hasFile gateway.disa.mil /export rhosts) ; stupid
	 (found gateway.disa.mil /etc sharetab /export) ; exposure
	 ;;==attacker
	 (hasAccount azrael.mil.foreign guest user /export))
  (:goal (hasShell black-hat gateway.disa.mil guest)))

;;; tftp doesn't require much effort to hack.
;;; Its often turned on for routers to get the router table update.
(define (problem steal-passwd)
    (:domain hacker)
  (:situation red-hacker2)
  (:deadline 48.0)
  (:init (hasAccount gateway.disa.mil guest users /export)
	 (offersService victim.disa.mil tftp) ; esposure!
	 (connected gateway.disa.mil victim.disa.mil))
  (:goal (knowsPassword black-hat victim.disa.mil root)))

;;;-- additional test situation --

;;; changes for demo:
;;;  NIPRNet, SIPRNet, JWICS for FriendlyNet, SecretNet, TopSecretNet
;;;  Friend1.disa.mil --> gateway.disa.mil
;;;  secret1.disa.mil --> victim.disa.mil
;;;  enemy1.foreign.mil --> azrael.foreign.mil
;;;  got rid of enemyNet and FW1, azrael.foreign.mil part of internet

#|  unused 2/4/2016
(define (situation sample-MSRNet)
    (:domain network)
  (:objects
   MSRNet InterNet NIPRNet SIPRNet JWICS - network
   Router1 Router2 Router3 Router4 - router
   FW6 FW2 FW3 FW4 FW5 - firewall
   Hub3 Hub2 Hub1 - Hub
   Azrael.foreign.mil Gateway.disa.mil victim.disa.mil 
   Friend2.disa.mil Friend3.disa.mil Friend4.disa.mil Friend5.disa.mil Friend6.disa.mil 
   ts1.disa.mil ts2.disa.mil ts3.disa.mil secret2.disa.mil - Host
   )
  (:init
          (part-of InterNet MSRNet)
          (part-of NIPRNet MSRNet)
          (part-of SIPRNet MSRNet)
          (part-of JWICS SIPRNet)
          (part-of Router1 MSRNet)
          (part-of Router2 MSRNet)
          (part-of Router3 MSRNet)
          (part-of Router4 MSRNet)
          (part-of FW6 SIPRNet)
          (part-of FW2 MSRNet)
          (part-of FW3 MSRNet)
          (part-of FW4 MSRNet)
          (part-of FW5 MSRNet)
          (part-of Hub3 NIPRNet)
          (part-of Hub2 JWICS)
          (part-of Hub1 SIPRNet)
          (part-of Gateway.disa.mil NIPRNet)
          (part-of Friend2.disa.mil NIPRNet)
          (part-of Friend3.disa.mil NIPRNet)
          (part-of Friend4.disa.mil NIPRNet)
          (part-of Friend5.disa.mil NIPRNet)
          (part-of Friend6.disa.mil NIPRNet)
          (part-of Azrael.foreign.mil InterNet)
          (part-of ts1.disa.mil JWICS)
          (part-of ts2.disa.mil JWICS)
          (part-of ts3.disa.mil JWICS)
          (part-of victim.disa.mil SIPRNet)
          (part-of secret2.disa.mil SIPRNet)
          
          (connected Hub3 Gateway.disa.mil)
          (connected Gateway.disa.mil Hub3)
          (connected Hub3 Friend6.disa.mil)
          (connected Friend6.disa.mil Hub3)
          (connected Hub3 Friend5.disa.mil)
          (connected Friend5.disa.mil Hub3)
          (connected Hub3 Friend4.disa.mil)
          (connected Friend4.disa.mil Hub3)
          (connected Hub3 Friend3.disa.mil)
          (connected Friend3.disa.mil Hub3)
          (connected Hub3 Friend2.disa.mil)
          (connected Friend2.disa.mil Hub3)
          (connected Hub2 ts1.disa.mil)
          (connected ts1.disa.mil Hub2)
          (connected Hub2 ts3.disa.mil)
          (connected ts3.disa.mil Hub2)
          (connected Hub2 ts2.disa.mil)
          (connected ts2.disa.mil Hub2)
          (connected victim.disa.mil Hub1)
          (connected Hub1 victim.disa.mil)
          (connected Hub1 secret2.disa.mil)
          (connected secret2.disa.mil Hub1)
          (connected Hub1 FW6)
          (connected FW6 Hub1)
          (connected FW6 JWICS)
          (connected JWICS FW6)
          (connected Router1 InterNet)
          (connected InterNet Router1)
          (connected InterNet Router2)
          (connected Router2 InterNet)
          (connected Router2 FW2)
          (connected FW2 Router2)
          (connected FW2 NIPRNet)
          (connected NIPRNet FW2)
          (connected NIPRNet FW5)
          (connected FW5 NIPRNet)
          (connected FW5 Router3)
          (connected Router3 FW5)
          (connected Router3 FW3)
          (connected FW3 Router3)
          (connected FW3 SIPRNet)
          (connected SIPRNet FW3)
          (connected SIPRNet FW4)
          (connected FW4 SIPRNet)
          (connected FW4 Router4)
          (connected Router4 FW4)
          (connected Router4 InterNet)
          (connected InterNet Router4)
))
|#