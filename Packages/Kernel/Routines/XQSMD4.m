XQSMD4 ; SEA/MJM,JLI - Edit a user's options ;2/1/90  15:32 ; [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1002,1003,1004,1005,1007**;APR 1, 2003
 ;;8.0;KERNEL;;Jul 10, 1995
BUILD ;
 I '($D(^VA(200,DUZ,19.5,0))#2) W !!,$C(7),"You have not been delegated options with which to build a menu.",! G K
 D NAME I 'XQVALID G K
 W !!,"OPTION NAME: " R X:$S($D(DTIME):DTIME,1:999) G:'$T!(X="")!(X[U) K D CHKNAM G:'XQVALID BUILD
 S XQSMDOPT=X,DIC(0)="MLE",DIC=19,DLAYGO=19 D ^DIC G:Y'>0 BUILD S XQSMDY=+Y I '$P(Y,U,3) G OLD
 ;
NEW ;
 S DIE=DIC,DR="1;3.5;4///M;",DA=+Y D ^DIE ; ENTER AS NEW OPTION AND FORCE TYPE TO BE MENU
 S DIC="^VA(200,"_DUZ_",19.5,",P=200.19,X=XQSMDOPT,DIC(0)="MLX",DA(1)=DUZ,DLAYGO=200 D ^DIC Q:Y'>0
 G EDIT
 ;
OLD ;
 I $P(^DIC(19,XQSMDY,0),U,4)'="M" W !,*7,"This option already exists but is not a MENU." G BUILD
 I '$D(^VA(200,DUZ,19.5,XQSMDY,0)) W !,*7,"This option already exists but is not included in your delegated options,",!,"choose another option name or get this option delegated to yourself" G BUILD
 ;
EDIT ;
 W !!,"NOTE THAT YOU MAY ONLY INCLUDE OPTIONS THAT HAVE BEEN DELEGATED AS ITEMS TO",!,"YOU.",!
 ;
EDIT1 ;
 W !,"   Select ITEM: " R X:$S($D(DTIME):DTIME,1:999) G:'$T!(X="")!(X[U) ENDIT
 S DIC("S")="I $D(^VA(200,DUZ,19.5,+Y,0)) Q",DIC="^DIC(19,",P=19,DIC(0)="EQM" D ^DIC I Y'>0 G EDIT1
 K DIC S DLAYG0=19,X=$P(Y,U,2),DIC="^DIC(19,XQSMDY,10,",P=19.01,DA(1)=XQSMDY,D0=XQSMDY,DIC(0)="ML" S:'$D(@(DIC_"0)")) @(DIC_"0)")="^19.01PI" D ^DIC I Y'>0 G ENDIT
 I '$P(Y,U,3) S DR=".01///@;" W !,*7,"MENU ITEM ",$P(^DIC(19,+$P(Y,U,2),0),U,1)," DELETED FROM MENU ******" ; IF RESELECTED REMOVE IT FROM MENU
 E  S DR="2:3;"
 S DIE=DIC,DA=+Y,DA(1)=XQSMDY D ^DIE
 G EDIT1
 ;
NAME ; Check for available namespaces, let user know rules
 I '$D(^VA(200,DUZ,19.6)) W !!,*7,"No available namespace(s) has been established for you to build new menus.",!,"See your site manager or his representative to establish your namespace(s).",!!,*7 S XQVALID=0 Q
 K X S X=0 F I=0:0 S I=$O(^VA(200,DUZ,19.6,I)) Q:I'>0  S X=X+1,X(X)=^(I,0)
 I X=0 K ^VA(200,DUZ,19.6) G NAME
 W !,"The menu options you build or edit must begin with ",$S(X>1:"one of ",1:""),"the namespace",$S(X>1:"(s)",1:""),":"
 F I=1:1:X W !?10,X(I)_"Z"
 W ! S XQVALID=1
 Q
 ;
CHKNAM ;
 S XQVALID=0 F I=0:0 S I=$O(X(I)) Q:I=""  I $E(X,1,$L(X(I)))=X(I),$E(X,$L(X(I))+1)="Z" S XQVALID=1 Q
 I 'XQVALID W !!,*7,"A menu option created by user from delegated options is a local option and MUST",!,"begin with a valid namespace, e.g., ",X(1),", followed by the letter Z, e.g., ",X(1),"Zxxx.",*7,!
 Q
ENDIT ;
 S XQVALID=$O(^DIC(19,XQSMDY,10,0)),DIE="^VA(200,"_DUZ_",19.5,"
 I XQVALID'>0 S DA(1)=DUZ,DA=XQSMDY,P=200.19,DR=".01///@;" D ^DIE S DIE=19,DA=XQSMDY,DR=".01///@;" D ^DIE W !!,*7,"** EMPTY MENU removed from option file and your delegated options",*7,!
K K XQSMDUZ,XQSMDY,XQSMDOPT,XQVALID,DIE,DIC,%,%1,%DT,%H,%W,%Y,D,D0,D1,DA,DI,DIG,DIH,DIU,DIV,DQ,DR,I,J,K,L,P,X,XQD,XQPK,XQR,DG,DIW,XY,Y,DICR
 Q
