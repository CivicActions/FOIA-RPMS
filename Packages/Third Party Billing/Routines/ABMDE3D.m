ABMDE3D ; IHS/SD/SDR - Edit Page 3 - QUESTIONS - part 4 ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**6,10,13,14,21,30,31,39,40**;NOV 12, 2009;Build 785
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
 ;IHS/SD/SDR 2.6*31 CR8881 Split from ABMDE3C; Removed #44
 ;IHS/SD/SDR 2.6*39 ADO99168 Added #45 Date Last SRP
 ;IHS/SD/SDR 2.6*40 ADO111599 Added #46 VA Contract#
 ;**********************************************************************
 ;
24 ;Admitting DX
 W !,"** CODING SYSTEM IS "_$S(ABMP("VDT")<ABMP("ICD10"):"ICD-9",1:"ICD-10")_" **"  ;abm*2.6*10 ICD10 002E
 ;start old abm*2.6*14 ICD10 002E
 ;start new abm*2.6*10 ICD10 002E
 ;I $D(^ROUTINE("ICDSAPI")) D  Q
 ;.W !,"["_ABM("#")_"] Admitting DX"
 ;.S ABMFLD=+$$SEARCH^ICDSAPI("DIAG",,,$S($G(ABMP("ICD10")):ABMP("ICD10"),$G(ABMP("VDT")):ABMP("VDT"),1:DT))
 ;.I ABMFLD>0 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=ABMFLD D ^DIE
 ;end new code ICD10 002E
 ;S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".59["_ABM("#")_"] Admitting DX" D ^DIE
 ;end old start new ICD10 002E
 K DIR,DR,X,Y
 S DIR(0)="PO^80:QEAM"
 I ABMP("VDT")<ABMP("ICD10")  S DIR("S")="I $P($$DX^ABMCVAPI(+Y),U,20)'=30"
 I '(ABMP("VDT")<ABMP("ICD10")) S DIR("S")="I $P($$DX^ABMCVAPI(+Y),U,20)=30"
 S DIR("A")="["_ABM("#")_"] Admitting DX"
 S:(+$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),U,9)) DIR("B")=$P($$DX^ABMCVAPI(+$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),U,9)),U,2)  ;abm*2.6*14 HEAT163740
 D ^DIR
 I X="@" S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".59////@" D ^DIE
 Q:$D(DIRUT)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".59////"_+Y D ^DIE
 ;end new ICD10 002E
 Q
25 ; Supervising Prov (FL19)
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".912["_ABM("#")_"] Supervising Prov.(FL19)" D ^DIE
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".911["_ABM("#")_"] Date Last Seen" D ^DIE
 S ABMNPIU=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 I ABMNPIU="B"!(ABMNPIU="N") D
 .S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR="925["_ABM("#")_"] NPI" D ^DIE
 I ABMNPIU'="N" D
 .S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR="924["_ABM("#")_"] I.D. Number (UPIN)" D ^DIE
 Q
26 ; Date of Last X-Ray
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".913["_ABM("#")_"] Date of Last X-Ray" D ^DIE
 Q
27 ;Referral Number
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".511["_ABM("#")_"] Referral Number" D ^DIE
 Q
28 ;Prior Authorization Number
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".512["_ABM("#")_"] Prior Authorizaion Number" D ^DIE
 Q
29 ;Homebound Indicator
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".914["_ABM("#")_"] Homebound Indicator" D ^DIE
 Q
30 ;Hospice Employed Provider
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".915["_ABM("#")_"] Hospice Employed Provider" D ^DIE
 Q
31 ;Delayed Reason Code
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".916["_ABM("#")_"] Delayed Reason Code" D ^DIE
 Q
32 ;#Enclosures - Radiographs/Oral Images/Models
 W !,"Number of Enclosures: ",!
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".917 Radiographs" D ^DIE
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".918 Oral Images" D ^DIE
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".919 Models" D ^DIE
 Q
33 ;Other Dental Charges
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".921["_ABM("#")_"] Other Dental Charges" D ^DIE
 Q
34 ;Reference Lab CLIA#
 N ABMDCLIA
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN")
 S ABMDCLIA=$P($G(^ABMDPARM(DUZ(2),1,4)),U,12)
 I ABMDCLIA'="" S ABMDCLIA=$P($G(^ABMRLABS(ABMDCLIA,0)),U)
 I ABMDCLIA'="" S ABMDCLIA=$P($G(^AUTTVNDR(ABMDCLIA,0)),U)
 S DR=".923"_$S(ABMDCLIA'="":"//"_ABMDCLIA,1:"")
 D ^DIE
 K ABMDCLIA
 Q
35 ;In-House CLIA#
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".922["_ABM("#")_"] In-House CLIA#: //"_$P($G(^ABMDPARM(DUZ(2),1,4)),U,11) D ^DIE
 Q
 ;start new abm*2.6*6 5010
36 ;Hearing and Vision Prescription Date
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".714["_ABM("#")_"] Hearing/Vision Prescription Date: //" D ^DIE
 Q
37 ;Start/End Disability Dates
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN")
 S DR=".715["_ABM("#")_"] Start Disability Date: //" D ^DIE
 S DR=".716["_ABM("#")_"] End Disability Date: //" D ^DIE
 Q
38 ;Assumed/Relinquished Care Dates
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN")
 S DR=".719["_ABM("#")_"] Assumed Care Date: //" D ^DIE
 S DR=".721["_ABM("#")_"] Relinquished Care Date: //" D ^DIE
 Q
39 ;Property/Casualty Date of 1st contact
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".722["_ABM("#")_"] Property/Casualty Date of 1st Contact: //" D ^DIE
 Q
40 ;Patient Paid Amount
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".723["_ABM("#")_"] Patient Paid Amount: //" D ^DIE
 Q
41 ;Spinal Manipulation Cond Code
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".724["_ABM("#")_"] Spinal Manipulation Cond Code Ind: //" D ^DIE
 ;start new abm*2.6*13 exp mode 35
 I "^A^M^"[("^"_$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,24)_"^") S DR=".727 Acute Manifestation Date: //" D ^DIE
 I "^A^M^"'[("^"_$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,24)_"^") S DR=".727////@" D ^DIE
 ;end new exp mode 35
 Q
42 ; Vision Condition Info
 S DIE="^ABMDCLM(DUZ(2),"
 S DA=ABMP("CDFN")
 S DR=".821["_ABM("#")_"] Vision Condition Info: //"
 S DR=DR_";W !?3;.822 Vision Certification Condition Indicator: //"
 D ^DIE
 F  D  Q:Y<0
 .K DIC,DIE,DIR,X,Y,DA
 .S DA(1)=ABMP("CDFN")
 .S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",8.5,"
 .S DIC(0)="AQELM"
 .S DIC("P")=$P(^DD(9002274.3,8.5,0),U,2)
 .D ^DIC
 Q
 ;end new 5010
 ;start new abm*2.6*13 exp mode 35
43 ;Initial Treatment Date
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".823["_ABM("#")_"] Initial Treatment Date: //" D ^DIE
 Q
 ;start old abm*2.6*31 IHS/SD/SDR CR8881
 ;44 ;Ord/Ref/Sup Phys (FL17)
 ;S ABM("PROVIDER")=$$PRVLKUP^ABMDFUTL($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,24),$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,26))
 ;S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".824////"_$S($P(ABM("PROVIDER"),U)'="":$P(ABM("PROVIDER"),U),1:"@") D ^DIE
 ;S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".826////"_$S($P(ABM("PROVIDER"),U,2)'="":$P(ABM("PROVIDER"),U,2),1:"@") D ^DIE
 ;I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,24)="" S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".825////@" D ^DIE  ;abm*2.6*14 HEAT163737
 ;I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,26)="" Q  ;abm*2.6*14 HEAT163697
 ;I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,24)'="" S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DIE("NO^")=1,DR=".825R~Physician Type: //" D ^DIE
 ;I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,24)="" S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".825////@" D ^DIE
 ;Q
 ;end new exp mode 35
 ;end old abm*2.6*31 IHS/SD/SDR CR8881
 ;start new abm*2.6*39 IHS/SD/SDR ADO99168
45 ;Date Last SRP (Scaling and Root Planing)
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR="926["_ABM("#")_"] Date Last SRP: //" D ^DIE
 Q
 ;end new abm*2.6*39 IHS/SD/SDR ADO99168
 ;start new abm*2.6*40 IHS/SD/SDR ADO111599
46 ;VA Contract Number
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR="927["_ABM("#")_"] VA Contract Number: //" D ^DIE
 Q
 ;end new abm*2.6*39 IHS/SD/SDR ADO111599
