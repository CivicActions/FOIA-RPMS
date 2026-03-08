BCH20P1 ; IHS/CMI/LAB - PATCH 1 ; 
 ;;2.0;IHS RPMS CHR SYSTEM;**1**;OCT 23, 2012;Build 6
 ;
ENV ;-- environment check
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I '$$INSTALLD("XU*8.0*1018") D SORRY(2)
 I '$$INSTALLD("DI*22.0*1018") D SORRY(2)
 I +$$VERSION^XPDUTL("BCH")<2 D MES^XPDUTL($$CJ^XLFSTR("Version 2.0 of the CHR REPORTING SYSTEM is required.  Not installed.",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("CHR (BCH) Version 2.0 is installed.",80))
 Q
 ;
PRE ;
 Q
INSTALLD(BDGSTAL) ;EP - Determine if patch BDGSTAL was installed, where
 ; BDGSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW BDGY,DIC,X,Y
 S X=$P(BDGSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(BDGSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 I $P(BDGSTAL,"*",3)="" D IMES Q 1
 S DIC=DIC_+Y_",""PAH"",",X=$P(BDGSTAL,"*",3)
 D ^DIC
 S BDGY=Y
 D IMES
 Q $S(BDGY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_BDGSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" Present.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ;
POST ;post init
 S DA=$O(^BCHSORT("B","Patient SSN",0))
 I DA S DIK="^BCHSORT(" D ^DIK
 Q
