

(define
 (problem mealPlanningPantry)
 (:domain mealPlanningPantry)
 (:objects walmart1 - SUPPLIER traditionalSplitPeaWithHam_Progresso1 spaghettiRingsPastaWithMeatballs_GreatValue1 macAndCheese_ChefBoyardee1 chickenNoodeSoup_GreatValue1 beefRavioli_ChefBoyardee1 - INSTANCE andrewDougherty - AGENT)
 (:init
  (= (calories beefRavioli_ChefBoyardee1) 460.0)
  (= (calories chickenNoodeSoup_GreatValue1) 200.0)
  (= (calories macAndCheese_ChefBoyardee1) 420.0)
  (= (calories spaghettiRingsPastaWithMeatballs_GreatValue1) 460.0)
  (= (calories traditionalSplitPeaWithHam_Progresso1) 280.0))
 (:goal
  (and
   (consumed-by-agent macAndCheese_ChefBoyardee1 andrewDougherty)))
 (:metric minimize
  (caloric-intake andrewDougherty)))