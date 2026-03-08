DICOMP0 ;SFISC/GFT-EVALUATE COMPUTED FLD EXPR ;10:03 AM  11 Sep 1996 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**24**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 I DPS,$D(DPS(DPS,"SET")),'$D(W(DPS)) S T="""",D=$P(X,T,1)_$P(X,T,2) G BAD:$L(D)+2\5-1!(D'?.UN)!(D?1"D".E)!(DUZ(0)'="@") S X=T_D_T,DICOMPX(D)=D,Y=0 Q
 I X?1"""".E1"""" S Y=0,%=$E(X,2,$L(X)-1) K:%[""" X "!(%[""" D @") Y Q
L S T=DLV,DICN=X G M:'$D(J(T))
TRY S DIC="^DD("_J(T)_",",DG=$O(^DD(J(T),0,"NM",0))_" ",DIC("S")=$S(W="["!($E(I,M,M+1)="'[")!$D(DICMX):"I 1",1:"S %=$P(^(0),U,2) I '%,%'[""m""")_$P(",Y-DA",U,DICO(1)=T&DA) D DICS^DICOMPY:DUZ(0)'="@"
R I X?1"#"1NP.NP S X=$E(X,2,99) D ^DIC G:Y>0 A:DLV,X S X="#"_X
 D ^DIC G A:Y>0
N I $P(X,DG,1)="",X=DICN S X=$P(X,DG,2,9) G R
 I X="NUMBER" S Y=.001,Y(0)=0 G D
 S T=T-1,X=DICN G M:T<0,TRY:$D(J(T)) F T=T-99:1 G TRY:'$D(J(T+1))
A F D=M:1:$L(I)+1 Q:$F(X,$E(I,1,D))-1-D  S W=$E(I,D+1)
 I DICOMP["?",DICN'="#.01",$P(Y,U,2)'=DICN,DG_$P(Y,U,2)'=DICN W !?3,"By '"_DICN_"', do you mean "_DG_"'"_$P(Y,U,2)_"'" S %=1 D YN^DICN G BAD:%<0,N:%-1
 S M=D
X I $D(DICOMPX)#2 S %Y=J(T)_U_+Y_$E(";",1,$L(DICOMPX)) S:";"_DICOMPX_";"'[(";"_%Y) DICOMPX=%Y_DICOMPX
D S D=$P(Y(0),"^",2),%=T\100*100,DICN=+Y D DATE:D["D"&'$D(DPS(DPS,"INTERNAL"))
 I D["m"!D G MUL^DICOMPZ
 I $D(DICOMPX(1,J(T),+Y)) S X=DICOMPX(1,J(T),+Y) G O
 I D["C" S:'$D(DG(%,T,+Y)) DG(%)=DG(%)+1,DG(%,T,+Y)=DG(%) S X=DQI_DG(%,T,+Y)_")" Q
 D G^DICOMPY
O Q:W=")"&$D(DPS(DPS,"INTERNAL"))  S T=J(T)
S ;
 S %=DLV0,DG=W=":"&'$D(DPS(DPS,$S)) I D["O",D'["P"!'DG,$D(^DD(T,DICN,2)) S DICF=X D ST^DICOMP S K=K+2,K(K-1)=X,K(K)=" S Y="_DICF_" X:$D(^DD("_T_","_DICN_",2)) ^(2) S X=Y" G DPS^DICOMPW
 I D["S" S DG(%)=DG(%)+1,DG(%,DG(%))="$C(59)_$S($D(^DD("_T_","_DICN_",0)):$P(^(0),U,3)",X="$P($P("_DQI_DG(%)_"),$C(59)_"_X_"_"":"",2),$C(59),1)"
 I D["V",'$D(DPS(DPS,"FILE")) S X=X_",C=$S(X="""":-1,'$D(@(U_$P(X,"";"",2)_""0)"")):-1,1:$P(^(0),U,2)),X=$S(X="""":X,'$D(^(+X,0)):"""",1:$P(^(0),U,1)),Y=X,C=$S($D(^DD(+C,.01,0)):$P(^(0),U,2),1:""D"") D:X]"""" Y^DIQ:C'[""D"" S X=Y,C="","""
 Q:D'["P"  S %Y=U_$P(Y(0),U,3),DICN=+$P(@(%Y_"0)"),U,2)
 I DG,$D(^DIC(DICN,0)) D DRW^DICOMPX S %1=Y,Y=DICN X:$D(^DIC(Y,0)) DIC("S") S Y=%1 K %1 G MR:'$T
 I 'DG S D=$S($D(^DD(DICN,.01,0)):$P(^(0),U,2),1:"") I D'["V",D'["S",D'["P" D DATE:D["D" S X="$S('$D("_%Y_"+"_X_",0)):"""",1:$P(^(0),U,1))" Q
P G P^DICOMPX
 ;
M S T=$F(X," IN ") I T S X=$E(X,1,T-5),W=":",M=T-4,I=X_W_$E(I,T,999),T=$F(I," FILE",M) S:T&$F(DPUNC,$E(I,T)) I=$E(I,1,T-6)_$E(I,T,999) G DICOMP0
 G MR:$L(X)>30 S DICF=X,T=$O(^DD("FUNC","B",X,0)) I T'="",$D(^DD("FUNC",T,3)),^(3)?1"0".E,$D(^(1)) D 2^DICOMP S Y(0)=0,K=K+1,K(K)=X D DATE:$S($D(^(2)):^(2)?1"D".E,1:0),DPS^DICOMPW Q
 S T=-1,%DT="T" D ^%DT I Y>0 S X=Y,Y(0)=0 G DATE
 S T=$O(^DIC("B",X)) S:T="" T=-1 I $D(DICOMPW)#2,$P(T,X)=""!$D(^(X)) S T=DLV0 D ^DICOMPV I D>0 G P:D=.01 Q
MR I M'>$L(I),+X'=X D MR^DICOMP G L
BAD K Y Q
 ;
DATE S DATE(K+1)=1
