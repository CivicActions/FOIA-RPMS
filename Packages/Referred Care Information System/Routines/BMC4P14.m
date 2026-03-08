BMC4P14 ;IHS/OIT/FCJ - BMC 4.0 PATCH 14 ; 16 Feb 2011  2:54 PM
 ;;4.0;REFERRED CARE INFO SYSTEM;**14**;JAN 09, 2006;Build 111
 ;
INSTALLD(BMC) ; Determine if patch BMC was installed, where BMC is
 ; the name of the INSTALL.  E.g "AVA*93.2*12".
 NEW DIC,X,Y
 ;  lookup package.
 S X=$P(BMC,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 ;  lookup version.
 S DIC=DIC_+Y_",22,",X=$P(BMC,"*",2)
 D ^DIC
 I Y<1 Q 0
 ;  lookup patch.
 S DIC=DIC_+Y_",""PAH"",",X=$P(BMC,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
 ; -----------------------------------------------------
PRE ;EP - From KIDS.
 I $$NEWCP^XPDUTL("PRE1","AUDS^BMC4E")
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
 ;
POST ;EP - From KIDS.
 ;Add BUSA entries
 I $D(^BUSA(9002319.03,0)) D
 . ;BMC ADD REFERRAL
 . I $O(^BUSA(9002319.03,"B","BMC ADD REFERRAL",""))="" D
 .. NEW DIC,X,DLAYGO,Y,DTOUT,DIRUT,DUOUT,BUSAUPD,DA,ERROR
 .. S DIC(0)="L",DIC="^BUSA(9002319.03,"
 .. L +^BUSA(9002319.03,0):1 E  Q
 .. S X="BMC ADD REFERRAL",DLAYGO=9002319.03
 .. K DO,DD D FILE^DICN
 .. L -^BUSA(9002319.03,0)
 .. I +Y<0 Q
 .. S DA=+Y
 .. S BUSAUPD(9002319.03,DA_",",.02)="P",BUSAUPD(9002319.03,DA_",",.03)="A"
 .. S BUSAUPD(9002319.03,DA_",",.06)="S X=""BMC: Created patient referral"""
 .. S BUSAUPD(9002319.03,DA_",",1.01)="I~2",BUSAUPD(9002319.03,DA_",",2.01)="I~32"
 .. D FILE^DIE("","BUSAUPD","ERROR")
 . ;BMC UPDATE REFERRAL
 . I $O(^BUSA(9002319.03,"B","BMC UPDATE REFERRAL",""))="" D
 .. NEW DIC,X,DLAYGO,Y,DTOUT,DIRUT,DUOUT,BUSAUPD,DA,ERROR
 .. S DIC(0)="L",DIC="^BUSA(9002319.03,"
 .. L +^BUSA(9002319.03,0):1 E  Q
 .. S X="BMC UPDATE REFERRAL",DLAYGO=9002319.03
 .. K DO,DD D FILE^DICN
 .. L -^BUSA(9002319.03,0)
 .. I +Y<0 Q
 .. S DA=+Y
 .. S BUSAUPD(9002319.03,DA_",",.02)="P",BUSAUPD(9002319.03,DA_",",.03)="E"
 .. S BUSAUPD(9002319.03,DA_",",.06)="S X=""BMC: Update patient referral"""
 .. S BUSAUPD(9002319.03,DA_",",1.01)="I~1"
 .. S BUSAUPD(9002319.03,DA_",",1.02)="S X=$$GET1~DIQ(90001,X_"","",.03,""I"")"
 .. S BUSAUPD(9002319.03,DA_",",2.01)="I~1"
 .. S BUSAUPD(9002319.03,DA_",",2.02)="S X=$$GET1~DIQ(90001,X_"","",1309,""I"")"
 .. D FILE^DIE("","BUSAUPD","ERROR")
 ;
 ; --- Restore dd audit settings.
 S %="AUDR^BMC4E"
 I $$NEWCP^XPDUTL("POS1-"_%,%)
 ; ---Update Gen Ret file
 S %="P14^BMC4P14"
 I $$NEWCP^XPDUTL("POS12-"_%,%)
 ; --- Send mail message of install.
 S %="MAIL^BMC4E"
 I $$NEWCP^XPDUTL("POS13-"_%,%)
 Q
 ;
P14 ;Patch 14
 ;S BMC="BMC*4.0*14" Q:$$INSTALLD(BMC)
 ;update GEN RET option CHS Dt PO Added
 NEW DA,DIE,DIC,DR
 S X="CHS Dt PO Added",(DIC,DIE)="^BMCTSORT("
 D ^DIC
 I +Y<0 D BMES^XPDUTL("Unable to update CHS Dt PO Added item from Gen Ret Report list . . .")
 S DA=+Y
 S DR="3////"_"F  S BMCX=$O(^BMCREF(BMCREF,41,BMCX)) Q:BMCX'=+BMCX  S BMCPCNT=BMCPCNT+1,BMCDT=$P($G(^BMCREF(BMCREF,41,BMCX,11)),U,2)"
 S DR=DR_" Q:BMCDT'?1N.N  S Y=BMCDT D DT^BMCRUTL S BMCDT=Y,BMCPRNM(BMCPCNT)=BMCDT"
 D ^DIE
 D BMES^XPDUTL("CHS Dt PO Added item updated in Gen Ret items . . .")
 K DA,DIE,DIC,DR
 Q
