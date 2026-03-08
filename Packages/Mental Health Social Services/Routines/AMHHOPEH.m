AMHHOPEH ; IHS/CMI/LAB - SDOH INPATIENT REPORT ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**12**;JUN 02, 2010;Build 46
 ;
 ;
START ;EP - called from option
 D XIT
 W:$D(IOF) @IOF
 W !,$$CTR("Inpatient SDOH Report",IOM)
 W !!,"This report will tally inpatients who had all 5 SDOH screenings (Food, Housing,"
 W !,"Transportation, Utilities and Interpersonal Safety) documented by"
 W !,"their discharge date.  NOTE: If a patient has multiple admissions, the last"
 W !,"admission is used in this report."
 W !,"You may also request a list of those patients who were not screened for all 5."
 D DBHUSR^AMHUTIL
LOC ;
 ;S DIC("A")="Run for which Facility (Hospital): ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 END
 ;S APCLLOC=+Y
DATES ;
 W !!,"Please enter the discharge date range."
BD ;get beginning date
 S DIR(0)="D^:DT:EP",DIR("A")="Enter Beginning Discharge Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S AMHBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_AMHBD_":DT:EP",DIR("A")="Enter Ending Discharge Date" S Y=AMHBD D DD^%DT D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S AMHED=Y
 S X1=AMHBD,X2=-1 D C^%DTC S AMHSD=X S Y=AMHBD D DD^%DT S AMHBDD=Y S Y=AMHED D DD^%DT S AMHEDD=Y
LIST ;
 S AMHRLIST=""
 W !
 S DIR(0)="Y",DIR("A")="Would you like to include a list of patients not screened",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DATES
 S AMHRLIST=Y
 I 'AMHRLIST G DEMO
DEMO ;
 D DEMOCHK^AMHUTIL1(.AMHDEMO)
 I AMHDEMO=-1 G LIST
ZIS ;
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 W !! S XBRP="PRINT^AMHHOPEH",XBRC="PROC^AMHHOPEH",XBNS="AMH*",XBRX="XIT^AMHHOPEH"
 D ^XBDBQUE
 D XIT
 Q
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^AMHHOPEH"")"
 S XBNS="AMH",XBRC="PROC^AMHHOPEH",XBRX="XIT^AMHHOPEH",XBIOP=0 D ^XBDBQUE
 Q
 ;
PROC ;EP - called from xbdbque
 ;loop through all AUPNVINP in date range and look for discharge
 S AMHJOB=$J,AMHTOT=0,AMHBT=$H,AMHDTOT=0,AMHN1=0
 K ^TMP($J),^XTMP("AMHHOPEH",AMHJOB,AMHBT)
 ;gather up all "last admissions" for each patient
 K AMHSDOH
 S AMHSDOH("FOOD")="0^0"
 S AMHSDOH("HOUSING")="0^0"
 S AMHSDOH("TRANSPORTATION")="0^0"
 S AMHSDOH("UTILITIES")="0^0"
 S AMHSDOH("SAFETY")="0^0"
 D XTMP^AMHUTIL("AMHHOPEH","BH - HOPE INPATIENT REPORT")
 S X1=AMHBD,X2=-1 D C^%DTC S AMHSD=X
 S AMHODAT=AMHSD_".9999" F  S AMHODAT=$O(^AUPNVINP("B",AMHODAT)) Q:AMHODAT=""!((AMHODAT\1)>AMHED)  D
 .S AMHR=0 F  S AMHR=$O(^AUPNVINP("B",AMHODAT,AMHR)) Q:AMHR'=+AMHR  D
 ..Q:'$D(^AUPNVINP(AMHR,0))
 ..S AMHPAT=$P(^AUPNVINP(AMHR,0),U,2) Q:'AMHPAT
 ..Q:'$$ALLOWP^AMHUTIL(DUZ,AMHPAT)
 ..Q:$$DEMO^AMHUTIL1(AMHPAT,$G(AMHDEMO))
 ..S AMHVSIT=$P(^AUPNVINP(AMHR,0),U,3)
 ..Q:'$D(^AUPNVSIT(AMHVSIT,0))
 ..Q:$$AGE^AUPNPAT(AMHPAT,$$VD^APCLV(AMHVSIT))<18
 ..Q:$P(^AUPNVSIT(AMHVSIT,0),U,3)="C"  ;skip contract health
 ..Q:$P(^AUPNVSIT(AMHVSIT,0),U,7)="E"  ;skip events
 ..S ^XTMP("AMHHOPEH",AMHJOB,AMHBT,"AMHADMS",AMHPAT)=AMHR_U_AMHVSIT
 S AMHPAT=0 F  S AMHPAT=$O(^XTMP("AMHHOPEH",AMHJOB,AMHBT,"AMHADMS",AMHPAT)) Q:AMHPAT'=+AMHPAT  D
 .S AMHR=$P(^XTMP("AMHHOPEH",AMHJOB,AMHBT,"AMHADMS",AMHPAT),U),AMHVSIT=$P(^XTMP("AMHHOPEH",AMHJOB,AMHBT,"AMHADMS",AMHPAT),U,2)
 .D CHK
 Q
CHK ;
 ;check for 1 refusals  
 S AMHAD=$$VD^APCLV(AMHVSIT)  ;admission date
 S AMHDD=$P($P(^AUPNVINP(AMHR,0),U,1),".")
 Q:$$REF(AMHPAT,AMHAD,AMHDD)  ;had a refusal during hospital stay so don't count this patient
 S AMHDTOT=AMHDTOT+1  ;number of patients discharged
 D SDOHSCR
 I AMHSCRC<5 D  Q
 .S $P(^XTMP("AMHHOPEH",AMHJOB,AMHBT,"AMHADMS",AMHPAT),U,3)=0 ;_U_AMHSDOH
L S AMHN1=AMHN1+1
 ;ADD TO TOTALS
 I $P(AMHSDOH,U,1)]"" S $P(AMHSDOH("FOOD"),U,1)=$P($G(AMHSDOH("FOOD")),U,1)+1 I $P(AMHSDOH,U,1)="POSITIVE" S $P(AMHSDOH("FOOD"),U,2)=$P($G(AMHSDOH("FOOD")),U,2)+1
 I $P(AMHSDOH,U,2)]"" S $P(AMHSDOH("HOUSING"),U,1)=$P($G(AMHSDOH("HOUSING")),U,1)+1 I $P(AMHSDOH,U,2)="POSITIVE" S $P(AMHSDOH("HOUSING"),U,2)=$P($G(AMHSDOH("HOUSING")),U,2)+1
 I $P(AMHSDOH,U,3)]"" S $P(AMHSDOH("TRANSPORTATION"),U,1)=$P($G(AMHSDOH("TRANSPORTATION")),U,1)+1 I $P(AMHSDOH,U,3)="POSITIVE" S $P(AMHSDOH("TRANSPORTATION"),U,2)=$P($G(AMHSDOH("TRANSPORTATION")),U,2)+1
 I $P(AMHSDOH,U,4)]"" S $P(AMHSDOH("UTILITIES"),U,1)=$P($G(AMHSDOH("UTILITIES")),U,1)+1 I $P(AMHSDOH,U,4)="POSITIVE" S $P(AMHSDOH("UTILITIES"),U,2)=$P($G(AMHSDOH("UTILITIES")),U,2)+1
 I $P(AMHSDOH,U,5)]"" S $P(AMHSDOH("SAFETY"),U,1)=$P($G(AMHSDOH("SAFETY")),U,1)+1 I $P(AMHSDOH,U,5)="POSITIVE" S $P(AMHSDOH("SAFETY"),U,2)=$P($G(AMHSDOH("SAFETY")),U,2)+1
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
 S AMHRSD=$$FMADD^XLFDT(AMHAD,-1),AMHRSD=AMHRSD_".9999"
 F  S AMHRSD=$O(^AMHREC("AF",AMHPAT,AMHRSD)) Q:AMHRSD'=+AMHRSD!($P(AMHRSD,".")>AMHDD)  D
 .S AMHRBIEN=0 F  S AMHRBIEN=$O(^AMHREC("AF",AMHPAT,AMHRSD,AMHRBIEN)) Q:AMHRBIEN'=+AMHRBIEN  D
 ..S AMHRDATE=$P(AMHRSD,".")
 ..Q:'$D(^AMHREC(AMHRBIEN,0))
 ..S V=$$VAL^XBDIQ1(9002011,AMHRBIEN,2203) I V="REF"!(V="UAS") S G=1 Q
 ..S V=$$VAL^XBDIQ1(9002011,AMHRBIEN,2205) I V="REF"!(V="UAS") S G=1 Q
 ..S V=$$VAL^XBDIQ1(9002011,AMHRBIEN,2207) I V="REF"!(V="UAS") S G=1 Q
 ..S V=$$VAL^XBDIQ1(9002011,AMHRBIEN,2209) I V="REF"!(V="UAS") S G=1 Q
 ..S V=$$VAL^XBDIQ1(9002011,AMHRBIEN,2211) I V="REF"!(V="UAS") S G=1 Q
 Q G
SDOHSCR ;check for exam from admission to discharge in both pcc and bh
 S AMHSDOH=""
 S AMHSCRC=0
 S X=$$LASTITEM^APCLAPIU(AMHPAT,46,"EXAM",AMHAD,AMHDD,"A")  ;food
 I X S AMHSCRC=AMHSCRC+1,$P(AMHSDOH,U,1)=$P(X,U,3)
 S X=$$LASTITEM^APCLAPIU(AMHPAT,47,"EXAM",AMHAD,AMHDD,"A")  ;Housing
 I X S AMHSCRC=AMHSCRC+1,$P(AMHSDOH,U,2)=$P(X,U,3)
 S X=$$LASTITEM^APCLAPIU(AMHPAT,48,"EXAM",AMHAD,AMHDD,"A")  ;Transportation
 I X S AMHSCRC=AMHSCRC+1,$P(AMHSDOH,U,3)=$P(X,U,3)
 S X=$$LASTITEM^APCLAPIU(AMHPAT,49,"EXAM",AMHAD,AMHDD,"A")  ;Utilities
 I X S AMHSCRC=AMHSCRC+1,$P(AMHSDOH,U,4)=$P(X,U,3)
 S X=$$LASTITEM^APCLAPIU(AMHPAT,50,"EXAM",AMHAD,AMHDD,"A")  ;Saftey
 I X S AMHSCRC=AMHSCRC+1,$P(AMHSDOH,U,5)=$P(X,U,3)
 I AMHSCRC>4 Q  ;had all five
 ;NOW CHECK BH
 S AMHRSD=$$FMADD^XLFDT(AMHAD,-1),AMHRSD=AMHRSD_".9999"
 F  S AMHRSD=$O(^AMHREC("AF",AMHPAT,AMHRSD)) Q:AMHRSD'=+AMHRSD!($P(AMHRSD,".")>AMHDD)  D
 .S AMHRBIEN=0 F  S AMHRBIEN=$O(^AMHREC("AF",AMHPAT,AMHRSD,AMHRBIEN)) Q:AMHRBIEN'=+AMHRBIEN  D
 ..S AMHRDATE=$P(AMHRSD,".")
 ..Q:'$D(^AMHREC(AMHRBIEN,0))
 ..Q:'$$ALLOWVI^AMHUTIL(DUZ,AMHRBIEN)
 ..I $P(AMHSDOH,U,1)="" S F=$P($G(^AMHREC(AMHRBIEN,22)),U,3) I F]"" S V=$$VAL^XBDIQ1(9002011,AMHRBIEN,2203) I V'="REF",V'="UAS" S $P(AMHSDOH,U,1)=V S AMHSCRC=AMHSCRC+1
 ..I $P(AMHSDOH,U,2)="" S F=$P($G(^AMHREC(AMHRBIEN,22)),U,5) I F]"" S V=$$VAL^XBDIQ1(9002011,AMHRBIEN,2205) I V'="REF",V'="UAS" S $P(AMHSDOH,U,2)=V S AMHSCRC=AMHSCRC+1
 ..I $P(AMHSDOH,U,3)="" S F=$P($G(^AMHREC(AMHRBIEN,22)),U,7) I F]"" S V=$$VAL^XBDIQ1(9002011,AMHRBIEN,2207) I V'="REF",V'="UAS" S $P(AMHSDOH,U,3)=V S AMHSCRC=AMHSCRC+1
 ..I $P(AMHSDOH,U,4)="" S F=$P($G(^AMHREC(AMHRBIEN,22)),U,9) I F]"" S V=$$VAL^XBDIQ1(9002011,AMHRBIEN,2209) I V'="REF",V'="UAS" S $P(AMHSDOH,U,4)=V S AMHSCRC=AMHSCRC+1
 ..I $P(AMHSDOH,U,5)="" S F=$P($G(^AMHREC(AMHRBIEN,22)),U,11) I F]"" S V=$$VAL^XBDIQ1(9002011,AMHRBIEN,2211) I V'="REF",V'="UAS" S $P(AMHSDOH,U,5)=V S AMHSCRC=AMHSCRC+1
 Q
PRINT ;EP - called from xbdbque
 D PRINT1
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS RETURN" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 K ^XTMP("AMHHOPEH",AMHJOB,AMHBT),AMHJOB,AMHBT
 Q
PRINT1 ;
 K AMHQ S AMHPG=0
 D HEADER
 W "SDOH 1: Population-Inpatient Screening",!
 W ?40,"# Patients",?55,"# Patients",?70,"%",!
 W "Measure Name",?40,"w/Admission",?55,"Screened",?70,"Screened",!
 W !,$TR($J(" ",80)," ","_"),!
 W !,"SDOH 1: Population-Inpatient Screening",?40,$$C(AMHDTOT,0,6),?55,$$C(AMHN1,0,6) W:'AMHDTOT ?72,"------",! W:AMHDTOT ?71,$J(((AMHN1/AMHDTOT)*100),6,2),"%",!
 I $Y>(IOSL-15) D HEADER Q:$D(AMHQ)
 W !!,"SDOH-2: Population-Inpatient Positive Screening",!
 W ?40,"# Patients",?55,"# Patients",?70,"%",!
 W "Measure Name",?40,"w/Admission",?55,"Screened",?70,"Positive",!
 W !,$TR($J(" ",80)," ","_"),!
 W !,"SDOH-2-SDOH Food",?40,$$C(AMHDTOT,0,6),?55,$$C(+$P(AMHSDOH("FOOD"),U,1),0,6) D
 .S D=$P(AMHSDOH("FOOD"),U,1),N=$P(AMHSDOH("FOOD"),U,2)
 .I 'D W ?72,"------",! Q
 .S P=(N/D)*100 W ?71,$J(P,6,2),"%",!
 W !,"SDOH-2-SDOH Housing",?40,$$C(AMHDTOT,0,6),?55,$$C(+$P(AMHSDOH("HOUSING"),U,1),0,6) D
 .S D=$P(AMHSDOH("HOUSING"),U,1),N=$P(AMHSDOH("HOUSING"),U,2)
 .I 'D W ?72,"------",! Q
 .S P=(N/D)*100 W ?71,$J(P,6,2),"%",!
 W !,"SDOH-2-SDOH Transportation",?40,$$C(AMHDTOT,0,6),?55,$$C(+$P(AMHSDOH("TRANSPORTATION"),U,1),0,6) D
 .S D=$P(AMHSDOH("TRANSPORTATION"),U,1),N=$P(AMHSDOH("TRANSPORTATION"),U,2)
 .I 'D W ?72,"------",! Q
 .S P=(N/D)*100 W ?71,$J(P,6,2),"%",!
 W !,"SDOH-2-SDOH Utilities",?40,$$C(AMHDTOT,0,6),?55,$$C(+$P(AMHSDOH("UTILITIES"),U,1),0,6) D
 .S D=$P(AMHSDOH("UTILITIES"),U,1),N=$P(AMHSDOH("UTILITIES"),U,2)
 .I 'D W ?72,"------",! Q
 .S P=(N/D)*100 W ?71,$J(P,6,2),"%",!
 W !,"SDOH-2-SDOH Interpersonal Safety",?40,$$C(AMHDTOT,0,6),?55,$$C(+$P(AMHSDOH("SAFETY"),U,1),0,6) D
 .S D=$P(AMHSDOH("SAFETY"),U,1),N=$P(AMHSDOH("SAFETY"),U,2)
 .I 'D W ?72,"------",! Q
 .S P=(N/D)*100 W ?71,$J(P,6,2),"%",!
 I 'AMHRLIST Q  ;no list
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQ="" Q
 D HEADER2
 S AMHPAT="" F  S AMHPAT=$O(^XTMP("AMHHOPEH",AMHJOB,AMHBT,"AMHADMS",AMHPAT)) Q:AMHPAT=""!($D(AMHQ))  D
 .Q:$P(^XTMP("AMHHOPEH",AMHJOB,AMHBT,"AMHADMS",AMHPAT),U,3)'=0
 .S AMHR=$P(^XTMP("AMHHOPEH",AMHJOB,AMHBT,"AMHADMS",AMHPAT),U,1),AMHVSIT=$P(^XTMP("AMHHOPEH",AMHJOB,AMHBT,"AMHADMS",AMHPAT),U,2)
 .I $Y>(IOSL-3) D HEADER2 Q:$D(AMHQ)
 .S DFN=$P(^AUPNVSIT(AMHVSIT,0),U,5)
 .W !,$E($P(^DPT(DFN,0),U),1,30),?32,$$HRN^AUPNPAT(DFN,DUZ(2)),?44,$$VAL^XBDIQ1(9000010,AMHVSIT,.01)
 Q
XIT ;
 D EN^XBVK("AMH")
 D KILL^AUPNPAT
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
HEADER ;EP
 I 'AMHPG G HEADER1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQ="" Q
HEADER1 ;
 W:$D(IOF) @IOF S AMHPG=AMHPG+1
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),?($S(80=132:120,1:72)),"Page ",AMHPG,!
 W $$CTR("SDOH Inpatient Screening Population Reports",80),!
 W $$CTR("Screening Dates: "_$$FMTE^XLFDT(AMHBD)_" to "_$$FMTE^XLFDT(AMHED),80),!
 W $$CTR("This report includes data from the PCC clinical database",80),!
 W !,$TR($J(" ",80)," ","_"),!
 Q
HEADER2 ;
 S AMHLPG=0
 I 'AMHLPG G HEADER3
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQ="" Q
HEADER3 ;
 W:$D(IOF) @IOF S AMHLPG=AMHLPG+1
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),?($S(80=132:120,1:72)),"Page ",AMHLPG,!
 S AMHTEXT="Patients Admitted to the Hospital without SDOH Screening"
 W !?(80-$L(AMHTEXT)/2),AMHTEXT,!
 W $$CTR("Screening Dates: "_$$FMTE^XLFDT(AMHBD)_" to "_$$FMTE^XLFDT(AMHED),80),!
 W $$CTR("This report includes data from the PCC clinical database",80),!
 W $TR($J(" ",80)," ","_"),!
 W !,"PATIENT NAME",?32,"HRN",?44,"ADMISSION DATE",!
 W $TR($J(" ",80)," ","-")
 Q
