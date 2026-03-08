DICATT4 ;SFISC/XAK-DELETE A FIELD ;5/7/93  1:42 PM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
DIEZ S DI=A,DA=D0 D DIPZ^DIU0
 K ^DD(A,0,"ID",D0),^DD(A,0,"SP",D0)
EN I $O(@(I(0)_"0)"))'>0 G N
 S %=1,Y=$P(O,U,4),X=$P(Y,S,1),Y=$P(Y,S,2),O=$S(+X=X:X,1:Q_X_Q)_")",E="^("_O
 I $O(^DD(A,"GL",X,""))="" S T="K ^(M,"_O G F
 I Y S T="U_$P("_E_",U,"_(Y+1)_",999) K:"_E_"?.""^"" "_E S:Y>1 T="$P("_E_",U,1,"_(Y-1)_")_U_"_T
 E  S X=+$E(Y,2,4),Y=+$P(Y,",",2) G N:'X!'Y S T="$E("_E_",1,"_(X-1)_")_$J("""","_(Y-X+1)_")_$E("_E_","_(Y+1)_",999)"
 S T="I $D(^(M,"_O_")#2 S "_E_"="_T
F I '$D(DIU(0)) W $C(7),!,"OK TO DELETE '",$P(M,U),"' FIELDS IN THE EXISTING ENTRIES" D YN^DICN G N:%-1
 S M="",X=DICL,Y=I(0) I $D(DQI) K @(I(0)_Q_DQI_""")")
L S O="M" S:X O=O_"("_X_")" S Y=Y_O,M=M_"F "_O_"=0:0 S "_O_"=$O("_Y_")) Q:"_O_"'>0  "
 S X=X-1 I X+1 S Y=Y_","_I(DICL-X)_"," G L
 X M_"X T"_$P(" W "".""",U,$S('$D(DIU(0)):1,DIU(0)["E":1,1:0))
N Q:$D(DIU)  G N^DICATT
NEW D KDD G DICATT4
 ;
VP ; VARIABLE POINTER
 S DA(2)=DA(1),DA(1)=DA,DICATT=DA I $D(DICS) S DICSS=DICS K DICS
V S DA(2)=A,DA(1)=DICATT,DIC="^DD("_A_","_DICATT_",""V"",",DIC("P")=".12P",DIC(0)="QEAMLI",DIC("W")="W:$S($D(^DIC(+^(0),0)):$P(^(0),U)'=$P(^DD(DA(2),DA(1),""V"",+Y,0),U,2),1:0) ?30,$P(^(0),U,2)" D ^DIC S DIE=DIC K DIC
 I Y>0 S DA=+Y,Z="P",DR=".01:.04;"_$S($P($G(^DD(+$P(Y,U,2),0,"DI")),U,2)["Y":".06///n",1:".06T")_";S:DUZ(0)'=""@"" Y=0;.05;I ""n""[X K ^DD(DA(2),DA(1),""V"",DA,1),^(2) S Y=0;1;2;" S:$P(Y,U,3) DIE("NO^")=""
 I Y>0 D ^DIE K DIE W ! S:$D(DTOUT) DA=DICATT G CHECK^DICATT:$D(DTOUT),V
 S Z="V^",DIZ=Z,C="Q",L=18,DA=DICATT,DA(1)=A S:$D(DICSS) DICS=DICSS K DICSS,DR,DIE,DA(2),DICATT G CHECK^DICATT:$D(DTOUT)!(X=U),^DICATT1
 Q
HELP ;
 W !?5,"Enter a MUMPS statement which begins with 'S DIC(""S"")=' and contains",!?5,"code which sets $T.  Those entries for which $T=1 will be selectable."
 I Z?1"P".E W !?5,"The naked reference will be at the zeroeth node of the pointed to",!?5,"file, e.g., ^DIZ(9999,Entry Number,0).  The number of the entry that",!?5,"is being processed in the pointed to file will be in the variable Y." Q
 W !?5,"The variable Y will be equal to the internally-stored code of the item",!?5,"in the set which is being processed."
 Q
KDD ;
 S DQ=$O(DQ(0)),X=0 S:DQ="" DQ=-1 Q:DQ<1  S Y=0 F  S X=$O(^DD(DQ,"SB",X)) S:X="" X=-1 S DQ(X)=0 D KIX Q:X<0
 S Y=0 F %=0:0 S Y=$O(^DD(DQ,Y)) Q:'Y  I $D(^(Y,9.01)) S X=^(9.01) D KACOMP
 K DQ(DQ),^DD(DQ),^DD("ACOMP",DQ),^DD(A,"TRB",DQ)
 S Y=0 F  S Y=$O(^DIE("AF",DQ,Y)) Q:Y=""  S %=0 F  S %=$O(^DIE("AF",DQ,Y,0)) Q:%=""  K ^(%),^DIE(%,"ROU")
 S Y=0 F  S Y=$O(^DIPT("AF",DQ,Y)) G KDD:Y="" S %=0 F  S %=$O(^DIPT("AF",DQ,Y,0)) Q:%=""  K ^(%),^DIPT(%,"ROU")
 ;
KIX S Y=$O(^DD(A,0,"IX",Y)) S:Y="" Y=-1 Q:Y<0  K:$D(^(Y,DQ)) ^(DQ) G KIX
 Q
KACOMP N DA,I,% S DA(1)=DQ,DA=Y X ^DD(0,9.01,1,1,2) Q
