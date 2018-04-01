(define (problem cooking)

 (:domain cooking)

 (:objects
  file1 - file
  dir1 - dir
  file1 - module
  )

 (:init
  (is-script file1)
  )

 (:goal 
  (and
   (dir-has-file dir1 file1)
   (is-executable file1)
   )
  )

 )


