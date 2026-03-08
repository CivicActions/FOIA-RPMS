XT731019 ;IHS/OIT/FBD-XT*7.3*1019 Environmental Checking and Post Install; 03/20/2020
 ;;8.0;KERNEL;**1019**;Jul 10, 1995;Build 5
 ;
ENV ;ENVIROMENT CHECK
 ;
 NEW X,IORVON,IORVOFF
 ;
 I '$G(IOM) D HOME^%ZIS
 ;
 I '$G(DUZ) D MES^XPDUTL("No user identification specified; aborting.") D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) D MES^XPDUTL("No FileMan access code specified; aborting.") D SORRY(2) Q
 ;
 I '$L($G(DUZ(2))) D MES^XPDUTL("No user location specified; aborting.") D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM)
 ;
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 ;
 I '$$INSTALLD("XT*7.3*1018") D SORRY(2)
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(3)
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ;
POST ;EP - XT V7.3 PATCH 1019 POST-INIT
 ;
 NEW PIEN,DIFROM,XMSUB,XMDUZ,XMTEXT,XMY,%
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("Beginning XT v7.3 patch 1019 post-init process.",80))
 D BMES^XPDUTL("Delivering XT*7.3*1019 install message to select users...")
 KILL ^TMP("XT731019",$J)
 S ^TMP("XT731019",$J,1)=" --- XU v 7.3, Patch 1019, has been installed into this uci ---"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   S ^TMP("XT731019",$J,(%+1))=" "_^(%,0)
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""XT731019"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("XT731019",$J)
 Q
 ;
SINGLE(K) ; Get holders of a single key K.
 NEW Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
INSTALLD(AUPNSTAL) ;EP - Determine if patch AUPNSTAL was installed, where
 ; AUPNSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW AUPNY,DIC,X,Y,D
 S X=$P(AUPNSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(AUPNSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(AUPNSTAL,"*",3)
 D ^DIC
 S AUPNY=Y
 D IMES
 Q $S(AUPNY<1:0,1:1)
 ;
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_AUPNSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
