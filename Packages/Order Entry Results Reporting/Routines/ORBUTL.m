ORBUTL ; slc/CLA - Modified for K8.0 by JLI/ISC-SF.SEA - Utilities for OE/RR notifications ;10/24/94  10:41 [ 04/02/2003   8:51 AM ]
 ;;8.0;KERNEL;**1002,1003,1004,1005,1007**;APR 1, 2003
 ;;8.0;KERNEL;;Jul 10, 1995
 ; This is a modified version of ORBUTL that has been prepared to travel
 ; with KERNEL 8.0 for test sites at least.
 ;  THE routine ORBUTL uses UNAUTHORIZED ENTRY POINTS AND FILE REFERENCES
 ;  without an integration agreement.  This was not known until the
 ;  routine failed to perform at the test sites.  This version of the
 ;  routine calls the same functionality within a KERNEL namespaced
 ;  routine.  This has been done in conjunction with the individuals
 ;  responsible at salt lake.
 ;
EN ;
 Q
TESTNOT ;called by option ORB NOT TEST - notification test procedure
 W !! K DIC
 S ORNOTE(97)="" ;use test notif 97
 K DIC S DIC="^DPT(",DIC(0)="AEQN",DIC("A")="Enter notification test patient's name: " D ^DIC Q:Y<1  S ORVP=+Y_";DPT("
 K DIC W ! S DIC="^VA(200,",DIC(0)="AENQ",DIC("A")="Enter notification recipient's (user) name: " S:$D(^TMP("ORB",$J,"ORBDUZ")) DIC("B")=^TMP("ORB",$J,"ORBDUZ") D ^DIC Q:Y<1  S ORBADUZ(+Y)=""
 D NOTE^ORX3 ;normal OE/RR notification processing entry point
 K DIC,ORVP,ORNOTE,ORBADUZ ;^TMP("ORB",$J,"ORBDUZ") killed by option
 Q
RECIPURG ;called by option ORB PURG RECIP - purge existing notifs: recipient/DUZ
 W !!,"This option purges all existing notifications for a recipient/user.",!?5,"*** USE WITH CAUTION ***"
 D GETUSER^ORBU
 S XQ1=$S($D(^TMP("ORB",$J,"ORBDUZ")):^TMP("ORB",$J,"ORBDUZ"),1:DUZ)
 W !!,*7,"Do you want to purge all notifications for recipient ",$P(^VA(200,XQ1,0),"^") S %=2 D YN^DICN D
 .I %=0 W !,"Enter 'YES' if you want to purge all existing notifications for this person.",!,"Do you want to purge all notifications for this recipient" S %=2 D YN^DICN
 Q:%'=1  W !!,"Purging notifications...",!
 D RECIPURG^XQALBUTL(XQ1)
 D END
 Q
PTPURG ;called by option ORB PURG PATIENT - purge existing notifs: patient
 W !!,"This option purges all existing notifications for a patient.",!?5,"*** USE WITH CAUTION ***"
 K DIC S DIC="^DPT(",DIC(0)="AENQ",DIC("A")="Enter notification patient's name: " D ^DIC Q:Y<1
 W !!,*7,"Do you want to purge all notifications for patient ",$P(Y,"^",2),"?" S %=2 D YN^DICN Q:%'=1  W !!,"Purging notifications...",!
 D PTPURG^XQALBUTL(+Y)
 D END
 Q
NOTIPURG ;called by option ORB PURG NOTIF - purge existing notifs: notification
 W !!,"This option purges all existing instances of a notification.",!?5,"*** USE WITH CAUTION ***"
 K DIC S DIC="^ORD(100.9,",DIC(0)="AENQ",DIC("A")="Enter notification name: " D ^DIC Q:Y<1
 W !!,*7,"Do you want to purge all instances of notification ",$P(Y,"^",2),"?" S %=2 D YN^DICN Q:%'=1  W !!,"Purging notifications...",!
 D NOTIPURG^XQALBUTL(+Y)
 D END
 Q
END K %,DIC,X1,X2,X,XQ1,XQ2,XQA,XQDAT,Y
 Q
