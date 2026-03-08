ABMBLRX ; IHS/SD/SDR - 3PB Pharmacy POS Bill Cleanup Report  
 ;;2.6;IHS Third Party Billing System;**36**;NOV 12, 2009;Build 698
 ;
 ;IHS/SD/SDR 2.6*36 ADO74860 New routine to report Pharmacy POS bills that are missing the medication
 ;
 ;*******************************
 W !!?3,"Prior to abm*2.6*36 there was an issue with the Pharmacy POS Application"
 W !?3,"Program Interface that is used to create a 3P Bill entry (which in turn"
 W !?3,"creates the A/R Bill entry for posting) where it wouldn't put the"
 W !?3,"medication on the bill entry.  There are two choices in this menu option."
 W !?3,"One is a report to see what bills are missing a medication.  The other is"
 W !?3,"a matching option allowing the user to match the bill to the correct"
 W !?3,"prescription so the medication can be placed on the bill."
 ;
 D ^XBFMK
 S DIR(0)="SO^1:Run report for bills missing medications;2:Match bills to prescriptions"
 S DIR("A")="Selection"
 D ^DIR
 Q:$D(DIROUT)!$D(DIRUT)!$D(DTOUT)!$D(DUOUT)
 S ABMANS=+Y
 ;
 I ABMANS=1 D ^ABMBLRX1 Q  ;report
 ;
 F  D  Q:$D(DUOUT)!$D(DTOUT)!$D(DIRUT)!$D(DIROUT)
 .D MATCHING
 Q
MATCHING ;EP
 D EN^ABMVDF("IOF")  ;clear page to start fresh with bill/patient prompt
 K ABMP
 S (ABMBST,ABMOTHI,ABMRXNUM,ABMDRUG,ABMNDC,ABMIDT,ABMPST,ABMRXPT)=""
 ;
 D ^ABMDBDIC
 Q:$D(DUOUT)!$D(DTOUT)!$D(DIRUT)!$D(DIROUT)
 I '$G(ABMP("BDFN")) H 1 G MATCHING
 S ABMBILLN=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U)
 S ABMP("PDFN")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,5)
 S ABMBST=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,4)
 S ABMBAMT=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),2)),U)
 S ABMBST=$S(ABMBST="R":"REVIEWED",ABMBST="A":"APPROVED",ABMBST="B":"BILLED",ABMBST="T":"TRANSFERRED TO FINANCE",ABMBST="C":"COMPLETED",ABMBST="P":"PARTIAL PAYMENT",1:"CANCELLED")
 S ABMOTHI=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),1)),U,15)
 I $G(ABMOTHI)'="",$D(^PSRX(ABMOTHI)) D
 .S ABMRXNUM=$P($G(^PSRX(ABMOTHI,0)),U)
 .S ABMDRUG=$P($G(^PSDRUG($P($G(^PSRX(ABMOTHI,0)),U,6),0)),U)
 .S ABMNDC=$P($G(^PSRX(ABMOTHI,2)),U,7)
 .S ABMIDT=$P($G(^PSRX(ABMOTHI,0)),U,13)
 .S ABMA=$P($G(^PSRX(ABMOTHI,"STA")),U)
 .S ABMPST="PROVIDER HOLD"  ;default this and change accordingly
 .S:ABMA=0 ABMPST="ACTIVE"
 .S:ABMA=1 ABMPST="NON-VERIFIED"
 .S:ABMA=2 ABMPST="REFILL"
 .S:ABMA=3 ABMPST="HOLD"
 .S:ABMA=4 ABMPST="DRUG INTERACTIONS"
 .S:ABMA=5 ABMPST="SUSPENDED"
 .S:ABMA=10 ABMPST="DONE"
 .S:ABMA=11 ABMPST="EXPIRED"
 .S:ABMA=12 ABMPST="DISCONTINUED"
 .S:ABMA=13 ABMPST="DELETED"
 .S:ABMA=14 ABMPST="DISCONTINUED BY PROVIDER"
 .S:ABMA=15 ABMPST="DISCONTINUED (EDIT)"
 .S ABMRXPT=$E($P($G(^DPT($P($G(^PSRX(ABMOTHI,0)),U,2),0)),U),1,30)
 ;
 W !!!,$$EN^ABMVDF("ULN"),"3P Bill Data:",$$EN^ABMVDF("ULF"),?40,$$EN^ABMVDF("ULN"),"Prescription Data:",$$EN^ABMVDF("ULF")
 W !?8,"Bill#: "_ABMBILLN,?48,"RX#: ",ABMRXNUM
 W !?6,"Patient: "_$E($P($G(^DPT(ABMP("PDFN"),0)),U),1,27),?44,"Patient: ",ABMRXPT
 W !?10,"DOS: "_$$SDT^ABMDUTL($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U)),?41,"Issue Date: ",$$SDT^ABMDUTL(ABMIDT)
 W !,"Other Bill ID: ",$$EN^ABMVDF("HIN"),ABMOTHI,$$EN^ABMVDF("HIF")
 W ?45,"RX IEN: ",$$EN^ABMVDF("HIN"),$S(((+$G(ABMOTHI)'=0)&($D(^PSRX(+ABMOTHI)))):ABMOTHI,1:"<NO MATCH>"),$$EN^ABMVDF("HIF")
 W !?48,"NDC: ",ABMNDC
 ;W !?3,"Medication: "_$S($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,1,0))'="":$P($G(^PSDRUG($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,1,0)),U),0)),U),1:"<NONE>")
 ;W ?41,"Medication: ",ABMDRUG
 W !
 S ABMU("TXT")="Medication: "_$S($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,1,0))'="":$P($G(^PSDRUG($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,1,0)),U),0)),U),1:"<NONE>")
 S ABMU("LM")=3,ABMU("RM")=38
 S ABMU("2TXT")="Medication: "_ABMDRUG
 S ABMU("2LM")=41,ABMU("2RM")=80
 D PRTTXT^ABMDWRAP
 W !?2,"Bill Status: "_ABMBST,?42,"RX Status: ",ABMPST
 W !?2,"Bill Amount: "_$FN(ABMBAMT,",",2)
 W !!
 ;
 ;if there's no Prescription entry for the Other Bill Identifier - write message, quit
 I ((+$G(ABMOTHI)=0)!('$D(^PSRX(ABMOTHI)))) D  Q
 .W !!?3,"There's no Prescription entry for the selected bill.",!?3,"No Matching can be done."
 .D PAZ^ABMDRUTL
 ;if there's already a medication on the 3P Bill - write message, quit
 I $G(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,1,0))'="" D  Q
 .W !!?3,"There's already a medication on the selected bill.",!?3,"No Matching can be done."
 .D PAZ^ABMDRUTL
 ;
 D ^XBFMK
 S DIR(0)="YO"
 S DIR("A")="Is this a correct match (Yes/No)"
 D ^DIR
 Q:$D(DIROUT)!$D(DTOUT)!$D(DUOUT)
 S ABMANS=+Y
 K DIROUT,DTOUT,DUOUT,DIRUT
 I ABMANS<1 W !!?3,"Bill/Prescription matching will not be done for this bill" H 1 Q  ;if they answer NO, don't match and go back to bill/patient selection prompt
 ;
 ;if it gets here they said YES it's a match
 W !!?3,"Matching bill to prescription"
 D ^XBFMK
 S DA(1)=ABMP("BDFN")
 S DIC="^ABMDBILL(DUZ(2),DA(1),23,",X=$P($G(^PSRX(ABMOTHI,0)),U,6)
 S DIC(0)="EMQL"
 K DD,DO
 D FILE^DICN
 Q:Y<0  S DA=+Y
 S DIE=DIC
 S ABMP("VTYP")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,7)
 ;
 K ABMRPTMI,ABMLOTI
 S (ABMUCST,ABMDFEE,ABMQTY)=0
 S ABMRPTMI=$O(^ABSPECX("RPT","C",ABMOTHI,0))
 I +$G(ABMRPTMI)'=0 D
 .S ABMLOTI=$P($G(^ABSPECX("RPT",ABMRPTMI,0)),U,3)
 .I ABMLOTI'="" D
 ..S ABMUCST=$$GET1^DIQ(9002313.57,ABMLOTI,502)
 ..S ABMDFEE=$$GET1^DIQ(9002313.57,ABMLOTI,504)
 ..S ABMQTY=$$GET1^DIQ(9002313.57,ABMLOTI,501)
 ; 
 S DR=".04////"_ABMUCST  ;unit cost
 S DR=DR_";.05////"_ABMDFEE  ;dispensing fee
 S DR=DR_";.03////"_ABMQTY  ;units
 S DR=DR_";.06////"_ABMOTHI  ;prescription
 D ^DIE
 ;
 S ABMHOLD=DUZ(2)
 S DUZ(2)=0
 S ABMBFND=0
 F  S DUZ(2)=$O(^BARBL(DUZ(2))) Q:'DUZ(2)  D  Q:ABMBFND=1
 .S ABMBBDFN=0
 .F  S ABMBBDFN=$O(^BARBL(DUZ(2),"G",ABMOTHI,ABMBBDFN)) Q:'ABMBBDFN  D  Q:ABMBFND=1  ;other bill identifier xref
 ..I $P($P($G(^BARBL(DUZ(2),ABMBBDFN,0)),U),"-")'=ABMBILLN Q  ;this isn't our bill number
 ..I ABMP("PDFN")'=$P($G(^BARBL(DUZ(2),ABMBBDFN,1)),U) Q  ;this isn't our patient
 ..I $P($G(^BARBL(DUZ(2),ABMBBDFN,1)),U,14)'=901 Q  ;this isn't a Pharmacy POS visit type
 ..I ABMBAMT'=$P($G(^BARBL(DUZ(2),ABMBBDFN,0)),U,13) Q  ;this isn't our billed amount
 ..I $G(^BARBL(DUZ(2),ABMBBDFN,3,1,0))'="" Q  ;there is already a line item on this A/R Bill; just being safe
 ..S ABMBFND=1
 I ABMBFND=0 W !,"...Issue finding correct bill, A/R Bill not updated" H 1 S DUZ(2)=ABMHOLD Q
 D ^XBFMK
 S DA(1)=ABMBBDFN
 S X=""""_ABMNDC_" "_ABMDRUG_""""
 S DIC="^BARBL(DUZ(2),"_DA(1)_",3,"
 S DIC("P")=$P(^DD(90050.01,301,0),U,2)
 S DIC(0)="LX"
 D ^DIC
 I Y<0 W "...issue adding medication to A/R Bill..." H 1 S DUZ(2)=ABMHOLD Q
 E  W "....Done." H 1
 S DIE=DIC
 S DA=+Y
 S DR="2////"_ABMIDT
 S DR=DR_";3////0"  ;item code
 S DR=DR_";4////DISPENSING FEE;5////"_ABMDFEE
 S DR=DR_";6////PHARMACY"
 S DR=DR_";7////"_ABMQTY  ;quantity
 S DR=DR_";9////"_ABMUCST  ;unit cost
 S DR=DR_";10////"_ABMBAMT  ;total item cost
 S DR=DR_";11////1"  ;3P item number
 D ^DIE
 S DUZ(2)=ABMHOLD
 Q
