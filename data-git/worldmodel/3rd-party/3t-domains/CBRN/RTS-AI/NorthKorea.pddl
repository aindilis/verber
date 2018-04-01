(in-package :ap)

(define (domain NorthKorea)
    (:extends nuclear_weapon)
  (:types Rodong - ShortRangeMissile
	  Taepodong-1 Musudan - MediumRangeMissile
	  Taepodong-2 KN-11 Scud - LongRangeMissile
	  KN-08 RoadMobileICBM - ICBM
	  SubmarineLaunchedCruiseMissile - CruiseMissile
	  )
  (:constants PRK - RogueState
	      Punggye-riNuclearTestSite - NuclearTestFacility
	      KiljuCounty Kusong Wonsan - County
	      NorthHamgyongProvince - StateOrProvince)
  (:init
   (hasAdversary PRK USA)
   ;;-geography
   (hasAccessTo PRK Punggye-riNuclearTestSite) ; not for long!
   (geographicSubregionOf Punggye-riNuclearTestSite KiljuCounty)
   (geographicSubregionOf KiljuCounty NorthHamgyongProvince)
   (geographicSubregionOf NorthHamgyongProvince PRK)
   ;;-missile stuff
   (maxEmploymentRange Musudan 2400)
   ;;-nuclear stuff
   (not (hasAccessTo PRK HydrocarbonFuel))
   (builtAndTested PRK ImplosionWeapon 4)
   (numTests PRK ImplosionWeapon 4)
   (numBuilt PRK ImplosionWeapon 6)
   (performR&D PRK NuclearWeapon)
   (possesses PRK HighlyEnrichedUranium)
   (possesses PRK ImplosionWeapon)
   (hasKnowledgeAbout PRK NuclearWeapon 3)
   )
  (:comment "steps to go: minituraize, build ICBM"))

(define (problem "PRK Nuke")
    (:domain NorthKorea)
  (:requirements :counterplanning)
  (:init (produce PRK ImplosionWeapon))
  (:goal (prepareForDelivery PRK ImplosionWeapon))
  (:comment "steps to go: minituraize, build ICBN"))
