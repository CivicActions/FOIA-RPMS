DIC1 ;SFISC/GFT-READ X, SHOW CHOICES ;2/17/98  05:48 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**29,41**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;12373;7448670;3285;
 ;
 K DUOUT,DTOUT I $D(DIC("A")) S DD=DIC("A") G B
 D DO S Y=$P(DO,U) I D="B",DO(2)>1.9 S X=$P(^DD(+DO(2),.01,0),U) I X'[Y,Y'[X S Y=Y_" "_X
 S DD=$$EZBLD^DIALOG(8042,Y)
B I $D(DIC("B")),DIC("B")]"" S Y=DIC("B"),X=$O(@(DIC_"D,Y)")),DIY=$S($D(^(Y)):Y,$F(X,Y)-1=$L(Y):X,$D(@(DIC_"Y,0)")):$P(^(0),U),1:Y) W DD D WR^DIC2 R "// ",X:$S($D(DTIME):DTIME,1:300) G T:'$T,DO:X]"" S X=DIY S:DIC(0)'["O" DIC(0)=DIC(0)_"O" G DO
 W DD R X:$S($D(DTIME):DTIME,1:300) E  G T
DO ; GET FILE ATTR
 Q:$D(DO)  I $D(@(DIC_"0)")) S DO=^(0)
 E  S DO="0^-1" I $D(DIC("P")) S DO=U_DIC("P"),^(0)=DO
DO2 S DO(2)=$P(DO,U,2) I DO?1"^".E S DO=$O(^DD(+DO(2),0,"NM",0))_DO
 I DO(2)["s",$D(^DD(+DO(2),0,"SCR")) S DO("SCR")=^("SCR")
 Q:DO(2)'["I"!$D(DIC("W"))  Q:'$D(^DD(+DO(2),0,"ID"))  S %=0,DIC("W")="" I DO(2)["P" D WOV S %=+DO(2),%Y=DIC G P
W ;
 S %=$O(^DD(+DO(2),0,"ID",%)) I %]"" G WOV:$L(DIC("W"))+$L(^(%))>224 S:^(%)'="W """"" DIC("W")=DIC("W")_" W ""   "" "_^(%) G W
 S DIC("W")=$E(DIC("W"),2,999) Q
P I %,$D(^DD(%,.01,0)) S %=+$P($P(^(0),U,2),"P",2) I $D(^DIC(%,0,"GL")) S %W=^("GL") D Q:%W]"" G P
 Q
Q S %W1=%W
 I %W[$C(34) S %W1=$P(%W,$C(34))_$C(34,34)_$P(%W,$C(34),2)_$C(34,34)_$P(%W,$C(34),3,9)
 I $L(DIC("W"))<200 S DIC("W")=DIC("W")_" I '$D(DICR) S %Y=+"_%Y_"%Y,0) I $D("_%W_"%Y,0)) S %W="_%_",%Z="""_%W1_""" D WOV^DICQ1",%Y=%W
 K %W1 Q
WOV S DIC("W")="S %W=+DO(2),%Y=Y,%Z=DIC D WOV^DICQ1" Q
 ;
RENUM ;
 D DO I '$D(DF),X?.NP,^DD(+DO(2),.01,0)["DINUM",$D(@(DIC_"X)")) S Y=X G 1^DIC
 G F^DIC
 ;
DT S DST=DST_$$FMTE^DILIBF(%,"7S")
 I '$D(DDS) W DST S DST=""
 Q
Y ;
 S DZ=Y,DD=$O(DS(DD)),DDH=DD-1,Y=+DS(DD),DIYX=0
 I DIC(0)["E" W:'$D(DDS) !?5,DD,?9 D E
 S Y=DZ I DIC(0)["Y" G Y:DD<DS F Y=DS:-1 G Q^DIC2:'Y S Y(+DS(Y))=""
 G N:DIC(0)'["E" I DS>DD G Y:DD#5 W:'$D(DDS) !,"Press <RETURN> to see more, '^' to exit this list, OR"
 I $D(DDS) S DDD=2,DDC=5 D LIST^DDSU K DDD,DDC I $D(DTOUT) D T G N
 I '$D(DDS) W !,"CHOOSE "_$O(DS(0))_"-"_DD R ": ",DIY:$S($D(DTIME):DTIME,1:300) E  D T G N
 I DIY=""!(U[DIY)!$D(DUOUT) S:DIY=U DUOUT=1 G:DD=DS L^DICM:DO(2)["O"&(DO(2)'["A"),A^DIC G Y^DIC:DIY="" S X=U G A^DIC
 I DIY?1."?" S DIC1Q=1 I DIC(0)_$G(DICR(1,0))'["A" D
 . S DIY=X I '$D(DICRS) N DIY,X,D,DZ S D=$S($D(DF):DF,1:"B"),DZ="?" D DQ^DICQ
 I DIY'?1.N&'$D(DICRS)!$D(DIC1Q) S D=$S($D(DF):DF,1:"B"),X=DIY K DIC1Q,DIY,DS,DDH("ID") G X^DIC
 G BAD:'$D(DS(DIY))!(DIY>DD) S Y=+DS(DIY) K DIVP1
 S DIY(DIY)=$P($G(@(DIC_"Y,0)")),U)
 S:$D(DDS) DST=X_$P(DS(DIY),U,2,9)_$S($G(DIYX(DIY)):$G(DIY(DIY)),1:"")
 G C^DIC
 ;
E S DST=""
 S %=$P(X,U,'$D(DICRS))_$P(DS(DD),U,2,9),DIY=$S(%=DIY(DD):"",DO(2)["D"&($D(DIDA)!(DIY(DD)="")):%,1:"")_DIY(DD)
 S:DO(2)'["D"&'$D(DIDA) DST=DST_%
 S:$G(DIYX(DD)) DST=DST_DIY(DD),DIY=""
 D DT:D'="B"&$D(DIDA),WO^DIC2
 Q
 ;
T W $C(7) S X="",DTOUT=1 Q
OK ;
 S %=1 I $D(DS),DS=1 S DST="         ...OK" D Y^DICN
 I %>0 G R^DIC2:%=1 S X=DIX G L^DICM
O ;
BAD I DIC(0)["Q" D
 . W:'$D(DUOUT) $C(7)_$S('$D(DDS):" ??",1:"")
 . I $D(Y),Y[U S Y=-1
 Q:$D(DTOUT)  G A^DIC
N G NO^DIC
MIX ;
 S DID=D_"^-1",DID(1)=2,D=$P(DID,U) G IX^DIC
 ;
 ;#8042  Select |filename|:
