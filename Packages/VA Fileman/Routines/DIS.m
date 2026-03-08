DIS ;SFISC/GFT-GATHER SEARCH CRITERIA ;9/30/94  15:57 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 K ^UTILITY($J),DC,DIS,%ZIS,O,N,R D ^DICRW
 G Q:'$D(DIC)!$D(DTOUT)
EN ;
 S:DIC DIC=$S($D(^DIC(DIC,0,"GL")):^("GL"),1:"") Q:DIC=""
 K DI,DX,DY,I,J,DL,DC,DA,DTOUT,^UTILITY($J) G Q:'$D(@(DIC_"0)"))
 S (R,DI,I(0))=DIC,(DL,DC)=1,DY=999,N=0,Q="""",DV="" D DL
R ;
 I +R=R S (J(N),DK)=R,R=""
 E  S @("(J(N),DK)=+$P("_R_"0),U,2)"),R=$P(^(0),U)
F ;
 W ! K X,DIC,P D W S DIC(0)="EZ",C=",",DIC="^DD("_DK_C,DIC("W")="S %=$P(^(0),U,2) W:% $S($P(^DD(+%,.01,0),U,2)[""W"":""   (word-processing)"",1:""   (multiple)"")",DIC("S")="I $P(^(0),U,2)'[""m"""_$S($D(DICS):" "_DICS,1:""),DU=""
 W "SEARCH FOR "_R_" "_$P(^DD(DK,0),U,1)_": "
 R X:DTIME S:'$T DTOUT=1 G Q:X=U!'$T,TEM^DIS2:X?1"[".E D  I Y>0 K P S DE=Y(0),O(DC)=$P(DE,U,1),DU=+Y,Z=$P(DE,U,3),E=$P(DE,U,2) G G
 .N DISVX S DISVX=X D ^DIC S:Y=-1 X=DISVX Q
HARD G UP:X="",F:X?."?",Q:X=U!($D(DTOUT)),COMP^DIS2
DL ;S DL=$S('$D(DIARF0):DL,1:DIARF1+DL)
 Q
G ;
 K X,DIC S DIC="^DOPT(""DIS"",",DIC(0)="QEZ" I E["B" S X="" G OK
 I E S N(DL)=N,N=N+1,DV(DL)=DV,DL(DL)=DK,DK=+E,J(N)=DK,X=$P($P(DE,U,4),";",1),I(N)=$S(+X=X:X,1:Q_X_Q),Y(0)=^DD(DK,.01,0),DL=DL+1 G WP:$P(Y(0),U,2)["W" S DV=DV_+Y_C G F
 I E["P" S P=+Y_U_Y(0),X="#"_+Y_":.01" G HARD
C D W R "CONDITION: ",X:DTIME S:'$T DTOUT=1 G Q:X[U!'$T
 S DN=$S("'-"[$E(X):"'",1:""),X=$E(X,DN]""+1,99) D ^DIC
 G:Y<0 Q:X[U,B:X="",DISC^DIQQQ:X["?",C
 S O=$P("NOT ",U,DN]"")_$P(Y,U,2)
 I +Y=1 S X=DN_"?."" """,O(DC)=O(DC)_" "_O G OK
 S DQ=Y D W W O I E["D",Y-3 R " DATE: ",X:DTIME S:'$T DTOUT=1 G Q:X=U!'$T S %DT="TE" D ^%DT S X=Y_U_X G X:Y<0 X ^DD("DD") S Y=X_U_Y G GOT
 ;POINTERS
PT I $D(P),+DQ=5 K DIC,DIS($C(DC+64)_DL) S DIC=U_$P(P,U,4),DIC(0)="EMQ",DU=+P W " "_$P(@(DIC_"0)"),U,1)_": " R X:DTIME S:'$T DTOUT=1 G Q:U[X!'$T D ^DIC G GOT:Y>0,PT
 R ": ",Y:DTIME I '$T S DTOUT=1 G Q
 G X:Y="" I Y[U,$P(DE,U,4)'[";E" G X
 I +DQ=3 S X="I X?"_Y D ^DIM G GOT:$D(X) S Y="?"
 G DIS^DIQQQ:Y?."?",T:E'["S",N:+DQ'=5 S Y=":"_Y
 ;SET OF CODES
 F X=1:1 S D=$P(Z,";",X) Q:D=""  I D[Y W $P(D,Y,2) S Y=$P(D,":")_U_$P(D,":",2) G T
 S %="",Y="""" W $C(7),!,"[ Enter EXTERNAL VALUE for one of the following: ",!
 G O
N S %="[ WILL APPLY TO:" W $C(7),!?7
O F X=1:1 S D=$P(Z,";",X),DE=$P(D,":",2) Q:D=""  W % W:X>1 "," W " " S %="'"_$P(D,":")_"' ("_DE_")",DIS(U,DC,$P(D,":",1))=DE W:$X+$L(%)>73 !?7
 W:X>2 "AND " W %_" ]"
 I +DQ=5,$P(Y,U)[Q K DIS(U,DC)
T I DQ["THAN",+$P(Y,U)'=$P(Y,U) G X
 I DQ#3=2 G X:$P(Y,U)[Q I +$P(Y,U)'=$P(Y,U) S $P(Y,U)=Q_$P(Y,U)_Q
GOT S X=DN_$E(" [?<=>",DQ)_$P(Y,U) I E["D" S Y=$P(Y,U,3)_U_$P(Y,U,2)
 S O(DC)=O(DC)_" "_O_" "_Y
OK S DC(DC)=DV_DU_U_X_U_$P(Y,U,2),%=DL-1_U_(N#100)
 I DL>1,O(DC)'[R S O(DC)=R_" "_O(DC)
 S:DU["W" %=DL-2_U_(N#100-1) S DX(DC)=%,DC=DC+1
B G F:DU'["W"
UP I DC>1 G ^DIS0:DL<$S('$D(DIARF0):2,1:2) S DL=DL-1,DV=DV(DL),DK=DL(DL),N=N(DL),R=$S($D(R(DL)):R(DL),1:R) K R(DL) S %=N F  S %=$O(I(%)) S:%="" %=-1 G F:%<0 K I(%),J(%)
Q G Q^DIS2:'$D(DIARU),^DIS2
 ;
WP S DIC("S")="I Y<3",DU=+Y_"W" G C
 ;
X ;
 W $C(7),"??",!! G B
 ;
W W !?DL*2,"-"_$C(DC+64)_"- " Q
ENS ; ENTRY POINT FOR RE-DOING THE SORT USING AN EXISTING SORT TEMPLATE
 G EN^DIS3
