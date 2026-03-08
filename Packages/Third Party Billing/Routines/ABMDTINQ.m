ABMDTINQ ; IHS/SD/SDR - Inquire UTILITY ;  
 ;;2.6;IHS 3P BILLING SYSTEM;**6,10,29,31**;NOV 12, 2009;Build 615
 ;IHS/DSD/MRS Patch 1 NOIS QDA-299-130004 3/20/1999 Modified to change insurer look up to pull visit type
 ;    from abmnins instead of autnins
 ;IHS/SD/SDR 2.6*29 CR10669 Changed DIC call for ICPT to only show CPTs that don't have INACTIVE FLAG
 ;IHS/SD/SDR 2.6*31 CR10857 Added to DIQ call so the NUMBER would display for IQCP CPT displays; removed setting of
 ;   DR so it will display all fields
 ;
LOC ;EP for displaying Location Record
 S ABM("SUB")="LOCATION" D HD S DIC="^AUTTLOC(" G DIC
CPT ;EP for displaying CPT Record
 S ABM("SUB")="CPT PROCEDURE" D HD S DIC="^ICPT(" G DIC
INS ;EP for displaying Insurer Record
 S ABM("SUB")="INSURER" D HD S DIC="^AUTNINS(" D DIC Q
PRV ;EP for displaying Provider Record
 S ABM("SUB")="PROVIDER" D HD S DIC="^VA(200,",DIC("S")="I $D(^(""PS""))" G DIC
 ;
BILL ;EP for displaying Bill Record
 D ^ABMDBDIC
 G XIT:'$G(ABMP("BDFN"))
 S ABM("SUB")="BILL"
 S DA=ABMP("BDFN")
 W $$EN^ABMVDF("IOF")
 W !?80-$L(ABM("SUB"))-21\2,"*** ",ABM("SUB")," FILE INQUIRY ***"
 S DIC="^ABMDBILL(DUZ(2),"
 S ABM=""
 S $P(ABM,"=",80)=""
 W !!,ABM
 K S
 D EN^DIQ
 W ABM
 G BILL
 ;
DRUG ;EP for displaying Drug Record
 S ABM("SUB")="DRUG" D HD S DIC="^PSDRUG(" G DIC
 ;
DIC ;
 ;W !! S DIC("A")="Select "_ABM("SUB")_": ",DIC(0)="QEAM" D ^DIC  ;abm*2.6*29 IHS/SD/SDR CR10669
 W !! S DIC("A")="Select "_ABM("SUB")_": "  ;abm*2.6*29 IHS/SD/SDR CR10669
 I DIC["ICPT" S DIC(0)="QEAMI",DIC("S")="I $$CHKCPT^ABMDUTL(Y)'=0"  ;abm*2.6*29 IHS/SD/SDR CR10669
 E  S DIC(0)="QEAM"
 D ^DIC  ;abm*2.6*29 IHS/SD/SDR CR10669
 G XIT:X=""!(X["^")!$D(DUOUT)!$D(DTOUT)
 I +Y<1 G DIC
 S DA=+Y
 W $$EN^ABMVDF("IOF") W !?80-$L(ABM("SUB"))-21\2,"*** ",ABM("SUB")," FILE INQUIRY ***"
 S ABM="",$P(ABM,"=",80)="" W !!,ABM K S
 ;start new code abm*2.6*10 ICD10 022
 I DIC["CPT" D  G DIC
 .;S DR="0:81.02;9999999"  ;abm*2.6*31 IHS/SD/SDR CR10857
 .S DIQ(0)="R"  ;abm*2.6*31 IHS/SD/SDR CR10857
 .D EN^DIQ
 .W ABM
 ;end new code 022
 I DIC'["AUTNINS" D EN^DIQ W ABM G DIC
 ;S DR="0:31;43" D EN^DIQ ; Skip visit type node 39 in autnins  ;abm*2.6*10 ICD10 024
 S DR="0:31" D EN^DIQ  ;abm*2.6*10 ICD10 024
 ;S DIC="^ABMNINS(DUZ(2),",DR="1:2" D EN^DIQ ; Write it from abmnins  ;abm*2.6*6 5010
 ;S DIC="^ABMNINS(DUZ(2),",DR="1:2.5" D EN^DIQ ; Write it from abmnins  ;abm*2.6*6 5010  ;abm*2.6*10 ICD10 024
 S DIC="^ABMNINS(DUZ(2),",DR="0;1:2.5" D EN^DIQ ; Write it from abmnins  ;abm*2.6*6 5010  ;abm*2.6*10 ICD10 024
 W ABM
 S DIC="^AUTNINS("  ;abm*2.6*10 ICD10 024
 G DIC
 ;
XIT K ABM,DIR,DIC,DIE
 Q
 ;
HD K DIC,DR
 Q
