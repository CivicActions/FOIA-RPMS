AMQQWH ; CMI/MIC/GIS - WOMEN'S HEALTH SETUP ROUTINE ;  [ 01/31/2008   5:08 PM ]
 ;;2.0;PCC QUERY UTILITY;**14,18,20,21**;FEB 07, 2007
 ;IHS/CMI/LAB patch 14 WH
SETUP ;
 N DA,DIC,DIK,X,Y,Z,%DEVOARG,%DEVTYPE
 W !!!,"SETUP ROUTINE FOR Q-MAN'S WOMEN'S HEALTH ATTRIBUTES",!!!
 I $D(^AMQQ(7,48,0)),^(0)'="WOMEN'S HEALTH" W "INVALID METADICTIONARY ENTRIES DETECTED.  SETUP CANCELLED...",*7 Q
 W "Cleaning out old metadictionary entries..."
 F Z=5,1 S DIK="^AMQQ("_Z_"," F DA=600:0 S DA=$O(^AMQQ(Z,DA)) Q:'DA  Q:DA>699  D ^DIK W "-"
 S DIK="^AMQQ(7," F DA=48:1:51 D ^DIK W "-"
 W !!,"Restoring globals...",!,"When prompted for the name of a file, enter 'AMQQWH.G'",!!
 D ^%GI
 I '$D(^AMQQ(1,675)) W "Globals not fully restored, install aborted!",!! Q
 W !!,"Restoring metadictionary indices..."
 S DIK="^AMQQ(7," F DA=48:1:51 D IX^DIK W "+"
 F Z=1,5 S DIK="^AMQQ("_Z_"," F DA=600:0 S DA=$O(^AMQQ(Z,DA)) Q:'DA  Q:DA>699  D IX^DIK W "+"
 W !!,"All metadictionary entries successfully updated!!!!",!
 W "Q-Man is now linked to the Women's Health Package."
 W !!,"Exiting setup...."
 Q
 ;
