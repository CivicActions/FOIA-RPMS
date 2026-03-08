BUSAARPU ;GDIT/HS/BEE-BUSA Purge Archive option ; 06 Mar 2013  1:52 PM
 ;;1.0;IHS USER SECURITY AUDIT;**3**;Nov 05, 2013;Build 47
 ;
 Q
 ;
PU ;Purge the archived files
 ;
 NEW KSKIP,DTOUT,DUOUT,DIRUT,DIROUT,X,Y,DIR,PATH,STS,USER,TASK
 ;
 ;Reset status kill skip flag
 S KSKIP=0
 ;
 ;Ensure no one else is in option
 ;
 L +^XTMP("BUSAARCH",0):1 E  D  Q
 . ;
 . W !!,"<Another user is currently utilizing this option. Please try again later>" H 4
 . W:$D(IOF) @IOF
 . D BANNER^BUSAARO("M")
 ;
 ;Make sure process is not already running
 L +^XTMP("BUSAARCH",1):1 E  D  G XPU
 . W !!,"<Another archive process is currently running. Please try again later>"
 . I $D(^XTMP("BUSAARCH","STS")) W !!,"Status: ",$G(^XTMP("BUSAARCH","STS"))
 . S KSKIP=1
 . H 4
 . W:$D(IOF) @IOF
 . D BANNER^BUSAARO("M")
 L -^XTMP("BUSAARCH",1)
 K ^XTMP("BUSAARCH","STS")
 ;
 ;Check to see if there are verified files
 I $O(^BUSAAH("C","V",""))="" D  G XPU
 . ;
 . NEW STS
 . ;
 . W !!,"<There are no archive files that are waiting to be purged>"
 . H 4
 . W:$D(IOF) @IOF
 . D BANNER^BUSAARO("M")
 ;
 ;Display the verified files
 D VDISP^BUSAARST(2)
 ;
 ;Display purge message
 W !!,"To purge the auditing information from the system, a final"
 W !,"check is required to confirm the existence of the archived files."
 W !,"After the purge is complete, it is recommended that these files"
 W !,"be moved to a secure location where they will not accidentally"
 W !,"get deleted."
 ;
 ;Retrieve the path
 S PATH=$$PATH^BUSAAUT("R") I PATH="" G XPU
 ;
 ;Look for the archived files
 S STS=$$VFILE(PATH) I STS=0 G XPU
 ;
 W !!,"All of the verified files have been located. Are you sure that"
 W !,"you want to purge the information contained in these files off"
 W !,"of the system? Once the data has been removed, it can only be"
 W !,"reloaded as archived auditing files. Type the full word 'YES'"
 W !,"at the prompt to proceed with the information purge.",!
 S DIR(0)="YA"
 S DIR("A")="Purge auditing information: "
 S DIR("B")="NO"
 D ^DIR
 I ($G(DTOUT)]"")!($G(DUOUT)]"")!($G(DIRUT)]"")!($G(DIROUT)]"") G XPU
 I Y'=1 G XPU
 I ('Y)!(Y<0) G XPU
 I X'="YES" W !!,"<The word 'YES' was not entered. Cancelling purge>" H 4 G XPU
 ;
 ;Queue or foreground
 W !!,"This process may make extensive use of system resources. Please make"
 W !,"sure that your system is not overloaded while this process is running"
 W !,"as it may impact system performance. In addition, this process may take"
 W !,"several hours to complete. It is therefore highly recommended that the"
 W !,"archive purge process be tasked off as a background process.",!
 S DIR(0)="YA"
 S DIR("A")="Would you like to queue this process: "
 S DIR("B")="Y"
 D ^DIR
 I ($G(DTOUT)]"")!($G(DUOUT)]"")!($G(DIRUT)]"")!($G(DIROUT)]"") G XPU
 S USER=DUZ
 I Y=1 S TASK=$$JOB(USER) D  G XPU
 . ;
 . NEW RUN,TRY
 . W !!,"Attempting to start the background process. This may take several minutes"
 . S RUN="" F TRY=1:1:90 D  H 1 Q:RUN
 .. ;
 .. W "."
 .. ;
 .. ;See if started
 .. L +^XTMP("BUSAARCH",1):1 E  S RUN=1 Q
 .. L -^XTMP("BUSAARCH",1)
 . ;
 . ;Display status
 . I RUN=1 W !!,"Background process ",TASK," has been started" H 3 Q
 . E  D
 .. W !!,"The background process ",TASK," has been queued but has either not started"
 .. W !,"or ran so quickly that its status wasn't captured. Verify Taskman"
 .. W !,"is running and run the BUSA purge archive option again in a few minutes to see"
 .. W !,"if it has started or display a history of completed processes to see if it"
 .. W !,"finished already."
 ;
 I Y'=0 W !!,"<Aborting the process>" H 3 G XPU
 ;
 ;Perform the purge
 W !!,"Running the archive purge process in the foreground:",!
 S STS=$$PURGE(USER,0)
 ;
 ;Display purge results
 I STS=0 W !!,"Archive purge process completed successfully. The records have now been properly",!,"archived." H 4
 I STS=1 W !!,"The archive purge process failed." H 4
 ;
XPU L -^XTMP("BUSAARCH",0)
 I '$G(KSKIP) K ^XTMP("BUSAARCH","STS")
 Q
 ;
VFILE(PATH) ;Check to make sure verified files can be found
 ;
 NEW AIEN,FNAME,FNTFND,ERR,PSTS
 ;
 ;Reset purge status
 S PSTS=1
 ;
 ;Display a list of any verified files
 W !!,"Searching for verified files in the chosen path:"
 S (ERR,AIEN)=0 F  S AIEN=$O(^BUSAAH(AIEN)) Q:'AIEN  D  Q:ERR
 . ;
 . NEW STS,FNAME,CSTS
 . ;
 . ;Get the filename
 . S FNAME=$$GET1^DIQ(9002319.13,AIEN_",",.11,"I") I FNAME="" D  Q
 .. W !!,"<File: 9002319.13, IEN: "_AIEN_" is corrupted - no Filename>"
 .. S ERR=1
 . ;
 . ;Get the status - only look for verified
 . S STS=$$GET1^DIQ(9002319.13,AIEN_",",.14,"I")
 . I STS'="V" Q
 . ;
 . ;Search for the file
 . U 0 W !,"Searching for file: ",FNAME
 . I $$DEVICE^BUSAAUT("R",PATH,FNAME) D  Q
 .. U 0 W " ...not found"
 .. S FNTFND(AIEN)=FNAME
 . U 0 W " ...found"
 . ;Close the file
 . S CSTS=$$DEVICE^BUSAAUT("C",PATH,FNAME)
 ;
 ;Display file list
 I $D(FNTFND) D
 . S PSTS=0
 . W !!,"The following archive file(s) were not found in the archive folder"
 . W !,"and must be placed into the folder before the purge can be run."
 . W !,"If the file(s) cannot be found then the archive process will have"
 . W !,"to be rerun to regenerate the file(s). When running the 'Archive"
 . W !,"BUSA Information' option, select 'C' to clear out all files and"
 . W !,"start over."
 . W !!,"Filename: "
 . S FNAME="" F  S FNAME=$O(FNTFND(FNAME)) Q:FNAME=""  D
 .. W !,FNTFND(FNAME)
 . ;
 . ;Continue
 . W !
 . S DIR(0)="FO^0:30"
 . S DIR("A")="Press Enter to Continue"
 . K DIR("B")
 . D ^DIR
 ;
 S:ERR PSTS=0
 ;
 Q PSTS
 ;
JOB(USER) ;Queue off the background purge process
 ;
 NEW ZTDTH,ZTDESC,ZTRTN,ZTIO,ZTSAVE,ZTSK,BSTSOVR
 ;
 S ZTIO=""
 S ZTRTN="JPURGE^BUSAARPU",ZTDESC="BUSA - Background Archive Purge Process"
 S ZTSAVE("USER")=""
 S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,1)
 D ^%ZTLOAD
 ;
 Q $G(ZTSK)
 ;
JPURGE ;Archive purge process task front end
 ;
 NEW STS
 ;
 I +$G(USER)=0 Q
 ;
 ;Perform the archive
 S STS=$$PURGE(USER,1)
 ;
 Q
 ;
PURGE(USER,QUEUE) ;Perform the purge process
 NEW AIEN,X1,X2,X,STS,ERR,PSTS,DCNT,JOURNAL
 ;
 S QUEUE=$G(QUEUE)
 I +$G(USER)=0 S USER=DUZ
 ;
 ;Reset success
 S PSTS=0
 ;
 ;Lock the process so others cannot run it
 L +^XTMP("BUSAARCH",1):1 E  S PSTS=1 G PQUIT
 ;
 ;Set up error handling, get current journal status and disable if needed
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BUSAARPU D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 S JOURNAL=$$CURRENT^%NOJRN() I JOURNAL D DISABLE^%NOJRN
 ;
 ;Create ^XTMP entry
 S X1=DT,X2=60 D C^%DTC
 S ^XTMP("BUSAARCH",0)=X_U_DT_U_"BUSA ARCHIVE RUN INFORMATION"
 ;
 ;Loop through the history file and find verified files
 S (ERR,AIEN,DCNT)=0 F  S AIEN=$O(^BUSAAH(AIEN)) Q:'AIEN  D  Q:ERR
 . ;
 . NEW ASTS,BSTS,SIEN,EIEN,BSUM,BDET,DA,DIK,%,HUPDATE,ERROR
 . ;
 . ;Get the status - find the verified ones
 . S ASTS=$$GET1^DIQ(9002319.13,AIEN_",",.14,"I")
 . I ASTS'="V" Q
 . ;
 . ;Pull the information for each archive
 . S FNAME=$$GET1^DIQ(9002319.13,AIEN_",",.11,"I")
 . ;
 . ;Log start to BUSA
 . S BSTS=$$LOG^BUSAAPI("A","S","","BUSAARPU","BUSA Archiving: Started purging BUSA records archived to file "_FNAME_" (#"_AIEN_")")
 . ;
 . ;Provide status
 . I 'QUEUE U 0 W !,"Purging BUSA records archived to file: ",FNAME
 . S ^XTMP("BUSAARCH","STS")="Purging BUSA records archived to file: "_FNAME
 . D EVENT^BUSAARO(AIEN,"A","BUSA Archiving: Started purging BUSA records archived to file "_FNAME_" (#"_AIEN_")")
 . ;
 . ;Get the start IEN and end IEN
 . S SIEN=$$GET1^DIQ(9002319.13,AIEN_",",.05,"I") I 'SIEN D  Q
 .. D EVENT^BUSAARO(AIEN,"A","Purge aborted - Invalid FIRST ARCHIVE BUSA RECORD")
 .. S ERR=1
 . S EIEN=$$GET1^DIQ(9002319.13,AIEN_",",.06,"I") I 'EIEN D  Q
 .. D EVENT^BUSAARO(AIEN,"A","Purge aborted - Invalid LAST ARCHIVE BUSA RECORD")
 .. S ERR=1
 . ;
 . ;Purge summary and detail records
 . S BSUM=SIEN-1 F  S BSUM=$O(^BUSAS(BSUM)) Q:(BSUM>EIEN)!'BSUM  D
 .. ;
 .. ;First purge detail records
 .. S BDET="" F  S BDET=$O(^BUSAD("B",BSUM,BDET)) Q:BDET=""  D
 ... S DA=BDET,DIK="^BUSAD(" D ^DIK
 ... S DCNT=DCNT+1 I 'QUEUE I DCNT#20000=0 W "."
 .. ;
 .. ;Now purge summary records
 .. S DA=BSUM,DIK="^BUSAS(" D ^DIK
 .. S DCNT=DCNT+1 I 'QUEUE I DCNT#20000=0 W "."
 . ;
 . ;Update history entry
 . D NOW^%DTC
 . I $G(%)]"" S HUPDATE(9002319.13,AIEN_",",.12)=%
 . I $G(USER)]"" S HUPDATE(9002319.13,AIEN_",",.13)=USER
 . S HUPDATE(9002319.13,AIEN_",",.14)="A"
 . D FILE^DIE("","HUPDATE","ERROR")
 . ;
 . ;Log end to BUSA
 . S BSTS=$$LOG^BUSAAPI("A","S","","BUSAARPU","BUSA Archiving: Completed purging BUSA records archived to file "_FNAME_" (#"_AIEN_")")
 . D EVENT^BUSAARO(AIEN,"A","BUSA Archiving: Completed purging BUSA records archived to file "_FNAME_" (#"_AIEN_")")
 ;
 I ERR S PSTS=1
 ;
PQUIT I $G(JOURNAL) D ENABLE^%NOJRN
 L -^XTMP("BUSAARCH",1)
 K ^XTMP("BUSAARCH","STS")
 Q PSTS
 ;
ERR ;Error occurred during process
 I $G(JOURNAL) D ENABLE^%NOJRN
 NEW %ERROR,EXEC
 S EXEC="S $"_"ZE=""<The BUSA PU process errored out>""" X EXEC
 S %ERROR="Please log a ticket with the BUSA Support Group for their assistance"
 D ^ZTER
 Q
