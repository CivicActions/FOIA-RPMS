ICPT002P ;IHS/OIT/FCJ - ICPT 6.0 Patch 1002 ; 14 Mar 2012  12:41 PM
 ;;6.0;CPT/HCPCS;**1002**;May 19, 1997;Build 9
 ;=================================================================
 ;Patch required for Lexicon, patch history will be populated with
 ;patches 38-57
 ;
 ;
POST ;EP FROM KERNAL
 S %="HIST^ICPT002P"
 I $$NEWCP^XPDUTL("POS4-"_%,%)
 S %="MAIL^ICPT002P"
 I $$NEWCP^XPDUTL("POS5-"_%,%)
 ;
 Q
MAIL ;
 D BMES^XPDUTL("BEGIN Delivering MailMan message to select users.")
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 K ^TMP("ICPT002",$J)
 D RSLT(" --- ICPT v 2.0 Patch 1002, have been installed into this namespace ---")
 F %=1:1 D RSLT($P($T(GREET+%),";",3)) Q:$P($T(GREET+%+1),";",3)="###"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D RSLT(^(%,0))
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""ICPT002"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 K ^TMP("ICPT002",$J)
 D MES^XPDUTL("END Delivering MailMan message to select users.")
 Q
 ;
RSLT(%) S ^(0)=$G(^TMP("ICPT002",$J,0))+1,^(^(0))=%
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
 ;;Routines and/or data dictionaries on your RPMS system have been updated.
 ;;  
 ;;You are receiving this message because of the RPMS
 ;;security keys that you hold.  This is for your information.
 ;;Do not respond to this message.
 ;;  
 ;;Questions about this patch may be directed to
 ;;the ITSC Support Center, at 505-248-4371,
 ;;refer to patch "ICPT*6.0*1002".
 ;;  
 ;;###;NOTE: This line end of text.
 ;
HIST ;PATCH HISTORY UPDATE
 D MES^XPDUTL("Begin adding patches to package file.")
 S DDLM=";;",DLM="|",TAG="ICPT"
 S PKGNM="CPT/HCPCS CODES"
 I '$D(^DIC(9.4,"B",PKGNM)) D MES^XPDUTL("Problem with package name.") Q
 S PKGIEN=$O(^DIC(9.4,"B",PKGNM,0))
 S:$$GET1^DIQ(9.4,PKGIEN,13)'="6.0" FDA(9.4,PKGIEN_",",13)="6.0" D FILE^DIE(,"FDA")
 K FDA
 F I=1:1 D  Q:TEXT["END"
 .S TEXT=$T(@TAG+I) Q:TEXT["END"
 .S DATA=$P(TEXT,DDLM,2)
 .S VERSION=$P(DATA,DLM,2),PATCH=$P(DATA,DLM,3)
 .S VSB=$O(^DIC(9.4,PKGIEN,22,"B",VERSION,0))
 .Q:'VSB
 .; Do not update if the patch is already in the patch history
 .Q:$D(^DIC(9.4,PKGIEN,22,VSB,"PAH","B",PATCH))
 .S FDA(9.4901,"+1,"_VSB_","_PKGIEN_",",.01)=$G(PATCH)
 .S FDA(9.4901,"+1,"_VSB_","_PKGIEN_",",.02)=DT
 .S FDA(9.4901,"+1,"_VSB_","_PKGIEN_",",.03)=DUZ
 .D UPDATE^DIE(,"FDA")
 .D:$G(DIERR)'="" MES^XPDUTL("Error adding patch "_PATCH_" to package file.")
 D MES^XPDUTL("Completed adding patches to package file.")
 Q
 ;;;;FORMAT - Package name|Version|Patch|Sequence
ICPT ;
 ;;CPT/HCPCS CODES|6.0|38 SEQ #38
 ;;CPT/HCPCS CODES|6.0|39 SEQ #39
 ;;CPT/HCPCS CODES|6.0|40 SEQ #40
 ;;CPT/HCPCS CODES|6.0|41 SEQ #41
 ;;CPT/HCPCS CODES|6.0|42 SEQ #42
 ;;CPT/HCPCS CODES|6.0|44 SEQ #43
 ;;CPT/HCPCS CODES|6.0|45 SEQ #44
 ;;CPT/HCPCS CODES|6.0|47 SEQ #45
 ;;CPT/HCPCS CODES|6.0|48 SEQ #46
 ;;CPT/HCPCS CODES|6.0|49 SEQ #47
 ;;CPT/HCPCS CODES|6.0|50 SEQ #48
 ;;CPT/HCPCS CODES|6.0|51 SEQ #49
 ;;CPT/HCPCS CODES|6.0|52 SEQ #50
 ;;CPT/HCPCS CODES|6.0|53 SEQ #51
 ;;CPT/HCPCS CODES|6.0|54 SEQ #52
 ;;CPT/HCPCS CODES|6.0|55 SEQ #53
 ;;CPT/HCPCS CODES|6.0|56 SEQ #54
 ;;CPT/HCPCS CODES|6.0|57 SEQ #55
 ;END
