

(define
 (problem mealPlanningPantry)
 (:domain mealPlanningPantry)
 (:objects walmart1 - SUPPLIER traditionalSplitPeaWithHam_Progresso1 spaghettiRingsPastaWithMeatballs_GreatValue1 macAndCheese_ChefBoyardee1 chickenNoodeSoup_GreatValue1 beefRavioli_ChefBoyardee1 - INSTANCE andrewDougherty - AGENT)
 (:init
  (= (caloricIntake andrewDougherty) 0.0)
  (= (calories beefRavioli_ChefBoyardee1) 460.0)
  (= (calories chickenNoodeSoup_GreatValue1) 200.0)
  (= (calories macAndCheese_ChefBoyardee1) 420.0)
  (= (calories spaghettiRingsPastaWithMeatballs_GreatValue1) 460.0)
  (= (calories traditionalSplitPeaWithHam_Progresso1) 280.0)
  (notConsumed beefRavioli_ChefBoyardee1)
  (notConsumed chickenNoodeSoup_GreatValue1)
  (notConsumed macAndCheese_ChefBoyardee1)
  (notConsumed spaghettiRingsPastaWithMeatballs_GreatValue1)
  (notConsumed traditionalSplitPeaWithHam_Progresso1))
 (:goal
  (and
   (replete andrewDougherty)))
 (:metric minimize
  (caloricIntake andrewDougherty)))