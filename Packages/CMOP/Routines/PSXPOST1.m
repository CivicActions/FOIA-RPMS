PSXPOST1 ;BIR/HTW-Post Initialization Routine ;[ 04/08/97   2:06 PM ]
 ;;2.0;CMOP;;11 Apr 97
 S XQABT4=$H
 W !,"NOTE: This routine will be deleted from your system after running to completion."
 G:^XMB("NETNAME")?1"CMOP-".E HOST
 G:^XMB("NETNAME")'?1"CMOP-".E REMOTE
 Q
HOST ; Delete Medical Center Options at Host CMOPs
 W !,"The HOST installation is now REMOVING medical center options and files."
 S PSX="PSXQ" F  S PSX=$O(^DIC(19,"B",PSX)) Q:PSX'?1"PSXR".E  S DA=$O(^DIC(19,"B",PSX,0)) Q:'DA  S DIK="^DIC(19," D ^DIK W "."
 F FILE=550,550.1,550.2 I $D(^DD(FILE)) S DIU=FILE,DIU(0)="D" W "." D EN^DIU2 K DIU
 W !,"Done."
 Q
REMOTE ; Delete Host CMOP Options at Medical Centers
 W !,"The Medical Center installation is now REMOVING host options and files."
 S PSX="PSX" F  S PSX=$O(^DIC(19,"B",PSX)) Q:PSX'?1"PSX ".E  S DA=$O(^DIC(19,"B",PSX,0)) Q:'DA  S DIK="^DIC(19," D ^DIK W "."
 F FILE=552,552.1,552.2,552.3,552.4,552.5,553,553.1,554,555 I $D(^DD(FILE)) S DIU=FILE,DIU(0)="D"  W "." D EN^DIU2 K DIU
 I '$D(DT) S %DT="",X="T" D ^%DT S DT=Y
 ;IHS/MSC/PLS - Next 8 lines commented out - S SITES="CHARLESTON^LEAVENWORTH^WEST LA^MURFREESBORO^DALLAS^BEDFORD^HINES"
 ;S DM1=".MED.VA.GOV",SITES1="CHAR^LEAV^WLA^MURF^DAL^BED^HINES"
 ;K DD,DO
 ;S DIC="^PSX(550,",DIC(0)="LZ",DLAYGO=550
 ;F I=1:1:7 S S1=$P(SITES,"^",I) Q:S1=""  S SITE(I)=S1
 ;F J=1:1:7 S S2=$P(SITES1,"^",J) Q:S2=""  S DOMAIN="CMOP-"_S2_DM1,DREC=$O(^DIC(4.2,"B",DOMAIN,"")),SITE(J)=$G(SITE(J))_"^"_$G(DOMAIN)_"^"_$G(DREC)
 ;F K=1:1:7 S S3=$G(SITE(K)),X=$P(S3,"^",1),DMN=$P(S3,"^",3) S PSX=$O(^PSX(550,"B",X,"")) I $G(PSX)="" S DIC("DR")="1////I;2////H;3////"_$G(DMN) D FILE^DICN
 ;K SITES,I,S1,S2,S3,K,J,DM1,DIC,DIC(0),DLAYGO,X,Y,DIC("DR"),DR,SITES1,SITE
 W !,"Remember to configure the DAYS TO PULL SUSPENDED CS CMOP parameter."
 W !,"Remember to run the Setup CS Auto-transmission option [PSXR AUTO TRANSMIT CS]."
 W !,"Both procedures are described in the Post-Installation section of the CMOP CS"
 W !,"Installation Guide." 
 W !,"Done."
 Q
