BDMDI1MR ; IHS/CMI/LAB - IHS Diabetes Audit 2021 ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**14**;JUN 14, 2007;Build 80
 ;
BEGIN ;EP - called from option
 W:$D(IOF) @IOF
 D XIT
 D INFORM
 ;CONTINUE?
 K DIR
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 I 'Y D XIT Q
 ;
 W !
 D TAXCHK^BDMDI19
B1 D EN^XBVK("BDM")
 K ^TMP($J)
 W:$D(IOF) @IOF
REGASK ;
 W !!!,$$CTR("ASSESSMENT OF DIABETES CARE, 2021")
 W !!,$$CTR("DIABETES AUDIT COMBINING MULTIPLE REGISTRIES/COMMUNITY")
 W !!
 S BDMMULTR=1,BDMDMRG=""
 K BDMQUIT,BDMREGLT
 D MREGLIST^BDMFUTIL
 I '$O(BDMREGLT(0)) W !,"NO Register(s) Selected!!! " H 2 G BEGIN
 ;
STAT ;GET STATUS
 S BDMSTAT=""
 S DIR(0)="Y",DIR("A")="Do you want to select register patients with a particular status",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S BDMSTP=1 Q
 I Y=0 G COMM
 ;which status
 S DIR(0)="9002241,1",DIR("A")="Which status",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G B1
 S BDMSTAT=Y
 ;
COMM ;GET COMMUNITY
 S BDMCOM=""
 W ! K DIR S DIR(0)="Y",DIR("A")="Limit the patients who live in a particular community ",DIR("B")="N" KILL DA D ^DIR K DIR
 I $D(DIRUT) G STAT
 G:'Y BEN
 K DIC S DIC="^AUTTCOM(",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 G STAT
 S BDMCOM=$P(^AUTTCOM(+Y,0),U)
BEN ;GET BENEFICIARY
 S BDMBEN="",BDMSTP=0
 S DIR(0)="S^1:Indian/Alaskan Native (Classification 01);2:Not Indian Alaskan/Native (Not Classification 01);3:All (both Indian/Alaskan Natives and Non 01)",DIR("A")="Select Beneficiary Population to include in the audit"
 S DIR("B")="1" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G COMM
 S BDMBEN=Y
 ;GATHER THEM UP BASED ON BEN,STAT,COMM
 ;gather up all unique patients in these registers
 S BDMJOB=$J,BDMBTH=$H,BDMCNT=0
 K ^XTMP("BDMDM21",BDMJOB,BDMBTH),^TMP($J,"PATS"),^TMP($J,"PATSNODUPE")
 ;LOOP EACH REGISTER
 S BDMR=0 F  S BDMR=$O(BDMREGLT(BDMR)) Q:BDMR'=+BDMR  D
 .S BDMX=0 F  S BDMX=$O(^ACM(41,"B",BDMR,BDMX)) Q:BDMX'=+BDMX  D
 ..;GET PATIENT IN BDMP
 ..Q:'$D(^ACM(41,BDMX,0))
 ..S BDMP=$P(^ACM(41,BDMX,0),U,2)
 ..;CHECK STATUS
 ..I BDMSTAT]"",$P($G(^ACM(41,BDMX,"DT")),U,1)'=BDMSTAT Q
 ..;CHECK BEN
 ..I BDMBEN=1,$$BEN^AUPNPAT(BDMP,"C")'="01" Q
 ..I BDMBEN=2,$$BEN^AUPNPAT(BDMP,"C")="01" Q
 ..;CHECK COMMUNITY
 ..I BDMCOM]"",$P($G(^AUPNPAT(BDMP,11)),U,18)'=BDMCOM Q
 ..Q:$D(^TMP($J,"PATSNODUPE",BDMP))  ;ALREADY COUNTED
 ..S BDMCNT=BDMCNT+1
 ..S ^TMP($J,"PATS",BDMCNT,BDMP)="",^TMP($J,"PATSNODUPE",BDMP)=""
 W !!,"There are ",BDMCNT," individual patients in those registers that meet this criteria.",!! H 1
GETDATES ;
 S BDMSTP=0 D TIME I BDMSTP G BEN
 D PREG
 I BDMSTP G GETDATES
 S BDMSTP=0
 D RAND
 I BDMSTP G GETDATES
IF ;PEP - called from BDM indivdual or epi
 S BDMSTP=0
 K DIR
 S DIR(0)="S^1:Print Individual Reports;2:Create AUDIT EXPORT file;3:Audit Report (Cumulative Audit);4:Both Individual and Cumulative Audits;5:SDPI RKM Report"
 S DIR("A")="Enter Print option",DIR("B")="1" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G GETDATES
 S BDMPREP=Y
 I BDMPREP=2 D FLAT^BDMDI1 Q:BDMSTP
 ;
IF2 ;
 I BDMPREP=1!(BDMPREP=4) S BDMPPN="" D  G:BDMSTP IF
 .K DIR S DIR(0)="Y",DIR("A")="Do you wish to print the Patient's Name on the audit sheet",DIR("B")="N" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S BDMSTP=1
 .S BDMPPN=Y
ZIS ;
DEMO ;
 S BDMDEMO="I"
 D DEMOCHK^BDMUTL(.BDMDEMO) I BDMDEMO=-1 G IF
 S BDMTYPE="C"
 I BDMPREP=2 S XBRP="",XBRC="^BDMDI10",XBRX="XIT^BDMDI1MR",XBNS="BDM" D ^XBDBQUE,XIT Q
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) D XIT Q
 S BDMOPT=Y
 I Y="B" D BROWSE,XIT Q
 S XBRP="^BDMDI1P",XBRC="^BDMDI10",XBRX="XIT^BDMDI1MR",XBNS="BDM"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BDMDI1P"")"
 S XBRC="^BDMDI10",XBRX="XIT^BDMDI1MR",XBIOP=0 D ^XBDBQUE
 Q
BENC(B) ;
 I B=1 Q "Indian/Alaskan Native (Classification 01)"
 I B=2 Q "Not Indian Alaskan/Native (Not Classification 01)"
 I B=3 Q "All (both Indian/Alaskan Natives and Non 01)"
 Q "BENEFICIARY NOT SELECTED"
PREG ;
 S BDMPREG="",BDMSTP=0
 S DIR(0)="S^I:Include Pregnant Patients;E:Exclude Pregnant Patients",DIR("A")="Select whether to include or exclude pregnant patients in the audit"
 S DIR("B")="E" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S BDMSTP=1 Q
 S BDMPREG=Y
 Q:BDMPREG="I"
 W !,"okay, hold on...this may take a few minutes.."
 S X=0 F  S X=$O(^TMP($J,"PATS",X)) Q:X'=+X  S P=$O(^TMP($J,"PATS",X,0)) D
 .Q:$P(^DPT(P,0),U,2)'="F"
 .;W ".",P
 .I $$PREG^BDMDI1B(P,BDMBDAT,BDMADAT,1,1,BDMBDAT,BDMADAT) K ^TMP($J,"PATS",X,P)
 K ^XTMP("BDMTAX",BDMJOB,BDMBTH)
 Q
PTAX ;
 I '$D(^ICDS(0)) Q  ;only in icd10 environment
 K ^XTMP("BDMTAX",BDMJOB,BDMBTH)
 S BDMTAX="BGP PREGNANCY DIAGNOSES 2"
 S BDMFL=80
 S BDMTYP=""
 S BDMTAXI=$O(^ATXAX("B",BDMTAX,0))
 S BDMTGT="^XTMP("_"""BDMTAX"""_","_BDMJOB_","_""""_BDMBTH_""""_","_""""_BDMTAX_""""_")"
 D BLDTAX^BDMTAPI(BDMTAX,BDMTGT,BDMTAXI,BDMTYP)
 Q
RAND ;random sample or not
 S (X,BDMCNT)=0 F  S X=$O(^TMP($J,"PATS",X)) Q:X'=+X  S BDMCNT=BDMCNT+1
 W !!,"There are ",BDMCNT," patients selected so far to be used in the audit.",!
 S DIR(0)="S^A:ALL Patients selected so far;R:RANDOM Sample of the patients selected so far",DIR("A")="Do you want to select",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S BDMSTP=1 Q
 I Y="A" S C=0 F  S C=$O(^TMP($J,"PATS",C)) Q:C'=+C  S X=$O(^TMP($J,"PATS",C,0)),^XTMP("BDMDM21",BDMJOB,BDMBTH,"PATS",X)=""
 I Y="A" K ^TMP($J,"PATS"),^TMP($J,"PATSNODUPE") Q
 S DIR(0)="N^2:"_BDMCNT_":0",DIR("A")="How many patients do you want in your random sample" KILL DA D ^DIR KILL DIR
 ;get random sample AND set xtmp
 I $D(DIRUT) S BDMSTP=1 Q
 S C=0 F N=1:1:BDMCNT Q:C=Y  S I=$R(BDMCNT) I I,$D(^TMP($J,"PATS",I)) S X=$O(^TMP($J,"PATS",I,0)),^XTMP("BDMDM21",BDMJOB,BDMBTH,"PATS",X)="",C=C+1 K ^TMP($J,"PATS",I,X)
 K ^TMP($J,"PATS"),^TMP($J,"PATSNODUPE")
 Q
TIME ;PEP - called from BDM Get fiscal year or time frame
 S BDMSTP=0
 S (BDMRBD,BDMRED,BDMADAT)=""
 W !!,"Enter the date of the audit.  This date will be considered the ending",!,"date of the audit period.  For most data items all data for the period one",!,"year prior to this date will be reviewed.",!
 S DIR(0)="D^::EPX",DIR("A")="Enter the Audit Date" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S BDMSTP=1 Q
 S BDMADAT=Y
 S BDMRED=$$FMTE^XLFDT(BDMADAT)
 S BDMBDAT=($E(BDMADAT,1,3)-1)_$E(BDMADAT,4,7),BDMBDAT=$$FMADD^XLFDT(BDMBDAT,1)
 S BDMRBD=$$FMTE^XLFDT(BDMBDAT)
 Q
 ;
XIT1 ;
 K ^BDMDATA($J),^BDMDATA("BDMEPI",$J)
 K ^XTMP("BDMTAX",BDMJOB,BDMBTH)  ;cmi/maw kill tmp storage of taxonomies
 K ^XTMP("BDMDM21",BDMJOB,BDMBTH),BDMJOB,BDMBTH
XIT ;
 I '$D(BDMGUI) D EN^XBVK("BDM"),EN^XBVK("AUPN")
 D ^XBFMK,KILL^AUPNPAT
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
INFORM ;
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC)
 W !,$$CTR($$USR)
 W !!,$$CTR("MULTIPLE REGISTER COMMUNITY DIABETES AUDIT",80)
 W !!,"This report will search two or more Diabetes Registers to combine "
 W !,"a list of patients from a particular community. You can run the audit"
 W !,"just for the subset of patients who live in a particular community.",!!
 Q
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
