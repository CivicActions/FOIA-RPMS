XUCSUTL ;CLARKSBURG/SO GENERAL UTILITIES - PART 1 ;2/7/96  08:17 [ 04/02/2003   8:47 AM ]
 ;;7.3;TOOLKIT;**1001**;APR 1, 2003
 ;;7.3;TOOLKIT;**12**;Apr 25, 1995
LOAD ; Load Common Local Variables
 I '$D(XUCSITE) D SITE^XUCSUTL3
 S XUCSPAR=Y(0) ; Save File 8987.1, Field #3, zeroth node
 S XUCSVG=$P(XUCSPAR,U) ; Name of Vol. Group
 S XUCSPUCI=$P(Y(0),U,3) ; Name of Producton UCI
 Q
EDIT ; Common edit for file 8987.2
 I '$D(XUCSITEN) D SITE^XUCSUTL3
 K DIC S DIC="^XUCS(8987.2,",DIC(0)="FLMXZ",X=XUCSITEN_XUCSVG D ^DIC K DIC
E1 ; If SITE_VG not already defined - Add It
 I +Y<1 K DD,DO S DIC="^XUCS(8987.2,",DIC(0)="FLMXZ",X=XUCSITEN_XUCSVG D FILE^DICN K DD,DO,DIC
E2 ; Update 990001.01 Multiple
 I $D(XUCSDA2),$D(XUCSDA1) Q  ; Multiple already updated
E3 ; Update it
 S DIC="^XUCS(8987.2,",DA(1)=+Y,DIC=DIC_DA(1)_",1,",DIC(0)="FLMXZ"
 S DIC("P")=$P(^DD(8987.2,1,0),U,2),X=XUCSSDT D ^DIC
 S DIE=DIC K DIC S DA=+Y,DR="1.2///^S X=$P(XUCSRID,U,5)" D ^DIE
 I $D(XUCSTBFR) S DR="1.3///^S X=XUCSTBFR" D ^DIE
 I $D(XUCSTBFG) S DR="1.4///^S X=XUCSTBFG" D ^DIE
 K DIE,DR,Y
 S XUCSDA2=DA(1),XUCSDA1=DA K DA
 Q
KILL ; Kill off Loaded Local Variables
 I '$D(XUCSALL) K XUCSITE,XUCSITEN,XUCSPAR,XUCSPUCI,XUCSRID,XUCSVG,XUCSPAR,XUCSVG,XUCSPUCI,XUCSRID,XUCSRN
 Q
CHKF() ; Check for File #8987.2
 I '$D(^XUCS(8987.2,0))#2 W $C(7),!,"Capacity Management for MSM does NOT appear to be installed!" Q 0
 Q 1
PAUSE ; Terminal Screen Pause
 Q:$E(IOST)'="C"  ; Output NOT a terminal
 W ! K DIR S DIR(0)="E",XUCSEND=0 D ^DIR K DIR S:+Y<1 XUCSEND=1
 Q
ALERT ; Setup Alert Recipents
 S XQA(DUZ)=""
 I $D(^XUCS(8987.1,1,2,0))'>1 Q  ; No Local CMP Recipents
 N D1,X
 ; Address alert to Local CMP Recipients
 S D1=0 F  S D1=$O(^XUCS(8787.1,1,2,D1)) Q:+D1<1  S X=^(+D1,0),XQA(+X)=""
 Q
