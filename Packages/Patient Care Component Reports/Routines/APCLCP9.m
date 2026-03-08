APCLCP9 ; IHS/OHPRD/TMJ - APC visits by primary provider ; [ 02/06/02  9:29 AM ]
 ;;3.0;IHS PCC REPORTS;**11**;FEB 05, 1997
 ;
START ; 
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! K APCLSITE Q
 D INFORM
GETGROUP ;
 S DIC="^APCLACTG(",DIC("A")="Enter the Provider Discipline Group you wish to report on: ",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 W !,"Bye ... " G XIT
 S APCLACTG=+Y
 W !!,"You have selected the ",$P(Y,U,2)," discipline group.",!
 S DIC="^APCLACTG(",DA=+Y D EN^DIQ K DIC,DA
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Visit Date for Search" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G GETGROUP
 S APCLBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCLBD_":DT:EP",DIR("A")="Enter ending Visit Date for Search:  " S Y=APCLBD D DD^%DT S Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
 ;
S S APCLDICB=$P(^AUTTLOC(DUZ(2),0),U,5),APCLDIC("B")=$P(^AUTTSU(APCLDICB,0),U),DIC("A")="Which Service Unit: "_APCLDIC("B")_"//"
 S DIC="^AUTTSU(",DIC(0)="AEMQZ" W ! D ^DIC K DIC
 I X="" S (APCLSU,APCLSUF)=APCLDICB G ZIS
 G:Y=-1 XIT
 S (APCLSU,APCLSUF)=+Y
ZIS ;
 S XBRP="^APCLCP9P",XBRC="^APCLCP91",XBNS="APCL",XBRX="XIT^APCLCP9"
 D ^XBDBQUE
 Q
ERR W $C(7),$C(7),!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
XIT ;
 K APCL80S,APCLBD,APCLBDD,APCLBT,APCLCODE,APCLDT,APCLED,APCLEDD,APCLLENG,APCLPG,APCLQUIT,APCLSU,APCL1,APCL2,APCLAP,APCLCHN,APCLDA1,APCLDA2,APCLDISC,APCLFOUN,APCLHIGH,APCLICD,APCLIPTR,APCLLOW,APCLODAT,APCLSD
 K APCLSKIP,APCLSU,APCLVACT,APCLVDFN,APCLVLOC,APCLVREC,APCLVTM,APCLVTT,APCLSITE,APCLX,APCLY,APCLPRIM,APCLLOC,APCLCNT,APCLDIC,APCLDICB,APCLSUF,APCLGLOB,APCLPIEC,APCLACTG,APCLNUM,APCLRRTN,APCLJOB
 K X,X1,X2,IO("Q"),%,Y,DIRUT,POP,ZTSK,ZTQUEUED,T,S,M,TS,H
 Q
 ;
INFORM ;
 W:$D(IOF) @IOF
 W !,"Top Ten Primary Purposes for Services",!
 W !,"This report displays, by service unit, the top ten primary purposes for",!,"services by staff in the discipline group that you select.",!
 W !
 Q
 ;
 ;
