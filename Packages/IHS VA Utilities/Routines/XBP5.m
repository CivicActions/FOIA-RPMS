XBP5 ; IHS/ADC/GTH - XB/ZIB V 3.0 PATCH 5 ; [ 07/06/1998  1:57 PM ]
 ;;3.0;IHS/VA UTILITIES;**5**;FEB 07, 1997
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW,HELP("INTRO")
 S Y=$$DIR^XBDIR("Y","Do you want to queue the upgrade to TaskMan","Y","","","^D HELP^XBP5(""Q2"")",2)
 I $D(DIRUT) Q
 G START:'Y
QUE ;
 S %DT="AERSX",%DT("A")="Requested Start Time: ",%DT("B")="T@2015",%DT(0)="NOW"
 D ^%DT
 I Y<1 W !,"QUEUE INFORMATION MISSING - NOT QUEUED" G XBP5
 S X=+Y
 D H^%DTC
 S ZTDTH=%H_","_%T
 S ZTRTN="START^XBP5",ZTIO="",ZTDESC=$P($P($T(+1),";",2)," ",4,99)
 D ^%ZTLOAD,HOME^%ZIS
 I $D(ZTSK) W !!,"QUEUED TO TASK ",ZTSK,!!,"A mail message with the results will be sent to your MailMan 'IN' basket.",!
 E  W !!,*7,"QUEUE UNSUCCESSFUL.  RESTART UTILITY."
 Q
 ;
START ;EP - From Taskman
 ;
 D MAIL^XBMAIL("XUMGR-XUPROGMODE","DESC^XBP5")
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
 ;;This is Patch 5 to XB/ZIB utilities.  Please see the routines of the
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
 ;;XB/ZIB v 3.0, Patch 5 Announcement.
 ;;  
 ;;+++++++++++++++ XB/ZIB 3.0 Patch 5 Announcement +++++++++++++++++
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
 ;;(1) XBLM OPEN EXECUTES AND IOM VALUES.
 ;;$$OPEN^%ZISH can open host devices with unfriendly open executes.
 ;;Similar to the MESSAGE and BROWSER Device, XBLM HF DEVICE is
 ;;added to be used for functions.
 ;;  NOTE:  Kernel team has a concurrent patch release planned.
 ;;         In agreement with the Kernel support team, if the K8
 ;;         patch is not installed, XBLM will sense the lack of
 ;;         an appropriate device and will set it up.
 ;;When XBLM is exited, IOM has been set to 80, which can cause a
 ;;problem within Screenman calls to XBLM. (A recent link developed
 ;;by TUCSON.)  XBLM is recoded and now the existing IOM is used for
 ;;the host file open parameter and is restored when returning to
 ;;the calling application.
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;(2) XBDBQUE - DOUBLE QUEING TO IP PRINTERS.
 ;;There has been a problem with doublequeing to printers that are
 ;;accessed using IP.  The IO parameters for IP printers are a
 ;;combination that were not anticipated in doublequeing.  XBDBQUE
 ;;was recoded to include the new combination of parameters.
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;(3) XBFIXPT can abort because of a missing ^DD node.  This patch
 ;;adds $DATA protection for programmers.
 ;;  THANKS TO DON ENOS FOR FINDING, REPORTING, AND FIXING THE BUG.
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;(4) XBCSPC had a bug resulting in the count of the number of
 ;;duplicate values for a particular value being wrong.  This patch
 ;;fixes the count.
 ;;  THANKS TO DON ENOS FOR FINDING, REPORTING, AND FIXING THE BUG.
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;(5) XBVK expects "MSM" to be the first "-" piece of the first "^"
 ;;piece of the ^%ZOSF("OS") node.  Micronetic's implementation of
 ;;MSM on an NT platform departs from that de facto standard,
 ;;resulting in an <INDIR>.  This patch fixes the to look for "MSM"
 ;;in the first "^" piece of ^%ZOSF("OS").
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;(6) XBKVAR had an incorrect reference to ^XMB(1,0), which should
 ;;have been ^XMB(1,1,0), sometimes resulting in DUZ("AG") being set
 ;;to null.  This patch the reference.
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;++++++++++++++++++++ end of Patch 5 announcement ++++++++++++++++
 ;;###
 ;
