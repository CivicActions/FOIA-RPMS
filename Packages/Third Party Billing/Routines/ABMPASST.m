ABMPASST ;IHS/SD/SDR - Tool to test data being passed to A/R;    
 ;;2.6;IHS 3P BILLING SYSTEM;**33,34**;NOV 12, 2009;Build 645
 ;Original;SDR; added in abm*2.6*33 ADO60197 Displays array of data sent to A/R
 ;IHS/SD/SDR 2.6*34 ADO60694 CR7384 Added DRG to display
 ;
 ;this routine is a tool for testing the ABMAPASS routine.  Data will be in the array
 ;that won't be captured in A/R yet, not until A/R is patched.
 ;
 K ABMA
 K ABMP
 ;
 W $$EN^ABMVDF("IOF")
 W !!,"This purpose of this routine is to let you see the data that is being sent to"
 W !,"A/R when an A/R Bill is being created.  It only works on bills that have"
 W !,"already been approved because it is using the data from the 3P Bill to"
 W !,"generate the list."
 W !!,"You will be prompted for a claim or patient, and then shown what crossed"
 W !,"over to A/R.  Note: At this time not all the data is being captured on"
 W !,"the A/R bill."
 W ! S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 Q:$D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)
 ;
 W $$EN^ABMVDF("IOF")
 W !!,"The first section of data will be listed by field number and name.  This section"
 W !,"is 'general' information that applies to the whole bill."
 W !!,"The second section could have multiple entries for each (i.e., visits, insurers,"
 W !,"service lines, etc.).  This uses the variable names that are used in the"
 W !,"^TMP($J,""ABMPASS"" global that contains the data sent to A/R.  Because some of"
 W !,"the names are a little cryptic they will be listed on the next screen with"
 W !,"what they mean."
 ;
 W !!,"Both of these sections will have 3 columns."
 W !,"Column 1 is the field/variable name."
 W !,"Column 2 is the actual data being sent to A/R."
 W !,"Column 3 is the data from column 2 formatted (i.e., dates are in a readable"
 W !,"format, pointers are resolved, sets of codes, etc.)."
 W ! S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 Q:$D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)
 ;
 W !!,"INM    = Insurer Name"
 W !,"CTYP   = Coverage Type"
 W !,"RINM   = Replacement Insurer Name"
 W !,"BLSRV  = Billable Service"
 W !?10,"the multiple name it came from (for example, page8A charges would"
 W !?10,"say 'MEDICAL PROCEDURES', page8B would say 'MED/SURG PROCEDURES',"
 W !?10," etc.)"
 W !,"ITCODE = Revenue Code (it will be '0' if there's no revenue code)"
 W !,"ITNM   = Item Name as related to the service line"
 W !?10,"could be the CPT description, the drug name, etc., as related"
 W !?10,"to what the service line is"
 W !,"ITQT   = Item Quantity"
 W !,"ITTOT  = Item Total"
 W !,"ITUC   = Item Unit Cost"
 W !,"LICN   = Line Item Control Number"
 W !,"OTUC   = Dispensing Fee (Pharmacy only)"
 W !,"TSTTYP = Test type (Labs only)"
 W !,"TSTR   = Test result (Labs only)"
 W !
 W !,"GCN   = Group Control Number (when exporting/re-exporting bills)"
 W !,"RSN   = Reason for Recreate/Resend of 837 batch"
 W ! S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 Q:$D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)
 ;
 D ^ABMDBDIC  ;returns ABMP("BDFN") and ABMP("PDFN")
 I +$G(ABMP("BDFN"))=0 D  Q
 .W !," <NOTHING SELECTED> "
 W !
 S ABMF=0
 S DIR(0)="S^A:All;P:Populated Only"
 S DIR("A")="What fields do you want to display?"
 D ^DIR
 Q:$D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)
 I Y="A" S ABMF=1
 W !!,"Consider turning on session logging because the data will be written to"
 W !,"the screen and it could be a lot, depending on how much information is on"
 W !,"the 3P Bill."
 W ! S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 Q:$D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)
 ;
 S DA=ABMP("BDFN")
 S ABMREX("BDFN")=ABMP("BDFN")
 S X=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,4)
 S ABMP("BTYP")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,2)
 S ABMP("EXP")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,6)
 S ABMP("VTYP")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,7)
 D BLD^ABMAPASS
 S ABMTAB=37,ABMTAB2=57,ABMLNGTH=23
 W !!,"IEN to 3P BILL file",?ABMTAB,ABMA("BLDA")
 W !,"Insurer priority or cancelled status ",?ABMTAB,ABMA("ACTION")_" "_$S(ABMA("ACTION")=1:"Primary",ABMA("ACTION")=2:"Secondary",ABMA("ACTION")=3:"Tertiary",1:"Cancelled Status")
 ;     value  1 = Primary Insurer
 ;     value  2 = Secondary Insurer
 ;     value  3 = Tertiary Insurer
 ;     value 99 = Cancelled Status
 W !,".01 Bill#(Bill#-suffix-HRN)",?ABMTAB,ABMA("BLNM")
 W !,".02 Bill Type",?ABMTAB,ABMA("BTYP")
 W !,".03 Visit location",?ABMTAB,ABMA("VSLC"),?ABMTAB2,$P($G(^AUTTLOC(ABMA("VSLC"),0)),U,2)
 W !,".05 Patient (Pointer)",?ABMTAB,ABMA("PTNM"),?ABMTAB2,$E($P($G(^DPT(ABMA("PTNM"),0)),U),1,ABMLNGTH)
 W !,".06 Export Mode",?ABMTAB,ABMA("EXP"),?ABMTAB2,$E($P($G(^ABMDEXP(ABMA("EXP"),0)),U),1,ABMLNGTH)
 W !,".07 Visit Type",?ABMTAB,ABMA("VSTP"),?ABMTAB2,$E($P($G(^ABMDVTYP(ABMA("VSTP"),0)),U),1,ABMLNGTH)
 W !,".08 Active Insurer",?ABMTAB,ABMA("INS"),?ABMTAB2,$E($P($G(^AUTNINS(ABMA("INS"),0)),U),1,ABMLNGTH)
 ;
 W !,".09 Procedure Coding Method",?ABMTAB,ABMA("PROCD")
 W:($G(ABMA("PROCD"))'="")!ABMF ?ABMTAB2,$S(ABMA("PROCD")="C":"CPT",ABMA("PROCD")="I":"ICD",ABMA("PROCD")="A":"ADA",1:"")
 W:($G(ABMA("MNSPLT"))'="")!ABMF !,".022 Manual, Split Claim",?ABMTAB,ABMA("MNSPLT")
 W:+$G(ABMA("MNSPLT"))'="" ?ABMTAB2,$S(ABMA("MNSPLT")="A":"AUTO-SPLIT",ABMA("MNSPLT")="S":"SPLIT (MANUAL)",ABMA("MNSPLT")="O":"ORIGINAL",1:"")
 W !,".1  Clinic",?ABMTAB,ABMA("CLNC"),?ABMTAB2,$E($P($G(^DIC(40.7,ABMA("CLNC"),0)),U),1,ABMLNGTH)
 W:ABMA("MTAXID")!ABMF !,".114 Master Tax ID",?ABMTAB,ABMA("MTAXID")
 ;
 W:ABMA("TPRTTYP")!ABMF !,".1212 Type of Transport",?ABMTAB,ABMA("TPRTTYP")
 W:($G(ABMA("TPRTTYP"))'="") ?ABMTAB2,$S(ABMA("TPRTTYP")="I":"INITIAL",ABMA("TPRTTYP")="R":"RETURN",ABMA("TPRTTYP")="T":"TRANSFER",ABMA("TPRTTYP")="X":"ROUND",1:"")_" TRIP"
 W:ABMA("TRPTTF")!ABMF !,".1213 Transported To/For",?ABMTAB,ABMA("TRPTTF")
 I $G(ABMA("TRPTTF"))'="" D
 .I ABMA("TRPTTF")="A" S ABMD="NEAREST FACILITY FOR CARE OF SYMPTOMS,COMPLAINTS, OR BOTH"
 .I ABMA("TRPTTF")="B" S ABMD="BENEFIT OF PREFERRED PHYSICIAN"
 .I ABMA("TRPTTF")="C" S ABMD="NEARNESS OF FAMILY MEMBERS"
 .I ABMA("TRPTTF")="D" S ABMD="CARE OF SPECIALIST OR AVAILABILITY OF SPECIALIZED EQUIPMENT"
 .I ABMA("TRPTTF")="E" S ABMD="TRANS. TO REHAB FACILITY"
 .W ?ABMTAB2,$E(ABMD,1,ABMLNGTH)
 ;
 W:ABMA("POPMOD")!ABMF !,".1214 Point of Pickup Modifier",?ABMTAB,ABMA("POPMOD")
 I $G(ABMA("POPMOD"))'="" D
 .W ?ABMTAB2
 .I ABMA("POPMOD")="D" W "DIAG/THERA/FREE FAC"
 .I ABMA("POPMOD")="E" W "RES/DOM/CUST. FAC"
 .I ABMA("POPMOD")="G" W "HOSP-BASED DIAL FAC"
 .I ABMA("POPMOD")="H" W "HOSPITAL"
 .I ABMA("POPMOD")="I" W "TRANS SITE (AIRPORT, ETC)"
 .I ABMA("POPMOD")="J" W "NON-HOSP-BASED DIAL FAC"
 .I ABMA("POPMOD")="N" W "SNF"
 .I ABMA("POPMOD")="P" W "PHYS OFFICE"
 .I ABMA("POPMOD")="R" W "RESIDENCE"
 .I ABMA("POPMOD")="S" W "SCENE OF ACCIDENT"
 .I ABMA("POPMOD")="X" W "INTER. STOP AT PHYS OFFICE"
 W:ABMA("MNECIND")!ABMF !,".1215 Medical Necessity Indicator",?ABMTAB,ABMA("MNECIND")
 W:(+$G(ABMA("MNECIND"))'="") ?ABMTAB2,$S(ABMA("MNECIND")="Y":"YES",1:"")
 W:ABMA("DESTMOD")!ABMF !,".1216 Dest Modifier",?ABMTAB,ABMA("DESTMOD")
 I ($G(ABMA("DESTMOD"))'="") D
 .W ?ABMTAB2
 .I ABMA("DESTMOD")="E" W "RES/DOM/CUST. FAC"
 .I ABMA("DESTMOD")="G" W "HOSP-BASED DIAL FAC"
 .I ABMA("DESTMOD")="H" W "HOSPITAL"
 .I ABMA("DESTMOD")="I" W "TRANS SITE (AIRPORT, ETC)"
 .I ABMA("DESTMOD")="J" W "NON-HOSP-BASED DIAL FAC"
 .I ABMA("DESTMOD")="N" W "SNF"
 .I ABMA("DESTMOD")="P" W "PHYS OFFICE"
 .I ABMA("DESTMOD")="R" W "RESIDENCE"
 .I ABMA("DESTMOD")="S" W "SCENE OF ACCIDENT"
 .I ABMA("DESTMOD")="X" W "INTER. STOP AT PHYS OFFICE"
 W:ABMA("POPORG")!ABMF !,".122 Point of Pickup Origin",?ABMTAB,ABMA("POPORG")
 W:ABMA("POPADDR")!ABMF !,".123 Point of Pickup Address",?ABMTAB,ABMA("POPADDR")
 W:ABMA("POPCTY")!ABMF !,".124 Point of Pickup City",?ABMTAB,ABMA("POPCTY")
 W:ABMA("POPST")!ABMF !,".125 Point of Pickup State",?ABMTAB,ABMA("POPST")
 I (+$G(ABMA("POPST"))'=0) W ?ABMTAB2,$P($G(^DIC(5,ABMA("POPST"),0)),U)
 W:ABMA("POPZIP")!ABMF !,".126 Point of Pickup Zip",?ABMTAB,ABMA("POPZIP")
 W:ABMA("DEST")!ABMF !,".127 Destination",?ABMTAB,ABMA("DEST")
 I ($G(ABMA("DEST"))'="") D
 .W ?ABMTAB2
 .I ABMA("DEST")["AUTTLOC" W $P($G(^AUTTLOC(+ABMA("DEST"),0)),U,2)
 .I ABMA("DEST")["AUPNPAT" W "PATIENT'S HOME"
 .I ABMA("DEST")["AUTTVNDR" W $P($G(^AUTTVNDR(+ABMA("DEST"),0)),U)
 W:ABMA("COVMI")!ABMF !,".128 Coverage Mileage",?ABMTAB,ABMA("COVMI")
 W:ABMA("NCOVMI")!ABMF !,".129 Non-Coverage Mileage",?ABMTAB,ABMA("NCOVMI")
 ;
 W !,".14 Approving Official",?ABMTAB,ABMA("APPR"),?ABMTAB2,$E($P($G(^VA(200,ABMA("APPR"),0)),U),1,ABMLNGTH)
 W:ABMA("DTAP")!ABMF !,".15 Date/Time Approved",?ABMTAB,ABMA("DTAP"),?ABMTAB2,$$BDT^ABMDUTL(ABMA("DTAP"))
 W:ABMA("DTBILL")!ABMF !,".17 Export number",?ABMTAB,ABMA("DTBILL"),?ABMTAB2,$$BDT^ABMDUTL(ABMA("DTBILL"))
 W:ABMA("BLAMT")!ABMF !,".21 Bill Amount",?ABMTAB,ABMA("BLAMT")
 W:ABMA("OBLAMT")!ABMF !,".27 Original Bill Amount",?ABMTAB,ABMA("OBLAMT")
 W:ABMA("FRATE")!ABMF !,".28 Flat Rate Amount",?ABMTAB,ABMA("FRATE")
 W:ABMA("LICN")!ABMF !,".29 Line Item Control# - Flat Rate",?ABMTAB,ABMA("LICN")
 W:ABMA("FRCPT")!ABMF !,".31 Flat Rate CPT",?ABMTAB,ABMA("FRCPT"),?ABMTAB2
 I +$G(ABMA("FRCPT"))'=0 W $P($G(^ICPT(ABMA("FRCPT"),0)),U)
 W:ABMA("FRREV")!ABMF !,".32 Flat Rate Rev Code",?ABMTAB,ABMA("FRREV"),?ABMTAB2
 I +$G(ABMA("FRREV"))'=0 W $P($G(^AUTTREVN(ABMA("FRREV"),0)),U)
 W:((ABMA("FRREVD")'="")!(ABMF)) !,".33 Flat Rate Rev Description",?ABMTAB,ABMA("FRREVD")
 ;
 W:ABMA("XRAYS")!ABMF !,".43 Number X-Rays Included",?ABMTAB,ABMA("XRAYS")
 W:ABMA("ORTHOR")!ABMF !,".44 Orthodontic Related",?ABMTAB,ABMA("ORTHOR")
 W:(+$G(ABMA("ORTHOR"))'=0) ?ABMTAB2,$S(ABMA("ORTHOR")=1:"YES",ABMA("ORTHOR")=0:"NO",1:"")
 W:ABMA("ORTHPDT")!ABMF !,".45 Orthodontic Placement Date",?ABMTAB,ABMA("ORTHPDT")
 W:(+$G(ABMA("ORTHPDT"))'=0) ?ABMTAB2,$$BDT^ABMDUTL(ABMA("ORTHPDT"))
 W:ABMA("PROINC")!ABMF !,".46 Prothesis Included",?ABMTAB,ABMA("PROINC")
 W:(+$G(ABMA("PROINC"))'=0) ?ABMTAB2,$S(ABMA("PROINC")=1:"YES",ABMA("PROINC")=0:"NO",1:"")
 W:ABMA("PRIPDT")!ABMF !,".47 Prior Placement Date",?ABMTAB,ABMA("PRIPDT")
 W:(+$G(ABMA("PRIPDT"))'=0) ?ABMTAB2,$$BDT^ABMDUTL(ABMA("PRIPDT"))
 W:ABMA("CASE#")!ABMF !,".48 Case Number",?ABMTAB,ABMA("CASE#")
 W:ABMA("RESUB#")!ABMF !,".49 Resubmission (Control) Number",?ABMTAB,ABMA("RESUB#")
 W:ABMA("ADMTYP")!ABMF !,".51 Admit Type",?ABMTAB,ABMA("ADMTYP")
 W:(+$G(ABMA("ADMTYP"))'=0) ?ABMTAB2,$P($G(^ABMDCODE(ABMA("ADMTYP"),0)),U,3)
 W:ABMA("REF#")!ABMF !,".511 Referral Number",?ABMTAB,ABMA("REF#")
 W:ABMA("PRIAUTH")!ABMF !,".512 Prior Authorization Number",?ABMTAB,ABMA("PRIAUTH")
 W:ABMA("DRG")!ABMF !,".513 DRG",?ABMTAB,ABMA("DRG") ;abm*2.6*34 IHS/SD/SDR ADO60694
 W:ABMA("ADMSRC")!ABMF !,".52 Admission Source/Newborn Code",?ABMTAB,ABMA("ADMSRC")
 W:(+$G(ABMA("ADMSRC"))'=0) ?ABMTAB2,$E($P($G(^ABMDCODE(ABMA("ADMSRC"),0)),U,3),1,ABMLNGTH)
 W:ABMA("NWBNDYS")!ABMF !,".525 Newborn Days",?ABMTAB,ABMA("NWBNDYS")
 ;
 W:ABMA("DSCHST")!ABMF !,".53 Discharge Status",?ABMTAB,ABMA("DSCHST")
 W:(+$G(ABMA("DSCHST"))'=0) ?ABMTAB2,$E($P($G(^ABMDCODE(ABMA("DSCHST"),0)),U,3),1,ABMLNGTH)
 W:ABMA("PSRO")!ABMF !,".54 PSRO Approval Code",?ABMTAB,ABMA("PSRO")
 W:(+$G(ABMA("PSRO"))'=0) ?ABMTAB2,$P($G(^ABMDCODE(ABMA("PSRO"),0)),U,3)
 W:ABMA("ADMTDX")!ABMF !,".59 Admitting Diagnosis",?ABMTAB,ABMA("ADMTDX")
 W:(+$G(ABMA("ADMTDX"))'=0) ?ABMTAB2,$P($G(^ICD9(ABMA("ADMTDX"),0)),U)
 ;
 W:ABMA("ADT")!ABMF !,".61 Admission Date",?ABMTAB,ABMA("ADT"),?ABMTAB2,$$BDT^ABMDUTL(ABMA("ADT"))
 W:ABMA("AHR")!ABMF !,".62 Admission Hour",?ABMTAB,ABMA("AHR")
 W:ABMA("DDT")!ABMF !,".63 Discharge Date",?ABMTAB,ABMA("DDT"),?ABMTAB2,$$BDT^ABMDUTL(ABMA("DDT"))
 W:ABMA("DHR")!ABMF !,".64 Discharge Hour",?ABMTAB,ABMA("DHR")
 W:ABMA("NCDAYS")!ABMF !,".66 Non-Covered Days",?ABMTAB,ABMA("NCDAYS")
 ;
 W !,".71 Service Date From",?ABMTAB,ABMA("DOSB"),?ABMTAB2,$$SDT^ABMDUTL(ABMA("DOSB"))
 W:ABMA("ROIDT")!ABMF !,".711 Release of Information Date",?ABMTAB,ABMA("ROIDT")
 W:(+$G(ABMA("ROIDT"))'=0) ?ABMTAB2,$$BDT^ABMDUTL(ABMA("ROIDT"))
 W:ABMA("AOBDT")!ABMF !,".712 Assignment of Benefits Date",?ABMTAB,ABMA("AOBDT")
 W:(+$G(ABMA("AOBDT"))'=0) ?ABMTAB2,$$BDT^ABMDUTL(ABMA("AOBDT"))
 ;
 W:($G(ABMA("PROCN"))'="")!ABMF !,".713 Property/Casualty Claim Number",?ABMTAB,ABMA("PROCN")
 W:ABMA("HVRXDT")!ABMF !,".714 Hearing/Vision RX Date",?ABMTAB,ABMA("HVRXDT")
 W:(+$G(ABMA("HVRXDT"))'=0) ?ABMTAB2,$$BDT^ABMDUTL(ABMA("HVRXDT"))
 W:ABMA("DISASDT")!ABMF !,".715 Start Disability Date",?ABMTAB,ABMA("DISASDT")
 W:(+$G(ABMA("DISASDT"))'=0) ?ABMTAB2,$$BDT^ABMDUTL(ABMA("DISASDT"))
 W:ABMA("DISAEDT")!ABMF !,".716 End Disability Date",?ABMTAB,ABMA("DISAEDT")
 W:(+$G(ABMA("DISAEDT"))'=0) ?ABMTAB2,$$BDT^ABMDUTL(ABMA("DISAEDT"))
 ;
 D ^ABMPAST2  ;this does all the multiples
 K ^TMP($J,"ABMPASS")
 K ABMA
 Q
