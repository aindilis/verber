(in-package :ap)

(define (domain network)
    (:extends computer)
  (:types Node Network NetworkDomain NetworkProtocol - Thing
	  SecureNetwork WirelessNetwork - Network
	  WiFi - WirelessNetwork
	  NetworkProtocol - Protocol
	  Firewall Router - Node
	  Hub - Router)
  (:constants ssh - Service
	      ftp tftp telnet - (and NetworkProtocol Service)
	      PPTP RDP - NetworkProtocol
	      known_Hosts - ComputerFile)
  (:predicates 
   (connected ?h1 ?h2 - Host)
   (part-of ?net - Network ?domain - NetworkDomain)
   (transmitted ?from ?to - Thing ?via - Protocol ?c - DigitizedInformationBearingEntity))
  (:action get
     :parameters (?host - Host
		  ?destination - Directory      
		  ?file - ComputerFile
		  ?uid - OnlineAccount)
     :vars (?remote - Host
	    ?source - Directory
	    ?user - User)
     :precondition (and (offersService ?host ftp)
			(hasShell ?user ?host ?uid)
			(offersService ?remote ftp)
			(hasFile ?remote ?source ?file)
			(not (= ?host ?remote)))
     :effect (and (hasFile ?host ?destination ?file)
		  (fileOwner ?host ?destination ?uid ?file)))
  (:action put
     :parameters (?host ?remote - Host
		  ?source ?destination - Directory      
		  ?file - ComputerFile
		  ?user - User
		  ?uid - OnlineAccount)
     :precondition (and (offersService ?host ftp)
			(hasShell ?user ?host ?uid)
			(offersService ?remote ftp)
			(hasFile ?host ?source ?file)
			(not (= ?host ?remote)))
     :effect (hasFile ?remote ?destination ?file))
  (:action tftp
     :parameters (?host ?target - Host
		  ?file - ComputerFile)
     :precondition (and (offersService ?target tftp)
			(connected ?host ?target)
			(not (= ?host ?target)))
     :effect (hasAccess ?host ?target ?file)
     :documentation "?target listening on UDP port 69")
  )

(inverseOf 'connected 'connected)
