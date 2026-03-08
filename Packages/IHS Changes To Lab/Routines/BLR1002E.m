BLR1002E ;DALISC/CYM - LR*5.2*72 PATCH ENVIRNMENT CHECK ROUTINE [ 12/21/1998  2:07 PM ]
 ;;5.2;BLR;**1002**;JUN 01, 1998
 ;;5.2;LAB SERVICE;**72**;Feb 14, 1996
EN ;Prevents loading of the transport global.
 ;Envirnment check is done only during the install.
 ;
 Q:'$G(XPDENV)
 I $S('($D(DUZ)#2):1,'($D(DUZ(0))#2):1,'DUZ:1,1:0) W !!,$C(7),">>>  DUZ and DUZ(0) must be defined as an active user to initialize.",!,"     Please setup these parameters (Sign-on) before continuing.",! S XPDQUIT=1
 I DUZ(0)'="@" W !!,$C(7),">>>  You must have programmer access (DUZ(0)=@) to run this init.",! S XPDQUIT=1
 I +$G(^DD(60,0,"VR"))<5.2 W !!,$C(7),">>>  You must at least be running Lab 5.2 to continue.",! S XPDQUIT=1
 I +$G(^DD(200,0,"VR"))<7.1 W !!,$C(7),">>>  You must at least be running KERNEL 7.1 to continue.",! S XPDQUIT=1
 I $S('$G(IOM):1,'$G(IOSL):1,$G(U)'="^":1,1:0) W !,$$CJ^XLFSTR("Terminal Device in not defined",80),!! S XPDQUIT=1
 I $S('$G(DUZ):1,$D(DUZ)[0:1,$D(DUZ(0))[0:1,1:0) W !!,$$CJ^XLFSTR("Please Log in to set local DUZ... variables",80),! S XPDQUIT=1
 I '$D(^VA(200,$G(DUZ),0))#2 W !,$$CJ^XLFSTR("You are not a valid user on this system",80),! S XPDQUIT=1
 S LRSITE=+$P(^XMB(1,1,"XUS"),U,17) I 'LRSITE W !!,"You must have a DEFAULT INSTITUTION defined in  KERNEL SITE PARAMETERS FILE.",!!,$C(7) S XPDQUIT=1
 I LRSITE'=DUZ(2) W !!?5,"Your Instituion File entry does not match your KERNEL SITE PARAMETERS FILE.",!!,$C(7) S XPDQUIT=2
 ;I LRSITE'=+$P($$SITE^BLRFUNC,U) W !!?5,"Your Instituion File entry does not match your KERNEL SITE PARAMETERS FILE.",!!,$C(7) S XPDQUIT=1  ;IHS/OIRM TUC/AAB 3/1/98
 I +$G(^LAM("VR"))'>5.1 W !,$$CJ^XLFSTR("You must have LAB V5.2 or greater Installed",80),! S XPDQUIT=1
 I $O(^LAB(64.81,0)) W !?5," You have old still in file 64.81 requiring linking ",$C(7) S XPDQUIT=1  ;PATCH LR*5.2*127 AAB
 I '$D(^LRO(68,"VR")) D
 . K DIC S DIC=68,DIC(0)="Z" F X="SURGICAL PATHOLOGY","CYTOPATHOLOGY","ELECTRON MICROSCOPY","AUTOPSY" D
 ..; D ^DIC I Y=-1 W $C(7),!!,"You must have ",X," defined in file 68 to proceed with this install",!! S XPDQUIT=2 Q
 .. D ^DIC I Y=-1 D   ;IHS/OIRM TUC/AAB 3/1/98
 ...K BLRIEN,BLRFDA,BLREMSG
 ...S BLRFDA(1,68,"+1,",.01)=X
 ...S BLRFDA(1,68,"+1,",.02)=$S($E(X)="S":"SP",$E(X)["C":"CY",$E(X)["A":"AU",1:"EM")
 ...S BLRFDA(1,68,"+1,",.03)="Y"
 ...S BLRFDA(1,68,"+1,",.05)=$O(^LAB(62.07,"B","YEARLY",""))
 ...;S BLRFDA(1,68,"+1,",.05)=1
 ...S BLRFDA(1,68,"+1,",.09)=$S($E(X)="S":"SP",$E(X)["C":"CY",$E(X)["A":"AU",1:"EM")
 ...S BLRFDA(1,68,"+1,",.095)=$O(^LAB(62.2,"B",X,""))
 ...S BLRFDA(1,68,"+1,",.19)="AP"
 ...S BLRIEN="+1,"
 ...D UPDATE^DIE("","BLRFDA(1)","BLRIEN","BLREMSG")
 ...I $D(BLREMSG) W $C(7),!!,BLREMSG("DIERR",1,"TEXT",1),!! S XPDQUIT=1 Q
 ..; S LRSS=$P(Y(0),U,2),LRABV=$P(Y(0),U,11)
 ..; I LRSS="" W $C(7),!!,"You must have the LR Subscript field in file 68 defined for ",X," to proceed with this install",!! S XPDQUIT=2
 ..; I LRABV="" W $C(7),!!,"You must have the ABBREVIATION field in file 68 defined for ",X," to proceed with this install",!! S XPDQUIT=2
 ..; I X="SURGICAL PATHOLOGY",LRSS'="SP" W !!,$C(7),$$CJ^XLFSTR("Check your file setup for SURGICAL PATHOLOGY.  Refer to instructions in the Installation Guide",80) S XPDQUIT=2
 ..; I X="CYTOPATHOLOGY",LRSS'="CY" W !!,$C(7),$$CJ^XLFSTR("Check your file setup for CYTOPATHOLOGY.  Refer to instructions in the Installation Guide",80) S XPDQUIT=2
 ..; I X="EM",LRSS'="EM" W !!,$C(7),$$CJ^XLFSTR("Check your file setup for EM.  Refer to instructions in the Installation Guide",80) S XPDQUIT=2
 ..; I X="AUTOPSY",LRSS'="AU" W !!,$C(7),$$CJ^XLFSTR("Check your file setup for AUTOPSY.  Refer to instructions in the Installation Guide",80) S XPDQUIT=2
 W !!,"Checking for 1001..."  ;IHS/DIR TUC/AAB 6/9/98
 ;F RN="BLRFLTL","BLRLINK" X "ZL @RN S LN2=$T(+2)" I LN2'["1001" D
 ;.  W !,$$CJ^XLFSTR(RN_"--Patch 'LR*5.2*1001' has not been installed.",80)
 ;.  W ! S XPDQUIT=1
 K BLRFDA,BLRIEN,BLREMSG,DIC  ;IHS/OIRM TUC/AAB 3/1/98
 ;I $G(XPDQUIT) W !!,$$CJ^XLFSTR("Install environment check FAILED",80)
 I $G(XPDQUIT) S ^TMP("LR*5.2*1002",$J)=1 W !!,$$CJ^XLFSTR("Install environment check FAILED",80) Q   ;IHS/DIR TUC/AAB 06/10/98
 ;I '$G(XPDQUIT) W !!,$$CJ^XLFSTR("Environment Check is Ok ---",80)
 W !!,$$CJ^XLFSTR("Environment Check is Ok ---",80)  ;IHS/DIR TUC/AAB 06/10/98
 Q
