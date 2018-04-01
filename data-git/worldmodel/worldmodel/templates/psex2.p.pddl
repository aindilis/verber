(define
 (problem PSEX2)
 (:domain PSEX2)
 (:includes)
 (:objects When_Eva_comes_over_on_Monday__drive_to_Staples_and_have_it_replaced_ Upload_the_packages_ Sign_the_packages_ Scan_my_diet_ Scan_all_receipts_ Read_a_book_on_paperwork_management_ Read_a_book_on_organization_ Populate_inventory_manager Order_a_new_set_of_keys_ Make_an_inventory_management_system_ Make_a_list_of_all_maintenance_goals_ Make_a_categories_interface_for_paperwork_ Highlight_circular_dependencies__and_have_a_wizard_for_resolving_them_ Have_system_to_track_which_piles_or_documents_have_already_been_scanned__etc_ Go_through_and_clean_my_paperwork_ Get_the_chair_replaced_ Get_the_Android_FRDCSA_Client_working_ Get_day_to_day_life_planner_working_ Get_a_chair_upstairs_ Generate_a_signing_key_ Find_the_warranty_and_replacement_info_for_the_chair_ Find_Ben_s_warranty_ Develop_tools_to_intelligently_segment_paperwork_after_scanning_it_ Create_a_new_set_of_keys_ Automatically_log_circular_dependencies_with_SPSE2_ Add_inventory_from_one_room_ Add_a_comment_syntax_to_SPSE2__so_that_you_can_mark_different_goals_in_notes_ - pse-entry andy - person)
 (:init
  (= (budget andy) 500)
  (= (duration When_Eva_comes_over_on_Monday__drive_to_Staples_and_have_it_replaced_) 6)
  (depends Add_inventory_from_one_room_ Make_an_inventory_management_system_)
  (depends Automatically_log_circular_dependencies_with_SPSE2_ Add_a_comment_syntax_to_SPSE2__so_that_you_can_mark_different_goals_in_notes_)
  (depends Automatically_log_circular_dependencies_with_SPSE2_ Highlight_circular_dependencies__and_have_a_wizard_for_resolving_them_)
  (depends Find_Ben_s_warranty_ Go_through_and_clean_my_paperwork_)
  (depends Find_the_warranty_and_replacement_info_for_the_chair_ Go_through_and_clean_my_paperwork_)
  (depends Generate_a_signing_key_ Create_a_new_set_of_keys_)
  (depends Get_a_chair_upstairs_ Get_the_chair_replaced_)
  (depends Get_day_to_day_life_planner_working_ Make_a_list_of_all_maintenance_goals_)
  (depends Get_the_Android_FRDCSA_Client_working_ Make_an_inventory_management_system_)
  (depends Get_the_chair_replaced_ Find_the_warranty_and_replacement_info_for_the_chair_)
  (depends Get_the_chair_replaced_ When_Eva_comes_over_on_Monday__drive_to_Staples_and_have_it_replaced_)
  (depends Go_through_and_clean_my_paperwork_ Get_a_chair_upstairs_)
  (depends Order_a_new_set_of_keys_ Find_Ben_s_warranty_)
  (depends Populate_inventory_manager Make_an_inventory_management_system_)
  (depends Scan_all_receipts_ Have_system_to_track_which_piles_or_documents_have_already_been_scanned__etc_)
  (depends Scan_my_diet_ Get_a_chair_upstairs_)
  (depends Sign_the_packages_ Generate_a_signing_key_)
  (depends Upload_the_packages_ Sign_the_packages_)
  (eases Get_a_chair_upstairs_ Get_the_Android_FRDCSA_Client_working_)
  (eases Make_an_inventory_management_system_ Have_system_to_track_which_piles_or_documents_have_already_been_scanned__etc_)
  (eases Scan_all_receipts_ Populate_inventory_manager)
  (has-time-constraints When_Eva_comes_over_on_Monday__drive_to_Staples_and_have_it_replaced_))
 (:goal
  (and
   (completed Upload_the_packages_)
   (completed Read_a_book_on_paperwork_management_)
   (completed Get_the_Android_FRDCSA_Client_working_)
   (completed Make_a_list_of_all_maintenance_goals_)
   (completed Generate_a_signing_key_)
   (completed Automatically_log_circular_dependencies_with_SPSE2_)
   (completed Get_the_chair_replaced_)
   (completed Scan_all_receipts_)
   (completed Sign_the_packages_)
   (completed Add_a_comment_syntax_to_SPSE2__so_that_you_can_mark_different_goals_in_notes_)
   (completed Read_a_book_on_organization_)
   (completed Make_an_inventory_management_system_)
   (completed Find_Ben_s_warranty_)
   (completed Order_a_new_set_of_keys_)
   (completed Find_the_warranty_and_replacement_info_for_the_chair_)
   (completed Add_inventory_from_one_room_)
   (completed Populate_inventory_manager)
   (completed Scan_my_diet_)
   (completed Create_a_new_set_of_keys_)
   (completed Make_a_categories_interface_for_paperwork_)
   (completed Go_through_and_clean_my_paperwork_)
   (completed Develop_tools_to_intelligently_segment_paperwork_after_scanning_it_)
   (completed Highlight_circular_dependencies__and_have_a_wizard_for_resolving_them_)
   (completed When_Eva_comes_over_on_Monday__drive_to_Staples_and_have_it_replaced_)
   (completed Get_a_chair_upstairs_)
   (completed Get_day_to_day_life_planner_working_)
   (completed Have_system_to_track_which_piles_or_documents_have_already_been_scanned__etc_)))
 (:metric minimize
  (total-time)))