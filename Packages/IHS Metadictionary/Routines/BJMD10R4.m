BJMD10R4 ;VNGT/HS/GCD-Pre-Install Routine; 25 Jun 2013
 ;;1.0;CDA/C32;**4**;Feb 08, 2011
 ;
EN ;
 N DIE,DA,DR,PRUN,CRUN,EXEC,USER,STATUS,DIR
 ;
 ; Set the C MESSAGING ENABLED flag to N to stop C Messaging
 S DIE=90607,DA=1,DR=".07///N"
 D ^DIE
 ; Make sure that BJMDPUSH and BJMDTSK are not running
 S PRUN=1,CRUN=1
 F I=1:1:121 D  I 'PRUN,'CRUN Q
 . I I=10 D BMES^XPDUTL("Waiting for current C32 tasks to stop")
 . I PRUN S PRUN=$$CKOPTSCH("BJMD NHIE PUSH JOB")
 . I CRUN S CRUN=$$CKOPTSCH("BJMD BACKGROUND JOB")
 . I 'PRUN,'CRUN Q
 . H 1
 I I=121 D BMES^XPDUTL("Could not stop C32 jobs. Install aborted") S XPDABORT=1 Q
 ; Check for locks
 I $$LOCK^BJMDPAT("^BJMDTSK")!$$LOCK^BJMDPAT("^BJMDPUSH") D BMES^XPDUTL("Could not stop C32 jobs. Install aborted") S XPDABORT=1 Q
 ;
 ; Run the pre-install task in the Ensemble namespace
 ; If the _SYSTEM account is not active, then the user will need to perform the pre-install task's steps manually.
 S EXEC="S USER=$Username" X EXEC
 S EXEC="S STATUS=##class(%SYSTEM.Security).Login(""_SYSTEM"")" X EXEC
 S EXEC="D ##class(%SYSTEM.Security).Login(USER)" X EXEC  ; Restore the user's original login.
 I STATUS S EXEC="S SC=##class(BJMD.Install.PreInstallTask).RunTask()" X EXEC I 1
 E  D
 . D BMES^XPDUTL("Could not run pre-install task. Please follow the pre-installation steps in the patch notes before continuing.")
 . D BMES^XPDUTL("") S DIR(0)="E",DIR("A")="Press RETURN to continue",DIR("T")=86400 D ^DIR
 ;
 Q
 ;
CKOPTSCH(OPT) ;
 N OPTIEN,SCHED,TASK
 S OPTIEN=$O(^DIC(19,"B",OPT,"")) I 'OPTIEN Q 0
 S SCHED=$O(^DIC(19.2,"B",OPTIEN,"")) I 'SCHED Q 0
 S TASK=$G(^DIC(19.2,SCHED,1)) I 'TASK Q 0
 I '$D(^%ZTSCH("TASK",TASK)) Q 0
 Q 1
