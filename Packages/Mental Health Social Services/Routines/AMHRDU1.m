AMHRDU1 ; IHS/CMI/LAB - list ALCOHOL ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**12**;JUN 02, 2010;Build 46
 ;
 ;
INFORM ;
 W !,$$CTR($$USR)
 W !,$$LOC()
 W !!,$$CTR("TALLY AND LISTING OF PATIENTS RECEIVING DRUG USE SCREENING,INCLUDING REFUSALS",80)
 W !!,"This report will tally all patients who have had a DRUG USE "
 W !,"screening or a refusal documented in the time frame specified by "
 W !,"the user.  Drug Use Screening is defined as any of the following documented:"
 W !?5,"- Unhealthy Drug Screening Exam (Exam code 45)"
 W !?5,"- Measurements: DAST-10"
 W !?5,"- Health Factor categories 4PS, CAGE, CAGE-AID, or NIDA Quick Screen"
 W !?5,"- Any TAPS-Sedative, TAPS-Cannabis, TAPS-Stimulant, TAPS-Opioid, "
 W !?5,"  TAPS-Heroin Health Factor"
 W !?5,"- POV ICD-10: Z02.83 (Encounter for blood-alcohol and blood-drug test)"
 W !?5,"- refusal of exam code 45"
 W !,"This report will tally the patients by age groups, gender, "
 W !,"screening exam result, clinic, Patient Community, Race, Ethnicity."
 W !,"   Notes:  "
 W !?10,"- the last screening/refusal for each patient is used.  "
 W !?10,"  If a patient was screened more than once in the time period, "
 W !?10,"  only the latest is used in this report."
 W !?10,"- this report will optionally, look at both PCC and the Behavioral"
 W !?10,"   Health databases for evidence of screening/refusal"
 W !?10,"- this is a tally of Patients, not visits or screenings"
 W !
 D PAUSE^AMHLEA,DBHUSR^AMHUTIL
 D XIT
 S AMHREXC=$O(^AUTTEXAM("C",45,0))
 I 'AMHREXC W !!,"Exam code 45 is missing from the EXAM table.  Cannot run report.",! H 3 D XIT Q
 ;
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
 ;
TALLY ;which items to tally
 K AMHRTALL
 W !!,"Please select which items you wish to tally on this report:",!
 W !?3,"0)  Do not include any Tallies"
 W !?3,"1)  Result"
 W !?3,"2)  Gender"
 W !?3,"3)  Age Groupings"
 W !?3,"4)  Clinic"
 W !?3,"5)  Ethnicity"
 W !?3,"6)  Race"
 W !?3,"7)  Patient Community"
 K DIR S DIR(0)="L^0:7",DIR("A")="Which items should be tallied",DIR("B")="" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DATES
 I Y="" G DATES
 I Y[0 K AMHRTALL G EXCL
 S AMHRTALL=Y
 S A=Y,C="" F I=1:1 S C=$P(A,",",I) Q:C=""  S AMHRTALL(C)=""
AGEG ;
 I '$D(AMHRTALL(3)) G EXCL
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
 S AMHREXPC=""
 W !!,"Would you like to include DRUG Use Screenings documented in the PCC clinical"
 S DIR(0)="Y",DIR("A")="database",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DATES
 S AMHREXPC=Y
DEMO ;
 D DEMOCHK^AMHUTIL1(.AMHDEMO)
 I AMHDEMO=-1 G EXCL
ZIS ;CALL TO XBDBQUE
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 S XBRP="PRINT^AMHRDU1P",XBRC="PROC^AMHRDU1",XBRX="XIT^AMHRDU1",XBNS="AMH"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^AMHRDU1P"")"
 S XBNS="AMH",XBRC="PROC^AMHRDU1",XBRX="XIT^AMHRDU1",XBIOP=0 D ^XBDBQUE
 Q
XIT ;
 D EN^XBVK("AMHR")
 D ^XBFMK
 Q
PROC ;
 S AMHRCNT=0
 S AMHRH=$H,AMHRJ=$J
 K ^XTMP("AMHRDU1",AMHRJ,AMHRH)
 D XTMP^AMHUTIL("AMHRDU1","DURG USE SCREENING REPORT")
 ;now go through BH
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D
 .Q:'$$ALLOWP^AMHUTIL(DUZ,DFN)  ;allowed to see this patient?
 .Q:$$DEMO^AMHUTIL1(DFN,$G(AMHDEMO))
 .S AMHALSC=$$BHALCS(DFN,AMHRBD,AMHRED),AMHPFI="BH"  ;include refusals
 .S AMHPCALS="" I AMHREXPC S AMHPCALS=$$PCCALCS(DFN,AMHRBD,AMHRED)  ;include refusals
 .I $P(AMHPCALS,U,1)>$P(AMHALSC,U,1) S AMHALSC=AMHPCALS,AMHPFI="PCC"
 .S AMHREFS="" I AMHREXPC S AMHREFS=$$REFUSAL(DFN,9999999.15,$O(^AUTTEXAM("C",45,0)),AMHRBD,AMHRED)
 .I $P(AMHREFS,U,1)>$P(AMHALSC,U,1) S AMHALSC=AMHREFS,AMHPFI="PCC"
 .I AMHALSC="" Q  ;no screenings
 .S ^XTMP("AMHRDU1",AMHRJ,AMHRH,"PTS",DFN)=AMHALSC,$P(^XTMP("AMHRDU1",AMHRJ,AMHRH,"PTS",DFN),U,20)=AMHPFI
 .S $P(^XTMP("AMHRDU1",AMHRJ,AMHRH,"PTS",DFN),U,25)=$$RACE^AMHUTIL2(DFN)
 .S $P(^XTMP("AMHRDU1",AMHRJ,AMHRH,"PTS",DFN),U,26)=$$ETHN^AMHUTIL2(DFN)
 .S $P(^XTMP("AMHRDU1",AMHRJ,AMHRH,"PTS",DFN),U,27)=$$COMMRES^AUPNPAT(DFN,"E")
 Q
 ;
BHPPNAME(R) ;EP primary provider internal # from 200
 NEW %,%1
 S %=0,%1="" F  S %=$O(^AMHRPROV("AD",R,%)) Q:%'=+%  I $P(^AMHRPROV(%,0),U,4)="P" S %1=$P(^AMHRPROV(%,0),U),%1=$P($G(^VA(200,%1,0)),U)
 I %1]"" Q %1
 Q "UNKNOWN"
SPRV(E) ;
 I $P($G(^AUPNVXAM(E,12)),U,4) Q $$VAL^XBDIQ1(9000010.13,E,1204)
 Q "UNKNOWN"
PRVREF(R) ;
 I $P($G(^AUPNPREF(R,12)),U,4)]"" Q $$VAL^XBDIQ1(9000022,R,1204)
 Q "UNKNOWN"
PPV(V) ;
 NEW %
 S %=$$PRIMPROV^APCLV(V)
 I %]"" Q %
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
 ;----------
BHALCS(P,BDATE,EDATE) ;EP - pass back last BH screening
 I '$G(P) Q ""
 I '$G(BDATE) Q ""
 I '$G(EDATE) Q ""
 ;loop through all of this patient's visits in date range
 NEW SDATE,X,V,D,R,M,E
 S R=""
 S SDATE=9999999-$$FMADD^XLFDT(EDATE,1),SDATE=SDATE_".9999"
 F  S SDATE=$O(^AMHREC("AE",P,SDATE)) Q:SDATE'=+SDATE!($P(SDATE,".")>(9999999-BDATE))!(R]"")  D
 .S V=0 F  S V=$O(^AMHREC("AE",P,SDATE,V)) Q:V'=+V!(R]"")  D
 ..Q:'$D(^AMHREC(V,0))
 ..Q:'$$ALLOWVI^AMHUTIL(DUZ,V)
 ..;get exam
 ..S E=$P($G(^AMHREC(V,22)),U,1)
 ..I E["REFUSED" S E="PATIENT REFUSED"
 ..I E]"" S R=$$BHRT(V,"UNHEALTHY DRUG SCREENING EXAM",$$VAL^XBDIQ1(9002011,V,2201),P,$P($G(^AMHREC(V,22)),U,2),$P($G(^AMHREC(V,23)),U,1))
 ..I R]"" Q
 ..;get measurements DAST-10
 ..S X=0 F  S X=$O(^AMHRMSR("AD",V,X)) Q:X'=+X!(R]"")  D
 ...S M=$$VAL^XBDIQ1(9002011.12,X,.01)
 ...S S=$$VAL^XBDIQ1(9002011.12,X,.04)
 ...S S=$S(S>1:"POSITIVE",1:"NEGATIVE")
 ...I M="DA10" S R=$$BHRT(V,"DAST-10 (Score: "_$P(^AMHRMSR(X,0),U,4)_")",S,P,$$VALI^XBDIQ1(9002011.12,X,1204))
 ..I R]"" Q
 ..;HEALTH FACTORS 4PS, CAGE, CAGE-AID, NIDA, TAPS
 ..S X=0 F  S X=$O(^AMHRHF("AD",V,X)) Q:X'=+X!(R]"")  D
 ...S M=$$VALI^XBDIQ1(9002011.08,X,.01) D
 ....I $P(^AUTTHF($P(^AUTTHF(M,0),U,3),0),U,2)="C001" S R=$$BHRT(V,$$VAL^XBDIQ1(9002011.08,X,.01),"",P,$$VALI^XBDIQ1(9002011.08,X,.05),$P($G(^AMHRHF(V,811)),U,1)) Q
 ....I $P(^AUTTHF($P(^AUTTHF(M,0),U,3),0),U,2)="C023" S R=$$BHRT(V,$$VAL^XBDIQ1(9002011.08,X,.01),"",P,$$VALI^XBDIQ1(9002011.08,X,.05),$P($G(^AMHRHF(V,811)),U,1)) Q
 ....I $P(^AUTTHF($P(^AUTTHF(M,0),U,3),0),U,2)="C024" S R=$$BHRT(V,$$VAL^XBDIQ1(9002011.08,X,.01),"",P,$$VALI^XBDIQ1(9002011.08,X,.05),$P($G(^AMHRHF(V,811)),U,1)) Q
 ....I $P(^AUTTHF($P(^AUTTHF(M,0),U,3),0),U,2)="C036" S R=$$BHRT(V,$$VAL^XBDIQ1(9002011.08,X,.01),"",P,$$VALI^XBDIQ1(9002011.08,X,.05),$P($G(^AMHRHF(V,811)),U,1)) Q
 ....I $P(^AUTTHF($P(^AUTTHF(M,0),U,3),0),U,2)="C030" S R=$$BHRT(V,$$VAL^XBDIQ1(9002011.08,X,.01),"",P,$$VALI^XBDIQ1(9002011.08,X,.05),$P($G(^AMHRHF(V,811)),U,1)) Q
 ....I $P(^AUTTHF($P(^AUTTHF(M,0),U,3),0),U,2)="C031" S R=$$BHRT(V,$$VAL^XBDIQ1(9002011.08,X,.01),"",P,$$VALI^XBDIQ1(9002011.08,X,.05),$P($G(^AMHRHF(V,811)),U,1)) Q
 ....I $P(^AUTTHF($P(^AUTTHF(M,0),U,3),0),U,2)="C032" S R=$$BHRT(V,$$VAL^XBDIQ1(9002011.08,X,.01),"",P,$$VALI^XBDIQ1(9002011.08,X,.05),$P($G(^AMHRHF(V,811)),U,1)) Q
 ....I $P(^AUTTHF($P(^AUTTHF(M,0),U,3),0),U,2)="C033" S R=$$BHRT(V,$$VAL^XBDIQ1(9002011.08,X,.01),"",P,$$VALI^XBDIQ1(9002011.08,X,.05),$P($G(^AMHRHF(V,811)),U,1)) Q
 ....I $P(^AUTTHF($P(^AUTTHF(M,0),U,3),0),U,2)="C034" S R=$$BHRT(V,$$VAL^XBDIQ1(9002011.08,X,.01),"",P,$$VALI^XBDIQ1(9002011.08,X,.05),$P($G(^AMHRHF(V,811)),U,1)) Q
 ..I R]"" Q
 ..S X=0 F  S X=$O(^AMHRPRO("AD",V,X)) Q:X'=+X!(R]"")  D
 ...S M=$$VAL^XBDIQ1(9002011.01,X,.01)
 ...I M="Z02.83" S R=$$BHRT(V,M,"",P,$$VALI^XBDIQ1(9002011.01,X,1204)) Q
 ..I R]"" Q
 Q R
 ;
GETAGE(A) ;
 NEW R,L,H,I
 S R=""
 S I="" F  S I=$O(AMHRBINA(I)) Q:I=""!(R]"")  D
 .S L=$P(AMHRBINA(I),U,1)
 .S H=$P(AMHRBINA(I),U,2)
 .I A'<L,A'>H S R=I
 I R="" Q "???"
 Q R
 ;
BHRT(V,TYPE,RES,PAT,PROVSCRN,COMMENT) ;EP
 S PROVSCRN=$G(PROVSCRN)
 S COMMENT=$G(COMMENT)
 NEW T,D,A
 S (D,T)=$P($P(^AMHREC(V,0),U),".")
 S $P(T,U,2)=TYPE_";"_RES
 S $P(T,U,3)=$$VAL^XBDIQ1(2,PAT,.02)
 S A=$$GETAGE($$AGE^AUPNPAT(PAT,D))
 S $P(T,U,4)=A
 S $P(T,U,5)=$S($G(PROVSCRN)]"":$P(^VA(200,PROVSCRN,0),U),1:"UNKNOWN")
 S $P(T,U,6)=$$VAL^XBDIQ1(9002011,V,.25)
 S $P(T,U,7)=$$BHPPNAME(V)
 S $P(T,U,8)=$$VAL^XBDIQ1(9002011.55,PAT,.02)
 S $P(T,U,9)=$$VAL^XBDIQ1(9002011.55,PAT,.03)
 S $P(T,U,10)=$$VAL^XBDIQ1(9002011.55,PAT,.04)
 S $P(T,U,11)=$$VAL^XBDIQ1(9000001,PAT,.14)
 S $P(T,U,13)=V
 S $P(T,U,12)=COMMENT
 S $P(T,U,15)=PAT
 S $P(T,U,20)="BH"
 Q T
 ;
PCCALCS(P,BDATE,EDATE) ;EP - get alcohol screening from pcc
 I '$G(P) Q ""
 I '$G(BDATE) Q ""
 I '$G(EDATE) Q ""
 NEW T
 ;S T=$$LASTALC^APCLAPI(P,BDATE,EDATE,"A")
 NEW R,V,AMHRDATE,SDATE
 S R=""
 S SDATE=9999999-$$FMADD^XLFDT(EDATE,1),SDATE=SDATE_".9999"
 F  S SDATE=$O(^AUPNVSIT("AA",P,SDATE)) Q:SDATE'=+SDATE!($P(SDATE,".")>(9999999-BDATE))!(R]"")  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,SDATE,V)) Q:V'=+V!(R]"")  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$$ALLOWPCC^AMHUTIL(DUZ,V)
 ..S AMHRDATE=$P($P(^AUPNVSIT(V,0),U),".")
 ..S DFN=$P(^AUPNVSIT(V,0),U,5)
 ..Q:DFN=""
 ..Q:'$$ALLOWP^AMHUTIL(DUZ,DFN)
 ..Q:$D(^AMHREC("AVISIT",V))  ;visit is in BH - already counted
 ..S R=$$PCCSCR^AMHRDU1P(V)
 Q R
REFUSAL(PAT,F,I,B,E) ;EP
 I '$G(PAT) Q ""
 I '$G(F) Q ""
 I '$G(I) Q ""
 I $G(B)="" Q ""
 I $G(E)="" Q ""
 NEW T,X,Y,%DT S X=B,%DT="P" D ^%DT S B=Y
 S X=E,%DT="P" D ^%DT S E=Y
 S (X,T)="" F  S X=$O(^AUPNPREF("AA",PAT,F,I,X)) Q:X'=+X!(T]"")  S Y=0 F  S Y=$O(^AUPNPREF("AA",PAT,F,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) D
 .S T=D
 .S R=$$VALI^XBDIQ1(9000022,Y,.07)
 .I R'="R",R'="U" Q
 .S $P(T,U,2)="UNHEALTHY DRUG SCREENING EXAM;"_$S(R="R":"PATIENT REFUSED",1:"UNABLE TO SCREEN")
 .S $P(T,U,3)=$$VAL^XBDIQ1(2,PAT,.02)
 .S A=$$GETAGE($$AGE^AUPNPAT(PAT,D))
 .S $P(T,U,4)=A
 .S $P(T,U,5)=$$VAL^XBDIQ1(9000022,Y,1204) I $P(T,U,5)="" S $P(T,U,5)="UNKNOWN"
 .S $P(T,U,6)="UNKNOWN"
 .S $P(T,U,7)="UNKNOWN"
 .S $P(T,U,8)=$$VAL^XBDIQ1(9002011.55,PAT,.02)
 .S $P(T,U,9)=$$VAL^XBDIQ1(9002011.55,PAT,.03)
 .S $P(T,U,10)=$$VAL^XBDIQ1(9002011.55,PAT,.04)
 .S $P(T,U,11)=$$VAL^XBDIQ1(9000001,PAT,.14)
 Q T
PCCV(S,PAT) ;EP
 NEW T,A
 S T=""
 S $P(T,U)=$P(S,U)
 S $P(T,U,2)=$P(S,U,2)_";"_$P(S,U,3)
 S $P(T,U,3)=$$VAL^XBDIQ1(2,PAT,.02)
 S A=$$GETAGE($$AGE^AUPNPAT(PAT,$P(S,U)))
 S $P(T,U,4)=A
 S $P(T,U,5)=$$SCRNPCC(S)
 S $P(T,U,6)=$$VAL^XBDIQ1(9000010,$P(S,U,4),.08)
 S $P(T,U,7)=$$PRIMPROV^APCLV($P(S,U,4),"N")
 S $P(T,U,8)=$$VAL^XBDIQ1(9002011.55,PAT,.02)
 S $P(T,U,9)=$$VAL^XBDIQ1(9002011.55,PAT,.03)
 S $P(T,U,10)=$$VAL^XBDIQ1(9002011.55,PAT,.04)
 S $P(T,U,11)=$$VAL^XBDIQ1(9000001,PAT,.14)
 S $P(T,U,14)=$P(S,U,4)
 S $P(T,U,15)=PAT
 S $P(T,U,20)="PCC"
 Q T
SCRNPCC(T) ;get screening provider based on v file
 NEW S,F
 S F=1202
 I $P(T,U,5)=9000010.16!($P(T,U,5)=9000010.23) S F=".05"
 S S=$$VAL^XBDIQ1($P(T,U,5),$P(T,U,6),F)
 I S]"" Q S
 Q "UNKNOWN"
