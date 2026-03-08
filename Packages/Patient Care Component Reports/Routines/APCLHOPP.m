APCLHOPP ; IHS/CMI/LAB - list refusals ;
 ;;2.0;IHS PCC SUITE;**31**;MAY 14, 2009;Build 10
 ;
 ;
PRINT ;EP - called from xbdbque
 D PRINT1
 D DONE
 Q
PRINT1 ;
 S APCLPG=0 K APCLQUIT
 K APCLLSTP
 I '$D(^XTMP("APCLHOPA",APCLJ,APCLH)) D HEADER W !!,"No data to report.",! G DONE
 D HEADER
 S APCLTOT=$$TOT
 W !,"Total Number of Patients screened for any SDOH factor",?40,$J($$COM(APCLTOT,0),8)
 D RES
 Q:$$END
 ;tally food
 I APCLEXTP=1!(APCLEXTP=2) D  Q:$$END
 .S APCLS="FOOD" D TALLIES
 Q:$D(APCLQUIT)
 I APCLEXTP=1!(APCLEXTP=3) D  Q:$$END
 .S APCLS="HOUSING" D TALLIES
 Q:$D(APCLQUIT)
 I APCLEXTP=1!(APCLEXTP=4) D  Q:$$END
 .S APCLS="TRANSPORTATION" D TALLIES
 Q:$D(APCLQUIT)
 I APCLEXTP=1!(APCLEXTP=5) D  Q:$$END
 .S APCLS="UTILITIES" D TALLIES
 Q:$D(APCLQUIT)
 I APCLEXTP=1!(APCLEXTP=6) D  Q:$$END
 .S APCLS="INTERPERSONAL SAFETY" D TALLIES
 Q:$D(APCLQUIT)
 Q
TALLIES ;
 Q:'$D(APCLRALL)
 W !!!,$$CTR("SDOH "_APCLS_" SCREENING")
 S D=+$P($G(^XTMP("APCLHOPA",APCLJ,APCLH,APCLS)),U,1)
 I 'D W !!,$$CTR("No "_APCLS_" Screenings done."),! Q
 I $D(APCLRALL(1)) S APCLLABL="By Sex",APCLT="SEX" D T1
 Q:$D(APCLQUIT)
 I $D(APCLRALL(2)) S APCLLABL="By Age Grouping",APCLT="AGE" D T1
 Q:$D(APCLQUIT)
 I $D(APCLRALL(3)) S APCLLABL="By Clinic",APCLT="CLINIC" D T1
 Q:$D(APCLQUIT)
 I $D(APCLRALL(5)) S APCLLABL="By Ethnicity",APCLT="ETHNICITY" D T1
 Q:$D(APCLQUIT)
 I $D(APCLRALL(6)) S APCLLABL="By Race",APCLT="RACE" D T1
 Q:$D(APCLQUIT)
 I $D(APCLRALL(7)) S APCLLABL="By Patient Community",APCLT="COMMUNITY" D T1
 Q
RES ;
 F APCLS="FOOD","HOUSING","TRANSPORTATION","UTILITIES","INTERPERSONAL SAFETY" Q:$$END  D
 .I APCLS="FOOD",APCLEXTP'=1,APCLEXTP'=2 Q  ;no food
 .I APCLS="HOUSING",APCLEXTP'=1,APCLEXTP'=3 Q
 .I APCLS="TRANSPORTATION",APCLEXTP'=1,APCLEXTP'=4 Q
 .I APCLS="UTILITIES",APCLEXTP'=1,APCLEXTP'=5 Q
 .I APCLS="INTERPERSONAL SAFETY",APCLEXTP'=1,APCLEXTP'=6 Q
 .S APCLV=""
 .S APCLV=$G(^XTMP("APCLHOPA",APCLJ,APCLH,APCLS))
 .W !!,"SDOH Exam ",APCLS,?34,"Total number screened (denominator): ",$$COM($P(APCLV,U,1),0,8),!
 .I 'APCLV Q  ;no denominator so don't tally
 .W ?35,"#",?45,"%",!
 .W ?5,"POSITIVE",?35,$$COM(+$P(APCLV,U,2),0,8),?45,$$PER($P(APCLV,U,2),$P(APCLV,U,1)),!!
 .W ?5,"NEGATIVE",?35,$$COM(+$P(APCLV,U,3),0,8),?45,$$PER($P(APCLV,U,3),$P(APCLV,U,1)),!!
 .W ?5,"PATIENT REFUSED SCREENING",?35,$$COM(+$P(APCLV,U,4),0,8),?45,$$PER($P(APCLV,U,4),$P(APCLV,U,1)),!!
 .W ?5,"UNABLE TO SCREEN",?35,$$COM(+$P(APCLV,U,5),0,8),?45,$$PER($P(APCLV,U,5),$P(APCLV,U,1)),!!
 .W ?5,"REFERRAL NEEDED",?35,$$COM(+$P(APCLV,U,6),0,8),?45,$$PER($P(APCLV,U,6),$P(APCLV,U,1)),!!
 .Q
 Q
T1 ;
 ;S J=$L(APCLLABL)
 ;W !!,?(38-J),APCLLABL,!
 W !!,$$CTR(APCLLABL),!
 S APCLX="" F  S APCLX=$O(^XTMP("APCLHOPA",APCLJ,APCLH,APCLS,APCLT,APCLX)) Q:APCLX=""!($D(APCLQUIT))  D
 .Q:$$END
 .S V=^XTMP("APCLHOPA",APCLJ,APCLH,APCLS,APCLT,APCLX)
 .S D=+$P($G(^XTMP("APCLHOPA",APCLJ,APCLH,APCLS)),U,1)
 .S R=APCLX I APCLT="AGE" S R=$P(APCLRBIN,";",APCLX)
 .S Y=$L(R),Y=38-Y W !?Y,R,?40,$J($$COM(V,0),8),?55,$$PER(V,D)
 .Q
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
 I $D(APCLQUIT) Q 1
 Q 0
ENDL() ;
 I $Y<(IOSL-8) Q 0
 D HEADER
 I $D(APCLQUIT) Q 1
 Q 0
TOT() ;
 NEW C,X
 S C=0
 S X=0 F  S X=$O(^XTMP("APCLHOPA",APCLJ,APCLH,"PATS",X)) Q:X'=+X  S C=C+1
 ;W BOMB
 Q C
HEADER ;EP
 G:'APCLPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
HEADER1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",APCLPG,!
 W !,$$CTR("***  SDOH SCREENINGS PATIENT TALLY"_"  ***",80),!
 S X="Screening Dates: "_$$FMTE^XLFDT(APCLBD)_" to "_$$FMTE^XLFDT(APCLED) W $$CTR(X,80),!
 I APCLEXBH S X="This report includes data from the Behavioral Health database." W $$CTR(X,80),!
 I 'APCLEXBH S X="This report excludes data from the Behavioral Health database." W $$CTR(X,80),!
 W !,$TR($J("",80)," ","-")
 ;I '$G(APCLLSTP) W !?46,"#",?53,"% of patients"
 Q
DONE ;
 K ^TMP($J)
 K ^XTMP("APCLHOPA",APCLJ,APCLH)
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
