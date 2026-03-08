ADE6P343 ;IHS/OIT/GAB - ADE V6.0 PATCH 34 [ 11/22/2019  10:51 AM ]
 ;;6.0;ADE*6.0*34;;March 25, 1999;Build 68
 ;IHS/OIT/GAB 11/2019 Patch 34 ADA-CDT code updates for 2020
 ;Deactivated 5 ADA-CDT Codes
 ;
DELCDT34 ;EP
 D DELETES^ADEUPD34("DELADA^ADE6P343","SETX^ADE6P343","^AUTTADA(")
 Q
 ;
SETX ;EP
 S ADEX=$P($P(ADEX,U),"D",2),ADEX=$O(^AUTTADA("B",ADEX,""))
 Q
 ;
DELADA ;  CODE & NOMENCLATURE
 ;;D1555^removal of fixed space maintainer
 ;;D8691^repair of orthodontic appliance
 ;;D8692^replacement of lost or broken retainer
 ;;D8693^re-cement or re-bond fixed retainer
 ;;D8694^repair of fixed retainers, includes reattachment
 ;;***END***
MODADA ;
 Q
ZAPINA ;REMOVE INACTIVE DATE
 ;/IHS/OIT/GAB COMMENTED OUT NEXT THREE LINES, NO REACTIVATED CODES
 ;S ADEIRN=""
 ;S ADEIRN=$O(^AUTTADA("B","0191",0)) I +ADEIRN D ZAPIT
 ;S ADEIRN=$O(^AUTTADA("B","1208",0)) I +ADEIRN D ZAPIT
 Q
ZAPIT ;
 ;/IHS/OIT/GAB COMMENTED OUT BELOW - NO REACTIVATED CODES
 ;S DIE="^AUTTADA(",DA=ADEIRN
 ;S DR=".08////@" D ^DIE
 ;S ADEIRN=""
 Q
ZAP K D,DA,DR,DIE,D0,DIC,ADEIRN
 Q
