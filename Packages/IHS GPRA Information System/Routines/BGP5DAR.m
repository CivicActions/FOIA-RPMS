BGP5DAR ; IHS/CMI/LAB - ihs area GPRA ; 02 Sep 2004  1:11 PM
 ;;5.0;IHS CLINICAL REPORTING;**1**;OCT 15, 2004
 ;
 ;
 W:$D(IOF) @IOF
 S BGPA=$E($P(^AUTTLOC(DUZ(2),0),U,10),1,2),BGPA=$O(^AUTTAREA("C",BGPA,0)) S BGPA=$S(BGPA:$P(^AUTTAREA(BGPA,0),U),1:"UNKNOWN AREA")
 W !!,$$CTR(BGPA_" Area Aggregate National GPRA Report",80)
INTRO ;
 D EXIT
TP ;
 S BGPAREAA=1
 S BGPRTYPE=1,BGPBEN=1,BGP5RPTH=""
 ;W !!,"for testing purposes only, please enter a report year",!
 ;D F
 ;I BGPPER="" W !!,"no year entered..bye" D EXIT Q
 ;S BGPQTR=3
 ;S BGPBD=$E(BGPPER,1,3)_"0101",BGPED=$E(BGPPER,1,3)_"1231"
 ;S BGPPBD=($E(BGPPER,1,3)-1)_"0101",BGPPED=($E(BGPPER,1,3)-1)_"1231"
 ;W !!,"for testing purposes only, please enter a BASELINE year",!
 ;D B
 ;I BGPBPER="" W !!,"no year entered..bye" D EXIT Q
 ;S BGPBBD=$E(BGPBPER,1,3)_"0101",BGPBED=$E(BGPBPER,1,3)_"1231"
 ;END TEST STUFF
 S BGPBD=3040701,BGPED=3050630
 S BGPBBD=2990701,BGPBED=3000630
 S BGPPBD=3030701,BGPPED=3040630
 S BGPPER=3050000,BGPQTR=3
 W !!,"The date ranges for this report are:"
 W !?5,"Report Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
ASU ;
 S BGPSUCNT=0
 S BGPRPTT=""
 S DIR(0)="S^A:AREA Aggregate;F:One Facility",DIR("A")="Run Report for",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) EXIT
 S BGPRPTT=Y
 I BGPRPTT="F" D  G:$D(BGPQUIT) TP
 .S BGPSUCNT=0,BGPSU="",BGPSUC="" K BGPSUL
 .K BGPSUL S BGPX=0 F  S BGPX=$O(^BGPGPDCV(BGPX)) Q:BGPX'=+BGPX  S V=^BGPGPDCV(BGPX,0) D
 ..I $P(V,U)=BGPBD,$P(V,U,2)=BGPED,$P(V,U,7)=BGPPER,$P(V,U,12)=1,$P(V,U,5)=BGPBBD,$P(V,U,6)=BGPBED,$P(V,U,14)=BGPBEN S BGPSUL(BGPX)="",BGPSUCNT=BGPSUCNT+1
 .I '$D(BGPSUL) W !!,"No data from that time period has been uploaded from the service units.",! S BGPQUIT=1 Q
 .W !!,"Data from the following Facilities has been received.",!,"Please select the facility.",!
 .S BGPC=0 K BGPSUL1 S X=0,C=0 F  S X=$O(BGPSUL(X)) Q:X'=+X  S C=C+1,BGPSUL1(C)=X
 .S X=0 F  S X=$O(BGPSUL1(X)) Q:X'=+X  S BGP0=^BGPGPDCV(BGPSUL1(X),0) S BGPC=BGPC+1 D DISP
 .;,?2,"BEG DATE: ",$$DATE^BGP5UTL($P(BGP0,U)),?11,"END DATE: ",$$DATE^BGP5UTL($P(BGP0,U,2)) D
 .;W ?36,"SU: ",$$SU($P(BGP0,U,11)),?55,"Facility: ",$E($$FAC($P(BGP0,U,9)),1,15)
 .W !,"0",?5,"None of the Above"
 .S DIR(0)="N^0:"_BGPC_":0",DIR("A")="Please Select the Facility",DIR("B")="0" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S BGPQUIT=1 Q
 .I 'Y S BGPQUIT=1 Q
 .K BGPSUL S BGPSUL(BGPSUL1(Y))="",BGPSUCNT=1,X=$P(^BGPGPDCV(BGPSUL1(Y),0),U,9),X=$O(^AUTTLOC("C",X,0)) I X S BGPSUNM=$P(^DIC(4,X,0),U)
 .Q
 G:BGPRPTT="F" ZIS
GETSU ;
 K BGPSUL S BGPX=0 F  S BGPX=$O(^BGPGPDCV(BGPX)) Q:BGPX'=+BGPX  S V=^BGPGPDCV(BGPX,0) D
 .I $P(V,U)=BGPBD,$P(V,U,2)=BGPED,$P(V,U,7)=BGPPER,$P(V,U,5)=BGPBBD,$P(V,U,6)=BGPBED,$P(V,U,12)=1,$P(V,U,14)=BGPBEN S BGPSUL(BGPX)=""
 I '$D(BGPSUL) W !!,"No data from that time period has been uploaded from the service units.",! G INTRO
 W !!,"Data from the following Facilities has been received and will be used",!,"in the Area Aggregate Report:",!
 S X=0,BGPC=0 F  S X=$O(BGPSUL(X)) Q:X'=+X  S BGPC=BGPC+1,BGP0=^BGPGPDCV(X,0) D DISP
 ;W !?2,"FY: ",$$FMTE^XLFDT($P(BGP0,U,7)),?11,"END DATE: ",$$VAL^XBDIQ1(90371.03,X,.08),?36,"SU: ",$$SU($P(BGP0,U,11)),?55,"Facility: ",$E($$FAC($P(BGP0,U,9)),1,15)
ZIS ;call to XBDBQUE
EISSEX ;
 S BGPEXCEL=""
 S BGPUF=""
 I ^%ZOSF("OS")["PC"!(^%ZOSF("OS")["NT")!($P($G(^AUTTSITE(1,0)),U,21)=2) S BGPUF=$S($P($G(^AUTTSITE(1,1)),U,2)]"":$P(^AUTTSITE(1,1),U,2),1:"C:\EXPORT")
 I $P(^AUTTSITE(1,0),U,21)=1 S BGPUF="/usr/spool/uucppublic"
 I BGPRPTT="A" S BGPEXCEL=1 D
 .S BGPNOW=$$NOW^XLFDT() S BGPNOW=$$NOW^XLFDT() S BGPNOW=$P(BGPNOW,".")_"."_$$RZERO^BGP5UTL($P(BGPNOW,".",2),6)
 .S BDWC=0,X=0 F  S X=$O(BGPSUL(X)) Q:X'=+X  S BDWC=BDWC+1
 .I BGPUF="" W:'$D(ZTQUEUED) !!,"Cannot continue.....can't find export directory name. EXCEL file",!,"not written." Q
 .S BGPFN="GPRAEX"_$P(^AUTTLOC(DUZ(2),0),U,10)_2005063000000000_$$D^BGP5UTL(BGPNOW)_"_"_$$LZERO^BGP5UTL(BDWC,6)_".TXT"
 .Q
 S BGPASUF=$P(^AUTTLOC(DUZ(2),0),U,10)
 I BGPEXCEL D
 .W !!,"A file will be created called ",BGPFN,!,"and will reside in the ",BGPUF," directory. This file can be used in Excel.",!
 S BGPASUF=$P(^AUTTLOC(DUZ(2),0),U,10)
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
 I BGPRPTT="A" D EXCELGS^BGP5UTL
 D ^%ZISC
 D EXIT
 Q
 ;
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BGP*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BGP5DAR",ZTDTH="",ZTDESC="GPRA REPORT" D ^%ZTLOAD D EXIT Q
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
B ;fiscal year
 S (BGPBPER,BGPVDT)=""
 W !!,"Enter the BASELINE year for the report.  Use a 4 digit ",!,"year, e.g. 2004"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter BASELINE year"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR KILL DIR
 I $D(DIRUT) Q
 I $D(DUOUT) S DIRUT=1 Q
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G F
 S BGPBPER=BGPVDT
 Q
F ;fiscal year
 S BGPPER=""
 W !
 S BGPVDT=""
 W !,"Enter the Fiscal Year (FY) for the report END date.  Use a 4 digit",!,"year, e.g. 2002, 2004"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter FY"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR
 K DIC
 I $D(DUOUT) S DIRUT=1 S BGPQUIT="" Q
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G F
 S BGPPER=BGPVDT,BGPBD=($E(BGPVDT,1,3)-1)_"1001",BGPED=$E(BGPVDT,1,3)_"0930"
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
DISP ;
 W:BGPC=1 !,"#",?4,"BEG DATE",?13,"END DATE",?22,"BASE BEG",?32,"BASE END",?42,"SU",?59,"FACILITY",!,"-",?4,"--------",?13,"--------",?22,"---------",?32,"-------",?42,"--",?59,"--------"
 W !,BGPC,?4,$$DATE^BGP5UTL($P(BGP0,U,1)),?13,$$DATE^BGP5UTL($P(BGP0,U,2)),?22,$$DATE^BGP5UTL($P(BGP0,U,5)),?32,$$DATE^BGP5UTL($P(BGP0,U,6)),?42,$E($$SU($P(BGP0,U,11)),1,15),?59,$E($$FAC($P(BGP0,U,9)),1,20)
 Q
