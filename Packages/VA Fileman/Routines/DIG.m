DIG ;SFISC/GFT-SCATTERGRAM ;12/13/96  16:53 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**35**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 I '$D(^DOSV(0,IO(0),2)) W !,"NO SUB-SUB TOTALS WERE RUN" Q
 K ZTSK S:$D(^%ZTSK) %ZIS="QM" D ^%ZIS G ENDK:POP,QUE:$D(IO("Q"))
DQ S C(1)=^DOSV(0,IO(0),"BY",1),C(2)=^(2),X=$O(^DOSV(0,IO(0),2,"")),(DXMIN,DXMAX)=X,(DYMIN,DYMAX)=$O(^(X,"")),X=""
 I $E(IOST)="C" S DIFF=1
 F C=1,2 S C(C,0)=$S($D(^DD(+C(C),+$P(C(C),U,2),0)):$P(^(0),U,2),1:$P(C(C),U,7))
 F C=0:0 S X=$O(^DOSV(0,IO(0),2,X)) Q:X=""  S:X>DXMAX DXMAX=X S Y=$O(^(X,"")),DY=Y S:Y<DYMIN DYMIN=Y D A S:DYMAX<DY DYMAX=DY
 I DXMAX-DXMIN*(DYMAX-DYMIN)=0 W $C(7),!,"NO RANGE OF VARIABLES" G ENDK
 S H=DYMAX,L=DYMIN,DYS=IOSL-9,N=DYS/6,C=2 D S S DYMIN=B,DYSC=I/6,DYMAX=T,DYI=X
DYI I T-B/DYI*6'>DYS S DYI=DYI\2 G DYI
 S H=DXMAX,L=DXMIN,DXS=IOM-28,N=DXS/6,C=1 D S S DXMIN=B,DXSC=I/6,DXI=X,DXMAX=T,T=X*DXS/(T-B),H=-1
LOOP K ^UTILITY($J) S H=$O(^DOSV(0,IO(0),"F",H)) I H S X=^(H) U IO W:$D(DIFF)&($Y) @IOF S DIFF=1 W ?22,$O(^DD(+X,0,"NM",0))," ",$P(X,U,$P(X,U,2)'=.01*3)," COUNT   " S (B,DX,DY)="" D I2 G LOOP:X'=U
END W:$E(IOST)'="C"&($Y) @IOF K:$D(ZTSK) ^DOSV(0,IO(0)) D CLOSE^DIO4
ENDK K %H,%T,%Y,%D,B,I,L,H,T,C,X,Y,POP,IOP,DX,DY,DXS,DYS,DXSC,DYSC,DXMIN,DYMIN,DXMAX,DYMAX,DXI,N,DYI,DIFF Q
 ;
I2 S (DX,X)=$O(^DOSV(0,IO(0),2,DX)) I X="" W "(TOTAL = "_B_")",! G O
 I C(1,0)["D" D H^%DTC S X=%H
 S X=$J(X-DXMIN/DXSC,0,0)
I3 S (Y,DY)=$O(^DOSV(0,IO(0),2,DX,DY)) G I2:Y="" I C(2,0)["D" S C=X,X=Y D H^%DTC S Y=%H,X=C
 G I3:'$D(^(DY,H,"N")) S C=^("N"),Y=$J(Y-DYMIN/DYSC,0,0),B=B+C,^(X)=C+$S($D(^UTILITY($J,Y,X)):^(X),1:0) G I3
 ;
A F C=0:0 S Y=$O(^(DY)) Q:Y=""  S DY=Y
 Q
 ;
O S X=0 D X W !?12,"." D P K Y S L=0 F B=DYMIN:DYI:DYMAX S C=2,Y=B D Y S Y($J(L,0,0))=Y,L=DYI*DYS/(DYMAX-DYMIN)+L
 W ".",! F Y=DYS:-1:0 D LINE W !
 W ?13 D P W ! S X=DXI D X W !?22,"X-AXIS: ",$P(C(1),U,3),"    Y-AXIS: ",$P(C(2),U,3) I IOST?1"C".E W $C(7) R X:DTIME S:'$T X=U
 Q
 ;
P S L=-1,X=0
PP I L<X W "+" S L=L+T
 E  W "-"
 S X=X+1 G PP:X'>DXS Q
 ;
X F B=DXMIN+X:DXI*2:DXMAX S Y=B,C=1 D Y W ?B-DXMIN\DXSC-($L(Y)\2)+13,Y
 Q
Y S C=C(C,0) I C["D" S %H=Y D 7^%DTC S Y=X
 G S^DIQ
 ;
LINE I $D(Y(Y)) W ?12-$L(Y(Y)),Y(Y),"+"
 E  W ?12,"|"
 S X="" F  S X=$O(^UTILITY($J,Y,X)) Q:X=""  S I=^(X) W ?X+13,$S(I>9:"*",I:I,1:"")
 W ?DXS+14 I  W "+",Y(Y) Q
 W "|" Q
 ;
S I C(C,0)["D" F B="H","L" S X=@B D H^%DTC S @B=%H
 S B=H-L,X=1 I B>1 F C=1:1 S X=X*10 Q:B'>X
 E  S I=1 Q:'B  F C=0:-1 Q:X/10'>B  S X=X/10
 S B=L-X\X*X F I=B:X/10 Q:I'<L  S B=I
 S T=H+X\X*X F I=T:-X/10 Q:I'>H  S T=I
I S I=T-B/X*10 I I>N S X=X*2 G I
 S X=X/10,I=T-B/N
 Q
QUE ;
 S ZTSAVE("^DOSV(0,$I,")=""
 S ZTIO=ION_";"_IOST_";"_IOM_";"_IOSL,ZTRTN="DQ^DIG"
 D ^%ZTLOAD K ZTSK G END
