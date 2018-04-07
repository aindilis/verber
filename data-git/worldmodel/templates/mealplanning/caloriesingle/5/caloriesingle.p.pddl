;; <problem-file>

;; (generate the pantry problem from the pantry contents, so as to
;;  limit the number of entries, as opposed to all possible)

;; ((Home Storage Solutions 101: A place for everything that matters)

;;  ((Fresh Food Stoage Guidelines for Refrigerator {Cheat Sheet})
;;   (Freezer Storage Times {Cheat Sheet})
;;   (Pantry Food Storage Chart: Common Shelf Life {Cheat Sheet})

;;   (Michigan Availability Guide (Vegetables))
;;   (Michigan Availability Guide (Fruits))
;;   (What should be discarded after a power outage)

;;   ))


(define (problem mealPlanningPantry)

 (:domain mealPlanningPantry)

 ;; (:includes)

 ;; (:timing
 ;;  (start-date TZID=America/Chicago:20161228T010000)
 ;;  (units 0000-00-00_01:00:00)
 ;;  )

 (:objects
  shepherdsPieRecipe - RECIPE
  russetPotatoes halfAndHalf unsaltedButter kosherSalt freshlyGroundBlackPepper eggYolk - INGREDIENT
  krogerRussetPotatoes krogerHalfAndHalf krogerUnsaltedButter krogerKosherSalt krogerFreshlyGroundBlackPepper krogerDozenEggs - PRODUCT
  krogerRussetPotatoes1 krogerHalfAndHalf1 krogerUnsaltedButter1 krogerKosherSalt1 krogerFreshlyGroundBlackPepper1 krogerDozenEggs1 - INSTANCE
  i1 i2 i3 i4 i5 i6 i7 i8 i9 i10 i11 i12 i13 i14 i15 i16 i17 i18 i19 i20 i21 i22 i23 i24 i25 i26 i27 i28 i29 i30 i31 i32 i33 i34 i35 i36 i37 i38 i39 i40 - INSTANCE
  pounds cups ounces teaspoons item - UNIT
  pantry fridge freezer - LOCATION
  kroger1 - SUPPLIER
  )

 (:init
  ;; HAS INGREDIENT
  (hasIngredient shepherdsPieRecipe russetPotatoes)
  (hasIngredient shepherdsPieRecipe halfAndHalf)
  (hasIngredient shepherdsPieRecipe unsaltedButter)
  (hasIngredient shepherdsPieRecipe kosherSalt)
  (hasIngredient shepherdsPieRecipe freshlyGroundBlackPepper)
  (hasIngredient shepherdsPieRecipe eggYolk)

  ;; HAS INGREDIENT AMOUNT
  (= (hasIngredientAmount shepherdsPieRecipe russetPotatoes pounds) 1.5)
  (= (hasIngredientAmount shepherdsPieRecipe halfAndHalf cups) 0.25)
  (= (hasIngredientAmount shepherdsPieRecipe unsaltedButter ounces) 2)
  (= (hasIngredientAmount shepherdsPieRecipe kosherSalt teaspoons) 0.75)
  (= (hasIngredientAmount shepherdsPieRecipe freshlyGroundBlackPepper teaspoons) 0.25)
  (= (hasIngredientAmount shepherdsPieRecipe eggYolk item) 1)

  ;; PRODUCT CONTAINS
  (productContains krogerRussetPotatoes russetPotatoes)
  (productContains krogerHalfAndHalf halfAndHalf)
  (productContains krogerUnsaltedButter unsaltedButter)
  (productContains krogerKosherSalt kosherSalt teaspoons)
  (productContains krogerFreshlyGroundBlackPepper freshlyGroundBlackPepper)
  (productContains krogerDozenEggs eggYolk)

  ;; PRODUCT CONTAINS AMOUNT
  (= (productContainsAmount krogerRussetPotatoes russetPotatoes pounds) 3)
  (= (productContainsAmount krogerHalfAndHalf halfAndHalf cups) 2)
  (= (productContainsAmount krogerUnsaltedButter unsaltedButter ounces) 16)
  (= (productContainsAmount krogerKosherSalt kosherSalt teaspoons) 130)
  (= (productContainsAmount krogerFreshlyGroundBlackPepper freshlyGroundBlackPepper teaspoons) 15)
  (= (productContainsAmount krogerDozenEggs eggYolk item) 12)

  ;; PRODUCT COSTS
  (= (costs krogerRussetPotatoes kroger1) 3.99)
  (= (costs krogerHalfAndHalf kroger1) 1.69)
  (= (costs krogerUnsaltedButter kroger1) 2.69)
  (= (costs krogerKosherSalt kroger1) 2.69)
  (= (costs krogerFreshlyGroundBlackPepper kroger1) 4.99)
  (= (costs krogerDozenEggs kroger1) 0.86)

  ;; INSTANCES OF PRODUCT
  (instanceFn krogerRussetPotatoes krogerRussetPotatoes1)
  (instanceFn krogerHalfAndHalf krogerHalfAndHalf1)
  (instanceFn krogerUnsaltedButter krogerUnsaltedButter1)
  (instanceFn krogerKosherSalt krogerKosherSalt1)
  (instanceFn krogerFreshlyGroundBlackPepper krogerFreshlyGroundBlackPepper1)
  (instanceFn krogerDozenEggs krogerDozenEggs1)

  ;; STORAGE LOCATION OF INSTANCES
  (storage_location krogerRussetPotatoes1 pantry)
  (storage_location krogerHalfAndHalf1 fridge)
  (storage_location krogerUnsaltedButter1 fridge)
  (storage_location krogerKosherSalt1 pantry)
  (storage_location krogerFreshlyGroundBlackPepper1 pantry)
  (storage_location krogerDozenEggs1 fridge)
  
  ;; INSTANCE REMAINING AMOUNT
  (= (instanceRemainingAmount krogerRussetPotatoes1 russetPotatoes pounds) 3)
  (= (instanceRemainingAmount krogerHalfAndHalf1 halfAndHalf cups) 2)
  (= (instanceRemainingAmount krogerUnsaltedButter1 unsaltedButter ounces) 16)
  (= (instanceRemainingAmount krogerKosherSalt1 kosherSalt teaspoons) 130)
  (= (instanceRemainingAmount krogerFreshlyGroundBlackPepper1 freshlyGroundBlackPepper teaspoons) 15)
  (= (instanceRemainingAmount krogerDozenEggs1 eggYolk item) 12)
  )

 (:goal
  
  )
 
 (:metric (minimize (total-cost)))
 
 )

;; </problem-file>
