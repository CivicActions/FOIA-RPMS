PSSPOIMO ;BIR/RTR,WRT-Edit Orderable Item Name and Inactive date ; 02/04/00 13:32
 ;;1.0;PHARMACY DATA MANAGEMENT;**29,32**;9/30/97
 S PSSITE=+$O(^PS(59.7,0)) I +$P($G(^PS(59.7,PSSITE,80)),"^",2)<2 W !!?3,"Orderable Item Auto-Create has not been completed yet!",! K PSSITE K DIR S DIR("A")="Press RETURN to continue",DIR(0)="E" D ^DIR K DIR Q
 K PSSITE W !!,"This option enables you to edit Orderable Item names, Formulary status,",!,"drug text, Inactive Dates, and Synonyms."
EN I $D(PSOIEN) L -^PS(50.7,PSOIEN)
 K DIC S PY=$P($G(^PS(59.7,1,31)),"^",2)
 S PSS1="W ""  ""_$P(^PS(50.606,$P(^PS(50.7,+Y,0),""^"",2),0),""^"")_$S($P(^PS(50.7,+Y,0),""^"",3):"" ""_$G(PY),1:"""")_"" ""_$S($P(^(0),""^"",4):$E($P(^(0),""^"",4),4,5)_""-""_$E($P(^(0),""^"",4),6,7)_""-""_$E($P(^(0),""^"",4),2,3),1:"""")"
 S PSS2=" S NF=$P($G(^PS(50.7,+Y,0)),""^"",12) I NF S NF=""   N/F"" W NF"
 S DIC("W")=PSS1_PSS2
 S $P(PLINE,"-",79)="" W !! K PSOUT S DIC="^PS(50.7,",DIC(0)="QEAMZ" D ^DIC K DIC,PY G:Y<0!($D(DTOUT))!($D(DUOUT)) END
 S PSOIEN=+Y,PSOINAME=$P(Y,"^",2),PSDOSE=+$P(^PS(50.7,PSOIEN,0),"^",2) L +^PS(50.7,PSOIEN):0 I '$T W !,$C(7),"Another person is editing this one." Q
 W !!!,?5,"Orderable Item -> ",PSOINAME,!?5,"Dose Form      -> ",$P($G(^PS(50.606,PSDOSE,0)),"^"),!
 I $P($G(^PS(50.7,PSOIEN,0)),"^",3) W !?3,"*** This Orderable Item is flagged for IV use! ***",!
 G:$P($G(^PS(50.7,PSOIEN,0)),"^",3) ADDIT
 K DIR S DIR(0)="Y",DIR("B")="YES",DIR("A")="List all Dispense Drugs tied to this Orderable Item" D ^DIR K DIR I Y["^"!($D(DTOUT))!($D(DUOUT)) G EN
 I Y D DISP G:$G(PSOUT) EN
EDIT K DIR W ! S DIR(0)="Y",DIR("A")="Are you sure you want to edit this Orderable Item",DIR("B")="NO",DIR("?")="Answer YES to edit the fields associated with this Orderable Item." D ^DIR K DIR I 'Y!($D(DTOUT))!($D(DUOUT)) G EN
 W !!?3,"Now editing Orderable Item:",!?3,PSOINAME,"   ",$P($G(^PS(50.606,PSDOSE,0)),"^")
DIR W ! K DIR S DIR(0)="F^3:40",DIR("B")=PSOINAME,DIR("A")="Orderable Item Name" D ^DIR
 I Y["^"!($D(DUOUT))!($D(DTOUT)) G EN
 I X[""""!($A(X)=45)!('(X'?1P.E))!(X?2"z".E) W $C(7),!!?5,"??" G DIR
 I X'=PSOINAME S ZZFLAG=0 D @$S('$P($G(^PS(50.7,PSOIEN,0)),"^",3):"CHECK",1:"ZCHECK") I ZZFLAG G DIR
 S PSONEW=X,DIE="^PS(50.7,",DA=PSOIEN,DR=".01////"_X D ^DIE I PSONEW'=PSOINAME W !!,"Name changed from  ",PSOINAME,!?15,"to  ",PSONEW
 I $P($G(^PS(59.7,1,20.4)),"^",16)=1,$P(^PS(50.7,PSOIEN,0),"^",3)=1,$P(^PS(50.7,PSOIEN,0),"^",11)="" D UDMSG K DIE S DIE="^PS(50.7,",DR="3",DA=PSOIEN D ^DIE
 I $P($G(^PS(59.7,1,20.4)),"^",16)=1,$P(^PS(50.7,PSOIEN,0),"^",3)'=1,$P(^PS(50.7,PSOIEN,0),"^",10)="" D IVMSG K DIE S DIE="^PS(50.7,",DR="4",DA=PSOIEN D ^DIE
 W ! K DIE N MFLG S PSBEFORE=$P(^PS(50.7,PSOIEN,0),"^",4),PSAFTER=0,PSINORDE="" S DIE="^PS(50.7,",DR="5;6;.04;.05;.06;.07;.08",DA=PSOIEN D ^DIE S PSAFTER=$P(^PS(50.7,PSOIEN,0),"^",4) K DIE
 S:PSBEFORE&('PSAFTER) PSINORDE="D" S:PSAFTER PSINORDE="I"
 I PSINORDE'="" D REST^PSSPOIDT(PSOIEN)
 K PSBEFORE,PSAFTER,PSINORDE
SYN W ! K DIC S:'$D(^PS(50.7,PSOIEN,2,0)) ^PS(50.7,PSOIEN,2,0)="^50.72^0^0" S DIC="^PS(50.7,"_PSOIEN_",2,",DA(1)=PSOIEN,DIC(0)="QEAMZL",DIC("A")="Select SYNONYM: ",DLAYGO=50.72 D ^DIC K DIC
 I Y<0!($D(DUOUT))!($D(DTOUT)) K:'$O(^PS(50.7,PSOIEN,2,0)) ^PS(50.7,PSOIEN,2,0) D EN^PSSPOIDT(PSOIEN),EN2^PSSHL1(PSOIEN,"MUP") G EN
 W ! S DA=+Y,DIE="^PS(50.7,"_PSOIEN_",2,",DA(1)=PSOIEN,DR=.01 D ^DIE K DIE G SYN
 D EN^PSSPOIDT(PSOIEN),EN2^PSSHL1(PSOIEN,"MUP")
 G EN
END K ZZFLAG,DIC,DIR,DIE,DTOUT,DUOUT,FLAG,PSOINAME,PSOUT,PSDOSE,PSONEW,UPFLAG,VV,ZZ,AA,BB,Y,AAA,SSS,PSOARR,PSOARRAD,PLINE I $D(PSOIEN) L -^PS(50.7,PSOIEN) K PSOIEN
 Q
DISP S FLAG=1,UPFLAG=0 D HEAD F ZZ=0:0 S ZZ=$O(^PSDRUG("ASP",PSOIEN,ZZ)) Q:'ZZ!($G(PSOUT))!($G(UPFLAG))  S FLAG=0 D:($Y+5)>IOSL HEAD Q:$G(PSOUT)!($G(UPFLAG))  I ZZ W !,$P($G(^PSDRUG(ZZ,0)),"^") W:$P(^PSDRUG(ZZ,0),"^",9)=1 "   N/F" D DTE
 Q:$G(PSOUT)
 I FLAG W !?5,"No Dispense Drugs are tied to this Orderable Item!",!
 Q
HEAD I 'FLAG W ! K DIR S DIR(0)="E",DIR("A")="Press RETURN to continue" D ^DIR K DIR I 'Y S:Y="" PSOUT=1 S:Y=0 UPFLAG=1 Q
 W @IOF W !,?6,"Orderable Item ->  ",PSOINAME,!?6,"Dose Form      ->  ",$P($G(^PS(50.606,+$P($G(^PS(50.7,PSOIEN,0)),"^",2),0)),"^"),!!,"Dispense Drugs:"_$S('FLAG:" (continued)",1:""),!,"---------------"
 Q
ADDIT ;If orderable item is flagged for IV
 S AA=$O(^PS(52.6,"AOI",PSOIEN,0))
 S BB=$O(^PS(52.7,"AOI",PSOIEN,0))
 I 'AA,'BB W $C(7),!,"This Orderable Item is flagged for IV use, but currently there are no IV",!,"Additives or IV Solutions matched to this Orderable Item!" G EDIT
 G SOL
CHECK ;
 S ZZFLAG=0 F VV=0:0 S VV=$O(^PS(50.7,"ADF",X,PSDOSE,VV)) Q:'VV  I VV,'$P($G(^PS(50.7,VV,0)),"^",3) S ZZFLAG=1
 I ZZFLAG W $C(7),!!?5,"There is already an Orderable Item with this same name and Dose Form",!?5,"that is not flagged as an 'IV'. Use the 'DISPENSE DRUG/ORDERABLE ITEM",!?5,"MAINTENANCE' option if you want to re-match to this Orderable Item!",!
 Q
ZCHECK ;
 S ZZFLAG=0 F VV=0:0 S VV=$O(^PS(50.7,"ADF",X,PSDOSE,VV)) Q:'VV  I VV,$P($G(^PS(50.7,VV,0)),"^",3) S ZZFLAG=1
 I ZZFLAG W $C(7),!!?5,"There is already an Orderable Item with the same name and Dose Form,",!?5,"that is flagged for 'IV' use.",!
 Q
SOL ;
 K DIR S DIR(0)="Y",DIR("B")="YES",DIR("A")="List all Additives and Solutions tied to this Orderable Item" D ^DIR K DIR G:Y["^"!($D(DTOUT)) EN G:Y=0 EDIT
 H 1 K PSOARR,PSOARRAD S AAA=$O(^PS(52.6,"AOI",PSOIEN,0)) I AAA,$D(^PS(52.6,AAA,0)) S PSOARRAD=AAA
 F SSS=0:0 S SSS=$O(^PS(52.7,"AOI",PSOIEN,SSS)) Q:'SSS  S:$D(^PS(52.7,SSS,0)) PSOARR(SSS)=""
 S FLAG=1,UPFLAG=0 D SHEAD F ZZ=0:0 S ZZ=$O(PSOARR(ZZ)) Q:'ZZ!($G(PSOUT))!($G(UPFLAG))  S FLAG=0 D:($Y+7)>IOSL SHEAD Q:$G(PSOUT)!($G(UPFLAG))  I ZZ W !,$P($G(^PS(52.7,ZZ,0)),"^"),"   ",$P($G(^(0)),"^",3)
 G:$G(PSOUT) EN
 G EDIT
SHEAD I 'FLAG W ! K DIR S DIR(0)="E",DIR("A")="Press RETURN to continue" D ^DIR K DIR I 'Y S:Y="" PSOUT=1 S:Y=0 UPFLAG=1 Q
 W @IOF W !?6,"Orderable Item ->  ",PSOINAME,?68,"(IV)",!?6,"Dose Form      ->  ",$P($G(^PS(50.606,+$P($G(^PS(50.7,PSOIEN,0)),"^",2),0)),"^"),!,PLINE I FLAG,'$G(PSOARRAD) W !?5,"IV Solutions:",!
 I 'FLAG W !?5,"IV Solutions:",!
 I FLAG,$G(PSOARRAD) W !,$P($G(^PS(52.6,PSOARRAD,0)),"^"),"    ","(IV Additive)",! I $D(PSOARR) W !?5,"IV Solutions:",!
 Q
DTE I $D(^PSDRUG(ZZ,"I")) S Y=$P(^PSDRUG(ZZ,"I"),"^") D DD^%DT W ?50,Y K Y
 Q
IVMSG ; display a message if the CORRESPONDING IV field is entered
 ;
 S PSSIVMSG=$P(^PS(50.7,PSOIEN,0),"^",11) I PSSIVMSG="" Q
 S PSSIVFRM=$P(^PS(50.7,PSSIVMSG,0),"^",2) I PSSIVFRM S PSSIVFRM=$P(^PS(50.606,PSSIVFRM,0),"^")
 S PSSIVMSG=$P(^PS(50.7,PSSIVMSG,0),"^")_" "_PSSIVFRM
 W !!,"The Corresponding IV Item is currently identified as: "_PSSIVMSG,!
 K PSSIVFRM,PSSIVMSG
 Q
UDMSG ; display a message if the CORRESPONDING UD field is entered
 ;
 S PSSUDMSG=$P(^PS(50.7,PSOIEN,0),"^",10) I PSSUDMSG="" Q
 S PSSUDFRM=$P(^PS(50.7,PSSUDMSG,0),"^",2) I PSSUDFRM S PSSUDFRM=$P(^PS(50.606,PSSUDFRM,0),"^")
 S PSSUDMSG=$P(^PS(50.7,PSSUDMSG,0),"^")_" "_PSSUDFRM
 W !!,"The Corresponding UD Item is currently identified as: "_PSSUDMSG,!
 K PSSUDMSG,PSSUDFRM
 Q
