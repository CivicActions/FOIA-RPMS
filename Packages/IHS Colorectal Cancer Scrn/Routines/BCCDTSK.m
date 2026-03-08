BCCDTSK ;GDIT/HS/AM-CCDA Task ; 22 Feb 2013  2:25 PM
 ;;2.0;CCDA;**2**;Aug 12, 2020;Build 119
 ;
EN ; Taskman Entry Point
 I '$G(ZTQUEUED) W !,"C MESSAGING GENERATOR CAN ONLY RUN AS A SCHEDULED OPTION!" Q
 L +^BCCDTSK:3 E  D LOG("CANNOT OBTAIN LOCK") Q
 ; Set Error Trap
 N $ESTACK,$ETRAP S $ETRAP="D ERR1^BCCDTSK D UNWIND^%ZTER"
 ;
 ; Check if CCDA has been disabled
 I $P($G(^BCCDS(90310.01,1,0)),"^",4)'="Y" D LOG("CCDA DISABLED") G Q
 ; Check if installation has completed
 I $P($G(^BCCDS(90310.01,1,0)),"^",5)="" D LOG("INSTALLATION NOT COMPLETE") G Q
 ; Check if user has %All role
 S EXEC="S ROLES=$roles" X EXEC
 I (","_ROLES_",")'[",%All," D LOG("USER DOES NOT HAVE %ALL ROLE") G Q
 ; New and initialize the ZTSTOP flag
 N ZTSTOP,ZTJRN,ZTBAT
 S ZTSTOP=0
 ; Capture the current status of transaction processing during %Save
 S EXEC="S ZTJRN=##class(BCCD.Xfer.CCDMain).GetTransactionMode()"
 X EXEC
 ; Disable transaction processing during %Save
 S EXEC="I ##class(BCCD.Xfer.CCDMain).SetTransactionMode(0)"
 X EXEC
 ; Save the batch status so we can restore it when we stop or error out
 S EXEC="S ZTBAT=##class(BCCD.Xfer.CCDMain).GetBatchStatus()"
 X EXEC
 ;
 ; This loop is defined so that if there is an error in EN1 or subsequent call,
 ; the error trap will quit back to here and continue processing.
 F  D EN1 Q:ZTSTOP
 ;
Q L -^BCCDTSK
 ; Restore the status of transaction processing during %Save to saved value
 I $G(ZTJRN)'="" S EXEC="I ##class(BCCD.Xfer.CCDMain).SetTransactionMode(ZTJRN)" X EXEC
 ; Restore the batch status to the saved value
 I $G(ZTBAT)'="" S EXEC="I ##class(BCCD.Xfer.CCDMain).SetBatchStatus(ZTBAT)" X EXEC
 Q
 ;
EN1 ;
 ; Error trap for this stack level
 N $ESTACK,$ETRAP S $ETRAP="D ERR2^BCCDTSK D UNWIND^%ZTER"
 ;
 ; New all variables
 ; Note that the % variables are set by CCDPopulate but we 
 ;   want them logged in the error log so we NEW them here
 N BCCDTIME,EXEC,SC,TODAY,%DFN,%BCCDQID
 ;
 ; Initialize variables
 S ZTSTOP=0,BCCDTIME=$P($G(^BCCDS(90310.01,1,0)),"^",2)
 I BCCDTIME="" S BCCDTIME=2
 ; 
 ; Loop until told to stop
 F  D  Q:ZTSTOP
 . ; 
 . ; Check if we should shut down
 . I '$$TM^%ZTLOAD() S ZTSTOP=1 Q
 . ; 
 . ; Check if CCDA has been disabled while we were running
 . I $P($G(^BCCDS(90310.01,1,0)),"^",4)'="Y" S ZTSTOP=1 Q
 . ; 
 . ; Check if there are any requests to process
 . S EXEC="set SC=##class(BCCD.Xfer.CCDPopulate).ProcessRequest()"
 . X EXEC
 . ; Hang for 0.1-2 seconds as directed by site specific settings
 . I 'SC H BCCDTIME
 . ;
 Q
 ;
ERR1 ; Error trap for top of the routine
 ;
 ; Reset $ETRAP to prevent an infinite loop if the error trap 
 ; gets an error
 S $ETRAP="D UNWIND^%ZTER"
 ;
 N EXEC
 ; Log error to the error trap and hang for 1 second in the unlikely
 ; event that we are in a tight error loop
 D ^%ZTER H 1
 S EXEC="D ##class(BCCD.Audit.ErrorThrottle).Increment()" X EXEC
 ;
 L -^BCCDTSK
 ; Restore the status of transaction processing during %Save to saved value
 I $G(ZTJRN)="" S ZTJRN=1
 S EXEC="I ##class(BCCD.Xfer.CCDMain).SetTransactionMode(ZTJRN)"
 X EXEC
 ; Restore the batch status to the saved value
 S EXEC="I ##class(BCCD.Xfer.CCDMain).SetBatchStatus(ZTBAT)"
 X EXEC
 ; $Quit=1 indicates whether the process was in a function call so we need 
 ; to return a value
 I $QUIT Q ""
 Q
 ;
ERR2 ; Error trapping for inside of the loop
 ;
 ; Reset $ETRAP to prevent an infinite loop if the error trap
 ; gets an error
 S $ETRAP="D ERR1^BCCDTSK D UNWIND^%ZTER"
 ;
 N EXEC
 ; If %BCCDQID is set, try to update the Queue entry to indicate an error occured
 I $G(%BCCDQID) S EXEC="do ##class(BCCD.Xfer.CCDPopulate).SetError("_%BCCDQID_")" X EXEC
 ;
 ; Log error to the error trap and hang for 1 second in the unlikely
 ; event that we are in a tight error loop
 D ^%ZTER H 1
 S EXEC="D ##class(BCCD.Audit.ErrorThrottle).Increment()" X EXEC
 ;
 ; $Quit=1 indicates whether the process was in a function call so we need 
 ; to return a value
 I $QUIT Q ""
 Q
 ;
LOG(TEXT) ; Log reason task wasn't started
 N DIE,DA,%,%H,%I,X
 I $G(TEXT)="" S TEXT="@"
 D NOW^%DTC
 S TEXT=TEXT_"|"_%
 S DIE=90310.01,DA=1,DR="1///"_TEXT
 D ^DIE
 Q
 ;
STARTTSK(QID,THDNUM) ; Start an extract task
 N X,X1,X2,TODAY,NOW
 N ZTRTN,ZTDESC,ZTIO,ZTDTH,ZTSAVE
 ; First, set the ^XTMP nodes to mark the thread and Queue record in use
 ; Set purge date 60 days from today
 D NOW^%DTC
 S X1=X,X2=60,TODAY=X,NOW=%
 D C^%DTC
 S ^XTMP("BCCDTHREAD",0)=X_U_TODAY_U_"BCCD EXTRACT PROCESS"
 S ^XTMP("BCCDTHREAD","THREAD",THDNUM)=QID_U_NOW
 S ^XTMP("BCCDTHREAD","QUEUE",QID)=THDNUM_U_NOW
 ;
 ; Then schedule the extract task
 S ZTRTN="EXTSK^BCCDTSK",ZTDESC="CCDA Extract Task",ZTIO="",ZTDTH=$H
 S ZTSAVE("QID")="",ZTSAVE("THDNUM")=""
 D ^%ZTLOAD
 S $P(^XTMP("BCCDTHREAD","THREAD",THDNUM),U,3)=ZTSK
 S $P(^XTMP("BCCDTHREAD","QUEUE",QID),U,3)=ZTSK
 Q
 ;
EXTSK ; Extract task
 N $ESTACK,$ETRAP S $ETRAP="D EXERR^BCCDTSK D UNWIND^%ZTER"
 D @("##class(BCCD.Xfer.CCDPopulate).ExtractTask($g(QID),$g(THDNUM))")
 Q
 ;
EXERR ; Error trap for the extract task
 ; Reset $ETRAP to prevent an infinite loop if the error trap gets an error
 S $ETRAP=""
 ;
 ; If %BCCDQID is set, try to update the Queue entry to indicate an error occurred
 I $D(%BCCDQID)#2 D
 . K ^XTMP("BCCDTHREAD","QUEUE",%BCCDQID)
 . X "do ##class(BCCD.Xfer.CCDPopulate).SetError("_%BCCDQID_")"
 I $D(THDNUM)#2 K ^XTMP("BCCDTHREAD","THREAD",THDNUM)
 ;
 ; Log error to the error trap and hang for 1 second in the unlikely
 ; event that we are in a tight error loop
 D ^%ZTER H 1
 X "D ##class(BCCD.Audit.ErrorThrottle).Increment()"
 ;
 ; $Quit=1 indicates whether the process was in a function call so we need 
 ; to return a value
 I $QUIT Q ""
 Q
 ;
TASKSTAT(TASKID) ; Get task status
 N ZTSK
 S ZTSK=$G(TASKID)
 D STAT^%ZTLOAD
 Q $G(ZTSK(1))
