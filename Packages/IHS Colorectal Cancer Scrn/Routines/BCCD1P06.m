BCCD1P06 ;GDIT/HS/GCD-Post-Install; 1 Jun 2016  2:39 PM
 ;;1.0;CCDA;**6**;Feb 21, 2014;Build 46
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
 I I=121 D ERRMSG("  Could not stop CCDA jobs.  Post-install aborted.") G Q
 ;
 ; Check for locks to verify that the tasks are stopped.
 I $$LOCK^BCCDPAT("^BCCDTSK")!$$LOCK^BCCDPAT("^BCCDPUSH") D ERRMSG("  Could not stop CCDA jobs.  Post-install aborted.") G Q
 ;
 ; Import BCCD classes
 D BMES^XPDUTL("  Import BCCD package")
 K ERR
 S TRNM=$G(@XPDGREF@("SENT REC"))
 I TRNM="" D ERRMSG("  Error occurred duing import.  Post-install aborted.") G Q
 S TRIEN=$O(^BCCDCLS("B",TRNM,""))
 I $G(TRIEN)'="" D IMPORT^BCCDCLAS(TRIEN,.ERR)
 I $G(ERR) D ERRMSG("  Error occurred duing import. Error: "_ERR_".  Post-install aborted.") G Q
 ;
 ; Run tasks in the Ensemble namespace
 ; If the _SYSTEM account is not active, then the user will have to perform the post-install task's steps manually
 D BMES^XPDUTL("  Running Ensemble post-install task")
 S EXEC="S USER=$Username" X EXEC
 S EXEC="S STATUS=##class(%SYSTEM.Security).Login(""_SYSTEM"")" X EXEC
 S EXEC="D ##class(%SYSTEM.Security).Login(USER)" X EXEC  ; Restore the user's original login.
 I STATUS S EXEC="S TSC=##class(BCCD.Install.PostInstallPatch6).RunTask()" X EXEC I 1
 E  D
 . D BMES^XPDUTL("  Could not run Ensemble post-install task. Please schedule the production monitor task as described in the installation notes.")
 . D BMES^XPDUTL(" ")
 . K DIR
 . S DIR(0)="E",DIR("A")="  Press RETURN after completing Ensemble post-install tasks",DIR("T")=86400 D ^DIR
 ;
 D BMES^XPDUTL("  Moving audit log globals")
 D MOVELOG
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
 ;
ERRMSG(MSG) ;
 I $G(MSG)'="" D BMES^XPDUTL(MSG)
 D MES^XPDUTL("Please contact the OIT help desk if you need assistance.")
 Q
 ;
 ; Move the audit log globals from the CCDA database to the RPMS database.
 ; ^BCCD.Audit.ProductionStatusD is added with this patch so move it if it's there,
 ; but don't include it in the pre-move check.
MOVELOG ;
 N EXEC,RPMSNS,CCDANS,RPMSDIR,CCDADIR,STATUS,MAP,TSC,PROP
 ; Get the name of the CCDA and RPMS namespaces
 S EXEC="S RPMSNS=##class(%SYSTEM.SYS).NameSpace()" X EXEC
 S CCDANS="CCDA"_RPMSNS
 S RPMSDIR="^^"_$$GETDIR(RPMSNS)
 S CCDADIR="^^"_$$GETDIR(CCDANS)
 ; Check whether the audit log needs to be moved
 S STATUS=$$CHKLOG(RPMSNS,CCDANS)
 I STATUS=0 D BMES^XPDUTL("    CCDA audit log is already in the RPMS database and does not need to be moved.") Q 1
 I STATUS<0 D ERRMSG("    CCDA audit log has an unexpected configuration: "_$P(STATUS,"^",2)_". Audit log move aborted") Q 0
 ; Change the mapping
 S MAP="BCCD.Audit.*"
 D BMES^XPDUTL("    Remapping "_MAP)
 ZN "%SYS"  ; SAC exemption granted 7/08/2016
 S EXEC="S TSC=##class(Config.MapGlobals).Delete(RPMSNS,MAP)" X EXEC
 I 'TSC ZN RPMSNS D ERRMSG("    Unable to delete existing global mapping. Audit log move aborted.") Q 0  ; SAC exemption granted 7/08/2016
 S PROP("Database")=RPMSNS
 S EXEC="S TSC=##class(Config.MapGlobals).Create(CCDANS,MAP,.PROP)" X EXEC
 I 'TSC ZN RPMSNS D ERRMSG("    Unable to create global mapping. Contact CCDA support for assistance.") Q 0  ; SAC exemption granted 7/08/2016
 ZN RPMSNS  ; SAC exemption granted 7/08/2016
 ; Merge the globals into the RPMS database
 I @("$D(^[CCDADIR]BCCD.Audit.AuditLogD)") D  I @("'$D(^BCCD.Audit.AuditLogD)") D ERRMSG("    Unable to move ^BCCD.Audit.AuditLogD. Audit log move aborted.") Q 0  ; SAC exemption granted 7/08/2016
 . D BMES^XPDUTL("    Moving ^BCCD.Audit.AuditLogD")
 . S EXEC="M ^BCCD.Audit.AuditLogD=^[CCDADIR]BCCD.Audit.AuditLogD" X EXEC  ; SAC exemption granted 7/08/2016
 I @("$D(^[CCDADIR]BCCD.Audit.AuditLogI)") D  I @("'$D(^BCCD.Audit.AuditLogI)") D ERRMSG("    Unable to move ^BCCD.Audit.AuditLogI. Audit log move aborted.") Q 0  ; SAC exemption granted 7/08/2016
 . D BMES^XPDUTL("    Moving ^BCCD.Audit.AuditLogI")
 . S EXEC="M ^BCCD.Audit.AuditLogI=^[CCDADIR]BCCD.Audit.AuditLogI" X EXEC  ; SAC exemption granted 7/08/2016
 I @("$D(^[CCDADIR]BCCD.Audit.ErrorThrottleD)") D  I @("'$D(^BCCD.Audit.ErrorThrottleD)") D ERRMSG("    Unable to move ^BCCD.Audit.ErrorThrottleD. Audit log move aborted.") Q 0  ; SAC exemption granted 7/08/2016
 . D BMES^XPDUTL("    Moving ^BCCD.Audit.ErrorThrottleD")
 . S EXEC="M ^BCCD.Audit.ErrorThrottleD=^[CCDADIR]BCCD.Audit.ErrorThrottleD" X EXEC  ; SAC exemption granted 7/08/2016
 I @("$D(^[CCDADIR]BCCD.Audit.ProductionStatusD)") D  I @("'$D(^BCCD.Audit.ProductionStatusD)") D ERRMSG("    Unable to move ^BCCD.Audit.ErrorThrottleD. Audit log move aborted.") Q 0  ; SAC exemption granted 7/08/2016
 . D BMES^XPDUTL("    Moving ^BCCD.Audit.ProductionStatusD")
 . S EXEC="M ^BCCD.Audit.ProductionStatusD=^[CCDADIR]BCCD.Audit.ProductionStatusD" X EXEC  ; SAC exemption granted 7/08/2016
 ; Delete the globals from the CCDA database
 S EXEC="K ^[CCDADIR]BCCD.Audit.AuditLogD" X EXEC  ; SAC exemption granted 7/08/2016
 S EXEC="K ^[CCDADIR]BCCD.Audit.AuditLogI" X EXEC  ; SAC exemption granted 7/08/2016
 S EXEC="K ^[CCDADIR]BCCD.Audit.ErrorThrottleD" X EXEC  ; SAC exemption granted 7/08/2016
 S EXEC="K ^[CCDADIR]BCCD.Audit.ProductionStatusD" X EXEC  ; SAC exemption granted 7/08/2016
 ; Check that everything moved correctly
 S EXEC="S STATUS=$$CHKLOG(RPMSNS,CCDANS)" X EXEC
 I STATUS>0 D BMES^XPDUTL("    CCDA audit log was not moved. Contact CCDA support for assistance.") Q 0
 I STATUS<0 D ERRMSG("    CCDA audit log has an unexpected configuration: "_$P(STATUS,"^",2)_". Contact CCDA support for assistance.") Q 0
 Q 1
 ;
 ; Check status of the CCDA audit log globals.
 ; Return 1 if audit log is in CCDA database and mapping is CCDA->RPMS (need to move)
 ;        0 if audit log is in RPMS database and mapping is RPMS->CCDA (okay)
 ;       -1 if there is an unexpected situation (audit log in both databases, mapping doesn't match global location)
CHKLOG(RPMSNS,CCDANS) ;
 N EXEC,RPMSDIR,CCDADIR,PROP,MAP,STATUS
 S EXEC="I $G(RPMSNS)="""" S RPMSNS=##class(%SYSTEM.SYS).NameSpace()" X EXEC
 I $G(CCDANS)="" S CCDANS="CCDA"_RPMSNS
 S RPMSDIR="^^"_$$GETDIR(RPMSNS)
 S CCDADIR="^^"_$$GETDIR(CCDANS)
 S STATUS=""
 ; Check the direction of the global mapping
 ZN "%SYS"  ; SAC exemption granted 7/08/2016
 S MAP="BCCD.Audit.*"
 I @("##class(Config.MapGlobals).Exists(RPMSNS,MAP)") D
 . S EXEC="D ##class(Config.MapGlobals).Get(RPMSNS,MAP,.PROP)" X EXEC
 . I PROP("Database")=CCDANS S STATUS=1
 . E  S STATUS="-1^Global mapping is wrong"
 I @("##class(Config.MapGlobals).Exists(CCDANS,MAP)") D
 . S EXEC="D ##class(Config.MapGlobals).Get(CCDANS,MAP,.PROP)" X EXEC
 . I PROP("Database")=RPMSNS S STATUS=0
 . E  S STATUS="-1^Global mapping is wrong"
 ZN RPMSNS  ; SAC exemption granted 7/08/2016
 I STATUS<0 Q STATUS
 ; Check if the audit log globals exist in both databases
 I @("$D(^[CCDADIR]BCCD.Audit.AuditLogD) && $D(^[RPMSDIR]BCCD.Audit.AuditLogD)") Q "-1^BCCD.Audit.AuditLogD exists in both namespaces"  ; SAC exemption granted 7/08/2016
 I @("$D(^[CCDADIR]BCCD.Audit.AuditLogI) && $D(^[RPMSDIR]BCCD.Audit.AuditLogI)") Q "-1^BCCD.Audit.AuditLogI exists in both namespaces"  ; SAC exemption granted 7/08/2016
 I @("$D(^[CCDADIR]BCCD.Audit.ErrorThrottleD) && $D(^[RPMSDIR]BCCD.Audit.ErrorThrottleD)") Q "-1^BCCD.Audit.ErrorThrottleD exists in both namespaces"  ; SAC exemption granted 7/08/2016
 ; Check if the audit log globals are in the mapped database
 I STATUS=1 D
 . I @("$D(^[RPMSDIR]BCCD.Audit.AuditLogD)") S STATUS="-1^BCCD.Audit.AuditLogD exists in the RPMS database" Q  ; SAC exemption granted 7/08/2016
 . I @("$D(^[RPMSDIR]BCCD.Audit.AuditLogI)") S STATUS="-1^BCCD.Audit.AuditLogI exists in the RPMS database" Q  ; SAC exemption granted 7/08/2016
 . I @("$D(^[RPMSDIR]BCCD.Audit.ErrorThrottleD)") S STATUS="-1^BCCD.Audit.ErrorThrottleD exists in the RPMS database" Q  ; SAC exemption granted 7/08/2016
 I STATUS=0 D
 . I @("$D(^[CCDADIR]BCCD.Audit.AuditLogD)") S STATUS="-1^BCCD.Audit.AuditLogD exists in the CCDA database" Q  ; SAC exemption granted 7/08/2016
 . I @("$D(^[CCDADIR]BCCD.Audit.AuditLogI)") S STATUS="-1^BCCD.Audit.AuditLogI exists in the CCDA database" Q  ; SAC exemption granted 7/08/2016
 . I @("$D(^[CCDADIR]BCCD.Audit.ErrorThrottleD)") S STATUS="-1^BCCD.Audit.ErrorThrottleD exists in the CCDA database" Q  ; SAC exemption granted 7/08/2016
 Q STATUS
 ;
 ; Get directory associated with a namespace.
GETDIR(NS) ;
 Q @("$P(##class(%SYS.Namespace).GetGlobalDest($G(NS)),""^"",2)")
