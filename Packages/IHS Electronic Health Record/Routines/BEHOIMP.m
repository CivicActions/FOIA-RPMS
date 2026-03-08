BEHOIMP ;IHS/MSC/PLS - SUPPORT FOR IMPLANTABLE DEVICES ;22-Nov-2022 16:54;PLS
 ;;1.1;BEH COMPONENTS;**073001,073003**;March 20,2007
 ;
 Q
 ;Return device count for patient
GETCNT(DATA,DFN) ;-
 D GETCNT^BEHOIMP1(.DATA,DFN)
 Q
 ;Return list of devices associated with patient
PTDEVLST(DATA,DFN) ;-
 D PTDEVLST^BEHOIMP1(.DATA,DFN)
 Q
 ;Return list of Implantable Device Categories
GETCATGY(DATA) ;-
 D GETCATGY^BEHOIMP1(.DATA)
 Q
 ;Stores XML content into file
SAVE(DATA,XML) ;-
 D SAVE^BEHOIMP2(.DATA,.XML)
 Q
 ;Stores changes to an existing record
UPDATE(DATA,IEN,XML) ;-
 D STORE^BEHOIMP2(.DATA,.XML,IEN,1)
 Q
 ;Returns list of body locations for Implant Category
GETBLOCS(DATA,IMPCAT) ;-
 D GETBLOCS^BEHOIMP1(.DATA,.IMPCAT)
 Q
 ;Update the status of an entry
UPTSTS(DATA,IEN,STS,RSN) ;-
 D UPTSTS^BEHOIMP1(.DATA,.IEN,.STS,.RSN)
 Q
 ;Return list of patient problems
PTPROB(DATA,DFN) ;-
 D PROB^BEHOIMP3(.DATA,DFN)
 Q
FNDLOC(DFN,START,NUM) ;-
 N X,DATA
 D PTDEVLST(.DATA,DFN)
 S LP=0 F  S LP=$O(@DATA@(LP)) Q:'LP  S X=$G(X)_@DATA@(LP)
 Q $E(X,START,START+NUM)
