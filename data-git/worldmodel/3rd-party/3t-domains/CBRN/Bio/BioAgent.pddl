(in-package :ap)

(define (domain BioAgent)
  (:imports CBRNEMatEquip CBRNEChemical)
  (:prefix "BioAgent")
  (:uri "http://agent.jhuapl.edu/2010/07/02/bio/BioAgent#")
  (:types   
   BioAgentRelatedEntity - PhysicalEntity
   ToxinState AnimalNoise - BioAgentRelatedEntity
   FormOfBotulinumToxin ToxinMilled - ToxinState
   MilledBotulinumToxin - (and FormOfBotulinumToxin ToxinMilled)
   ToxinIsolate - ToxinState
   BotulinumToxinIsolate - (and ToxinIsolate FormOfBotulinumToxin)
   BotulinumToxinPellet BotulinumToxinPrecipitate BotulinumToxinSupernatant
   BotulinumToxinFiltrate - BotulinumToxinIsolate
   ToxinFluidized - ToxinState
   FluidizedBotulinumToxin - (and ToxinFluidized FormOfBotulinumToxin)
   ToxinFrozen - ToxinState
   FrozenBotulinumToxin - (and ToxinFrozen FormOfBotulinumToxin)
   ToxinDried - ToxinState
   DriedBotulinumToxin - (and ToxinDried FormOfBotulinumToxin)
   BiologicalAgentExposureIndicator BiologicalAgentExposureTreatment - BioAgentRelatedEntity
   DeadMice - BiologicalAgentExposureIndicator
   BioterrorismHazardCategory - BioAgentRelatedEntity
   CDCBioterrorismAgentOrDiseases - BioterrorismHazardCategory
   CDCCategoryA CDCCategoryB CDCCategoryC - CDCBioterrorismAgentOrDiseases
   BiologicalAgentSourceMaterialSource - BioAgentRelatedEntity
   BacillusAnthracisSourceFacility VeterinaryFacility ClostridiumBotulinumSourceFacility - BiologicalAgentSourceMaterialSource
   Slaughterhouse Tannery Farm
   WoolMill - BacillusAnthracisSourceFacility
   BiologicalResourceCenter Hospital - BiologicalAgentSourceMaterialSource
   BiologicalExtractionKit - BioAgentRelatedEntity
   RNAExtractionKit ProteinExtractionKit DNAExtractionKit - BiologicalExtractionKit
   MicroorganismState - BioAgentRelatedEntity
   ViralState - MicroorganismState
   FormOfMarburgVirus - ViralState
   MicroorganismIsolate MicroorganismViralCulture - MicroorganismState
   MarburgVirusIsolate - (and FormOfMarburgVirus MicroorganismIsolate)
   MarburgVirusFiltrate MarburgVirusSupernatant - MarburgVirusIsolate
   MicroorganismDried MicroorganismColony - MicroorganismState
   DriedMarburgVirus - (and FormOfMarburgVirus MicroorganismDried)
   MicroorganismFluidized - MicroorganismState
   FluidizedMarburgVirus - (and FormOfMarburgVirus MicroorganismFluidized)
   MicroorganismPlaque - MicroorganismState
   MarburgVirusPlaque - (and MicroorganismPlaque FormOfMarburgVirus)
   BacterialState MicroorganismSpore - MicroorganismState
   FormOfClostridiumBotulinum - BacterialState
   ClostridiumBotulinumColony - (and FormOfClostridiumBotulinum MicroorganismColony)
   ClostridiumBotulinumIsolate - (and FormOfClostridiumBotulinum MicroorganismIsolate)
   ClostridiumBotulinumSupernatant ClostridiumBotulinumPellet ClostridiumBotulinumFiltrate - ClostridiumBotulinumIsolate
   ClostridiumBotulinumSpore - (and MicroorganismSpore FormOfClostridiumBotulinum)
   FormOfYersiniaPestis - BacterialState
   FluidizedYersiniaPestis - (and MicroorganismFluidized FormOfYersiniaPestis)
   DriedYersiniaPestis - (and MicroorganismDried FormOfYersiniaPestis)
   YersiniaPestisColony - (and FormOfYersiniaPestis MicroorganismColony)
   YersiniaPestisIsolate - (and FormOfYersiniaPestis MicroorganismIsolate)
   YersiniaPestisSupernatant YersiniaPestisPellet YersiniaPestisFiltrate - YersiniaPestisIsolate
   FormOfBacillusAnthracis - BacterialState
   BacillusAnthracisSpore - (and MicroorganismSpore FormOfBacillusAnthracis)
   BacillusAnthracisColony - (and FormOfBacillusAnthracis MicroorganismColony)
   FluidizedBacillusAnthracisSpore - (and MicroorganismFluidized FormOfBacillusAnthracis)
   DriedBacillusAnthracis - (and FormOfBacillusAnthracis MicroorganismDried)
   BacillusAnthracisIsolate - (and FormOfBacillusAnthracis MicroorganismIsolate)
   BacillusAnthracisSupernatant BacillusAnthracisFiltrate BacillusAnthracisPellet - BacillusAnthracisIsolate
   MicroorganismMilled - MicroorganismState
   MilledClostridiumBotulinum - (and MicroorganismMilled FormOfClostridiumBotulinum)
   MilledBacillusAnthracis - (and MicroorganismMilled FormOfBacillusAnthracis)
   MilledYersiniaPestis - (and MicroorganismMilled FormOfYersiniaPestis)
   MilledMarburgVirus - (and MicroorganismMilled FormOfMarburgVirus)
   MicroorganismCulture - MicroorganismState
   BacillusAnthracisCulture - (and MicroorganismCulture FormOfBacillusAnthracis)
   ClostridiumBotulinumCulture - (and MicroorganismCulture FormOfClostridiumBotulinum)
   MarburgViralCulture - (and MicroorganismCulture FormOfMarburgVirus MicroorganismViralCulture)
   YersiniaPestisCulture - (and MicroorganismCulture FormOfYersiniaPestis)
   MicroorganismLiquidCulture - MicroorganismState
   BacillusAnthracisLiquidCulture - (and MicroorganismLiquidCulture FormOfBacillusAnthracis)
   ClostridiumBotulinumLiquidCulture - (and MicroorganismLiquidCulture FormOfClostridiumBotulinum)
   YersiniaPestisLiquidCulture - (and MicroorganismLiquidCulture FormOfYersiniaPestis)
   MicroorganismSolidCulture - MicroorganismState
   BacillusAnthracisSolidCulture - (and MicroorganismSolidCulture FormOfBacillusAnthracis)
   YersiniaPestisSolidCulture - (and MicroorganismSolidCulture FormOfYersiniaPestis)
   ClostridiumBotulinumSolidCulture - (and MicroorganismSolidCulture FormOfClostridiumBotulinum)
   MicroorganismStock - MicroorganismState
   MarburgVirusStock - (and MicroorganismStock FormOfMarburgVirus)
   MicroorganismFrozen - MicroorganismState
   FrozenYersiniaPestis - (and MicroorganismFrozen FormOfYersiniaPestis)
   FrozenBacillusAnthracis - (and MicroorganismFrozen FormOfBacillusAnthracis)
   FrozenMarburgVirus - (and MicroorganismFrozen FormOfMarburgVirus)
   FrozenClostridiumBotulinum - (and MicroorganismFrozen FormOfClostridiumBotulinum)
   MicroorganismEggExtract - MicroorganismState
   MarburgVirusEggExtract - (and MicroorganismEggExtract FormOfMarburgVirus)
   BiologicalReferenceMaterial - BioAgentRelatedEntity
   BiologicalEquipmentManufactureInstructions MicrobiologyTextbook ClostridiumBotulinumReferencePicture
   StainingInstructions BacillusAnthracisReferencePicture - BiologicalReferenceMaterial
   TestAnimal - BioAgentRelatedEntity
   LiveMice - TestAnimal
   BWARelatedSubstance - BioAgentRelatedEntity
   TargetOrganismNucleicAcid - BWARelatedSubstance
   YersiniaPestisNucleicAcid ClostridiumBotulinumDNA BacillusAnthracisDNA - TargetOrganismNucleicAcid
   CellDissociation - BWARelatedSubstance
   ManualCellDissociationMaterial - CellDissociation
   CellScraper - ManualCellDissociationMaterial
   ChemicalCellDissociationMaterial - CellDissociation
   CellStripper - ChemicalCellDissociationMaterial
   PCRChemicalComponent - BWARelatedSubstance
   PCRProbe - PCRChemicalComponent
   BacillusAnthracisProbe ClostridiumBotulinumProbe - PCRProbe
   PCRPrimer MasterMix - PCRChemicalComponent
   ReversePCRPrimer ClostridiumBotulinumPrimer BacillusAnthracisPrimer
   ForwardPCRPrimer - PCRPrimer
   dNTP - PCRChemicalComponent
   PCRBuffer - (and Buffer PCRChemicalComponent)
   WaterForBiologicalProcessing - BWARelatedSubstance
   DistilledWater DeionizedWater DEPCTreatedWater
   SterileWater MBGWater - WaterForBiologicalProcessing
   CellLine - BWARelatedSubstance
   MarburgVirusCellLine - CellLine
   MarburgVirusAdherentCellLine Vero76 MarburgVirusSuspensionCellLine - MarburgVirusCellLine
   EbolaCellLine - CellLine
   Vero - (and EbolaCellLine MarburgVirusCellLine)
   R06E - (and EbolaCellLine MarburgVirusCellLine)
   FetalRhesusLung R05R - EbolaCellLine
   VeroE6 - (and EbolaCellLine MarburgVirusCellLine)
   SW13 _293T R05T - EbolaCellLine
   GrowthMedium - BWARelatedSubstance
   SelectiveMedium SolidGrowthMedium DifferentialMedium - GrowthMedium
   EnrichmentMedium - SelectiveMedium
   ViralTransportMedium - GrowthMedium
   Virocult HHMedium RichardsViralTransport
   BartelsViralTransport - ViralTransportMedium
   CellCultureMedium - (and GrowthMedium ViralTransportMedium)
   BasalCellCultureMedium CompleteCellCultureMedium - CellCultureMedium
   RPMI1640 F-12 F-10
   L-15Medium DMEM McCoy5A
   BME MEM RPMI1630
   LactalbuminHydrolysateMedium Medium199 RPMI1634 - BasalCellCultureMedium
   BotGrowthMedium - GrowthMedium
   BotSolidGrowthMedium - (and BotGrowthMedium SolidGrowthMedium)
   TryptoseSulfiteCycloserineAgar SalicinTrypticSoyAgar CBIAgar
   BotulinumAssayMedium Ionagar MeatAgar - BotSolidGrowthMedium
   EggYolkAgar - (and DifferentialMedium BotSolidGrowthMedium)
   BaGrowthMedium - GrowthMedium
   BaSolidGrowthMedium - (and BaGrowthMedium SolidGrowthMedium)
   TrypticSoyAgar - (and BaSolidGrowthMedium BotSolidGrowthMedium)
   NutrientAgar - (and BaSolidGrowthMedium BotSolidGrowthMedium)
   SheepBloodAgar - BaSolidGrowthMedium
   LiquidGrowthMedium ReducingMedium - GrowthMedium
   BotLiquidGrowthMedium - (and LiquidGrowthMedium BotGrowthMedium)
   MeatBroth TPGYBroth TrypticasePeptoneBroth - BotLiquidGrowthMedium
   BaLiquidGrowthMedium - (and LiquidGrowthMedium BaGrowthMedium)
   NutrientBroth - (and BaLiquidGrowthMedium BotLiquidGrowthMedium)
   TrypticSoyBroth - (and BaLiquidGrowthMedium BotLiquidGrowthMedium)
   SporulationMedium - GrowthMedium
   BaLiquidSporulationMedium - (and SporulationMedium BaLiquidGrowthMedium)
   BaSolidSporulationMedium - (and SporulationMedium BaSolidGrowthMedium)
   SporulationAgar - BaSolidSporulationMedium
   YpGrowthMedium - GrowthMedium
   YpLiquidGrowthMedium - (and YpGrowthMedium LiquidGrowthMedium)
   YpSolidGrowthMedium - (and YpGrowthMedium SolidGrowthMedium)
   Microorganism - BWARelatedSubstance
   Bacterium - Microorganism
   AnaerobicOrganism - Bacterium
   ObligateAnaerobe AerotolerantAnaerobe - AnaerobicOrganism
   ClostridiumBotulinum - ObligateAnaerobe
   FacultativeAnaerobe - AnaerobicOrganism
   YersiniaPestis - (and CDCCategoryA FacultativeAnaerobe)
   AerobicOrganism - Bacterium
   ObligateAerobe FacultativeAerobe - AerobicOrganism
   BacillusAnthracis - (and CDCCategoryA ObligateAerobe)
   Microaerophile - AerobicOrganism
   Virus - Microorganism
   Filovirus - Virus
   Ebola - (and CDCCategoryA Filovirus)
   Zaire Sudan Reston
   IvoryCoast Bundibugyo - Ebola
   MarburgVirus - (and CDCCategoryA Filovirus)
   Voege Ravn Musoke
   Ci67 Ozolin Ratayczak
   Leiden Popp Angola - MarburgVirus
   MediumComponent - BWARelatedSubstance
   BotMediumComponent BaMediumComponent - MediumComponent
   YeastExtract - (and BotMediumComponent BaMediumComponent)
   Thiotone - (and BotMediumComponent BaMediumComponent)
   PeptonizedMilk - (and BotMediumComponent BaMediumComponent)
   CornSyrup - (and BotMediumComponent BaMediumComponent)
   CornsteepLiquor - (and BotMediumComponent BaMediumComponent)
   HydrolyzedSoy - (and BotMediumComponent BaMediumComponent)
   SoyMilk - (and SolventDryingChemical BotMediumComponent BaMediumComponent)
   SolidifyingAgent Protamine - MediumComponent
   Agarose Agar Gelatin - SolidifyingAgent
   CellCultureMediumComponent - MediumComponent
   HanksBalancedSaltSolution - CellCultureMediumComponent
   CellCultureBuffer - (and CellCultureMediumComponent Buffer)
   HEPESBuffer - (and Buffer CellCultureBuffer)
   PhosphateBufferedSaline - (and Buffer CellCultureBuffer)
   CellCultureAntibiotic LactalbuminHydrolysate Non-essentialAminoAcids
   EarlesBalancedSaltSolution SerumAlbumin - CellCultureMediumComponent
   Streptomycin Penicillin PenicillinStreptomycinMixture
   AmphotericinB - CellCultureAntibiotic
   SodiumBicarbonate MilkFiltrate - CellCultureMediumComponent
   TryptosePhosphateBroth - (and CellCultureMediumComponent ViralTransportMedium)
   MagnesiumChloride L-Glutamine - CellCultureMediumComponent
   FluidizerAdditive Excipient - BWARelatedSubstance
   PVC CarboxylicResin FumedSilica - FluidizerAdditive
   Stain - BWARelatedSubstance
   CellCultureStain Safranin CrystalViolet - Stain
   TrypanBlue - CellCultureStain
   NeutralRed - (and CellCultureMediumComponent CellCultureStain)
   GramStain MalachiteGreen - Stain
   BiologicalSourceMaterial - BWARelatedSubstance
   EnvironmentalSourceMaterial PlantSourceMaterial - BiologicalSourceMaterial
   OceanSediment Soil EnvironmentalWaterSource
   Sand - EnvironmentalSourceMaterial
   ClinicalSourceMaterial FrozenStock - BiologicalSourceMaterial
   Feces - ClinicalSourceMaterial
   Serum - (and CellCultureMediumComponent ClinicalSourceMaterial)
   CalfSerum - Serum
   IrradiatedCalfSerum IrradiatedFetalCalfSerum NewbornCalfSerum
   GG-freeCalfSerum DialyzedNewbornCalfSerum IrradiatedNewbornCalfSerum
   HeatInactivatedFetalCalfSerum DialyzedFetalCalfSerum GG-freeFetalCalfSerum
   HeatInactivatedCalfSerum DialyzedCalfSerum FetalBovineSerum
   GG-freeNewbornCalfSerum HeatInactivatedNewbornCalfSerum - CalfSerum
   HorseSerum - Serum
   InactivatedHorseSerum DialyzedHorseSerum GG-freeHorseSerum - HorseSerum
   Blood Urine Swab
   Hair - ClinicalSourceMaterial
   AnimalSourceMaterial - BiologicalSourceMaterial
   AnimalHide Sputum CerebralSpinalFluid
   HumanSourceMaterial Organ Stool
   AnimalHair - AnimalSourceMaterial
   FoodSourceMaterial - BiologicalSourceMaterial
   Seafood Honey - FoodSourceMaterial
   BlueCrab - Seafood
   Meat BakedPotato CannedGood
   GarlicInOil - FoodSourceMaterial
   BroilerChicken - Meat
   Vegetable BeverageSourceMaterial GrilledOnion
   VacuumPackagedFood - FoodSourceMaterial
   AnimalSource FacilitySourceMaterial FilterPaperStock
   LyophilizedStock - BiologicalSourceMaterial
   InsectVectorSourceMaterial NonHumanPrimate Pheasant
   FruitBat - AnimalSource
   BitingFly - InsectVectorSourceMaterial
   Mouse WildDuck Pig
   BirdCarcass WaterBird Turkey - AnimalSource
   VirusCulture - BiologicalSourceMaterial
   BiologicalAgentSourceMaterial - BWARelatedSubstance
   MarburgVirusSourceMaterial ClostridiumBotulinumSourceMaterial - BiologicalAgentSourceMaterial
   MarburgVirusBRCSourceMaterial - MarburgVirusSourceMaterial
   MarburgVirusCulture MarburgVirusFilterPaperStock MarburgFrozenStock
   MarburgLyophilizedStock - MarburgVirusBRCSourceMaterial
   MarburgVirusClinicalSourceMaterial - MarburgVirusSourceMaterial
   MarburgVirusOrgan MarburgVirusFeces MarburgVirusSemen
   MarburgVirusBreastMilk MarburgVirusTissue - MarburgVirusClinicalSourceMaterial
   MarburgVirusBrain MarburgVirusHeart MarburgVirusKidney
   MarburgVirusSpleen MarburgVirusLiver - MarburgVirusOrgan
   MarburgVirusBlood MarburgVirusSwab MarburgVirusUrine - MarburgVirusClinicalSourceMaterial
   MarburgVirusReservoir - MarburgVirusSourceMaterial
   MarburgVirusNonHumanPrimate - MarburgVirusReservoir
   MarburgVirusChimpanzee MarburgVirusSquirrelMonkey MarburgVirusAfricanGreenMonkey
   MarburgVirusRhesusMonkey MarburgVirusBaboon MarburgVirusCynomolgusMonkey - MarburgVirusNonHumanPrimate
   MarburgVirusFruitBat MarburgVirusEnvironmentalSourceMaterial - MarburgVirusReservoir
   BacillusAnthracisSourceMaterial - BiologicalAgentSourceMaterial
   PotentialBacillusAnthracisFoodSource PotentialBacillusAnthracisBRCSourceMaterial BacillusAnthracisAnimalSourceMaterial - BacillusAnthracisSourceMaterial
   MicroorganismInhibitor - BWARelatedSubstance
   ChemicalDisinfectant - MicroorganismInhibitor
   Phenolic Peroxygen Detergent
   HeavyMetal Antiseptic GaseousSterilant - ChemicalDisinfectant
   Bactericide Antibody Viricide - MicroorganismInhibitor
   Stabilizer Inoculum - BWARelatedSubstance
   ViralStabilizer Microcarrier - Stabilizer
   MagnesiumSulfate SoyProteinAcidHydrolysate Starch
   Casitone CaseinHydrolysate Albumin
   HyPep4601 SodiumGlutamate Haemaccel - ViralStabilizer
   Polyvinylpyrrolidone - (and FluidizerAdditive ViralStabilizer)
   EDTA BovineGelatin CalciumGluconateLactobionate
   Carrageenan Milk - ViralStabilizer
   SucrosePhosphateGlutamate - (and ViralStabilizer ViralTransportMedium)
   ViralStabilizerSugarAlcohol PeptoneNZ-Soy ViralStabilizerAminoAcid
   MarburgVirusStabilizer GelatinHydrolysate - ViralStabilizer
   PowderedMilk - (and SolidsDryingChemical BotMediumComponent Excipient ViralStabilizer BaMediumComponent)
   ViralStabilizerSugar - ViralStabilizer
   BacterialStabilizer - Stabilizer
   Glycerol - (and MarburgVirusStabilizer BacterialStabilizer)
   BacterialStorageBead CellCultureStabilizer - Stabilizer
   ExperimentalControl - BWARelatedSubstance
   PositiveBacillusAnthracisAntibodyStandardControl PositiveClostridiumBotulinumAntibodyStandardControl PositiveBacillusAnthracisDNAStandardControl
   PositiveClostridiumBotulinumDNAStandardControl - ExperimentalControl
   Egg - BWARelatedSubstance
   EmbryonicEgg - Egg
   Enzyme - BWARelatedSubstance
   Protease DNase - Enzyme
   Papain Bromelain Chymotrypsin
   Collagenase - Protease
   Trypsin - (and ChemicalCellDissociationMaterial Protease)
   ChymotrypsinogenA - Protease
   Polymerase - (and Enzyme PCRChemicalComponent)
   RNAPolymerase DNAPolymerase ReverseTranscriptase - Polymerase
   Gel Lysin - BWARelatedSubstance
   AgaroseGel - Gel
   ChemicalPrecipitant Antifoam - BWARelatedSubstance
   CalciumChloride - (and ChemicalPrecipitant ViralStabilizer)
   ToxinAcidPrecipitant - ChemicalPrecipitant
   AceticAcid - (and ToxinAcidPrecipitant Acid)
   HydrochloricAcid SulfuricAcid - ToxinAcidPrecipitant
   Flocculant SodiumAcetate - ChemicalPrecipitant
   DensityGradientMedium - BWARelatedSubstance
   BiologicalAssayKit SurfaceStain - BioAgentRelatedEntity
   NucleicAcidAssayKit - BiologicalAssayKit
   RNAPCRKit GelElectrophoresisKit DNAPCRKit - NucleicAcidAssayKit
   ImmunoassayKit - BiologicalAssayKit
   HandHeldAssayKit ELISAKit - ImmunoassayKit
   ColumnBuffer - Buffer
   ColumnWashBuffer ColumnElutionBuffer - ColumnBuffer
   ProteinAffinityColumn DNAAffinityColumn RNAAffinityColumn - AffinityColumn
   PBSTween LysisBuffer DialysisBuffer - Buffer)
  (:predicates
    (hasSporulationPercentage - fact ?a - object ?b - number)
    ))


