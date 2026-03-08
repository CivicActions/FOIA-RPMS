DICM1 ;SFISC/XAK-LOOKUP WHEN INPUT MUST BE TRANSFORMED ;10/4/94  11:03 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 G @Y
 ;
P ;POINTERS
 G P^DICM0
 ;
D ;DATES
 I $S(X'?.N:1,$L(X)>15:0,1:X>49) S %DT=$S($D(^DD(+DO(2),.001)):"N",1:"")_$P($P(DS,"%DT=""",2),"""") F %="E","R" D DZ
 I  D ^%DT S X=Y K %DT I X>1 Q:DIC(0)'["E"  S DIDA=1 Q:$D(DDS)  W "   " G DT^DIQ
 K X Q
DZ S %DT=$P(%DT,%)_$P(%DT,%,2) Q
 ;
S ;SETS
 N A8,A9 I $P(DS,U,2)["*"!($D(DIC("S"))) D SC
 S DICR(DICR,1)=1,I=$P(DS,U,3),DD=$P(";"_I,";"_X_":",2) I DD]"" S Y=X X:$D(A9) A9 I  W:DIC(0)["E"&'$D(DDS) "  (",$P(DD,";",1),")" D SK Q
SS N DDH,DS S (DDH,DICMF,DS)=0
 F DICM=1:1 S DD=$P(I,";",DICM) Q:DD=""  I $P($P(DD,":",2),X)="" D
 . S Y=$P(DD,":"),DD=$P(DD,":",2) Q:DIC(0)["X"&(DD'=X)
 . I $D(A9) X A9 E  Q
 . I DIC(0)["O" S:DD=X DICMF=1 I DD'=X,DICMF=1 Q
 . S DDH=DDH+1,DDH(DDH,Y)=$S(Y=DDH:"",1:Y)_"   "_DD
 . S DS=DS+1,DS(DS)=Y_"^     "_DDH_"   "_DDH(DDH,Y)
 G:DDH=0 NO
 I DDH=1 S X=$O(DDH(1,"")) G SK
 G:DIC(0)'["E" NO
 I $D(DDS) S DD=DDH,DDD=2 K DDQ D LIST^DDSU K DDD,DDQ G:$D(DTOUT) NO
 I '$D(DDS) F  D  Q:DICM'="AGN"
 . F DICM=1:1:DDH W !,$P(DS(DICM),U,2,999)
 . W !,"CHOOSE 1-"_DDH_": "
 . R DIY:$S($D(DTIME):DTIME,1:300) E  Q
 . Q:U[DIY!(DIY[U)  I DIY?1.N,$D(DS(+DIY)) Q
 . W $C(7),"??" S DICM="AGN"
 G:'$D(DS(+DIY)) NO
 S X=$P(DS(DIY),U) G SK
 ;
NO K X,Y S Y=-1
SK K DIC("S") S:$D(A8) DIC("S")=A8
 K DDH,DICM,DICMF,DICMS
 Q
SC ;SCREENS ON SETS
 S:$D(DIC("S")) A8=DIC("S") Q:$P(DS,U,2)'["*"
 Q:'$D(^DD(+DO(2),.01,12.1))  X ^(12.1) Q:'$D(DIC("S"))
 S Y="("_DIC,I="DIC"_DICR,%=""""_%_"""",A9="X DIC(""S"")"
 Q:$G(DICR(DICR))?1"""".E1""""
 ;I DS["DINUM=X" S D=D_" E  I $D"_Y_"Y,0))" Q
 S A9=A9_" E  F "_I_"=0:0 S "_I_"=$O"_Y
 I @("$O"_Y_%_",0))'=""""") S A9=A9_%_",Y,"_I_")) Q:"_I_"=""""  "_$S($D(A8):"X ""N Y S Y="_I_" ""_A8 I $T,",1:"I ")_"$D"_Y_I_",0)) Q" Q
 S A9=A9_I_")) Q:'"_I_"  "_$S($D(A8):"X ""N Y S Y="_I_" ""_A8 I $T,",1:"I ")_"$P(^("_I_",0),U)=Y Q" Q
 ;
V ;VARIABLE POINTER
 I X["?BAD" K X Q
 D ^DICM2,DO^DIC1
 Q
 ;
LC ;
 Q:DIC(0)["X"  S DIC(0)=$P(DIC(0),"L",1)_$P(DIC(0),"L",2)
 S X=$$OUT^DIALOGU(X,"UC")
 G DIC^DICM
 ;
SOU ;
 S DSOU="01230129022455012623019202",DSOV=X,X=$C($A(X)-(X?1L.E*32)),DIX=$E(DSOU,$A(X)-64) F DIY=2:1 S Y=$E(DSOV,DIY) Q:","[Y  I Y?1A S %=$E(DSOU,$A(Y)-$S(Y?1U:64,1:96)) I %-DIX,%-9 S DIX=% I % S X=X_% Q:$L(X)=4
 S X=$E(X_"000",1,4) K DSOU,DSOV Q
 ;
ACT ;
 S DIY=Y,DIY(1)=DIC,DIC("W")="",DIX=X
A X:$D(^DD(+DO(2),0,"ACT")) ^("ACT") I Y<0 S DIC=DIY(1),X=DIX K DIC("W"),DO Q
 I DO(2)["P" S DIC=U_$P(^DD(+DO(2),.01,0),U,3) K DO D DO^DIC1 I $D(@(DIC_+$P(Y,U,2)_",0)")) S Y=+$P(Y,U,2)_U_$P(^(0),U) G A
 S Y=DIY,DIC=DIY(1),X=DIX K DIC("W"),DO D DO^DIC1 Q
