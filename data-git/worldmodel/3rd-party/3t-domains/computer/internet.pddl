(in-package :ap)

(define (domain internet)
    (:extends network computer communication)
  (:types "Email Protocol" "Secure Protocol" "URI Scheme" - NetworkProtocol
	  SecureURIScheme - (and SecureProtocol URIScheme)
	  EmailAddress Webpage MessageContent - DigitizedInformationBearingEntity
	  EmailAddress - MessageContent
	  webform - Webpage
	  "Web Email Service" "Web Forum" - Website
	  SocialNetwork - (and WebForum Resource)
	  CloudService - (and Website Host Resource))
  (:predicates
   (msg_response - fact ?in ?back - DigitizedInformationBearingEntity)) ; what to expect back from given input
  (:constants icmp - Protocol
	      SMTP POP IMAP - EmailProtocol
	      http - URIScheme
	      https - SecureURIScheme
	      eft - SecureProtocol
	      hotmail gmail yahoo.com - WebEmailService
	      Facebook Twitter - SocialNetwork
	      iCloud GoogleApps Egnyte OpenDrive DropBox AmazonCloudDrive
	      MicrosoftCloud - CloudService
	      memberAcctForm - webform
	      noContent - MessageContent)
  (:axiom
   :vars (?a - Agent
	  ?site - Website)
   :context (memberOf ?a ?site)
   :implies (hasAccessTo ?a ?site))
  (:axiom
   :vars (?from ?to - Thing
	  ?via - (or Protocol Network)
	  ?content - DigitizedInformationBearingEntity)
   :context (transmitted ?from ?to ?via ?content)
   :implies (send ?from ?to ?content))
  )

(define (action "Register At Site")
    :parameters (?a - Agent
		 ?site - Website)
    :precondition  (not (memberOf ?a ?site))
    :expansion (series
		(transmitted ?a ?site https memberAcctForm)
		(transmitted ?site ?a https memberAcctForm))
    :effect (memberOf ?a ?site))

;;;--- transmitted ---

(define (action "Transfer Information")
    :domain internet
    :subClassOf CommunicateElectronically
    :parameters (?from ?to - Thing
		 ?via - (or Protocol Network)
		 ?content - DigitizedInformationBearingEntity)
    :precondition (and (not (instance ?via EmailProtocol))
		       (not (instance ?via URIScheme)))
    :effect (transmitted ?from ?to ?via ?content)
    :comment "very general, specifics below")

(define (action "http Display")
    :subClassOf Transmit
    :parameters (?website - Website
		 ?user - Agent
		 ?s - URIScheme
		 ?webpage - Webpage)
    :effect (transmitted ?website ?user ?s ?webpage)
    :documentation "Website serves page to user")

(define (action cgi_enter)
    :subClassOf Transmit
    :parameters (?user - Agent
		 ?website - Website
		 ?s - URIScheme
		 ?webform - webform)
    :effect (transmitted ?user ?website ?s ?webform)
    :documentation "user stupid if ?s not HTTPS")

#| this and httpDisplay work when :assumptions 3/31/2016
(define (action serve_page)
    :subClassOf Transmit
    :parameters (?content - Webpage
		 ?site - Website
		 ?user - Agent
		 ?s - URIScheme)
    :vars (?req - Webpage)
    :precondition (and (msg_response ?req ?content)
		       (transmitted ?user ?site ?s ?req))
    :effect (transmitted ?site ?user ?s ?content))
|#

(define (action Email)
    :parameters (?content - MessageContent
		 ?p - EmailProtocol
		 ?from ?to - EmailAccount)
    :effect (transmitted ?from ?to ?p ?content)
    :comment "you can send email to yourself")

#|
(define (action "Email Reply")
    :subClassOf Email
    :parameters (?content - MessageContent
		 ?p - EmailProtocol	  
		 ?site - Website
		 ?user - EmailAccount)
    :vars (?req - DigitizedInformationBearingEntity
	   ?s - URIScheme)
    :precondition (and (msg_response ?req ?content)
		       (transmitted ?user ?site ?s ?req))
    :effect (transmitted ?site ?user ?p ?content))
|#
