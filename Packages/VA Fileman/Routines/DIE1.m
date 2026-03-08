DIE1 ;SFISC/GFT-FILE DATA, XREF IT, GO UP AND DOWN MULTIPLES ;7/30/96  15:33 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**29**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 K DQ,DB G E1:$D(DG)<9 I DP<0 K DG S DQ=0 Q
 S DQ="",DU=-2,DG="$D("_DIE_DA_",DU))"
Y S DQ=$O(DG(DQ)),DW=$P(DQ,";",2) G DE:$P(DQ,";",1)=DU
 I DU'<0 S ^(DU)=DV,DU=-2
 G IX:DQ="" S DU=$P(DQ,";",1),DV="" I @DG S DV=^(DU)
DE I 'DW S DW=$E(DW,2,99),DE=DW-$L(DV)-1,%=$P(DW,",",2)+1,X=$E(DV,%,999),DV=$E(DV,0,DW-1)_$J("",$S(DE>0:DE,1:0))_DG(DQ) S:X'?." " DV=DV_$J("",%-DW-$L(DG(DQ)))_X G Y
PC S $P(DV,"^",DW)=DG(DQ) G Y
 ;
IX S DQ=$O(DE(" ")) G E1:DQ="",E1:'$D(DG(DQ)) I $D(DE(DE(DQ)))#2 F DG=1:1 Q:'$D(DE(DQ,DG))  S DIC=DIE,X=DE(DE(DQ)) X DE(DQ,DG,2)
 S X="" I DG(DQ)]"" F DG=1:1 Q:'$D(DE(DQ,DG))  S DIC=DIE,X=DG(DQ) X DE(DQ,DG,1)
E1 K DIFLD,DG,DB,DE,DIANUM S DQ=0 Q
 ;
B ;
 I '$D(DB(DQ)) S X="?BAD" G ^DIEQ
 S DC=DQ,DIK="",DL=1
OUT ;
 D DIE1 S Y(DC)=DIK G UP:DL>1,Q:DC=0,QY
 ;
E ;
 I DP'<0 S DC=$S($D(X)#2:X,1:"") D DIE1 S X=DC G G:DI>0,UP:DL>1
Q K Y
QY I $D(DTOUT),$D(DIEDA) D
 . N % K DA
 . F %=1:1 Q:'$D(DIEDA(%))  S DA(%)=DIEDA(%)
 . S DA=DIEDA
 . Q
 K:$D(DTOUT) DG,DQ
 K DIP,DB,DE,DM,DK,DL,DH,DU,DV,DW,DP,DC,DIK,DOV,DIEL,DIFLD Q
 ;
M ;
 S DD=X,DIC(0)="LM"_$S($D(DB(DQ)):"X",1:"QE"),DO(2)=$P(DC,"^",2),DO=$E($P(DQ(DQ),"^",1),8,99)_"^"_DO(2)_"^"_$P(DC,"^",4,5) D DOWN I @("'$D("_DIC_"0))") S ^(0)="^"_DO(2)
 E  I DO(2)["I" S %=0,DIC("W")="" D W^DIC1
 K DICR S D="B",DLAYGO=DP\1,X=DD D X^DIC
 I Y>0 S DA=+Y,DI=0,X=$P(Y,U,2) S:+DR=.01!(DR="")&$P(Y,U,3) DI=.01,DK=1,DM=$P($P(DR,";",1),":",2),DM=$S(DR="":9999999,DM="":+DR,1:DM) G D1
 S DI(DL-1)=DI(DL-1)_U K DUOUT,DTOUT G U1
 ;
DOWN D S,DIE1,DDA S DIE=DIC Q
 ;
S S DIOV(DL)=$S('$D(DOV):0,1:DOV) K DOV
 S DP(DL)=DP,DP=+$P(DC,"^",2),DI(DL)=$S(DV'["M":DI,$D(DSC(DP))!$D(DB(DQ)):DI,1:DI_U),DIE(DL)=DIE,DK(DL)=DK,DR(DL)=DR,DM(DL)=DM,DK=0,DL=DL+1,DIEL=DIEL+1,DM=9999999,DR="" I $D(DR(DL,DP)) S DM=0,DR=DR(DL,DP)
 Q
 ;
DDA F X=DL+1:-1:1 I $D(DA(X)) S DA(X+1)=DA(X)
 S DA(1)=DA,DIC=DIE_DA_","""_$P(DC,U,3)_"""," Q
 ;
UDA S DA=DA(1) F X=2:1 Q:'$D(DA(X))  S DA(X-1)=DA(X) K DA(X)
 K DA(DL)
 Q
N ;
 D DOWN S DA=$P(DC,U,4),DI=.01 S ^DISV(DUZ,$E(DIC,1,28))=$E(DIC,29,999)_DA
D1 S @("D"_DIEL)=DA
G G MORE^DIE
 ;
UP ;
 Q:$D(DTOUT)  S DP(0)=DP I $D(DIEC(DL)) D DIEC G U
U1 D UDA S DIEL=DIEL-1
U S DQ=0,DL=DL-1,DIE=DIE(DL),DM=DM(DL),DI=DI(DL),DP=DP(DL),DR=DR(DL),DK=DK(DL) I $D(DIOV(DL)) S DOV=DIOV(DL) K DIOV(DL)
 G G
 ;
DIEC K DA S DA=DIEC(DL) F %=1:1 Q:'$D(DIEC(DL,%))  S DA(%)=DIEC(DL,%)
 F DIEL=0:1 Q:'$D(DIEC(DL,0,DIEL))  S @("D"_DIEL)=DIEC(DL,0,DIEL)
 S DIEL=DIEL-1 K DIEC(DL)
