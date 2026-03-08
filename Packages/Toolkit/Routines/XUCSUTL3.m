XUCSUTL3 ;CLARKSBURG/SO UTILITIES FOR REPORTS - PART 3 ;2/27/96  09:57 [ 04/02/2003   8:47 AM ]
 ;;7.3;TOOLKIT;**1001**;APR 1, 2003
 ;;7.3;TOOLKIT;**6,12,14,15**;Apr 25, 1995
A1 ; Ask Number of Char. for Routines & Globals
 ; XUCSRL = routine name length
 ; XUCSTH = '<thresh' Value
 I '$D(^XUCS(8987.1,1,0)) S XUCSEND=1 Q
 S DIE="^XUCS(8987.1,",DA=1,DR="5;5.2" D ^DIE  K DIE,DA,DR I X=""!($D(DTOUT)) K DTOUT S XUCSEND=1 Q
 S XUCSSY=^XUCS(8987.1,1,0),XUCSRL=$P(XUCSSY,"^",3),XUCSTH=$P(XUCSSY,"^",6)
 Q
A2 ; Get type of report
 ; XUCSRT =
 ;     A = AM Reports Only
 ;     P = PM Reports Only
 ;     B = Both AM & PM Reports
 K DIR S DIR(0)="SM^A:AM Reports Only;P:PM Reports Only;B:Both AM & PM Reports",DIR("A")="     Report Type",DIR("B")="Both" D ^DIR K DIR I Y=""!(Y="^") S XUCSEND=1 Q
 S XUCSRT=Y
 Q
A3 ; Get Date Range of Report & AM-PM
 ; XUCSBD = Beginning Date
 ; XUCSED = Ending Date
 ;S X1=DT,X2=-1 D C^%DTC S XUCSDD1=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3),XUCSDD2=X
 S X=9999999,X=$O(^XUCS(8987.2,"C",X),-1),X=$P(X,"."),XUCSDD1=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3),XUCSDD2=X
A3A ; Get Beginning Date
 K DIR S XUCSBD="",XUCSBD=$O(^XUCS(8987.2,"C",XUCSBD)),DIR(0)="D^"_$S(XUCSBD]"":$P(XUCSBD,"."),1:"")_":"_XUCSDD2_":EPX",DIR("A")="Enter Beginning Date",DIR("B")=XUCSDD1,DIR("?")="^D A3H^XUCSUTL3"
 D ^DIR K DIR I $D(DIRUT) K DIRUT S XUCSEND=1 G A3XIT
 S XUCSBD=$P(Y,".")
A3B ; Get Ending Date
 K DIR S DIR(0)="D^"_XUCSBD_":"_XUCSDD2_":EPX",DIR("A")="   Enter Ending Date",DIR("B")=XUCSDD1,DIR("?")="^D A3H^XUCSUTL3"
 D ^DIR K DIR I $D(DIRUT) K DIRUT S XUCSEND=1 G A3XIT
 S XUCSED=$P(Y,".")
 I XUCSBD'=XUCSED,XUCSED']XUCSBD W $C(7),!,"Ending Date must be Greater than Beginning date." G A3
 ; If XUCSNOA2 then Entry Point A2 will not done
 K XUCSDD1,XUCSDD2 D:'$D(XUCSNOA2) A2
A3XIT I XUCSEND K XUCSDD1,XUCSDD2,XUCSBD,XUCSED,XUCSRT
 Q
A3H ; Date Selection Help
 N DIR,%DT
 D A3HH S:'$D(XUCSBD) XUCSXD=0 S:$D(XUCSBD) XUCSXD=XUCSBD-1
 S XUCSXDD=0 F  S XUCSXD=$O(^XUCS(8987.2,"C",+XUCSXD)) Q:+XUCSXD<1!($D(A3HOUT))  D
 . I XUCSXDD'=$P(XUCSXD,".") S XUCSXDD=$P(XUCSXD,".") W !,?5,$E(XUCSXDD,4,5)_"-"_$E(XUCSXDD,6,7)_"-"_$E(XUCSXDD,2,3)
 . I $Y>(IOSL-5) D A3HP D:'$D(A3HOUT) A3HH Q:$D(A3HOUT)
 . Q
 K XUCSXD,XUCSXDD,A3HOUT
 Q
A3HH ; Date Selection Header
 W @IOF,!,"Some of the Dates you may choose from:",!
 Q
A3HP ; Date Help Pause
 K DIR S DIR(0)="E" D ^DIR K DIR I $D(DIRUT) K DIRUT S A3HOUT=1
 Q
A4 ; Ask Number of Char. Globals
 ; XUCSGL = global name length
 ; XUCSTH = '<thresh' Value
 I '$D(^XUCS(8987.1,1,0)) S XUCSEND=1 Q
 S DIE="^XUCS(8987.1,",DA=1,DR="5.1;5.3" D ^DIE K DIE,DA,DR I X=""!($D(DTOUT)) K DTOUT S XUCSEND=1 Q
 S XUCSSY=^XUCS(8987.1,1,0),XUCSGL=$P(XUCSSY,"^",5),XUCSTH=$P(XUCSSY,"^",7)
 Q
A5AB ; Filter Out File Servers? Y/N
 K DIR S DIR(0)="SAOB^A:ALL Nodes are to be printed;U:USER Selected Nodes are to be printed"
 S DIR("B")="ALL",DIR("A")="Print/Display which Nodes: ",DIR("?")=" ",DIR("?",1)="A = ALL Nodes are to be printed.",DIR("?",2)="U = USER Selected Nodes are to be printed."
 D ^DIR K DIR I $D(DTOUT)!($D(DUOUT)) S XUCSEND=1 K DIRUT,DTOUT,DUOUT Q
A5A I $E(Y)="U" DO
 . S XUCSFS=""
A5AQ . W !!,?10,"<cr> to QUIT selection.",?10 S DIC="^XUCS(8987.2,",DIC(0)="AEMQZ",DIC("A")="Slect Node to be printed: " D ^DIC K DIC
 . I $D(DTOUT) K XUCSFS S XUCSEND=1 Q  ; User Timed Out
 . I $D(DUOUT) K XUCSFS S XUCSEND=1 Q  ; User '^' Out
 . I +Y<1 Q  ; User Done Selecting\
 . S XUCSFS(Y(0,0))="" G A5AQ
 . Q
 K XUCSD0,XUCSD1,XUCSX
 Q
S1 ; Set Scale For CMND/SEC & GREF/SEC
 S XUCSS1C=10 ; Scale for CMNDS/SEC
 S XUCSS1G=2 ; Scale for GREF/SEC
 Q
S2 ; Set Scale For GREF/SEC by GLOBAL
 S XUCSS2G=10 ; Scale for GREF/SEC by GLOBAL
 Q
SITEH ; Get Site Name For Report
 N X
 S X=0,X=$O(^DIC(4,"D",+XUCSVG,X))
 I X,$D(^DIC(4,+X,0))#2 S XUCSITEH=XUCSVG_"."_$P(^DIC(4,+X,0),"^") Q
 I 'X S XUCSITEH=XUCSVG_"."_"File #4 Entry Missing"
 Q
SITE ; Get Site Info. From - 8987.1;.01
 K DIC S DIC="^XUCS(8987.1,",DIC(0)="MNXZ",X=1 D ^DIC K DIC I +Y<1 S XUCSEND=1 Q
 S XUCSITE=Y(0,0),XUCSITEN=$P(Y(0),"^",2)
 Q
A5 ; SITE_VOL GROUP SELECTION
 K DIC,DIR,DA,XUCSFS S DIR(0)="FAOU^0:6^S Y=$$UP^XLFSTR(X)",DIR("A")="Select Site/Vol. Group: ",DIR("B")="ALL",DIR("?")="^D A5LH^XUCSUTL3 S DIC=8987.2,DIC(0)=""Q"" D ^DIC" D ^DIR
 I $D(DTOUT)!($D(DUOUT)) K DTOUT,DUOUT S XUCSEND=1 Q
 I "ALL"[Y K DIR Q
 S XUCSFS=""
 K DIC S DIC=8987.2,DIC(0)="EMQZ",X=Y D ^DIC I Y'=-1 S XUCSFS(Y(0))=""
A5L ;
 K DIC,DIR,DA
 S DIC=8987.2,DIC(0)="AEMQZ" D ^DIC
 I $D(DTOUT)!($D(DUOUT))!($D(DIRUT)) K DTOUT,DUOUT,DIRUT S XUCSEND=1 Q
 I Y'=-1 S XUCSFS(Y(0))="" G A5L
 Q
A5LH ; A Little Help For Our Friends
 W !!,"If you want to Print/Display ALL nodes then take the default.",!,"Otherwise make individual selection(s) from the following nodes.",!
 Q
