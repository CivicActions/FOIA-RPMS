ACPT212M ;IHS/OIT/NKD - ACPT V2.12 P1 2012 CPT/HCPCS modifier load (new DD) 02/06/12 ;
 ;;2.12;CPT FILES;**1**;DEC 13, 2011;Build 1
 ;
 Q  ;
CPTM1 ; load CPT modifiers from ^TMP("ACPT-MOD",$J)
 ;
 N ACPTIEN,ACPTNAME,ACPTDESC,ACPTPNM,ACPTINAC,ACPTCNT,ACPTRES,ACTDT,FDA,NEWIEN,ACPTCHG
 S ACPTNAME=$$UP^XLFSTR($$CLEAN^ACPTUTL($P($G(^TMP("ACPT-MOD",$J,ACPTCODE)),U,1)))
 S ACPTDESC=$$UP^XLFSTR($$CLEAN^ACPTUTL($P($G(^TMP("ACPT-MOD",$J,ACPTCODE)),U,2)))
 S ACPTPNM=$$UP^XLFSTR($$CLEAN^ACPTUTL($P($G(^TMP("ACPT-MOD",$J,ACPTCODE)),U,3)))
 S ACPTINAC=$P($G(^TMP("ACPT-MOD",$J,ACPTCODE)),U,4) I $L(ACPTINAC)<1 S ACPTINAC=0
 I $L(ACPTNAME)<1 S ACPTNAME=$E(ACPTDESC,1,60)
 S ACPTCHG=1
 ;
 S ACPTIEN=""
 D FIND^DIC(81.3,"","@;.01;.02;.04I","OPX",ACPTCODE,"","","","","ACPTRES")
 S ACPTCNT=$P($G(ACPTRES("DILIST",0)),"^",1)
 I ACPTCNT=0 S ACPTIEN="" ; No matches found, create new
 I ACPTCNT=1 S ACPTIEN=$P($G(ACPTRES("DILIST",1,0)),"^",1) ; One match found, store IEN
 I ACPTCNT>1 D
 .F ACPTCNT=1:1:$P($G(ACPTRES("DILIST",0)),"^",1) D  Q:$L(ACPTIEN)>0
 ..; If the source doesn't match, skip
 ..I $P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",4)'="C" Q
 ..I $$UP^XLFSTR($P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",3))=ACPTNAME S ACPTIEN=$P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",1) Q
 ..I $$UP^XLFSTR($P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",3))=ACPTPNM S ACPTIEN=$P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",1) Q
 .I $L(ACPTIEN)>0 Q
 .I $L(ACPTIEN)<1 F ACPTCNT=1:1:$P($G(ACPTRES("DILIST",0)),"^",1) D  Q:$L(ACPTIEN)>0
 ..I $$UP^XLFSTR($P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",3))=ACPTNAME S ACPTIEN=$P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",1) Q
 ..I $$UP^XLFSTR($P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",3))=ACPTPNM S ACPTIEN=$P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",1) Q
 K ACPTRES
 ;
 I ($L(ACPTIEN)<1)&(ACPTINAC=0) D  ; if there isn't one, create it
 .K FDA,NEWIEN
 .S FDA(81.3,"+1,",.01)=ACPTCODE ; Modifier (.01)
 .S FDA(81.3,"+1,",.02)=ACPTNAME ; Name (.02)
 .D UPDATE^DIE(,"FDA","NEWIEN") ; Add the entry
 .S ACPTIEN=NEWIEN(1)
 ;
 ; Effective Date (60)
 K FDA
 S FDA(81.33,"?+1,"_ACPTIEN_",",.01)=ACPTYR ; Look for an entry for this install, add if not found
 I ACPTINAC=0 S FDA(81.33,"?+1,"_ACPTIEN_",",.02)="1" ; Set to ACTIVE if no Inactive flag
 E  S FDA(81.33,"?+1,"_ACPTIEN_",",.02)="0" ; Set to INACTIVE if Inactive flag present
 D UPDATE^DIE(,"FDA",)
 ;
 K FDA
 S FDA(81.3,ACPTIEN_",",.02)=ACPTNAME ; Name (.02)
 S FDA(81.3,ACPTIEN_",",.04)="C" ; Source (.04)
 I ACPTINAC=0 D
 .S FDA(81.3,ACPTIEN_",",5)="@" ; Inactive Flag (5) - Removed
 .S FDA(81.3,ACPTIEN_",",8)=ACPTYR ; Active Date (8)
 E  D
 .S FDA(81.3,ACPTIEN_",",5)="1" ; Inactive Flag (5) - Flagged inactive
 .S FDA(81.3,ACPTIEN_",",7)=ACPTYR ; Inactive Date (7)
 D UPDATE^DIE(,"FDA",)
 ;
 ; Range (10)
 ;IHS/OIT/NKD ACPT*2.12*1 Add complete CPT range to all modifiers dated 1/1/10 for EHR display EHR*1.1*9
 K FDA
 S FDA(81.32,"+1,"_ACPTIEN_",",.01)="00100" ; Begin CPT Range
 S FDA(81.32,"+1,"_ACPTIEN_",",.02)="9999Z" ; End CPT Range
 S FDA(81.32,"+1,"_ACPTIEN_",",.03)="3100101" ; Active Date
 I ACPTINAC=0 D UPDATE^DIE(,"FDA",)
 ;
 ; Description (50) WP
 D TEXT(.ACPTDESC) ; convert string to WP array
 D WP^DIE(81.3,ACPTIEN_",",50,,"ACPTDESC")
 ;
 ; Name (Versioned) (61)
 K FDA
 S FDA(81.361,"?+1,"_ACPTIEN_",",.01)=ACPTYR ; Look for an entry for this install, add if not found
 S FDA(81.361,"?+1,"_ACPTIEN_",",1)=ACPTNAME ; Set to ACPTNAME
 D UPDATE^DIE(,"FDA",)
 ;
 ; Description (Versioned) (62)
 K FDA,NEWIEN
 S FDA(81.362,"?+1,"_ACPTIEN_",",.01)=ACPTYR ; Look for an entry for this install, add if not found
 D UPDATE^DIE(,"FDA","NEWIEN")
 I $D(NEWIEN) D WP^DIE(81.362,NEWIEN(1)_","_ACPTIEN_",",1,,"ACPTDESC")
 ;
 I ACPTCHG D MES^XPDUTL($J("",5)_ACPTCODE_$J("",10)_ACPTNAME)
 ;
 Q
 ;
HCPCSM1 ; load HCPCS modifiers from ^TMP("ACPT-HCPCS",$J,"M")
 ;
 N ACPTIEN,ACPTNAME,ACPTDESC,ACPTADT,ACPTEDT,ACPTTDT,ACPTPNM,ACPTCNT,ACPTRES,ACTDT,FDA,NEWIEN,ACPTCHG,ACPTFST
 S ACPTNAME=$$UP^XLFSTR($$CLEAN^ACPTUTL($P($G(^TMP("ACPT-HCPCS",$J,"M",ACPTCODE)),U,1)))
 S ACPTDESC=$$UP^XLFSTR($$CLEAN^ACPTUTL($P($G(^TMP("ACPT-HCPCS",$J,"M",ACPTCODE)),U,2)))
 S ACPTADT=$P($G(^TMP("ACPT-HCPCS",$J,"M",ACPTCODE)),U,3)-17000000
 S ACPTEDT=$P($G(^TMP("ACPT-HCPCS",$J,"M",ACPTCODE)),U,4)-17000000
 S ACPTTDT=+$P($G(^TMP("ACPT-HCPCS",$J,"M",ACPTCODE)),U,5)
 I ACPTTDT'=0 S ACPTTDT=ACPTTDT-17000000
 S ACPTPNM=$$UP^XLFSTR($$CLEAN^ACPTUTL($P($G(^TMP("ACPT-HCPCS",$J,"M",ACPTCODE)),U,6)))
 S ACPTCHG=1
 ;
 S ACPTIEN=""
 D FIND^DIC(81.3,"","@;.01;.02;.04I","OPX",ACPTCODE,"","","","","ACPTRES")
 S ACPTCNT=$P($G(ACPTRES("DILIST",0)),"^",1)
 I ACPTCNT=0 S ACPTIEN="" ; No matches found, create new
 I ACPTCNT=1 S ACPTIEN=$P($G(ACPTRES("DILIST",1,0)),"^",1) ; One match found, store IEN
 I ACPTCNT>1 D
 .F ACPTCNT=1:1:$P($G(ACPTRES("DILIST",0)),"^",1) D  Q:$L(ACPTIEN)>0
 ..; If the source doesn't match, skip
 ..I $P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",4)'="H" Q
 ..I $$UP^XLFSTR($P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",3))=ACPTNAME S ACPTIEN=$P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",1) Q
 ..I $$UP^XLFSTR($P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",3))=ACPTPNM S ACPTIEN=$P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",1) Q
 .I $L(ACPTIEN)>0 Q
 .I $L(ACPTIEN)<1 F ACPTCNT=1:1:$P($G(ACPTRES("DILIST",0)),"^",1) D  Q:$L(ACPTIEN)>0
 ..I $$UP^XLFSTR($P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",3))=ACPTNAME S ACPTIEN=$P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",1) Q
 ..I $$UP^XLFSTR($P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",3))=ACPTPNM S ACPTIEN=$P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",1) Q
 K ACPTRES
 ;
 ;IHS/OIT/NKD ACPT*2.12*1 Clean the previous entries for GD and Q1 due to bad VA data
 I ((ACPTCODE="GD")!(ACPTCODE="Q1"))&($L(ACPTIEN)>0) D
 .K FDA,ACPTRES,ACPTLST,ACPTFST
 .D LIST^DIC(81.33,","_ACPTIEN_",","@;.01I;.02I","P","","","","","","","ACPTRES","")
 .S ACPTFST=$P($G(ACPTRES("DILIST",1,0)),"^",2)
 .S ACPTLST=$P($G(ACPTRES("DILIST",$P($G(ACPTRES("DILIST",0)),"^",1),0)),"^",1)
 .S FDA(81.33,ACPTLST_","_ACPTIEN_",",.01)="@" ; Remove
 .D UPDATE^DIE(,"FDA",)
 .S FDA(81.3,ACPTIEN_",",8)=ACPTFST ; Active Date (8)
 .S FDA(81.3,ACPTIEN_",",5)="1" ; Inactive Flag (5) - Flagged inactive
 .D UPDATE^DIE(,"FDA",)
 ;
 ;IHS/OIT/NKD ACPT*2.12*1 The following codes should create a duplicate entry rather than matching
 I "AY|CG|GU|JD|KE|PI|PS|RE|GD|Q1|PD"[ACPTCODE S ACPTIEN=""
 ;
 I $L(ACPTIEN)<1 D  ; if there isn't one, create it
 .K FDA,NEWIEN
 .S FDA(81.3,"+1,",.01)=ACPTCODE ; Modifier (.01)
 .S FDA(81.3,"+1,",.02)=ACPTNAME ; Name (.02)
 .D UPDATE^DIE(,"FDA","NEWIEN") ; Add the entry
 .S ACPTIEN=NEWIEN(1)
 S ACTDT=$$GET1^DIQ(81.3,ACPTIEN,8,"I")
 ;
 ; Effective Date (60)
 K FDA
 S FDA(81.33,"?+1,"_ACPTIEN_",",.01)=ACPTYR ; Look for an entry for this install, add if not found
 I ACPTTDT=0 S FDA(81.33,"?+1,"_ACPTIEN_",",.02)="1" ; Set to ACTIVE if no TERMINATION DATE
 E  S FDA(81.33,"?+1,"_ACPTIEN_",",.02)="0" ; Set to INACTIVE if TERMINATION DATE present
 D UPDATE^DIE(,"FDA",)
 ;
 K FDA
 S FDA(81.3,ACPTIEN_",",.02)=ACPTNAME ; Name (.02)
 S FDA(81.3,ACPTIEN_",",.04)="H" ; Source (.04)
 I ACPTTDT=0 D
 .S FDA(81.3,ACPTIEN_",",5)="@" ; Inactive Flag (5) - Removed
 .S FDA(81.3,ACPTIEN_",",8)=ACPTADT ; Active Date (8)
 E  D
 .S FDA(81.3,ACPTIEN_",",5)="1" ; Inactive Flag (5) - Flagged inactive
 .S FDA(81.3,ACPTIEN_",",7)=ACPTYR ; Inactive Date (7) - Replace ACPTYR with ACPTTDT on incremental updates
 D UPDATE^DIE(,"FDA",)
 ;
 ; Range (10)
 ;IHS/OIT/NKD ACPT*2.12*1 Add complete CPT range to all modifiers dated 1/1/10 for EHR display EHR*1.1*9
 K FDA
 S FDA(81.32,"+1,"_ACPTIEN_",",.01)="00100" ; Begin CPT Range
 S FDA(81.32,"+1,"_ACPTIEN_",",.02)="9999Z" ; End CPT Range
 S FDA(81.32,"+1,"_ACPTIEN_",",.03)="3100101" ; Active Date
 I ACPTTDT=0 D UPDATE^DIE(,"FDA",)
 ;
 ; Description (50) WP
 D TEXT(.ACPTDESC) ; convert string to WP array
 D WP^DIE(81.3,ACPTIEN_",",50,,"ACPTDESC")
 ;
 ; Name (Versioned) (61)
 K FDA
 S FDA(81.361,"?+1,"_ACPTIEN_",",.01)=ACPTYR ; Look for an entry for this install, add if not found
 S FDA(81.361,"?+1,"_ACPTIEN_",",1)=ACPTNAME ; Set to ACPTNAME
 D UPDATE^DIE(,"FDA",)
 ;
 ; Description (Versioned) (62)
 K FDA,NEWIEN
 S FDA(81.362,"?+1,"_ACPTIEN_",",.01)=ACPTYR ; Look for an entry for this install, add if not found
 D UPDATE^DIE(,"FDA","NEWIEN")
 I $D(NEWIEN) D WP^DIE(81.362,NEWIEN(1)_","_ACPTIEN_",",1,,"ACPTDESC")
 ;
 I ACPTCHG D MES^XPDUTL($J("",5)_ACPTCODE_$J("",10)_ACPTNAME)
 ;
 Q
 ;
HCPCSM2 ; load HCPCS modifiers from ^TMP("ACPT-HCPCS",$J,"M")
 ;
 N ACPTIEN,ACPTNAME,ACPTDESC,ACPTADT,ACPTEDT,ACPTTDT,ACPTPNM,ACPTCNT,ACPTRES,ACTDT,FDA,NEWIEN,ACPTLST,ACPTDTO,ACPTDFR,ACPTNEW,ACPTCHG
 S ACPTNAME=$$UP^XLFSTR($$CLEAN^ACPTUTL($P($G(^TMP("ACPT-HCPCS",$J,"M",ACPTCODE)),U,1)))
 S ACPTDESC=$$UP^XLFSTR($$CLEAN^ACPTUTL($P($G(^TMP("ACPT-HCPCS",$J,"M",ACPTCODE)),U,2)))
 S ACPTADT=$P($G(^TMP("ACPT-HCPCS",$J,"M",ACPTCODE)),U,3)-17000000
 S ACPTEDT=$P($G(^TMP("ACPT-HCPCS",$J,"M",ACPTCODE)),U,4)-17000000
 S ACPTTDT=+$P($G(^TMP("ACPT-HCPCS",$J,"M",ACPTCODE)),U,5)
 I ACPTTDT'=0 S ACPTTDT=ACPTTDT-17000000
 S ACPTCHG=0
 ;
 S ACPTIEN=""
 D FIND^DIC(81.3,"","@;.01;.02;8I","OPX",ACPTCODE,"","","","","ACPTRES")
 S ACPTCNT=$P($G(ACPTRES("DILIST",0)),"^",1)
 I ACPTCNT=0 S ACPTIEN="" ; No matches found, create new
 I ACPTCNT=1 S ACPTIEN=$P($G(ACPTRES("DILIST",1,0)),"^",1) D
 .I $P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",4)=ACPTADT ; One match found, store IEN
 .E  S ACPTIEN=""
 I ACPTCNT>1 D
 .F ACPTCNT=1:1:$P($G(ACPTRES("DILIST",0)),"^",1) D  Q:$L(ACPTIEN)>0
 ..I $P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",4)=ACPTADT S ACPTIEN=$P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",1)
 .I $L(ACPTIEN)>0 Q
 .I $L(ACPTIEN)<1 F ACPTCNT=1:1:$P($G(ACPTRES("DILIST",0)),"^",1) D  Q:$L(ACPTIEN)>0
 ..I $$UP^XLFSTR($P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",3))=ACPTNAME S ACPTIEN=$P($G(ACPTRES("DILIST",ACPTCNT,0)),"^",1)
 K ACPTRES
 ;
 I $L(ACPTIEN)<1 D  ; if there isn't one, create it
 .K FDA,NEWIEN
 .S FDA(81.3,"+1,",.01)=ACPTCODE ; Modifier (.01)
 .S FDA(81.3,"+1,",.02)=ACPTNAME ; Name (.02)
 .D UPDATE^DIE(,"FDA","NEWIEN") ; Add the entry
 .S ACPTIEN=NEWIEN(1)
 .S ACPTCHG=1
 ;
 ; Effective Date (60)
 K FDA,ACPTRES,ACPTLST
 D LIST^DIC(81.33,","_ACPTIEN_",","@;.01I;.02I","P","","","","","","","ACPTRES","")
 S ACPTLST=$P($G(ACPTRES("DILIST",$P($G(ACPTRES("DILIST",0)),"^",1),0)),"^",3)
 I (ACPTTDT=0)&((ACPTLST=0)!($L(ACPTLST)<1)) D
 .S FDA(81.33,"?+1,"_ACPTIEN_",",.01)=ACPTYR ; Look for an entry for this install, add if not found
 .S FDA(81.33,"?+1,"_ACPTIEN_",",.02)="1" ; Set to ACTIVE
 .D UPDATE^DIE(,"FDA",)
 .S ACPTCHG=1
 I (ACPTTDT>0)&((ACPTLST=1)!($L(ACPTLST)<1)) D
 .S FDA(81.33,"?+1,"_ACPTIEN_",",.01)=ACPTYR ; Look for an entry for this install, add if not found
 .S FDA(81.33,"?+1,"_ACPTIEN_",",.02)="0" ; Set to INACTIVE
 .D UPDATE^DIE(,"FDA",)
 .S ACPTCHG=1
 ;
 K FDA
 S FDA(81.3,ACPTIEN_",",.02)=ACPTNAME ; Name (.02)
 S FDA(81.3,ACPTIEN_",",.04)="H" ; Source (.04)
 I ACPTTDT=0 D
 .S FDA(81.3,ACPTIEN_",",5)="@" ; Inactive Flag (5) - Removed
 .S FDA(81.3,ACPTIEN_",",8)=ACPTADT ; Active Date (8) - ACPTADT on incremental updates
 E  D
 .S FDA(81.3,ACPTIEN_",",5)="1" ; Inactive Flag (5) - Flagged inactive
 .S FDA(81.3,ACPTIEN_",",7)=ACPTYR ; Inactive Date (7) - Replace ACPTYR with ACPTTDT on incremental updates
 D UPDATE^DIE(,"FDA",)
 ;
 ; Description (50) WP
 D TEXT(.ACPTDESC) ; convert string to WP array
 D WP^DIE(81.3,ACPTIEN_",",50,,"ACPTDESC")
 ;
 ; Name (Versioned) (61)
 K FDA,ACPTRES,ACPTLST
 ; Find the last Name
 D LIST^DIC(81.361,","_ACPTIEN_",","@;.01I;1I","P","","","","","","","ACPTRES","")
 S ACPTLST=$P($G(ACPTRES("DILIST",$P($G(ACPTRES("DILIST",0)),"^",1),0)),"^",3)
 ; If the two are different, create a new entry
 I ACPTLST'=ACPTNAME D
 .S FDA(81.361,"?+1,"_ACPTIEN_",",.01)=ACPTYR ; Look for an entry for this install, add if not found
 .S FDA(81.361,"?+1,"_ACPTIEN_",",1)=ACPTNAME ; Set to ACPTNAME
 .D UPDATE^DIE(,"FDA",)
 .S ACPTCHG=1
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
 .S FDA(81.362,"?+1,"_ACPTIEN_",",.01)=ACPTYR ; Look for an entry for this install, add if not found
 .D UPDATE^DIE(,"FDA","NEWIEN")
 .I $D(NEWIEN) D WP^DIE(81.362,NEWIEN(1)_","_ACPTIEN_",",1,,"ACPTDESC")
 .S ACPTCHG=1
 ;
 I ACPTCHG D MES^XPDUTL($J("",5)_ACPTCODE_$J("",10)_ACPTNAME)
 ;
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
 ...;
 ...I "&_+-*/<=>}])|:;,.?!"[$E(ACPTSTRN,ACPTRY) D  Q  ; on delimiter?
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
