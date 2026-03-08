AMHRDU3 ; IHS/CMI/LAB - list DRUG screenings ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**6,11,12**;JUN 02, 2010;Build 46
 ;
 ;
INFORM ;
 W !,$$CTR($$USR)
 W !,$$CTR($$LOC())
 W !!,$$CTR("LISTING OF PATIENTS RECEIVING DRUG USE SCREENING, INCLUDING REFUSALS",80)
 W !!,"This report lists all patients who have had A DRUG USE screening"
 W !,"or a refusal documented in the time frame specified by the user."
 W !,"Drug Use Screening is defined as any of the following documented:"
 W !?5,"- Unhealthy Drug Screening Exam (Exam code 45)"
 W !?5,"- Measurements: DAST-10"
 W !?5,"- Health Factor categories 4PS, CAGE, CAGE-AID, or NIDA Quick Screen"
 W !?5,"- Any TAPS-Sedative, TAPS-Cannabis, TAPS-Stimulant, TAPS-Opioid, "
 W !?5,"  TAPS-Heroin Health Factor"
 W !?5,"- POV ICD-10: Z02.83 (Encounter for blood-alcohol and blood-drug test)"
 W !?5,"- refusal of exam code 45 (unhealthy drug screen exam)"
 W !,"  Notes:  "
 W !?10,"- this report will optionally, look at both PCC and the Behavioral"
 W !?10,"   Health databases for evidence of screening/refusal"
 W !?10,"- this is a list of patients with all of their screenings"
 D PAUSE^AMHLEA
 W !!,"You will be able to choose the patients by result, age, gender or those",!,"screened in a certain clinic."
 W !
 D DBHUSRP^AMHUTIL,DBHUSR^AMHUTIL,PAUSE^AMHLEA
 D XIT
 ;
DATES K AMHRED,AMHRBD
 W !,"Please enter the date range during which the screening was done.",!,"To get all screenings ever put in a long date range like 01/01/1980",!,"to the present date.",!
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Date for Screening"
 D ^DIR Q:Y<1  S AMHRBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Date for Screening"
 D ^DIR Q:Y<1  S AMHRED=Y
 ;
 I AMHRED<AMHRBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 ;
EXCL ;
 S AMHREXPC=""
 W !!,"Would you like to include screenings documented in non-behavioral health"
 S DIR(0)="Y",DIR("A")="clinics (those documented in PCC)",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DATES
 S AMHREXPC=Y
SEX ;
 S AMHRSEX=""
 S DIR(0)="S^F:FEMALES Only;M:MALES Only;B:Both MALE and FEMALES",DIR("A")="Include which patients in the list",DIR("B")="B" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G EXCL
 S AMHRSEX=Y
 I AMHRSEX="B" S AMHRSEX="MF"
AGE ;Age Screening
 K AMHRAGE,AMHRAGET
 W ! S DIR(0)="YO",DIR("A")="Would you like to restrict the report by Patient age range",DIR("B")="NO"
 S DIR("?")="If you wish to include visits from ALL age ranges, anwser No.  If you wish to list visits for only patients within a particular age range, enter Yes."
 D ^DIR K DIR
 G:$D(DIRUT) SEX
 I 'Y G RESULT
 ;
AGER ;Age Screening
 W !
 S DIR(0)="FO^1:7",DIR("A")="Enter an Age Range (e.g. 5-12,1-1)" D ^DIR
 I Y="" W !!,"No age range entered." G AGE
 I Y'?1.3N1"-"1.3N W !!,$C(7),$C(7),"Enter a numeric range in the format nnn-nnn. e.g. 0-5, 0-99, 5-20." G AGER
 S AMHRAGET=Y
RESULT ;result screenig
 K AMHRREST
 W !!,"You can limit the list to only patients who have had a screening"
 W !,"in the time period on which the result was any of the"
 W !,"following: (e.g. to get only those patients who have had a result of "
 W !,"Positive enter 2.)",!,"All screenings are used in this, not just the last."
 W !?3,"1)  Patients with any NEGATIVE Screening"
 W !?3,"2)  Patients with any POSITIVE Screening"
 W !?3,"3)  Patients who Refused a Screening"
 W !?3,"4)  Patients with an Unable to Screen Screening"
 W !?3,"5)  Patients with a Referral Needed Sreening Result"
 W !?3,"6)  Patients with ANY Screening result (any of the above)"
 W !
 S DIR(0)="N^1:6:",DIR("A")="Which set of patients do you want to list",DIR("B")="6",DIR("?")="'" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G AGE
 I Y="" G AGE
 S AMHRREST=Y
 ;S A=Y,C="" F I=1:1 S C=$P(A,",",I) Q:C=""  S AMHRREST(C)=""
CLINIC ;
 K AMHRCLNT
 W ! S DIR(0)="Y",DIR("A")="Include visits to ALL clinics",DIR("B")="Yes" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) AGE
 I Y=1 G TEMP
CLINIC1 ;
 S X="CLINIC",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"AMHRCLNT(")
 I '$D(AMHRCLNT) G CLINIC
 I $D(AMHRCLNT("*")) K AMHRCLNT
 ;
TEMP ;TEMPLATE OR LIST
 W !!,"This report will list patients by Health Record Number.",!
 ;
DEMO ;
 D DEMOCHK^AMHUTIL1(.AMHDEMO)
 I AMHDEMO=-1 G TEMP
ZIS ;
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 S XBRP="PRINT^AMHRDU3P",XBRC="PROC^AMHRDU31",XBRX="XIT^AMHRDU3",XBNS="AMH"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^AMHRDU3P"")"
 S XBNS="AMH",XBRC="PROC^AMHRDU31",XBRX="XIT^AMHRDU3",XBIOP=0 D ^XBDBQUE
 Q
XIT ;
 D EN^XBVK("AMHR")
 D ^XBFMK
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
