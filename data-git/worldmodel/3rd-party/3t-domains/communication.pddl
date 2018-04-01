(in-package :ap)

(define (domain communication)
    (:extends event)
  (:predicates
   (contact ?from ?to - Agent)
   (send ?from ?to - Agent ?info - InformationBearingEntity))
  )

(define (action Contact)
    :subClassOf Communicate
    :parameters (?from ?to - Agent)
    :effect (contact ?from ?to)
    :duration 1.0
    :probability 0.9
    :label (?from "contact" ?to)
    :documentation "call, email, write, visit")

(define (action Transmit)
    :subClassOf Send
    :effect (send ?from ?to ?info)
    :label (?from "send" ?info "to" ?to)
    :comment "specialize for email, snail mail, FAX")