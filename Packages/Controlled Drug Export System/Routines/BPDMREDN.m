BPDMREDN ; IHS/CMI/LAB - MAIN DRIVER FOR PDM RE-EXPORT REPORT ;
 ;;2.0;CONTROLLED DRUG EXPORT SYSTEM;**1,4,5,6,7**;NOV 15, 2011;Build 51
 ;
START ;
 W !!,"This option is used to re-send an entire file of prescriptions."
 W !,"This option should only be used if the entire file was rejected"
 W !,"with a fatal error.  If only some of the prescriptions sent in the"
 W !,"file failed then you should use the option to re-send individual"
 W !,"prescriptions.",!!
 K DIR
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I 'Y Q
 D EN^XBVK("BPDM")
 K ^TMP($J)
 S BPDMQFLG=0
 D GETSITE^BPDMCHKN
 Q:BPDMSITE=""  ;get site to do the export for
 Q:BPDMQFLG
 D CHECK^BPDMCHKN
 I BPDMQFLG W !!,BPDMQMSG D EOJ Q
 S BPDMPTYP="P"
 I $$GET1^DIQ(9002315.01,BPDMSITE,1108,"I") S BPDMPTYP="T"  ;maw beta testing
START1 ;
 D HOME^%ZIS S BPDMBS=$S('$D(ZTQUEUED):IOBS,1:"")
 K ^TMP($J)
 S BPDM("COUNT")=0,BPDMQFLG=0
 S BPDMDTAX=$O(^ATXAX("B","BPDM DRUGS FOR PDM",0))
 S (BPDMERRC,BPDMCNT,BPDMRCNT)=0
 S BPDMRTYP=1
 S BPDMREDO=1  ;this is a redo
 ;D ^BPDMRDR2
 K DIC S DIC="^BPDMLOG(",DIC(0)="AEMQ",DIC("S")="I $P(^(0),U,10)=BPDMOSIT" D ^DIC K DIC I Y=-1 W !!,"Goodbye" G EOJ
 S BPDM("RUN LOG")=+Y
EN U IO ;W @IOF
 S Y=$P(^BPDMLOG(BPDM("RUN LOG"),0),U) X ^DD("DD") S BPDMD=Y
DIQ ; CALL TO DIQ
 W !!,"Information for Log Entry ",BPDM("RUN LOG")," Run Date: ",BPDMD,!
 S DIC="^BPDMLOG(",DA=BPDM("RUN LOG"),DR="0",DIQ(0)="C" D EN^DIQ
 I $D(ZTQUEUED) S ZTREQ="@" D ^%ZISC G EOJ
 D ^%ZISC U IO(0)
 S DIR(0)="Y",DIR("A")="Is this the log you want to re-run",DIR("B")="Y" D ^DIR KILL DIR
 I 'Y W !,"Okay....exiting..." D EOJ Q
 S BPDMRTYP=$P(^BPDMLOG(BPDM("RUN LOG"),0),U,8)
 S BPDMFILT=$P(^BPDMLOG(BPDM("RUN LOG"),0),U,9)
 S BPDMFILE=$P(^BPDMLOG(BPDM("RUN LOG"),0),U,9)  ;cmi/maw p4 believe BPDMFILT should be BPDMFILE
 S BPDMREDO=1
DRIVER ;called from TSKMN+2
 S BPDM("BT")=$H
 D NOW^%DTC S BPDM("RUN START")=%,BPDM("MAIN TX DATE")=$P(%,".") K %,%H,%I
 S BPDMCNT=$S('$D(ZTQUEUED):"X BPDMCNT1  X BPDMCNT2",1:"S BPDMCNTR=BPDMCNTR+1"),BPDMCNT1="F BPDMCNTL=1:1:$L(BPDMCNTR)+1 W @BPDMBS",BPDMCNT2="S BPDMCNTR=BPDMCNTR+1 W BPDMCNTR,"")"""
 ;
 I BPDMRTYP'=4 D PROCESS
 I BPDMQFLG D BULL^BPDMDRN,EOJ Q
 ;
 I '$D(ZTQUEUED) W !!,"Writing out transaction file...."
 I BPDMRTYP'=4 D TAPE^BPDMDR1N
 I BPDMRTYP=4 D
 . D RPT^BPDMZERO
 . S BPDM("REC COUNT")=0
 I BPDMQFLG D BULL^BPDMDRN,EOJ Q
 I '$D(ZTQUEUED) W !!,"Updating Log Entry...."
 D LOG
 I $G(BPDMNOFI) D  Q  ;20220223 patch 6 73211
 . I '$D(ZTQUEUED) ;W !,"Error in file export, failed to create export file"
 . D EOJ
 ;no autoftp for redo only regular and queued export
 ;S BPDMAUUP=$$GET1^DIQ(9002315.01,BPDMSITE,1107,"I")
 ;I '$$OPENSSH^BPDMRDRN() D
 ;. Q:'$G(BPDMAUUP)
 ;. W !,"OpenSSH is not installed on server, Auto Upload is disabled for this run..."
 ;. S BPDMAUUP=0  ;turn off auto upload if OpenSSH isnt installed
 ;I '$D(ZTQUEUED) W !!,"Successfully completed...you must now send the file ",BPDMFILE," to the state.",!
 I '$G(BPDMAUUP) W !!,"Successfully completed...you must now send the file ",$G(BPDMFILE)," to the state.",!
 ;I $G(BPDMAUUP) W !!,"Successfully completed...the file ",$G(BPDMFILE)," will auto upload to the state.",!
 D EOJ
 Q
 ;
PROCESS ;
 K ^TMP($J)
 K ^BPDMLOG(BPDM("RUN LOG"),51) ;CLEAR OUT ERROR MULTIPLE
 W:'$D(ZTQUEUED) !,"Generating transactions.  Counting records.  (1)"
 S BPDMCNTR=0,BPDMIEN=0
 F  S BPDMIEN=$O(^BPDMLOG(BPDM("RUN LOG"),21,BPDMIEN)) Q:BPDMIEN'=+BPDMIEN  D PROCESS2
 Q
PROCESS2 ;
 K BPDMAIEN
 S BPDMR=$P(^BPDMLOG(BPDM("RUN LOG"),21,BPDMIEN,0),U,1)
 S BPDMRF=$P(^BPDMLOG(BPDM("RUN LOG"),21,BPDMIEN,0),U,3)
 S BPDMPFI=$P(^BPDMLOG(BPDM("RUN LOG"),21,BPDMIEN,0),U,4)
 S BPDMPART=$S(BPDMPFI:"01",1:"02")
 S BPDMSTAT=$P(^BPDMLOG(BPDM("RUN LOG"),21,BPDMIEN,0),U,5)
 S BPDMPULG=$P(^BPDMLOG(BPDM("RUN LOG"),21,BPDMIEN,0),U,9)  ;20230828 maw p7 pickup
 S BPDMACTL=$P(^BPDMLOG(BPDM("RUN LOG"),21,BPDMIEN,0),U,10)  ;20240202 maw act log
 D PROCESS3^BPDMDR1N
 Q
TAPE ; COPY TRANSACTIONS TO TAPE
 D TAPE^BPDMDR1N
 Q
 ;
CHKLOG ; CHECK LOG FILE
 Q
 S BPDM("X")=0 F BPDM("I")=BPDM("RUN LOG"):-1:1 Q:'$D(^BPDMLOG(BPDM("I")))  I $O(^BPDMLOG(BPDM("I"),21,0)) S BPDM("X")=BPDM("X")+1
 I BPDM("X")>12 W !,"-->There are more than twelve generations of CURES RECORDs stored in the LOG file.",!,"-->Time to do a purge."
 Q
 ;
LOG ;UPDATE LOG
 D ^XBFMK
 K ^BPDMLOG(BPDM("RUN LOG"),21),^BPDMLOG(BPDM("RUN LOG"),31)
 D LOG^BPDMDR1N
 Q
ERR ;
 S:'$D(^BPDMLOG(BPDM("RUN LOG"),51,0)) ^BPDMLOG(BPDM("RUN LOG"),51,0)="^19256.0951PA^^"
 S ^BPDMLOG(BPDM("RUN LOG"),51,BPDMR,0)=BPDMR_U_BPDMMSG
 S $P(^BPDMLOG(BPDM("RUN LOG"),51,0),U,3)=BPDMR,$P(^(0),U,4)=$P(^(0),U,4)+1
 Q
DATE(D) ;EP
 I $G(D)="" Q ""
 Q (1700+$E(D,1,3))_$E(D,4,5)_$E(D,6,7)
LZERO(V,L) ;EP - left zero fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
EOJ ; EOJ
 D ^XBFMK
 D EN^XBVK("BPDM")
 K ^TMP($J)
PAUSE ;EP
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
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
