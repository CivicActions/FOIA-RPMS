DICOMP ;SFISC/GFT-EVALUATE COMPUTED FLD EXPR ;3:22 PM  25 Jun 1996 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**15**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 S:$D(DICOMP)[0 DICOMP="" K K S K=0 F DLV=0:1 G A:'$D(J(DLV+1))
EN1 ;
 S K=0 F  S DLV=K,K=$O(I(K)) G K:K="",K:I'>0!'$D(J(K))!'$D(I(K\100*100))
EN ;
 S DLV=+DICOMP
K K K S K=0 I DLV F I=0:100 Q:I>DLV  S K=K+1,K(K)="",K(K,1)=I
A K DICO S I=DLV F  S I=$O(J(I)),DICO(1)=DLV Q:I=""  K:DLV I(I),J(I)
 S DPUNC=",'+-():[]!&\/*_=<>",DLV0=DLV\100*100,I=X,DIM=9.1,DIMW="" K X,DG,DIC,DATE,DPS,M,Y,W
 S DIC(0)="ZFO",Q="""",(M,DPS,DBOOL)=0,DICO=I,DICO(1)=DLV,DICO(0)=DLV\100*100 F %=0:100 Q:'$D(J(%))  S DG(%)=%
 G 0:" "[I!(+I=I)!(I'?.ANP)!(I?."?")!($E(I,$L(I))=":") I DPUNC[$E(I,1),$A(I)-40,$A(I)-39 G 0
G D I I X?.NP G:X="" N:I]"",^DICOMP1 I +X=X,X<1700!'$D(DATE(K-1))!'DBOOL G N:W'=":",N:$D(DPS(DPS,"$S"))
 G E:$L(X)>30,FUNC:W="(",N:X?1"$"1U
V I $D(DICOMPX(X))#2 D DATE^DICOMP0:$D(DICOMPX(X,"DATE")) S T=X,X=DICOMPX(X) G N:'$D(DICOMPX(T,U)) S T=DICOMPX(T,U),DICN=$P(T,U,2),T=+T,Y(0)=^DD(T,DICN,0),D=$P(Y(0),U,2) D S^DICOMP0 G N
E K Y D ^DICOMP0 G 0:+X'=X&'$D(Y)
N ;
 I X]"" S K=K+1,K(K)=X
 S I=$E(I,M,999),M=0 G G:$F(DPUNC,W)<2
 I W=":",'$D(DPS(DPS,"$S")) S I=$E(I,2,999) D I,M^DICOMPX,M^DICOMPW:$D(X) S W="" G N:$D(X),0
 S X=W,W="",M=2 G N:X=""
 G DPS:X=")",C:",:"[X,0:"+-'"[X&'$L($E(I,M,999)) I X="(" D ST G N
 S DBOOL="><]['=!&"[X,Y="[]!&/\_><*=" G N:Y'[X I $E(I,M,999)_W]"",$D(K(K)),")'"[K(K)!'$F(DPUNC,K(K)),$F(Y,W)<2 G N:K(K)'="'" S K(K)="'"_X,X="" G N:DBOOL
0 G 0^DICOMP1
 ;
I I $A(I,M+1)=34 S M=$F(I,Q,M+2)-1 G I:M>0 S W=0,M=999,X=U Q
MR F M=M+1:1 S W=$E(I,M) Q:DPUNC[W
 S X=$E(I,1,M-1) Q
 ;
C I DICO["SETDATA(" D SD^DICOMPZ G Q^DICOMP1:'$D(X)
 S DICF=X D DG S K(K+1,2)=0
 I $O(DPS(DPS,"$"))["$" S DPS(DPS)=DPS(DPS)_Y_DICF G N
 G 0:'$D(W(DPS)) S (W,W(DPS))=W(DPS)-1 K:W<2 W(DPS) S DPS(DPS)=" S X"_W_"="_Y_DPS(DPS) G N
 ;
DPS I DPS D DPS^DICOMPW G N:'$D(W(DPS+1))
 G 0
 ;
FUNC S Y=$O(^DD("FUNC","B",X,0)) S:Y="" Y=-1 I '$D(^DD("FUNC",Y,0)),X'?1N.N2A,X'?1"$"1U G V
 S DICF=X D ST I $D(^(1)) D 1 G B
 I DICF'?1"$"1U.U D ^DICOMPX S W="" G DPS:DPS,0
 S DPS(DPS,DICF)=DPS(DPS),DPS(DPS)=" S X="_DICF_W
B S M=M+1,W="" G 0:$E(I,M)=")",N
 ;
2 ;
 D ST
1 G ARG^DICOMPZ
 ;
ST ;
 S DPS=DPS+1,%="",Y=K
S I 'Y S X="",DPS(DPS)=$P(" S X="_%_"X",U,%]"") Q
 I K(Y)="" S Y=Y-1 G S
 I "'"[K(Y)!(K(Y)="+"),$S(Y=1:1,1:K(Y-1)?1P!(K(Y-1)="")) S %=K(Y)_%,K=K-1,Y=Y-1 G S
 D DG S DPS(DPS)="" I K(K)?1P!(K(K)?2P) S DPS(DPS)=" S Y="_%_"X,X="_Y_",X=X",DPS(DPS,U)=K(K)_"Y",K=K-1
 S:$D(DATE(K)) DPS(DPS,"DATE")=1 S:DBOOL DBOOL=0,DPS(DPS,"BOOL")=1
 S K(K+1,2)=0 Q
 ;
DG S (Y,DG(DLV0))=$G(DG(DLV0))+1,Y=DQI_Y_")",X=" S "_Y_"=X"
