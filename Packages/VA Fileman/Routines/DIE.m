DIE ;SFISC/GFT,XAK-PROC.DR-STR ;2/10/95  06:54 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**19**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 K DB I DIE S DIE=^DIC(DIE,0,"GL")
 Q:$D(@(DIE_DA_",-9)"))  Q:'$D(@(DIE_"0)"))  S U="^",DP=+$P(^(0),U,2) Q:$P($G(^DD($$FNO^DILIBF(DP),0,"DI")),U,2)["Y"&'$D(DIOVRD)&'$G(DIFROM)
GO Q:DIE?1"^DIA(".E  K DE,DOV,DIOV,DIEC,DTOUT N DIEDA D
 . N %
 . F %=1:1 Q:'$G(DA(%))  S DIEDA(%)=DA(%)
 . S DIEDA=DA
 . Q
 S DL=1,D0=DA,DI=DP,DR(1,DP)=DR D INI I $E(DR)'="[" D DR^DIE17
 S DP=DI,DA=D0,(DQ,DIEL,DK,DP(0))=0 K DIC("S")
MR S DK=DK+1,DH=$P(DR,";",DK) I +DH=DH S (DI,DM)=DH G S:$D(^DD(DP,DI)),MR
 S DI=$P(DH,":",1) I 'DI G K:DI=0,PB
J I DH["//" S DE(DQ+1,0)=$P(DH,"//",2,9),DI=$P(DI,"//",1),DH=""
 G K:+DI=DI S DM=+DI,Y=$P(DI,DM,2,99),DI=DM G MR:Y=""!'$D(^DD(DP,DI,0)) S DQ=DQ+1,(DZ,DQ(DQ))=^(0),DIFLD(DQ)=DI
 F %=1:1 S DIG=$P(Y,$C(126),%) Q:DIG=""  S DZ=$S(DIG="d"!(DIG="R"):$P(DZ,U,1,2)_DIG_U_$P(DZ,U,3,99),DIG="T":$S($D(^(.1)):^(.1),1:$P(DZ,U))_U_$P(DZ,U,2,99),1:DIG_U_$P(DZ,U,2,99))
 S DQ(DQ)=DZ K DZ,DIG G Y
K S DM=$P(DH,":",2),DM=$S(DM:DM,1:DI) I DI,$D(^DD(DP,DI)) G S
NX S DI=$O(^DD(DP,DI)) S:DI="" DI=-1 G MR:DI'>0,MR:DI>DM
S I $S<2000,DQ,'$D(DE(DQ+1)) G H
 S DQ=DQ+1,DQ(DQ)=^(DI,0),DIFLD(DQ)=DI
Y S Y=$P(DQ(DQ),"^",4),DG=$P(Y,";",1)
 I $D(^(1))!($P(DQ(DQ),U,2)["a") S DE=0,DB=DM,DM=0 F DW=1:1 S DE=$O(^DD(DP,DI,1,DE)) Q:DE<1  S DE(Y)=DQ,DE(Y,DW,1)=^(DE,1),DE(Y,DW,2)=^(2)
 I  S:DE="" DE=-1
 I $P(DQ(DQ),U,2)["a" S DE(Y,DW,2)="S DIIX=2_U_DIFLD(DE(DQ)) D AUDIT^DIET",DE(Y,DW,1)="S DIIX=3_U_DIFLD(DE(DQ)) D AUDIT^DIET",DE(Y)=DQ I ^DD(DP,DI,"AUDIT")="e" S DE(Y,DW,1)="I $D(DE(DE(DQ)))#2 "_DE(Y,DW,1)
 S Y=$P(Y,";",2) I DU'=DG S D="",DU=DG,@DC G M:Y=0,B:DU=" ",EQ:DW[0 S D=^(DG)
 I Y S:$P(D,"^",Y)]"" DE(DQ)=$P(D,"^",Y)
 E  S Y=$E(D,+$E(Y,2,9),$P(Y,",",2)) S:Y'?." " DE(DQ)=Y
EQ G MR:DI=DM,NX:DM S DM=DB K DB G D
 ;
INI K DIC("S") S DIC=DIE,DU=-1,DC="DW=$D("_DIE_DA_",DG))"
Q Q
MORE ;
 D INI G MR:DI=DM,NX:DI'[U S DI=+DI G S:$D(^DD(DP,DI)),MR
JMP ;
 D INI G J
 ;
PB I DH="" G D:$D(DR(DL,DP))<9 S:'$D(DOV) DOV=0,DR(DL,DP)=DR S DOV=$O(DR(DL,DP,DOV)) S:DOV="" DOV=-1 G D:DOV'>0 S DR=DR(DL,DP,DOV),DK=0 G MR
 G MR:DH?1"@".N I 'DQ G TEM:DH?1"[".E S:"Q"'=DH DQ=1,DQ(0,1)=DH G MR:$A(DH)-94 S DC=$P(DH,U,1,4) X $P(DH,U,5,999) G O^DIE0
E S DK=DK-1,(DI,DM)=1
D G DQ^DIED
H S DI=DI_U G D
M S Y=$P(DQ(DQ),U,2)_U_DG G DC:DW<9
 I $D(DSC(+Y))#2,$P(DSC(+Y),"I $D(^UTILITY(",1)="" S D=DIEL+1 D D1 X DSC(+Y) S D=$O(^(0)) S:D="" D=-1 S @DC S DC=$O(^(DG,0)) S:DC="" DC=-1 G DE
 I $D(^(DG,0)) S D=$P(^(0),U,3,4)
 E  S D=$O(^(0)) S:D="" D=-1
DE I D>0 S Y=Y_U_D I DP(0)-Y,$D(^(+D,0)) S DE(DQ)=$P(^(0),U,1)
DC S DC=$P(^DD(+Y,0),U,4)_U_Y,%=DQ(DQ),Y=^(.01,0) I $P(Y,U,2)'["W" S DQ(DQ)="Select "_$P(Y,U,1)_U_1_$P(Y,U,2,99) G D
 I DQ>1 K DQ(DQ) G E:$D(DE(DQ,0)),H
 D
 .Q:DH'[$C(126)
 .N DIEA S DIEA=$P($P(DH,+DH,2),$C(126)) Q:DIEA=""!(DIEA="d")!(DIEA="R")
 .S $P(%,U)=$S(DIEA="T"&$D(^DD(+$P(%,U,2),.01,.1)):^(.1),1:DIEA)
 .Q
 S Y=$P(%,U,1)_U_$P(Y,U,2) D DIEN^DIWE K DQ,DG,DE S DQ=0 G QY^DIE1:$D(DTOUT) G MORE
 ;
D1 Q:D'>0  S:'$D(@("D"_D)) @("D"_D)=0 S D=D-1 G D1
 ;
B K DQ(DQ) S DQ=DQ-1,DU=-9 G EQ
 ;  
TEM S Y=0 F  S Y=$O(^DIE("B",$P($E(DR,2,99),"]",1),Y)) S:Y="" Y=-1 G Q:Y=-1,Q:'$D(^DIE(+Y,0)) Q:$P(^(0),U,4)=DP
 S $P(^(0),U,7)=DT I $G(^("ROU"))[U,$$ROUEXIST^DILIBF($P(^("ROU"),U,2)) G @^DIE(+Y,"ROU")
 S:$D(^("W")) DIE("W")=^("W") S %X="^DIE(+Y,""DR"",",%Y="DR(" D %XY^%RCR
 S DIE("^")=DR,DR=$S($D(^DIE(Y,"DR"))#2:^("DR"),1:DR(1,DP)) D DIE K DR S DR=DIE(U)
 Q
 ;
 ;Silent call concerning editing and filing of data.
 ;
FILE(DIEFFLAG,DIEFAR,DIEFOUT) ;
 G FILEX^DIEF
 ;
WP(DIEFF,DIEFIEN,DIEFFLD,DIEFWPFL,DIEFTSRC,DIEFOUT) ;
 G WPX^DIEFW
 ;
HELP(DIEHF,DIEHIEN,DIEHFLD,DIEHFLG,DIEHOUT) ;
 G GETX^DIEH
 ;
VAL(DIEVF,DIEVIEN,DIEVFLD,DIEVFLG,DIEVAL,DIEVANS,DIEVFAR,DIOUTAR) ;
 G VALX^DIEV
 ;
CHK(DIEVF,DIEVFLD,DIEVFLG,DIEVAL,DIEVANS,DIOUTAR) ;
 G CHKX^DIEV
 ;
UPDATE(DIFLAGS,DIFDA,DIEN,DIMSGA) ;SEA/TOAD
 ; ENTRY POINT--update database
 ; procedure, all passed by value
 G ADDX^DICA
 ;
