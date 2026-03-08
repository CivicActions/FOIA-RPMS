BSDP23PS ;IHS/CMI/FBD - PIMS Patch 1023 Post Init and Environment
 ;;5.3;PIMS;**1023**;MAY 28, 2004;Build 24
 ;
 ;
ENV ;-- environment check
 I '$$INSTALLD("XU*8.0*1018") D SORRY(2)
 I '$$INSTALLD("DI*22.0*1018") D SORRY(2)
 I '$$INSTALLD("AUPN*99.1*29") D SORRY(2)
 I '$$INSTALLD("PIMS*5.3*1022") D SORRY(2)
 Q
 ;
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
POST ;-- post init
 N MCD
 D BMES^XPDUTL("PIMS v5.3 Patch 1023 Post-install starting...")
 ;If no "CENSUS RECALC FROM LIMIT (YRS)" field (#401) value already present, set to default of 3 years
 S MCD=0  ;MEDICAL CENTER DIVISION
 F  S MCD=$O(^BDGPAR(MCD)) Q:MCD'=+MCD  D  ;ENSURE DEFAULT SET FOR ALL MEDICAL CENTER DIVISIONS
 . I '+$G(^BDGPAR(MCD,4)) D  ;SET ONLY IF PARAMETER NOT ALREADY DEFINED
 . . S DIE="^BDGPAR("
 . . S DA=MCD
 . . S DR="401///3"  ;DEFAULT BACK-CALC LIMIT = 3 YEARS
 . . D ^DIE
 . . D BMES^XPDUTL("Census recalc limit defined for all medical center divisions...")
 ;
 D BMES^XPDUTL("Delivering MailMan message to select users...")
 D MAIL
 D BMES^XPDUTL("PIMS v5.3 Patch 1023 Post-install routine complete.")
 Q
 ;
MAIL ; Send install mail message.
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("BSDP1023",$J)
 S ^TMP("BSDP1023",$J,1)=" --- PIMS v5.3 Patch 1023 has been installed into this uci ---"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   S ^TMP("BSDP1023",$J,(%+1))=" "_^(%,0)
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""BSDP1023"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("BSDP1023",$J)
 Q
 ;
SINGLE(K) ;----- GET HOLDERS OF A SINGLE KEY K.
 Q:'$D(^XUSEC(K))
 N Y S Y=0 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
