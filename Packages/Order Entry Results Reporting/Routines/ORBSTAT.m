ORBSTAT ; slc/CLA - OE/RR Notifications stats ;10/6/95  09:25 [ 04/02/2003   8:51 AM ]
 ;;8.0;KERNEL;**1002,1003,1004,1005,1007**;APR 1, 2003
 ;;8.0;KERNEL;**7**;Jul 10, 1995
 ;  MODIFIED FOR KERNEL 8.0  JLI(ISC-SF) 6/20/95
 Q
NOTIF ;called by option ORB STAT NOTIF - get stats for a single notification
 K DIC S DIC="^ORD(100.9,",DIC(0)="AEMNQ",DIC("A")="Enter notification's name: " F  D ^DIC Q:Y<1  S NIEN=+Y D
 .S (CNT,X)=0
 .F  S X=$O(^XTV(8992,"AXQAN",X)) Q:X=""  S:$P(X,",",3)=NIEN CNT=CNT+1
 .W !,"Total current occurrences of notification ",$P(^ORD(100.9,NIEN,0),"^")," = ",CNT,!
 K CNT,DIC,NIEN,X,Y
 Q
RECIP ;called by option ORB STAT RECIP - get stats for a single recipient
 K DIC S DIC="^VA(200,",DIC(0)="AEMNQ",DIC("A")="Enter recipient's (user's) name: " F  D ^DIC Q:Y<1  S RIEN=+Y D
 .S (CNT,X)=0
 .F  S X=$O(^XTV(8992,RIEN,"XQA",X)) Q:X=""  S:X>0 CNT=CNT+1
 .W !,"Total current notifications for recipient ",$P(^VA(200,RIEN,0),"^")," = ",CNT,!
 K CNT,DIC,RIEN,X,Y
 Q
PT ;called by option ORB STAT PATIENT - get stats for a single patient
 K DIC S DIC="^DPT(",DIC(0)="AEMNQ",DIC("A")="Enter patient's name: " F  D ^DIC Q:Y<1  S PIEN=+Y D
 .S (CNT,X)=0
 .F  S X=$O(^XTV(8992,"AXQAN",X)) Q:X=""  S:$P(X,",",2)=PIEN CNT=CNT+1
 .W !,"Total current notifications for patient ",$P(^DPT(PIEN,0),"^")," = ",CNT,!
 K CNT,DIC,PIEN,X,Y
 Q
RTOTALS ;called by option ORB STAT TOTALS - get and print stats for all recipients
 S DIC="^XTV(8992,",L=0,BY="-@COUNT(ALERT DATE/TIME),RECIPIENT",FR="",TO="",FLDS="[ORB RECIP TOTALS]"
 S DIS(0)="I $D(^XTV(8992,D0,""XQA"",0)),$D(^XTV(8992,D0,""XQA"",+$P(^(0),""^"",3),0))"
 S DIOBEG="W !,""... recipient totals are being calculated ..."""
 D EN1^DIP
 K BY,DIC,DIOBEG,DIS,FLDS,FR,L,TO
 Q
