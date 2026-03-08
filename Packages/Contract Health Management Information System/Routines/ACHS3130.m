ACHS3130 ;IHS/OIT/FCJ - ACHS 3.1 PATCH 30 ;7/30/10  08:37
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**30**;JUNE 11,2001;Build 14
 ;IHS/OIT/FCJ - COPY OF P28
 ;ENV CHECK TO ACHS31E1
 ;
PRE ;EP - From KIDS.
 I $$NEWCP^XPDUTL("PRE1","AUDS^ACHS3130")
 Q
 ;
POST ;EP - From KIDS.
 ;
 ;PATCH 30 New report options
 S %="P30^ACHS3130"
 I $$NEWCP^XPDUTL("POS6-"_%,%)
 ;
 ;PATCH 30 New report options
 S %="OPT30^ACHS3130"
 I $$NEWCP^XPDUTL("POS6-"_%,%)
 ;
 ; --- Restore dd audit settings.
 S %="AUDR^ACHS3130"
 I $$NEWCP^XPDUTL("POS7-"_%,%)
 ;
 ; --- Send mail message of install.
 S %="MAIL^ACHS3130"
 I $$NEWCP^XPDUTL("POS8-"_%,%)
 ;
 Q
MAIL ;
 D BMES^XPDUTL("BEGIN Delivering MailMan message to select users.")
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("ACHS3130",$J)
 D RSLT(" --- ACHS v 3.1 Patch 29, has been installed into this namespace ---")
 F %=1:1 D RSLT($P($T(GREET+%),";",3)) Q:$P($T(GREET+%+1),";",3)="###"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D RSLT(^(%,0))
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""ACHS3130"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="ACHSZMENU","XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("ACHS3130",$J)
 D MES^XPDUTL("END Delivering MailMan message to select users.")
 Q
 ;
RSLT(%) S ^(0)=$G(^TMP("ACHS3130",$J,0))+1,^(^(0))=%
 Q
 ;
SINGLE(K) ; Get holders of a key
 NEW Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
GREET ;;To add to mail message.
 ;;  
 ;;Standard Routines on your RPMS system have been updated.
 ;;  
 ;;You are receiving this message because of the RPMS
 ;;security keys that you hold.  This is for your information.
 ;;Do not respond to this message.
 ;;  
 ;;Questions about this patch may be directed to
 ;;the ITSC Support Center, at 505-248-4297,
 ;;refer to patch "ACHS*3.1*29".
 ;;  
 ;;###;NOTE: This line end of text.
 ; ---------------------------------------------
 ; The global location for dictionary audit is:
 ;           ^DD(FILE,0,"DDA")
 ; value = "Y", dd audit is on.  Any other value, or the
 ; absence of the node, means dd audit is off.
 ;
AUDS ;EP - From KIDS.
 D BMES^XPDUTL("Saving current DD AUDIT settings for files in this patch")
 D MES^XPDUTL("and turning DD AUDIT to 'Y'.")
 S ^XTMP("ACHS3130",0)=$$FMADD^XLFDT(DT,10)_"^"_DT_"^"_$P($P($T(+1),";",2)," ",3,99)
 NEW ACHS
 S ACHS=0
 F  S ACHS=$O(^XTMP("XPDI",XPDA,"FIA",ACHS)) Q:'ACHS  D
 . I '$D(^XTMP("ACHS3130",ACHS,"DDA")) S ^XTMP("ACHS3130",ACHS,"DDA")=$G(^DD(ACHS,0,"DDA"))
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(ACHS,12)_" - "_$$LJ^XLFSTR(^XTMP("XPDI",XPDA,"FIA",ACHS),30)_"- DD audit was '"_$G(^XTMP("ACHS3130",ACHS,"DDA"))_"'"),MES^XPDUTL($$RJ^XLFSTR("Set to 'Y'",69))
 . S ^DD(ACHS,0,"DDA")="Y"
 D MES^XPDUTL("DD AUDIT settings saved in ^XTMP(.")
 Q
 ;
AUDR ; Restore the file data audit values to their original values.
 D BMES^XPDUTL("Restoring DD AUDIT settings for files in this patch.")
 NEW ACHS
 S ACHS=0
 F  S ACHS=$O(^XTMP("ACHS3130",ACHS)) Q:'ACHS  D
 . S ^DD(ACHS,0,"DDA")=^XTMP("ACHS3130",ACHS,"DDA")
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(ACHS,12)_" - "_$$LJ^XLFSTR($$GET1^DID(ACHS,"","","NAME"),30)_"- DD AUDIT Set to '"_^DD(ACHS,0,"DDA")_"'")
 .Q
 KILL ^XTMP("ACHS3130")
 D MES^XPDUTL("DD AUDIT settings restored.")
 Q
 ;
P30 ;
INDX30 ;NEW INDEX FOR CHS TX STATUS FILE
 N ACHSX,ACHSXIEN
 D BMES^XPDUTL("BEGIN Re-index of Patient field in the CHS CHEF REGISTRY  file.")
 S ACHSX=0 F  S ACHSX=$O(^ACHSCHEF(ACHSX)) Q:ACHSX'?1N.N  D
 .K ^ACHSCHEF(ACHSX,"C")
 .S ACHSXIEN=0
 .F  S ACHSXIEN=$O(^ACHSCHEF(ACHSX,1,ACHSXIEN)) Q:ACHSXIEN'?1N.N  D
 ..Q:$P($G(^ACHSCHEF(ACHSX,1,ACHSXIEN,0)),U,2)=""
 ..S ^ACHSCHEF("C",$P(^ACHSCHEF(ACHSX,1,ACHSXIEN,0),U,2),ACHSX,ACHSXIEN)="" W "."
 D MES^XPDUTL("END Re-index of Date Export Processed in CHS TX Status file.")
 Q
OPT30 ;ADD NEW OPTIONS
 D BMES^XPDUTL("Begin adding new options.")
 I $$ADD^XPDMENU("ACHS MENU EXPORT","ACHSTX VIEW EPOV","VEPO",10)
 I $$ADD^XPDMENU("ACHS E-SIG MENU","ACHS E-SIG AUTHORIZING OFC.","SIGA",5) D MES^XPDUTL($J("",5)_"Added Authorizing e-signature option")
 I $$ADD^XPDMENU("ACHS E-SIG MENU","ACHS E-SIG DENIAL OFFICIAL","SIGD",10) D MES^XPDUTL($J("",5)_"Added Denial e-signature option")
 I $$ADD^XPDMENU("ACHS E-SIG MENU","ACHS E-SIG ORDERING OFC.","SIGO",15) D MES^XPDUTL($J("",5)_"Added Ordering e-signature option")
 D MES^XPDUTL("END updating options.")
OPTEX ;UPDATE OPTIONS FOR ESIG DISPLAY
 N DIE,DA
 S DIE="^DIC(19,"
 F I="ACHSAA","ACHSPAYMENU","ACHSRA","ACHSOA","ACHSDA","ACHSMGP","ACHSAD","ACHSOD","ACHSMGR","ACHS E-SIG MENU","ACHS PG OPTIONS" D
 .S IEN=0,IEN=$O(^DIC(19,"B",I,IEN))
 .S DA=IEN,DR="15////D PHDR^ACHS,ESIG^ACHS" D ^DIE
 S I="ACHS DEFDEN MENU" S IEN=0,IEN=$O(^DIC(19,"B",I,IEN))
 S DA=IEN,DR="15////D PHDR^ACHS,^XBFMK,ESIG^ACHS" D ^DIE
 S I="ACHSMENU" S IEN=0,IEN=$O(^DIC(19,"B",I,IEN))
 S DA=IEN,DR="20////D ISMGR^ACHS(DUZ) S LEVEL=0 D LOGO^ACHS,^ACHSVAR,ESIG^ACHS" D ^DIE
 Q
 ;
