XBP6 ; IHS/ADC/GTH - XB/ZIB V 3.0 PATCH 6 ; [ 07/02/1998  8:11 AM ]
 ;;3.0;IHS/VA UTILITIES;**6**;FEB 07, 1997
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW,HELP("INTRO")
 S Y=$$DIR^XBDIR("Y","Do you want to queue the upgrade to TaskMan","Y","","","^D HELP^XBP6(""Q2"")",2)
 I $D(DIRUT) Q
 G START:'Y
QUE ;
 S %DT="AERSX",%DT("A")="Requested Start Time: ",%DT("B")="T@2015",%DT(0)="NOW"
 D ^%DT
 I Y<1 W !,"QUEUE INFORMATION MISSING - NOT QUEUED" G XBP6
 S X=+Y
 D H^%DTC
 S ZTDTH=%H_","_%T
 S ZTRTN="START^XBP6",ZTIO="",ZTDESC=$P($P($T(+1),";",2)," ",4,99)
 D ^%ZTLOAD,HOME^%ZIS
 I $D(ZTSK) W !!,"QUEUED TO TASK ",ZTSK,!!,"A mail message with the results will be sent to your MailMan 'IN' basket.",!
 E  W !!,*7,"QUEUE UNSUCCESSFUL.  RESTART UTILITY."
 Q
 ;
START ;EP - From Taskman
 ;
 D MAIL^XBMAIL("XUMGR-XUPROGMODE","DESC^XBP6")
 I $D(ZTQUEUED) S ZTREQ="@"
 E  W !!,"You're done.  You may delete this routine.",!
 Q
 ;
HELP(L) ;EP - Display text at label L.
 W !
 F %=1:1 W !?4,$P($T(@L+%),";",3) Q:$P($T(@L+%+1),";",3)="###"
 Q
 ;
INTRO ;
 ;;This is Patch 6 to XB/ZIB utilities.  Please see the routines of the
 ;;patch for complete descriptions of the upgrades.  This patch
 ;;generates a mail message to everyone on your local machine that holds
 ;;the XUMGR, XUPROG, or XUPROGMODE security key.  The mail message
 ;;informs the users that the upgrade has been installed, and describes
 ;;the changes in greater detail.
 ;;###
 ;
Q2 ;
 ;;Answer "Y" if you want to queue this announcement to TaskMan.
 ;;Answer "N" if you want to run the announcement immediately.
 ;;
 ;;If you run interactively, a mail message with the description of this
 ;;upgrade will be delivered to those users holding the XUMGR, XUPROG, or
 ;;XUPROGMODE security key, now.  If you q the announcement to TaskMan,
 ;;the mail message will be delivered when TaskMan runs the task.
 ;;###
 ;
DESC ;
 ;;XB/ZIB v 3.0, Patch 6 Announcement.
 ;;  
 ;;+++++++++++++++ XB/ZIB 3.0 Patch 6 Announcement +++++++++++++++++
 ;;+     This mail message has been delivered to all local         +
 ;;+ users that hold an XUMGR, XUPROG, or XUPROGMODE security key. +
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;  
 ;;Please direct your questions or comments about RPMS software to:
 ;;            OIRM / DSD (Division of Systems Development)
 ;;            5300 Homestead Road NE
 ;;            Albuquerque NM  87110
 ;;            505-248-4191
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;(1) XBLM Was modified to correct a potential <MODER> when the 
 ;;routine calls DIQ when DX(0) contains a call to DIR and IO is open
 ;;for read.
 ;;  
 ;;-------------------------------------------------------------------
 ;; 
 ;;(2) XBDT is a new routine with two function calls:  FISCAL and LEAP.
 ;;these functions will provide accurate Y2K compliant values.  The
 ;;documentation is at the beginning of the routine.]
 ;; 
 ;;++++++++++++++++++++ end of Patch 6 announcement ++++++++++++++++
 ;;###
 ;
