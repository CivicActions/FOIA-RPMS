APCLCP3 ; IHS/OHPRD/TMJ - activity report ; [ 02/06/02  9:23 AM ]
 ;;3.0;IHS PCC REPORTS;**11**;FEB 05, 1997
 ;
START ; 
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! Q
 S APCLSITE=DUZ(2)
 I APCLSORV="APCLVLOC" S APCLSORT="LOCATION OF ENCOUNTER"
 I APCLSORV="APCLCODE" S APCLSORT="PRIMARY DX"
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
ZIS ;
 S XBRP="^APCLCP3P",XBRC="^APCLCP31",XBRX="XIT^APCLCP3",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
ERR W $C(7),$C(7),!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
XIT ;
 K APCL80S,APCLBD,APCLBDD,APCLBT,APCLCODE,APCLDT,APCLED,APCLEDD,APCLLENG,APCLPG,APCLQUIT,APCLSU,APCL1,APCL2,APCLAP,APCLCHN,APCLDA1,APCLDA2,APCLDISC,APCLFOUN,APCLHIGH,APCLICD,APCLIPTR,APCLLOW,APCLODAT,APCLSD,APCLG
 K APCLSKIP,APCLSU,APCLVACT,APCLVDFN,APCLVLOC,APCLVREC,APCLVTM,APCLVTT,APCLSITE,APCLX,APCLY,APCLPRIM,APCLLOC,APCLPRIM,APCLSORV,APCLSORT,APCLCODE,APCLNSP,APCLSECV,APCLSECS,APCLVAL,APCLVALP,APCLSUB,APCLZ,APCLACTG
 K APCLJOB,APCLPIEC,APCLRRTN,APCLGLOB
 K X,X1,X2,IO("Q"),%,Y,DIRUT,POP,ZTSK,ZTQUEUED,H
 Q
 ;
INFORM ;
 W:$D(IOF) @IOF
 W !,"Time and Patient Services by ",APCLSECS," for a Group of Provider",!,"Disciplines that you select.",!
 W !,"This report displays, by ",APCLSORT,", the number of patient contacts",!,"total activity time and total travel time for each provider with",!,"a discipline in the provider discipline group that you select."
 W !
 Q
 ;
 ;
