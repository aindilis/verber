(in-package :ap)

(define (domain time)
    (:comment "OWL-Time")
  (:extends owl)
  (:prefix "time")
  (:uri "http://www.w3.org/2006/time#")
  (:types TemporalEntity - Thing
	  Instant Interval - TemporalEntity
	  ProperInterval - Interval
	  DateTimeInterval - ProperInterval
	  DurationDescription DateTimeDescription TemporalUnit DayOfWeek - TemporalEntity
	  TemporalUnit - Collection
	  )
  (:predicates
   (before ?te1 ?te2 - TemporalEntity)
   (after ?te1 ?te2 - TemporalEntity)
   (inside ?i1 - Interval ?i2 - Instant) ; seems backwards
   (intervalEquals ?pi1 ?pi2 - ProperInterval)
   (intervalBefore ?pi1 ?pi2 - ProperInterval)
   (intervalMeets ?pi1 ?pi2 - ProperInterval)
   (intervalOverlaps ?pi1 ?pi2 - ProperInterval)
   (intervalStarts ?pi1 ?pi2 - ProperInterval)
   (intervalDuring ?pi1 ?pi2 - ProperInterval)
   (intervalFinishes ?pi1 ?pi2 - ProperInterval)
   (intervalAfter ?pi1 ?pi2 - ProperInterval)
   (intervalMetBy ?pi1 ?pi2 - ProperInterval)
   (intervalOverlappedBy ?pi1 ?pi2 - ProperInterval)
   (intervalStartedBy ?pi1 ?pi2 - ProperInterval)
   (intervalContains ?pi1 ?pi2 - ProperInterval)
   (intervalFinishedBy ?pi1 ?pi2 - ProperInterval)
   )
  (:functions
   (hasBeginning ?te - TemporalEntity) - Instant
   (hasEnd ?te - TemporalEntity) - Instant
   )
  )

#| add these later 6/2/2016
years
DurationDescription
xsd;decimal

months
DurationDescription
xsd;decimal

weeks
DurationDescription
xsd;decimal

days
DurationDescription
xsd;decimal

hours
DurationDescription
xsd;decimal

minutes
DurationDescription
xsd;decimal

seconds
DurationDescription
xsd;decimal

hasDurationDescription
TemporalEntity
DurationDescription

unitType
DateTimeDescription
TemporalUnit

year
DateTimeDescription
xsd;gYear

month
DateTimeDescription
xsd;gMonth

week
DateTimeDescription
xsd;nonNegativeInteger

day
DateTimeDescription
xsd;gDay

dayOfWeek
DateTimeDescription
DayOfWeek

dayOfYear
DateTimeDescription
xsd;nonNegativeInteger

hour
DateTimeDescription
xsd;nonNegativeInteger

minute
DateTimeDescription
xsd;nonNegativeInteger

second
DateTimeDescription
xsd;decimal

timeZone
DateTimeDescription
tzont;TimeZone

inDateTime
Instant
DateTimeDescription

inXSDDateTime
Instant
xsd;dateTime

hasDateTimeDescription
DateTimeInterval
DateTimeDescription

xsdDateTime
DateTimeInterval
xsd					;dateTime
|#