BDWCOVLG ; IHS/CMI/LAB - DISPLAY DW EXPORT LOG DATA AUGUST 14, 1992 ;
 ;;1.0;IHS DATA WAREHOUSE;**7,11**;JAN 24, 2006;Build 14
 ;
EN1 ;
 W:$D(IOF) @IOF
 K BDWQUIT
 W !!,"Display COVID-19 EXPORT Log Entry",!
 W !,"Type a ?? and press enter at the following prompt to view a list of RUN DATES.",!,"Or, if you know the run date you can enter it in the format MM/DD/YY:  e.g. 2/26/19",!
 S DIC="^BDWCVLOG(",DIC(0)="AEMQ" D ^DIC K DIC I Y=-1 W !!,"Goodbye" G XIT
 S BDWLOG=+Y
 ;S DIR(0)="SO^B:BROWSE Output on Screen;P:PRINT Output to Printer",DIR("A")="Do you want to",DIR("B")="B" K DA D ^DIR K DIR
 ;G:$D(DIRUT) XIT
 ;I Y="B" D BROWSE,XIT Q
 ;S XBRP="PRINT^BDWCOVLG",XBRC="PROC^BDWCOVLG",XBRX="XIT^BDWCOVLG",XBNS="BDW"
 ;D ^XBDBQUE
 D BROWSE
 D XIT
 Q
BROWSE ;
 D VIEWR^XBLM("PRINT^BDWCOVLG","COVID-19 Data Warehouse Export Log Display")
 Q
XIT ;EP
 D FULL^VALM1
 K BDWLOG,BDWREC
 Q
PROC ;
 Q
PRINT ;
 W ?19,"COVID-19 DATA WAREHOUSE EXPORT LOG REPORT"
 W !?7,"Information for Log Entry ",BDWLOG," Run Date:  ",$$VAL^XBDIQ1(90213.2,BDWLOG,.01)
 S BDWREC=^BDWCVLOG(BDWLOG,0)
 W !!?35,"Number:",?45,BDWLOG
 W !?20,"Run Database/Location:",?45,$$VAL^XBDIQ1(90213.2,BDWLOG,.02)
 W !?27,"Beginning Date:",?45,$$VAL^XBDIQ1(90213.2,BDWLOG,.08)
 W !?30,"Ending Date:",?45,$$VAL^XBDIQ1(90213.2,BDWLOG,.09)
 W !?30,"Export Type:",?45,$$VAL^XBDIQ1(90213.2,BDWLOG,.07)
 W !?22,"Transmission Status:",?45,$$VAL^XBDIQ1(90213.2,BDWLOG,.1)
 W !?25,"Filename Created:",?45,$$VAL^XBDIQ1(90213.2,BDWLOG,.05)
 W !?19,"Production/Test System:",?45,$$VAL^XBDIQ1(90213.2,BDWLOG,.14)
 W !!?3,"DATE/ASUFAC DATA EXPORTED"
 S BDWDM=0 F  S BDWDM=$O(^BDWCVLOG(BDWLOG,11,BDWDM)) Q:BDWDM'=+BDWDM  D
 .I '$O(^BDWCVLOG(BDWLOG,11,BDWDM,11,0)) Q  ;NO DATA FOR THIS DATE
 .W !?7,$$DATE($P(^BDWCVLOG(BDWLOG,11,BDWDM,0),U,1))
 .S BDWY=0 F  S BDWY=$O(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY)) Q:BDWY'=+BDWY  D
 ..W !?10,"Location: " S Y=$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,2) I Y W ?50,$P(^DIC(4,Y,0),U,1)
 ..W !?10,"# of Hospital Beds:",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,13),0,6)
 ..W !?10,"# of Occupied Beds:",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,14),0,6)
 ..W !?10,"# of Open Beds:",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,15),0,6)
 ..W !?10,"# of ICU Beds:",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,16),0,6)
 ..W !?10,"# of Occupied ICU Beds:",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,17),0,6)
 ..W !?10,"# of Open ICU Beds:",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,18),0,6)
 ..W !?10,"# of COVID Patients in Hospital:",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,19),0,6)
 ..W !?10,"# of COVID Patients in ICU Beds:",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,20),0,6)
 ..W !?10,"# Discharged Home:",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,21),0,6)
 ..W !?10,"# Patients Transferred:",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,22),0,6)
 ..W !?10,"# COVID Deaths:",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,23),0,6)
 ..W !?10,"# of Tests Done:",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,3),0,6)
 ..W !?10,"# of Positive Tests:",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,4),0,6)
 ..W !?10,"# of Negative Tests:",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,5),0,6)
 ..W !?10,"# of Indeterminate Tests:",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,6),0,6)
 ..W !?10,"# of Tests in Progress:",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,7),0,6)
 ..W !?10,"# of Tests Done (Cumulative):",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,8),0,6)
 ..W !?10,"# of Positive Tests (Cumulative):",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,9),0,6)
 ..W !?10,"# of Negative Tests (Cumulative):",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,10),0,6)
 ..W !?10,"# of Indeterminate Tests (Cumulative):",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,11),0,6)
 ..W !?10,"# of Tests in Progress (Cumulative):",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,12),0,6)
 ..W !?10,"# of Abbott Tests Done:",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,24),0,6)
 ..W !?10,"# of Abbott Tests Resulted:",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,25),0,6)
 ..W !?10,"# of Abbott Tests Positive:",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,26),0,6)
 ..W !?10,"# of Abbott Tests Done (Cumulative):",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,27),0,6)
 ..W !?10,"# of Abbott Tests Resulted (Cumulative):",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,28),0,6)
 ..W !?10,"# of Abbott Tests Positive (Cumulative):",?50,$$C(+$P(^BDWCVLOG(BDWLOG,11,BDWDM,11,BDWY,0),U,29),0,6)
 W !!
 Q
DATE(D) ;
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
EOP ;
 W !
 S DIR(0)="E",DIR("A")="Press ENTER to continue" KILL DA D ^DIR KILL DIR
 Q
C(X,X2,X3) ;
 D COMMA^%DTC
 Q $J(X,8)
