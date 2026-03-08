DIVR ;SFISC/GFT-VERIFY FLDS ;11:00 AM  19 Mar 1996 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**8**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 S W="W !,""ENTRY#"_$S(V:"'S",1:"")_""",?10,"""_$P(^DD(A,.01,0),U)_""",?40,""ERROR"""
 W ! S T=$E(T) S:"PS"[T&($D(DIVZ)[0) DIVZ=Z G E:'$D(^(+$O(^DD(A,DA,1,0)),1)) K DG
 F %=0:0 S %=$O(^DD(A,DA,1,%)) Q:%'>0  I $D(^(%,1)),$P(^(0),U,2,9)?1.A,^(2)?1"K ^".E1")",^(1)?1"S ^".E S DG(%)="I $D("_$E(^(2),3,99)_"),"_$E(^(1),3,99)
 I $D(DG) W "(CHECKING" S E=T,T="IX"
 E  W $C(7),"(CANNOT CHECK"
 W " CROSS-REFERENCE)",!
E S Y=$F(DDC,"%DT=""E") S:Y DDC=$E(DDC,1,Y-2)_$E(DDC,Y,999)
 I DR["*" S DDC="Q" I $D(^DD(A,DA,12.1)) X ^(12.1) I $D(DIC("S")) S DDC(1)=DIC("S"),DDC="X DDC(1) E  K X"
 D 0 S X=$P(Y(0),U,4),Y=$P(X,S,2),X=$P(X,S)
 I +X'=X S X=Q_X_Q I Y="" S DE=DE_"S X=DA D R" G XEC
 S M="S X=$S($D(^(DA,"_X_")):$"_$S(Y:"P(^("_X_"),U,"_Y,1:"E(^("_X_"),"_$E(Y,2,9))_"),1:"""") D R"
 I $L(M)+$L(DE)>250 S DE=DE_"X DE(1)",DE(1)=M
 E  S DE=DE_M
XEC K DIC,M,Y X DE Q:$D(DQI)
 W:'$D(M) $C(7),!,"NO PROBLEMS"
Q S M=$O(^UTILITY("DIVR",$J,0)),E=$O(^(M)),DK=J(0)
 G:'E QX K DIBT,DISV D
 . N C,D,I,J,L,O,Q,S,D0,DDA,DICL,DIFLD,DIU0
 . D S2^DIBT1 Q
 S DDC=0 I '$D(DIRUT) G Q:Y<0 F E=0:0 S E=$O(^UTILITY("DIVR",$J,E)) Q:E=""  S DDC=DDC+1,^DIBT(+Y,1,E)=""
 S:DDC>0 ^DIBT(+Y,"QR")=DT_U_DDC
QX K ^UTILITY("DIVR",$J),DIRUT,DIROUT,DTOUT,DUOUT,DQI,DK,DA,DG,DQ,DE,T,P,E,M,DR,W,DDC,DIVZ Q
 ;
R I X?." " Q:DR'["R"  S M="Missing" G X
 G @T
 ;
P I @("$D(^"_DIVZ_"X,0))") S Y=X G F
 S M="No '"_X_"' in pointed-to File" G X
 ;
S S Y=X X DDC I '$D(X) S M=Q_Y_Q_" fails screen" G X
 Q:S_DIVZ[(S_X_":")  S M=Q_X_Q_" not in Set" G X
 ;
D S Y=X,X=$E(Y,1,3)+1700,%=$E(Y,6,7) S:% X=%_"-"_X S:$E(Y,4,5) X=+$E(Y,4,5)_"-"_X
 S:Y["." X=X_"@"_$E(Y_"00",9,10)_":"_$E(Y_"0000",11,12)_$S($E(Y,13,14):":"_$E(Y_"0",13,14),1:"")
N ;
K ;
F S DQ=X I X'?.ANP S M="Non-printing character" G X
 X DDC Q:$D(X)  S M=Q_DQ_Q_" fails Input Transform"
X I $O(^UTILITY("DIVR",$J,0))="" X W
 S X=$S(V:DA(V),1:DA),^UTILITY("DIVR",$J,X)=""
 S X=V I @(I(0)_"0)")
DA I 'X W !,DA,?10,$S($D(^(DA,0)):$P(^(0),U),1:DA),?40,$E(M,1,40) W:V ! Q
 W !,DA(X),?10,$P(^(DA(X),0),U) S X=X-1,@("Y=$D(^("_I(V-X)_",0))") G DA
 ;
0 ;
 S Y=I(0),DE="",X=V
L S DA="DA" S:X DA=DA_"("_X_")" S Y=Y_DA,DE=DE_"F "_DA_"=0:0 ",%="S "_DA_"=$O("_Y_"))" I V>2 S DE(X+X)=%,DE=DE_"X DE("_(X+X)_")"
 E  S DE=DE_%
 S DE=DE_" Q:"_DA_"'>0  S D"_(V-X)_"="_DA_" "
 I X=1,DIFLD=.01 S DE=DE_"X P:$D(^(DA(1),"_I(V)_",0)) ",P="S $P(^(0),U,2)="""_$P(^DD(J(V-1),P,0),U,2)_Q
 S X=X-1 Q:X<0  S Y=Y_","_I(V-X)_"," G L
 ;
IX F %=0:0 S %=$O(DG(%)) Q:+%'>0  X DG(%) I '$T S M=Q_X_Q_" not properly Cross-referenced" G X
 G @E
 ;
V I $P(X,S,2)'?1A.AN1"(".ANP,$P(X,S,2)'?1"%".AN1"(".ANP S M=Q_X_Q_" has the wrong format" G X
 S M=$S($D(@(U_$P(X,S,2)_"0)")):^(0),1:"")
 I '$D(^DD(A,DIFLD,"V","B",+$P(M,U,2))) S M=$P(M,U)_" FILE not in the DD" G X
 I '$D(@(U_$P(X,S,2)_+X_",0)")) S M=U_$P(X,S,2)_+X_",0) does not exist" G X
 G F
