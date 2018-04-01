

(define
 (problem flpInventory1)
 (:domain flpInventory)
 (:objects venomEnergyDrinks - type meredithsRoom downstairsComputerRoom - location meredithMcGhan andrewDougherty - agent)
 (:init
  (= (has-inventory venomEnergyDrinks meredithsRoom) 2)
  (has-location andrewDougherty meredithsRoom))
 (:goal
  (and
   (out-of-type venomEnergyDrinks meredithsRoom)))
 (:metric minimize
  (has-inventory venomEnergyDrinks meredithsRoom)))