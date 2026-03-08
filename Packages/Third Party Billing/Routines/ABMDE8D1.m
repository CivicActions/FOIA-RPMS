ABMDE8D1 ; IHS/SD/SDR - Page 8 - MEDICATIONS (Cont) ; APR 05, 2002
 ;;2.6;IHS Third Party Billing System;**2,7,9,19,21,28,30,31,32,33,37**;NOV 12, 2009;Build 739
 ;
 ;IHS/SD/SDR 2.5 P8 Rewrote routine Request to completely change display
 ;IHS/SD/SDR 2.5 p9 IM16660 4-digit revenue codes
 ;IHS/SD/SDR 2.5 p9 task 1 Use service line provider multiple
 ;IHS/SD/SDR 2.5 p11 NPI
 ;
 ;IHS/SD/SDR 2.6*2 3PMS10003A Modified to call ABMFEAPI
 ;IHS/SD/SDR 2.6*19 HEAT173117 Added code to prompt for CPT Narrative if necessary for med.
 ;IHS/SD/SDR 2.6*21 HEAT168435 Added code to display/add/edit pharmacy modifiers
 ;IHS/SD/SDR 2.6*21 HEAT207995 Gave user ability to edit NDC even when a prescription from the
 ;  prescription file is selected.  They want ability to remove dashes in NDC.
 ;IHS/SD/SDR 2.6*28 CR10648 Added default (CPT description) to CPT NARRATIVE prompt
 ;IHS/SD/SDR 2.6*28 CR10551 Added IMMUNIZATION LOT/BATCH NUMBER prompt
 ;IHS/SD/SDR 2.6*30 CR8870 Updated display so it won't wrap if units are maxed out, including 3 decimal places
 ;IHS/SD/SDR 2.6*31 CR11624 Change API call to CPTD^ABMCVAPI to fix <SUBSCR>VLTCP+8^ICPTCOD
 ;IHS/SD/SDR 2.6*32 CR8943 Added code to stop error <UNDEFINED>E+48^ABMDE8D, when the first prescription prompt is answered
 ;  and the provider is deleted.
 ;IHS/SD/SDR 2.6*32 CR10335 Fixed so user can type 'E#' or just '#' to edit a line; before if you entered '3' it would turn around and ask what line (1-##) instead
 ;  of recognizing that you entered '3' to edit line 3
 ;IHS/SD/SDR 2.6*33 ADO60186/CR12024 Prompt for CPT Narrative if export mode is UB-04 (in addition to all 5010s and 1500(02/12)); Added new checks for Medication description
 ;  in the NARR option; split from ABMDE8D due to size
 ;IHS/SD/SDR 2.6*37 ADO89299 Added logic for DEA# if ordering provider
 ;
 ;start new abm*2.6*28 IHS/SD/SDR CR10551
IMMUN ;EP
 I $G(ABMTCPT)="" S DR="15////@" D ^DIE  ;delete IMMUN LOT/BATCH#
 ;
 S ABMIMFG=0
 I $G(ABMTCPT)'="" D
 .S ABMTCAT=$S($P($G(^ICPT(ABMTCPT,0)),U,3)'="":$P($G(^DIC(81.1,$P($G(^ICPT(ABMTCPT,0)),U,3),0)),U),1:"")  ;cpt cat
 .I (ABMTCAT["IMMUNIZATION")!(ABMTCAT["VACCINE") S ABMIMFG=1
 .;
 .;S ABMTDESC=$$CPTD^ICPTCOD(ABMTCPT,"ABMTCD","",ABMP("VDT"))  ;cpt long desc  ;abm*2.6*31 IHS/SD/SDR CR11624
 .S ABMTDESC=$$CPTD^ABMCVAPI(ABMTCPT,"ABMTCD","",ABMP("VDT"))  ;cpt long desc  ;abm*2.6*31 IHS/SD/SDR CR11624
 .S ABMT=0
 .F  S ABMT=$O(ABMTCD(ABMT)) Q:'ABMT  D
 ..S ABMTDESC=$G(ABMTCD(ABMT))
 ..I (ABMTDESC["IMMUNIZATION")!(ABMTDESC["VACCINE") S ABMIMFG=1
 .;
 .I ABMIMFG=1 S DR="15//" D ^DIE  ;prompt for IMMUN LOT/BATCH#
 .I ABMIMFG=0 S DR="15////@" D ^DIE  ;delete it
 Q
 ;end new abm*2.6*28 IHS/SD/SDR CR10551
 ;start new abm*2.6*19 IHS/SD/SDR HEAT173117 NARR
NARR ;
 I (+$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,29)'=0) D
 .I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,29))) D
 ..;Q:$P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["5010"  ;only 5010 formats  ;abm*2.6*28 IHS/SD/SDR CR10648
 ..;I ($P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["5010")&(ABMP("EXP")'=35) Q  ;abm*2.6*28 IHS/SD/SDR CR10648  ;abm*2.6*33 IHS/SD/SDR CR12024
 ..I ($P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["5010")&(ABMP("EXP")'=35)&(ABMP("EXP")'=28) Q  ;abm*2.6*28 IHS/SD/SDR CR10648  ;abm*2.6*33 IHS/SD/SDR CR12024
 ..S ABMCNCK=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,29),0))
 ..;I ABMCNCK,$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMCNCK,0)),U,2)="Y" S DR="22Narrative" D ^DIE  ;abm*2.6*28 IHS/SD/SDR CR10648
 ..;start old abm*2.6*33 IHS/SD/SDR CR12024
 ..;I ABMCNCK,$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMCNCK,0)),U,2)="Y" S DR="22CPT Narrative"  ;abm*2.6*28 IHS/SD/SDR CR10648
 ..;I ABMCNCK,$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMCNCK,0)),U,3)="Y" S DR=DR_"//"_$P($$CPT^ABMCVAPI($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,29),ABMP("VDT")),U,3)  ;abm*2.6*28 IHS/SD/SDR CR10648
 ..;D ^DIE  ;abm*2.6*28 IHS/SD/SDR CR10648
 ..;end old start new abm*2.6*33 IHS/SD/SDR CR12024
 ..I ABMCNCK D
 ...I $P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMCNCK,0)),U,2)="Y" S DR="22CPT Narrative"
 ...S ABMT("MED")="",ABM("NDC")="",ABMT("MEDN")=""
 ...I $P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMCNCK,0)),U,3)="R" D
 ....S ABMT("MEDN")="<NO MED FOR NDC>"
 ....S ABM("NDC")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,24)
 ....I $G(ABM("NDC"))'="" I +$O(^PSDRUG("ZNDC",$TR(ABM("NDC"),"-"),0))=0 S ABM("NDC")=""
 ....I $G(ABM("NDC"))="" S ABM("NDC")=$P($G(^PSDRUG($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U),2)),U,4)
 ....S ABM("NDC")=$O(^PSDRUG("ZNDC",$TR(ABM("NDC"),"-"),0))
 ....I +$G(ABM("NDC"))'=0 S (ABMT("MED"),ABMT("MEDN"))=$P($G(^PSDRUG(ABM("NDC"),0)),U)
 ...;
 ...I ((($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMCNCK,0)),U,3)="C"))!(($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMCNCK,0)),U,4)="Y")&($G(ABMT("MED"))=""))) D
 ....K ABMTDESC
 ....S ABMTDESC=$$CPTD^ABMCVAPI($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,29),"ABMTDESC",ABMP("VDT"))
 ....W !!,$P($G(^ICPT($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,29),0)),U)_" Long Description:"
 ....S ABMT("I")=0  F  S ABMT("I")=$O(ABMTDESC(ABMT("I"))) Q:'ABMT("I")  W !,$G(ABMTDESC(ABMT("I")))
 ....S ABMT("MED")=$P($$CPT^ABMCVAPI($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,29),ABMP("VDT")),U,3)
 ...I "^C^R^"[("^"_$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMCNCK,0)),U,3)_"^") D
 ....S DR=DR_"//"_$S($G(ABMT("MED"))'="":ABMT("MED"),1:"")
 ...D ^DIE
 ..;end new abm*2.6*33 IHS/SD/SDR CR12024
 Q
 ;end new abm*2.6*19 IHS/SD/SDR HEAT173117 NARR
 ;
PPDU ;PRICE PER DISPENSE UNIT
 S DR=""
 S:^ABMDEXP(ABMMODE(4),0)["UB" DR=".02//250;"
 ;S ABMZ("PPDU")=+$P($G(^ABMDFEE(ABMP("FEE"),25,ABMZ("DRUG"),0)),U,2)  ;abm*2.6*2 3PMS10003A
 S ABMZ("PPDU")=+$P($$ONE^ABMFEAPI(ABMP("FEE"),25,ABMZ("DRUG"),ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 S:'ABMZ("PPDU") ABMZ("PPDU")=+$P($G(^PSDRUG(ABMZ("DRUG"),660)),U,6)
 S DIR(0)="Y",DIR("A")="Is this entry an IV"
 S DIR("B")=$S($P(^ABMDCLM(DUZ(2),DA(1),23,DA,0),"^",15)'="":"YES",1:"NO")
 D ^DIR K DIR S ABMZ("IV")=Y I Y=1 D
 .S DIR(0)="N^0:9999:3",DIR("B")=ABMZ("PPDU"),DIR("A")="IV Price per Unit"
 .I $P(^ABMDCLM(DUZ(2),DA(1),23,DA,0),U,4) S DIR("B")=$P(^(0),U,4)
 .D ^DIR K DIR S ABMZ("PPDU")=Y
 .S DR=".02//IV;.15;.07;.08;.09;"
 Q
DFEE ;GET DISPENSE FEE
 S ABMZ("DISPFEE")=0
 I ABMP("VTYP")'=111,ABMP("VTYP")'=831 S ABMZ("DISPFEE")=$P($G(^ABMDPARM(DUZ(2),1,0)),U,3) Q
 I $P($G(ABM("X0")),U,15)="" S ABMZ("DISPFEE")=$P($G(^ABMDPARM(DUZ(2),1,4)),U,6) Q
 S ABMZ("DISPFEE")=$P($G(^ABMDPARM(DUZ(2),1,4)),U,$F("APHSC",$P(ABM("X0"),U,15))-1)
 Q
PROV ;
 N DIC,DR,DIE
 S DA(2)=ABMP("CDFN")
 S (DA(1),ABMSIEN)=DA
 S DIC="^ABMDCLM(DUZ(2),"_DA(2)_","_ABMZ("SUB")_","_DA(1)_",""P"","
 S DIC(0)="AELMQ"
 S ABMFLNM="9002274.30"_$G(ABMZ("SUB"))
 S DIC("P")=$P(^DD(ABMFLNM,.18,0),U,2)
 S DIC("DR")=".01;.02//R"
 D ^DIC
 K DIC,DR,DIE
 I +Y>0,(+$P(Y,U,3)=0) D
 .K DIE,DA,DR
 .S DA(2)=ABMP("CDFN")
 .S DA(1)=ABMSIEN
 .S DIE="^ABMDCLM(DUZ(2),"_DA(2)_","_ABMZ("SUB")_","_DA(1)_",""P"","
 .S DA=+Y
 .S DR=".01//;.02"
 .D ^DIE
 S DA=+$G(DA(1))
 S DA(1)=ABMP("CDFN")
 D ORDDEA  ;abm*2.6*37 IHS/SD/SDR ADO89299
 Q
 ;start new abm*2.6*37 IHS/SD/SDR ADO89299
ORDDEA ;
 I "^23^27^43^"'[("^"_ABMZ("SUB")_"^") Q  ;these are the only multiples that store the ordering provider and NDC
 S ABMDEA=""
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMSIEN,"P","C","D")) D
 .S ABMPRIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMSIEN,"P","C","D",0))
 .S ABMDEA=$$GET1^DIQ(200,$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMSIEN,"P",ABMPRIEN,0)),U),"53.2","E")  ;New Person DEA
 .I ABMDEA="" S ABMDEA=$$GET1^DIQ(4,ABMP("LDFN"),52,"E")  ;Institution DEA
 I ABMDEA="" S ABMDEA="@"
 ;
 K DA(2)
 S DA(1)=ABMP("CDFN")
 S DA=ABMSIEN
 S DR="23////"_ABMDEA
 S DIE="^ABMDCLM(DUZ(2),"_DA(1)_","_ABMZ("SUB")_","
 D ^DIE
 Q
 ;end new abm*2.6*37 IHS/SD/SDR ADO89299
