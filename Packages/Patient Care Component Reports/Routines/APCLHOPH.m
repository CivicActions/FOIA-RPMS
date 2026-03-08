APCLHOPH ; IHS/CMI/LAB - SDOH INPATIENT REPORT ;
 ;;2.0;IHS PCC SUITE;**31**;MAY 14, 2009;Build 10
 ;
 ;
START ;EP - called from option
 D XIT
 W:$D(IOF) @IOF
 W !,$$CTR("Inpatient SDOH Report",IOM)
 W !!,"This report will tally inpatients who had all 5 SDOH screenings (Food, Housing,"
 W !,"Transportation, Utilities and Interpersonal Safety) documented by"
 W !,"their discharge date.  NOTE: If a patient has multiple admissions, the last"
 W !,"admission is used in this report.  Only patients 18 and older are included in"
 W !,"this report."
 W !,"You may also request a list of those patients who were not screened for all 5.",!!
LOC ;
 S DIC("A")="Run for which Facility (Hospital): ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA I Y<0 D XIT Q
 S APCLLOC=+Y
DATES ;
 W !!,"Please enter the discharge date range."
BD ;get beginning date
 S DIR(0)="D^:DT:EP",DIR("A")="Enter Beginning Discharge Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S APCBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_APCBD_":DT:EP",DIR("A")="Enter Ending Discharge Date" S Y=APCBD D DD^%DT D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCED=Y
 S X1=APCBD,X2=-1 D C^%DTC S APCSD=X S Y=APCBD D DD^%DT S APCBDD=Y S Y=APCED D DD^%DT S APCEDD=Y
LIST ;
 S APCRLIST=""
 W !
 S DIR(0)="Y",DIR("A")="Would you like to include a list of patients not screened",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DATES
 S APCRLIST=Y
 I 'APCRLIST G DEMO
DEMO ;
 D DEMOCHK^APCLUTL(.APCDEMO)
 I APCDEMO=-1 G LIST
ZIS ;
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 W !! S XBRP="PRINT^APCLHOPH",XBRC="PROC^APCLHOPH",XBNS="APC*",XBRX="XIT^APCLHOPH"
 D ^XBDBQUE
 D XIT
 Q
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^APCLHOPH"")"
 S XBNS="APC",XBRC="PROC^APCLHOPH",XBRX="XIT^APCLHOPH",XBIOP=0 D ^XBDBQUE
 Q
 ;
PROC ;EP - called from xbdbque
 ;loop through all AUPNVINP in date range and look for discharge
 S APCJOB=$J,APCTOT=0,APCBT=$H,APCDTOT=0,APCN1=0
 K ^TMP($J),^XTMP("APCLOPEH",APCJOB,APCBT)
 ;gather up all "last admissions" for each patient
 K APCSDOH
 S APCSDOH("FOOD")="0^0"
 S APCSDOH("HOUSING")="0^0"
 S APCSDOH("TRANSPORTATION")="0^0"
 S APCSDOH("UTILITIES")="0^0"
 S APCSDOH("SAFETY")="0^0"
 D XTMP^APCLOSUT("APCLHOPH","PCC - HOPE INPATIENT REPORT")
 S X1=APCBD,X2=-1 D C^%DTC S APCSD=X
 S APCODAT=APCSD_".9999" F  S APCODAT=$O(^AUPNVINP("B",APCODAT)) Q:APCODAT=""!((APCODAT\1)>APCED)  D
 .S APCR=0 F  S APCR=$O(^AUPNVINP("B",APCODAT,APCR)) Q:APCR'=+APCR  D
 ..Q:'$D(^AUPNVINP(APCR,0))
 ..S APCPAT=$P(^AUPNVINP(APCR,0),U,2) Q:'APCPAT
 ..Q:$$DEMO^APCLUTL(APCPAT,$G(APCDEMO))
 ..S APCVSIT=$P(^AUPNVINP(APCR,0),U,3)
 ..Q:APCVSIT=""
 ..Q:'$D(^AUPNVSIT(APCVSIT,0))
 ..Q:$$AGE^AUPNPAT(APCPAT,$$VD^APCLV(APCVSIT))<18
 ..Q:$P(^AUPNVSIT(APCVSIT,0),U,3)="C"  ;skip contract health
 ..Q:$P(^AUPNVSIT(APCVSIT,0),U,7)="E"  ;skip events
 ..Q:$P(^AUPNVSIT(APCVSIT,0),U,6)'=APCLLOC
 ..S ^XTMP("APCLOPEH",APCJOB,APCBT,"APCADMS",APCPAT)=APCR_U_APCVSIT W ".",APCVSIT
 S APCPAT=0 F  S APCPAT=$O(^XTMP("APCLOPEH",APCJOB,APCBT,"APCADMS",APCPAT)) Q:APCPAT'=+APCPAT  D
 .S APCR=$P(^XTMP("APCLOPEH",APCJOB,APCBT,"APCADMS",APCPAT),U),APCVSIT=$P(^XTMP("APCLOPEH",APCJOB,APCBT,"APCADMS",APCPAT),U,2)
 .D CHK
 Q
CHK ;
 ;check for 1 refusals  
 S APCAD=$$VD^APCLV(APCVSIT)  ;admission date
 S APCDD=$P($P(^AUPNVINP(APCR,0),U,1),".")
 Q:$$REF(APCPAT,APCAD,APCDD)  ;had a refusal during hospital stay so don't count this patient
 S APCDTOT=APCDTOT+1  ;number of patients discharged
 D SDOHSCR
 I APCSCRC<5 D  Q
 .S $P(^XTMP("APCLOPEH",APCJOB,APCBT,"APCADMS",APCPAT),U,3)=0 ;_U_APCSDOH
L S APCN1=APCN1+1
 ;ADD TO TOTALS
 I $P(APCSDOH,U,1)]"" S $P(APCSDOH("FOOD"),U,1)=$P($G(APCSDOH("FOOD")),U,1)+1 I $P(APCSDOH,U,1)="POSITIVE" S $P(APCSDOH("FOOD"),U,2)=$P($G(APCSDOH("FOOD")),U,2)+1
 I $P(APCSDOH,U,2)]"" S $P(APCSDOH("HOUSING"),U,1)=$P($G(APCSDOH("HOUSING")),U,1)+1 I $P(APCSDOH,U,2)="POSITIVE" S $P(APCSDOH("HOUSING"),U,2)=$P($G(APCSDOH("HOUSING")),U,2)+1
 I $P(APCSDOH,U,3)]"" S $P(APCSDOH("TRANSPORTATION"),U,1)=$P($G(APCSDOH("TRANSPORTATION")),U,1)+1 I $P(APCSDOH,U,3)="POSITIVE" S $P(APCSDOH("TRANSPORTATION"),U,2)=$P($G(APCSDOH("TRANSPORTATION")),U,2)+1
 I $P(APCSDOH,U,4)]"" S $P(APCSDOH("UTILITIES"),U,1)=$P($G(APCSDOH("UTILITIES")),U,1)+1 I $P(APCSDOH,U,4)="POSITIVE" S $P(APCSDOH("UTILITIES"),U,2)=$P($G(APCSDOH("UTILITIES")),U,2)+1
 I $P(APCSDOH,U,5)]"" S $P(APCSDOH("SAFETY"),U,1)=$P($G(APCSDOH("SAFETY")),U,1)+1 I $P(APCSDOH,U,5)="POSITIVE" S $P(APCSDOH("SAFETY"),U,2)=$P($G(APCSDOH("SAFETY")),U,2)+1
 Q
REF(P,BD,ED) ;did they have a refusal or unable to screen in BH or PCC refusal file
 NEW F,G,I,C,ID,X
 S F=0,G="" F F=9999999.15  D
 .S I="" F  S I=$O(^AUPNPREF("AA",P,F,I)) Q:I=""!(G)  D
 ..I F=9999999.15 S C=$$VAL^XBDIQ1(9999999.15,I,.02)
 ..I C'=46,C'=47,C'=48,C'=49,C'=50 Q  ;has to be SDOH
 ..S ID=0 F  S ID=$O(^AUPNPREF("AA",P,F,I,ID)) Q:ID=""!(G)  D
 ...S D=9999999-ID,D=$P(D,".")
 ...Q:D<BD
 ...Q:D>ED
 ...S X=0 F  S X=$O(^AUPNPREF("AA",P,F,I,ID,X)) Q:X'=+X!(G)  D
 ....;get snomed reason not done and it must be in one of the subsets
 ....I $$VALI^XBDIQ1(9000022,X,.07)="R" S G=1 Q
 ....I $$VALI^XBDIQ1(9000022,X,.07)="U" S G=1 Q
 I G Q G
 ;check BH
 S G=0
 S APCRSD=$$FMADD^XLFDT(APCAD,-1),APCRSD=APCRSD_".9999"
 F  S APCRSD=$O(^AMHREC("AF",APCPAT,APCRSD)) Q:APCRSD'=+APCRSD!($P(APCRSD,".")>APCDD)  D
 .S APCRBIEN=0 F  S APCRBIEN=$O(^AMHREC("AF",APCPAT,APCRSD,APCRBIEN)) Q:APCRBIEN'=+APCRBIEN  D
 ..S APCRDATE=$P(APCRSD,".")
 ..Q:'$D(^AMHREC(APCRBIEN,0))
 ..S V=$$VAL^XBDIQ1(9002011,APCRBIEN,2203) I V="REF"!(V="UAS") S G=1 Q
 ..S V=$$VAL^XBDIQ1(9002011,APCRBIEN,2205) I V="REF"!(V="UAS") S G=1 Q
 ..S V=$$VAL^XBDIQ1(9002011,APCRBIEN,2207) I V="REF"!(V="UAS") S G=1 Q
 ..S V=$$VAL^XBDIQ1(9002011,APCRBIEN,2209) I V="REF"!(V="UAS") S G=1 Q
 ..S V=$$VAL^XBDIQ1(9002011,APCRBIEN,2211) I V="REF"!(V="UAS") S G=1 Q
 Q G
SDOHSCR ;check for exam from admission to discharge in both pcc and bh
 S APCSDOH=""
 S APCSCRC=0
 S X=$$LASTITEM^APCLAPIU(APCPAT,46,"EXAM",APCAD,APCDD,"A")  ;food
 I X S APCSCRC=APCSCRC+1,$P(APCSDOH,U,1)=$P(X,U,3)
 S X=$$LASTITEM^APCLAPIU(APCPAT,47,"EXAM",APCAD,APCDD,"A")  ;Housing
 I X S APCSCRC=APCSCRC+1,$P(APCSDOH,U,2)=$P(X,U,3)
 S X=$$LASTITEM^APCLAPIU(APCPAT,48,"EXAM",APCAD,APCDD,"A")  ;Transportation
 I X S APCSCRC=APCSCRC+1,$P(APCSDOH,U,3)=$P(X,U,3)
 S X=$$LASTITEM^APCLAPIU(APCPAT,49,"EXAM",APCAD,APCDD,"A")  ;Utilities
 I X S APCSCRC=APCSCRC+1,$P(APCSDOH,U,4)=$P(X,U,3)
 S X=$$LASTITEM^APCLAPIU(APCPAT,50,"EXAM",APCAD,APCDD,"A")  ;Saftey
 I X S APCSCRC=APCSCRC+1,$P(APCSDOH,U,5)=$P(X,U,3)
 I APCSCRC>4 Q  ;had all five
 ;NOW CHECK BH
 S APCRSD=$$FMADD^XLFDT(APCAD,-1),APCRSD=APCRSD_".9999"
 F  S APCRSD=$O(^AMHREC("AF",APCPAT,APCRSD)) Q:APCRSD'=+APCRSD!($P(APCRSD,".")>APCDD)  D
 .S APCRBIEN=0 F  S APCRBIEN=$O(^AMHREC("AF",APCPAT,APCRSD,APCRBIEN)) Q:APCRBIEN'=+APCRBIEN  D
 ..S APCRDATE=$P(APCRSD,".")
 ..Q:'$D(^AMHREC(APCRBIEN,0))
 ..;Q:'$$ALLOWVI^APCUTIL(DUZ,APCRBIEN)
 ..I $P(APCSDOH,U,1)="" S F=$P($G(^AMHREC(APCRBIEN,22)),U,3) I F]"" S V=$$VAL^XBDIQ1(9002011,APCRBIEN,2203) I V'="REF",V'="UAS" S $P(APCSDOH,U,1)=V S APCSCRC=APCSCRC+1
 ..I $P(APCSDOH,U,2)="" S F=$P($G(^AMHREC(APCRBIEN,22)),U,5) I F]"" S V=$$VAL^XBDIQ1(9002011,APCRBIEN,2205) I V'="REF",V'="UAS" S $P(APCSDOH,U,2)=V S APCSCRC=APCSCRC+1
 ..I $P(APCSDOH,U,3)="" S F=$P($G(^AMHREC(APCRBIEN,22)),U,7) I F]"" S V=$$VAL^XBDIQ1(9002011,APCRBIEN,2207) I V'="REF",V'="UAS" S $P(APCSDOH,U,3)=V S APCSCRC=APCSCRC+1
 ..I $P(APCSDOH,U,4)="" S F=$P($G(^AMHREC(APCRBIEN,22)),U,9) I F]"" S V=$$VAL^XBDIQ1(9002011,APCRBIEN,2209) I V'="REF",V'="UAS" S $P(APCSDOH,U,4)=V S APCSCRC=APCSCRC+1
 ..I $P(APCSDOH,U,5)="" S F=$P($G(^AMHREC(APCRBIEN,22)),U,11) I F]"" S V=$$VAL^XBDIQ1(9002011,APCRBIEN,2211) I V'="REF",V'="UAS" S $P(APCSDOH,U,5)=V S APCSCRC=APCSCRC+1
 Q
PRINT ;EP - called from xbdbque
 D PRINT1
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS RETURN" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 K ^XTMP("APCLOPEH",APCJOB,APCBT),APCJOB,APCBT
 Q
PRINT1 ;
 K APCQ S APCPG=0
 D HEADER
 W "SDOH 1: Population-Inpatient Screening",!
 W ?40,"# Patients",?55,"# Patients",?70,"%",!
 W "Measure Name",?40,"w/Admission",?55,"Screened",?70,"Screened",!
 W !,$TR($J(" ",80)," ","_"),!
 W !,"SDOH 1: Population-Inpatient Screening",?40,$$C(APCDTOT,0,6),?55,$$C(APCN1,0,6) W:'APCDTOT ?72,"------",! W:APCDTOT ?71,$J(((APCN1/APCDTOT)*100),6,2),"%",!
 I $Y>(IOSL-15) D HEADER Q:$D(APCQ)
 W !!,"SDOH-2: Population-Inpatient Positive Screening",!
 W ?40,"# Patients",?55,"# Patients",?70,"%",!
 W "Measure Name",?40,"w/Admission",?55,"Screened",?70,"Positive",!
 W !,$TR($J(" ",80)," ","_"),!
 W !,"SDOH-2-SDOH Food",?40,$$C(APCDTOT,0,6),?55,$$C(+$P(APCSDOH("FOOD"),U,1),0,6) D
 .S D=$P(APCSDOH("FOOD"),U,1),N=$P(APCSDOH("FOOD"),U,2)
 .I 'D W ?72,"------",! Q
 .S P=(N/D)*100 W ?71,$J(P,6,2),"%",!
 W !,"SDOH-2-SDOH Housing",?40,$$C(APCDTOT,0,6),?55,$$C(+$P(APCSDOH("HOUSING"),U,1),0,6) D
 .S D=$P(APCSDOH("HOUSING"),U,1),N=$P(APCSDOH("HOUSING"),U,2)
 .I 'D W ?72,"------",! Q
 .S P=(N/D)*100 W ?71,$J(P,6,2),"%",!
 W !,"SDOH-2-SDOH Transportation",?40,$$C(APCDTOT,0,6),?55,$$C(+$P(APCSDOH("TRANSPORTATION"),U,1),0,6) D
 .S D=$P(APCSDOH("TRANSPORTATION"),U,1),N=$P(APCSDOH("TRANSPORTATION"),U,2)
 .I 'D W ?72,"------",! Q
 .S P=(N/D)*100 W ?71,$J(P,6,2),"%",!
 W !,"SDOH-2-SDOH Utilities",?40,$$C(APCDTOT,0,6),?55,$$C(+$P(APCSDOH("UTILITIES"),U,1),0,6) D
 .S D=$P(APCSDOH("UTILITIES"),U,1),N=$P(APCSDOH("UTILITIES"),U,2)
 .I 'D W ?72,"------",! Q
 .S P=(N/D)*100 W ?71,$J(P,6,2),"%",!
 W !,"SDOH-2-SDOH Interpersonal Safety",?40,$$C(APCDTOT,0,6),?55,$$C(+$P(APCSDOH("SAFETY"),U,1),0,6) D
 .S D=$P(APCSDOH("SAFETY"),U,1),N=$P(APCSDOH("SAFETY"),U,2)
 .I 'D W ?72,"------",! Q
 .S P=(N/D)*100 W ?71,$J(P,6,2),"%",!
 I 'APCRLIST Q  ;no list
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCQ="" Q
 D HEADER2
 S APCPAT="" F  S APCPAT=$O(^XTMP("APCLOPEH",APCJOB,APCBT,"APCADMS",APCPAT)) Q:APCPAT=""!($D(APCQ))  D
 .Q:$P(^XTMP("APCLOPEH",APCJOB,APCBT,"APCADMS",APCPAT),U,3)'=0
 .S APCR=$P(^XTMP("APCLOPEH",APCJOB,APCBT,"APCADMS",APCPAT),U,1),APCVSIT=$P(^XTMP("APCLOPEH",APCJOB,APCBT,"APCADMS",APCPAT),U,2)
 .I $Y>(IOSL-3) D HEADER2 Q:$D(APCQ)
 .S DFN=$P(^AUPNVSIT(APCVSIT,0),U,5)
 .W !,$E($P(^DPT(DFN,0),U),1,30),?32,$$HRN^AUPNPAT(DFN,DUZ(2)),?44,$$VAL^XBDIQ1(9000010,APCVSIT,.01)
 Q
XIT ;
 D EN^XBVK("APC")
 D KILL^AUPNPAT
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
HEADER ;EP
 I 'APCPG G HEADER1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCQ="" Q
HEADER1 ;
 W:$D(IOF) @IOF S APCPG=APCPG+1
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),?($S(80=132:120,1:72)),"Page ",APCPG,!
 W $$CTR("SDOH Inpatient Screening Population Reports",80),!
 W $$CTR("Screening Dates: "_$$FMTE^XLFDT(APCBD)_" to "_$$FMTE^XLFDT(APCED),80),!
 W $$CTR("This report includes recorded screenings from the PCC clinical database",80),!
 W $$CTR("and the Behavioral Health database.",80),!
 W !,$TR($J(" ",80)," ","_"),!
 Q
HEADER2 ;
 S APCLPG=0
 I 'APCLPG G HEADER3
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCQ="" Q
HEADER3 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),?($S(80=132:120,1:72)),"Page ",APCLPG,!
 S APCTEXT="Patients Admitted to the Hospital without SDOH Screening"
 W !?(80-$L(APCTEXT)/2),APCTEXT,!
 W $$CTR("Screening Dates: "_$$FMTE^XLFDT(APCBD)_" to "_$$FMTE^XLFDT(APCED),80),!
 W $$CTR("This report includes recorded screenings from the PCC clinical database",80),!
 W $$CTR("and the Behavioral Health database.",80),!
 W $TR($J(" ",80)," ","_"),!
 W !,"PATIENT NAME",?32,"HRN",?44,"ADMISSION DATE",!
 W $TR($J(" ",80)," ","-")
 Q
