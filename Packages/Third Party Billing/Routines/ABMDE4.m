ABMDE4 ; IHS/SD/SDR - Edit Page 4 - Providers ;  
 ;;2.6;IHS Third Party Billing;**1,3,9,11,30,39**;NOV 12, 2009;Build 776
 ;
 ;IHS/SD/SDR 2.5*9 task 1 Only allows providers on page 4
 ;IHS/SD/SDR 2.5*10 IM20059 All providers displayed instead of one for each type
 ;IHS/SD/SDR 2.5*11 NPI
 ;
 ;IHS/SD/SDR 2.6*1 HEAT4207 If subpart NPI is populated show it on page4
 ;IHS/SD/SDR 2.6*3 HEAT12442 Make error 92 display for all 837s
 ;IHS/SD/SDR 2.6*30 CR8939 Added error 256 if attending and rendering are missing from claim
 ;IHS/SD/SDR 2.6*39 ADO99168 Added Locum Tenens prompt and Edit option to page 4
 ;
 Q:$D(ABMP("WORKSHEET"))
 K ABM,ABME,ABMZ
OPT K ABME D DISP G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ;W !! S ABMP("OPT")="ADVNJBQ" S:ABM("NUM")=0 ABMP("ED")=1 D SEL^ABMDEOPT K ABMP("ED") I "AVD"'[$E(Y) G XIT  ;abm*2.6*39 IHS/SD/SDR ADO99168
 W !! S ABMP("OPT")="AEDVNJBQ" S:ABM("NUM")=0 ABMP("ED")=1 D SEL^ABMDEOPT K ABMP("ED") I "AEVD"'[$E(Y) G XIT  ;abm*2.6*39 IHS/SD/SDR ADO99168
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ;S ABM("DO")=$S($E(Y)="A":"A1",$E(Y)="V":"^ABMDE4A",1:"D1") D @ABM("DO")  ;abm*2.6*39 IHS/SD/SDR ADO99168
 S ABM("DO")=$S($E(Y)="A":"A1",$E(Y)="E":"E",$E(Y)="V":"^ABMDE4A",1:"D1") D @ABM("DO")  ;abm*2.6*39 IHS/SD/SDR ADO99168
 G OPT
 ;
DISP S ABMZ("TITL")="PROVIDER DATA",ABMZ("PG")=4
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)  I 1 G PROV
 D SUM^ABMDE1
 ;
PROV ; Provider Info
 K ABM("A"),ABM("O")
 K ABM("R")  ;abm*2.6*30 IHS/SD/SDR CR8939
 S ABM("SUB")=41
 S ABM("DR")=";.03"
 S ABM("ITEM")="Provider"
 S ABM("DIC")="^VA(200,"
 S ABM("PRIM")=""
 S ABM("MD")=0
 S ABMNPIUS=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 I ABMNPIUS=""!(ABMNPIUS="L") D
 .W !?17,"PROVIDER",?39,"NUMBER",?59,"DISCIPLINE"
 .W !?8,"==========================",?36,"============",?50,"============================="
 I ABMNPIUS="N" D
 .;start old abm*2.6*39 IHS/SD/SDR ADO99168
 .;W !?17,"PROVIDER",?40,"NPI",?59,"DISCIPLINE"
 .;W !?8,"==========================",?36,"============",?50,"============================="
 .;end old start new abm*2.6*39 IHS/SD/SDR ADO99168
 .W !?20,"PROVIDER",?45,"NPI",?64,"DISCIPLINE"
 .W !?8,"=================================",?43,"==========",?55,"========================"
 ;end new abm*2.6*39 IHS/SD/SDR ADO99168
 I ABMNPIUS="B" D
 .W !?15,"PROVIDER",?38,"NPI",?48,"NUMBER",?65,"DISCIPLINE"
 .W !?8,"======================",?33,"==========",?44,"===============",?60,"===================="
 S ABM("NUM")=0,ABM=""
 S ABM("I")=1
 F  S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C",ABM)) Q:ABM=""  D
 .S ABM("X")=""
 .F  S ABM("X")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C",ABM,ABM("X"))) Q:ABM("X")=""  D
 ..S ABM("NUM")=ABM("I") D PRV
 .S ABM("I")=ABM("I")+1
 I $P(^ABMDEXP(ABMP("EXP"),0),U)["HCFA-1500",ABMP("EXP")'=15,$P(^ABMDPARM(DUZ(2),1,0),U,17)=2 Q
 I (('$D(ABM("A")))&('$D(ABM("R")))) S ABME(256)=""  ;no attending and no rendering  ;abm*2.6*30 IHS/SD/SDR CR8939
 I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"B",0))=0 S ABME(244)=""  ;abm*2.6*11 HEAT81017
 I '$D(ABM("A")) D
 .;Q:ABMP("EXP")=22  ;abm*2.6*3 HEAT12442
 .;Q:ABMP("EXP")=23  ;abm*2.6*3 HEAT12442
 .Q:ABMP("EXP")=22!(ABMP("EXP")=32)  ;abm*2.6*9 HEAT57734
 .S ABME(92)=""
 I '$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C","O")),$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,0)),ABMP("PAGE")'[8 S ABME(2)=""
ER I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 Q
PRV ;provider display
 S ABMTYP("A")="(attn)"
 S ABMTYP("O")="(oper)"
 S ABMTYP("T")="(other)"
 S ABMTYP("F")="(refer)"
 S ABMTYP("R")="(rend)"
 S ABMTYP("P")="(pursvc)"
 S ABMTYP("S")="(suprvs)"
 D SEL^ABMDE4X,AFFL^ABMDE4X
 I ABMNPIUS=""!(ABMNPIUS="L") D
 .W !,ABMTYP($P(ABM("X0"),U,2))
 .I $D(ABM($P(ABM("X0"),U,2))) W ?8,$P(ABM($P(ABM("X0"),U,2)),U),?36,ABM("PNUM"),?50,ABM("DISC")
 ;
 I ABMNPIUS="N" D
 .W !,ABMTYP($P(ABM("X0"),U,2))
 .I $D(ABM($P(ABM("X0"),U,2))) D
 ..;W ?8,$P(ABM($P(ABM("X0"),U,2)),U)  ;abm*2.6*39 IHS/SD/SDR ADO99168
 ..W ?8,$E($P(ABM($P(ABM("X0"),U,2)),U),1,26)  ;abm*2.6*39 IHS/SD/SDR ADO99168
 ..I $P(ABM("X0"),U,4)="Y" W:(ABMP("EXP")=37) ?34,"(Locum)"  ;abm*2.6*39 IHS/SD/SDR ADO99168
 ..;W ?36,$S($P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U)>0:$P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U),$P($$NPI^XUSNPI("Organization_ID",+ABMP("LDFN")),U)>0:$P($$NPI^XUSNPI("Organization_ID",+ABMP("LDFN")),U)_"*",1:"")  ;abm*2.6*1 HEAT4207
 ..;start new code abm*2.6*1 HEAT4207
 ..S ABMLNPI=$S($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,8)'="":$P(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1),U,8),$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,12)'="":$P(^ABMDPARM(ABMP("LDFN"),1,2),U,12),1:ABMP("LDFN"))
 ..;start old abm*2.6*39 IHS/SD/SDR ADO99168
 ..;W ?36,$S($P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U)>0:$P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U),$P($$NPI^XUSNPI("Organization_ID",+ABMLNPI),U)>0:$P($$NPI^XUSNPI("Organization_ID",+ABMLNPI),U)_"*",1:"")
 ..;end old start new abm*2.6*39 IHS/SD/SDR ADO99168
 ..W ?43,$S($P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U)>0:$P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U),$P($$NPI^XUSNPI("Organization_ID",+ABMLNPI),U)>0:$P($$NPI^XUSNPI("Organization_ID",+ABMLNPI),U)_"*",1:"")
 ..;end new abm*2.6*39 IHS/SD/SDR ADO99168
 ..;end new code HEAT4207
 ..;W ?50,ABM("DISC")  ;abm*2.6*39 IHS/SD/SDR ADO99169
 ..W ?55,$E(ABM("DISC"),1,25)  ;abm*2.6*39 IHS/SD/SDR ADO99169
 ;
 I ABMNPIUS="B" D
 .W !,ABMTYP($P(ABM("X0"),U,2))
 .I $D(ABM($P(ABM("X0"),U,2))) D
 ..S ABMTMP=$S($P(ABM("X0"),U,4)="Y":16,1:20)  ;abm*2.6*39 IHS/SD/SDR ADO99168
 ..W ?8,$E($P(ABM($P(ABM("X0"),U,2)),U),1,ABMTMP)  ;abm*2.6*39 IHS/SD/SDR ADO99168
 ..I $P(ABM("X0"),U,4)="Y" W ?24,"(Locum)"  ;abm*2.6*39 IHS/SD/SDR ADO99168
 ..;W ?30,$S($P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U)>0:$P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U),$P($$NPI^XUSNPI("Organization_ID",+ABMP("LDFN")),U)>0:$P($$NPI^XUSNPI("Organization_ID",+ABMP("LDFN")),U)_"*",1:"")  ;abm*2.6*1 HEAT4207
 ..;start new code abm*2.6*1 HEAT4207
 ..S ABMLNPI=$S($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,8)'="":$P(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1),U,8),$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,12)'="":$P(^ABMDPARM(ABMP("LDFN"),1,2),U,12),1:ABMP("LDFN"))
 ..;W ?30,$S($P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U)>0:$P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U),$P($$NPI^XUSNPI("Organization_ID",+ABMLNPI),U)>0:$P($$NPI^XUSNPI("Organization_ID",+ABMLNPI),U)_"*",1:"")  ;abm*2.6*1
 ..;end new code HEAT4207
 ..S ABMNPI=0
 ..S ABMNPI=$P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U)
 ..I +ABMNPI<1 S ABMNPI=$P($$NPI^XUSNPI("Organization_ID",+ABMP("LDFN")),U)_"*"
 ..;W ?30,ABMNPI  ;abm*2.6*39 IHS/SD/SDR ADO99168
 ..W ?32,ABMNPI  ;abm*2.6*39 IHS/SD/SDR ADO99168
 ..;W ?42,ABM("PNUM")  ;abm*2.6*39 IHS/SD/SDR ADO99168
 ..S ABMXTR="" I $L(ABM("PNUM"))>12 S ABMXTR="..."  ;abm*2.6*39 IHS/SD/SDR ADO99168
 ..W ?44,$E(ABM("PNUM"),1,12)_ABMXTR  ;abm*2.6*39 IHS/SD/SDR ADO99168
 ..;W ?55,ABM("DISC")  ;abm*2.6*39 IHS/SD/SDR ADO99168
 ..W ?60,$E(ABM("DISC"),1,20)  ;abm*2.6*39 IHS/SD/SDR ADO99168
 Q
 ;
A1 ; Add Multiple
 W ! K DIC
 S DIC="^VA(200,",DIC(0)="QEAM"
 S DIC("A")="Select "_ABM("ITEM")_": "
 S DIC("S")="I $D(^VA(200,Y,""PS""))"
 D ^DIC K DIC
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(X="")
 I $D(ABM("A")) S ABM("ANS")="O"
 E  S ABM("ANS")="A"
 W ! S ABM("Y")=Y
 S DIR(0)="S^A:Attending;O:Operating;T:Other;F:Referring;R:Rendering;P:Purchased Service;S:Supervising"
 S DIR("A")="Provider Status",DIR("B")=ABM("ANS")
 D ^DIR K DIR Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("ANS")=Y,Y=ABM("Y")
 I $D(ABM("A"))&(ABM("ANS")="A") W !!?5,*7,"***Attending Provider are Already Established!***",!?5,"      (Delete as necessary to facilitate editing)",! H 2 Q
 I $D(ABM("O"))&(ABM("ANS")="O") W !!?5,*7,"***Operating Provider are Already Established!***",!?5,"      (Delete as necessary to facilitate editing)",! H 2 Q
A2 I +Y>0 K DD,DO S X=+Y,DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_","_ABM("SUB")_",",DIC("DR")=".02////"_ABM("ANS"),DIC(0)="LE"
 I  S:ABM("NUM")=0 ^ABMDCLM(DUZ(2),DA(1),ABM("SUB"),0)="^9002274.30"_ABM("SUB")_"P^^" D FILE^DICN
 ;start new abm*2.6*39 IHS/SD/SDR ADO99168
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,+Y,0)),U,2)="A" D
 .Q:(ABMP("EXP")'=37)
 .S DIE=DIC
 .S DA=+Y
 .S DR=".04//N"
 .D ^DIE
 Q
E ;
 S DIC="^ABMDCLM(DUZ(2),ABMP(""CDFN""),41,"
 S DIC(0)="AEMQ"
 ;start new abm*2.6*39 IHS/SD/SDR ADO99168
 S DIC("W")="S ABMPT=$P(^(0),U,2) W ?30,""- ""_$S(ABMPT=""R"":""RENDERING"",ABMPT=""O"":""OPERATING"",ABMPT=""T"":""OTHER"",ABMPT=""F"":""REFERRING"",ABMPT=""A"":""ATTENDING"",ABMPT=""S"":""SUPERVISING"",1:""PURCHASED SERVICE"")"
 S DIC("A")="Select Provider: " D ^DIC
 Q:+Y<0  S DA=+Y
 Q:'$G(DA)
E2 ;
 S DIE=DIC
 K DIR(0)
 S DIR(0)="S^"
 I ('$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C","A"))!($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,DA,0)),U,2)="A")) S DIR(0)=DIR(0)_"A:Attending;"
 I '$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C","O")) S DIR(0)=DIR(0)_"O:Operating;"
 S DIR(0)=DIR(0)_"T:Other;F:Referring;R:Rendering;P:Purchased Service;S:Supervising"
 S DIR("A")="Provider Status"
 S DIR("B")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,DA,0)),U,2)
 D ^DIR K DIR Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("ANS")=Y
 I $G(Y)'="" S DA(1)=ABMP("CDFN"),DIE="^ABMDCLM(DUZ(2),"_DA(1)_",41,",DR=".02////"_ABM("ANS")
 D ^DIE
 ;
 I ABMP("EXP")=37 D  ;export mode is ADA-2024
 .Q:($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,DA,0)),U,2)'="A")
 .S DR=".04//N"
 .D ^DIE
 Q
 ;end new abm*2.6*39 IHS/SD/SDR ADO99168
 ;
D1 ; Delete Multiple
 K DA
 I ABM("NUM")=0 W *7 Q
 S DIC="^ABMDCLM(DUZ(2),ABMP(""CDFN""),41,",DIC(0)="AEMQ"
 ;start new abm*2.6*39 IHS/SD/SDR ADO99168
 S DIC("W")="S ABMPT=$P(^(0),U,2) W ?30,""- ""_$S(ABMPT=""R"":""RENDERING"",ABMPT=""O"":""OPERATING"",ABMPT=""T"":""OTHER"",ABMPT=""F"":""REFERRING"",ABMPT=""A"":""ATTENDING"",ABMPT=""S"":""SUPERVISING"",1:""PURCHASED SERVICE"")"
 ;end new abm*2.6*39 IHS/SD/SDR ADO99168
 I ABM("NUM")=1 S DA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,0))
 I '$G(DA) D
 .S DIC("A")="Select Provider: " D ^DIC
 .Q:+Y<0  S DA=+Y
 Q:'$G(DA)
 S DIR(0)="Y",DIR("A")="SURE",DIR("B")="NO" D ^DIR K DIR Q:Y'=1
 S DIK=DIC,DA(1)=ABMP("CDFN") D ^DIK
 K DIC
 Q
 ;
XIT K ABM,ABME
 Q
