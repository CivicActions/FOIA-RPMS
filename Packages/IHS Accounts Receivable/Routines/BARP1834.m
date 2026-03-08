BARP1834 ; IHS/OIT/SDR - Post init for V1.8 Patch 34 ;02/01/2020
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**34**;OCT 26,2005;Build 139;Build 22
 ;
 ;IHS/SD/SDR 1.8*34 post install
 Q
 ; ********************************************************************
 ;
POST ;
 D CBATCH  ;fix A/R Collection Batch items so everything isn't item #1
 D CODES  ;add SARs and add/edit Remark Codes
 Q
 ;
CBATCH ;EP
 D BMES^XPDUTL("Re-indexing Collection Batch/Items...")
 S BARHOLD=DUZ(2)
 S DUZ(2)=0
 S BARC=0
 F  S DUZ(2)=$O(^BARCOL(DUZ(2))) Q:'DUZ(2)  D
 .K ^BARCOL(DUZ(2),"D")  ;kill xref; otherwise bad entries will stay out there mixed in with good entries
 .S BARBATCH=0
 .F  S BARBATCH=$O(^BARCOL(DUZ(2),BARBATCH)) Q:'BARBATCH  D
 ..S BARITEM=0
 ..F  S BARITEM=$O(^BARCOL(DUZ(2),BARBATCH,1,BARITEM)) Q:'BARITEM  D
 ...S DA(1)=BARBATCH
 ...S DA=BARITEM
 ...S DIK="^BARCOL(DUZ(2),"_DA(1)_",1,"
 ...D IX^DIK
 ...S BARC=+$G(BARC)+1
 ...I (BARC#10000&(IOST["C")) W "."
 S DUZ(2)=BARHOLD
 Q
CODES ;EP
 D EN^BAR1834A  ;add standard adjustment reason codes
 ;
 D EN^BAR1834C  ;add remark codes
 D RMK^BAR1834B  ;edit remark codes
 Q
LDESC(LDESC,CODE,WP)  ;PARSE LONG DESCRIPTION for word processing fields
 N X
 S V=$O(WP(999999999999999),-1)
 S X=0
 F X=1:1:$L(LDESC) D
 .S WP=WP_$E(LDESC,X)
 .I $L(WP)>65,($E(LDESC,X)=" ") S V=V+1,WP(V)=WP,WP=""
 .I ($L(WP)=$L(LDESC))!($L(LDESC)=X) S V=V+1,WP(V)=WP,WP=""
 Q
