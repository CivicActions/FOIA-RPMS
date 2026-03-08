DIL ;SFISC/XAK-TURN PRINT FLDS INTO CODE ;11/4/92  10:27 AM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F DD=1:1 S W=$P(R,$C(126),DD) G Q:W="" S:DIWL DIWL=9 D DM I DIO S DN=-8,W=DIO,DIO=0 I W>1 S DIO=DM+2-W,W=$P(F,C,1,DIO)_$E(C,DIO>0)_"D 0^DIWW;X" D DM S DIWR(DIO)=DX,DIO=0
 ;
DM I DM G UP:$P(W,F,1)]"" S W=$P(W,F,2,999)
 I W[";Y" S DE="" D W:DG S I=+$P(W,";Y",2),DG=0,Y=DE_" F Y=0:0 Q:$Y>"_$S(I>0:I-2,1:"(IOSL"_(I-2)_")")_"  W !" S:I>0 M(DP)=I D PX S O=999
 G ^DIL1:'W,^DIL11:W?.NP1",".E,^DIL1:$P(W,";",1)'=+W K DPQ(DP,+W)
 D DE,^DIL0 G T:DU=DN I $P(X,U,2)["C" S DN=-2 G PX
 S DN=DU,Y=" S X=$G("_DI_C_DN_"))"_Y
PX ;
 I DHT G PX^DIPZ1:DHT<0 S ^UTILITY($J,DV)=$E(Y,2,999),Y="",DV=DV+1 Q
 S DX=DX+1 G PX:$D(^UTILITY($J,99,DX)) S ^(DX)=$E(Y,2,999)
 I DM S M=DX D DX
 S O=0
Q Q
 ;
DE S DE="" I W[";S" D W:DG S I=+$P(W,";S",2),DG=0 S:'I I=1 S M(DP)=M(DP)+I,DE=DE_" D T Q:'DN " F I=I:-1:1 S DE=DE_" D N"
 I $P(W,";C",2) S DIC=$P(W,";C",2) S:DIC<0 DIC=IOM+DIC+1 D W:DIC<DG S DG=DIC-1 I 1
 I DN=-4!$T S DE=DE_" D N:$X>"_DG_" Q:'DN "
 S DE=DE_" W ?"_DG Q
W ;
 D DIWR^DIL0:$D(DIWR)
A ;
 S M(DP)=M(DP)+1 I DHD,$D(V)>9 S I=$O(V(0)) S:I="" I=-1 F I=I:1:99 S Z="W !" D B
 K ^UTILITY("DIL",$J),V Q
B F V=-1:0 S V=$O(^UTILITY("DIL",$J,V)) Q:V=""  I $D(^(V,I)) S %=^($O(^(0))-I+99) D C,U:$L(Z)+$L(%)>245 S Z=Z_",?"_V_","""_%_""""
U S ^UTILITY($J,DHD)=Z,DHD=DHD+1,Z="W """"" Q
C I %?1" ".E S V=V+1,%=$E(%,2,999) G C
 Q
 ;
D ;
 D PX:DHT<1 S F(DM)=DX,R(DX)=DP(DM),R(DX,1)=M(DP(DM)),F=F_W_C,DM=DM+1,DIL=DIL+1,DD=DD-1 I DHT+1 S DX=$S('DHT:900,1:DX) D:DHT PX Q
 G DE^DIPZ1
 ;
UP D UN G DM
 ;
UNSTACK ;
 D UN Q:'DM  G UNSTACK
 ;
UN ;
 D DIWR^DIL0:$D(DIWR(DM))
 D:DHT<0 UP^DIPZ1 S O=999,DN=-8,DM=DM-1,DIL=DIL-1,DP=DP(DM),DX=$S(DM:F(DM),1:0),F=$P(F,C,1,DM)_$E(C,DM>0),DY=DY(DM),DI=DI(DM)
 I $D(DIL(DM)) S Y=" K J("_DIL0_"),I("_DIL0_")",DIL=DIL(DM),DIL0=DIL(DM,0) K DIL(DM) F X=DIL0:1 S %=X#100,V="I("_X_C_"0)",Y=Y_" S:$D("_V_") D"_%_"="_V I X=DIL G PX
 Q
 ;
O ;
 D DE,DN^DIL0
T ;
 G PX:'$D(^UTILITY($J,99,DX))!DIO,PX:$L(^(DX))+$L(Y)+O>240 S ^(DX)=^(DX)_Y Q
 ;
DX ;
 S Y=F(DM-1) D IF S ^(Y)=^UTILITY($J,99,Y)_$S($T:",^UTILITY($J,99,",1:" X ^UTILITY($J,99,")_M_")"
 I $T,$L(^UTILITY($J,99,Y))>99 F O=500:1 I '$D(^(O)) S ^(Y)=$E(^(Y),1,$L(^(Y))-1-$L(M))_O_")",F(DM-1)=O,^(O)="X ^UTILITY($J,99,"_M_")" Q
 Q
IF I ^UTILITY($J,99,Y)?.E1"^UTILITY($J,99,".N1")"
 Q
