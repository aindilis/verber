(in-package :ap)

(define (domain computer)
    (:extends foaf event)
  (:types Protocol OnlineAccount Segment Privilege wildcard - object
	  Computer - Machine
	  Host - Computer
	  OperatingSystem RemoteAdministrationTool - Program
	  User - Agent
	  Superuser - Group
	  Segment - DigitizedInformationBearingEntity
	  ComputerFile Link - Segment
	  Directory TarFile SystemFile ApplicationFile - ComputerFile
	  RemovableMedia - DigitizedInformationBearingEntity
	  USB Flash/SD CD/DVD - RemovableMedia)
  (:constants console - Service
	      guest - OnlineAccount)
  (:predicates
   (offersService - fact ?h - Host ?s - Service)
   ;; hasAccount is mostly a short way to write everything down in a 
   ;;  situation. group, accountExists, homeDirectory, and hasAccess
   ;;  are all implied by hasAccount.  See the first axiom below.
   (hasAccount ?h - Host ?uid - OnlineAccount ?gid - Group ?home - Directory)
   (group ?h - Host ?uid - OnlineAccount ?gid - Group)
   (accountExists ?h - Host ?uid - OnlineAccount)
   ;; Files
   (hasFile ?h - Host ?d - Directory ?s - Segment) ; ?s could be a subdir
   (found ?h - Host ?d - Directory ?f - ComputerFile ?s - object)
   (fileOwner ?h - Host ?dir - Directory ?ownership - object ?s - Segment)
   (hasAccess ?from - (or Host OnlineAccount) ?h - Host ?s - Segment)
   ;; Users
   (knowsPassword ?u - User ?h - Host ?uid - OnlineAccount)
   (hasShell ?user - User ?h - Host ?uid - OnlineAccount)
   ;;(hasPrivileges ?h - Host ?uid - OnlineAccount ?p - Privilege)
   )
  (:functions
   ;;(os - fact ?h - Host) - OperatingSystem
   (homeDirectory ?h - Host ?uid - OnlineAccount) - Directory
   (workingDirectory ?uid - OnlineAccount ?h - Host) - Directory)
  ;; basics just in case situation not completely specified
  (:axiom
   :vars (?user - User
	  ?host - Host
	  ?uid - OnlineAccount)
   :context (knowsPassword ?user ?host ?uid)
   :implies (accountExists ?host ?uid))
  (:axiom  
   :vars (?host - Host 
	  ?uid - OnlineAccount 
	  ?gid - Group
	  ?home - Directory)
   :context (hasAccount ?host ?uid ?gid ?home)
   :implies (and (accountExists ?host ?uid)
		 (group ?host ?uid ?gid)
		 (homeDirectory ?host ?uid ?home)
		 (hasAccess ?uid ?host ?home)) ; added 2/4/2016
   :documentation "tanslate hasAccess into what it implies")
  (:axiom				; this did not fire after above did
   :vars (?host - Host 
	  ?uid - OnlineAccount 
	  ?gid - Group
	  ?home - Directory)
   :context (homeDirectory ?host ?uid ?home)
   :implies (hasAccess ?uid ?host ?home)
   :documentation "is this so for windows?")
  (:axiom 
   :vars (?user - User 
	  ?host - Host 
	  ?uid  - OnlineAccount
	  ?home - (homeDirectory ?host ?uid))
   :context (hasShell ?user ?host ?uid)
   :implies (workingDirectory ?uid ?host ?home)
   :documentation "when you first login")
  (:axiom 
   :vars (?host - Host 
	  ?uid - OnlineAccount 
	  ?segment - Segment
	  ?dir - Directory)
   :context (fileOwner ?host ?dir ?uid ?segment)
   :implies (hasAccess ?uid ?host ?segment)
   :documentation "owner can hasAccess segments")
  ;;==establishing identity
  (:action login
     :parameters (?user - User 
		  ?host - Host 
		  ?uid  - OnlineAccount)
     :precondition (and (knowsPassword ?user ?host ?uid)
			;;(offersService ?host console)
			(not (hasShell ?user ?host ?uid)))
     :effect (hasShell ?user ?host ?uid))
  (:action logout
     :parameters (?host - Host
		  ?uid - OnlineAccount
		  ?user - User)
     :precondition (hasShell ?user ?host ?uid)
		;;	(offersService ?host console)) ; needed?
     :effect (not (hasShell ?user ?host ?uid))
     :documentation "only works on login shells")
  (:action exit
     :parameters (?user - User
		  ?host - Host
		  ?uid - OnlineAccount)
     :vars (?back-to - Host
	    ?old-uid - OnlineAccount)
     :precondition (and (hasShell ?user ?host ?uid)
			(hasShell ?user ?back-to ?old-uid)
			(not (= ?host ?back-to)))
     :effect (not (hasShell ?user ?host ?uid)))
  ;;==unix commands that are more general in reality

#| fix hasShell later.
(:action delete
     :parameters (?content - (either Host OnlineAccount wildcard)
		  ?host - Host 
		  ?uid - OnlineAccount
		  ?dir - directory 
		  ?file - ComputerFile )
    :precondition (and (found ?content ?host ?dir ?file)
		       (hasAccess ?uid ?host ?dir)
		       (shell ?uid ?host))	
    :effect (not (found ?content ?host ?dir ?file)))
  (:action root-delete
     :parameters (?content - (either Host Account wildcard)
		  ?host - Host 
		  ?root - Account
		  ?dir ?any - Directory 
		  ?file - ComputerFile )
     :precondition (and (found ?content ?host ?dir ?file)
			(hasAccount ?host ?root superuser ?any)
			(shell ?root ?host))	
    :effect (not (found ?content ?host ?dir ?file)))
  (:action cp
      :parameters (?h - Host 
		   ?source ?destination - Directory 
		   ?f - ComputerFile
		   ?uid - Account)
      :precondition (and (hasFile ?h ?source ?f)
			 (shell ?uid ?h)
			 (hasAccess ?uid ?h ?destination)
			 (not (= ?source ?destination)))
      :effect (hasFile ?h ?destination ?f))
  |#
    
    )

(define (action cd)
    :parameters (?uid  - Account
		 ?host - Host 
		 ?new - Directory)
    :vars (?user - User)
    :precondition (hasShell ?user ?host ?uid)
    :effect (workingDirectory ?uid ?host ?new)
    :comment "workingDirectory is an object fluent so it is not
              necessary to check precondition of some other WD")

;;; It is sometimes better to use functions in the :parameters
;;; instead of types when there are many possible bindings
;;; that can cause :precondition checking to go haywire.
;;; Below are some examples where knowledge of the problem
;;;  helps us avoid explosion.  
;;; Note that these functions should return lists.

(defun all-accounts (host)
  "return list of all known accounts on host"
  (loop for (predicate . arguments) in (situation-propositions (situation *problem*))
      if (and (samep predicate 'hasAccount)
	      (samep (first arguments) host))
      collect 
	(third arguments)))

(defun all-home-directories (host)
  "return list of all known accounts on host"
  (loop for (predicate . arguments) in (situation-propositions (situation *problem*))
      if (and (samep predicate 'hasAccount)
	      (samep (first arguments) host))
      collect 
	(last1 arguments)))
