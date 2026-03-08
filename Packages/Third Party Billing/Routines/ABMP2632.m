ABMP2632 ; IHS/SD/SDR - 3P BILLING 2.6 Patch 32 POST INIT ;  
 ;;2.6;IHS Third Party Billing;**32**;NOV 12, 2009;Build 621
 Q
POST ;
 ;new x-refs were added; this re-indexes to populate the x-ref with existing claims
 D BMES^XPDUTL("Re-indexing a few new cross references, this may take a few minutes...")
 S ABMHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDCLM(DUZ(2))) Q:'DUZ(2)  D
 .D ^XBFMK
 .S DIK="^ABMDCLM(DUZ(2),"
 .S DIK(1)=".026^AH"
 .D ENALL^DIK
 .D ^XBFMK
 .S DA(1)=0
 .F  S DA(1)=$O(^ABMDCLM(DUZ(2),DA(1))) Q:'DA(1)  D
 ..S DIK="^ABMDCLM(DUZ(2),"_DA(1)_",69,"
 ..S DIK(1)=".01^AB"
 ..D ENALL^DIK
 ;
 D ^XBFMK
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDBILL(DUZ(2))) Q:'DUZ(2)  D
 .S DIK="^ABMDBILL(DUZ(2),"
 .S DIK(1)=".112^AH"
 .D ENALL^DIK
 S DUZ(2)=ABMHOLD
 Q
