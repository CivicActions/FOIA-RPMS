XURTLC ;SFISC/HVB - COPY RAW RT DATA to FM file ;12/22/94  09:48 [ 04/02/2003   8:47 AM ]
 ;;7.3;TOOLKIT;**1001**;APR 1, 2003
 ;;7.3;TOOLKIT;**19**;September 6, 2001
 ;
 N DIR,X,Y,ZTDESC,ZTIO,ZTRTN,ZTSK
 ;
 W !!,"This option queues a task to copy the Response Time (RT) data that is stored",!
 W "in the ^%ZRTL(3 global node to the RT RAWDATA (#3.094) file.  When significant",!
 W "amounts of RT data are involved, this option will take a long time for",!
 W "completion and can consume a lot of disk storage.  It will TRIPLE the size",!
 W "of the ^%ZRTL global in MGR where the Response Time (RT) raw data and files",!
 W "are stored.",!
 ;
 S DIR(0)="Y",DIR("A")="Do you wish to proceed",DIR("B")="NO"
 D ^DIR
 Q:'Y!($D(DTOUT)!$D(DUOUT))
 ;
 S ZTIO="",ZTDESC="COPY %ZRTL DATA TO RT RAWDATA FILE",ZTRTN="DQ^XURTLC"
 D ^%ZTLOAD
 W:$D(ZTSK) !!,"Option queued successfully as Task #",ZTSK,".",!
 Q
 ;
DQ ;
 N DA,DA0,D0,EDT,ENDATE,ENDTIM,RTN,VOL
 ;
 S (ENDATE,ENDTIM,RTN,VOL)="",D0=$S($D(^%ZRTL(4,0)):^(0),1:""),(DA,DA0)=+$P(D0,U,3)
 F  S VOL=$O(^%ZRTL(3,VOL)) Q:VOL=""  D CPY
 S $P(^%ZRTL(4,0),U,3,4)=DA_"^"_(DA-DA0+$P(D0,U,4)),DA=DA0
 F  S DA=$O(^%ZRTL(4,DA)) Q:'DA  S EDT=$P(^(DA,0),U),^%ZRTL(4,"B",EDT,DA)=""
 Q
 ;
CPY F  S ENDATE=$O(^%ZRTL(3,VOL,ENDATE)) Q:ENDATE=""  D
 .F  S RTN=$O(^%ZRTL(3,VOL,ENDATE,RTN)) Q:RTN=""  D
 ..F  S ENDTIM=$O(^%ZRTL(3,VOL,ENDATE,RTN,ENDTIM)) Q:ENDTIM=""  D
 ...S EDT=ENDATE_","_ENDTIM
 ...I '$D(^%ZRTL(4,"B",EDT)) S DA=DA+1,^%ZRTL(4,DA,0)=EDT_U_VOL_U_RTN_U_^%ZRTL(3,VOL,ENDATE,RTN,ENDTIM)
 Q
