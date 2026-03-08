BJPC2P24 ; IHS/CMI/LAB - PCC Suite v2.0 
 ;;2.0;IHS PCC SUITE;**24**;MAY 14, 2009;Build 21
 ;
 ;
 ; The following line prevents the "Disable Options..." and "Move Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 ;KERNEL
 I '$$INSTALLD("XU*8.0*1018") D MES^XPDUTL($$CJ^XLFSTR("Requires Kernel v8 patch 1018.  Not installed.",80)) D SORRY(2)
 I '$$INSTALLD("DI*22.0*1018") D MES^XPDUTL($$CJ^XLFSTR("Requires Fileman v22 patch 1018.  Not installed.",80)) D SORRY(2)
 I '$$INSTALLD("BJPC*2.0*23") D MES^XPDUTL($$CJ^XLFSTR("Requires BJPC V2.0 patch 23.  Not installed.",80)) D SORRY(2)
 I '$$INSTALLD("AUT*98.1*29") D MES^XPDUTL($$CJ^XLFSTR("Requires AUT V98.1 patch 29.  Not installed.",80)) D SORRY(2)
 ;
 Q
 ;
PRE ;
 Q
POST ;
 ;
 D MES^XPDUTL("RE-INDEXING V PROCEDURE MAP X-REF...THIS MAY TAKE A FEW MINUTES...")
 S BJPCX=0
 F  S BJPCX=$O(^AUPNVPRC(BJPCX)) Q:BJPCX'=+BJPCX  D
 .Q:'$D(^AUPNVPRC(BJPCX,0))
 .Q:'$D(^AUPNVPRC(BJPCX,26))  ;never had a mapping
 .S DA=BJPCX
 .D PRC^AUPNMAP W:'(BJPCX#10000) "."
 Q
INSTALLD(BJPCSTAL) ;EP - Determine if patch BJPCSTAL was installed, where
 ; APCLSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW BJPCY,DIC,X,Y
 S X=$P(BJPCSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(BJPCSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(BJPCSTAL,"*",3)
 D ^DIC
 S BJPCY=Y
 D IMES
 Q $S(BJPCY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_BJPCSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
