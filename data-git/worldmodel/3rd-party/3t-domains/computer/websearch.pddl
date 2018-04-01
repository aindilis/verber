(in-package :ap)

(define (domain websearch)
    (:extends internet)		; physob for possesses
  (:requirements :multi-agent)		; for Resources
  (:types
   "Search Engine" - (and Website Resource)
   "Research Website" - (and Website Resource))
  (:constants
   google.com bing.com - SearchEngine
   wikipedia.org - ResearchWebsite)
  (:predicates
   (knowsAbout ?a - Agent ?topic - Entity) ; moved here from communication.pddl 2016-01-15
   (sourceIdentified ?a - Agent ?via - SearchEngine ?topic - InformationContentEntity)
   (obtainInformation ?a - Agent ?source - Website ?topic - InformationContentEntity))
  )

(define (action "Web Research")
    :subClassOf Investigate
    :label ("Search Web for" ?topic)
    :parameters (?a - Agent
		 ?topic - Thing)
    :vars (?se - SearchEngine
	   ?site - ResearchWebsite)	; wikipedia, for example
    :expansion (series
		(link (sourceIdentified ?a ?se ?topic) :input ?site)
		(link (obtainInformation ?a ?site ?topic) :input ?se))
    :effect (knowsAbout ?a ?topic))

(define (action Google)
    :subClassOf Search
    :label ("Google" ?topic)
    :parameters (?a - Agent
		 ?se - SearchEngine
		 ?topic - Thing)
    :vars (?site - Website)
    :value ?site
    :precondition (and (containsInformation ?site ?topic)
		       (not (instance ?site WebEmailService))
		       (not (instance ?site SearchEngine))
		       (not (= ?site ?se)))
    :effect (sourceIdentified ?a ?se ?topic)
    :probability 0.9
    :duration 0.25			; hours
    :comment "identify Website that appears to have topic info")

(define (action "Site Search")
    :subClassOf Gather
    :label ("Search" ?site "for" ?topic)
    :parameters (?a - Agent
		 ?site - Website
		 ?topic - Thing)
    :vars (?se - SearchEngine)
    :value ?se
    :precondition (and (containsInformation ?site ?topic)
		       (sourceIdentified ?a ?se ?topic)
		       (not (instance ?site SearchEngine))
		       (not (= ?se ?site)))
    :effect (obtainInformation ?a ?site ?topic)
    :duration 0.5			; hours
    :probability 0.85)
