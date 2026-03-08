ABSPP57 ;IHS/SD/SDR - PRE/POST ROUTINE FOR PATCH 57
 ;;1.0;PHARMACY POINT OF SALE;**57**;JUN 01, 2001;Build 131
 ;
POST ;
 ;ADO125991 - populate new cross reference for paper claims by last update
 D BMES^XPDUTL("Populating ABSP Transaction 'AI' xref for paper prescriptions...")
 S DIK="^ABSPT("
 S DIK(1)="7^AI"
 D ENALL^DIK
 Q
