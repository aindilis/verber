(in-package :ap)

(define (domain CBRNEChemical)
  (:imports event)
  (:prefix "CBRNEChemical")
  (:uri "http://agent.jhuapl.edu/2011/11/15/Chem/CBRNEChemical#")
  (:types
   AnimalMaterial - OrganicEntity	; added
   ChemicalRole - (and Role ChemicalMaterial)
   Antimicrobial - ChemicalRole
   Bactericide - Antimicrobial
   ChemicalDisinfectant Antibody Antibiotic
   Fungicide - ChemicalRole
   Detergent ToxicMetal - ChemicalDisinfectant
   SoapDetergent AcidDetergent CationicDetergent - Detergent
   GaseousSterilant Antiseptic - ChemicalDisinfectant
   Acid - ChemicalRole
   StrongAcid - Acid
   StrongMonoproticAcid - StrongAcid
   WeakAcid OrganicAcid - Acid
   Solvent ChelatingAgent Surfactant
   MethylatingAgent Sealant - ChemicalRole
   PolarSolvent NonPolarSolvent - Solvent
   PolarAproticSolvent PolarProticSolvent - PolarSolvent
   DryingSolvent AnhydrousSolvent - Solvent
   Fuel Excipient FluidizerAdditive
   Buffer Toxin ChemicalWeaponRole - ChemicalRole
   FossilFuel - Fuel
   HydrocarbonFuel - FossilFuel
   Catalyst OrganicLeavingGroup - ChemicalRole
   Enzyme EpoxideCatalyst - Catalyst
   DNase Protease Polymerase - Enzyme
   DehydrationCatalyst IridiumCatalyst MetalCatalyst - Catalyst
   PurificationChemical Viricide - ChemicalRole
   Desiccant - PurificationChemical
   SolidsDryingChemical SolventDryingChemical GasDryingChemical - Desiccant
   Base Reagent NonOxidizingGas - ChemicalRole
   StrongBase - Base
   ChemicalPrecipitant - ChemicalRole
   Flocculant ToxinPrecipitant - ChemicalPrecipitant
   ChemicalExplosive - ChemicalRole
   DetonatorExplosive SecondaryExplosive ExtrudedExplosive
   TertiaryExplosive - ChemicalExplosive
   PlasticBondedExplosive - DetonatorExplosive
   HighPerformancePlasticBondedEplosive - PlasticBondedExplosive
   PrimaryExplosive - (and ChemicalExplosive DetonatorExplosive)
   Propellant CastExplosive - ChemicalExplosive
   ArtilleryPropellant - Propellant
   DoubleBasePropellant SingleBasePropellant TripleBasePropellant - ArtilleryPropellant
   ChemicalEntity - MaterialEntity
   Protein - ChemicalEntity
   Albumin - Protein
   HumanAlbumin BovineAlbumin Lactalbumin - Albumin
   SoyProtein SoyProteinAcidHydrolysate CaseinHydrolysate - Protein
   PeptoneNZ-Soy HyPep4601 - SoyProtein
   Gelatin - Protein
   BovineGelatin - Gelatin
   GelatinHydrolysate - Protein
   MetalThiocyanate AlkaliMetal Freon
   EthyleneSulfideOligomer Haemaccel - ChemicalEntity
   NitricAcid - (and StrongMonoproticAcid ChemicalEntity)
   TrimethylsilylHalide TriethylammoniumAlkylthiolate - ChemicalEntity
   Peroxygen - (and ChemicalEntity ChemicalDisinfectant)
   MagnesiumChlorideHydrate AlkylAcetimidateHydrochloride OxideOfPlutonium
   Alkane Aldehyde - ChemicalEntity
   AlkaliCarbonate - ChemicalEntity
   TrialkylPhosphite - ChemicalEntity
   ReverseTranscriptase - (and ChemicalEntity Polymerase)
   MetalIAlkylsulfate Dialkyl-H-Phosphonate - ChemicalEntity
   SodiumAlkylsulfate PotassiumAlkylsulfate - MetalIAlkylsulfate
   Alkene Bleach - ChemicalEntity
   Butylene - Alkene
   DNAPolymerase - (and ChemicalEntity Polymerase)
   DialkylSulfate - ChemicalEntity
   SilicaGel - (and ChemicalEntity Desiccant)
   FumedSilica - (and ChemicalEntity FluidizerAdditive)
   HydrophobicSilica HydrophilicSilica - FumedSilica
   AminoAcid - ChemicalEntity
   ViralStabilizerAminoAcid NonEssentialAminoAcid - AminoAcid
   Glutamine - (and ViralStabilizerAminoAcid ChemicalEntity)
   HydrogenHalide LiquidNitrogen OxideOfTitanium
   HalogenHalide - ChemicalEntity
   DisulfideCompound - ChemicalEntity
   SugarAlcohol TrialkylOrthoacetate N-N-Diethylamino-alkylchloroaluminum
   OxalateOfUranium - ChemicalEntity
   ViralStabilizerSugarAlcohol - SugarAlcohol
   ActivatedCarbon - (and ChemicalEntity Catalyst Desiccant)
   S-AlkylIsothiouroniumSalt MetalIAlkoxide IsouroniumSalt
   TrialkylAluminum Starch - ChemicalEntity
   S-AlkylIsothiouroniumChloride - S-AlkylIsothiouroniumSalt
   ChemicalMixture O-Alkyl-DiethylacetimidiniumHalide N_N-DiethylguanidiniumSalt - ChemicalEntity
   CarbolFushin CaryBlairMedium Thiotone
   HydrolyzedSoy MilkFiltrate YeastExtract
   ModifiedInfusionBroth - ChemicalMixture
   Tween - (and Surfactant ChemicalMixture)
   Polymer BME Virocult
   YellowCake - ChemicalMixture
   Polyethylene Polyimide - Polymer
   UltraHighMolecularWeightPolyethylene - Polyethylene
   CarboxylicResin - (and FluidizerAdditive Polymer)
   PVC - (and FluidizerAdditive Polymer)
   Polyglycine - (and SolidsDryingChemical Polymer)
   Polyamide Polystyrene - Polymer
   Polyvinylpyrrolidone - (and SolidsDryingChemical FluidizerAdditive Polymer)
   Fluoroplastic Polyisobutylene PolyethyleneGlycol
   Polysulfone PolyacrylamideGel HighDensityPolyethylene - Polymer
   PerFluoroAlkoxy PolyTetraFluoroEthylene FluorinatedEthylenePropylene - Fluoroplastic
   Phenolic - (and Polymer ChemicalDisinfectant)
   Polypropylene - Polymer
   HydrocarbonMixture - ChemicalMixture
   Gasoline - (and HydrocarbonFuel HydrocarbonMixture)
   ParaffinWax - HydrocarbonMixture
   Diesel - (and HydrocarbonFuel HydrocarbonMixture)
   NaturalGas - (and HydrocarbonFuel HydrocarbonMixture)
   Kerosene - (and HydrocarbonFuel HydrocarbonMixture)
   Petroleum - (and HydrocarbonFuel HydrocarbonMixture)
   ExplosiveMixture CoalTarPitch DMEM
   TrypticSoyBroth - ChemicalMixture
   PBX9010 - (and ExplosiveMixture SecondaryExplosive)
   HBX - (and ExplosiveMixture SecondaryExplosive)
   PBXN-103 - (and ExplosiveMixture SecondaryExplosive)
   HTA-3 - (and ExplosiveMixture SecondaryExplosive)
   PBXN-104 - (and ExplosiveMixture SecondaryExplosive)
   Ednatol - (and ExplosiveMixture SecondaryExplosive)
   CompositionB3 - (and CastExplosive ExplosiveMixture SecondaryExplosive)
   CompositionB - (and CastExplosive ExplosiveMixture SecondaryExplosive)
   CompositionB4 - (and CastExplosive ExplosiveMixture SecondaryExplosive)
   LX-07 - (and ExplosiveMixture HighPerformancePlasticBondedEplosive SecondaryExplosive)
   LX-09 - (and ExplosiveMixture SecondaryExplosive)
   LX-04 - (and ExplosiveMixture HighPerformancePlasticBondedEplosive SecondaryExplosive)
   Pentolite - (and ExplosiveMixture SecondaryExplosive)
   PBXTypeI - (and ExplosiveMixture SecondaryExplosive)
   BlackPowder - (and Propellant ExplosiveMixture)
   CompositionCH6 - (and ExplosiveMixture SecondaryExplosive)
   PBXN-6 - (and ExplosiveMixture SecondaryExplosive)
   RX-08 - (and ExplosiveMixture SecondaryExplosive ExtrudedExplosive)
   Tetrytol - (and ExplosiveMixture SecondaryExplosive)
   PropellantM30 - (and ExplosiveMixture TripleBasePropellant)
   Torpex - (and ExplosiveMixture SecondaryExplosive)
   Tritonal - (and ExplosiveMixture SecondaryExplosive)
   Minol-2 - (and ExplosiveMixture SecondaryExplosive)
   CompositionHTA-3 - (and ExplosiveMixture SecondaryExplosive)
   PBX0280 - (and ExplosiveMixture SecondaryExplosive)
   Picratol - (and ExplosiveMixture SecondaryExplosive)
   Amatex-20 - (and ExplosiveMixture SecondaryExplosive)
   PropellantIMR - (and SingleBasePropellant ExplosiveMixture)
   Cordite - (and ExplosiveMixture ArtilleryPropellant)
   CorditeN - (and Cordite TripleBasePropellant)
   CorditeHSC - (and DoubleBasePropellant Cordite)
   CorditeMD - (and DoubleBasePropellant Cordite)
   CorditeMC - (and DoubleBasePropellant Cordite)
   CorditeMark1 - (and DoubleBasePropellant Cordite)
   CorditeSC - (and DoubleBasePropellant Cordite)
   FNHP - (and SingleBasePropellant ExplosiveMixture)
   NH - (and SingleBasePropellant ExplosiveMixture)
   PropellantM9 - (and Propellant ExplosiveMixture)
   PBXN-301 - (and ExplosiveMixture SecondaryExplosive)
   PBXN-4 - (and ExplosiveMixture SecondaryExplosive)
   NF - (and ExplosiveMixture TripleBasePropellant)
   CompositionC4 - (and ExplosiveMixture SecondaryExplosive)
   CompositionH6 - (and ExplosiveMixture SecondaryExplosive)
   PBXN-102 - (and ExplosiveMixture SecondaryExplosive)
   Cyclotol - (and CastExplosive ExplosiveMixture SecondaryExplosive)
   PropellantM5 - (and DoubleBasePropellant ExplosiveMixture)
   PBXN-5 - (and ExplosiveMixture SecondaryExplosive)
   PBXN-201 - (and ExplosiveMixture SecondaryExplosive)
   Nitrostarch - (and ExplosiveMixture SecondaryExplosive)
   Ammonal - (and ExplosiveMixture SecondaryExplosive)
   PropellantM7 - (and Propellant ExplosiveMixture)
   PropellantM26 - (and DoubleBasePropellant ExplosiveMixture)
   PropellantM2 - (and DoubleBasePropellant ExplosiveMixture)
   PBXN-3 - (and ExplosiveMixture SecondaryExplosive)
   PropellantM6 - (and Propellant ExplosiveMixture)
   XTX8003 - (and ExplosiveMixture SecondaryExplosive ExtrudedExplosive)
   XTX8004 - (and ExplosiveMixture SecondaryExplosive ExtrudedExplosive)
   Amatol - (and ExplosiveMixture SecondaryExplosive)
   LX-14 - (and ExplosiveMixture SecondaryExplosive)
   LX-10 - (and ExplosiveMixture SecondaryExplosive)
   LX-13 - (and ExplosiveMixture SecondaryExplosive)
   MilitaryDynamite - (and ExplosiveMixture SecondaryExplosive)
   H6 - (and ExplosiveMixture SecondaryExplosive)
   PBX9404 - (and ExplosiveMixture HighPerformancePlasticBondedEplosive SecondaryExplosive)
   PBX9407 - (and ExplosiveMixture SecondaryExplosive)
   PBXN-101 - (and ExplosiveMixture SecondaryExplosive)
   CSP2 - (and DoubleBasePropellant ExplosiveMixture)
   Octol - (and CastExplosive ExplosiveMixture SecondaryExplosive)
   Coal - (and HydrocarbonFuel ChemicalMixture)
   Agar Medium199 SerumAlbumin
   MeatBroth - ChemicalMixture
   SodiumSulfiteGentianVioletAgar CBIAgar NutrientAgar
   MacConkeyAgar HyperSaltedAgar BeefHeartTrypticDigestGlucoseAgar
   TryptosePhosphateAgar CongoRedAgar SalicinTrypticSoyAgar
   Luria TryptoseBloodAgar BloodAgarBaseMedium
   BrainHeartInfusionAgar BINAgar CefsulodinIrgasanNovobiocinAgar
   SheepBloodAgar CopperSulfateAgar YersiniaSelcetiveAgar
   TrypticSoyAgar MeatAgar EggYolkAgar
   SporulationAgar TryptoseSulfiteCycloserineAgar - Agar
   Solution - ChemicalMixture
   PlatingSolution pHStandardSolution - Solution
   NickelPlatingSolution - PlatingSolution
   AcidicWater - (and Solution Acid)
   EarlesBalancedSaltSolution SodiumCarbonateSolution SodiumAcetateSolution
   SodiumHydroxideSolution SodiumPhosphateSolution HanksBalancedSaltSolution
   SaltSolution - Solution
   Ore CornsteepLiquor TPGYBroth
   RPMI1634 - ChemicalMixture
   Pyrolusite - Ore
   Alloy PhosphateBufferedSaline Characoal
   NutrientBroth TryptosePhosphateBroth McCoy5A - ChemicalMixture
   MetalAlloy - Alloy
   NickelAlloy - MetalAlloy
   NickelSuperAlloy - NickelAlloy
   Inconel Hastelloy Monel - NickelSuperAlloy
   AluminumBerylliumAlloy TantalumAlloy MagnesiumCadmiumAlloy
   TungstenAlloy PlutoniumAlloy - MetalAlloy
   Gel Milk BrainHeartInfusionBroth - ChemicalMixture
   AgaroseGel - Gel
   Ionagar - ChemicalMixture
   PenicillinStreptomycinMixture - (and ChemicalMixture Antibiotic)
   MethylatedSpirit TBA-MgOXMedium - ChemicalMixture
   SoyMilk - (and SolventDryingChemical ChemicalMixture)
   LactalbuminHydrolysateMedium BartelsViralTransport MEM
   LactalbuminHydrolysate LuriaBroth - ChemicalMixture
   MolecularSieve - (and PurificationChemical ChemicalMixture)
   Serum - (and ChemicalMixture AnimalMaterial)
   HorseSerum - Serum
   GG-freeHorseSerum DialyzedHorseSerum InactivatedHorseSerum - HorseSerum
   CalfSerum - Serum
   IrradiatedNewbornCalfSerum GG-freeCalfSerum FetalBovineSerum
   HeatInactivatedFetalCalfSerum NewbornCalfSerum HeatInactivatedCalfSerum
   GG-freeFetalCalfSerum DialyzedNewbornCalfSerum HeatInactivatedNewbornCalfSerum
   IrradiatedFetalCalfSerum GG-freeNewbornCalfSerum DialyzedFetalCalfSerum
   DialyzedCalfSerum IrradiatedCalfSerum - CalfSerum
   ChemicalWarfareAgentMixture F-12 BotulinumAssayMedium
   CornSyrup CellStripper - ChemicalMixture
   SulfurMustard MustardTMixture DistilledSulfurMustard
   CNS CNB CNC
   MustardLewisiteMixture - ChemicalWarfareAgentMixture
   Peptone RichardsViralTransport - ChemicalMixture
   Casitone - Peptone
   F-10 - ChemicalMixture
   Coke - (and HydrocarbonFuel Catalyst ChemicalMixture)
   RPMI1630 IndianInk L-15Medium
   HeartInfusionBroth - ChemicalMixture
   PowderedMilk - (and SolidsDryingChemical Excipient ChemicalMixture)
   AcetateBuffer - (and Buffer ChemicalMixture)
   Protamine TrypticasePeptoneBroth RPMI1640
   HEPESBuffer BestCaseScenarioMedium PeptonizedMilk
   WaysonStain DenaturedAlcohol - ChemicalMixture
   O-Ethyl-S-Alkyl-Phosphoramidothioate DialkyAcetal HalogenAcid
   Tragacanth - ChemicalEntity
   Collagenase - (and ChemicalEntity Protease)
   ElementalEntity - ChemicalEntity
   SulfurElementalEntity - ElementalEntity
   Sulfur - SulfurElementalEntity
   HydrogenElementalEntity HeliumElementalEntity - ElementalEntity
   HydrogenIsotope - HydrogenElementalEntity
   Tritium Deuterium Protium - HydrogenIsotope
   CobaltElementalEntity - ElementalEntity
   Cobalt - CobaltElementalEntity
   PhosphorusElementalEntity - ElementalEntity
   Phosphorus - PhosphorusElementalEntity
   RadiumElementalEntity - ElementalEntity
   RadiumIsotope Radium - RadiumElementalEntity
   Radium226 - RadiumIsotope
   IodineElementalEntity - ElementalEntity
   Iodine - IodineElementalEntity
   PoloniumElementalEntity - ElementalEntity
   PoloniumIsotope Polonium - PoloniumElementalEntity
   Polonium210 - PoloniumIsotope
   TantalumElementalEntity - ElementalEntity
   Tantalum - TantalumElementalEntity
   PlutoniumElementalEntity - ElementalEntity
   PlutoniumIsotope Plutonium - PlutoniumElementalEntity
   Plutonium240 Plutonium238 Plutonium241
   Plutonium239 - PlutoniumIsotope
   BerylliumElementalEntity - ElementalEntity
   Beryllium - BerylliumElementalEntity
   TinElementalEntity XenonElementalEntity - ElementalEntity
   Tin - TinElementalEntity
   CarbonElementalEntity - ElementalEntity
   Graphite - CarbonElementalEntity
   MachinableGraphite - Graphite
   Carbon - CarbonElementalEntity
   IronElementalEntity RadonElementalEntity - ElementalEntity
   Iron - IronElementalEntity
   SodiumElementalEntity - ElementalEntity
   Sodium - (and MetalCatalyst SodiumElementalEntity)
   NickelElementalEntity - ElementalEntity
   Nickel - NickelElementalEntity
   AluminumElementalEntity - ElementalEntity
   Aluminum - AluminumElementalEntity
   SilverElementalEntity - ElementalEntity
   Silver - (and MetalCatalyst SilverElementalEntity)
   UraniumElementalEntity - ElementalEntity
   NonEnrichedUranium - UraniumElementalEntity
   DepletedUranium NaturalUranium - NonEnrichedUranium
   EnrichedUranium - UraniumElementalEntity
   HighlyEnrichedUranium LowEnrichedUranium - EnrichedUranium
   UraniumIsotope - UraniumElementalEntity
   Uranium233 Uranium235 Uranium238 - UraniumIsotope
   CalciumElementalEntity - ElementalEntity
   Calcium - CalciumElementalEntity
   TungstenElementalEntity - ElementalEntity
   Tungsten - TungstenElementalEntity
   MagnesiumElementalEntity KryptonElementalEntity - ElementalEntity
   Magnesium - MagnesiumElementalEntity
   ChromiumElementalEntity - ElementalEntity
   Chromium - ChromiumElementalEntity
   PotassiumElementalEntity - ElementalEntity
   Potassium - PotassiumElementalEntity
   GalliumElementalEntity - ElementalEntity
   Gallium - GalliumElementalEntity
   ScandiumElementalEntity - ElementalEntity
   Scandium - ScandiumElementalEntity
   CeriumElementalEntity - ElementalEntity
   Cerium - CeriumElementalEntity
   TitaniumElementalEntity - ElementalEntity
   Titanium - TitaniumElementalEntity
   PlatinumElementalEntity ArgonElementalEntity - ElementalEntity
   Platinum - (and PlatinumElementalEntity MetalCatalyst)
   CopperElementalEntity - ElementalEntity
   Copper - (and CopperElementalEntity MetalCatalyst)
   CadmiumElementalEntity - ElementalEntity
   Cadmium - CadmiumElementalEntity
   ActiniumElementalEntity - ElementalEntity
   ActiniumIsotope - ActiniumElementalEntity
   Actinium227 - ActiniumIsotope
   Actinium - ActiniumElementalEntity
   HafniumElementalEntity - ElementalEntity
   Hafnium - HafniumElementalEntity
   LeadElementalEntity - ElementalEntity
   Lead - LeadElementalEntity
   SiliconElementalEntity - ElementalEntity
   Silicon - SiliconElementalEntity
   ZirconiumElementalEntity - ElementalEntity
   Zirconium - ZirconiumElementalEntity
   LithiumElementalEntity - ElementalEntity
   Lithium - LithiumElementalEntity
   NeonElementalEntity - ElementalEntity
   PhosphiteEster - ChemicalEntity
   Salt TrialkylamineHydrochloride MetalCarbide
   S-AlkylIsothiouroniumSulfate DNA - ChemicalEntity
   MetalSalt - Salt
   MetalHalide - MetalSalt
   MetalChloride MetalFluoride - MetalHalide
   ChlorideOfUranium - MetalChloride
   MetalBromide MetalIodide - MetalHalide
   MetalISalt MetalCyanide MetalSulfate - MetalSalt
   MetalIBromide - (and MetalBromide MetalISalt)
   MetalIFluoride - (and MetalFluoride MetalISalt)
   MetalIChloride - (and MetalChloride MetalISalt)
   SodiumHalide - MetalISalt
   MetalISulfate - (and MetalISalt MetalSulfate)
   MetalIHydrogenSulfate - MetalISulfate
   MetalSulfide FluorideOfPlutonium - MetalSalt
   MetalISulfide - MetalSulfide
   CopperSalt MetalCyanate FluorideOfUranium - MetalSalt
   CopperIISulfatePentahydrate - (and CopperSalt MetalSulfate)
   CopperIISulfate - (and CopperSalt MetalSulfate)
   CopperIHalide - (and CopperSalt MetalHalide)
   MetalNitrate - MetalSalt
   MetalINitrate - (and MetalNitrate MetalISalt)
   MecuricDihalide - MetalSalt
   MetalAlkylthiolate CarbonBlack O-AlkylIsouroniumChloride - ChemicalEntity
   AntimonyAlkylthiolate SilverAlkylthiolate MetalIAlkylthiolate - MetalAlkylthiolate
   BulkWater - ChemicalEntity
   EnvironmentalWater TapWater MBGWater
   DeionizedWater DEPCTreatedWater SterileWater
   DistilledWater - BulkWater
   WellWater - EnvironmentalWater
   OxideOfUranium Tri-n-ButylAmmoniumChloride DialkylPhosphorodithioate - ChemicalEntity
   UranylPeroxide - OxideOfUranium
   Carrageenan AlkylCarbamimidothioate TrialkylAmine - ChemicalEntity
   AmineBase - (and ChemicalEntity Catalyst)
   O-AlkylIsouroniumSalt Tris-HClSolution Carbohydrate
   CalciumGluconateLactobionate - ChemicalEntity
   O-AlkylIsouroniumAlkylSulfate O-AlkylIsouroniumSulfateSalt O-AlkylIsouroniumHydrogenSulfate
   O-AlkylIsouroniumHydrohalide - O-AlkylIsouroniumSalt
   MetalHydroxide DialkylPhosphonothioate PolysulfoMustards - ChemicalEntity
   MetalIHydroxide - MetalHydroxide
   Peptide - ChemicalEntity
   HydrofluoricAcid - (and StrongMonoproticAcid ChemicalEntity)
   AlkylsulfonicAcid OxalateOfPlutonium AntimonyChlorideX-Fluoride3-X - ChemicalEntity
   SynDol - (and DehydrationCatalyst ChemicalEntity)
   SucrosePhosphateGlutamate - ChemicalEntity
   InertGas - (and NonOxidizingGas ChemicalEntity)
   NobleGas - InertGas
   Helium - (and NobleGas HeliumElementalEntity)
   Radon - (and RadonElementalEntity NobleGas)
   Neon - (and NeonElementalEntity NobleGas)
   Xenon - (and NobleGas XenonElementalEntity)
   Krypton - (and KryptonElementalEntity NobleGas)
   Argon - (and ArgonElementalEntity NobleGas)
   N_N-DiethylguanidiniumAlkylSulfate TrialkylamineHydrofluoride SolubleOil
   Biguanide BaseHydrochlorideSalt Feldspar - ChemicalEntity
   RNAPolymerase - (and ChemicalEntity Polymerase)
   BaseHydrofluorideSalt MetalIHydrosulfide CyanogenHalide
   AlkylCarbamate S-AlkylIsothiouroniumHalide DialkylPhosphorochloridothioate
   AlkylHydrogenSulfate S-AlkylIsothiouroniumHydrogenSulfate Air
   TrimethylsilylAlkylEther Chloroalkane S-AlkylIsothiourea - ChemicalEntity
   HydrochloricAcid - (and StrongMonoproticAcid ChemicalEntity ToxinPrecipitant)
   DialkylChloroPhosphite AlkylPhosphonicDifluoride S-AlkylIsothiouroniumAlkylSulfate - ChemicalEntity
   CarbideOfUranium - (and ChemicalEntity MetalCarbide)
   MetalHydrogenSulfate - ChemicalEntity
   Penicillin - (and ChemicalEntity Antibiotic)
   dNTP - ChemicalEntity
   Inositol - (and ViralStabilizerSugarAlcohol ChemicalEntity)
   MolecularEntity - ChemicalEntity
   PalladiumChloride - (and MolecularEntity Catalyst MetalChloride)
   PinacolHydrate O_S-DimethylPhosphorochloridothioate - MolecularEntity
   Dimethyl-H-Phosphonate - (and MolecularEntity Dialkyl-H-Phosphonate)
   Tributylamine - (and MolecularEntity Catalyst AmineBase Solvent TrialkylAmine)
   Tetramethoxysilane VX NitrousOxide
   BariumSulfate Edemo SodiumCarbonate
   AmmoniumCarbonate - MolecularEntity
   SodiumNitrate - (and MolecularEntity MetalINitrate)
   Tetrahydrofuran Thiodiglycol - MolecularEntity
   AntimonyButylthiolate - (and MolecularEntity AntimonyAlkylthiolate)
   AmmoniumFluoride Diethylphthalate Bis2-hydroxyethylthiomethane
   BritishAntiLewisite Thiobisethane-21-diylDibenzoate - MolecularEntity
   SilverMethylthiolate - (and MolecularEntity SilverAlkylthiolate)
   VS O_O-DiethylPhosphorochloridothioate - MolecularEntity
   O-EthylIsouroniumSulfate - (and MolecularEntity O-AlkylIsouroniumSulfateSalt)
   SodiumHypochlorite CalciumLactobionate IsocyanicAcid
   EthylChlorofluorophosphate Diphenylamine - MolecularEntity
   UraniumDioxideOxalate - (and MolecularEntity OxalateOfUranium)
   GuanidineNitrate - MolecularEntity
   SodiumMethylSulfate - (and MolecularEntity SodiumAlkylsulfate)
   Bis-2-Chloroethyl-Ethylamine DicyclohexylMethylphosphonate BenzoylChloride - MolecularEntity
   UraniumHexachloride - (and MolecularEntity ChlorideOfUranium)
   CyclohexylMethylphosphonicAcid - MolecularEntity
   BariumNitrate - (and MolecularEntity PrimaryExplosive)
   EthyleneGlycol SodiumGlutamate - MolecularEntity
   TrimethylOrthoacetate - (and MolecularEntity TrialkylOrthoacetate)
   SodiumMolybdate - MolecularEntity
   PotassiumFerricyanide - (and MolecularEntity MetalCyanide)
   _24-Dinitrotoluene Fuchsine Perfluoroisobutylene
   Dioctylphthalate - MolecularEntity
   _2-EthylIsoureaHydrobromide - (and MolecularEntity O-AlkylIsouroniumHydrohalide)
   Bis-2-chlorovinylchloroarsine PhosphorusTrichloride _13-bis2-hydroxyethylthioproane - MolecularEntity
   AmphotericinB - (and MolecularEntity Antibiotic)
   Propane - (and MolecularEntity Alkane)
   SodiumIsopropoxide Bis-O-MethylIsouroniumSulfate LanthanumBromide
   FormicAcid - MolecularEntity
   N_N-DiethylguanidiniumMethylSulfate - (and MolecularEntity N_N-DiethylguanidiniumAlkylSulfate)
   TrypanBlue - MolecularEntity
   HydrogenFluorideGas - (and MolecularEntity HydrogenHalide)
   SilverOxide - (and MolecularEntity Catalyst)
   _1-4-Thioxane DiethyleneglycolDinitrate MagnesiumFluoride
   Benzotrichloride - MolecularEntity
   PlutoniumOxide - (and MolecularEntity OxideOfPlutonium)
   N_N-DiethylguanidiniumChloride - (and MolecularEntity N_N-DiethylguanidiniumSalt)
   MethylFluoride - MolecularEntity
   PlutoniumSesquioxide - (and MolecularEntity OxideOfPlutonium)
   SodiumHydrogenSulfate - (and MetalIHydrogenSulfate MolecularEntity)
   DiethylEther _2-Chloroethanethiol LithiumHydride
   AcridineOrange AmmoniumBicarbonate - MolecularEntity
   TrimethylPhosphite - (and MolecularEntity TrialkylPhosphite)
   CalciumCarbide - (and MolecularEntity MetalCarbide)
   MethylSulfonicAcid - (and MolecularEntity AlkylsulfonicAcid)
   Tabun - MolecularEntity
   TriethylOrthoacetate - (and MolecularEntity TrialkylOrthoacetate)
   UreaNitrate NeutralRed Arsine - MolecularEntity
   _246_Trinitrotoluene - (and MolecularEntity CastExplosive SecondaryExplosive)
   Acetonitrile - MolecularEntity
   TriethylamineHydrochloride - (and MolecularEntity TrialkylamineHydrochloride)
   MethylIodide - (and MolecularEntity MethylatingAgent)
   N_N-Diethylacetamide TrimethylsilylIodide HydrogenTetrachloroaluminate
   AluminumHydroxide - MolecularEntity
   Glycine - (and MolecularEntity ViralStabilizerAminoAcid)
   VinylChloride AmmoniumHydroxide VR - MolecularEntity
   PotassiumBromide - (and MolecularEntity MetalIBromide)
   Arginine - (and MolecularEntity ViralStabilizerAminoAcid)
   Ammonia - MolecularEntity
   MethylCarbamimidothioate - (and MolecularEntity AlkylCarbamimidothioate)
   CalciumStearate t-ButylMagnesiumChloride - MolecularEntity
   ZirconiumCarbide - (and MolecularEntity MetalCarbide)
   _2-2-chloroethylthioethanol - MolecularEntity
   SodiumIodide - (and MolecularEntity SodiumHalide)
   PerchloricAcid SilicaChloride - MolecularEntity
   PotassiumMethylSulfate - (and MolecularEntity PotassiumAlkylsulfate)
   IsouroniumSulfate - (and MolecularEntity IsouroniumSalt)
   Chloroacetophenone _2-Chlorovinyldichloroarsine PotassiumEthoxide - MolecularEntity
   SodiumHydroxide - (and MolecularEntity MetalIHydroxide)
   PlutoniumIIIOxalate - (and MolecularEntity OxalateOfPlutonium)
   Adamsite Tris-2-ChloroethylAmine CalciumSulfateHemihydrate
   AmmoniumDiuranate t-Butanol Phenol
   IsopropylMethylphosphonicAcid TrimethylAluminum CS
   AmmoniumSulfate Bromobenzylcyanide DimethylCarbonate
   Bis2-chloroethylsulfide - MolecularEntity
   HydrogenChlorideGas - (and MolecularEntity HydrogenHalide)
   SodiumEthylSulfate - (and MolecularEntity SodiumAlkylsulfate)
   N_N-DiethylguanidiniumBromide - (and MolecularEntity N_N-DiethylguanidiniumSalt)
   DisulfurDichloride - MolecularEntity
   TitaniumCarbide - (and MolecularEntity MetalCarbide)
   AceticAcid - (and WeakAcid MolecularEntity ToxinPrecipitant)
   Diethyl-H-Phosphonate - (and MolecularEntity Dialkyl-H-Phosphonate)
   AntimonyPropylthiolate - (and MolecularEntity AntimonyAlkylthiolate)
   AntimonyTrifluoride Soman - MolecularEntity
   PlutoniumIIIOxalateDecahydrate - (and MolecularEntity OxalateOfPlutonium)
   ThiodiglycolSulfoxide O_O-DimethylAmino-DiethylAmino-Methylene-Phosphoramidothioate Water
   HydrogenSulfide _26-Dinitrotoluene OxalylChloride
   OroticAcid BenzoylFluoride VE - MolecularEntity
   TriethylamineHydrofluoride - (and MolecularEntity TrialkylamineHydrofluoride)
   LithiumChloride - (and MolecularEntity MetalChloride)
   DiIodine FluorineGas - MolecularEntity
   _135-Trinitrobenzene - (and MolecularEntity PrimaryExplosive)
   CobaltII_IIIOxide - (and MolecularEntity Catalyst)
   ButanetriolTrinitrate BZ - MolecularEntity
   O_O-DimethylPhosphorochloridothioate - (and MolecularEntity DialkylPhosphorochloridothioate)
   DimethylSulfoxide N-ButylamineHydrochloride - MolecularEntity
   CalciumSulfate - (and MolecularEntity Desiccant)
   AmmoniumBifluoride CyanogenChloride Chloropicrin
   EthyleneGlycolDinitrate Pyridine ChloroFluoroMethylPhosphonate - MolecularEntity
   IronTrichloride - (and MolecularEntity MetalChloride)
   t-ButylMethylKetone O_O-DimethylPhosphoramidothioate Acetylene
   EthyleneSulfide - MolecularEntity
   PhosphorusTriiodide - MolecularEntity
   N_N-DiethylguanidiniumNitrate - (and MolecularEntity N_N-DiethylguanidiniumSalt)
   _246-Trinitrophenylmethylnitramine - (and MolecularEntity DetonatorExplosive SecondaryExplosive)
   PotassiumPropylthiolate - (and MolecularEntity MetalIAlkylthiolate)
   TrimethylamineHydrofluoride - (and MolecularEntity TrialkylamineHydrofluoride)
   S-MethylIsothiouroniumChloride - (and MolecularEntity S-AlkylIsothiouroniumChloride)
   HypochlorousAcid SodiumPerchlorate - MolecularEntity
   MercuryFulminate - (and MolecularEntity PrimaryExplosive)
   UraniumTetrafluoride - (and MolecularEntity FluorideOfUranium)
   SilverIIFluoride - MolecularEntity
   IsouroniumNitrate - (and MolecularEntity IsouroniumSalt)
   Propylene EthylAcetimidateHydrochloride - MolecularEntity
   SodiumMethylthiolate - (and MolecularEntity MetalIAlkylthiolate)
   MagnesiumSulfate - MolecularEntity
   N_N-DiethylguanidiniumEthylSulfate - (and MolecularEntity N_N-DiethylguanidiniumAlkylSulfate)
   CalciumCyanide - (and MolecularEntity MetalCyanide)
   CalciumChloride - (and ChemicalPrecipitant MolecularEntity Desiccant)
   PotassiumHydrogenSulfate - (and MetalIHydrogenSulfate MolecularEntity)
   SodiumTetraborateDecahydrate Cyanamide - MolecularEntity
   DibutylMethylphosphonate - MolecularEntity
   CopperBromide - (and MolecularEntity CopperIHalide)
   CyanogenBromide - MolecularEntity
   Erythromycin - (and MolecularEntity Antibiotic)
   SodiumSulfide - (and MolecularEntity MetalSulfide)
   p-Nitrotoluene AceticAnhydride DiethylamineHydrochloride - MolecularEntity
   Chloropropane - (and MolecularEntity Chloroalkane)
   Ethylene ManganeseHydroxide DimethylPhosphoramidate
   Methamidophos DiisopropylMethylphosphonate Isopropanol - MolecularEntity
   TriacetoneTriperoxide - (and MolecularEntity PrimaryExplosive)
   AmmoniumThiocyanate - MolecularEntity
   Papain - (and MolecularEntity Protease)
   Trichloroacetaldehyde DiethylacetamideDiethylacetal - MolecularEntity
   IronSulfide - (and MolecularEntity MetalSulfide)
   ToluidineBlue EthylDichlorophosphate Tetrafluorosilane
   DimethylAmine - MolecularEntity
   EthylHydrogenSulfate - (and MolecularEntity AlkylHydrogenSulfate)
   IsouroniumHydrochloride - (and MolecularEntity IsouroniumSalt)
   N_N-DiethylCyanamide _12-Dichloroethylene AscorbicAcid - MolecularEntity
   _246-Trinitroresorcinol - (and ChemicalExplosive MolecularEntity)
   CesiumSulfide - (and MolecularEntity MetalSulfide)
   PotassiumNitrate - (and MolecularEntity MetalINitrate)
   ThiophosphorylChloride Diphenylcyanoarsine CopperHydroxide
   t-ButylChloride - MolecularEntity
   dATP - (and MolecularEntity dNTP)
   FormamidineSulfinicAcid MethylAcetate O_O-DiethylPhosphoramidothioate - MolecularEntity
   TripropylamineHydrofluoride - (and MolecularEntity TrialkylamineHydrofluoride)
   _2-Mercaptoethanol StearicAcid SodiumOxalate
   Thiourea - MolecularEntity
   dCTP - (and MolecularEntity dNTP)
   _23-dimethylbutane-23-diol Dibutylphthalate Diazepam - MolecularEntity
   S-EthylIsothiouroniumChloride - (and MolecularEntity S-AlkylIsothiouroniumChloride)
   PotassiumChloride - (and MolecularEntity MetalIChloride)
   DiethylacetamideDimethylacetal FormamidineSulfonicAcid - MolecularEntity
   S-MethylIsothiouroniumMethylSulfate - (and MolecularEntity S-AlkylIsothiouroniumAlkylSulfate)
   Bis-2-ChloroethylthioEthylEther CarbamimidicAcidHydrochloride - MolecularEntity
   TungstenCarbide - (and MolecularEntity MetalCarbide)
   SiliconDioxide - MolecularEntity
   UraniumTetrachloride - (and MolecularEntity ChlorideOfUranium)
   MercuricSulfide - (and MolecularEntity MetalSulfide)
   CalciumHydroxide - MolecularEntity
   Streptomycin - (and MolecularEntity Antibiotic)
   O_O-DiethylPhosphonothioate - (and MolecularEntity DialkylPhosphonothioate)
   MethylDifluorophosphate Sarin - MolecularEntity
   O_S-DiethylPhosphorochloridothioate - (and MolecularEntity DialkylPhosphorochloridothioate)
   AcetylFluoride - MolecularEntity
   CrystalViolet TrimethylsilylCyanide Isopropylamine
   Nitroguanidine DiphosphorusPentasulfide SulfurDioxide - MolecularEntity
   S-MethylIsothiourea - (and MolecularEntity S-AlkylIsothiourea)
   PhenylDichloroarsine - MolecularEntity
   SodiumAcetate - (and ChemicalPrecipitant MolecularEntity)
   Tetra-n-butylammoniumFluoride - MolecularEntity
   _246-TrinitroMXylene - (and MolecularEntity SecondaryExplosive)
   Cyclohexanol AmmoniumChloride - MolecularEntity
   LithiumCyanide - (and MolecularEntity MetalCyanide)
   SulfuricAcid - (and MolecularEntity ToxinPrecipitant StrongAcid)
   Acetone - MolecularEntity
   CalciumSulfide - (and MolecularEntity MetalSulfide)
   HydrogenPeroxide - MolecularEntity
   ChymotrypsinogenA - (and MolecularEntity Protease)
   SYBRGreen1 AmmoniumPerchlorate SodiumMethylate - MolecularEntity
   Proline - (and MolecularEntity ViralStabilizerAminoAcid)
   Mannitol - (and MolecularEntity SolidsDryingChemical SugarAlcohol)
   TrimethylsilylChloride CalciumGluconate MethylBromide
   Trichloroethylene DimethylMethylPhosphonate UraniumIIIHydride - MolecularEntity
   S-MethylIsothiouroniumHydrogenSulfate - (and MolecularEntity S-AlkylIsothiouroniumHydrogenSulfate)
   SodiumCyanide - (and MolecularEntity MetalCyanide)
   IsopropylEthylphosphonofluoridate - MolecularEntity
   LeadAzide - (and MolecularEntity PrimaryExplosive)
   N_N-DiethylguanidiniumIodide - (and MolecularEntity N_N-DiethylguanidiniumSalt)
   CyclohexylMethylphosphonochloridate - MolecularEntity
   Diazodinitrophenol - (and MolecularEntity PrimaryExplosive)
   CalciumFluoride ThiodiglycolSulfone Tris-2-chloroethenylarsine - MolecularEntity
   TriuraniumOctoxide - (and MolecularEntity OxideOfUranium)
   AntimonyTrichloride - (and MolecularEntity MetalChloride)
   SodiumBicarbonate - MolecularEntity
   Triethylamine - (and MolecularEntity TrialkylAmine)
   DimethylEther - MolecularEntity
   PlutoniumIVOxalateHexahydrate - (and MolecularEntity OxalateOfPlutonium)
   SodiumDiuranate DichloroethylMethylamine - MolecularEntity
   PlutoniumHexafluoride - (and MolecularEntity FluorideOfPlutonium)
   EthylBromide MagnesiumHydroxide - MolecularEntity
   O-MethylIsouroniumChloride - (and MolecularEntity O-AlkylIsouroniumChloride)
   AmmoniumNitrate - (and MolecularEntity SecondaryExplosive)
   PotassiumMonoFluorophosphate N_N-Diisopropylurea - MolecularEntity
   N_N-DiethylguanidiniumSulfate - (and MolecularEntity N_N-DiethylguanidiniumSalt)
   MercuryIIChloride - (and MolecularEntity MetalChloride)
   MethylDichlorophosphate Urea - MolecularEntity
   AluminumChloride - (and MolecularEntity MetalChloride)
   Octogen - (and MolecularEntity SecondaryExplosive)
   SodiumPropylthiolate - (and MolecularEntity MetalIAlkylthiolate)
   Glycerol - (and MolecularEntity SolventDryingChemical SugarAlcohol)
   dTTP - (and MolecularEntity dNTP)
   PyridostigmineBromide - MolecularEntity
   LeadStyphnateBasic - (and MolecularEntity PrimaryExplosive)
   _1_2-Bis-2-ChloroethylthioEthane MalachiteGreen SulfurDichloride
   PinacolylMethylphosphonochloridate CeriumBromide - MolecularEntity
   UraniumTrichloride - (and MolecularEntity ChlorideOfUranium)
   Chymotrypsin - (and MolecularEntity Protease)
   BariumPerchlorate - MolecularEntity
   PentaerythritolTetranitrate - (and MolecularEntity DetonatorExplosive SecondaryExplosive)
   CarbonDioxide - MolecularEntity
   DryIce - CarbonDioxide
   PotassiumTellurite MethyleneBlue - MolecularEntity
   Nitroglycerin - (and MolecularEntity PrimaryExplosive)
   PotassiumCarbonate DiisopropylCarbodiimide - MolecularEntity
   MolybdenumDisulfide - (and MolecularEntity MetalSulfide DisulfideCompound)
   Safranin DipotassiumPhosphate DiethylAmine - MolecularEntity
   Hexanitrostilbene - (and MolecularEntity SecondaryExplosive)
   Diaminotrinitrobenzene MethylFluorophosphonicAcid NitricOxide
   TriethyleneGlycolDinitrate - MolecularEntity
   MethylHydrogenSulfate - (and MolecularEntity AlkylHydrogenSulfate)
   PotassiumCyanide - (and MolecularEntity MetalCyanide)
   _2-MethylIsoureaHydrobromide - (and MolecularEntity O-AlkylIsouroniumHydrohalide)
   PotassiumDinitrobenzofuroxane - (and MolecularEntity PrimaryExplosive)
   Diphosgene - MolecularEntity
   SodiumBromide - (and MolecularEntity SodiumHalide)
   PotassiumBicarbonate - MolecularEntity
   DimethylSulfate - (and MolecularEntity MethylatingAgent DialkylSulfate)
   Benzene - MolecularEntity
   MethylChloride - (and MolecularEntity Chloroalkane)
   AnilineDye Cyclosarin MethylMethacrylate
   Propan-2-ylMethylphosphonochloridate IsouroniumHydrogenSulfate - MolecularEntity
   S-MethylIsothiouroniumIodide - (and MolecularEntity S-AlkylIsothiouroniumHalide)
   MonomethylCarbonate ManganeseDioxide - MolecularEntity
   PotassiumButylthiolate - (and MolecularEntity MetalIAlkylthiolate)
   NitrogenDioxide - MolecularEntity
   TributylamineHydrofluoride - (and MolecularEntity TrialkylamineHydrofluoride)
   DimethylChloroPhosphite - (and MolecularEntity DialkylChloroPhosphite)
   TitaniumDioxide - (and MolecularEntity OxideOfTitanium)
   N_N-DiethylguanidiniumHydrogenSulfate - (and MolecularEntity N_N-DiethylguanidiniumSalt)
   HydrogenCyanide Hydroxyproline ThoriumDioxide
   MethylChlorofluorophosphate Bromobenzene Dichloromethane - MolecularEntity
   ManganeseChloride - (and MolecularEntity MetalChloride)
   BenzoicAcid CalciumCarbonate _14-bis2-hydroxyethylthiobutane - MolecularEntity
   PlutoniumTrifluoride - (and MolecularEntity FluorideOfPlutonium)
   Triaminotrinitrobenzene - MolecularEntity
   Sorbitol - (and MolecularEntity ViralStabilizerSugarAlcohol)
   LanthanumChloride - (and MolecularEntity MetalChloride)
   PropylCarbamate - (and MolecularEntity AlkylCarbamate)
   DimethylPhosphonate - MolecularEntity
   EDTA - (and MolecularEntity ChelatingAgent)
   EthylFluoride - MolecularEntity
   S-EthylIsothiouroniumHydrogenSulfate - (and MolecularEntity S-AlkylIsothiouroniumHydrogenSulfate)
   _246-TrinitroMCresol - (and MolecularEntity SecondaryExplosive)
   PotassiumFluoride EthylDichloroarsine - MolecularEntity
   AntimonyMethylthiolate - (and MolecularEntity AntimonyAlkylthiolate)
   t-ButylHydroperoxide CyanogenIodide - MolecularEntity
   UraniumTetraoxide - (and MolecularEntity OxideOfUranium)
   MethylPhosphonicDifluoride - (and MolecularEntity AlkylPhosphonicDifluoride)
   S-EthylIsothiourea - (and MolecularEntity S-AlkylIsothiourea)
   PlutoniumTrichloride - (and MolecularEntity MetalChloride)
   SodiumEthoxide Toluene Centralite
   PotassiumIodide N_N-DiethylguanidiniumHydrogenSulfoxylate MethylDichloroarsine
   PhosphorusOxychloride - MolecularEntity
   dGTP - (and MolecularEntity dNTP)
   AntimonyEthylthiolate - (and MolecularEntity AntimonyAlkylthiolate)
   TriethylammoniumPropylthiolate - (and MolecularEntity TriethylammoniumAlkylthiolate)
   IronChloride - (and MolecularEntity Catalyst MetalChloride)
   Chloroform - MolecularEntity
   S-EthylIsothiouroniumEthylSulfate - (and MolecularEntity S-AlkylIsothiouroniumAlkylSulfate)
   SulfurylChloride - MolecularEntity
   DiethylChloroPhosphite - (and MolecularEntity DialkylChloroPhosphite)
   PhosphoricAcid - MolecularEntity
   PlutoniumIVPeroxide - (and MolecularEntity OxideOfPlutonium)
   TriethylAluminum CR - MolecularEntity
   TriethylammoniumButylthiolate - (and MolecularEntity TriethylammoniumAlkylthiolate)
   TrimethylamineHydrochloride - (and MolecularEntity TrialkylamineHydrochloride)
   _2-MethylIsoureaHydroiodide - (and MolecularEntity O-AlkylIsouroniumHydrohalide)
   _1-4-Thioxane-1-1-dioxide - MolecularEntity
   O-MethylIsouroniumMethylSulfate - (and MolecularEntity O-AlkylIsouroniumAlkylSulfate)
   AmmoniumPhosphate - MolecularEntity
   Ethane - (and MolecularEntity Alkane)
   AcetylChloride - MolecularEntity
   TriethylPhosphite - (and MolecularEntity TrialkylPhosphite)
   S-MethylIsothiouroniumBromide - (and MolecularEntity S-AlkylIsothiouroniumHalide)
   PotassiumMethoxide Vx - MolecularEntity
   Alanine - (and MolecularEntity ViralStabilizerAminoAcid)
   PotassiumIsopropoxide - MolecularEntity
   CeriumSulfide - (and MolecularEntity MetalSulfide)
   MethylAcetimidateHydrochloride - MolecularEntity
   PotassiumEthylSulfate - (and MolecularEntity PotassiumAlkylsulfate)
   TributylamineHydrochloride - (and MolecularEntity TrialkylamineHydrochloride)
   O-EthylIsouroniumChloride - (and MolecularEntity O-AlkylIsouroniumChloride)
   Naphthalene - (and MolecularEntity Catalyst)
   Acephate - MolecularEntity
   L-Glutamine - (and MolecularEntity Glutamine)
   NitrogenGas - (and MolecularEntity InertGas)
   Tripropylamine - (and MolecularEntity TrialkylAmine)
   Haleite Diphenylchloroarsine - MolecularEntity
   PotassiumSulfate - (and MolecularEntity MetalSulfate)
   Lithium-6Deuteride Cytosine - MolecularEntity
   Histidine - (and MolecularEntity ViralStabilizerAminoAcid)
   CeriumChloride - (and MolecularEntity MetalChloride)
   SodiumSulfate - MolecularEntity
   Cyclotrimethylenetrinitramine - (and MolecularEntity SecondaryExplosive)
   LeadMononitroresorcinate - (and MolecularEntity PrimaryExplosive)
   MethylEthylSulfate BariumBromideDihydrate - MolecularEntity
   MethylFormate - MolecularEntity
   PhosphorousAcid PotassiumPermanganate PhosphorisocyanatidicDichloride
   MethylEthylKetone PhosgeneOxime - MolecularEntity
   DiethylSulfate - (and MolecularEntity DialkylSulfate)
   Phosphorocyanidate - MolecularEntity
   PotassiumThiocyanate - (and MolecularEntity MetalThiocyanate)
   Uracil EthyleneOxide PhosphorusPentachloride - MolecularEntity
   O-EthylIsouroniumEthylSulfate - (and MolecularEntity O-AlkylIsouroniumAlkylSulfate)
   Phosgene _2-2-hydroxyethylthioethylBenzoate Oxygen
   Atropine - MolecularEntity
   O_O-DimethylPhosphonothioate - (and MolecularEntity DialkylPhosphonothioate)
   S-EthylIsothiouroniumIodide - (and MolecularEntity S-AlkylIsothiouroniumHalide)
   Fluorodichlorophosphonate AntimonyPentafluoride - MolecularEntity
   EthylCarbamate - (and MolecularEntity AlkylCarbamate)
   TriethylammoniumMethylthiolate - (and MolecularEntity TriethylammoniumAlkylthiolate)
   N_N-Diethylguanidine PotassiumBisulfate - MolecularEntity
   DiTrimethylsilylEther - (and MolecularEntity Solvent)
   SodiumPhosphate - MolecularEntity
   dUTP - (and MolecularEntity dNTP)
   DipinacolylMethylphosphonate Cyclohexane PinacolylAlcohol
   Pralidoxime SodiumFluoride DimethylMethylPhosphonite
   HafniumOxide TrimethylolethaneTrinitrate - MolecularEntity
   N_N-DiethylguanidiniumFluoride - (and MolecularEntity N_N-DiethylguanidiniumSalt)
   CopperChloride - (and MolecularEntity Catalyst CopperIHalide MetalChloride)
   ChlorineGas Formamide CalciumHypochlorite
   MagnesiumSilicate _11-Dichloroethane - MolecularEntity
   UraniumPentachloride - (and MolecularEntity ChlorideOfUranium)
   UraniumTrioxide - (and MolecularEntity OxideOfUranium)
   PotassiumMethylthiolate - (and MolecularEntity MetalIAlkylthiolate)
   N_N-DiethylguanidineHydrochloride - (and MolecularEntity N_N-DiethylguanidiniumSalt)
   MagnesiumChloride - MolecularEntity
   SiliconCarbide - (and MolecularEntity MetalCarbide)
   HydrogenGas CarbonTetrachloride MethylPhosphonicDichloride
   CarbonMonoxide - MolecularEntity
   SodiumButylthiolate - (and MolecularEntity MetalIAlkylthiolate)
   MethylChloroformate _12-Dichloroethane - MolecularEntity
   O_S-DimethylPhosphorodithioate - (and MolecularEntity DialkylPhosphorodithioate)
   Citrulline - MolecularEntity
   MagnesiumChlorideHexahydrate - (and MolecularEntity MagnesiumChlorideHydrate)
   PlutoniumCarbide - (and MolecularEntity MetalCarbide)
   _2-ChloroethanesulfenylChloride IsopropylamineHydrochloride - MolecularEntity
   S-EthylIsothiouroniumSulfate - (and MolecularEntity S-AlkylIsothiouroniumSulfate)
   PinacolylMethylphosphonicAcid - MolecularEntity
   TriethylammoniumEthylthiolate - (and MolecularEntity TriethylammoniumAlkylthiolate)
   DiethylPhosphonate - MolecularEntity
   AluminumSulfide - (and MolecularEntity MetalSulfide)
   O_O-DiethylPhosphorodithioate - (and MolecularEntity DialkylPhosphorodithioate)
   _12-bis2-hydroxyethylthioethane - MolecularEntity
   S-MethylIsothiouroniumSulfate - (and MolecularEntity S-AlkylIsothiouroniumSulfate)
   CarbonDisulfide - (and MolecularEntity DisulfideCompound)
   Trimethylamine - (and MolecularEntity TrialkylAmine)
   _246-Trinitromesitylene - (and MolecularEntity SecondaryExplosive)
   _2-Chloroethanol CopperChlorideDihydrate Formaldehyde
   EthylIodide Acrylonitrile - MolecularEntity
   _2-EthylIsoureaHydroiodide - (and MolecularEntity O-AlkylIsouroniumHydrohalide)
   EthylMethylphosphonicAcid - MolecularEntity
   Trypsin - (and MolecularEntity Protease)
   EthylenediamineDinitrate MethylMethylphosphonicAcid CalciumCyanamide - MolecularEntity
   EthylCarbamimidothioate - (and MolecularEntity AlkylCarbamimidothioate)
   MercuryIICyanide - (and MolecularEntity MetalCyanide)
   PlutoniumIVOxalate - (and MolecularEntity OxalateOfPlutonium)
   CalciumOxide - (and MolecularEntity Desiccant)
   Triphosgene - MolecularEntity
   _224466-Hexanitroazobenzene - (and MolecularEntity SecondaryExplosive)
   PotassiumHydroxide - (and MolecularEntity MetalIHydroxide)
   Novobiocin - (and MolecularEntity Antibiotic)
   LeadStyphnate - (and MolecularEntity PrimaryExplosive)
   EthyleneCarbonate MethylPhosphonicAcid SilverMethylSulfide
   Amiton - MolecularEntity
   Nitrocellulose - (and Propellant MolecularEntity)
   AmmoniumPicrate - (and MolecularEntity SecondaryExplosive)
   SilverEthylthiolate - (and MolecularEntity SilverAlkylthiolate)
   ThiamineHydrochloride - MolecularEntity
   EthylPhosphonicDifluoride - (and MolecularEntity AlkylPhosphonicDifluoride)
   ThionylChloride BariumBromide CalciumSilicate
   N_N-DiethylguanidiniumHydrogenBisulfite PhosphorisocyanatidicDifluoride ZirconiumOrthosilicate
   PhosphorusTrifluoride - MolecularEntity
   MethylCarbamate - (and MolecularEntity AlkylCarbamate)
   EthylSulfonicAcid - (and MolecularEntity AlkylsulfonicAcid)
   Tetraethoxysilane Acetaldehyde - MolecularEntity
   BariumChloride - (and MolecularEntity MetalChloride)
   SodiumEthylthiolate - (and MolecularEntity MetalIAlkylthiolate)
   _112-Trichloroethane - MolecularEntity
   TripropylamineHydrochloride - (and MolecularEntity TrialkylamineHydrochloride)
   CopperIodide - (and MolecularEntity CopperIHalide)
   S-EthylIsothiouroniumBromide - (and MolecularEntity S-AlkylIsothiouroniumHalide)
   CalciumPlutoniumHexafluoride - (and MolecularEntity FluorideOfPlutonium)
   UraniumCarbide - (and MolecularEntity CarbideOfUranium)
   DiethylammoniumAcetate Tetracene - MolecularEntity
   SodiumChloride - (and MolecularEntity SodiumHalide MetalIChloride)
   Tetra-n-butylammoniumChloride O-MethylIsoureaBisulfate _2-dimethylamino-ethyl-dimethylphosphoramido-fluoridate
   SilverIFluoride - MolecularEntity
   Nitromethane - (and Propellant MolecularEntity)
   PlutoniumTetrafluoride - (and MolecularEntity FluorideOfPlutonium)
   DiacetoneDiperoxide - MolecularEntity
   Chloroethane - (and MolecularEntity Chloroalkane)
   Methane - (and MolecularEntity Alkane)
   PotassiumEthylthiolate - (and MolecularEntity MetalIAlkylthiolate)
   OxalicAcid AntimonyChlorideTetrafluoride N-Butylamine - MolecularEntity
   _246-Trinitroaniline - (and MolecularEntity PrimaryExplosive)
   Sugar - ChemicalEntity
   Dextrose - (and Sugar MolecularEntity SolidsDryingChemical)
   Agarose - (and Sugar MolecularEntity)
   ViralStabilizerSugar - Sugar
   Glucose - (and ViralStabilizerSugar MolecularEntity)
   Sucrose - (and ViralStabilizerSugar MolecularEntity SolidsDryingChemical)
   Lactose - (and ViralStabilizerSugar MolecularEntity SolidsDryingChemical)
   Trehalose - (and ViralStabilizerSugar MolecularEntity SolidsDryingChemical)
   Dextran - ViralStabilizerSugar
   RefractoryOxide - ChemicalEntity
   MagnesiumOxide - (and RefractoryOxide MolecularEntity)
   MagnesiumZirconate - (and RefractoryOxide MolecularEntity)
   BerylliumOxide - (and RefractoryOxide MolecularEntity)
   AluminumOxide - (and RefractoryOxide MolecularEntity Catalyst)
   CalciumZirconate - (and RefractoryOxide MolecularEntity)
   ErbiumOxide - (and RefractoryOxide MolecularEntity)
   Spinel - (and RefractoryOxide MolecularEntity)
   UraniumDioxide - (and RefractoryOxide MolecularEntity OxideOfUranium)
   YittriumOxide - (and RefractoryOxide MolecularEntity)
   ZirconiumDioxide - (and RefractoryOxide MolecularEntity)
   Alkylthiol - ChemicalEntity
   Methylthiol - (and Alkylthiol MolecularEntity)
   Ethylthiol - (and Alkylthiol MolecularEntity)
   Bromelain - (and ChemicalEntity Protease)
   AlkylHalide DiethylacetamideDialkylAcetal AlkylIsothiouroniumSalt
   Tri-n-PropylAmmoniumChloride - ChemicalEntity
   AlkylIodide AlkylChloride - AlkylHalide
   PropylIodide - (and MolecularEntity AlkylIodide)
   ButylIodide - (and MolecularEntity AlkylIodide)
   AlkylBromide - AlkylHalide
   Bromoethane - (and MolecularEntity AlkylBromide)
   ButylBromide - (and MolecularEntity AlkylBromide)
   PropylBromide - (and MolecularEntity AlkylBromide)
   Alcohol Halogen - ChemicalEntity
   Methanol - (and Alcohol MolecularEntity SugarAlcohol)
   Ethanol - (and Alcohol MolecularEntity)
   EthylEthers OrganoNitrile - ChemicalEntity
   Aspartate - (and ViralStabilizerAminoAcid ChemicalEntity))
  (:predicates
    (hasComposition ?a ?b - object)
    (hasSmell ?a ?b - object)
    (ContaminatedWith ?a ?b - object)))

