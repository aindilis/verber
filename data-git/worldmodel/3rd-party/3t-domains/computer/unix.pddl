(in-package :ap)
;;; The unix domain defined herein is at the command processing level.
;;; That is, the actions represent unix commands, and the predicates
;;; express the goals and conditions that define the success of executing
;;; commands. 

(define (domain unix)
    (:extends computer network)
  (:types unixHost - Host 
	  unixOperatingSystem - OperatingSystem
	  LINUX - unixOperatingSystem
	  passwd-file log-file DotFile - ComputerFile)
  (:constants UNIX OSX - unixOperatingSystem
	      Ubuntu - LINUX
	      +wildcard+ - wildcard
              r-commands x11 - Service
	      root nobody - OnlineAccount
	      admin - Superuser
	      everyone - Group
	      hosts hosts.equiv rhosts - DotFile
	      passwd shadow - passwd-file
	      sharetab - ComputerFile
	      /tmp /etc /usr /home /pub /export / - Directory)
  (:axiom
   :vars (?h - unixHost)
   :implies (and (accountExists ?h root)
		 (group ?h root admin)
		 (accountExists ?h nobody)))   
  (:axiom
   :vars (?uid - OnlineAccount
	  ?host - unixHost)
   :context (group ?host ?uid admin)
   :implies (hasAccess ?uid ?host /etc))
  ;;==establishing hasShell as a OnlineAccount
  (:action rlogin
     :parameters (?uid - OnlineAccount 
		  ?host - Host
		  ?user - User)
     :vars (?home - (all-home-directories ?host) ; much faster than typing
	    ?local - Host
	    ?trusted-by - DotFile)
     :precondition (and (offersService ?host r-commands)
			(homeDirectory ?host ?uid ?home)
			(offersService ?local r-commands)
		        (hasShell ?user ?local ?uid)
			(found ?host ?home ?trusted-by ?local)
			(not (= ?host ?local)))
     :effect (hasShell ?user ?host ?uid)
     :documentation "User rhosts file compromised?")
  (:action rlogin-hosts.equiv-wildcard
     :parameters (?uid - OnlineAccount 
		  ?host - Host
		  ?user - User)
     :vars (?home - (all-home-directories ?host) ; much faster than typing
	    ?local - Host)
     :precondition (and (offersService ?host r-commands)
			(homeDirectory ?host ?uid ?home)
			(offersService ?local r-commands)
		        (hasShell ?user ?local ?uid)
			(found ?host /etc hosts.equiv +wildcard+)
			(not (= ?host ?local)))
     :effect (hasShell ?user ?host ?uid)
     :documentation "User rhosts file compromised?")
  (:action rlogin-trusted-wildcard
     :parameters (?uid - OnlineAccount 
		  ?host - Host
		  ?user - User)
     :vars (?home - (all-home-directories ?host) ; much faster than typing
	    ?local - Host
	    ?trusted-by - DotFile)
     :precondition (and (offersService ?host r-commands)
			(homeDirectory ?host ?uid ?home)
			(offersService ?local r-commands)
		        (hasShell ?user ?local ?uid)
			(found ?host ?home ?trusted-by +wildcard+)
			(not (= ?host ?local)))
     :effect (hasShell ?user ?host ?uid)
     :documentation "User rhosts file compromised?")
  (:action su
     :parameters (?user - User
		 ?host - Host 
		 ?uid - OnlineAccount)
     :vars (?current - OnlineAccount)
     :precondition (and (hasShell ?user ?host ?current)
			(group ?host ?current superuser)
			(not (= ?uid ?current)))
     :effect (hasShell ?user ?host ?uid)
     :documentation "always works for root")
  (:action su-password
    :parameters (?user - User
		 ?host - Host 
		 ?uid - OnlineAccount)
     :vars (?current - OnlineAccount)
     :precondition (and (hasShell ?user ?host ?current)
			(knowsPassword ?user ?host ?uid)
			(not (= ?uid ?current)))
     :effect (hasShell ?user ?host ?uid)
     :documentation "user knows password")
  (:action mount
    :parameters (?host ?source-host - unixHost 
		 ?dir - Directory)
    :vars (?user - User
	   ?root - OnlineAccount)
    :precondition (and (found ?source-host /etc sharetab ?dir)
		       (hasShell ?user ?host ?root)
		       ;;(hasAccount ?host ?root superuser /)
		       (group ?host ?root superuser)
		       )
    :effect (hasAccess ?host ?source-host ?dir))
  ;;==file creation
  (:action mkdir
     :parameters (?user - User
		  ?host - Host
		  ?dir - Directory)
     :vars (?uid - OnlineAccount
	    ?working - Directory)
     :precondition (and (hasShell ?user ?host ?uid)
			(workingDirectory ?uid ?host ?working))
     :effect (and (hasFile ?host ?working ?dir)
		  (fileOwner ?host ?working ?uid ?dir)))
  (:action rm
      :parameters (?host - Host 
		   ?dir - Directory 
		   ?file - ComputerFile)
      :vars (?uid - OnlineAccount
	     ?user - User)
      :precondition (and (hasFile ?host ?dir ?file)
			 (hasShell ?user ?host ?uid)
			 ;(fileOwner ?host ?dir ?uid ?subdir)
			 (or (hasAccess ?uid ?host ?dir)
			     (hasAccount ?host ?uid superuser /)))
      :effect (not (hasFile ?host ?dir ?file)))
  ;;==shell commands
  (:action rsh
   :parameters (?host - unixHost 
		?user - User
		?uid - OnlineAccount)
;;     :constraints (or (instance ?exposed-to 'wildcard)
   ;;		      (eql ?exposed-to ?local))
   :vars (?local - Host
	  ?home - (all-home-directories ?host)
	  ?exposed-to - (either wildcard Host))
   :precondition (and (offersService ?host r-commands)
		      (hasShell ?user ?local ?uid)
		      (hasAccount ?uid ?host :ignore ?home)
		      (found ?host /etc hosts.equiv ?exposed-to)
		      (= ?exposed-to ?local) ; makes no sense!
		      (not (= ?host ?local)))
   :execute (run-unix-program 'exec("/bin/sh") :args ?uid)
   :effect (and (hasShell ?user ?host ?uid)
		(workingDirectory ?uid ?host ?home))
   :comment "the :execute line is a demo")
  (:action tar-xvf
     :parameters (?tool - ComputerFile	 
		  ?host - Host
		  ?dir - Directory)
     :vars (?tarfile - TarFile
	    ?from - Host
	    ?uid - OnlineAccount
	    ?user - User
	    ?source-dir - Directory)
     :precondition (and (hasFile ?host ?dir ?tarfile)
			(found ?from ?source-dir ?tarfile ?tool)
			(hasShell ?user ?host ?uid))
     :effect (hasFile ?host ?dir ?tool))
  (:action echo
      :parameters (?host - Host 
		   ?dir - Directory 
		   ?file - ComputerFile
		   ?content - object) ;;(either Host Account wildcard))
      :vars (?uid - OnlineAccount
	     ?user - User)	  
      :precondition (and (hasFile ?host ?dir ?file)
			 (hasShell ?user ?host ?uid)
			 (hasAccess ?uid ?host ?dir))
      :effect (found ?host ?dir ?file ?content))
  (:action echo-remote
      :parameters (?host - Host 
		   ?dir - Directory 
		   ?file - ComputerFile
		   ?content - object) ;;(either Host OnlineAccount wildcard))
      :vars (?remote-host - Host 
	     ?uid - OnlineAccount
	     ?user - User)	  
      :precondition (and (hasFile ?host ?dir ?file)
			 (hasShell ?user ?remote-host ?uid)
			 ;;(hasAccess ?remote-host ?host ?dir);; is this correct?
			 (hasAccess ?uid ?host ?dir)
			 (not (= ?host ?remote-host)))
      :effect (found ?host ?dir ?file ?content))
  (:action create-Account-remote
    :parameters (?host - unixHost
		 ?uid ?new-id - OnlineAccount
		 ?gid - Group
		 ?home - Directory
		 ?user - User)
    :vars (?current-host - Host)
    :precondition (and (hasAccess ?uid ?host /etc)
		       (hasShell ?user ?current-host ?uid)
		       (not (= ?current-host ?host)))
    :expansion (sequential
		(hasShell ?user ?host ?uid) ; rsh
		(parallel
		 (found ?host /etc passwd ?new-id)
		 (found ?host /etc shadow ?new-id))
		(not (hasShell ?user ?host ?uid)))
    :effect (and (hasAccount ?host ?new-id ?gid ?home)
		 (knowsPassword ?user ?host ?new-id))
    :documentation "assumes rsh")
  (:action "create Account"
    :parameters (?host - unixHost
		 ?new-id - OnlineAccount
		 ?gid - Group
		 ?home - Directory
		 ?user - User)
    :vars (?uid - OnlineAccount)
    :precondition (and (hasAccess ?uid ?host /etc)
		       (hasShell ?user ?host ?uid))
    :expansion (parallel
		(found ?host /etc passwd ?new-id)
		(found ?host /etc shadow ?new-id))
    :effect (and (hasAccount ?host ?new-id ?gid ?home)
		 (knowsPassword ?user ?host ?new-id))
    :documentation "generally have to be root")
  )

