ACPT21NL ;IHS/SD/RNB - ACPT 2.11 2011 load (new DD) ;10 Nov 2010 08:47 AM
 ;;2.11;CPT FILES;**1**;JAN 03, 2011
 ;
 Q  ;
IMPCPT ;  this tag will load the complete file into ^TMP("ACPT-IMP",$J) using the concept ID
 ;  and the property ID as the identifiers
 K ^TMP("ACPT-IMP",$J),^TMP("ACPT-CPTS",$J),^TMP("ACPT-CNT",$J)
 N POP D  Q:POP
 .D OPEN^%ZISH("CPTHFILE",ACPTPTH,"acpt2011.01l","R")  ; open read-only
 .U IO(0)  ; use terminal
 .I POP D MES^XPDUTL("Could not open CPT file.")
 .E  D MES^XPDUTL("Reading CPT file.")
 ;
 W !
 K ACPTCNT  ; count entries to print a dot for every 100
 F ACPTCNT=1:1 D  Q:$$STATUS^%ZISH  ; loop until end of file
 .;
 .K ACPTLINE  ; each line extracted from the file
 .U IO R ACPTLINE:DTIME Q:$$STATUS^%ZISH
 .S ACPTCODE=$P(ACPTLINE,$C(9),1) ; CPT Code
 .S ACPTLDSC=$P(ACPTLINE,$C(9),2) ; Long Description
 .;[RNB ADD NEXT CONDITION]
 .K ACPTX,ACPTY,ACPTZ S ACPTZ=0 F ACPTX=1:1:$L(ACPTLDSC) S ACPTY=$E(ACPTLDSC,ACPTX) I ($A(ACPTY)<32)!($A(ACPTY)>126) S ACPTZ=1 Q
 .I ACPTZ D  ;Clean control characters
 ..D CLEAN^ACPT210A(.ACPTLDSC,.ACPTMAPV,0) ; strip out the control characters
 ..U IO(0) D MES^XPDUTL("From acpt2011.01l"_"="_ACPTMAPV_"...") W ! ; show the problem (safely)
 ..Q
 .;
 .;S ACPTFIEN=$P(ACPTLINE,"|")  ;file IEN (concept ID)
 .;S ACPTPID=$P(ACPTLINE,"|",2)  ;property ID
 .;the below check has to be done for long description; it could be spread over
 .;multiple lines and have 01, 02 etc on each line.
 .S ACPTLCNT=1
 .;S ACPTLCNT=$S(ACPTPID=106:1,$P(ACPTLINE,"|",3)[":"&($P(+$P(ACPTLINE,"|",3),":")'=0):+$P($P(ACPTLINE,"|",3),":"),1:1)
 .;S ACPTDATA=$S(+$P($P(ACPTLINE,"|",3),":",2)'=0&(ACPTPID'=106):$P($P(ACPTLINE,"|",3),":",2),(+$P($P(ACPTLINE,"|",3),":",2)=0)&(ACPTPID'=106):$P(ACPTLINE,"|",3),1:$P(ACPTLINE,"|",3))
 .S ^TMP("ACPT-IMP",$J,ACPTCODE,104,ACPTLCNT)=ACPTCODE
 .S ^TMP("ACPT-IMP",$J,ACPTCODE,106,ACPTLCNT)=ACPTLDSC
 .;I ACPTPID=104,($P(ACPTLINE,"|",3)'="") D
 .S ^TMP("ACPT-CPTS",$J,ACPTCODE,104)=""  ;only CPT entries
 .S ^TMP("ACPT-CNT",$J)=+$G(^TMP("ACPT-CNT",$J))+1  ;count
 .;[RNB]I '(ACPTFIEN#100) U IO(0) W "."
 .I '(ACPTCNT#100) U IO(0) W "."
 D ^%ZISC  ; close the file
 ;
 ; READ FOR SHORT DESCRIPTION
 ;
 D  Q:POP
 .D OPEN^%ZISH("CPTHFILE",ACPTPTH,"acpt2011.01s","R")  ; open read-only
 .U IO(0)  ; use terminal
 .I POP D MES^XPDUTL("Could not open CPT file.")
 .E  D MES^XPDUTL("Reading CPT file.")
 ;
 W !
 K ACPTCNT  ; count entries to print a dot for every 100
 F ACPTCNT=1:1 D  Q:$$STATUS^%ZISH  ; loop until end of file
 .;
 .K ACPTLINE  ; each line extracted from the file
 .U IO R ACPTLINE:DTIME Q:$$STATUS^%ZISH
 .S ACPTCODE=$E(ACPTLINE,1,5) ; CPT Code
 .S ACPTSDSC=$E(ACPTLINE,7,$L(ACPTLINE)) ; Long Description
 .S ACPTSDSC=$P(ACPTSDSC,"  ",1)
 .;[RNB ADD NEXT CONDITION]
 .K ACPTX,ACPTY,ACPTZ S ACPTZ=0 F ACPTX=1:1:$L(ACPTSDSC) S ACPTY=$E(ACPTSDSC,ACPTX) I ($A(ACPTY)<32)!($A(ACPTY)>126) S ACPTZ=1 Q
 .I ACPTZ D  ;Clean control characters
 ..D CLEAN^ACPT210A(.ACPTSDSC,.ACPTMAPV,0) ; strip out the control characters
 ..U IO(0) D MES^XPDUTL("From acpt2011.01s"_"="_ACPTMAPV_"...") W ! ; show the problem (safely)
 ..Q
 .;
 .;S ACPTFIEN=$P(ACPTLINE,"|")  ;file IEN (concept ID)
 .;S ACPTPID=$P(ACPTLINE,"|",2)  ;property ID
 .;the below check has to be done for long description; it could be spread over
 .;multiple lines and have 01, 02 etc on each line.
 .S ACPTLCNT=1
 .;S ACPTLCNT=$S(ACPTPID=106:1,$P(ACPTLINE,"|",3)[":"&($P(+$P(ACPTLINE,"|",3),":")'=0):+$P($P(ACPTLINE,"|",3),":"),1:1)
 .;S ACPTDATA=$S(+$P($P(ACPTLINE,"|",3),":",2)'=0&(ACPTPID'=106):$P($P(ACPTLINE,"|",3),":",2),(+$P($P(ACPTLINE,"|",3),":",2)=0)&(ACPTPID'=106):$P(ACPTLINE,"|",3),1:$P(ACPTLINE,"|",3))
 .S ^TMP("ACPT-IMP",$J,ACPTCODE,111,ACPTLCNT)=ACPTSDSC
 .;[RNB]I '(ACPTFIEN#100) U IO(0) W "."
 .I '(ACPTCNT#100) U IO(0) W "."
 D ^%ZISC  ; close the file
 ;
 ;now actually load codes
 W !,"ADDING/UPDATING CODES:"
 ;S ACPTFIEN=0
 ;F  S ACPTFIEN=$O(^TMP("ACPT-CPTS",$J,ACPTFIEN)) Q:+ACPTFIEN=0  D
 S ACPTCODE=""
 F  S ACPTCODE=$O(^TMP("ACPT-CPTS",$J,ACPTCODE)) Q:ACPTCODE=""  D
 .D LOADCODE  ;this will actually load code into ^ICPT
 .W !?5,ACPTCODE,?15,ACPTSHRT
 ;
 ;D DELETE  ;now process deletes
 Q
 ;
LOADCODE ; load CPTs from ^TMP("ACPT-IMP",$J)
 ;
 K ACPTNEW,ACPTIEN,ACPTSHRT,ACPTDESC
 Q:(ACPTCODE'?5N)&(ACPTCODE'?4N1U)  ;cpt or ####F
 ;
 S ACPTIEN=$O(^ICPT("B",ACPTCODE,0))  ; find the code's record number
 I '$D(^ICPT("B",ACPTCODE)) D  ; if there isn't one, create it
 .K DIC,DIE,X,Y,DA,DIR,DIK,DR
 .S ACPTIEN=$S(ACPTCODE?4N1U:$A($E(ACPTCODE,1))_$A($E(ACPTCODE,2))_$A($E(ACPTCODE,3))_$A($E(ACPTCODE,4))_$A($E(ACPTCODE,5)),1:+ACPTCODE)
 .;S X=ACPTIEN
 .S ^ICPT(ACPTIEN,0)=ACPTCODE  ; CPT Code field (.01)
 .S ^ICPT("B",ACPTCODE,ACPTIEN)=""  ; index of CPT Codes
 .S ($P(^ICPT(ACPTIEN,9999999),U,6),$P(^ICPT(ACPTIEN,0),U,8))=ACPTYR  ;Date Added (7)
 .;S DIC("DR")="8////"_ACPTYR_";9999999.06////"_ACPTYR
 .;S DIC="^ICPT("
 .;S DIC(0)="L"
 .;D ^DIC
 I $P(^ICPT(ACPTIEN,9999999),U,6)=ACPTYR S ACPTNEW=1
 ;
 ;S ACPTNODE=$G(^ICPT(ACPTIEN,0))  ; get record's header node
 S ACPTSHRT=$$UP^XLFSTR($TR($$CLEAN^ACPT21NL($G(^TMP("ACPT-IMP",$J,ACPTCODE,111,1))),";",","))  ; clean up the Short Name
 ;I ACPTSHRT'="" S $P(ACPTNODE,U,2)=ACPTSHRT  ; update it
 I ACPTSHRT'="" D
 .S DIE="^ICPT("
 .S DA=ACPTIEN
 .S DR="2////"_ACPTSHRT
 .D ^DIE
 ;
 K DIC,DIE,DA,DR,X,Y
 S DIE="^ICPT("
 S DA=ACPTIEN
 I $G(ACPTNEW)=1 D  ;handle new codes specially
 .;Date Added (9999999.06) and Active Date (8)
 .;S ($P(ACPTNODE,U,8),$P(^ICPT(ACPTIEN,9999999),U,6))=ACPTYR
 .S DR="8////"_ACPTYR_";9999999.06////"_ACPTYR
 .S DR=DR_";5////@"  ;Inactive Flag
 .S DR=DR_";7////@;9999999.07////@"  ;Inactive Date and Date Deleted
 .;
 .D ^DIE
 I $G(ACPTNEW)'=1 D  ; for all other codes:
 .;S ($P(^ICPT(ACPTIEN,0),U,4),$P(ACPTNODE,U,4))=""  ;Inactive Flag
 .S DR="5////@"  ;Inactive Flag
 .;
 .;S $P(^ICPT(ACPTIEN,0),U,7)="",$P(^ICPT(ACPTIEN,9999999),U,7)=""  ;Inactive Date and Date Deleted
 .S DR=DR_";7////@;9999999.07////@"  ;Inactive Date and Date Deleted
 .;
 .;I $P(ACPTNODE,U,8)="" S $P(ACPTNODE,U,8)=ACPTYR  ;Active Date
 .K ACPTASV
 .I $P($G(^ICPT(ACPTIEN,0)),U,8)="" S DR=DR_";8////"_ACPTYR  ;Active Date
 .;
 .;I $P(^ICPT(ACPTIEN,9999999),U,6)="" S $P(^ICPT(ACPTIEN,9999999),U,6)=ACPTYR  ;Date Added
 .I $P(^ICPT(ACPTIEN,9999999),U,6)="" S DR=DR_";9999999.06////"_ACPTYR  ;Date Added
 D ^DIE
 ;
 ;S ^ICPT(ACPTIEN,0)=ACPTNODE  ; update header node
 ;
 S ACPTL=0
 S ACPTDESC=""
 F  S ACPTL=$O(^TMP("ACPT-IMP",$J,ACPTCODE,106,ACPTL)) Q:+ACPTL=0  D
 .I ACPTDESC'="" S ACPTDESC=ACPTDESC_" "_$G(^TMP("ACPT-IMP",$J,ACPTCODE,106,ACPTL))
 .I ACPTDESC="" S ACPTDESC=$G(^TMP("ACPT-IMP",$J,ACPTCODE,106,ACPTL))
 S ACPTDESC=$$UP^XLFSTR($$CLEAN^ACPT21NL(ACPTDESC))  ; clean up the Description
 D TEXT^ACPT21NL(.ACPTDESC) ; convert string to WP array
 K ^ICPT(ACPTIEN,"D") ; clean out old Description (50)
 M ^ICPT(ACPTIEN,"D")=ACPTDESC ; copy array to field, incl. header
 K DIC,DIE,X,Y,DA,DR
 S DA(1)=ACPTIEN
 S DIK="^ICPT("_DA(1)_",""D"","
 S DIK(1)=".01"
 S ACPTI=0
 F  S ACPTI=$O(^ICPT(ACPTIEN,"D",ACPTI)) Q:+ACPTI=0  D
 .S DA=ACPTI
 .D EN1^DIK
 ;
 S ACPTEDT=$O(^ICPT(ACPTIEN,60,"B",9999999),-1)  ; find the last
 N ACPTEIEN S ACPTEIEN=$O(^ICPT(ACPTIEN,60,"B",+ACPTEDT,0))  ; its IEN
 ;
 I ACPTEIEN D  ; if there is one for this install date
 .Q:$P($G(^ICPT(ACPTIEN,60,ACPTEIEN,0)),U,2)  ; if active, we're fine
 .; otherwise, we need to activate it:
 .K DIC,DIE,DA,DIR,X,Y
 .S DA=+ACPTEIEN  ; IEN of last Effective Date
 .S DA(1)=ACPTIEN  ; IEN of its parent CPT
 .S DIE="^ICPT("_DA(1)_",60,"  ; Effective Date (60/81.02)
 .S DR=".02////1"  ; set Status field to ACTIVE
 .N DIDEL,DTOUT  ; other parameters for DIE
 .D ^DIE  ; Fileman Data Edit call
 ;
 E  D  ; if not, then we need one
 .K DIC,DIE,DA,X,Y,DIR
 .S DA(1)=ACPTIEN  ; into subfile under new entry
 .S DIC="^ICPT("_DA(1)_",60,"  ; Effective Date (60/81.02)
 .S DIC(0)="L"  ; LAYGO
 .S DIC("P")=$P(^DD(81,60,0),U,2)  ; subfile # & specifier codes
 .S X="01/01/2011"  ; new entry
 .S DIC("DR")=".02////1"  ; with Status = 1 (active)
 .N DLAYGO,Y,DTOUT,DUOUT  ; other parameters
 .D ^DIC  ; Fileman LAYGO lookup
 ;
 ;versioned short description
 S ACPTSHRO=""
 S ACPTSDTL=$O(^ICPT(ACPTIEN,61,"B",9999999),-1)  ;get last short desc date
 I +ACPTSDTL'=0 D
 .S ACPTSDTI=$O(^ICPT(ACPTIEN,61,"B",ACPTSDTL,0))  ;get last short desc IEN
 .S:ACPTSDTI'="" ACPTSHRO=$P($G(^ICPT(ACPTIEN,61,ACPTSDTI,0)),U,2)  ;get last short desc
 ;short desc now not equal last short desc
 I $$UP^XLFSTR($$TRIM^XLFSTR(ACPTSHRO,"LR"))'=$$UP^XLFSTR($$TRIM^XLFSTR(ACPTSHRT,"LR")) D
 .D ^XBFMK
 .S DA(1)=ACPTIEN
 .S DIC="^ICPT("_DA(1)_",61,"
 .S DIC("P")=$P(^DD(81,61,0),U,2)
 .S DIC(0)="L"
 .S X=ACPTYR
 .D ^DIC
 .S ACPTENT=+Y
 .Q:ACPTENT<0
 .D ^XBFMK
 .S DA(1)=ACPTIEN
 .S DA=ACPTENT
 .S DIE="^ICPT("_DA(1)_",61,"
 .S DR="1///"_ACPTSHRT
 .D ^DIE
 ;
 ;versioned description
 S ACPTDSCO=""
 S ACPTDSCN=""
 S ACPTDIEN=0
 F  S ACPTDIEN=$O(^ICPT(ACPTIEN,"D",ACPTDIEN)) Q:'ACPTDIEN  D
 .I ACPTDSCN'="" S ACPTDSCN=$$TRIM^XLFSTR(ACPTDSCN,"R")_" "_$G(^ICPT(ACPTIEN,"D",ACPTDIEN,0))
 .I ACPTDSCN="" S ACPTDSCN=$G(^ICPT(ACPTIEN,"D",ACPTDIEN,0))
 S ACPTDDT=$O(^ICPT(ACPTIEN,62,"B",9999999),-1)  ;get last desc date
 S ACPTDSCO=""
 I +ACPTDDT'=0 D
 .S ACPTDIEN=$O(^ICPT(ACPTIEN,62,"B",ACPTDDT,0))  ;get last desc IEN
 .S ACPTIIEN=0
 .F  S ACPTIIEN=$O(^ICPT(ACPTIEN,62,ACPTDIEN,1,ACPTIIEN)) Q:'ACPTIIEN  D
 ..S ACPTDSCO=$$TRIM^XLFSTR(ACPTDSCO,"R")_" "_$G(^ICPT(ACPTIEN,62,ACPTDIEN,1,ACPTIIEN,0))
 ;description not equal to old description
 I $$UP^XLFSTR($$TRIM^XLFSTR(ACPTDSCO,"LR"))'=$$UP^XLFSTR($$TRIM^XLFSTR(ACPTDSCN,"LR")) D
 .D TEXT(.ACPTDSCN)
 .;
 .D ^XBFMK
 .S DA(1)=ACPTIEN
 .S DIC="^ICPT("_DA(1)_",62,"
 .S DIC(0)="L"
 .S X=ACPTYR
 .D ^DIC
 .Q:Y<0
 .S ACPTDIEN=+Y
 .K DIC,DIE,X,Y,DA,DR
 .S DA(2)=ACPTIEN
 .S DA(1)=ACPTDIEN
 .S DIC="^ICPT("_DA(2)_",62,"_DA(1)_",1,"
 .S DIC(0)="L"
 .S ACPTI=0
 .F  S ACPTI=$O(ACPTDESC(ACPTI)) Q:'ACPTI  D
 ..S X=$$UP^XLFSTR(ACPTDESC(ACPTI,0))
 ..D ^DIC
 ;
 S $P(^ICPT(ACPTIEN,0),U,4)=""  ;Inactive Flag
 ;
 U IO(0) W:'(ACPTCNT#100) "."
 Q
 ;
DELETE ;  this tag will load the complete file into ^TMP("ACPT-DEL",$J) using the concept ID
 ;  and the property ID as the identifiers
 K ^TMP("ACPT-DEL",$J),^TMP("ACPT-DCNT",$J)
 N POP D  Q:POP
 .D OPEN^%ZISH("CPTHFILE",ACPTPTH,"acpt2011.01D","R")  ; open read-only
 .U IO(0)  ; use terminal
 .I POP D MES^XPDUTL("Could not open CPT delete file.")
 .E  D MES^XPDUTL("Reading CPT delete file.")
 ;
 K ACPTCNT  ; count entries to print a dot for every 100
 F ACPTCNT=1:1 D  Q:$$STATUS^%ZISH  ; loop until end of file
 .;
 .K ACPTLINE  ; each line extracted from the file
 .U IO R ACPTLINE:DTIME Q:$$STATUS^%ZISH
 .S ACPTFIEN=$P(ACPTLINE,"|")  ;file IEN (concept ID)
 .Q:+ACPTFIEN=0  ;no file IEN
 .S ACPTCD=$P(ACPTLINE,"|",2)  ;code
 .Q:$L(ACPTCD)'=5  ;all codes should be 5 chars
 .Q:$P(ACPTLINE,"|",3)'=2011  ;only do 2011 deletes
 .S ^TMP("ACPT-DEL",$J,ACPTFIEN,ACPTCD)=$P(ACPTLINE,"|",3),^TMP("ACPT-DCNT",$J)=+$G(^TMP("ACPT-DCNT",$J))+1  ;only CPT entries
 D ^%ZISC  ; close the file
 ;now actually load codes
 W !!,"Deleting Codes:"
 S ACPTFIEN=0
 F  S ACPTFIEN=$O(^TMP("ACPT-DEL",$J,ACPTFIEN)) Q:+ACPTFIEN=0  D
 .S ACPTCODE=0
 .F  S ACPTCODE=$O(^TMP("ACPT-DEL",$J,ACPTFIEN,ACPTCODE)) Q:+ACPTCODE=0  D
 ..D DELCODE  ;this will actually flag code as deleted in ^ICPT
 ..W !?5,ACPTCODE,?15,$G(ACPTSHRT)
 Q
DELCODE ;
 S ACPTIEN=0
 S ACPTSHRT="Couldn't find code to inactivate"
 F  S ACPTIEN=$O(^ICPT("B",ACPTCODE,ACPTIEN)) Q:'ACPTIEN  D  ; find the code's record number
 .S:$P($G(^ICPT(ACPTIEN,0)),U,2)'="" ACPTSHRT=$P(^ICPT(ACPTIEN,0),U,2)
 .;
 .K DIC,DIE,DIR,X,Y,DA,DR
 .S DA(1)=ACPTIEN  ; parent record, i.e., the CPT code
 .S DIC="^ICPT("_DA(1)_",60,"  ; Effective Date subfile (60/81.02)
 .S DIC(0)="L"  ; allow LAYGO (Learn As You Go, i.e., add if not found)
 .S DIC("P")=$P(^DD(81,60,0),"^",2)  ; subfile # & specifier codes
 .S X="12/31/2010"  ; value to lookup in the subfile
 .N DLAYGO,Y,DTOUT,DUOUT  ; other parameters for DIC
 .D ^DIC  ; Fileman Lookup call
 .S DA=+Y  ; save IEN of found/added record for next call below
 .;
 .K DIR,DIE,DIC,X,Y,DR
 .S DA(1)=ACPTIEN
 .S DIE="^ICPT("_DA(1)_",60,"  ; Effective Date subfile (60/81.02)
 .S DR=".02////0"  ; set Status field to INACTIVE
 .N DIDEL,DTOUT  ; other parameters for DIE
 .D ^DIE  ; Fileman Data Edit call
 .;
 .K DIC,DIE,DIR,X,Y,DA,DR
 .S DIE="^ICPT("
 .S DA=ACPTIEN
 .; Date Deleted and Inactive Date to 3091231
 .;S ($P(^ICPT(ACPTIEN,9999999),U,7),$P(^ICPT(ACPTIEN,0),U,7))=3081231
 .S DR="7////3101231;9999999.07////3101231"
 .D ^DIE
 .;
 Q
 ;
 ;
CLEAN(ACPTDESC,ACPTUP) ; clean up description field
 ;
 ;strip out control characters
 I ACPTDESC?.E1C.E D CLEAN^ACPT28P1(.ACPTDESC)
 ;
 ;trim extra spaces
 N ACPTCLN S ACPTCLN=""
 N ACPTPIEC F ACPTPIEC=1:1:$L(ACPTDESC," ") D  ; traverse words
 .N ACPTWORD S ACPTWORD=$P(ACPTDESC," ",ACPTPIEC)  ; grab each word
 .Q:ACPTWORD=""  ; skip empty words (multiple spaces together)
 .S ACPTCLN=ACPTCLN_" "_ACPTWORD  ; reassemble words with 1 space between
 S $E(ACPTCLN)=""  ; remove extraneous leading space
 ;
 ;optionally, convert to upper case
 I $G(ACPTUP) S ACPTDESC=$$UP^XLFSTR(ACPTCLN)
 ;
 Q ACPTCLN
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
 .S ACPTDESC(ACPTCNT,0)=$E(ACPTSTRN,1,ACPTBRK) ; copy line into array
 .S $E(ACPTSTRN,1,ACPTBRK)="" ; & remove it from the string
 ;
 Q
