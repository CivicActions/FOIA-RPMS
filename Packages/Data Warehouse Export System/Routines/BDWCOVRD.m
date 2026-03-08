BDWCOVRD ; IHS/CMI/LAB - REDO A COVID RUN ;
 ;;1.0;IHS DATA WAREHOUSE;**7,11**;JAN 24, 2006;Build 14
START ;
 D EN^XBVK("BDW")
 I $D(^BDWCTMP) W !!,"Previous run not completed." D  D EOJ Q
 .S DIR(0)="EO",DIR("A")="Press ENTER to continue" K DA D ^DIR K DIR
 S BDWO("RUN")="REDO" ;     Let ^BDWHRDRI know this is a 'REDO'
 S BDWO("RUN TYPE")="REX"
 D ^BDWCOVD1
 I BDW("QFLG")=66 W:'$D(ZTQUEUED) !,"Contact your site manager.  ^BDWCTMP still exists." D  D EOJ Q
 .S DIR(0)="EO",DIR("A")="Press ENTER to continue" K DA D ^DIR K DIR
 I BDW("QFLG") D EOJ W !!,"Bye",!! Q
 D INIT ;               Get Log entry to redo
 I BDW("QFLG") D EOJ W !!,"Bye",!! Q
 ;D QUEUE^BDWCOVD1
 ;I BDW("QFLG") D EOJ W !!,"Bye",!! Q
 ;I $D(BDWO("QUEUE")) D EOJ W !!,"Okay your request is queued!",!! Q
 ;
EN ;EP FROM TASKMAN
 S BDWLOG=BDW("RUN LOG")
 D NOW^%DTC S BDW("RUN START")=% K %,%H,%I
 D ^XBFMK S DA=BDWLOG,DIE="^BDWCVLOG(",DR=".01////"_BDW("RUN START")_";.1///R"_";.14///"_$S($$PROD^XUPROD():"P",1:"T") D ^DIE,^XBFMK
 S BDW("BT")=$HOROLOG
 D PROCESS ;            Generate transactions
 ;S DIR(0)="EO",DIR("A")="DONE -- Press ENTER to Continue" K DA D ^DIR K DIR
 D EOJ
 Q
 ;
PROCESS ;
 K ^BDWCVLOG(BDW("RUN LOG"),21)  ;clean out old data
 K ^BDWCVLOG(BDW("RUN LOG"),11)
 ;GET BEGIN AND END DATES FOR RUN
 S BDW("RUN BEGIN")=$P(^BDWCVLOG(BDWLOG,0),U,8)
 S BDW("RUN END")=$P(^BDWCVLOG(BDWLOG,0),U,9)
 D DRIVER^BDWCOVD
 Q
 ;
LOG ;
 W:'$D(ZTQUEUED) !,"Updating log entry."
 D NOW^%DTC S BDW("RUN STOP")=%
 S DA=BDWLOG,DIE="^BDWCVLOG("
 S DR=".04////"_BDW("RUN STOP") D ^DIE I $D(Y) S BDW("QFLG")=26 Q
 K DIE,DA,DR
 Q
INIT ;
 Q:BDW("QFLG")
 W !,"Type a ?? and press enter at the following prompt to view a list of ORIGINAL RUN DATES.",!,"Or, if you know the original run date you can enter it in the format MM/DD/YY:  e.g. 2/26/19",!
 S DIC="^BDWCVLOG(",DIC(0)="AEQ",DIC("S")="I $P(^(0),U,10)=""C""" D ^DIC K DIC
 I Y<0 S BDW("QFLG")=99 Q
 S (BDW("RUN LOG"),BDWLOG)=+Y
 ;
 S X=^BDWCVLOG(BDW("RUN LOG"),0),BDW("RUN BEGIN")=$P(X,U,8),BDW("RUN END")=$P(X,U,9)
 S Y=BDW("RUN BEGIN") S BDW("PRINT BEGIN")=$$UP^XLFSTR($$FMTE^XLFDT(Y))
 S Y=BDW("RUN END") S BDW("PRINT END")=$$UP^XLFSTR($$FMTE^XLFDT(Y))
 W !!,"Log entry ",BDW("RUN LOG")," was for date range ",BDW("PRINT BEGIN")," through",!,BDW("PRINT END"),"."
RDD ;
 S DIR(0)="Y",DIR("A")="Do you want to regenerate the data warehouse export file for this run",DIR("B")="N" K DA D ^DIR K DIR
 I $D(DIRUT)!'Y S BDW("QFLG")=99 Q
 Q
ABORT ; ABNORMAL TERMINATION
 I $D(BDW("RUN LOG")) S DA=BDW("RUN LOG"),DIE="^BDWCVLOG(",DR=".1///F" D ^DIE K DA,DIE
 I $D(ZTQUEUED) D EOJ Q
 ;W !!,"Abnormal termination!!  QFLG=",BDW("QFLG")
 S DIR(0)="EO",DIR("A")="Press ENTER to continue" K DA D ^DIR K DIR
 Q
 ;
EOJ ;
 D EN^XBVK("BDW")
 I $D(ZTQUEUED) S ZTREQ="@"
 Q
