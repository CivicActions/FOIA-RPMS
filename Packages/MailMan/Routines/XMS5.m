XMS5 ;(WASH ISC)/CAP/RM/AML-DISPLAY/TRANSMIT QUEUES ;05/27/99  07:22
 ;;7.1;MailMan;**13,8,23,27,55,58,50**;Jun 02, 1994
 ; Entry points used by MailMan options (not covered by DBIA):
 ; GO      XMQACTIVE
 ; ENT     XMQUEUED
 ; REQUE   XMSTARTQUE-ALL
ENT ;
 N XMDUZ,XMK
 S XMK=999
 F  S XMK=$O(^XMB(3.7,.5,2,XMK)) Q:XMK'>0  Q:XMK>9999  I $O(^(XMK,1,0))  W:'$D(ZTQUEUED) "." D RSEQ^XMXBSKT(.5,XMK)
 D EN^XUTMDEVQ("QZTSK^XMS5","MailMan Queues with Messages to Transmit Report")
 Q
QZTSK ;
 N XMIEN,XMK,XMKN,XMABORT,XMPAGE,XMDT,XMCNT,XMDREC
 S (XMPAGE,XMABORT,XMCNT("D"),XMCNT("M"))=0
 S XMDT=$$MMDT^XMXUTIL1($$NOW^XLFDT)
 W:$G(IOST)["C-" @IOF
 D QHDR(XMDT,.XMPAGE)
 S XMKN=""
 F  S XMKN=$O(^DIC(4.2,"B",XMKN)) Q:XMKN=""  D  Q:XMABORT
 . S XMIEN=0
 . F  S XMIEN=$O(^DIC(4.2,"B",XMKN,XMIEN)) Q:'XMIEN  D  Q:XMABORT
 . . S XMK=XMIEN+1000
 . . S XMCNT=$$BMSGCT^XMXUTIL(.5,XMK)
 . . Q:'XMCNT
 . . S XMDREC=^DIC(4.2,XMIEN,0)
 . . I $Y+3>IOSL D  Q:XMABORT
 . . . D PAGE(.XMABORT) Q:XMABORT
 . . . D QHDR(XMDT,.XMPAGE)
 . . W !,$E($P(XMDREC,U),1,40)
 . . W ?42,$J(XMCNT,5),"    ",$P(XMDREC,U,17)
 . . S XMCNT("D")=XMCNT("D")+1
 . . S XMCNT("M")=XMCNT("M")+XMCNT
 Q:XMABORT
 I 'XMCNT("D") W !,"No messages queued" Q
 I $Y+3>IOSL D  Q:XMABORT
 . D PAGE(.XMABORT) Q:XMABORT
 . D QHDR(XMDT,.XMPAGE)
 W !!,"Total Domains: ",XMCNT("D"),", Total Messages Queued: ",XMCNT("M")
 I $D(ZTQUEUED) S ZTREQ="@"
 Q:$G(IOST)'["C-"
 W !
 D WAIT^XMXUTIL
 Q
PAGE(XMABORT) ;
 I $G(IOST)["C-" D PAGE^XMXUTIL(.XMABORT) Q:XMABORT
 W @IOF
 Q
QHDR(XMDT,XMPAGE) ;
 S XMPAGE=XMPAGE+1
 W !,"Queues with messages to go out"
 W ?79-$L(XMDT),XMDT
 W !,"At "_^XMB("NETNAME"),?71,"Page: ",$J(XMPAGE,2)
 W !!,"Domain",?40,"# Que'd    Physical Link",!
 Q
GO ;DSP ALL
 D EN^XUTMDEVQ("AZTLOOP^XMS5","MailMan Active Queues Report")
 Q
AZTLOOP ;
 F  D AZTSK Q:$G(IOST)'["C-"  D  Q:'(Y!$D(DTOUT))
 . W !
 . N DIR,X,DTIME
 . S DTIME=5
 . S DIR(0)="Y",DIR("A")="Refresh",DIR("B")="YES"
 . S DIR("?",1)="Answer YES if you want the display refreshed."
 . S DIR("?",2)="Answer NO if you don't."
 . S DIR("?")="If you don't answer, the display will be refreshed every five seconds."
 . D ^DIR
 I $D(ZTQUEUED) S ZTREQ="@"
 Q
AZTSK ;
 N XMIEN,XMK,XMKN,XMABORT,XMPAGE,XMDT,XMCNT,XMDREC,XMSREC,XMSECS
 S (XMPAGE,XMABORT,XMCNT("D"),XMCNT("M"))=0
 S XMDT=$$MMDT^XMXUTIL1($$NOW^XLFDT)
 W:$G(IOST)["C-" @IOF
 D AHDR(XMDT,.XMPAGE)
 S XMKN=""
 F  S XMKN=$O(^DIC(4.2,"B",XMKN)) Q:XMKN=""  D  Q:XMABORT
 . S XMIEN=0
 . F  S XMIEN=$O(^DIC(4.2,"B",XMKN,XMIEN)) Q:'XMIEN  D  Q:XMABORT
 . . S XMSREC=$G(^XMBS(4.2999,XMIEN,3))
 . . Q:XMSREC=""
 . . S XMSECS=$$HDIFF^XLFDT($H,$P(XMSREC,U),2)
 . . Q:XMSECS>599
 . . Q:$P(XMSREC,U,1,6)?.P
 . . S XMK=XMIEN+1000
 . . S XMCNT=$$BMSGCT^XMXUTIL(.5,XMK)
 . . S XMDREC=^DIC(4.2,XMIEN,0)
 . . I $Y+3>IOSL D  Q:XMABORT
 . . . D PAGE(.XMABORT) Q:XMABORT
 . . . D AHDR(XMDT,.XMPAGE)
 . . W !,$$MELD^XMXUTIL1($P(XMDREC,U),XMCNT,23)," "  ; domain, q'd msgs
 . . I XMSECS>180 D
 . . . W $E($P(XMSREC,U,6),1,16)
 . . . W ?40," == Appears Inactive - ",XMSECS\60," Minutes",!,?40," == Analysis of device indicated."
 . . E  D
 . . . I '$P(XMSREC,U,2) D  Q
 . . . . W $E($P(XMSREC,U,6),1,16)
 . . . . W ?44,"Connecting/Disconnecting"
 . . . S:$P(XMSREC,U,4)<0 $P(XMSREC,U,4)=""
 . . . ; Device, Msg #, xmit line, ztsk, errors, xmit rate
 . . . W $$MELD^XMXUTIL1($P(XMSREC,U,6),$P(XMSREC,U,2),28),$J($P(XMSREC,U,3),6),$J($P(XMSREC,U,7),10),$J($P(XMSREC,U,4),4),$J($P(XMSREC,U,5),8)
 . . S XMCNT("D")=XMCNT("D")+1
 . . S XMCNT("M")=XMCNT("M")+XMCNT
 Q:XMABORT
 I $Y+$S($G(IOST)["C-":2,1:0)+$S(XMCNT("D"):4,1:3)>IOSL D  Q:XMABORT
 . D PAGE(.XMABORT) Q:XMABORT
 . D AHDR(XMDT,.XMPAGE)
 I 'XMCNT("D") W !,"No messages actively transmitting"
 E  W !!,"Total Domains: ",XMCNT("D"),", Total Messages Queued: ",XMCNT("M")
 Q
AHDR(XMDT,XMPAGE) ;
 S XMPAGE=XMPAGE+1
 W !,"Queues actively transmitting messages"
 W ?79-$L(XMDT),XMDT
 W !,"At "_^XMB("NETNAME"),?71,"Page: ",$J(XMPAGE,2)
 W !,?75,"Rate"
 W !,"Domain",?16,"# Que'd  Device/Protocol",?47,"Msg #",?54,"Line",?63,"ZTSK  Err  C/Sec",!
 Q
TASK ;
REQUE ;
 K ^TMP($J,"ZTMKZ") S %=$G(XMDUZ)
 N DIR,DIRUT,DTOUT,DUOUT,I,J,K,X,XMDUZ,Y,ZTD,ZTI,ZTQ,ZTS
 S XMDUZ=$S($G(%):%,1:DUZ)
 S I=999 F  D  Q:I=""
 . S I=$O(^XMB(3.7,.5,2,I)) I $S(I'=+I:1,I>9999:1,I<1001:1,1:0) S I="" Q
 . W:'$D(ZTQUEUED) "." I $O(^XMB(3.7,.5,2,I,1,0)) S K=I-1000 D
 . . S J=$P($G(^XMBS(4.2999,K,0)),U,2) S:J J=$$CHK(J,K) I 'J S ^TMP($J,"ZTMKZ",$P(^DIC(4.2,K,0),U))=K
 . Q
 ;
 ;W/Tasks
 ;W:'$D(ZTQUEUED) !,"Wait for %ZTLOAD",!
 ;D H F ZTS=0:0 S ZTS=$O(^%ZTSK(ZTS)) Q:'ZTS  S %=$S($D(^%ZTSK(ZTS,.1)):^(.1),1:"") I $S($L(%)'=1:1,"12345AG"[%:1,1:0),$D(^(.3,"XMB","XMSCRN"))#2 S ZTD=^("XMSCRN") K ^TMP($J,"ZTMKZ",ZTD)
 ;
 I '$D(ZTQUEUED) W !,"Some queues have no messages.",!
 D H S ZTD="" F ZTI=2:1 S ZTD=$O(^TMP($J,"ZTMKZ",ZTD)) Q:ZTD=""  I '$O(^XMB(3.7,.5,2,^(ZTD)+1000,1,0)) K ^TMP($J,"ZTMKZ",ZTD)
 I $O(^TMP($J,"ZTMKZ",""))="" W:'$D(ZTQUEUED) !!!,"<<<<  NO domains lack tasks !!! >>>",!!! Q
 I '$D(ZTQUEUED) W !!,"These domains lack tasks."
 I  S ZTD="" F ZTI=2:1 S ZTD=$O(^TMP($J,"ZTMKZ",ZTD)) Q:ZTD=""  S X=^(ZTD) W !?5,ZTD W:$P(^DIC(4.2,X,0),U,2)'["S" " << No Send Flag" I ZTI#20=0 S DIR(0)="E" D ^DIR K DIR,DIRUT
 ;
 ;
 I '$D(ZTQUEUED) S DIR(0)="YO",DIR("A")="Requeue the missing tasks",DIR("B")="NO",DIR("?")="Answer YES to transmit these domains." D ^DIR K DIR,DIRUT I 'Y W !!,"Tasks not requeued." K ^TMP($J,"ZTMKZ") Q
 ;
 ;
 S XMDUZ=$S($D(XMDUZ)[0:.5,'XMDUZ:.5,1:XMDUZ)
 S XMS5="",XMS5("RETURN_TASK#")=1 F XMS5Z=0:0 S XMS5=$O(^TMP($J,"ZTMKZ",XMS5)) Q:XMS5=""  S XMSITE=XMS5,(XMINST,XMSCR)=^TMP($J,"ZTMKZ",XMS5) D Z
 W:'$D(ZTQUEUED) !,"Done !" K XMS5,XMS5Z,^TMP($J,"ZTMKZ"),ZTD,ZTS Q
H F I=1:1:9 H 1 W:'$D(ZTQUEUED) "."
 Q
CHK(ZTSK,XMINST) ;Is Task scheduled ? (0=no,.5=pending,1=running)
 Q:'ZTSK 0
 N % D STAT^%ZTLOAD
 Q:ZTSK(1)=0 0  ; "Undefined"
 Q:ZTSK(1)=1 .5  ; "Active: Pending"
 I ZTSK(1)=2 N %1 D  L -^DIC(4.2,+$G(XMINST),"XMNETSEND") Q %1
 . ; "Active: Running"
 . L +^DIC(4.2,+$G(XMINST),"XMNETSEND"):2 ; Is it really running?
 . I $T D KILL(XMINST,ZTSK) S %1=0 Q  ; Nope
 . S %1=1  ; Yep
 Q:ZTSK(1)=3 0  ; "Inactive: Finished"
 I ZTSK(1)=4 D KILL(XMINST,ZTSK) Q 0  ; "Inactive: Available"
 I ZTSK(1)=5 D KILL(XMINST,ZTSK) Q 0  ; "Interrupted"
 Q
KILL(XMINST,ZTSK) ;
 D KILL^%ZTLOAD
 ;S $P(^XMBS(4.2999,XMINST,0),U,2)=""  ; Task number
 ;K ^XMBS(4.2999,XMINST,3)  ; Progress report
 ;K ^XMBS(4.2999,XMINST,4)  ; Transmission data
 ;K ^XMBS(4.2999,XMINST,5)  ; Transmission script
 ;K ^XMBS(4.2999,XMINST,6)  ; Transmission audit
 Q
Z N % S %=$P(^DIC(4.2,XMINST,0),U,2)
 I %["C"!(%["c")!(%["P")!(%["p") W:'$D(ZTQUEUED) !!,"Domain ",XMS5," has no send flag." Q
 N XMB,ZTSK D ENQ^XMS1
 I $G(ZTSK) W:'$D(ZTQUEUED) !!,"Task "_ZTSK_" queued for domain "_XMS5,! Q
 I '$D(ZTQUEUED) W !!,"NO task queued for domain "_XMS5_"."
 Q
