ABMDE8D ; IHS/SD/SDR - Page 8 - MEDICATIONS ; APR 05, 2002
 ;;2.6;IHS Third Party Billing System;**2,7,9,19,21,28,30,31,32,33,37**;NOV 12, 2009;Build 739
 ;
 ;IHS/SD/SDR 2.5 P8 Rewrote routine Request to completely change display
 ;IHS/SD/SDR 2.5 p9 IM16660 4-digit revenue codes
 ;IHS/SD/SDR 2.5 p9 task 1 Use service line provider multiple
 ;IHS/SD/SDR 2.5 p11 NPI
 ;
 ;IHS/SD/SDR 2.6*2 3PMS10003A Modified to call ABMFEAPI
 ;IHS/SD/SDR 2.6*19 HEAT173117 Added code to prompt for CPT Narrative if necessary for med.
 ;IHS/SD/SDR 2.6*21 HEAT168435 Added code to display/add/edit pharmacy modifiers
 ;IHS/SD/SDR 2.6*21 HEAT207995 Gave user ability to edit NDC even when a prescription from the
 ;  prescription file is selected.  They want ability to remove dashes in NDC.
 ;IHS/SD/SDR 2.6*28 CR10648 Added default (CPT description) to CPT NARRATIVE prompt
 ;IHS/SD/SDR 2.6*28 CR10551 Added IMMUNIZATION LOT/BATCH NUMBER prompt
 ;IHS/SD/SDR 2.6*30 CR8870 Updated display so it won't wrap if units are maxed out, including 3 decimal places
 ;IHS/SD/SDR 2.6*31 CR11624 Change API call to CPTD^ABMCVAPI to fix <SUBSCR>VLTCP+8^ICPTCOD
 ;IHS/SD/SDR 2.6*32 CR8943 Added code to stop error <UNDEFINED>E+48^ABMDE8D, when the first prescription prompt is answered
 ;  and the provider is deleted.
 ;IHS/SD/SDR 2.6*32 CR10335 Fixed so user can type 'E#' or just '#' to edit a line; before if you entered '3' it would turn around and ask what line (1-##) instead
 ;  of recognizing that you entered '3' to edit line 3
 ;IHS/SD/SDR 2.6*33 ADO60186/CR12024 Prompt for CPT Narrative if export mode is UB-04 (in addition to all 5010s and 1500(02/12)); Added new checks for Medication description
 ;  in the NARR option; split routine to ABMDE8D1 due to size; Added DEA# if ordering provider is present and it's a controlled substance
 ;IHS/SD/SDR 2.6*37 ADO89299 Changed display to use new field for DEA_VA_USPHS number
 ;
DISP K ABMZ,DIC
 S ABMZ("TITL")="MEDICATIONS",ABMZ("PG")="8D"
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
 ;
 D D^ABMDE8X
 S $P(ABMZ("="),"=",81)=""
 S ABMZ("SUB")=23,ABMZ("DIAG")=";.13"
 S ABMZ("ITEM")="Medication",ABMZ("DIC")="^PSDRUG("
 S ABMZ("X")="X",(ABM("FEE"),ABMZ("TOTL"))=0
 D HD G LOOP
HD ;
 ;start old abm*2.6*30 IHS/SD/SDR CR8870
 ;W !?5,"REVN",?11,"CHARGE",?60,"DAYS",?74,"TOTAL"
 ;W !?5,"CODE",?11,"DATE",?30,"MEDICATION",?60,"SUPPLY",?68,"QTY",?74,"CHARGE"
 ;W !,ABMZ("=")
 ;end old start new abm*2.6*30 IHS/SD/SDR CR8870
 W !?5,"REVN",?11,"CHARGE",?55,"DAYS",?72,"TOTAL"
 W !?5,"CODE",?11,"DATE",?30,"MEDICATION",?54,"SUPPLY",?63,"QTY",?72,"CHARGE"
 W !?5,"====",?11,"==========================================",?55,"====",?61,"=======",?70,"=========="
 ;end old abm*2.6*30 IHS/SD/SDR CR8870
 Q
LOOP S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1),ABM)=0 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM)) Q:'ABM  S ABM("X")=ABM,ABMZ("NUM")=ABM("I") D PC1
 ;I ABMZ("NUM")>0 W !,?72,"========",!?5,"TOTAL",?71,$J("$"_($FN(ABMZ("TOTL"),",",2)),9)  ;abm*2.6*30 IHS/SD/SDR CR8870
 I ABMZ("NUM")>0 W !,?69,"===========",!?5,"TOTAL",?68,$J("$"_($FN(ABMZ("TOTL"),",",2)),12),!  ;abm*2.6*30 IHS/SD/SDR CR8870
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 G XIT
 ;
PC1 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM("X"),0)
 S ABM("X2")=$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM("X"),2))  ;abm*2.6*21 IHS/SD/SDR HEAT168435
 S ABMZ("UNIT")=$P(ABM("X0"),U,3)
 S:'+ABMZ("UNIT") ABMZ("UNIT")=1
 Q:'$D(^PSDRUG(+ABM("X0"),0))  S ABMZ(ABM("I"))=$P(^(0),U)_U_ABM("X")_U_$P(ABM("X0"),U,2)
EOP I $Y>(IOSL-8) D PAUSE^ABMDE1,HD
 W !,"[",ABM("I"),"]"
 I $P(ABM("X0"),U,14) D
 .W ?5,$$GETREV^ABMDUTL($P(ABM("X0"),U,2))  ;rev code
 .W ?11,$$CDT^ABMDUTL($P(ABM("X0"),U,14))  ;charge date
 .I $P(ABM("X0"),U,28)'="",($P(ABM("X0"),U,14)'=$P(ABM("X0"),U,28)) W "-",$$CDT^ABMDUTL($P(ABM("X0"),U,28))
 I $P(ABM("X0"),U,26)'="" W " (+)"  ;date disc
 I $P(ABM("X0"),U,27)'="" W " (*)"  ;RTS
 W ?30,$S($P(ABM("X0"),U,22)]"":"  Rx:"_$P($G(^PSRX($P(ABM("X0"),U,22),0)),U)_" ",$P($G(ABM("X0")),U,6)'="":" Rx: "_$P(ABM("X0"),U,6)_" ",1:"<No Rx>")  ;Rx number
 I $P(ABM("X0"),U,29)'="" W ?40,"CPT: ",$P($$CPT^ABMCVAPI(+$P(ABM("X0"),U,29),ABMP("VDT")),U,2)  ;abm*2.6*7 HEAT30524
 S ABMZ("MOD")=""  ;abm*2.6*21 IHS/SD/SDR HEAT168435
 F ABM("M")=3,4,5 S:$P(ABM("X2"),U,ABM("M"))]"" ABMZ("MOD")=ABMZ("MOD")_"-"_$P(ABM("X2"),U,ABM("M"))  ;abm*2.6*21 IHS/SD/SDR HEAT168435
 W:ABMZ("MOD")]"" ABMZ("MOD")_" "  ;abm*2.6*21 IHS/SD/SDR HEAT168435
 S ABMRPRV=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM("X"),"P","C","D",0))
 S:ABMRPRV="" ABMRPRV=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM("X"),"P","C","R",0))
 I ABMRPRV'="" D  ;rendering provider on line item
 .;W " ("_$P($G(^VA(200,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM("X"),"P",ABMRPRV,0),U),0)),U)_"-"_$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM("X"),"P",ABMRPRV,0),U,2)_")"  ;abm*2.6*7 HEAT30524
 .;W !?51," ("_$E($P($G(^VA(200,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM("X"),"P",ABMRPRV,0),U),0)),U),1,23)_"-"_$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM("X"),"P",ABMRPRV,0),U,2)_")"  ;abm*2.6*7 HEAT30524  ;abm*2.6*21 IHS/SD/SDR HEAT168435
 .;W !?40," ("_$E($P($G(^VA(200,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM("X"),"P",ABMRPRV,0),U),0)),U),1,23)_"-"_$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM("X"),"P",ABMRPRV,0),U,2)_")"  ;abm*2.6*21 HEAT168435  ;abm*2.6*37 IHS/SD/SDR ADO89299
 .W !?10," ("_$E($P($G(^VA(200,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM("X"),"P",ABMRPRV,0),U),0)),U),1,23)_"-"_$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM("X"),"P",ABMRPRV,0),U,2)_")"  ;abm*2.6*37 IHS/SD/SDR ADO89299
 .;start new abm*2.6*33 IHS/SD/SDR ADO60186
 .I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM("X"),"P",ABMRPRV,0),U,2)="D" D
 ..S ABMA("CSUB")=$P($G(^PSDRUG(+ABM("X0"),0)),U,3)
 ..I '((ABMA("CSUB")[2)!(ABMA("CSUB")[3)!(ABMA("CSUB")[4)!(ABMA("CSUB")[5)) Q
 ..;W "  DEA# "_$P($G(^VA(200,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM("X"),"P",ABMRPRV,0),U),"PS")),U,2)  ;abm*2.6*37 IHS/SD/SDR ADO89299
 I (("^32^35^"[("^"_ABMP("EXP")_"^"))&($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM("X"),2)),U,6)'="")) W "  DEA# "_$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABM("X"),2)),U,6)  ;abm*2.6*37 IHS/SD/SDR ADO89299
 ;end new abm*2.6*33 IHS/SD/SDR ADO60186
 W !
 W ?4,$S($P($G(ABM("X0")),U,24)]"":$P(ABM("X0"),U,24)_" ",1:"<NO NDC>        ")  ;NDC number
 S ABMU("TXT")=$P(ABMZ(ABM("I")),U)  ;Medication
 N M7,M8,M9
 S M7=$P(ABM("X0"),U,7)  ;additive
 S M8=$P(ABM("X0"),U,8)  ;solution
 S M9=" "_$P(ABM("X0"),U,9)  ;narrative
 S ABMU("TXT")=ABMU("TXT")_" "_$S(M7&($D(^PS(52.6,+M7,0))):$P(^PS(52.6,M7,0),U)_M9,M8&($D(^PS(52.7,+M8,0))):$P(^(0),U)_M9,1:"")
 ;S ABMU("RM")=57  ;abm*2.6*30 IHS/SD/SDR CR8870
 S ABMU("RM")=53  ;abm*2.6*30 IHS/SD/SDR CR8870
 ;S ABMU("LM")=22  ;abm*2.6*30 IHS/SD/SDR CR8870
 S ABMU("LM")=18  ;abm*2.6*30 IHS/SD/SDR CR8870
 D ^ABMDWRAP
 ;start old abm*2.6*30 IHS/SD/SDR CR8870
 ;W ?60,$J($P(ABM("X0"),U,20),3)  ;days supply
 ;W ?68,$J(ABMZ("UNIT"),3)  ;quantity
 ;W ?72,$J($FN(($P(ABM("X0"),U,4)*ABMZ("UNIT"))+$P(ABM("X0"),U,5),",",2),8)  ;total charge
 ;end old start new abm*2.6*30 IHS/SD/SDR CR8870
 W ?56,$J($P(ABM("X0"),U,20),3)  ;days supply
 W ?60,$$FMT^ABMERUTL(ABMZ("UNIT"),"9R")  ;quantity
 W ?69,$J($FN(($P(ABM("X0"),U,4)*ABMZ("UNIT"))+$P(ABM("X0"),U,5),",",2),11)  ;total charge
 ;end new abm*2.6*30 IHS/SD/SDR CR8870
 I $P(ABM("X0"),U,6)]"" D
 .N DA S DA=$O(^PSRX("B",$P(ABM("X0"),"^",6),0)) Q:'DA
 .S DIC="^PSRX(",DR=12,DIQ="ABM(",DIQ(0)="E" D EN^DIQ1 K DIQ
 .Q:ABM(52,DA,12,"E")=""
 .S ABMU("TXT")=$G(ABMU("TXT"))_" Comments: "_ABM(52,DA,12,"E")
 S ABM("FEE")=ABM("FEE")+$P(ABM("X0"),U,5)
 S ABMZ("CHARGE")=+$P(ABM("X0"),U,4)  ;abm*2.6*21 IHS/SD/SDR HEAT168435
 ;S ABMZ("TOTL")=(ABMZ("UNIT")*$P(ABM("X0"),U,4))+ABMZ("TOTL")+$P(ABM("X0"),U,5)  ;abm*2.6*21 IHS/SD/SDR HEAT168435
 S ABMZ("TOTL")=(ABMZ("UNIT")*ABMZ("CHARGE"))+ABMZ("TOTL")+$P(ABM("X0"),U,5)  ;abm*2.6*21 IHS/SD/SDR HEAT168435
 Q
XIT K ABM,ABMMODE
 Q
A ;EP  ADD ENTRY
 K DIC
 S DIC="^PSDRUG("
 S DIC(0)="AEMQ"
 S DIC("P")=$P(^DD(9002274.3,23,0),U,2)
 D ^DIC
 Q:+Y<0  S ABMZ("DRUG")=+Y
 S DA(1)=ABMP("CDFN")
 S DIC="^ABMDCLM(DUZ(2),DA(1),23,",X=+Y
 S ABMX("Y")=X,$P(ABMZ(ABMX("Y")),U,2)=X ;abm*2.6*21 IHS/SD/SDR HEAT168435
 K DD,DO
 D FILE^DICN
 Q:Y<0  S DA=+Y
 I '$G(ABMZ("NUM")) S ABMZ("NUM")=1
 S ABMZ(+Y)=$P($G(^PSDRUG($P(Y,U,2),0)),U)_U_+Y,DA=+Y G E2  ;abm*2.6*32 IHS/SD/SDR CR10335
E ;EDIT EXISTING ENTRY
 I +$G(ABMZ("NUM"))=0 W *7,!!,"There are no entries to edit, you must first ADD an entry.",! K DIR S DIR(0)="E" D ^DIR K DIR Q
 ;start new abm*2.6*32 IHS/SD/SDR CR10335
 I $E(Y,2,3)>0&($E(Y,2,3)<(ABMZ("NUM")+1)) S Y=$E(Y,2,3) G E2
 I ABMZ("NUM")=1 S Y=1 G E2
 K DIR S DIR(0)="NO^1:"_ABMZ("NUM")_":0"
 S DIR("?")="Enter the Sequence Number of "_ABMZ("ITEM")_" to Edit",DIR("A")="Sequence Number to EDIT"
 D ^DIR K DIR
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(+Y'>0)
E2 ;
 I $G(ABMZ(+Y))'="" W !!,"["_+Y_"]  "_$P(ABMZ(+Y),U),!
 S DA(1)=ABMP("CDFN")  ;abm*2.6*33 IHS/SD/SDR ADO60186
 S DA=$P(ABMZ(+Y),U,2)
 S ABMZ("DRUG")=$P(^ABMDCLM(DUZ(2),DA(1),23,DA,0),U)
 ;end new abm*2.6*32 IHS/SD/SDR CR10335
 ;
 ;start old abm*2.6*32 IHS/SD/SDR CR10335
 ;I '$G(ABMZ("DRUG")) D  Q:'Y
 ;.S DA(1)=ABMP("CDFN")
 ;.I ABMZ("NUM")=1 S Y=1
 ;.E  S DIR(0)="NO^1:"_ABMZ("NUM") D ^DIR K DIR Q:'Y
 ;.S DA=$P(ABMZ(Y),U,2)
 ;.S ABMZ("DRUG")=$P(^ABMDCLM(DUZ(2),DA(1),23,DA,0),U)
 ;end old abm*2.6*32 IHS/SD/SDR CR10335
 D MODE^ABMDE8X
 S DIE="^ABMDCLM(DUZ(2),DA(1),23,"
 ;start new abm*2.6*21 IHS/SD/SDR HEAT168435
 S ABMX("Y")=DA,$P(ABMZ(ABMX("Y")),U,2)=DA
 S ABMZ("MOD")=.31_U_3_U_.32_U_.33
 D MOD3^ABMDEMLC
 ;end new abm*2.6*21 IHS/SD/SDR HEAT168435
 D PPDU^ABMDE8D1 Q:$D(DIRUT)
 S DR=DR_".22Prescription"
 S ABMSCRIP=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,22)
 D ^DIE
 I ABMSCRIP'="",$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,22)="" D  Q  ;the Prescription was removed
 .K DIR,DIE,DIC
 .S DA(1)=ABMP("CDFN")
 .S DIK="^ABMDCLM(DUZ(2),"_DA(1)_",23,"
 .D ^DIK
 ;if prescription, get data from there and just ask about Dxs
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,22)'="" D
 .S ABMIEN=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,22)
 .K DR
 .S DR=".06////@"  ;remove other Prescription#
 .S DR=DR_";.03Units (at $"_ABMZ("PPDU")_" per unit)//"_$P($G(^PSRX(ABMIEN,0)),U,7)_";.04///"_ABMZ("PPDU") D ^DIE
 .D DFEE^ABMDE8D1 S DR=".16Times Dispensed (at $"_ABMZ("DISPFEE")_" per each time dispensed) //1"
 .D ^DIE Q:$D(Y)
 .S DR=".05///"_(ABMZ("DISPFEE")*X) D ^DIE
 .S DR=".25////"_$P($G(^PSRX(ABMIEN,0)),U,13)  ;date written
 .S DR=DR_";.2////"_$P($G(^PSRX(ABMIEN,0)),U,8)  ;days supply
 .;S DR=DR_";.24////"_$P($G(^PSRX(ABMIEN,2)),U,7)  ;NDC  ;abm*2.6*21 IHS/SD/SDR HEAT207995
 .S DR=DR_";.29//"  ;CPT code  ;abm*2.6*7 HEAT30524  ;abm*2.6*33 IHS/SD/SDR CR12024
 .S DR=DR_";.24//"_$P($G(^PSRX(ABMIEN,2)),U,7)  ;NDC  ;abm*2.6*21 IHS/SD/SDR HEAT207995
 .;S DR=DR_";.29//"  ;CPT code  ;abm*2.6*7 HEAT30524  ;abm*2.6*33 IHS/SD/SDR CR12024
 .D ^DIE
 .;
 .;start new abm*2.6*33 IHS/SD/SDR CR12024
 .S ABM("NDC")=""
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,24)'="" D
 ..S ABM("NDC")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,24)
 ..I +$O(^PSDRUG("ZNDC",$TR(ABM("NDC"),"-"),0))=0 S ABM("NDC")=""
 .I $G(ABM("NDC"))="" S ABM("NDC")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U)
 .I ABM("NDC")'="" S ABMT("MEDN")="<NO MED FOR NDC>"  ;default of the NDC isn't found for some reason
 .I $G(ABM("NDC"))'="" D
 ..S ABM("NDC")=$O(^PSDRUG("ZNDC",$TR(ABM("NDC"),"-"),0))
 ..I $G(ABM("NDC"))="" Q
 ..I +$G(ABM("NDC"))'=0 S (ABMT("MED"),ABMT("MEDN"))=$P($G(^PSDRUG(ABM("NDC"),0)),U)
 .W "  "_ABMT("MEDN")
 .;end new abm*2.6*33 IHS/SD/SDR CR12024
 .;
 .S ABMTCPT=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,29)  ;abm*2.6*28 IHS/SD/SDR CR10551
 .D IMMUN^ABMDE8D1  ;abm*2.6*28 IHS/SD/SDR CR10551
 .D NARR^ABMDE8D1  ;abm*2.6*19 IHS/SD/SDR HEAT173117
 .D PROV^ABMDE8D1
 ;
 ;no prescription, prompt for all fields
 ;E  D  ;abm*2.6*19 IHS/SD/SDR HEAT173117
 S DA=ABMX("Y")  ;abm*2.6*32 IHS/SD/SDR CR8943
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,22)="" D  ;abm*2.6*19 IHS/SD/SDR HEAT173117
 .S DR=".14//"_$S($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,14)'="":$$SDT^ABMDUTL($P(^(0),U,14)),$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),7),U,1)'=$P(^(7),U,2):$$SDT^ABMDUTL($P(^(7),U)),1:"/"_$$SDT^ABMDUTL($P(^(7),U)))
 .S DR=DR_";.28//"_$$SDT^ABMDUTL($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0),U,14))
 .S DR=DR_";.03Units (at $"_ABMZ("PPDU")_" per unit);.04///"_ABMZ("PPDU")
 .D ^DIE Q:$D(Y)
 .S DR=".17///M" D ^DIE
 .S ABM("X0")=^ABMDCLM(DUZ(2),DA(1),23,DA,0)
 .D DFEE^ABMDE8D1 S DR=".16Times Dispensed (at $"_ABMZ("DISPFEE")_" per each time dispensed) //1"
 .D ^DIE Q:$D(Y)
 .S ABMZ("SVCPT")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,29)  ;abm*2.6*28 IHS/SD/SDR CR10648  ;abm*2.6*33 IHS/SD/SDR CR12024
 .S DR=".05///"_(ABMZ("DISPFEE")*X) D ^DIE
 .S DR=".2;.06;.22////@;.19Refill"
 .;S DR=DR_";.24//"_$S($P($G(^PSDRUG(+ABM("X0"),2)),U,4)]"":$P(^(2),U,4),1:"")  ;abm*2.6*33 IHS/SD/SDR CR12024
 .S DR=DR_";.25"
 .S DR=DR_";.29//"  ;CPT code  ;abm*2.6*7 HEAT30524
 .;
 .;start new abm*2.6*33 IHS/SD/SDR CR12024
 .D ^DIE
 .S DR=".24//"_$S($P($G(^PSDRUG(+ABM("X0"),2)),U,4)]"":$P(^(2),U,4),1:"")
 .D ^DIE
 .S ABM("NDC")="",ABMT("MEDN")=""
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,24)'="" D
 ..S ABM("NDC")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,24)
 ..I ABM("NDC")'="" S ABMT("MEDN")="<NO MED FOR NDC>"  ;default of the NDC isn't found for some reason
 ..I +$O(^PSDRUG("ZNDC",$TR(ABM("NDC"),"-"),0))=0 S ABM("NDC")=""
 .I $G(ABM("NDC"))="" S ABM("NDC")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U)
 .I $G(ABM("NDC"))'="" D
 ..S ABM("NDC")=$O(^PSDRUG("ZNDC",$TR(ABM("NDC"),"-"),0))
 ..I $G(ABM("NDC"))="" Q
 ..I +$G(ABM("NDC"))'=0 S (ABMT("MED"),ABMT("MEDN"))=$P($G(^PSDRUG(ABM("NDC"),0)),U)
 .W "  "_ABMT("MEDN")
 .;end new abm*2.6*33 IHS/SD/SDR CR12024
 .;
 .;S ABMZ("SVCPT")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,29)  ;abm*2.6*28 IHS/SD/SDR CR10648  ;abm*2.6*33 IHS/SD/SDR CR12024
 .;D ^DIE  ;abm*2.6*33 IHS/SD/SDR CR12024
 .;
 .;start new abm*2.6*28 IHS/SD/SDR CR10648
 .I ABMZ("SVCPT")'=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,29) D
 ..S DR="22////@"
 ..D ^DIE
 .;end new abm*2.6*28 IHS/SD/SDR CR10648
 .S ABMTCPT=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,29)  ;abm*2.6*28 IHS/SD/SDR CR10551
 .D IMMUN^ABMDE8D1  ;abm*2.6*28 IHS/SD/SDR CR10551
 .D NARR^ABMDE8D1  ;abm*2.6*19 IHS/SD/SDR HEAT173117
 .D PROV^ABMDE8D1
 .;
 I (^ABMDEXP(ABMMODE(4),0)["HCFA")!(^ABMDEXP(ABMMODE(4),0)["CMS") D
 .D DX^ABMDEMLC S DR=".13////"_$G(Y(0)) D ^DIE
 .S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 Q
