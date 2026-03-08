DID1 ;SFISC/XAK,JLT-STD DD LIST ;12/16/94  4:27 PM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 S DJ(Z)=D0,DDL1=14,DDL2=32 G B
 ;
L S DJ(Z)=0
A S DJ(Z)=$O(^DD(F(Z),DJ(Z))) I DJ(Z)'>0 S:DJ(Z)="" DJ(Z)=-1 W !! S Z=Z-1 Q
B S N=^DD(F(Z),DJ(Z),0) K DDF I $D(DIGR),Z<2!(DJ(Z)-.01) X DIGR E  G ND
 D HD:$Y+6>IOSL Q:M=U  W !!,F(Z),",",DJ(Z)
 W ?(Z+Z+12),$P(N,U,1),?DDL2+4," "_$P(N,U,4)
 S X=$P(N,U,2) I X,$D(^DD(+X,.01,0)) S W=$P(^(0),U,2) I W["W" W "   WORD-PROCESSING #",+X W:W["L" " (NOWRAP)" S X=""
 F W="BOOLEAN","COMPUTED","FREE TEXT","SET","DATE","NUMBER","POINTER","K","VARIABLE POINTER" I X[$E(W) D VP^DIDX:$E(W)="V" S:W="K" W="MUMPS" W ?40," "_W G ND:M=U
 I +X S W=" Multiple" S W=W_" #"_+X D W G ND:M=U
 I X["V" S I=0 F  S I=$O(^DD(F(Z),D0,"V",I)) Q:I'>0  S %Y=$P(^(I,0),U) I $D(^DIC(%Y,0)),$D(@(^(0,"GL")_"0)")) S ^UTILITY($J,"P",$E($P(^(0),U),1,30),0)=%Y,^(F(Z),DJ(Z))=0
 S:I="" I=-1 G MP:X'["P"!X S Y=$P(N,U,3) I Y]"",$D(@("^"_Y_"0)")) S %Y=+$P(X,"P",2),W=" TO "_$P(^(0),U,1)_" FILE (#"_%Y_")",^UTILITY($J,"P",$E($P(^(0),U,1),1,30),0)=%Y,^(F(Z),DJ(Z))=0 D W G ND:M=U,MP
 S W=" ** TO AN UNDEFINED FILE ** " W:($L(W)+$X)'<IOM ! D W G ND:M=U
MP I X'["V" D RT^DIDX G:M=U ND
S I X["S" S N=$P(N,U,3) F %1=1:1 S Y=$P(N,";",%1) Q:Y=""  W ! S W="'"_$P(Y,":",1)_"' FOR "_$P(Y,":",2)_"; " D W G ND:M=U
 G RD:$D(DINM) I X["C" S W=$P(N,U,5,99) W !?DDL1,"MUMPS CODE: " D W G ND:M=U G RD
 I "Q"'[$P(N,U,5) W !?DDL1,"INPUT TRANSFORM:" S W=$P(N,U,5,99) D W G ND:M=U
 I $D(^DD(F(Z),DJ(Z),2))#2 W !?DDL1,"OUTPUT TRANSFORM:" S W=$S($D(^DD(F(Z),DJ(Z),2.1)):^(2.1),1:^(2)) D W G ND:M=U
RD D ^DID2:$O(^DD(F(Z),DJ(Z),2.99))]"" G ND:M=U I 'X S W="UNEDITABLE" W:X["I" ! D W:X["I" G N
 I $O(^DD(+X,0,"ID",""))]"" W !?DDL1,"IDENTIFIED BY:" S W="" F %=0:0 S %=$O(^DD(+X,0,"ID",%)) S:%>0 W=W_$P(^DD(+X,%,0),U)_"(#"_%_"), " I %'>0 D W G ND:M=U Q
 S Z=Z+1,DDL1=DDL1+2,DDL2=DDL2+2,F(Z)=+X
 D L
N K DDN1 I X["X" S DDN1=1 W !,?DDL1,"NOTES:",?DDL2,"XXXX--CAN'T BE ALTERED EXCEPT BY PROGRAMMER" W ! G ND:M=U
 S W=0 I $O(^DD(F(Z),DJ(Z),5,W))'="",'$D(DDN1) W !?DDL1,"NOTES:"
TR S W=$O(^DD(F(Z),DJ(Z),5,W)) S:W="" W=-1 G IX:W'>0 S I=^(W,0),%=+I I '$D(^DD(%,$P(I,U,2),0))!$D(W(I)) K ^DD(F(Z),DJ(Z),5,W) G TR
 S W(I)=0 S WS=W D WR^DIDH1 W ! S W=WS K WS G TR
IX S F=0 F  S F=$O(^DD(F(Z),DJ(Z),1,F)) Q:F'>0  G ND:M=U W !?DDL1,"CROSS-REFERENCE:" D IX1
 S:F="" F=-1
ND S X="" G:M'=U A:Z>1 Q
IX1 S W=^(F,0)_" " K DDF W ?DDL2,W,! G ND:M=U D TP:$P(W,U,3)["TRIG" I '$D(DINM) S X=0 F %=0:0 S X=$O(^DD(F(Z),DJ(Z),1,F,X)) Q:X=""  I X'="%D",X'="DT" S W=^(X) S:$L(W)<248 W=X_")= "_W K:X=3 DDF D W W ! G ND:M=U
 Q:'$D(^("%D"))  N X,%,W S %=$P($G(^DD(F(Z),DJ(Z),1,F,"%D",0)),U,3),X=0 F  S X=$O(^DD(F(Z),DJ(Z),1,F,"%D",X)) Q:X'>0  Q:+%&(X>+%)  S W=^(X,0) W:X>1 " " D W1^DIDH1 G ND:M=U
 W !
 Q
 ;
TP S X=+$P(^(0),U,4) I F(Z)-X,$D(^DIC(X,0))#2 S ^UTILITY($J,"P",$E($P(^(0),U,1),1,30),0)=X,^(F(Z),DJ(Z))=6
 Q
W F K=0:0 W:$D(DDF) ! W ?DDL2 S %Y=$E(W,IOM-$X,999) W $E(W,1,IOM-$X-1) Q:%Y=""  S W=%Y,DDF=1
 K:'X DDF Q:$Y+6<IOSL
HD S DC=DC+1 D ^DIDH Q
