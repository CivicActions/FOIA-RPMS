DIL1 ;SFISC/GFT-STATS, NUMBER FIELD, ON-THE-FLY ;11/4/92  10:39 AM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 I $A(W)=34 S Y="" F A9=0:0 S Y=Y_""""_$P(W,"""",2)_"""",W=$P(W,"""",3,99) Q:$A(W)'=34&($A(W)'=95)  S:$A(W)=95 Y=Y_$C(95),W=$P(W,"_",2,99)
 I  K A9 S Y=" W "_Y,DLN=0,X="",DRJ=0 D DE^DIL,W^DILL:W[";" G:W[";W" WR S %=$L(Y)-5 S:'DLN DLN=% S:DRJ Y=" W ?"_(DG+DLN-%)_Y D DN^DIL0 G T^DIL
 S:DN<0 O=999 S X="",DRJ=0 I W?1"0".E K DPQ(DP,0) S Y="D"_(DIL-DIL0),X=$S($D(^DD(DP,.001,0)):^(0),1:"NUMBER^^^^$L(X)>9") G 0:$D(DCL(DP_U_0)) D ^DILL G O^DIL
 S DN=$E(W,$L(W)),X=$P(W,";",1) K DLN
 S V=$S(X?.E1" W X K Y":8,X?.E1" W X K DIP":10,X?.E1" D DT K DIP":"11D",X?.E1" D DT K Y":"9D",1:0),X=$E(X,1,$L(X)-V)_" K DIP K:DN Y"
 I W[";N" S DCL=DCL+1,X=X_" S Y=X,C="_DCL_" D D S X=Y",DITTO(DCL)=""
 S Y=" "_X,X="^^^^"_X,%=DN,DN=-3
 I W[";m" D W S X="D "_$E("L",W'[";w")_"^DIWP",V=$F(Y,"D ^DIWP"),Y=$S(V:$E(Y,1,V-8)_X_$E(Y,V,999),1:" S DICMX="""_X_""""_Y) G T^DIL
 D CLC^DILL:V,W^DILL:'V
 S:'$D(DLN) DLN=9 I W[";W" D W S Y=Y_" D ^DIWP" G T^DIL
 G O^DIL:"+#&!*"'[%
 S X="^C"_V_"^^^"_$E(Y,2,999),W=-1_";"_$P(W,";",2,9),DCL(DP_U_-1)=%
0 D DE^DIL,STATS G T^DIL
 ;
W D DE^DIL,WR^DIL0 S Y=Y_" "_$E(X,5,999) Q
 ;
WR S D1=" S Y="_$P(Y,"W ",2,999),Y="" D W^DIL0
 F D1=D1," S X=Y D ^DIWP" S:$L(Y)+$L(D1)'>250 Y=Y_D1 I $F(Y,D1)-1'=$L(Y) D PX^DIL S Y=D1
 G T^DIL
 ;
STATS ;
 I DG<10!(DG>900) S DG=10 D DE^DIL I DE'["!" S DE=" W:$X>8 !"_DE
 S V=DP_U_+W,I=DCL(V),D=+I S:'D (D,DCL)=DCL+1,DCL(V)=D_I
 S DXS=$S(I["*":"C",I["#":"S",I["&":"A",I["+":"P",1:1),I=$P(X,U,2),V=I,%=":Y"_$S(I["C":"'?.""*""",Y["$E":"'?."" """,1:"]""""") I DXS S DSUM=" S"_%_" N("_D_")=N("_D_")+1",N(D)=0 G E
 G @DXS
 ;
C S CP(D)=""
S S Q(D)=0,L(D)=9999999999,H(D)=-L(D) I $P(I,"I",2) S DLN=+$P(I,"I",2)
P S N(D)=0
A S (S(D),DRJ)=0
 S DSUM=",C="_D_" D "_DXS_%
E I I["C" D V^DILL S Y=Y_" S Y=X"_DSUM,DXS=$S($D(^DD(DP,+W,9.02)):^(9.02),1:0) G UTIL
DILL S DXS=DSUM,Y=" S Y="_Y_DXS,I="",DXS="Y" D V^DILL
UTIL K DSUM S ^UTILITY($J,"T",DG)=DLN_U_D_U_DRJ_U_$P(X,U,2)_U_I
 I DXS?1E G DN^DIL0
 S ^(DG)=^(DG)_U_DXS,DN=^DD(DP,+W,9.01),DOP=$D(DNP),DNP="",DOP(1)=DLN,DOP(2)=X I 'DOP S V=$L(Y)+$L(DE) S:V<250 Y=DE_Y I V>249 S V=Y,Y=DE D PX^DIL S Y=V
LOOP S DE="",V=$P(DN,";"),W=$P(V,U,2),DN=$P(DN,";",2,99) G Q:V="",LOOP:$D(DCL(V))
 D PX^DIL,XDUY^DIL0,^DILL
 I $P(X,U,2)'["C" S Y=",X=$G("_DI_C_DU_"))"_$P(",Y=",U,Y'[" S Y=")_Y
 E  S Y=Y_" S Y=X"
 S (D,DCL)=DCL+1,S(D)=0,DCL(DP_U_+W)=D,Y=" S C="_D_Y_" D A" G LOOP
 ;
Q S DLN=DOP(1),X=DOP(2) K:'DOP DNP K DOP G DN^DIL0
