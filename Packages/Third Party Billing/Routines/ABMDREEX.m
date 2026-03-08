ABMDREEX ; IHS/SD/SDR - Re-Create batch of Selected Bills ;    
 ;;2.6;IHS Third Party Billing System;**2,3,4,6,10,14,21,35,37,38**;NOV 12, 2009;Build 756
 ;IHS/SD/SDR 2.6*2-FIXPMS10005 New routine
 ;IHS/SD/SDR 2.6*3-RPMS10005#2 mods to make Submission date of 3P Tx status file work correctly
 ;IHS/SD/SDR 2.6*3-FIXPMS10005 mods to create 1 file for each 1000 bills
 ;IHS/SD/SDR 2.6*4-NOHEAT if create and re-export are done on same day it will have duplicates
 ;IHS/SD/SDR 2.6*6-HEAT28632 <SUBSCR>CHECKBAL+17^ABMDREEX error when parent/satellite present
 ;IHS/SD/SDR 2.6*14-HEAT136160 re-wrote to sort by ins/vloc/vtyp/expmode. Wasn't creating enough files. Didn't label all
 ;   changes because there were so many.
 ;IHS/SD/SDR 2.6*21 Split routine to ABMDREX1.
 ;IHS/SD/SDR 2.6*21 HEAT207484 Made change to stop error <UNDEF>EXPMODE+66^ABMDREEX when no bills meet selected criteria
 ;IHS/SD/SDR 2.6*35 ADO60707 Fix for <SUBSCR>CHECKBAL+20^ABMDREEX, fix for '??' displaying when a valid bill is selected (and
 ;   that bill being the last (most recent) entry in the A/R Bill file); Added help text at the beginning; Removed balance check
 ;   and replaced with message to let user know the A/R Bill CURRENT BILL AMOUNT is zero and 'ARE YOU SURE' you want to include
 ;IHS/SD/SDR 2.6*37 ADO75923 Added .04 EXPORT DATE/TIME field to BILLSTAT
 ;IHS/SD/SDR 2.6*38 ADO99134 Fixed programming error <SUBSCRIPT>S4+12^DICL2 when ?? was typed at Bill# prompt
 ;
 ;start new abm*2.6*35 IHS/SD/SDR ADO60707
 W !!?2,"This option gives the user the ability to re-export 837 bills, either by"
 W !?2,"selecting one bill at a time or batching bills based on the selection"
 W !?2,"criteria that have a balance.  If selecting one bill at a time the bills"
 W !?2,"must be for the same insurer, the same visit type, and the same export"
 W !?2,"mode."
 ;end new abm*2.6*35 IHS/SD/SDR ADO60707
 ;
EN K ABMT,ABMREX,ABMP,ABMY
 K ^TMP($J,"ABM-D"),^TMP($J,"ABM-D-DUP"),^TMP($J,"D")  ;abm*2.6*4 NOHEAT
 S ABMREX("XMIT")=0
 S ABMT("TOT")="0^0^0"
 W !!,"Re-Print Bills for:"
 K DIR
 ;S DIR(0)="SO^1:SELECTIVE BILL(S) (Type in the Bills to be included in this                     export.  Grouped by Insurer and Export Mode)"  ;abm*2.6*35 IHS/SD/SDR ADO60707
 S DIR(0)="SO^1:SELECTIVE BILL(S) (Type in the Bills to be included in                          this export.  Grouped by Insurer and Export Mode)"  ;abm*2.6*35 IHS/SD/SDR ADO60707
 S DIR(0)=DIR(0)_";2:FOR 277 - Response of not received for insurance company                        (INACTIVE AT THIS TIME)"
 S DIR(0)=DIR(0)_";3:UNPAID BILLS for an insurer - bill should not have posted                       transactions and should be the original bill amount."
 S DIR("A")="Select Desired Option"
 D ^DIR
 K DIR
 S ABMT=1  ;abm*2.6*35 IHS/SD/SDR ADO60707
 G XIT:$D(DIRUT)!$D(DIROUT),SEL:Y=1,UNPD:Y=3
277 ;
 W !!!,"INACTIVE AT THIS TIME; functionality will be available in a future patch" H 2 W !
 G EN
SEL ;
 W !!
 K DIC
 S DIC="^ABMDBILL(DUZ(2),"
 S DIC(0)="QZEAM"
 ;S ABMT=$G(ABMT)+1  ;abm*2.6*35 IHS/SD/SDR ADO60707
 S ABM("E")=$E(ABMT,$L(ABMT))
 S DIC("A")="Select "_ABMT_$S(ABMT>3&(ABMT<21):"th",ABM("E")=1:"st",ABM("E")=2:"nd",ABM("E")=3:"rd",1:"th")_" BILL to Re-Print: "
 ;start old abm*2.6*35 IHS/SD/SDR ADO60707
 ;S DIC("S")="I $P(^(0),U)'=+^(0),""BTCP""[$P(^(0),""^"",4),$P(^ABMDEXP($P(^(0),""^"",6),0),U)[""837"",($$CHECKBAL^ABMDREEX(Y)=1)"
 ;S:ABMT>1 DIC("S")=DIC("S")_",$P(ABMT(""FORM""),""^"",1)[$P(^(0),""^"",6),($$CHECKBAL^ABMDREEX(Y)=1),(ABMT(""INS"")=$P(^(0),""^"",8)),($P(^(0),U,7)=ABMT(""VTYP""))"
 ;end old start new abm*2.6*35 IHS/SD/SDR ADO60707
 ;S DIC("S")="I (""BTCP""[$P(^ABMDBILL(DUZ(2),Y,0),""^"",4))&($P(^ABMDEXP($P(^(0),""^"",6),0),U)[""837"")"  ;abm*2.6*38 IHS/SD/SDR ADO99134
 S DIC("S")="I (+$P(^(0),""^"",6)'=0) I (""BTCP""[$P(^ABMDBILL(DUZ(2),Y,0),""^"",4))&($P(^ABMDEXP($P(^(0),""^"",6),0),U)[""837"")"  ;abm*2.6*38 IHS/SD/SDR ADO99134
 S:ABMT>1 DIC("S")=DIC("S")_",$P(ABMT(""FORM""),""^"",1)[$P(^ABMDBILL(DUZ(2),Y,0),""^"",6),(ABMT(""INS"")=$P(^(0),""^"",8)),($P(^(0),U,7)=ABMT(""VTYP""))"
 ;end new abm*2.6*35 IHS/SD/SDR ADO60707
 D BENT^ABMDBDIC
 G XIT:$D(DUOUT)!$D(DTOUT)
 I '$G(ABMP("BDFN")) G ZIS:ABMT>1,XIT
 I '$G(ABMP("BDFN")) S ABMT=ABMT-1 G SEL
 ;start new abm*2.6*35 IHS/SD/SDR ADO60707
 S ABMARBAL=$$CHECKBAL(ABMP("BDFN"))  ;check if A/R bill has a balance
 S ABMQ=0
 I +$G(ABMARBAL)=0 D  I ABMQ=1 G SEL
 .W !?2,"Bill "_$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U)_" has a zero balance in A/R."
 .K X,Y,DIR,DIE,DIC,DA
 .S DIR(0)="Y"
 .S DIR("A")="ARE YOU SURE"
 .D ^DIR
 .I $D(DTOUT)!$D(DIROUT)!$D(DIRUT)!$D(DUOUT)!(Y<1) S ABMQ=1 W !?3,"Bill won't be included in batch" H 1
 ;end new abm*2.6*35 IHS/SD/SDR ADO60707
 S ABMY(ABMP("BDFN"))=""
 ;start old abm*2.6*35 IHS/SD/SDR ADO60707
 ;G SEL:ABMT>1
 ;S ABMT("EXP")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,6)
 ;S ABMT("INS")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,8)
 ;S ABMT("VTYP")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,7)  ;abm*2.6*3
 ;S ABMT("FORM")=ABMT("EXP")_"^"_$P($G(^ABMDEXP(ABMT("EXP"),0)),U)
 ;end old start new abm*2.6*35 IHS/SD/SDR ADO60707
 I ABMT=1 D
 .S ABMT("EXP")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,6)
 .S ABMT("INS")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,8)
 .S ABMT("VTYP")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,7)  ;abm*2.6*3
 .S ABMT("FORM")=ABMT("EXP")_"^"_$P($G(^ABMDEXP(ABMT("EXP"),0)),U)
 S ABMT=$G(ABMT)+1
 ;end new abm*2.6*35 IHS/SD/SDR ADO60707
 ;
 G SEL
UNPD ;UN-PAID BILLS
 W !!
 K DIR
 S DIR(0)="PO^9999999.18:EQM"
 S DIR("A")="Select Insurer"
 D ^DIR
 K DIR
 G XIT:$D(DIRUT)!$D(DIROUT)
 S ABMREX("SELINS")=+Y
BEGDT K DIR
 S DIR(0)="DO"
 S DIR("A")="Select Beginning Export Date"
 D ^DIR
 K DIR
 I $D(DIRUT) K ABMREX("SELINS") G UNPD
 G XIT:$D(DIROUT)
 S ABMREX("BEGDT")=+Y
ENDDT K DIR
 S DIR(0)="DO"
 S DIR("A")="Select Ending Export Date"
 D ^DIR
 K DIR
 I $D(DIRUT) K ABMREX("BEGDT") G BEGDT
 G XIT:$D(DIROUT)
 S ABMREX("ENDDT")=+Y
EXPMODE D ^XBFMK
 S DIC(0)="AEBNQ"
 S DIC="^ABMDEXP("
 S DIC("S")="I $P($G(^ABMDEXP(Y,0)),U)[""837"""
 S DIC("A")="Select Export Mode (leave blank for ALL): "
 D ^DIC
 G XIT:(X["^^")
 I $D(DUOUT) K ABMREX("ENDDT") G ENDDT
 S ABMREX("SELEXP")=$S(+Y>0:+Y,1:"")  ;they can select all exp modes by leaving prompt blank
 I (ABMREX("BEGDT")>(ABMREX("ENDDT"))) W !!,"Beginning Export Date must be before Ending Export Date" H 1 G UNPD
 ;
 S ABMBDT=(ABMREX("BEGDT")-.5)
 S ABMEDT=(ABMREX("ENDDT")+.999999)
 S (ABMBCNT,ABMTAMT)=0  ;abm*2.6*21 IHS/SD/SDR HEAT207484
 ;start old HEAT136160
 ;S ABMBCNT=0,ABMTAMT=0
 ;S ABMFCNT=1  ;file cnt  ;abm*2.6*3 FIXPMS10005
 ;F  S ABMBDT=$O(^ABMDTXST(DUZ(2),"B",ABMBDT)) Q:(+ABMBDT=0!(ABMBDT>ABMEDT))  D
 ;.S ABMIEN=0
 ;.F  S ABMIEN=$O(^ABMDTXST(DUZ(2),"B",ABMBDT,ABMIEN)) Q:+ABMIEN=0  D
 ;..I $P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U,4)'=ABMREX("SELINS") Q  ;not our ins
 ;..I ABMREX("SELEXP")'="",($P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U,2)'=(ABMREX("SELEXP"))) Q  ;they selected one & this isn't it
 ;..I ABMREX("SELEXP")="",($P($G(^ABMDEXP($P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U,2),0)),U)'[("837")) Q  ;they didn't answer so deflt to all 837s
 ;..S ABMBIEN=0
 ;..S ABMFBCNT=0  ;cnt bills in file ;abm*2.6*3 FIXPMS10005
 ;..F  S ABMBIEN=$O(^ABMDTXST(DUZ(2),ABMIEN,2,ABMBIEN)) Q:+ABMBIEN=0  D
 ;...I $P($G(^ABMDBILL(DUZ(2),ABMBIEN,0)),U,4)="X" Q  ;skip cancelled bills
 ;...S ABMBALCK=$$CHECKBAL(ABMBIEN)
 ;...I ABMBALCK=0 Q  ;has been posted to
 ;...;cnt tot bills & amt
 ;...S ABMBCNT=+$G(ABMBCNT)+1
 ;...S ABMTAMT=+$G(ABMTAMT)+($P($G(^ABMDBILL(DUZ(2),ABMBIEN,2)),U))
 ;...;cnt bills not cancelled or posted to in export
 ;...S ABMREX("CNTS",$P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U,2),ABMIEN)=+$G(ABMREX("CNTS",$P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U,2),ABMIEN))+1
 ;...S $P(ABMREX("CNTS",$P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U,2),ABMIEN),U,2)=+$P($G(ABMREX("CNTS",$P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U,2),ABMIEN)),U,2)+($P($G(^ABMDBILL(DUZ(2),ABMBIEN,2)),U))
 ;...S ABMREX("EXPS",$P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U,2),ABMIEN)=""  ;capture what export IENs to do
 ;...;start new abm*2.6*3 FIXPMS10005
 ;...S ^TMP($J,"ABM-D",ABMFCNT,$P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U,2),ABMIEN,ABMBIEN)=""
 ;...S ^TMP($J,"ABM-D-DUP",ABMBIEN)=+$G(^TMP($J,"ABM-D-DUP",ABMBIEN))+1  ;cnt # of times bill in select exports  ;abm*2.6*3
 ;...S ABMFBCNT=+$G(ABMFBCNT)+1
 ;...I ABMFBCNT>1000 S ABMFCNT=+$G(ABMFCNT)+1,ABMFBCNT=0
 ;...;end new abm*2.6*3 FIXPMS10005
 ;end old start new HEAT136160
 F  S ABMBDT=$O(^ABMDTXST(DUZ(2),"B",ABMBDT)) Q:(+ABMBDT=0!(ABMBDT>ABMEDT))  D
 .S ABMIEN=0
 .F  S ABMIEN=$O(^ABMDTXST(DUZ(2),"B",ABMBDT,ABMIEN)) Q:+ABMIEN=0  D
 ..I $P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U,4)'=ABMREX("SELINS") Q  ;not our ins
 ..I ABMREX("SELEXP")'="",($P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U,2)'=(ABMREX("SELEXP"))) Q  ;they selected one & this isn't it
 ..I ABMREX("SELEXP")="",($P($G(^ABMDEXP($P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U,2),0)),U)'[("837")) Q  ;they didn't answer so deflt to all 837s
 ..S ABMBIEN=0
 ..S ABMFBCNT=0
 ..F  S ABMBIEN=$O(^ABMDTXST(DUZ(2),ABMIEN,2,ABMBIEN)) Q:+ABMBIEN=0  D
 ...I $P($G(^ABMDBILL(DUZ(2),ABMBIEN,0)),U,4)="X" Q  ;skip cancelled bills
 ...S ABMBALCK=$$CHECKBAL(ABMBIEN)
 ...I ABMBALCK=0 Q  ;has been posted to
 ...S ABMVLOC=$P($G(^ABMDBILL(DUZ(2),ABMBIEN,0)),U,3)
 ...S ABMVTYP=$P($G(^ABMDBILL(DUZ(2),ABMBIEN,0)),U,7)
 ...S ABMEXP=$P($G(^ABMDBILL(DUZ(2),ABMBIEN,0)),U,6)
 ...S ABMINS=$P($G(^ABMDBILL(DUZ(2),ABMBIEN,0)),U,8)
 ...S ^TMP($J,"ABM-REEX",ABMINS,ABMVLOC,ABMVTYP,ABMEXP,ABMBIEN)=""  ;use this for export
 ...S ABMBCNT=+$G(ABMBCNT)+1
 ...S ABMTAMT=+$G(ABMTAMT)+$P($G(^ABMDBILL(DUZ(2),ABMBIEN,2)),U)  ;total bill cnt, amt
 ...S ABMREX("CNTS",ABMEXP,ABMIEN)=+$G(ABMREX("CNTS",ABMEXP,ABMIEN))+1
 ...S $P(ABMREX("CNTS",ABMEXP,ABMIEN),U,2)=+$P(ABMREX("CNTS",ABMEXP,ABMIEN),U,2)+$P($G(^ABMDBILL(DUZ(2),ABMBIEN,2)),U)
 ...S ^TMP($J,"ABM-D-DUP",ABMBIEN)=+$G(^TMP($J,"ABM-D-DUP",ABMBIEN))+1
 ;end new HEAT136160
 I ABMBCNT=0 W !!,"No Bills were found that meet the selected criteria" H 3 Q  ;abm*2.6*21 IHS/SD/SDR HEAT207484
 W !!,"A total of "_ABMBCNT_" "_$S(ABMBCNT=1:"bill ",1:"bills ")_"for $"_$J(ABMTAMT,1,2)_" have been located."
 I ABMBCNT>0 D
 .W !?8,"Export mode",?25,"Export Dt/Tm",?50,"#Bills",?60,"Total Amt"
 .S ABMREX("EXP")=0,ABMECNT=0
 .F  S ABMREX("EXP")=$O(ABMREX("CNTS",ABMREX("EXP"))) Q:($G(ABMREX("EXP"))="")  D
 ..S ABMIEN=0
 ..F  S ABMIEN=$O(ABMREX("CNTS",ABMREX("EXP"),ABMIEN)) Q:($G(ABMIEN)="")  D
 ...S ABMECNT=+$G(ABMECNT)+1
 ...W !,?1,ABMECNT,?8,$P(^ABMDEXP(ABMREX("EXP"),0),U),?25,$$CDT^ABMDUTL($P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U)),?50,+$G(ABMREX("CNTS",ABMREX("EXP"),ABMIEN)),?60,$J(+$P($G(ABMREX("CNTS",ABMREX("EXP"),ABMIEN)),U,2),1,2)
ZIS ;EP
 D ZIS^ABMDREX1  ;abm*2.6*20 IHS/SD/SDR split routine due to size
OUT ;
 D ^%ZISC
 ;
XIT ;
 K ^TMP($J,"D"),^TMP($J,"ABM-D")
 K ABMP,ABMY,DIQ,ABMT,ABMREX
 Q
CHECKBAL(ABMBIEN) ;this checks if there's an open balance on the A/R Bill and returns '1' if there is, '0' if not
 S ABMBALCK=0
 S ABMHOLD=DUZ(2)
 S BARSAT=$P($G(^ABMDBILL(DUZ(2),ABMBIEN,0)),U,3)  ;Satellite=3P Visit loc
 S ABMP("DOS")=$P($G(^ABMDBILL(DUZ(2),ABMBIEN,7)),U)
 S BARPAR=0  ;Parent
 ; check site active at DOS to ensure bill added to correct site
 S DA=0
 F  S DA=$O(^BAR(90052.06,DA)) Q:DA'>0  D  Q:BARPAR
 .Q:'$D(^BAR(90052.06,DA,DA))  ;Pos Parent UNDEF Site Parm
 .Q:'$D(^BAR(90052.05,DA,BARSAT))  ;Sat UNDEF Par/Sat
 .Q:+$P($G(^BAR(90052.05,DA,BARSAT,0)),U,5)  ;Par/Sat not usable
 .;Q if sat NOT active at DOS
 .I ABMP("DOS")<$P($G(^BAR(90052.05,DA,BARSAT,0)),U,6) Q
 .;Q if sat became NOT active before DOS
 .I $P($G(^BAR(90052.05,DA,BARSAT,0)),U,7),(ABMP("DOS")>$P($G(^BAR(90052.05,DA,BARSAT,0)),U,7)) Q
 .S BARPAR=$S(BARSAT:$P($G(^BAR(90052.05,DA,BARSAT,0)),U,3),1:"")
 I 'BARPAR Q ABMBALCK  ;No parent defined for satellite
 S DUZ(2)=BARPAR
 ;S ABMARBIL=$O(^BARBL(DUZ(2),"B",$P($G(^ABMDBILL(ABMHOLD,ABMBIEN,0)),U)))  ;abm*2.6*35 IHS/SD/SDR ADO60707
 S ABMARBIL=$O(^BARBL(DUZ(2),"B",$P($P($G(^ABMDBILL(ABMHOLD,ABMBIEN,0)),U),"-")_" "))  ;abm*2.6*35 IHS/SD/SDR ADO60707
 S ABMARIEN=$O(^BARBL(DUZ(2),"B",ABMARBIL,0))
 Q:'ABMARIEN ABMBALCK
 S ABMARBAL=$$GET1^DIQ(90050.01,ABMARIEN,15)
 ;start old abm*2.6*35 IHS/SD/SDR ADO60707
 ;I ABMARBAL'=($P($G(^ABMDBILL(ABMHOLD,ABMBIEN,2)),U)) S ABMBALCK=0
 ;I ABMARBAL=($P($G(^ABMDBILL(ABMHOLD,ABMBIEN,2)),U)) S ABMBALCK=1
 ;end old start new abm*2.6*35 IHS/SD/SDR ADO60707
 S ABMBALCK=0
 I +$G(ABMARBAL)'=0 S ABMBALCK=1
 ;end new abm*2.6*35 IHS/SD/SDR ADO60707
 S DUZ(2)=ABMHOLD
 Q ABMBALCK
CREATEN ;
 S ABMSEQ=1
 S ($P(ABMER(ABMSEQ),U,3),ABMP("EXP"))=ABMEXP
 ;S ABMLOC=$P($G(^AUTTLOC(DUZ(2),0)),U,2)  ;HEAT136160
 S ABMLOC=$P($G(^AUTTLOC(ABMY("LOC"),0)),U,2)  ;HEAT136160
 S ABMY("INS")=$S($G(ABMREX("SELINS")):ABMREX("SELINS"),1:ABMT("INS"))
 S ABMINS("IEN")=ABMY("INS")  ;ins
 S $P(ABMER(ABMSEQ),U)=ABMINS("IEN")
 S $P(ABMER(ABMSEQ),U,2)=ABMY("VTYP")
 S $P(ABMER(ABMSEQ),U,5)=ABMY("TOT")
 S ABMITYP=$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABMY("INS"),".211","I"),1,"I")  ;ins typ
 ;# forms & tot chgs
 I $G(ABMP("SELINS"))="" S $P(ABMER(ABMSEQ),U,4)=+$G(ABMBCNT)
 I $G(ABMP("SELINS"))'="" S $P(ABMER(ABMSEQ),U,4)=+$G(ABMREX("CNTS",ABMEXP,ABMREX("EDFN")))
 D FILE^ABMECS
 Q
USEORIG ;
 S ABMP("XMIT")=ABMREX("EDFN")
 S ABMP("EXP")=$P(^ABMDTXST(DUZ(2),ABMP("XMIT"),0),"^",2)
 S ABMP("XRTN")=$P($G(^ABMDEXP(+ABMP("EXP"),0)),"^",4)
 S X=ABMP("XRTN")
 X ^%ZOSF("TEST")
 I '$T D  K ABMP Q
 .W !!,"Routine :",ABMP("XRTN")," not found.Cannot proceed.",!
 .S DIR(0)="E"
 .D ^DIR
 .K DIR
 D @("^"_ABMP("XRTN"))
 K ABMP
 Q
LISTBILL ;
 K ABMY
 S ABMT("BDFN")=0
 F  S ABMT("BDFN")=$O(^ABMDTXST(DUZ(2),ABMREX("EDFN"),2,ABMT("BDFN"))) Q:'ABMT("BDFN")  D
 .I $P($G(^ABMDBILL(DUZ(2),ABMT("BDFN"),0)),U,4)="X" Q  ;skip cancelled bills
 .S ABMBALCK=$$CHECKBAL(ABMT("BDFN"))
 .I ABMBALCK=0 Q
 .S ABMY(ABMT("BDFN"))=""
 Q
BILLSTAT(ABMLOC,ABMBDFN,ABMEXP,ABMSTAT,ABMGCN) ;
 N DIC,DIE,DIR,DA,X,Y,ABMP
 S ABMHOLD=DUZ(2)
 S DUZ(2)=ABMLOC
 S (DA(1),ABMREX("BDFN"))=ABMBDFN
 S DIC="^ABMDBILL(DUZ(2),"_DA(1)_",74,"
 S DIC("P")=$P(^DD(9002274.4,.175,0),U,2)
 S DIC(0)="L"
 S X=ABMEXP
 I $G(ABMREX("BILLSELECT"))'="" S ABMSTAT="F"
 I $G(ABMREX("BATCHSELECT"))'="" S ABMSTAT="S"
 I $G(ABMREX("RECREATE"))'="" S ABMSTAT="C"
 S DIC("DR")=".02////"_ABMSTAT_";.03////"_ABMGCN
 S DIC("DR")=DIC("DR")_";.04////"_ABMXMTDT  ;abm*2.6*37 IHS/SD/SDR ADO75923
 K DD,DO
 D FILE^DICN
 S DUZ(2)=ABMHOLD
 S X="A"  ;deflt bill status to approved
 N DA
 S DA=ABMBDFN
 Q
