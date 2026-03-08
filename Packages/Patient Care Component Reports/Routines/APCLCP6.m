APCLCP6 ; IHS/OHPRD/TMJ - activity report print ; [ 02/06/02  9:23 AM ]
 ;;3.0;IHS PCC REPORTS;**11**;FEB 05, 1997
 ;
START ; 
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! Q
 S APCLSITE=DUZ(2)
 I APCLSORV="APCLAP" S APCLSORT="PROVIDER",APCLNSP="APCLCP6"
 I APCLSORV="APCLSU" S APCLSORT="SERVICE UNIT",APCLNSP="APCLCP7"
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
 S XBRP="^APCLCP6P",XBRC="^APCLCP61",XBRX="XIT^APCLCP6",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
ERR W $C(7),$C(7),!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
XIT ;
 I '$D(ZTQUEUED) S IOP="HOME" D ^%ZIS U IO(0)
 K APCL80S,APCLBDD,APCLBT,APCLDT,APCLED,APCLEDD,APCLLENG,APCLLOC,APCLPG,APCLQUIT,APCL1,APCL2,APCLAP,APCLDISC,APCLODAT,APCLSD,APCLSKIP,APCLVACT,APCLVDFN,APCLVLOC,APCLVREC,APCLVTM,APCLVTT,APCLX,APCLY,APCLPRIM,APCLSITE,APCLBD
 K APCLACTG,APCLJOB
 K X,X1,X2,IO("Q"),%,Y,DIRUT,POP,ZTSK,ZTQUEUED,T,S,M,TS,H,DIR,DUOUT,DTOUT,DUOUT,DLOUT,APCLVAL,APCLVALP,APCLNSP,APCLSORT,APCLSORV,APCLAP,APCLSU
 Q
 ;
INFORM ;
 W:$D(IOF) @IOF
 W !,"Number of Individuals Seen by ",APCLSORT," for staff members in the discipline",!,"group that you select.",!
 W !,"This report displays, by location of encounter, the number of individuals",!,"seen by each provider with a discipline in the discipline group that you select."
 W !
 Q
 ;
 ;
