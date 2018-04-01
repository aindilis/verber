;; $VAR1 = {
;;           'Includes' => {},
;;           'Units' => undef
;;         };

(define
 (domain billpayment)
 (:requirements :derived-predicates :equality :negative-preconditions :fluents :conditional-effects :durative-actions :typing)
 (:types utilitySupplier - serviceProvider residence intelligentAgent informationBearingThing - object bankCard - moneyTenderType serviceProvider person party financialInstitution - intelligentAgent stateGovernmentAgency financialInstitution - institution date confirmationNumber action accountType - informationBearingThing income expense - financialObligation creditCardServiceCompany consumerBankingCompany - financialInstitution foodStampsCard - bankDebitCard bankDebitCard bankCreditCard - bankCard savingsAccount foodStampsAccount creditAccount checkingAccount cashAssistanceAccount - bankAccount bankAccount - accountType)
 (:predicates
  (acceptsPaymentMethod ?p - payee ?m - method)
  (bankAccountBelongsTo ?ba - bankAccount ?ia - intelligentAgent)
  (before ?d1 - date ?d2 - date)
  (connectedToResidence ?b - bill ?r - residence)
  (dateStamp ?o - object ?y - year ?m - month ?d - day)
  (dateTimeStamp ?o - object ?y - year ?m - month ?d - day ?h - hour ?mi -minute ?s - second)
  (depositAuthorizedDate ?d - deposit ?d - date)
  (depositPostedOnDate ?d - deposit ?d - date)
  (deposited ?d - deposit)
  (hasBankAccount ?d - deposit ?ba - bankAccount)
  (hasBankAccount ?p - payment ?ba - bankAccount)
  (hasBankCard ?ba - bankAccount ?bc - bankCard)
  (hasDepositor ?d - deposit ?p - party)
  (hasDueDate ?b - bill ?d - date)
  (hasExpectedDate ?d - deposit ?da - date)
  (hasExpectedDate ?p - payment ?d - date)
  (hasPayee ?b - bill ?ia - intelligentAgent)
  (hasPayee ?p - payment ?pa - party)
  (hasPayer ?b - bill ?ia - intelligentAgent)
  (holdPlacedOn ?ba - bankAccount)
  (inIntelligentAgentsName ?sp - serviceProvider ?ia - intelligentAgent)
  (issuingInstitution ?ba - bankAccount ?i - institution)
  (paid ?p - bill)
  (paid ?p - payment)
  (paymentAuthorizedDate ?b - bill ?d - date)
  (paymentAuthorizedDate ?p - payment ?d - date)
  (paymentMethod ?b - bill ?m - billPaymentMethod)
  (paymentMethod ?p - payment ?m - paymentMethod)
  (paymentPostedOnDate ?b - bill ?d - date)
  (paymentPostedOnDate ?p - payment ?d - date))
 (:functions
  (availableBalance ?ba - bankAccount)
  (currentBalance ?ba - bankAccount)
  (duration ?da - durativeAction)
  (hasAmount ?b - bill)
  (hasAmount ?ba - bankAccount)
  (hasAmount ?d - deposit)
  (hasAmount ?p - payment)
  (hasCash ?ia - intelligentAgent))
 (:derived
  (depositAuthorized ?d - deposit)
  (exists
   (?da - date)
   (depositAuthorizedDate ?d ?da)))
 (:derived
  (depositPosted ?d - deposit)
  (exists
   (?da - date)
   (depositPostedOnDate ?d ?da)))
 (:derived
  (paymentAuthorized ?p - payment)
  (exists
   (?d - date)
   (paymentAuthorizedDate ?p ?d)))
 (:derived
  (paymentPosted ?p - payment)
  (exists
   (?d - date)
   (paymentPostedOnDate ?p ?d)))
 (:durative-action deposit-cash :parameters
  (?ba - bankAccount ?ia - intelligentAgent ?fi - financialInstitution) :duration
  (= ?duration (duration deposit)) :condition
  (and
   (over all
    (= (hasCash ?ia) ?c)
    (bankAccountBelongsTo ?ba ?ia)
    (= (hasAmount ?ba) ?a))) :effect
  (and
   (at end (assign (availableBalance ?ba1) (+ (availableBalance ?ba1) ?a)))))
 (:durative-action deposit-check :parameters
  (?ba1 - bankAccount ?ia - intelligentAgent ?fi - financialInstitution ?ba2 - bankAccount ?a - amount) :duration
  (= ?duration (duration deposit)) :condition
  (and
   (over all
    (hasAccountWith ?ba1 ?ia ?fi ?ba2))) :effect
  (and
   (at end (assign (availableBalance ?ba1) (+ (availableBalance ?ba1) ?a)))))
 (:durative-action makeInStorePayment)
 (:durative-action makeOnlinePayment)
 (:durative-action pay :parameters
  (?ba1 - bankAccount ?ia - intelligentAgent ?fi - financialInstitution ?ba2 - bankAccount ?a - amount) :duration
  (= ?duration (duration withdrawal)) :condition
  (and
   (over all
    (bankAccountBelongsTo ?ba1 - bankAccount ?ia - intelligentAgent))) :effect
  (and
   (at end (assign (availableBalance ?ba1) (- (availableBalance ?ba1) ?a)))))
 (:durative-action pay :parameters
  (?p - payment ?ia - intelligentAgent ?pa - party ?a - account ?d1 - date ?d2 - date) :duration
  (= ?duration (duration deposit)) :condition
  (and
   (at start (hasPayee ?b ?p) (inIntelligentAgentsName ?p ?ia) (not (paymentAuthorized ?b)))
   (over all
    (and
     (hasPayee ?p ?pa)
     (hasExpectedDate ?p ?d)
     (= (hasAmount ?p) ?a)
     (hasBill ?r ?sp ?a ?duedate)
     (currentDate ?currentdate)
     (atOrbefore ?currentdate ?duedate)
     (not
      (hasNegativeAvailableBalance ?b ?dts))))) :effect
  (and
   (over all
    (holdPlacedOn ?ba1))
   (at end (assign (availableBalance ?ba1) (- (availableBalance ?ba1) ?a)) (paymentHasBeenSentForBill ?r ?sp ?a ?duedate ?currentdate))))
 (:durative-action payBill :parameters
  (?ia - intelligentAgent ? ?ba1 - bankAccount ?ba2 - bankAccount ?fi - financialInstitution ?r - residence ?sp - serviceProvider ?a - amount ?duedate - date ?currentdate - date) :duration
  (= ?duration (duration deposit)) :condition
  (and
   (over all
    (and
     (bankAccountBelongsTo ?ba1 - bankAccount ?ia - intelligentAgent)
     (hasBill ?r ?sp ?a ?duedate)
     (currentDate ?currentdate)
     (atOrbefore ?currentdate ?duedate)
     (not
      (hasNegativeAvailableBalance ?ba ?dts))))) :effect
  (and
   (over all
    (holdPlacedOn ?ba1))
   (at end (assign (availableBalance ?ba1) (- (availableBalance ?ba1) ?a)) (paymentHasBeenSentForBill ?r ?sp ?a ?duedate ?currentdate)))))