XUCMPA ;SFISC/JC-Compute new reference ranges ;05/17/94  16:23 [ 04/02/2003   8:47 AM ]
 ;;7.3;TOOLKIT;**1001**;APR 1, 2003
 ;;7.3;TOOLKIT;**25**;Aug 01, 1997
EN ;Interactive update
 N XUCMPARM,DTRNG,FMBEG,FMEND,BEGDT,ENDDT,D,IEN,XUCMREF,SUMDEV,SUM,SITIEN,SIT,SD,RES,NODE,NDHW,METNM,MET,MEAN,J,IEN,I,END,DSKHW,DSK,DEV,D,C,A
 S XUCMPARM=$$PARM^XUCMVPU
 S DTRNG=$$DTRNG^XUCMVPU Q:'+DTRNG!('$P(DTRNG,U,2))
 S FMBEG=$P(DTRNG,U),FMEND=$P(DTRNG,U,2),BEGDT=$P(DTRNG,U,3),ENDDT=$P(DTRNG,U,4)
 S SIT=$$SIT
 W !,"I will print your current metric references and the new"
 W !,"ranges. You will be able to exit this routine if the new ranges"
 W !,"are unsatisfactory."
 W !
 S %ZIS="Q",%ZIS("A")="Print current references to which DEVICE? "
 S DIC=8986.4,BY="[XUCM PRINT FILE]",FLDS="[XUCM PRINT FILE]",DHD=">>Current entries in CM METRICS FILE<<",DQTIME="NOW" D EN1^DIP
 G:POP EXIT D ^%ZISC
 W !!,"Computing new references. One Moment..."
 D LOOP^XUCMPA1(FMBEG,FMEND)
 D COMP^XUCMPA1
 S %ZIS="MQ",%ZIS("A")="Print NEW references on which DEVICE? " D ^%ZIS
 I $D(IO("Q")) D
 . S ZTDESC="New hardware reference ranges",ZTRTN="OUT^XUCMPA1",ZTSAVE("*")=""
 . S ZTDTH=$H D ^%ZTLOAD,HOME^%ZIS
 I '$D(ZTQUEUED) D OUT^XUCMPA1
 D CHK I $D(Y) W !,"No updating occurred." D EXIT Q
 W !,"OK to file this data" S %=1 D YN^DICN I %'=1 W !,"No updating occurred." D EXIT Q
 W !,"Updating NOW. One moment..."
 D FIL^XUCMPA1
 W !,"...DONE!"
 D EXIT
 Q
SIT() ;get ien of local site in 8986.6
 S X=$P(XUCMPARM,U,2),DIC=8986.6,DIC(0)="MQZ" D ^DIC Q:+Y=-1 ""
 Q +Y
CHK ;
 K Y I $P(XUCMPARM,U,12) D
 . W !!,"Your site parameters indicate that your new data will be overwritten"
 . W !,"the next time the Morning Summary is generated."
 . W !,"To prevent this, you may delete the entry in the following field."
 . S DIC=8986.095,DIC(0)="MQZ",X=$P(XUCMPARM,U,2) D ^DIC S IEN=+Y
 . K DIC,DA S DA=IEN,DIE="^XUCM(8986.095,",DR="[XUCM EDIT SITE REFERENCE]" D ^DIE K DIE,DA,DR
 Q
EN2 ;Non-interactive local update
 N XUCMPARM,DTRNG,FMBEG,FMEND,BEGDT,ENDDT,D,IEN,XUCMREF,SUMDEV,SUM,SITIEN,SIT,SD,RES,NODE,NDHW,METNM,MET,MEAN,J,IEN,I,END,DSKHW,DSK,DEV,D,C,A
 S XUCMPARM=$$PARM^XUCMVPU,XUCMREF=$P(XUCMPARM,U,12) S SIT=$$SIT
 Q:'XUCMREF!('SIT)
 S FMBEG=$O(^XUCM(8986.6,SIT,1,"B","")),FMEND=DT-1
 I XUCMREF<999 S FMBEG="T-"_(XUCMREF+1)
 D LOOP^XUCMPA1(FMBEG,FMEND),COMP^XUCMPA1,FIL^XUCMPA1
 D EXIT
 Q
EN3 ;Ref's for VA (all sites/all data)
 N XUCMPARM,DTRNG,FMBEG,FMEND,BEGDT,ENDDT,D,IEN,XUCMREF,SUMDEV,SUM,SITIEN,SIT,SD,RES,NODE,NDHW,METNM,MET,MEAN,J,IEN,I,END,DSKHW,DSK,DEV,D,C,A
 S SIT=0 F  S SIT=$O(^XUCM(8986.6,SIT)) Q:SIT<1  D
 . S FMBEG=0,FMEND=DT-1 D LOOP^XUCMPA1(FMBEG,FMEND)
 D COMP^XUCMPA1
 S %ZIS="MQ",%ZIS("A")="Print NEW references on which DEVICE? " D ^%ZIS
 I $D(IO("Q")) D
 . S ZTDESC="New hardware reference ranges",ZTRTN="OUT^XUCMPA1",ZTSAVE("*")=""
 . S ZTDTH=$H D ^%ZTLOAD,HOME^%ZIS
 I '$D(ZTQUEUED) D OUT^XUCMPA1
 D EXIT
 Q
EN4 ;Performance Assessment for yesterday
 I '$D(^TMP($J,"ND")) D EN^XUCMNIT3
EXIT ;
 K A,^TMP("XUCMSYS",$J),^TMP("XUCMDSK",$J)
 Q
