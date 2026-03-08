XBP8 ; IHS/ASDST/GTH - XB/ZIB V 3.0 PATCH 8 ; [ 01/22/2001  11:55 AM ]
 ;;3.0;IHS/VA UTILITIES;**8**;FEB 07, 1997
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW,HELP("INTRO")
 S Y=$$DIR^XBDIR("Y","Do you want to queue the upgrade to TaskMan","Y","","","^D HELP^XBP8(""Q2"")",2)
 I $D(DIRUT) Q
 G START:'Y
QUE ;
 S %DT="AERSX",%DT("A")="Requested Start Time: ",%DT("B")="T@2015",%DT(0)="NOW"
 D ^%DT
 I Y<1 W !,"QUEUE INFORMATION MISSING - NOT QUEUED" G XBP8
 S X=+Y
 D H^%DTC
 S ZTDTH=%H_","_%T,ZTRTN="START^XBP8",ZTIO="",ZTDESC=$P($P($T(+1),";",2)," ",4,99)
 D ^%ZTLOAD,HOME^%ZIS
 I $D(ZTSK) W !!,"QUEUED TO TASK ",ZTSK,!!,"A mail message with the results will be sent to your MailMan 'IN' basket.",!
 E  W !!,*7,"QUEUE UNSUCCESSFUL.  RESTART XBP8."
 Q
 ;
START ;EP - From Taskman and KIDS.
 NEW DIFROM
 D MAIL^XBMAIL("XUMGR-XUPROGMODE","DESC^XBP8")
 I $D(ZTQUEUED) S ZTREQ="@"
 E  W !!,"You're done.  You may delete this routine (XBP8).",!
 F X="XBP5","XBP6","XBP7" X ^%ZOSF("DEL")
 Q
 ;
HELP(L) ;EP - Display text at label L.
 W !
 F %=1:1 W !?4,$P($T(@L+%),";",3) Q:$P($T(@L+%+1),";",3)="###"  Q:$T(@L+%+1)=""
 Q
 ;
INTRO ;
 ;;This is Patch 8 to XB/ZIB version 3.0 utilities.  Please see the
 ;;routines of the patch for complete descriptions of the upgrades.
 ;;This patch generates a mail message to everyone on your local machine
 ;;that holds the XUMGR, XUPROG, or XUPROGMODE security key.  The mail
 ;;message informs the users that the patch has been installed, and
 ;;describes the changes in greater detail.
 ;;###
 ;
Q2 ;
 ;;Answer "Y" if you want to queue this announcement to TaskMan.
 ;;Answer "N" if you want to run the announcement immediately.
 ;;
 ;;If you run interactively, a mail message with the description of this
 ;;patch will be delivered to those users holding the XUMGR, XUPROG, or
 ;;XUPROGMODE security key, now.  If you q the announcement to TaskMan,
 ;;the mail message will be delivered when TaskMan runs the task.
 ;;###
 ;
DESC ;
 ;;XB/ZIB v 3.0, Patch 8 Announcement.
 ;;  
 ;;+++++++++++++++ XB/ZIB 3.0 Patch 8 Announcement +++++++++++++++++
 ;;+     This mail message has been delivered to all local         +
 ;;+ users that hold an XUMGR, XUPROG, or XUPROGMODE security key. +
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;  
 ;;Please direct your questions or comments about RPMS software to:
 ;;   Information Technology Support Center (ITSC)
 ;;   5300 Homestead Road NE
 ;;   Albuquerque NM  87110
 ;;   505-248-4371 or 888-830-7280
 ;;   E-mail:  hqwhd@mail.ihs.gov
 ;;  
 ;;-----------------------------------------------------------------
 ;;(1)  XBDBQUE
 ;;     Parsing of the file name has been corrected if ":" is in the
 ;;     pathname.
 ;;-----------------------------------------------------------------
 ;;(2)  XBDSET
 ;;     The BUILD file has been added to the list of methods of
 ;;     identifying a list of FileMan files.
 ;;-----------------------------------------------------------------
 ;;(3)  XBPKDEL
 ;;     Modified to include FORMS, PROTOCOLS, and LIST templates in
 ;;     the list of package components that can be listed and deleted.
 ;;     Modified to delete SECURITY KEYS from holders of the keys,
 ;;     when SECURITY KEYS are deleted.
 ;;-----------------------------------------------------------------
 ;;(4)  XBPKDEL1
 ;;     New routine that will list retired/replaced packages, and
 ;;     give the user the opportunity to delete those packages by
 ;;     calling XBPKDEL.  Will also give the user the opportunity to
 ;;     delete routines and globals in the package's namespace.
 ;;-----------------------------------------------------------------
 ;;(5)  XB1
 ;;     Added 2 items to the Developer's menu of the IHS/VA UTILITIES:
 ;;               16   List retired/replaced packages
 ;;               17   Delete retired/replaced packages
 ;;-----------------------------------------------------------------
 ;;(6)  ZIBGSVEP
 ;;     Added protection for WRITEs and USEs for background processing.
 ;;     Added check for non-queuing for local saves that do not need
 ;;     SENTO the Area Office.
 ;;-----------------------------------------------------------------
 ;;(7)  XBLM
 ;;     A line added in patch 5 that had a timed read (R:DTIIME) in it
 ;;     was causing infinite SETs to ^TMP( to fill up the journal space
 ;;     on UNIX machines.  The problem did not occur on NT systems.
 ;;     Removing the timeout from the READ fixed the bug on the UNIX
 ;;     systems and did not affect the NT systems.
 ;;-----------------------------------------------------------------
 ;;(8)  ZIBNSSV
 ;;     Incorrect parsing of the OS has been corrected.
 ;;++++++++++++++++++++ end of Patch 8 announcement ++++++++++++++++
