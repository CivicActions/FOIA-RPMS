BJPC2P26 ; IHS/CMI/LAB - PCC Suite v2.0 PATCH 25 PRE/POST INIT
 ;;2.0;IHS PCC SUITE;**26**;MAY 14, 2009;Build 48
 ;
 ;
 ; The following line prevents the "Disable Options..." and "Move Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 ;KERNEL
 I '$$INSTALLD("XU*8.0*1018") D SORRY(2)
 I '$$INSTALLD("DI*22.0*1018") D SORRY(2)
 I '$$INSTALLD("BJPC*2.0*25") D MES^XPDUTL($$CJ^XLFSTR("Requires BJPC V2.0 patch 25.  Not installed.",80)) D SORRY(2)
 ;
 Q
 ;
PRE ;
 Q
POST ;
 S X=$$ADD^XPDMENU("APCDCAF EHR CODING AUDIT MENU","APCDCAF RESOLVED CHARTS","RCPD")
 I 'X W !,"Attempt to add RESOLVED CHART option failed.." H 3
 S X=$$ADD^XPDMENU("APCDSUPER","APCD CPT BY REV/USER","CPTV")
 I 'X W !,"Attempt to add CPT CODING OPTION option failed.." H 3
 S DA=0 F  S DA=$O(^APCDSITE(DA)) Q:DA'=+DA  I $P(^APCDSITE(DA,0),U,39)="" S $P(^APCDSITE(DA,0),U,39)=0
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
 Q
