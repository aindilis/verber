

(define
 (problem pgourmet)
 (:domain pgourmet)
 (:objects near minimize maximize - rdv_preference_type andrewDougherty - person 59b0f0b2aed9df1277deec33 - nutritionix_id trans_fatty_acid total_fat total_carbohydrate sugars sodium servings_per_container serving_size_qty saturated_fat protein iron_dv dietary_fiber cholesterol calories_from_fat calories calcium_dv - info_type)
 (:init .
  (= (nf calcium_dv 59b0f0b2aed9df1277deec33) 2)
  (= (nf calories 59b0f0b2aed9df1277deec33) 140)
  (= (nf calories_from_fat 59b0f0b2aed9df1277deec33) 18)
  (= (nf cholesterol 59b0f0b2aed9df1277deec33) 20)
  (= (nf dietary_fiber 59b0f0b2aed9df1277deec33) 2)
  (= (nf iron_dv 59b0f0b2aed9df1277deec33) 6)
  (= (nf protein 59b0f0b2aed9df1277deec33) 9)
  (= (nf saturated_fat 59b0f0b2aed9df1277deec33) 05)
  (= (nf serving_size_qty 59b0f0b2aed9df1277deec33) 1)
  (= (nf servings_per_container 59b0f0b2aed9df1277deec33) 2)
  (= (nf sodium 59b0f0b2aed9df1277deec33) 690)
  (= (nf sugars 59b0f0b2aed9df1277deec33) 2)
  (= (nf total_carbohydrate 59b0f0b2aed9df1277deec33) 22)
  (= (nf total_fat 59b0f0b2aed9df1277deec33) 2)
  (= (nf trans_fatty_acid 59b0f0b2aed9df1277deec33) 0)
  (= (rdv calcium_dv andrewDougherty) 2)
  (= (rdv calories andrewDougherty) 140)
  (= (rdv calories_from_fat andrewDougherty) 18)
  (= (rdv cholesterol andrewDougherty) 20)
  (= (rdv dietary_fiber andrewDougherty) 2)
  (= (rdv iron_dv andrewDougherty) 6)
  (= (rdv protein andrewDougherty) 9)
  (= (rdv saturated_fat andrewDougherty) 05)
  (= (rdv serving_size_qty andrewDougherty) 1)
  (= (rdv servings_per_container andrewDougherty) 2)
  (= (rdv sodium andrewDougherty) 1500)
  (= (rdv sugars andrewDougherty) 2)
  (= (rdv total_carbohydrate andrewDougherty) 22)
  (= (rdv total_fat andrewDougherty) 2)
  (= (rdv trans_fatty_acid andrewDougherty) 0)
  (brand_id 59b0f0b2aed9df1277deec33 '51db37c1176fe9790a89907e')
  (brand_name 59b0f0b2aed9df1277deec33 'Campbell_SINGLEQUOTE_s')
  (has_inventory 59b0f0b2aed9df1277deec33 discovery)
  (item_id 59b0f0b2aed9df1277deec33 '59b0f0b2aed9df1277deec33')
  (item_name 59b0f0b2aed9df1277deec33 'Chunky Soup, Chicken Tortilla with Grilled Chicken')
  (nf_serving_size_unit 59b0f0b2aed9df1277deec33 cup)
  (rdv_preference sodium andrewDougherty minimize)
  (updated_at 59b0f0b2aed9df1277deec33 '2017-09-07T07:09:42000Z'))
 (:goal
  (and
   (forall
    (?fi - foodItem)
    (and
     (not
      (and
       (ate andrewDougherty ?dts ?fi)
       (hasCarbs ?fi)))))
   (over all
    (forall
     (?account - account
      (not
       (overdrafted ?account)))))))
 (:metric minimize
  (total-time)))