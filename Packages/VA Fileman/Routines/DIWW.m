DIWW ;SFISC/GFT-OUTPUT WP LINE ;6/21/96  12:53 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**15**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=0:1 G:$D(DN) QQ:'DN Q:'$D(^UTILITY($J,"W"))  D T G:$D(DN) QQ:'DN D 0
T W:$X !
B Q:$S($D(DN):'DN,1:0)  I '$D(DIWF) S DIWF=""
 I '$D(DIOT(2)),$D(IOSL),$Y+$S($P(DIWF,"B",2):$P(DIWF,"B",2),1:2)'<IOSL,$D(^UTILITY($J,1))#2,^(1)?1U1P1E.E X ^(1) I $D(DN),'DN S D0="zzzzzz",W=9999999 Q
 F I=$Y+2:1:+$P(DIWF,"T",2) W !
 Q
 ;
A ;
 D 0 G DIWW
 ;
NX ;
 W:$X+1>DIWL ! D B G:$D(DN) Q:'DN
0 ;
 S I=999999,%=0 F  S %=$O(^UTILITY($J,"W",%)) Q:%'>0  S:$O(^(%,""))<I I=$O(^(""))
1 S %=0 F  S %=$O(^UTILITY($J,"W",%)) Q:%'>0  I $D(^(%,I)) D W I $D(^UTILITY($J,"W",%))<9 K ^(%) I $O(^(""))="" K DIWI,DIWX,DIWTC
 S:%="" %=-1 G Q
 ;
W G X:^(I,0)="",O:'$D(DIWF) I DIWF[" " S DIWF=$P(DIWF," ",1)_$P(DIWF," ",2) G X:^(0)?." "
 W:$X+1>% ! I DIWF["L",$D(^("L")) W $E(^("L")_"   ",1,4)
O W ?%-1,^(0)
X D U:$D(^("U")) I $D(^("X")) S Y=^("X") D K X Y Q
K K ^UTILITY($J,"W",%,I) Q
 ;
U Q:'$D(IOST)  Q:IOST'?1"P".E  W $C(13) F DE=1:1:$S($D(^("L")):%+3,1:%-1) W " "
 S DE=1
UU S %Y=$O(^UTILITY($J,"W",%,I,"U","")) I %Y="" S %Y=$L(^UTILITY($J,"W",%,I,0))+1 S:'$D(DIWFWU) DIWFWU=" " D UUU K DIWFWU Q
 S Y=^(%Y) K ^(%Y) I Y="" D UUU K DIWFWU G UU
 S DIWFWU=Y F DE=DE:1 G UU:DE'<%Y W " "
UUU I $D(DIWFWU) F DE=DE:1 Q:DE'<%Y  W DIWFWU
Q Q
QQ K DIWI,DIWX,DIWTC Q
 ;
RCR ;
 F DQI=1:1 I '$D(DIWF(DQI)) S DIWF(DQI)="" Q
 F M="DIWX","DICMX","DIC","D","D0","D1","D2","D3","D4","D5","D6","D7","Y" I $D(@M)#2 S DIWF(DQI,M)=@M
 S DQI="Y(",DA="X(",DICMX="X DICMX",DICOMP="T" S:$D(DIA("P"))#2 J(0)=DIA("P") D EN1^DICOMP
 I '$D(X) G RESTORE:DIWF'["?"!(IO(0)=IO)!$D(IO("C")) U IO(0) W $C(7),!,$P(@(I(0)_"D0,0)"),U,1),"---",!?4,$P(DIWX,DIW,1)_": " R X:DTIME,! U IO G BACK
 I Y["m" S DICMX=$S(Y["w":"D ^DIWP",1:"S DIWX=X,DIWTC=1 D DIW^DIWP S DIWI=$J("""","_$L(DIWI)_")") X X S X="" G BACK
 I Y["X" S X=DIW_X_DIW G BACK
 I $P(DIWX,"SETPAGE(",1)="" S ^(DIWL,^UTILITY($J,"W",DIWL),"X")=X,X="" G BACK
 S DICMX=Y["D" X X I DICMX S Y=X X ^DD("DD") S X=Y
 I $P(DIWX,"INDENT(",1)="" S X=$J(X,$P(DIWF,"I",2)-$L(DIWI)-1)
BACK D C^DIWP:X]"" S X="" K DICMX
RESTORE F DQI=1:1 I '$D(DIWF(DQI)) S DQI=DQI-1,M="" Q
R S M=$O(DIWF(DQI,M)) I M]"" S @M=DIWF(DQI,M) G R
 K DIWF(DQI) Q
 ;
DIQ ;
 S DIWF=$E("N",C["L")_"W|",DIWL=2,DIWR=IOM,X=O_":   " K ^UTILITY($J,"W")
 X "S W=0 F  D ^DIWP X ""N W W:$E(IOST)=""""C""""&(S>21) ! ""_DX(0) S W=$O("_D(DL-1)_"W)) Q:W'>0!(S=0)  S X=^(W,0)" S:W="" W=-1
 G DIWW
 ;
H G H^DIO2
DT G DT^DIO2
 ;
N W ! G B
