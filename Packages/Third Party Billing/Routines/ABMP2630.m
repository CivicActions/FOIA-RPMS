ABMP2630 ; IHS/SD/SDR - 3P BILLING 2.6 Patch 30 POST INIT ;  
 ;;2.6;IHS Third Party Billing;**30**;NOV 12, 2009;Build 585
 Q
POST ;
 D CCREASON  ;new cancelled claim reason for CR8338
 D EXP36  ;new export mode ADA-2019 for CR11171
 D ERRCODE  ;CR8939 and CR10215
 ;
 Q
 ;
CCREASON ;
 K DIC,X,DINUM,DR,DLAYGO
 S DIC="^ABMCCLMR("
 S DIC(0)="LM"
 S X="EXCEEDS MAXIMUM VISITS ALLOWED"
 D ^DIC
 Q
 ;
EXP36 ;
 K DIC,DR,DINUM,DLAYGO,DIE
 S DIC="^ABMDEXP("
 S DIC(0)="LM"
 S DLAYGO=9002274
 S X="ADA-2019",DINUM=36
 K DD,DO
 D ^DIC
 Q:Y<0
 S DA=+Y
 S DIE="^ABMDEXP("
 S DR=".04////ABMDF36;.05////ABMDF36X;.06///C;.07///ADA Claim Form dated 2019, J-430;.08///1,2,3,4,9,16,17,18,32,33;.11////ABMDES4;.15///H"
 D ^DIE
 Q
 ;
ERRCODE ;
 ;256 - ATTENDING AND RENDERING PROVIDER MISSING
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=256
 S X="ATTENDING AND/OR RENDERING PROVIDER MISSING"
 S DIC("DR")=".02///Add Attending and/or Rendering provider on page4"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(256)
 ;
 ;257 - Discharge Status contains 'Expired'
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=257
 S X="Discharge Status contains 'Expired'"
 S DIC("DR")=".02///DISCHARGE STATUS INDICATES THE PATEINT EXPIRED - VERIFY THIS IS CORRECT"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 D SITE(257)
 ;
 ;21 - update 21 from warning to error
 S DIE="^ABMDERR("
 S DA=21
 S DR=".03////E"
 S DR=DR_";.02////[J]ump to either Questions Page (3) or Inpatient Data Page (7) and [E]dit the Discharge Status field so that it is specified."
 D ^DIE
 D SITE2(21)
 ;
 Q
 ;
SITE(ABMX) ;Add SITE multiple
 S DUZHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDCLM(DUZ(2))) Q:'+DUZ(2)  D
 .S DIC(0)="LX"
 .S DA(1)=ABMX
 .S DIC="^ABMDERR("_DA(1)_",31,"
 .S DIC("P")=$P(^DD(9002274.04,31,0),U,2)
 .S DINUM=DUZ(2)
 .S X=$P($G(^DIC(4,DUZ(2),0)),U)
 .S DIC("DR")=".03////"_$S(ABMX=256:"E",ABMX=21:"E",1:"W")
 .D ^DIC
 .K DA,DIC,DINUM
 S DUZ(2)=DUZHOLD
 K DUZHOLD,DLAYGO,ABMX
 Q
SITE2(ABMX) ;EP
 S DA(1)=21
 S DA=0
 S DIE="^ABMDERR("_DA(1)_",31,"
 F  S DA=$O(^ABMDERR(21,31,DA)) Q:'DA  D
 .S DR=".03///E"
 .D ^DIE
 Q
