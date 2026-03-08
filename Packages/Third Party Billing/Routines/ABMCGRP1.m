ABMCGRP1 ; IHS/SD/SDR - Claim Generator Report
 ;;2.6;IHS Third Party Billing;**35,40**;NOV 12, 2009;Build 785
 ;IHS/SD/SDR 2.6*35 ADO60700 New report - printer summary output
 ;IHS/SD/SDR 2.6*40 ADO85530 Report visits w/o Loc. Of Encounter
PRINT ;
 D HDB
 I ABMY("DT")="C" D DTCHK  ;this makes sure there is at least one line for each day of the claim generator
 S ABMCGI=0
 F  S ABMCGI=$O(^TMP("ABM-CGRPT",$J,"S",ABMCGI)) Q:'ABMCGI  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .I $O(^TMP("ABM-CGRPT",$J,"S",ABMCGI,""))="NOCG" D  Q
 ..I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W !," (cont)"
 ..W !,$$SDT^ABMDUTL(ABMCGI),?12,"<<CLAIM GENERATOR NOT RUN - NO DATA TO PRINT>>"
 .;S ABMVLOC=0  ;abm*2.6*40 IHS/SD/SDR ADO85530
 .S ABMVLOC=""  ;abm*2.6*40 IHS/SD/SDR ADO85530
 .;F  S ABMVLOC=$O(^TMP("ABM-CGRPT",$J,"S",ABMCGI,ABMVLOC)) Q:'ABMVLOC  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  ;abm*2.6*40 IHS/SD/SDR ADO85530
 .F  S ABMVLOC=$O(^TMP("ABM-CGRPT",$J,"S",ABMCGI,ABMVLOC)) Q:(ABMVLOC="")  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  ;abm*2.6*40 IHS/SD/SDR ADO85530
 ..S ABMOPT=""
 ..F  S ABMOPT=$O(^TMP("ABM-CGRPT",$J,"S",ABMCGI,ABMVLOC,ABMOPT)) Q:$G(ABMOPT)=""  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ...I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W !," (cont)"
 ...W !
 ...W $$SDT^ABMDUTL($P($G(^ABMCGAUD(ABMCGI,0)),U))  ;run date
 ...;S ABMLABBR=$P($G(^AUTTLOC(ABMVLOC,0)),U,7)  ;loc abbr  ;abm*2.6*40 IHS/SD/SDR ADO85530
 ...S ABMLABBR=$S(+ABMVLOC'=0:$P($G(^AUTTLOC(ABMVLOC,0)),U,7),1:"NONE")  ;loc abbr  ;abm*2.6*40 IHS/SD/SDR ADO85530
 ...I $G(ABMLABBR)="" S ABMLABBR=$E($P($G(^AUTTLOC(ABMVLOC,0)),U,2),1,4)
 ...W ?12,ABMLABBR
 ...W ?18,ABMOPT  ;option
 ...W ?25,$G(^TMP("ABM-CGRPT",$J,"S-BKMG",ABMCGI,ABMVLOC,ABMOPT))
 ...W ?35,$J(+$P($G(^TMP("ABM-CGRPT",$J,"S",ABMCGI,ABMVLOC,ABMOPT,"TOT","VSTS")),U),"7R")  ;visit count
 ...W ?45,$J(+$P($G(^TMP("ABM-CGRPT",$J,"S",ABMCGI,ABMVLOC,ABMOPT,"TOT","CLMS")),U),"7R")  ;claim count
 ...W ?55,$J(+$P($G(^TMP("ABM-CGRPT",$J,"S",ABMCGI,ABMVLOC,ABMOPT,"TOT","RCVSTS")),U),"7R")  ;re-check visit count
 ;
 ;totals
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 W !
 F A=1:1:80 W "-"
 ;S ABMVLOC=0  ;abm*2.6*40 IHS/SD/SDR ADO85530
 S ABMVLOC=""  ;abm*2.6*40 IHS/SD/SDR ADO85530
 ;F  S ABMVLOC=$O(^TMP("ABM-CGRPT",$J,"VLOCTOT",ABMVLOC)) Q:'ABMVLOC  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  ;abm*2.6*40 IHS/SD/SDR ADO85530
 F  S ABMVLOC=$O(^TMP("ABM-CGRPT",$J,"VLOCTOT",ABMVLOC)) Q:(ABMVLOC="")  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  ;abm*2.6*40 IHS/SD/SDR ADO85530
 .;W !,"Totals for "_$P($G(^AUTTLOC(ABMVLOC,0)),U,2)  ;abm*2.6*40 IHS/SD/SDR ADO85530
 .W !,"Totals for "_$S(+ABMVLOC'=0:$P($G(^AUTTLOC(ABMVLOC,0)),U,2),1:"NONE")  ;abm*2.6*40 IHS/SD/SDR ADO85530
 .W ?32,$J(+$P($G(^TMP("ABM-CGRPT",$J,"VLOCTOT",ABMVLOC)),U),"10R")  ;visit loc visit total
 .W ?40,$J(+$P($G(^TMP("ABM-CGRPT",$J,"VLOCTOT",ABMVLOC)),U,2),"10R")  ;visit loc claim total
 .W ?50,$J(+$P($G(^TMP("ABM-CGRPT",$J,"VLOCTOT",ABMVLOC)),U,3),"10R")  ;visit loc recheck visit total
 W !
 F A=1:1:80 W "-"
 W !,"GRAND TOTAL"
 W ?32,$J(+$P($G(^TMP("ABM-CGRPT",$J,"GTOT")),U),"10R")
 W ?40,$J(+$P($G(^TMP("ABM-CGRPT",$J,"GTOT")),U,2),"10R")
 W ?50,$J(+$P($G(^TMP("ABM-CGRPT",$J,"GTOT")),U,3),"10R")
 ;
 I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W !," (cont)"
 W !!
 F A=1:1:80 W "-"
 W !
 D CENTER^ABMUCUTL("BACKBILLING CHECKS")
 W !!,?21,"Queued From",?70,"Backbill"
 W !?2,"Date",?22,"Location",?36,"Initiated By",?72,"Date"
 I $O(TMP("ABM-CGRPT",$J,"S-BKMG",0))=0 W !!?2,"<No Backbill checks done in selected date range for report>"
 S ABMDT=0
 F  S ABMDT=$O(^TMP("ABM-CGRPT",$J,"B",ABMDT)) Q:'ABMDT  D
 .S ABMLOC=0
 .F  S ABMLOC=$O(^TMP("ABM-CGRPT",$J,"B",ABMDT,ABMLOC)) Q:'ABMLOC  D
 ..S ABMBY=0
 ..F  S ABMBY=$O(^TMP("ABM-CGRPT",$J,"B",ABMDT,ABMLOC,ABMBY)) Q:'ABMBY  D
 ...S ABMIDT=0
 ...F  S ABMIDT=$O(^TMP("ABM-CGRPT",$J,"B",ABMDT,ABMLOC,ABMBY,ABMIDT)) Q:'ABMIDT  D
 ....W !,$$BDT^ABMDUTL(ABMDT)
 ....W ?21,$P($G(^AUTTLOC(ABMLOC,0)),U,2)
 ....W ?36,$P($G(^VA(200,ABMBY,0)),U)
 ....W ?69,$$SDT^ABMDUTL(ABMIDT)
 W !!,"End of report"
 K ^TMP("ABM-CGRPT",$J)
 ;
 Q
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB ;
 S ABM("PG")=ABM("PG")+1
 D WHD
 W !!?2,"CG Run",?24,"Backbill",?45,"# Claims",?54,"# Visits"
 W !?3,"Date",?12,"Loc",?18,"Type",?25,"Check?",?35,"# Visits",?45,"Generatd",?54,"Recheckd"
 W !,"----------",?12,"---",?18,"----",?25,"--------",?35,"--------",?45,"--------",?54,"--------"
 Q
WHD ;EP for writing Report Header
 W $$EN^ABMVDF("IOF"),!
 I $D(ABM("PRIVACY")) W ?($S($D(ABM(132)):34,1:8)),"WARNING: Confidential Patient Information, Privacy Act Applies",!
 K ABM("LINE") S $P(ABM("LINE"),"=",$S($D(ABM(132)):132,1:80))="" W ABM("LINE"),!
 D NOW^%DTC
 W ABM("HD",0),?$S($D(ABM(132)):103,1:48) S Y=% X ^DD("DD") W Y,"   Page ",ABM("PG")
 W:$G(ABM("HD",1))]"" !,ABM("HD",1)
 W:$G(ABM("HD",2))]"" !,ABM("HD",2)
 ;
 W !,"Parent Location: ",$P($G(^AUTTLOC(ABMPAR,0)),U,2)
 W !,"For Visit Locations: "
 S ABMI=0
 ;F  S ABMI=$O(ABMY("LOC",ABMI)) Q:'ABMI  W !?3,$P($G(^AUTTLOC(ABMI,0)),U,2)
 S ABMU("TXT")=""
 F  S ABMI=$O(ABMY("LOC",ABMI)) Q:'ABMI  D
 .I ABMU("TXT")="" S ABMU("TXT")=$P($G(^AUTTLOC(ABMI,0)),U,2)
 .E  S ABMU("TXT")=ABMU("TXT")_", "_$P($G(^AUTTLOC(ABMI,0)),U,2)
 S ABMU("LM")=3,ABMU("RM")=78
 D ^ABMDWRAP
 W !,ABM("LINE") K ABM("LINE")
 Q
DTCHK ;
 S X=$G(ABMY("DT",1))
 D H^%DTC
 S ABMHSDT=+%H
 S X=$G(ABMY("DT",2))
 D H^%DTC
 S ABMHEDT=+%H
 S ABMFDT=$G(ABMY("DT",1))
 F ABMHSDT=ABMHSDT:1:ABMHEDT D
 .S %H=ABMHSDT
 .D YMD^%DTC
 .S ABMFTDT=X
 .I $O(^TMP("ABM-CGRPT",$J,"S",ABMFTDT))'[ABMFTDT S ^TMP("ABM-CGRPT",$J,"S",ABMFTDT,"NOCG")=""
 Q
