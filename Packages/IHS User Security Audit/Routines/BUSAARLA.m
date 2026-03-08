BUSAARLA ;GDIT/HS/BEE-BUSA Load Archive option ; 06 Mar 2013  1:52 PM
 ;;1.0;IHS USER SECURITY AUDIT;**3,4**;Nov 05, 2013;Build 71
 ;
 Q
 ;
LA ;Load the archived files
 ;
 NEW KSKIP,DTOUT,DUOUT,DIRUT,DIROUT,X,Y,DIR,PATH,STS,USER,TASK,QUIT,DONE,FLIST,AIEN
 ;
 ;Reset status kill skip flag
 S KSKIP=0
 ;
 ;Ensure no one else is in option
 ;
 L +^XTMP("BUSAARCH",0):1 E  D  Q
 . ;
 . W !!,"<Another user is currently utilizing a BUSA option. Please try again later>" H 4
 . W:$D(IOF) @IOF
 . D BANNER^BUSAARO("M")
 ;
 ;Make sure process is not already running
 L +^XTMP("BUSAARCH",1):1 E  D  G XLA
 . W !!,"<Another archive process is currently running. Please try again later>"
 . I $D(^XTMP("BUSAARCH","STS")) W !!,"Status: ",$G(^XTMP("BUSAARCH","STS"))
 . S KSKIP=1
 . H 4
 . W:$D(IOF) @IOF
 . D BANNER^BUSAARO("M")
 L -^XTMP("BUSAARCH",1)
 K ^XTMP("BUSAARCH","STS")
 ;
 ;Display previous load failures
 W ! D LLIST^BUSAARST()
 ;
 ;Display reload message
 W !!,"This option will allow an external BUSA archived file to be loaded into"
 W !,"the BUSA archive files so that the information contained in it can be"
 W !,"reviewed. This option will not interfere with existing BUSA auditing"
 W !,"functionality and reporting."
 W !!,"You will now be prompted to enter the name of the files that are to be"
 W !,"loaded. The filename lookup is case sensitive. After entering all of the"
 W !,"filenames to be loaded, hit enter to continue.",!
 ;
 S (QUIT,DONE)=0 F  D  Q:QUIT!DONE
 . ;
 . NEW FNAME,AIEN
 . ;
 . ;Prompt for filename
 . S DIR("A")="Enter the filename to load"
 . S DIR(0)="FO^1:80"
 . D ^DIR
 . I $G(DTOUT)!$G(DUOUT)!$G(DIROUT) S QUIT=1 Q
 . ;
 . ;Finished entering files
 . I Y="" S DONE=1 Q
 . S FNAME=Y
 . ;
 . ;Check in history
 . S AIEN=$$FCHK(FNAME) I 'AIEN Q
 . ;
 . ;Save the filename
 . S FLIST(AIEN)=FNAME
 ;
 ;Check for abort
 I QUIT=1 W !!,"<Process aborted>" H 4 G XLA
 ;
 ;Check for no filenames
 I '$D(FLIST) W !!,"<No filenames entered - process aborted>" H 4 G XLA
 ;
 ;Retrieve the path
 S PATH=$$PATH^BUSAAUT("R") I PATH="" G XLA
 ;
 ;Look for the archived files
 S STS=$$LFILE(PATH,.FLIST) I STS=0 G XLA
 ;
 ;Assemble list into a string
 S (FLIST,AIEN)="" F  S AIEN=$O(FLIST(AIEN)) Q:AIEN=""  S FLIST=FLIST_$S(FLIST="":"",1:U)_AIEN
 ;
 W !!,"All of the archived files have been located. Are you sure that"
 W !,"you want to load the information contained in these files into"
 W !,"the online BUSA archive files. Type the full word 'YES' to"
 W !,"load the files.",!
 S DIR(0)="YA"
 S DIR("A")="Load auditing information: "
 S DIR("B")="NO"
 D ^DIR
 I ($G(DTOUT)]"")!($G(DUOUT)]"")!($G(DIRUT)]"")!($G(DIROUT)]"") G XLA
 I Y'=1 G XLA
 I ('Y)!(Y<0) G XLA
 I X'="YES" W !!,"<The word 'YES' was not entered. Cancelling purge>" H 4 G XLA
 ;
 ;Queue or foreground
 W !!,"This process may make extensive use of system resources. Please make"
 W !,"sure that your system is not overloaded while this process is running"
 W !,"as it may impact system performance. In addition, this process may take"
 W !,"several hours to complete. It is therefore highly recommended that the"
 W !,"archive load process be tasked off as a background process.",!
 S DIR(0)="YA"
 S DIR("A")="Would you like to queue this process: "
 S DIR("B")="Y"
 D ^DIR
 I ($G(DTOUT)]"")!($G(DUOUT)]"")!($G(DIRUT)]"")!($G(DIROUT)]"") G XLA
 S USER=DUZ
 I Y=1 S TASK=$$JOB(PATH,FLIST,USER) D  G XLA
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
 I Y'=0 W !!,"<Aborting the process>" H 3 G XLA
 ;
 ;Perform the purge
 W !!,"Running the archive load process in the foreground:",!
 S STS=$$LOAD(PATH,FLIST,USER,0)
 ;
 ;Display load results
 U 0 I STS=0 W !!,"Archive load process completed successfully.",!,"The records have now been loaded." H 4
 I STS=1 W !!,"The archive load process failed" D LLIST^BUSAARST(FLIST)
 ;
XLA L -^XTMP("BUSAARCH",0)
 I '$G(KSKIP) K ^XTMP("BUSAARCH","STS")
 Q
 ;
FCHK(FNAME) ;Check for filename in archive history
 ;
 NEW AIEN,FIEN
 ;
 ;Loop through the file history and try to locate the history entry
 S AIEN=0,FIEN="" F  S AIEN=$O(^BUSAAH("D",$E(FNAME,1,30),AIEN)) Q:AIEN=""  D  Q:FIEN]""
 . ;
 . NEW HFNAME,ASTS,RIEN
 . ;
 . ;Get the full filename
 . S HFNAME=$$GET1^DIQ(9002319.13,AIEN_",",.11,"I") Q:HFNAME=""
 . ;
 . ;Compare
 . I HFNAME'=FNAME Q
 . ;
 . ;Get the status
 . S ASTS=$$GET1^DIQ(9002319.13,AIEN_",",.14,"I")
 . I ASTS'="A" W !,"<File has not been purged yet so it cannot be loaded>" S FIEN=0 Q
 . ;
 . ;Check if already reloaded and not purged
 . S RIEN=0 F  S RIEN=$O(^BUSAAH(AIEN,1,RIEN)) Q:'RIEN  D
 .. NEW DA,IENS,PDT
 .. S DA(1)=AIEN,DA=RIEN,IENS=$$IENS^DILF(.DA)
 .. ;
 .. ;Get the purge date
 .. S PDT=$$GET1^DIQ(9002319.131,IENS,.04,"I") Q:PDT]""
 .. ;
 .. ;Found entry that hasn't been purged
 .. W !,"<File has already been loaded and has not yet been purged>" S FIEN=0 Q
 .;
 . ;Save the entry
 . I FIEN'=0 S FIEN=AIEN
 ;
 ;Return failure if not found
 I FIEN="" W !,"<Filename not found in archive history>"
 S:FIEN=0 FIEN=""
 ;
 Q FIEN
 ;
LFILE(PATH,FLIST) ;Check to make sure archived files can be found
 ;
 NEW AIEN,FNAME,FNTFND,ERR,LSTS
 ;
 ;Reset purge status
 S LSTS=1
 ;
 ;Check for the files
 W !!,"Searching for archived files in the chosen path:"
 S (ERR,AIEN)=0 F  S AIEN=$O(FLIST(AIEN)) Q:'AIEN  D  Q:ERR
 . ;
 . NEW STS,FNAME,CSTS
 . ;
 . ;Get the filename
 . S FNAME=$$GET1^DIQ(9002319.13,AIEN_",",.11,"I") I FNAME="" D  Q
 .. W !!,"<File: 9002319.13, IEN: "_AIEN_" is corrupted - no Filename>"
 .. S ERR=1
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
 . S LSTS=0
 . W !!,"The following archive file(s) were not found in the archive folder"
 . W !,"and must be placed into the folder before they can be loaded."
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
 S:ERR LSTS=0
 ;
 Q LSTS
 ;
JOB(PATH,FLIST,USER) ;Queue off the background purge process
 ;
 NEW ZTDTH,ZTDESC,ZTRTN,ZTIO,ZTSAVE,ZTSK,BSTSOVR
 ;
 S ZTIO=""
 S ZTRTN="JLOAD^BUSAARLA",ZTDESC="BUSA - Background Archive Load Process"
 S ZTSAVE("PATH")=""
 S ZTSAVE("FLIST")=""
 S ZTSAVE("USER")=""
 S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,1)
 D ^%ZTLOAD
 ;
 Q $G(ZTSK)
 ;
JLOAD ;Archive load process task front end
 ;
 NEW STS
 ;
 I $G(PATH)="" Q
 I $G(FLIST)="" Q
 I +$G(USER)=0 Q
 ;
 ;Perform the archive
 S STS=$$LOAD(PATH,FLIST,USER,1)
 ;
 Q
 ;
LOAD(PATH,FLIST,USER,QUEUE) ;Perform the load process
 ;
 NEW AIEN,PIECE,X1,X2,X,STS,ERR,LSTS,DCNT,BDLAST,BDTOT,BSLAST,BSTOT,IEN,JOURNAL,BDT,USR
 ;
 I $G(PATH)="" S LSTS=1 G LQUIT
 I $G(FLIST)="" S LSTS=1 G LQUIT
 S QUEUE=$G(QUEUE)
 I +$G(USER)=0 S USER=DUZ
 ;
 ;Reset success
 S LSTS=0
 ;
 ;Lock the process so others cannot run it
 L +^XTMP("BUSAARCH",1):1 E  S LSTS=1 G LQUIT
 ;
 ;Set up error handling, get current journal status and disable if needed
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BUSAARLA D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 S JOURNAL=$$CURRENT^%NOJRN() I JOURNAL D DISABLE^%NOJRN
 ;
 ;Create ^XTMP entry
 S X1=DT,X2=60 D C^%DTC
 S ^XTMP("BUSAARCH",0)=X_U_DT_U_"BUSA ARCHIVE RUN INFORMATION"
 ;
 ;Loop through the file list and load each file
 F PIECE=1:1:$L(FLIST,U) S AIEN=$P(FLIST,U,PIECE) I AIEN]"" D  Q:LSTS=1
 . ;
 . NEW FNAME,OPEN,STS,CLOSE,ERROR,BSTS
 . ;
 . S STS=1
 . ;
 . ;Clear out previous run
 . K ^XTMP("BUSAARCH","L",AIEN)
 . K ^XTMP("BUSAARCH","LERR",AIEN)
 . ;
 . ;Pull the information for each archive
 . S FNAME=$$GET1^DIQ(9002319.13,AIEN_",",.11,"I")
 . ;
 . ;Open the file
 . S OPEN=0 I $$DEVICE^BUSAAUT("R",PATH,FNAME) D EVENT^BUSAARO(AIEN,"L","Unable to open "_FNAME_" file") S LSTS=1,STS=0
 . I STS=1 S OPEN=1
 . ;
 . ;Log the activity
 . I STS=1 D EVENT^BUSAARO(AIEN,"L","Opened file "_FNAME_" for loading")
 . ;
 . ;Log to BUSA
 . I STS=1 S BSTS=$$LOG^BUSAAPI("A","S","","BUSAARLA","BUSA Archiving: Opened file "_FNAME_" for archive loading")
 . ;
 . ;Provide status if not queued
 . I 'QUEUE U 0 W !,"Loading file: ",FNAME U IO
 . S ^XTMP("BUSAARCH","STS")="Loading archive file: "_FNAME
 . ;
 . ;Read in the file line by line
 . I STS=1 S STS=$$LREAD(AIEN,FNAME) I STS=0 S LSTS=1
 . ;
 . ;Close the file
 . S CLOSE=1 I OPEN,$$DEVICE^BUSAAUT("C",PATH,FNAME) D EVENT^BUSAARO(AIEN,"L","Unable to close "_FNAME_" file") S LSTS=1,STS=0,CLOSE=0 Q
 . ;
 . ;Log the activity
 . I OPEN=1,CLOSE=1 D EVENT^BUSAARO(AIEN,"L","Closed file "_FNAME_" after loading")
 . ;
 . ;Log to BUSA
 . I OPEN=1,CLOSE=1 S BSTS=$$LOG^BUSAAPI("A","S","","BUSAARLA","BUSA Archiving: Closed file "_FNAME_" after archive loading")
 . ;
 . ;Log the status
 . ;
 . ;Failure
 . I STS=0 D
 .. D EVENT^BUSAARO(AIEN,"LS","0^Load failed")
 .. S ^XTMP("BUSAARCH","LERR",AIEN)=""
 . ;
 . ;Success
 . I STS=1 D  I $G(ERROR)]"" S STS=0
 .. NEW HUPDATE,%,DA,IENS,DIC,DLAYGO,X,Y
 .. ;
 .. ;Log
 .. D EVENT^BUSAARO(AIEN,"LS","1^Load succeeded")
 .. ;
 .. ;Update history entry
 .. D NOW^%DTC
 .. S DIC(0)="L",DA(1)=AIEN
 .. S DIC="^BUSAAH("_AIEN_",1,"
 .. L +^BUSAAH(AIEN,1,0):1 E  Q
 .. S X=%
 .. S DLAYGO=9002319.131 D ^DIC
 .. L -^BUSAAH(AIEN,1,0)
 .. I +Y<1 Q
 .. S DA(1)=AIEN,DA=+Y,IENS=$$IENS^DILF(.DA)
 .. S HUPDATE(9002319.131,IENS,.02)=USER
 .. S HUPDATE(9002319.131,IENS,.03)=$$GET1^DIQ(9002319.13,AIEN_",",".07","I")
 .. D FILE^DIE("","HUPDATE","ERROR")
 . ;
 . ;Display
 . I 'QUEUE U 0 W !,"Load ",$S(STS:"succeeded",1:"failed") U IO
 ;
 ;Recount records for headers
 S (BDLAST,BDTOT,BSLAST,BSTOT)=0
 ;
 ;Update detail archive
 S IEN=0 F  S IEN=$O(^BUSADA(IEN)) Q:'IEN  S BDLAST=IEN,BDTOT=BDTOT+1
 S $P(^BUSADA(0),U,3,4)=BDLAST_U_BDTOT
 ;
 ;Update summary archive and make sure "B" cross reference is set up
 S IEN=0 F  S IEN=$O(^BUSASA(IEN)) Q:'IEN  D  S BSLAST=IEN,BSTOT=BSTOT+1
 . S BDT=$P($G(^BUSASA(IEN,0)),U) I BDT]"",'$D(^BUSASA("B",BDT,IEN)) S ^BUSASA("B",BDT,IEN)=""
 . S USR=$P($G(^BUSASA(IEN,0)),U,2) I USR]"",'$D(^BUSASA("C",USR,IEN)) S ^BUSASA("C",USR,IEN)=""
 S $P(^BUSASA(0),U,3,4)=BSLAST_U_BSTOT
 ;
LQUIT I $G(JOURNAL) D ENABLE^%NOJRN
 L -^XTMP("BUSAARCH",1)
 K ^XTMP("BUSAARCH","STS")
 Q LSTS
 ;
LREAD(AIEN,FNAME) ;Process each file
 ;
 NEW REC,LREC,RCNT,STS,DRCNT,ESTOP,BSUM,BDET
 ;
 ;Reset maximum error counter
 S ESTOP=0
 ;
 ;Read the first record
 U IO R REC:2 E  S REC=""
 I FNAME'=REC D ERROR(AIEN,1,"of file: "_REC_" does not match the recorded filename of "_FNAME,.STS,.ESTOP) Q 0
 ;
 ;Read remaining records
 S (STS,RCNT)=1
 S (BSUM,BDET,LREC)="" F  U IO R REC:2 S:$G(REC)="" REC="" Q:((LREC="")&(REC=""))  Q:$E(REC,1,12)="LAST RECORD^"  D  S LREC=REC I ESTOP>24 D ERROR(AIEN,RCNT,"Maximum errors reached",.STS,.ESTOP) Q
 . ;
 . NEW S
 . ;
 . ;Convert $c(10)/$c(13) back
 . S REC=$TR(REC,$C(28),$C(13))
 . S REC=$TR(REC,$C(29),$C(10))
 . ;
 . ;Increment record counter
 . S RCNT=RCNT+1
 . ;
 . ;BUSA summary reference
 . I $E(REC,1,6)="^BUSAS" S BSUM=$$BSUM(REC,RCNT,.STS,.ESTOP) Q
 . ;
 . ;BUSA detail reference
 . I $E(REC,1,6)="^BUSAD" S BDET=$$BDET(REC,RCNT,.STS,.ESTOP) Q
 . ;
 . ;Summary value string
 . I BSUM]"" S S=$$VALUE(REC,BSUM),BSUM="" Q
 . ;
 . ;Detail value string
 . I BDET]"" S S=$$VALUE(REC,BDET),BDET="" Q
 . ;
 . ;Unmatched data value
 . D ERROR(AIEN,RCNT,"'"_REC_"' has data string without a global reference",.STS,.ESTOP)
 ;
 ;Check the last record
 I ESTOP<25 D
 . I $E(REC,1,12)'="LAST RECORD^" D ERROR(AIEN,RCNT,"The last record of "_FNAME_" is corrupted",.STS,.ESTOP)
 . I $P(REC,U,2)'=RCNT D ERROR(AIEN,RCNT,"Record count in last record ("_$P(REC,U,2)_") does not match total records ("_RCNT_")",.STS,.ESTOP)
 . S DRCNT=$$GET1^DIQ(9002319.13,AIEN_",",".07","I")
 . I DRCNT'=RCNT D ERROR(AIEN,RCNT,"Record count in archive definition ("_DRCNT_") does not match total records ("_RCNT_")",.STS,.ESTOP)
 ;
 Q STS
 ;
VALUE(X,REF) ;Save the value
 ;
 ;Quit if issue with reference
 I REF=-1 Q 1
 ;
 ;Save the entry
 S @REF=X
 ;
 Q 1
 ;
BSUM(X,CNT,STS,ESTOP) ;Review ^BUSAS reference
 ;
 NEW RETURN,REF
 ;
 S RETURN="^BUSASA("_$P(X,"(",2,99)
 ;
 ;Check format
 I X'["(" D ERROR(AIEN,CNT,"'"_X_"' missing opening parenthesis",.STS,.ESTOP) Q -1
 I X'[")" D ERROR(AIEN,CNT,"'"_X_"' missing closing parenthesis",.STS,.ESTOP) Q -1
 ;
 ;Check "B" cross reference
 I $E(X,8,10)="""B""" D  Q RETURN
 . S REF="^BUSASA("_$P(X,"(",2,99)
 . S @REF=""
 . S RETURN=""
 ;
 ;Check "C" cross reference
 I $E(X,8,10)="""C""" D  Q RETURN
 . S REF="^BUSASA("_$P(X,"(",2,99)
 .S @REF=""
 . S RETURN=""
 ;
 Q RETURN
 ;
BDET(X,CNT,STS,ESTOP) ;Review ^BUSAD reference
 ;
 NEW RETURN,REF
 ;
 S RETURN="^BUSADA("_$P(X,"(",2,99)
 ;
 ;Check format
 I X'["(" D ERROR(AIEN,CNT,"'"_X_"' missing opening parenthesis",.STS,.ESTOP) Q -1
 I X'[")" D ERROR(AIEN,CNT,"'"_X_"' missing closing parenthesis",.STS,.ESTOP) Q -1
 ;
 ;Check "B" cross reference
 I $E(X,8,10)="""B""" D  Q RETURN
 . S REF="^BUSADA("_$P(X,"(",2,99)
 . S @REF=""
 . S RETURN=""
 ;
 ;Check "C" cross reference
 I $E(X,8,10)="""C""" D  Q RETURN
 . S REF="^BUSADA("_$P(X,"(",2,99)
 . S @REF=""
 . S RETURN=""
 ;
 Q RETURN
 ;
ERROR(AIEN,CNT,ERROR,STS,ESTOP) ;Log load error
 D EVENT^BUSAARO(AIEN,"L","Record "_$E(CNT_"            ",1,12)_ERROR)
 S STS=0
 S ESTOP=$G(ESTOP)+1
 Q
 ;
ERR ;Error occurred during process
 I $G(JOURNAL) D ENABLE^%NOJRN
 NEW %ERROR,EXEC
 S EXEC="S $"_"ZE=""<The BUSA LA process errored out>""" X EXEC
 S %ERROR="Please log a ticket with the BUSA Support Group for their assistance"
 D ^ZTER
 Q
