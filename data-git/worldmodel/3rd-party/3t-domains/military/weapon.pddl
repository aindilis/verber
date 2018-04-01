(in-package :ap)

(define (domain weapon)
    (:comment "created 2016-05-13 from weapon_ont.owl")
  (:extends manufacturing)
;; imports isxbase.owl isxartifactont.owl not found
  (:prefix "isxweaponont.owl")
  (:uri "http://ontologies.isx.com/onts/dione/2004/09/isxweaponont.owl#")
  (:types
   WeaponComponent Weapon - Artifact
   Fuze ImprovisedWeaponComponent Payload Primer TargeetingSystem
   WeaponGuidance Detonator Rocket - WeaponComponent
   TimedFuze SensorFuze - Fuze
   WeaponOfMassDestruction - Weapon
   RadiologicalWeapon ChemicalWeapon BiologicalWeapon - WeaponOfMassDestruction
   ProjectileLaunchingWeapon EdgedWeapon - Weapon
   Gun ArtilleryPiece - ProjectileLaunchingWeapon
   Firearm - Gun
   Smallarm - Firearm
   Handgun Rifle Shotgun - Smallarm
   Missile GrenadeLauncher MissileLauncher - ProjectileLaunchingWeapon
   CruiseMissile BallisticMissile - Missile
   ShortRangeMissile MediumRangeMissile LongRangeMissile - BallisticMissile
   ICBM - LongRangeMissile
   MissileDefenseSystem - MissileLauncher
   ExplosiveWeapon ProjectileWeapon - Weapon
   Grenade Bomb MolotovCocktail LandMine - ExplosiveWeapon
   NuclearWeapon - (and WeaponOfMassDestruction ExplosiveWeapon)
   ImplosionWeapon GunTypeWeapon - NuclearWeapon ; added 6/30/2016 CE
   IED - (and Bomb LandMine)
   RocketPropelledGrenade - (and GrenadeLauncher Grenade)
   Arrow Bullet - ProjectileWeapon
   ArtilleryShell - (and ExplosiveWeapon ProjectileWeapon)
   MedicalDrug Radioisotope ChemicalCompound Antidote - PhysicalEntity)
  (:predicates
    (hasPayload ?d ?r - Thing)
    (hasWeaponComponent - hasPart ?d - Weapon ?r - WeaponComponent)
    (developedBy ?d ?r - Thing)
    (hasPrimer ?d ?r - Thing)
    (launchesProjectile - fact ?d - Weapon ?r - Thing)
    (agentChemical ?d ?r - Thing)
    (hasDetonator ?d ?r - Thing)
    (hasAntidote - fact ?d - BiologicalWeapon ?r - Thing)
    (hasRadioisotope - fact ?d ?r - Thing)
    (hasMedicalTreatment - fact ?d - BiologicalWeapon ?r - Thing)
    (weaponDeliveryMeans - fact ?d - Weapon ?r - Thing)
    (borneByVehicle ?d ?r - Thing)
    (hasVaccine - fact ?d - BiologicalWeapon ?r - Thing)
    (biologicalAgentType - fact ?d - BiologicalWeapon ?r - Thing)
    (infectionVector - fact ?d - BiologicalWeapon ?r - Thing)
    (infectionSymptom - fact ?d - BiologicalWeapon ?r - Thing)
    (chemicalAgentType - fact ?d - ChemicalWeapon ?r - ChemicalMaterial)
    (actuationMeans ?d ?r - Thing))
  (:functions
    (optimalEmploymentRange ?d - Weapon)
    (maxEmploymentRange - fact ?d - Weapon)
    (minEmploymentRange - fact ?d - Weapon)
    (projectileCaliber - fact ?d - ProjectileLaunchingWeapon)
    (explosiveSubstanceQuantity ?d - ExplosiveWeapon)
    (effectiveExplosiveYield ?d - ExplosiveWeapon)
    (shrapnelSubstanceQuantity ?d - ExplosiveWeapon)
    (chemicalAgentQuantity ?d - Thing)
    (biologicalAgentQuantity ?d - BiologicalWeapon)
    ;; range is number unless specified
    (shrapnelSubstanceType - fact ?d - ExplosiveWeapon) - Thing
    (explosiveSubstanceType - fact ?d - ExplosiveWeapon) - Thing))

