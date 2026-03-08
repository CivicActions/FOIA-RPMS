DICM ;SFISC/GFT,XAK,TKW-MULTIPLE LOOKUP FOR FLDS WHICH MUST BE TRANSFORMED ;11/26/96  13:02 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**29**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 S:'$D(DICR(1)) DICR=0 I $A(X)=34,X?.E1"""" G N
 G:$D(^DD(+DO(2),0,"LOOK")) @^("LOOK") I DIC(0)["U" S DD=0 G W
R S DID(2)=0 I DICR=0!($E($G(DICR(DICR,1)))'=U),$G(DID)]""!(D'="B") S %="",DID(2)=1 G Z
 S %="B",Y=+DO(2),%Y=.01,DD=0 G 1
Z S:%=-1 %="" D  S:%="" %=-1
 . I DID(2) D  I DID(2) S DID(2)=DID(2)+1 Q
 .. I $G(DID)]"" D  Q
 ... F  S %=$P(DID,U,DID(2)) Q:%=""!(%=-1)  Q:$$IDXOK(%)  S DID(2)=DID(2)+1
 ... Q
 .. S %=$P(D,U,DID(2)) S:'$$IDXOK(%) %="" Q:DIC(0)'["M"  I %="" S %=D,DID(2)=0
 .. Q
 . F  S %=$O(^DD(+DO(2),0,"IX",%)) Q:%=""  Q:$$IDXOK(%)
 . Q
 S DD=1,Y=$O(^DD(+DO(2),0,"IX",%,0)) S:Y="" Y=-1 S %Y=$O(^(Y,0)) S:%Y="" %Y=-1
1 G 2:Y<0,Z:$D(DICR(U,Y,%Y)),Z:D'=%&(DIC(0)'["M"),Z:'$D(^DD(Y,%Y,0))
 S DICR(U,Y,%Y)=0,DS=^DD(Y,%Y,0) I $D(^(7)) D RS K DS X ^(7) G Y
 S DIX=Y F Y="P","D","S","V",-1 I $P(DS,U,2)[Y D A D:'Y ^DICM1,D Q
Y G R:Y<0
2 K DID(2)
 G K:Y+1 I X?.E1L.E,DIC(0)'["X" D %,LC^DICM1 G K:Y+1
 S DS="",DIX=$P(X,",",1) F %=2:1 S DD=$P(X,",",%) I DD'["""" S:$A(DD)=32 DD=$E(DD,2,999) Q:$L(DD)*2+$L(DS)>200!(DD="")  S DS=DS_" I %?.E1P1"""_DD_""".E!(D'=""B""&(%?1"""_DD_""".E))"
 I DS]"",DIC(0)'["X",$L(DIX)<31 D % S X=DIX,DS="S %=$P(^(0),U,1)"_DS,DIC(0)=DIC(0)_"D" D 7 G K:Y+1
 I $L(X)>30 D
 . D % S Y="DICR("_DICR_")",DS=$S(DIC(0)["X":"I $P(^(0),U)="_Y,1:"I '$L($P(^(0),"_Y_"))"),X=$E(X,1,30) S:DIC(0)["O"&(DIC(0)'["E") DS=DS_",'$L($P($P(^(0),U),"_Y_",2))" D 7 Q:Y>0
 . Q:X'?.E1L.E  Q:DIC(0)["X"
 . D % S Y=$E($$OUT^DIALOGU(DICR(DICR),"UC"),1,60),X=$$OUT^DIALOGU($E(X,1,30),"UC")
 . S DS="I '$L($P(^(0),"""_Y_"""))" S:DIC(0)["O"&(DIC(0)'["E") DS=DS_",'$L($P($P(^(0),U),"""_Y_""",2))"
 . D 7 Q
K S DD=$D(DICR(DICR,6)) K:'DICR DICR
 I Y+1 K DIC("W") G R^DIC2
W D U G:'$T NL:DIC(0)["N",DD I DO(2)'["Z" S Y=0 F DS=1:1 S @("Y=$O("_DIC_"Y))") S:Y="" Y=-1 Q:Y'>0  W:DIC(0)["E"&(DS#20=0) ".." I $D(^(Y,0)),$P(^(0),U)=X X:$D(DIC("S")) DIC("S") I  S DIY="",DS=1 G GOT^DIC2
NL I '$D(DICR) D NQ I $T S (DS,DIASKOK)=1 G GOT^DIC2
DD G B:DD
L I DIC(0)["L" K DD G ^DICN
B G O^DIC1
 ;
N D RS S X=$E(X,2,$L(X)-1),DS=^DD(+DO(2),.01,0),%=D,%Y=.01 F Y="P","D","S","V" I $P(DS,U,2)[Y K:Y="P" DO D ^DICM1 Q
 S Y=-1 D L:$D(X),E G B:Y<0,2
 ;
IDXOK(%) ; See whether selected index exists in 1 nodes of DD
 N DIX,%Y,DD,X Q:%="" 0
 S DIX=$O(^DD(+DO(2),0,"IX",%,0)) Q:'DIX 0
 S %Y=$O(^DD(+DO(2),0,"IX",%,DIX,0)) Q:'%Y 0
 F DD=0:0 S DD=$O(^DD(DIX,%Y,1,DD)) Q:'DD  S X=$P($G(^(DD,0)),U,2) Q:X=%
 Q:'DD 0
 Q 1
 ;
A I DD D  I 'DD S (DD,Y)=-1 Q
 . N DI1,I,J S DI1=0
 . F DD=DD-1:0 S DD=$O(^DD(DIX,%Y,1,DD)) Q:'DD  S I=$G(^(DD,0)),J=$P(I,U,2) I J]"" D  Q:DI1&(J=%)
 .. I 'DI1!(J=%),$P(I,U,3,9)="",$D(^DD(+DO(2),0,"IX",J,DIX,%Y))#2 D
 ... I $G(DID)]"" S:(U_DID)[(U_J_U) DI1=DD Q
 ... I DIC(0)'["M",J'=D Q 
 ... S DI1=DD Q
 .. Q
 . I DI1 S DD=1,%=$P(^DD(DIX,%Y,1,DI1,0),U,2)
 . Q
 S DICR(DICR+1,4)=%
 D % K DF,DID,DINUM Q
 ;
% I %'="B"!(DIC(0)'["L") S DICR(DICR+1,8)=1
 I $G(DINUM)]"" S DICR(DICR+1,10)=DINUM
 I $D(DF) S DICR(DICR+1,9)=DF S:$G(DID)]"" DICR(DICR+1,9.1)=$G(DID(1))_U_DID
RS S DICR=DICR+1,DICR(DICR)=X,DICR(DICR,0)=DIC(0),DD="A" D DZ S DD="Q"
DZ S DIC(0)=$P(DIC(0),DD,1)_$P(DIC(0),DD,2) Q
 ;
D S:$G(DICR(DICR,10))]"" DINUM=DICR(DICR,10)
 S (D,DF)=DICR(DICR,4) D
 . N T S T=$P($G(DS),U,2)
 . S DIC(0)=$TR(DIC(0),"M","") I T["V" S DIC(0)=$TR(DIC(0),"A","")
 . I D="B",T'["D" S DIC(0)=DIC(0)_"S"
 . I T["P"!(T["V")!(T["S") S DIC(0)=DIC(0)_"X"
 . Q
RCR S:'$D(DIDA) DICRS=1
DIC ;
 I $D(DICR(DICR,8)) S DD="L" D DZ
 S Y=-1 I $D(X),$L(X)<31 D RENUM^DIC1 K DIDA
 S:DIC(0)["L" DICR(DICR-1,6)=1 K:$D(DICR(DICR,4)) DF
E S D="B",%=DICR,X=DICR(%),DIC(0)=DICR(%,0),DICR=%-1
 S:$G(DICR(%,10))]"" DINUM=DICR(%,10)
 S:$D(DICR(%,9)) (D,DF)=DICR(%,9) I $G(DICR(%,9.1))]"" S:$P(DICR(%,9.1),U)]"" DID(1)=$P(DICR(%,9.1),U) S DID=$P(DICR(%,9.1),U,2,999)
 K DICRS,DICR(%) D DO^DIC1:'$D(DO) Q
 ;
U I @("$O("_DIC_"""A[""))=""""")
 Q
 ;
NQ I $L(X)<14,X?.NP,+X=X,@("$D("_DIC_"X,0))") S Y=X D S^DIC
 Q
 ;
SOUNDEX I DIC(0)["E",'$D(DICRS) W "  " D RS,SOU S DD="L" D DZ,RCR Q:Y>0
 G R
 ;
7 S Y=-1,%=$S($D(DIC("S")):DIC("S"),1:1) I $D(DS),'$D(DIC("S1")) S DIC("S")=DS,DD="L" S:'% DIC("S")=DIC("S")_" X DIC(""S1"")",DIC("S1")=% D:X]"" DZ,F^DIC K DIC("S") S:$D(DIC("S1")) DIC("S")=DIC("S1") K DIC("S1")
 G E
 ;
SOU G SOU^DICM1
