XURTL3 ;SFISC/KAK - DELETE RT RAWDATA ;8/17/2001  14:41 [ 04/02/2003   8:47 AM ]
 ;;7.3;TOOLKIT;**1001**;APR 1, 2003
 ;;7.3;TOOLKIT;**19**;September 6, 2001
 ;
EN ;
 N DIR,X,Y
 ;
 W !!,"This option will purge all of the System Response Time (RT) metrics in the",!
 W "RESPONSE TIME (#3.091), RT DATE_UCI,VOL (#3.092) and RT RAWDATA (#3.094)",!
 W "files.  The data in these files is irrecoverable after being purged.",!
 S DIR(0)="Y",DIR("A")="Purge ALL data in three files",DIR("B")="NO"
 D ^DIR
 Q:($D(DTOUT)!$D(DUOUT))
 I Y=0 W !!,"No data purged.",! Q
 K ^%ZRTL(1),^%ZRTL(2),^%ZRTL(4)
 S ^%ZRTL(1,0)="RESPONSE TIME^3.091P^^"
 S ^%ZRTL(2,0)="RT DATE_UCI,VOL^3.092^^"
 S ^%ZRTL(4,0)="RT RAWDATA^3.094D^0^0"
 W !!,"All of the data in the RT RAWDATA (#3.094) has been purged.",!
 Q
