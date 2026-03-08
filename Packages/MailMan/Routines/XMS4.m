XMS4 ;(WASH ISC)/CAP/AML/RJ-Query into message queues ;03/10/98  07:32
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Entry points used by MailMan options (not covered by DBIA):
 ; ^XMS4   XMQHIST
 D EN^XUTMDEVQ("ENT^XMS4","MailMan Queue History Report")
 Q
ENT K DIR S (XMF0,XMF0("PG"),XMC0,XME0)=0,DIR(0)="E" D NOW^%DTC
 S XMD0=$$MMDT^XMXUTIL1($$NOW^XLFDT)
Q S XMF0=$O(^DIC(4.2,"B",XMF0)) I XMF0="" G END
 S XMG0=$O(^DIC(4.2,"B",XMF0,0)),XMB0=$G(^XMBS(4.2999,XMG0,0))
 S XMB=$E(XMF0,1,16),XMA=0 D M I XMB0="",XMA=0 G Q
W ;write results
 S XMC0=XMC0+1_U_($P(XMC0,U,2)+$P(XMB0,U,5))_U_($P(XMC0,U,3)+$P(XMB0,U,7))_U_($P(XMC0,U,4)+XMA)
 I $Y+5>IOSL!'XMF0("PG") S X="" D:'$D(ZTQUEUED)&XMF0("PG") ^DIR:IOST?1"C-".E K DIRUT D HD G END:X=U
 W:$X>60 !
 W $E(XMB_"                  ",1,18),$J(XMA,6),$J($P(XMB0,U,5),6),$J($P(XMB0,U,7),7) W:$X<40 ?41
 G Q
M ;number in queue
 S XMA=$$BMSGCT^XMXUTIL(.5,XMG0+1000)
 Q
HD S XMF0("PG")=XMF0("PG")+1 W @IOF,!,"TRANSMISSION QUEUE HISTORY",?79-$L(XMD0),XMD0,!,"At "_^XMB("NETNAME"),?70,"Page: "_XMF0("PG")
 W !! F I=1,2 W ?I-1*40+1,"  Domain           Q'd   Sent    Rec'd  "
 W ! Q
END I 'XMF0("PG") D HD:IOST'?1"C".E W !!,"<<<<   NOTHING TO REPORT  >>>>" G E
 I $Y+8'<IOSL,IOST?1"C-".E D ^DIR K DIRUT I $D(X) G E:X[U
 W !!!,"TOTAL Domains:  ",$J(+XMC0,9)
 W !,"TOTAL Queued:   ",$J(+$P(XMC0,U,4),9)
 W !,"TOTAL Sent:     ",$J(+$P(XMC0,U,2),9)
 W !,"TOTAL Received: ",$J(+$P(XMC0,U,3),9),!!
E K %,%H,%I,DIR,I,X,XMA,XMA0,XMB,XMB0,XMC0,XMD0,XME0,XMF0,XMG0,Y
 I $D(ZTSK),ZTSK W @IOF S ZTREQ="@" Q
 I '$D(ZTQUEUED) D ^%ZISC
 Q
CONT ;CONTINUOUS DISPLAY
 D XMS4 R !,X:10 Q:$T  G CONT
GO W !! G XMS4
