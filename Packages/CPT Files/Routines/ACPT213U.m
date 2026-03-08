ACPT213U ;IHS/OIT/NKD - ACPT V2.13 CPT UPDATER 12/19/12 ;
 ;;2.13;CPT FILES;**1,2**;DEC 19, 2012;Build 1
 ; 2/6/13 - ACPT*2.13*1 - MODIFIED BREAK LOGIC FOR LONG DESCRIPTION
 ; 07/03/13 - ACPT*2.13*2 - MODIFIED DINUM LOGIC FOR NEW CPT CODES
 ;                        - INCLUDED CPT CATEGORY FIELD WHEN UPDATING CPT/HCPCS CODES
 ;                        - ADDED CPT RANGE ON MODIFIERS FOR EHR
 ;
 Q
 ; EXPECTED VARIABLES
 ; ACPTA       ACPTT       ACPTIEN
 ; ACPTCODE    ACPTNAME    ACPTDESC
 ; ACPTADT     ACPTEDT     ACPTTDT
UPD81 ; EP - PRIMARY UPDATER TO CPT FILE
 N FDA,NEWIEN,ACPTRES,ACPTLST,ACPTCNT,ACPTLSI,ACPTDFR,ACPTDTO,ACPTNEW,ACPTPYR
 I ACPTIEN']"" D  ; If there isn't one, create it
 . K FDA,NEWIEN
 . S FDA(81,"+1,",.01)=ACPTCODE ; CPT Code (.01)
 . ;S:ACPTCODE=+ACPTCODE NEWIEN(1)=ACPTCODE ; Attempt DINUM ; IHS/OIT/NKD ACPT*2.13*2 - MODIFIED DINUM LOGIC
 . S NEWIEN(1)=$$CPTIEN(ACPTCODE) ; Attempt DINUM or next available IEN starting from 100000
 . D UPDATE^DIE(,"FDA","NEWIEN") ; Add the entry
 . S ACPTIEN=NEWIEN(1),ACPTCHG="N"
 Q:'ACPTIEN
 ;
 S ACPTPYR=$$GET1^DIQ(81,ACPTIEN,8,"I") ; SET PREVIOUS ACTIVE DATE
 ; Effective Date (60)
 K FDA,ACPTRES,ACPTLST
 D LIST^DIC(81.02,","_ACPTIEN_",","@;.01I;.02I","P",,,,,,,"ACPTRES",)
 S ACPTLST=$P($G(ACPTRES("DILIST",$P($G(ACPTRES("DILIST",0)),"^",1),0)),"^",3)
 I ((ACPTLST=0)&(ACPTA'="D"))!((ACPTLST=1)&(ACPTA="D"))!(ACPTLST']"") D
 . S FDA(81.02,"?+1,"_ACPTIEN_",",.01)=ACPTEDT
 . S FDA(81.02,"?+1,"_ACPTIEN_",",.02)=$S(ACPTA="D":0,1:1)
 . D UPDATE^DIE(,"FDA",)
 . S ACPTCHG=ACPTCHG_$S(ACPTA="D":"I",1:"A")
 ;
 ; Non-versioned fields
 K FDA
 S:ACPTA'="D" FDA(81,ACPTIEN_",",2)=ACPTNAME ; Short Name (2)
 S FDA(81,ACPTIEN_",",6)=$S(ACPTT="CPT":"C",ACPTT="HCPCS":"H",1:"@") ; Source (6)
 S FDA(81,ACPTIEN_",",5)=$S(ACPTA="D":1,1:"@") ; Inactive Flag (5)
 S FDA(81,ACPTIEN_",",8)=$S(ACPTADT]"":ACPTADT,ACPTPYR]"":ACPTPYR,1:ACPTYR) ; Active Date (8)
 S FDA(81,ACPTIEN_",",9999999.06)=$S(ACPTADT]"":ACPTADT,ACPTPYR]"":ACPTPYR,1:ACPTYR) ; Date Added (9999999.06)
 S FDA(81,ACPTIEN_",",7)=$S(ACPTA="D":ACPTTDT,1:"@") ; Inactive Date (7)
 S FDA(81,ACPTIEN_",",9999999.07)=$S(ACPTA="D":ACPTTDT,1:"@") ; Date Deleted (9999999.07)
 ; IHS/OIT/NKD ACPT*2.13*2 CPT CATEGORY - START NEW CODE
 N ACPTCAT
 S ACPTCAT=$$CATFIND^ACPT213C(ACPTCODE)
 S:ACPTA'="D" FDA(81,ACPTIEN_",",3)=$S(ACPTCAT]"":ACPTCAT,1:"@")
 ; IHS/OIT/NKD ACPT*2.13*2 END NEW CODE
 D UPDATE^DIE(,"FDA",)
 Q:ACPTA="D"
 ;
 ; Description (50)
 K FDA,ACPTCNT,ACPTRES
 D TEXT(.ACPTDESC) ; Convert string to WP array
 I $L($G(^ICPT(ACPTIEN,"D",0)))<1 S ^ICPT(ACPTIEN,"D",0)="^81.01A" ; Fix global due to CSV
 ; Remove previous Description
 S ACPTCNT=0
 D GETS^DIQ(81,ACPTIEN,"50*",,"ACPTRES")
 F  S ACPTCNT=$O(ACPTRES(81.01,ACPTCNT)) Q:'ACPTCNT  D
 . S ACPTRES(81.01,ACPTCNT,.01)="@"
 D UPDATE^DIE(,"ACPTRES",)
 ; Add new Description
 S ACPTCNT=0
 F  S ACPTCNT=$O(ACPTDESC(ACPTCNT)) Q:'ACPTCNT  D
 . S FDA(81.01,"+"_ACPTCNT_","_ACPTIEN_",",.01)=$G(ACPTDESC(ACPTCNT))
 D UPDATE^DIE(,"FDA",)
 ;
 ; Short Name (Versioned) (61)
 K FDA,ACPTRES,ACPTLST,ACPTCNT
 ; Find the last Short Name
 D LIST^DIC(81.061,","_ACPTIEN_",","@;.01I;1I","P",,,,,,,"ACPTRES",)
 S ACPTLST=$P($G(ACPTRES("DILIST",$P($G(ACPTRES("DILIST",0)),"^",1),0)),"^",3)
 ; If the last is blank, find the previous until a Short Name is found
 I ACPTLST']"" F ACPTCNT=1:1:$P($G(ACPTRES("DILIST",0)),"^",1)-1 S ACPTLST=$P($G(ACPTRES("DILIST",$P($G(ACPTRES("DILIST",0)),"^",1)-ACPTCNT,0)),"^",3) Q:ACPTLST]""
 ; If the two are different, create a new entry
 I $$UP^XLFSTR($$CLEAN^ACPTUTL(ACPTLST))'=$$UP^XLFSTR($$CLEAN^ACPTUTL(ACPTNAME)) D
 . S FDA(81.061,"?+1,"_ACPTIEN_",",.01)=ACPTEDT ; Look for an entry for this install, add if not found
 . S FDA(81.061,"?+1,"_ACPTIEN_",",1)=ACPTNAME ; Set to ACPTNAME
 . D UPDATE^DIE(,"FDA",)
 . S ACPTCHG=ACPTCHG_"S"
 ;
 ; Description (Versioned) (62)
 K FDA,NEWIEN,ACPTRES,ACPTLST,ACPTLSI,ACPTCNT,ACPTDFR,ACPTDTO,ACPTNEW
 S ACPTNEW=0
 ; Find the last Description
 D LIST^DIC(81.062,","_ACPTIEN_",","@;.01I","P",,,,,,,"ACPTRES",)
 S ACPTCNT=$P($G(ACPTRES("DILIST",0)),"^",1)
 S ACPTLSI=$P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",1)
 D GETS^DIQ(81.062,ACPTLSI_","_ACPTIEN,"1*",,"ACPTLST")
 ; Merge the entries into one string
 S ACPTCNT=0,ACPTDTO="" F  S ACPTCNT=$O(ACPTDESC(ACPTCNT)) Q:'ACPTCNT  S ACPTDTO=ACPTDTO_" "_ACPTDESC(ACPTCNT)
 S ACPTCNT=0,ACPTDFR="" F  S ACPTCNT=$O(ACPTLST(81.621,ACPTCNT)) Q:'ACPTCNT  S ACPTDFR($P(ACPTCNT,",",1))=ACPTLST(81.621,ACPTCNT,.01)
 S ACPTCNT=0 F  S ACPTCNT=$O(ACPTDFR(ACPTCNT)) Q:'ACPTCNT  S ACPTDFR=ACPTDFR_" "_ACPTDFR(ACPTCNT)
 ; If the two are different, create a new entry
 I $$UP^XLFSTR($$CLEAN^ACPTUTL(ACPTDFR))'=$$UP^XLFSTR($$CLEAN^ACPTUTL(ACPTDTO)) D
 . S FDA(81.062,"?+1,"_ACPTIEN_",",.01)=ACPTEDT ; Look for an entry for this install, add if not found
 . D UPDATE^DIE(,"FDA","NEWIEN")
 . I $D(NEWIEN) D
 . . ; Remove previous Description
 . . K ACPTRES
 . . S ACPTCNT=0
 . . D GETS^DIQ(81.062,NEWIEN(1)_","_ACPTIEN,"1*",,"ACPTRES")
 . . F  S ACPTCNT=$O(ACPTRES(81.621,ACPTCNT)) Q:'ACPTCNT  D
 . . . S ACPTRES(81.621,ACPTCNT,.01)="@"
 . . D UPDATE^DIE(,"ACPTRES",)
 . . ; Add new Description
 . . S ACPTCNT=0
 . . F  S ACPTCNT=$O(ACPTDESC(ACPTCNT)) Q:'ACPTCNT  D
 . . . S FDA(81.621,"+"_ACPTCNT_","_NEWIEN(1)_","_ACPTIEN_",",.01)=$G(ACPTDESC(ACPTCNT))
 . . D UPDATE^DIE(,"FDA",)
 . . S ACPTCHG=ACPTCHG_"L"
 Q
 ;
UPD813 ; EP - PRIMARY UPDATER TO CPT MODIFIER FILE
 N FDA,NEWIEN,ACPTRES,ACPTLST,ACPTCNT,ACPTDFR,ACPTDTO,ACPTNEW,ACPTPYR
 I ACPTIEN']"" D  ; If there isn't one, create it
 . K FDA,NEWIEN
 . S FDA(81.3,"+1,",.01)=ACPTCODE ; Modifier (.01)
 . S FDA(81.3,"+1,",.02)=ACPTNAME ; Name (.02)
 . D UPDATE^DIE(,"FDA","NEWIEN") ; Add the entry
 . S ACPTIEN=NEWIEN(1),ACPTCHG="N"
 Q:'ACPTIEN
 ;
 S ACPTPYR=$$GET1^DIQ(81.3,ACPTIEN,8,"I") ; SET PREVIOUS ACTIVE DATE
 ; Effective Date (60)
 K FDA,ACPTRES,ACPTLST
 D LIST^DIC(81.33,","_ACPTIEN_",","@;.01I;.02I","P",,,,,,,"ACPTRES",)
 S ACPTLST=$P($G(ACPTRES("DILIST",$P($G(ACPTRES("DILIST",0)),"^",1),0)),"^",3)
 I ((ACPTLST=0)&(ACPTTDT']""))!((ACPTLST=1)&(ACPTTDT]""))!(ACPTLST']"") D
 . S FDA(81.33,"?+1,"_ACPTIEN_",",.01)=ACPTEDT ; Look for an entry for this install, add if not found
 . S FDA(81.33,"?+1,"_ACPTIEN_",",.02)=$S(ACPTTDT]"":0,1:1)
 . D UPDATE^DIE(,"FDA",)
 . S ACPTCHG=ACPTCHG_$S(ACPTTDT]"":"I",1:"D")
 ;
 ; Non-versioned fields
 K FDA
 S:ACPTTDT']"" FDA(81.3,ACPTIEN_",",.02)=ACPTNAME ; Name (.02)
 S FDA(81.3,ACPTIEN_",",.04)=$S(ACPTT="CPT":"C",ACPTT="HCPCS":"H",1:"@") ; Source (.04)
 S FDA(81.3,ACPTIEN_",",5)=$S(ACPTTDT]"":1,1:"@") ; Inactive Flag (5)
 S FDA(81.3,ACPTIEN_",",7)=$S(ACPTTDT]"":ACPTTDT,1:"@") ; Inactive Date (7)
 S FDA(81.3,ACPTIEN_",",8)=$S(ACPTADT]"":ACPTADT,ACPTPYR]"":ACPTPYR,1:ACPTYR) ; Active Date (8)
 D UPDATE^DIE(,"FDA",)
 Q:ACPTTDT]""
 ;
 ; Range (10)
 ;IHS/OIT/NKD ACPT*2.13*2 Add complete CPT range to all modifiers dated 1/1/10 for EHR display EHR*1.1*9
 K FDA
 S FDA(81.32,"?+1,"_ACPTIEN_",",.01)="00100" ; Begin CPT Range
 S FDA(81.32,"?+1,"_ACPTIEN_",",.02)="9999Z" ; End CPT Range
 S FDA(81.32,"?+1,"_ACPTIEN_",",.03)="3100101" ; Active Date
 D UPDATE^DIE(,"FDA",)
 ;
 ; Description (50) WP
 D TEXT(.ACPTDESC) ; convert string to WP array
 D WP^DIE(81.3,ACPTIEN_",",50,,"ACPTDESC")
 ;
 ; Name (Versioned) (61)
 K FDA,ACPTRES,ACPTLST
 ; Find the last Name
 D LIST^DIC(81.361,","_ACPTIEN_",","@;.01I;1I","P",,,,,,,"ACPTRES",)
 S ACPTLST=$P($G(ACPTRES("DILIST",$P($G(ACPTRES("DILIST",0)),"^",1),0)),"^",3)
 I ACPTLST'=ACPTNAME D  ; If the two are different, create a new entry
 . S FDA(81.361,"?+1,"_ACPTIEN_",",.01)=ACPTEDT ; Look for an entry for this install, add if not found
 . S FDA(81.361,"?+1,"_ACPTIEN_",",1)=ACPTNAME ; Set to ACPTNAME
 . D UPDATE^DIE(,"FDA",)
 . S ACPTCHG=ACPTCHG_"S"
 ;
 ; Description (Versioned) (62)
 K FDA,NEWIEN,ACPTRES,ACPTLST,ACPTCNT,ACPTDFR,ACPTDTO,ACPTNEW
 S ACPTNEW=0
 ; Find the last Description
 D LIST^DIC(81.362,","_ACPTIEN_",","@;.01I","P",,,,,,,"ACPTRES",)
 S ACPTCNT=$P($G(ACPTRES("DILIST",0)),"^",1)
 S ACPTLST=$$GET1^DIQ(81.362,ACPTCNT_","_ACPTIEN_",",1,,"ACPTLST",)
 ; Merge the entries into one string
 S ACPTCNT=0,ACPTDTO=0 F  S ACPTCNT=$O(ACPTDESC(ACPTCNT)) Q:'ACPTCNT  S ACPTDTO=ACPTDTO+1
 S ACPTCNT=0,ACPTDFR=0 F  S ACPTCNT=$O(ACPTLST(ACPTCNT)) Q:'ACPTCNT  S ACPTDFR=ACPTDFR+1
 I ACPTDFR'=ACPTDTO S ACPTNEW=1
 E  F ACPTCNT=1:1:ACPTDTO D
 . S:ACPTDESC(ACPTCNT)'=ACPTLST(ACPTCNT) ACPTNEW=1
 ; If the two are different, create a new entry
 I ACPTNEW D
 . S FDA(81.362,"?+1,"_ACPTIEN_",",.01)=ACPTEDT ; Look for an entry for this install, add if not found
 . D UPDATE^DIE(,"FDA","NEWIEN")
 . I $D(NEWIEN) D WP^DIE(81.362,NEWIEN(1)_","_ACPTIEN_",",1,,"ACPTDESC") S ACPTCHG=ACPTCHG_"L"
 Q
 ;
DIS81 ; EP - DISPLAY CPT FILE ENTRY
 N ACPTDISP,ACPTCNT,ACPTDN
 I ACPTCHG]"" D
 . S:ACPTCHG["N" ACPTCHG="N"
 . S ACPTDISP=""
 . S ACPTDISP=ACPTDISP_$S(ACPTCHG["N":"N",1:" ")_$J("",3)
 . S ACPTDISP=ACPTDISP_$S(ACPTCHG["A":"A",ACPTCHG["I":"I",1:" ")_$J("",6)
 . S ACPTDISP=ACPTDISP_$S(ACPTCHG["S":"S",1:" ")_$J("",5)
 . S ACPTDISP=ACPTDISP_$S(ACPTCHG["L":"L",1:" ")
 . S ACPTDN=$S(ACPTNAME]"":$E(ACPTNAME,1,30),1:$$GET1^DIQ(81,ACPTIEN,2,"I"))
 . D MES^XPDUTL($J("",2)_ACPTCODE_$J("",8-$L(ACPTCODE))_ACPTDN_$J("",33-$L(ACPTDN))_ACPTDISP)
 Q
 ;
DIS813 ; EP - DISPLAY CPT MODIFIER FILE ENTRY
 N ACPTDISP,ACPTCNT,ACPTDN
 I ACPTCHG]"" D
 . S:ACPTCHG["N" ACPTCHG="N"
 . S ACPTDISP=""
 . S ACPTDISP=ACPTDISP_$S(ACPTCHG["N":"N",1:" ")_$J("",3)
 . S ACPTDISP=ACPTDISP_$S(ACPTCHG["A":"A",ACPTCHG["I":"I",1:" ")_$J("",6)
 . S ACPTDISP=ACPTDISP_$S(ACPTCHG["S":"S",1:" ")_$J("",5)
 . S ACPTDISP=ACPTDISP_$S(ACPTCHG["L":"L",1:" ")
 . S ACPTDN=$S(ACPTNAME]"":$E(ACPTNAME,1,30),1:$$GET1^DIQ(81.3,ACPTIEN,.02,"I"))
 . D MES^XPDUTL($J("",2)_ACPTCODE_$J("",8-$L(ACPTCODE))_ACPTDN_$J("",33-$L(ACPTDN))_ACPTDISP)
 Q
 ;
TEXT(ACPTDESC) ; convert Description text to Word-Processing data type
 ; input: .ACPTDESC = passed by reference, starts out as long string,
 ; ends as Fileman WP-format array complete with header
 ;
 N ACPTSTRN S ACPTSTRN=ACPTDESC ; copy string out
 K ACPTDESC ; clear what will now become a WP array
 N ACPTCNT S ACPTCNT=0 ; count WP lines for header
 ;
 F  Q:ACPTSTRN=""  D  ; loop until ACPTSTRN is fully transformed
 .;
 .N ACPTBRK S ACPTBRK=0 ; character position to break at
 .;
 .D  ; find the character position to break at
 ..N ACPTRY ; break position to try
 ..S ACPTRY=$L(ACPTSTRN) ; how long is the string?
 ..I ACPTRY<81 S ACPTBRK=ACPTRY Q  ; if 1 full line or less, we're done
 ..;
 ..F ACPTRY=80:-1:2 D  Q:ACPTBRK
 ...I $E(ACPTSTRN,ACPTRY+1)=" " D  Q  ; can break on a space
 ....S $E(ACPTSTRN,ACPTRY+1)="" ; remove the space
 ....S ACPTBRK=ACPTRY ; and let's break here
 ...; IHS/OIT/NKD ACPT*2.13*1 - MODIFIED LOGIC TO BREAK ON DELIMITERS BETTER
 ...;I "&_+-*/<=>}])|:;,.?!"[$E(ACPTSTRN,ACPTRY) D  Q  ; on delimiter?
 ...I "&_+-*/<=>}])|:;,.?!"[$E(ACPTSTRN,ACPTRY),$E(ACPTSTRN,ACPTRY+1)=" " D  Q  ; on delimiter?
 ....S ACPTBRK=ACPTRY ; so let's break here
 ..;
 ..Q:ACPTBRK  ; if we found a good spot to break, we're done
 ..;
 ..S ACPTBRK=80 ; otherwise, hard-break on 80 (weird content)
 .;
 .S ACPTCNT=ACPTCNT+1 ; one more line
 .S ACPTDESC(ACPTCNT)=$E(ACPTSTRN,1,ACPTBRK) ; copy line into array
 .S $E(ACPTSTRN,1,ACPTBRK)="" ; & remove it from the string
 ;
 Q
 ;
 ; IHS/OIT/NKD ACPT*2.13*2 
CPTIEN(ACPTC) ;EP - RETURNS IEN TO BE USED IN NEW CPT CODE ENTRY
 N ACPTN,ACPTCNT
 S ACPTN=$$NUM^ICPTAPIU(ACPTC) ; ATTEMPT NUMERIC CONVERSION
 Q:'$D(^ICPT(ACPTN)) ACPTN ; RETURN NUMERIC CONVERSION IF IEN IS FREE
 S ACPTN=0 F ACPTCNT=100000:1 Q:ACPTN  S:'$D(^ICPT(ACPTCNT)) ACPTN=ACPTCNT ; STARTING FROM 100000, FIND NEXT AVAILABLE IEN
 Q ACPTN
 ; IHS/OIT/NKD ACPT*2.13*2
CPTMOD ; ASSIGN RANGES TO CPT MODIFIERS FOR EHR USE
 N ACPTI,ACPTR
 D BMES^XPDUTL("Correcting CPT Modifiers with blank CPT Ranges.")
 S ACPTI=0,ACPTR="" F  S ACPTI=$O(^DIC(81.3,ACPTI)) Q:'ACPTI  D
 . Q:'$D(^DIC(81.3,ACPTI,60))
 . Q:$D(^DIC(81.3,ACPTI,10))
 . N FDA
 . S FDA(81.32,"?+1,"_ACPTI_",",.01)="00100" ; Begin CPT Range
 . S FDA(81.32,"?+1,"_ACPTI_",",.02)="9999Z" ; End CPT Range
 . S FDA(81.32,"?+1,"_ACPTI_",",.03)="3100101" ; Active Date
 . D UPDATE^DIE(,"FDA",)
 . S ACPTR=ACPTR_$$GET1^DIQ(81.3,ACPTI,.01)_$J("",3)
 . I $L(ACPTR)>79 D MES^XPDUTL(ACPTR) S ACPTR=""
 I $L(ACPTR)>0 D MES^XPDUTL(ACPTR)
 Q
