BJMDPAT ;VNGT/HS/AM-Patient CMessaging routines and Status/Manage; 18 Nov 2009  12:51 PM
 ;;1.0;CDA/C32;**1,3,4**;Feb 08, 2011
 ;
ONE ;
 N AUPNLK,C32RUN,ELG,EXEC,PLIST,SC
 ; Option disabled; replaced by CCDA - 2/05/2014 GCD
 D CCDAMSG^BJMDTSK
 Q
 ;
 I '$$HASALL Q
 S C32RUN=$O(^BJMDS(90606,"B","C32",""))
 I '$$CHECK(C32RUN) Q
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
 S EXEC="S ELG=##CLASS(BJMD.Xfer.PushQueue).Eligible(DFN)" X EXEC
 I 'ELG W !,"This patient is not eligible for C32 transmission" Q
 ; Taskman task BJMDTSK will then pick it up and create C32 documents
 S EXEC="set c32=##Class(BJMD.Xfer.Queue).%New()" X EXEC
 S EXEC="set c32.PersonID=DFN,c32.RequestTimestamp=$zdt($h,3,1),c32.Status=""R""" X EXEC
 S EXEC="set c32.PushFlag=1,SC=c32.%Save()" X EXEC
 I SC=1 W !,"C32 request has been scheduled for patient ",$P($G(^DPT(DFN,0)),U)
 E  W !,"C32 request could not be submitted. Please contact Support."
 Q
ALL ;
 N C32RUN,PT,SPACE,DIE,DA,DR
 ; Option disabled; replaced by CCDA - 2/05/2014 GCD
 D CCDAMSG^BJMDTSK
 Q
 ;
 I '$$HASALL Q
 S C32RUN=$O(^BJMDS(90606,"B","C32",""))
 I '$$CHECK(C32RUN) Q
 S PT=$P($G(^BJMDS(90607,1,0)),U,9)
 I PT="" D  Q
 . W !,"C Messaging nightly job not scheduled.  Please schedule it before running this option" Q
 W !,"Checking free space..."
 S SPACE=$$SPACE^BJMDECK(),PATSPC=40
 I SPACE<PATSPC D  Q
 . W !,!,"There are ",$P(SPACE,U,3)," patients and ",$P(SPACE,U,2)\1024," MB of free disk space in the C32"
 . W !,"Database (",$J($P(SPACE,U),"",3)," KB per patient).  The C32 database needs ",PATSPC," KB of"
 . W !,"free disk space per patient, "
 . S NEEDSPC=$P(SPACE,U,3)*PATSPC-$P(SPACE,U,2)
 . W NEEDSPC\1024," MB more than you currently have."
 . I $P(SPACE,U,6)<0 D
 .. W !,!,"Your system doesn't have enough free space on file system to allow this"
 .. W !,"to proceed. Contact Support to assist you with expanding file system."
 . I $P(SPACE,U,6)>0 D
 .. S XYZ=$P(SPACE,U,4)+NEEDSPC\1024
 .. W !,!,"You must change the value of the ""Maximum Size"" field in the ""Database "
 .. W !,"Properties"" screens in the Ensemble System Management Portal to at least "
 .. W !,XYZ," MB before you can enable C32 generation" W "OK"
 W !!,"Generation and transmission of C32 documents for all patients may take"
 W !,"in excess of 2 days.  It may also make extensive use of system resources. "
 W !,"Please make sure that your system is not overloaded while this process is"
 W !,"running as this may impact system performance."
 W !
 ;W !,"Also, make sure that the receiver is ready to receive the high volume of messages"
 ;W !,"that this process will generate."
 ;W !
 W !,"Generation of all C32 documents will be done during the next C Messaging"
 W !,"nightly job which is currently scheduled to run at ",PT
 W !
 W !,"Schedule All Patients"
 S %=1 D YN^DICN
 I %'=1 W !,"Not scheduled" Q
 S DIE=90606,DA=C32RUN,DR=".02///@"
 D ^DIE
 W !,"Scheduled"
 Q
MAN ;
STATUS ;
 N CMNZ,CSTATUS,CMENABLE,DIE,DA,DR,OK,C32IEN,C32URL,EXEC
 ; Option disabled; replaced by CCDA - 2/05/2014 GCD
 D CCDAMSG^BJMDTSK
 Q
 ;
 I '$$HASALL Q
 S OK=1,U="^",C32URL=""
 W !,"C Messaging status:"
 S CMNZ=$G(^BJMDS(90607,1,0))
 I $P(CMNZ,U,10)="" W !,"Fileman Classes are currently not installed" S OK=0
 I $P(CMNZ,U,8)="" W !,"C Messaging software is currently not installed" S OK=0
 ; for now, just check C32
 D
 . S C32IEN=$O(^BJMDS(90606,"B","C32","")) I 'C32IEN W !,"No C32 record found" S OK=0 Q
 . I $P($G(^BJMDS(90606,C32IEN,0)),U,5) W !,"C32 is not enabled" S OK=0 Q
 . S C32URL=$G(^BJMDS(90606,C32IEN,1))
 . I C32URL="",$P(CMNZ,U,9)'="" W !,"Nightly Task is scheduled, but no Repository Location found for C32" S OK=0 Q
 . ; Next situation is no longer a problem
 . ;I C32URL'="",$P(CMNZ,U,9)="" W !,"Nightly Task is not scheduled, but there is a Repository Location for C32" S OK=0 Q
 I OK W !,"No configuration problems found"
 W !
 ;
 S CMENABLE=($P(CMNZ,U,7)="Y"),CMSTATUS=($$LOCK("^BJMDTSK")'=0)
 ; normal state - it is running and it is meant to run.  Ask user if we should stop it.
 I CMENABLE,CMSTATUS D  G SQ
 . W !,"C Messaging processing task is running"
 . W !,!,"Stop C Messaging"
 . S %=2 D YN^DICN
 . I %'=1 Q
 . S DIE=90607,DA=1,DR=".07///N" D ^DIE W !,"Attempting to stop C Messaging..."
 . F I=1:1:120 H 1 W "." I '$$LOCK("^BJMDTSK") W "C Messaging stopped" Q
 . I '$$LOCK("^BJMDTSK") Q
 . W "C Messaging failed to stop.  Contact Support to investigate"
 . S DIE=90607,DA=1,DR=".07///Y" D ^DIE
 ; it is not running.  Ask user if should start it.
 I 'CMSTATUS D  G SQ
 . I 'CMENABLE W !,"C Messaging processing task is not running"
 . E  D
 .. W !,"C Messaging process is supposed to be running but it is not running"
 .. W !,"If this is unexpected, please notify Support"
 . W !,!,"Start C Messaging"
 . S %=2 D YN^DICN
 . Q:%'=1
 . S DIE=90607,DA=1,DR=".07///Y" D ^DIE W !,"Attempting to start C Messaging"
 . ;S ZTRTN="EN^BJMDTSK",ZTDESC="C Messaging Background Task",ZTIO="",ZTDTH=$H
 . ;D ^%ZTLOAD
 . D START
 . F I=1:1:120 H 1 W "." I $$LOCK("^BJMDTSK") W "C Messaging started" Q
 . I $$LOCK("^BJMDTSK") D  Q
 .. S EXEC="S tSC=##class(BJMD.Tasks.UpdateProductionState).RunTask()" X EXEC
 . W !,"C Messaging failed to start.  Contact Support to investigate"
 . S DIE=90607,DA=1,DR=".07///N" D ^DIE
 ; abnormal state - it is meant to be stopped but it is running
 I 'CMENABLE,CMSTATUS D  G SQ
 . W !,"The C Messaging process is supposed to be stopped but it is running"
 . W !,"Please contact Support to investigate the source of this condition"
 . ; 
 ; display of message specific parameters and the status of push task is disabled
 G SQ
 S MT=0
 F  S MT=$O(^BJMDS(90606,MT)) Q:'MT  D
 . S MTNZ=$G(^BJMDS(90606,MT,0))
 . W !,!,$P(MTNZ,U)," " I $P(MTNZ,U,3)'="" W "(",$P(MTNZ,U,3),") "
 . W "is ",$S($P(MTNZ,U,5)="Y":"en",1:"dis"),"abled."
 . W !,"Last time Pushed: ",$S($P(MTNZ,U,2)'="":$P(MTNZ,U,2),1:"never (all messages sent on next push)")
 . W !,"Receiver: ",$S($G(^BJMDS(90606,MT,1))'="":^BJMDS(90606,MT,1),1:"not defined")
 S PSTATUS=0 I $$LOCK("^BJMDPUSH") S PSTATUS=1 W !,"Push task is running" G SQ
 W !,!,"Push task is "
 I $P(CMNZ,U,9)="" W "not set to start" D
 . ;I URL="" W " and can't be started since you have no destination" Q
 . S DIE=90607,DA=1,DR=".09" D ^DIE
 . S CMNZ=$G(^BJMDS(90607,1,0)) I $P(CMNZ,U,9) W !,"Push task is "
 I $P(CMNZ,U,9) W "set to run at ",$P(CMNZ,U,9)
SQ ;
 Q
 ;
 ; Start BJMDTSK task, and also schedule the BJMD BACKGROUND JOB option to start 
 ; it on system startup.   Because of the ^BJMDTSK lock, only one instance will run.
START ;
 S ZTRTN="EN^BJMDTSK",ZTDESC="C Messaging Background Task",ZTIO="",ZTDTH=$H
 D ^%ZTLOAD
 S OPT=$O(^DIC(19,"B","BJMD BACKGROUND JOB",""))
 Q:'OPT
 D OPTSTAT^XUTMOPT("BJMD BACKGROUND JOB",.ROOT)
 I ROOT=0 D
 . S DIC="^DIC(19.2,",DIC(0)="",X=OPT
 . D FILE^DICN
 S SCHED=$O(^DIC(19.2,"B",OPT,"")),DR=""
 Q:'SCHED
 I $P($G(^DIC(19.2,SCHED,0)),U,2)="" S H=$H*86400+$P($H,",",2)+125 S %H=H\86400_","_(H#86400) D TT^%DTC S %=$P(%H,",",2) D S^%DTC S %=X_$S(%:%,1:.24) S DR="2///"_%_";"
 S DIE="^DIC(19.2,",DA=SCHED,DR=DR_"9///SP"
 D ^DIE
 Q
CHECK(C32RUN) ;
 I 'C32RUN W !,"C32 settings not configured, please consult the C32 Installation Guide" Q 0
 I $G(^BJMDS(90606,C32RUN,1))="" D  Q 0
 . W !,"No receiving location is currently defined for C32 documents."
 . W !,"Your site needs to be associated with a receiving location in order"
 . W !,"to be able to upload C32 documents. If Support has provided you with"
 . W !,"the URL of your receiving location, please consult the C32 Installation"
 . W !,"Guide for instructions on how to enter this information into the system."
 . W !,!,"If Support hasn't provided this URL to your site, then your site is a "
 . W !,"""pull"" site and you will be unable to generate C Messaging on demand."
 . W !,"This will not affect other C Messaging functionality."
 Q 1
LOCK(GL) ;
 N RT,EXEC
 S RT=0
 ; 6/08/12 GCD SCCB-P03400 Changed to use CompiledClass.
 S EXEC="I ##class(%Dictionary.CompiledClass).%ExistsId(""BJMD.Xfer.C32Populate""),$IsObject(##class(%Dictionary.CompiledClass).%OpenId(""BJMD.Xfer.C32Populate"")) S RT=##class(BJMD.Xfer.C32Populate).Lock("""_GL_""")"
 X EXEC
 Q RT
HASALL() ;
 ; Check if the user is granted a specific role
 N EXEC,ROLES
 S EXEC="S ROLES=$roles"
 X EXEC
 I (","_ROLES_",")'[(",%All,") D  Q 0
 . W !,"Sorry, you do not have '%All' security role defined. C32 functions unavailable."
 Q 1
