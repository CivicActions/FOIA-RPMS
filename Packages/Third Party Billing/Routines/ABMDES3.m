ABMDES3 ; IHS/SD/SDR - Display Summarized HCFA-1500B charges ; 
 ;;2.6;IHS 3P BILLING SYSTEM;**6,10,19,29,30**;NOV 12, 2009;Build 585
 ;
 ;IHS/SD/SDR 2.5*5 5/18/04 Modified to put POS and TOS on line item
 ;IHS/SD/SDR 2.5*6 7/12/04 IM14097 - Added fix for FL Override for POS
 ;IHS/SD/SDR 2.5*6 7/14/04 IM14187 - Modified to get around bad X-refs if there are any
 ;IHS/SD/SDR 2.5*8 IM15905 <UNDEF>HCFA+27^ABMDES3
 ;IHS/SD/SDR 2.5*10 IM21581 Added active insurer print to summary
 ;
 ;IHS/SD/SDR 2.6*19 HEAT235246 Updated summary so T1015 will be first line to print
 ;IHS/SD/SDR 2.6*29 CR10888 Updated to write message and display anesthesia minutes as units
 ;IHS/SD/SDR 2.6*30 CR8870 Updated display so it won't wrap if units are maxed out, including 3 decimal places
 ;
HCFA ;EP for displaying charge summary for HCFA-1500
 ;
 D HD
 ;I ABMP("EXP")=22 S ABMEXP=14  ;abm*2.6*6 5010
 I ABMP("EXP")=22!(ABMP("EXP")=32) S ABMEXP=14  ;abm*2.6*6 5010
 E  S ABMEXP=ABMP("EXP")
 S ABMS=0 F  S ABMS=$O(ABMS(ABMS)) Q:'ABMS  D  Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 .I $Y>(IOSL-5) S DIR(0)="EO" D ^DIR W $$EN^ABMVDF("IOF") Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)  D HD
 .;start new abm*2.6*19 IHS/SD/SDR HEAT235246
 .I ($$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABMP("INS"),".211","I"),1,"I")="D"!($P($G(^AUTNINS(ABMP("INS"),0)),U)="ARBOR HEALTH PLAN")) D
 ..S ABMIL=0
 ..F  S ABMIL=$O(ABMS(ABMIL)) Q:'ABMIL  D
 ...I $P($G(ABMS(ABMIL)),U,4)'="T1015" Q
 ...S ABMTMP("TMP")=$G(ABMS(1))
 ...S ABMS(1)=$G(ABMS(ABMIL))
 ...S ABMS(ABMIL)=$G(ABMTMP("TMP"))
 .K ABMIL,ABMTMP
 .;end new abm*2.6*19 IHS/SD/SDR HEAT235246
 .S ABMS("I")=1,ABMLN=0 D PROC^ABMDF3E
 .;start old abm*2.6*30 IHS/SD/SDR CR8870
 .;W !,$$HDT^ABMDUTL($P(ABMR(ABMS,0),U))
 .;W ?11,$$HDT^ABMDUTL($P(ABMR(ABMS,0),U,2))
 .;end old start new abm*2.6*30 IHS/SD/SDR CR8870
 .W !,$$HDTO^ABMDUTL($P(ABMR(ABMS,0),U))
 .W ?9,$$HDTO^ABMDUTL($P(ABMR(ABMS,0),U,2))
 .;end new abm*2.6*30 IHS/SD/SDR CR8870
 .;I $D(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",ABMEXP,37,3))!($D(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",ABMEXP,37,4))) D  ;abm*2.6*10 HEAT53137
 .I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",ABMEXP,37,3))!($D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",ABMEXP,37,4))) D  ;abm*2.6*10 HEAT53137
 ..S ABMFL=0,ABMFLE=0
 ..F ABMLN=3,4 D
 ...;F  S ABMFL=$O(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",ABMEXP,37,ABMLN,ABMFL)) Q:ABMFL=""  I ^(ABMFL)'="^" S ABMFLE=1  ;abm*2.6*10 HEAT53137
 ...F  S ABMFL=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",ABMEXP,37,ABMLN,ABMFL)) Q:ABMFL=""  I ^(ABMFL)'="^" S ABMFLE=1  ;abm*2.6*10 HEAT53137
 .I $G(ABMFLE)=1 D
 ..S ABMFLMSG="Form Locator Override edits exist for POS/TOS"
 ..;
 ..S ABMVTYP=""
 ..;I $D(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",ABMEXP,37,3)) D  ;abm*2.6*10 HEAT53137
 ..I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",ABMEXP,37,3)) D  ;abm*2.6*10 HEAT53137
 ...;I $D(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",ABMEXP,37,3,0)) S ABMVTYP=0  ;abm*2.6*10 HEAT53137
 ...I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",ABMEXP,37,3,0)) S ABMVTYP=0  ;abm*2.6*10 HEAT53137
 ...;I $D(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",ABMEXP,37,3,ABMP("VTYP"))) S ABMVTYP=ABMP("VTYP")  ;abm*2.6*10 HEAT53137
 ...I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",ABMEXP,37,3,ABMP("VTYP"))) S ABMVTYP=ABMP("VTYP")  ;abm*2.6*10 HEAT53137
 ...Q:+$G(ABMVTYP)=0
 ...;S $P(ABMR(ABMS,0),U,3)=^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",ABMEXP,37,3,ABMVTYP)  ;abm*2.6*10 HEAT53137
 ...S $P(ABMR(ABMS,0),U,3)=^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",ABMEXP,37,3,ABMVTYP)  ;abm*2.6*10 HEAT53137
 ..;
 ..S ABMVTYP=""
 ..;I $D(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",ABMEXP,37,4)) D  ;abm*2.6*10 HEAT53137
 ..I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",ABMEXP,37,4)) D  ;abm*2.6*10 HEAT53137
 ...;I $D(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",ABMEXP,37,4,0)) S ABMVTYP=0  ;abm*2.6*10 HEAT53137
 ...I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",ABMEXP,37,4,0)) S ABMVTYP=0  ;abm*2.6*10 HEAT53137
 ...;I $D(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",ABMEXP,37,4,ABMP("VTYP"))) S ABMVTYP=ABMP("VTYP")  ;abm*2.6*10 HEAT53137
 ...I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",ABMEXP,37,4,ABMP("VTYP"))) S ABMVTYP=ABMP("VTYP")  ;abm*2.6*10 HEAT53137
 ...Q:+$G(ABMVTYP)=0
 ...;S $P(ABMR(ABMS,0),U,4)=^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",ABMEXP,37,4,ABMVTYP)  ;abm*2.6*10 HEAT53137
 ...S $P(ABMR(ABMS,0),U,4)=^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",ABMEXP,37,4,ABMVTYP)  ;abm*2.6*10 HEAT53137
 .;start old abm*2.6*30 IHS/SD/SDR CR8870
 .;W ?22,$J($P(ABMR(ABMS,0),U,3),2)  ;POS
 .;W ?23,$J($P(ABMR(ABMS,0),U,4),2)  ;TOS
 .;W ?30,$S($P($G(ABMR(ABMS,(-1))),U)'="":$P(ABMR(ABMS,(-1)),U),1:$P(ABMR(ABMS,0),U,5))  ;desc.
 .;W ?49,$J($P(ABMR(ABMS,0),U,6),5)  ;coor. dx.
 .;W ?56,$J($FN($P(ABMR(ABMS,0),U,7),",",2),10)  ;charge
 .;W ?72,$J($P(ABMR(ABMS,0),U,8),3)  ;qty
 .;end old start new abm*2.6*30 IHS/SD/SDR CR8870
 .W ?18,$J($P(ABMR(ABMS,0),U,3),2)  ;POS
 .W ?21,$J($P(ABMR(ABMS,0),U,4),2)  ;TOS
 .W ?25,$E($S($P($G(ABMR(ABMS,(-1))),U)'="":$P(ABMR(ABMS,(-1)),U),1:$P(ABMR(ABMS,0),U,5)),1,18)  ;desc.
 .W ?44,$J($P(ABMR(ABMS,0),U,6),5)  ;coor. dx.
 .W ?57,$J($FN($P(ABMR(ABMS,0),U,7),",",2),13)  ;charge
 .W ?71,$$FMT^ABMERUTL($P(ABMR(ABMS,0),U,8),"8R")  ;qty
 .;end new abm*2.6*30 IHS/SD/SDR CR8870
 .I (+$G(ABMANESF(ABMS))=1) W "*"  ;abm*2.6*29 IHS/SD/SDR CR10888
 ;W !?58,"----------"  ;abm*2.6*30 IHS/SD/SDR CR8870
 W !?57,"-------------"  ;abm*2.6*30 IHS/SD/SDR CR8870
 ;W !,?10,"TOTAL CHARGE",?56,$J($FN(ABMS("TOT"),",",2),10)  ;abm*2.6*30 IHS/SD/SDR CR8870
 W !,?10,"TOTAL CHARGE",?56,$J($FN(ABMS("TOT"),",",2),14)  ;abm*2.6*30 IHS/SD/SDR CR8870
 S ABMP("TOT")=ABMP("TOT")+ABMS("TOT")
 I $G(ABMFLMSG)'="" W !!!!,ABMFLMSG
 F  W ! Q:$Y+4>IOSL
 S DIR(0)="E" D ^DIR K DIR
 Q
 ;
HD ;SCREEN HEADER
 W $$EN^ABMVDF("IOF")
 W !,?20,"***** "
 W $P(^ABMDEXP(ABMP("EXP"),0),U)
 W " CHARGE SUMMARY *****"
 W !!,"Active Insurer: ",$P($G(^AUTNINS(ABMP("INS"),0)),U),!
 I $D(ABMANESF) W !,"* - Indicates time (minutes) instead of units",!  ;abm*2.6*29 IHS/SD/SDR CR10888
 ;start old abm*2.6*30 IHS/SD/SDR CR8870
 ;W !,?51,"Corr"
 ;W !?1,"Charge Date  ",?21,"POS",?25,"TOS",?30," Description",?51,"Diag",?60,"Charge",?72,"Qty"
 ;end old start new abm*2.6*30 IHS/SD/SDR CR8870
 W !,?47,"Corr"
 W !?1,"Charge Date  ",?17,"POS",?21,"TOS",?25," Description",?47,"Diag",?60,"Charge",?73,"Qty"
 ;end new abm*2.6*30 IHS/SD/SDR CR8870
 S ABMS("I")="",$P(ABMS("I"),"-",80)="" W !,ABMS("I")
 Q
