BDWCOVD1 ; IHS/CMI/LAB - INIT FOR DW ;
 ;;1.0;IHS DATA WAREHOUSE;**7,11**;JAN 24, 2006;Build 14
 ;
START ;
 S BDW("RUN LOCATION")=$P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,10),BDW("QFLG")=0
 S BDWIEDST=$O(^INRHD("B","HL IHS DW1COVID IE",0)) ;I BDWIEDST="" S BDWIEDST=23456  ;LORIFIX
 S BDW("RUN DATE")=$$NOW^XLFDT()
 D CHKSITE ;     Make sure Site file has correct fields.
 Q:BDW("QFLG")
 ;
 D:BDWO("RUN")="NEW" NEW ;  Do new run initialization.
 Q:$D(ZTQUEUED)
 Q:BDW("QFLG")
 ;D:BDWO("RUN")="NEW" QUEUE
 Q
 ;
CHKSITE ;EP
 I '$D(^AUTTSITE(1,0)) W:'$D(ZTQUEUED) !!,"*** RPMS SITE FILE has not been set up! ***" S BDW("QFLG")=1 Q
 I $P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,10)="" W:'$D(ZTQUEUED) !!,"No ASUFAC for facility in RPMS Site file!!" S BDW("QFLG")=1 Q
 I '$D(^BDWSITE(1,0)) W:'$D(ZTQUEUED) !!,"*** Site file has not been setup! ***" S BDW("QFLG")=1 Q
 I $P(^BDWSITE(1,0),U)'=DUZ(2) W:'$D(ZTQUEUED) !!,"*** RUN LOCATION not in SITE file!" S BDW("QFLG")=2 Q
 I $D(^BDWCTMP(BDWIEDST)) W:'$D(ZTQUEUED) !!,"previous COVID export not written to host file" S BDW("QFLG")=4 Q
 K ^BDWCTMP(BDWIEDST)
 Q
 ;
QUEUE ;EP
 K ZTSK
 S DIR(0)="Y",DIR("A")="Do you want to QUEUE this to run at a later time",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y=1 D QUEUE1 Q
 I BDWO("RUN")="NEW",$D(DIRUT) S BDW("QFLG")=99 S DA=BDWLOG,DIK="^BDWCVLOG(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA
 I BDWO("RUN")="REDO",$D(DIRUT) S BDW("QFLG")=99 Q
 Q
QUEUE1 ;
 S ZTRTN=$S(BDWO("RUN")="NEW":"DRIVER^BDWCOVD",1:"EN^BDWCOVDR")
 S ZTIO="",ZTDTH="",ZTDESC="DATA WAREHOUSE COVID-19 EXP" S ZTSAVE("BDW*")=""
 D ^%ZTLOAD
 W !!,$S($D(ZTSK):"Request Queued!!",1:"Request cancelled")
 I '$D(ZTSK),BDWO("RUN")="NEW" S BDW("QFLG")=99 S DA=BDWLOG,DIK="^BDWCVLOG(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA Q
 S BDWO("QUEUE")=""
 S DIE="^BDWCVLOG(",DA=BDWLOG,DR=".1///Q" D ^DIE K DIE,DA,DR
 K ZTSK
 Q
NEW ;
 D INFORM ;      Let operator know what is going on.
 D GETLOG ;      Get last log entry and display data.
 Q:BDW("QFLG")
 D CURRUN ;      Compute run dates for current run.
 Q:BDW("QFLG")
 ;
 D CONFIRM ;     Get ok from operator.
 Q:BDW("QFLG")
 D GENLOG ;      Generate new log entry.
 Q
 ;
GETLOG ;EP GET LAST LOG ENTRY
 S (X,BDW("LAST LOG"))=0 F  S X=$O(^BDWCVLOG(X)) Q:X'=+X  I $P(^BDWCVLOG(X,0),U,7)="R" S BDW("LAST LOG")=X
 Q:'BDW("LAST LOG")
 D DISPLOG
 Q:$P(^BDWCVLOG(BDW("LAST LOG"),0),U,10)="C"
 D ERROR
 Q
ERROR ;
 S BDW("QFLG")=12
 S BDW("PREV STATUS")=$P(^BDWCVLOG(BDW("LAST LOG"),0),U,10)
 I BDW("PREV STATUS")="" D EERR Q
 D @(BDW("PREV STATUS")_"ERR") Q
 Q
EERR ;
 S BDW("QFLG")=13
 ;
 Q:$D(ZTQUEUED)
 W $C(7),$C(7),!!,"*****ERROR ENCOUNTERED*****",!,"The last Data Export never successfully completed to end of job!!!",!,"This must be resolved before any other exports can be done.",!
 Q
RERR ;
 S BDW("QFLG")=15
 ;
 Q:$D(ZTQUEUED)
 W $C(7),$C(7),!!,"Data Warehouse COVID is currently running!!"
 Q
QERR ;
 S BDW("QFLG")=16
 ;
 Q:$D(ZTQUEUED)
 W !!,$C(7),$C(7),"Data Warehouse COVID Transmission is already queued to run!!"
 Q
FERR ;
 S BDW("QFLG")=17
 ;
 Q:$D(ZTQUEUED)
 W !!,$C(7),$C(7),"The last COVID DATA WAREHOUSE Export failed and has never been reset.",!,"See your site manager for assistence",!
 Q
 ;
DISPLOG ; DISPLAY LAST LOG DATA
 S Y=$P(^BDWCVLOG(BDW("LAST LOG"),0),U,8) S BDW("LAST BEGIN")=$$UP^XLFSTR($$FMTE^XLFDT(Y)) S Y=$P(^BDWCVLOG(BDW("LAST LOG"),0),U,9) S BDW("LAST END")=$$UP^XLFSTR($$FMTE^XLFDT(Y))
 Q:$D(ZTQUEUED)
 W !!,"Last run was dates ",BDW("LAST BEGIN")," through ",BDW("LAST END"),"."
 W !,"Run date was ",$$VAL^XBDIQ1(90213.2,BDW("LAST LOG"),.01),".",!
 Q
 ;
CONFIRM ;EP SEE IF THEY REALLY WANT TO DO THIS
 Q:$D(ZTQUEUED)
 W !,"The computer database location for this run is ",$P(^DIC(4,DUZ(2),0),U),".",!
CFLP  ;
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="N" K DA D ^DIR K DIR
 I 'Y S BDW("QFLG")=99
 Q
 ;
GENLOG ; GENERATE NEW LOG ENTRY
 D ^XBFMK K DIADD
 W:'$D(ZTQUEUED) !,"Generating New Log entry."
 S Y=BDW("RUN DATE") X ^DD("DD") S X=""""_Y_"""",DIC="^BDWCVLOG(",DIC(0)="L",DLAYGO=90213.2
 S DIC("DR")=".08////"_BDW("RUN BEGIN")_";.09////"_BDW("RUN END")_";.07////R;.02////"_DUZ(2)_";.14///"_$S($$PROD^XUPROD():"P",1:"T"),DIADD=1
 D ^DIC K DIC,DLAYGO,DR,DIADD
 I Y<0 S BDW("QFLG")=23 D ^XBFMK Q
 S BDWLOG=+Y
 D ^XBFMK
 Q
INFORM ;EP - INFORM OPERATOR WHAT IS GOING TO HAPPEN
 Q:$D(ZTQUEUED)
 W !!,"This option will generate an export of Hospital Bed and COVID-19 testing"
 W !,"data for a specified range of dates.  "
 W !,"You may ""^"" out at any prompt and will be asked to confirm your entries ",!,"prior to generating the HL7 messages.",!
 Q
 ;
CURRUN ;EP - COMPUTE DATES FOR CURRENT RUN
 S BDW("RUN BEGIN")=""
 I BDW("LAST LOG") S BDW("RUN BEGIN")=$$FMADD^XLFDT($P(^BDWCVLOG(BDW("LAST LOG"),0),U,9),1)
 I BDW("RUN BEGIN")="" D FIRSTRUN
 Q:BDW("QFLG")
 S Y=$$FMADD^XLFDT(DT,-1)
 I Y<BDW("RUN BEGIN") W:'$D(ZTQUEUED) !!,"  Ending date cannot be before beginning date!  There is no new data to send.",$C(7) S BDW("QFLG")=18 Q
 S BDW("RUN END")=Y
 K %,%H,%I,BDW("RDFN"),BDW("X"),BDW("Y"),BDW("LAST LOG"),BDW("LAST BEGIN"),BDW("Z"),BDW("DATE")
 Q
 ;
FIRSTRUN ; FIRST RUN EVER (NO LOG ENTRY)
 I '$D(ZTQUEUED) W !!,"No log entry.  First run ever assumed.",!
 I BDW("RUN BEGIN")="" S BDW("RUN BEGIN")=3200301
 S BDW("FIRST RUN")=1
 Q
