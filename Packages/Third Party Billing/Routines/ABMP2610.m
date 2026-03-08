ABMP2610 ; IHS/SD/SDR - 3P BILLING 2.6 Patch 10 POST INIT ;  
 ;;2.6;IHS Third Party Billing;**10**;NOV 12, 2009;Build 43
 ;
 Q
POST ;
 D ICDEFFDT  ;populate ICD10 effective date for all insurers
 D CBILLRSN   ;new cancel bill reason
 D QUES  ;update export mode 21 and 31 to include referring provider question (12)
 D ^ABMFPOA  ;remove POAs that are really E-code pointers
 D ECODES
 D ERRORCD
 Q
 ;
ICDEFFDT ;
 D BMES^XPDUTL("Auto-populating ICD-10 EFFECTIVE DATE with 10/1/2013 for all insurers...")
 S ABMHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMNINS(DUZ(2))) Q:'DUZ(2)  D
 .S ABMDA=0
 .F  S ABMDA=$O(^ABMNINS(DUZ(2),ABMDA)) Q:'ABMDA  D
 ..S DIE="^ABMNINS("_DUZ(2)_","
 ..S DA=ABMDA
 ..S DR=".12////3131001"
 ..D ^DIE
 Q
CBILLRSN ;
 S DIE="^ABMCBILR("
 S DA=16
 S DR=".01////INCORRECT VERSION OF ICD BILLED"
 D ^DIE
 Q
QUES ;
 S DIE="^ABMDEXP("
 F DA=21,31 D
 .S DR=".08////"_$P($G(^ABMDEXP(DA,0)),U,8)_",12"
 .D ^DIE
 Q
ECODES ;
 ;70844
 K DIC,DIE,DIR,X,Y,DA,DR
 S DIC="^ABMDCODE("
 S DIC(0)="ML"
 S X="G0"
 S DIC("DR")=".02////C"
 S DIC("DR")=DIC("DR")_";.03////DISTINCT MEDICAL VISIT"
 K DD,DO
 D ^DIC
 ;
 K DIC,DIE,DIR,X,Y,DA,DR
 S DIC="^ABMDCODE("
 S DIC(0)="ML"
 S X="82"
 S DIC("DR")=".02////V"
 S DIC("DR")=DIC("DR")_";.03////CO-INSURANCE DAYS"
 K DD,DO
 D ^DIC
 ;
 K DIC,DIE,DIR,X,Y,DA,DR
 S DIC="^ABMDCODE("
 S DIC(0)="ML"
 S X="83"
 S DIC("DR")=".02////V"
 S DIC("DR")=DIC("DR")_";.03////LIFETIME RESERVE DAYS"
 K DD,DO
 D ^DIC
 ;
 ;74309
 K DIC,DIE,DIR,X,Y,DA,DR
 S DIC="^ABMDCODE("
 S DIC(0)="ML"
 S X="5"
 S DIC("DR")=".02////A"
 S DIC("DR")=DIC("DR")_";.03////"
 K DD,DO
 D ^DIC
 K DIC,DIE,DIR,X,Y,DA,DR
 S DIC="^ABMDCODE("
 S DIC(0)="ML"
 S X="6"
 S DIC("DR")=".02////A"
 S DIC("DR")=DIC("DR")_";.03////"
 K DD,DO
 D ^DIC
 K DIC,DIE,DIR,X,Y,DA,DR
 S DIC="^ABMDCODE("
 S DIC(0)="ML"
 S X="E"
 S DIC("DR")=".02////A"
 S DIC("DR")=DIC("DR")_";.03////"
 K DD,DO
 D ^DIC
 K DIC,DIE,DIR,X,Y,DA,DR
 S DIC="^ABMDCODE("
 S DIC(0)="ML"
 S X="F"
 S DIC("DR")=".02////A"
 S DIC("DR")=DIC("DR")_";.03////S"
 K DD,DO
 D ^DIC
 Q
ERRORCD ;
 ;HEAT72979
 ;19 - Accident hour unspecified
 K DIC,X,DIE
 S DIE="^ABMDERR("
 S DA=19
 S DR=".01///ACCIDENT HOUR OR STATE UNSPECIFIED;.02///Jump to Page 3 and then Edit Item Number 4 (Accident Related) Enter the Hour or State that the accident occurred.;.03///E"
 D ^DIE
 D SITEEDIT(19)
 ;
 ;HEAT65628
 ;242 - Imprecise service dates
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=242
 S X="Imprecise Service Date(s)"
 S DIC("DR")=".02///Make Service From and Service To Dates precise"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(242)
 ;
 ;ICD10 002F
 ;243 - Other DX Codes Exist - Update necessary
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=243
 S X="OTHER DX CODES EXIST - UPDATES NECESSARY"
 S DIC("DR")=".02///Use View option to view and possibly re-code claim"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 D SITE(243)
 Q
 ;
SITE(ABMX) ;
 S DUZHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDCLM(DUZ(2))) Q:'+DUZ(2)  D
 .S DIC(0)="LX"
 .S DA(1)=ABMX
 .S DIC="^ABMDERR("_DA(1)_",31,"
 .S DIC("P")=$P(^DD(9002274.04,31,0),U,2)
 .S DINUM=DUZ(2)
 .S X=$P($G(^DIC(4,DUZ(2),0)),U)
 .S DIC("DR")=".03////"_$S(ABMX=243:"W",1:"E")
 .D ^DIC
 .K DA,DIC,DINUM
 S DUZ(2)=DUZHOLD
 K DUZHOLD,DLAYGO,ABMX
 Q
SITEEDIT(ABMX) ;Add SITE multiple
 S DUZHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDCLM(DUZ(2))) Q:'+DUZ(2)  D
 .S DA(1)=ABMX
 .S DIE="^ABMDERR("_DA(1)_",31,"
 .S DA=DUZ(2)
 .S DR=".03////E"
 .D ^DIE
 .K DA,DIC,DINUM,DIE
 S DUZ(2)=DUZHOLD
 K DUZHOLD,DLAYGO,ABMX
 Q
