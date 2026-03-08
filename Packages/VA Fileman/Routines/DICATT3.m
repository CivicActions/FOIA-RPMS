DICATT3 ;SFISC/XAK-COMPUTED FIELDS ;1/11/91  2:21 PM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
6 W !!,"'COMPUTED-FIELD' EXPRESSION: " I O,$D(^DD(A,DA,9.1)) S (X,Y)=^(9.1),%=$L(X)>19 W X W:'% "// " I % D RW^DIR2 W ! G 61
 R X:DTIME,! S:'$T X=U,DTOUT=1
61 K DICOMPX S DICOMPX="" I U[X G:X=U N^DICATT:O,CHECK^DICATT G 6:'O D DEC:$P($P(O,U,2),"J",1)="C" G N^DICATT
 G DICATT3^DIQQ:X?."?" S Z=X,DQI="Y("_A_","_DA_",",DICMX="X DICMX",DICOMP="?I"
 D ^DICOMP I '$D(X) W $C(7),"  ...",I,"??" G 6
 I DUZ(0)="@" W !,"TRANSLATES TO THE FOLLOWING CODE:",!,X,!
 I Y["m" W !,"FIELD IS 'MULTIPLE-VALUED'!",!
 I O,$D(^DD(A,DA,9.01))!(DICOMPX]"") D ACOMP
 S (Y,DATE)=$E("D",Y["D")_$E("B",Y["B")_"C"_$S(Y'["m":"",1:"m"_$E("w",Y["w")),^DD(A,DA,0)=F_U_Y_"^^ ; ^"_X,^(9)=U,^(9.1)=Z,^(9.01)=DICOMPX
 F Y=9.2:.1 Q:'$D(X(Y))  S ^(Y)=X(Y)
 K X,DICOMPX D SDIK^DICATT22:'O,DEC:DATE="C" I O S DI=A D PZ^DIU0
 K DATE G N^DICATT
 ;
ACOMP ;SET/KILL ACOMP NODES
 N X,I I $D(^DD(A,DA,9.01)),^(9.01)]"" S X=^(9.01) X ^DD(0,9.01,1,1,2)
 I DICOMPX]"" S X=DICOMPX X ^DD(0,9.01,1,1,1)
 Q
DEC S C=$P(^DD(A,DA,0),U,2),Y="",Z=$P(C,"J",2) F J=0:0 S N=$E(Z,1) Q:N?.A  S Z=$E(Z,2,99),Y=Y_N
 W !,"NUMBER OF FRACTIONAL DIGITS TO OUTPUT (ONLY ANSWER IF NUMBER-VALUED): " S N=$P(Y,",",2),E=$S(Y:+Y,1:8) I N]"" W N,"// "
 R DG:DTIME S:'$T DTOUT=1 Q:DG[U!'$T  S N=$S(DG="":N,DG="@":"",1:DG) G S:N="",DICATT31^DIQQ:N'?1N
 I C?1"D".E S C=$E(C,2,99),^(0)=$P(^(0),U,1)_U_C_U_$P(^(0),U,3,99)
 S DG=" S X=$J(X,0,",M=$P(^(0),DG,1),%=M_DG_N_")"'=^(0)+1 W !,"SHOULD VALUE ALWAYS BE INTERNALLY ROUNDED TO ",N," DECIMAL PLACE",$E("S",N'=1) D YN^DICN G DEC:'% Q:%'>0  S ^(0)=M_$P(DG_N_")",U,%)
S S DQI="Y(",O=$D(^(9.02)),X=^(9.1) K DICOMPX,^(9.02) G J:'$D(^(9.01))
 F Y=1:1 S M=$P(^(9.01),";",Y) Q:M=""  S DICOMPX(1,+M,+$P(M,U,2))="S("""_M_""")",DICOMPX=""
 G J:Y<2 I X'["/",X'["\" G J:X'["*",J:Y<3
 D ^DICOMP G J:$D(X)-1
 S %=2-O W !,"WHEN TOTALLING THIS FIELD, SHOULD THE SUM BE COMPUTED FROM",!?7,"THE SUMS OF THE COMPONENT FIELDS" D YN^DICN
 I %=1 S ^DD(A,DA,9.02)=X_" S Y=X"
J K DICOMPX Q:$D(DTOUT)  W !,"LENGTH OF FIELD: ",E,"// " R DG:DTIME S:'$T DTOUT=1 Q:DG[U!'$T  I DG,DG\1=DG S E=DG G 0
 I DG]"" W !,"MAXIMUM NUMBER OF CHARACTERS" G J
0 S ^(0)=$P(^DD(A,DA,0),U,1)_U_$P(C,"J",1)_"J"_E_$E(",",N]"")_N_Z_U_$P(^(0),U,3,99)
