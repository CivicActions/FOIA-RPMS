BLR1007E ;IHS/DIR/FJE- LR*5.2*1008 PATCH ENVIRNMENT CHECK ROUTINE [ 05/14/1999  10:50 AM ]
 ;;5.2;BLR;**1008**;MAY 14, 1999
EN ;Prevents loading of the transport global.
 ;Envirnment check is done only during the install.
 ;
 Q:'$G(XPDENV)
 I $S('($D(DUZ)#2):1,'($D(DUZ(0))#2):1,'DUZ:1,1:0) W !!,$C(7),">>>  DUZ and DUZ(0) must be defined as an active user to initialize.",!,"     Please setup these parameters (Sign-on) before continuing.",! S XPDQUIT=1
 ;I DUZ(0)'="@" W !!,$C(7),">>>  You must have programmer access (DUZ(0)=@) to run this init.",! S XPDQUIT=1
 I +$G(^DD(60,0,"VR"))<5.2 W !!,$C(7),">>>  You must at least be running Lab 5.2 to continue.",! S XPDQUIT=1
 I +$G(^DD(200,0,"VR"))<8.0 W !!,$C(7),">>>  You must at least be running KERNEL 8.0 to continue.",! S XPDQUIT=1
 I $S('$G(IOM):1,'$G(IOSL):1,$G(U)'="^":1,1:0) W !,$$CJ^XLFSTR("Terminal Device in not defined",80),!! S XPDQUIT=1
 I $S('$G(DUZ):1,$D(DUZ)[0:1,$D(DUZ(0))[0:1,1:0) W !!,$$CJ^XLFSTR("Please Log in to set local DUZ... variables",80),! S XPDQUIT=1
 I '$D(^VA(200,$G(DUZ),0))#2 W !,$$CJ^XLFSTR("You are not a valid user on this system",80),! S XPDQUIT=1
 S LRSITE=+$P(^XMB(1,1,"XUS"),U,17) I 'LRSITE W !!,"You must have a DEFAULT INSTITUTION defined in  KERNEL SITE PARAMETERS FILE.",!!,$C(7) S XPDQUIT=1
 I LRSITE'=DUZ(2) W !!?5,"Your Instituion File entry does not match your KERNEL SITE PARAMETERS FILE.",!!,$C(7) S XPDQUIT=2
 I +$G(^LAM("VR"))'>5.1 W !,$$CJ^XLFSTR("You must have LAB V5.2 or greater Installed",80),! S XPDQUIT=1
KERP W !!,"Checking for Kernel Patch 1005..."
 F RN="XUP","XUS11" X "ZL @RN S LN2=$T(+2)" I LN2'["1005" D
 .  W !,$$CJ^XLFSTR(RN_"--Kernel Patch 'XU*8.0*1005' has not been installed.",80)
 .  W ! S XPDQUIT=1
 W !!,"Checking for Patch 1006..."
 F RN="BLRFLTL","BLRCU" X "ZL @RN S LN2=$T(+2)" I LN2'["1006" D
 .  W !,$$CJ^XLFSTR(RN_"--Patch 'LR*5.2*1006' has not been installed.",80)
 .  W ! S XPDQUIT=1
 K BLRFDA,BLRIEN,BLREMSG,DIC  ;IHS/OIRM TUC/AAB 3/1/98
 I $G(XPDQUIT) W !!,$$CJ^XLFSTR("Install environment check FAILED",80)
 I '$G(XPDQUIT) W !!,$$CJ^XLFSTR("Environment Check is Ok ---",80)
 Q
