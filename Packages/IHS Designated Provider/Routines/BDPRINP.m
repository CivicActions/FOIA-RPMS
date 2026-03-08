BDPRINP ;IHS/CMI/LAB - listing of patients with no desg prov
 ;;2.0;IHS PCC SUITE;**27**;MAY 14, 2009;Build 64
 ;
 ;
INFORM ;
 W !!,"This option will remove patients whose health record has been"
 W !,"inactivated through patient registration from any provider's panel."
 W !,"A list of patients and the panel they were removed from will be"
 W !,"provided."
 W !!
LOC1 ;enter location
 W !!,"Enter the Chart Facility to use when scanning for inactive HRNs."
 K DIC
 S DIC("A")="Which Chart Facility: ",DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("B")=$P(^DIC(4,DUZ(2),0),U,1) D ^DIC K DIC,DA G:Y<0 XIT
 S BDPLOC=+Y
PROV ;
 W !!,"Please indicate the provider whose panel these patients will ","be removed from."
 K DIC,DIRUT
 S BDPPROV=""
 S DIC="^VA(200,",DIC(0)="AEMQ",DIC("A")="Which Provider: " D ^DIC K DIC,DA S:$D(DUOUT) DIRUT=1
 I Y=-1 G LOC1
 I $D(DIRUT) G LOC1
 S BDPPROV=+Y
 ;COUNT
 W !!,"Hang on while I count them up..."
 S (P,C)=0
 K T
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D
 .I '$D(^AUPNPAT(DFN,41,BDPLOC,0)) Q  ;no hrn at this facility
 .I $P(^AUPNPAT(DFN,41,BDPLOC,0),U,3)="" Q  ;not inactive, no inactive date
 .NEW BDPX,BDPY,BDPZ,BDPCIEN
 .S BDPCIEN=0 F  S BDPCIEN=$O(^BDPRECN("AA",DFN,BDPCIEN)) Q:BDPCIEN'=+BDPCIEN  D
 ..S BDPRIEN=$O(^BDPRECN("AA",DFN,BDPCIEN,0))
 ..Q:'BDPRIEN
 ..Q:$P(^BDPRECN(BDPRIEN,0),U,3)=""  ;already deleted
 ..Q:$P(^BDPRECN(BDPRIEN,0),U,3)'=BDPPROV
 ..S C=C+1
 ..S P=$P(^BDPRECN(BDPRIEN,0),U,3)
 I 'C W !!,"There are no inactive patients currently on a",!,$P(^VA(200,BDPPROV,0),U,1)," panel.",!!
 I C W !!,C," patients will be removed from ",!,$P(^VA(200,P,0),U,1)," panels.",!!
 ;S X="" F  S X=$O(T(X)) Q:X=""  W !?5,X,?36,"# patients: ",T(X)
 W !
CONT ;
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I 'Y D XIT Q
ZIS ;
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 S BDPBROW=Y
 I $G(Y)="B" D BROWSE,XIT Q
 W !! S XBRP="PRINT^BDPRINP",XBRC="PROC^BDPRINP",XBNS="BDP",XBRX="XIT^BDPRINP"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^BDPRINP"")"
 S XBNS="BDP",XBRC="PROC^BDPRINP",XBRX="XIT^BDPRINP",XBIOP=0 D ^XBDBQUE
 Q
 ;
PAUSE ; 
 S DIR(0)="E",DIR("A")="Press return to continue or '^' to quit" D ^DIR K DIR,DA
 S:$D(DIRUT) BDPQUIT=1
 W:$D(IOF) @IOF
 Q
XIT ;
 D EN^XBVK("BDP")
 K L,M,S,T,X,X1,X2,Y,Z,B
 D KILL^AUPNPAT
 D ^XBFMK
 Q
PROC ;
 S BDPJOB=$J,BDPBTH=$H,BDPTOT=0,DFN=0,BDPBT=$H
 D XTMP^APCLOSUT("BDPRINP","BDP - REMOVE INAC PTS FROM PANEL")
 ;loop through either the template or the patient file and apply screens
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D GETPROV
 Q
GETPROV ;
 I '$D(^AUPNPAT(DFN,41,BDPLOC,0)) Q  ;no hrn at this facility
 I $P(^AUPNPAT(DFN,41,BDPLOC,0),U,3)="" Q  ;not inactive, no inactive date
 NEW BDPX,BDPY,BDPZ,BDPCIEN
 S BDPCIEN=0 F  S BDPCIEN=$O(^BDPRECN("AA",DFN,BDPCIEN)) Q:BDPCIEN'=+BDPCIEN  D
 .S BDPRIEN=$O(^BDPRECN("AA",DFN,BDPCIEN,0))
 .Q:'BDPRIEN
 .Q:$P(^BDPRECN(BDPRIEN,0),U,3)=""  ;already deleted
 .Q:$P(^BDPRECN(BDPRIEN,0),U,3)'=BDPPROV
 .D DEL
 .Q
 Q
DEL ;
 NEW DA,DIE,DR,BDPLINKI  ;P19
 S BDPLINKI=1
 S ^XTMP("BDPRINP",BDPJOB,BDPBTH,DFN,BDPRIEN)=$$VAL^XBDIQ1(90360.1,BDPRIEN,.01)_U_$$VAL^XBDIQ1(90360.1,BDPRIEN,.03)
 S BDPPROV=$P(^BDPRECN(BDPRIEN,0),U,3)
 ;NEW DA,DIE,DR
 S DA=BDPRIEN,DIE="^BDPRECN(",DR=".03///@;.04////"_DUZ_";.05////"_DT D ^DIE K DIE,DA,DR
 ;FIND THE MULTIPLE AND SET .05 EQUAL TO DT, .02 AND .03
 NEW X,Y
 S X=0 F  S X=$O(^BDPRECN(BDPRIEN,1,X)) Q:X'=+X  I $P(^BDPRECN(BDPRIEN,1,X,0),U,1)=BDPPROV S Y=X
 I Y,$P(^BDPRECN(BDPRIEN,1,Y,0),U,5)="" S DIE="^BDPRECN("_BDPRIEN_",1,",DA(1)=BDPRIEN,DA=Y,DR=".02////"_DUZ_";.03////"_DT_";.05////"_DT D ^DIE K DIE,DR,DA,DINUM
 Q
 ;
PRINT ;
 S BDP80D="-------------------------------------------------------------------------------"
 S BDPPG=0
 I '$D(^XTMP("BDPRINP",BDPJOB,BDPBTH)) D HEAD W !!,"NO PATIENTS TO REPORT" G DONE
 D HEAD
 S DFN=0 F  S DFN=$O(^XTMP("BDPRINP",BDPJOB,BDPBTH,DFN)) Q:DFN=""!($D(BDPQ))  D
 .S BDPRIEN=0 F  S BDPRIEN=$O(^XTMP("BDPRINP",BDPJOB,BDPBTH,DFN,BDPRIEN)) Q:BDPRIEN=""!($D(BDPQ))  D DFN
DONE D DONE^APCLOSUT
 K ^XTMP("BDPRINP",BDPJOB,BDPBTH),BDPJOB,BDPBTH
 Q
DFN ;
 I $Y>(IOSL-3) D HEAD Q:$D(BDPQ)
 W $E($P(^DPT(DFN,0),U),1,20),?22,$$HRN^AUPNPAT(DFN,DUZ(2)),?30,$E($P(^XTMP("BDPRINP",BDPJOB,BDPBTH,DFN,BDPRIEN),U,1),1,15),?47,$E($P(^XTMP("BDPRINP",BDPJOB,BDPBTH,DFN,BDPRIEN),U,2),1,20),?70,$$LVST(DFN),!
 Q
HEAD I 'BDPPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDPQ="" Q
HEAD1 ;
 I BDPPG W:$D(IOF) @IOF
 S BDPPG=BDPPG+1
 W $P(^VA(200,DUZ,0),U,2),?30,$$FMTE^XLFDT($$NOW^XLFDT),?70,"PAGE  "_BDPPG,!
 W ?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),!
 W $$CTR("INACTIVE PATIENTS REMOVED FROM PROVIDER PANELS",80),!
 W "NAME",?22,"HRN",?30,"CATEGORY",?47,"PROVIDER",!,BDP80D,!
 Q
LVST(P) ;ENTRY POINT from [BDP PRIM PROV LISTING print template
 NEW BDPAST,BDPVDFN
 S BDPAST=$O(^AUPNVSIT("AA",DFN,""))
 I BDPAST="" Q ""
 S BDPVDFN=$O(^AUPNVSIT("AA",DFN,BDPAST,""))
 Q $$DATE($$VD^APCLV(BDPVDFN))
 ;
DATE(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
