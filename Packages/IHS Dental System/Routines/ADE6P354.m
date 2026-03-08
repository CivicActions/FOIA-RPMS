ADE6P354 ;IHS/OIT/GAB - ADE V6.0 PATCH 35 [ 11/22/2020 8:37 AM ]
 ;;6.0;ADE*6.0*35;;March 25, 1999;Build 82
 ;IHS/OIT/GAB 11/2020 Patch 35 ADA-CDT code updates for 2021
 ;Modification of 2021 ADA-CDT Codes - Update the OPSITE VALUE
MOD2CDT ;EP
 D P1
 Q
P1 ;
 ;No Opsite changes (Delete 'NO OPSITE' fld)
 N DIE,DR,DA,CODE
 F CODE="7993","7994" D
 .S DA=0
 .S DA=$O(^AUTTADA("B",CODE,DA))
 .S DIE="^AUTTADA(",DR=".09////"_"@" D ^DIE K DA,DIE,DR
 Q
