ABMP2628 ; IHS/SD/SDR - 3P BILLING 2.6 Patch 28 POST INSTALL ;  
 ;;2.6;IHS Third Party Billing;**28**;NOV 12, 2009;Build 513
 ;
 ;IHS/SD/SDR 2.6*28 Make sure FETM options are locked or unlocked appropriately based on p27 CUFE cleanup being done or not
 ;
POST ;EP
 S ABMFT=0
 S ABMFTOK=0
 F  S ABMFT=$O(^ABMDFEE(ABMFT)) Q:'ABMFT  D
 .I $P($G(^ABMDFEE(ABMFT,0)),U,6)="" S ABMFTOK=1  ;ABMFTOK=1 means a fee table isn't complete
 D ^XBFMK
 I ABMFTOK=0 D  ;all fee tables are complete
 .F ABMA="ABMD TM FEE MAINT","ABMD TM FEE LISTING","ABMD TM FEE DRUG","ABMD TM FEE FOREIGN","ABMD TM FEE PERCENT","ABMD TM FEE CPT VIEW" D
 ..S DA=$O(^DIC(19,"B",ABMA,0))
 ..S DIE="^DIC(19,"
 ..S DR="2////@"
 ..D ^DIE
 .S DA=$O(^DIC(19,"B","ABMD TM CLEANUP FEE TABLE",0))
 .S DR="2////All fee tables reviewed - no action needed"
 .S DIE="^DIC(19,"
 .D ^DIE
 I ABMFTOK=1 D
 .F ABMA="ABMD TM FEE MAINT","ABMD TM FEE DRUG","ABMD TM FEE FOREIGN","ABMD TM FEE PERCENT" D
 ..S DA=$O(^DIC(19,"B",ABMA,0))
 ..S DIE="^DIC(19,"
 ..S DR="2////USE 'CUFE' TO CLEANUP FEE TABLE AND REACTIVATE"
 ..D ^DIE
 .S DA=$O(^DIC(19,"B","ABMD TM CLEANUP FEE TABLE",0))
 .S DR="2////@"
 .S DIE="^DIC(19,"
 .D ^DIE
 Q
