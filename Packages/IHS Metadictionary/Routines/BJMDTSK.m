BJMDTSK ;VNGT/HS/AM-C32 Task ; 14 Dec 2009  2:25 PM
 ;;1.0;CDA/C32;**1,3,4**;Feb 08, 2011
 ;
EN ; Taskman Entry Point
 I '$G(ZTQUEUED) W !,"C MESSAGING GENERATOR CAN ONLY RUN AS A SCHEDULED OPTION!" Q
 ; Task disabled; replaced by CCDA - 2/05/2014 GCD
 Q
 ;
 L +^BJMDTSK:3 E  Q
 ; Set Error Trap
 N $ESTACK,$ETRAP S $ETRAP="D ERR1^BJMDTSK D UNWIND^%ZTER"
 ;
 ; Check if CMESSAGING has been disabled
 I $P($G(^BJMDS(90607,1,0)),"^",7)'="Y" G Q
 ; Check if FM2C has completed
 I $P($G(^BJMDS(90607,1,0)),"^",8)="" G Q
 ; Check if user has %All role
 S EXEC="S ROLES=$roles" X EXEC
 I (","_ROLES_",")'[",%All," G Q
 ; New and initialize the ZTSTOP flag
 N ZTSTOP,ZTJRN,ZTBAT
 S ZTSTOP=0
 ; Capture the current status of transaction processing during %Save
 S EXEC="S ZTJRN=##class(BJMD.Xfer.C32Main).GetTransactionMode()"
 X EXEC
 ; Disable transaction processing during %Save
 S EXEC="I ##class(BJMD.Xfer.C32Main).SetTransactionMode(0)"
 X EXEC
 ; Save the batch status so we can restore it when we stop or error out
 S EXEC="S ZTBAT=##class(BJMD.Xfer.C32Main).GetBatchStatus()"
 X EXEC
 ;
 ; This loop is defined so that if there is an error in EN1 or subsequent call,
 ; the error trap will quit back to here and continue processing.
 F  D EN1 Q:ZTSTOP
 ;
Q L -^BJMDTSK
 ; Restore the status of transaction processing during %Save to saved value
 I $G(ZTJRN)'="" S EXEC="I ##class(BJMD.Xfer.C32Main).SetTransactionMode(ZTJRN)" X EXEC
 ; Restore the batch status to the saved value
 I $G(ZTBAT)'="" S EXEC="I ##class(BJMD.Xfer.C32Main).SetBatchStatus(ZTBAT)" X EXEC
 Q
 ;
EN1 ;
 ; Error trap for this stack level
 N $ESTACK,$ETRAP S $ETRAP="D ERR2^BJMDTSK D UNWIND^%ZTER"
 ;
 ; New all variables
 ; Note that the % variables are set by C32Populate but we 
 ;   want them logged in the error log so we NEW them here
 N BJMDTIME,EXEC,SC,TODAY,%DFN,%BJMDQID
 ;
 ; Initialize variables
 S ZTSTOP=0,BJMDTIME=$P($G(^BJMDS(90607,1,0)),"^",2)
 I BJMDTIME="" S BJMDTIME=2
 ; 
 ; Loop until told to stop
 F  D  Q:ZTSTOP
 . ; 
 . ; Check if we should shut down
 . I '$$TM^%ZTLOAD() S ZTSTOP=1 Q
 . ; 
 . ; Check if CMESSAGING has been disabled while we were running
 . I $P($G(^BJMDS(90607,1,0)),"^",7)'="Y" S ZTSTOP=1 Q
 . ; 
 . ; Check if there are any requests to process
 . S EXEC="set SC=##class(BJMD.Xfer.C32Populate).ProcessRequest()"
 . X EXEC
 . ; Hang for 0.1-2 seconds as directed by site specific settings
 . I 'SC H BJMDTIME
 . ;
 Q
 ;
ERR1 ; Error trap for top of the routine
 ;
 ; Reset $ETRAP to prevent an infinite loop if the error trap 
 ; gets an error
 S $ETRAP="D UNWIND^%ZTER"
 ;
 ; Log error to the error trap and hang for 1 second in the unlikely
 ; event that we are in a tight error loop
 D ^%ZTER H 1
 ;
 L -^BJMDTSK
 ; Restore the status of transaction processing during %Save to saved value
 I $G(ZTJRN)="" S ZTJRN=1
 S EXEC="I ##class(BJMD.Xfer.C32Main).SetTransactionMode(ZTJRN)"
 X EXEC
 ; Restore the batch status to the saved value
 S EXEC="I ##class(BJMD.Xfer.C32Main).SetBatchStatus(ZTBAT)"
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
 S $ETRAP="D ERR1^BJMDTSK D UNWIND^%ZTER"
 ;
 ; If %BJMDQID is set, try to update the Queue entry to indicate an error occured
 I $G(%BJMDQID) S EXEC="do ##class(BJMD.Xfer.C32Populate).SetError("_%BJMDQID_")" X EXEC
 ;
 ; Log error to the error trap and hang for 1 second in the unlikely
 ; event that we are in a tight error loop
 D ^%ZTER H 1
 ;
 ; $Quit=1 indicates whether the process was in a function call so we need 
 ; to return a value
 I $QUIT Q ""
 Q
 ;
CCDAMSG W !,"C Messaging has been replaced by CCDA. Please use the appropriate CCDA option."
 Q
