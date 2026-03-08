BUSAARVA ;GDIT/HS/BEE-BUSA Verify Archive option ; 06 Mar 2013  1:52 PM
 ;;1.0;IHS USER SECURITY AUDIT;**3**;Nov 05, 2013;Build 47
 ;
 Q
 ;
VA ;Verify the archived files
 ;
 NEW AIEN,DTOUT,DUOUT,DIRUT,DIROUT,X,Y,DIR,PATH,STS,TASK,USER,KSKIP
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
 L +^XTMP("BUSAARCH",1):1 E  D  G XVA
 . W !!,"<Another archive process is currently running. Please try again later>"
 . I $D(^XTMP("BUSAARCH","STS")) W !!,"Status: ",$G(^XTMP("BUSAARCH","STS"))
 . S KSKIP=1
 . H 4
 . W:$D(IOF) @IOF
 . D BANNER^BUSAARO("M")
 L -^XTMP("BUSAARCH",1)
 K ^XTMP("BUSAARCH","STS")
 ;
 ;Check to see if there are unverified files
 I $O(^BUSAAH("C","C",""))="" D  G XVA
 . ;
 . NEW STS
 . ;
 . W !!,"<There are no archive files that are waiting to be verified>"
 . ;
 . ;Look for existing process
 . S STS=$$ASTS^BUSAARST(1)
 . W:$D(IOF) @IOF
 . D BANNER^BUSAARO("M")
 ;
 ;If verification process has already been run display results
 D VDISP^BUSAARST
 ;
 ;Display list of archived files awaiting verification
 W !!,"The following files have been created and are waiting to be verified:"
 W !!,"CREATION DATE",?18,"FILENAME",?65,$J("# RECORDS",10)
 S AIEN="" F  S AIEN=$O(^BUSAAH("C","C",AIEN)) Q:AIEN=""  D
 . NEW FNAME,ATIME,ARCNT,ASTDT,AENDT
 . ;
 . ;Pull the information for each archive
 . S FNAME=$$GET1^DIQ(9002319.13,AIEN_",",.11,"I")
 . S ATIME=$$GET1^DIQ(9002319.13,AIEN_",",.01,"I")
 . S ARCNT=$$GET1^DIQ(9002319.13,AIEN_",",.07,"I")
 . S ASTDT=$$GET1^DIQ(9002319.13,AIEN_",",.03,"I")
 . S AENDT=$$GET1^DIQ(9002319.13,AIEN_",",.04,"I")
 . W !,$TR($$FMTE^XLFDT(ATIME,"5MZ"),"@"," "),?18,FNAME,?65,$J(ARCNT,10)
 ;
 ;Continue
 W !
 S DIR(0)="YA"
 S DIR("A")="Do you wish to verify these files: "
 S DIR("B")="N"
 D ^DIR
 I ($G(DTOUT)]"")!($G(DUOUT)]"")!($G(DIRUT)]"")!($G(DIROUT)]"") G XVA
 I Y'=1 G XVA
 I ('Y)!(Y<0) G XVA
 ;
 ;Retrieve the path
 S PATH=$$PATH^BUSAAUT("R") I PATH="" G XVA
 ;
 ;Queue or foreground
 W !!,"This process may make extensive use of system resources. Please make"
 W !,"sure that your system is not overloaded while this process is running"
 W !,"as it may impact system performance. In addition, this process may take"
 W !,"several hours to complete. It is therefore highly recommended that the"
 W !,"archive verification process be tasked off as a background process.",!
 S DIR(0)="YA"
 S DIR("A")="Would you like to queue this process: "
 S DIR("B")="Y"
 D ^DIR
 I ($G(DTOUT)]"")!($G(DUOUT)]"")!($G(DIRUT)]"")!($G(DIROUT)]"") G XVA
 S USER=DUZ
 I Y=1 S TASK=$$JOB(PATH,USER) D  G XVA
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
 .. W !,"is running and run the BUSA archive option again in a few minutes to see if"
 .. W !,"it has started or display a history of completed processes to see if it"
 .. W !,"finished already."
 ;
 I Y'=0 W !!,"<Aborting the process>" H 3 G XVA
 ;
 ;Perform the verification
 W !!,"Running the archive verification process in the foreground:",!
 S STS=$$VERIFY(PATH,USER,0)
 ;
 ;Display verification results
 U 0 I STS=0 D VDISP^BUSAARST(1) G XVA
 W !!,"Archive verification process completed successfully. The records can now",!,"be purged." H 4
 ;
XVA L -^XTMP("BUSAARCH",0)
 I '$G(KSKIP) K ^XTMP("BUSAARCH","STS")
 Q
 ;
JOB(PATH,USER) ;Queue off the background verification process
 ;
 NEW ZTDTH,ZTDESC,ZTRTN,ZTIO,ZTSAVE,ZTSK,BSTSOVR
 ;
 S ZTIO=""
 S ZTRTN="JVERIFY^BUSAARVA",ZTDESC="BUSA - Background Archive Verification Process"
 S ZTSAVE("PATH")=""
 S ZTSAVE("USER")=""
 S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,1)
 D ^%ZTLOAD
 ;
 Q $G(ZTSK)
 ;
JVERIFY ;Archive verification process task front end
 ;
 NEW STS
 ;
 I $G(PATH)="" Q
 I $G(USER)="" Q
 ;
 ;Perform the archive
 S STS=$$VERIFY(PATH,USER,1)
 ;
 Q
 ;
VERIFY(PATH,USER,QUEUE) ;Perform the verification process
 ;
 NEW AIEN,X1,X2,X,STS,JOURNAL
 ;
 ;Lock the process so others cannot run it
 L +^XTMP("BUSAARCH",1):1 E  S STS=0 G VQUIT
 ;
 ;Set up error handling, get current journal status and disable if needed
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BUSAARVA D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 S JOURNAL=$$CURRENT^%NOJRN() I JOURNAL D DISABLE^%NOJRN
 ;
 ;Reset success
 S STS=1
 ;
 ;Create ^XTMP entry
 S X1=DT,X2=60 D C^%DTC
 S ^XTMP("BUSAARCH",0)=X_U_DT_U_"BUSA ARCHIVE RUN INFORMATION"
 ;
 ;Loop through each file
 S AIEN="" F  S AIEN=$O(^BUSAAH("C","C",AIEN)) Q:AIEN=""  D  I STS=0 Q
 . NEW FNAME,ATIME,ARCNT,ASTDT,AENDT,VISSUE,BSTS,OPEN,CLOSE,ERROR
 . ;
 . S STS=1
 . ;
 . ;Clear out previous run
 . K ^XTMP("BUSAARCH","V",AIEN)
 . ;
 . ;Pull the information for each archive
 . S FNAME=$$GET1^DIQ(9002319.13,AIEN_",",.11,"I")
 . ;
 . ;Open the file
 . S OPEN=0 I $$DEVICE^BUSAAUT("R",PATH,FNAME) D EVENT^BUSAARO(AIEN,"V","Unable to open "_FNAME_" file") S STS=0
 . I STS=1 S OPEN=1
 . ;
 . ;Log the activity
 . I STS=1 D
 .. D EVENT^BUSAARO(AIEN,"VF",FNAME)
 .. D EVENT^BUSAARO(AIEN,"V","Opened file "_FNAME_" for verification")
 . ;
 . ;Log to BUSA
 . I STS=1 S BSTS=$$LOG^BUSAAPI("A","S","","BUSAARVA","BUSA Archiving: Opened file "_FNAME_" for archive verification")
 . ;
 . ;Provide status if not queued
 . I 'QUEUE U 0 W !,"Verifying file: ",FNAME U IO
 . S ^XTMP("BUSAARCH","STS")="Verifying archive file: "_FNAME
 . ;
 . ;Read in the file line by line
 . I STS=1 S STS=$$VREAD(AIEN,FNAME)
 . ;
 . ;Close the file
 . S CLOSE=1 I OPEN,$$DEVICE^BUSAAUT("C",PATH,FNAME) D EVENT^BUSAARO(AIEN,"V","Unable to close "_FNAME_" file") S STS=0,CLOSE=0 Q
 . ;
 . ;Log the activity
 . I OPEN=1,CLOSE=1 D EVENT^BUSAARO(AIEN,"V","Closed file "_FNAME_" for verification")
 . ;
 . ;Log to BUSA
 . I OPEN=1,CLOSE=1 S BSTS=$$LOG^BUSAAPI("A","S","","BUSAARVA","BUSA Archiving: Closed file "_FNAME_" for archive verification")
 . ;
 . ;Log the status
 . ;
 . ;Failure
 . I STS=0 D EVENT^BUSAARO(AIEN,"VS","0^Verification failed")
 . ;
 . ;Success
 . I STS=1 D  I $G(ERROR)]"" S STS=0
 .. NEW HUPDATE,%
 .. ;
 .. ;Log
 .. D EVENT^BUSAARO(AIEN,"VS","1^Verification succeeded")
 .. ;
 .. ;Update history entry
 .. D NOW^%DTC
 .. S HUPDATE(9002319.13,AIEN_",",.08)=1
 .. I $G(%)]"" S HUPDATE(9002319.13,AIEN_",",.09)=%
 .. I $G(USER)]"" S HUPDATE(9002319.13,AIEN_",",.1)=USER
 .. S HUPDATE(9002319.13,AIEN_",",.14)="V"
 .. D FILE^DIE("","HUPDATE","ERROR")
 . ;
 . ;Display
 . I 'QUEUE U 0 W !,"Verification ",$S(STS:"succeeded",1:"failed") U IO
 ;
VQUIT I $G(JOURNAL) D ENABLE^%NOJRN
 L -^XTMP("BUSAARCH",1)
 Q STS
 ;
VREAD(AIEN,FNAME) ;Process each file
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
 . I BSUM]"" S S=$$BSVAL(REC,BSUM,RCNT,.STS,.ESTOP),BSUM="" Q
 . ;
 . ;Detail value string
 . I BDET]"" S S=$$BDVAL(REC,BDET,RCNT,.STS,.ESTOP),BDET="" Q
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
BSVAL(X,BSUM,CNT,STS,ESTOP) ;Review summary value
 ;
 ;Quit if issue with reference or undefined hash
 I BSUM=-1 Q 1
 ;
 ;Make sure values match
 I @BSUM'=X D ERROR(AIEN,CNT,"'"_X_"' does not match value found in entry '"_BSUM_"'",.STS,.ESTOP)
 ;
 Q 1
 ;
BDVAL(X,BDET,CNT,STS,ESTOP) ;Review detail value or undefined hash
 ;
 I BDET=-1 Q 1
 ;
 ;Make sure values match
 I @BDET'=X D ERROR(AIEN,CNT,"'"_X_"' does not match value found in entry '"_BDET_"'",.STS,.ESTOP)
 ;
 Q 1
 ;
BSUM(X,CNT,STS,ESTOP) ;Review ^BUSAS reference
 ;
 NEW RETURN
 ;
 S RETURN=X
 ;
 ;Check format
 I X'["(" D ERROR(AIEN,CNT,"'"_X_"' missing opening parenthesis",.STS,.ESTOP) Q -1
 I X'[")" D ERROR(AIEN,CNT,"'"_X_"' missing closing parenthesis",.STS,.ESTOP) Q -1
 ;
 ;Check "B" cross reference
 I $E(X,8,10)="""B""" D  Q RETURN
 . S RETURN=""
 . I '$D(@X) D ERROR(AIEN,CNT,"'"_X_"' ""B"" cross reference is not defined",.STS,.ESTOP)
 ;
 ;Check "C" cross reference
 I $E(X,8,10)="""C""" D  Q RETURN
 . S RETURN=""
 . I '$D(@X) D ERROR(AIEN,CNT,"'"_X_"' ""C"" cross reference is not defined",.STS,.ESTOP)
 ;
 ;Check hash entry
 I $P($P(X,")"),",",2)=2 D  Q RETURN
 . I '$D(@X) S RETURN=-1
 ;
 ;Check regular entry
 I '$D(@X) D  Q RETURN
 . D ERROR(AIEN,CNT,"'"_X_"' is undefined on the system",.STS,.ESTOP)
 . S RETURN=-1
 ;
 Q RETURN
 ;
BDET(X,CNT,STS,ESTOP) ;Review ^BUSAD reference
 ;
 NEW RETURN
 ;
 S RETURN=X
 ;
 ;Check format
 I X'["(" D ERROR(AIEN,CNT,"'"_X_"' missing opening parenthesis",.STS,.ESTOP) Q -1
 I X'[")" D ERROR(AIEN,CNT,"'"_X_"' missing closing parenthesis",.STS,.ESTOP) Q -1
 ;
 ;Check "B" cross reference
 I $E(X,8,10)="""B""" D  Q RETURN
 . S RETURN=""
 . I '$D(@X) D ERROR(AIEN,CNT,"'"_X_"' ""B"" cross reference is not defined",.STS,.ESTOP)
 ;
 ;Check "C" cross reference
 I $E(X,8,10)="""C""" D  Q RETURN
 . S RETURN=""
 . ;
 . ;Check for valid DFN
 . I $P(X,",",2)'?1N.N D  Q
 .. S:($P(X,",",2)'[$C(34)) $P(X,",",2)=$C(34)_$P(X,",",2)_$C(34)
 .. I $D(@X) D WARN(AIEN,CNT,"'"_X_"' ""C"" cross reference exists in RPMS but is corrupted",.STS) Q
 .. D ERROR(AIEN,CNT,"'"_X_"' ""C"" cross reference is not defined and entry is corrupted",.STS,.ESTOP)
 . I '$D(@X) D ERROR(AIEN,CNT,"'"_X_"' ""C"" cross reference is not defined",.STS,.ESTOP)
 ;
 ;Check hash entry
 I $P($P(X,")"),",",2)=3 D  Q RETURN
 . I '$D(@X) S RETURN=-1
 ;
 ;Check regular entry
 I '$D(@X) D  Q RETURN
 . D ERROR(AIEN,CNT,"'"_X_"' is undefined on the system",.STS,.ESTOP)
 . S RETURN=-1
 ;
 Q RETURN
 ;
ERROR(AIEN,CNT,ERROR,STS,ESTOP) ;Log verification error
 D EVENT^BUSAARO(AIEN,"V","Record "_$E(CNT_"            ",1,12)_ERROR)
 S STS=0
 S ESTOP=$G(ESTOP)+1
 Q
 ;
WARN(AIEN,CNT,ERROR,STS) ;Log verification warning
 D EVENT^BUSAARO(AIEN,"V","Record "_$E(CNT_"            ",1,12)_ERROR,1)
 Q
 ;
ERR ;Error occurred during process
 I $G(JOURNAL) D ENABLE^%NOJRN
 NEW %ERROR,EXEC
 S EXEC="S $"_"ZE=""<The BUSA VA process errored out>""" X EXEC
 S %ERROR="Please log a ticket with the BUSA Support Group for their assistance"
 D ^ZTER
 Q
