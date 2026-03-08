DIA ;SFISC/GFT-SELECT FIELDS TO EDIT ;7/10/97  11:37 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**29,43**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;12999;7752413;3179;
 ;
 D DICS
1 D F W !?F*3,"EDIT WHICH "_X I $S(DB:DIAT="",1:1) R ": ALL// ",X:DTIME S:'$T X=U,DTOUT=1 G ALL^DIA1:X=""!(X="ALL"),TEMP^DIA1:X?1"[".E&'F,L
ED G NDB:DIAT=""
GDB S Y=$P(DIAT,";",DB) I "Q"[Y G NDB:Y="" D DB G GDB
 I Y?.NP,$P(Y,":",2),Y'["/" S Y=+Y_"-"_$P(Y,":",2)
 I $D(DI(DB)),$D(DI(DB,F,DI,DIAO)) S Y=DI(DB,F,DI,DIAO)
 W ": "_Y D RW
 I X="" S X=Y I X="ALL" G ALL^DIA1
L S DSC=X?1"^".E I DSC S X=$E(X,2,999) I U[X K DR Q
 I $A(X)=64 G X:X'?1P.N,P:$L(X)>1,X:'DB S DB=DB+1 G 2
 K DIC,DIAB D DICS S DV="",J=$P(X,"-",2) I +J=J,$P(X,"-",1)=+X,J>X S D(F)=J K DA D RANGE^DIA1 K D S Y=DA G X:Y="" D DB G 2
DIC ;
 S DIC(0)="EZI",DIC="^DD(DI,",Y=-1 G X^DIA3:X[";" S DIC("W")="S %=$P(^(0),U,2) I % W $S($P(^DD(+%,.01,0),U,2)[""W"":""  (word-processing)"",1:""  (multiple)"")" D ^DIC Q:$D(DTOUT)
 I Y>0 D SET S Y=$P(Y(0),U,2) G 2:'Y S L=L+1,(DI,J(L))=+Y,I(L)=""""_$P($P(Y(0),U,4),";",1)_"""" G DOWN
 I $E(X)="]" S DRS=9,X=$E(X,2,999) G DIC:X]"",2
 G DIA^DIQQQ:X?."?" I $D(^DD(DI,"GR")) K Y S Y=-1 D:$L(X)<31
 . N I,DIGRP,DTOUT,DUOUT,DIRUT,DIROUT,DIYN S DIGRP=X,DIYN=0
 . D:$D(^DD(DI,"GR",DIGRP))  Q:DIYN  F  S DIGRP=$O(^DD(DI,"GR",DIGRP)) Q:$E(DIGRP,1,$L(X))'=X  D  Q:DIYN
 .. N X,I
 .. F I=0:0 S I=$O(^DD(DI,"GR",DIGRP,I)) Q:'I  I $G(^DD(DI,I,0))]"" S I(I)=I_U_$P(^(0),U)
 .. Q:'$O(I(0))
 .. W !!,"Fields in Group: ",DIGRP F I=0:0 S I=$O(I(I)) Q:'I  W !,?2,I,?10,$P(I(I),U,2)
 .. D  Q:DIYN'=1
 ... N X,Y S DIR(0)="Y",DIR("A")="Edit this GROUP of fields",DIR("B")="YES" D ^DIR S DIYN=$S(Y=1:1,$G(DIRUT):2,1:0) Q
 .. M Y=I S Y=0 Q
 . Q
 K DIYN G X^DIA3
 ;
F S X=$P(^DD(DI,0),U,1) I F,X="FIELD" S X=$O(^(0,"NM",0))_" "_X
 Q
 ;
X ;
 W $C(7),"??" D DICS
2 ;
 G 1:'$D(DR(F+1,DI)) D F W !?F*3,"THEN EDIT "_X G ED:DB
R R ": ",X:DTIME E  W $C(7) S X=U,DTOUT=1
 I X]"" G L
UP ;
 G ^DIA1:'F K I(L),J(L) S L=L-1 I '$D(J(L)) F L=L-99:1 Q:'$D(J(L+1))
 I DB S DB=DB(F),DIAO=DIAO(F),DIAT=$S(DIAO<0:"",DIAO:^DIE(DIAA,"DR",F,J(L),DIAO),$D(^DIE(DIAA,"DR",F,J(L))):^(J(L)),1:"")
 S DIAP=DIAP(F),DI=J(L),F=F-1 G 2
 ;
NDB I DB,DIAO'<0 S DIAO=DIAO+1 I $D(^DIE(DIAA,"DR",F+1,DI,DIAO)) S DIAT=^(DIAO),DB=1 G GDB
 S DIAO=-1 G R
 ;
EN ;
 D OS^DII:'$D(DISYS),DICS
DOWN S F=F+1,DIAP(F)=DIAP,DIAP=0 I DB S DB(F)=DB,DB=1,DIAO(F)=DIAO,DIAO=0,DIAT=$S($D(^DIE(DIAA,"DR",F+1,DI)):^(DI),1:"")
 G 1:$P(^DD(DI,.01,0),U,2)'["W",1:L#100=0,UP
DICS ;
 S DIC("S")="I Y>.001,$P(^(0),U,2)'[""C"""_$S(DUZ(0)="@":"",1:",$P(^(0),U,2)'[""K""")_" Q:'$D(^(9))  I ^(9)'=U"_$S(DUZ(0)'="@":" F DW=1:1:$L(^(9)) I DUZ(0)[$E(^(9),DW) Q",1:"") Q
 ;
P ;
 S DRS=99,Y=X D DB G 2
 ;
SET S Y=+Y_DV
DB ;
 I DB,'DSC S DB=DB+1
D ;
 I '$D(DR(F+1,DI)) S DR(F+1,DI)="",DIAP=0
 E  I $L(DR(F+1,DI))+$L(Y)>230 F %=0:1 I '$D(DW(DI,%)) S DIAP=DIAP\1000+1*1000,DW(DI)=F+1,DW(DI,%)=DR(F+1,DI),DR(F+1,DI)="" Q
 S DR(F+1,DI)=DR(F+1,DI)_Y_";",DRS=DRS+1,DIAP=DIAP+1 I $D(DIAB) S ^UTILITY($J,DIAP#1000,F,DI,DIAP\1000)=DIAB K DIAB
 Q
RW I $L(Y)>19 D RW^DIR2 Q
 W "// " R X:DTIME I '$T S X=U,DTOUT=1 W $C(7)
