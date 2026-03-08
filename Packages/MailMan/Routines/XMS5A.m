XMS5A ;(WASH ISC)/CAP/AML/RJ-Query into message queues ;01/28/98  11:17
 ;;7.1;MailMan;**55,50**;Jun 02, 1994
 ; Entry points used by MailMan options (not covered by DBIA):
 ; ^XMS5A    XMQDISP
 D ^%ZIS Q:POP  U IO
 D NOW^%DTC K %I S A=$E(%,6,7)_" "_$P("Jan^Feb^Mar^Apr^May^Jun^Jul^Aug^Sep^Oct^Nov^Dec",U,$E(%,4,5))_" "_$E(%,2,3)
 I %\1'=% S %=$P(%,".",2)_"0000",A=A_" "_$E(%,1,2)_":"_$E(%,3,4)
 S XMD0=A K DIR S (XMF0,XMF0("PG"),XMC0,XME0)=0,DIR(0)="E"
Q S XMF0=$O(^DIC(4.2,"B",XMF0)) I XMF0="" G END
 S XMG0=$O(^DIC(4.2,"B",XMF0,0)) I '$D(^XMBS(4.2999,XMG0)) G Q
 S XMB0=$S($D(^XMBS(4.2999,XMG0,3))#2:^(3),1:""),XMB=$E(XMF0,1,16)
 S XMA=0 D M G:XMA<1 Q:XMB0=""
 I +XMB0=0 S XMA0="" G W
 S Y=$$HTE^XLFDT($P(XMB0,U,1),1)
 S Y=$P(Y,",",1)_" "_$E($P(Y,"@",2),1,5)
 S XMA0=Y_"^"_$P(XMB0,"^",2,6)
W ;write results
 I $Y+5>IOSL!'XMF0("PG") S X="" D:'$D(ZTQUEUED)&XMF0("PG") ^DIR:IOST?1"C-".E K DIRUT D HD G END:X=U
 S XMC0=XMC0+1 I $P(XMA0,U,4)<0 S $P(XMA0,U,4)=0
 W !,XMB,?18,$J(XMA,6),?25,$P(XMA0,"^",1),?40,$P(XMA0,"^",2),?48,$P(XMA0,"^",3),?54,$J($P(XMA0,"^",4),4),?59,$J($P(XMA0,"^",5)\1,4),?64,$P(XMA0,"^",6)
 G Q
M ;number in queue
 S XMA=$$BMSGCT^XMXUTIL(.5,XMG0+1000)
 Q
HD S XMF0("PG")=XMF0("PG")+1 W @IOF,!,"TRANSMISSION QUEUE STATUS REPORT",?79-$L(XMD0),XMD0,!,"At "_^XMB("NETNAME"),?70,"Page: "_XMF0("PG"),!
 W !,"Domain",?18,"Queued",?25,"Updated",?40,"Msg #   Line  Errors  Rate   IO",!
 Q
END I $D(XMC0),XMC0<1 D HD:IOST'?1"C".E&'XMF0("PG") W !,"No messages queued or in active transmission.",!
 K %,%I,DIR,I,X,XMC0,XMB,XME0,XMB0,XMA0,XMA,XMG0,XMF0,Y
 D ^%ZISC
 Q
CONT ;CONTINUOUS DISPLAY
 D XMS5A R !,X:10 Q:$T  G CONT
GO W !! G XMS5A
