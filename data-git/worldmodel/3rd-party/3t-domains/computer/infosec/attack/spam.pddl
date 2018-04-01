(in-package :ap)
#|
 ;;; actions developed from Lighthouse rules.
;;; Assumes definitions of unix and network.

;;; Questions:
;;;  1. Should we continue to make a distinction between "identity"
;;;     and having a "shell" as a particular UID?
;;;  2. Should "trusts" be mainly derived in :axioms from
;;;     stuff found in files--like UIDs and Wildcards?
;;;  3. Where is the xhost file usually kept?  Which dir?
;;;  4. What about "reachable"?  that could be an important, or nasty
;;;     to compute relation.  Should the config data sent from the GUI
;;;     include it?
;;; ohters?


(define (domain spam)
    (:extends hacker)
  (:predicates (trusts ?h - Host ?u - Account ?other - Host)
	       (reachable ?s - Host ?d - Host))
  (:axiom
   :vars (?local ?remote - Host
	  ?home - Directory)
   :context (and (home ?uid ?remote ?home)
		 (find ?local ?remote ?home rhosts))
   :implies (trusts ?remote ?uid ?local))

  ;;==vulnerabilities in versions of Solaris  
;;;  if the target is running Solaris 2.5.1
;;;      and rlogin is possible on the target
;;;      and the attacker can run the rlogin buffer overflow exploit code on
;;;          the attack system
;;;      and the attack system can reach the target
;;;   then it is possible for attacker run a shell as root on the target
  (action rlogin_buffer_overflow
	  :parameters (?attack-host ?target - Host
		       ?uid - Account
		       ?attacker - User)
	  :precondition (and (os ?target solaris_2.5.1)
			     (offersService ?target r-commands)
			     (hasShell ?attacker ?uid ?attack-host)
			     (reachable ?attack-host ?target))
	  :effect (hasShell ?attacker ?uid ?target))

;;;   if the target is running Solaris 2.7
;;;      and rlogin is possible on the target
;;;      and the target trusts a Account on the attack system
;;;      and the attacker can run rlogin on the attack system as the Account
;;;          trusted by the target
;;;      and the attack system can reach the target
;;;   then the attacker can get a shell on the target as the trusted Account
   (action rlogin_trust
	   :parameters (?attack-host ?target - Host
	                ?uid - Account
			?attacker - User)
	   :precondition (and (os ?target solaris_2.7)
			      (offersService ?target r-commands)
			      (trusts ?target ?attacker ?attack-host)
			      (hasShell ?attacker ?uid ?attack-host)
			      (reachable ?target ?attack-host))
	   :effect (hasShell ?attacker ?uid ?target))

;;;   if the target is running Solaris 2.5
;;;      and the attacker can get a shell on the target as a regular Account
;;;   then the attacker can run a shell as root on the target
   (action bin_eject
	   :parameters (?target - Host
	                ?uid - Account
			?attacker - User)
	   :precondition (and (os ?target solaris_2.5)
			      (hasShell ?attacker ?uid ?target))
	   :effect (identity ?target root))

   ;;==X11 trust mistakes
;;;   if the target is running X11
;;;      and the target's xhost configuration permits a Account on the attack
;;;          system to connect  (either directly or via xhost +)
;;;      and the attacker can run the xhost trust exploit code on the attack
;;;          system 
;;;      and the attack system can reach the target
;;;   then the attacker can get a shell on the target as the trusted Account
   (action xhost_trust
	   :parameters (?attack-host ?target - Host
	                ?attacker - User
	                ?uid - Account
			?exposed-to - (either wildcard Host)
			?dir - Directory)
	   :constraints (or (typep ?exposed-to 'wildcard)
			    (eql ?exposed-to ?attack-host))
	   :precondition (and (offersService ?target x11)
			      (found ?target ?dir xhost-configuration ?exposed-to)
			      (hasShell ?attacker ?uid ?attack-host)
			      (reachable ?target ?attack-host))
	   :effect (hasShell ?attacker ?uid ?target))
   
   ;;=== misc junk exploits
;;;   if the target is running a server
;;;      and the attacker knows the password of a Account who is authorized
;;;          access to the server 
;;;      and there is a system where attacker can execute the client
;;;   then the attacker can execute the command interpreter of the server on
;;;        the target
  (:action password_replay_shell
	   :parameters (?target ?attack-host - Host
			?service - Service
	                ?uid - Account
			?attacker - Account)
	   :precondition (and (offersService ?target ?service)
			      (hasAccess ?uid ?target ?service)
			      (knowsPassword ?target ?uid)
			      (offersService ?attack-host ?service)
			      (reachable ?target ?attack-host))
	   :effect (hasShell ?attacker ?uid ?target))
  
;;;   if the target is running Internet Explorer 5.0 as as a POP mail client
;;;      and ActiveX Controls are enabled
;;;      and the attacker can run mail on the attack system
;;;   then the attacker can get a shell on the target as root
  (:action outlook_express_activex
	   :parameters (?target - Host
			?attacker - User
			?uid - Account)
	   :precondition (and (offersService ?target IE_5.0)
			      (offersService ?target ActiveX))
	   :effect (hasShell ?attacker ?uid ?target))
  
;;;   if there is a client-server pair used by a login name known to attacker
;;;      and attacker can run a sniffer on the attack system
;;;      and the attack system is connected to a link on the path between the
;;;          client-server pair
;;;   then the attacker can steal the password corresponding to the login name
  (:action sniff_password
	   :parameters (?target ?attack-host - Host
				?attacker - User
				?uid - Account)
	   :precondition (and (accountExists ?target ?uid)
			      (hasShell ?attacker :ignore ?attack-host)
			      (connected ?attack-host ?target))
	   :effect (knowsPassword ?attacker ?target ?uid))
  
;;;   if there is a telnet client-server pair in use by Account
;;;      and the attacker can run the session hijack code on the attack system
;;;      and the attack system is connected to a link on the path between the
;;;          client-server pair
;;;   then the attacker can get a shell on root as the Account
  (:action telnet_session_hijack
	   :parameters (?target ?attack-host - Host
			?attacker - User
			?uid - Account)
	   :precondition (and (offersService ?target telnet)
			      (accountExists ?target ?uid)
			      (hasShell ?attacker ?uid ?attack-host)
			      (connected ?attack-host ?target))
	   :effect (hasShell ?attacker ?uid ?target))
			;(identity ?target root)

;;;   if a web browser on the target is configured to automatically open files
;;;      with executable content (e.g., Word docs with macros)
;;;      and the attacker has the execute from browser exploit code
;;;      and the attack system can reach the target
;;;   then the target is penetrated
  (:action execute_from_browser
	   :parameters (?target ?attack-host - Host
			?dir - Directory)
	   :precondition (and (offersService ?target IE_5.0)
			      (reachable ?target ?attack-host))
	   :effect (hasAccess ?attack-host ?target ?dir))
  )
|#