PSSMRCON ;BIR/RTR-Medication Routes conversion of IV flag ;02/19/00
 ;;1.0;PHARMACY DATA MANAGEMENT;**34**;9/30/97
 ;
EN ;
 W !!,"This option allows you to automatically populate the IV Flag field in the",!,"Medication Routes file for all Routes associated with IV flagged Orderable",!,"Items, and all Routes contained in Quick Codes in the IV Additive File.",!
 K DIR S DIR(0)="E",DIR("A")="Press Return to continue, '^' to exit" D ^DIR K DIR I 'Y G END
 N PMR,PSSLINE,PSSMROUT,PMRNAME,PSSA,PSSAN,PSSDT,PSSFL,PSSO,PSSOMR,PSSOMRN,PSSOID
 K ^TMP($J,"PSSMR") W !!,"Gathering data.." H 1
 S PSSMROUT=0
 F PSSA=0:0 S PSSA=$O(^PS(52.6,PSSA)) Q:'PSSA  F PSSAN=0:0 S PSSAN=$O(^PS(52.6,PSSA,1,PSSAN)) Q:'PSSAN  D
 .S PMR=$P($G(^PS(52.6,PSSA,1,PSSAN,0)),"^",8) I PMR,$D(^PS(51.2,PMR,0)) S PMRNAME=$P($G(^(0)),"^") I $G(PMRNAME)'="",'$D(^TMP($J,"PSSMR",PMRNAME,PMR)) D  I $G(PSSFL) S ^TMP($J,"PSSMR",PMRNAME,PMR)="" W "."
 ..S PSSFL=1,PSSDT=$P($G(^PS(52.6,PSSA,"I")),"^") I $G(PSSDT),$G(PSSDT)<DT S PSSFL=0
 ..I '$P($G(^PS(51.2,PMR,0)),"^",4) S PSSFL=0
 F PSSO=0:0 S PSSO=$O(^PS(50.7,"AIV",1,PSSO)) Q:'PSSO  D:$P($G(^PS(50.7,PSSO,0)),"^",3)
 .S PSSOMR=$P($G(^PS(50.7,PSSO,0)),"^",6) Q:'$G(PSSOMR)
 .S PSSOMRN=$P($G(^PS(51.2,PSSOMR,0)),"^")
 .Q:$G(PSSOMRN)=""!('$P($G(^PS(51.2,PSSOMR,0)),"^",4))
 .I '$D(^TMP($J,"PSSMR",PSSOMRN,PSSOMR)) D
 ..S PSSOID=$P($G(^PS(50.7,PSSO,0)),"^",4) D  I $G(PSSFL) S ^TMP($J,"PSSMR",PSSOMRN,PSSOMR)="" W "."
 ...S PSSFL=1 I $G(PSSOID),$G(PSSOID)<DT S PSSFL=0
 I '$D(^TMP($J,"PSSMR")) W !!,"There are no available Medication Routes in these files that can be used to",!,"populate the IV Flag in the Medication Routes file.",! K DIR S DIR(0)="E",DIR("A")="Press Return to continue" D ^DIR K DIR G END
 W ! K DIR  S DIR(0)="E",DIR("A")="Press Return to continue, '^' to exit" D ^DIR K DIR I 'Y W ! G END
 S $P(PSSLINE,"-",78)=""
 W @IOF W !?3,"Medication Routes to be flagged for IV use:",!,$G(PSSLINE),!
 S PSSAN="" F  S PSSAN=$O(^TMP($J,"PSSMR",PSSAN)) Q:PSSAN=""!($G(PSSMROUT))  F PSSA=0:0 S PSSA=$O(^TMP($J,"PSSMR",PSSAN,PSSA)) Q:'PSSA!($G(PSSMROUT))  D
 .I ($Y+4)>IOSL D HD
 .Q:$G(PSSMROUT)
 .W !?2,$P($G(^PS(51.2,PSSA,0)),"^") I $P($G(^(0)),"^",6) W ?48,"(Already flagged for IV Use)"
 I $G(PSSMROUT) G END
 W ! K DIR S DIR(0)="Y",DIR("?")="Answer Yes to automatically set the IV Flag for the Medication Routes listed",DIR("B")="Yes",DIR("A")="Mark these Medication Routes for IV Use" D ^DIR K DIR I '$G(Y)!($G(DIRUT)) W ! G END
 W !,"Flagging Med Routes.." H 1
 S PSSAN="" F  S PSSAN=$O(^TMP($J,"PSSMR",PSSAN)) Q:PSSAN=""  F PSSA=0:0 S PSSA=$O(^TMP($J,"PSSMR",PSSAN,PSSA)) Q:'PSSA  D
 .I $D(^PS(51.2,PSSA,0)) S DIE="^PS(51.2,",DA=PSSA,DR="6////1" D ^DIE W "."
 K DIE,DA,DR W !,"Finished!",!!
END ;
 K ^TMP($J,"PSSMR")
 Q
HD ;
 W ! K DIR S DIR(0)="E",DIR("A")="Press Return to continue, '^' to exit" D ^DIR K DIR I 'Y W ! S PSSMROUT=1 Q
 W @IOF W !?3,"Medication Routes to be flagged for IV use:",!,$G(PSSLINE),!
 Q
EDIT ;
 W ! K DIC S DIC(0)="QEAMZ",DIC="^PS(51.2," D ^DIC I Y<1!($D(DTOUT))!($D(DUOUT)) G EDITQ
 K DIE S DA=+Y,DIE="^PS(51.2,",DR="6" D ^DIE G:$D(Y)!($D(DTOUT)) EDITQ
 G EDIT
EDITQ W ! K DIC,DIE Q
