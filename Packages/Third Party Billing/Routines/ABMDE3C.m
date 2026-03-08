ABMDE3C ; IHS/SD/SDR - Edit Page 3 - QUESTIONS - part 4 ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**6,10,13,14,21,30,31**;NOV 12, 2009;Build 615
 ;IHS/SD/SDR 2.5*6-7/14/04-IM14117 - Modified code to prompt for either
 ;  Person Class, Provider Class, or taxonomy code.  One of the three must be entered
 ;IHS/SD/SDR 2.5*8-IM14016/IM15234/IM15615 - Fix Prior Authorization field
 ;IHS/SD/SDR 2.5*8-IM14693/IM16105 - Added code for Number of Enclosures (32)
 ;IHS/SD/SDR-2.5*8-IM12246/IM17548 - Added Reference and In-House CLIA Numbers
 ;IHS/SD/SDR-2.5*9-IM19291 - Supervising provider and UPIN
 ;IHS/SD/SDR-2.5*9-IM18516 - Delayed Reason Code
 ;IHS/SD/SDR-2.5*9-IM19062 - allow employment related to be "N"
 ;IHS/SD/SDR 2.5*11-NPI
 ;IHS/SD/SDR-2.6*6-5010-added question 36 HEARING/VISION RX DATE
 ;IHS/SD/SDR-2.6*6-5010-added start/end disability dates
 ;IHS/SD/SDR-2.6*6-5010-added assumed/relinquished care dates
 ;IHS/SD/SDR-2.6*6-5010-added property/casualty date of 1st contact
 ;IHS/SD/SDR-2.6*6-5010-added patient paid amount
 ;IHS/SD/SDR-2.6*6-5010-added spinal manipulation cond code
 ;IHS/SD/SDR-2.6*6-5010-added vision condition info
 ;IHS/SD/SDR 2.6*13-ICD10 Added code to create/update 9A entry for Onset of Symptoms/Illness if
 ;  Date of First Symptom is populated.  They should both exist and be same date.
 ;IHS/SD/SDR 2.6*13-exp mode 35 -added Initial Treatment Date
 ;IHS/SD/SDR 2.6*13-Added acute manifestation date
 ;IHS/SD/SDR-2.6*13-Added Ord/Ref/Sup Phys FL17
 ;IHS/SD/SDR 2.6*14-ICD10 002E -Correction to screen for Admit DX.
 ;IHS/SD/SDR 2.6*14-HEAT163697 -Added quit to stop edits for referring provider to happen if prv was deleted.
 ;IHS/SD/SDR 2.6*14-HEAT163737 -for ref/ord/sup phys remove provider type is provider name is deleted.
 ;IHS/SD/SDR 2.6*14-HEAT163740 -Added default to Admit Dx if it was previously populated.
 ;IHS/SD/SDR 2.6*14-HEAT165301 -Removed link to page 9A for Date of First Symptom
 ;IHS/SD/SDR 2.6*21 HEAT159770 Made lookup for employment related use '02' not '2'
 ;IHS/SD/SDR 2.6*30 CR10400 Fixed #18 to prompt for date when YES
 ;IHS/SD/SDR 2.6*31 CR8881 Split routine to ABMDE3D due to size; updated how #12 works to do look up into New Person file
 ;  but still allow free-text; also will prompt for 3P Claim .825 depending on export mode (#35)
 ;**********************************************************************
 ;
9 W ! S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".86["_ABM("#")_"] Date of First Symptom" D ^DIE K DR
 I X>ABMP("VDT") W *7,!!,"ERROR: Date can not be after the Visit Date (",$$HDT^ABMDUTL(ABMP("VDT")),")!" S DR=".86///@" D ^DIE G 9
 ;abm*2.6*14 HEAT165301 removed new to populate page 9A
 ;start new abm*2.6*13 ICD10 new export mode 35
 ;S ABMTEST=+$O(^ABMDCODE("AC","O",11,0))
 ;S ABMI=0
 ;F  S ABMI=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),51,ABMI)) Q:'ABMI  D
 ;.I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),51,ABMI,0)),U)'=ABMTEST Q
 ;.D ^XBFMK
 ;.S DA(1)=ABMP("CDFN")
 ;.S DA=ABMI
 ;.S DIK="^ABMDCLM(DUZ(2),"_DA(1)_",51,"
 ;.D ^DIK
 ;I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,6)="" Q
 ;K ABMTEST,ABMI
 ;D ^XBFMK
 ;S DA(1)=ABMP("CDFN")
 ;S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",51,"
 ;S DIC("P")=$P(^DD(9002274.3,51,0),U,2)
 ;S X=+$O(^ABMDCODE("AC","O",11,0))
 ;S DIC(0)="ML"
 ;K DD,DO
 ;D FILE^DICN
 ;S DIE=DIC
 ;S DA=+Y
 ;S DR=".02////"_$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,6)
 ;D ^DIE
 ;end new ICD10 new export mode
 Q
 ;
11 W ! S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".87["_ABM("#")_"] Date First Consulted for this Condition" D ^DIE K DR
 I X>ABMP("VDT") W *7,!!,"ERROR: Date can not be after the Visit Date (",$$HDT^ABMDUTL(ABMP("VDT")),")!" S DR=".87///@" D ^DIE G 11
 Q
 ;
12 ;
 ;start old abm*2.6*31 IHS/SD/SDR CR8881
 ;W ! S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".88["_ABM("#")_"] Name of Referring Physician" D ^DIE
 ;I X="",$P($G(^ABMDCLM(DUZ(2),DA,8)),U,11)]"" S DR=".884///@;.885///@;.886///@;.887///@;.888///@;.889///@" D ^DIE Q
 ;S ABMNPIU=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 ;I ABMNPIU="B"!(ABMNPIU="N") D
 ;.S DR=".889   Referring Physician NPI"
 ;.D ^DIE
 ;end old start new abm*2.6*31 IHS/SD/SDR CR8881
 S ABMSVREF=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,8)
 S ABM("PROVIDER")=$$PRVLKUP^ABMDFUTL($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,8),$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,17))
 I ($G(ABMSVREF)'="")&(ABMSVREF'=$P(ABM("PROVIDER"),U)) S DR=".884///@;.885///@;.886///@;.887///@;.888///@;.889///@;.825///@" D ^DIE  ;if a different provider is entered clear existing data
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".88////"_$S($P(ABM("PROVIDER"),U)'="":$P(ABM("PROVIDER"),U),1:"@") D ^DIE
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".889////"_$S($P(ABM("PROVIDER"),U,2)'="":$P(ABM("PROVIDER"),U,2),1:"@") D ^DIE
 I $G(ABM("PROVIDER"))="" D  Q  ;clear fields if nothing entered
 .S DR=".884///@;.885///@;.886///@;.887///@;.888///@;.889///@;.825///@" D ^DIE
 I ABMP("EXP")=35 S DR=".825R~Physician Type: //" D ^DIE Q  ;if 1500(02/12) ask for provider type
 ;end new abm*2.6*31 IHS/SD/SDR CR8881
 I ABMNPIU'="N" D
 .S DR=".884    Referring Physician ID Qualifier"
 .S DR=DR_";.885    Referring Physician I.D. No"
 .D ^DIE
 I $P($G(^ABMDCLM(DUZ(2),DA,8)),U,11)'="" D  ;only ask if UPIN was entered
 .S ABMTXFLG=0
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,13)'="" D  ;Person Class
 ..W !!,"Person Class already entered:  ",$P($G(^USC(8932.1,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),8),U,13),0)),U)
 ..S ABMTXFLG=1
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,14)'="" D  ;Provider Class
 ..W !!,"Provider Class already entered:  ",$P($G(^DIC(7,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),8),U,14),9999999)),U)_"  "_$P($G(^DIC(7,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),8),U,14),0)),U)
 ..S ABMTXFLG=1
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,15)'="" D  ;Taxonomy Code
 ..W !!,"Taxonomy Code already entered:  ",$P($G(^ABMPTAX($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),8),U,15),0)),U)
 ..S ABMTXFLG=1
 .F  D  Q:ABMTXFLG=1
 ..S DIR(0)="SO^1:Person Class;2:Provider Class;3:Taxonomy Code"
 ..S DIR("A")="Which would you like to enter?"
 ..D ^DIR K DIR
 ..I Y=1 D  Q  ;Person Class
 ...S DR=".887////@;.888////@;.886          Referring Physician Person Class..:"
 ...D ^DIE
 ...I X'="" S ABMTXFLG=1
 ..I Y=2 D  Q  ;Provider Class
 ...S DR=".886////@;.888////@;.887          Referring Physician Provider Class..:"
 ...D ^DIE
 ...I X'="" S ABMTXFLG=1
 ..I Y=3 D  Q  ;Taxonomy code
 ...S DR=".886////@;.887////@;.888          Referring Physician Taxonomy Code..:"
 ...D ^DIE
 ...I X'="" S ABMTXFLG=1
 K DR
 Q
 ;
10 W ! S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".89["_ABM("#")_"] Similiar Illness or Injury Date" D ^DIE K DR
 I X>ABMP("VDT") W *7,!!,"ERROR: Date can not be after the Visit Date (",$$HDT^ABMDUTL(ABMP("VDT")),")!" S DR=".89///@" D ^DIE G 10
 Q
 ;
4 K DIR W ! S DIR(0)="Y",DIR("A")="["_ABM("#")_"] Was Visit Employment Related",DIR("?")="Was the Reason for the Visit Related to Employment"
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),$P(^(9),U,1)="Y" S DIR("B")="Y"
 E  S DIR("B")="N"
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("Y")=Y
 I Y=1 G EMCODE
 I ABM("Y")=0,$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),$P(^(9),U,1)="Y" S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".91///@;.92///@;.93///@;.94///@;.95///@;.96///@" D ^DIE K DR
 Q:($D(^ABMDCLM(DUZ(2),ABMP("CDFN"),53,0))<10)
 S DA(1)=ABMP("CDFN"),DIK="^ABMDCLM(DUZ(2),"_DA(1)_",53,",DA=$O(^ABMDCODE("AC","C",2,"")) D ^DIK
 Q
EMCODE ;
 ;S (DINUM,X)=$O(^ABMDCODE("AC","C",2,"")) Q:X=""  ;abm*2.6*21 IHS/SD/SDR HEAT159770
 S (DINUM,X)=$O(^ABMDCODE("AC","C","02","")) Q:X=""  ;abm*2.6*21 IHS/SD/SDR HEAT159770
 K DD,DO S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_",53,",DIC(0)="LE"
 I '$D(^ABMDCLM(DUZ(2),DA(1),53,0)) S ^ABMDCLM(DUZ(2),DA(1),53,0)="^9002274.3053P^^"
 D FILE^DICN K DIC
 S DR=".91////Y",DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN") W !
 I "AB"'[$E(ABM("QU"),$L(ABM("QU"))) G ESET
 I $E(ABM("QU"),$L(ABM("QU")))="B" S DR=DR_";.93Unable to Work From Date...: ;I X="""" S Y=""@9"";.94Unable to Work Thru Date...: ;@9"
 E  S DR=DR_";.92T;.93T;I X="""" S Y=.95;.94T;.95T;I X="""" S Y=""@9"";.96T;@9"
ESET D ^DIE K DR
 Q
 ;
13 ;
 Q
 ;
14 W ! S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".48["_ABM("#")_"] Assigned Case Number" D ^DIE K DR
 Q
 ;
15 W ! S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".49["_ABM("#")_"] Medicaid Resubmission No." D ^DIE K DR
 Q
 ;
16 W ! S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".43["_ABM("#")_"] Number Radiographs Submitted" D ^DIE K DR
 Q
 ;
17 W ! S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".44["_ABM("#")_"] Orthodontic Related" D ^DIE K DR
 Q:X'=1
 S DR=".45    Placement Date" D ^DIE
 S DR="413    Months of Treatment Remaining:" D ^DIE
 I X>ABMP("VDT") W *7,!!,"ERROR: Date can not be after the Visit Date (",$$HDT^ABMDUTL(ABMP("VDT")),")!" S DR=".45///@" D ^DIE G 17
 Q
 ;
18 W ! S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".46["_ABM("#")_"] Init. Prosthesis Placed" D ^DIE K DR
 ;I X=0 S DR=".47   Prior Placement Date" D ^DIE  ;abm*2.6*30 IHS/SD/SDR CR10400
 I X=1 S DR=".47   Prior Placement Date" D ^DIE  ;abm*2.6*30 IHS/SD/SDR CR10400
 Q
 ;
19 W ! S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".58["_ABM("#")_"] Peer Review Organization (PRO) Approval No." D ^DIE K DR
 Q
20 ;HCFA-1500B BLOCK 19
 S $P(ABM("-"),"-",49)="" W !,?15,ABM("-")
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR="10["_ABM("#")_"] Block 19" D ^DIE K DR
 Q
21 ;TYPE OF ADMISSION
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".51["_ABM("#")_"] Admission Type" D ^DIE
 Q
22 ;SOURCE OF ADMISSION
 S:'$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)) ^(5)=""
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".52["_ABM("#")_"] Admission Source" D ^DIE
 Q
23 ;DISCHARGE STATUS
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".53["_ABM("#")_"]Discharge Status" D ^DIE
 Q
