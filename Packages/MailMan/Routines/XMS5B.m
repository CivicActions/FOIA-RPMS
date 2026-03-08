XMS5B ;(WASH ISC)/CAP/RM/AML-DISPLAY/TRANSMIT QUEUES ;1/15/94  12:51
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;**13,23**;Jun 02, 1994
 ;; ACC/IHS/OHPRD - adapted from VA's XMS5.
 ;;   This option provides a queueable option to insure that
 ;;   all sites on poll list are contacted via background tasks
 ;;   (as contrasted with XMAUTOPOLL, which does one at a time)
 ;;   Note that contact will be attempted REGARDLESS of whether
 ;;   any messages are queued for the site.
 ;
TSKPOLR ;
 ;Process domains on poll list
 N DIR,DIRUT,DTOUT,DUOUT,X,Y
 N XMS5D
 K ^TMP($J,"ZTMKZ")
 S XMS5D=0 F  S XMS5D=$O(^DIC(4.2,"AC","P",XMS5D)) Q:'XMS5D  D CHKDOM
 I $O(^TMP($J,"ZTMKZ",""))="" W:'$D(ZTQUEUED) !!!,"<<<<  NO domains lack tasks !!! >>>",!!!
 E  D ASKXMIT D:Y TASKXMIT
 K ^TMP($J,"ZTMKZ")
 S:$D(ZTQUEUED) ZTREQ="@"
 Q
 ;
CHKDOM ;
 ;Process a single candidate domain
 N %,XMS5T,XMS5S
 W:'$D(ZTQUEUED) "."
 S XMS5T=$P($G(^XMBS(4.2999,XMS5D,0)),U,2) I XMS5T S %=$$CHK^XMS5(XMS5T,XMS5D)
 S XMS5S=$P(^DIC(4.2,XMS5D,0),U)
 I $G(%) W:'$D(ZTQUEUED) !,"Domain ",XMS5S," is already tasked [",XMS5T,"].",! Q
 ;
 ;The next line is commented out because leaving send flag in results in
 ; excess transcripts, but taking it out prevented contacting sites
 ; on poll list
 ;I $P(^DIC(4.2,XMS5D,0),U,2)'["S" W:'$D(ZTQUEUED) !,"Domain ",XMS5S," has no send flag.",! Q
 ;
 S ^TMP($J,"ZTMKZ",XMS5S)=XMS5D
 Q
 ;
ASKXMIT ;
 ;Ask it eligible queues should be transmitted
 N ZTD,ZTI
 I $D(ZTQUEUED) S Y=1 Q
 W !!,"These domains lack tasks:"
 S ZTD="" F ZTI=2:1 S ZTD=$O(^TMP($J,"ZTMKZ",ZTD)) Q:ZTD=""  S X=^(ZTD) W !?5,ZTD I ZTI#20=0 S DIR(0)="E" D ^DIR K DIR
 S DIR(0)="YO",DIR("A")="Requeue the missing tasks",DIR("B")="NO",DIR("?")="Answer YES to transmit these domains." D ^DIR K DIR I 'Y W !!,"Tasks not requeued."
 Q
 ;
TASKXMIT ;
 ;Task off transmission jobs
 N XMS5,XMSITE,XMINST,XMSCR
 I '$D(ZTQUEUED) W !
 S XMDUZ=$S($D(XMDUZ)[0:.5,'XMDUZ:.5,1:XMDUZ)
 S XMS5="",XMS5("RETURN_TASK#")=1 F  S XMS5=$O(^TMP($J,"ZTMKZ",XMS5)) Q:XMS5=""  D TASK1
 W:'$D(ZTQUEUED) !,"Done !"
 Q
 ;
TASK1 ;
 S XMSITE=XMS5,(XMINST,XMSCR)=^TMP($J,"ZTMKZ",XMS5)
 K ZTSK D ENQ^XMS1
 I '$D(ZTQUEUED) W !,"Task "_ZTSK_" queued for domain "_XMS5
 Q
