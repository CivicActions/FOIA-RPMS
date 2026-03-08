ACPT2102 ;IHS/SD/RNB - ACPT 2.11 2011 HCPCS load (new DD) ; 10 Nov 2010 08:47 AM
 ;;2.11;CPT FILES;**1**;JAN 03, 2011
 ;
 Q  ;
IMPHCPCS ;  this tag will load the complete file into ^TMP("ACPT-IMP",$J) using the concept ID
 ;  and the property ID as the identifiers
 N POP D  Q:POP
 .D OPEN^%ZISH("CPTHFILE",ACPTPTH,"acpt2011.01h","R")  ; open read-only
 .U IO(0)  ; use terminal
 .I POP D MES^XPDUTL("Could not open HCPCS file.")
 .E  D MES^XPDUTL("Reading HCPCS file.")
 ;
 ; Fields that will be used with their character counts
 ; Chars   Field
 ; 1-5     HCPCS code
 ; 4-5     HCPCS modifier
 ; 6-10    HCPCS Sequence # - used to group proc or modifier codes together
 ; 11-11   HCPCS Rec ID code
 ;   3=First line of proc code
 ;   4=Second, third, fourth, etc. desc of proc
 ;   7=First line of mod code
 ;   8=Second, third, fourth, etc desc of mod
 ; 12-91   Long description
 ; 92-119  Short description
 ; 269-276 HCPCS Code Added Date
 ;;;; 277-284 HCPCS Action Effective Date (not used)
 ; 285-292 HCPCS Termination Date
 ; 293-293 HCPCS Action Code
 ;  a A=Add proc or mod code
 ;  c B=Change in both admin data field & long desc.
 ;  c C=Change in long desc
 ;  d D=Discontinued
 ;  n F=Change in admin data field
 ;  n N=No maintenance for this code
 ;  n P=Payment change
 ;  a R=Reactivate disc/deleted code
 ;  c S=Change in short desc
 ;  n T=Misc change (TOS, BETOS, etc)
 ;
 W !
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
 ...S ACPTLONG=$E(ACPTLINE,12,91)  ;mod long desc.
 ...;[RNB] For ACPTLONG
 ...K ACPTX,ACPTY,ACPTZ,ACPTSTRX S ACPTZ=0 F ACPTX=1:1:$L(ACPTLONG) S ACPTY=$E(ACPTLONG,ACPTX) I ($A(ACPTY)<32)!($A(ACPTY)>126) S ACPTZ=1 Q
 ...I ACPTZ S ACPTSTRX=ACPTLONG D CLNSTR S ACPTLONG=ACPTSTRX ;Clean control characters
 ...S ACPTSHRT=$E(ACPTLINE,92,119)  ;mod short desc.
 ...;[RNB] For ACPTSHRT
 ...K ACPTX,ACPTY,ACPTZ,ACPTSTRX S ACPTZ=0 F ACPTX=1:1:$L(ACPTSHRT) S ACPTY=$E(ACPTSHRT,ACPTX) I ($A(ACPTY)<32)!($A(ACPTY)>126) S ACPTZ=1 Q
 ...I ACPTZ S ACPTSTRX=ACPTSHRT D CLNSTR S ACPTSHRT=ACPTSTRX ;Clean control characters
 ...S ^TMP("ACPT-HCPCS",$J,"M",ACPTMOD)=ACPTSHRT_"^"_ACPTLONG
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
 ...S ^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE)=ACPTSHRT_"^"_ACPTLONG
 ...I ACPTACT="D" S $P(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE),U,3)=$E(ACPTLINE,285,292)
 ...I ACPTACT="A" S $P(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE),U,3)=$E(ACPTLINE,269,276)
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
 .W !!,"HCPCS ",$S(ACPTACT="A":"ADDING",ACPTACT="C":"Modifying",ACPTACT="D":"Deleting",1:"Modifier")_" Codes:"
 .S ACPTCODE=""
 .F  S ACPTCODE=$O(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE)) Q:ACPTCODE=""  D
 ..I ACPTACT'="D" D LOADCODE  ;this will actually load code into ^ICPT
 ..I ACPTACT="D" D DELCODE  ;delete codes
 ..W !?5,ACPTCODE
 ..W ?15,$S($G(ACPTSHRT)'="":ACPTSHRT,1:"NO SHORT DESC FOUND")
 Q
CLNSTR ; Clean string of control characters
 D CLEANCC^ACPTUTL(.ACPTSTRX,.ACPTMAPV,0) ; strip out the control characters
 U IO(0) D MES^XPDUTL("From acpt2011.01h"_"="_ACPTMAPV_"...") W ! ; show the problem (safely)
 Q
LOADCODE ; load CPTs from ^TMP("ACPT-HCPCS",$J)
 ;
 K ACPTNEW,ACPTIEN,ACPTSHRT,ACPTDESC,ACPTSHRO
 Q:(ACPTCODE'?1U4N)&(ACPTCODE'?2U)&(ACPTCODE'?1U1N)  ;check format of code
 ;
 I ACPTCODE?1U4N D  ;HCPCS codes
 .S ACPTIEN=$O(^ICPT("B",ACPTCODE,0))  ; find the code's record number
 .I '$D(^ICPT("B",ACPTCODE)) D  ; if there isn't one, create it
 ..S ACPTIEN=$A($E(ACPTCODE,1))_$E(ACPTCODE,2,5)
 ..K DIC,DIE,X,Y,DA
 ..S X=ACPTCODE
 ..S DIC("DR")="8////"_ACPTYR_";9999999.06////"_ACPTYR
 ..;if they sent a date, use it instead
 ..I $P($G(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE)),U,3)'="" D
 ...S ACPTDT=($P(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE),U,3)-17000000)
 ...S DIC("DR")="8////"_ACPTDT_";9999999.06////"_ACPTDT
 ..S DIC="^ICPT("
 ..S DIC(0)="LI"
 ..D ^DIC
 .;
 .S ACPTSHRT=$$CLEAN^ACPTUTL($P($G(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE)),U))  ; clean up the Short Name
 .I ACPTSHRT[";" S ACPTSHRT=$TR(ACPTSHRT,";",":")
 .I ACPTSHRT'="" D
 ..K DIC,DIE,X,Y,DA,DR
 ..S DIE="^ICPT("
 ..S DA=ACPTIEN
 ..S DR="2////"_ACPTSHRT
 ..D ^DIE
 .;
 .S DR=DR_";7////@;9999999.07////@"  ;Inactive Date and Date Deleted
 .S DR=DR_";5////@"  ;Inactive Flag
 .I $P($G(^ICPT(ACPTIEN,0)),U,8)="" S DR=DR_";8////"_ACPTYR  ;Active Date
 .I $P($G(^ICPT(ACPTIEN,9999999)),U,6)="" S DR=DR_";9999999.06////"_ACPTYR  ;Date Added
 .D ^DIE
 .S ACPTDESC=$$CLEAN^ACPTUTL($P($G(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE)),U,2))  ; clean up the Description
 .D TEXT^ACPTUTL(.ACPTDESC) ; convert string to WP array
 .K ^ICPT(ACPTIEN,"D") ; clean out old Description (50)
 .M ^ICPT(ACPTIEN,"D")=ACPTDESC ; copy array to field, incl. header
 .K DIC,DIE,X,Y,DA,DR
 .S DA(1)=ACPTIEN
 .S DIK="^ICPT("_DA(1)_",""D"","
 .S DIK(1)=".01"
 .S ACPTI=0
 .F  S ACPTI=$O(^ICPT(ACPTIEN,50,ACPTI)) Q:+ACPTI=0  D
 ..S DA=ACPTI
 ..D EN1^DIK
 .;
 .S ACPTEDT=$O(^ICPT(ACPTIEN,60,"B",9999999),-1)  ; find the last
 .N ACPTEIEN S ACPTEIEN=$O(^ICPT(ACPTIEN,60,"B",+ACPTEDT,0))  ; its IEN
 .;
 .I ACPTEDT=3110101,ACPTEIEN D  ; if there is one for this install date
 ..Q:$P($G(^ICPT(ACPTIEN,60,ACPTEIEN,0)),U,2)  ; if active, we're fine
 ..; otherwise, we need to activate it:
 ..K DIC,DIE,DA,DIR,X,Y
 ..S DA=+ACPTEIEN  ; IEN of last Effective Date
 ..S DA(1)=ACPTIEN  ; IEN of its parent CPT
 ..S DIE="^ICPT("_DA(1)_",60,"  ; Effective Date (60/81.02)
 ..S DR=".02////1"  ; set Status field to ACTIVE
 ..N DIDEL,DTOUT  ; other parameters for DIE
 ..D ^DIE  ; Fileman Data Edit call
 .;
 .E  D  ; if not, then we need one
 ..K DIC,DIE,DA,X,Y,DIR
 ..S DA(1)=ACPTIEN  ; into subfile under new entry
 ..S DIC="^ICPT("_DA(1)_",60,"  ; Effective Date (60/81.02)
 ..S DIC(0)="L"  ; LAYGO
 ..S DIC("P")=$P(^DD(81,60,0),U,2)  ; subfile # & specifier codes
 ..S X="01/01/2011"  ; new entry for 1/1/2011
 ..S DIC("DR")=".02////1"  ; with Status = 1 (active)
 ..N DLAYGO,Y,DTOUT,DUOUT  ; other parameters
 ..D ^DIC  ; Fileman LAYGO lookup
 .;
 .;versioned short description
 .S ACPTSDTL=$O(^ICPT(ACPTIEN,61,"B",9999999),-1)  ;get last short desc date
 .S ACPTSHRO=""
 .I ACPTSDTL'="" D
 ..S ACPTSDTI=$O(^ICPT(ACPTIEN,61,"B",ACPTSDTL,0))  ;get last short desc IEN
 ..S ACPTSHRO=$P($G(^ICPT(ACPTIEN,61,ACPTSDTI,0),""),U,2)  ;get last short desc
 .;short desc now not equal last short desc
 .I $$UP^XLFSTR($$TRIM^XLFSTR(ACPTSHRO,"LR"))'=$$UP^XLFSTR($$TRIM^XLFSTR(ACPTSHRT,"LR")) D
 ..D ^XBFMK
 ..S DA(1)=ACPTIEN
 ..S DIC="^ICPT("_DA(1)_",61,"
 ..S DIC(0)="L"
 ..S X=ACPTYR
 ..S DIC("DR")="1///"_ACPTSHRT
 ..D ^DIC
 .;
 .;versioned description
 .S ACPTDSCO=""
 .S ACPTDIEN=0
 .S ACPTDSCN=""
 .F  S ACPTDIEN=$O(^ICPT(ACPTIEN,"D",ACPTDIEN)) Q:'ACPTDIEN  D
 ..S ACPTDSCN=$$TRIM^XLFSTR(ACPTDSCN,"R")_" "_$G(^ICPT(ACPTIEN,"D",ACPTDIEN,0))
 .S ACPTDDT=$O(^ICPT(ACPTIEN,62,"B",9999999),-1)  ;get last desc date
 .I ACPTDDT'="" D
 ..S ACPTDIEN=$O(^ICPT(ACPTIEN,62,"B",ACPTDDT,0))  ;get last desc IEN
 ..S ACPTIIEN=0
 ..F  S ACPTIIEN=$O(^ICPT(ACPTIEN,62,ACPTDIEN,1,ACPTIIEN)) Q:'ACPTIIEN  D
 ...S ACPTDSCO=$$TRIM^XLFSTR(ACPTDSCO,"R")_" "_$G(^ICPT(ACPTIEN,62,ACPTDIEN,1,ACPTIIEN,0))
 .;description not equal to old description
 .I $$UP^XLFSTR($$TRIM^XLFSTR(ACPTDSCO,"LR"))'=$$UP^XLFSTR($$TRIM^XLFSTR(ACPTDSCN,"LR")) D
 ..D TEXT^ACPTUTL(ACPTDSCN)
 ..D ^XBFMK
 ..S DA(1)=ACPTIEN
 ..S DIC="^ICPT("_DA(1)_",62,"
 ..S DIC(0)="L"
 ..S X=ACPTYR
 ..D ^DIC
 ..S ACPTDIEN=+Y
 ..K DIC,DIE,DR,DA,X,Y
 ..S DA(2)=ACPTIEN
 ..S DA(1)=ACPTDIEN
 ..S DIC="^ICPT("_DA(2)_",62,"_DA(1)_",1,"
 ..S DIC("P")=$P(^DD(81.062,1,0),U,2)
 ..S DIC(0)="L"
 ..S ACPTI=0
 ..F  S ACPTI=$O(ACPTDESC(ACPTI)) Q:'ACPTI  D
 ...S X=$$UP^XLFSTR(ACPTDESC(ACPTI,0))
 ...D ^DIC
 ;
 ; add modifiers
 I ACPTCODE?2U!(ACPTCODE?1U1N) D
 .S ACPTIEN=$O(^AUTTCMOD("B",ACPTCODE,0)) ; find code's record number
 .I 'ACPTIEN D  ; if there isn't one yet, create it
 ..S ACPTIEN=$A(ACPTCODE)_$A(ACPTCODE,2) ; DINUM based on ASCII of code
 ..S ^AUTTCMOD(ACPTIEN,0)=ACPTCODE_U_U_ACPTYR ; set Code & Date Added
 ..S ^AUTTCMOD("B",ACPTCODE,ACPTIEN)="" ; and cross-reference it
 .;
 .S ACPTSHRT=$$CLEAN^ACPTUTL($P($G(^TMP("ACPT-HCPCS",$J,"M",ACPTCODE)),U),1)  ;Short desc
 .I ACPTSHRT'="" D  ; if a description is present in the AMA file
 ..S $P(^AUTTCMOD(ACPTIEN,0),U,2)=ACPTSHRT ; set the field
 .S $P(^AUTTCMOD(ACPTIEN,0),U,4)="" ; clear Date Deleted (.04)
 .;
 .N ACPTDESC ; Long Description (1)
 .S ACPTDESC=$$CLEAN^ACPTUTL($P($G(^TMP("ACPT-HCPCS",$J,"M",ACPTCODE)),U,2))  ;Long Desc
 .D TEXT^ACPTUTL(.ACPTDESC) ; convert string to WP array
 .K ^AUTTCMOD(ACPTIEN,1) ; delete its subtree
 .M ^AUTTCMOD(ACPTIEN,1)=ACPTDESC  ; copy array to field, incl. header
 ;
 U IO(0) W:'(ACPTCNT#100) "."
 Q
 ;
DELCODE ;
 S ACPTIEN=0,IEN=0
 S ACPTSHRT="Couldn't find code to inactivate"
 F  S ACPTIEN=$O(^ICPT("B",ACPTCODE,ACPTIEN)) Q:'ACPTIEN  D  ; find the code's record number
 .S:$P($G(^ICPT(ACPTIEN,0)),U,2)'="" ACPTSHRT=$P(^ICPT(ACPTIEN,0),U,2)
 .; Date Deleted and Inactive Date
 .S ($P(^ICPT(ACPTIEN,9999999),U,7),$P(^ICPT(ACPTIEN,0),U,7))=3101231
 .I $P($G(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE)),U,3)'="" S ($P(^ICPT(ACPTIEN,9999999),U,7),$P(^ICPT(ACPTIEN,0),U,7))=($P($G(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE)),U,3)-17000000)
 .;
 .K DIC,DIE,DIR,X,Y,DA,DR
 .S DA(1)=ACPTIEN  ; parent record, i.e., the CPT code
 .S DIC="^ICPT("_DA(1)_",60,"  ; Effective Date subfile (60/81.02)
 .S DIC(0)="L"  ; allow LAYGO (Learn As You Go, i.e., add if not found)
 .S DIC("P")=$P(^DD(81,60,0),"^",2)  ; subfile # & specifier codes
 .S X="01/01/2011"  ; value to lookup in the subfile
 .I $P($G(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE)),U,3)'="" D
 ..S X=$P($G(^TMP("ACPT-HCPCS",$J,ACPTACT,ACPTCODE)),U,3)
 ..S X=$E(X,5,6)_$E(X,7,8)_$E(X,1,4)
 .D ^DIC  ; Fileman Lookup call
 .S DA=+Y  ; save IEN of found/added record for next call below
 .;
 .K DIR,DIE,DIC,X,Y,DR
 .S DA(1)=ACPTIEN
 .S IEN=ACPTIEN
 .S DIE="^ICPT("_DA(1)_",60,"  ; Effective Date subfile (60/81.02)
 .S DR=".02////0"  ; set Status field to INACTIVE
 .D ^DIE  ; Fileman Data Edit call
 S ACPTIEN=IEN
 Q
