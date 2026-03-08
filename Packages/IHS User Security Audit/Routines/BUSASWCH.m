BUSASWCH ;GDIT/HS/BEE-Turn on/off FileMan Auditing ; 06 Mar 2013  1:52 PM
 ;;1.0;IHS USER SECURITY AUDIT;**3,5**;Nov 05, 2013;Build 42
 ;
 Q
 ;
ONOFF(ON,PARTIAL,IEN) ;EP - Turn FileMan auditing on/off
 ;
 ;Input parameter
 ; ON - 1 - Enable FileMan auditing
 ;      0 - Disable FileMan auditing
 ; PARTIAL - 1 - Enable Partial FileMan auditing
 ; IEN - Previous switch entry for switch
 ;
 NEW CPARTIAL,CSTS
 ;
 S ON=+$G(ON)
 ;
 ;Handle disables
 I 'ON D OFF  W !!,"FileMan audit link turned off",! H 3 Q
 ;
 ;Need to see if going from partial to full or full to partial
 ;If so, turn off first
 S CPARTIAL=$$GET1^DIQ(9002319.04,IEN_",",.06,"I")
 S CSTS=$$GET1^DIQ(9002319.04,IEN_",",.02,"I")
 I (CSTS&CPARTIAL),'PARTIAL D OFF
 I (CSTS&'CPARTIAL),PARTIAL D OFF
 ;
 ;Enable Partial
 I ON,PARTIAL D PRTON Q
 ;
 ;Enable Full
 I ON D ON Q
 ;
 Q
 ;
OFF ;Turn off auditing
 ;
 NEW BFILE,NWENT,LSTDT,LIEN,SWSTS
 ;
 ;Locate the newest history definition entry
 S (LIEN,SWSTS)=""
 S LSTDT=$O(^BUSAFDEF("B",""),-1)
 I LSTDT]"" S LIEN=$O(^BUSAFDEF("B",LSTDT,""),-1)
 I LIEN]"" S SWSTS=$$GET1^DIQ(9002319.09,LIEN_",",.02,"I")
 I 'SWSTS W !!,"The BUSA FileMan switch is already marked as off" H 3 Q
 ;
 ;Create a new BUSA FILEMAN LOCAL AUDIT DEF entry
 S NWENT=$$NWENT(0) I NWENT<0 Q
 ;
 ;Loop through list of files and process
 W !!,"Turning off FileMan auditing link - restoring fields to original audit status"
 S BFILE=0 F  S BFILE=$O(^BUSAFDEF(LIEN,"F",BFILE)) Q:'BFILE  D
 . ;
 . ;Loop through the file fields and process each one
 . ;
 . NEW BFIELD,NWFILE
 . S (NWFILE,BFIELD)=0 F  S BFIELD=$O(^BUSAFDEF(LIEN,"F",BFILE,BFIELD)) Q:'BFIELD  D
 .. NEW BFILN,BFLDN
 .. S BFILN="" F  S BFILN=$O(^BUSAFDEF(LIEN,"F",BFILE,BFIELD,BFILN)) Q:BFILN=""  D
 ... S BFLDN="" F  S BFLDN=$O(^BUSAFDEF(LIEN,"F",BFILE,BFIELD,BFILN,BFLDN)) Q:BFLDN=""  D
 .... ;
 .... NEW DA,IENS,BCAUDIT,BOAUDIT,BNAUDIT,NEWFLD
 .... ;
 .... ;Retrieve the current audit value
 .... S BCAUDIT=$G(^DD(BFILE,BFIELD,"AUDIT"))
 .... ;
 .... ;Get the original and modified values from history
 .... S DA(2)=LIEN,DA(1)=BFILN,DA=BFLDN,IENS=$$IENS^DILF(.DA)
 .... S BOAUDIT=$$GET1^DIQ(9002319.911,IENS,.02)
 .... S BNAUDIT=$$GET1^DIQ(9002319.911,IENS,.03)
 .... ;
 .... ;If current is different from new, a patch update or local update has changed the value
 .... ;need to honor that one rather than the new one stored
 .... ;I BNAUDIT'=BCAUDIT S BNAUDIT=BCAUDIT
 .... ;
 .... ;Check if we need to create a new file subentry
 .... I 'NWFILE S NWFILE=$$NWFIL(BFILE,NWENT) I NWFILE<0 Q
 .... ;
 .... ;Create new entry for field
 .... S NEWFLD=$$NWFLD(NWENT,NWFILE,BFIELD,BCAUDIT,BOAUDIT)
 .... ;
 .... ;Turn on auditing for field
 .... ; CALL FM AUDITING API: TURNING ON SET TO 'y', TURNING OFF SET TO PREVIOUS VALUE OR 'n'
 .... W !,BFILE,?30,BFIELD
 .... D TURNON^DIAUTL(BFILE,BFIELD,BOAUDIT)
 ;
 Q
 ;
ON ;Turn on auditing
 ;
 NEW BFILE,NWENT,LSTDT,LIEN,SWSTS,BBACK,CPARTIAL
 ;
 ;Locate the newest history definition entry
 S (LIEN,SWSTS)=""
 S LSTDT=$O(^BUSAFDEF("B",""),-1)
 I LSTDT]"" S LIEN=$O(^BUSAFDEF("B",LSTDT,""),-1)
 I LIEN]"" S SWSTS=$$GET1^DIQ(9002319.09,LIEN_",",.02,"I")
 I SWSTS,'$$GET1^DIQ(9002319.09,.04,"I") W !!,"BUSA FileMan auditng is already enabled" H 3 Q
 ;
 ;Create a new BUSA FILEMAN LOCAL AUDIT DEF entry
 S NWENT=$$NWENT(1,1) I NWENT<0 Q
 ;
 ;See if we need to create a backup copy of the original
 S BBACK=0 I +$P($G(^BUSAFBCK("STS")),U)<1 S BBACK=1
 I BBACK=1 S ^BUSAFBCK("STS")=DT_U_DUZ,^BUSAFBCK(0)="BUSA FILEMAN AUDITING BACKUP OF ORIGINAL FMAN AUDIT VALUES"
 ;
 ;Loop through list of files and process
 W !!,"Turning FileMan auditing on for file (or subfile) and field"
 S BFILE=0 F  S BFILE=$O(^BUSAFMAN("F",BFILE)) Q:'BFILE  D
 . ;
 . NEW BFILN
 . ;
 . ;Process each file
 . S BFILN=$$FILE(NWENT,BFILE,BBACK)
 ;
 W !!,"FileMan audit link turned on" H 3
 ;
 Q
 ;
PRTON ;Turn on partial auditing
 ;
 NEW BFILE,NWENT,LSTDT,LIEN,SWSTS,BBACK
 ;
 ;Locate the newest history definition entry
 S (LIEN,SWSTS)=""
 S LSTDT=$O(^BUSAFDEF("B",""),-1)
 I LSTDT]"" S LIEN=$O(^BUSAFDEF("B",LSTDT,""),-1)
 I LIEN]"" S SWSTS=$$GET1^DIQ(9002319.09,LIEN_",",.02,"I")
 I SWSTS,$$GET1^DIQ(9002319.09,.04,"I") W !!,"BUSA FileMan partial auditng is already enabled" H 3 Q
 ;
 ;Create a new BUSA FILEMAN LOCAL AUDIT DEF entry
 S NWENT=$$NWENT(1) I NWENT<0 Q
 ;
 ;See if we need to create a backup copy of the original
 S BBACK=0 I +$P($G(^BUSAFBCK("STS")),U)<1 S BBACK=1
 I BBACK=1 S ^BUSAFBCK("STS")=DT_U_DUZ,^BUSAFBCK(0)="BUSA FILEMAN AUDITING BACKUP OF ORIGINAL FMAN AUDIT VALUES"
 ;
 ;Loop through list of files and process
 W !!,"Turning FileMan partial auditing on for file (or subfile) and field"
 ;
 ;Turn on entries with all fields
 S BFILE=0 F  S BFILE=$O(^BUSAPFMN("B",BFILE)) Q:BFILE=""  D
 . ;
 . NEW FIEN,BFILN
 . S FIEN=$O(^BUSAPFMN("B",BFILE,"")) Q:'FIEN
 . ;
 . ;See if all
 . I '$$GET1^DIQ(9002319.14,FIEN_",",.02,"I") Q
 . ;
 . ;All fields in file
 . S BFILN=$$FILE(NWENT,BFILE,BBACK)
 ;
 ;Now do the partial fields
 S BFILE=0 F  S BFILE=$O(^BUSAPFMN("FLD",BFILE)) Q:'BFILE  D
 . ;
 . NEW FIEN,BFILN
 . S FIEN=$O(^BUSAPFMN("FLD",BFILE,"")) Q:'FIEN
 . ;
 . ;See if all
 . I $$GET1^DIQ(9002319.14,FIEN_",",.02,"I") Q
 . ;
 . ;Process each file
 . S BFILN=$$PFILE(NWENT,BFILE,BBACK)
 ;
 W !!,"FileMan audit link turned on" H 3
 ;
 Q
 ;
PFILE(NWENT,BFILE,BBACK) ;Process one file entry
 ;
 I $G(NWENT)="" Q 0
 I $G(BFILE)="" Q 0
 ;
 NEW BFIELD,NWFILE,MFIL
 ;
 ;Create a new file subentry
 S NWFILE=$$NWFIL(BFILE,NWENT) I NWFILE<0 Q 0
 ;
 ;Loop through the file partial fields and process each one
 S BFIELD="" F  S BFIELD=$O(^BUSAPFMN("FLD",BFILE,BFIELD)) Q:BFIELD=""  D
 . ;
 . NEW BSTS
 . ;
 . ;Check for WP fields - cannot audit
 . I $P($G(^DD(BFILE,BFIELD,0)),U,2)["W" Q
 . ;
 . NEW DA,IENS,BAUDIT,NEWFLD
 . ;
 . ;Retrieve the audit value
 . S BAUDIT=$G(^DD(BFILE,BFIELD,"AUDIT"))
 . ;
 . ;Save current new and old values
 . I BBACK S ^BUSAFBCK(BFILE,BFIELD)=BAUDIT
 . ;
 . ;Create new entry for field
 . S NEWFLD=$$NWFLD(NWENT,NWFILE,BFIELD,BAUDIT,"y")
 . ;
 . ;Turn on auditing for field
 . W !,BFILE,?30,BFIELD
 . D TURNON^DIAUTL(BFILE,BFIELD,"y")
 ;
 Q 1
 ;
FILE(NWENT,BFILE,BBACK) ;Process one file entry
 ;
 I $G(NWENT)="" Q 0
 I $G(BFILE)="" Q 0
 ;
 NEW BFIELD,NWFILE,MFIL
 ;
 ;Create a new file subentry
 S NWFILE=$$NWFIL(BFILE,NWENT) I NWFILE<0 Q 0
 ;
 ;Loop through the file fields and process each one
 S BFIELD=0 F  S BFIELD=$O(^DD(BFILE,BFIELD)) Q:'BFIELD  D
 . ;
 . NEW BSTS
 . ;
 . ;First check if a multiple and process
 . S MFIL=+$P($G(^DD(BFILE,BFIELD,0)),U,2) I MFIL>0 S BSTS=$$FILE(NWENT,MFIL,BBACK) Q
 . ;
 . ;Check for WP fields - cannot audit
 . I $P($G(^DD(BFILE,BFIELD,0)),U,2)["W" Q
 . ;
 . NEW DA,IENS,BAUDIT,NEWFLD
 . ;
 . ;Retrieve the audit value
 . S BAUDIT=$G(^DD(BFILE,BFIELD,"AUDIT"))
 . ;
 . ;Save current new and old values
 . I BBACK S ^BUSAFBCK(BFILE,BFIELD)=BAUDIT
 . ;
 . ;Create new entry for field
 . S NEWFLD=$$NWFLD(NWENT,NWFILE,BFIELD,BAUDIT,"y")
 . ;
 . ;Turn on auditing for field
 . W !,BFILE,?30,BFIELD
 . D TURNON^DIAUTL(BFILE,BFIELD,"y")
 ;
 Q 1
 ;
NWENT(ON,PARTIAL) ;Create new definition entry
 ;
 S ON=+$G(ON)
 ;
 NEW DIC,X,Y,DA,DLAYGO,%,DINUM,NIEN,BUPD,ERROR
 S DIC(0)="L",DIC="^BUSAFDEF(",DLAYGO=DIC
 D NOW^%DTC
 S X=%
 K DO,DD D FILE^DICN
 I +Y<0 Q -1
 S NIEN=+Y
 ;
 ;Set SWITCH STATUS
 S BUPD(9002319.09,NIEN_",",.02)=ON
 S BUPD(9002319.09,NIEN_",",.03)=DUZ
 S BUPD(9002319.09,NIEN_",",.04)=+$G(PARTIAL)
 D FILE^DIE("","BUPD","ERROR")
 Q NIEN
 ;
NWFIL(BFILE,NWENT) ;Create new file subfield entry
 ;
 I +$G(NWENT)<0 Q -1
 I '$G(BFILE) Q -1
 ;
 NEW DIC,X,Y,DA,DLAYGO,%,DINUM,NIEN,BUPD,ERROR
 S DA(1)=NWENT
 S DIC(0)="L",DIC="^BUSAFDEF("_DA(1)_",1,",DLAYGO=DIC
 S X=BFILE
 K DO,DD D FILE^DICN
 I +Y<0 Q -1
 Q +Y
 ;
NWFLD(NWENT,NWFILE,BFIELD,BOAUDIT,BNAUDIT) ;Create new entry for field
 ;
 I '$G(NWENT) Q -1
 I '$G(NWFILE) Q -1
 I $G(BFIELD)="" Q -1
 S BOAUDIT=$G(BOAUDIT) S:BOAUDIT="" BOAUDIT="n"
 S BNAUDIT=$G(BNAUDIT) S:BNAUDIT="" BNAUDIT="n"
 ;
 NEW DIC,X,Y,DA,DLAYGO,%,DINUM,NFLD,BUPD,ERROR,IENS
 S DA(2)=NWENT,DA(1)=NWFILE
 S DIC(0)="L",DIC="^BUSAFDEF("_DA(2)_",1,"_DA(1)_",1,",DLAYGO=DIC
 S X=BFIELD
 K DO,DD D FILE^DICN
 I +Y<0 Q -1
 S (DA,NFLD)=+Y
 ;
 ;Set SWITCH STATUS
 S DA(2)=NWENT,DA(1)=NWFILE
 S IENS=$$IENS^DILF(.DA)
 S BUPD(9002319.911,IENS,.02)=BOAUDIT
 S BUPD(9002319.911,IENS,.03)=BNAUDIT
 D FILE^DIE("","BUPD","ERROR")
 Q NFLD
