BDWHRSET ; IHS/CMI/LAB - RESET TX LOG AUGUST 14, 1992 ;
 ;;1.0;IHS DATA WAREHOUSE;**6**;JAN 23, 2006;Build 60
 ;
 W !!,"This option will reset the Prescription Data Warehouse Export Log.  You must be",!,"absolutely sure that you have corrected the underlying problem that caused ","the Export process to fail in the first place!",!!
 W "The Prescription Data Warehouse Export log entry you choose will be REMOVED",!,"from the log file and all Utility and Data globals associated with that ",!,"run will be killed!!",!!
 W "You must now select the Log Entry to be RESET.  <<< SELECT CAREFULLY >>>",!
 S DIC="^BDWHLOG(",DIC(0)="AEMQ",DIC("S")="I $P(^BDWHLOG(Y,0),U,15)'=""C"",$P(^BDWHLOG(Y,0),U,15)'=""Q""" D ^DIC K DIC I Y=-1 W !!,"Goodbye" G EOJ
 S BDWDFN=+Y
 D DISP
 S DIR(0)="Y",DIR("A")="Are you sure you want to do this",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y'=1 D EOJ Q
DIK ;
 S DA=BDWDFN,DIK="^BDWHLOG(" D ^DIK
 K ^TMP($J,"RXBYVISIT")
 K ^BDWHTMP
 D EOJ
 Q
DISP ;
DIQ ; CALL TO DIQ
 W !!,"Information for Log Entry ",BDWDFN,!
 S DIC="^BDWHLOG(",DA=BDWDFN,DR="0;21",DIQ(0)="C" D EN^DIQ
 K DIC,DIQ,DR,DA
 Q
EOJ ;
 K DA,DIK,BDWDFN,Y,X,DIR,DIRUT
 Q
R ;
 S DA=1,DIK="^BDWHLOG(" D ^DIK
 K ^BDWHTMP
 Q
