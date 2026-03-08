ADEUTL2 ;IHS/GDIT/GAB - ADE v6.0 PATCH 41 [ 07/05/2024  14:05 PM ]
 ;;6.0;ADE IHS DENTAL;**41**;March 25, 1999;Build 57
 ;
 ;Adds an entry to the ADA Code file or deactivates an entry using either the code or the IEN
 ;ADEFILE:  example ADA Code file 9999999.31, required field
 ;ADEFLDS:  Fields to be updated, required and does not include WP fields
 ;ADEWPFLD: Word Processing Field (use 1101 for the ADA Code file), use "" if no WP fields
 ;ADEIENST: "?+1" ('?' if the .01 value exits; '+' if .01 doesn't exist add it; '1' is placeholder), required
 ;ADETGRTN: Routine with List of codes to be added or inactivated (example ADDADA^ADE6P413), required
 ;ADESETX:  Routine with an action, for new codes it sets the field to uppercase (SETX^ADE6P413), uses null if not needed
 ;          for inactivating it sets it to the IEN in the ADA Code file, example (SETX^ADE6P412)
 ;
 ;      File  Fields  WP Fields
UPDATE(ADEFILE,ADEFLDS,ADEWPFLD,ADEIENST,ADETGRTN,ADESETX) ;EP
 N ADEFDA
 S ADENFLDS=$L(ADEFLDS,","),ADEDONE=0,ADERPEAT=0,ADEN="",ADETXT=0
 F ADEI=1:1 S ADEX=$P($T(@$P(ADETGRTN,"^")+ADEI^@$P(ADETGRTN,"^",2)),";;",2) S:ADEX="***END***" ADEDONE=1 D  Q:ADEDONE
 .I ADEX[U!ADEDONE D  K ADETEXT S ADETXT=0 Q
 ..F  D  Q:ADERPEAT<2
 ...S ADELSTN=ADEN D:ADESETX'="" @ADESETX D:ADELSTN]"" FILE D SETFDA Q
 .Q:$G(ADEWPFLD)=""
 .S ADETXT=ADETXT+1,ADETEXT(ADETXT)=ADEX
 K ADECURX,ADEDONE,ADEI,ADEI1,ADELSTN,ADEN,ADEEND,ADENFLDS,ADERPEAT,ADESVX,ADESTART,ADETXT,ADETEXT,ADEX,ADEX1
 Q
 ;
SETFDA  ;EP
 ; Corresponds to values in X: the first is the field that is set with the first piece, etc.  If a value isn't used to set a field
 ; nothing should be entered for that piece; should be left empty e.g. ".01,02,,.09"
 F ADEI1=1:1:ADENFLDS S ADEFLD=$P(ADEFLDS,",",ADEI1) I ADEFLD'="" S ADEX1=$P(ADEX,U,ADEI1) S:ADEX1'="" ADEFDA(ADEFILE,ADEIENST,ADEFLD)=ADEX1
 S ADEN=$P(ADEX,U)
 Q
 ;
FILE  ;EP
 D UPDATE^DIE(,"ADEFDA","ADEIEN","ADEEMSG")
 K ADEFDA,ADEEMSG
 ; get the IEN assigned
 I +$G(ADEIEN(1)),$G(ADETEXT(1))'="" D WP^DIE(ADEFILE,ADEIEN(1)_",",ADEWPFLD,,"ADETEXT","ADEEMSG")
 K ADEEMSG,ADEIEN
 Q
 ;
DELETES(ADETGRTN,ADESETX,ADEDIK,INACTDT)  ;EP  INACTIVATE DENTAL CODE
 ;Change the date in DR=".08////3250101"
 F ADEI=1:1 S ADEX=$P($T(@$P(ADETGRTN,"^")+ADEI^@$P(ADETGRTN,"^",2)),";;",2) Q:ADEX="***END***"  D
 . D:ADESETX'="" @ADESETX
 . I ADEX'="" S DA=ADEX,DIE=ADEDIK,DR=".08////"_INACTDT D ^DIE
 . Q
 Q
INACT(ADEDIEN,DDATE)  ;EP INACTIVATE A CODE USING THE IEN
 ;ADEDIEN: ADA CODE IEN
 ;DDATE:  INACTIVATE DATE
 S DA=ADEDIEN
 I $D(DA) S DIE="^AUTTADA(",DR=".08////"_DDATE D ^DIE
 K DA,DR,DIE,Y
 Q
