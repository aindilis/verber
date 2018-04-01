(in-package :ap)


(defmethod can-destroy-p ((?weapon resource)(?target object))
  (and (instance ?weapon 'weapon)
       (instance ?target 'target)))


(defun appropriate-lab-p (lab agent)
  "does PDDL have a 'rule'?"
  (cond ((instance agent 'bioAgent)
	 (instance lab 'bioLab))
	((instance agent 'chemicalAgent)
	 (instance lab 'chemLab))))

(defun appropriate-delivery-system (?ds ?a)
  (cond ((instance ?ds 'crop_duster)
	 (instance ?a 'inhalant))
	(t
	 (instance ?ds 'LandVehicle))))
