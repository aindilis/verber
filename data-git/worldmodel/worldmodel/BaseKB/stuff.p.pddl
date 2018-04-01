;; <problem-file>

(define (problem )

  (:domain )

  (:objects
   ibm-r30 - laptop
   platronics-headset - headset
   ibm-r30-power-supply - power-supply
   ibm-r30-power-cord - power-cord
   shoes-dockers - shoes
   socks0 - socks
   grey-shirt - shirt
   green-pants - pants
   duffle-bag0 - bag
   overcoat - coat
   sleeping-bag-bag - bag
   black-plastic-sheeting - tarp
   wallet0 - wallet
   cmu-id-card illinois-drivers-liscense - id-card
   cvs-card geagle-card - shopping cards

   shower-kit daily-kit - kit
   can-opener finger-nail-clippers - tool
   )


  (:init
   (complete wallet)
   
   (part-of-kit finger-nail-clippers daily-kit)
   (part-of-kit can-opener daily-kit)
   (part-of-kit wallet0 daily-kit)

   )

  (:goal

   )
  
  (:metric)
    
  )
      
;; </problem-file>
