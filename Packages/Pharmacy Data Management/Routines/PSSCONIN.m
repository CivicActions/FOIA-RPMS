PSSCONIN ;BIR/RTR-Instructions conversion routine ;03/02/00
 ;;1.0;PHARMACY DATA MANAGEMENT;**34**;9/30/97
REP ;report of instructions
 W !!,"This report shows the Instructions associated with each Dosage Form. Use the",!,"Convert Instructions to Nouns option to move all non-numeric Instructions into",!,"the Noun field of the Dosage Form file.",!
 K IOP,%ZIS,POP S %ZIS="QM" D ^%ZIS I $G(POP) W !!,"Nothing queued to print.",!! Q
 I $D(IO("Q")) S ZTRTN="EN^PSSCONIN",ZTDESC="Dose Form Instructions report" D ^%ZTLOAD K %ZIS W !,"Report queued to print." Q
EN ;
 U IO
 N PSSINC,PSSI,PSSIRI,PSSNFLAG
 S PSSOUT=0,PSSDV=$S($E(IOST)="C":"C",1:"P"),PSSCT=1
 K PSSLINE S $P(PSSLINE,"-",79)=""
 D INHD
 S PSSI="" F  S PSSI=$O(^PS(50.606,"B",PSSI)) Q:PSSI=""!($G(PSSOUT))  F PSSIR=0:0 S PSSIR=$O(^PS(50.606,"B",PSSI,PSSIR)) Q:'PSSIR!($G(PSSOUT))  D
 .I ($Y+5)>IOSL D INHD Q:$G(PSSOUT)
 .W !,$P($G(^PS(50.606,PSSIR,0)),"^")
 .S PSSINC=0 F PSSIRI=0:0 S PSSIRI=$O(^PS(50.606,PSSIR,"INS",PSSIRI)) Q:'PSSIRI!($G(PSSOUT))  S PSSX=$P($G(^PS(50.606,PSSIR,"INS",PSSIRI,0)),"^") I PSSX'="" D
 ..I $G(PSSINC) W !
 ..S PSSINC=PSSINC+1
 ..I ($Y+5)>IOSL D INHD Q:$G(PSSOUT)
 ..S PSSNFLAG=0 I PSSX?.N!(PSSX?.N1".".N) S PSSNFLAG=1
 ..W ?32,PSSX I 'PSSNFLAG W ?65,"Y"
END ;
 I '$G(PSSOUT),$G(PSSDV)="C" W !!,"End of Report." K DIR S DIR(0)="E",DIR("A")="Press Return to continue" D ^DIR K DIR
 I $G(PSSDV)="C" W !
 E  W @IOF
 K PSSOUT,PSSDV,PSSCT,PSSLINE D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@"
 Q
INHD ;
 I $G(PSSDV)="C",$G(PSSCT)'=1 W ! K DIR S DIR(0)="E",DIR("A")="Press Return to continue, '^' to exit" D ^DIR K DIR I 'Y S PSSOUT=1 Q
 W @IOF W !?5,"Instructions Report"_$S($G(PSSCT)=1:"",1:"  (cont.)"),?68,"PAGE: "_$G(PSSCT) S PSSCT=PSSCT+1
 W !,"Y in convert column indicates non-numeric (can convert to Noun field)",!,"Dosage Form",?32,"Instruction",?65,"Convert",!,PSSLINE,!
 Q
