BCCD1P02 ;GDIT/HS/GCD-Post-Install; 18 Apr 2013  12:51 PM
 ;;1.0;CCDA;**2**;Feb 21, 2014;Build 16
 Q
POST ;
 N DIC,DIE,DIK,DA,DR,DTOUT
 N PRUN,CRUN,I,ERR,TRNM,TRIEN
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
 I I=121 D ERRMSG("  Could not stop CCDA jobs.  Install aborted.") G Q
 ;
 ; Check for locks to verify that the tasks are stopped.
 I $$LOCK^BCCDPAT("^BCCDTSK")!$$LOCK^BCCDPAT("^BCCDPUSH") D ERRMSG("  Could not stop CCDA jobs.  Install aborted.") G Q
 ;
 ; Import BCCD classes
 D BMES^XPDUTL("  Import BCCD package")
 K ERR
 S TRNM=$G(@XPDGREF@("SENT REC"))
 I TRNM="" D ERRMSG("  Error occurred duing import.  Install aborted.") G Q
 S TRIEN=$O(^BCCDCLS("B",TRNM,""))
 I $G(TRIEN)'="" D IMPORT^BCCDCLAS(TRIEN,.ERR)
 I $G(ERR) D ERRMSG("  Error occurred duing import. Error: "_ERR_".  Install aborted.") G Q
 ;
 D BMES^XPDUTL("Post-install routine is complete")
 ; Exit point
Q ;
 Q
 ;
CKOPTSCH(OPT) ;
 N OPTIEN,SCHED,TASK
 S OPTIEN=$O(^DIC(19,"B",OPT,"")) I 'OPTIEN Q 0
 S SCHED=$O(^DIC(19.2,"B",OPTIEN,"")) I 'SCHED Q 0
 S TASK=$G(^DIC(19.2,SCHED,1)) I 'TASK Q 0
 I '$D(^%ZTSCH("TASK",TASK)) Q 0
 Q 1
ERRMSG(MSG) ;
 I $G(MSG)'="" D BMES^XPDUTL(MSG)
 D MES^XPDUTL("Please contact the OIT help desk if you need assistance.")
 Q
