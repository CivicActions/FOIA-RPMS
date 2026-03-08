LRXO7 ; IHS/DIR/AAB - Lab collection samples 7/3/89 15:07 ; [ 05/27/98 1:49 PM ]
 ;;5.2;LR;**1001,1002**;JUN 01, 1998
 ;
 ;;5.2;LAB SERVICE;**75,128,160**;Sep 27, 1994
EN ;
 ;W !!,"For "_LRTSTNM
GS ;
 I LRSAMP G W18A
 S LRSAMP=-1,LRSPEC=-1,J=0,LRCSN=1,N1=""
 S LRUNQ=$P(^LAB(60,LRTST,0),"^",8) I LRUNQ D
 .S LRUNQ=$O(^LAB(60,LRTST,3,0)) I LRUNQ D
 ..S LRUNQ=+^LAB(60,LRTST,3,+LRUNQ,0)
 .I 'LRUNQ W $C(7),!!,"This test is defined as a unique specimen but there is no collection sample",!,"entered in file 60. Contact IRM or your Lab ADPAC for correction." H 2 S (LRSAMP,LRSPEC,LRUNQ)=""
 I "ILC"[LRZX(1),$P(^LAB(60,LRTST,0),"^",9) S N1=$P(^(0),"^",9),LRCS(1)=N1
 I "ILC"'[LRZX(1) S N1=$S($D(^LAB(60,LRTST,3,0)):$O(^LAB(60,LRTST,3,0)),1:"") I N1 S LRCS(1)=+^(N1,0)
 I 'N1,LRUNQ S LRCS(1)=LRUNQ G G2
 G GSNO:'N1 S X=$P(^LAB(62,LRCS(1),0),"^") I $S('LRASK:1,LRASK&("ILC"'[LRZX(1)):1,1:0) W !,$S(LRUNQ:"The Sample ",1:"")_"Is "_X_"   "_$P(^(0),"^",3)
 G G2:LRUNQ S %=1 I $S('LRASK:1,LRASK&("ILC"'[LRZX(1)):1,1:0) W " the correct sample to collect" D YN^DICN I %=-1 S LREND=1 Q
 I %=0 S LRSAMP="" W !,"    ANSWER 'YES' OR 'NO':" G GS
 G G2:%'=2
 I $S(LRASK&("ILC"[LRZX(1)):1,1:0) G G2
 S LRCSN=0 F  S J=$O(^LAB(60,LRTST,3,J)) Q:J<1  S LRCSN=LRCSN+1,LRCS(LRCSN)=+^(J,0)
 G GSNO:LRCSN<2
 W ! F I=0:0 S I=$O(LRCS(I)) Q:'I  W !,I," ",$P(^LAB(62,LRCS(I),0),"^")_"  "_$P(^(0),"^",3)
 R !,"Choose one: ",X:DTIME IF X>0&(X<(LRCSN+1)) S LRCSN=+X G G2
GSNO ;from
 Q:LRSAMP=""  S LRCSN=1,LRCS(1)=-1,DIC="^LAB(62,",DIC(0)="AEMOQ" D ^DIC K DIC S LRCS(1)=+Y
G2 S LRSAMP=LRCS(LRCSN) I LRSAMP<1 S Y=-1,LROT="" G G3
 I $P(^LAB(62,LRSAMP,0),"^",2)'="" S LRSPEC=+$P(^(0),"^",2) G G4
W18A S DIC="^LAB(61,",DIC(0)="EMOQ",D="E" R !,"Select SITE/SPECIMEN: ",X:DTIME D IX^DIC:X["?" G W18A:X["?" D ^DIC
 K DIC G W18A:'($D(DUOUT)!$D(DTOUT))&(Y<0) I $D(DTOUT)!$D(DUOUT) S:X="^^" DIROUT=1 S LREND=1 Q
G3 S LRSPEC=+Y
G4 Q
