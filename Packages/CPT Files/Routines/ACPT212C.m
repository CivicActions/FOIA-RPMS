ACPT212C ;IHS/OIT/NKD - ACPT V2.12 P1 2012 CPT load (new DD) 02/06/12 ;
 ;;2.12;CPT FILES;**1**;DEC 13, 2011;Build 1
 ;
 Q  ;
IMPCPT ; Processing for CPT codes and modifiers
 D LOADCPT ; Import and load CPT codes
 D LOADDEL ; Import and load CPT delete codes
 D LOADMOD ; Import and load CPT modifiers
 Q
 ;
LOADCPT ; Processing for CPT codes
 ;
 ; Read Short Description
 K ^TMP("ACPT-IMP",$J),^TMP("ACPT-CNT",$J)
 N POP D  Q:POP
 .D OPEN^%ZISH("CPTHFILE",ACPTPTH,"acpt2012.01s","R")  ; Open read-only
 .U IO(0)  ; Use terminal
 .I POP D MES^XPDUTL("Could not open CPT Short file.")
 .E  D MES^XPDUTL("Reading CPT Short file.")
 ;
 W !
 K ACPTCNT  ; Count entries to print a dot for every 100
 F ACPTCNT=1:1 D  Q:$$STATUS^%ZISH  ; Loop until end of file
 .;
 .K ACPTLINE  ; Each line extracted from the file
 .U IO R ACPTLINE:DTIME Q:$$STATUS^%ZISH
 .S ACPTCODE=$E(ACPTLINE,1,5) ; CPT Code
 .S ACPTSDSC=$E(ACPTLINE,7,$L(ACPTLINE)) ; Short Description
 .S ACPTSDSC=$P(ACPTSDSC,"  ",1)
 .K ACPTX,ACPTY,ACPTZ,ACPTSTRX S ACPTZ=0 F ACPTX=1:1:$L(ACPTSDSC) S ACPTY=$E(ACPTSDSC,ACPTX) I ($A(ACPTY)<32)!($A(ACPTY)>126) S ACPTZ=1 Q
 .I ACPTZ S ACPTSTRX=ACPTSDSC D CLNSTR S ACPTSDSC=ACPTSTRX ; Clean control characters
 .S ^TMP("ACPT-IMP",$J,ACPTCODE)=ACPTSDSC
 .S ^TMP("ACPT-CNT",$J)=+$G(^TMP("ACPT-CNT",$J))+1  ; Count
 .I '(ACPTCNT#100) U IO(0) W "."
 D ^%ZISC  ; Close the file
 ;
 ; Read Long Description
 D  Q:POP
 .D OPEN^%ZISH("CPTHFILE",ACPTPTH,"acpt2012.01l","R")  ; Open read-only
 .U IO(0)  ; Ese terminal
 .I POP D MES^XPDUTL("Could not open CPT Long file.")
 .E  D MES^XPDUTL("Reading CPT Long file.")
 ;
 W !
 K ACPTCNT  ; Count entries to print a dot for every 100
 F ACPTCNT=1:1 D  Q:$$STATUS^%ZISH  ; Loop until end of file
 .;
 .K ACPTLINE  ; Each line extracted from the file
 .U IO R ACPTLINE:DTIME Q:$$STATUS^%ZISH
 .S ACPTCODE=$P(ACPTLINE,$C(9),1) ; CPT Code
 .S ACPTLDSC=$P(ACPTLINE,$C(9),2) ; Long Description
 .K ACPTX,ACPTY,ACPTZ,ACPTSTRX S ACPTZ=0 F ACPTX=1:1:$L(ACPTLDSC) S ACPTY=$E(ACPTLDSC,ACPTX) I ($A(ACPTY)<32)!($A(ACPTY)>126) S ACPTZ=1 Q
 .I ACPTZ S ACPTSTRX=ACPTLDSC D CLNSTR S ACPTLDSC=ACPTSTRX ; Clean control characters
 .S ^TMP("ACPT-IMP",$J,ACPTCODE)=$G(^TMP("ACPT-IMP",$J,ACPTCODE))_"^"_ACPTLDSC
 .I '(ACPTCNT#100) U IO(0) W "."
 D ^%ZISC  ; Close the file
 ;
 ; Now actually load codes
 ;IHS/OIT/NKD ACPT*2.12*1 Replaced WRITE with XPDUTL
 D BMES^XPDUTL("CPT Adding/Updating Codes:")
 S ACPTCODE=""
 F  S ACPTCODE=$O(^TMP("ACPT-IMP",$J,ACPTCODE)) Q:ACPTCODE=""  D
 .D CPT  ; This will process the CPT codes
 ;
 Q
CPT ; Load CPTs from ^TMP("ACPT-IMP",$J)
 ;
 N ACPTIEN,ACPTNAME,ACPTL,ACPTDESC,ACPTPNM,ACPTCNT,ACPTRES,FDA,NEWIEN,ACPTLST,ACPTDTO,ACPTDFR,ACPTNEW,ACPTCHG
 S ACPTNAME=$$UP^XLFSTR($TR($$CLEAN^ACPTUTL($P($G(^TMP("ACPT-IMP",$J,ACPTCODE)),"^",1)),";",","))
 S ACPTDESC=$$UP^XLFSTR($$CLEAN^ACPTUTL($P($G(^TMP("ACPT-IMP",$J,ACPTCODE)),"^",2)))
 S ACPTCHG=0
 ;
 S ACPTIEN=""
 D FIND^DIC(81,"","@;.01;2","OPX",ACPTCODE,"","","","","ACPTRES")
 S ACPTCNT=$P($G(ACPTRES("DILIST",0)),"^",1)
 I ACPTCNT=0 S ACPTIEN="" ; No matches found, create new
 I ACPTCNT=1 S ACPTIEN=$P($G(ACPTRES("DILIST",1,0)),"^",1) ; One match found, store IEN
 I ACPTCNT>1 S ACPTIEN=$P($G(ACPTRES("DILIST",1,0)),"^",1) ; Multiple matches found, use the first
 K ACPTRES
 ;
 ; If there isn't one, create it
 I $L(ACPTIEN)<1 D
 .K FDA,NEWIEN
 .S FDA(81,"+1,",.01)=ACPTCODE ; CPT Code (.01)
 .D UPDATE^DIE(,"FDA","NEWIEN") ; Add the entry
 .S ACPTIEN=NEWIEN(1)
 .S ACPTCHG=1
 ;
 ; Effective Date (60)
 K FDA,ACPTRES,ACPTLST
 D LIST^DIC(81.02,","_ACPTIEN_",","@;.01I;.02I","P","","","","","","","ACPTRES","")
 S ACPTLST=$P($G(ACPTRES("DILIST",$P($G(ACPTRES("DILIST",0)),"^",1),0)),"^",3)
 I (ACPTLST=0)!($L(ACPTLST)<1) D
 .S FDA(81.02,"?+1,"_ACPTIEN_",",.01)=ACPTYR ; Look for an entry for this install, add if not found
 .S FDA(81.02,"?+1,"_ACPTIEN_",",.02)="1" ; Set to ACTIVE
 .D UPDATE^DIE(,"FDA",)
 .S ACPTCHG=1
 ;
 K FDA
 S FDA(81,ACPTIEN_",",2)=ACPTNAME ; Short Name (2)
 S FDA(81,ACPTIEN_",",6)="C" ; Source (6)
 S FDA(81,ACPTIEN_",",5)="@" ; Inactive Flag (5) - Remove
 I ACPTCHG D
 .S FDA(81,ACPTIEN_",",8)=ACPTYR ; Active Date (8)
 .S FDA(81,ACPTIEN_",",9999999.06)=ACPTYR ; Date Added (9999999.06)
 S FDA(81,ACPTIEN_",",7)="@" ; Inactive Date (7) - Remove
 S FDA(81,ACPTIEN_",",9999999.07)="@" ; Date Deleted (9999999.07) - Remove
 D UPDATE^DIE(,"FDA",)
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
 .S FDA(81.061,"?+1,"_ACPTIEN_",",.01)=ACPTYR ; Look for an entry for this install, add if not found
 .S FDA(81.061,"?+1,"_ACPTIEN_",",1)=ACPTNAME ; Set to ACPTNAME
 .D UPDATE^DIE(,"FDA",) S ACPTCHG=1
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
 .S FDA(81.062,"?+1,"_ACPTIEN_",",.01)=ACPTYR ; Look for an entry for this install, add if not found
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
 ..S ACPTCHG=1
 ;
 I ACPTCHG D MES^XPDUTL($J("",5)_ACPTCODE_$J("",15)_ACPTNAME)
 ;
 Q
 ;
LOADMOD ;  this tag will load the complete file into ^TMP("ACPT-MOD",$J)
 K ^TMP("ACPT-MOD",$J),^TMP("ACPT-MCNT",$J)
 N POP D  Q:POP
 .D OPEN^%ZISH("CPTHFILE",ACPTPTH,"acpt2012.01m","R")  ; Open read-only
 .U IO(0)  ; Use terminal
 .I POP D MES^XPDUTL("Could not open CPT Modifier file.")
 .E  D MES^XPDUTL("Reading CPT Modifier file.")
 ;
 K ACPTCNT  ; Count entries to print a dot for every 100
 F ACPTCNT=1:1 D  Q:$$STATUS^%ZISH  ; Loop until end of file
 .;
 .K ACPTLINE  ; Each line extracted from the file
 .U IO R ACPTLINE:DTIME Q:$$STATUS^%ZISH
 .S ACPTMOD=$P(ACPTLINE,$C(9),1) ; Modifier
 .S ACPTNAME=$P(ACPTLINE,$C(9),2) ; Name
 .K ACPTX,ACPTY,ACPTZ,ACPTSTRX S ACPTZ=0 F ACPTX=1:1:$L(ACPTNAME) S ACPTY=$E(ACPTNAME,ACPTX) I ($A(ACPTY)<32)!($A(ACPTY)>126) S ACPTZ=1 Q
 .I ACPTZ S ACPTSTRX=ACPTNAME D CLNSTR S ACPTNAME=ACPTSTRX ; Clean control characters
 .S ACPTDESC=$P(ACPTLINE,$C(9),3) ; Description
 .K ACPTX,ACPTY,ACPTZ,ACPTSTRX S ACPTZ=0 F ACPTX=1:1:$L(ACPTDESC) S ACPTY=$E(ACPTDESC,ACPTX) I ($A(ACPTY)<32)!($A(ACPTY)>126) S ACPTZ=1 Q
 .I ACPTZ S ACPTSTRX=ACPTDESC D CLNSTR S ACPTDESC=ACPTSTRX ; Clean control characters
 .S ACPTPNAM=$P(ACPTLINE,$C(9),4) ; Previous name
 .K ACPTX,ACPTY,ACPTZ,ACPTSTRX S ACPTZ=0 F ACPTX=1:1:$L(ACPTPNAM) S ACPTY=$E(ACPTPNAM,ACPTX) I ($A(ACPTY)<32)!($A(ACPTY)>126) S ACPTZ=1 Q
 .I ACPTZ S ACPTSTRX=ACPTPNAM D CLNSTR S ACPTPNAM=ACPTSTRX ; Clean control characters
 .S ACPTINAC=$P(ACPTLINE,$C(9),5) ; Inactive
 .S ^TMP("ACPT-MOD",$J,ACPTMOD)=ACPTNAME_"^"_ACPTDESC_"^"_ACPTPNAM_"^"_ACPTINAC,^TMP("ACPT-MCNT",$J)=+$G(^TMP("ACPT-MCNT",$J))+1
 D ^%ZISC  ; Close the file
 ; Now actually load codes
 D BMES^XPDUTL("CPT Modifier Codes:")
 S ACPTCODE=0
 F  S ACPTCODE=$O(^TMP("ACPT-MOD",$J,ACPTCODE)) Q:ACPTCODE=""  D
 .D CPTM1^ACPT212M  ; This will process the CPT modifiers
 ;
 Q
 ;
LOADDEL ;  This load the complete file into ^TMP("ACPT-DEL",$J)
 K ^TMP("ACPT-DEL",$J),^TMP("ACPT-DCNT",$J)
 N POP D  Q:POP
 .D OPEN^%ZISH("CPTHFILE",ACPTPTH,"acpt2012.01d","R")  ; Open read-only
 .U IO(0)  ; Use terminal
 .I POP D MES^XPDUTL("Could not open CPT Delete file.")
 .E  D MES^XPDUTL("Reading CPT Delete file.")
 ;
 K ACPTCNT  ; Count entries to print a dot for every 100
 F ACPTCNT=1:1 D  Q:$$STATUS^%ZISH  ; Loop until end of file
 .;
 .K ACPTLINE  ; Each line extracted from the file
 .U IO R ACPTLINE:DTIME Q:$$STATUS^%ZISH
 .S ACPTFIEN=$P(ACPTLINE,"|")  ; File IEN (concept ID)
 .Q:+ACPTFIEN=0  ; No file IEN
 .S ACPTCD=$P(ACPTLINE,"|",2)  ; Code
 .Q:$L(ACPTCD)'=5  ; All codes should be 5 chars
 .Q:($P(ACPTLINE,"|",3)'=2012)  ;IHS/OIT/NKD ACPT*2.12*1 only 2012 deletes
 .S ^TMP("ACPT-DEL",$J,ACPTFIEN,ACPTCD)=$P(ACPTLINE,"|",3),^TMP("ACPT-DCNT",$J)=+$G(^TMP("ACPT-DCNT",$J))+1  ; Only CPT entries
 D ^%ZISC  ; Close the file
 ; Now actually load codes
 D BMES^XPDUTL("Deleting Codes:")
 S ACPTFIEN=0
 F  S ACPTFIEN=$O(^TMP("ACPT-DEL",$J,ACPTFIEN)) Q:+ACPTFIEN=0  D
 .S ACPTCODE=0
 .F  S ACPTCODE=$O(^TMP("ACPT-DEL",$J,ACPTFIEN,ACPTCODE)) Q:+ACPTCODE=0  D
 ..D DELETE  ; This will actually flag code as deleted in ^ICPT
 ;
 Q
 ;
DELETE ; Load CPTs from ^TMP("ACPT-DEL",$J)
 ;
 N ACPTIEN,ACPTCNT,ACPTRES,FDA,NEWIEN,ACPTLST,ACPTCHG,ACPTINAC,ACPTNAME
 S ACPTINAC="1/1/"_$P($G(^TMP("ACPT-DEL",$J,ACPTFIEN,ACPTCODE)),"^",1)
 S ACPTCHG=0
 ;
 S ACPTIEN=""
 D FIND^DIC(81,"","@;.01;2","OPX",ACPTCODE,"","","","","ACPTRES")
 S ACPTCNT=$P($G(ACPTRES("DILIST",0)),"^",1)
 I ACPTCNT=0 S ACPTIEN="" ; No matches found
 I ACPTCNT=1 S ACPTIEN=$P($G(ACPTRES("DILIST",1,0)),"^",1),ACPTNAME=$P($G(ACPTRES("DILIST",1,0)),"^",3) ; One match found, store IEN
 I ACPTCNT>1 S ACPTIEN=$P($G(ACPTRES("DILIST",1,0)),"^",1),ACPTNAME=$P($G(ACPTRES("DILIST",1,0)),"^",3) ; Multiple matches found, use the first
 K ACPTRES
 ;
 I $L(ACPTIEN)<1 D MES^XPDUTL($J("",5)_ACPTCODE_$J("",15)_"Couldn't find code to inactivate") Q
 ; Effective Date (60)
 K FDA,ACPTRES,ACPTLST
 D LIST^DIC(81.02,","_ACPTIEN_",","@;.01I;.02I","P","","","","","","","ACPTRES","")
 S ACPTLST=$P($G(ACPTRES("DILIST",$P($G(ACPTRES("DILIST",0)),"^",1),0)),"^",3)
 I $L(ACPTLST)<1 F ACPTCNT=1:1:$P($G(ACPTRES("DILIST",0)),"^",1)-1 S ACPTLST=$P($G(ACPTRES("DILIST",$P($G(ACPTRES("DILIST",0)),"^",1)-ACPTCNT,0)),"^",3) Q:$L(ACPTLST)>0
 I (ACPTLST=1)!($L(ACPTLST)<1) D
 .S FDA(81.02,"?+1,"_ACPTIEN_",",.01)=ACPTINAC ; Look for an entry for this install, add if not found
 .S FDA(81.02,"?+1,"_ACPTIEN_",",.02)="0" ; Set to INACTIVE
 .D UPDATE^DIE("E","FDA",)
 .S ACPTCHG=1
 ;
 K FDA
 S FDA(81,ACPTIEN_",",5)="1" ; Inactive Flag (5)
 S FDA(81,ACPTIEN_",",7)=ACPTINAC ; Inactive Date (7)
 S FDA(81,ACPTIEN_",",9999999.07)=ACPTINAC ; Date Deleted (9999999.07)
 I ACPTCHG D UPDATE^DIE("E","FDA",),MES^XPDUTL($J("",5)_ACPTCODE_$J("",15)_ACPTNAME)
 ;
 Q
 ;
CLNSTR ; Clean string of control characters
 D CLEANCC^ACPTUTL(.ACPTSTRX,.ACPTMAPV,0) ; strip out the control characters
 U IO(0) D MES^XPDUTL("From acpt2012.01"_"="_ACPTMAPV_"...") W ! ; show the problem (safely)
 Q
