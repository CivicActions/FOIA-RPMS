ACHS3129 ;IHS/OIT/FCJ - ACHS 3.1 PATCH 29 ;7/30/10  08:37
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**29**;JUNE 11,2001;Build 86
 ;IHS/OIT/FCJ - COPY OF P28
 ;ENV CHECK TO ACHS31E1
 ;
PRE ;EP - From KIDS.
 I $$NEWCP^XPDUTL("PRE1","AUDS^ACHS3129")
 Q
 ;
POST ;EP - From KIDS.
 ;
 ;PATCH 21 AREA UPDATES
 S %="P21^ACHS3129"
 I $$NEWCP^XPDUTL("POS2-"_%,%)
 ;
 ;PATCH 22 NEW ICD9 REPORT MENU OPTION
 S %="P22^ACHS3129"
 I $$NEWCP^XPDUTL("POS3-"_%,%)
 ;
 ;PATCH 24 Set ICD10 Parameters
 S %="P24^ACHS3129"
 I $$NEWCP^XPDUTL("POS4-"_%,%)
 ;
 ;PATCH 25 Clean up the option
 S %="P25^ACHS3129"
 I $$NEWCP^XPDUTL("POS5-"_%,%)
 ;
 ;PATCH 26 New report options
 S %="P26^ACHS3129"
 I $$NEWCP^XPDUTL("POS6-"_%,%)
 ;
 ;PATCH 28 New report options
 S %="P28^ACHS3129"
 I $$NEWCP^XPDUTL("POS6-"_%,%)
 ;
 ;PATCH 29 New report options
 S %="P29^ACHS3129"
 I $$NEWCP^XPDUTL("POS6-"_%,%)
 ;
 ; --- Restore dd audit settings.
 S %="AUDR^ACHS3129"
 I $$NEWCP^XPDUTL("POS7-"_%,%)
 ;
 ; --- Send mail message of install.
 S %="MAIL^ACHS3129"
 I $$NEWCP^XPDUTL("POS8-"_%,%)
 ;
 Q
MAIL ;
 D BMES^XPDUTL("BEGIN Delivering MailMan message to select users.")
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("ACHS3129",$J)
 D RSLT(" --- ACHS v 3.1 Patch 29, has been installed into this namespace ---")
 F %=1:1 D RSLT($P($T(GREET+%),";",3)) Q:$P($T(GREET+%+1),";",3)="###"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D RSLT(^(%,0))
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""ACHS3129"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="ACHSZMENU","XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("ACHS3129",$J)
 D MES^XPDUTL("END Delivering MailMan message to select users.")
 Q
 ;
RSLT(%) S ^(0)=$G(^TMP("ACHS3129",$J,0))+1,^(^(0))=%
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
 S ^XTMP("ACHS3129",0)=$$FMADD^XLFDT(DT,10)_"^"_DT_"^"_$P($P($T(+1),";",2)," ",3,99)
 NEW ACHS
 S ACHS=0
 F  S ACHS=$O(^XTMP("XPDI",XPDA,"FIA",ACHS)) Q:'ACHS  D
 . I '$D(^XTMP("ACHS3129",ACHS,"DDA")) S ^XTMP("ACHS3129",ACHS,"DDA")=$G(^DD(ACHS,0,"DDA"))
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(ACHS,12)_" - "_$$LJ^XLFSTR(^XTMP("XPDI",XPDA,"FIA",ACHS),30)_"- DD audit was '"_$G(^XTMP("ACHS3129",ACHS,"DDA"))_"'"),MES^XPDUTL($$RJ^XLFSTR("Set to 'Y'",69))
 . S ^DD(ACHS,0,"DDA")="Y"
 D MES^XPDUTL("DD AUDIT settings saved in ^XTMP(.")
 Q
 ;
AUDR ; Restore the file data audit values to their original values.
 D BMES^XPDUTL("Restoring DD AUDIT settings for files in this patch.")
 NEW ACHS
 S ACHS=0
 F  S ACHS=$O(^XTMP("ACHS3129",ACHS)) Q:'ACHS  D
 . S ^DD(ACHS,0,"DDA")=^XTMP("ACHS3129",ACHS,"DDA")
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(ACHS,12)_" - "_$$LJ^XLFSTR($$GET1^DID(ACHS,"","","NAME"),30)_"- DD AUDIT Set to '"_^DD(ACHS,0,"DDA")_"'")
 .Q
 KILL ^XTMP("ACHS3129")
 D MES^XPDUTL("DD AUDIT settings restored.")
 Q
 ;
P21 ;PATCH 21
 ;REMOVE 2 SPLITOUT MENU OPT NOW COMBINED WITH THE PROCESSING OPTIONS
 Q:$$INSTALLD^ACHS31E1("ACHS*3.1*21")
 D BMES^XPDUTL("Begin Removing split out options.")
 I $$DELETE^XPDMENU("ACHSAREA","ACHSAREA SP/EX") D MES^XPDUTL($J("",5)_"Removed Option: Area CHS Splitout / Export To HAS/FI/CORE")
 I $$DELETE^XPDMENU("ACHSAREAEOBRPROC","ACHSAREAEOBROUT") D MES^XPDUTL($J("",5)_"Remove Option: Area CHS Generate Facility EOBR Files")
 D MES^XPDUTL("END updating options.")
 ;SET PRINT EOBR PARAMETER TO NO
 S ACHS=0
 F  S ACHS=$O(^ACHSF("B",ACHS)) Q:ACHS'?1N.N  D
 .S DA=ACHS,DIE="^ACHSF("
 .S DR="14.14///N"
 .D ^DIE
 Q
 ;
P22 ;PATCH 22
 Q:$$INSTALLD^ACHS31E1("ACHS*3.1*22")
 ;ADD NEW OPTIONS - P22-ICD9 REPORT OPTION
 D BMES^XPDUTL("Begin adding new option.")
 I $$ADD^XPDMENU("ACHSREPORTS","ACHSRPTICDERROR","ICDR") D MES^XPDUTL($J("",5)_"Added ICD9 Report - to reports option")
 D MES^XPDUTL("END updating options.")
 ;SET UP ICD GLOBALS
 D SET^ACHSIC2
 Q
 ;
P24 ;PATCH 24
 Q:$$INSTALLD^ACHS31E1("ACHS*3.1*24")
 ;ADD ICD START DATE IN PARAMETERS
 D BMES^XPDUTL("Checking/Updating ICD10 PARAMETERS.")
 S L=0
 F  S L=$O(^ACHSF(L)) Q:L'?1N.N  D
 .S $P(^ACHSF(L,0),U,17,18)="3151001^3151001"
 ;
 D MES^XPDUTL("END updating Parameters.")
 K L
 Q
 ;
P25 ;PATCH 25
 Q:$$INSTALLD^ACHS31E1("ACHS*3.1*25")
 Q:'$D(^DIC(19,"B","ACHS DEN REP-CARE NOT MED PRI"))
 S L=0,L=$O(^DIC(19,"B","ACHS DEN REP-CARE NOT MED PRI",L))
 S (^DIC(19,L,20),^DIC(19,L,60),^DIC(19,L,62),^DIC(19,L,63),^DIC(19,L,64),^DIC(19,L,69))=""
 Q
P26 ;PATCH 26
 Q:$$INSTALLD^ACHS31E1("ACHS*3.1*26")
 ;ADD NEW REPORT OPTIONS
 D BMES^XPDUTL("Begin adding new option.")
 I $$ADD^XPDMENU("ACHSREPORTS","ACHS MENU SPEC REPORTS","SPEC") D MES^XPDUTL($J("",5)_"Added Special Reports option")
 I $$ADD^XPDMENU("ACHS MENU SPEC REPORTS","ACHSDOCSTATUSREPFY-FILE","DSFY") D MES^XPDUTL($J("",5)_"Added Document Status Report by FY with option to create file")
 I $$ADD^XPDMENU("ACHS MENU SPEC REPORTS","ACHSDOCSTATUSREPFYTOT","DSFT") D MES^XPDUTL($J("",5)_"Added Document Status Report with totals by FY selected")
 I $$ADD^XPDMENU("ACHS MENU SPEC REPORTS","ACHS REPORT DOS","DOSR") D MES^XPDUTL($J("",5)_"Added Report for Estimated and Actual DOS with issue date")
 I $$ADD^XPDMENU("ACHS MENU SPEC REPORTS","ACHSDOCSTATUSSPLOC","DSSP") D MES^XPDUTL($J("",5)_"Added Document Status Report for Special local PO's")
 I $$ADD^XPDMENU("ACHS MENU SPEC REPORTS","ACHSDOCSTATUSREPEOBR","DSEB") D MES^XPDUTL($J("",5)_"Added Document Status Report for Paid PO's with EOBR date")
 I $$ADD^XPDMENU("ACHS MENU VENDOR REPORTS","ACHSVNDRUSAGE-SPECIFIC","VURS") D MES^XPDUTL($J("",5)_"Added Vendor Usage Report by Vendor with option to create file")
 I $$ADD^XPDMENU("ACHS MENU VENDOR REPORTS","ACHSVNDRUSAGEFY","VFY") D MES^XPDUTL($J("",5)_"Added FY Vendor usage report by selected Vendor")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU DEN REPORTS","ACHS DEN PVDRLIST-SPECIFIED","PVDS") D MES^XPDUTL($J("",5)_"Added Denial Report by selected Vendor")
 I $$ADD^XPDMENU("ACHSAD","ACHSDOCUMENTTRANS","TRD") D MES^XPDUTL($J("",5)_"Added Document Transaction report")
 D MES^XPDUTL("END updating options.")
 ;ADD ENTRY TO ZISH PARAMETER FILE
 S X="ACHS REPORTS",DIC="^%ZIB(9888888.93,",DIC(0)="L"
 D ^DIC
 I Y<0 W !,"ZISH SEND PARAMETER FOR THE ACHS UFMS ENTRY COULD NOT BE ADDED, YOU WILL NEED TO THROUGH FILEMAN" Q
 S DA=+Y,DIE=DIC
 S DR=".07////"_"B"_";.08////"_"sendto"
 D ^DIE
 K D,D0,D1,DI,DIADD,DIC,DICR,DIE,DLAYGO,DQ,DR,DINUM,DA
P28 ;PATCH 28
 ;^ACHSEOBE("EOBD",CLEAN UP OF OLD EOBR ERROR AND CHEF FILE; KEEP 10 YEARS OF DATA
 Q:$$INSTALLD^ACHS31E1("ACHS*3.1*28")
 S ACHSTMP=(17000000+DT)-100001,L=0
 W !,"Cleaning up CHS NON-PROCESSED EOBR and CHS CHEF REGISTRY file"
 F  S L=$O(^ACHSEOBE("EOBD",L)) Q:(L'?1N.N)!(L>ACHSTMP)  D
 .S DA=0 F  S DA=$O(^ACHSEOBE("EOBD",L,DA)) Q:DA'?1N.N  D
 ..S DIK="^ACHSEOBE(" D ^DIK
 ;CHEF
 N ACHS,DA,DIK,FAC
 S FAC=0 F  S FAC=$O(^ACHSCHEF("B",FAC)) Q:FAC'?1N.N  D
 .S ACHSCHEF=0 F  S ACHSCHEF=$O(^ACHSCHEF(FAC,1,ACHSCHEF)) Q:ACHSCHEF'?1N.N  D
 ..S ACHSDOC=0,ACHSQ=0 F  S ACHSDOC=$O(^ACHSCHEF(FAC,1,ACHSCHEF,1,"B",ACHSDOC)) Q:ACHSDOC=""  D  Q:ACHSQ
 ...S ACHSDOC1=1_$E(ACHSDOC,1)_$E(ACHSDOC,7,11) Q:$D(^ACHSF(FAC,"D","B",ACHSDOC1))
 ...S DA=ACHSCHEF,DA(1)=FAC S DIK="^ACHSCHEF("_DA(1)_",1," D ^DIK S ACHSQ=1
 K DA,DIK,FAC,L,ACHSTMP,ACHSCHEF,ACHSDOC,ACHSDOC1,ACHSQ
 Q
P29 ;PATCH 29
 D UEI     ;Perform matching Vendor file with UEI file
 D TXFL    ;Cleanup CHS TX Status File
 D OPT29   ;Add new Options
 D INDX29  ;Reindex new index in CHS TX STATUS file
 Q
UEI ;LOOP THROUGHT UEI VENDOR FILE CHECKING THE VENDOR FILE FOR A MATCH
 ;Match on DUNS;Possible match if IEN and DUNs does not match
 S ACHSUIEN=0 F I="N","P","M" S ACHSTOT(I)=0
 F  S ACHSUIEN=$O(^ACHSVUEI(ACHSUIEN)) Q:ACHSUIEN'?1N.N  D
 .S ACHSUREC=^ACHSVUEI(ACHSUIEN,0)
 .S ACHSUEIN=$P(ACHSUREC,U,3),ACHSUEI=$P(ACHSUREC,U,4),ACHSDUNS=$P(ACHSUREC,U,6)
 .S ACHSSTA="N"
 .;Check for DUNS match;"H" INDX=DUNS
 .I $D(^AUTTVNDR("H",ACHSDUNS)) D
 ..S ACHSVIEN="" F  S ACHSVIEN=$O(^AUTTVNDR("H",ACHSDUNS,ACHSVIEN)) Q:ACHSVIEN'?1N.N  D
 ...S ACHSSTA="M" D UPDT
 .Q:ACHSSTA="M"
 .;Check for EIN match;"C" INDX=EIN
 .I $D(^AUTTVNDR("C",ACHSUEIN)) D
 ..S ACHSVIEN="" F  S ACHSVIEN=$O(^AUTTVNDR("C",ACHSUEIN,ACHSVIEN)) Q:ACHSVIEN'?1N.N  D
 ...S ACHSSTA="P" D UPDT
 .Q:ACHSSTA="P"
 .S ACHSSTA="N" D UPDT
 D BMES^XPDUTL("Total Updates to Vendor UEI")
 D MES^XPDUTL($J("",5)_"Total Matched: "_ACHSTOT("M"))
 D MES^XPDUTL($J("",5)_"Total Possible: "_ACHSTOT("P"))
 D MES^XPDUTL($J("",5)_"Total Not Matched: "_ACHSTOT("N"))
 Q
UPDT ;UPDATE VENDOR AND CHS VENDOR UEI STATUS FILES
 N DA,DIE,DIC,DR,X
 S $P(^ACHSVUEI(ACHSUIEN,0),U,2)=ACHSSTA
 S ACHSTOT(ACHSSTA)=ACHSTOT(ACHSSTA)+1
 Q:ACHSSTA="N"
 K DA,DIE,DR,X
 I ACHSSTA="M" D
 .S DIE="^AUTTVNDR(",DA=ACHSVIEN
 .S DR=".1////"_ACHSUEI
 .D ^DIE
 .K DA,DIE,DR,X
 I '$D(^ACHSVUEI(ACHSUIEN,1)) S ^ACHSVUEI(ACHSUIEN,1,0)="^9002075.11P^"
 I '$D(^ACHSVUEI(ACHSUIEN,1,"B",ACHSVIEN)) D  Q
 .S DA=$P(^ACHSVUEI(ACHSUIEN,1,0),U,3)+1
 .S ^ACHSVUEI(ACHSUIEN,1,DA,0)=ACHSVIEN_U_ACHSSTA
 .S ^ACHSVUEI(ACHSUIEN,1,"B",ACHSVIEN,DA)=""
 .S $P(^ACHSVUEI(ACHSUIEN,1,0),U,3,4)=DA_U_DA
 Q
 ;
TXFL ;CLEAN UP THE CHS TX EXPORT FILE
 D MES^XPDUTL("Cleaning up the CHS TX Status File. ")
 S CT=0,L=0
 F  S L=$O(^ACHSTXST(L)) Q:L'?1N.N  D
 .Q:'$D(^ACHSTXST(L,1,0))
 .S L1=0
 .F  S L1=$O(^ACHSTXST(L,1,L1)) Q:L1'?1N.N  D
 ..S X1=DT
 ..S X2=$P(^ACHSTXST(L,1,L1,0),U)
 ..D ^%DTC Q:X<1825
 ..S DA(1)=L,DA=L1,DIK="^ACHSTXST("_DA(1)_",1," D ^DIK W "."
 ..S CT=CT+1
 Q
 ;
OPT29 ;ADD NEW OPTIONS
 D BMES^XPDUTL("Begin adding new options.")
 I $$ADD^XPDMENU("ACHS MENU VENDOR REPORTS","ACHSVNDRUEI RPT","VUEI",10) D MES^XPDUTL($J("",5)_"List Vendor UEI Report added to Vendor Report Option")
 I $$ADD^XPDMENU("ACHS MENU EXPORT","ACHSTXR EXPORT SUMMARY REPORT","CEXS",6) D MES^XPDUTL($J("",5)_"Export Summary Report added to Export Menu")
 I $$ADD^XPDMENU("ACHS MENU EXPORT","ACHSADTX","EDID",8) D MES^XPDUTL($J("",5)_"View Document export status added to Export Menu")
 I $$ADD^XPDMENU("ACHS MENU EXPORT","ACHSTX VIEW EPOV","VEPO",10) D MES^XPDUTL($J("",5)_"Added option to View epov file Export Menu")
 I $$ADD^XPDMENU("ACHSAREA","ACHSTX VIEW EPOV","VEPO",10) D MES^XPDUTL($J("",5)_"Added option to View epov file to Area options")
 D MES^XPDUTL("END updating options.")
 Q
 ;
INDX29 ;NEW INDEX FOR CHS TX STATUS FILE
 N ACHSX,ACHSXIEN
 D BMES^XPDUTL("BEGIN Re-index of Date Export Processed in CHS TX Status file.")
 K ^ACHSTXST("F")
 S ACHSX=0 F  S ACHSX=$O(^ACHSTXST(ACHSX)) Q:ACHSX'?1N.N  D
 .S ACHSXIEN=0
 .F  S ACHSXIEN=$O(^ACHSTXST(ACHSX,1,ACHSXIEN)) Q:ACHSXIEN'?1N.N  D
 ..S ^ACHSTXST("F",ACHSX,$P(^ACHSTXST(ACHSX,1,ACHSXIEN,0),U),ACHSXIEN)="" W "."
 D MES^XPDUTL("END Re-index of Date Export Processed in CHS TX Status file.")
 Q
 ;
