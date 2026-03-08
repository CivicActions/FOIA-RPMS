AMHLITR2 ; IHS/CMI/LAB - print report of Intakes ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**12**;JUN 02, 2010;Build 46
 ;
 ;fixed potential undef
 ;
 ;
 I '$D(IOF) D HOME^%ZIS
 W @(IOF),!!
 W "**********  LIST INTAKE (INITIAL AND UPDATES)  **********",!!
 W "This report will list patients who have an Intake (Initial or Update) ",!,"on file matching the criteria you specify."
 D DBHUSRP^AMHUTIL
TYPE ;
 S AMHITYP=""
 K DIR
 S DIR(0)="S^I:INITIAL INTAKES;U:INTAKE UPDATES;B:BOTH",DIR("A")="Search Which Intake Documents",DIR("B")="B" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 S AMHITYP=Y
 ;
GETDATES ;
BD ;get beginning date
 W !,"Please enter the date range for the Intake Document search.",!
 W ! S DIR(0)="D^::EP",DIR("A")="Enter BEGINNING Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S AMHBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_AMHBD_":"_DT_":E",DIR("A")="Enter ENDING Date" S Y=AMHBD D DD^%DT D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S AMHED=Y
 S X1=AMHBD,X2=-1 D C^%DTC S AMHSD=X S Y=AMHBD D DD^%DT S AMHBDD=Y S Y=AMHED D DD^%DT S AMHEDD=Y
PROG ;
 S AMHPROG=""
 S DIR(0)="S^O:ONE Program;A:ALL Programs",DIR("A")="Include Intake Documens for which PROGRAM",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) GETDATES
 I Y="A" G THER
 S DIR(0)="9002011.13,.17",DIR("A")="Which PROGRAM" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) PROG
 I X="" G PROG
 S AMHPROG=Y
THER ;
 W !!,"You can limit the report output to Intakes for one or all Providers",!
 K AMHTHER W ! S DIR(0)="S^O:One Provider;A:All Providers",DIR("A")="List Intakes for",DIR("B")="A" K DA D ^DIR K DIR
 G:$D(DIRUT) XIT
 G:Y="A" SORT
 S DIC("A")="Which Provider: ",DIC="^VA(200,",DIC(0)="AEMQ" D ^DIC K DIC,DA
 I X="" G THER
 I Y<0 G THER
 S AMHTHER=+Y
SORT ;
 S AMHSORT=""
 S DIR(0)="S^P:Provider;N:Patient Name;D:Date of Intake",DIR("A")="Sort list by",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G THER
 S AMHSORT=Y
DEMO ;
 D DEMOCHK^AMHUTIL1(.AMHDEMO)
 I AMHDEMO=-1 G THER
ZIS ;CALL TO XBDBQUE
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 S XBRP="PRINT^AMHLITR2",XBRC="PROC^AMHLITR2",XBRX="XIT^AMHLITR2",XBNS="AMH"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^AMHLITR2"")"
 S XBNS="AMH",XBRC="PROC^AMHLITR2",XBRX="XIT^AMHLITR2",XBIOP=0 D ^XBDBQUE
 Q
XIT ;
 D EN^XBVK("AMH")
 Q
 ;
PROC ;EP - entry point for processing
 S AMHJOB=$J,AMHBTH=$H,AMHTOT=0,AMHTP=0,AMHBT=$H
 S AMHSD=$$FMADD^XLFDT(AMHBD,-1)_".9999"
 F  S AMHSD=$O(^AMHRINTK("B",AMHSD)) Q:AMHSD'=+AMHSD!(AMHSD>AMHED)  D
 .S AMHINTK=0 F  S AMHINTK=$O(^AMHRINTK("B",AMHSD,AMHINTK)) Q:AMHINTK=""  D PROC1
 S AMHET=$H
 K AMHINTK
 Q
PROC1 ;
 S X=$G(^AMHRINTK(AMHINTK,0))
 Q:$P(X,U,2)=""  ;no patient
 Q:'$$ALLOWP^AMHUTIL(DUZ,$P(X,U,2))  ;not allowed to see this patient
 Q:$$DEMO^AMHUTIL1($P(X,U,2),$G(AMHDEMO))  ;demo patient check
 Q:'$$ALLOWINT^AMHLEIV(DUZ,AMHINTK)  ;is user allowed to see this intake?
 I $G(AMHTHER),$P(X,U,4)'=AMHTHER Q  ;not correct provider
 I AMHPROG]"",$P(X,U,17)'=AMHPROG Q  ;not correct program
 I AMHITYP'="B" Q:$P(X,U,9)'=AMHITYP  ;not correct intake type
 D @AMHSORT
 S ^XTMP("AMHLITR2",AMHJOB,AMHBTH,AMHSORTV,AMHINTK)=""
 Q
P ;
 S AMHSORTV=$P(X,U,4)
 I AMHSORTV S AMHSORTV=$P(^VA(200,AMHSORTV,0),U) Q
 S AMHSORTV="--"
 Q
N ;
 S P=$P(^AMHRINTK(AMHINTK,0),U,2)
 I P="" S AMHSORVT="--" Q
 S AMHSORTV=$P(^DPT(P,0),U)
 I AMHSORTV="" S AMHSORTV="--"
 Q
D ;
 S AMHSORTV=$P(^AMHRINTK(AMHINTK,0),U,1)
 I AMHSORTV="" S AMHSORTV="--" Q
 Q
PRINT ;EP
 S AMH80D="-------------------------------------------------------------------------------",AMHQUIT=0,AMHPG=0
 D HEAD
 I '$D(^XTMP("AMHLITR2",AMHJOB,AMHBTH)) W !!,"NO DATA TO REPORT" G DONE
 S AMHSORTV="" F  S AMHSORTV=$O(^XTMP("AMHLITR2",AMHJOB,AMHBTH,AMHSORTV)) Q:AMHSORTV=""!(AMHQUIT)  D PRT2
 D DONE
 Q
PRT2 ;
 S AMHINTK=0 F  S AMHINTK=$O(^XTMP("AMHLITR2",AMHJOB,AMHBTH,AMHSORTV,AMHINTK)) Q:AMHINTK'=+AMHINTK!(AMHQUIT)  D
 .I $Y>(IOSL-4) D HEAD Q:AMHQUIT
 .S AMHINTKR=^AMHRINTK(AMHINTK,0)
 .S AMHPAT=$P(AMHINTKR,U,2)
 .W !,$E($$VAL^XBDIQ1(9002011.13,AMHINTK,.02),1,20),?23,$$FMTE^XLFDT($$DOB^AUPNPAT(AMHPAT),"2D"),?33,$$HRN^AUPNPAT(AMHPAT,DUZ(2))
 .W ?41,$$FMTE^XLFDT($P(AMHINTKR,U,1)),?56,$$VAL^XBDIQ1(9002011.13,AMHINTK,.09),?68,$$FMTE^XLFDT($P(AMHINTKR,U,7))
 .W !?3,"Program: ",$$VAL^XBDIQ1(9002011.13,AMHINTK,.05),?33,"Provider: ",$S($P(AMHINTKR,U,4):$P(^VA(200,$P(AMHINTKR,U,4),0),U),1:"????")
 Q
DONE D DONE^AMHLEIN,^AMHEKL
 K ^XTMP("AMHLITR2",AMHJOB,AMHBTH),AMHJOB,AMHBTH
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
HEAD ;
 I 'AMHPG G HEAD1
 NEW X
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQUIT=1 Q
HEAD1 ;EP
 S AMHPG=AMHPG+1
 W:$D(IOF) @IOF
 W !?13,"**********  CONFIDENTIAL PATIENT INFORMATION  **********"
 W !,$P(^VA(200,DUZ,0),U,2),?72,"Page 1 ",!
 W ?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),!
 S X="LISTING OF INTAKES" W $$CTR(X),!
 W ?20,"Date Range: ",AMHBDD," to ",AMHEDD,!
 I AMHPROG]"" S X="Program: "_$$EXTSET^XBFUNC(9002011.13,.17,AMHPROG) W $$CTR(X),!
 I $G(AMHTHER) S X="Provider:  "_$P(^VA(200,AMHTHER,0),U) W $$CTR(X),!
 W !,"PATIENT NAME",?23,"DOB",?33,"CHART #",?41,"DATE",?56,"TYPE",?68,"LAST UPDATE"
 W !
 W AMH80D,!
 Q
