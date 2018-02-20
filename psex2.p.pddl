(define
 (problem PSEX2)
 (:domain PSEX2)
 (:includes)
 (:timing
  (start-date TZID=America/Chicago:20100416T144640)
  (units 0000-00-00_01:00:00))
 (:objects install_FRDCSA_on_my_new_laptop Write_android_software Setup_core_business_processes Read_books_on_the_laptop Present_at_Flourish Order_mobile_broadband Make_adequate_money_each_month Make_a_list_of_t\
he_features_we_want_to_have_in_a_laptop Have_mobile_wireless_on_the_train Have_mobile_wireless_access_through_phone Have_dependency_reasoner_working Have_budget_analysis_system_working Have_FRDCSA_Interactive_Ex\
ecution_Monitor_working Have_1_630_300_5565_actually_work_when_I_already_have_a_phone_call__instead_of_just_ringing_endlessly Get_an_android_based_phone Get_a_new_laptop Do_job_for_REDACTED Develop_a_system_that_rea\
sons_about_what_will_fail_if_certain_things_aren_t_done_ Contact_REDACTED - unilang-entry andy - person)
 (:init
  (= (budget andy) 500)
  (= (costs Get_a_new_laptop) 400)
  (= (costs Get_an_android_based_phone) 200)
  (= (costs Have_mobile_wireless_access_through_phone) 60)
  (= (costs Order_mobile_broadband) 60)
  (= (earns Do_job_for_REDACTED) 250)
  (depends Get_a_new_laptop Make_a_list_of_the_features_we_want_to_have_in_a_laptop)
  (depends Have_FRDCSA_Interactive_Execution_Monitor_working Get_an_android_based_phone)
  (depends Have_FRDCSA_Interactive_Execution_Monitor_working Write_android_software)
  (depends Make_adequate_money_each_month Setup_core_business_processes)
  (depends Setup_core_business_processes Have_1_630_300_5565_actually_work_when_I_already_have_a_phone_call__instead_of_just_ringing_endlessly)
  (depends install_FRDCSA_on_my_new_laptop Get_a_new_laptop)
  (eases Contact_REDACTED Get_an_android_based_phone)
  (eases Contact_REDACTED Write_android_software)
  (eases Develop_a_system_that_reasons_about_what_will_fail_if_certain_things_aren_t_done_ Setup_core_business_processes)
  (eases Get_a_new_laptop Have_mobile_wireless_access_through_phone)
  (eases Get_a_new_laptop Present_at_Flourish)
  (eases Get_a_new_laptop Read_books_on_the_laptop)
  (eases Get_an_android_based_phone Have_mobile_wireless_access_through_phone)
  (eases Have_dependency_reasoner_working Have_FRDCSA_Interactive_Execution_Monitor_working)
  (eases Have_dependency_reasoner_working Have_budget_analysis_system_working)
  (provides Have_mobile_wireless_access_through_phone Have_mobile_wireless_on_the_train)
  (provides Order_mobile_broadband Have_mobile_wireless_on_the_train))
 (:goal
  (and
   (completed Have_FRDCSA_Interactive_Execution_Monitor_working)
   (completed Get_a_new_laptop)
   (completed Have_budget_analysis_system_working)
   (completed Have_mobile_wireless_on_the_train)
   (completed Present_at_Flourish)))
 (:metric minimize
  (total-time)))
