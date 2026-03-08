BPDMRSSP ; IHS/CMI/LAB - MAIN DRIVER FOR PDM REPORT 14 Mar 2011 3:42 PM ;
 ;;2.0;CONTROLLED DRUG EXPORT SYSTEM;**1,4,7**;NOV 15, 2011;Build 51
 ;
START ;
 W !!,"This option is used to re-send a prescriptions that"
 W !,"generateded an error when originally transmitted.",!
 K DIR
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I 'Y Q
 D EN^XBVK("BPDM")
 K ^TMP($J)
 S BPDMPTYP="P"
 S BPDM("RUN BEGIN")=""
 S BPDM("RUN END")=""
START1 ;
 D HOME^%ZIS S BPDMBS=$S('$D(ZTQUEUED):IOBS,1:"")
 S BPDMCNTR=0,BPDM("CONTROL DATE")=BPDM("RUN BEGIN")-1,BPDM("CONTROL DATE")=BPDM("CONTROL DATE")_".9999",BPDM("POSTING DATE")="      "
 S BPDMQFLG=0
 K ^TMP($J)
 S BPDM("COUNT")=0,BPDMQFLG=0
 S BPDMDTAX=$O(^ATXAX("B","BPDM DRUGS FOR PDM",0))
 S (BPDMERRC,BPDMCNT,BPDMRCNT)=0
 S BPDMRTYP=3
 D GETSITE^BPDMCHKN
 I BPDMSITE="" D EOJ Q  ;get site to do the export for
 I BPDMQFLG D EOJ Q
 D CHECK^BPDMCHKN
 I BPDMQFLG D EOJ Q
 I $$GET1^DIQ(9002315.01,BPDMSITE,1108,"I") S BPDMPTYP="T"  ;maw beta testing
 D GETRXS
 I '$D(BPDMRXS) W !!,"No Prescriptions Entered." D EOJ Q
 D GENLOG^BPDMCHKN ;      Generate new log entry.
 ;
 I BPDMQFLG D BULL^BPDMDR,EOJ Q
DRIVER ;called from TSKMN+2
 S BPDM("BT")=$H
 D NOW^%DTC S BPDM("RUN START")=%,BPDM("MAIN TX DATE")=$P(%,".") K %,%H,%I
 S BPDMCNT=$S('$D(ZTQUEUED):"X BPDMCNT1  X BPDMCNT2",1:"S BPDMCNTR=BPDMCNTR+1"),BPDMCNT1="F BPDMCNTL=1:1:$L(BPDMCNTR)+1 W @BPDMBS",BPDMCNT2="S BPDMCNTR=BPDMCNTR+1 W BPDMCNTR,"")"""
 D PROCESS ;            Generate trasactions
 ;
 I BPDMQFLG D BULL^BPDMDR,EOJ Q
 ;
 I BPDMQFLG D BULL^BPDMDR,EOJ Q
 I '$D(ZTQUEUED) W !!,"Writing out transaction file...."
 D TAPE^BPDMDR1N
 I BPDMQFLG D BULL^BPDMDR,EOJ Q
 I '$D(ZTQUEUED) W !!,"Updating Log Entry...."
 D LOG^BPDMDR1N
 I '$D(ZTQUEUED) W !!,"Successfully completed...you must now send the file ",$G(BPDMFILE)," to the state.",!
 D EOJ
 Q
PROCESS ;
 W:'$D(ZTQUEUED) !,"Reviewing prescriptions...........  (1)"
 S BPDMR=0 F  S BPDMR=$O(BPDMRXS(BPDMR)) Q:BPDMR'=+BPDMR  D
 .K BPDMPULG,BPDMAIEN
 .S BPDMRF=$P(BPDMRXS(BPDMR),U,1)
 .S BPDMPFI=$P(BPDMRXS(BPDMR),U,2)
 .S BPDMSTAT=$P(BPDMRXS(BPDMR),U,3)
 .S (BPDMPULG,BPDMAIEN)=$P(BPDMRXS(BPDMR),U,4)
 .S BPDMACTL=$P(BPDMRXS(BPDMR),U,5)
 .;S BPDMSTAT=$S($G(BPDMSTAT):BPDMSTAT,1:$P(BPDMRXS(BPDMR),U,3))  ;CMI/GRL
 .S BPDMPART=$S(BPDMPFI:"01",1:"02")
 .D PROCESS3^BPDMDR1N
 Q
 ;
TEST ;EP - called from option
 D EN^XBVK("BPDM")
 S BPDMPTYP="T"
 G START1
GETRXS ;
 W !!,"Please enter all of the prescriptions that you wish to re-export.",!
 K BPDMRXS
GETRXS1 W ! K DIC S DIC="^PSRX(",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 Q
 S BPDMY=+Y
 ;find the last time this was export
 I '$D(^BPDMLOG("APE",BPDMY)) D  G GETRXS1
 .W !!,"That prescription has never been exported and thus doesn't",!,"need to be re-exported.",!
 S BPDMDIVI=$$VALI^XBDIQ1(52,BPDMY,20)
 I BPDMDIVI="" W !,"OUTPATIENT IN PRESCRIPTION MISSING",! G GETRXS1
 I BPDMDIVI'=BPDMOSIT W !,"This prescription is not from your division, it is for ",$$VAL^XBDIQ1(52,BPDMY,20),".",! G GETRXS1
 S (X,BPDMLAST)="" F  S X=$O(^BPDMLOG("APE",BPDMY,X)) Q:X'=+X  S BPDMLAST=X
 S BPDMIEN=$O(^BPDMLOG("APE",BPDMY,BPDMLAST,0)),BPDMIENI=$O(^BPDMLOG("APE",BPDMY,BPDMLAST,BPDMIEN,0))
 S BPDM0=^BPDMLOG(BPDMIEN,31,BPDMIENI,0)
 W !!,"The last time this prescription was exported:"
 W !?5,"Patient: ",$$VAL^XBDIQ1(52,BPDMY,2)
 W !,?5,"Prescription #: ",$P(^PSRX(BPDMY,0),U,1),?40,"Date Exported: ",$$FMTE^XLFDT(BPDMLAST)
 W !,?5,"Refill #: ",$P(BPDM0,U,3),?40,"Fill Date: ",$E($P(BPDM0,U,6),5,6)_"/"_$E($P(BPDM0,U,6),7,8)_"/"_$E($P(BPDM0,U,6),1,4)
 W !,?5,"Status of exported record: ",$$EXTSET^XBFUNC(9002315.0931,.05,$P(BPDM0,U,5))
 I $P(BPDM0,U,4) W !?5,"Partial #: ",$P(BPDM0,U,4)
 W !,?5,"Drug: ",$$VAL^XBDIQ1(52,BPDMY,6),!
 ;CMI/GRL ask about record type
 K DIR
 W !!,"You must now select the record type...",!
 S DIR(0)="S^N:New;R:Revise;V:Void"
 S DIR("A")="Please make a selection and press enter"
 D ^DIR
 S BPDMSTAT=$S(Y="N":"00",Y="R":"01",Y="V":"02",1:"")
 I $G(BPDMSTAT)]"" S BPDMRXS(BPDMY)=$P(BPDM0,U,3)_U_$P(BPDM0,U,4)_U_BPDMSTAT_U_$P(BPDM0,U,9)_U_$P(BPDM0,U,10)
 K DIR
 I $D(DIRUT) G GETRXS1
 ;W !!,"What type of error was reported that is causing you to resubmit this",!,"prescription?",!
 ;S DIR(0)="S^F:Fatal Error;M:Minor Error",DIR("A")="Which type of Error was reported" KILL DA D ^DIR KILL DIR
 ;S DIR(0)="S^F:Fatal Error;N:Non-Fatal Error",DIR("A")="Which type of Error was reported" KILL DA D ^DIR KILL DIR
 ;I $D(DIRUT) G GETRXS1
 ;S BPDMSTAT=""   ;S BPDMOSTA=$P(BPDM0,U,5)
 ;I Y="N",$P(BPDM0,U,5)="00" S BPDMSTAT="01"
 ;I Y="N",$P(BPDM0,U,5)'="00" S BPDMSTAT=$P(BPDM0,U,5)
 ;I Y="F" S BPDMSTAT=$P(BPDM0,U,5)
 S DIR(0)="Y",DIR("A")="Re-Export this Prescription",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G GETRXS1
 I 'Y G GETRXS1
 ;S BPDMRXS(BPDMY)=$P(BPDM0,U,3)_U_$P(BPDM0,U,4)_U_$P(BPDM0,U,5)
 S BPDMRXS(BPDMY)=$P(BPDM0,U,3)_U_$P(BPDM0,U,4)_U_BPDMSTAT_U_$P(BPDM0,U,9)_U_$P(BPDM0,U,10)  ;CMI/GRL
 G GETRXS1
ERR ;
 Q
DATE(D) ;EP
 I $G(D)="" Q ""
 Q (1700+$E(D,1,3))_$E(D,4,5)_$E(D,6,7)
RZERO(V,L) ;ep right zero fill 
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_"0"
 Q V
LBLK(V,L) ;left blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=" "_V
 Q V
RBLK(V,L) ;EP right blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_" "
 Q V
LZERO(V,L) ;EP - left zero fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
EOJ ; EOJ
 D ^XBFMK
 D EN^XBVK("BPDM")
 K ^TMP($J)
PAUSE ;EP
 Q:$D(ZTQUEUED)
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
CALLDIE ;EP
 Q:'$D(DA)
 Q:'$D(DIE)
 Q:'$D(DR)
 D ^DIE
 D ^XBFMK
 K DLAYGO,DIADD
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
