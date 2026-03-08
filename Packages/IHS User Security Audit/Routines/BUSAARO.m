BUSAARO ;GDIT/HS/BEE-BUSA Archive Menu Options ; 06 Mar 2013  1:52 PM
 ;;1.0;IHS USER SECURITY AUDIT;**3**;Nov 05, 2013;Build 47
 ;
 Q
 ;
AI ;EP - BUSA ARCHIVE BUSA INFORMATION option
 ;
 NEW FNAME,PATH,LRM,LRIEN,BIENDT,LRMDT,LRANGE,DIR,FND,A2DT,I,A1YR,X,Y,ERR
 NEW DTOUT,DUOUT,DIRUT,DIROUT,LDT,BSUM,BDET,BSIEN,STS,TASK,QUIT,DFDAT,USER,KSKIP
 ;
 ;Reset status kill flag
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
 L +^XTMP("BUSAARCH",1):1 E  D  G XAI
 . W !!,"<Another archive process is currently running. Please try again later>"
 . I $D(^XTMP("BUSAARCH","STS")) W !!,"Status: ",$G(^XTMP("BUSAARCH","STS"))
 . H 4
 . S KSKIP=1
 . W:$D(IOF) @IOF
 . D BANNER^BUSAARO("M")
 L -^XTMP("BUSAARCH",1)
 ;
 ;Look for existing process
 S STS=$$ASTS^BUSAARST(0) W !! I STS=0 D  G XAI
 . D BANNER^BUSAARO("M")
 ;
 ;Retrieve the first record to archive
 ;
 ;If no previous archive start over
 I STS=1 D
 . ;
 . ;First look for last archived entry
 . S BIEN=$$ANEXT() Q:BIEN
 . ;
 . ;Retrieve the first record on file
 . S BIEN=$O(^BUSAS(0))
 ;
 ;If adding to existing created files
 I STS=2 D  I $G(ERR) H 4 G XAI
 . NEW LBIEN,LFIEN
 . ;
 . ;Retrieve next record not sent to a file
 . S LFIEN=$O(^BUSAAH("C","C",""),-1)  ;First look for created
 . I LFIEN="" S LFIEN=$O(^BUSAAH("C","V",""),-1)  ;Then look for verified
 . I LFIEN="" D  Q
 .. W !!,"<The BUSA ARCHIVE HISTORY file is corrupted - No Entry Found>"
 .. W !,"<Please run the process again and choose to clear out the files and start over>"
 .. S ERR=1
 . S LBIEN=$$GET1^DIQ(9002319.13,LFIEN_",",.06,"I")
 . I LBIEN="" D  Q
 .. W !!,"<The BUSA ARCHIVE HISTORY file is corrupted - Last ARCHIVE record not found>"
 .. W !,"<Please run the process again and choose to clear out the files and start over>"
 .. S ERR=1
 . S BIEN=$O(^BUSAS(LBIEN))
 ;
 I 'BIEN W !!,"No BUSA Summary file information found" H 4 G XAI
 S BIENDT=$$GET1^DIQ(9002319.01,BIEN_",",.01,"I") I BIENDT="" D  G XAI
 . W !!,"The first date on file in the BUSA Summary file could not be determined" H 4
 ;
 ;Establish look back range - set to 24 months
 S LRANGE=24
 ;
 ;Retrieve the last record on file for the selected date range
 S LRM=$P($$LM^BUSAAUT(LRANGE_"LM",DT),"^")  ;First get the date from the selected range
 S LRMDT=$O(^BUSAS("B",LRM),-1)  ;Try to locate the first entry prior to that date
 I LRMDT="" D  G XAI
 . W !!,"BUSA information can be archived up to the following date: ",$$FMTE^XLFDT(LRM,"5D")
 . W !,"The earliest non-archived BUSA date/time on file is: ",$TR($$FMTE^XLFDT(BIENDT,"5S"),"@"," ")
 . W !!,"No BUSA Summary file information meets the criteria to be archived",! H 5
 ;
 ;Get the first BUSA entry for that ending range
 S LRIEN=$O(^BUSAS("B",LRMDT,""))
 I LRIEN="" W !!,"No BUSA Summary file information records found to be archived" H 4 G XAI
 S LRMDT=$$GET1^DIQ(9002319.01,LRIEN_",",.01,"I") I LRMDT="" D  G XAI
 . W !!,"Issue found with the first BUSA Summary file entry available" H 4
 ;
 ;Select Archive To date - Go to the end of the starting date month
 S FND=0,A2DT=$P(BIENDT,".") F I=1:1:31 D  Q:FND
 . NEW X1,X2,X
 . S X1=A2DT,X2=1 D C^%DTC
 . I $E(X,4,5)'=$E(A2DT,4,5) S FND=1 Q
 . S A2DT=X
 ;
 ;Retrieve the 1 year maximum date - only allow up to one year to be processed at a time
 S A1YR=($E(BIENDT,1,3)+1)_$E(BIENDT,4,7)
 S X=A1YR D ^%DT I $G(Y)=-1 S $E(A1YR,6,7)="28"  ;Account for February 29
 S:A1YR>$P(LRMDT,".") A1YR=$P(LRMDT,".")
 ;
 ;Display header information
 W !!,"This option allows BUSA information to be archived into files so that the online"
 W !,"information can later be purged from the system. Running this option will only"
 W !,"create the archive file(s). It will not purge any date from the system."
 W !,"Reporting regulations require that a mininum range of auditing data remain on"
 W !,"the system. The latest date allowed for archiving is: ",$$FMTE^XLFDT(LRMDT,"5D"),!
 ;
 ;Display the current information
 W !!,"The earliest BUSA Summary information on file is for date: ",$$FMTE^XLFDT(BIENDT,"5D")
 W !,"With IEN: ",BIEN
 ;
 I (BIENDT'<LRMDT) W !!,"No BUSA Summary file information meets the criteria to be archived" H 4 G XAI
 ;
 S DFDAT=A2DT S:DFDAT>$P(LRMDT,".") DFDAT=$P(LRMDT,".")
 S DIR("B")=$$FMTE^XLFDT(DFDAT,"5D")
 S DIR(0)="DA^"_$P(BIENDT,".")_":"_A1YR_":EX"
 S DIR("A")="Enter the date to archive BUSA records to (up to "_$$FMTE^XLFDT(A1YR,"5D")_"): "
 S DIR("?")="Enter the latest date to archive BUSA records to. Archives are limited to one year from the earliest information on file (or to the maximum allowed archive date) which in this case is "_$$FMTE^XLFDT(A1YR,"5D")
 W !!,"Each archive process can be run for a maximum date range of one year from the"
 W !,"first audit entry on file. To get an idea of how much data will be archived,"
 W !,"it is recommended that, at first, a smaller date range, such as one month, be"
 W !,"used. Sites can then increase the date range used for future archives if"
 W !,"the amount of generated archived data can easily be handled.",!
 D ^DIR
 I ($G(DTOUT)]"")!($G(DUOUT)]"")!($G(DIRUT)]"")!($G(DIROUT)]"") G XAI
 I ('Y)!(Y<0) G XAI
 ;
 ;Retrieve the last record to output for the date
 S LRMDT=Y,LRMDT=LRMDT_".999999"
 S LRMDT=$O(^BUSAS("B",LRMDT),-1) I LRMDT="" D  G XAI
 . W !!,"Cannot locate last date to archive" H 4
 S LRIEN=$O(^BUSAS("B",LRMDT,""),-1) I LRIEN="" D  G XAI
 . W !!,"Cannot locate last IEN to archive" H 4
 ;
 ;Display the latest record to archive
 W !!,"The following record will be the final record archived:"
 W !,"Date/time: ",$TR($$FMTE^XLFDT(LRMDT,"5S"),"@"," ")," with IEN: ",LRIEN,!
 ;
 W !!,"Calculating the number of entries that will be archived. Each summary"
 W !,"and detail entry will be composed of one or more output records. In"
 W !,"addition, record cross references will also be archived. This"
 W !,"calculation process may take several minutes to complete:",!
 S BSUM=1,BDET=0 S BSIEN=BIEN F  S BSIEN=$O(^BUSAS(BSIEN)) Q:(BSIEN="")!(BSIEN>LRIEN)  D
 . ;
 . NEW BDIEN
 . ;
 . ;Increment summary counter
 . S BSUM=BSUM+1 I BSUM#20000=0 W "."
 . ;
 . ;Retrieve associated detail records
 . S BDIEN="" F  S BDIEN=$O(^BUSAD("B",BSIEN,BDIEN)) Q:BDIEN=""  S BDET=BDET+1
 ;
 ;Display the output records
 W !!,"Total BUSA Summary entries to be archived: ",BSUM
 W !,"Total BUSA Detail entries to be archived: ",BDET
 W !
 ;
 ;Retrieve the estimated file size
 S SIZE=$$SIZE^BUSAAUT() I SIZE="" G XAI
 ;
 ;Retrieve the path
 S PATH=$$PATH^BUSAAUT("W") I PATH="" G XAI
 ;
 ;Check for deleted file references
 S STS=$$DFILE^BUSAARST(PATH) I STS=0 G XAI
 ;
 ;Remove the deleted file list
 K ^XTMP("BUSAARCH","DFILE")
 ;
 ;Continue
 W !
 S DIR(0)="YA"
 S DIR("A")="Do you wish to continue: "
 S DIR("B")="N"
 D ^DIR
 I ($G(DTOUT)]"")!($G(DUOUT)]"")!($G(DIRUT)]"")!($G(DIROUT)]"") G XAI
 I Y'=1 G XAI
 I ('Y)!(Y<0) G XAI
 ;
 ;Queue or foreground
 W !!,"This process may make extensive use of system resources. It may also"
 W !,"require a large amount of storage space to complete. Please also make"
 W !,"sure that your system is not overloaded while this process is running"
 W !,"as it may impact system performance. In addition, this process may take"
 W !,"several hours to complete. It is therefore highly recommended that the"
 W !,"archive process be tasked off as a background process.",!
 S DIR(0)="YA"
 S DIR("A")="Would you like to queue this process: "
 S DIR("B")="Y"
 D ^DIR
 S USER=DUZ
 I ($G(DTOUT)]"")!($G(DUOUT)]"")!($G(DIRUT)]"")!($G(DIROUT)]"") G XAI
 I Y=1 S TASK=$$JOB(PATH,BIEN,BIENDT,LRIEN,SIZE,USER) D  G XAI
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
 . I RUN=1 W !!,"Background process ",TASK," has been started" H 4 Q
 . E  D
 .. W !!,"The background process ",TASK," has been queued but has either not started"
 .. W !,"or ran so quickly that its status wasn't captured. Verify Taskman"
 .. W !,"is running and run the BUSA archive option again in a few minutes to see if"
 .. W !,"it has started or display a history of completed processes to see if it"
 .. W !,"finished already."
 ;
 I Y'=0 W !!,"<Aborting the process>" H 4 G XAI
 ;
 ;Perform the archive
 W !!,"Running the archive process in the foreground:",!
 S STS=$$ARCHIVE^BUSAARAI(PATH,BIEN,BIENDT,LRIEN,SIZE,DUZ,0)
 I STS=0 W !!,"<Archive process failed. Please see errors stored in global ^XTMP(""BUSAARCH"")>" H 4 G XAI
 W !!,"Archive process completed successfully. Please run the Verify Archive option"
 W !,"to confirm that the archive files were generated correctly." H 5
 ;
 ;Exit the option
XAI L -^XTMP("BUSAARCH",0)
 I '$G(KSKIP) K ^XTMP("BUSAARCH","STS")
 Q
 ;
ANEXT() ;Retrieve next entry after latest archived entry
 ;
 NEW AIEN,LIEN
 ;
 S AIEN=0,LIEN="" F  S AIEN=$O(^BUSAAH(AIEN)) Q:'AIEN  D
 . ;
 . NEW ASTS,LARCH
 . ;
 . ;
 . ;Get the status - find the verified ones
 . S ASTS=$$GET1^DIQ(9002319.13,AIEN_",",.14,"I")
 . I ASTS'="A" Q
 . ;
 . ;Get the last archived record
 . S LARCH=$$GET1^DIQ(9002319.13,AIEN_",",.06,"I") Q:LARCH=""
 . S LIEN=LARCH
 ;
 ;If found increment by on
 I LIEN S LIEN=LIEN+1
 Q LIEN
 ;
JOB(PATH,BIEN,BIENDT,LRIEN,SIZE,USER) ;Queue off the background process
 ;
 NEW ZTDTH,ZTDESC,ZTRTN,ZTIO,ZTSAVE,ZTSK,BSTSOVR
 ;
 S ZTIO=""
 S ZTRTN="ARCHIVE^BUSAARO",ZTDESC="BUSA - Background Archive Process"
 S ZTSAVE("PATH")=""
 S ZTSAVE("BIEN")=""
 S ZTSAVE("BIENDT")=""
 S ZTSAVE("LRIEN")=""
 S ZTSAVE("SIZE")=""
 S ZTSAVE("USER")=""
 S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,1)
 D ^%ZTLOAD
 ;
 Q $G(ZTSK)
 ;
ARCHIVE ;Archive process task front end
 ;
 NEW STS
 ;
 I $G(PATH)="" Q
 I $G(BIEN)="" Q
 I $G(BIENDT)="" Q
 I $G(LRIEN)="" Q
 I $G(SIZE)="" Q
 I +$G(USER)=0 S USER=DUZ
 ;
 ;Perform the archive
 S STS=$$ARCHIVE^BUSAARAI(PATH,BIEN,BIENDT,LRIEN,SIZE,USER,1)
 ;
 Q
 ;
VA ;EP - BUSA VERIFY ARCHIVE option
 ;
 D VA^BUSAARVA
 ;
 Q
 ;
PA ;EP - BUSA PURGE BUSA RECORDS option
 ;
 D PU^BUSAARPU
 ;
 Q
 ;
LA ;EP - BUSA LOAD BUSA ARCHIVE FILE option
 ;
 D LA^BUSAARLA
 Q
 ;
RR ;EP - BUSA REMOVE RESTORED RECORDS option
 ;
 D RR^BUSAARPA
 ;
 Q
 ;
AR ;EP - BUSA ARCHIVE REPORT option
 ;
 D AR^BUSAARRP
 ;
 Q
 ;
BANNER(BUSATEXT) ;Display Archive Menu Banner
 ;
 NEW BUSA
 ;
 S BUSATEXT=$G(BUSATEXT)
 ;
 ;
 ;Main Archive Menu
 I $G(BUSATEXT)="" S BUSATEXT="TEXT",BUSALINE=3 D PRINT(BUSALINE) Q
 ;
 ;Regular BUSA Option
 S BUSATEXT="TEXT"_BUSATEXT
 F BUSAJ=1:1 S BUSAX=$T(@BUSATEXT+BUSAJ),BUSAX=$P(BUSAX,";;",2) Q:BUSAX="QUIT"!(BUSAX="")  S BUSALINE=BUSAJ
 D PRINT(BUSALINE)
 Q
 ;
EVENT(AIEN,TYPE,ERROR,WARN) ;Log the creation event
 ;
 NEW STS,FILE
 ;
 I $G(AIEN)="" Q
 I $G(TYPE)="" Q
 I $G(ERROR)="" Q
 S WARN=$G(WARN)
 S (FILE,STS)=""
 ;
 ;Handle creation file open
 I TYPE="CF" S TYPE="C",FILE=1
 ;
 ;Handle creation status
 I TYPE="CS" S TYPE="C",STS=1
 ;
 ;Handle verification file
 I TYPE="VF" S TYPE="V",FILE=1
 ;
 ;Handle verification status
 I TYPE="VS" S TYPE="V",STS=1
 ;
 ;Handle load status
 I TYPE="LS" S TYPE="S",STS=1
 ;
 ;Increment counter and log event
 I STS="",FILE="" D
 . S ^XTMP("BUSAARCH",TYPE,AIEN,"CNT")=$G(^XTMP("BUSAARCH",TYPE,AIEN,"CNT"))+1
 . S ^XTMP("BUSAARCH",TYPE,AIEN,^XTMP("BUSAARCH",TYPE,AIEN,"CNT"))=ERROR
 . I $G(WARN) D
 .. S ^XTMP("BUSAARCH",TYPE,AIEN,^XTMP("BUSAARCH",TYPE,AIEN,"CNT"),"W")=1
 .. S ^XTMP("BUSAARCH",TYPE,AIEN,"WARN")=1
 ;
 ;Log the status
 I STS=1 D
 . S ^XTMP("BUSAARCH",TYPE,AIEN,"STS")=ERROR
 ;
 ;Log the file
 I FILE=1 D
 . S ^XTMP("BUSAARCH",TYPE,AIEN,"FILE")=ERROR
 ;
 Q
 ;
PRINT(BUSALINE) ;Print the header
 NEW BUSAJ,BUSAX,BUSA
 ;
 W:$D(IOF) @IOF
 S BUSA("VERSION")=+$$VERSION^XPDUTL("BUSA") S:BUSA("VERSION")]"" BUSA("VERSION")="Version "_BUSA("VERSION")
 F BUSAJ=1:1:BUSALINE S BUSAX=$T(@BUSATEXT+BUSAJ),BUSAX=$P(BUSAX,";;",2) W !?80-$L(BUSAX)\2,BUSAX
 W !?80-(22+$L(BUSA("VERSION")))/2,"IHS USER SECURITY AUDIT ",BUSA("VERSION")
 I '$D(DUZ(2)) Q
 S BUSA("SITE")=$P($G(^DIC(4,DUZ(2),0)),"^") W !?80-$L(BUSA("SITE"))\2,BUSA("SITE")
 ;
TEXT ;
 ;;********************************
 ;;**   BUSA Data Archive Menu   **
 ;;********************************
 ;;QUIT
TEXTM ;
 ;;************************
 ;;**   BUSA Main Menu   **
 ;;************************
 ;;QUIT
TEXTAI ;
 ;;**********************************
 ;;**   Archive BUSA Information   **
 ;;**********************************
 ;;QUIT
TEXTVA ;
 ;;******************************************
 ;;**   Verify Archived BUSA Information   **
 ;;******************************************
 ;;QUIT
TEXTPA ;
 ;;*************************************
 ;;**   Purge Archived BUSA Records   **
 ;;*************************************
 ;;QUIT
TEXTLA ;
 ;;****************************************
 ;;**   Load Archived BUSA Information   **
 ;;****************************************
 ;;QUIT
TEXTRR ;
 ;;******************************************
 ;;**   Remove Restored BUSA Information   **
 ;;******************************************
 ;;QUIT
TEXTAR ;
 ;;*****************************
 ;;**   BUSA Archive Report   **
 ;;*****************************
 ;;QUIT
