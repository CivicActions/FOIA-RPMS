PSSDOSER ;BIR/RTR-Dose edit option ;03/10/00
 ;;1.0;PHARMACY DATA MANAGEMENT;**34**;9/30/97
 ;Reference to ^PS(50.607 supported by DBIA 2221
 ;
 ;have an entry point for NDF to call when rematching
DOS ;Edit dosages
 D CHECK^PSSUTLPR I $G(PSSNOCON) K PSSNOCON D END Q
 D END
 W !! S DIC(0)="QEAMZ",DIC("A")="Select Drug: ",DIC="^PSDRUG(" D ^DIC I Y<1!($D(DTOUT))!($D(DUOUT)) D END W ! Q
 S PSSIEN=+Y,PSSNAME=$P($G(^PSDRUG(PSSIEN,0)),"^"),PSSIND=$P($G(^("I")),"^"),PSSNFID=$P($G(^(0)),"^",9)
 S PSSPKG=$P($G(^PSDRUG(PSSIEN,2)),"^",3)
 W !!,"This entry is marked for the following PHARMACY packages:" W:PSSPKG["O" !,"Outpatient" W:PSSPKG["U" !,"Unit Dose" W:PSSPKG["I" !,"IV" W:PSSPKG["W" !,"Ward Stock" W:PSSPKG["N" !,"Controlled Substances"
 I PSSPKG'["O",PSSPKG'["U",PSSPKG'["I",PSSPKG'["W",PSSPKG'["N" W !," (none)"
 K PSSPKG L +^PSDRUG(PSSIEN):0 I '$T W !!,$C(7),"Another person is editing this drug.",! K DIR S DIR(0)="E",DIR("A")="Press Return to continue" D ^DIR K DIR G DOS
 W !!,PSSNAME_$S($G(PSSNFID):"    *N/F*",1:"") W ?52,"Inactive Date: "_$S($G(PSSIND):$E(PSSIND,4,5)_"/"_$E(PSSIND,6,7)_"/"_$E(PSSIND,2,3),1:"")
 S PSSST=$P($G(^PSDRUG(PSSIEN,"DOS")),"^"),PSSUN=$P($G(^("DOS")),"^",2)
 S PSSXYZ=0 D CHECK
 I $G(PSSXYZ) D STR
 K PSSXYZ
 I '$P($G(^PSDRUG(PSSIEN,"DOS")),"^") G LOC
DOSA S PSSST=$P($G(^PSDRUG(PSSIEN,"DOS")),"^")
 W !!,"Strength => "_$S($E($G(PSSST),1)=".":"0",1:"")_$G(PSSST)_"   Unit => "_$S($P($G(^PS(50.607,+$G(PSSUN),0)),"^")'["/":$P($G(^(0)),"^"),1:"") W !
 K DIC S DA(1)=PSSIEN,DIC="^PSDRUG("_PSSIEN_",""DOS1"",",DIC(0)="QEAMLZ",DIC("A")="Select DISPENSE UNITS PER DOSE: " D  D ^DIC K DIC I Y<1!($D(DTOUT))!($D(DUOUT)) G DOSLOC
 .S DIC("W")="W ""  ""_$S($E($P($G(^PSDRUG(PSSIEN,""DOS1"",+Y,0)),""^"",2),1)=""."":""0"",1:"""")_$P($G(^PSDRUG(PSSIEN,""DOS1"",+Y,0)),""^"",2)_""    ""_$P($G(^PSDRUG(PSSIEN,""DOS1"",+Y,0)),""^"",3)"
 S PSSDOSA=+Y
 W ! K DIE S DA(1)=PSSIEN,DA=PSSDOSA,DR=".01;2",DIE="^PSDRUG("_PSSIEN_",""DOS1""," D ^DIE K DIE G:$D(Y)!($D(DTOUT)) DOSLOC
 G DOSA
DOSLOC ;
 S (PSSPCI,PSSPCO)=0
 F PSSPCZ=0:0 S PSSPCZ=$O(^PSDRUG(PSSIEN,"DOS1",PSSPCZ)) Q:'PSSPCZ  D
 .I $P($G(^PSDRUG(PSSIEN,"DOS1",PSSPCZ,0)),"^",2)'="" S:$P($G(^(0)),"^",3)["I" PSSPCI=1 S:$P($G(^(0)),"^",3)["O" PSSPCO=1
 I PSSPCI,PSSPCO W !! K DIR S DIR(0)="Y",DIR("B")="N",DIR("A")="Enter/Edit Local Possible Dosages" D  D ^DIR K DIR I Y'=1 K PSSPCI,PSSPCO,PSSPCZ W ! D ULK G DOS
 .S DIR("?")=" ",DIR("?",1)="Possible Dosages exist for both Outpatient Pharmacy and Inpatient Medications.",DIR("?",2)="Local Possible Dosages can be added, but will not be displayed for selection"
 .S DIR("?",3)="as long as there are Possible Dosages.",DIR("?",4)=" ",DIR("?",5)="Enter 'Y' to Enter/Edit Local Possible Dosages."
 K PSSPCI,PSSPCO,PSSPCZ
LOC ; Edit local dose
 W ! K DIC S DA(1)=PSSIEN,DIC="^PSDRUG("_PSSIEN_",""DOS2"",",DIC(0)="QEAMLZ" D  D ^DIC K DIC I Y<1!($D(DTOUT))!($D(DUOUT)) D ULK G DOS
 .S DIC("W")="W ""  ""_$P($G(^PSDRUG(PSSIEN,""DOS2"",+Y,0)),""^"",2)"
 S PSSDOSA=+Y
 W ! K DIE S DA(1)=PSSIEN,DA=PSSDOSA,DR=".01;1",DIE="^PSDRUG("_PSSIEN_",""DOS2""," D ^DIE K DIE I $D(Y)!($D(DTOUT)) D ULK G DOS
 G LOC
 Q
STR ;Edit strength
 N PSSIENS,PSS11
 W !!,"Strength from National Drug File match => "_$S($E($G(PSSNATST),1)=".":"0",1:"")_$G(PSSNATST)_"    "_$P($G(^PS(50.607,+$G(PSSUN),0)),"^")
 W !,"Strength currently in the Drug File    => "_$S($E($P($G(^PSDRUG(PSSIEN,"DOS")),"^"),1)=".":"0",1:"")_$P($G(^PSDRUG(PSSIEN,"DOS")),"^")_"    "_$S($P($G(^PS(50.607,+$G(PSSUN),0)),"^")'["/":$P($G(^(0)),"^"),1:"")
 W ! K DIR S DIR(0)="Y",DIR("?")="Changing the strength will update all possible dosages for this Drug",DIR("B")="N",DIR("A")="Edit Strength" D ^DIR K DIR I 'Y W ! Q
 W ! K DIE S DIE="^PSDRUG(",DA=PSSIEN,DR=901 D ^DIE K DIE W !
 Q
CHECK ;
 K PSSNAT,PSSNATND,PSSNATDF,PSSNATUN,PSSNATST
 S PSSNAT=+$P($G(^PSDRUG(PSSIEN,"ND")),"^",3),PSSNAT1=$P($G(^("ND")),"^") I 'PSSNAT!('PSSNAT1) Q
 S PSSNATND=$$DFSU^PSNAPIS(PSSNAT1,PSSNAT) S PSSNATDF=$P(PSSNATND,"^"),PSSNATST=$P(PSSNATND,"^",4),PSSNATUN=$P(PSSNATND,"^",5)
 I $G(PSSST) S PSSXYZ=1 Q
 Q:'PSSNATDF!('PSSNATUN)!($G(PSSNATST)="")
 Q:'$D(^PS(50.606,PSSNATDF,0))!('$D(^PS(50.607,PSSNATUN,0)))
 I PSSNATST'?.N&(PSSNATST'?.N1".".N) Q
 I $D(^PS(50.606,"ACONI",PSSNATDF,PSSNATUN)),$O(^PS(50.606,"ADUPI",PSSNATDF,0)) S PSSXYZ=1
 I $D(^PS(50.606,"ACONO",PSSNATDF,PSSNATUN)),$O(^PS(50.606,"ADUPO",PSSNATDF,0)) S PSSXYZ=1
 Q
END K PSSNFID,PSSNAT,PSSNAT1,PSSNATND,PSSNATDF,PSSNATUN,PSSNOCON,PSSST,PSSUN,PSSIEN,PSSNAME,PSSIND,PSSDOSA,PSSXYZ,PSSNATST
 Q
ULK ;
 Q:'$G(PSSIEN)
 L -^PSDRUG(PSSIEN)
 Q
