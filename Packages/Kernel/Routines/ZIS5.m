%ZIS5 ;SFISC/STAFF --DEVICE LOOK-UP ;11/5/97  09:29 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1002,1003,1004,1005,1007**;APR 1, 2003
 ;;8.0;KERNEL;**18,24,69**;JUL 10, 1995
 N %DO,%DIY,%DD,%DIX
 S U="^",%DO="" K DUOUT
 I $D(^%ZIS(%ZISDFN,0)) S %DO=^(0)
A G:%ZIS(0)'["A" X I $D(%ZIS("A")) S %DD=%ZIS("A") G B
 S %DD="Select "_$P(%DO,U,1)_": "
B I $D(%ZIS("B")),%ZIS("B")]"" S %YY=%ZIS("B"),%XX=$O(^%ZIS(%ZISDFN,%D,%YY)),%DIY=$S($F(%XX,%YY)-1=$L(%YY):%XX,$D(^%ZIS(%ZISDFN,%YY,0)):$P(^(0),U,1),1:%YY) W %DD,%DIY,"// " R %XX:$S($D(DTIME):DTIME,1:9999) G G:%XX]"" S %XX=%DIY G G
 W !,%DD R %XX:$S($D(DTIME):DTIME,1:9999)
G G NO:'$T,NO:%XX["^" G:%XX?.N&(+%XX=%XX) NUM I %XX'?.ANP!($L(%XX)>30) W:%ZIS(0)["Q" *7," ??" G A
X I %XX=" ",$D(DUZ)#2,$D(^DISV(+DUZ,"^%ZIS("_%ZISDFN_",")) S %YY=+^("^%ZIS("_%ZISDFN_",") D S G:'$T NO G GOT
F G NO:%XX="" K %DS S %DS=0,%DS(0)=1,%DIX=%XX,%DIY=0
 I $D(^%ZIS(%ZISDFN,%D,%XX)) G T1
TRY S %DIX=$O(^%ZIS(%ZISDFN,%D,%DIX)) G:$P(%DIX,%XX,1)'=""!(%DIX="") T2 S %DIY=0
T1 S %DIY=$O(^%ZIS(%ZISDFN,%D,%DIX,+%DIY)) G:%DIY'>0 TRY S %YY=+%DIY D S G:'$T T1
 I %DS,'(%DS#10) D LST G NO:%XX=U,ADD:%YY<0,GOT:%YY>0
 S %DS=%DS+1,%DS(%DS)=%DIY G T1
LSYN ;
S I $D(^%ZIS(%ZISDFN,%YY,0)) G S1
 Q
S1 G S2:%ZISDFN'=1!(%D'="LSYN") I $P(^%ZIS(1,%YY,0),U,9)=%ZISV!($P(^(0),U,9)="") G S2
 Q
S2 N Y S Y=%YY D:$D(%ZIS("S")) XS^ZISX Q
T2 G:'%DS NO S %DIY="" D LST G NO:%XX=U,ADD:%YY<1,GOT
LST I %DS=1,'$D(%ZISLST) S %YY=%DS(1) Q
 S %YY=-1 Q:%ZIS(0)'["E"  W !
 F %DZ=%DS(0):1:%DS W !,$J(%DZ,2)," ",$P(^%ZIS(%ZISDFN,%DS(%DZ),0),U,1) D:%ZISDFN=1  I $D(%ZIS("W")),$D(^(0)) W "  " D XW^ZISX
 . ;Show Location
 . S %=$G(^(1)) W:$X+$L($P(%,U))>74 !?75-$L(X) W "   "_$P(%,U)
L1 W:%DIY !,"Type '^' to Stop, or" W !,"Choose 1" W:%DS>1 "-",%DS
 R "> ",%YY:$S($D(DTIME):DTIME,1:9999) S %ZISLST=1 I %YY="",%DIY S %DS(0)=%DS+1,%YY=0 W ! Q
 I %YY=U!(%YY="") S %YY=-1,DUOUT=1 S:%YY=U %XX=U Q
 I +%YY'=%YY!(%YY<1)!(%YY>%DS) W:%ZIS(0)["Q" *7," ??" G L1
 S %YY=%DS(%YY) Q
GOT S %DZ=^%ZIS(%ZISDFN,+%YY,0)
 W:%ZIS(0)["E" "  ",$P(%DZ,U,1)
R I %ZIS(0)'["F" S:$S($D(DUZ)#2:$S(DUZ:1,1:0),1:0) ^DISV(DUZ,"^%ZIS("_%ZISDFN_",")=+%YY
 I %ZIS(0)["Z" S %YY(0)=^%ZIS(%ZISDFN,+%YY,0)
Q K %ZISDFN,%DO,%DD,%DIX,%DIY,%DZ Q
K K %D,%DS,%ZISLST Q
ADD ;can't add to files
NO S %YY=-1 G Q
NUM I $D(^%ZIS(%ZISDFN,%XX)) S %YY=%XX D S I $T G GOT
 G F
1 F %D="B","LSYN" S %ZISDFN=1,%ZIS(0)=$S($D(IOP):"M",1:"EMQ") D %ZIS5 Q:%YY>0
 D K Q
2 S %D="B",%ZISDFN=2,%ZIS(0)=$S($D(IOP):"M",1:"EMQ") D %ZIS5 D K Q
 ;
LD1 S %E=0,%Y=0 D LCPU:"PD"[$E(%X) S %E=0 W !
L S %E=$S("PD"[$E(%X):$O(^UTILITY("ZIS",$J,"DEVLST","B",%E)),1:$O(^%ZIS(1,"B",%E))) G:%E="" RESTART S %A=+$O(^(%E,0))
 G L:'$D(^%ZIS(1,%A,0)),L:$P(^(0),"^",2)=46,L:$P(^(0),"^",2)=63 I $D(%ZIS("S")) N Y S Y=%A D XS^ZISX G L:'$T
 I "AP"[$E(%X) G L:$P($G(^%ZIS(2,+$G(^%ZIS(1,%A,"SUBTYPE")),0)),U)'?1"P".E
 W $J($P(^%ZIS(1,%A,0),"^",1),9) W:$D(^(1)) " ",$P(^(1),"^",1) I $D(^(90)),^(90) W " ** OUT OF SERVICE"
 W ?39 I $X>40 W ! S %Y=%Y+1 I %Y>20 R "'^' TO STOP: ",%Y:$S($D(DTIME):DTIME,1:60),! G RESTART:%Y?1P S %Y=0
 G L
 ;
LCPU S %A=%ZISV
LC1 S %A=$O(^%ZIS(1,"CPU",%A)) Q:$P(%A,".")'=%ZISV  S %E=0
LC2 S %E=+$O(^%ZIS(1,"CPU",%A,%E)) G LC1:%E'>0,LC1:'$D(^%ZIS(1,%E,0)) S ^UTILITY("ZIS",$J,"DEVLST","B",$P(^(0),"^",1),%E)="" G LC2
RESTART S:$D(%H) %E=+%H K %X,^UTILITY("ZIS",$J,"DEVLST") Q
