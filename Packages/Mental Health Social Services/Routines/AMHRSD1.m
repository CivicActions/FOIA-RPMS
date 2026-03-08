AMHRSD1 ; IHS/CMI/LAB - list SDOH SCREENING ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**11,12**;JUN 02, 2010;Build 46
 ;
 ;
INFORM ;
 W !,$$CTR($$USR)
 W !,$$LOC()
 W !!,$$CTR("TALLY AND LISTING OF PATIENTS RECEIVING SDOH SCREENING,INCLUDING REFUSALS",80)
 W !!,"This report will tally all patients who have had SDOH screening "
 W !,"or a refusal documented in the time frame specified by "
 W !,"the user.  SDOH Screening is defined as any of the following documented:"
 W !?5,"- SDOH Food Screening Exam (Exam code 46)"
 W !?5,"- SDOH Housing Screening Exam (Exam code 47)"
 W !?5,"- SDOH Transportation Screening Exam (Exam code 48)"
 W !?5,"- SDOH Utilities Screening Exam (Exam code 49)"
 W !?5,"- SDOH Interpersonal Safety Screening Exam (Exam code 50)"
 W !?5,"- Refusal of exam code 46, 47, 48, 49 50"
 W !,"This report will tally the patients by age groups, gender, screening exam,"
 W !,"result, clinic, Patient Community, Race, Ethnicity."
 W !,"  Notes:  "
 W !?10,"- the last screening/refusal for each patient is used.  If a patient"
 W !?10,"  was screened more than once in the time period, only the latest"
 W !?10,"  is used in this report."
 W !?10,"- this report will optionally, look at both PCC and the Behavioral"
 W !?10,"   Health databases for evidence of screening/refusal"
 W !?10,"- this is a tally of PATIENTS, not visits or screenings"
 W !
 D PAUSE^AMHLEA,DBHUSR^AMHUTIL
 D XIT
 ;
DATES K AMHRED,AMHRBD
 W !,"Please enter the date range during which the screening was done.",!,"To get all screenings ever put in a long date range like 01/01/1980 ",!,"to the present date.",!
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Date for Screening"
 D ^DIR Q:Y<1  S AMHRBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Date for Screening"
 D ^DIR Q:Y<1  S AMHRED=Y
 ;
 I AMHRED<AMHRBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
FAC ;
 K AMHRLOCT
 W ! S DIR(0)="Y",DIR("A")="Include screenings done at ALL locations",DIR("B")="Yes" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) DATES
 I Y=1 G CLINICS
FAC1 ;
 S X="LOCATION OF ENCOUNTER",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"AMHRLOCT(")
 I '$D(AMHRLOCT) G CLINICS
 I $D(AMHRLOCT("*")) K AMHRLOCY
CLINICS ;
 K AMHRCLNT
 W ! S DIR(0)="Y",DIR("A")="Include screenings done in ALL clinics",DIR("B")="Yes" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) FAC
 I Y=1 G EXAMT
CLINIC1 ;
 S X="CLINIC",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"AMHRCLNT(")
 I '$D(AMHRCLNT) G EXAMT
 I $D(AMHRCLNT("*")) K AMHRCLNT
EXAMT ;
 K AMHEXTYP
 S DIR(0)="S^1:All;2:SDOH Food;3:SDOH Housing;4:SDOH Transportation;5:SDOH Utilities;6:SDOH Interpersonal Safety",DIR("A")="Which exam type should be tallied" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DATES
 I Y="" G DATES
 S AMHEXTYP=Y
 ;
TALLY ;which items to tally
 K AMHRTALL
 W !!,"Please select which items you wish to tally on this report:",!
 W !?3,"0)  Do not include any Tallies"
 W !?3,"1)  Gender"
 W !?3,"2)  Age Groupings"
 W !?3,"3)  Clinic"
 W !?3,"4)  Ethnicity"
 W !?3,"5)  Race"
 W !?3,"6)  Patient Community"
 K DIR S DIR(0)="L^0:6",DIR("A")="Which items should be tallied",DIR("B")="" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DATES
 I Y="" G DATES
 I Y[0 K AMHRTALL G EXCL
 S AMHRTALL=Y
 S A=Y,C="" F I=1:1 S C=$P(A,",",I) Q:C=""  S AMHRTALL(C)=""
AGEG ;
 I '$D(AMHRTALL(2)) G EXCL
AGEGRP ;GET AGE GROUPS
 W !!
 D SETBIN
BIN ;
 W !,"The Age Groups to be used are currently defined as:",! D LIST
 S DIR(0)="YO",DIR("A")="Do you wish to modify these age groups",DIR("B")="NO" D ^DIR K DIR
 I $D(DIRUT) S AMHQUIT="" G TALLY
 I Y=0 G EXCL
RUN ;
 K AMHQUIT S AMHRY="",AMHRA=-1 W ! F  D AGE Q:AMHRX=""  I $D(AMHQUIT) G BIN
 D CLOSE I $D(AMHQUIT) G BIN
 D LIST
 G BIN
 ;
AGE ;
 S AMHRX=""
 S DIR(0)="NO^0:150:0",DIR("A")="Enter the starting age of the "_$S(AMHRY="":"first",1:"next")_" age group" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DUOUT)!($D(DTOUT)) S AMHQUIT="" Q
 S AMHRX=Y
 I Y="" Q
 I AMHRX?1.3N,AMHRX>AMHRA D SET Q
 W $C(7) W !,"Make sure the age is higher the beginning age of the previous group.",! G RUN
 ;
SET S AMHRA=AMHRX
 I AMHRY="" S AMHRY=AMHRX Q
 S AMHRY=AMHRY_"-"_(AMHRX-1)_";"_AMHRX
 Q
 ;
CLOSE I AMHRY="" Q
GC ;
 S DIR(0)="NO^0:150:0",DIR("A")="Enter the highest age for the last group" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DUOUT)!($D(DTOUT)) S AMHQUIT="" Q
 S AMHRX=Y I Y="" S AMHRX=199
 I AMHRX?1.3N,AMHRX'<AMHRA S AMHRY=AMHRY_"-"_AMHRX,AMHRBIN=AMHRY Q
 W "  ??",$C(7) G CLOSE
 Q
 ;
LIST ;
 S %=AMHRBIN
 F I=1:1 S X=$P(%,";",I) Q:X=""  W !,$P(X,"-")," - ",$P(X,"-",2)
 W !
 Q
 ;
SETBIN ;
 S AMHRBIN="0-12;13-17;18-64;65-125"
 Q
EXCL ;
 K AMHRBINA
 I '$D(AMHRBIN) D SETBIN
 F I=1:1 S J=$P(AMHRBIN,";",I) Q:J=""  S AMHRBINA(J)=$P(J,"-",1)_U_$P(J,"-",2)
PCC ;
 S AMHREXPC=""
 W !!,"Would you like to include SDOH Screenings documented in the PCC (Patient"
 ;W !,""
 S DIR(0)="Y",DIR("A")="Care Component) clinical database",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DATES
 S AMHREXPC=Y
 ;
DEMO ;
 D DEMOCHK^AMHUTIL1(.AMHDEMO)
 I AMHDEMO=-1 G EXCL
ZIS ;CALL TO XBDBQUE
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 S XBRP="PRINT^AMHRSD1P",XBRC="PROC^AMHRSD1",XBRX="XIT^AMHRSD1",XBNS="AMH"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^AMHRSD1P"")"
 S XBNS="AMH",XBRC="PROC^AMHRSD1",XBRX="XIT^AMHRSD1",XBIOP=0 D ^XBDBQUE
 Q
XIT ;
 D EN^XBVK("AMHR")
 D ^XBFMK
 Q
PROC ;
 S AMHRCNT=0
 S AMHRH=$H,AMHRJ=$J
 K ^XTMP("AMHRSD1",AMHRJ,AMHRH)
 D XTMP^AMHUTIL("AMHRSD1","SDOH SCREENING REPORT")
 ;now go through each patient
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D
 .;I DUZ=6295 Q:DFN'=5989
 .Q:'$$ALLOWP^AMHUTIL(DUZ,DFN)  ;allowed to see this patient?
 .Q:$$DEMO^AMHUTIL1(DFN,$G(AMHDEMO))
 .;GET EACH OF THE 5 SCREENS AND PUT IN ^XTMP
 .D GATHER("FOOD",DFN,AMHRBD,AMHRED,2203,46)  ;2203,46
 .D GATHER("HOUSING",DFN,AMHRBD,AMHRED,2205,47)  ;2205,47
 .D GATHER("TRANSPORTATION",DFN,AMHRBD,AMHRED,2207,48)
 .D GATHER("UTILITIES",DFN,AMHRBD,AMHRED,2209,49)
 .D GATHER("INTERPERSONAL SAFETY",DFN,AMHRBD,AMHRED,2211,50)
 Q
GATHER(SUB,PAT,BDATE,EDATE,BHF,CODE) ;
 NEW RESULT,X,Y,Z,SDATE,E,G,F,I,D,A
 ;first check BH for exam
 ;loop through all of this patient's visits in date range
 NEW SDATE,X,V,D,R,M,E
 S RESULT=""
 S SDATE=9999999-$$FMADD^XLFDT(EDATE,1),SDATE=SDATE_".9999"
 F  S SDATE=$O(^AMHREC("AE",PAT,SDATE)) Q:SDATE'=+SDATE!($P(SDATE,".")>(9999999-BDATE))!(RESULT]"")  D
 .S V=0 F  S V=$O(^AMHREC("AE",PAT,SDATE,V)) Q:V'=+V!(RESULT]"")  D
 ..Q:'$D(^AMHREC(V,0))
 ..Q:'$$ALLOWVI^AMHUTIL(DUZ,V)
 ..S A=$$VALI^XBDIQ1(9002011,V,.04) I $D(AMHRLOCT) Q:A=""  Q:'$D(AMHRLOCT(A))  ;I A,$D(AMHLOCT),'$D(AMHLOCT(A)) Q
 ..S A=$$VALI^XBDIQ1(9002011,V,.25) I $D(AMHRCLNT) Q:A=""  Q:'$D(AMHRCLNT(A))  ;not correct clinic
 ..;get exams
 ..S E=$$VAL^XBDIQ1(9002011,V,BHF)
 ..I E]"" S RESULT=$P($$VALI^XBDIQ1(9002011,V,.01),".")_U_E_U_$S($$VAL^XBDIQ1(9002011,V,.25)]"":$$VAL^XBDIQ1(9002011,V,.25),1:"UNKNOWN")
 I AMHREXPC D  ;now check PCC
 .S X=$$LASTITEM^APCLAPIU(PAT,CODE,"EXAM",BDATE,EDATE,"A")
 .I 'X G PCCREF
 .S A=$$VALI^XBDIQ1(9000010,$P(X,U,4),.06) I $D(AMHRLOCT) Q:A=""  Q:'$D(AMHRLOCT(A))
 .S A=$$VALI^XBDIQ1(9000010,$P(X,U,4),.08) I $D(AMHRCLNT) Q:A=""  Q:'$D(AMHRCLNT(A))
 .I $P(X,U)>$P(RESULT,U,1) S RESULT=$P(X,U)_U_$P(X,U,3)_U_$$CLINIC($P(X,U,4))
PCCREF .;now check REF and UAS in refusal file
 .S F=0,G="" F F=9999999.15  D
 .S I="" F  S I=$O(^AUPNPREF("AA",PAT,F,I)) Q:I=""!(G)  D
 ..I F=9999999.15 S C=$$VAL^XBDIQ1(9999999.15,I,.02)
 ..I C'=CODE Q  ;has to be SDOH
 ..S ID=0 F  S ID=$O(^AUPNPREF("AA",PAT,F,I,ID)) Q:ID=""!(G)  D
 ...S D=9999999-ID,D=$P(D,".")
 ...Q:D<BDATE
 ...Q:D>EDATE
 ...S X=0 F  S X=$O(^AUPNPREF("AA",PAT,F,I,ID,X)) Q:X'=+X!(G)  D
 ....;get snomed reason not done and it must be in one of the subsets
 ....I $$VALI^XBDIQ1(9000022,X,.07)="R" S G=D_U_"PATIENT REFUSED SCREENING^UNKNOWN"_U_$S($$VAL^XBDIQ1(9000022,X,1204)]"":$$VAL^XBDIQ1(9000022,X,1204),1:"UNKNOWN") Q
 ....I $$VALI^XBDIQ1(9000022,X,.07)="U" S G=D_U_"UNABLE TO SCREEN^UNKNOWN"_U_$S($$VAL^XBDIQ1(9000022,X,1204)]"":$$VAL^XBDIQ1(9000022,X,1204),1:"UNKNOWN") Q
 .I $P(G,U)>$P(RESULT,U) S RESULT=G_U_$P(G,U,2)
 Q:RESULT=""
 S $P(^XTMP("AMHRSD1",AMHRJ,AMHRH,SUB),U,1)=$P($G(^XTMP("AMHRSD1",AMHRJ,AMHRH,SUB)),U,1)+1  ;number screened
 S R=$P(RESULT,U,2)
 S P=$S(R="POSITIVE":2,R["NEGATIVE":3,R="PATIENT REFUSED SCREENING":4,R="UNABLE TO SCREEN":5,R="REFERRAL NEEDED":6,1:"")
 I 'P Q  ;HUH
 S $P(^XTMP("AMHRSD1",AMHRJ,AMHRH,SUB),U,P)=$P($G(^XTMP("AMHRSD1",AMHRJ,AMHRH,SUB)),U,P)+1  ;result
 ;patient list
 S V=$S(SUB="FOOD":1,SUB="HOUSING":2,SUB="TRANSPORTATION":3,SUB="UTILITIES":4,SUB="INTERPERSONAL SAFETY":5,1:"")
 I V="" Q  ;HUH
 S $P(^XTMP("AMHRSD1",AMHRJ,AMHRH,"PATS",PAT),U,V)=$$FMTE^XLFDT($P(RESULT,U))_" Result: "_$P(RESULT,U,2)
TALLIES ;
 ;now all tallies
 S G=$$VAL^XBDIQ1(2,PAT,.02)
 I G="" S G="UNKNOWN"
 S ^XTMP("AMHRSD1",AMHRJ,AMHRH,SUB,"GENDER",G)=$G(^XTMP("AMHRSD1",AMHRJ,AMHRH,SUB,"GENDER",G))+1
 ;age
 S A=$$AGE^AUPNPAT(PAT,$P(RESULT,U))
 S AMHRAGE=$$GETAGE(A)
 S ^XTMP("AMHRSD1",AMHRJ,AMHRH,SUB,"AGE",AMHRAGE)=$G(^XTMP("AMHRSD1",AMHRJ,AMHRH,SUB,"AGE",AMHRAGE))+1
 S A=$P(RESULT,U,3)
 S ^XTMP("AMHRSD1",AMHRJ,AMHRH,SUB,"CLINIC",A)=$G(^XTMP("AMHRSD1",AMHRJ,AMHRH,SUB,"CLINIC",A))+1
 S A=$$ETHN^AMHUTIL2(PAT)
 S ^XTMP("AMHRSD1",AMHRJ,AMHRH,SUB,"ETHNICITY",A)=$G(^XTMP("AMHRSD1",AMHRJ,AMHRH,SUB,"ETHNICITY",A))+1
 S A=$$RACE^AMHUTIL2(PAT)
 S ^XTMP("AMHRSD1",AMHRJ,AMHRH,SUB,"RACE",A)=$G(^XTMP("AMHRSD1",AMHRJ,AMHRH,SUB,"RACE",A))+1
 S A=$$COMMRES^AUPNPAT(PAT,"E")
 S ^XTMP("AMHRSD1",AMHRJ,AMHRH,SUB,"COMMUNITY",A)=$G(^XTMP("AMHRSD1",AMHRJ,AMHRH,SUB,"COMMUNITY",A))+1
 Q
 ;
GETAGE(A) ;
 NEW R,L,H,I
 S R=""
 S I="" F  S I=$O(AMHRBINA(I)) Q:I=""!(R]"")  D
 .S L=$P(AMHRBINA(I),U,1)
 .S H=$P(AMHRBINA(I),U,2)
 .I A'<L,A'>H S R=I
 Q R
 ;
CLINIC(V) ;
 NEW Y
 S Y=$$CLINIC^APCLV(V,"E")
 I Y]"" Q Y
 Q "UNKNOWN"
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
