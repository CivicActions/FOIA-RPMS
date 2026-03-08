ABMDEAD2 ; IHS/SD/SDR - Add New Claim - Program 2 ;  
 ;;2.6;IHS 3P BILLING SYSTEM;**40**;NOV 12, 2009;Build 785
 ;
 ;IHS/SD/SDR 2.5*10 IM20022 Use ROI/AOB multiples
 ;IHS/SD/SDR 2.5*10 IM20320 Fix for manually added insurer (not being put as ACTIVE INSURER)
 ;
 ;IHS/SD/SDR 2.6*40 ADO111599 Added VA Contract# to claim if VA MEDICAL BENEFIT (VMBP) is an insurer on claim
 ;
STUFF K DIC S DIC="^ABMDCLM(DUZ(2),",DIC(0)="L",X=ABMP("PDFN")
 S DINUM=$$NXNM^ABMDUTL
 I DINUM="" D  G XIT
 .W !!,"ERROR: Claim not created - check global ^ABMDCLM(0)"
 .S DIR(0)="E" D ^DIR K DIR
 K DD,DO D FILE^DICN
 I +Y<0 D  G XIT
 .W *7,!!,"ERROR: Claim not created, ensure FILEMAN ACCESS CODE contains a 'V'."
 .S DIR(0)="E" D ^DIR K DIR
 L +^ABMDCLM(DUZ(2),+Y):1 I '$T W !,*7,"Claim File is LOCKED by another USER, CLAIM NOT CREATED!" H 3 G XIT
 S (ABMP("CDFN"),ABMA("CDFN"))=+Y,ABMA("X")=+Y
 S DA=ABMP("CDFN"),DIE="^ABMDCLM(DUZ(2),"
 S DR=".02////"_ABMP("VDT")_";.03////"_ABMP("LDFN")_";.04////E" D ^DIE
 S DR=".06////"_ABMP("CLN")_";.07////"_ABMP("VTYP") D ^DIE
 S DR=".72////"_ABMP("DDT")_";.17////"_DT D ^DIE
 I ABMP("VTYP")=111 D
 .S X2=ABMP("VDT"),X1=ABMP("DDT") D ^%DTC S ABM("CVD")=X,ABM("PCD")=X+1
 .I X=0 S (ABM("CVD"),ABM("PCD"))=1
 .S DR=".57////"_ABM("PCD")_";.61////"_ABMP("VDT")_";.63////"_ABMP("DDT")_";.51////83" D ^DIE
 .S DR=".52////45;.53////58;.54////90;.62////12;.64////12;.73////"_ABM("CVD")_";.66////0" D ^DIE
 S ABM=$O(ABML(0)) Q:ABM=""  D
 .S ABMI=$O(ABML(ABM,0)) Q:ABMI=""  S DR=".08////"_ABMI
 .D ^DIE K DR
 I $D(ABM("F1")) D
 .S DR=".91;.83" D ^DIE
 ;
 ;start new abm*2.6*40 IHS/SD/SDR ADO111599
 K ABMVAFLG
 S ABMT("I")=0
 F  S ABMT("I")=$O(ABML(ABMT("I"))) Q:'ABMT("I")  D
 .Q:(ABMT("I")>97)
 .S ABMT("IN")=$O(ABML(ABMT("I"),0))
 .I $P($G(^AUTNINS(ABMT("IN"),0)),U)="VA MEDICAL BENEFIT (VMBP)" S ABMVAFLG=1
 I $G(ABMVAFLG)=1 D
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DA=ABMP("CDFN")
 .S DR="927////"_$P($G(^ABMDPARM(DUZ(2),1,3)),U,13)  ;SITM VA CONTRACT#
 .D ^DIE
 ;end new abm*2.6*40 IHS/SD/SDR ADO111599
 ;
 I $O(^DIC(40.7,"B","EMERGENCY MEDICINE",""))=ABMP("CLN") S ABMP("C0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),0) D ASET^ABMDE3B
 I $O(^DIC(40.7,"B","EPSDT",""))=ABMP("CLN") S Y=67 D SP^ABMDE3B
 I $O(^DIC(40.7,"B","FAMILY PLANNING",""))=ABMP("CLN") S Y=70 D SP^ABMDE3B
 ;
REL K DIE S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN")
 I ABMP("VTYP")=111 S DR=".74////N;.75////N" D ^DIE K DR G ELCK
 I ($D(^AUPNPAT(ABMP("PDFN"),36,0)))>10,($O(^AUPNPAT(ABMP("PDFN"),36,"B",0),-1)<ABMP("VDT")) S DR=".74////Y;.711////"_$O(^AUPNPAT(ABMP("PDFN"),36,"B",0),-1)
 E  S DR=".74////N"
BENE I ($D(^AUPNPAT(ABMP("PDFN"),71,0)))>10,($O(^AUPNPAT(ABMP("PDFN"),71,"B",0),-1)<ABMP("VDT")) S DR=".75////Y;.712////"_$O(^AUPNPAT(ABMP("PDFN"),71,"B",0),-1)
 E  S DR=DR_";.75////N"
 D ^DIE K DR
 ;
ELCK D ENT^ABMDE2E
 L -^ABMDCLM(DUZ(2),ABMP("CDFN"))
 ;
 K ABMP,ABM,ABMX,ABMV,ABMZ,ABMC,ABMU,ABML
 S ABMP("CDFN")=ABMA("CDFN"),X=ABMA("X") K ABMA
 S ABMPERM("EDITOR")=1
 G EXT^ABMDE
 ;
XIT K DIC,ABM,ABMP,ABMX,ABMV,ABME,ABML
 Q
