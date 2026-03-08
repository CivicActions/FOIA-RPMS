PSN4P89D ;BIR/DMA-post install routine to load data ;31 Aug 99 / 11:32 AM
 ;;4.0; NATIONAL DRUG FILE;**89**; 30 Oct 98
 ;
 ;Reference to ^DD(50.416 supported by DBIA #4252
 I '$D(XPDGREF) Q
BUILD ;
 N DA,K,PSN
 S DA=0 F  S DA=$O(^PSNDF(50.68,DA)),K=0 Q:'DA  S PSN=$P(^(DA,0),"^",2)_"A"_DA F  S K=$O(^PSNDF(50.68,DA,2,K)) Q:'K  D
 .S ^PS(50.416,"APD",PSN,K)=""
 ;NOW THE PROTECTION
 S PSN("DD")="@",PSN("DEL")="@",PSN("WR")="@",PSN("RD")="pP",PSN("LAYGO")="@" D FILESEC^DDMOD(50.416,.PSN)
 S ^DD(50.416,.01,"LAYGO",.01,0)="D:'$D(PSNDF) EN^DDIOL(""ADDITIONS ARE NOT ALLOWED"") I $D(PSNDF)"
 K K,DA,PSN
 Q
