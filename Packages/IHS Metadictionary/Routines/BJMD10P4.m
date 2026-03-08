BJMD10P4 ;VNGT/HS/GCD-Post-Install Routine; 25 Jun 2013
 ;;1.0;CDA/C32;**4**;Feb 08, 2011
 ;
EN ;
 N ERR,TRNM,TRIEN,EXEC,USER,STATUS,DIR
 N DIE,DA,DR,DTOUT
 ; Import the classes
 S TRNM=@XPDGREF@("SENT REC")
 I TRNM="" D BMES^XPDUTL("Error occurred duing import. Install aborted.") Q
 S TRIEN=$O(^BJMDCLS("B",TRNM,""))
 I $G(TRIEN)'="" D IMPORT^BJMDCLAS(TRIEN,.ERR)
 ;
 ; Clear the time to run the nightly task - 2/05/2014 GCD
 S DIE="^BJMDS(90607,",DA=1,DR=".09///@"
 D ^DIE
 ; Now that we've cleared the time to run the nightly task, call SchedulePush to unschedule the task
 S EXEC="do ##class(BJMD.Xfer.C32Populate).SchedulePush()" X EXEC
 ;
 ; Run the post-install task in the Ensemble namespace
 ; If the _SYSTEM account is not active, then the user will need to perform the post-install task's steps manually.
 S EXEC="S USER=$Username" X EXEC
 S EXEC="S STATUS=##class(%SYSTEM.Security).Login(""_SYSTEM"")" X EXEC
 S EXEC="D ##class(%SYSTEM.Security).Login(USER)" X EXEC  ; Restore the user's original login.
 I STATUS S EXEC="S SC=##class(BJMD.Install.PostPatchTask).RunTask()" X EXEC I 1
 E  D
 . D BMES^XPDUTL("Could not run the post-install task. Please follow the post-installation steps in the patch notes.")
 . D BMES^XPDUTL("") S DIR(0)="E",DIR("A")="Press RETURN to continue",DIR("T")=86400 D ^DIR
 Q
