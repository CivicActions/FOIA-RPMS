DIEQ ;SFISC/XAK,YJK-HELP DURING INPUT ;4/14/95  10:10 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**3**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
BN S D=$P(DQ(DQ),U,4) S:DP+1 D=DIFLD
 S DZ=X D EN1 G B^DIED
QQ ;
 I DV,DV["*",$D(^DD(+DV,.01,0)) S DQ(DQ)=$P(DQ(DQ),U,1,4)_U_$P(^(0),U,5,99)
EN1 S DDH=0 G M:DV I DP<0 D HP G P
 I X="?"!(X["BAD") F DG=3,12 Q:DG=12&($G(DISORT))  I $D(^DD(DP,D,DG)) S X=^(DG),A1="T" D N
 D H G:'$D(DZ) Q
 ;
P I DV["P" K DO S DIC=U_DU,D="B",DIC(0)="M"_$E("L",DV'["'") G AST:DV["*"&('$G(DISORT)) D DQ^DICQ D %
VP I DV["V" S DU=DP S:DV DU=+DO(2),D=.01 D V G Q
D I DV["D" S %(0)=0,%DT=$P($P($P(DQ(DQ),U,5,9),"%DT=""",2),"""",1) D HELP^%DTC
S I DV["S" X:($D(^DD(DP,D,12.1))#2)&('$G(DISORT)) ^(12.1) S A1="T",DST=$$EZBLD^DIALOG(8068)_" " D DS,S1
Q K DST,A1 S:$D(DIE) DIC=DIE S D=0 I $D(DDH)>10 D LIST^DDSU
 Q
 ;
 ;
S1 F DG=1:1 S Y=$P($P(DQ(DQ),U,3),";",DG) Q:Y=""  S D=$P(Y,":",2),Y=$P(Y,":",1) X:$D(DIC("S")) DIC("S") I  S A2="",$P(A2," ",15-($L(Y)+7))=" ",DST="  "_Y_A2_" "_D D DS
 K A1,A2 Q
 ;
N F  Q:X=""  F %=$L(X," "):-1:1 I $L($P(X," ",1,%))<75 S DST=$P(X," ",1,%) D DS D:X'="" N1 Q
 S X=DZ
 Q
 ;
N1 S X=$P(X," ",%+1,$L(X," ")) Q
 ;
DS S:'$D(A1) A1="T" S DDH=$G(DDH)+1,DDH(DDH,A1)=$S(A1="X":"",1:"     ")_DST K A1,DST Q
 ;
HP I $D(DQ(DQ,3)) S A1="T",DST=DQ(DQ,3) D DS
 I $D(DQ(DQ,4)) S A1="X",DST=DQ(DQ,4) D DS
 Q
 ;
% S %=$G(DIC("V")) K DIC S:%]"" DIC("V")=% Q
 ;
AST S:$D(X)[0 X="?" X $P(DQ(DQ),U,5,99) K DIC G Q
 D ^DIC K DIC,DICS,DICW G Q
 ;
M K DO S DZ=X,DIC=DIE_DA_","_$S(+$P(DC,U,3)=$P(DC,U,3):$P(DC,U,3),1:$C(34)_$P(DC,U,3)_$C(34))_",",D="B",DIC(0)="LM",DZ(1)=0
 I '$D(@(DIC_"0)")) S DO=U_$P(DC,U,2) D DO2^DIC1
 D DQ^DICQ D % G Q:'$D(DZ)!(DV["S") S X=DZ G P
 ;
H I '$G(DISORT),$D(^DD(DP,D,4)) S A1="X",DST=^(4) D DS,LIST^DDSU Q:'$D(DZ)
 I $D(X),X'["BAD",X?1"??".E D
 . N DIDG,DG
 . S DIDG=$P($G(^DD(DP,D,21,0)),U,3)
 . K DDSQ
 . F DG=1:1 Q:'$D(^DD(DP,D,21,DG,0))  Q:+DIDG&(DG>DIDG)  D:$G(DDH)'<15 LIST^DDSU Q:$D(DDSQ)  S DST=^DD(DP,D,21,DG,0) D DS
 . I $D(DDSQ) K DDSQ,DDH
 Q
 ;
BK S DDH=$G(DDH)+1,DDH(DDH,"T")=" " Q
 ;
V S DDH=+$G(DDH),A1="T",DST=$$EZBLD^DIALOG(8071) D DS
 F Y=0:0 S Y=$O(^DD(DU,D,"V",Y)) Q:Y'>0  I $D(^(Y,0)) S Y(0)=^(0) X:$D(DIC("V")) DIC("V") I  I $D(^DIC(+Y(0),0)) S Y(1)=$P(Y(0),U,4),Y(2)=$P(Y(0),U,2),DST=$$EZBLD^DIALOG(8072,.Y) K Y(1),Y(2) D DS
 D BK S DST=$$EZBLD^DIALOG(8073) D DS S DU="" D BK I DZ'?1"??".E K X,DZ Q
 D T^DIEQ1 K X,DZ Q
 ;
 ;#8071  Enter one of the following
 ;#8072  |Prefix|.EntryName to select a |filename|
 ;#8073  To see the entries in any particular file type <Prefix.?>
