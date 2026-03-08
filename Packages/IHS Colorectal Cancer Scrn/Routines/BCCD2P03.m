BCCD2P03 ;GDIT/HS/GCD-Post-Install; 22 Feb 2023  1:23 PM
 ;;2.0;CCDA;**3**;Aug 12, 2020;Build 139
 Q
 ;
POST ;
 N DIC,DIE,DIK,DA,DR,DTOUT
 N PRUN,CRUN,I,ERR,TRNM,TRIEN,BCCD,CLASS,TIME
 ;
 D BMES^XPDUTL("Starting Post-Install Routine")
 I $G(DT)="" D DT^DICRW
 ;
 ; Set the CCDA Enabled flag to NO to stop the CCDA background job.
 D BMES^XPDUTL("  Stopping BCCD background processes")
 K DA,DIC,DIE,DR,DTOUT
 S DIE=90310.01,DA=1,DR=".04///N"
 D ^DIE
 ;
 ; Now that "Enabled" has been to NO, make sure that BCCDPUSH and BCCDTSK are not running
 S PRUN=1,CRUN=1
 F I=1:1:121 D  I 'PRUN,'CRUN Q
 . I I=10 D BMES^XPDUTL("    Waiting for current CCDA tasks to stop")
 . I 'PRUN,'CRUN Q
 . I PRUN S PRUN=$$CKOPTSCH("BCCD NHIE PUSH JOB")
 . I CRUN S CRUN=$$CKOPTSCH("BCCD BACKGROUND JOB")
 . H 1
 I I=121 D ERRMSG("  Could not stop CCDA jobs.  Post-install aborted.") G Q
 ;
 ; Check for locks to verify that the tasks are stopped.
 I $$LOCK^BCCDPAT("^BCCDTSK")!$$LOCK^BCCDPAT("^BCCDPUSH") D ERRMSG("  Could not stop CCDA jobs.  Post-install aborted.") G Q
 ;
 ; Stop the CCDA production
 D BMES^XPDUTL("  Stopping the CCDA production")
 I '$$STOPPROD() D BMES^XPDUTL("  Unable to stop the CCDA production. Post-install aborted.")
 ;
 ; Import BCCD classes
 D BMES^XPDUTL("  Importing BCCD package")
 K ERR
 S TRNM=$G(@XPDGREF@("SENT REC"))
 I TRNM="" D ERRMSG("  Error occurred duing import.  Post-install aborted.") G Q
 S TRIEN=$O(^BCCDCLS("B",TRNM,""))
 I $G(TRIEN)'="" D IMPORT^BCCDCLAS(TRIEN,.ERR)
 I $G(ERR) D ERRMSG("  Error occurred duing import. Error: "_ERR_".  Post-install aborted.") G Q
 ;
 D BMES^XPDUTL("Post-install routine is complete")
 ; Exit point
Q ;
 Q
 ;
STOPPROD() ; Stop the CCDA production. Returns 1 if successful or it was already stopped.
 N CCDANS,NS,TSC,STOPPED
 S @("NS=$NAMESPACE"),CCDANS="CCDA"_NS
 ; Switch to the CCDA namespace
 N @("$NAMESPACE")
 S @("$NAMESPACE=CCDANS")
 S @("STOPPED='##class(Ens.Director).IsProductionRunning()")
 I STOPPED Q 1
 S @("TSC=##class(Ens.Director).StopProduction(30,1)")
 S @("STOPPED='##class(Ens.Director).IsProductionRunning()")
 Q STOPPED
 ;
CKOPTSCH(OPT) ;
 N OPTIEN,SCHED,TASK
 S OPTIEN=$O(^DIC(19,"B",OPT,"")) I 'OPTIEN Q 0
 S SCHED=$O(^DIC(19.2,"B",OPTIEN,"")) I 'SCHED Q 0
 S TASK=$G(^DIC(19.2,SCHED,1)) I 'TASK Q 0
 I '$D(^%ZTSCH("TASK",TASK)) Q 0
 Q 1
 ;
ERRMSG(MSG) ;
 I $G(MSG)'="" D BMES^XPDUTL(MSG)
 D MES^XPDUTL("Please contact the OIT help desk if you need assistance.")
 Q
