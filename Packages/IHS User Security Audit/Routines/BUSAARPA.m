BUSAARPA ;GDIT/HS/BEE-BUSA Reload Purge Archive option ; 06 Mar 2013  1:52 PM
 ;;1.0;IHS USER SECURITY AUDIT;**3**;Nov 05, 2013;Build 47
 ;
 Q
 ;
RR ;Remove reloaded archived files
 ;
 NEW KSKIP,DTOUT,DUOUT,DIRUT,DIROUT,X,Y,DIR,STS,USER,TASK,RLOAD,AIEN,CNT,STOP,SEL
 NEW FNAME
 ;
 ;Reset status kill skip flag
 S (CNT,KSKIP)=0
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
 L +^XTMP("BUSAARCH",1):1 E  D  G XRA
 . W !!,"<Another archive process is currently running. Please try again later>"
 . I $D(^XTMP("BUSAARCH","STS")) W !!,"Status: ",$G(^XTMP("BUSAARCH","STS"))
 . S KSKIP=1
 . H 4
 . W:$D(IOF) @IOF
 . D BANNER^BUSAARO("M")
 L -^XTMP("BUSAARCH",1)
 K ^XTMP("BUSAARCH","STS")
 ;
 ;Check to see if there are reloaded files
 S AIEN=0 F  S AIEN=$O(^BUSAAH(AIEN)) Q:'AIEN  D
 . ;
 . NEW ASTS,RIEN
 . ;
 . ;Only include Archived status
 . S ASTS=$$GET1^DIQ(9002319.13,AIEN_",",.14,"I") Q:ASTS'="A"
 . ;
 . ;Pull the information for each archive
 . S FNAME=$$GET1^DIQ(9002319.13,AIEN_",",.11,"I")
 . ;
 . ;Loop through reloaded entries
 . S RIEN=0 F  S RIEN=$O(^BUSAAH(AIEN,1,RIEN)) Q:'RIEN  D
 .. ;
 .. NEW DA,IENS,PDT
 .. ;
 .. ;Look for entries that haven't been purged
 .. S DA(1)=AIEN,DA=RIEN,IENS=$$IENS^DILF(.DA)
 .. ;
 .. ;Get the purge date
 .. S PDT=$$GET1^DIQ(9002319.131,IENS,.04,"I") Q:PDT]""
 .. ;
 .. ;Found an entry
 .. S RLOAD(AIEN)=FNAME
 .. S RLOAD(AIEN,RIEN)=""
 ;
 ;Look to see if any loaded files were found
 I $O(RLOAD(""))="" D  G XRA
 . ;
 . W !!,"<There are no reloaded archive files to be removed>"
 . H 4
 . W:$D(IOF) @IOF
 . D BANNER^BUSAARO("M")
 ;
 ;Display the loaded files
 W !,"ENTRY",?10,"FILENAME"
 S (STOP,AIEN,SEL)="" F  S AIEN=$O(RLOAD(AIEN)) Q:'AIEN  D  Q:SEL!STOP
 . S CNT=CNT+1
 . S RLOAD("C",CNT)=AIEN
 . W !,CNT,?10,RLOAD(AIEN)
 . ;
 . ;Prompt for selection
 . I CNT#10=0 D
 .. S DIR("A")="Select the ENTRY # to be removed or hit enter to continue"
 .. S DIR(0)="FO^1:10"
 .. W !
 .. D ^DIR
 .. I $G(DTOUT)!$G(DUOUT)!$G(DIROUT) S STOP=1 Q
 .. ;
 .. ;An entry was selected
 .. I Y>0 D
 ... I '$D(RLOAD("C",Y)) Q
 ... S SEL=$G(RLOAD("C",Y))
 I 'STOP,'SEL,CNT#10'=0 D
 . S DIR("A")="Select the ENTRY # to be removed or hit enter to continue"
 . S DIR(0)="FO^1:10"
 . W !
 . D ^DIR
 . I $G(DTOUT)!$G(DUOUT)!$G(DIROUT) S STOP=1 Q
 . ;
 . ;An entry was selected
 . I Y>0 D
 .. I '$D(RLOAD("C",Y)) Q
 .. S SEL=$G(RLOAD("C",Y))
 ;
 ;Exit
 I STOP G XRA
 ;
 ;No selection
 I 'SEL W !!,"<An entry was not selected for removal>" H 4 G XRA
 ;
 ;Pull the information for each archive
 S FNAME=$$GET1^DIQ(9002319.13,SEL_",",.11,"I")
 ;
 W !!,"You have chosen to remove the records associated with the"
 W !,"following file out of the BUSA archives: ",!
 W !,FNAME
 W !!,"Are you sure you want to remove these records from the BUSA"
 W !,"Archive Summary and Detail RPMS files? Once the records have"
 W !,"been removed they can be reloaded again if needed. Type the"
 W !,"full word 'YES' to continue.",!
 S DIR(0)="YA"
 S DIR("A")="Remove reloaded records: "
 S DIR("B")="NO"
 D ^DIR
 I ($G(DTOUT)]"")!($G(DUOUT)]"")!($G(DIRUT)]"")!($G(DIROUT)]"") G XRA
 I Y'=1 G XRA
 I ('Y)!(Y<0) G XRA
 I X'="YES" W !!,"<The word 'YES' was not entered. Cancelling purge>" H 4 G XRA
 ;
 ;Queue or foreground
 W !!,"This process may make extensive use of system resources. Please make"
 W !,"sure that your system is not overloaded while this process is running"
 W !,"as it may impact system performance. In addition, this process may take"
 W !,"some time to complete. It is therefore highly recommended that the"
 W !,"reloaded recordarchive removal process be tasked off as a background"
 W !,"process.",!
 S DIR(0)="YA"
 S DIR("A")="Would you like to queue this process: "
 S DIR("B")="Y"
 D ^DIR
 I ($G(DTOUT)]"")!($G(DUOUT)]"")!($G(DIRUT)]"")!($G(DIROUT)]"") G XRA
 S USER=DUZ
 I Y=1 S TASK=$$JOB(SEL,USER) D  G XRA
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
 I Y'=0 W !!,"<Aborting the process>" H 3 G XRA
 ;
 ;Perform the record removal
 W !!,"Running the reloaded record removal process in the foreground:",!
 S STS=$$REMOVE(SEL,USER,0)
 ;
 ;Display purge results
 I STS=0 W !!,"The reloaded record removal process completed successfully.",!,"The records have now been properly removed." H 4
 I STS=1 W !!,"The reloaded record removal process failed." H 4
 ;
XRA L -^XTMP("BUSAARCH",0)
 I '$G(KSKIP) K ^XTMP("BUSAARCH","STS")
 Q
 ;
JOB(AIEN,USER) ;Queue off the background reloaded record removal process
 ;
 NEW ZTDTH,ZTDESC,ZTRTN,ZTIO,ZTSAVE,ZTSK,BSTSOVR
 ;
 S ZTIO=""
 S ZTRTN="JREMOVE^BUSAARPA",ZTDESC="BUSA - Background Reloaded Archive Removal Process"
 S ZTSAVE("AIEN")=""
 S ZTSAVE("USER")=""
 S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,1)
 D ^%ZTLOAD
 ;
 Q $G(ZTSK)
 ;
JREMOVE ;Reloaded archive removal process task front end
 ;
 NEW STS
 ;
 I +$G(AIEN)=0 Q
 I +$G(USER)=0 Q
 ;
 ;Perform the archive
 S STS=$$REMOVE(AIEN,USER,1)
 ;
 Q
 ;
REMOVE(AIEN,USER,QUEUE) ;Perform the reloaded archive removal process
 ;
 NEW X1,X2,X,STS,ERR,DCNT
 NEW FNAME,BSTS,SIEN,EIEN,BSUM,BDET,DA,DIK,%,HUPDATE,ERROR,RIEN,JOURNAL
 ;
 S QUEUE=$G(QUEUE)
 I +$G(USER)=0 S USER=DUZ
 ;
 ;Reset success
 S ERR=0
 ;
 ;Lock the process so others cannot run it
 L +^XTMP("BUSAARCH",1):1 E  Q 1
 ;
 ;Set up error handling, get current journal status and disable if needed
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BUSAARPA D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 S JOURNAL=$$CURRENT^%NOJRN() I JOURNAL D DISABLE^%NOJRN
 ;
 ;Create ^XTMP entry
 S X1=DT,X2=60 D C^%DTC
 S ^XTMP("BUSAARCH",0)=X_U_DT_U_"BUSA ARCHIVE RUN INFORMATION"
 ;
 S DCNT=0
 ;
 ;Pull the information for each archive
 S FNAME=$$GET1^DIQ(9002319.13,AIEN_",",.11,"I")
 ;
 ;Log start to BUSA
 S BSTS=$$LOG^BUSAAPI("A","S","","BUSAARPU","BUSA Archiving: Started removing records reloaded from file "_FNAME_" (#"_AIEN_")")
 ;
 ;Provide status
 I 'QUEUE U 0 W !,"Removing records reloaded reloaded from archive file: ",FNAME
 S ^XTMP("BUSAARCH","STS")="Removing records reloaded from archive file: "_FNAME
 D EVENT^BUSAARO(AIEN,"A","BUSA Archiving: Started removing records reloaded from file "_FNAME_" (#"_AIEN_")")
 ;
 ;Get the start IEN and end IEN
 S SIEN=$$GET1^DIQ(9002319.13,AIEN_",",.05,"I") I 'SIEN D  G RQUIT
 . D EVENT^BUSAARO(AIEN,"A","Purge aborted - Invalid FIRST ARCHIVE BUSA RECORD")
 . S ERR=1
 S EIEN=$$GET1^DIQ(9002319.13,AIEN_",",.06,"I") I 'EIEN D  G RQUIT
 . D EVENT^BUSAARO(AIEN,"A","Purge aborted - Invalid LAST ARCHIVE BUSA RECORD")
 . S ERR=1
 ;
 ;Remove archive summary and detail records
 S BSUM=SIEN-1 F  S BSUM=$O(^BUSASA(BSUM)) Q:(BSUM>EIEN)!'BSUM  D
 . ;
 . ;First remove detail records
 . S BDET="" F  S BDET=$O(^BUSADA("B",BSUM,BDET)) Q:BDET=""  D
 .. S DA=BDET,DIK="^BUSADA(" D ^DIK
 .. S DCNT=DCNT+1 I 'QUEUE I DCNT#20000=0 W "."
 .. ;
 . ;Now purge summary records
 . S DA=BSUM,DIK="^BUSASA(" D ^DIK
 . S DCNT=DCNT+1 I 'QUEUE I DCNT#20000=0 W "."
 ;
 ;Update history entry (or entries)
 D NOW^%DTC
 S RIEN=0 F  S RIEN=$O(^BUSAAH(AIEN,1,RIEN)) Q:'RIEN  D
 . NEW DA,IENS
 . S DA(1)=AIEN,DA=+RIEN,IENS=$$IENS^DILF(.DA)
 . S PDT=$$GET1^DIQ(9002319.131,IENS,.04) Q:PDT]""
 . ;
 . ;Found an entry
 . S HUPDATE(9002319.131,IENS,.04)=%
 . S HUPDATE(9002319.131,IENS,.05)=USER
 . D FILE^DIE("","HUPDATE","ERROR")
 ;
 ;Log end to BUSA
 S BSTS=$$LOG^BUSAAPI("A","S","","BUSAARPU","BUSA Archiving: Completed removing records reloaded from file "_FNAME_" (#"_AIEN_")")
 D EVENT^BUSAARO(AIEN,"R","BUSA Archiving: Completed removing records reloaded from file "_FNAME_" (#"_AIEN_")")
 ;
RQUIT I $G(JOURNAL) D ENABLE^%NOJRN
 L -^XTMP("BUSAARCH",1)
 K ^XTMP("BUSAARCH","STS")
 Q ERR
 ;
ERR ;Error occurred during process
 I $G(JOURNAL) D ENABLE^%NOJRN
 NEW %ERROR,EXEC
 S EXEC="S $"_"ZE=""<The BUSA RR process errored out>""" X EXEC
 S %ERROR="Please log a ticket with the BUSA Support Group for their assistance"
 D ^ZTER
 Q
