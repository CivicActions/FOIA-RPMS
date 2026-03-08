BUSAFMAN ;GDIT/HS/BEE-FileMan auditing logging calls ; 06 Mar 2013  1:52 PM
 ;;1.0;IHS USER SECURITY AUDIT;**5**;Nov 05, 2013;Build 42
 ;
 Q
 ;
PST ;Merge new logged files into history
 ;
 NEW BFILE,NWENT,HSTDT,HIEN,SWSTS,ONATSITE
 ;
 ;Get the current link status
 S SWSTS=$$STS()
 ;
 ;If the BUSA switch is turned on (or missing) we need to turn off first
 S ONATSITE=SWSTS
 I (SWSTS=1)!(SWSTS="") D
 . W !!,"Turning off the BUSA FileMan switch",!
 . D OFF^BUSASWCH
 . D LSTS(0)
 ;
 ;Check again for newest entry (could have changed)
 S SWSTS=$$STS()
 I SWSTS="" W !!,"<No previous history information found. Aborting>" H 5 Q
 ;
 ;Get the previous entry
 S HIEN=""
 S HSTDT=$O(^BUSAFDEF("B",""),-1)
 I HSTDT]"" S HIEN=$O(^BUSAFDEF("B",HSTDT,""),-1)
 I HIEN="" W !!,"<No previous history entry found. Aborting>" H 5 Q
 ;
 ;Create a new BUSA FILEMAN LOCAL AUDIT DEF entry
 S NWENT=$$NWENT^BUSASWCH(0) I NWENT<0 Q
 ;
 ;Loop through list of files and process
 W !,"Saving a copy of file/field audit statuses"
 S BFILE=0 F  S BFILE=$O(^BUSAFMAN("F",BFILE)) Q:'BFILE  D
 . ;
 . ;Process each file
 . W !,BFILE
 . D PFILE(NWENT,HIEN,BFILE)
 ;
 ;Turn switch back on if it was on
 I (SWSTS=1) D
 . W !!,"Turning the BUSA FileMan switch back on",!
 . D ON^BUSASWCH
 . D LSTS(1)
 ;
 Q
 ;
STS() ;Return FileMan Link Status
 ;
 NEW DTM,IEN,SWCH
 S DTM=$O(^BUSA(9002319.04,"C","F",""),-1)
 S IEN=""
 I DTM'="" S IEN=$O(^BUSA(9002319.04,"C","F",DTM,""))
 I IEN="" Q ""
 S SWCH=$$GET1^DIQ(9002319.04,IEN_",",".02","I")
 I SWCH]"" Q SWCH
 Q ""
 ;
LSTS(ON) ;Log the status change
 ;
 ;Mark the link as ON/OFF
 NEW DIC,X,DLAYGO,DA,BUSAUP,DESC,STS,ESWIT,Y
 S DIC="^BUSA(9002319.04,",DIC(0)="L",DLAYGO=9002319.04,X="F"
 K DO,DD D FILE^DICN
 S DA=+Y
 S BUSAUP(9002319.04,DA_",",.02)=+$G(ON)
 S BUSAUP(9002319.04,DA_",",.05)="Required for Patch Install Logic"
 D FILE^DIE("","BUSAUP","ERROR")
 ;
 Q
 ;
PFILE(NWENT,HIEN,BFILE) ;Process one file entry
 ;
 I $G(NWENT)="" Q
 I $G(HIEN)="" Q
 I $G(BFILE)="" Q
 ;
 NEW BFIELD,NWFILE,MFIL,PFIEN
 ;
 ;Get the previous file ien pointer (may not exist for new files)
 S PFIEN=$O(^BUSAFDEF(HIEN,1,"B",BFILE,""))
 ;
 ;Create a new file subentry
 S NWFILE=$$NWFIL^BUSASWCH(BFILE,NWENT) I NWFILE<0 Q
 ;
 ;Loop through the file fields and process each one
 S BFIELD=0 F  S BFIELD=$O(^DD(BFILE,BFIELD)) Q:'BFIELD  D
 . ;
 . NEW BSTS,SUB1,SUB2,MFIL,BAUDIT,NAUDIT,NEWFLD
 . ;
 . ;Check for WP fields - cannot audit
 . I $P($G(^DD(BFILE,BFIELD,0)),U,2)["W" Q
 . ;
 . ;First check if a multiple and process
 . S MFIL=+$P($G(^DD(BFILE,BFIELD,0)),U,2) I MFIL>0 D PFILE(NWENT,HIEN,MFIL) Q
 . ;
 . ;Look for previously saved field entry - If defined pull values
 . S (SUB1,SUB2)=""
 . S SUB1=$O(^BUSAFDEF(HIEN,"F",BFILE,BFIELD,""))
 . I SUB1]"" S SUB2=$O(^BUSAFDEF(HIEN,"F",BFILE,BFIELD,SUB1,""))
 . S (BAUDIT,NAUDIT)=""
 . I SUB2]"" D
 .. NEW SUBND
 .. S SUBND=$G(^BUSAFDEF(HIEN,1,SUB1,1,SUB2,0))
 .. S BAUDIT=$P(SUBND,U,2)
 .. S NAUDIT=$P(SUBND,U,3)
 . ;
 . ;If not previously defined, create new entry
 . I (BAUDIT="")!(NAUDIT="") D
 .. ;
 .. ;Retrieve the current audit value - could be new field that is marked to be audited already
 .. S (NAUDIT,BAUDIT)=$G(^DD(BFILE,BFIELD,"AUDIT"))
 .. I BAUDIT="" S (NAUDIT,BAUDIT)="n"
 . ;
 . ;Create new entry for field
 . S NEWFLD=$$NWFLD^BUSASWCH(NWENT,NWFILE,BFIELD,BAUDIT,NAUDIT)
 ;
 Q
