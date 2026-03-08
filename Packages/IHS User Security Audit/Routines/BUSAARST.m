BUSAARST ;GDIT/HS/BEE-BUSA Archive Information Status ; 06 Mar 2013  1:52 PM
 ;;1.0;IHS USER SECURITY AUDIT;**3**;Nov 05, 2013;Build 47
 ;
 Q
 ;
ASTS(VDISP) ;Display current in progress archives
 ;
 ;Came from verify option
 S VDISP=$G(VDISP)
 ;
 NEW AIEN,FIRST,CREATE,VERIFY,FVERIFY
 NEW DTOUT,DUOUT,DIRUT,DIROUT,X,Y,DIR,PROMPT
 ;
 ;Display a list of the in progress archives
 S (FIRST,AIEN,CREATE,VERIFY,FVERIFY,PROMPT)=0 F  S AIEN=$O(^BUSAAH(AIEN)) Q:'AIEN  D
 . ;
 . NEW STS,FNAME,XSTS
 . ;
 . ;Get the filename
 . S FNAME=$$GET1^DIQ(9002319.13,AIEN_",",.11,"I")
 . ;
 . ;Get the status - filter out archived
 . S STS=$$GET1^DIQ(9002319.13,AIEN_",",.14,"I") Q:STS="A"
 . ;
 . ;Retrieve status from ^XTMP
 . S XSTS=""
 . I STS="C" D
 .. ;
 .. ;First see if verify failed
 .. S XSTS=$G(^XTMP("BUSAARCH","V",AIEN,"STS"))
 .. I $P(XSTS,U)=0 S FVERIFY=1,XSTS=$P(XSTS,U,2) Q
 .. ;
 .. ;Next pull creation status
 .. S XSTS=$G(^XTMP("BUSAARCH","C",AIEN,"STS"))
 .. I $P(XSTS,U)=1 S CREATE=1,XSTS=$P(XSTS,U,2)
 . ;
 . ;Pull verify status
 . I STS="V" S XSTS=$P($G(^XTMP("BUSAARCH","V",AIEN,"STS")),U,2) S VERIFY=1
 . ;
 . ;Display the in progress builds
 . I FIRST=0 D
 .. I '$G(VDISP) W !!,"There are currently archive(s) in progress"
 .. E  W !!,"Files that have currently been verified:"
 .. W !!,"File",?55,"Status" S FIRST=1
 . W !,FNAME,?55,XSTS
 ;
 ;Quit if from verify option
 I $G(VDISP) D  Q 0
 . NEW DTOUT,DUOUT,DIRUT,DIROUT,X,Y,DIR,PROMPT
 . W !
 . S DIR(0)="FO^0:30"
 . S DIR("A")="Press Enter to Continue"
 . K DIR("B")
 . D ^DIR
 ;
 ;Determine next step
 ;
 ;Failed verify
 I 'PROMPT,FVERIFY D
 . W !!,"There is an archive file that has failed verification."
 . S DIR(0)="S^C:Clear out all files and start over"
 . I VERIFY S DIR(0)=DIR(0)_";R:Remove unverified files and re-archive"
 . S PROMPT=1
 ;
 ;Only created
 I 'PROMPT,CREATE,'VERIFY D
 . W !!,"There are archive files that have been created but have not yet been verified."
 . S DIR(0)="S^C:Clear out all files and start over;A:Archive additional audit data"
 . S PROMPT=1
 ;
 ;Only verified
 I 'PROMPT,VERIFY,'CREATE D
 . W !!,"There are archive files that have been verified but not yet archived."
 . S DIR(0)="S^C:Clear out all files and start over;A:Archive additional audit data"
 . S PROMPT=1
 ;
 ;Both create and verify
 I 'PROMPT,VERIFY,CREATE D
 . W !!,"There are both created and verified archive files."
 . S DIR(0)="S^C:Clear out all files and start over;A:Archive additional audit data"
 . S PROMPT=1
 ;
 ;Prompt user for next step
 I PROMPT=0 Q 1
 S DIR("A")="How would you like to proceed"
 D ^DIR
 I ($G(DTOUT)]"")!($G(DUOUT)]"")!($G(DIRUT)]"")!($G(DIROUT)]"") Q 0
 S Y=$G(Y) I Y'="C",Y'="A",Y'="R" Q 0
 ;
 ;Clear out files and start over
 I Y="C" D CLEAR("CV") Q 1
 ;
 ;Append to existing created records
 I Y="A" Q 2
 ;
 ;Remove unverified and continue
 I Y="R" D CLEAR("C") Q 2
 ;
 Q 0
 ;
CLEAR(TYPE) ;Clear out existing files and start over
 ;
 NEW FLIST,DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT,FNAME,II
 ;
 ;Clear deleted files list
 K ^XTMP("BUSAARCH","DFILE")
 ;
 ;Clear out existing archive and run history
 S II=0 F  S II=$O(^BUSAAH(II)) Q:'II  D
 . ;
 . NEW FSTS,DA,DIK,FNAME
 . ;
 . ;Filter out Archived
 . S FSTS=$$GET1^DIQ(9002319.13,II_",",.14,"I")
 . ;
 . ;Filter out Archived
 . I FSTS="A" Q
 . ;
 . ;Remove Create?
 . I TYPE'["C",FSTS="C" Q
 . ;
 . ;Remove Verified?
 . I TYPE'["V",FSTS="V" Q
 . ;
 . ;Get the filename
 . S FNAME=$$GET1^DIQ(9002319.13,II_",",.11,"I")
 . I FNAME]"" S FLIST(FNAME)=""
 . ;
 . ;Remove the entry
 . S DA=II,DIK="^BUSAAH(" D ^DIK
 . K ^XTMP("BUSAARCH",FSTS,II)
 . ;
 . ;Remove the ^XTMP
 . K ^XTMP("BUSAARCH",FSTS,II)
 . I FSTS="V" K ^XTMP("BUSAARCH","C",II)  ;Remove "C" info if verified
 . I FSTS="C" K ^XTMP("BUSAARCH","V",II)  ;Remove "V" if failure
 ;
 W !!,"Existing file definitions have been removed."
 ;
 ;Display list of removed files
 I $D(FLIST) D
 . W !!,"Please make sure these archive files get removed from the"
 . W !,"archive folder as they will be replaced with new archive files."
 . I TYPE'["V" W !!,"Be care not to remove files that have already been verified."
 . W !!,"Filename:"
 . S FNAME="" F  S FNAME=$O(FLIST(FNAME)) Q:FNAME=""  D
 .. W !,FNAME
 .. S ^XTMP("BUSAARCH","DFILE",FNAME)=""
 ;
 ;Continue
 W !
 S DIR(0)="FO^0:30"
 S DIR("A")="Press Enter to Continue"
 K DIR("B")
 D ^DIR
 ;
 Q
 ;
VDISP(DSP) ;Display list of already verified files
 ;
 S DSP=$G(DSP)  ;Set to 1 if coming from after verify display section, 2 if from purge
 ;
 NEW AIEN,FIRST,VFAIL,WARN,DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT
 ;
 ;Display a list of any verified files
 S (AIEN,FIRST,VFAIL,WARN)=0 F  S AIEN=$O(^BUSAAH(AIEN)) Q:'AIEN  D  Q:VFAIL
 . ;
 . NEW STS,FNAME,XSTS,EVENT,SUCC,FWARN,CWARN
 . ;
 . ;Reset warnign
 . S FWARN=0
 . ;
 . ;Get the filename
 . S FNAME=$$GET1^DIQ(9002319.13,AIEN_",",.11,"I")
 . ;
 . ;Get the status - filter out archived
 . S STS=$$GET1^DIQ(9002319.13,AIEN_",",.14,"I")
 . I STS="A" Q
 . ;
 . ;Display failed verifications if still available
 . I STS="C",'$D(^XTMP("BUSAARCH","V",AIEN,"STS")) Q
 . ;
 . I FIRST=0 D
 .. I DSP="" W !!,"The verification process has already been run on these created files"
 .. I DSP=1 W !!,"The verification process completed"
 .. I DSP=2 D
 ... W !!,"The following files have been verified."
 ... W !,"The data contained in them can now be purged."
 .. W !!,"File",?55,"Status"
 .. S FIRST=1
 . ;
 . ;Check for warnings in verify
 . I $D(^XTMP("BUSAARCH","V",AIEN,"WARN")) S (FWARN,WARN)=1
 . ;
 . ;Check for HASH warnings in create
 . I FWARN=0 S FWARN=$$CWARN(AIEN) S:FWARN=1 WARN=1
 . ;
 . ;Get the event status - ^XTMP could have been deleted by now
 . ;so only quit if an error found
 . S EVENT=$G(^XTMP("BUSAARCH","V",AIEN,"STS"))
 . S SUCC=$P(EVENT,U),EVENT=$P(EVENT,U,2)
 . I STS'="C",EVENT="" S EVENT="Verification succeeded"
 . I STS="C" D
 .. S:EVENT="" EVENT="Verification failed"
 .. S VFAIL=AIEN
 . ;
 . ;For purge do not display file with errors
 . I DSP=2,VFAIL Q
 . ;
 . ;Display the entry
 . W !,FNAME,?55,EVENT
 . ;
 . ;Display error/warning messages
 . I VFAIL W !,?55," **Errors present**"
 . I FWARN W !,?55," **Warnings present**"
 ;
 ;Display note if failure or warning (if not from purge option)
 I VFAIL,DSP'=2 D
 . ;
 . NEW ERR
 . W !!,"The verification process failed on one of the files."
 . I '$D(^XTMP("BUSAARCH","V",VFAIL)) D  Q
 .. W !,"It has been too long since the file was verified however and"
 .. W !,"the errors have been purged from the system. Please rerun the"
 .. W !,"verification process again to regenerate the errors so that"
 .. W !,"they can be reviewed."
 . ;
 . ;Errors still on file
 . W !,"If the file is repaired, the verification process can be rerun to"
 . W !,"check if the file is now valid. The 'Archive BUSA Information' option"
 . W !,"can also be run to recreate the file with errors."
 . W !!,"Verification errors are stored in global: "
 . W !!,"^XTMP(""BUSAARCH"",""V"","_VFAIL_")",!
 . S DIR("A")="Would you like to view the errors/warnings in the file that failed"
 . S DIR("B")="NO"
 . S DIR(0)="Y"
 . D ^DIR
 . I $G(Y)'=1 Q
 . ;
 . ;Display the verify warnings/errors
 . W:$D(IOF) @IOF
 . W "VERIFICATION HISTORY FOR FILENAME: ",$G(^XTMP("BUSAARCH","V",VFAIL,"FILE")),!
 . W !,"ERROR/WARNING"
 . ;
 . ;Display create warnings
 . S ERR=0 F  S ERR=$O(^XTMP("BUSAARCH","C",VFAIL,ERR)) Q:'ERR  D
 .. NEW ERROR
 .. S ERROR=$G(^XTMP("BUSAARCH","C",VFAIL,ERR))
 .. I ERROR["HASH mismatch" W !,"* WARNING - ",ERROR
 . ;
 . S ERR=0 F  S ERR=$O(^XTMP("BUSAARCH","V",VFAIL,ERR)) Q:'ERR  D
 .. ;
 .. NEW WARN,ERROR
 .. S ERROR=$G(^XTMP("BUSAARCH","V",VFAIL,ERR))
 .. I $E(ERROR,1,11)="Opened file" Q   ;Filter out opens
 .. I $E(ERROR,1,11)="Closed file" Q   ;Filter out closes
 .. ;
 .. S WARN=""
 .. I $D(^XTMP("BUSAARCH","V",VFAIL,ERR,"W")) S WARN="*WARNING - "
 .. ;
 .. ;Display the error
 .. W !,WARN,$G(^XTMP("BUSAARCH","V",VFAIL,ERR))
 . S DSP=1
 I WARN D
 . NEW DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT,AIEN
 . W !!,"One or more of the files passed verification but had warnings.",!
 . I DSP=1 S DIR("A")="Would you like to view the warnings now for other files"
 . E  S DIR("A")="Would you like to view the warnings in the files"
 . S DIR("B")="NO"
 . S DIR(0)="Y"
 . D ^DIR
 . I $G(Y)'=1 Q
 . ;
 . ;Loop through list and report
 . W:$D(IOF) @IOF
 . S AIEN=0 F  S AIEN=$O(^XTMP("BUSAARCH","V",AIEN)) Q:(('AIEN)!((VFAIL>0)&(AIEN'<VFAIL)))  D
 .. ;
 .. S FIRST=0
 .. ;
 .. S ERR=0 F  S ERR=$O(^XTMP("BUSAARCH","V",AIEN,ERR)) Q:'ERR  D
 ... ;
 ... ;Filter out non-warnings
 ... I '$D(^XTMP("BUSAARCH","V",AIEN,ERR,"W")) Q
 ... ;
 ... ;Display the header
 ... I FIRST=0 W !,"Filename: ",$G(^XTMP("BUSAARCH","V",AIEN,"FILE")),! S FIRST=1
 ... ;
 ... ;Display the warning
 ... W !,$G(^XTMP("BUSAARCH","V",AIEN,ERR))
 .. I FIRST=1 W !
 . S DSP=1
 ;
 I DSP=1 D
 . NEW DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT
 . ;Continue
 . W !
 . S DIR(0)="FO^0:30"
 . S DIR("A")="Press Enter to Continue"
 . K DIR("B")
 . D ^DIR
 ;
 Q
 ;
LLIST(FLIST) ;Display load errors
 ;
 NEW AIEN,DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT
 ;
 S FLIST=$G(FLIST)
 ;
 I $O(^XTMP("BUSAARCH","LERR",""))="" Q
 ;
 I FLIST="" W !,"Previous file loads have been unsuccessful.",!
 S DIR(0)="YA"
 S DIR("A")="Would you like to view the load errors: "
 S DIR("B")="NO"
 D ^DIR
 I ($G(DTOUT)]"")!($G(DUOUT)]"")!($G(DIRUT)]"")!($G(DIROUT)]"") Q
 I Y'=1 Q
 ;
 ;Loop through load history
 S AIEN="" F  S AIEN=$O(^XTMP("BUSAARCH","L",AIEN)) Q:'AIEN  D
 . ;
 . NEW FNAME,FIRST,ERROR
 . ;
 . S FIRST=0
 . ;
 . ;If a list passed in limit to that. Otherwise display all
 . I FLIST]"",FLIST'[AIEN Q
 . ;
 . ;Get the filename
 . S FNAME=$$GET1^DIQ(9002319.13,AIEN_",",.11,"I")
 . ;
 . ;Loop through activity display
 . S ERR="" F  S ERR=$O(^XTMP("BUSAARCH","L",AIEN,ERR)) Q:'ERR  D
 .. S ERROR=$G(^XTMP("BUSAARCH","L",AIEN,ERR))
 .. ;
 .. I $E(ERROR,1,12)="Opened file " Q  ;Skip opens
 .. I $E(ERROR,1,12)="Closed file " Q  ;Skip closes
 .. I 'FIRST W !!,"Filename: ",FNAME,! S FIRST=1
 .. ;
 .. ;Display the error
 .. W !,ERROR
 ;
 W !!,"Please fix the error(s) and reload the file(s)",!
 ;
 ;Continue
 W !
 S DIR(0)="FO^0:30"
 S DIR("A")="Press Enter to Continue"
 K DIR("B")
 D ^DIR
 ;
 Q
 ;
CWARN(AIEN) ;Check for warnings on creation
 ;
 NEW EVENT,WARN
 S (WARN,EVENT)=0 F  S EVENT=$O(^XTMP("BUSAARCH","C",AIEN,EVENT)) Q:'EVENT  D  Q:WARN=1
 . I $G(^XTMP("BUSAARCH","C",AIEN,EVENT))["HASH mismatch" S WARN=1
 Q WARN
 ;
DFILE(PATH) ;Check for deleted files in archive path
 ;
 NEW FNAME,STS,DLIST,DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT
 ;
 ;If no deleted files exit
 I '$D(^XTMP("BUSAARCH","DFILE")) Q 1
 ;
 W !!,"Deleted file list found. Checking to make sure each file has"
 W !,"been removed from the archive folder location.",!
 ;
 S STS=1
 S FNAME="" F  S FNAME=$O(^XTMP("BUSAARCH","DFILE",FNAME)) Q:FNAME=""  D
 . ;
 . NEW CSTS
 . ;
 . ;Attempt to open the file - Quit if not found
 . U 0 W !,"Searching for file: ",FNAME
 . I $$DEVICE^BUSAAUT("R",PATH,FNAME) U 0 W " ...not found" Q
 . ;
 . ;Close the file
 . S CSTS=$$DEVICE^BUSAAUT("C",PATH,FNAME)
 . ;
 . ;Record that file was found
 . S DLIST(FNAME)="",STS=0
 . U 0 W " ...found"
 ;
 ;Display file list
 I $D(DLIST) D
 . W !!,"The following archive files were found in the archive folder"
 . W !,"and must be removed prior to running the new archive process."
 . W !,"Please remove the files from the archive folder and then rerun"
 . W !,"the file creation option."
 . W !!,"Filename: "
 . S FNAME="" F  S FNAME=$O(DLIST(FNAME)) Q:FNAME=""  D
 .. W !,FNAME
 . ;
 . ;Continue
 . W !
 . S DIR(0)="FO^0:30"
 . S DIR("A")="Press Enter to Continue"
 . K DIR("B")
 . D ^DIR
 ;
 Q STS
