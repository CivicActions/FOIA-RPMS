BDWCOVDR ;IHS/CMI/LAB - Main Driver COVID EXPORT DATE RANGE; ; 29 Jan 2019  12:46 PM
 ;;1.0;IHS DATA WAREHOUSE;**7,11**;JAN 24, 2006;Build 14
 ;
 ;
 ;
START ;Begin processing
 D EN^XBVK("BDW"),^XBFMK K DIADD,DLAYGO
 S BDW("QFLG")=0
 ;W:$D(IOF) @IOF
 W !,$$CTR($$LOC(),80),!
 S X="*****  IHS DATA WAREHOUSE COVID-19 EXPORT IN A DATE RANGE  *****" W !,$$CTR(X,80),!
 S T="INTRO" F J=1:1 S X=$T(@T+J),X=$P(X,";;",2) Q:X="END"  W !,X
 K J,X,T
 ;
 S BDWERR=0
 D CHECK
 S BDWIEDST=$O(^INRHD("B","HL IHS DW1COVID IE",0))
 D CHKSITE^BDWCOVD1
 I BDW("QFLG") D XIT Q
 I BDWERR D XIT Q
GETDATES ;
 W !,"Please enter the date range for which COVID-19 data should be generated.",!
BD ;
 S DIR(0)="D^3200301:"_$$FMADD^XLFDT(DT,-1)_":EP",DIR("A")="Enter Beginning Date",DIR("?")="Enter the beginning date." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 S BDW("RUN BEGIN")=Y
ED ;
 S DIR(0)="D^3200301:"_$$FMADD^XLFDT(DT,-1)_":EP",DIR("A")="Enter Ending Date" D ^DIR K DIR,DA S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 I Y<BDW("RUN BEGIN") W !,"Ending date must be greater than or equal to beginning date!" G ED
 S BDW("RUN END")=Y
 S BDWERR=0
 W !!,"Log entry ",$$NLOG," will be created and data generated for ",!,"date range ",$$UP^XLFSTR($$FMTE^XLFDT(BDW("RUN BEGIN")))," to ",$$UP^XLFSTR($$FMTE^XLFDT(BDW("RUN END"))),".",!
CONT ;continue or not
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"Goodbye" D XIT Q
 I 'Y W !!,"Goodbye" D XIT Q
 S BDWRUN="NEW",BDWERR=0
 D GENLOG ;generate new log entry
 I $G(BDWERR) D XIT Q
 ;D QUEUE
 ;I $G(BDWERR) W !!,"Goodbye, no processing will occur.",! D XIT Q
 ;I $D(BDWQUE) D XIT Q
 ;
PROCESS ;EP - process new run
 S BDWDDR=1
 S BDW("RUN LOCATION")=$P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,10),BDW("QFLG")=0
 S BDW("RUN LOG")=BDWLOG
 D DRIVER^BDWCOVD
 D XIT
 Q
C(X,X2,X3) ;
 I X="" Q ""
 D COMMA^%DTC
 Q X
CHECK ;
 I '$P($G(^AUTTSITE(1,0)),U) W !!,"RPMS Site file not SET UP" S BDWERR=1 Q
 Q
QUEUE ;EP
 K ZTSK
 S DIR(0)="Y",DIR("A")="Do you want to QUEUE this to run at a later time",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y=1 D QUEUE1 Q
 I BDWRUN="NEW",$D(DIRUT) S BDWERR=1 S DA=BDWLOG,DIK="^BDWCVLOG(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA
 Q
QUEUE1 ;
 S ZTRTN="PROCESS^BDWCOVDR"
 S ZTIO="",ZTDTH="",ZTDESC="COVID DATA WAREHOUSE DATE RANGE" S ZTSAVE("BDW*")=""
 D ^%ZTLOAD
 W !!,$S($D(ZTSK):"Request Queued!!",1:"Request cancelled")
 I '$D(ZTSK),BDWRUN="NEW" S BDWERR=1 S DA=BDWLOG,DIK="^BDWCVLOG(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA Q
 S BDWQUE=""
 S DIE="^BDWCVLOG(",DA=BDWLOG,DR=".1///Q" D ^DIE K DIE,DA,DR
 K ZTSK
 Q
GENLOG ; GENERATE NEW LOG ENTRY
 D ^XBFMK K DIADD
 W:'$D(ZTQUEUED) !,"Generating New Log entry."
 S BDW("RUN DATE")=$$NOW^XLFDT
 S Y=BDW("RUN DATE") X ^DD("DD") S X=""""_Y_"""",DIC="^BDWCVLOG(",DIC(0)="L",DLAYGO=90213.2
 S DIC("DR")=".08////"_BDW("RUN BEGIN")_";.09////"_BDW("RUN END")_";.07////D;.02////"_DUZ(2)_";.14///"_$S($$PROD^XUPROD():"P",1:"T"),DIADD=1
 D ^DIC K DIC,DLAYGO,DR,DIADD
 I Y<0 S BDW("QFLG")=23 D ^XBFMK Q
 S BDWLOG=+Y
 D ^XBFMK
 Q
XIT ;exit, eoj cleanup
 D EOP
 D ^XBFMK
 D EN^XBVK("BDW")
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="End of Job.  Press ENTER.",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
DATE(D) ;EP ;IHS/CMI/LAB - new date format - format date in YYYYMMDD format
 I $G(D)="" Q ""
 Q $E(D,1,3)+1700_$E(D,4,7)
 ;
 ;
NLOG() ;get next log
 NEW X,L S (X,L)=0 F  S X=$O(^BDWCVLOG(X)) Q:X'=+X  S L=X
 Q L+1
INTRO ;introductory text
 ;;
 ;;
 ;;This program will generate COVID-19 transactions for a 
 ;;date range that you enter.  A log entry will be created which will log
 ;;the data generated.
 ;;
 ;;END
