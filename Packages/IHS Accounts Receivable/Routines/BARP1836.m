BARP1836 ; IHS/OIT/SDR - Post init for V1.8 Patch 36;02/01/2020
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**36**;OCT 26,2005;Build 199;Build 22
 ;IHS/SD/SDR 1.8*36 Pre and Post install routine
 Q
 ;*****************************************
 ;
PRE ;EP
 ;Kill bad xref on A/R Transaction, A/R ACCOUNT field
 S BARH=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BARTR(DUZ(2))) Q:'DUZ(2)  D
 .K ^BARTR(DUZ(2),"AE")
 S DUZ(2)=BARH
 Q
 ;
POST ;
 ;recreate AE xref with updated DD
 S BARH=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BARTR(DUZ(2))) Q:'DUZ(2)  D
 .S DIK="^BARTR(DUZ(2),"
 .S DIK(1)="6^AE"
 .D ENALL^DIK
 S DUZ(2)=BARH
 Q
