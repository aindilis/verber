;; Persistence
(in-package :ap)
;;; CAPA domain definition

(define (domain cg)
    (:extends c2  exfiltration newAttack privilegeEscalation recon)  ;  credentialAccess persistence

    (:constants
	;;mocat - malware
	;;wce RAR - malware
	;;PSCP - software
	;;ssh - protocol
     fileName_vpn fileName_vpn32 - fileName
   )


	
 
)

;; Create Persistence by DLL Proxying

(define (action mv-rename)
      :parameters (?h - host 
		   ?source ?destination - directory 
		   ?f - file
		   ?fn1 ?fn2 - fileName
		   ?uid - account)
      :vars (?attacker - user)
      :precondition (and (hasFile ?h ?source ?f)
      		    	 (hasName ?f ?fn1)
			 (hasShell ?attacker ?h ?uid)
			 ;; (hasAccess ?uid ?h ?destination)  ;; need to use the new permissions stuff
			 (not (equal ?fn1 ?fn2)))
      :effect (and
      	   (hasFile ?h ?destination ?f)
	   (not (hasFile ?h ?source ?f))
	   (hasName ?f ?fn2)
	   (not (hasName ?f ?fn1))))

(define (action mv)
      :parameters (?h - host 
		   ?source ?destination - directory 
		   ?f - file
		   ?uid - account)
      :vars (?attacker - user)
      :precondition (and (hasFile ?h ?source ?f)
			 (hasShell ?attacker ?h ?uid)
			 (hasAccess ?uid ?h ?destination))
      :effect (and
      	   (hasFile ?h ?destination ?f)
	   (not (hasFile ?h ?source ?f))))

(define (action create_DLL_proxy)
        :parameters (?host - host
		     ?proxyDLL - malware 
		     ?originalDLL - file
		     ?malware - malware)
	:vars (?originalDLL_dir ?someDir1 ?someDir2 - directory
	       ?uid - account
	       ?fn1 ?fn2 - fileName
	       ?movedDLL - file)
	:precondition  (and
		(os ?host WINDOWS)
		(hasFile ?host ?someDir1 ?proxyDLL)  
		(hasFile ?host ?originalDLL_dir ?originalDLL)
		(hasName ?originalDLL ?fn1)
		(not (equal ?fn1 ?fn2))
		(not (equal ?movedDLL ?malware))
		(launches ?proxyDLL ?movedDLL)
		(launches ?proxyDLL ?malware))
	:expansion (series
			(hasFile ?host ?someDir2 ?malware)  
			(parallel
				(hasName ?originalDLL ?fn2)
	   			(not (hasName ?originalDLL ?fn1)))
			(parallel
				(hasFile ?host ?originalDLL_dir ?proxyDLL)
	   			(not (hasFile ?host ?someDir1 ?proxyDLL))))
	:effect
;;	     (and 
	      (hasDLLproxy ?host ?proxyDLL ?malware ?originalDLL))
;;		  (hasName ?movedDLL ?fn2)))
		
(define (action Persistence_by_DLL_Proxying)
 	:parameters (?attacker - user
	             ?host - host)
	:vars (?uid - account
	       ?dir1 ?dir2 ?originalDLL_dir - directory
	       ?originalDLL - file
	       ?malware ?proxyDLL - malware)
	:precondition  (and
		(os ?host WINDOWS)
		(hasShell ?attacker ?host ?uid)
		(hasFile ?host ?originalDLL_dir ?originalDLL)
		(not (equal ?dir1 ?originalDLL_dir))  ;; can't start out with original and proxy being in the same directory
		(not (equal ?proxyDLL ?originalDLL))  ;; all files must be different
		(not (equal ?malware ?originalDLL))
		(not (equal ?proxyDLL ?malware)))
	:expansion (series
		(hasFile ?host ?dir1 ?proxyDLL)
		(hasFile ?host ?dir2 ?malware)
		(hasDLLproxy ?host ?proxyDLL ?malware ?originalDLL ))
	:effect
		(hasPersistence ?attacker ?host))

(define (problem "CG3_1")
    (:domain cg)
  (:objects 
	    mm246 mm250  - host ; mm277 FM-EPO-DC VPS
	    operator1_2 - user
	    M_mkem unknown - account   ;; F_blake 
	    vpnapidll_o vpnapi32dll - file  
	    someDir syswow ciscoDir - directory
	    ktmdll vpnapidll_p - malware ;; ktmdll is mocat
	    )
  (:init
    (hasShell operator1_2 mm250 unknown) 
    (knowsPassword operator mm246 M_mkem)   
    (exploitInstalled ktmdll M_mkem mm246) ;; previously attained
    (os mm246 WINDOWS)
    (hasShell operator1_2 mm246 M_mkem)   ;; because mocat is installed
    (hasFile mm246 someDir vpnapidll_p)   ;; they got there somehow
    (hasFile mm246 ciscoDir vpnapidll_o)  ;; 
    (hasFile mm246 syswow ktmdll)     ;; ktmdll is mocat (need to make a connection between mocat object and ktmdll object)
    (launches vpnapidll_p ktmdll)
    (launches vpnapidll_p vpnapi32dll)
    (hasName vpnapidll_o fileName_vpn)
   )
  (:goal (and (hasName vpnapidll_o fileName_vpn32) (not (hasName vpnapidll_o fileName_vpn)))))
;;(hasDLLproxy mm246 vpnapidll_p ktmdll vpnapidll_o)))

;; (hasName vpnapidll_o fileName_vpn32))))  ;(hasPersistence operator1_2 mm246)))
