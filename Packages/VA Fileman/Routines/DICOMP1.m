DICOMP1 ;SFISC/GFT-EVALUATE COMPUTED FLD EXPR ;2/17/93 12:45 ; [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 G 0:DPS
 I DICO["SETDATA(" S K=K+1,K(K)=DICF(1)_",DIC(DIG)=X D SD^DICR S X="""" K DIC"
 S DG=-1,T=99,M=DIM,DLV0=0,X="",K=1,W=0 K DIM
ST S DG=$O(DG(DLV0,DG)),Y=$P(DG,U,2) I DG="" D EX S DG=-1,W=0 G NN
 I Y]"" S:+Y'=Y Y=Q_Y_Q S I=DQI_DG(DLV0,DG)_")=$S($D(^(" D X:T-DG!(DG<DLV0) S I=I_Y_")):^("_Y_")" G 9
C S %=$O(DG(DLV0,DG,0)) S:%="" %=-1 I %>0 S I=" X $P(^DD("_J(DG)_","_%_",0),U,5,99) S "_DQI_DG(DLV0,DG,%)_")=X" D EX:W,M:$L(X)+$L(I)>180 S X=X_I K DG(DLV0,DG,%) G C
 G ST:$D(DG(DLV0,DG))[0 S I=DG(DLV0,DG) I I?.N S I=$S(DA:DQI_(DLV0+I+80),1:"I("_(DLV0+I)_",0")_")=$S($D(D"_I_"):D"_I
 E  S I=DQI_+DG_")="_I
 K DG(DLV0,DG) G OV:DG?.N1A
9 S I=I_",1:"""")" I $D(DICV),DICV["V" S I=I_"_$C(59)_"""_$E(I(0),2,99)_""""
OV I $L(I)+$L(X)>180 D M
 S:'W X=X_" S " S X=X_I_",",W=2 G ST
 ;
X S I=$P(I,U),%=DG\100*100 F T=0:1:DG#100 S I=I_I(%)_$E(",",1,T)_$S(DICOMP["T"&(DG<DICO(0)):"I("_%_",0)",1:"D"_T)_",",%=%+1
 K DG(DLV0,DG) Q
 ;
NN I $D(K(K,1)) S W=0,DLV0=K(K,1),DG=-1 K K(K,1) G ST
 I $D(K(K,9)) F %=1:1:K K DATE(%)
 G S:$D(K(K))[0 I " "[$E(K(K),1) G K1:K(K)="",1:X="",AS:$P(K(K)," S ",1)="" D EX:W,M:$L(X)+$L(K(K))>180 G 1
 I 'W D M:$L(X)+$L(K(K))>165 S X=X_" S X=",W=6
1 G P:K(K)?1P,A:'$D(DATE(K)) S Y=1 I K>1,K(K-1)="+" S X=X_"0,X2=X,X1="_K(K) G DTC
2 G A:'$D(K(K+2)) K DATE(K) I '$D(DATE(K+2)),$F("+-",K(K+1))>1 S X=X_K(K)_",X1=X,X2="_K(K+1)_K(K+2),DATE(K+2)=1
 E  G A:K(K+1)'="-" K DATE(K+2) S X=X_K(K)_",X1=X,X2="_K(K+2),Y=0
 S K=K+2
DTC S K=K+1,X=X_",X="""" D"_$P(":X2 ^ C",U,Y+1)_"^%DTC:X1" G S:'$D(K(K)) D SX G NN:'Y S K=K-1,K(K)="" G 2
 ;
P I "\/"[K(K),$D(K(K+1)),K(K+1)'?.NP S K=K+1,K(K)=",X=$S("_K(K)_":X"_K(K-1)_K(K)_",1:""*******"")"
 I $L(X)>150,$F(DPUNC,K(K))>3 D M,SX
A S W='$D(K(K,2)),X=X_K(K)
K1 S K=K+1 G NN:$D(K(K))#2
S S I="" F  S I=$O(M(I)),W=0 Q:I=""  D M:$L(X)>235 S K=$O(M(I,"")),X=X_" S D"_I_"="_$S(DA:DQI_(K+80),1:"I("_K_",0")_")"
 S I=-1 D SS S:X?.E1" S X=X" X=$E(X,1,$L(X)-6) I X'?1"S X="1N.NP G Q
0 ;
 S DICOMP="",DLV=DICO(1) K X,DIM,DATE I DICO[" ",DUZ(0)="@" S X=DICO,DIM=1 D ^DIM
Q I DICOMP'["S" S K=DICO(1) F  S K=$O(I(K)) Q:K=""  K I(K),J(K)
 K Y S Y=DLV_$E("W",$D(DPS("W")))_DIMW_$E("D",$D(DATE)>9)_$E("B",DBOOL)_$E("X",$D(DIM))_$E("L",$D(DICO(2)))
 K V,K,W,T,M,DG,DIM,DICN,DICF,DICV,DLV,DPS,DIC,DICOMP,DBOOL,DICO,DLV0,DPUNC,DICMX,DIMW Q
 ;
 ;
EX S X=$E(X,1,$L(X)-W+1) Q
 ;
AS D EX I $L(K(K))+$L(X)<160 S K(K)=$E(K(K),4,999),X=X_","
 E  D M
 G 1
 ;
M D SS,EX S M=M+.1,X(M)=X,X="X "_$S(DA:"^DD("_A_","_DA_",",1:DA)_M_")",W=0 Q
 ;
SS S:$A(X)=32 X=$E(X,2,999) Q
 ;
SX S X=X_" S X=X",W=1
 Q
