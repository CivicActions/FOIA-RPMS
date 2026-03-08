ABMDE8K ; IHS/SD/SDR - Page 8 - AMBULANCE INFO ; 
 ;;2.6;IHS 3P BILLING SYSTEM;**10,21,30,32**;NOV 12, 2009;Build 621
 ;
 ;IHS/SD/SDR 2.5*8 task 6 New routine for page 8K-ambulance
 ;IHS/SD/SDR 2.5*10 IM9843 Added new prompt SERVICE TO DATE/TIME
 ;IHS/SD/SDR 2.5*11 NPI
 ;
 ;IHS/SD/SDR 2.6 CSV
 ;IHS/SD/AML 2.6*21 HEAT155818 Made it so the modifier can be edited.
 ;IHS/SD/SDR 2.6*30 CR8870 Updated display so it won't wrap if units are maxed out, including 3 decimal places
 ;IHS/SD/SDR 2.6*32 CR8942 Added default revenue code
 ;
DISP K ABMZ S ABMZ("TITL")="AMBULANCE SERVICES",ABMZ("PG")="8K"
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
 ;
AMB ; Amb. Services
 S ABMZ("CAT")=13
 S ABMZ("SUB")=47
 D MODE^ABMDE8X
 S:((^ABMDEXP(ABMMODE(8),0)["HCFA")!(^ABMDEXP(ABMMODE(8),0)["CMS")) ABMZ("DIAG")=";.06"
 S ABMZ("DR")=";W !;.07//"_$$SDT^ABMDUTL(ABMP("VDT"))_";W !;.12//"_$$SDT^ABMDUTL(ABMP("VDT"))_";.03;.11"
 S ABMZ("CHRG")=";.04"
 S ABMZ("ITEM")="Amb. Services (HCPCS Code)"
 S ABMZ("DIC")="^ICPT(",ABMZ("X")="X",ABMZ("MAX")=10,ABMZ("TOTL")=0
 ;I ^ABMDEXP(ABMMODE(8),0)["UB" S ABMZ("DR")=";W !;.02"_ABMZ("DR")  ;abm*2.6*32 IHS/SD/SDR CR8942
 I ^ABMDEXP(ABMMODE(8),0)["UB" S ABMZ("REVN")=";W !;.02//540"  ;abm*2.6*32 IHS/SD/SDR CR8942
 D K^ABMDE8X
 D HD G LOOP
HD ;
 ;start old abm*2.6*30 IHS/SD/SDR CR8870
 ;W !?5,"REVN",?60,"UNIT",?71,"TOTAL"
 ;W !?5,"CODE",?10,"        HCPCS - AMBULANCE SERVICES",?59,"CHARGE",?66,"QTY",?71,"CHARGE"
 ;W !?5,"====",?10,"===============================================",?59,"======",?66,"===",?70,"========="
 ;end old start new abm*2.6*30 IHS/SD/SDR CR8870
 W !?5,"REVN",?53,"UNIT",?70,"TOTAL"
 W !?5,"CODE",?10,"     HCPCS - AMBULANCE SERVICES",?52,"CHARGE",?62,"QTY",?70,"CHARGE"
 W !?5,"====",?10,"========================================",?51,"========",?60,"=======",?68,"==========="
 ;end new abm*2.6*30 IHS/SD/SDR CR8870
 Q
LOOP S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1),ABM)=0 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),47,ABM)) Q:'ABM  S ABM("X")=ABM,ABMZ("NUM")=ABM("I") D PC1
 ;S ABMZ("MOD")=.05_U_5_.08_U_.09  ;abm*2.6*21 IHS/SD/AML HEAT155818
 S ABMZ("MOD")=.05_U_5_U_.08_U_.09  ;abm*2.6*21 IHS/SD/AML HEAT155818
 ;I ABMZ("NUM")>0 W !?69,"==========",!?69,$J("$"_($FN(ABMZ("TOTL"),",",2)),10)  ;abm*2.6*30 IHS/SD/SDR CR8870
 I ABMZ("NUM")>0 W !?66,"==============",!?67,$J("$"_($FN(ABMZ("TOTL"),",",2)),13)  ;abm*2.6*30 IHS/SD/SDR CR8870
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 G XIT
 ;
PC1 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),47,ABM("X"),0),ABM("X")=$P(^(0),U)
 S ABMZ("UNIT")=$P(ABM("X0"),U,3)
 S:'+ABMZ("UNIT") ABMZ("UNIT")=1
 S ABMZ(ABM("I"))=$P($$CPT^ABMCVAPI($P(ABM("X0"),U),ABMP("VDT")),U,2)_U_ABM_U_$P(ABM("X0"),U,2)  ;CSV-c
EOP I $Y>(IOSL-5) D PAUSE^ABMDE1,HD
 W !,"[",ABM("I"),"]"
 I $P(ABM("X0"),"^",7) D
 .W ?5,"CHARGE DATE: "
 .W $$CDT^ABMDUTL($P(ABM("X0"),"^",7))
 .I $P(ABM("X0"),U,12)'="",($P(ABM("X0"),U,12)'=$P(ABM("X0"),U,7)) W "-",$$CDT^ABMDUTL($P(ABM("X0"),U,12))
 .I $P(ABM("X0"),U,11) D
 ..W " ("_$P($G(^VA(200,$P(ABM("X0"),U,11),0)),U)_")"
 .W !
 W ?6,$P(ABM("X0"),"^",2)
 W ?10,$P(ABMZ(ABM("I")),U)
 S ABMZ("MOD")=""
 F ABM("M")=5,8,9 S:$P(ABM("X0"),U,ABM("M"))]"" ABMZ("MOD")=ABMZ("MOD")_"-"_$P(ABM("X0"),U,ABM("M"))
 W ?10 W:ABMZ("MOD")]"" ABMZ("MOD")_" "
 ;start old abm*2.6*30 IHS/SD/SDR CR8870
 ;K ABMU S ABMU(1)="?59"_U_$J($P(ABM("X0"),U,4),6,2)
 ;S ABMU(2)="?66"_U_$J(ABMZ("UNIT"),2)
 ;S ABMU(3)="?70"_U_$J($FN((ABMZ("UNIT")*$P(ABM("X0"),U,4)),",",2),9)
 ;end old start new abm*2.6*30 IHS/SD/SDR CR8870
 K ABMU S ABMU(1)="?52"_U_$J($FN($P(ABM("X0"),U,4),",",2),"8R")  ;unit charge
 S ABMU(2)="?61"_U_$$FMT^ABMERUTL(ABMZ("UNIT"),"6R")  ;quantity/units
 S ABMU(3)="?67"_U_$J($FN((ABMZ("UNIT")*$P(ABM("X0"),U,4)),",",2),13)  ;total charge
 ;end new abm*2.6*30 IHS/SD/SDR CR8870
 S ABMZ("TOTL")=(ABMZ("UNIT")*$P(ABM("X0"),U,4))+ABMZ("TOTL")
 I $P(^ABMDPARM(DUZ(2),1,0),U,14)'="Y" S ABMU("TXT")=$P($$CPT^ABMCVAPI($P(ABM("X0"),U),ABMP("VDT")),U,3)  ;CSV-c
 ;start CSV-c
 E  D
 .S ABMU("TXT")=""
 .K ABMZCPTD  ;abm*2.6*10 HEAT56410
 .;D IHSCPTD^ABMCVAPI($P(ABM("X0"),U),ABMZCPTD,"",ABMP("VDT"))  ;abm*2.6*10 HEAT56410
 .D IHSCPTD^ABMCVAPI($P(ABM("X0"),U),"ABMZCPTD","",ABMP("VDT"))  ;abm*2.6*10 HEAT56410
 .S ABM("CP")=0
 .;F  S ABM("CP")=$O(ABMZCPTD(ABM("CP"))) Q:'$D(ABMZCPTD(ABM("CP")))  D  ;abm*2.6*10 HEAT56410
 .F  S ABM("CP")=$O(ABMZCPTD(ABM("CP"))) Q:(+ABM("CP")=0)  D  ;abm*2.6*10 HEAT56410
 ..S ABMU("TXT")=ABMU("TXT")_ABMZCPTD(ABM("CP"))_" "
 ;end CSV-c
 ;I ABMU("TXT")]"" S ABMU("RM")=59,ABMU("LM")=16 D ^ABMDWRAP I 1  ;abm*2.6*30 IHS/SD/SDR CR8870
 I ABMU("TXT")]"" S ABMU("RM")=44,ABMU("LM")=16 D ^ABMDWRAP I 1  ;abm*2.6*30 IHS/SD/SDR CR8870
 E  W ?17,$P(^ICPT($P(ABM("X0"),U),0),U,2)
 Q
 ;
XIT K ABM,ABMMODE
 Q
