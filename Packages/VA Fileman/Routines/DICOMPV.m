DICOMPV ;SFISC/GFT,XAK-EVALUATE COMPUTED FLD EXPR ;8/15/95  13:50 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**13**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 D DRW^DICOMPX S T=DLV0,DD=0
DD S DD=$O(^DD(J(T),0,"PT",DD)) I DD'>0 S T=T-100,DD=0 G DD:T'<0 Q
 F Y=DD:0 G DD:'$D(^DD(Y,0)) Q:'$D(^(0,"UP"))  S Y=^("UP")
 I $D(^DIC(Y,0)),$P(^(0),X)="" X DIC("S") I $T,$D(^DIC(Y,0,"GL")) S V=^("GL"),D=0 F  S D=$O(^DD(J(T),0,"PT",DD,D)) S:D="" D=-1 Q:D'>0  D F G Y^DICOMPX:Y[U,Q:'$D(T)
 G DD
 ;
F I D=.01,DD=Y,$D(^DD(Y,.01,0)),$P(^(0),U,5,99)["DINUM=X" D YN I %=1 S %Y=V,X="D0" K T S:$D(DIFG) DIFG=1 G DICOMPX
 Q:'$D(DICMX)  S %=0 F  S %=$O(^DD(DD,D,1,%)) S:%="" %=-1 Q:%'>0  I $D(^(%,0)) S J=^(0) I +J=Y,$P(J,U,3,9)="" D YN G Q:%-1 S X=V D QQ^DICOMPX:X[Q G MP
 I DICOMP["?",$D(^DD(DD,D,0)) W $C(7),!,"THE '"_$P(^(0),U,1)_"' POINTER FROM FILE #"_DD,!?9,"IS NOT CROSS-REFERENCED",!
Q Q
 ;
YN S %=1 Q:DICOMP'["?"  W !?3,"By '"_DICN_"', do you mean the "_$P(^DIC(Y,0),U,1)_" File,"
 W !?7,"pointing via its '"_$P(^DD(DD,D,0),U,1),"' Field" S DICV=$P(^(0),U,2)
 D YN^DICN I %=1,DICOMP["W",$P($G(^DD(DD,0,"DI")),U,2)["Y" W !,$C(7),"SORRY, CAN'T EDIT A RESTRICTED"_$S($P($G(^("DI")),U)["Y":" (ARCHIVE)",1:"")_" FILE!" S %=2
 Q
 ;
MP S DICN=$S(DA:DQI_(80+T),1:"I("_T_",0")_")",J=Q_$P(J,U,2)_Q,T=D S:$D(DIFG) DIFG=$P(J,Q,2)
 I DICOMP'["W" S D=Y,X=$P(^DD(D,.01,0),U,2) D X^DICOMPZ S D="S D=0 F  S (D,D0)=$O("_V_J_","_DICN_",D)) S:D="""" (D,D0)=-1 Q:D'>0  I $D("_V_"D,0)) "_X_" "_DICMX_" Q:'$D(D)  S D=D0" D DIM^DICOMPZ S X=X_" S X=""""" G POP
 D ASKE^DICOMPW I 'D,T-.01&'DS!(DD-Y) S D=0
 E  S DZ=0 D ASK^DICOMPW:'D I D<0 K T Q
 S %=D,D="S DIC="_Y_$S(%=2:",DIADD=1",1:"")_",DIC(0)="""_$P("EQ",U,DS)_$E("L",D>0)_$E("W",$D(DICO(3)))
 I T-.01 S D=D_$P("AM",U,DS)_""",DIC(""S"")=""I $D("_X_Q_J_Q_","_DICN_",Y))"" D ^DIC K DIADD S D0=+Y,DIC("_T_")="_DICN_",DIH="_Y_" D DICL^DICR:$P(Y,U,3) K DIC"
 E  S D=D_"U"",X="_DICN_" D ^DIC K DIC,DIADD S D0=+Y"
 D DIM^DICOMPZ I '% S %=":$O(^(D0))>0",X=" S D0=$O("_V_J_","_DICN_",0))"_$S(DS:X_%,1:" S"_%_" D0=0")
 S X=X_" S X=$S(D0>0:D0,1:"""")" S:$D(DICOMPX(0)) X=X_","_DICOMPX(0)_"0)=X"
POP S Y=Y_U,D=1
DICOMPX ;
 S DICN=+Y I $D(DICOMPX)#2 S DICOMPX=+Y_U_.01_$E(";",1,$L(DICOMPX))_DICOMPX
 Q
