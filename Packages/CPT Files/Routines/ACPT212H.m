ACPT212H ;IHS/OIT/NKD - ACPT V2.12 P1 2012 HCPCS load (new DD) 02/06/12 ;
 ;;2.12;CPT FILES;**1**;DEC 13, 2011;Build 1
 ;
 Q  ;
IMPHCPC ;  this tag will load the complete file into ^TMP("ACPT-HCPCS",$J)
 N POP D  Q:POP
 .D OPEN^%ZISH("CPTHFILE",ACPTPTH,"acpt2012.01h","R")  ; open read-only
 .U IO(0)  ; use terminal
 .I POP D MES^XPDUTL("Could not open HCPCS file.")
 .E  D MES^XPDUTL("Reading HCPCS file.")
 ;
 K ^TMP("ACPT-HCPCS")
 K ACPTCNT  ; count entries to print a dot for every 100
 F ACPTCNT=1:1 D  Q:$$STATUS^%ZISH  ; loop until end of file
 .;
 .K ACPTLINE  ; each line extracted from the file
 .U IO R ACPTLINE:DTIME Q:$$STATUS^%ZISH
 .;
 .I $E(ACPTLINE,1)=" " D  ;this is a modifier
 ..S ACPTMOD=$E(ACPTLINE,4,5)  ;modifier code
 ..I $E(ACPTLINE,11)=7 D  ;first line of mod
 ...S ACPTLONG=$E(ACPTLINE,12,91)  ;mod desc.
 ...;[RNB] For ACPTLONG
 ...K ACPTX,ACPTY,ACPTZ,ACPTSTRX S ACPTZ=0 F ACPTX=1:1:$L(ACPTLONG) S ACPTY=$E(ACPTLONG,ACPTX) I ($A(ACPTY)<32)!($A(ACPTY)>126) S ACPTZ=1 Q
 ...I ACPTZ S ACPTSTRX=ACPTLONG D CLNSTR S ACPTLONG=ACPTSTRX ;Clean control characters
 ...S ACPTSHRT=$E(ACPTLINE,92,119)  ;mod name
 ...;[RNB] For ACPTSHRT
 ...K ACPTX,ACPTY,ACPTZ,ACPTSTRX S ACPTZ=0 F ACPTX=1:1:$L(ACPTSHRT) S ACPTY=$E(ACPTSHRT,ACPTX) I ($A(ACPTY)<32)!($A(ACPTY)>126) S ACPTZ=1 Q
 ...I ACPTZ S ACPTSTRX=ACPTSHRT D CLNSTR S ACPTSHRT=ACPTSTRX ;Clean control characters
 ...S ACPTADT=$E(ACPTLINE,269,276) ;add date
 ...S ACPTEDT=$E(ACPTLINE,277,284) ;effective date
 ...S ACPTTDT=$E(ACPTLINE,285,292) ;termination date
 ...S ACPTPNM=$E(ACPTLINE,294,353) ;previous name
 ...S ^TMP("ACPT-HCPCS",$J,"M",ACPTMOD)=ACPTSHRT_"^"_ACPTLONG_"^"_ACPTADT_"^"_ACPTEDT_"^"_ACPTTDT_"^"_ACPTPNM
 ..I $E(ACPTLINE,11)=8 D  ;second line of mod
 ...S ACPTLONG=$E(ACPTLINE,12,91)
 ...;[RNB] For ACPTLONG
 ...K ACPTX,ACPTY,ACPTZ,ACPTSTRX S ACPTZ=0 F ACPTX=1:1:$L(ACPTLONG) S ACPTY=$E(ACPTLONG,ACPTX) I ($A(ACPTY)<32)!($A(ACPTY)>126) S ACPTZ=1 Q
 ...I ACPTZ S ACPTSTRX=ACPTLONG D CLNSTR S ACPTLONG=ACPTSTRX ;Clean control characters
 ...S $P(^TMP("ACPT-HCPCS",$J,"M",ACPTMOD),U,2)=$P(^TMP("ACPT-HCPCS",$J,"M",ACPTMOD),U,2)_" "_ACPTLONG
 .;
 .I $E(ACPTLINE,1)'=" " D  ;this is a proc code
 ..S ACPTCODE=$E(ACPTLINE,1,5)  ;Proc code
 ..I $E(ACPTLINE,11)=3 D  ;first line of proc
 ...S ACPTLONG=$E(ACPTLINE,12,91)  ;proc long desc.
 ...;[RNB] For ACPTLONG
 ...K ACPTX,ACPTY,ACPTZ,ACPTSTRX S ACPTZ=0 F ACPTX=1:1:$L(ACPTLONG) S ACPTY=$E(ACPTLONG,ACPTX) I ($A(ACPTY)<32)!($A(ACPTY)>126) S ACPTZ=1 Q
 ...I ACPTZ S ACPTSTRX=ACPTLONG D CLNSTR S ACPTLONG=ACPTSTRX ;Clean control characters
 ...S ACPTSHRT=$E(ACPTLINE,92,119)  ;proc short desc.
 ...;[RNB] For ACPTSHRT
 ...K ACPTX,ACPTY,ACPTZ,ACPTSTRX S ACPTZ=0 F ACPTX=1:1:$L(ACPTSHRT) S ACPTY=$E(ACPTSHRT,ACPTX) I ($A(ACPTY)<32)!($A(ACPTY)>126) S ACPTZ=1 Q
 ...I ACPTZ S ACPTSTRX=ACPTSHRT D CLNSTR S ACPTSHRT=ACPTSTRX ;Clean control characters
 ...S ACPTACT=$E(ACPTLINE,293)  ;proc action code
 ...S ACPTACT=$S(ACPTACT="R":"A",ACPTACT="B"!(ACPTACT="S"):"C",ACPTACT="F"!(ACPTACT="P")!(ACPTACT="T"):"N",1:ACPTACT)
 ...Q:ACPTACT="N"  ;no maintenance codes are skipped
 ...S ACPTADT=$E(ACPTLINE,269,276) ;add date
 ...S ACPTEDT=$E(ACPTLINE,277,284) ;effective date
 ...S ACPTTDT=$E(ACPTLINE,285,292) ;termination date
 ...S ^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE)=ACPTSHRT_"^"_ACPTLONG_"^"_ACPTADT_"^"_ACPTEDT_"^"_ACPTTDT
 ..I $E(ACPTLINE,11)=4 D  ;second line of proc
 ...Q:'$D(^TMP("ACPT-HCPCS",$J,"A",ACPTCODE))&'$D(^TMP("ACPT-HCPCS",$J,"C",ACPTCODE))&'$D(^TMP("ACPT-HCPCS",$J,"D",ACPTCODE))
 ...S ACPTACT=$S($D(^TMP("ACPT-HCPCS",$J,"A",ACPTCODE)):"A",$D(^TMP("ACPT-HCPCS",$J,"C",ACPTCODE)):"C",$D(^TMP("ACPT-HCPCS",$J,"D",ACPTCODE)):"D",1:"")
 ...Q:ACPTACT=""
 ...S ACPTLONG=$E(ACPTLINE,12,91)
 ...;[RNB] For ACPTLONG
 ...K ACPTX,ACPTY,ACPTZ,ACPTSTRX S ACPTZ=0 F ACPTX=1:1:$L(ACPTLONG) S ACPTY=$E(ACPTLONG,ACPTX) I ($A(ACPTY)<32)!($A(ACPTY)>126) S ACPTZ=1 Q
 ...I ACPTZ S ACPTSTRX=ACPTLONG D CLNSTR S ACPTLONG=ACPTSTRX ;Clean control characters
 ...S $P(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE),U,2)=$P(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE),U,2)_" "_ACPTLONG
 .;
 .I '(ACPTCNT#100) U IO(0) W "."
 D ^%ZISC  ; close the file
 ;
 ;now actually load codes
 F ACPTACT="A","C","D","M" D
 .D BMES^XPDUTL("HCPCS "_$S(ACPTACT="A":"Adding",ACPTACT="C":"Modifying",ACPTACT="D":"Deleting",1:"Modifier")_" Codes:")
 .S ACPTCODE=""
 .F  S ACPTCODE=$O(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE)) Q:ACPTCODE=""  D
 ..I ACPTCODE?1U4N D HCPCS ;HCPCS codes
 ..I ACPTCODE?2U!(ACPTCODE?1U1N) D HCPCSM1^ACPT212M ;HCPCS modifier
 Q
HCPCS ; load CPTs from ^TMP("ACPT-HCPCS",$J)
 ;
 N ACPTIEN,ACPTNAME,ACPTDESC,ACPTADT,ACPTEDT,ACPTTDT,ACPTPNM,ACPTCNT,ACPTRES,ACTDT,FDA,NEWIEN,ACPTLST,ACPTDTO,ACPTDFR,ACPTNEW,ACPTCHG
 S ACPTNAME=$$CLEAN^ACPTUTL($P($G(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE)),U,1))
 S ACPTDESC=$$UP^XLFSTR($$CLEAN^ACPTUTL($P($G(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE)),U,2)))
 S ACPTADT=$P($G(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE)),U,3)-17000000
 S ACPTEDT=$P($G(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE)),U,4)-17000000
 S ACPTTDT=+$P($G(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE)),U,5)
 I ACPTTDT'=0 S ACPTTDT=ACPTTDT-17000000
 S ACPTCHG=0
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
 I ($L(ACPTIEN)>0)&(ACPTACT'="D") D
 .I ($E(ACPTADT,1,3)=$E(ACPTYR,1,3))&(ACPTADT'=$P($G(^DIC(81,ACPTIEN,0)),"^",8)) S ACPTIEN=""
 ;
 I ($L(ACPTIEN)<1)&(ACPTACT="D") D MES^XPDUTL($J("",5)_ACPTCODE_$J("",15)_"Couldn't find code to inactivate") Q
 I ($L(ACPTIEN)<1)&(ACPTACT'="D") D  ; If there isn't one, create it
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
 I (ACPTACT'="D")&((ACPTLST=0)!($L(ACPTLST)<1)) D
 .S FDA(81.02,"?+1,"_ACPTIEN_",",.01)=ACPTYR ; Look for an entry for this install, add if not found
 .S FDA(81.02,"?+1,"_ACPTIEN_",",.02)="1" ; Set to ACTIVE
 .D UPDATE^DIE(,"FDA",)
 .S ACPTCHG=1
 I (ACPTACT="D")&((ACPTLST=1)!($L(ACPTLST)<1)) D
 .S FDA(81.02,"?+1,"_ACPTIEN_",",.01)=ACPTYR ; Look for an entry for this install, add if not found
 .S FDA(81.02,"?+1,"_ACPTIEN_",",.02)="0" ; Set to INACTIVE
 .D UPDATE^DIE(,"FDA",)
 .S ACPTCHG=1
 ;
 K FDA
 S FDA(81,ACPTIEN_",",2)=ACPTNAME ; Short Name (2)
 S FDA(81,ACPTIEN_",",6)="H" ; Source (6)
 I (ACPTACT'="D") D
 .S FDA(81,ACPTIEN_",",5)="@" ; Inactive Flag (5) - Removed
 .S FDA(81,ACPTIEN_",",8)=ACPTADT ; Active Date (8)
 .S FDA(81,ACPTIEN_",",9999999.06)=ACPTADT ; Date Added (9999999.06)
 .S FDA(81,ACPTIEN_",",7)="@" ; Inactive Date (7) - Removed
 .S FDA(81,ACPTIEN_",",9999999.07)="@" ; Date Deleted (9999999.07) - Removed
 E  D
 .S FDA(81,ACPTIEN_",",5)="1" ; Inactive Flag (5) - Flagged inactive
 .S FDA(81,ACPTIEN_",",7)=ACPTTDT ; Inactive Date (7)
 .S FDA(81,ACPTIEN_",",9999999.07)=ACPTTDT ; Date Deleted (9999999.07)
 D UPDATE^DIE(,"FDA",)
 ;
 ; Description (50)
 K FDA,ACPTCNT,ACPTRES
 D TEXT^ACPT212M(.ACPTDESC) ; convert string to WP array
 I $L($G(^ICPT(ACPTIEN,"D",0)))<1 S ^ICPT(ACPTIEN,"D",0)="^81.01A" ; Fix global due to CSV
 ; Remove previous Description
 S ACPTCNT=0
 D GETS^DIQ(81,ACPTIEN,"50*","","ACPTRES")
 F  S ACPTCNT=$O(ACPTRES(81.01,ACPTCNT)) Q:'ACPTCNT  D
 .S ACPTRES(81.01,ACPTCNT,.01)="@"
 I (ACPTACT'="D") D UPDATE^DIE(,"ACPTRES",)
 ; Add new Description
 S ACPTCNT=0
 F  S ACPTCNT=$O(ACPTDESC(ACPTCNT)) Q:'ACPTCNT  D
 .S FDA(81.01,"+"_ACPTCNT_","_ACPTIEN_",",.01)=$G(ACPTDESC(ACPTCNT))
 I (ACPTACT'="D") D UPDATE^DIE(,"FDA",)
 ;
 ; Short Name (Versioned) (61)
 K FDA,ACPTRES,ACPTLST,ACPTCNT
 ; Find the last Short Name
 D LIST^DIC(81.061,","_ACPTIEN_",","@;.01I;1I","P","","","","","","","ACPTRES","")
 S ACPTLST=$P($G(ACPTRES("DILIST",$P($G(ACPTRES("DILIST",0)),"^",1),0)),"^",3)
 ; If the last is blank, find the previous until a Short Name is found
 I $L(ACPTLST)<1 F ACPTCNT=1:1:$P($G(ACPTRES("DILIST",0)),"^",1)-1 S ACPTLST=$P($G(ACPTRES("DILIST",$P($G(ACPTRES("DILIST",0)),"^",1)-ACPTCNT,0)),"^",3) Q:$L(ACPTLST)>0
 ; If the two are different, create a new entry
 I $$UP^XLFSTR(ACPTLST)'=$$UP^XLFSTR(ACPTNAME) D
 .S FDA(81.061,"?+1,"_ACPTIEN_",",.01)=ACPTYR ; Look for an entry for this install, add if not found
 .S FDA(81.061,"?+1,"_ACPTIEN_",",1)=ACPTNAME ; Set to ACPTNAME
 .I (ACPTACT'="D") D UPDATE^DIE(,"FDA",) S ACPTCHG=1
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
 I ($$UP^XLFSTR($$CLEAN^ACPTUTL(ACPTDFR))'=$$UP^XLFSTR($$CLEAN^ACPTUTL(ACPTDTO)))&(ACPTACT'="D") D
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
CLNSTR ; Clean string of control characters
 D CLEANCC^ACPTUTL(.ACPTSTRX,.ACPTMAPV,0) ; strip out the control characters
 U IO(0) D MES^XPDUTL("From acpt2012.01h"_"="_ACPTMAPV_"...") W ! ; show the problem (safely)
 Q
