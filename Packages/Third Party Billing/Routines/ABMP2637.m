ABMP2637 ; IHS/SD/SDR - 3P BILLING 2.6 Patch 37 POST INIT ;  
 ;;2.6;IHS Third Party Billing;**37**;NOV 12, 2009;Build 739
 ;
 Q
POST ;EP
 D CODE2  ;ADO84370
 D CODE10  ;ADO84370
 D EXPNUM  ;ADO75349
 D WARN261  ;ADO89299
 Q
CODE2 ;
 S DA=+$O(^ABMDCODE("AC","H","02",0))
 I DA'=0 D  Q
 .K DIE,X
 .S DIE="^ABMDCODE("
 .S DR=".03///Telehealth Provided Other than in Patient's Home"
 .D ^DIE
 ;
 ;this next section is just in case they don't have '02' for some reason
 K DIC,X
 S DIC="^ABMDCODE("
 S DIC(0)="ML"
 S X="02"
 S DIC("DR")=".02///H"
 S DIC("DR")=DIC("DR")_";.03///Telehealth Provided Other than in Patient's Home"
 K DD,DO
 D FILE^DICN
 Q
CODE10 ;
 I +$O(^ABMDCODE("AC","H",10,0))'=0 Q  ;entry already exists
 K DIC,X
 S DIC="^ABMDCODE("
 S DIC(0)="ML"
 S X="10"
 S DIC("DR")=".02///H"
 S DIC("DR")=DIC("DR")_";.03///Telehealth Provided in Patient's Home"
 K DD,DO
 D FILE^DICN
 Q
EXPNUM ;
 D BMES^XPDUTL("Populating the EXPORT DATE on 3P Bills...")
 S ABMCNT=0
 S ABMHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDBILL(DUZ(2))) Q:'DUZ(2)  D
 .S DIE="^ABMDBILL(DUZ(2),"
 .S ABMBDFN=0
 .F  S ABMBDFN=$O(^ABMDBILL(DUZ(2),ABMBDFN)) Q:'ABMBDFN  D
 ..Q:($G(^ABMDBILL(DUZ(2),ABMBDFN,0))="")  ;no zero node for bill
 ..Q:(+$P($G(^ABMDBILL(DUZ(2),ABMBDFN,1)),U,7)=0)  ;no EXPORT NUMBER to figure out the date from
 ..Q:('$D(^ABMDTXST(DUZ(2),+$P($G(^ABMDBILL(DUZ(2),ABMBDFN,1)),U,7),0)))  ;broken pointer to 3P TX Status file
 ..S ABMCNT=ABMCNT+1
 ..S DA=ABMBDFN
 ..S DR=".172////"_$P($P(^ABMDTXST(DUZ(2),$P(^ABMDBILL(DUZ(2),ABMBDFN,1),U,7),0),U),".")  ;export date
 ..D ^DIE
 ..I (ABMCNT#5000&(IOST["C")) U IO(0) W ".+"
 S DUZ(2)=ABMHOLD
 Q
WARN261 ;ADO89299 New warning for missing ordering provider when controlled substance
 ;261 - Missing ordering provider
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=261
 S X="The Ordering Provider is missing from this medication"
 S DIC("DR")=".02///Add the Ordering Provider"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 D SITE(261)
 Q
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
 .S DIC("DR")=".03////W"
 .D ^DIC
 .K DA,DIC,DINUM
 S DUZ(2)=DUZHOLD
 K DUZHOLD,DLAYGO,ABMX
 Q
