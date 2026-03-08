XMC2 ;(WASH ISC)/THM-COMM FUNCTIONS ;03/21/99  10:38
 ;;7.1;MailMan;**13,23,27,50**;Jun 02, 1994
 ; Entry points used by MailMan options (not covered by DBIA):
 ; VAL    XMEDIT-DOMAIN-VALIDATION#
 ; LST    XMLIST
 ; OUT    XMSCRIPTOUT
 ; Q      XMSTARTQUE
 Q
INIT ;INITIALIZE COMMAND TABLE
 K ^DOPT("XMC") S DIK="^DOPT(""XMC""," S ^DOPT("XMC",0)="Network TalkMan Option^1N^" F I=1:1 S X=$E($T(Z+I),4,99) Q:X=""  S ^DOPT("XMC",I,0)=X
 D IXALL^DIK Q
Z ;;
 ;;ACTIVELY TRANSMITTING QUEUES REPORT^GO^XMS5
 ;;DIAL PHONE^DI^XMC11
 ;;EDIT A SCRIPT^EDIT^XMC11
 ;;HANG UP PHONE^H^XMC11
 ;;HISTORICAL QUEUE STATISTICS REPORT^^XMS4
 ;;LIST TRANSCRIPT^LST^XMC2
 ;;PLAY A SCRIPT^GO^XMC11
 ;;QUEUES WITH MESSAGES TO GO OUT REPORT^ENT^XMS5
 ;;RECEIVE MESSAGES FROM ANOTHER UCI VIA %ZISL GLOBAL^RECV^XMS3
 ;;RESUME SCRIPT PROCESSING^RES^XMC11
 ;;SCHEDULE TASKS FOR ALL QUEUED MESSAGES^REQUE^XMS5
 ;;SEND MESSAGE TO OTHER XMB GLOBAL VIA %ZISL GLOBAL^TASKER^XMS
 ;;SEQUENTIAL MEDIA QUEUE TRANSMISSION^BAT^XMS
 ;;SEQUENTIAL MEDIA MESSAGE RECEPTION^BAT^XMR
 ;;SHOW A QUEUE^QUEUE^XMC4
 ;;STATUSES REPORT^^XMS5A
 ;;SUBROUTINE EDITOR^EDITSC^XMC11
 ;;TOGGLE A SCRIPT OUT OF SERVICE^OUT^XMC2
 ;;TRANSMIT QUEUED MESSAGES FOR ONE DOMAIN^Q^XMC2
 ;;VALIDATION NUMBER EDIT^VAL^XMC2
 ;;
 ;;**OBSOLETE**
 ;;BLOB SEND^BLOB^XMA2B
 ;;IMMEDIATE SCRIPT MODE^IMM^XMC11
 ;;MAILMAN^^XM
 ;;
LST S XMB=0,I=0
C S XMB=$O(^TMP("XMC",XMB))
D I XMB="" W !!,*7,"<< No ",$S(I:"more ",1:""),"Transcripts on File. >>",!
 I  W "(This is controlled by whether or not line TRAN+3^XMC1 is commented out !",!,"Remember to put the ';' back in when done viewing transcripts.",!,"It is more efficient that way.)",!! G E
 W !,"7 lines of the transcript will be displayed at a time." H 2
 S K=0,I=XMB F J=0:0 S J=$O(^TMP("XMC",I,J)) Q:J=""  W !,^(J,0) S K=K+1 Q:K>7
 S DIR(0)="E",XMB0=J_U_I W !! D ^DIR S J=+XMB0,I=$P(XMB0,U,2) K XMB0,DIRUT
 I $D(DUOUT)!$D(DTOUT) K XMB0 G B
 G K:J=0 S K=0
L S J=$O(^TMP("XMC",I,J)) I J'="",$D(^(J,0)) S X=$G(^(J,0)) S:X?.E1C.E X=$$STRAN^XMCU1(X) W !,X S K=K+1 G L:K<8 S XMB0=I_U_J W ! D ^DIR S K=0,I=+XMB0,J=$P(XMB0,U,2) K XMB0,DIRUT W ! I '$D(DUOUT),'$D(DTOUT) G L
K W *7,!!,"DELETE this Transcript ? N// " R J:DTIME Q:'$T
 I J["?" D  G K
 . W !!,"Enter 'Yes' to delete this transcript."
 . W !,"Enter 'No' or <RETURN> to keep this transcript on file."
 . W !,"Or enter '^' to abort."
 . Q
 S J=$TR("noyes","NOYES") W !,"Transcript "
 I $E("YES",1,$L(J))=J K ^TMP("XMC",I) S BF=1 W *7,"DELETED !" G B
 W "RETAINED",! I J["^" W !!,"Aborted by user request",! G E
B I '$O(^TMP("XMC",XMB)) S XMB="" G D
 W !!,"Do you wish to see the next transcript ? Y//",*7 R J:DTIME G E:'$T,E:"yY"'[$E(J) S I=1 G C
E K DUOUT,DTOUT,DIR,XMB Q
Q ;TRIGGER A QUEUE FOR TRANSMISSION
 N XMQ1,XMB,ZTSK,XMABORT
 S XMQ1=1,XMABORT=0
 D INST^XMC11A(.XMSCR,.XMSCRN,.XMB,.XMDIC,.XMIO,.XMABORT) G QQ:XMABORT
 S %=$P($G(^DIC(4.2,XMSCR,1,XMB("SCRIPT",0),0)),U,4) I $S(%="SMTP":0,%="":0,1:1) W !!,"MailMan does not allow tasking with TCP/IP transmission script." G QQ
 S %=$S($P(^XMBS(4.2999,XMSCR,0),U,2):$P(^(0),U,2),1:0) I % S %1=$$CHK^XMS5(%,XMSCR)
 I '$G(%1) D QTASK G QQ
 I %1=1 W !!,*7,"Task #"_%_" is already running to transmit this domain's messages,",!,"so we won't queue up another one." G QQ
 ; (%1=.5 means: Task is pending)
 W !!,*7,"Task #"_%_" is already scheduled to transmit this domain's messages"
 W !,"on ",$$HTE^XLFDT($P(^%ZTSK(%,0),U,6)),"."
 N DIR
 S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Do you want to kill task "_%_" and queue up a new one"
 D ^DIR
 I Y=1 D KILL^XMS5(XMSCR,%),QTASK
QQ K %H,XMDT,XMINST,XMIO,XMSITE,XMSCR,XMSCRN,ZTSK
 Q
QTASK ;
 S XMSITE=XMSCRN,XMINST=XMSCR,XMS5("RETURN_TASK#")=1
 D ENQ^XMS1
 W:$G(ZTSK) !,"Task #"_ZTSK_" Queued for transmission"
 Q
OUT ;toggle script out of service
 N %,D,D0,D1,DA,DI,DIC,DIE,DIR,DIRUT,DIOUT,DR,X,XMB,XMINST,XMOKSCR
 N XMS5,XMSCR,XMSCRN,XMSITE,XMTMP,Y,ZTSK,XMSCRDAT,XMABORT
 S XMABORT=0
 D ASKINST^XMC11A(.XMSCR,.XMSCRN,.XMB,.XMABORT) Q:XMABORT
 S DA=XMSCR,DR="1;4",DR(2,4.21)=1.5,DIE="^DIC(4.2,"
 D ^DIE
 S DIR(0)="Y",DIR("A")="Do you want to requeue this domain",DIR("B")="YES",DIR("?")="Yes, will create a task to start transmitting this domain."
 D ^DIR Q:'Y!$D(DIRUT)
 S ZTSK=$P($G(^XMBS(4.2999,XMSCR,3)),U,7)
 I ZTSK D KILL^%ZTLOAD S XMTMP(4.2999,XMSCR_",",25)="" D UPDATE^DIE("","XMTMP")
 S (XMOKSCR("SMTP"),XMOKSCR("NONE"))=""
 S XMSCRDAT=$$SCR^XMBPOST(XMSCR,.XMOKSCR,"")
 I XMSCRDAT="" W !!,"No Transmission Script !!!",*7,!! Q
 D S^XMC11A(XMSCRDAT,.XMB,.XMIO)
 S XMSITE=XMSCRN,XMINST=XMSCR,XMS5("RETURN_TASK#")=1
 D ENQ^XMS1 I '$G(ZTSK) W !!,"Couldn't create task",! Q
 W !,"Task #",ZTSK," Queued for transmission.",!
 Q
VAL S DR="1.6",DIC=4.2,DIC(0)="AEQMZ" D ^DIC Q:Y<0  S DIE=DIC,DA=+Y D ^DIE Q
