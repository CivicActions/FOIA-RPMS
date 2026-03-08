BDWHRDRI ; IHS/CMI/LAB - INIT FOR DW ;
 ;;1.0;IHS DATA WAREHOUSE;**6,10**;JAN 24, 2006;Build 9
 ;
START ;
 D BASICS ;      Set variables like U,DT,DUZ(2) etc.
 D CHKSITE ;     Make sure Site file has correct fields.
 Q:BDW("QFLG")
 ;
 D:BDWO("RUN")="NEW" ^BDWHRDI2 ;  Do new run initialization.
 Q:$D(ZTQUEUED)
 Q:BDW("QFLG")
 D:BDWO("RUN")="NEW" QUEUE
 Q
 ;
BASICS ;EP - BASIC INITS
 S BDWVA("COUNT")=0
 D HOME^%ZIS S BDWBS=$S('$D(ZTQUEUED):IOBS,1:"")
 K BDW,BDWS,BDWV,BDWT,BDWE,BDWERRC
 S BDW("RUN LOCATION")=$P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,10),BDW("QFLG")=0
 S (BDWSKIP,BDW("TXS"),BDW("FPROC"),BDW("COUNT"),BDWERRC,BDW("DEL"),BDWTOTF,BDW("OM BL COUNT"),BDW("OM COUNT"))=0
 S BDWIEDST=$O(^INRHD("B","HL IHS DW1HOPE IE",0))
 S BDW("RUN DATE")=DT
 Q
 ;
CHKSITE ;EP
 I '$D(^AUTTSITE(1,0)) W:'$D(ZTQUEUED) !!,"*** RPMS SITE FILE has not been set up! ***" S BDW("QFLG")=1 Q
 I $P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,10)="" W:'$D(ZTQUEUED) !!,"No ASUFAC for facility in RPMS Site file!!" S BDW("QFLG")=1 Q
 I '$D(^BDWSITE(1,0)) W:'$D(ZTQUEUED) !!,"*** Site file has not been setup! ***" S BDW("QFLG")=1 Q
 I $P(^BDWSITE(1,0),U)'=DUZ(2) W:'$D(ZTQUEUED) !!,"*** RUN LOCATION not in SITE file!" S BDW("QFLG")=2 Q
 K BDWHOPE
 S X=0,Y=0 F  S X=$O(^BDWSITE(1,21,X)) Q:X'=+X  I $P(^BDWSITE(1,21,X,0),U,2)=1 S BDWHOPE(X)=$P(^BDWSITE(1,21,X,0),U,3)  ;SET TO DATE OF BACKLOAD DONE
 I '$D(BDWHOPE) W:'$D(ZTQUEUED) !!,"*** No Pharmacy Divsions have enabled the PRESCRIPTION export. ***" S BDW("QFLG")=2 Q
 S X=$O(^INRHD("B","HL IHS DW1HOPE IE",0))
 I $D(^BDWHTMP(X)) W:'$D(ZTQUEUED) !!,"previous PRESCRIPTION export not written to host file" S BDW("QFLG")=4 Q
 K ^BDWHTMP(X)
 Q
HASHOPE(I) ;
 NEW X,Y
 S X=0,Y=0 F  S X=$O(^BDWSITE(I,21,X)) Q:X'=+X  I $P(^BDWSITE(I,21,X,0),U,2)=1 S Y=1
 Q Y
 ;
QUEUE ;EP
 K ZTSK
 S DIR(0)="Y",DIR("A")="Do you want to QUEUE this to run at a later time",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y=1 D QUEUE1 Q
 I BDWO("RUN")="NEW",$D(DIRUT) S BDW("QFLG")=99 S DA=BDWLOG,DIK="^BDWHLOG(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA
 I BDWO("RUN")="REDO",$D(DIRUT) S BDW("QFLG")=99 Q
 Q
QUEUE1 ;
 S ZTRTN=$S(BDWO("RUN")="NEW":"DRIVER^BDWHRDR",1:"EN^BDWHREDO")
 S ZTIO="",ZTDTH="",ZTDESC="DATA WAREHOUSE PRESCRIPTION EXP" S ZTSAVE("BDW*")=""
 D ^%ZTLOAD
 W !!,$S($D(ZTSK):"Request Queued!!",1:"Request cancelled")
 I '$D(ZTSK),BDWO("RUN")="NEW" S BDW("QFLG")=99 S DA=BDWLOG,DIK="^BDWHLOG(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA Q
 S BDWO("QUEUE")=""
 S DIE="^BDWHLOG(",DA=BDWLOG,DR=".15///Q" D ^DIE K DIE,DA,DR
 K ZTSK
 Q
