DICOMPY ;SFISC/GFT-EVALUATE COMPUTED FLD EXPR ;2/18/93  15:00 ; [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 G BAD:'$D(X) S DG(DLV0)=DG(DLV0)+1,DICN=DQI_DG(DLV0)_")",W=DLV#100,K=K+2,%="D"_W,K(K)=" S "_DICN_"=""""",J=" X ""F "_%_"=0:0 S "_%_"=$O("_X_%_")) Q:"_%_"'>0  "
 S DIC("S")="I '$P(^(0),U,2)",DIC="^DD("_J(DLV)_",",D=M,M=$F(I,")")-1,X=$E(I,D+1,M-1) G BAD:M<1 S:X?1"#".NP X=$E(X,2,9) S:X="" X=.01
 I X="NUMBER" S D=%,%=W,W=D,D=$S($D(^DD(J(DLV),.001,0)):$P(^(0),U,2),1:"") G NUMBER
 D DICS,^DIC G BAD:Y<0
 S T=+Y,%=DLV-DLV0,D=$P(Y(0),U,2) I D["C" S W="X",J=J_"X $P(^DD("_J(DLV)_","_T_",0),U,5,99) " G NUMBER
 D W I X="" S W="D"_%
 E  S:+Y'=Y Y=Q_Q_Y_Q_Q S W="$S($D(^(D"_%_","_Y_")):",Y="(^("_Y_")," D EP S W=W_X_",1:"""""""")"
NUMBER I DICF S DG(DLV0)=DG(DLV0)+1,%X=DQI_DG(DLV0)_")",K(K)=" S X=0,"_%X_"=0"_K(K) D L S W=W_" "_%X_"="_%X_"+1 I "_%X_"="_+DICF_" S "_DICN_"=Y Q",DPS(DPS,"O")=""
 E  D @DICF
 I $D(DICOMPX)#2 S %X=J(DLV)_U_T_$E(";",1,$L(DICOMPX)) S:";"_DICOMPX_";"'[(";"_%X) DICOMPX=%X_DICOMPX
 S W=W_""" S "_$S($D(DICOMPX(0)):"("_DICOMPX(0)_%_"),D("_%_")",1:"D("_%)_")=D"_%
 I DICF="COUNT" S DICN="+"_DICN
 S K=K+1,K(K)=J_W,K(K,2)=0,K=K+1,K(K)=DICN,M=M+1 I "TOTAL"=DICF!$T K DATE(K-2) Q
 Q:$D(DPS(DPS,"INTERNAL"))  I D["O",$D(^DD(J(DLV),T,2)) S K=K+1,K(K)=" S Y=X "_^(2),K(K,2)=0,K=K+1,K(K)="Y" Q
 S:D["D" DATE(K)=1 S X="X",DICN=T,T=J(DLV) D S^DICOMP0 Q:X="X"
 S K(K,2)=0,K=K+1,K(K)=X Q
 ;
W S X=$P(Y(0),U,4),Y=$P(X,";",1),X=$P(X,";",2) Q
 ;
DICS ;
 S:DUZ(0)'="@" D=DICOMP["W"+8,DIC("S")=DIC("S")_" Q:'$D("_DIC_"Y,"_D_"))  F %=1:1:$L(^("_D_")) I DUZ(0)[$E(^("_D_"),%) Q" Q
G ;
 D W I X="" S Y=T#100,X=$S(T<DLV0&$D(M(Y,T))!(DICOMP["T"&(T<DICO(0))):$S(DA:DQI_(T+80)_")",1:"I("_T_",0)"),1:"$S('$D(D"_Y_"):"""",D"_Y_"<0:"""",1:D"_Y_")") Q
 I '$D(DG(%,T_U_Y)) S (DG(%),DG(%,T_U_Y))=DG(%)+1
 S Y="("_DQI_DG(%,T_U_Y)_"),"
EP I X S X="$P"_Y_"U,"_X_")" Q
 I X?1"E".E S X="$E"_Y_+$E(X,2,9)_","_$P(X,",",2)_")"
 Q
 ;
BAD S DPS=0 Q
 ;
PREVIOUS S W="I $O("_V_"D"_%_"))=I("_DLV_",0) S "_DICN_"="_W_" Q" Q
NEXT S X=" S D"_%_"=+$O("_V_"D"_%_")) " I D["C" S X=X_"X $P(^"_$P(J,"X $P(^",2)
 S J=X_"S "_DICN_"=",W=W_" S:D"_%_"'>0 D"_%_"=-1,"_DICN_"=""" Q
MAXIMUM S %X="'>" G MM
MINIMUM S %X="'<"
MM D L S W=W_"&("_DICN_%X_"Y!'$L("_DICN_")) "_DICN_"=Y" Q
TOTAL S W="S "_DICN_"="_DICN_"+"_W Q
COUNT S W=$S($P(Y(0),U,2)["W":"S ",1:"S:"_W_"'?."""" """" ")_DICN_"="_DICN_"+1" Q
LAST D L S W=W_" "_DICN_"=Y" Q
L S W="S Y="_W_" S:Y'?."""" """"" S:D["D" DPS(DPS,"DATE")=1
 Q
