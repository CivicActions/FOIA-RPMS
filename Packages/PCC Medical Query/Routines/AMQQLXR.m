AMQQLXR ; OHPRD/DG - SETS AQ1 XREF ON BLOOD QUANTUM FLD IN PT FILE ;  [ 01/31/2008   5:08 PM ]
 ;;2.0;PCC QUERY UTILITY;**9,18,20,21**;FEB 07, 2007
REINDEX ;
 S U="^"
 I $P(^AUTTSITE(1,0),U,19)'="Y" W *7,!,"""AQ"" indices for Q-MAN not currently set up.",!,"Use Q-MAN site manager option to create these indices." Q
 K ^AUPNPAT("AQ1")
 F DA=0:0 S DA=$O(^AUPNPAT(DA)) Q:'DA  S X=$P($G(^(DA,11)),U,10) K AMQQQXR D QXR I $D(AMQQQXR) S ^AUPNPAT("AQ1",AMQQQXR,DA)=""
 K ^AUPNPAT("AQ2") ;IHS/OHPRD/TMJ 6/24/96 Patch #9
 F DA=0:0 S DA=$O(^AUPNPAT(DA)) Q:'DA  S X=$P($G(^(DA,11)),U,9) K AMQQQXR D QXR I $D(AMQQQXR) S ^AUPNPAT("AQ2",AMQQQXR,DA)="" ;IHS/OHPRD/TMJ 6/24/96 Patch #9
 Q
 ;
QXR ; ENTRY POINT
 I X="" Q
 N % S %=X N X
 I %["/" S %=(+%/$S($P(%,"/",2):$P(%,"/",2),1:1)) S:$E(%)="." %=0_%,AMQQQXR=$E(%,1,8)+1 S:'$D(AMQQQXR) AMQQQXR=%+1 Q  ;IHS/OHPRD/TMJ 6/24/96 Patch #9
 S %=$S($E(%)="F":2,$E(%)="N":1,$E(%,1,3)="UNK":2.1,$E(%,1,3)="UNS":2.2,1:"")
 I %'="" S AMQQQXR=%
 Q
 ;
