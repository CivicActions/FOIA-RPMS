%ZTP1 ;SF/RWF -  PRINTS 1ST LINES IN SIZE OR DATE ORDER (ISM OR DSM) ;04/16/97  10:28 [ 04/02/2003   8:47 AM ]
 ;;7.3;TOOLKIT;**1001**;APR 1, 2003
 ;;7.3;TOOLKIT;**20**;Apr 25, 1995
 ;Updated with KERNEL patch 34.
A K ^UTILITY($J) W !!,"PRINTS FIRST LINES",!! X ^%ZOSF("RSEL") G KIL:$O(^UTILITY($J,0))=""
A1 R !,"(A)lpha, (D)ate ,(P)atched, OR (S)ize ORDER: A//",ZTP1:$S($G(DTIME):DTIME,1:360) S:ZTP1="" ZTP1="A" S ZTP1=$E(ZTP1,1) G KIL:ZTP1="^",A1:"ADPS"'[ZTP1
 S Z2=$S(ZTP1="P":"YES",1:"NO")
A2 W !,"Include line 2? ",Z2,"//" R X:$S($G(DTIME):DTIME,1:360) G KIL:X["^"!('$T) S:X="" X=Z2 G A2:"YN"'[$E(X) S Z2=("Yy"[$E(X))
 S %ZIS="QM" D ^%ZIS G KIL:POP
 I $D(IO("Q")) K IO("Q") S ZTRTN="B^%ZTP1",ZTSAVE("ZTP1")="",ZTSAVE("^UTILITY($J,")="",ZTSAVE("Z2")="",ZTDESC="FIRST LINES PRINT" D ^%ZTLOAD K ZTSK Q
 ;Set RN for all loops
B S RN=" " G DATE:ZTP1="D",SIZE:ZTP1="S",PATCH:ZTP1="P"
 ;
ALPHA F JP=1:1 S RN=$O(^UTILITY($J,RN)) Q:RN=""  S ^UTILITY($J,1,JP,RN)=0
 S HED="    FIRST LINE LIST:"
 G LIST
SIZE S A="F JR=1:1 S RN=$O(^UTILITY($J,RN)) Q:RN=""""  ZL @RN X ^%ZOSF(""SIZE"") W RN,"" "",Y,?$X\19+1*19 S ^UTILITY($J,1,Y,RN)=2,^(RN,1)=$T(+1),^(2)=$T(+2) W:$X>66 !"
 X A S HED="    SIZE RANKING:"
LIST ;All 3 sorts come here to print the list.
 S IOSL=IOSL-2-Z2,X=$H X ^%ZOSF("ZD")
 S HED=Y_"   "_HED X ^%ZOSF("UCI") S HED=Y_"   "_HED U IO W @IOF,!?8,HED,!
 S ZP=0,X=0 F S=0:0 S S=$O(^UTILITY($J,1,S)),RN="" Q:S'>0  F S2=0:0 S RN=$O(^UTILITY($J,1,S,RN)) Q:RN=""  D:$Y>IOSL WAIT G:X["^" KIL S ZP=ZP+1 D L2
 W !!?14,ZP," ROUTINES",!
KIL D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@" K %L,%R,%ZN,A,B,C,HED,Z2,JR,S,X,Y,ZTP,ZTP1,ZP,RN,^UTILITY($J),ZTSK
 Q
L2 I ^UTILITY($J,1,S,RN) S S(1)=^(RN,1),S(2)=^(2)
 I '$T X "ZL @RN S S(1)=$T(+1),S(2)=$T(+2)"
 W RN,?10 W:ZTP1="S" $J(S,4)," - " W $P(S(1)," ",2,999),! W:Z2 ?10,S(2),!
 Q
WAIT I IOST["C-" R !,"Enter Return to continue",X:120 Q:X["^"
 W @IOF,!?8,HED,! Q
DATE ;Sort by date
 S A="F JR=1:1 S RN=$O(^UTILITY($J,RN)) Q:RN=""""  ZL @RN S B=1,ZTP=$T(+1),X=$P(ZTP,"" ;"",3) X A(1) S B=1,X=$P(ZTP,"";"",4) X:Y<0 A(1) W RN,"" "",Y,?$X\19+1*19 S ^UTILITY($J,1,9999999-Y,RN)=2,^(RN,1)=ZTP,^(2)=$T(+2) W:$X>66 !"
 S A(1)="F %=1:1 S %DT=""T"",S=$E(X,%)?1P S:B&S X=$E(X,1,%-1)_$E(X,%+1,99),%=%-1 S:'S B=0 S:$E(X,%+1,99)?1N.N1"":"".E X=$E(X,1,%-1)_""@""_$E(X,%+1,99),%=999 I %>$L(X) D ^%DT Q"
 X A S HED="    REVERSE DATE ORDER:"
 G LIST
PATCH ;Sort by first patch number
 F S2=0:0 S RN=$O(^UTILITY($J,RN)) Q:RN=""  X "ZL @RN S X=$P($T(+2),"";"",5) I X]"""" S S=+$P(X,""**"",2),^UTILITY($J,1,S,RN)=0"
 S HED="    Patched routines" G LIST
 ;
BUILD ;
 I '$D(^XPD(9.6,0)) W !,"No BUILD file to work from." Q
 G BUILD^XTRUTL
