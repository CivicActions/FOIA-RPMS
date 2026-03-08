BGP5DGPA ; IHS/CMI/LAB - ihs area GPRA ; 02 Sep 2004  1:11 PM
 ;;5.0;IHS CLINICAL REPORTING;**1**;OCT 15, 2004
 ;
 ;
 W:$D(IOF) @IOF
 S BGPA=$E($P(^AUTTLOC(DUZ(2),0),U,10),1,2),BGPA=$O(^AUTTAREA("C",BGPA,0)) S BGPA=$S(BGPA:$P(^AUTTAREA(BGPA,0),U),1:"UNKNOWN AREA")
 W !!,$$CTR(BGPA_" Area Aggregate GPRA Performance Report with user defined date range",80)
INTRO ;
 D EXIT
TP ;
 S BGPAREAA=1
 S BGPRTYPE=1,BGP5RPTH="",BGP5GPU=1
 ;
 S (BGPBD,BGPED,BGPTP)=""
 S DIR(0)="S^1:January 1 - December 31;2:April 1 - March 31;3:July 1 - June 30;4:October 1 - September 30;5:User-Defined Report Period",DIR("A")="Enter the date range for your report" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 S BGPQTR=Y
 I BGPQTR=5 D ENDDATE
 I BGPQTR'=5 D F
 I BGPPER="" W !,"Year not entered.",! G TP
 I BGPQTR=1 S BGPBD=$E(BGPPER,1,3)_"0101",BGPED=$E(BGPPER,1,3)_"1231"
 I BGPQTR=2 S BGPBD=($E(BGPPER,1,3)-1)_"0401",BGPED=$E(BGPPER,1,3)_"0331"
 I BGPQTR=3 S BGPBD=($E(BGPPER,1,3)-1)_"0701",BGPED=$E(BGPPER,1,3)_"0630"
 I BGPQTR=4 S BGPBD=($E(BGPPER,1,3)-1)_"1001",BGPED=$E(BGPPER,1,3)_"0930"
 I BGPQTR=5 S BGPBD=$$FMADD^XLFDT(BGPPER,-365),BGPED=BGPPER,BGPPER=$E(BGPED,1,3)_"0000"
 I BGPED>DT D  G:BGPDO=1 TP
 .W !!,"You have selected Current Report period ",$$FMTE^XLFDT(BGPBD)," through ",$$FMTE^XLFDT(BGPED),"."
 .W !,"The end date of this report is in the future; your data will not be",!,"complete.",!
 .K DIR S BGPDO=0 S DIR(0)="Y",DIR("A")="Do you want to change your Current Report Dates?",DIR("B")="N" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S BGPDO=1 Q
 .I Y S BGPDO=1 Q
 .Q
BY ;get baseline year
 S BGPVDT=""
 W !!,"Enter the Baseline Year to compare data to.",!,"Use a 4 digit year, e.g. 1999, 2000"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter Year (e.g. 2000)"
 D ^DIR KILL DIR
 I $D(DIRUT) G TP
 I $D(DUOUT) S DIRUT=1 G TP
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G BY
 S X=$E(BGPPER,1,3)-$E(BGPVDT,1,3)
 S X=X_"0000"
 S BGPBBD=BGPBD-X,BGPBBD=$E(BGPBBD,1,3)_$E(BGPBD,4,7)
 S BGPBED=BGPED-X,BGPBED=$E(BGPBED,1,3)_$E(BGPED,4,7)
 S BGPPBD=($E(BGPBD,1,3)-1)_$E(BGPBD,4,7)
 S BGPPED=($E(BGPED,1,3)-1)_$E(BGPED,4,7)
 W !!,"The date ranges for this report are:"
 W !?5,"Report Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
 I BGPPBD=BGPBBD,BGPPED=BGPBED K Y D CHKY I Y K BGPBBD,BGPBED,BGPPBD,BGPPED G BY
BEN ;
 S BGPBEN=""
 S DIR(0)="S^1:Indian/Alaskan Native (Classification 01);2:Not Indian Alaskan/Native (Not Classification 01);3:All (both Indian/Alaskan Natives and Non 01)",DIR("A")="Select Beneficiary Population to include in this report"
 S DIR("B")="1" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G BY
 S BGPBEN=Y,BGPBENF=Y(0)
HOME ;
 S BGPHOME=$P($G(^BGPSITE(DUZ(2),0)),U,2)
 I BGPHOME="" W !!,"Home Location not found in Site File!!",!,"PHN Visits counts to Home will be calculated using clinic 11 only!!" H 2 G AI
 W !,"Your HOME location is defined as: ",$P(^DIC(4,BGPHOME,0),U)," asufac:  ",$P(^AUTTLOC(BGPHOME,0),U,10)
AI ;gather all gpra indicators
 S X=0 F  S X=$O(^BGPINDV("GPRA",1,X)) Q:X'=+X  S BGPIND(X)=""
 S BGPINDT="G"
ASU ;
 S BGPSUCNT=0
 S BGPRPTT=""
 S DIR(0)="S^A:AREA Aggregate;F:One Facility",DIR("A")="Run Report for",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) EXIT
 S BGPRPTT=Y
 I BGPRPTT="F" D  G:$D(BGPQUIT) TP
 .S BGPSUCNT=0,BGPSU="",BGPSUC="" K BGPSUL
 .K BGPSUL S BGPX=0 F  S BGPX=$O(^BGPGPDCV(BGPX)) Q:BGPX'=+BGPX  S V=^BGPGPDCV(BGPX,0) D
 ..I $P(V,U)=BGPBD,$P(V,U,2)=BGPED,$P(V,U,7)=BGPPER,$P(V,U,8)=BGPQTR,$P(V,U,12)=1,$P(V,U,5)=BGPBBD,$P(V,U,6)=BGPBED,$P(V,U,14)=BGPBEN S BGPSUL(BGPX)="",BGPSUCNT=BGPSUCNT+1
 .I '$D(BGPSUL) W !!,"No data from that time period has been uploaded from the service units.",! S BGPQUIT=1 Q
 .W !!,"Data from the following Facilities has been received.",!,"Please select the facility.",!
 .S BGPC=0 K BGPSUL1 S X=0,C=0 F  S X=$O(BGPSUL(X)) Q:X'=+X  S C=C+1,BGPSUL1(C)=X
 .S X=0 F  S X=$O(BGPSUL1(X)) Q:X'=+X  S BGP0=^BGPGPDCV(BGPSUL1(X),0) S BGPC=BGPC+1 D DISP
 .W !,X,")" ;,?2,"BEG DATE: ",$$DATE^BGP5UTL($P(BGP0,U)),?11,"END DATE: ",$$DATE^BGP5UTL($P(BGP0,U,2)) D
 ..;W ?36,"SU: ",$$SU($P(BGP0,U,11)),?55,"Facility: ",$E($$FAC($P(BGP0,U,9)),1,15)
 .W !?2,"0)",?5,"None of the Above"
 .S DIR(0)="N^0:"_C_":0",DIR("A")="Please Select the Facility",DIR("B")="0" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S BGPQUIT=1 Q
 .I 'Y S BGPQUIT=1 Q
 .K BGPSUL S BGPSUL(BGPSUL1(Y))="",BGPSUCNT=1,X=$P(^BGPGPDCV(BGPSUL1(Y),0),U,9),X=$O(^AUTTLOC("C",X,0)) I X S BGPSUNM=$P(^DIC(4,X,0),U)
 .Q
 G:BGPRPTT="F" ZIS
GETSU ;
 K BGPSUL S BGPX=0 F  S BGPX=$O(^BGPGPDCV(BGPX)) Q:BGPX'=+BGPX  S V=^BGPGPDCV(BGPX,0) D
 .I $P(V,U)=BGPBD,$P(V,U,2)=BGPED,$P(V,U,7)=BGPPER,$P(V,U,8)=BGPQTR,$P(V,U,5)=BGPBBD,$P(V,U,6)=BGPBED,$P(V,U,12)=1,$P(V,U,14)=BGPBEN S BGPSUL(BGPX)=""
 I '$D(BGPSUL) W !!,"No data from that time period has been uploaded from the service units.",! G INTRO
 W !!,"Data from the following Facilities has been received and will be used",!,"in the Area Aggregate Report:",!
 S X=0,BGPC=0 F  S X=$O(BGPSUL(X)) Q:X'=+X  S BGPC=BGPC+1,BGP0=^BGPGPDCV(X,0) D DISP
 ;W !?2,"FY: ",$$FMTE^XLFDT($P(BGP0,U,7)),?11,"END DATE: ",$$VAL^XBDIQ1(90371.03,X,.08),?36,"SU: ",$$SU($P(BGP0,U,11)),?55,"Facility: ",$E($$FAC($P(BGP0,U,9)),1,15)
ZIS ;call to XBDBQUE
EISSEX ;
 S BGPEXCEL=""
 D ^XBFMK
 K DIC,DIADD,DLAYGO,DR,DA,DD,X,Y,DINUM
GI ;gather all gpra indicators
 S X=0 F  S X=$O(^BGPINDV("GPRA",1,X)) Q:X'=+X  S BGPIND(X)=""
 S BGPINDT="G"
 D PT^BGP5DSL
 I BGPROT="" G ASU
 ;
 K IOP,%ZIS W !! S %ZIS=$S(BGPDELT'="S":"PQM",1:"PM") D ^%ZIS
 I $D(IO("Q")) G TSKMN
DRIVER ;
 U IO
 D PRINT^BGP5PARP
 D ^%ZISC
 D EXIT
 Q
 ;
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BGP*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BGP5DGPA",ZTDTH="",ZTDESC="GPRA REPORT" D ^%ZTLOAD D EXIT Q
 Q
 ;
FAC(S) ;
 NEW N S N=$O(^AUTTLOC("C",S,0))
 I N="" Q N
 Q $P(^DIC(4,N,0),U)
SU(S) ;
 NEW N S N=$O(^AUTTSU("C",S,0))
 I N="" Q N
 Q $P(^AUTTSU(N,0),U)
EXIT ;
 D EN^XBVK("BGP")
 D KILL^AUPNPAT
 D ^XBFMK
 Q
 ;
CHKY ;
 W !!,"The baseline year and the previous year time periods are the same.",!!
 S DIR(0)="Y",DIR("A")="Do you want to change the baseline year",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S Y="" Q
 Q
F ;calendar year
 S (BGPPER,BGPVDT)=""
 W !!,"Enter the Calendar Year for the report END date.  Use a 4 digit",!,"year, e.g. 2004"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter Year"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR KILL DIR
 I $D(DIRUT) Q
 I $D(DUOUT) S DIRUT=1 Q
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G F
 S BGPPER=BGPVDT
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
 ;
ENDDATE ;
 W !!,"When entering dates, if you do not enter a full 4 digit year (e.g. 2005)"
 W !,"will assume a year in the past, if you want to put in a future date,"
 W !,"remember to enter the full 4 digit year.  For example, if today is"
 W !,"January 4, 2005 and you type in 6/30/05 the system will assume the year"
 W !,"as 1905 since that is a date in the past.  You must type 6/30/2005 if you"
 W !,"want a date in the future."
 S (BGPPER,BGPVDT)=""
 W ! K DIR,X,Y S DIR(0)="D^::EP",DIR("A")="Enter End Date for the Report: (e.g. 11/30/2004)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) Q
 S (BGPPER,BGPVDT)=Y
 Q
DISP ;
 W:BGPC=1 !,"#",?4,"BEG DATE",?13,"END DATE",?22,"BASE BEG",?32,"BASE END",?42,"SU",?59,"FACILITY",!,"-",?4,"--------",?13,"--------",?22,"---------",?32,"-------",?42,"--",?59,"--------"
 W !,BGPC,?4,$$DATE^BGP5UTL($P(BGP0,U,1)),?13,$$DATE^BGP5UTL($P(BGP0,U,2)),?22,$$DATE^BGP5UTL($P(BGP0,U,5)),?32,$$DATE^BGP5UTL($P(BGP0,U,6)),?42,$E($$SU($P(BGP0,U,11)),1,15),?59,$E($$FAC($P(BGP0,U,9)),1,20)
 Q
