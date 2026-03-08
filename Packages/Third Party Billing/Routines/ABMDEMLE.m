ABMDEMLE ; IHS/SD/SDR - Edit Utility - FOR MULTIPLES ;
 ;;2.6;IHS 3P BILLING SYSTEM;**3,6,8,9,10,11,13,14,15,18,21,23,28,29,31,32,33,37**;NOV 12, 2009;Build 739
 ;
 ;IHS/SD/SDR 2.5*5 5/18/04 put POS and TOS by line item
 ;IHS/SD/SDR 2.5*6 7/9/04 IM14079, IM14121 Edited TOS; call to not do if 837 format
 ;IHS/SD/SDR 2.5*8 IM12246/IM17548 New prompts for In-House, Reference Lab CLIAs
 ;IHS/SD/SDR 2.5*8 task 6 Added mileage population on page 3A, message about editing
 ;IHS/SD/SDR 2.5*9 task 1 Added new provider multiple on service lines
 ;IHS/SD/SDR 2.5*9 IM19820 Fix for <UNDEF>E2+37^ABMDEMLE
 ;IHS/SD/SDR 2.5*10 task order item 1 Calls added for Chargemaster.  Calls supplied by Lori Butcher
 ;IHS/SD/SDR 2.5*11 IM23175 Added so G0107 could be entered on lab page.  It needs CLIA number
 ;
 ;IHS/SD/SDR v2.6 CSV
 ;IHS/SD/SDR 2.6*6 5010 added SV5 segment
 ;IHS/SD/SDR 2.6*6 5010 added 2400 DTP Test Date
 ;IHS/SD/SDR 2.6*13 exp mode 35.  Linked occurrence codes (01 and 11) to page 3 questions (Date First Symptom and Injury Date)
 ;IHS/SD/SDR 2.6*14 HEAT161263 Changed to use $$GET1^DIQ so output transform will execute for SNOMED/Provider Narrative; also
 ;  made change so provider narrative can't be edited if there are SNOMED codes present on claim
 ;IHS/SD/SDR 2.6*14 HEAT165301 Removed link between page 9a and 3 introduced in patch 13
 ;IHS/SD/SDR 2.6*15 Added change so you can edit POA even if there is SNOMED on claim
 ;IHS/SD/SDR 2.6*18 HEAT240919 put code back from p14 so user can edit provider narrative
 ;IHS/SD/AML 2.6*21 HEAT197195 Removed dot so POA would be editable on page 5A.
 ;IHS/SD/SDR 2.6*21 HEAT233742 Updated check for CPT Narrative prompt.  Wasn't including Surgical (21) or Ambulance (47) because range wasn't inclusive.  Changed >21 to >20 and <47 to <48.
 ;IHS/SD/AML 2.6*23 HEAT247169 Add .19 for NDC to list of editable fields if subfile is 43
 ;IHS/SD/SDR 2.6*28 CR10648 Added default (CPT description) to CPT NARRATIVE
 ;IHS/SD/SDR 2.6*28 CR10551 Added NDC for 25 (rev), 27 (Medical)
 ;IHS/SD/SDR 2.6*29 CR10686 Fixed long description look up to use correct variable; non-DINUMed entries caused issue
 ;IHS/SD/SDR 2.6*29 CR10404 Use new 3P Insurer 4 multiple field to prompt for CLIA if CPT is not in 80000 range
 ;IHS/SD/SDR 2.6*31 CR11624 Fix for <SUBSCR>VLTCP+8^ICPTCOD when two entries in CPT file for one CPT
 ;IHS/SD/SDR 2.6*32 CR8942 Split revenue code check to ABMDEML2
 ;IHS/SD/SDR 2.6*32 CR10335 Fixed so editing 2-digit entry will work when you type '10' at prompt; before it would select first entry when you typed '10' for 10th entry 
 ;IHS/SD/SDR 2.6*33 ADO60186/CR12024 Moved NDC and CPT NARRATIVE; data from NDC prompt is needed for CPT NARRATIVE prompt with changes for this CR.
 ;IHS/SD/SDR 2.6*37 ADO89299 Added call to populate DEA#
 ;
E1 ;Edit Multiple
 I ABMZ("NUM")=0 W *7,!!,"There are no entries to edit, you must first ADD an entry.",! K DIR S DIR(0)="E" D ^DIR K DIR Q
 S ABMX("EDIT")=""
 ;I $E(Y,2)>0&($E(Y,2)<(ABMZ("NUM")+1)) S Y=$E(Y,2) G E2  ;abm*2.6*32 CR10335
 I $E(Y,2,3)>0&($E(Y,2,3)<(ABMZ("NUM")+1)) S Y=$E(Y,2,3) G E2  ;abm*2.6*32 CR10335
 I ABMZ("NUM")=1 S Y=1 G E2
 K DIR S DIR(0)="NO^1:"_ABMZ("NUM")_":0"
 S DIR("?")="Enter the Sequence Number of "_ABMZ("ITEM")_" to Edit",DIR("A")="Sequence Number to EDIT"
 D ^DIR K DIR
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(+Y'>0)
E2 W !!!,"[",+Y,"]  ",$P(ABMZ(+Y),U) S ABMX("Y")=+Y
 I $P(ABMZ(+Y),U)="A0",$P($G(^DIC(40.7,ABMP("CLN"),0)),U,2)="A3" W !,"Please edit this value on page 3A1" H 1 K ABMZ("Y"),ABMZ("DR") Q
 ;only execute MOD2^ABMDEMLC if it is not a tran code entry (Chargemaster)
 S ABMZIEN=$O(^ICPT("BA",$P(ABMZ(ABMX("Y")),U)_" ",""))  ;initialize var; if they are using ChargeMaster it wasn't getting set and caused error  ;abm*2.6*29 CR10686
 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),$P(ABMZ(ABMX("Y")),U,2),0),U,17)'["|TC" D
 .I $D(ABMZ("MOD")),$P($G(^ABMDPARM(DUZ(2),1,2)),"^",5) D MOD2^ABMDEMLC S ABMZ("DR")=ABMZ("DR")_ABMZ("CHRG")_"////"_ABMZ("MODFEE")
 ;start old abm*2.6*33 CR12024
 ;I ABMZ("SUB")>20,ABMZ("SUB")<48,ABMZ("SUB")'=41,$G(ABMZIEN)'="",$D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",ABMZIEN)) D  ;abm*2.6*21 HEAT233742
 ;.;Q:$P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["5010"  ;only 5010 formats  ;abm*2.6*28 CR10648
 ;.I ($P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["5010")&(ABMP("EXP")'=35) Q  ;abm*2.6*28 CR10648
 ;.S ABMCNCK=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",ABMZIEN,0))
 ;end old abm*2.6*33 CR12024
 ;.;I ABMCNCK,$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMCNCK,0)),U,2)="Y" S ABMZ("DR")=ABMZ("DR")_";22"  ;abm*2.6*28 CR10648
 ;.;I ABMCNCK,$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMCNCK,0)),U,2)="Y" S ABMZ("DR")=ABMZ("DR")_";22CPT Narrative"  ;abm*2.6*28 CR10648
 ;.;I ABMCNCK,$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMCNCK,0)),U,3)="Y" S ABMZ("DR")=ABMZ("DR")_"//"_$P($$CPT^ABMCVAPI(ABMZIEN,ABMP("VDT")),U,3)  ;abm*2.6*28 CR10648  ;abm*2.6*33 CR12024
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 I $D(ABMZ("DIAG")) D DX^ABMDEMLC G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT) S ABMZ("DR")=ABMZ("DR")_ABMZ("DIAG")_"////"_$G(Y(0))
 I $D(ABMZ("NARR")),$P(ABMZ(ABMX("Y")),U,$P(ABMZ("NARR"),U,3)) D  ;abm*2.6*14 HEAT161263  ;abm*2.6*18 HEAT240919  uncommented line
 .S IENS=$P(ABMZ(ABMX("Y")),U,$P(ABMZ("NARR"),U,3))
 .S ABMX("DICB")=$$GET1^DIQ(9999999.27,IENS,".01","E")
 .D NARR^ABMDEMLC S ABMZ("DR")=ABMZ("DR")_$P(ABMZ("NARR"),U)_+Y
 ;end old abm*2.6*18 HEAT240919
 I $G(ABMZ("SUB"))=17&($P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,13)="Y")&(($E(ABMP("BTYP"),1,2)=11)!($E(ABMP("BTYP"),1,2)="12")) S ABMZ("DR")=ABMZ("DR")_";.05//"  ;abm*2.6*21 HEAT197195 edit POA
 ; don't do POS if page 5 (Dxs)
 I $G(ABMZ("SUB"))'=17 D
 .D POSA^ABMDEMLC  ;abm*2.6*9 NOHEAT  ;abm*2.6*10 IHS/SD/AML HEAT76189 - <<REACTIVATED LINE>> REMOVE DUPLICATE POS FIELD FROM 8G, ASKS FOR POS NOW
 .I ABMP("EXP")'=21,(ABMP("EXP")'=22),(ABMP("EXP")'=23) D TOSA^ABMDEMLC  ;don't do for 837 formats
 ;I $G(ABMZIEN)'="",((ABMZIEN>79999)&(ABMZIEN<90000))!($E($P($$CPT^ABMCVAPI(ABMZIEN,ABMP("VDT")),U,2))="G")!(ABMZIEN=36415) D  ;G0107 or Lab charges only  ;CSV-c  ;abm*2.6*8 HEAT40295  ;abm*2.6*29 CR10404
 ;start new abm*2.6*29 CR10404
 S ABMP("CLIAREQ")=0
 I (ABMZ("SUB")=37!(ABMZ("SUB")=43)) D CLIANUM^ABMDEMLB(ABMZIEN)
 I $G(ABMZIEN)'="",((ABMZIEN>79999)&(ABMZIEN<90000))!(ABMP("CLIAREQ")=1) D  ;lab charges or 3P Insurer 4 mult CLIA req'd
 .;end new abm*2.6*29 CR10404
 .S ABMXMOD=""
 .S DA=$P(ABMZ(ABMX("Y")),U,2)
 .I ABMZ("SUB")=43 F ABMMOD=5,8,9 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,0),U,ABMMOD)=90 S ABMXMOD=1
 .I ABMZ("SUB")=37 F ABMMOD=6,7,8 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,0),U,ABMMOD)=90 S ABMXMOD=1
 .I $G(ABMXMOD)'="" D
 ..S ABMODFLT=$S($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,0),U,14):$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,0),U,14),1:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,23))
 ..S ABMODFLT=$$GET1^DIQ(9002274.35,ABMODFLT,".01","E")  ;display ref lab by name, not IEN into ref lab file  ;abm*2.6*11 HEAT85498
 ..S ABMZ("DR")=ABMZ("DR")_";.13////@;.14//^S X=ABMODFLT"
 .E  S ABMZ("DR")=ABMZ("DR")_";.14////@;.13//"_$S($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,0),U,13):$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,0),U,13),1:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,22))
 I ABMZ("SUB")=37 D
 .Q:+$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),4,"B",ABMZIEN,0))=0
 .S ABMIIEN=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),4,"B",ABMZIEN,0))
 .Q:$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),4,ABMIIEN,0)),U,2)'="Y"
 .S:(ABMP("EXP")=22) ABMZ("DR")=ABMZ("DR")_";W !,!,""Enter LABORATORY Results:"";.19;.21"
 .S:(ABMP("EXP")=32) ABMZ("DR")=ABMZ("DR")_";W !,!,""Enter LABORATORY Results:"";.19;.21;.22"
 .S:(ABMP("EXP")=21) ABMZ("DR")=ABMZ("DR")_";W !,!,""Value Code 48 or 49 should be present on Page 9C"",!"
 ;I $D(ABMZ("REVN")) S ABMZ("DR")=ABMZ("DR")_$P(ABMZ("REVN"),"//")  ;abm*2.6*32 CR8942
 I $D(ABMZ("REVN")) D REVN^ABMDEML2  ;abm*2.6*32 CR8942
 I $D(ABMZ("CONTRACT")) D CONT^ABMDEMLB
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 I $D(ABMZ("OUTLAB")) D LAB^ABMDEMLB
 I $D(ABMZ("CHRG")) S ABMZ("DR")=ABMZ("DR")_ABMZ("CHRG")
 I $D(ABMZ("RX")),'$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,$P(ABMZ(ABMX("Y")),U,2),0),U,6) D
 .W !!,"Select PRESCRIPTION NUMBER: "
 .D RX^ABMDEMLB
 .I Y>0 S ABMZ("DR")=ABMZ("DR")_";.06////"_$P(Y(0),U) Q
 .W !,*7,"No match was found in the PRESCRIPTION FILE for this Drug and Patient!",!
 I ABMZ("SUB")=39 D 39^ABMDEML
 ;I ABMZ("SUB")=43 S ABMZ("DR")=ABMZ("DR")_";.19"  ;abm*2.6*23 IHS/SD/AML HEAT247169  ;abm*2.6*28 CR10551
 ;I "^27^43^"[("^"_ABMZ("SUB")_"^") S ABMZ("DR")=ABMZ("DR")_";.19"  ;abm*2.6*23 IHS/SD/AML HEAT247169  ;abm*2.6*28 CR10551  ;abm*2.6*33 CR12024
 I ABMZ("SUB")=43&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,4)="Y") S ABM("DR")=$S($G(ABM("DR")):ABM("DR")_";11;12;13;14",1:"11;12;13;14")
 S DA(1)=ABMP("CDFN"),DA=$P(ABMZ(ABMX("Y")),U,2),DIE="^ABMDCLM(DUZ(2),"_DA(1)_","_ABMZ("SUB")_",",DR=$E(ABMZ("DR"),2,200) D ^DIE K DR
 ;
 ;start new abm*2.6*33 CR12024
NDCCPTNA ;
 S ABMT("MED")="",ABM("NDC")=""
 I "^25^27^43^"[("^"_ABMZ("SUB")_"^") S DR=".19" D ^DIE  ;NDC
 I "^23^25^27^43^"[("^"_ABMZ("SUB")_"^") D  ;NDC is only on pages 8A, 8C, 8D, and 8H
 .S ABMT("MEDN")="<NO MED FOR NDC>"
 .I ABMZ("SUB")=23 S ABM("NDC")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,24)
 .I "^25^27^43^"[("^"_ABMZ("SUB")_"^") S ABM("NDC")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,0)),U,19)
 .I $G(ABM("NDC"))="" Q  ;no NDC
 .S ABM("NDC")=$O(^PSDRUG("ZNDC",$TR(ABM("NDC"),"-"),0))
 .I +$G(ABM("NDC"))'=0 S ABMT("MEDN")=$P($G(^PSDRUG(ABM("NDC"),0)),U)
 .W "  "_ABMT("MEDN")
 ;
 I ABMZ("SUB")>20,ABMZ("SUB")<48,ABMZ("SUB")'=41,$G(ABMZIEN)'="",$D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",ABMZIEN)) D
 .I ($P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["5010")&(ABMP("EXP")'=35)&(ABMP("EXP")'=28) Q  ;prompt for CPT narr for 5010s, 1500(02/12) and UB-04
 .S ABMCNCK=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",ABMZIEN,0))
 .I ABMCNCK D  ;CPT Narrative
 ..I $P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMCNCK,0)),U,3)="R" D
 ...S ABMT("MED")="",ABM("NDC")=""
 ...I "^23^25^27^43^"'[("^"_ABMZ("SUB")_"^") Q  ;NDC is only on pages 8A, 8C, 8D, and 8H - skip the rest
 ...I ABMZ("SUB")=23 S ABM("NDC")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0)),U,24)
 ...I "^25^27^43^"[("^"_ABMZ("SUB")_"^") S ABM("NDC")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,0)),U,19)
 ...I $G(ABM("NDC"))="" Q  ;no NDC
 ...S ABM("NDC")=$O(^PSDRUG("ZNDC",$TR(ABM("NDC"),"-"),0))
 ...I +$G(ABM("NDC"))'=0 D
 ....S ABMT("MED")=$P($G(^PSDRUG(ABM("NDC"),0)),U)
 ..I ($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMCNCK,0)),U,3)="C")!((($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMCNCK,0)),U,4)="Y")&($G(ABMT("MED"))=""))) D
 ...K ABMTDESC
 ...S ABMTDESC=$$CPTD^ABMCVAPI(ABMZIEN,"ABMTDESC",ABMP("VDT"))
 ...W !!,$P(ABMZ(ABMX("Y")),U)_" Long Description:"
 ...S ABMT("I")=0  F  S ABMT("I")=$O(ABMTDESC(ABMT("I"))) Q:'ABMT("I")  W !,$G(ABMTDESC(ABMT("I")))
 ...S ABMT("MED")=$P($$CPT^ABMCVAPI(ABMZIEN,ABMP("VDT")),U,3)
 ..;I "^C^R^"[("^"_$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMCNCK,0)),U,3)_"^") D
 ..I $P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMCNCK,0)),U,2)="Y" D
 ...S DR="22CPT Narrative"
 ...S DR=DR_"//"_$S($G(ABMT("MED"))'="":ABMT("MED"),1:"")
 ...D ^DIE
 ;end new abm*2.6*33 CR12024
 S DR=".17///M" D ^DIE
 ;I ABMZ("SUB")=21!(ABMZ("SUB")=27)!(ABMZ("SUB")=35)!(ABMZ("SUB")=37)!(ABMZ("SUB")=39)!(ABMZ("SUB")=43)!(ABMZ("SUB")=47) D  ;abm*2.6*28 CR10551
 ;
 ;start new abm*2.6*28 CR10551
 I ABMZ("SUB")=23!(ABMZ("SUB")=25)!(ABMZ("SUB")=27)!(ABMZ("SUB")=43) D
 .S ABMIMFG=0
 .S ABMTCPT=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),$P(ABMZ(ABMX("Y")),U,2),0)),U)
 .S ABMTCAT=$S($P($G(^ICPT(ABMTCPT,0)),U,3)'="":$P($G(^DIC(81.1,$P($G(^ICPT(ABMTCPT,0)),U,3),0)),U),1:"")
 .I (ABMTCAT["IMMUNIZATION")!(ABMTCAT["VACCINE") S ABMIMFG=1
 .;
 .;S ABMTDESC=$$CPTD^ICPTCOD(ABMZIEN,"ABMTCD","",ABMP("VDT")) ;cpt long desc ;abm*2.6*29 CR10686 ;abm*2.6*31 CR11624
 .S ABMTDESC=$$CPTD^ABMCVAPI($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),$P(ABMZ(ABMX("Y")),U,2),0)),U),"ABMTCD","",ABMP("VDT")) ;cpt long desc ;abm*2.6*29 CR10686 ;abm*2.6*31 CR11624
 .S ABMT=0
 .F  S ABMT=$O(ABMTCD(ABMT)) Q:'ABMT  D
 ..S ABMTDESC=$G(ABMTCD(ABMT))
 ..I (ABMTDESC["IMMUNIZATION")!(ABMTDESC["VACCINE") S ABMIMFG=1
 .;
 .I ABMIMFG=1 S DR="15//" D ^DIE  ;prompt for IMMUN LOT/BATCH#
 .I ABMIMFG=0 S DR="15////@" D ^DIE  ;delete it
 ;end new abm*2.6*28 CR10551
 ;
PROV ;
 S DA=$P(ABMZ(ABMX("Y")),U,2)
 I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,"P",0))>0 D
 .W !
 .S ABMIEN=0
 .F  S ABMIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,"P",ABMIEN)) Q:+ABMIEN=0  D
 ..W !?5,$P($G(^VA(200,$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,"P",ABMIEN,0)),U),0)),U)
 ..W ?40,$S($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,"P",ABMIEN,0)),U,2)="R":"RENDERING",$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA,"P",ABMIEN,0)),U,2)="D":"ORDERING",1:"")
 .W !
 K DIC,DR,DIE,DA
 S DA(2)=ABMP("CDFN")
 S DA(1)=$P(ABMZ(ABMX("Y")),U,2)
 S DIC="^ABMDCLM(DUZ(2),"_DA(2)_","_ABMZ("SUB")_","_DA(1)_",""P"","
 S DIC(0)="AELMQ"
 S ABMFLNM="9002274.30"_$G(ABMZ("SUB"))
 S DIC("P")=$P($G(^DD(ABMFLNM,.18,0)),U,2)
 Q:DIC("P")=""
 I $G(ABMDPRV)'="" S DIC("B")=ABMDPRV  ;abm*2.6*10
 S DIC("DR")=".01;.02//RENDERING"
 I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),DA(1),"P","C","R",0))>0 S DIC("DR")=".01;.02//ORDERING"
 D ^DIC
 K DIC,DR,DIE,DA
 I +Y>0,(+$P(Y,U,3)=0) D
 .K DIE,DA,DR
 .S DA(2)=ABMP("CDFN")
 .S DA(1)=$P(ABMZ(ABMX("Y")),U,2)
 .S DIE="^ABMDCLM(DUZ(2),"_DA(2)_","_ABMZ("SUB")_","_DA(1)_",""P"","
 .S DA=+Y
 .S DR=".01//;.02"
 .D ^DIE
 S ABMSIEN=ABMX("Y") D ORDDEA^ABMDE8D1  ;abm*2.6*37 ADO89299
 I $G(ABMP("EXP"))=14!($G(ABMP("EXP"))=22) D
 .S ABMPVCKR=0
 .S ABMPVCKD=0
 .S ABMTYP=""
 .S ABMLN=$P(ABMZ(ABMX("Y")),U,2)
 .F  S ABMTYP=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMLN,"P","C",ABMTYP)) Q:ABMTYP=""  D
 ..S ABMIEN=0
 ..F  S ABMIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMLN,"P","C",ABMTYP,ABMIEN)) Q:+ABMIEN=0  D
 ...I ABMTYP="R" S ABMPVCKR=+$G(ABMPVCKR)+1
 ...I ABMTYP="D" S ABMPVCKD=+$G(ABMPVCKD)+1
 .I ABMPVCKR>1!(ABMPVCKD>1) D  G PROV
 ..W !!,"YOU HAVE ENTERED TWO ",$S(ABMPVCKR>1:"RENDERING",1:"ORDERING")," PROVIDERS AND ONLY ONE CAN BE PUT ON AN 837P."
 ..K ABMPVCKR,ABMPVCKD,ABMTYP,ABMIEN,ABMLN
MILEAGE ;
 I ((ABMZ("SUB")=47)!(ABMZ("SUB")=43)),("^A0888^A0425^"[("^"_$P(ABMZ(ABMX("Y")),U))_"^") D
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DA=ABMP("CDFN")
 .S ABMIEN=$P(ABMZ(ABMX("Y")),U,2)
 .I $P(ABMZ(ABMX("Y")),U)="A0425" D
 ..S DR=".128////"_$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMIEN,0)),U,3)
 .I $P(ABMZ(ABMX("Y")),U)="A0888" D
 ..S DR=".129////"_$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMIEN,0)),U,3)
 .D ^DIE
 ;
XIT K ABMX
 Q
