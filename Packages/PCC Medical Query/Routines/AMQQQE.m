AMQQQE ; OHPRD/DG - SCRIPT EDITOR ;  [ 01/31/2008   5:08 PM ]
 ;;2.0;PCC QUERY UTILITY;**17,18,20,21**;FEB 07, 2007
LOOP F  D SEL I $D(AMQQQUIT) Q
 Q
 ;
SEL ;N (AMQQQUIT,AMQQFAIL,AMQQADAM,AMQQNOET,AMQQOPT,AMQQNV,AMQQRV,AMQQXV,AMQQVER,DUZ,DT,DTIME,U,IO,IOBS,IOF,IOHG,IOPAR,IOT,IOUPAR,IOM,ION,IOS,IOSL,IOST,IOXY,XQDIC,XQPSM,XQY,XQY0,ZTQUEUED)
 ;W:$D(IOF) @IOF,!!?20,"*****  Q-MAN SCRIPT UTILITIES  *****",!!
 ;S DIR(0)="SO^1:COPY a Script;2:EDIT a Script;3:IMPORT a Script;4:PURGE a Script;5:RUN a Script;6:VIEW a Script;7:WRITE a Script;9:HELP;0:EXIT"
 ;S DIR("??")="AMQQSCRIPT",DIR("A")=$C(10)_"     Your choice",DIR("?")="Select one of the choices or type '??' for instructions",DIR("B")="EXIT" D ^DIR K DIR
 S Y=5
 D CHKOUT I  Q
 I Y=-1 Q
 I Y=0 S AMQQQUIT="" Q
 W !! D @$P("COPY^EDIT^IMPORT^PURGE^RUN^VIEW^WRITE^^HELPME",U,Y) Q
EXIT K X,Y,%,%Y,AMQQXX,AMQQYY,AMQQFAIL,I
 Q
 ;
WRITE S DIR("A")="Script name" K AMQQFAIL
W1 W ! S DIR(0)="9009072,.01" D ^DIR K DIR
 D CHKOUT I  Q
CR1 ; ENTRY POINT FROM AMQQE1
 S Y=$O(^AMQQ(2,"B",X,"")) S Y=$S('Y:-1,1:(Y_U_X))
 I Y=-1 D ADD Q
 I DUZ'=$P(^AMQQ(2,+Y,0),U,2) W !!,*7,"This script already exists...Try another name.",!! G WRITE
 W !!,*7,"This script already exists.  Want to overwrite"
 S %=2 D YN^DICN I $D(DTOUT)+$D(DUOUT) Q
 I "Nn"[$E(%Y) W ! G WRITE
 S DIK="^AMQQ(2,",DA=+Y,AMQQQENA=$P(Y,U,2) D ^DIK K DIK,DA,DIC
 S X=AMQQQENA K AMQQQENA
ADD W !! S DIC="^AMQQ(2,",DIC(0)="L",DIC("DR")="1////"_DUZ_";2///"_DT_";5"
 I $D(AMQQESN) S DIC("DR")="1////"_DUZ_";2///"_DT
 D ^DIC K DIC
 I $D(AMQQESN) Q
 I $D(DUOUT)+$D(DTOUT)+(Y=-1) K DUOUT,DTOUT Q
 I '$P($G(^AMQQ(2,+Y,1,0)),U,4) S AMQQQUIT="" Q
COMPILE ; ENTRY POINT FROM ^AMQQQE1
 S AMQQXX="^AMQQ(2,"_+Y_",1,",AMQQYY=Y
 W !! D WAIT^DICD W !!
 D SEARCH^AMQQ
 I $D(AMQQFAIL) D FAIL K AMQQFAIL S AMQQQUIT="" G PAUSE
 I $D(AMQQQUIT) Q
 W !,"OK, I have saved your script """,$P(AMQQYY,U,2),""" and its compiled",!,"search code in the Q-Man Script file.  It is ready for use at any time!"
PAUSE W !!! S DIR(0)="E" D ^DIR K DIR
 Q
 ;
FAIL S %=AMQQFAIL,%=$S(%<5:"SUBJECT",%=5:"TAXONOMY",%=6:"ATTRIBUTE",%=7:"CONDITION",8:"VALUE",9:"OR GROUP",1:"SUBQUERY")
 W !!,"Script error detected...Unable to compile...Request terminated",!,"Source of error: ",%,!,"Use the EDIT function to correct script error.",*7
 K AMQQFAIL
 Q
 ;
HELPME W !!!,"Select a code from the list or type '??' for more information",!! S DIR(0)="E" D ^DIR K DIR
 Q
 ;
CHK ; ENTRY POINT FROM AMQQE1
 I +Y,$P($G(^AMQQ(2,+Y,0)),U,2)'=DUZ
 Q
 ;
GET S DIC("A")="Enter the name of the Q-Man script: "
 K AMQQFAIL
GET1 S DIC="^AMQQ(2,",DIC(0)="AEQ",DIC("S")="I $P($G(^AMQQ(2,Y,1,0)),U,4)" D ^DIC K DIC
CHKOUT I $D(DTOUT)+$D(DUOUT)+(Y=-1) K DIRUT,DUOUT,DTOUT S AMQQQUIT="" Q
 I Y="" S Y=-1 Q
 Q
 ;
RUN ;EP;TO RUN A SCRIPT ;PATCH 17
 W:$D(IOF) @IOF
 S DIC("A")="Enter the name of the search logic to be run: ",DIC="^AMQQ(2,",DIC(0)="AEQ" D ^DIC K DIC
 D CHKOUT I  Q
 D RUN^AMQQQE1
 Q
 ;
PURGE D GET Q:$T  D PURGE^AMQQQE1
 Q
 ;
VIEW D GET I  Q
 S (I,%)=0 F  S %=$O(^AMQQ(2,+Y,1,%)) Q:'%  S I=I+1,Z="" W ! X:'(I#(IOSL-4)) "I I>1 W ""<>"" R Z:DTIME S:'$T Z=U W $C(13),?9,$C(13)" Q:Z=U  W ^(%,0)
 W !! S DIR(0)="E" D ^DIR K DIR
 Q
 ;
IMPORT D IMPORT^AMQQQE1
 Q
 ;
EDIT D GET Q:$T  D EDIT^AMQQQE1
 Q
 ;
COPY S DIC("A")="Copy from what script: " D GET1 Q:$T  D COPY^AMQQQE1
 Q
 ;
STORE ; ENTRY POINT FROM AMQQCMPL
 S DIR("A")="Store logic under what name" S AMQQESN="" D W1
 I $D(AMQQQUIT) Q
 K AMQQESN S AMQQCPLF="",AMQQYY=Y
 W "OK, I will store this search logic for future use.",!!! H 2
 Q
 ;
