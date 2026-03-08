BJMDPUSH ;VNGT/HS/AM-Find modified patients since the last run ; 03 Apr 2010  6:33 PM
 ;;1.0;CDA/C32;**1,3,4**;Feb 08, 2011
 ;
EN ; Taskman Entry Point
 I '$G(ZTQUEUED) W !,"NHIE NIGHTLY JOB CAN ONLY RUN AS A SCHEDULED OPTION!" Q
 ; Task disabled; replaced by CCDA - 2/05/2014 GCD
 Q
 ;
 L +^BJMDPUSH:3 E  Q
 ; Set Error Trap
 N $ESTACK,$ETRAP S $ETRAP="D ERR1^BJMDPUSH D UNWIND^%ZTER"
 ;
 ; Check if CMessaging has been disabled
 I $P($G(^BJMDS(90607,1,0)),"^",7)'="Y" G EXIT
 ; Check if Install has completed
 I $P($G(^BJMDS(90607,1,0)),"^",8)="" G EXIT
 ; Check if user has %All role
 S EXEC="S ROLES=$roles" X EXEC
 I (","_ROLES_",")'[",%All," G EXIT
 ; New and initialize the ZTSTOP flag
 N ZTSTOP,ZTJRN S ZTSTOP=0
 ; Capture the current status of transaction processing during %Save
 S EXEC="S ZTJRN=##class(BJMD.Xfer.C32Main).GetTransactionMode()"
 X EXEC
 ; Disable transaction processing during %Save
 S EXEC="I ##class(BJMD.Xfer.C32Main).SetTransactionMode(0)"
 X EXEC
 ;
 ; New all variables including %BJMDDTS, which is used by FindPatients
 N EXEC,SC,%BJMDDTS
 S EXEC="set SC=##class(BJMD.Xfer.PushQueue).FindPatients()"
 X EXEC
 ; Set the value of ZTSTOP to 1 if the process aborted as per Taskman request
 S ZTSTOP='SC
 ; Restore the status of transaction processing during %Save to saved value
 S EXEC="I ##class(BJMD.Xfer.C32Main).SetTransactionMode(ZTJRN)"
 X EXEC
EXIT ;
 L -^BJMDPUSH
 Q
 ;
ERR1 ; Error trap for top of the routine
 ;
 ; Reset $ETRAP to prevent an infinite loop if the error trap 
 ; gets an error
 S $ETRAP="D UNWIND^%ZTER"
 ;
 ; Log error to the error trap
 D ^%ZTER
 ;
 L -^BJMDPUSH
 ; Restore the status of transaction processing during %Save to saved value
 I $G(ZTJRN)="" S ZTJRN=1
 S EXEC="I ##class(BJMD.Xfer.C32Main).SetTransactionMode(ZTJRN)"
 X EXEC
 ; $Quit=1 indicates whether the process was in a function call
 ; so we need to return a value
 I $QUIT Q ""
 Q
