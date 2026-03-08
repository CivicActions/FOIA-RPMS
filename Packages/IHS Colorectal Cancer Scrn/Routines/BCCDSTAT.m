BCCDSTAT ;GDIT/HS/GCD-CCDA Application Status; 30 Dec 2016  1:43 PM
 ;;2.0;CCDA;**1,4**;Aug 12, 2020;Build 158
 ;
 ; Resubmit or purge error records
ERROR ;
 N DIR
 ; Display most recent error documents
 S EXEC="do ##class(BCCD.Manage.ApplicationStatus).DisplayErrorDocs(20)"
 X EXEC
 ; Ask whether to resubmit or purge error docs
 W !
 K DIR
 S DIR(0)="SB^R:RESUBMIT;P:PURGE",DIR("A")="(R)esubmit or (P)urge error records"
 D ^DIR
 I Y="^" Q
 I Y="R" D ERRSUB Q
 I Y="P" D ERRPRG Q
 Q
 ;
 ; Purge error records
ERRPRG ;
 N DIR,DAYS
 ; Check if error purge is still running
 L +^BCCD.Tasks.PurgeErrorRecords:1
 E  W !!,"*** Error purge is already running.",! S DIR(0)="E" D ^DIR Q
 L -^BCCD.Tasks.PurgeErrorRecords
 ; Ask whether to purge error records
 W !
 S DIR(0)="Y",DIR("A")="Purge old error records",DIR("B")="No"
 D ^DIR
 I Y="^" Q
 I 'Y Q
 ; Ask days to keep
 K DIR
 S DIR(0)="N^0:365",DIR("A")="Days to keep",DIR("B")=60
 D ^DIR
 I Y="^" Q
 S DAYS=Y
 ; Ask whether to run in background
 K DIR
 S DIR(0)="Y",DIR("A")="Run in background",DIR("B")="Yes"
 D ^DIR
 I Y="^" Q
 ; Purge the error records
 I Y S EXEC="do ##class(BCCD.Tasks.Purge).PurgeErrorRecords(DAYS)"  ; background
 E  S EXEC="do ##class(BCCD.Tasks.Purge).PurgeRecords(""E"",DAYS,1)"  ; foreground
 X EXEC
 Q
 ;
 ; Resubmit error records
ERRSUB ;
 N DIR,SDATE,EDATE,EXEC
ERRSUB1 ; Ask user for start date/time
 S DIR(0)="D^::ERTX",DIR("A")="START DATE/TIME"
 D ^DIR
 I X="^" Q
 I Y=-1 W !!,"Invalid timestamp",! G ERRSUB1
 I Y>$$NOW^XLFDT W !!,"Response must not be in the future.",! G ERRSUB1
 S SDATE=Y
ERRSUB2 ; Ask user for end date/time
 S DIR(0)="D^::ERTX",DIR("A")="END DATE/TIME"
 D ^DIR
 I X="^" Q
 I Y=-1 W !!,"Invalid timestamp",! G ERRSUB2
 I Y>$$NOW^XLFDT W !!,"Response must not be in the future.",! G ERRSUB1
 S EDATE=Y
 I EDATE<SDATE W !,"End date must be after start date" G ERRSUB1
 ; Ask whether to run in background
 S DIR(0)="Y",DIR("A")="Run in background",DIR("B")="Yes"
 D ^DIR
 I Y="^" Q
 ; Resubmit the error records
 I Y S EXEC="do ##class(BCCD.Manage.Documents).ResubmitErrorRecords(SDATE,EDATE,DUZ)"  ; background
 E  S EXEC="do ##class(BCCD.Manage.Documents).ResubmitErrorRecords(SDATE,EDATE,DUZ,1)"  ; foreground
 X EXEC
 Q
 ;
 ; Ask the user whether to use page breaks, then display the CCDA application status report.
APPSTAT ;
 N %,DIR,Y
 S %=1  ; Default = yes
 W !,"Display the report with page breaks" D YN^DICN
 I %=-1 Q
 D APPRPT(2-%,1)  ; First parameter = 1 if Y, 0 if N.
 Q
 ;
 ; Display CCDA application status report. Parameters = page breaks (default = 0), called from menu (default = 0).
APPRPT(PGBRK,MENU) ;
 S EXEC="do ##class(BCCD.Manage.ApplicationStatus).DisplaySummary("_$G(PGBRK,0)_","_$G(MENU,0)_")"
 X EXEC
 Q
 ;
 ; Turn off the display of DFN on the CCDA application status report.
DFNOFF ;
 S ^BCCDSTAT("SUPPRESSDFN")=1
 Q
 ;
 ; Turn on the display of DFN on the CCDA application status report.
DFNON ;
 S ^BCCDSTAT("SUPPRESSDFN")=0
 Q
 ;
 ; Return the display of DFN on the CCDA application status report to its default behavior.
DFNCLR ;
 K ^BCCDSTAT("SUPPRESSDFN")
 Q
 ;
ABOUTQ(QID) ;
 N OBJ
 I $G(QID)="" S QID=$G(^BCCD.Xfer.QueueD) I QID="" Q
 S EXEC="set OBJ=##class(BCCD.Xfer.Queue).%OpenId(QID)" X EXEC
 I OBJ="" Q
 S EXEC="write !,""Queue ID = "",OBJ.%Id()" X EXEC
 S EXEC="write !,""Patient ID = "",OBJ.PatientId" X EXEC
 S EXEC="write !,""Visit IDs = "" for i=1:1:OBJ.VisitId.Count() write:i'=1 "","" write OBJ.VisitId.GetAt(i)" X EXEC
 S EXEC="write !,""Request Timestamp = "",OBJ.RequestTimestamp" X EXEC
 S EXEC="write !,""Status = "",OBJ.Status" X EXEC
 S EXEC="if OBJ.Status=""E"" write !,""Error text = "",OBJ.ErrorText" X EXEC
 ; Add other information, potentially including counts
 Q
 ;
DUMPQ(QID) ;
 N OBJ
 I $G(QID)="" S QID=$G(^BCCD.Xfer.QueueD) I QID="" Q
 S EXEC="set OBJ=##class(BCCD.Xfer.Queue).%OpenId(QID)" X EXEC
 I OBJ="" Q
 S EXEC="do $System.OBJ.Dump(OBJ)" X EXEC
 Q
