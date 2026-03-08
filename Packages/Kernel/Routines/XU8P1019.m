XU8P1019 ;GDIT/HS/BEE-XU*8.0*1019 Environmental Checking and Post Install;29-May-2019 09:45;du
 ;;8.0;KERNEL;**1019**;Jul 10, 1995;Build 10
 ;
ENV ;ENVIROMENT CHECK
 ;
 NEW X,IORVON,IORVOFF
 ;
 I '$G(IOM) D HOME^%ZIS
 ;
 I '$G(DUZ) D MES^XPDUTL("No valid user identification found; aborting.") D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) D MES^XPDUTL("No valid user location found; aborting.") D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM)
 ;
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 ;
 I '$$INSTALLD("XU*8.0*1018") D SORRY(2)
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
PRE D SKMDEL("XUEPCSEDIT")
 Q
 ;
POST ;EP - XU V8.0 PATCH 1019 POST-INIT
 ;
 NEW PIEN,DIFROM,XMSUB,XMDUZ,XMTEXT,XMY,%
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("Beginning XU v8.0 patch 1019 post-init process.",80))
 ;
 ;Set up new XUS,PROXY USER entry
 S PIEN=$O(^VA(200,"B","XUS,PROXY USER","")) I PIEN="" D
 . NEW X,DIC,Y,VAUPD,USCLS,DIEN,DA
 . S DIC="^VA(200,",DIC(0)="LX"
 . S X="XUS,PROXY USER"
 . D ^DIC
 . I '+Y Q
 . S DIEN=+Y
 . ;
 . ;Set up User Class
 . S USCLS=$O(^VA(201,"B","APPLICATION PROXY","")) Q:USCLS=""
 . I $D(^VA(200,DIEN,"USC3","B",USCLS)) Q
 . S DIC(0)="LX",DIC="^VA(200,"_DIEN_",""USC3"","
 . S X="APPLICATION PROXY",DA(1)=DIEN
 . D ^DIC
 ;
 D BMES^XPDUTL("Delivering XU*8.0*1019 install message to select users...")
 KILL ^TMP("XU8P1019",$J)
 S ^TMP("XU8P1019",$J,1)=" --- XU v 8.0, Patch 1019, has been installed into this uci ---"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   S ^TMP("XU8P1019",$J,(%+1))=" "_^(%,0)
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""XU8P1019"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("XU8P1019",$J)
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
 ;-
SKMDEL(KEYNM) ;
 N IEN
 S IEN=$O(^DIC(19.1,"B",KEYNM,0))
 Q:'IEN
 K ^DIC(19.1,IEN,1)  ;Remove description text
 K ^DIC(19.1,IEN,5)  ;Remove Mutually Exclusive keys
 Q
