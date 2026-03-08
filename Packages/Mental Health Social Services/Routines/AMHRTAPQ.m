AMHRTAPQ ; IHS/CMI/LAB - list refusals ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**12**;JUN 02, 2010;Build 46
 ;
 ;
PRINT ;EP - called from xbdbque
 D PRINT1
 D DONE
 Q
PRINT1 ;
 S AMHRPG=0 K AMHRQUIT
 K AMHRLSTP
 I AMHPTOT=0 D HEADER W !!,"No data to report.",! G DONE
 D HEADER
 W !,"Total Number of Patients screened positive for ",$P(AMHRSUBE,"-",2),":",?62,$J($$COM(AMHPTOT,0),7)
TALLIES ;
 D GENDER
 Q:$$END
 D AGE
 Q:$$END
 D CLINIC
 Q:$$END
 D RACE
 Q:$$END
 D ETHN
 Q:$$END
 D RES
 Q:$$END
 D LIST
 Q
GENDER ;
 ;TALLY BY GENDER OF PATIENT
 W !!?5,"By Gender",!
 S AMHRX="" F  S AMHRX=$O(AMHGEND(AMHRX)) Q:AMHRX=""!($D(AMHRQUIT))  D
 .Q:$$END
 .S Y=$L(AMHRX),Y=45-Y W !?20,AMHRX,?62,$J($$COM($G(AMHGEND(AMHRX)),0),7),?72,$J($$PER(AMHGEND(AMHRX),AMHPTOT),7)
 .Q
 Q
AGE ;
 W !!?5,"By Age",!
 S AMHRX="" F  S AMHRX=$O(AMHAGE(AMHRX)) Q:AMHRX=""!($D(AMHRQUIT))  D
 .Q:$$END
 .S AMHRX1=AMHRX_" yrs old"
 .S Y=$L(AMHRX1),Y=45-Y W !?20,AMHRX1,?62,$J($$COM($G(AMHAGE(AMHRX)),0),7),?72,$J($$PER(AMHAGE(AMHRX),AMHPTOT),7)
 .Q
 Q
CLINIC ;
 W !!?5,"By Clinic",!
 S AMHRX="" F  S AMHRX=$O(AMHCLN(AMHRX)) Q:AMHRX=""!($D(AMHRQUIT))  D
 .Q:$$END
 .S Y=$L(AMHRX),Y=45-Y W !?20,AMHRX,?62,$J($$COM($G(AMHCLN(AMHRX)),0),7),?72,$J($$PER(AMHCLN(AMHRX),AMHPTOT),7)
 .Q
 Q
RACE ;
 W !!?5,"By Race",!
 S AMHRX="" F  S AMHRX=$O(AMHRACE(AMHRX)) Q:AMHRX=""!($D(AMHRQUIT))  D
 .Q:$$END
 .S Y=$L(AMHRX),Y=45-Y W !?20,AMHRX,?62,$J($$COM($G(AMHRACE(AMHRX)),0),7),?72,$J($$PER(AMHRACE(AMHRX),AMHPTOT),7)
 .Q
 Q
ETHN ;
 W !!?5,"By Ethnicity",!
 S AMHRX="" F  S AMHRX=$O(AMHETHN(AMHRX)) Q:AMHRX=""!($D(AMHRQUIT))  D
 .Q:$$END
 .S Y=$L(AMHRX),Y=45-Y W !?20,AMHRX,?62,$J($$COM($G(AMHETHN(AMHRX)),0),7),?72,$J($$PER(AMHETHN(AMHRX),AMHPTOT),7)
 .Q
 Q
 ;
RES ;
 W !!?5,$P(AMHRSUBE,"-",2),!
 S AMHRX="" F  S AMHRX=$O(AMHRES(AMHRX)) Q:AMHRX=""!($D(AMHRQUIT))  D
 .Q:$$END
 .W !?20,AMHRX,?62,$J($$COM($G(AMHRES(AMHRX)),0),7),?72,$J($$PER(AMHRES(AMHRX),AMHPTOT),7)
 .Q
 ;W !!?20,"Positive Tobacco Tally",?62,$J($$COM(AMHTOPO(1),0),7),?72,$J($$PER(AMHTOPO(1),AMHPTOT),7)
 Q
 ;
PER(N,D) ;return % of n/d
 I 'D Q "0%"
 NEW Z
 S Z=N/D,Z=Z*100,Z=$J(Z,5,1)
 Q $$STRIP^XLFSTR(Z," ")_"%"
COM(X,X2,X3) ;
 D COMMA^%DTC
 Q $$STRIP^XLFSTR(X," ")
END() ;
 I $Y<(IOSL-3) Q 0
 D HEADER
 I $D(AMHRQUIT) Q 1
 Q 0
ENDL() ;
 I $Y<(IOSL-8) Q 0
 D HEADER
 I $D(AMHRQUIT) Q 1
 Q 0
TOT() ;
 NEW C,X
 S C=0
 S X=0 F  S X=$O(^XTMP("AMHRTAPD",AMHRJ,AMHRH,"PATS",X)) Q:X'=+X  S C=C+1
 Q C
HEADER ;EP
 G:'AMHRPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHRQUIT="" Q
HEADER1 ;
 W:$D(IOF) @IOF S AMHRPG=AMHRPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",AMHRPG,!
 W $$CTR("PATIENTS SCREENED POSITIVE FOR "_AMHRSUBE,80),!
 W $$CTR("*** PATIENT TALLY AND PATIENT LISTING ***",80),!
 S X="Screening Dates: "_$$FMTE^XLFDT(AMHRBD)_" to "_$$FMTE^XLFDT(AMHRED) W $$CTR(X,80),!
 I AMHREXPC S X="This report includes data from the PCC Clinical database." W $$CTR(X,80),!
 I 'AMHREXPC S X="This report excludes data from the PCC Clinical database." W $$CTR(X,80),!
 W !,$TR($J("",80)," ","-"),!
 I $G(AMHIAIL) W !,"PATIENT NAME",?28,"HRN",?36,"AGE",?42,"SEX",?49,"DATE",?61,"CLINIC",!?49,"SCREENED" W !,$TR($J("",80)," ","-"),!
 Q
DONE ;
 K ^TMP($J)
 K ^XTMP("AMHRTAPD",AMHRJ,AMHRH)
 D EOP
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:IO'=IO(0)
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 W !
 S DIR("A")="End of Report.  Press Enter",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
DT(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 ;
 ;----------
LIST ;EP - called from xbdbque
 S AMHIAIL=1
 S AMHRSORV="" F  S AMHRSORV=$O(^XTMP("AMHRTAPD",AMHRJ,AMHRH,"LIST",AMHRSORV)) Q:AMHRSORV=""!($D(AMHRQUIT))  D
 .S DFN=0 F  S DFN=$O(^XTMP("AMHRTAPD",AMHRJ,AMHRH,"LIST",AMHRSORV,DFN)) Q:DFN'=+DFN!($D(AMHRQUIT))  D
 ..Q:$$ENDL
 ..S AMHX="",AMHC=0 F  S AMHX=$O(^XTMP("AMHRTAPD",AMHRJ,AMHRH,"LIST",AMHRSORV,DFN,AMHX)) Q:AMHX=""!($D(AMHRQUIT))  D
 ...S AMHC=AMHC+1
 ...S AMHRY=""
 ...I AMHC=1 S AMHRY=^XTMP("AMHRTAPD",AMHRJ,AMHRH,"LIST",AMHRSORV,DFN,AMHX) D
 ....S D=$P(AMHRY,U,8)
 ....W !!,$E($P(^DPT(DFN,0),U),1,25),?28,$$HRN^AUPNPAT(DFN,DUZ(2)),?37,$$AGE^AUPNPAT(DFN,D),?43,$P(^DPT(DFN,0),U,2),?35,$$DT(D),?55,$E($P(AMHRY,U,4),1,18)
 ...W !?5,AMHX
 Q
