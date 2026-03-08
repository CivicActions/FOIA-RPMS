ABMDE8A ; IHS/SD/SDR - Page 8 - MEDICAL CARE ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**18,30,32,37**;NOV 12, 2009;Build 739
 ;
 ;IHS/ASDS/DMJ 2.4*7 9/7/01 NOIS HQW-0701-100066 Modifications done related to Medicare Part B
 ;
 ;IHS/SD/SDR 2.5*2 5/9/02 NOIS HQW-0302-100190 Modified to include 2nd and 3rd modifiers on display
 ;IHS/SD/SDR 2.5*8 IM10618/IM11164 Prompt/display provider
 ;IHS/SD/SDR 2.5*9 IM16660 4-digit revenue codes
 ;IHS/SD/SDR 2.5*9 task 1 Use provider multiple at line item
 ;IHS/SD/SDR 2.5*10 IM19843 Added new prompt SERVICE TO DATE/TIME
 ;IHS/SD/SDR 2.5*11 NPI
 ;
 ;IHS/SD/SDR 2.6 CSV
 ;IHS/SD/SDR 2.6*18 HEAT242924 Added code so coor. dx would be prompted for on the 5010 837D.
 ;IHS/SD/SDR 2.6*30 CR8870 Updated display so it won't wrap if units are maxed out, including 3 decimal places
 ;IHS/SD/SDR 2.6*32 CR8942 Fixed default rev code to use either the CPT DEFAULT REVENUE CODE or the default of 510 for page 8A
 ;IHS/SD/SDR 2.6*37 ADO89299 Added DEA# to display
 ;
DISP ;
 K ABMZ
 S ABMZ("TITL")="MEDICAL SERVICES"
 S ABMZ("PG")="8A"
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
 ;
PC ; Medical Care
 S:'$D(ABMP("FEE")) ABMP("FEE")=1
 S ABMZ("CAT")=19
 S ABMZ("SUB")=27
 S ABMZ("DR")=";W !;.07//"_$$SDT^ABMDUTL(ABMP("VDT"))_";.12//"_$$SDT^ABMDUTL(ABMP("VDT"))_";.03//1"
 D
 .S ABMDPRV=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C","A",0))
 .S ABMDPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,+ABMDPRV,0)),U)
 S ABMZ("CHRG")=";W !;.04"
 S ABMZ("ITEM")="Medical Service (CPT Code)"
 S ABMZ("DIC")="^ICPT("
 S ABMZ("X")="X"
 S ABMZ("MAX")=30
 S ABMZ("TOTL")=0
 D MODE^ABMDE8X
 I ^ABMDEXP(ABMMODE(1),0)["UB" D
 .;S ABMZ("REVN")=";W !;.02//960"  ;abm*2.6*32 IHS/SD/SDR CR8942
 .S ABMZ("REVN")=";W !;.02//510"  ;abm*2.6*32 IHS/SD/SDR CR8942
 ;I ^ABMDEXP(ABMMODE(1),0)["HCFA"!(^ABMDEXP(ABMMODE(1),0)["CMS") S ABMZ("DIAG")=";.06"  ;abm*2.6*18 IHS/SD/SDR HEAT242924
 I ^ABMDEXP(ABMMODE(1),0)["HCFA"!(^ABMDEXP(ABMMODE(1),0)["CMS")!(ABMMODE(1)=33) S ABMZ("DIAG")=";.06"  ;abm*2.6*18 IHS/SD/SDR HEAT242924
 D A^ABMDE8X
 D HD
 G LOOP
 ;
HD ;
 ;start old abm*2.6*30 IHS/SD/SDR CR8870
 ;W !?5,"REVN",?60,"UNIT",?71,"TOTAL"
 ;W !?5,"CODE",?10,"        CPT - MEDICAL SERVICES",?59,"CHARGE",?66,"QTY",?71,"CHARGE"
 ;W !?5,"====",?10,"===============================================",?59,"======",?66,"===",?70,"========="
 ;end old start new abm*2.6*30 IHS/SD/SDR CR8870
 W !?5,"REVN",?52,"UNIT",?70,"TOTAL"
 W !?5,"CODE",?10,"        CPT - MEDICAL SERVICES",?51,"CHARGE",?62,"QTY",?70,"CHARGE"
 W !?5,"====",?10,"=====================================",?50,"=========",?60,"======",?67,"============="
 ;end new abm*2.6*30 IHS/SD/SDR CR8870
 Q
 ;
LOOP ;
 S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1),ABM)=0
 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),27,ABM)) Q:'ABM  S ABM("X")=ABM,ABMZ("NUM")=ABM("I") D PC1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 S ABMZ("MOD")=.05_U_1_U_.08_U_.09
 G XIT:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 ;I ABMZ("NUM")>0 W !?69,"==========",!?69,$J("$"_($FN(ABMZ("TOTL"),",",2)),10)  ;abm*2.6*30 IHS/SD/SDR CR8870
 I ABMZ("NUM")>0 W !?66,"==============",!?65,$J("$"_($FN(ABMZ("TOTL"),",",2)),15)  ;abm*2.6*30 IHS/SD/SDR CR8870
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 G XIT
 ;
PC1 ;
 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),27,ABM("X"),0),ABM("X")=$P(^(0),U)
 S ABMZ("MOD")=""
 F ABM("M")=5,8,9 S:$P(ABM("X0"),U,ABM("M"))]"" ABMZ("MOD")=ABMZ("MOD")_"-"_$P(ABM("X0"),U,ABM("M")) I $P(ABM("X0"),U,ABM("M"))=90 S ABME(172)=""
 S ABMZ(ABM("I"))=$P($$CPT^ABMCVAPI(+$P(ABM("X0"),U),ABMP("VDT")),U,2)_U_ABM_U_$P(ABM("X0"),U,2)  ;CSV-c
 S ABMZ("UNIT")=$P(ABM("X0"),U,3)
 S:'+ABMZ("UNIT") ABMZ("UNIT")=1
 ;
EOP ;
 I $Y>(IOSL-5) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIRUT)  D HD
 W !,"[",ABM("I"),"]"
 I $P(ABM("X0"),"^",7) D
 .W ?5,"CHARGE DATE: "
 .W $$CDT^ABMDUTL($P(ABM("X0"),"^",7))
 .I $P(ABM("X0"),U,12)'="",($P(ABM("X0"),U,7)'=$P(ABM("X0"),U,12)) W "-",$$CDT^ABMDUTL($P(ABM("X0"),U,12))
 .S ABMRPRV=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),27,ABM,"P","C","D",0))  ;ordering
 .S:ABMRPRV="" ABMRPRV=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),27,ABM,"P","C","R",0))  ;rendering
 .I ABMRPRV'="" D  ;provider on line item
 ..W " ("_$P($G(^VA(200,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),27,ABM,"P",ABMRPRV,0),U),0)),U)_"-"_$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),27,ABM,"P",ABMRPRV,0),U,2)_")"
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),27,ABM,2)),U,6)'="" W " DEA# "_$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),27,ABM,2)),U,6)  ;abm*2.6*37 IHS/SD/SDR ADO89299
 .W !
 W ?5,$$GETREV^ABMDUTL($P(ABM("X0"),U,2))
 W ?10,$P(ABMZ(ABM("I")),U) W:ABMZ("MOD")]"" ABMZ("MOD")
 K ABMU
 ;start old abm*2.6*30 IHS/SD/SDR CR8870
 ;S ABMU(1)="?59"_U_$J($P(ABM("X0"),U,4),6,2)
 ;S ABMU(2)="?66"_U_$J(ABMZ("UNIT"),2)
 ;S ABMU(3)="?70"_U_$J($FN((ABMZ("UNIT")*$P(ABM("X0"),U,4)),",",2),9)
 ;end old start new abm*2.6*30 IHS/SD/SDR CR8870
 S ABMU(1)="?50"_U_$J($FN($P(ABM("X0"),U,4),",",2),"9R")  ;unit charge
 S ABMU(2)="?60"_U_$$FMT^ABMERUTL(ABMZ("UNIT"),"6R")  ;units
 S ABMU(3)="?67"_U_$J($FN((ABMZ("UNIT")*$P(ABM("X0"),U,4)),",",2),13)  ;total charge
 ;end new abm*2.6*30 IHS/SD/SDR CR8870
 S ABMZ("TOTL")=(ABMZ("UNIT")*$P(ABM("X0"),U,4))+ABMZ("TOTL")
 I $P(^ABMDPARM(DUZ(2),1,0),U,14)'="Y" S ABMU("TXT")=$P($$CPT^ABMCVAPI($P(ABM("X0"),U),0),U,3)  ;CSV-c
 E  S ABMU("TXT")="",ABM("CP")=0 F  S ABM("CP")=$O(^ICPT($P(ABM("X0"),U),"D",ABM("CP"))) Q:'ABM("CP")  Q:'$D(^(ABM("CP"),0))  S ABMU("TXT")=ABMU("TXT")_^(0)_" "
 ;S ABMU("RM")=58,ABMU("LM")=16+$L(ABMZ("MOD")) S:ABMZ("MOD") ABMU("TAB")=3+$L(ABMZ("MOD")) D ^ABMDWRAP  ;abm*2.6*30 IHS/SD/SDR CR8870
 S ABMU("RM")=50,ABMU("LM")=16+$L(ABMZ("MOD")) S:ABMZ("MOD") ABMU("TAB")=3+$L(ABMZ("MOD")) D ^ABMDWRAP  ;abm*2.6*30 IHS/SD/SDR CR8870
 Q
 ;
XIT ;
 K ABM,ABMMODE
 Q
