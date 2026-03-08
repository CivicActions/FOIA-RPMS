XUCT02 ; GENERATED FROM 'XU-ZISPL-USER' PRINT TEMPLATE (#680)  [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1004,1005,1007**;APR 1, 2003
 G BEGIN
CP G CP^DIO2
C S DQ(C)=Y
S S Q(C)=Y*Y+Q(C) S:L(C)>Y L(C)=Y S:H(C)<Y H(C)=Y
P S N(C)=N(C)+1
A S S(C)=S(C)+Y
 Q
D I Y=DITTO(C) S Y="" Q
 S DITTO(C)=Y
 Q
N W !
T W:$X ! I '$D(DIOT(2)),DN,$D(IOSL),$S('$D(DIWF):1,$P(DIWF,"B",2):$P(DIWF,"B",2),1:1)+$Y'<IOSL,$D(^UTILITY($J,1))#2,^(1)?1U1P1E.E X ^(1)
 S DISTP=DISTP+1,DILCT=DILCT+1 D:'(DISTP#100) CSTP^DIO2
 Q
DT I $G(DUZ("LANG"))>1,Y W $$OUT^DIALOGU(Y,"DD") Q
 I Y W $P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC",U,$E(Y,4,5))_" " W:Y#100 $J(Y#100\1,2)_"," W Y\10000+1700 W:Y#1 "  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12) Q
 W Y Q
M D @DIXX
 Q
BEGIN ;
 S:'$D(DN) DN=1 S DISTP=$G(DISTP),DILCT=$G(DILCT)
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(680,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S X=$G(^XMB(3.51,D0,0)) D T Q:'DN  D N W ?0 S Y=$P(X,U,5),C=1 D D S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 W:$X>8 ! D N:$X>4 Q:'DN  W ?4 S Y=$P(X,U,1) S:Y]"" N(2)=N(2)+1 W $E(Y,1,20)
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,3) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 S Y=$P(X,U,9),C=3 D A:Y]"" W:Y]"" $J(Y,8,0)
 D N:$X>49 Q:'DN  W ?49,$E($P(X,U,8),1,7)
 D N:$X>59 Q:'DN  W ?59 S DIP(2)=$S($D(^XMB(3.51,D0,0)):^(0),1:""),X=DT S X=X,DIP(1)=X S X=$P(DIP(2),U,6),Y=X,X=DIP(1),X=X,X1=X,X2=Y,X="" D:X2 ^%DTC:X1 K DIP K:DN Y W X
 S I(1)=2,J(1)=3.5121 F D1=0:0 Q:$O(^XMB(3.51,D0,2,D1))'>0  X:$D(DSC(3.5121)) DSC(3.5121) S D1=$O(^(D1)) Q:D1'>0  D:$X>70 T Q:'DN  D A1
 G A1R
A1 ;
 D N:$X>9 Q:'DN  W ?9 S DIP(1)=$S($D(^XMB(3.51,D0,2,D1,0)):^(0),1:"") S X=$P(DIP(1),U,6),DIP(2)=X S X="CNT",X1=DIP(2) S:X]""&(X?.ANP) DIPA($E(X,1,30))=X1 S X="" K DIP K:DN Y W X
 W ?9 S X="CNT",X=$S(X=""!(X'?.ANP):"",$D(DIPA($E(X,1,30))):DIPA($E(X,1,30)),1:"") K DIP K:DN Y W X
 W $S(DIPA("CNT")>1:" copies",1:" copy")_" printed on " K DIP K:DN Y
 S X=$G(^XMB(3.51,D0,2,D1,0)) W ?0,$E($P(X,U,1),1,30)
 W " at "
 S Y=$P(X,U,5) D DT
 Q
A1R ;
 K Y
 Q
HEAD ;
 W !,?0,"USER NAME"
 W !,?4,"DOCUMENT NAME",?29,"STATUS",?42,"LINES",?49,"SIZE",?59,"AGE"
 W !,"--------------------------------------------------------------------------------",!!
