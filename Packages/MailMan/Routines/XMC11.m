XMC11 ;(WASH ISC)/THM-SCRIPT INTERPRETER SETUP ;06/22/99  14:48
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Entry points used by MailMan options (not covered by DBIA):
 ; EDIT     XMSCRIPTEDIT
 ; EDITSC   XMSUBEDIT
 ; GO       XMSCRIPTPLAY
 ; RES      XMSCRIPTRES
GO ;Entry for Script Processing
 N XMABORT
 S XM="D",XMABORT=0
 D ENT1^XMR
 K ^TMP("XMC",XMR0),XMRDOM,XMSDOM,XMTLER
 D INST^XMC11A(.XMSCR,.XMSCRN,.XMB,.XMDIC,.XMIO,.XMABORT)
GQ I '$G(XMB("SCRIPT",0)) K DIC,XMDIC,XMR0,XMSCR,XMSCRN,X,Y Q
 S %=$S($D(^XMBS(4.2999,XMSCR,3))#10:$P(^(3),U,7),1:0) I % S XMC11=%,Y=$$CHK(XMIO),%=XMC11 K XMC11 S:Y<0 %=0
 I $S('%:1,$D(^XUSEC("XUPROGMODE",DUZ)):1,1:0) D ^XMC1 G KL^XMC
 W !!,*7,"Task "_%_" is scheduled to transmit this domain's messages.",!,"You must delete task "_%_" & the TRANSMISSION TASK# field",!,"from the MESSAGE STATISTICS (4.2999) file before playing the script !" S Y=-1 K %
 W !!,"CAUTION !!!  You must also make sure that the task is not running !",!,"CHECK THE SYSTEM STATUS !!",!
 G GQ
CHK(X) ;Is DEVICE in a HUNT GROUP ?
 S DIC="^%ZIS(1,",DIC(0)="MZX" K Y D ^DIC
 I $S(Y<0:1,'$L($P(Y(0),U,10)):1,1:0) G Q
 S X=$O(^%ZIS(1,"AH",$P(Y(0),U,10),0)) I $S(X="":1,'$O(^(X)):1,1:0) Q -1
Q Q 1
EDITSC N DIC,DLAYGO S (DLAYGO,DIC)=4.6,DIC(0)="AEQMZL" D ^DIC Q:Y<0
 S XMSCR=+Y,XMSCRN=$P(Y(0),U),DA=XMSCR,DIE=4.6,DR=".01;1" D ^DIE
 K XMSCR,XMSCRN,DA,DIE,DR
 Q
EDIT S DIC=4.2,DIC(0)="AEQMZ" D ^DIC Q:Y<0
 S DA=+Y,DIE=DIC,DR="17;1:4.2;6.2:6.9",DR(2,4.21)=".01;1:99",ZTSK=$S($D(^XMBS(4.2999,DA,3)):$P(^(3),U,7),1:0) D ^DIE S (DIE,DIC)=4.2999,DR=25 D ^DIE
 I ZTSK,$S('$D(^XMBS(4.2999,DA,3)):1,'$P(^(3),U,7):1,1:0) D KILL^%ZTLOAD W !!,*7,"<<< Task "_ZTSK_" has been deleted with a call to TaskMan. >>",!!
 K ZTSK Q
LIST W !!,"TRANSCRIPT IS: " F XMCI=0:0 S XMCI=$O(^TMP("XMC",XMR0,XMCI)) Q:XMCI=""  W !,^(XMCI)
 Q
DI R !,"NUMBER(S) TO DIAL ",XMC1:DTIME Q:XMC1=""
D ;DIAL NUMBERS SUCESSIVELY (Strip all punctuation not in XMSTRIP string)
 N XMC11D S XMC11D=$S($L($G(XMFIELD)):XMFIELD,1:$S($G(XMSTRIP)[",":";",1:","))
 F XMJ=1:1 S X=$P(XMC1,XMC11D,XMJ) Q:X=""  D D2 Q:'ER
 K XMSTRIP,XMFIELD Q
D2 S XMPHONE="",%=$G(XMSTRIP) F XMK=1:1:$L(X) S %0=$E(X,XMK) I $S(%0'?1P:1,%[%0:1,1:0) S XMPHONE=XMPHONE_%0
 S ER=0,XMTRAN="Dialing "_XMPHONE D TRAN^XMC1 X $S($D(XMDIAL):XMDIAL,1:"S ER=1") I ER,$S('$D(Y):0,$L(Y):1,1:0) S XMTRAN="Call failed: "_Y D TRAN^XMC1
 Q
H ;HANG UP PHONE
 S XMTRAN="Hanging up phone" D TRAN^XMC1 Q:'$D(XMHANG)  X XMHANG Q
IMM ;IMMEDIATE MODE INTERPRETER
 S XMBF=1,XMBUF="RT",XMCI=0 I $D(XMR0),$L(XMR0) K ^TMP("XMC",XMR0)
I1 R !!,"Script command: ",X:DTIME Q:X=""  D INT^XMC1 U IO(0) W "  ",$S(ER:"Failed",1:"Ok") G I1
 Q
RES S:'$D(XMCI) XMCI=0 D ^%ZIS Q:POP  F I=0:0 S I=$O(^DIC(4.2,XMINST,1,1,1,I)) Q:I=""  W !,$J(I,2),$S(I=XMCI:"->",1:"  "),^(I,0)
 W !!,"Resume script processing from: ",XMCI,"// " R I:DTIME S:'$T I=U Q:I[U  S:I'="" XMCI=+I S XMTRAN="Resuming script from line "_XMCI D TRAN^XMC1 S XMCI=XMCI-.1 U IO G IN^XMC1
 Q
CHRS ;Christening operation
 I '$D(^XMB("NAME")) W !!,*7,"This domain is not yet christened. It cannot christen others",!,"until initialized and christened by a parent domain.",!! Q
 W !!,"This process will create a new subordinate domain to this domain"
 W !,"and update network relationships both there and here, as well as"
 W !,"inform this domain's parent.",!!,"Do you really want to do this? NO// "
 R X:DTIME Q:"Yy"'[$S($L(X):$E(X),1:1)
C W !!!,"Enter the name of the subordinate domain which you wish to christen" S DIC=4.2,DIC(0)="AEQMZ" D ^DIC Q:Y<0
 S XMCHRS=^XMB("NAME")_","_$P(Y,U,2),XMSCR=+Y,XMSCRN=$P(Y,U,2),XM="D" K ^TMP("XMC",XMR0) D ^XMC1 K XMCHRS
 Q
 ;
 ;ENS and ENR are used by DECNET protocol as documented MailMan 7.0...
 ;Send
ENS Q:'$G(XMINST)  N X S X=$$STAT^XMLSTAT(XMINST,1,XMSG,"DECNET",1)
 Q
 ;Receive
ENR Q:'$G(XMINST)  N X S X=$$STAT^XMLSTAT(XMINST,2,XMRG,"DECNET",1)
 Q
