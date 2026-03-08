DIO1 ;SFISC/GFT,TKW-BUILD P-ARRAY WHICH CREATES SORTED DATA ;9/1/94  12:41 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F DJ=0:1:7 F DX=-1:0 S DX=$O(Y(DJ,DX)) Q:DX=""  F DPR=-1:0 S DPR=$O(Y(DJ,DX,DPR)) D:DPR=""  Q:DPR=""  S X=0 D A
 .Q:'$D(DIBTPGM)  I $G(P(DX))]"" S %=P(DX),DISETQ=1 D SETU
 .Q
 K W S W="",Z=" S:$T ^UTILITY($J,0" F X=1:1:DPP D  I W]"" D OVZ
 .N % S %=$S($P(DPP(X),U,4)["'":1,1:J(X)) I ($L(Z)+$L(%))'>180 S Z=Z_C_% Q
 .I %=J(X),J(X)'="DISX("_X_")" S W=W_" S DISX("_X_")="_J(X),%="DISX("_X_")"
 .S Z=Z_C_% Q
 F V=1:1:DPP I V=DPP&(W="")!(DPP(V)-DP) S F=C,Y=DP,%=1,X=0 D U D:$L(W)+$L(Z)+$L(F)+$L(DX(DPQ))+$S(V(DPQ):38,1:0)>237  S W=W_Z_F_")="""""
 .I '$D(DIBTPGM) S DIOVFL(V)=$E(W,2,999),W=" X DIOVFL("_V_")" Q
 .S %=W,(%(1),%(2))="OV",W=" D OV"_DICOV D SETU^DIOS
 .Q
 F X=-1:0 S X=$O(DX(X)),DX=X Q:X=""  D
 .N A,B S A=""
 .I $D(DIBTPGM) S B=+$O(^TMP("DIBTC",$J,X,0)),A=$G(^(B))
 .S:$E(DX(X),1)=" " DX(X)=$E(DX(X),2,999)
 .S:A="" A=DX(X)
 .S:X=DPQ A=A_W_$P(",DJ=DJ+1",U,$D(DIS)>9)
 .I V(X) S F="",%(0)=DX,%=DCC S:$D(DXIX(DX)) F=DXIX(DX) D:F="" GREF^DIOU(.V,.%,.F) S A=A_" "_"S D"_V(X)_"=$O("_F_")) Q:D"_V(X)_"'>0"
 .S DX(X)=A Q:'$D(DIBTPGM)
 .S:B ^TMP("DIBTC",$J,X,B)=A S DX(X)="D "_$P(A," ")
 .Q
 S DX(0)=DX(DP),DX=0,DPQ=0 K:DP DX(DP)
 ;
2 K D,%,I D 2^DIO I $G(DIERR) G IXK^DIO
 K DIOVFL,P,V,Y,D0,D1,D2,D3 K:'$D(DIB) DIS S:$D(DIBTPGM) DIBTPGM=""
 S V="I $D(^UTILITY($J,0" K DPP(0,"F"),DPP(0,"T") F X=1:1:DPP K DPP(X,"F"),DPP(X,"T") S V=V_$E(",DDDDDDDDDDD",1,DPP+3-X)_0
 F X=-1:0 S X=$O(DX(X)) Q:X=""  I $D(DX(X,U)) S DSC(X)=V_DX(X,U)_$S($D(DSC(X)):" "_DSC(X),1:"")
 K DX S DX=^UTILITY($J,"DX"),DJ=^("F"),%=$O(^("DX",-1)) S:%="" %=-1 F %=%:0 S DX(%)=^(%),%=$O(^(%)) I %="" G GO^DIO
 ;
U S:$D(D(Y)) X=X_D(Y) S %=%+1,Y=$P(Z(V),C,%),D=Y="",F=$S(F'=C:F_",D"_X,D:",D"_X,1:",D"_X_C_V) Q:D  S X=V(Y) G U
 ;
A S X=$O(Y(DJ,DX,DPR,X)) Q:X=""  D B G A
 ;
B S DL=Y(DJ,DX,DPR,X),W="DISX("_DL_")",DIO="=""""",D2=""
 I 'X,DL>$G(DPP(0)) S:'$D(DPP(DL,"CM")) W="D"_V(DX),DIO="<0"
 I X S Z=$P($P(^DD(DX,+X,0),U,4),";",2) S:$E(Z)="E" DIO="?."" """
 S Z="" S:$C(63,122)=$P($G(DPP(DL,"F")),U) Z=1 S:$P($G(DPP(DL,"T")),U)="@" Z=Z+2
 S F=$S($P(DPP(DL),U,4)["-":"999999999-",$P(DPP(DL),U,10)=2:"+",1:"")_$S($D(DE(DL)):"$E("_W_",1,"_DE(DL)_")",1:W)
 I Z S F="$S("_W_"'"_DIO_":"_F_",1:""  EMPTY"")" I Z>2 S F=""" """
 S J(DL)=F
 S P(DX)=$S($D(P(DX)):P(DX)_" ",1:"")
 S Y=$S($E(W,1,5)="DISX(":"S "_W_"="""" ",1:"")_DPP(DL,"GET")
 S DLN=$G(DPP(DL,"QCON")) I DL=DJK&$D(DPP(DL,"IX"))!(DLN="") S DLN="I "_W_"]"""""
 I $D(DIBTPGM) D  G BX
 .N % I $L(P(DX))+$L(Y)+$L(DLN)>237 S %=$E(P(DX),1,($L(P(DX))-1)) D SETU S P(DX)="I  "
 .S P(DX)=P(DX)_Y_" "_DLN Q
 I DPP>2!($L(P(DX))+$L(Y)>125) F Z=1:1 I '$D(P(DX,Z)) S P(DX,Z)=Y,P(DX)=P(DX)_"X P("_DX_C_Z_")"_$P(" I ",C,Y[" I ")_" "_DLN Q
 E  S P(DX)=P(DX)_Y_" "_DLN
BX S Y=DX Q
 ;
OVZ I '$D(DIBTPGM) S DIOVFL("SX"_X)=$E(W,2,999),Z=" X DIOVFL(""SX"_X_""") "_Z,W="" Q
 N % I $D(DIBTPGM) S %=W,(%(1),%(2))="OV",Z=" D OV"_DICOV_" "_Z D SETU^DIOS
 S W="" Q
 ;
SETU Q:%=""  N A
 S A=$G(DICP(DX)) I A S A="P"_A
 S ^TMP("DIBTC",$J,"P",DICNT)=A_" "_%
 I $D(DISETQ) S ^((DICNT+.001))=" Q" K DISETQ
 K DICP(DX) S DICNT=DICNT+1
 Q
