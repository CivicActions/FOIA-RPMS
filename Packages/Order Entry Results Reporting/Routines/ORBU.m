ORBU ; slc/CLA - Mgmt utilities for OE/RR notifications ;8/22/91  18:34 [ 04/02/2003   8:51 AM ]
 ;;8.0;KERNEL;**1005,1007**;APR 1, 2003
 ;;2.5;ORDER ENTRY/RESULTS REPORTING;;Jan 08, 1993
GETUSER ;called by ADD, DEL, LIST and options ORB NOT MGR MENU, ORB NOT COORD MENU - get user DUZ if not already in ^TMP(
 I '$D(^TMP("ORB",$J,"ORBDUZ")) D
 .K DIC,Y S DIC="^VA(200,",DIC(0)="AEQ",DIC("A")="Enter user's name: ",DIC("B")=DUZ D ^DIC S:Y<1 XQUIT=""
 .S ^TMP("ORB",$J,"ORBDUZ")=$S(Y'<1:$P(Y,"^"),1:DUZ) K DIC,Y
 S ORBDUZ=^TMP("ORB",$J,"ORBDUZ")
 Q
SETUP ;called by ADD, DEL - cleanup then set up ORUS vars and ask user to select notifs for processing
 K ^XUTL("OR",$J,"ORLP"),^("ORV"),^("ORU"),^("ORW")
 S ORUS="^ORD(100.9,"
 D ^ORUS I ($D(Y))<10 K ORUS,Y Q
 S J=0 F  S J=$O(Y(J)) Q:'J  S ORBY(J)=Y(J)
 Q
HEADER ;called by ADD, DEL - header displaying prompt help
 W "You may enter single or a range of numbers (e.g. 9 or 1,12 or 4-10 or 1,4,6-15.)",!,"Enter ALL to select all notifications.",!
 Q
ADD ;called by option ORB NOT ADD - turn ON notifs for user
 D GETUSER
 W @IOF,"Notifications on the system you may elect to receive.",!,"Turn ON notifications you want to receive by selecting from this list.",!
 S ORUS(0)="40MNA",ORUS("S")="I ^ORD(100.9,ORDA,3)=""E""",ORUS("A")="Select notifications to turn ON: "
 D HEADER,SETUP S ORBI=0
 F  S ORBI=$O(ORBY(ORBI)) Q:ORBI<1  D ADDLOOP
 D END
 Q
ADDLOOP ;called by ADD - add user as a RECIPIENT USER to notifs selected
 Q:$D(^ORD(100.9,"E",ORBDUZ,+ORBY(ORBI)))  ;quit if notif already ON for user
 S:'$D(^ORD(100.9,+ORBY(ORBI),200,0)) ^(0)="^100.9002PA^^"
 K DIC,DA,DO,DD
 S X=ORBDUZ,DA(1)=+ORBY(ORBI),DIC="^ORD(100.9,"_DA(1)_",200,",DIC(0)="L"
 D FILE^DICN
 Q
DEL ;called by option ORB NOT DELETE - turn OFF notifs for user
 D GETUSER
 W @IOF,"Notifications  ",$P(^VA(200,ORBDUZ,0),"^"),"  has turned on and can receive.",!,"Turn OFF notifications by selecting from this list.",!
 S ORUS(0)="40MNA",ORUS("S")="I $D(^ORD(100.9,""E"",ORBDUZ,ORDA))&(^ORD(100.9,ORDA,3)=""E"")",ORUS("A")="Select notifications you want to turn OFF: "
 D HEADER,SETUP S ORBI=0
 F  S ORBI=$O(ORBY(ORBI)) Q:ORBI<1  D DELLOOP
 D END
 Q
DELLOOP ; called by DEL - remove user as a RECIPIENT USER from notifs selected
 Q:'$D(^ORD(100.9,"E",ORBDUZ,+ORBY(ORBI)))  ;quit if notif is not ON for user
 S DA(1)=+ORBY(ORBI),DA=0,DA=$O(^ORD(100.9,"E",ORBDUZ,DA(1),DA)),DIK="^ORD(100.9,"_DA(1)_",200," D ^DIK
 Q
LIST ;called by option ORB NOT REVIEW - list user's notifs
 D GETUSER,SETUP
 W @IOF,"Notifications  ",$P(^VA(200,ORBDUZ,0),"^"),"  has turned on and can receive.",!,"(* indicates a mandatory notification which cannot be turned off.)",!
 S ORUS("S")="I $D(^ORD(100.9,""E"",ORBDUZ,ORDA))&(^ORD(100.9,ORDA,3)=""E"")",ORUS(0)="40MA",ORUS("A")="Press return to continue: "
 ;now display mandatory notifications
 S K=0 F N=1:1 S K=$O(^ORD(100.9,K)) Q:K<1  I ^(K,3)="M" S ORUS(900,N)=$P(^(0),"^")_"^"_"   *"
 S ORUS="^ORD(100.9,"
 D EN1^ORUS
END ; 
 K DA,DIE,DIK,DR,J,K,N,NIEN,NUM,ORBDUZ,ORBI,ORBY,ORUS,Y
 K ^XUTL("OR",$J,"ORLP"),^("ORV"),^("ORU"),^("ORW")
 ; ^TMP("ORB",$J,"ORBDUZ") killed by options
 Q
