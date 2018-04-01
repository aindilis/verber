(in-package :ap)

(define (domain windows)
    (:extends computer network)
  (:types  WindowsHost - Host
	   NTHost - WindowsHost
	   ZipFile - TarFile
	   Windows - OperatingSystem
	   OfficeDocument - ApplicationFile)
  (:constants WindowsXP Windows7 Vista Windows10 - Windows
	      ActiveX IE_5.0 - Service
	      admin - Account
	      users guests - Group
	      administrators - Superuser
	      Favorites - Directory)
  (:axiom
   :vars (?h - WindowsHost)
   :implies (and (accountExists ?h admin)
		 (group ?h admin administrators))))
