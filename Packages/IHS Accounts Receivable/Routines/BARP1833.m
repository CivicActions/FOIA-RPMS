BARP1833 ; IHS/OIT/SDR - Post init for V1.8 Patch 33;02/01/2020
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**33**;OCT 26,2005;Build 133;Build 22
 ;
 ;IHS/SD/SDR 1.8*33 post install
 Q
 ; ********************************************************************
 ;
 ;
POST ;EP - this populates the new A/R Transaction file .011 field, DATE/TIME, and the 'C' xref
 D BMES^XPDUTL("Populating the new A/R Transaction field DATE/TIME...")
 S BARHOLD=DUZ(2)
 S DUZ(2)=0
 S BARC=0
 F  S DUZ(2)=$O(^BARTR(DUZ(2))) Q:'DUZ(2)  D
 .S BARTDFN=0
 .F  S BARTDFN=$O(^BARTR(DUZ(2),BARTDFN)) Q:'BARTDFN  D
 ..S BARC=+$G(BARC)+1
 ..S DIE="^BARTR(DUZ(2),"
 ..S DA=BARTDFN
 ..S BARDTTM=$P($P($G(^BARTR(DUZ(2),BARTDFN,0)),U),".",1,2)  ;use date/time from .01 field to populate
 ..S DR=".011////"_BARDTTM
 ..D ^DIE
 ..I (BARC#10000&(IOST["C")) W "."
 S DUZ(2)=BARHOLD
 Q
