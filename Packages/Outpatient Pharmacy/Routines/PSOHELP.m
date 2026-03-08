PSOHELP ;BHAM/ISC/SAB - OUTPATIENT HELP TEXT/UTILITY ROUTINE ;2/17/93 18:00:36 [ 08/29/2003  3:30 PM ]
 ;;6.0;OUTPATIENT PHARMACY;**3,4**;09/03/97
 ;;6.0;OUTPATIENT PHARMACY;**7,69,111,126,133,137,145,173**;09/03/97
XREF ;code to create 'APD' xref on Drug Interaction file (#56)
 ;I '$D(ZTQUEUED),'$D(PSMSG) D WAIT^DICD W "Building 'APD' X-Ref."
 S ID1=$P(^PS(56,DA,0),"^",2),ID2=$P(^(0),"^",3),TOT=0
 F I1=0:0 S I1=$O(^PS(50.416,ID1,1,I1)) Q:'I1  S R2=$P(^(I1,0),"^") F I2=0:0 S I2=$O(^PS(50.416,ID2,1,I2)) Q:'I2  S D2=$P(^(I2,0),"^") W:+$G(PSMSG) "." D SEC
 F I1=0:0 S I1=$O(^PS(50.416,"APS",ID1,I1)) Q:'I1  F I3=0:0 S I3=$O(^PS(50.416,I1,1,I3)) Q:'I3  S R2=$P(^(I3,0),"^") F I5=0:0 S I5=$O(^PS(50.416,"APS",ID2,I5)) Q:'I5  F I6=0:0 S I6=$O(^PS(50.416,I5,1,I6)) Q:'I6  S D2=$P(^(I6,0),"^") D SEC
 F I1=0:0 S I1=$O(^PS(50.416,ID1,1,I1)) Q:'I1  S R2=$P(^(I1,0),"^") F I5=0:0 S I5=$O(^PS(50.416,"APS",ID2,I5)) Q:'I5  F I6=0:0 S I6=$O(^PS(50.416,I5,1,I6)) Q:'I6  S D2=$P(^(I6,0),"^") D SEC
 F I2=0:0 S I2=$O(^PS(50.416,ID2,1,I2)) Q:'I2  S D2=$P(^(I2,0),"^") F I1=0:0 S I1=$O(^PS(50.416,"APS",ID1,I1)) Q:'I1  F I3=0:0 S I3=$O(^PS(50.416,I1,1,I3)) Q:'I3  S R2=$P(^(I3,0),"^") D SEC
 S $P(^PS(56,DA,0),"^",6)=TOT
EX K TOT,I5,I6,D2,I4,I3,PRI,I1,I2,R2,PS1,PS2,ID2,ID1
 Q
SEC I +$G(DEL) K ^PS(56,"APD",R2,D2,DA),^PS(56,"APD",D2,R2,DA) Q
 S ^PS(56,"APD",R2,D2,DA)="",^PS(56,"APD",D2,R2,DA)="",TOT=TOT+2
 Q
SIG ;checks SIG for RXs
 I $E(X)=" " W !,"Leading spaces are not allowed in the SIG! " K X Q
SIGONE S SIG="" Q:$L(X)<1  F Z0=1:1:$L(X," ") G:Z0="" EN S Z1=$P(X," ",Z0) D  G:'$D(X) EN
 .I $L(Z1)>32 W !?5,"MAX OF 32 CHARACTERS ALLOWED BETWEEN SPACES.",! K X Q
 .D:$D(X)&($G(Z1)]"")  S SIG=SIG_" "_Z1
 ..S Y=$O(^PS(51,"B",Z1,0)) Q:'Y!($P($G(^PS(51,+Y,0)),"^",4)>1)  S Z1=$P(^PS(51,Y,0),"^",2) Q:'$D(^(9))  S Y=$P(X," ",Z0-1),Y=$E(Y,$L(Y)) S:Y>1 Z1=^(9)
EN K Z1,Z0
 Q
QTY ;Check quantity dispensed against inventory
 QUIT  ;WHO CARES IHS/OKCAO/POC 10/30/97
 S Z0=$S($G(PSODRUG("IEN"))]"":PSODRUG("IEN"),$G(PSXYES):$P(^PSRX(ZRX,0),"^",6),$D(^PSRX(DA,0)):+$P(^(0),"^",6),1:0) ;IHS/ITSC/ENM 02/06/02 VA CHNGS
 I $D(^PSDRUG("AQ",Z0)),(+X'=X) K X,Z0 Q  ;IHS/ITSC/ENM 02/06/02 VA CHNG
 S Z1=$S($D(^PSDRUG(Z0,660.1)):^(660.1),1:0)+(+X) W:X>Z1 "  GREATER THAN CURRENT INVENTORY!" K Z1 ;IHS/ITSC/ENM 02/06/02 VA CHNGS
 S ZX=X,ZZ0=$G(D0),D0=Z0 X $P(^DD(50,18,0),"^",5,99) W:X<$S($D(^PSDRUG(Z0,660)):+^(660),1:1) "  BELOW REORDER LEVEL" S X=ZX,D0=$G(ZZ0) K ZZ0,Z0,ZX
 Q
HELP ; QTY HELP ;IHS/ITSC/ENM 02/06/02 VA CHNG FOR THIS SUB ROUTINE
 S Z0=$S($G(PSODRUG("IEN"))]"":PSODRUG("IEN"),$G(PSXYES):$P(^PSRX(ZRX,0),"^",6),$D(^PSRX(DA,0)):$P(^PSRX(DA,0),"^",6),1:0)
 I $D(^PSDRUG("AQ",Z0)) W !!,"This is a CMOP drug.  The quantity may not contain alpha characters (i.e.; ML)    or more than two fractional decimal places (i.e.; .01)." D  K Z0 Q
 .W !,"Enter a number between 0 and 99999999 inclusive. The total entry cannot exceed    12 characters."
 W !!,"Enter a number between 0 and 99999999 inclusive. An Alpha suffix is allowed, but",!,"the entry cannot exceed 12 characters, or contain more than two fractional",!,"decimal places (i.e.; .01)."
 K Z0
 Q
ADD ;add/edited local drug/drug interactions
 I $T(^PSNDINT)]"" D ^PSNDINT G QU ;IHS/ITSC/ENM VA CHNG
 W ! S DIC("A")="Select Drug Interaction: ",DIC(0)="AEMQL",(DIC,DIE)="^PS(56,",DIC("S")="I '$P(^(0),""^"",5)" D ^DIC G:"^"[X QU G:Y<0 ADD S DA=+Y,DR="[PSO INTERACT]" L +^PS(56,DA):0 D ^DIE L:$G(DA) -^PS(56,DA) K DA G ADD
QU K X,DIC,DIE,DA
 Q
CRI ;change drug interaction severity to critical from significant
 I $T(^PSNDINT)]"" D ^PSNDINT G QU ;IHS/ITSC/ENM VA CHNG
 ;IHS/DSD/ENM REMOVE DIC("S") TO ALLOW SEVERTY CHANGE 5.10.95
 ;W ! S DIC("A")="Select Drug Interaction: ",DIC(0)="AEQM",(DIC,DIE)="^PS(56,",DIC("S")="I $P(^(0),""^"",4)=2" D ^DIC G:"^"[X QU G:Y<0 CRI S DA=+Y,DR=3 L +^PS(56,DA):0 D ^DIE L -^PS(56,DA) K DA G CRI
 W ! S DIC("A")="Select Drug Interaction: ",DIC(0)="AEQM",(DIC,DIE)="^PS(56," D ^DIC G:"^"[X QU G:Y<0 CRI S DA=+Y,DR=3 L +^PS(56,DA):0 D ^DIE L -^PS(56,DA) K DA G CRI
 G QU
 Q
 ;IHS/ITSC/ENM 02/07/02 MAX AND REF SUB FILES ARE RE-DONE IN VA PATCHES
 ;126, 133, 137, 145, 173
MAX ;S MAX=0 I $D(^PSDRUG(P(5),0)) S MAX=$S($P(^(0),"^",3)["S":+$P(PSOPAR,"^",9),1:5)
 S MAX=0 I $D(^PSDRUG(P(5),0)) S MAX=$S($P(^(0),"^",3)["S":+$P(PSOPAR,"^",9),1:12) ;IHS/DSD/ENM 02/06/96 MAX CHNG TO 12
 I $D(PTST) S MAX1=$P(PTST,"^",4),MAX=$S((MAX=+$P(PSOPAR,"^",9))&(MAX1=12)&($P(^(0),"^",3)["S"):MAX,1:MAX1)
 S:$P(^PSDRUG(P(5),0),"^",3)["A"&($P(^(0),"^",3)'["B") MAX=0
 ;S MAX=$S('MAX:0,P(7)=90:1,1:MAX)
 S MAX=$S('MAX:0,P(7)>120:1,1:MAX) ;IHS/DSD/ENM 02/06/96
 S MIN=0 I $D(DA) F REF=0:0 S REF=$O(^PSRX(DA,1,REF)) Q:'REF  I $D(^(REF,0)) S MIN=MIN+1
 K MAX1 Q
 ;
REF D MAX I (+X'=X)!(X<0)!(X>MAX)!(X?.E1"."1N.N) W *7," ** MAX REFILLS ALLOWED ARE ",MAX," ** " K X
 I $D(X),X<MIN W *7," ** PATIENT HAS ALREADY RECEIVED ",MIN," REFILLS ** " K X
 K MAX,MIN,REF
 Q
PAT ;patient field screen in file 52
 N DIC,DIE S DFN=X D INP^VADPT,DEM^VADPT
 I $P(VADM(6),"^") W !,?10,"PATIENT DIED "_$P(VADM(6),"^",2),! K X,DFN Q
 I $P(VAIN(4),"^") W !,?10,"PATIENT IS AN INPATIENT ON WARD ",$P(VAIN(4),"^",2)_" !!" K DIR D DIR K VA,VADN,VAIN Q
 E  S X=DFN K DFN,DIRUT,DTOUT,DUOUT
 Q
DIR S DIR(0)="Y",DIR("B")="YES",DIR("A")="DO YOU WISH TO CONTINUE" D ^DIR K DIR
 K:'Y X S:Y X=DFN K DFN,DIRUT,DTOUT,DUOUT,VA,VADM,VAIN
 Q
BG ;prevents editing of display groups with patients from name to ticket
 S $P(^PS(59.3,DA,0),"^",2)=PDP W !,"The display cannot be changed from NAME to TICKET when patients are",!,"already in the Display Group.  All patients must be purged and re-entered.",!,"Ticket numbers must be issued !!",! K Y,PDP
 Q
