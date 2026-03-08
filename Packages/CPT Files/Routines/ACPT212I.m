ACPT212I ;IHS/OIT/NKD - ACPT V2.12 P2 2012 CPT incremental load 09/19/12 ;
 ;;2.12;CPT FILES;**2**;DEC 13, 2011;Build 1
 ;
 Q
POST ; EP
 N ACPTT,ACPTA,ACPTC,ACPTYR
 S ACPTYR="3120101"
 F ACPTT="CPT","HCPCS"  D
 . Q:'$D(^ACPT(ACPTT))
 . F ACPTA="A","C","D","M"  D
 . . Q:'$D(^ACPT(ACPTT,ACPTA))
 . . D BMES^XPDUTL($G(^ACPT(ACPTT,ACPTA,0))_" "_ACPTT_" "_$S(ACPTA="A":"Adding",ACPTA="C":"Modifying",ACPTA="D":"Deleting",1:"Modifier")_" Codes:")
 . . S ACPTC=0
 . . F  S ACPTC=$O(^ACPT(ACPTT,ACPTA,ACPTC)) Q:'ACPTC  D
 . . . D @(ACPTT)(ACPTA,$G(^ACPT(ACPTT,ACPTA,ACPTC)))
 Q
CPT(ACPTA,ACPTD) ; CPT DRIVER
 I ACPTA="M" D CPTM(ACPTD)  Q
 N ACPTIEN,ACPTCODE,ACPTNAME,ACPTDESC,ACPTADT,ACPTEDT,ACPTTDT,ACPTCNT,ACPTRES,I
 S ACPTCODE=$P(ACPTD,"^",1)
 S ACPTNAME=$$UP^XLFSTR($TR($$CLEAN^ACPTUTL($P(ACPTD,"^",2)),";",","))
 S ACPTDESC=$$UP^XLFSTR($$CLEAN^ACPTUTL($P(ACPTD,"^",3)))
 S ACPTADT=$S($P(ACPTD,"^",4)]"":$P(ACPTD,"^",4)-17000000,1:"")
 S ACPTEDT=$S($P(ACPTD,"^",5)]"":$P(ACPTD,"^",5)-17000000,1:"")
 S ACPTTDT=$S($P(ACPTD,"^",6)]"":$P(ACPTD,"^",6)-17000000,1:"")
 I (ACPTA="D")&($L(ACPTTDT)<1) S ACPTTDT=ACPTEDT
 ;
 S ACPTIEN=""
 D FIND^DIC(81,"","@;.01;2;8I","OPX",ACPTCODE,"","","","","ACPTRES")
 S ACPTCNT=$P($G(ACPTRES("DILIST",0)),"^",1)
 I ACPTCNT=0 S ACPTIEN="" ; No matches found, create new
 I ACPTCNT=1 S ACPTIEN=$P($G(ACPTRES("DILIST",1,0)),"^",1) ; One match found, store IEN
 I ACPTCNT>1 S ACPTIEN=$P($G(ACPTRES("DILIST",1,0)),"^",1) ; Multiple matches found, use the first
 ; ACPT*2.12*2 Re-used CPT code that should create a duplicate
 S:ACPTCODE="90653" ACPTIEN=""
 I ((ACPTCNT>1)&(ACPTCODE="90653")) S ACPTIEN=""  D
 .F I=1:1:ACPTCNT S:$P(ACPTRES("DILIST",I,0),"^",4)=ACPTADT ACPTIEN=$P($G(ACPTRES("DILIST",I,0)),"^",1)
 K ACPTRES
 ;
 I ($L(ACPTIEN)<1)&(ACPTA="D") D MES^XPDUTL($J("",5)_ACPTCODE_$J("",15)_"Couldn't find code to inactivate") Q
 D UPD
 D MES^XPDUTL($J("",5)_ACPTCODE_$J("",15)_ACPTNAME)
 Q
 ;
HCPCS(ACPTA,ACPTD) ; HCPCS DRIVER
 N ACPTIEN,ACPTCODE,ACPTNAME,ACPTDESC,ACPTADT,ACPTEDT,ACPTTDT,ACPTCNT,ACPTRES
 S ACPTCODE=$P(ACPTD,"^",1)
 S ACPTNAME=$$CLEAN^ACPTUTL($P(ACPTD,"^",2))
 S ACPTDESC=$$UP^XLFSTR($$CLEAN^ACPTUTL($P(ACPTD,"^",3)))
 S ACPTADT=$S($P(ACPTD,"^",4)]"":$P(ACPTD,"^",4)-17000000,1:"")
 S ACPTEDT=$S($P(ACPTD,"^",5)]"":$P(ACPTD,"^",5)-17000000,1:"")
 S ACPTTDT=$S($P(ACPTD,"^",6)]"":$P(ACPTD,"^",6)-17000000,1:"")
 I ACPTA="M" D HCPCSM(ACPTD),MES^XPDUTL($J("",5)_ACPTCODE_$J("",10)_ACPTNAME)  Q
 ;
 S ACPTIEN=""
 D FIND^DIC(81,"","@;.01;2;8I","OPX",ACPTCODE,"","","","","ACPTRES")
 S ACPTCNT=$P($G(ACPTRES("DILIST",0)),"^",1)
 I ACPTCNT=0 S ACPTIEN="" ; No matches found, create new
 I ACPTCNT=1 S ACPTIEN=$P($G(ACPTRES("DILIST",1,0)),"^",1) ; One match found, store IEN
 I ACPTCNT>1 D
 .F ACPTCNT=1:1:$P($G(ACPTRES("DILIST",0)),"^",1) D  Q:$L(ACPTIEN)>0
 ..; If the Active Date (8) matches the HCPCS Add Date, store IEN
 ..I $P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",4)=ACPTADT S ACPTIEN=$P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",1) Q
 .; If no entries match Active Date, use most recently added
 .I $L(ACPTIEN)<1 S ACPTIEN=$P($G(ACPTRES("DILIST",$P($G(ACPTRES("DILIST",0)),"^",1),0)),"^",1)
 K ACPTRES
 ;
 ; If the code was added the same year as the install, a previous match was found, and the active dates are different,
 ; then ignore and create new
 ; Activates when codes are re-used and should NOT be linked to their previous definition
 I ($L(ACPTIEN)>0)&(ACPTA'="D") D
 .I ($E(ACPTADT,1,3)=$E(ACPTYR,1,3))&(ACPTADT'=$P($G(^ICPT(ACPTIEN,0)),"^",8)) S ACPTIEN=""
 ;
 I ($L(ACPTIEN)<1)&(ACPTA="D") D MES^XPDUTL($J("",5)_ACPTCODE_$J("",15)_"Couldn't find code to inactivate") Q
 D UPD
 D MES^XPDUTL($J("",5)_ACPTCODE_$J("",15)_ACPTNAME)
 Q
 ;
CPTM(ACPTD) ; CPT MODIFIERS
 Q
 ;
HCPCSM(ACPTD) ; HCPCS MODIFIERS
 N ACPTIEN,ACPTCNT,ACPTRES,FDA,NEWIEN,ACPTLST,ACPTDFR,ACPTDTO,ACPTNEW
 S ACPTNAME=$$UP^XLFSTR(ACPTNAME)
 ;
 S ACPTIEN=""
 D FIND^DIC(81.3,"","@;.01;.02;8I","OPX",ACPTCODE,"","","","","ACPTRES")
 S ACPTCNT=$P($G(ACPTRES("DILIST",0)),"^",1)
 I ACPTCNT=0 S ACPTIEN="" ; No matches found, create new
 I ACPTCNT=1 S ACPTIEN=$P($G(ACPTRES("DILIST",1,0)),"^",1)
 I ACPTCNT>1 D
 .F ACPTCNT=1:1:$P($G(ACPTRES("DILIST",0)),"^",1) D  Q:$L(ACPTIEN)>0
 ..I $P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",4)=ACPTADT S ACPTIEN=$P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",1)
 .I $L(ACPTIEN)>0 Q
 .I $L(ACPTIEN)<1 F ACPTCNT=1:1:$P($G(ACPTRES("DILIST",0)),"^",1) D  Q:$L(ACPTIEN)>0
 ..I $$UP^XLFSTR($P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",3))=ACPTNAME S ACPTIEN=$P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",1)
 I ($L(ACPTIEN)<1)&(ACPTTDT]"") D MES^XPDUTL($J("",5)_ACPTCODE_$J("",15)_"Couldn't find code to inactivate") Q
 K ACPTRES
 ;
 I $L(ACPTIEN)<1 D  ; if there isn't one, create it
 .K FDA,NEWIEN
 .S FDA(81.3,"+1,",.01)=ACPTCODE ; Modifier (.01)
 .S FDA(81.3,"+1,",.02)=ACPTNAME ; Name (.02)
 .D UPDATE^DIE(,"FDA","NEWIEN") ; Add the entry
 .S ACPTIEN=NEWIEN(1)
 Q:'ACPTIEN
 ;
 ; Effective Date (60)
 K FDA,ACPTRES,ACPTLST
 D LIST^DIC(81.33,","_ACPTIEN_",","@;.01I;.02I","P","","","","","","","ACPTRES","")
 S ACPTLST=$P($G(ACPTRES("DILIST",$P($G(ACPTRES("DILIST",0)),"^",1),0)),"^",3)
 I ((ACPTLST=0)&(ACPTTDT']""))!((ACPTLST=1)&(ACPTTDT]""))!($L(ACPTLST)<1) D
 .S FDA(81.33,"?+1,"_ACPTIEN_",",.01)=ACPTEDT ; Look for an entry for this install, add if not found
 .S FDA(81.33,"?+1,"_ACPTIEN_",",.02)=$S(ACPTTDT]"":0,1:1)
 .D UPDATE^DIE(,"FDA",)
 ;
 K FDA
 S:ACPTTDT']"" FDA(81.3,ACPTIEN_",",.02)=ACPTNAME ; Name (.02)
 S FDA(81.3,ACPTIEN_",",.04)="H" ; Source (.04)
 S FDA(81.3,ACPTIEN_",",5)=$S(ACPTTDT]"":1,1:"@") ; Inactive Flag (5)
 S FDA(81.3,ACPTIEN_",",7)=$S(ACPTTDT]"":ACPTTDT,1:"@") ; Inactive Date (7)
 S FDA(81.3,ACPTIEN_",",8)=ACPTADT ; Active Date (8)
 D UPDATE^DIE(,"FDA",)
 Q:ACPTTDT]""
 ;
 ; Description (50) WP
 D TEXT^ACPT212M(.ACPTDESC) ; convert string to WP array
 D WP^DIE(81.3,ACPTIEN_",",50,,"ACPTDESC")
 ;
 ; Name (Versioned) (61)
 K FDA,ACPTRES,ACPTLST
 ; Find the last Name
 D LIST^DIC(81.361,","_ACPTIEN_",","@;.01I;1I","P","","","","","","","ACPTRES","")
 S ACPTLST=$P($G(ACPTRES("DILIST",$P($G(ACPTRES("DILIST",0)),"^",1),0)),"^",3)
 ; If the two are different, create a new entry
 I ACPTLST'=ACPTNAME D
 .S FDA(81.361,"?+1,"_ACPTIEN_",",.01)=ACPTEDT ; Look for an entry for this install, add if not found
 .S FDA(81.361,"?+1,"_ACPTIEN_",",1)=ACPTNAME ; Set to ACPTNAME
 .D UPDATE^DIE(,"FDA",)
 ;
 ; Description (Versioned) (62)
 K FDA,NEWIEN,ACPTRES,ACPTLST,ACPTCNT,ACPTDFR,ACPTDTO,ACPTNEW
 S ACPTNEW=0
 ; Find the last Description
 D LIST^DIC(81.362,","_ACPTIEN_",","@;.01I","P","","","","","","","ACPTRES","")
 S ACPTCNT=$P($G(ACPTRES("DILIST",0)),"^",1)
 S ACPTLST=$$GET1^DIQ(81.362,ACPTCNT_","_ACPTIEN_",",1,"","ACPTLST","")
 S ACPTCNT=0,ACPTDTO=0
 F  S ACPTCNT=$O(ACPTDESC(ACPTCNT)) Q:'ACPTCNT  S ACPTDTO=ACPTDTO+1
 S ACPTCNT=0,ACPTDFR=0
 F  S ACPTCNT=$O(ACPTLST(ACPTCNT)) Q:'ACPTCNT  S ACPTDFR=ACPTDFR+1
 I ACPTDFR'=ACPTDTO S ACPTNEW=1
 E  F ACPTCNT=1:1:ACPTDTO D
 .I ACPTDESC(ACPTCNT)'=ACPTLST(ACPTCNT) S ACPTNEW=1
 ; If the two are different, create a new entry
 I ACPTNEW D
 .S FDA(81.362,"?+1,"_ACPTIEN_",",.01)=ACPTEDT ; Look for an entry for this install, add if not found
 .D UPDATE^DIE(,"FDA","NEWIEN")
 .I $D(NEWIEN) D WP^DIE(81.362,NEWIEN(1)_","_ACPTIEN_",",1,,"ACPTDESC")
 ;
 K FDA
 S FDA(81.3,ACPTIEN_",",8)=ACPTADT ; Active Date (8)
 D UPDATE^DIE(,"FDA",)
 Q
 ;
UPD ; PRIMARY UPDATER TO CPT FILE
 N FDA,NEWIEN,ACPTCHG,ACPTRES,ACPTLST,ACPTCNT,ACPTLSI,ACPTDFR,ACPTDTO,ACPTNEW
 ; If there isn't one, create it
 I $L(ACPTIEN)<1 D
 .K FDA,NEWIEN
 .S FDA(81,"+1,",.01)=ACPTCODE ; CPT Code (.01)
 .D UPDATE^DIE(,"FDA","NEWIEN") ; Add the entry
 .S ACPTIEN=NEWIEN(1),ACPTCHG=""
 Q:'ACPTIEN
 ; Effective Date (60)
 K FDA,ACPTRES,ACPTLST
 D LIST^DIC(81.02,","_ACPTIEN_",","@;.01I;.02I","P","","","","","","","ACPTRES","")
 S ACPTLST=$P($G(ACPTRES("DILIST",$P($G(ACPTRES("DILIST",0)),"^",1),0)),"^",3)
 I ((ACPTLST=0)&(ACPTA'="D"))!((ACPTLST=1)&(ACPTA="D"))!($L(ACPTLST)<1) D
 .S FDA(81.02,"?+1,"_ACPTIEN_",",.01)=ACPTEDT
 .S FDA(81.02,"?+1,"_ACPTIEN_",",.02)=$S(ACPTA="D":0,1:1)
 .D UPDATE^DIE(,"FDA",)
 ;
 K FDA
 S:ACPTA'="D" FDA(81,ACPTIEN_",",2)=ACPTNAME ; Short Name (2)
 S FDA(81,ACPTIEN_",",6)=$S(ACPTT="CPT":"C",ACPTT="HCPCS":"H",1:"@") ; Source (6)
 S FDA(81,ACPTIEN_",",5)=$S(ACPTA="D":1,1:"@") ; Inactive Flag (5)
 I (ACPTADT]"")&($$GET1^DIQ(81,ACPTIEN,8,"I")']"") S FDA(81,ACPTIEN_",",8)=ACPTADT ; Active Date (8)
 I (ACPTADT]"")&($$GET1^DIQ(81,ACPTIEN,9999999.06,"I")']"") S FDA(81,ACPTIEN_",",9999999.06)=ACPTADT ; Date Added (9999999.06)
 S FDA(81,ACPTIEN_",",7)=$S(ACPTA="D":ACPTTDT,1:"@") ; Inactive Date (7)
 S FDA(81,ACPTIEN_",",9999999.07)=$S(ACPTA="D":ACPTTDT,1:"@") ; Date Deleted (9999999.07)
 D UPDATE^DIE(,"FDA",)
 Q:ACPTA="D"
 ;
 ; Description (50)
 K FDA,ACPTCNT,ACPTRES
 D TEXT^ACPT212M(.ACPTDESC) ; Convert string to WP array
 I $L($G(^ICPT(ACPTIEN,"D",0)))<1 S ^ICPT(ACPTIEN,"D",0)="^81.01A" ; Fix global due to CSV
 ; Remove previous Description
 S ACPTCNT=0
 D GETS^DIQ(81,ACPTIEN,"50*","","ACPTRES")
 F  S ACPTCNT=$O(ACPTRES(81.01,ACPTCNT)) Q:'ACPTCNT  D
 .S ACPTRES(81.01,ACPTCNT,.01)="@"
 D UPDATE^DIE(,"ACPTRES",)
 ; Add new Description
 S ACPTCNT=0
 F  S ACPTCNT=$O(ACPTDESC(ACPTCNT)) Q:'ACPTCNT  D
 .S FDA(81.01,"+"_ACPTCNT_","_ACPTIEN_",",.01)=$G(ACPTDESC(ACPTCNT))
 D UPDATE^DIE(,"FDA",)
 ;
 ; Short Name (Versioned) (61)
 K FDA,ACPTRES,ACPTLST,ACPTCNT
 ; Find the last Short Name
 D LIST^DIC(81.061,","_ACPTIEN_",","@;.01I;1I","P","","","","","","","ACPTRES","")
 S ACPTLST=$P($G(ACPTRES("DILIST",$P($G(ACPTRES("DILIST",0)),"^",1),0)),"^",3)
 ; If the last is blank, find the previous until a Short Name is found
 I $L(ACPTLST)<1 F ACPTCNT=1:1:$P($G(ACPTRES("DILIST",0)),"^",1)-1 S ACPTLST=$P($G(ACPTRES("DILIST",$P($G(ACPTRES("DILIST",0)),"^",1)-ACPTCNT,0)),"^",3) Q:$L(ACPTLST)>0
 ; If the two are different, create a new entry
 I $$UP^XLFSTR($$CLEAN^ACPTUTL(ACPTLST))'=$$UP^XLFSTR($$CLEAN^ACPTUTL(ACPTNAME)) D
 .S FDA(81.061,"?+1,"_ACPTIEN_",",.01)=ACPTEDT ; Look for an entry for this install, add if not found
 .S FDA(81.061,"?+1,"_ACPTIEN_",",1)=ACPTNAME ; Set to ACPTNAME
 .D UPDATE^DIE(,"FDA",)
 ;
 ; Description (Versioned) (62)
 K FDA,NEWIEN,ACPTRES,ACPTLST,ACPTLSI,ACPTCNT,ACPTDFR,ACPTDTO,ACPTNEW
 S ACPTNEW=0
 ; Find the last Description
 D LIST^DIC(81.062,","_ACPTIEN_",","@;.01I","P","","","","","","","ACPTRES","")
 S ACPTCNT=$P($G(ACPTRES("DILIST",0)),"^",1)
 S ACPTLSI=$P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",1)
 D GETS^DIQ(81.062,ACPTLSI_","_ACPTIEN,"1*","","ACPTLST")
 ; Merge the entries into one string
 S ACPTCNT=0,ACPTDTO=""
 F  S ACPTCNT=$O(ACPTDESC(ACPTCNT)) Q:'ACPTCNT  S ACPTDTO=ACPTDTO_" "_ACPTDESC(ACPTCNT)
 S ACPTCNT=0,ACPTDFR=""
 F  S ACPTCNT=$O(ACPTLST(81.621,ACPTCNT)) Q:'ACPTCNT  S ACPTDFR($P(ACPTCNT,",",1))=ACPTLST(81.621,ACPTCNT,.01)
 S ACPTCNT=0
 F  S ACPTCNT=$O(ACPTDFR(ACPTCNT)) Q:'ACPTCNT  S ACPTDFR=ACPTDFR_" "_ACPTDFR(ACPTCNT)
 ; If the two are different, create a new entry
 I $$UP^XLFSTR($$CLEAN^ACPTUTL(ACPTDFR))'=$$UP^XLFSTR($$CLEAN^ACPTUTL(ACPTDTO)) D
 .S FDA(81.062,"?+1,"_ACPTIEN_",",.01)=ACPTEDT ; Look for an entry for this install, add if not found
 .D UPDATE^DIE(,"FDA","NEWIEN")
 .I $D(NEWIEN) D
 ..; Remove previous Description
 ..K ACPTRES
 ..S ACPTCNT=0
 ..D GETS^DIQ(81.062,NEWIEN(1)_","_ACPTIEN,"1*","","ACPTRES")
 ..F  S ACPTCNT=$O(ACPTRES(81.621,ACPTCNT)) Q:'ACPTCNT  D
 ...S ACPTRES(81.621,ACPTCNT,.01)="@"
 ..D UPDATE^DIE(,"ACPTRES",)
 ..; Add new Description
 ..S ACPTCNT=0
 ..F  S ACPTCNT=$O(ACPTDESC(ACPTCNT)) Q:'ACPTCNT  D
 ...S FDA(81.621,"+"_ACPTCNT_","_NEWIEN(1)_","_ACPTIEN_",",.01)=$G(ACPTDESC(ACPTCNT))
 ..D UPDATE^DIE(,"FDA",)
 ;
 I ACPTADT]"" D
 .K FDA
 .S FDA(81,ACPTIEN_",",8)=ACPTADT ; Active Date (8)
 .S FDA(81,ACPTIEN_",",9999999.06)=ACPTADT ; Date Added (9999999.06)
 .D UPDATE^DIE(,"FDA",)
 Q
