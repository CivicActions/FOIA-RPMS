BGPLP2 ; IHS/CMI/LAB - POST INIT  ; 
 ;;19.1;IHS CLINICAL REPORTING;**2**;MAY 30, 2019;Build 10
 ;
 ;
 ;SEND OUT BGP TAXONOMIES
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 ;;I '$$INSTALLD("BGP*18.1*1") D MES^XPDUTL($$CJ^XLFSTR("CRS v18.1 patch 1 is required.  Not installed.",80)) D SORRY(2)
 I '$$INSTALLD("XU*8.0*1018") D SORRY(2)
 I '$$INSTALLD("DI*22.0*1018") D SORRY(2)
 I '$$INSTALLD("BGP*19.1*1") D SORRY(2)
 ;I +$$VERSION^XPDUTL("BGP")<19.1 D MES^XPDUTL($$CJ^XLFSTR("Version 19.1 of the IHS CLINICAL REPORTING is required.  Not installed.",80)) D SORRY(2) I 1
 Q
 ;
PRE ;EP
 Q
POST ;EP - called from kids build
 D ^BGPL8
 Q
BMXPO ;-- update the RPC file
 N BGPRPC
 S BGPRPC=$O(^DIC(19,"B","BGPGRPC",0))
 Q:'BGPRPC
 D CLEAN(BGPRPC)
 D GUIEP^BMXPO(.RETVAL,BGPRPC_"|BGP")
 D GUIEP^BMXPO(.RETVAL,BGPRPC_"|ATX")
 Q
CLEAN(APP) ;-- clean out the RPC multiple first
 S DA(1)=APP
 S DIK="^DIC(19,"_DA(1)_","_"""RPC"""_","
 N BGPDA
 S BGPDA=0 F  S BGPDA=$O(^DIC(19,APP,"RPC",BGPDA)) Q:'BGPDA  D
 . S DA=BGPDA
 . D ^DIK
 K ^DIC(19,APP,"RPC","B")
 Q
 ;
INSTALLD(BGPSTAL) ;EP - Determine if patch BGPSTAL was installed, where
 ; BGPSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW BGPY,DIC,X,Y
 S X=$P(BGPSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(BGPSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(BGPSTAL,"*",3)
 D ^DIC
 S BGPY=Y
 D IMES
 Q $S(BGPY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_BGPSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
