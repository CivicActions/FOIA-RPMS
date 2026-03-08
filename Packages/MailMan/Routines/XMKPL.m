XMKPL ;ISC-SF/GMB-Manage the local mail posting process ;02/09/98  08:21
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Replaces ^XMADGO1,^XMADGO (ISC-WASH/CAP)
 ; Entry points (not covered by DBIA):
 ; CHECK   Check the local processes.
 ;         If they haven't been deliberately STOP'd,
 ;         and if they are not running,
 ;         then task them.
 ; STATUS  Get status of local processes.
 ;
 ; Entry points used by MailMan options (not covered by DBIA):
 ; STOP    Stop the local processes.   XMMGR-STOP-BACKGROUND-FILER
 ; START   Start the local processes.  XMMGR-START-BACKGROUND-FILER
 ;
CHECK ; Task Background Filer processes if any missing
 Q:$P(^XMB(1,1,0),U,16)  ; Quit if 'background filer stop flag' set.
 N XMPROC,XMSTATUS
 D STATUS(.XMSTATUS)
 Q:'$D(XMSTATUS)
 S XMPROC=""
 F  S XMPROC=$O(XMSTATUS(XMPROC)) Q:XMPROC=""  D QUEUE(XMPROC)
 Q
STATUS(XMSTATUS) ;Check status of background filer
 N XMPROC,XMLOCK
 F XMPROC="Mover","Tickler" D
 . S XMLOCK="POST_"_XMPROC
 . L +^XMBPOST(XMLOCK):0 E  Q
 . S XMSTATUS(XMPROC)=XMLOCK_" is NOT running!"
 . L -^XMBPOST(XMLOCK)
 Q
QUEUE(XMPROC) ;Start Queue processors
 N XMHANG,ZTRTN,ZTDESC,ZTSAVE,X,ZTSK,ZTQUEUED,ZTCPU,ZTDTH,ZTIO
 S XMHANG=$$HANG
 S ZTDESC="MailMan Delivery "_XMPROC
 S ZTSAVE("XMHANG")=""
 S ZTRTN=$S(XMPROC="Tickler":"GO^XMTDT",1:"GO^XMKPLQ")
 I $D(^XMB(1,1,0)) S X=$P(^(0),U,12) I X'="" S ZTCPU=$P(X,",",2)
 S ZTIO="",ZTDTH=$H
 D ^%ZTLOAD
 Q
HANG() ; Get Hangtime for delivery modules
 N X
 S X=$P($G(^XMB(1,1,0)),U,13)
 Q $S(X:X,1:5)
STOP ; Stop Background mail delivery processes
 N DIR,Y,DIRUT
 S DIR(0)="Y"
 S DIR("A")="Are you sure you want the BACKGROUND FILERS to STOP delivering mail"
 S DIR("B")="NO"
 D ^DIR Q:'Y
 S $P(^XMB(1,1,0),U,16)=1  ; Set 'background filer stop flag'
 W:'$D(ZTQUEUED) !!,*7,"<< Background filer will stop soon. >>"
 Q
START ; Start the local processes (usually after they had been STOP'd).
 S $P(^XMB(1,1,0),U,16)=""  ; Reset 'background filer stop flag'
 D CHECK
 W:'$D(ZTQUEUED) !!,*7,"<< Background filer will start soon. >>",!!
 Q
