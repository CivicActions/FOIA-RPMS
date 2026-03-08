ADSMON ;IHS/GDIT/AEF - BSTSPROCQ GLOBAL MONITOR
 ;;1.0;DISTRIBUTION MANAGEMENT;**3**;Apr 23, 2020;Build 15
 ;New routine
 ;
 ;Feature #83894:
 ;
DESC ; ROUTINE DESCRIPTION
 ;;
 ;;This routine monitors the ^XTMP("BSTSPROCQ","L") global and 
 ;;processes the entries.  It is intended to process a large
 ;;number of entries in the ^XTMP("BSTSPROCQ","L") global, such
 ;;as an initial upload of the Sign-On Log file, and continue
 ;;processing whenever a ZSOAP error occurs.  
 ;;It is a work around for the ZSOAP errors which are interrupting
 ;;the sending of the data.  Each time a process is interrupted
 ;;by a ZSOAP error a new process will be started to continue
 ;;processing the entries in the ^XTMP("BSTSPROCQ","L" global.
 ;;
 ;;$$END
 N I,X F I=1:1 S X=$P($T(DESC+I),";;",2) Q:X["$$END"  D EN^DDIOL(X)
 Q
 ;
START ;
 ;----- MONITOR ^XTMP("BSTSPROCQ","L") GLOBAL
 ;CALLED BY THE NIGHTLY ADSSITEEXPORT AUTOQUEUED OPTION WHICH CALLS
 ; TASK^ADSFAC, WHICH CALLS START^ADSMON
 ;
 N EXP,NOW,ZTDTH,ZTSK
 ;
 S EXP=$$FMADD^XLFDT($$NOW^XLFDT,60)
 S ^XTMP("ADSMON",0)=EXP_U_$$NOW^XLFDT_U_"ADS MONITOR"
 ;
 ;Stop the current background process:
 D STOP
 ;
 ;Kill STOP node:
 K ^XTMP("ADSMON","BACKGROUND MONITOR","STOP")
 ;
 ;Start the primary background monitor:
 ;(It is scheduled for every 3 hours so that if a ZSOAP error occurs
 ;a new one will start up in a few hours)
 S NOW=$$NOW^XLFDT
 ;F I=0,6,12,18 D   ;6 HOUR INTERVALS
 F I=0,3,6,9,12,15,18,21 D   ;3 HOUR INTERVALS
 . S ZTDTH=$$FMADD^XLFDT(NOW,,I)
 . D JOB("MONPBG^ADSMON","ADS BACKGROUND MONITOR - PRIMARY",ZTDTH,.ZTSK)
 . S ^XTMP("ADSMON","BACKGROUND MONITOR","Q","TASK",ZTSK)=ZTDTH
 ;
 ;Message background process scheduled:
 I $E($G(IOST),1,2)="C-" D
 . D BMES^XPDUTL("ADS Background process has been scheduled...")
 ;
 Q
MONPBG ;
 ;----- ADS BACKGROUND MONITOR - PRIMARY
 ;Loop to call secondary sub monitor
 ;Runs until the STOP node is set
 ;
 N CNT,I,PTASK,QUIT,STASK,ZTASK,ZTDTH
 ;
 S QUIT=0
 S PTASK=ZTSK
 ;
 ;Quit if STOP node:
 Q:$G(^XTMP("ADSMON","BACKGROUND MONITOR","STOP"))
 ;
 ;Remove task from queue:
 K ^XTMP("ADSMON","BACKGROUND MONITOR","Q","TASK",PTASK)
 ;
 ;Quit is there is one already running:
 S ZTASK=$G(^XTMP("ADSMON","BACKGROUND MONITOR","P","TASK"))
 I ZTASK D
 . S ZTSK=ZTASK
 . D STAT^%ZTLOAD
 . I $G(ZTSK(2))["Running"  S QUIT=1
 Q:QUIT
 ;
 S ^XTMP("ADSMON","BACKGROUND MONITOR","P","TASK")=PTASK_U_$$NOW^XLFDT
 ;
 ;Loop to see if there is something to do:
 ;(Will quit after trying 10x, so no more than 10 ZSOAP errors in ET)
 S CNT=0
 F  Q:$G(^XTMP("ADSMON","BACKGROUND MONITOR","STOP"))  D  Q:QUIT  H 60
 . I $G(^XTMP("ADSMON","BACKGROUND MONITOR","ZDEBUG")) D
 . . S ^XTMP("ADSMON","BACKGROUND MONITOR","ZLOOP",$$NOW^XLFDT)=PTASK  ;DEBUG
 . ;
 . ;Quit if not something to do:
 . Q:$$CHKQUIT
 . ;
 . ;Quit if a secondary background monitor is running:
 . S STASK=+$G(^XTMP("ADSMON","BACKGROUND MONITOR","S","TASK"))
 . S ZTSK=STASK
 . D STAT^%ZTLOAD
 . Q:$G(ZTSK(2))["Running"
 . ;
 . ;Start secondary background monitor:
 . S ZTDTH=$$NOW^XLFDT
 . D JOB("MONSBG^ADSMON","ADS BACKGROUND MONITOR - SECONDARY",ZTDTH,.ZTSK)
 . S STASK=ZTSK
 . S ^XTMP("ADSMON","BACKGROUND MONITOR","S","TASK")=STASK_U_ZTDTH
 . ;
 . ;Set count, stop after 10 tries:
 . ;(no more than 10 errors in error trap in case it errors out)
 . S CNT=CNT+1
 . I $G(^XTMP("ADSMON","BACKGROUND MONITOR","ZDEBUG")) D
 . . S ^XTMP("ADSMON","BACKGROUND MONITOR","ZTODOCNT",PTASK,$$NOW^XLFDT)=CNT_U_STASK   ;DEBUG
 . I CNT>9 S QUIT=1
 . Q:QUIT
 . ;5 minute delay before trying again after error occurs:
 . F I=1:1:5 D  Q:QUIT
 . . I $D(^XTMP("ADSMON","BACKGROUND MONITOR","STOP")) S QUIT=1
 . . Q:QUIT
 . . H 60
 ;
 K ^XTMP("ADSMON","BACKGROUND MONITOR","P","TASK")
 Q
MONSBG ;
 ;----- ADS BACKGROUND SUBMONITOR - SECONDARY
 ;
 Q:$G(^XTMP("ADSMON","BACKGROUND MONITOR","STOP"))
 Q:$$CHKQUIT
 ;
 ;Run PLOG:
 ;NOTE: Once PLOG is started it cannot be stopped until it finishes
 ;or encounters an error
 D PLOG^BSTSAPIL
 ;
 ;Kill secondary job node when done:
 K ^XTMP("ADSMON","BACKGROUND MONITOR","S","TASK")
 ;
 Q
STOP ;
 ;----- STOP THE BACKGROUND PROCESSES
 ;
 N I,QUIT,TASK,ZTSK
 S QUIT=0
 ;
 I $E($G(IOST),1,2)="C-" D
 . D BMES^XPDUTL("Stopping ADS Monitor background process")
 ;
 ;Tell the background job to quit running:
 S ^XTMP("ADSMON","BACKGROUND MONITOR","STOP")=1
 ; 
 ;Make sure primary background job is stopped:
 F  D  Q:$G(QUIT)
 . S ZTSK=+$G(^XTMP("ADSMON","BACKGROUND MONITOR","P","TASK"))
 . I 'ZTSK S QUIT=1 Q
 . D STAT^%ZTLOAD
 . I $G(ZTSK(2))'["Running" S QUIT=1
 . W:$E($G(IOST),1,2)="C-" "."
 . H 1
 ;
 ;Kill the primary background task:
 S ZTSK=+$G(^XTMP("ADSMON","BACKGROUND MONITOR","P","TASK"))
 K ^XTMP("ADSMON","BACKGROUND MONITOR","P","TASK")
 ;
 ;Kill future scheduled tasks:
 S TASK=0
 F  S TASK=$O(^XTMP("ADSMON","BACKGROUND MONITOR","Q","TASK",TASK)) Q:'TASK  D
 . S ZTSK=TASK
 . D KILL^%ZTLOAD
 . K ^XTMP("ADSMON","BACKGROUND MONITOR","Q","TASK",TASK)
 ;
 ;Kill the secondary background sub task:
 ;(Don't kill if it is still running PLOG)
 S ZTSK=+$G(^XTMP("ADSMON","BACKGROUND MONITOR","S","TASK"))
 I ZTSK D  Q:QUIT
 . D STAT^%ZTLOAD
 . I ZTSK(2)["Running" S QUIT=1
 . Q:QUIT
 . D KILL^%ZTLOAD
 . K ^XTMP("ADSMON","BACKGROUND MONITOR","S","TASK")
 ;
 Q
JOB(ZTRTN,ZTDESC,ZTDTH,ZTSK) ;
 ;----- JOB OFF BACKGROUND PROCESS
 ;Returns ZTSK
 ;
 N ZTIO
 I '$G(ZTDTH) S ZTDTH=$$NOW^XLFDT
 ;
 S ZTIO=""
 D ^%ZTLOAD
 Q
CHKQUIT() ;
 ;----- CHECK IF SHOULD QUIT
 ;Returns 1 if should quit
 ;
 N BSTS,GLOB,GR,IEN,Y
 S Y=0
 ;
 ;Quit if STOP node is set:
 S:$G(^XTMP("ADSMON","BACKGROUND MONITOR","STOP")) Y=1
 ;
 S BSTS="""BSTSPROCQ"""
 S GR="^"_"XTMP("
 S GLOB=GR_""_BSTS_""_","_"""L"""_",0)"
 ;
 ;Quit if nothing in the queue:
 I '$O(@GLOB) D
 . S ^XTMP("ADSMON","BACKGROUND MONITOR","STOP")=1
 . S Y=1
 ;
 ;Check if there is something in the queue and if it is processing:
 ;(Quit if it is processing)
 I $O(@GLOB) D
 . S IEN=$O(@GLOB)
 . H 10
 . I $O(@GLOB)'=IEN S Y=1
 ;
 ;Quit if background update process is running:
 S GLOB=GR_""_BSTS_""_",1)"
 L +@GLOB:1
 S:'$T Y=1
 L -@GLOB
 ;
 Q Y
 ;
CLEAN(DESC) ;
 ;----- CLEAN UP - FIND AND KILL ALL THE TASKS
 ;Finds all the tasks that contain DESC in .03 node
 ;Kills the tasks that are NOT running
 ;
 N TASK
 ;
 ;Find them:
 S TASK=0
 F  S TASK=$O(^%ZTSK(TASK)) Q:'TASK  D
 . I $G(^%ZTSK(TASK,.03))[DESC S TASK(TASK)=""
 ;
 ;Kill them:
 S TASK=0
 F  S TASK=$O(TASK(TASK)) Q:'TASK  D
 . S ZTSK=TASK
 . D STAT^%ZTLOAD
 . Q:ZTSK(2)["Running"
 . D KILL^%ZTLOAD
 ;
 Q
