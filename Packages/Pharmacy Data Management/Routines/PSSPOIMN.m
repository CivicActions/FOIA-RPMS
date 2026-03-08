PSSPOIMN ;BIR/RTR/WRT-Orderable Item manual create ;09/01/98
 ;;1.0;PHARMACY DATA MANAGEMENT;**15,32,34**;9/30/97
 S PSSITE=+$O(^PS(59.7,0)) I +$P($G(^PS(59.7,PSSITE,80)),"^",2)<2 W !!?3,"Orderable Item Auto-Create has not been completed yet!",! K PSSITE,DIR S DIR(0)="E",DIR("A")="Press RETURN to continue" D ^DIR K DIR Q
 K PSSITE D MESS^PSSPOIM1
BEG I $D(PSIEN) L -^PSDRUG(PSIEN)
 K DOSEFV,DOSEFORM,POINT,SPHOLD,NEWSP,PSVAR1,PSITEM,PSTOP,PSMASTER,DIC("S")
 S PSOUT=0 W !! K DIC S DIC(0)="QEAM",DIC="^PSDRUG(",DIC("A")="Select DISPENSE DRUG: ",DIC("S")="I $P($G(^PSDRUG(+Y,2)),""^"",3)[""I""!($P($G(^(2)),""^"",3)[""O"")!($P($G(^(2)),""^"",3)[""U"")"
 D ^DIC G:$D(DTOUT)!($D(DUOUT))!(Y<1) END K DIC("S") S PSIEN=+Y,PSNAME=$P(^PSDRUG(PSIEN,0),"^") L +^PSDRUG(PSIEN):0 I '$T W !,$C(7),"Another person is editing this one." Q
MAS I $G(PSMASTER) S PSOUT=0 N DOSEFV,DOSEFORM,POINT,SPHOLD,NEWSP,PSVAR1,PSITEM,PSTOP
 S NODE=$G(^PSDRUG(PSIEN,"ND")),DOSEPTR=0,DA=$P(NODE,"^"),X=$$VAGN^PSNAPIS(DA),VAGEN=X I +$P(NODE,"^"),+$P(NODE,"^",3),VAGEN'=0 S K=$P(NODE,"^",3),X=$$PSJDF^PSNAPIS(DA,K),DOSEFV=X I DOSEFV'=0 D
 .S DOSEPTR=$P(X,"^"),DOSEFORM=$P(X,"^",2)
 D TMP
 I +$P($G(^PSDRUG(PSIEN,2)),"^") S (POINT,PSITEM)=$P(^(2),"^") W !!,PSNAME," is already matched to",!!,?5,$P($G(^PS(50.7,POINT,0)),"^")_" "_$P($G(^PS(50.606,+$P($G(^(0)),"^",2),0)),"^"),!
 ;Warn user the Orderable Item is inactive. Display date and option to use.
 I  N PSSIAD D
 .S PSSIAD=$P($G(^PS(50.7,POINT,0)),"^",4) I $G(PSSIAD) S Y=PSSIAD D DD^%DT W !,"This Orderable Item has an Inactive Date.  *** "_Y,!,"To modify the Orderable Item, use the 'Edit Orderable Item' option."
 I  D  W ! K DIR S DIR("B")="NO",DIR(0)="Y",DIR("A")="Do you want to match to a different Orderable Item" D ^DIR K DIR D:Y=1 SET,REM D SETX D:POINT'=$G(PSITEM) EN^PSSPOIDT(POINT),EN2^PSSHL1(POINT,"MUP") G:$G(PSMASTER) END G BEG
 .K PSSDXLF
 D MCH I $G(PSIEN) D EN2^PSSUTIL(PSIEN,1)
 G:'$G(PSMASTER) BEG
END I $D(PSIEN) L -^PSDRUG(PSIEN)
 G END^PSSPOIM1
REM D TMP
 I $O(^TMP($J,"PSSOO",0)) H 1 D OTHER^PSSPOIM1,DISP
 Q:$G(PSOUT)  I $O(^TMP($J,"PSSOO",0)),$G(MATCH) S PSSP=MATCH D ^PSSPOIM1 Q:(PSOUT)!(PSNO)  S DIE="^PSDRUG(",DA=PSIEN,DR="2.1////"_MATCH  D ^DIE K DIE S PSITEM=MATCH D COM Q
 G MCHA
TMP K ^TMP($J,"PSSOO") S PSCNT=0 I +$P(NODE,"^"),+$P(NODE,"^",3) F ZZ=0:0 S ZZ=$O(^PSDRUG("AND",+NODE,ZZ)) Q:'ZZ  I +$P($G(^PSDRUG(ZZ,2)),"^"),$P(^PSDRUG(ZZ,2),"^")'=$G(POINT),$D(^PS(50.7,$P(^PSDRUG(ZZ,2),"^"),0)) S OTH=$G(^PSDRUG(ZZ,"ND")) D
 .I +$P(OTH,"^"),+$P(OTH,"^",3),DOSEFV'=0 S DA=$P(OTH,"^"),K=$P(OTH,"^",3),X=$$PSJDF^PSNAPIS(DA,K),DOSA=X I DOSA'=0,DOSEFV=DOSA D
 ..S NOFLAG=0,TMPTR=$P(^PSDRUG(ZZ,2),"^") F FFF=0:0 S FFF=$O(^TMP($J,"PSSOO",FFF)) Q:'FFF  I $P(^TMP($J,"PSSOO",FFF),"^")=TMPTR S NOFLAG=1
 ..I 'NOFLAG S PSCNT=PSCNT+1 S ^TMP($J,"PSSOO",PSCNT)=$P(^PSDRUG(ZZ,2),"^")_"^"_ZZ
 Q
DISP S MATCH=0 F TT=0:0 S TT=$O(^TMP($J,"PSSOO",TT)) Q:'TT  S SPT=$P(^TMP($J,"PSSOO",TT),"^") W !,TT,"  ",$P($G(^PS(50.7,SPT,0)),"^")_" "_$P($G(^PS(50.606,+$P($G(^(0)),"^",2),0)),"^") I $Y+5>IOSL D  Q:Y=0  I Y="" S PSOUT=1 Q
 .W ! K DIR S DIR(0)="E" D ^DIR I Y W @IOF W !,?3,"Dispense Drug -> ",PSNAME,!
DISPO Q:$G(PSOUT)  W ! K DIR S DIR(0)="N",DIR("A")="Choose number of Orderable Item to match, or '^' to enter a new one" D ^DIR K DIR I Y=""!($D(DTOUT)) S PSOUT=1 Q
 Q:Y["^"  I '$D(^TMP($J,"PSSOO",+Y)) W !!,?5,"INVALID NUMBER" G DISPO
 S MATCH=$P(^TMP($J,"PSSOO",+Y),"^") Q
 S PSOUT=1 Q
MCH I $O(^TMP($J,"PSSOO",0)) H 1 D OTHER^PSSPOIM1,DISP
 Q:$G(PSOUT)  I $O(^TMP($J,"PSSOO",0)),$G(MATCH) S PSSP=MATCH D ^PSSPOIM1 Q:(PSOUT)!(PSNO)  K DIE S DIE="^PSDRUG(",DA=PSIEN,DR="2.1////"_MATCH D ^DIE S PSITEM=MATCH D COM Q
MCHA W ! I $G(DOSEFORM)'="" W !?3,"Dose Form -> ",DOSEFORM,!! K DIR S DIR(0)="Y",DIR("B")="NO",DIR("A")="Match to another Orderable Item with same Dose Form" D ^DIR G:Y=1 LOOK I Y["^"!(Y="")!($D(DTOUT)) Q
 I $G(DOSEFORM)="" K DIC S DIC="^PS(50.606,",DIC(0)="QEAMZ",DIC("A")="Choose Dose Form: " D ^DIC Q:$D(DTOUT)!($D(DUOUT))!(Y<1)  S DOSEPTR=+Y W !!?3,"Dose Form -> ",$G(Y(0,0))
 I $G(DOSEFORM)="" K DIR W ! S DIR(0)="Y",DIR("B")="NO",DIR("A")="Match to another Orderable Item with same Dose Form" D ^DIR
 I $G(DOSEFORM)="" Q:$D(DTOUT)!($D(DUOUT))!(Y<0)  S DOSEFORM=$P(^PS(50.606,DOSEPTR,0),"^") G:Y>0 LOOK
MCHAN W !! I $L(VAGEN)>40 W !,"VA Generic Name -> ",VAGEN,!
 W !,?3,"Dose Form -> ",DOSEFORM,!,?3,"Dispense Drug -> ",PSNAME,!!
 K DIR S DIR(0)="F^3:40",DIR("A")="Orderable Item Name" S:$L(VAGEN)>2&($L(VAGEN)<41) DIR("B")=VAGEN
 D ^DIR Q:$D(DUOUT)!($D(DTOUT))!(Y["^")!(Y="")
 I X[""""!($A(X)=45)!('(X'?1P.E))!(X?2"z".E) W $C(7),!!?5,"??" G MCHAN
 S (X,SPHOLD)=Y,(STOP,PSNO)=0 F COMM=0:0 S COMM=$O(^PS(50.7,"ADF",SPHOLD,DOSEPTR,COMM)) Q:'COMM!(STOP)!($G(PSOUT))  I COMM,$P($G(^PS(50.7,COMM,0)),"^",3)="" D
 .S PSSP=COMM D ^PSSPOIM1 S:PSNO STOP=1 Q:PSOUT!(STOP)  K DIE S DIE="^PSDRUG(",DA=PSIEN,DR="2.1////"_COMM D ^DIE S PSITEM=COMM D COM S STOP=1 Q
 Q:PSOUT
 I STOP,$G(PSNO) G MCHAN
 Q:STOP
 S PSMAN=1
 D ^PSSPOIM1
 G:PSNO MCHAN Q:PSOUT  K DIC S DIC="^PS(50.7,",DIC(0)="L",X=SPHOLD,DIC("DR")=".02////"_DOSEPTR K DD,DO D FILE^DICN K DD,DO D:Y<1  G:(Y<1) MCHAN S NEWSP=+Y,DIE="^PSDRUG(",DA=PSIEN,DR="2.1////"_NEWSP D ^DIE S PSVAR1=1,PSITEM=NEWSP D COM Q
 .W $C(7),!?5,"Invalid entry!",!! Q
 Q
LOOK W !!!?3,"Enter ?? for Pharmacy Orderable Item List!",!
 K DIC S DIC="^PS(50.7,",DIC(0)="QEAM",DIC("S")="I $P($G(^(0)),""^"",2)=DOSEPTR,$P($G(^(0)),""^"",3)=""""" D ^DIC I Y>0 S (NEWSP,PSSP)=+Y D ^PSSPOIM1 G:PSNO LOOK Q:PSOUT  S DIE="^PSDRUG(",DA=PSIEN,DR="2.1////"_NEWSP D ^DIE S PSITEM=NEWSP D COM Q
 W ! K DIR S DIR(0)="Y",DIR("B")="YES",DIR("A")="Create a new Orderable Item to match" D ^DIR I Y=1 G MCHAN
 Q
COM W !,"Match Complete!",! D EN^PSSPOIM1(PSITEM) Q
 ;
SET ;
 S PSSDXLF=1,PSSDXL=+$P($G(^PS(50.7,+$G(POINT),0)),"^",2)
 Q
SETX ;
 I $G(PSSDXLF),$G(PSSDXL),$G(PSITEM),$G(PSSDXL)'=+$P($G(^PS(50.7,+$G(PSITEM),0)),"^",2) K ^PSDRUG(PSIEN,"DOS2") I $G(PSIEN) D EN2^PSSUTIL(PSIEN,1)
 K PSSDXL,PSSDXLF
 Q
