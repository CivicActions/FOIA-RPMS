DIE17 ;SFISC/GFT-COMPILED TMPLT UTIL ;7/30/96  15:33 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**19,29**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 I $D(DTOUT) S X="" G OUT
 G:$A(X)-94 X:'$P(DW,";E",2),@("T^"_DNM)
 I $D(DIE("NO^")),X=U,DIE("NO^")'["OUTOK" W !?3,"EXIT NOT ALLOWED " S D="" G X
 I $D(DIE("NO^")),X?1"^"1.E,DIE("NO^")'["BACK" W !?3,"JUMPING NOT ALLOWED " S D="" G X
 I $L(X,"^")-1>1 S X=$E(X,2,99) G DIE17
 S X=$P(X,U,2),DIC(0)="E" G OUT
Z ;
 S DL=1,X=0
OUT ;
 I 0[X S DM=DW D FILE G ABORT:DL=1,R
 S DIC="^DD("_DP_"," G OJ:'$D(^DIE(DIEZ,"AB")) S DIEZAB=$S(DL=1:U,1:DNM(DL,0)_U_DNM(DL)) I X?1"@".N,$D(^("AB",DIEZAB,X)) S DNM=^(X) G JMP
 S DDBK=0 I $D(DIE("NO^")),DIE("NO^")["BACK" D DR S DDBK=1,DIC("S")="I $D(^DIE(DIEZ,""AB"",DIEZAB,Y)) D S^DIE0"
 E  S DIC("S")="I $D(^DIE(DIEZ,""AB"",DIEZAB,Y)),DIC(0)[""F""!'$D(^(Y,""///""))"
 S DIC="^DD("_DP_"," D ^DIC S DIC=DIE I Y<0 S D="" W:DDBK !?3,"JUMPING FORWARD NOT ALLOWED "
 I DDBK K DR S DR(1,DP)=^DIE(DIEZ,"ROU"),DR=DI
 K A0,A1,DDBK,DIC,DTOUT G X:Y<0 S DNM=^DIE(DIEZ,"AB",DIEZAB,+Y)
JMP K DIEZAB D FILE S Y=DNM,DNM=$P(Y,U,2),DQ=+Y,D=0 D @("DE^"_DNM) G @Y
 ;
OJ I X?1"@".N,$D(^DIE("AF",X,DIEZ)) S DNM=^(DIEZ)
 E  S DIC("S")="I $D(^DIE(""AF"","_DP_",Y,DIEZ)),DIC(0)[""F""!'$D(^(DIEZ,""///""))" D ^DIC K DIC S DIC=DIE G X:Y<0 S DNM=^DIE("AF",DP,+Y,DIEZ)
 G JMP
F ;
 S DC=$S($D(X)#2:X,1:0) D FILE S X=DC Q
FILE ;
 K DQ Q:$D(DG)<9  S DQ="",DU=-2,DG="$D("_DIE_DA_",DU))"
Y S DQ=$O(DG(DQ)),DW=$P(DQ,";",2) G DE:$P(DQ,";",1)=DU
 I DU'<0 S ^(DU)=DV,DU=-2
 G E1:DQ="" S DU=$P(DQ,";",1),DV="" I @DG S DV=^(DU)
DE I 'DW S DW=$E(DW,2,99),DE=DW-$L(DV)-1,%=$P(DW,",",2)+1,X=$E(DV,%,999),DV=$E(DV,0,DW-1)_$J("",$S(DE>0:DE,1:0))_DG(DQ) S:X'?." " DV=DV_$J("",%-DW-$L(DG(DQ)))_X G Y
PC S $P(DV,U,DW)=DG(DQ) G Y
 ;
IX D @DE(DQ)
K K DE(DQ)
E1 S DQ=$O(DE(" ")) I DQ'="" G IX:$D(DG(DQ)),K
 K DG,DE,DIFLD S DQ=0 Q
1 ;
 D FILE
R D UP G @("R"_DQ_U_DNM)
 ;
UP S DNM=DNM(DL),DQ=DNM(DL,0) K DTOUT,DNM(DL) I $D(DIEC(DL)) D DIEC^DIE1 G U
 S DIEL=DIEL-1,%=2,DA=DA(1) K DA(1)
DA I $D(DA(%)) S DA(%-1)=DA(%) K DA(%) S %=%+1 G DA
U S DL=DL-1 Q
 ;
X W:X'["?"&'$D(ZTQUEUED) $C(7),"??" G Z:$D(DB(DQ))
B G @(DQ_U_DNM)
N ;
 D DOWN S DA=$P(DC,U,4),D=0 S ^DISV(DUZ,$E(DIC,1,28))=$E(DIC,29,999)_DA
D1 S @("D"_DIEL)=DA G @(DGO)
M ;
 S DD=X D DOWN S DO(2)=$P(DC,"^",2),DO=DOW_"^"_DO(2)_"^"_$P(DC,"^",4,5),DIC(0)="LM"_$S($D(DB(DNM(DL,0))):"X",1:"QE") I @("'$D("_DIC_"0))") S ^(0)="^"_DO(2)
 E  I DO(2)["I" S %=0,DIC("W")="" D W^DIC1
 K DICR S D="B",DLAYGO=DP\1,X=DD D X^DIC
 I Y>0 S DA=+Y,X=$P(Y,U,2),D=$P(Y,U,3) G D1
 D UP G @(DQ_U_DNM)
 ;
DOWN S DL=DL+1,DNM(DL)=DNM,DNM(DL,0)=DQ D FILE
 F %=DL+1:-1:1 I $D(DA(%)) S DA(%+1)=DA(%)
 S DA(1)=DA,DIC=DIE_DA_","""_$P(DC,U,3)_""",",DIEL=DIEL+1 Q
ABORT D E S Y(DM)="" Q
0 ;
 D FILE
E K DIP,Y,DE,DOW,DB,DP,DW,DU,DC,DV,DH,DIL,DNM,DIEZ,DLB,DIEL,DGO Q
DR ;
 N F,DA I $E(DR)="[" S %X="^DIE(DIEZ,""DR"",",%Y="DR(" D %XY^%RCR S DR=DR(DL,DP) Q
 S F=0 D DICS^DIA F DDW=1:1 S DDW1=$P(DR,";",DDW) Q:DDW1=""  I $D(^DD(DI,+DDW1,0)),+$P(^(0),U,2)!(DDW1[":") S X=+DDW1,D(F)=+$P(DDW1,":",2) S:'D(F) D(F)=X D RANGE^DIA1
 K DDW,DDW1 Q
