;; privilege escalation
(in-package :ap)
;;; CAPA domain definition

(define (domain privilege_escalation )
    (:extends hacker)
  (:constants SUPERUSER - Privilege))

;; Row 2
;; Exploitation of vulnerability

;; Row 3
;; Service file permissions weakness
;; based on similar action from persistence.pddl, row 3

(define (action privilege_escalation_via_Existing_Service)
    :parameters (?attacker - User
	         ?host - Host
		 ?level - Privilege)
    :vars (?uid - Account
	   ?file - File
	   ?dir - Directory
	   ?malware - Malware)				 
	:precondition (and
		(hasShell ?attacker ?host ?uid)
		(hasFile ?host ?dir ?file)
		(is_service_executable_file ?host ?file)
		(hasPrivileges ?host ?file ?level))
	:expansion (series
		(exploitInstalled ?malware ?uid ?host)
		(fileChanged ?file ?malware ?uid ?host))
	:effect
		(hasPrivileges ?host ?attacker ?level))
		
;; Row 4
;; Service registry permissions weakness

(define (action privilege_escalation_via_registry_paths)
	:parameters (?attacker - User
	             ?host - Host
		     ?level - Privilege)
	:vars (?uid - Account
	       ?file - File
	       ?dir - Directory
	       ?key - string
	       ?malware - Malware)				 
	:precondition (and
		(os ?host WINDOWS)
		(hasShell ?attacker ?host ?uid)
		(hasFile ?host ?dir ?file)
		(is_service_executable_file ?host ?file)
		(hasPrivileges ?host ?file ?level))
	:expansion (series
		(exploitInstalled ?malware ?uid ?host)
		(registryChanged ?key ImagePath ?malware ?uid ?host))
	:effect
		(hasPrivileges ?host ?attacker ?level))

;; Row 5
;; DLL path hijacking
;; also via .manifest/.local file

(define (action privilege_escalation_via_PATH_variable)
	:parameters (?attacker - User
	             ?host - Host
		     ?level - Privilege)
	:vars (?uid - Account
	       ?oldValue ?newValue - string
	       ?dir - Directory
	       ?software - software
	       ?dll - File)
	:precondition (and
		(hasShell ?attacker ?host ?uid)
		(envir_var_changed PATH ?host ?uid ?oldValue ?newValue)
		(hasFile ?host ?dir ?dll)
		(malware-category INFECTED_DLL ?dll)
		(containsSubstring ?dir ?newValue)
		(launches ?software ?dll)
		(hasPrivileges ?host ?software ?level))
	:effect
		(hasPrivileges ?host ?attacker ?level))

;; Row 6
;; Path interception
;; based on similar action from persistence.pddl, row 7

;;(define (action privilege_escalation_via_program.exe)
;;	:parameters (?attacker - User
;;	             ?host - Host
;;		     ?level - Privilege)
;;	:vars (?file_with_flaw - File
;;	       ?dir - Directory)
;;	:precondition (and 
;;		(os ?host WINDOWS)
;;		(hasPrivileges ?host ?file_with_flaw ?level))
;;	:expansion (series
;;		(hasFile ?host "C:/" "program.exe")
;;		(hasFile ?host ?dir ?file_with_flaw)
;;		(contains_string "C:/program " ?file_with_flaw))
;;	:effect
;;		(hasPrivileges ?host ?attacker ?level))

;; Row 7
;; Modification of shortcuts
;; based on similar action from persistence.pddl, row 9
;; similar action can be created for symbolic links, see persistence.pddl

(define (action privilege_escalation_via_link)
	:parameters (?attacker - User
	             ?host - Host
		     ?level - ?privilege)
	:vars (?shortcut - object  ;; what type should this really be?
		   ?dir - Directory
		   ?malware - Malware
		   ?cat - Malware-cat
		   ?uid - Account)
	:precondition (and
		(os ?host WINDOWS)
		(hasFile ?host ?dir ?shortcut)
		(isShortcut ?host ?shortcut)
		(launches ?shortcut ?malware)   ;; running ?shortcut causes ?malware to run
		(malware-category ?cat ?malware)
		(hasPrivileges ?host ?shortcut ?level))
	:expansion (series
		(exploitInstalled ?malware ?uid ?host))
	:effect
		(hasPrivileges ?host ?attacker ?level))
		
;; Row 8
;; Editing of default handlers

;; Row 9
;; AT / Schtasks / Cron
;; based on similar action from persistence.pddl, row 9
;; similar action can be created for windows based schedulers, see persistence.pddl

(define (action privilege_escalation_via_cron)
	:parameters (?attacker - User
	             ?host - Host)
	:vars (?cronjob - object  ;; what type should this really be?
		   ?malware - Malware
		   ?cat - Malware-cat
		   ?uid - Account)
	:precondition (and
		(os ?host UNIX)	
		(launches ?cronjob ?malware)    
		(malware-category ?cat ?malware))
	:expansion (series
		(exploitDelivered ?host ?uid ?cronjob)
		(exploitDelivered ?host ?uid ?malware)
		(cronjob_enabled ?host ?cronjob))
	:effect
		(hasPrivileges ?host ?attacker SUPERUSER))
