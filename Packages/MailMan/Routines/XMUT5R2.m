XMUT5R2 ;(WASH ISC)/CAP - Daily Reports ;4/12/93  17:38
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;;Jun 02, 1994
0 N %,%H,%I D NOW^%DTC S X1=X,X2=-1 D C^%DTC
 S XMA=$S($D(ZTQUEUED):X,1:$$DATE("RUN",$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3))) Q:XMA=""
 S XMB=XMA_".2359"
 S Y=DT D DD^%DT S XMD=Y
 Q
 ;Call FileMan to produce report
GO S XMC=$P(^XMB("NETNAME"),".")_" "_L
 I '$D(ZTQUEUED) W !!,"Calling FileMan template ..."
 ;
 ;XMA=Start Date FM format
 ;XMAH=Start Date $H format
 ;XMB=End Date FM format
 ;XMBH=End Date $H format
 S XMV=^%ZOSF("PROD")
 S:'$D(BY) BY=.01 S FR=XMA,TO=XMB,DIC="^XMBX(4.2998,"
 S:$D(ZTQUEUED) IOP=ZTIO D EN1^DIP
 ;
Q K BY,DIC,DIS,FLDS,FROM,TO,XMA,XMB,XMAH,XMBH,X,Y,Z,%ZIS,ZTRTN,ZTSAVE,ZTDTH
 I '$D(ZTQUEUED) K ZTSK
 Q
 ;
 ;Calculate Date
DATE(X,Z) ;Ask Start and End Dates
 N DUOUT,DTOUT,XMA,DIR,Y S DIR(0)="D^::XEP",DIR("A")=X_" Date",DIR("B")=Z
D D ^DIR K DIRUT I $D(DUOUT)!$D(DTOUT) Q ""
 S XMA=Y I XMA'?7N.E D ^%DT X XMA=Y
 D NOW^%DTC I %-XMA<0 W !,*7," No Future Dates !!!" G D
 Q XMA
 ;
 ;Active Users verses Deliveries Report
ACT D 0 Q:XMA=""  K BY
 S FLDS="[XMMGR-BKFILER-ACTIVE_USERS/DEL]",L="Active Users/Deliveries Report"
 G GO
 ;Deliveries by group
GROUP D 0 Q:XMA=""  K BY
 S FLDS="[XMMGR-BKFILER-DEL_BY_GROUP]",L="Deliveries by Group Report"
 G GO
 ;Queue Length
QUEUE D 0 Q:XMA=""  K BY
 S FLDS="[XMMGR-BKFILER-LENGTH_OF_QUEUES]",L="Length of Delivery Queues Report"
 G GO
 ;Queue Wait
WAIT D 0 Q:XMA=""  K BY
 S FLDS="[XMMGR-BKFILER-QUEUE-WAIT]",L="Active Users/Deliveries Report"
 G GO
 ;Statistics / Active Users, Deliveries, Queue Wait, Response Time
STAT D 0 Q:XMA=""  K BY
 S FLDS="[XMMGR-BKFILER-STATS-PLUS]",L="Statistics Report"
 G GO
 ;Statistics for download to graphics package
TAB D 0 Q:XMA=""  S BY="@.01"
 S FLDS="[XMMGR-BKFILER-STATS/TABBED]",L=""
 G GO
 ;Ask parameters
ASK N DIRUT F X=1:1:5 S A=$$ASS(X) Q:$D(DIRUT)  S $P(^XMB(1,1,7),",",X)=A
 Q
ASS(I) N DIR,X,Y,Z
 S X=$P("Active Users,Lines Displayed,Message & Response Deliveries,Queue Lengths,Response Time",",",I)
 S DIR(0)="N^.1:9999999999",DIR("A")="Enter normalized "_X,DIR("B")=$P($G(^XMB(1,1,7)),",",I)
 D ^DIR
 Q X
