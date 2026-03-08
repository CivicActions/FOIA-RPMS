DIED ;SFISC/GFT,XAK-MAJOR INPUT PROCESSOR ;1/24/96  10:57 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**1,13,19**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
O D W W Y W:$X>48 !?9
 I $L(Y)>19,'DV,DV'["I",(DV["F"!(DV["K")) G RW^DIR2
 I Y]"" W "// " I 'DV,DV["I",$D(DE(DQ))#2 S X="" W "  (No Editing)" Q
TR Q:$P(DQ(DQ),U,2)["K"&(DUZ(0)'="@")  R X:DTIME E  S (DTOUT,X)=U W $C(7)
 Q
W I $P(DQ(DQ),U,2)["K"&(DUZ(0)'="@") Q
 I $D(DIE("W")) X DIE("W") Q
 W !?DL+DL-2,$P(DQ(DQ),U,1)_": " Q
 ;
DQ ;
 S:$D(DTIME)[0 DTIME=300 S DQ=1 G B
A K DQ(DQ) S DQ=DQ+1
B S DIFLD=$S($D(DIFLD(DQ)):DIFLD(DQ),1:-1)
 I '$D(DQ(DQ)) G E^DIE1:'$D(DQ(0,DQ)),BR^DIE0
RE ;
 S DIP=$P(DQ(DQ),U,1),DV=$P(DQ(DQ),U,2),DU=$P(DQ(DQ),U,3) G:DV["K"&(DUZ(0)'="@") A G PR:$D(DE(DQ)) D W,TR I $D(DTOUT) K DQ,DG G QY^DIE1
N I X="" G A:DV'["R",X:'DV,X:$P(DC,U,2)-DP(0),A
RD G ^DIE0:X[U,^DIE2:X="@",^DIEQ:X?."?"
 I X=" ",DV["d",DV'["P",$D(^DISV(DUZ,"DIE",DIP)) S X=^(DIP) I DV'["D",DV'["S" W "  "_X
T G M^DIE1:DV,^DIE3:DV["V",P:DV'["S" X:$D(^DD(DP,DIFLD,12.1)) ^(12.1) I X?.ANP D SET I 'DDER X:$D(DIC("S")) DIC("S") I  W:'$D(DB(DQ)) "  "_% G V
 K DDER G X
P I DV["P" S DIC=U_DU,DIC(0)=$E("EN",$D(DB(DQ))+1)_"M"_$E("L",DV'["'") S:DIC(0)["L" DLAYGO=+$P(DV,"P",2) G AST:DV["*" D ^DIC S X=+Y,DIC=DIE G X:X<0
 G V:DV'["N" I $L($P(X,"."))>24 K X G Z
 I $P(DQ(DQ),U,5,99)'["$",X?.1"-".N.1".".N,$P(DQ(DQ),U,5,99)["+X'=X" S X=+X
V S DIER=1 X $P(DQ(DQ),U,5,99) K DIER,YS
Z K DIC("S"),DLAYGO I $D(X),X?.ANP,X'=U S DG($P(DQ(DQ),U,4))=X S:DV["d" ^DISV(DUZ,"DIE",DIP)=X G A
X W:'$D(ZTQUEUED) $C(7) W:'$D(DDS)&'$D(ZTQUEUED) "??"
 G B^DIE1
 ;
PR I $D(DE(DQ,0)) S Y=DE(DQ,0) G F:Y?1"/".E I $D(DE(DQ))=10 D Y:$E(Y,1)=U,O G RD:"@"'[X,A:DV'["R"&(X="@"),X:X="@" S X=Y G N
 S DG=DV,Y=DE(DQ),X=DU I DG["O",$D(^DD(DP,DIFLD,2)) X ^(2) G S
R I DG["P",@("$D(^"_X_"0))") S X=+$P(^(0),U,2) G S:'$D(^(Y,0)) S Y=$P(^(0),U,1),X=$P(^DD(X,.01,0),U,3),DG=$P(^(0),U,2) G R
 I DG["V",+Y,$P(Y,";",2)["(",$D(@(U_$P(Y,";",2)_"0)")) S X=+$P(^(0),U,2) G S:'$D(^(+Y,0)) S Y=$P(^(0),U,1) I $D(^DD(+X,.01,0)) S DG=$P(^(0),U,2),X=$P(^(0),U,3) G R
 X:DG["D" ^DD("DD") I DG["S" S %=$P($P(";"_X,";"_Y_":",2),";",1) S:%]"" Y=%
S D O I $D(DTOUT) K DQ,DG G QY^DIE1
 I X="" S X=DE(DQ) X:$D(DICATTZ) $P(DQ(DQ),U,5,99) G A:'DV,A:DC<2 G N^DIE1
 G RD:DQ(DQ)'["DINUM" D E^DIE0 G RD:$D(X),PR
 ;
F S DB(DQ)=1,X=$E(Y,2,999),DH=$F(DQ(DQ),"%DT=""E") I DH S DQ(DQ)=$E(DQ(DQ),1,DH-2)_$E(DQ(DQ),DH,999)
 I X?1"/".E S X=$E(X,2,999),DH=""
 X:$E(X,1)=U $E(X,2,999) G:X="" A:'DV,A:'$P(DC,U,4),N^DIE1 I $D(DE(DQ))#2,DV["I"!(DQ(DQ)["DINUM") D E^DIE0
 G X:'$D(X),RD:DH]"",RD:X="@",Z
 ;
Y X $E(Y,2,999) S Y=X I DV["D",Y?7N.NP X ^DD("DD")
Q Q
 ;
AST G V:DV["'",AST^DIE9
RW G RW^DIR2
SET N DIR S DIR(0)="SV"_$E("o",$D(DB(DQ)))_U_DU,DIR("V")=1
 I $D(DB(DQ)),'$D(DIQUIET) N DIQUIET S DIQUIET=1
 D ^DIR I 'DDER S %=Y(0),X=Y
