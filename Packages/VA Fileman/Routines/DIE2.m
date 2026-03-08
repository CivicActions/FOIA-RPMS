DIE2 ;SFISC/GFT,XAK-DELETE AND ENTRY ;2/8/94  09:26 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 D F,DL Q:$D(DTOUT)  G B^DIED:Y=2,A^DIED:Y,UP^DIE1:DL>1,Q^DIE1
 ;
F S D=$P(DQ(DQ),U,4) S:DP+1 D=DIFLD Q
 ;
Z D DL S DU="" I Y=2 G @(DQ_U_DNM)
 I Y G @("A^"_DNM)
 G R^DIE9:DL>1,E^DIE9
DL ;
 S %=DP,X=D,Y=$P(DQ(DQ),U,4)="0;1"
 G X:$D(DE(DQ))[0,X:DV["R"&'Y,S:DP<0,DD:DUZ(0)="@" I DV S %=+$P(DC,U,2),X=.01
 G DD:DP<2 I $D(DIDEL),DIDEL\1=(DP\1) G DD
 I Y,$S($D(^VA(200,"AFOF")):1,1:$D(^DIC(3,"AFOF"))) G DD:$D(^DD(DP,0,"UP"))!DV,DAR:'$S($D(^VA(200,DUZ,"FOF",DP)):1,1:$D(^DIC(3,DUZ,"FOF",DP))),DAR:'$P(^(DP,0),U,3),DD
 I Y,$D(^DIC(%,0,"DEL")) S X=^("DEL")
 E  G DD:'$D(^DD(%,X,8.5)) S X=^(8.5)
 G DD:X="" F %=1:1:$L(X) G DD:DUZ(0)[$E(X,%)
DAR W !,"'DELETE ACCESS' REQUIRED!!"
X I $D(DB(DQ)) D N G A
 W:'$D(DIER) $C(7),"??" W:DV["R"&'$D(DIER) "  Required" G R
DD G MD:DV S DH=0,DU=0 F  S DH=$O(^DD(DP,D,"DEL",DH)) Q:DH=""  I $D(^(DH,0)) X ^(0) Q:$D(DTOUT)  G X:$T
 S DH=-1,X=DQ(DQ) I Y,$E(@(DIE_"0)"))'=U S X=^(0)
 D D G R:X I Y S X=DE(DQ) D DEL:$D(DIU(0)) K DE,DG,DQ,DB S DIK=DIE D ^DIK S Y=0 K:DL<2 DA Q
S S X="",DG($P(DQ(DQ),U,4))=""
A S Y=1 Q
 ;
D I $D(DB(DQ)) S X=0 Q
 W $C(7),!?3,"SURE YOU WANT TO DELETE"
 I Y W " THE ENTIRE " W:DV'["D"&(DV'["P")&(DV'["V") "'"_DE(DQ)_"' " W $P(X,U,1)
 S %=0,X=0 D YN^DICN Q:%=1  S X=1 W:$X>55 !?9
N I $D(DE(DQ))#2,'$D(DDS) W:'$D(ZTQUEUED) $C(7),"  <NOTHING DELETED>"
 Q
 ;
MD G X:DV["R"&($P(DC,U,5)=1) S DH=0,DU=0 F  S DH=$O(^DD(+$P(DC,U,2),.01,"DEL",DH)) Q:DH=""  I $D(^(DH,0)) D DDA X ^(0) D UDA G X:$T
 S DH=-1,Y=DC>1,X=$E(DQ(DQ),8,99) D D
 I 'X D DDA S DIK=DIC D ^DIK,UDA K DE(DQ) S X=$P(@(DIK_"0)"),U,3,4),DC=$P(DC,U,1,3)_U_X,DIC=DIE S:$D(^(+X,0)) DE(DQ)=$P(^(0),U,1)
R S Y=2 Q
 ;
DDA F X=DL+1:-1:1 I $D(DA(X)) S DA(X+1)=DA(X)
 K DA(DL+2) S DA(1)=DA,DIC=DIE_DA_","""_$P(DC,U,3)_""",",DA=$P(DC,U,4) Q
 ;
UDA S DA=DA(1) F X=2:1 Q:'$D(DA(X))  S DA(X-1)=DA(X) K DA(X)
 Q
QS ;
 G ^DIEQ
QQ ;
 G QQ^DIEQ
 Q
DEL I '$S($D(^VA(200,"AFOF",DA)):1,1:$D(^DIC(3,"AFOF",DA))) Q
 S DA(1)="",DIFOF=DA
 F P=0:0 S DA(1)=$S($D(^VA(200,"AFOF")):$O(^VA(200,"AFOF",DA,DA(1))),1:$O(^DIC(3,"AFOF",DA,DA(1)))) Q:'DA(1)  I $S($D(^VA(200,DA(1),"FOF",DA)):1,1:$D(^DIC(3,DA(1),"FOF",DA))) S DIK=$S($D(^VA(200)):"^VA(200,",1:"^DIC(3,")_DA(1)_",""FOF""," D ^DIK
 K DA S DA=DIFOF K DIFOF
 Q
V ;
 G ^DIE3
