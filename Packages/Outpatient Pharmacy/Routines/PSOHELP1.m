PSOHELP1 ;BHAM/ISC/SAB - OUTPATIENT HELP TEXT/UTILITY ROUTINE 2  [ 05/14/1998  5:27 PM ]
 ;;6.1;OUTPATIENT PHARMACY;**1**;03/13/98
 ;;6.0;OUTPATIENT PHARMACY;**6,84**;09/03/97
2001 W !!,"Enter the lowest prescription number for this site.",!,"If this is the first time you are entering this field,"
 W !,"you should pick a number LARGER than the last prescription number used.",!! Q
 ;
2002 W !!,"Enter the largest acceptable prescription number for this site.",!,"The difference between this number and the lowest prescription"
 W !,"number should be substantial.  The system will not allow numbers",!,"larger than the one you choose.  It will give a warning message",!,"and not allow entry of any more prescriptions.",!!
 Q
 ;
2003 W !!,"Enter the last prescription number used.",!,"If you are entering this for the first time, this number",!,"should be the same as the number you entered for LOW RX#"
 W !,"The system will take this number, increment it by one",!,"until it finds a number that has not been used, and then",!,"use that number for the next prescription",!!
 Q
 ;IHS/DSD/ENM 01/08/97 CLOZAPINE QUEUE REMOVED
 ;IHS/DSD/ENM 06/26/97 REF TO FILE 19 NOW LOOK AT 19.2
AUTOQ ;ENTRY POINT ;IHS/DSD/ENM 12/04/97
 S APSPDA=$O(^DIC(19,"B","PSO AMIS COMPILE",0)) G:'APSPDA EXIT
 ;SETUP OPTION IN OPTION SCHEDULING FILE 19.2 IF IT DOESN'T EXIST 
 S DA=$O(^DIC(19.2,"B",APSPDA,0)) G:'DA OPTX
 D AUTOQ1
 Q
 ;CREATE OPTION
OPTX S DIC="^DIC(19.2,",DIC(0)="MZ",X=APSPDA,DIC("DR")="6///24H"
 K DD,DO D FILE^DICN K DIC
 S APSPDA1=$O(^DIC(19.2,"B",APSPDA,0)) G:'APSPDA1 EXIT
 D AUTOQ1
 Q
EXIT K APSPDA,APSPDA1
 Q
AUTOQ1 ;IHS/DSD/ENM 12/04/97
 S DR="W $P($G(^DIC(19,$P($G(Y(0)),""^""),0)),""^"",2);"_2,DIC(0)="ZM",(DIE,DIC)="^DIC(19.2," F X="PSO AMIS COMPILE","APSA AWP AUTO QUEUE" D ^DIC W ! S DA=+Y L +^DIC(19.2,DA) D ^DIE L -^DIC(19.2,DA) K Y W !!
CLO K C,D,D0,DI,DQ,DA,DIE,DR,DIC,Y,X,APSPDA,APSPDA1
 Q
EXP ;reset "P","A" xref in 55 from cancel option
 I REA="C" K:$P(^PSRX(DA,2),"^",6) ^PS(55,PSODFN,"P","A",$P(^(2),"^",6),DA) S ^PS(55,PSODFN,"P","A",DT,DA)="",$P(^PSRX(DA,3),"^",5)=DT Q
 S PCD=+$P($G(^PSRX(DA,3)),"^",5) I 'PCD D  K EXP,PCD,IFN Q
 .S (IFN,EXP)=0
 .F  S EXP=$O(^PS(55,PSODFN,"P","A",EXP)) Q:'EXP  F  S IFN=$O(^PS(55,PSODFN,"P","A",EXP,IFN)) Q:'IFN  I IFN=DA K ^PS(55,PSODFN,"P","A",EXP,DA) S ^PS(55,PSODFN,"P","A",$P(^PSRX(DA,2),"^",6),DA)=""
 K ^PS(55,PSODFN,"P","A",PCD,DA) S ^PS(55,PSODFN,"P","A",$P(^PSRX(DA,2),"^",6),DA)="",$P(^PSRX(DA,3),"^",5)=""
 K PCD Q
SREF ;set "P","A" xref in 55 from fileman
 I $P($G(^PSRX(X,0)),"^",15)=12,'$P($G(^PSRX(X,3)),"^",5) D  Q
 .F PX=0:0 S PA=$O(^PSRX(X,"A",PX)) Q:'PX  S:$P(^PSRX(X,"A",PX,0),"^",2)="C" PCD=$P($P(^PSRX(X,"A",PX,0),"^"),".")
 .I $G(PCD) S ^PS(55,DA(1),"P","A",PCD,X)="",$P(^PSRX(X,3),"^",5)=PCD
 .E  S:$P($G(^PSRX(X,2)),"^",6) ^PS(55,DA(1),"P","A",$P(^PSRX(X,2),"^",6),X)=""
 .K PCD,PX
 I $P($G(^PSRX(X,0)),"^",15)=12,$P($G(^PSRX(X,3)),"^",5) S ^PS(55,DA(1),"P","A",$P(^PSRX(X,3),"^",5),X)="" Q
 S:$P($G(^PSRX(X,2)),"^",6) ^PS(55,DA(1),"P","A",$P(^PSRX(X,2),"^",6),X)=""
 Q
KREF ;kill "P","A" xref in 55 from fileman
 K:+$P($G(^PSRX(X,2)),"^",6) ^PS(55,DA(1),"P","A",+$P(^PSRX(X,2),"^",6),X)
 I $P($G(^PSRX(X,0)),"^",15)=12,'$P($G(^PSRX(X,3)),"^",5) D  K PCD,PX Q
 .F PX=0:0 S A=$O(^PSRX(X,"A",PX)) Q:'PX  S:$P(^PSRX(X,"A",PX,0),"^",2)="C" PCD=$P($P(^PSRX(X,"A",PX,0),"^"),".")
 .I $G(PCD) K ^PS(55,DA(1),"P","A",PCD,X)
 I $P($G(^PSRX(X,0)),"^",15)=12,$P($G(^PSRX(X,3)),"^",5) K ^PS(55,DA(1),"P","A",$P(^PSRX(X,3),"^",5),X)
 Q
DAYS1 ;EP
 W !,"This is the days supply of a refill!",!
 Q
