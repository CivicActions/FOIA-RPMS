BCCDPAT ;GDIT/HS/AM-Patient CCD routines and Manage Status; 22 Feb 2013  12:51 PM
 ;;2.0;CCDA;**1**;Aug 12, 2020;Build 106
 ;
ONE ;
 N CCDARUN,AUPNLK,DIC,ELG,EXEC,PLIST,CCD,AUDIT,VISIT,STPCODES
 I '$$HASALL Q
 S CCDRUN=$O(^BCCDS(90310.02,"B","CCD",""))
 I '$$CHECK(CCDRUN) Q
 ;
 S AUPNLK("ALL")=1
 ; D PATIENT^ORU1(.PLIST,,1)
 S DIC="^AUPNPAT(",DIC(0)="AEMQZ",DIC("A")="ENTER NAME, SSN, DOB OR CHART#: "
 D SET^AUPNLKZ
 D ^AUPNLK
 D RESET^AUPNLKZ
 S DFN=+Y
 I 'DFN W !,"Please select one patient" Q
 I '$D(^DPT(DFN)) W !,"No VA patient record" Q
 I '$D(^AUPNPAT(DFN)) W !,"No patient record" Q
 S EXEC="S ELG=##CLASS(BCCD.Xfer.PushQueue).Eligible(DFN)" X EXEC
 I 'ELG W !,"This patient is not eligible for CCD transmission" Q
 S EXEC="set STPCODES=##class(BCCD.Xfer.CCDMain).#EMPLOYEEHEALTHSTOPCODES" X EXEC
 S VISIT=$$PRVVST^BCCDUTIL(DFN,"","","",STPCODES)
 I VISIT="" W !,"No eligible visit record for this patient" Q
 ; Taskman task BCCDTSK will then pick it up and create CCD documents
 S EXEC="set CCD=##class(BCCD.Xfer.Queue).%New()" X EXEC
 S EXEC="set AUDIT=##class(BCCD.Audit.AuditLog).%New()" X EXEC
 S EXEC="set CCD.PatientId=DFN,CCD.RequestTimestamp=$zdt($h,3,1)" X EXEC
 S EXEC="set CCD.PushFlag=1,CCD.DocType=""HIE"",CCD.AuditLog=AUDIT" X EXEC
 S EXEC="do CCD.VisitId.Insert(VISIT)" X EXEC
 S EXEC="set SC=CCD.%Save()" X EXEC
 I SC'=1 W !,"CCD request could not be submitted. Please contact Support." Q
 S EXEC="set CCD.Status=""R""" X EXEC
 S EXEC="set AUDIT.QueueId=CCD.%Id(),AUDIT.PatientId=CCD.PatientId" X EXEC
 S EXEC="set AUDIT.DocType=CCD.DocType,AUDIT.Status=CCD.Status" X EXEC
 S EXEC="set AUDIT.Source=""BCCDPAT"",AUDIT.RequestTimestamp=CCD.RequestTimestamp" X EXEC
 S EXEC="set AUDIT.RequestorDUZ=$g(DUZ),AUDIT.RequestorName=$$GET1^DIQ(200,$g(DUZ),.01,""E"")" X EXEC
 S EXEC="do AUDIT.VisitId.Insert(VISIT)" X EXEC
 S EXEC="set SC=AUDIT.%Save()" X EXEC
 S EXEC="set SC=CCD.%Save()" X EXEC
 I SC=1 W !,"CCD request has been scheduled for patient ",$P($G(^DPT(DFN,0)),U)
 E  W !,"CCD request could not be submitted. Please contact Support."
 Q
ALL ;
 N CCDRUN,PT,SPACE,DIE,DA,DR
 I '$$HASALL Q
 S CCDRUN=$O(^BCCDS(90310.02,"B","CCD",""))
 I '$$CHECK(CCDRUN) Q
 S PT=$P($G(^BCCDS(90310.01,1,0)),U,6)
 I PT="" D  Q
 . W !,"CCDA nightly job not scheduled.  Please schedule it before running this option" Q
 W !,"Checking free space..."
 S SPACE=$$SPACE^BCCDEDIT(),PATSPC=52
 I SPACE<PATSPC D  Q
 . W !,!,"There are ",$P(SPACE,U,3)," patients and ",$P(SPACE,U,2)\1024," MB of free disk space in the CCDA"
 . W !,"database (",$J($P(SPACE,U),"",3)," KB per patient).  The CCDA database needs ",PATSPC," KB of"
 . W !,"free disk space per patient, "
 . S NEEDSPC=$P(SPACE,U,3)*PATSPC-$P(SPACE,U,2)
 . W NEEDSPC\1024," MB more than you currently have."
 . I $P(SPACE,U,6)<0 D
 .. W !,!,"Your system doesn't have enough free space on file system to allow this"
 .. W !,"to proceed. Contact Support to assist you with expanding file system."
 . I $P(SPACE,U,6)>0 D
 .. S XYZ=$P(SPACE,U,4)+NEEDSPC\1024
 .. W !,!,"You must change the value of the ""Maximum Size"" field in the ""Database "
 .. W !,"Properties"" screens in Ensemble's Management Portal to at least ",XYZ," MB "
 .. W !,"before you can enable CCD generation"
 W !!,"Generation and transmission of CCD documents for all patients may take"
 W !,"in excess of 2 days.  It may also make extensive use of system resources. "
 W !,"Please make sure that your system is not overloaded while this process is"
 W !,"running as this may impact system performance."
 W !
 W !,"Generation of all CCD documents will be done during the next CCDA"
 W !,"nightly job which is currently scheduled to run at ",PT
 W !
 W !,"Schedule All Patients"
 S %=1 D YN^DICN
 I %'=1 W !,"Not scheduled" Q
 S DIE=90310.02,DA=CCDRUN,DR=".02///@"
 D ^DIE
 W !,"Scheduled"
 Q
MAN ;
STATUS ;
 N CMNZ,CSTATUS,CENABLED,DIE,DA,DR,OK,CCDIEN,CCDURL,EXEC
 I '$$HASALL Q
 S OK=1,U="^",CCDAURL=""
 W !,"CCDA status:"
 S CMNZ=$G(^BCCDS(90310.01,1,0))
 I $P(CMNZ,U,5)="" W !,"CCDA software is currently not installed" S OK=0
 ; for now, just check CCD
 D
 . S CCDIEN=$O(^BCCDS(90310.02,"B","CCD","")) I 'CCDIEN W !,"No CCD configuration record found" S OK=0 Q
 . I $P($G(^BCCDS(90310.02,CCDIEN,0)),U,5) W !,"CCD is not enabled" S OK=0 Q
 . S CCDURL=$G(^BCCDS(90310.02,CCDIEN,1))
 . I CCDURL="",$P(CMNZ,U,6)'="" W !,"Nightly Task is scheduled, but no Repository Location found for CCD" S OK=0 Q
 I OK W !,"No configuration problems found"
 W !
 ;
 S CENABLED=($P(CMNZ,U,4)="Y"),CSTATUS=($$LOCK("^BCCDTSK")'=0)
 ; Normal state - it is running and it is meant to run.  Ask user if we should stop it.
 I CENABLED,CSTATUS D  G SQ
 . W !,"CCDA processing task is running"
 . W !!,"Stop CCDA"
 . S %=2 D YN^DICN
 . I %'=1 Q
 . S DIE=90310.01,DA=1,DR=".04///N" D ^DIE W !,"Attempting to stop CCDA..."
 . F I=1:1:120 H 1 W "." I '$$LOCK("^BCCDTSK") W "CCDA stopped" Q
 . I '$$LOCK("^BCCDTSK") Q
 . W "CCDA failed to stop.  Contact Support to investigate"
 . S DIE=90310.01,DA=1,DR=".04///Y" D ^DIE
 ; It is not running.  Ask user if should start it.
 I 'CSTATUS D  G SQ
 . I 'CENABLED W !,"CCDA processing task is not running"
 . E  D
 .. W !,"CCDA process is supposed to be running but it is not running"
 .. W !,"If this is unexpected, please notify Support"
 . W !!,"Start CCDA"
 . S %=2 D YN^DICN
 . Q:%'=1
 . S DIE=90310.01,DA=1,DR=".04///Y" D ^DIE W !,"Attempting to start CCDA"
 . D START
 . F I=1:1:120 H 1 W "." I $$LOCK("^BCCDTSK") W "CCDA started" Q
 . I $$LOCK("^BCCDTSK") D  Q
 .. S EXEC="S tSC=##class(BCCD.Tasks.UpdateProductionState).RunTask()" X EXEC
 . W !,"CCDA failed to start.  Contact Support to investigate"
 . S DIE=90310.01,DA=1,DR=".04///N" D ^DIE
 ; Abnormal state - it is meant to be stopped but it is running
 I 'CENABLED,CSTATUS D  G SQ
 . W !,"The CCDA process is supposed to be stopped but it is running"
 . W !,"Please contact Support to investigate the source of this condition"
 . ; 
 ; Display of message specific parameters and the status of push task is disabled
 G SQ
 S MT=0
 F  S MT=$O(^BCCDS(90310.02,MT)) Q:'MT  D
 . S MTNZ=$G(^BCCDS(90310.02,MT,0))
 . W !,!,$P(MTNZ,U)," " I $P(MTNZ,U,3)'="" W "(",$P(MTNZ,U,3),") "
 . W "is ",$S($P(MTNZ,U,5)="Y":"en",1:"dis"),"abled."
 . W !,"Last time pushed: ",$S($P(MTNZ,U,2)'="":$P(MTNZ,U,2),1:"never (all messages sent on next push)")
 . W !,"Receiver: ",$S($G(^BCCDS(90310.02,MT,1))'="":^BCCDS(90310.02,MT,1),1:"not defined")
 S PSTATUS=0 I $$LOCK("^BCCDPUSH") S PSTATUS=1 W !,"Push task is running" G SQ
 W !,!,"Push task is "
 I $P(CMNZ,U,6)="" W "not set to start" D
 . S DIE=90310.01,DA=1,DR=".06" D ^DIE
 . S CMNZ=$G(^BCCDS(90310.01,1,0)) I $P(CMNZ,U,6) W !,"Push task is "
 I $P(CMNZ,U,6) W "set to run at ",$P(CMNZ,U,6)
SQ ;
 Q
 ;
 ; Start BCCDTSK task, and also schedule the BCCD BACKGROUND JOB option to start 
 ; it on system startup.   Because of the ^BCCDTSK lock, only one instance will run.
START ;
 S ZTRTN="EN^BCCDTSK",ZTDESC="CCDA Background Task",ZTIO="",ZTDTH=$H
 D ^%ZTLOAD
 S OPT=$O(^DIC(19,"B","BCCD BACKGROUND JOB",""))
 Q:'OPT
 D OPTSTAT^XUTMOPT("BCCD BACKGROUND JOB",.ROOT)
 I ROOT=0 D
 . S DIC="^DIC(19.2,",DIC(0)="",X=OPT
 . D FILE^DICN
 S SCHED=$O(^DIC(19.2,"B",OPT,"")),DR=""
 Q:'SCHED
 I $P($G(^DIC(19.2,SCHED,0)),U,2)="" S H=$H*86400+$P($H,",",2)+125 S %H=H\86400_","_(H#86400) D TT^%DTC S %=$P(%H,",",2) D S^%DTC S %=X_$S(%:%,1:.24) S DR="2///"_%_";"
 S DIE="^DIC(19.2,",DA=SCHED,DR=DR_"9///SP"
 D ^DIE
 Q
CHECK(CCDRUN) ;
 I 'CCDRUN W !,"CCD settings not configured, please consult the CCDA Installation Guide" Q 0
 I $G(^BCCDS(90310.02,CCDRUN,1))="" D  Q 0
 . W !,"No receiving location is currently defined for CCD documents."
 . W !,"Your site needs to be associated with a receiving location in order"
 . W !,"to be able to upload CCD documents. If Support has provided you with"
 . W !,"the URL of your receiving location, please consult the CCDA Installation"
 . W !,"Guide for instructions on how to enter this information into the system."
 . W !,!,"If Support hasn't provided this URL to your site, then your site is a "
 . W !,"""pull"" site and you will be unable to generate CCDA on demand."
 . W !,"This will not affect other CCDA functionality."
 Q 1
LOCK(GL) ;
 N RT,EXEC
 S RT=0
 S EXEC="I ##class(%Dictionary.CompiledClass).%ExistsId(""BCCD.Xfer.CCDPopulate""),$IsObject(##class(%Dictionary.CompiledClass).%OpenId(""BCCD.Xfer.CCDPopulate"")) S RT=##class(BCCD.Xfer.CCDPopulate).Lock("""_GL_""")"
 X EXEC
 Q RT
HASALL() ;
 ; Check if the user is granted a specific role
 N EXEC,ROLES
 S EXEC="S ROLES=$roles"
 X EXEC
 I (","_ROLES_",")'[(",%All,") D  Q 0
 . W !,"Sorry, you do not have '%All' security role defined. CCDA functions unavailable."
 Q 1
