PSSMRRPT ;BIR/RTR-Medication Routes file report ;02/15/00
 ;;1.0;PHARMACY DATA MANAGEMENT;**34**;9/30/97
 ;
 W !!,"This report displays the Medication Routes, along with the abbreviation, the",!,"package use (all packages or National Drug File only), and if the route is",!,"flagged for IV Use or not, which helps determine how Inpatient Med orders"
 W !,"entered through CPRS will be finished in the Pharmacy package.",!
 W !,"Med Routes are screened out during CPRS and Pharmacy ordering processes if they",!,"are marked as NDF ONLY, or if they are null.",!
 K IOP,%ZIS,POP S %ZIS="QM" D ^%ZIS I $G(POP) W !!,"Nothing queued to print.",!! Q
 I $D(IO("Q")) S ZTRTN="EN^PSSMRRPT",ZTDESC="Medication Routes report" D ^%ZTLOAD K %ZIS W !,"Report queued to print." Q
EN ;
 U IO
 S PSSOUT=0,PSSDV=$S($E(IOST)="C":"C",1:"P"),PSSCT=1
 K PSSLINE,PSSM,PSSMR S $P(PSSLINE,"-",79)=""
 D MEDH
 S PSSM="" F  S PSSM=$O(^PS(51.2,"B",PSSM)) Q:PSSM=""!($G(PSSOUT))  F PSSMR=0:0 S PSSMR=$O(^PS(51.2,"B",PSSM,PSSMR)) Q:'PSSMR!($G(PSSOUT))  D
 .I ($Y+5)>IOSL D MEDH Q:$G(PSSOUT)
 .S PSSNODE=$G(^PS(51.2,PSSMR,0))
 .W !,$P(PSSNODE,"^"),?47,$P(PSSNODE,"^",3),?64,$S($P(PSSNODE,"^",4)=0:"NDF ONLY",$P(PSSNODE,"^",4)=1:"ALL",1:""),?75,$S($P(PSSNODE,"^",6):"Y",1:"")
END ;
 I '$G(PSSOUT),$G(PSSDV)="C" W !!,"End of Report." K DIR S DIR(0)="E",DIR("A")="Press Return to continue" D ^DIR K DIR
 I $G(PSSDV)="C" W !
 E  W @IOF
 W ! K PSSLINE,PSSDV,PSSOUT,PSSCT,PSSM,PSSMR,PSSNODE D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@"
 Q
MEDH ;
 I $G(PSSDV)="C",$G(PSSCT)'=1 W ! K DIR S DIR(0)="E",DIR("A")="Press Return to continue, '^' to exit" D ^DIR K DIR I 'Y S PSSOUT=1 Q
 W @IOF W !?5,"MEDICATION ROUTES LIST"_$S($G(PSSCT)=1:"",1:"  (cont.)"),?68,"PAGE: "_$G(PSSCT) S PSSCT=PSSCT+1
 W !!,"NAME",?47,"ABBREVIATION",?64,"USAGE",?75,"IV",!,PSSLINE,!
 Q
