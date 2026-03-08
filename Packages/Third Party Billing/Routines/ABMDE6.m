ABMDE6 ; IHS/SD/SDR - Page 6 - DENTAL ;
 ;;2.6;IHS Third Party Billing System;**2,8,10,21,28,30,37**;NOV 12, 2009;Build 739
 ;
 ;IHS/SD/SDR 2.5*9 IM17106 <UNDEFINED>PC1^ABMDE6 regarding a cross reference with no entry
 ;IHS/SD/SDR 2.5*10 IM20380/IM20401 fix when Edit choosen & only one option of if they don't select any
 ;IHS/SD/SDR 2.5*10 IM20873 <UNDEF>E+21^ABMDE6 error (entry not selected when Delete is selected)
 ;IHS/SD/SDR 2.5*11 NPI change for needed fields for ADA-2006 format field was there but not being asked
 ;
 ;IHS/SD/SDR 2.6*2 3PMS10003A modified to call ABMFEAPI
 ;IHS/SD/SDR 2.6*21 HEAT124092 Made default revenue code 512
 ;IHS/SD/SDR 2.6*28 CR8340 Added 3 modifiers to page
 ;IHS/SD/SDR 2.6*30 CR8870 Updated display so it won't wrap if units are maxed out, including 3 decimal places
 ;IHS/SD/SDR 2.6*37 Updated display so operation site will display leading zero based on 3P Dental Recode parameter
 ;
OPT9 K ABM,ABME
 S ABM("TOTL")=0
 D DISP
 W ! S ABMP("OPT")="ADEVNJBQ" D SEL^ABMDEOPT S ABM("ACTION")=Y
 I "AVDE"'[$E(Y) S:$D(ABMP("DDL"))&($E(ABMP("PAGE"),$L(ABMP("PAGE")))=6) ABMP("QUIT")="" G XIT
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("DO")=$S($E(Y)="V":"V1",1:"A")
 K DA D @ABM("DO")
 G OPT9
 ;
DISP ;PAGE DISPLAY
 K ABMZ
 S ABMZ("TITL")="DENTAL SERVICES",ABMZ("PG")="6"
 S ABMZ("ITEM")="Dental (ADA Code)"
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
 ;
 D ^ABMDE6X
 S ABMZ("SUB")=33
 D HD G LOOP
HD ;
 ;start old abm*2.6*30 IHS/SD/SDR CR8870
 ;W !?4,"VISIT",?56,"ORAL",?61,"OPER"
 ;W !?4,"DATE",?11,"              DENTAL SERVICE",?56,"CAV",?61,"SITE",?66,"SURF",?73,"CHARGE"
 ;W !?4,"=====",?11,"============================================",?56,"====",?61,"====",?66,"=====",?73,"======"
 ;end old start new abm*2.6*30 IHS/SD/SDR CR8870
 W !?4,"VISIT",?52,"ORAL",?58,"OPER"
 W !?4,"DATE",?11,"             DENTAL SERVICE",?52,"CAV",?58,"SITE",?63,"SURF",?72,"CHARGE"
 W !?4,"=====",?11,"========================================",?52,"====",?58,"====",?63,"=====",?70,"=========="
 ;end new abm*2.6*30 IHS/SD/SDR CR8870
 Q
LOOP ;LOOP THROUGH LINE ITEMS
 S (ABMZ("LNUM"),ABMZ(1),ABM)=0
 S ABMZ("NUM")=0
 F  S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),33,"C",ABM)) Q:'ABM  D
 .S ABM("X")=0
 .F  S ABM("X")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),33,"C",ABM,ABM("X"))) Q:'ABM("X")  D
 ..I '$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),33,ABM("X"),0)) K ^ABMDCLM(DUZ(2),ABMP("CDFN"),33,"C",ABM,ABM("X")) Q
 ..D PC1
 ;W !?72,"=======",!?70,$J(("$"_$FN(ABM("TOTL"),",",2)),9)  ;abm*2.6*30 IHS/SD/SDR CR8870
 W !?67,"=============",!?67,$J(("$"_$FN(ABM("TOTL"),",",2)),13)  ;abm*2.6*30 IHS/SD/SDR CR8870
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 G XIT
 ;
PC1 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),33,ABM("X"),0)
 S ABMZ("NUM")=+ABMZ("NUM")+1
 S ABMZ(ABMZ("NUM"))=$P(^AUTTADA(+ABM("X0"),0),U)_U_ABM("X")
EOP I $Y>(IOSL-5) D PAUSE^ABMDE1,HD
 W !,"[",ABMZ("NUM"),"]"
 I $P(ABM("X0"),U,7)]"" W ?4,$E($P(ABM("X0"),U,7),4,5)_"/"_$E($P(ABM("X0"),U,7),6,7)
 ;W ?11,$P(^AUTTADA(+ABM("X0"),0),U)," ",$E($P(^(0),U,2),1,39)  ;abm*2.6*28 IHS/SD/SDR CR8340
 W ?11,$P(^AUTTADA(+ABM("X0"),0),U)  ;abm*2.6*28 IHS/SD/SDR CR8340
 F ABMI=13,14,15 I $P(ABM("X0"),U,ABMI)'="" W "-"_$P(ABM("X0"),U,ABMI)  ;abm*2.6*28 IHS/SD/SDR CR8340
 ;start old abm*2.6*30 IHS/SD/SDR CR8870
 ;W " ",$E($P(^(0),U,2),1,31)  ;abm*2.6*28 IHS/SD/SDR CR8340
 ;W ?57,$P($G(ABM("X0")),U,11)  ;oral cavity
 ;W ?62 W $S($P(ABM("X0"),U,5)="":"",$D(^ADEOPS($P(ABM("X0"),U,5),88)):$P(^(88),U),1:"")
 ;W ?66,$J($P(ABM("X0"),U,6),4)
 ;end old start new abm*2.6*30 IHS/SD/SDR CR8870
 W " ",$E($P(^(0),U,2),1,26)  ;abm*2.6*28 IHS/SD/SDR CR8340
 W ?53,$P($G(ABM("X0")),U,11)  ;oral cavity
 ;W ?60 W $S($P(ABM("X0"),U,5)="":"",$D(^ADEOPS($P(ABM("X0"),U,5),88)):$P(^(88),U),1:"")  ;operative site  ;abm*2.6*37 IHS/SD/SDR ADO76301
 ;start new abm*2.6*37 IHS/SD/SDR ADO76301
 W ?60
 I (($P(ABM("X0"),U,5)'="")) I ($D(^ADEOPS($P(ABM("X0"),U,5),88))) D
 .I (($D(^ABMDREC(ABMP("INS"))))&($P($G(^ABMDREC(ABMP("INS"),0)),U,3)="Y")) D
 ..I (+$P(^ADEOPS($P(ABM("X0"),U,5),88),U)'=0)&($L($P(^ADEOPS($P(ABM("X0"),U,5),88),U))=1) W "0"
 .W $P(^ADEOPS($P(ABM("X0"),U,5),88),U)  ;operative site
 ;end new abm*2.6*37 IHS/SD/SDR ADO76301
 W ?63,$J($P(ABM("X0"),U,6),4)  ;surface
 ;end new abm*2.6*30 IHS/SD/SDR CR8870
 S ABM("ITMTOTL")=$P(ABM("X0"),U,8)*$P(ABM("X0"),U,9)
 S:'+ABM("ITMTOTL") ABM("ITMTOTL")=$P(ABM("X0"),U,8)
 ;W ?73,$J($FN(ABM("ITMTOTL"),",",2),6)  ;abm*2.6*30 IHS/SD/SDR CR8870
 W ?70,$J($FN(ABM("ITMTOTL"),",",2),10)  ;charge  ;abm*2.6*30 IHS/SD/SDR CR8870
 S ABM("TOTL")=ABM("TOTL")+ABM("ITMTOTL")
 Q
 ;
XIT K ABM
 Q
 ;
V1 S ABMZ("TITL")="DENTAL VIEW OPTION" D SUM^ABMDE1
 D ^ABMDERR
 Q
A ;ADD LINE ITEM
 K DA S DA(1)=ABMP("CDFN")
 I $E(ABM("ACTION"))="A" D
 .S DIC="^AUTTADA(",DIC(0)="AEMQ"
 .D ^DIC Q:+Y<0
 .S X=$P(Y,U)
 .S DIC("P")=$P(^DD(9002274.3,33,0),U,2)
 .S DIC="^ABMDCLM(DUZ(2),DA(1),33,"
 .;K DD,DO D FILE^DICN Q:+Y<0  S DA=+Y  ;abm*2.6*8 5010
 .K DD,DO D FILE^DICN Q:+Y<0  S (DA,ABMXANS)=+Y  ;abm*2.6*8 5010
E ;EDIT LINE ITEM
 I $E(ABM("ACTION"))="D" D  Q
 .K DIR S DIR(0)="LO^1:"_ABMZ("NUM")_":0"
 .S DIR("?")="Enter the Sequence Number of "_ABMZ("ITEM")_" to Delete"
 .S DIR("A")="Sequence Number to DELETE"
 .D ^DIR K DIR
 .W !
 .S ABMXANS=Y
 .;Q:ABMXANS=""  ;abm*2.6*10 HEAT69379
 .Q:ABMXANS=""!$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)  ;abm*2.6*10 HEAT69379
 .F ABM("I")=1:1 S ABM=$P(ABMXANS,",",ABM("I")) Q:ABM=""  D
 ..I $G(ABMX("ANS"))'="" S ABMX("ANS")=ABMX("ANS")_","_$P(ABMZ(ABM),U)
 ..E  S ABMX("ANS")=$P(ABMZ(ABM),U)
 .K DIR S DIR(0)="YO",DIR("A")="Do you wish "_ABMX("ANS")_" DELETED"
 .D ^DIR K DIR
 .Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .I Y=1 D
 ..F ABM("I")=1:1 S ABM=$P(ABMXANS,",",ABM("I")) Q:ABM=""  D
 ...S DA(1)=ABMP("CDFN")
 ...S DA=$P(ABMZ(ABM),U,2)
 ...S DIK="^ABMDCLM(DUZ(2),"_DA(1)_",33,"
 ...D ^DIK
 ;
 I $E(ABM("ACTION"))="E" D
 .;I ABMZ("NUM")=1 S (DA,Y)=$P(ABMZ(1),U,2) Q  ;abm*2.6*8
 .I ABMZ("NUM")=1 S (DA,Y,ABMXANS)=$P(ABMZ(1),U,2) Q  ;abm*2.6*8
 .K DIR S DIR(0)="NO^1:"_ABMZ("NUM")_":0"
 .S DIR("?")="Enter the Sequence Number of "_ABMZ("ITEM")_" to Edit",DIR("A")="Sequence Number to EDIT"
 .D ^DIR K DIR
 .G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(+Y'>0)
 .;W !!!,"[",+Y,"]  ",$P(ABMZ(+Y),U) S DA=$P(ABMZ(+Y),U,2)  ;abm*2.6*8 5010
 .W !!!,"[",+Y,"]  ",$P(ABMZ(+Y),U) S (DA,ABMXANS)=$P(ABMZ(+Y),U,2)  ;abm*2.6*8 5010
E2 ;
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(+Y'>0)
 S ABMZ("ADACODE")=$P($G(^ABMDCLM(DUZ(2),DA(1),33,DA,0)),U)
 S ABMZ("DCD")=$P(^AUTTADA(ABMZ("ADACODE"),0),U)
 ;S ABMZ("CHRG")=+$P($G(^ABMDFEE(ABMP("FEE"),21,1_ABMZ("DCD"),0)),"^",2)  ;abm*2.6*2 3PMS10003A
 S ABMZ("CHRG")=+$P($$ONE^ABMFEAPI(ABMP("FEE"),21,1_ABMZ("DCD"),ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 ;start new abm*2.6*28 IHS/SD/SDR CR8340
 ;edit modifiers
 I $P($G(^ABMDPARM(DUZ(2),1,2)),"^",5) D
 .S ABMZ("MOD")=.13_U_3_U_.14_U_.15
 .S ABMZ("SUB")=33
 .S ABMX("Y")=$S(+$G(ABMZ("NUM"))'=0:ABMZ("NUM"),1:1)
 .S ABMZ("DR")=""
 .D MOD3
 ;end new abm*2.6*28 IHS/SD/SDR CR8340
 S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",33,"
 I $P(^ABMDEXP(ABMP("EXP"),0),"^",1)["UB" D  Q:$D(Y)
 .;S DR="W !;.02" D ^DIE  ;abm*2.6*21 IHS/SD/SDR HEAT124092
 .S DR="W !;.02//512" D ^DIE  ;abm*2.6*21 IHS/SD/SDR HEAT124092
 S DR="W !;.07//"_ABMP("VISTDT") D ^DIE Q:$D(Y)
 S ABMZ("OPSITE")=1 S:$P(^AUTTADA(ABMZ("ADACODE"),0),"^",9)="n" ABMZ("OPSITE")=0
 I ABMZ("OPSITE") D  Q:$D(Y)
 .S DR="W !;.05;W !;.06;W !;.11"
 .D ^DIE
 ;D DX^ABMDEMLC S DR=".04///"_Y(0) D ^DIE Q:$D(Y)  ;abm*2.6*10 ICD10 002I
 D DX^ABMDEMLC I +$G(Y(0)) S DR=".04///"_Y(0) D ^DIE Q:$D(Y)  ;abm*2.6*10 ICD10 002I
 S DR=".09//1" D ^DIE Q:$D(Y)
 S DR=".08//"_ABMZ("CHRG") D ^DIE Q:$D(Y)
 S DR=".17///M" D ^DIE
 D PROV  ;abm*2.6*8 5010
 Q
 ;start new abm*2.6*8 5010
PROV ;EP
 I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,"P",0))>0 D
 .W !
 .S ABMIEN=0
 .F  S ABMIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,"P",ABMIEN)) Q:+ABMIEN=0  D
 ..W !?5,$P($G(^VA(200,$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,"P",ABMIEN,0)),U),0)),U)
 ..W ?40,$S($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,"P",ABMIEN,0)),U,2)="R":"RENDERING",$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,"P",ABMIEN,0)),U,2)="D":"ORDERING",1:"")
 .W !
 K DIC,DR,DIE,DA
 S DA(2)=ABMP("CDFN")
 S DA(1)=ABMXANS
 S DIC="^ABMDCLM(DUZ(2),"_DA(2)_","_ABMZ("SUB")_","_DA(1)_",""P"","
 S DIC(0)="AELMQ"
 S ABMFLNM="9002274.30"_$G(ABMZ("SUB"))
 S DIC("P")=$P($G(^DD(ABMFLNM,.18,0)),U,2)
 Q:DIC("P")=""
 S DIC("DR")=".01;.02//RENDERING"
 I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA(1),"P","C","R",0))>0 S DIC("DR")=".01;.02//ORDERING"
 D ^DIC
 K DIC,DR,DIE,DA
 I +Y>0,(+$P(Y,U,3)=0) D
 .K DIE,DA,DR
 .S DA(2)=ABMP("CDFN")
 .S DA(1)=ABMXANS
 .S DIE="^ABMDCLM(DUZ(2),"_DA(2)_","_ABMZ("SUB")_","_DA(1)_",""P"","
 .S DA=+Y
 .S DR=".01//;.02"
 .D ^DIE
 Q
 ;end new abm*2.6*8
 ;start new abm*2.6*28 IHS/SD/SDR CR8340
MOD3 ;EP
 S DIE="^ABMDCLM(DUZ(2),"_ABMP("CDFN")_",33,"
 S ABMX("M")=$S($P(ABMZ("MOD"),U,4):3,1:1)
 F ABMX("I")=1:1:ABMX("M") D
 .S DR=$S(ABMX("I")=1:+ABMZ("MOD"),ABMX("I")=2:$P(ABMZ("MOD"),U,3),1:$P(ABMZ("MOD"),U,4))
 .S ABMX("M",ABMX("I"))=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),33,ABMXANS,0)),U,$E(DR,2,3))
 F ABMX("I")=1:1:ABMX("M") D  Q:$D(DUOUT)!(ABMX("I")=ABMX("M"))  I X="",$G(ABMX("M",ABMX("I")+1))="" Q
 .S ABMX("S")=$S(ABMX("I")=1:"1st",ABMX("I")=2:"2nd",1:"3rd")
 .K DIR,X,Y
 .S DIR(0)="PO"_$S($$VERSION^XPDUTL("BCSV")>0:"^DIC(81.3,",1:"^AUTTCMOD(")_":QEM"
 .S DIR("A")="Select "_$S(ABMX("I")=1:"1st",ABMX("I")=2:"2nd",1:"3rd")_" MODIFIER"
 .S:$G(ABMX("M",ABMX("I")))'="" DIR("B")=$G(ABMX("M",ABMX("I")))
 .D ^DIR
 .S ABMX("ANS","X")=X
 .S ABMX("ANS","Y")=$P(Y,U,2)
 .I ABMX("ANS","X")="@" D
 ..K DIR,X,Y
 ..S DIR(0)="Y"
 ..S DIR(0)="YO",DIR("A")="Do you wish "_ABMX("M",ABMX("I"))_" DELETED"
 ..D ^DIR K DIR
 ..I Y=0 S ABMX("ANS","Y")=ABMX("M",ABMX("I"))
 ..I Y=1 S ABMX("ANS","Y")="@"
 .I $G(ABMX("ANS","Y"))="" Q
 .I $D(ABMX("MODS",$G(ABMX("ANS","Y"))))&($G(ABMX("ANS","Y"))'="@") W *7,!!,"*** Modifier has already been entered! ***" S ABMX("I")=ABMX("I")-1 Q
 .I $G(ABMX("ANS","Y"))'="" S ABMX("MODS",$G(ABMX("ANS","Y")))=""
 .I ABMX("ANS","X")="" Q
 .S DR=$S(ABMX("I")=1:+ABMZ("MOD"),ABMX("I")=2:$P(ABMZ("MOD"),U,3),1:$P(ABMZ("MOD"),U,4))_"////"_$P(ABMX("ANS","Y"),U)
 .K DIR,X,Y,ABMX("ANS")
 .W ! D ^DIE S:$D(Y) DUOUT="" Q:X=""
 .I +X,+$P($G(^ABMDMOD(+X,0)),U,4),'$D(ABMZ("RCHARGE")) S ABMX("MC")=$P(^(0),U,4)*ABMZ("CHRG")
 .I +X=52 K DIR S DIR(0)="N^0:"_ABMZ("CHRG")_":2",DIR("A")="Reduced CHARGE",DIR("B")=ABMZ("CHRG") D ^DIR K DIR S:Y=0!(+Y) ABMZ("CHRG")=+Y Q
 Q:ABMX("M")=1
 ;below code moves modifiers up if first or second is deleted so the first slots are filled, last ones are blank
 F ABMXI=1:1:3 D
 .F ABMX("I")=ABMX("M"):-1:1 D
 ..S DR=$S(ABMX("I")=1:+ABMZ("MOD"),ABMX("I")=2:$P(ABMZ("MOD"),U,3),1:$P(ABMZ("MOD"),U,4))
 ..S ABMX("M",ABMX("I"))=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),33,ABMXANS,0)),U,$E(DR,2,3))_U_DR
 ..Q:ABMX("I")=3
 ..I $P(ABMX("M",ABMX("I")),U)="",$P(ABMX("M",ABMX("I")+1),U)]"" D
 ...S DR=DR_"////"_$P(ABMX("M",ABMX("I")+1),U) D ^DIE
 ...S DR=$P(ABMX("M",ABMX("I")+1),U,2)_"///@" D ^DIE
 ...Q:ABMX("I")=2  Q:$P(ABMX("M",ABMX("I")+2),U)=""
 ...S DR=$P(ABMX("M",ABMX("I")+1),U,2)_"////"_$P(ABMX("M",ABMX("I")+2),U) D ^DIE
 ...S DR=$P(ABMX("M",ABMX("I")+2),U,2)_"///@" D ^DIE
 Q
 ;end new abm*2.6*28 IHS/SD/SDR CR8340
