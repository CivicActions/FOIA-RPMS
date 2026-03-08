ABMDE3 ; IHS/SD/SDR - Edit Page 3 - QUESTIONS ;  
 ;;2.6;IHS 3P BILLING SYSTEM;**6,10,30,31**;NOV 12, 2009;Build 615
 ;
 ;IHS/DSD/DMJ 4/27/1999 NOIS QDA-0399-130056 Patch 1 new code looks for y2k hcfa form (#14) at line QUES+6
 ;
 ;IHS/SD/SDR 2.5*8 task 6 Added code for new page 3A
 ;
 ;IHS/SD/SDR 2.6*6 5010 made code skip question 41 if not chiropractic clinic
 ;IHS/SD/SDR 2.6*6 5010 made code skip question 42 if not optometry clinic
 ;IHS/SD/SDR 2.6*31 CR11832 Populate (837I or UB-04) or delete (not 837I or UB-04) data from Admission Type and
 ;   Admission Source if the SERVICE CATEGORY is either Telecommunications or Telemedicine
 ;
 ; *********************************************************************
 ;
OPT ;EP
 G XIT:$D(ABMP("WORKSHEET"))
 K ABM,ABME,ABMZ,DUOUT,ABMP("QU")
 S ABMP("OPT")="ENVJBQ"
 ;start new abm*2.6*31 IHS/SD/SDR CR11832
 S DIE="^ABMDCLM(DUZ(2),"
 S DA=ABMP("CDFN")
 I (("^T^M^"[("^"_$G(SERVCAT)_"^"))&("^28^31^"[("^"_$G(ABMP("EXP"))_"^"))) D
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),U)="" D
 ..S DR=".51///2"
 ..D ^DIE
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),U,2)="" D
 ..S DR=".52///1"
 ..D ^DIE
 I (("^T^M^"[("^"_$G(SERVCAT)_"^"))&'("^28^31^"[("^"_$G(ABMP("EXP"))_"^"))) D
 .S DR=".51////@;.52////@"
 .D ^DIE
 ;end new abm*2.6*31 IHS/SD/SDR CR11832
 D QUES
 S ABMZ("NUM")=$L(ABMP("QU"),",")
 D DISP
 G XIT:$D(DTOUT)!$D(DIROUT)
 D ^ABMDE3X
 I +$O(ABME(0)) D
 . S ABME("CONT")=""
 . D ^ABMDERR
 . K ABME("CONT")
 G XIT:$D(DTOUT)!$D(DIROUT)
 W !
 D SEL^ABMDEOPT
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!("EV"'[$E(Y))
 S ABM("DO")=$S($E(Y)="E":"E1",1:"V1")
 W !
 D @ABM("DO")
 G XIT:$D(DTOUT)!$D(DIROUT)
 G OPT
 ;
 ; *********************************************************************
V1 ;
 S ABMZ("TITL")="QUESTIONS - VIEW OPTION"
 D SUM^ABMDE1
 ;start new abm*2.6*30 IHS/SD/SDR CR10215
 S ABMT("VDFN")=0
 F  S ABMT("VDFN")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,ABMT("VDFN"))) Q:'ABMT("VDFN")  D
 .S ABMDVDSP=ABMT("VDFN") D DSPLHOSP^ABMDVDSP
 ;end new abm*2.6*30 IHS/SD/SDR CR10215
 D ^ABMDERR
 Q
 ;
 ; *********************************************************************
E1 ; Entry of Claim Identifiers
 S ABMP("FLDS")=$L(ABMP("QU"),",")
 I ABMP("QU")["13" S ABMP("FLDS")=ABMP("FLDS")-1
 D FLDS^ABMDEOPT
 Q:$D(DTOUT)!$D(DIROUT)!$D(DUOUT)
 F ABM("I")=1:1 S ABM=$P(ABMP("FLDS"),",",ABM("I")) Q:'ABM  D  Q:$G(Y)[U
 .S ABM=ABM\1
 .S ABM("#")=ABM
 .Q:'ABM
 .S ABM("QU")=$P(ABMP("QU"),",",ABM)
 .S ABM=+ABM("QU")
 .D @($P(^ABMQUES(+ABM,0),"^",4)_"^"_$P(^(0),"^",5))
 S DA=ABMP("CDFN")
 S DIE="^ABMDCLM(DUZ(2),"
 S DR=".09////Y"
 D ^DIE
 K DR
 S ABMP("C0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),0)
 Q
 ;
 ; *********************************************************************
QU K DIR,%P
 F ABM("SUB")=1:1:12 D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 . S ABM("SUB")=$S(ABM("SUB")<5:ABM("SUB")_"^ABMDE3A",1:ABM("SUB")_"^ABMDE3B")
 . D @ABM("SUB")
 G OPT
 ;
 ; *********************************************************************
DISP ;
 S ABMZ("TITL")="QUESTIONS"
 S ABMZ("PG")=3
 I $D(ABMP("DDL")),$Y>(IOSL-6) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)  I 1
 E  D SUM^ABMDE1
 F ABM("SUB")=1:1 S ABM("QU")=$P(ABMP("QU"),",",ABM("SUB")) Q:'ABM("QU")  D  Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 .I $Y>(IOSL-5) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 .W !,$J("["_ABM("SUB")_"]",4)," "
 .D @($P(^ABMQUES(+ABM("QU"),0),"^",2)_"^"_$P(^ABMQUES(+ABM("QU"),0),"^",3))
 Q
 ;
 ; *********************************************************************
XIT K ABM,ABMP("QU")
 Q
 ;
 ; *********************************************************************
QUES ;EP - for setting Questions Array
 I '$D(ABMP("EXP")) D EXP^ABMDEVAR
 S ABMP("QU")=""
 S ABM("F")=0
 F  S ABM("F")=$O(ABMP("EXP",ABM("F"))) Q:'ABM("F")  D
 .S ABM("QU")=$G(ABM("QU"))_$S($P(^ABMDEXP(ABM("F"),0),U,8)]"":$P(^(0),U,8),1:"1,2,3,4,5,6,7,8,9,10,11,12,13")_","
 .I $D(ABMP("EXP",3))!($D(ABMP("EXP",14))) D
 ..;I $P($G(^AUTNINS(+$G(ABMP("INS")),2)),U)="D" S ABM("QU")=ABM("QU")_"14,"  ;abm*2.6*10 HEAT73780
 ..I $$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABMP("INS"),".211","I"),1,"I")="D" S ABM("QU")=ABM("QU")_"14,"  ;abm*2.6*10 HEAT73780
 ..S ABM("QU")=ABM("QU")_"20,"
 .S ABM("QU")=$P(ABM("QU"),",13",1)_$P(ABM("QU"),",13",2)
 .F ABM("I")=1:1 S ABM=$P(ABM("QU"),",",ABM("I")) Q:ABM=""  S ABM("QU",+ABM)=$P(ABM,+ABM,2)
 S ABM=0
 ;F  S ABM=$O(ABM("QU",ABM)) Q:'ABM  S ABMP("QU")=$S(+ABMP("QU"):ABMP("QU")_",",1:"")_ABM_ABM("QU",ABM)  ;abm*2.6*6 5010
 ;start new code abm*2.6*6 5010
 F  S ABM=$O(ABM("QU",ABM)) Q:'ABM  D
 .I ((ABM=41)&($P($G(^DIC(40.7,ABMP("CLN"),0)),U,2)'="A6")) Q  ;only display if chiropractic clinic
 .I ((ABM=42)&($P($G(^DIC(40.7,ABMP("CLN"),0)),U,2)'=18)) Q  ;only display if optometry clinic
 .S ABMP("QU")=$S(+ABMP("QU"):ABMP("QU")_",",1:"")_ABM_ABM("QU",ABM)
 ;end new code abm*2.6*6 5010
 Q
3 ;
 Q:$P($G(^DIC(40.7,ABMP("CLN"),0)),U)'="AMBULANCE"
 D OPT^ABMDE31
 I "Bb"[Y D OPT^ABMDE3
 Q
