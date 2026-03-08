BRANCLNI ;IHS/OIT/NST - Radiology Imaging Clinical Indicator Unitlity ; 04 Mar 2025 10:24 AM
 ;;5.0;Radiology/Nuclear Medicine;**1012**;Mar 16, 1998;Build 1
 ;;
 Q
 ;***** Is Clinical indicator required for Imaging type and Patient category
 ;       
 ; RPC: BRANCLNI REQUIRED
 ; 
 ; Input Parameters
 ; ================
 ; 
 ; IMGTYPE - Imaging Type - IEN in IMAGING TYPE file (#79.2)
 ; PCAT  - Patient Category - I(npatient) or O(utpatient)  
 ; 
 ; Return Values
 ; =============
 ; if error BRARY = -1 ^ Error message
 ; if success BRARY = 1 ^ 1 (required) | 0 (not required)
REQUIRED(BRARY,IMGTYPE,PCAT) ; RPC [BRANCLNI REQUIRED]
 N CATEGORY,ERR
 ;
 S BRARY="-1"
 I $G(IMGTYPE)="" S BRARY="-1^Error: The Imaging Type value is required" Q
 I $G(PCAT)="" S BRARY="-1^Error: The Patient Category value is required" Q
 I (PCAT'="I"),(PCAT'="O") S BRARY="-1^Error: The Patient Category value """_PCAT_""" is invalid" Q
 ;
 S CATEGORY=$$GET^XPAR("ALL","BRA CLINICAL INDICATOR",IMGTYPE,"I")
 ;
 S BRARY="1^"_$S(CATEGORY="":0,CATEGORY="B":1,CATEGORY=PCAT:1,1:0)
 Q
 ;
ALLOWED() ; Is Clinical Indication allowed with Order entry
 N X
 S X=$$GET^XPAR("ALL","BEHOORPA CLINICAL INDICATOR","RADIOLOGY/NUCLEAR MEDICINE")
 Q X=1
 ;
 ; The following code reads the patient's entries in the PROBLEM file, uses the SNOMED Code
 ; and creates the necessary string for ListMan.
GETSNOPN(OUT,DFN,BRAODT) ; EP - SNOMED Selections
 N CNT,HDR,VARS,WHICHONE
 ;
 I $G(OUT) D  Q:$G(OUT)  ; Ask if we can keep the existing diagnosis
 . W "Diagnosis: ",$P(OUT,U,4),"  ",$P(OUT,U,2)
 . N DIR,Y,DIRUT
 . S Y=0
 . W !
 . S DIR(0)="Y"
 . S DIR("A")="Enter a new Diagnosis (Y/N)"
 . S DIR("B")="N"
 . S DIR("T")=1800 ; Wait 30 Minutes
 . D ^DIR
 . I Y S OUT=""
 . Q
 E  W !,"Select Diagnosis:"
 ;
 S HDR=""
 ;
 S CNT=$$GPROBLST(.VARS,DFN,BRAODT)  ; Get patient problem list
 ; 
 I 'CNT  D   ; No patient's problems found 
 . W !!,?4,$TR($J("",67)," ","*"),!
 . W ?4,"** Patient has no entries in the PROBLEM File. **",!
 . W ?4,$TR($J("",67)," ","*"),!!
 . Q
 ; 
 I CNT D  Q:OUT>0
 . S HDR="Select an appropriate code from the Patient's "_CNT_" Problems."
 . S OUT=$$LISTMSEL(HDR)
 . Q
 ;
 K VARS
 S (Y,OUT)=""
 F  S Y=$$NEWLIST() S:Y="^" OUT="^" Q:'Y!(Y="^")  D  Q:OUT'=""!(CNT="^")
 . S CNT=$$GETDIAG(.VARS,BRAODT)  ; Get diagnosis list
 . I CNT D
 . . S HDR="Select an appropriate code from the "_CNT_" retrieved."
 . . S OUT=$$LISTMSEL(HDR)
 . . Q
 . Q
 S:CNT="^" OUT="^"
 S:OUT<0 OUT="^"  ; -1^No Code Selected
 Q
 ;
NEWLIST()  ; Select from new list?
 N DIR,Y,DIRUT
 S Y=0
 W !
 S DIR(0)="YO"
 S DIR("A")="Create new listing of Diagnosis (ICD-10/SNOMED) Codes (Y/N/^)"
 S DIR("B")="YES"
 S DIR("T")=1800 ; Wait 30 Minutes
 D ^DIR
 Q Y
 ;
GPROBLST(VARS,DFN,BRAODT)   ; Get patient problem list 
 N APISTR,CNT,CONCID,ICDCODE,PROBIEN,PSTATUS,SNOMED,SNOMEDSC
 ;
 S CNT=0
 S PROBIEN="AAA"
 F  S PROBIEN=$O(^AUPNPROB("AC",DFN,PROBIEN),-1)  Q:PROBIEN<1  D
 . S CONCID=$$GET1^DIQ(9000011,PROBIEN,"SNOMED CT CONCEPT CODE","I")
 . Q:CONCID<1
 . ;
 . S PSTATUS=$$GET1^DIQ(9000011,PROBIEN,"STATUS","I")
 . Q:PSTATUS="I"!(PSTATUS="D")    ; If problem's status is INACTIVE or DELETED, skip
 . ;
 . S $P(CONCID,"^",3)=BRAODT       ; Make sure current codes as of Order's date are returned
 . S APISTR=$$CONC^BSTSAPI(CONCID_"^^^1")                  ; Search for Data from Terminology Server's local cache first
 . S:$L($TR(APISTR,"^"))<1 APISTR=$$CONC^BSTSAPI(CONCID)   ; If no local cache data, return Data from Terminology Server 
 . S ICDCODE=$P($P(APISTR,"^",5),";")
 . S SNOMED=$P(APISTR,"^",3)
 . S SNOMEDSC=$P(APISTR,"^",4)
 . ;
 . S CNT=CNT+1
 . S VARS(CNT,"PRB","DSC")=SNOMED
 . S VARS(CNT,"PRB","TRM")=SNOMEDSC
 . S VARS(CNT,"ICD",1,"COD")=ICDCODE
 . Q
 ;
 Q CNT
 ;
LISTMSEL(HDR) ; LIST Manager to Select entry
 N SNOMED,ICD,RES
 S ^TMP("BRA SNOMED GET",$J,"HDR")=$S(HDR="":"Select an appropriate code",1:HDR)
 ;
 S WHICHONE=0
 D EN^BRANSMLM(1)
 ;
 K ^TMP("BRA SNOMED GET",$J)
 S ICD=$G(SNOMED(+WHICHONE))  ; e.g. 356960015^Overweight^E66.3
 S RES=$$ICDDX^ICDEX($P(ICD,"^",3),DT)  ; e.g. 503331^E66.3^^Overweight^^10^^^^1^^^^^^^3151001^^^30^^
 ;
 Q RES
 ;
GETDIAG(VARS,BRAODT) ; Get a diagnosis.
 N DIR,OUT,X,Y
 ;
 S Y=0
 F  Q:Y!($E(Y)="^")  D
 . W !!
 . S DIR(0)="F"
 . S DIR("A")="Enter Clinical Indication (Free Text)"
 . S DIR("T")=1800      ; Wait 30 Minutes
 . D ^DIR
 . Q:$E(Y)="^"
 . ;
 . K OUT
 . S OUT="VARS"
 . S Y=$$GBSTSAPI(OUT,X,BRAODT)
 . I Y<1 W !!,?9,"No entries found in the IHS STANDARD TERMINOLOGY database.  Try Again."
 . Q
 ;
 Q $S(Y="^":"^",1:$O(VARS("A"),-1))
 ;
GBSTSAPI(OUT,SEARCH,BRAODT)  ;  Return a list by seearch term SEARCH 
 N IN,Y
 K @OUT
 S IN=SEARCH_"^S"
 S $P(IN,"^",5)=BRAODT      ; Make certain current codes returned
 S $P(IN,"^",6)=200
 S $P(IN,"^",8)=1
 S Y=$$SEARCH^BSTSAPI(OUT,IN)
 Q Y
 ;
GETCLIND(BRARY,DFN,BRAODT,BRACAT,RAPRI)  ; Get Clinical indication if allowed
 ; DFN = Patient DFN
 ; BRAODT - Date of order
 ; BRACAT - Patient category
 ; RAPRI - Procedure IEN in RAD/NUC MED PROCEDURES file (#71)
 N ALLOWED,BRANXE,DA,DIR,OUT,REQ,TYPEIEN
 S:'$D(BRARY) BRARY=""
 S:BRAODT="" BRAODT=$$DT^XLFDT()
 S ALLOWED=$$GET^XPAR("ALL","BEHOORPA CLINICAL INDICATOR","RADIOLOGY/NUCLEAR MEDICINE")
 I 'ALLOWED Q  ; It is not allowed
 ;
 ; Check if clinical indication is required
 S TYPEIEN=$$GET1^DIQ(71,RAPRI,12,"I")  ; Get Imgaing Type
 D REQUIRED(.REQ,TYPEIEN,$E(BRACAT))
 S REQ=$S($P(REQ,"^",1)<0:0,1:$P(REQ,"^",2))
 Q:'REQ  ; Quit if not required
 ;
 F  D GETSNOPN(.BRARY,DFN,BRAODT) Q:BRARY'=""!'REQ  D
 . I REQ S DIR(0)="EO",DIR("A")="Clinical indication is required! Press any key to continue" K DA D ^DIR K DIR
 . Q
 Q
 ; 
EDIT(BRACLIND,RADFN,RADTI,RACNI,RAPRI)  ; Edit ICD and save it
 ;
 I '$G(RADFN) Q
 I '$G(RADTI) Q
 I '$G(RACNI) Q
 ;
 N ALLOWED,BRADTE,BRACLNDO,BRACAT,BRAOIFN,TYPEIEN,REQ
 ;
 S ALLOWED=$$GET^XPAR("ALL","BEHOORPA CLINICAL INDICATOR","RADIOLOGY/NUCLEAR MEDICINE")
 I 'ALLOWED Q  ; It is not allowed
 ;
 ; e.g. BRACLIND = e.g. 503331^E66.3^^Overweight^^10^^^^1^^^^^^^3151001^^^30^^
 S BRADTE=9999999.9999-RADTI
 S BRACAT=$P($G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0)),U,4)
 S:BRACAT'="O" BRACAT="I"
 ; 
 S TYPEIEN=$$GET1^DIQ(71,RAPRI,12,"I")  ; Get Imgaing Type
 D REQUIRED(.REQ,TYPEIEN,$E(BRACAT))
 S REQ=$S($P(REQ,"^",1)<0:0,1:$P(REQ,"^",2))
 I 'REQ S BRACLIND="NOT REQUIRED" Q   ; It is not required
 ;
 S BRAOIFN=$P($G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0)),U,11)  ; RA Order IEN in #75.1
 S BRACLIND=$$GET1^DIQ(75.1,BRAOIFN,91,"I")
 S:BRACLIND BRACLIND=$$ICDDX^ICDEX(BRACLIND,BRADTE)
 S:BRACLIND'>0 BRACLIND=""
 S BRACLNDO=BRACLIND
 ;
 F  D  Q:'REQ  Q:(REQ&(BRACLIND'=""))
 . W !
 . D GETCLIND^BRANCLNI(.BRACLIND,RADFN,BRADTE,BRACAT,RAPRI)    ; Get Clinical indication if it is allowed and required
 . ;
 . I REQ,((BRACLIND="^")!(BRACLIND="")) S BRACLIND=BRACLNDO    ; if diagnosis is requred and new one is blank set it to original
 . I REQ,(BRACLIND="") S DIR(0)="EO",DIR("A")="Clinical indication is required! Press any key to continue" K DA D ^DIR K DIR
 . Q
 ;
 I (BRACLNDO'=BRACLIND),$D(^RAO(75.1,BRAOIFN,0)) D
 . N DIERR,BRAFDA,BRAMSG,BRARC
 . S BRAFDA(75.1,BRAOIFN_",",91)=$S(BRACLIND="":"@",1:+BRACLIND) ; Clinical Indication ICD Dx pointer.
 . D FILE^DIE("K","BRAFDA","BRAMSG")
 . S:$G(DIERR) BRARC=$$DBS^RAERR("BRAMSG",-999,75.1,BRAOIFN_",")
 . Q
 ;
 ;Update V RADIOLOGY file (#9000010.22)
 I BRACLNDO'=BRACLIND D UVRAD(RADFN,RADTI,RACNI,BRACLIND)
 Q
 ;
UVRAD(RADFN,RADTI,RACNI,BRACLIND)  ; Update V RADIOLOGY file (#9000010.22)
 N PCCVRAD,DIERR,BRAFDA,BRAMSG,BRARC
 ;get V RADIOLOGY ien, if none quit
 S PCCVRAD=$P($G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"PCC")),U,2)
 Q:'PCCVRAD  ; No V RADIOLOGY entry to update
 ;
 S BRAFDA(9000010.22,PCCVRAD_",",.09)=$S(BRACLIND="":"@",1:+BRACLIND) ; Clinical Indication ICD Dx pointer.
 S BRAFDA(9000010.22,PCCVRAD_",",1218)=$$NOW^XLFDT
 D FILE^DIE("K","BRAFDA","BRAMSG")
 S:$G(DIERR) BRARC=$$DBS^RAERR("BRAMSG",-999,9000010.22,PCCVRAD_",")
 Q
