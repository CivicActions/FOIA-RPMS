PSNCLASS ;BIR/DMA-fix class in DRUG file ; 11 Apr 2005  12:55 PM
 ;;4.0; NATIONAL DRUG FILE;**99**; 3O Oct 98
 ;
 ; Reference to ^PSDRUG supported by DBIA #2192
 ; Reference to ^GMR(120.8) supported by DBIA #4606
 ; Reference to ^GMR(120.8) supported by DBIA #2545
 ; Reference to ^FH(119.9) supported by DBIA #4637
 ; Reference to ^PXRMXT(810.3) supported by DBIA #4642
 ; Reference to ^PXRMD(811.5) supported by DBIA #4643
 ; Reference to ^PXD(811.9) supported by DBIA #4644
 ;
 N D,DA,DIE,DR,J,K,K1,NA,NEW,NEWC,NEWC1,OLD,OLDC,VAR,X,XMDUZ,XMSUB,XMTEXT,XMY
CLASS ;EDIT AND REPOINT
 K LIST S LIST(10)=11,LIST(529)=248,LIST(530)=249,LIST(635)=11
 S DIE="^PS(50.605,",DA=10,DR=".01////AM114;1////(INACTIVE) PENICILLINS" D ^DIE
 S DIE="^PS(50.605,",DA=11,DR=".01////AM114;1////PENICILLINS AND BETA-LACTAM ANTIMICROBIALS;" D ^DIE
 S DIE="^PS(50.605,",DA=635,DR=".01////AM114;1////(INACTIVE) BETA-LACTAM ANTIMICROBIALS;" D ^DIE
 S DIE="^PS(50.605,",DA=275,DR=".01////MS101;" D ^DIE
 S DIE="^PS(50.605,",DA=276,DR=".01////MS102;" D ^DIE
 ;NOW PARENTS
 S DA=0 F  S DA=$O(^PS(50.605,DA)) Q:'DA  S X=^(DA,0),OLD=+$P(X,"^",3) I $D(LIST(OLD)) S NEW=LIST(OLD),DIE="^PS(50.605,",DR="2////"_NEW_";" D ^DIE
 ;
PRODUCT ;
 S DA=0 F  S DA=$O(^PSNDF(50.68,DA)) Q:'DA  S OLD=+$P($G(^(DA,3)),"^") I $D(LIST(OLD)) S NEW=LIST(OLD),DIE="^PSNDF(50.68,",DR="15////"_NEW_";" D ^DIE
 K ^TMP($J),^TMP("PSN",$J)
 S DA=0 F  S DA=$O(^PSDRUG(DA)) Q:'DA  I $D(^(DA,0)) D
 .I $G(^PSDRUG(DA,"ND")) S NEWC1=$P(^PSNDF(50.68,$P(^("ND"),"^",3),3),"^"),NEWC=$P(^PS(50.605,NEWC1,0),"^",1),DIE="^PSDRUG(",DR="2////"_NEWC_";25////"_NEWC1_";" D ^DIE Q
  .S OLDC=$P(^PSDRUG(DA,0),"^",2) I OLDC]"",$P($T(@OLDC),";",3)]"" S NEWC=$P($T(@OLDC),";",3),^TMP($J,$P(^(0),"^"))=OLDC_"^"_NEWC,DIE="^PSDRUG(",DR="2////"_NEWC_";" D ^DIE
 .S NEWC=$P(^PSDRUG(DA,0),"^",2) I NEWC]"" S NEWC1=$O(^PS(50.605,"B",NEWC,0)),DIE="^PSDRUG(",DR="25////"_NEWC1 D ^DIE
 ;
 ;
ALLER ;GIES
 S K=0 F  S K=$O(^GMR(120.8,K)),K1=0 Q:'K  F  S K1=$O(^GMR(120.8,K,3,K1)) Q:'K1  S OLD=+$G(^(K1,0)) I $D(LIST(OLD)) S DA=K1,DA(1)=K,DIE="^GMR(120.8,"_DA(1)_",3,",DR=".01////"_LIST(OLD) D ^DIE
 S K=0 F  S K=$O(^GMRD(120.82,K)) Q:'K  S OLD=+$P($G(^(K,0)),"^",8) I $D(LIST(OLD)) S DIE="^GMRD(120.82,",DR="6////"_LIST(OLD),DA=K D ^DIE
REINDEX ;Make sure APC xref is correct
 I $T(EN2^GMRAUIX0)']"" G DIET
 N SUB,DA,DIK,GMRAIEN,CLASS
 S SUB=0 F  S SUB=$O(^GMR(120.8,SUB)) Q:'+SUB  I $D(^GMR(120.8,SUB,3)) D
 .S GMRAIEN=+$P($G(^GMR(120.8,SUB,0)),U) Q:'GMRAIEN
 .S CLASS="" F  S CLASS=$O(^GMR(120.8,"APC",GMRAIEN,CLASS)) Q:CLASS=""  K ^GMR(120.8,"APC",GMRAIEN,CLASS,SUB)
 .S DA(1)=SUB
 .S DIK="^GMR(120.8,DA(1),3,"
 .S DIK(1)=".01^ADRG3"
 .D ENALL^DIK ;Reset the drug class xref
 ;
DIET ;ETICS SITE PARAMETERS
 S K=0 F  S K=$O(^FH(119.9,K)),K1=0 Q:'K  F  S K1=$O(^FH(119.9,K,"P",K1)) Q:'K1  S X=+$G(^(K1,0)) D
 .I $D(LIST(X)) S NEW=LIST(X),DIE="^FH(119.9,"_K_",""P"",",DA(1)=K,DA=K1,DR=".01////"_NEW D ^DIE Q
 .I '$D(^PS(50.605,X,0)) S DIE="^FH(119.9,"_K_",""P"",",DA(1)=K,DA=K1,DR=".01////@" D ^DIE
 ;
VARIABLE ;POINTERS 
 ;120.8
 S DA=0 F  S DA=$O(^GMR(120.8,DA)) Q:'DA  S X=$P($G(^(DA,0)),"^",3) I X["PS(50.605",$D(LIST(+X)) S DIE="^GMR(120.8,",VAR=LIST(+X)_";PS(50.605,",DR="1////^S X=VAR" D ^DIE
 ;810.3
 S DA(1)=0 F  S DA(1)=$O(^PXRMXT(810.3,DA(1))),DA=0 Q:'DA(1)  D
 .F  S DA=$O(^PXRMXT(810.3,DA(1),1,DA)) Q:'DA  S X=$P($G(^(DA)),"^",4) I X["PS(50.605",$D(LIST(+X)) S VAR=LIST(+X)_";PS(50.605,",DIE="^PXRMXT(810.3,"_DA(1)_",1,",DR="4////^S X=VAR" D ^DIE
 .S DA=0 F  S K=$O(^PXRMXT(810.3,DA(1),2,DA)) Q:'DA  S X=$P($G(^(DA,0)),"^") I X["PS(50.605",$D(LIST(+X)) S VAR=LIST(+X)_"PS(50.605,",DIE="^PXRMXT(810.3,"_DA(1)_",2,",DR=".01////^SET X=VAR" D ^DIE
 ;811.5
 S DA(1)=0 F  S DA(1)=$O(^PXRMD(811.5,DA(1))),DA=0 Q:'DA(1)  F  S DA=$O(^PXRMD(811.5,DA(1),20,DA)) Q:'DA  S X=$P($G(^(DA,0)),"^") I X["PS(50.605",$D(LIST(+X)) D
 .S VAR=LIST(+X)_";PS(50.605,",DIE="^PXRMD(811.5,"_DA(1)_",20,",DR=".01////^S X=VAR" D ^DIE
 ;811.9
 S DA(1)=0 F  S DA(1)=$O(^PXD(811.9,DA(1))),DA=0 Q:'DA(1)  F  S K=$O(^PXD(811.9,DA(1),20,DA)) Q:'DA  S X=$P($G(^(DA,0)),"^") I X["PS(50.605",$D(LIST(+X)) S VAR=LIST(X)_";PS(50.605,",DIE="^PXD(811.9,"_DA(1),",20,",DR=".01////^S X=VAR" D ^DIE
MESSAGE ;
 F J=1:1 S X=$P($T(TEXT+J),";",3,300) Q:X=""  S ^TMP("PSN",$J,J)=$P($T(TEXT+J),";",3)
 I '$D(^TMP($J)) S ^TMP("PSN",$J,J)="No entries were changed"
 S NA="" F K=J:1 S NA=$O(^TMP($J,NA)) Q:NA=""  S X=^(NA),^TMP("PSN",$J,K)=NA,$E(^(K),55)=$P(X,"^"),$E(^(K),65)=$P(X,"^",2)
 S XMDUZ="NDF MANAGER",XMSUB="DRUG CLASS CHANGES",XMTEXT="^TMP(""PSN"",$J,"
 K XMY S XMY("G.NDF DATA"_"@"_^XMB("NETNAME"))="",XMY(DUZ)="",DA=0 F  S DA=$O(^XUSEC("PSNMGR",DA)) Q:'DA  S XMY(DA)=""
 N DIFROM D ^XMD
 K D,DA,DIE,DR,J,K,K1,LIST,NA,NEW,NEWC,NEWC1,OLD,OLDC,VAR,X,XMDUZ,XMSUB,XMTEXT,XMY,^TMP($J),^TMP("PSN",$J)
 Q
 ;
TEXT ;OF THE MESSAGE
 ;;National Drug File patch PSN*4*99 has been installed and has assessed
 ;;VA Drug Class information in your local DRUG file (#50).
 ;; 
 ;;Entries that are matched to NDF were automatically updated to have the
 ;;updated VA Class information in the VA CLASSIFICATION (#2) and
 ;;NATIONAL DRUG CLASS (#25) fields.
 ;; 
 ;;Entries that were manually classed were also assessed.  Some may have
 ;;been updated to reflect the updated VA Class entries provided by
 ;;previous National Drug File data update patches.
 ;; 
 ;;The changed locally classed entries are listed below.  Please review
 ;;each entry and update as necessary.
 ;; 
 ;; 
 ;; DRUG                                               OLD CLASS   NEW CLASS
 ;; 
 ;
 ;
LIST ;TAG=OLD CLASS TEXT=NEW CLASS
AH200 ;;AH102
AH300 ;;AH103
AH400 ;;AH104
AH500 ;;AH105
AH600 ;;AH106
AH700 ;;AH107
AH900 ;;AH109
AM050 ;;AM114
AM051 ;;AM110
AM052 ;;AM111
AM053 ;;AM112
AM054 ;;AM113
AM100 ;;AM114
AM101 ;;AM115
AM102 ;;AM116
AM103 ;;AM117
AM104 ;;AM118
AM130 ;;AM119
BL100 ;;BL110
BL200 ;;BL118
BL300 ;;BL116
BL600 ;;BL115
BL700 ;;BL117
DE801 ;;DE810
DE802 ;;DE820
GA400 ;;GA208
GA700 ;;GA605
MS110 ;;MS101
MS120 ;;MS102
MS103 ;;MS130
MS104 ;;MS140
MS105 ;;MS150
MS106 ;;MS160
MS109 ;;MS190
OP104 ;;OP140
OP106 ;;OP160
OP201 ;;OP210
OP202 ;;OP220
OP203 ;;OP230
OP209 ;;OP219
TN401 ;;TN410
TN402 ;;TN420
TN403 ;;TN430
TN404 ;;TN440
TN405 ;;TN450
TN406 ;;TN460
TN407 ;;TN470
TN408 ;;TN475
TN409 ;;TN476
TN410 ;;TN478
