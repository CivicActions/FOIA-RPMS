BARUP1 ; IHS/SD/LSL - 3P UPLOAD CONTINUED DEC 5,1996 ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,19,21,24,29,33,34**;OCT 26,2005;Build 139
 ;
 ;IHS/ASDS/LSL 9/11/01 1.5*2 Modified to accomodate Pharmacy POS.  Passes RX through to Other Bill Identifier field.
 ;
 ;IHS/SD/LSL V1.7 11/27/02 QAA-1200-130051 Modified to insert quit logic if error in creating a new
 ;   transaction.  Also inserted documentation.
 ;IHS/SD/LSL 1.7*1 06/09/03 If uploading bill (not created through 3P Claim Approval), create BILL NEW transaction with 3P Approval Date and populate
 ;   Message and Text fields of transaction.
 ;IHS/SD/LSL 1.7*2 08/21/03 IM11348 Allow for checking of existing manually entered bill.  Avoid duplicate bills in AR.
 ;IHS/SD/LSL 1.7*3 09/10/03 IM11459 Resolve creation of multiple bills in AR when print or reprint from 3P.
 ;
 ;IHS/SD/RTL 1.8*1 04/28/05 IM17271 Duplicate bills
 ;IHS/SD/SDR 1.8*24 06/2013 HEAT118656 Belcourt
 ;IHS/SD/SDR 1.8*24 10/10/13 HEAT135708
 ;IHS/SD/CPC 1.8*29 CR10754 Eliminate BARTT undefined error
 ;IHS/SD/SDR 1.8*33 ADO60817 Updated to make DATE field correct since IEN was changed to DATE/TIME/CNTR
 ;IHS/SD/SDR 1.8*34 ADO80817 Updated so more fields being passed to BAR are actually stored
 ;************************
 ;
 ;Global changes for indirection global - ABMA to @BAR3PUP@
 ;
 ;**Upload from 3P BILL file to A/R BILL/IHS file
 ; ---- continuation from ^BARUP
 ;
 ;**This routine is intended to be called from the 3p billing module
 ;   at the time an item is created in the 3P BILL file.
 ;
 ;**Calling this routine at the entry point TPB^BARUP(ABMA ARRAY)
 ;   will create an entry in the A/R BILL/IHS file.
 ;
 ;*************************
 Q
UPLOAD ; EP
 ;Create a new in A/R Bill File based on 3P data
 I '$D(BAR3PUP) D S3PUP
 D LK2              ;See if bill already exists for this parent in A/R
 I +BARBLDA>0 D
 .D UPDATE
 .I BARXX,$G(^TMP("BAR",$J,"BARUPCHK",$J)) D  Q  ;Already uploaded
 ..S BARACT=$$CMP^BARUPCHK(BARBLDA)
 ..S ^TMP($J,"BARXX")=BARXX
 .D BILLOAD
 I +BARBLDA<1 D ADD  ;Bill not found, try adding it
 I +BARBLDA<1 D NOT  ;Could not find/add bill in A/R
 Q
 ;*************************
 ;
S3PUP ;set BAR3PUP variable
 S BAR3PUP="^TMP($J,""ABMPASS"")"
 Q
 ;*************************
 ;
LK2 ;
 ;Try to find the 3PB bill under this parent in A/R
 N BARTMP
 S BARBLDA=-1
 S BARSNM=$P(@BAR3PUP@("BLNM"),"-",1)
 S BARNNM=+BARSNM_" "
 ;F  S BARNNM=$O(^BARBL(DUZ(2),"B",BARNNM)) Q:((+$P(BARNNM,"-")'=+BARSNM)!(BARBLDA>0))  D
 F  S BARNNM=$O(^BARBL(DUZ(2),"B",BARNNM)) Q:(($E(BARNNM,1,$L(+BARSNM))'=(+BARSNM))!(BARBLDA>0))  D  ;IM17271
 .I $P(BARNNM,"-")'=BARSNM Q
 .S BARTMP=0
 .F  S BARTMP=$O(^BARBL(DUZ(2),"B",BARNNM,BARTMP)) Q:('+BARTMP!(BARBLDA>0))  D
 ..Q:$P($G(^BARBL(DUZ(2),BARTMP,0)),U,17)'=@BAR3PUP@("BLDA")  ;3P IEN (DA)
 ..Q:$P($G(^BARBL(DUZ(2),BARTMP,1)),U)'=@BAR3PUP@("PTNM")     ;PATIENT DFN
 ..S BARBLDA=BARTMP
 Q
 ;*************************
ADD ;
 ;Create entry in A/R Bill file
 S DIC="^BARBL(DUZ(2),"
 S DIC(0)="LX"
 S X=@BAR3PUP@("BLNM")
 S DLAYGO=90050
 K DD,DO
 D FILE^DICN
 K DLAYGO
 I +Y<1 Q
 S BARBLDA=+Y
 ;Tell 3P where A/R put the bill
 S ^TMP($J,"ABMPASS","ARLOC")=DUZ(2)_","_BARBLDA
 D BILLOAD  ;Add items from 3P to AR
 D SETTX^BARUP2    ;Create BILL NEW transaction
 Q
 ;*************************
 ;
NOT ;
 ;Write message
 Q:$D(ZTQUEUED)
 U IO(0)
 W !,@BAR3PUP@("BLNM"),?10,"BILL NOT FOUND NOR ADDED ???"
 U IO
 Q
 ;*************************
 ;
UPDATE ;EP
 ;Update .01 field of A/R Bill
 K DR
 S DIE="^BARBL(DUZ(2),"
 S DA=BARBLDA
 I @BAR3PUP@("BLNM")'=$P(^BARBL(DUZ(2),DA,0),U) D
 . S DR=".01///"_@BAR3PUP@("BLNM")
 .D ^DIE
 S BARXX=$$GET1^DIQ(90050.01,BARBLDA,13)  ;check if previously loaded
 Q
 ;*************************
 ;
BILLOAD ;EP - called by barupchk
 ; add/reload item from 3P to A/R everytime
 I '$D(BARXX) D
 .I '$D(^TMP($J,"BARXX")) Q
 .I $D(^TMP($J,"BARXX")) D
 ..S BARXX=^TMP($J,"BARXX")
 ..K ^TMP($J,"BARXX")
 I '$D(BAR3PUP) D S3PUP
 I $G(BARXX) D ITMRLOAD Q  ; Previously loaded
 D BILLOAD2  ; Add top level A/R Bill data
 D SETITM^BARUP2
 D SETCOLL^BARUP2  ;IHS/SD/AR 1.8*19 07182010
 Q
 ;*************************
 ;
ITMRLOAD  ;
 ;Bill previously loaded into A/R, delete old items and create new ones
 D DELITM^BARUP2  ;Delete Items
 D SETITM^BARUP2  ;Create Items
 ;-------------------------------
 ;
 ;Update 3P IEN, 3P DUZ(2), and export date on A/R Bill
 K DA,DIC,DIE,X,Y,DR
 S DA=BARBLDA
 S DIE="^BARBL(DUZ(2),"
 I $L(@BAR3PUP@("BLDA")) D
 .S DR="17////^S X=@BAR3PUP@(""BLDA"")"
 .S DR=DR_";22////^S X=BARDUZ2"
 .I $L(@BAR3PUP@("DTBILL")) S DR=DR_";19////^S X=@BAR3PUP@(""DTBILL"")"
 .S DIE=$$DIC^XBDIQ1(90050.01)
 .D ^DIE
 ;-------------------------------
 ;
 ; Write message
 Q:$E(IOST)'="C"
 Q:IOT'["TRM"
 Q:$D(ZTQUEUED)
 W !,@BAR3PUP@("BLNM")
 W " Previously loaded .. deleting existing A/R Bill items",!
 W !,@BAR3PUP@("BLNM")," Now adding 3P Bill items to A/R Bill",!
 Q
 ;*************************
 ;
BILLOAD2  ;
 ;Populate top level A/R Bill data
 S @BAR3PUP@("BLAMT")=@BAR3PUP@("BLAMT")*100+.5\1/100
 ;S @BAR3PUP@("CURTOT")=@BAR3PUP@("BLAMT")-$G(@BAR3PUP@("CREDIT"))  ;IHS/SD/SDR bar*1.8*24 HEAT118656 belcourt
 S @BAR3PUP@("CURTOT")=@BAR3PUP@("BLAMT")  ;IHS/SD/SDR bar*1.8*24 HEAT118656 belcourt
 Q:'$D(BARPAR)
 S DIE="^BARBL(DUZ(2),"
 S DA=BARBLDA
 S DIDEL=90050
 ;-------------------------------
DR01  ;
 ;Populate 1st half zero node
 S DR=""
 S DR=DR_"3////^S X=BARACEIN"
 S DR=DR_";4////^S X=BARBLTYP"
 S DR=DR_";8////^S X=BARPAR"
 S DR=DR_";10////^S X=BARSERV"
 S DR=DR_";11////3PU"
 S DR=DR_";13////^S X=$G(@BAR3PUP@(""BLAMT""))"
 S DR=DR_";15////^S X=$G(@BAR3PUP@(""CURTOT""))"
 S DR=DR_";1001////^S X=$G(@BAR3PUP@(""LICN""))"  ;IHS/SD/TPF BAR*1.8*21 5010 SPECS PAGE 16
 D ^DIE
 ;------------------------------
DR02  ;
 ;Populate 2nd half zero node
 S DR=""
 S DR=DR_"16////^S X=BARSTAT"
 S DR=DR_";17///^S X=$G(@BAR3PUP@(""BLDA""))"
 S DR=DR_";18////^S X=@BAR3PUP@(""DTAP"")"
 ;S DR=DR_";18////^S X=@BAR3PUP@(""DTAP"");Q"
 S DR=DR_";19////^S X=@BAR3PUP@(""DTBILL"")"
 S DR=DR_";20///^S X=@BAR3PUP@(""CREDIT"")"
 S DR=DR_";22////^S X=BARDUZ2"
 D ^DIE
 ;-------------------------------
DR11  ;
 ;Populate 1st half one node
 S DR=""
 S DR=DR_"101////^S X=$G(@BAR3PUP@(""PTNM""))"
 S DR=DR_";102////^S X=$G(@BAR3PUP@(""DOSB""))"
 S DR=DR_";103////^S X=$G(@BAR3PUP@(""DOSE""))"
 S DR=DR_";105////^S X=BARSSN"
 S DR=DR_";106////^S X=BARPTYP"
 S DR=DR_";107////^S X=BARHRN"
 D ^DIE
 ;------------------------------
DR12  ;
 ;Populate 2nd half one node
 S DR=""
 S DR=DR_"108////^S X=BARSAT"
 S DR=DR_";112////^S X=$G(@BAR3PUP@(""CLNC""))"
 S DR=DR_";113////^S X=BARPRV"
 S DR=DR_";114////^S X=$G(@BAR3PUP@(""VSTP""))"
 S DR=DR_";115////^S X=BARPBEN"
 D ^DIE
 ;-------------------------------
DR278  ;
 ;Popolate two, seven, and eight nodes
 S DR=""
 S DR=DR_"205////^S X=BARTMP1(205)"
 S DR=DR_";206////^S X=BARTMP1(206)"
 S DR=DR_";207////^S X=BARTMP1(207)"
 S DR=DR_";215////^S X=@BAR3PUP@(""APPR"")"  ;bar*1.8*34 IHS/SD/SDR ADO80817
 S DR=DR_";218////^S X=@BAR3PUP@(""DTAP"")"  ;bar*1.8*34 IHS/SD/SDR ADO80817
 S DR=DR_";702///^S X=@BAR3PUP@(""POLN"")"
 S DR=DR_";701///^S X=@BAR3PUP@(""POLH"")"
 I $G(@BAR3PUP@("OTHIDENT")) S DR=DR_";801////^S X=@BAR3PUP@(""OTHIDENT"")"
 D ^DIE
 K DIDEL
 Q
