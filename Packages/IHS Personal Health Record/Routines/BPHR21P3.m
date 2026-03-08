BPHR21P3 ;GDIT/HC/BEE-Version 2.1 Patch 3 ; 28 Jun 2016  3:35 PM
 ;;2.1;IHS PERSONAL HEALTH RECORD;**3**;Apr 01, 2014;Build 5
 ;
ENV ;EP - Environment check
 ;
 ;
 ;Check for AMER*3.0*9
 I '$$INSTALLD("BPHR*2.1*2") D BMES^XPDUTL("Version 2.1 Patch 2 of BPHR is required!") S XPDQUIT=2 Q
 ;
 Q
 ;
EN ;EP - Postinstall
 NEW ERR,CONN
 ;
 ; Import BPHR classes
 D IMPORT^BPHRCLAS(1,.ERR)
 I $G(ERR) Q
 ;
 ;Define service paths
 F CONN=1,2 D
 . NEW BPHRUPD,ERROR,OURL
 . ;
 . ;Get regular PHR root
 . S OURL=$$GET1^DIQ(90670.2,CONN_",",.02)
 . ;
 . ;MEDREFILL URL ROOT - Copy from original
 . S BPHRUPD(90670.2,CONN_",",6.01)=OURL
 . ;
 . ;MEDREFILL SERVICE PATH
 . S BPHRUPD(90670.2,CONN_",",6.02)="/PharmacyRefillRequest/medicalRefillRequest"
 . D FILE^DIE("","BPHRUPD","ERROR")
 ;
 ;Schedule the option to run every 4 hours
 D RESCH^XUTMOPT("BPHR MEDICATION REFILL TASK","T+1@2200","","4H","L")
 ;
 Q
 ;
PRE ;EP - Preinstall
 NEW DA,DIK
 ;
 ;Clear out transport global
 S DIK="^BPHRCLS("
 S DA=0 F  S DA=$O(^BPHRCLS(DA)) Q:'DA  D ^DIK
 Q
 ;
INSTALLD(BPHRSTAL) ;EP - Determine if patch BPHRSTAL was installed, where
 ;BPHRSTAL is the name of the INSTALL.  E.g "BPHR*2.1*1"
 ;
 NEW DIC,X,Y,D
 S X=$P(BPHRSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",22,",X=$P(BPHRSTAL,"*",2)
 D ^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(BPHRSTAL,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
