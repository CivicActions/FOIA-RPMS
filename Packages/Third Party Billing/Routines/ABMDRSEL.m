ABMDRSEL ; IHS/SD/SDR - Selective Report Parameters ;
 ;;2.6;IHS 3P BILLING SYSTEM;**3,4,14,21,31,32,33,37**;NOV 12, 2009;Build 739
 ;Original;TMD;07/14/95 12:23 PM
 ;
 ;IHS/SD/SDR 2.5*8 Added code for cancelling official
 ;IHS/SD/SDR,TPF 2.5*8 Added code for pending status (12)
 ;IHS/SD/SDR 2.5*10 IM20566 Fix for <UNDEF>PRINT+13^ABMDRST1
 ;
 ;IHS/SD/SDR 2.6*4 NO HEAT Fixed closed/exported dates
 ;IHS/SD/SDR 2.6*14 ICD10 009 Added code for ICD-10 prompts
 ;IHS/SD/SDR 2.6*14 HEAT165197 (CR3109) Made it so a range of alphanumeric codes can be selected.
 ;IHS/SD/SDR 2.6*21 HEAT186137 Fixed pending report so user can select all visit types and still pick specific reasons
 ;IHS/SD/SDR 2.6*21 HEAT241429 Added code to not ask ELIGIBILITY STATUS
 ;IHS/SD/SDR 2.6*31 CR11834 Added code for pended dates; Made corrections for pended so it isn't mistaken for payment
 ;IHS/SD/SDR 2.6*32 CR11501 Added BILLING TECHNICIAN and ACTIVITY DATE for new employee productivity report
 ;IHS/SD/SRD 2.6*33 ADO60185 CR12178 Added preferred name is patient selected for billing entity
 ;IHS/SD/SDR 2.6*37 ADO81491 Updated preferred name PPN to use XPAR site parameter
 ;
 K DIC,DIR,ABMY
 S U="^"
 S ABMY("X")="W $$SDT^ABMDUTL(X)"
 I $D(ABM("EMPP"))  S ABMY("X")="W $$CDT^ABMDUTL(X)"  ;abm*2.6*32 IHS/SD/SDR CR11501
 I $D(ABM("APPR")) S ABMY("APPR")=ABM("APPR")
 I $D(ABM("CANC")) S ABMY("CANC")=ABM("CANC")
 I $D(ABM("CLOS")) S ABMY("CLOS")=ABM("CLOS")  ;Closed
 I $D(ABM("BILLT")) M ABMY("BILLT")=ABM("BILLT")  ;abm*2.6*32 IHS/SD/SDR CR11501 billing tech
 I $D(ABM("OVER-DUE")) D
 .S ABMY("DT")="X"
 .I ABM("OVER-DUE")=2 D  Q
 ..S ABMY("DT")=""  ;abm*2.6*3 NOHEAT
 ..S ABMY("DT",1)=$E(DT,1,5)_"01"
 ..S ABMY("DT",2)=DT
 .I ABM("OVER-DUE")=3 D  Q
 ..S ABMY("DT",1)=$S($E(DT,4,5)>10:$E(DT,1,3)_1001,1:($E(DT,1,3)-1)_1001)
 ..S ABMY("DT",2)=DT
 .S X1=DT
 .S X2=-30
 .D C^%DTC
 .S ABMY("DT",2)=X
 .S X1=DT
 .S X2=-330
 .D C^%DTC
 .S ABMY("DT",1)=X
 .Q
 ;
LOOP ;
 ; Display current exclusion parameters
 G XIT:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 W !!?3,"EXCLUSION PARAMETERS Currently in Effect for RESTRICTING the EXPORT to:",!?3,"======================================================================="
 I $D(ABMY("LOC")) W !?3,"- Visit Location.....: ",$P(^DIC(4,ABMY("LOC"),0),U)
 I $D(ABMY("INS")) W !?3,"- Billing Entity.....: ",$P(^AUTNINS(ABMY("INS"),0),U)
 ;I $D(ABMY("PAT")) W !?3,"- Billing Entity.....: ",$P(^DPT(ABMY("PAT"),0),U)  ;abm*2.6*33 IHS/SD/SDR ADO60185
 ;start new abm*2.6*33 IHS/SD/SDR ADO60185
 I $D(ABMY("PAT")) D
 .W !?3,"- Billing Entity.....: ",$P(^DPT(ABMY("PAT"),0),U)
 .;I $$GETPREF^AUPNSOGI(ABMY("PAT"),"")'="" D  ;abm*2.6*37 IHS/SD/SDR ADO81491
 .I $$GETPREF^AUPNSOGI(ABMY("PAT"),"I",1)'="" D  ;abm*2.6*37 IHS/SD/SDR ADO81491
 ..;W "* - ",$$GETPREF^AUPNSOGI(ABMY("PAT"),"")  ;abm*2.6*37 IHS/SD/SDR ADO81491
 ..W " - ",$$GETPREF^AUPNSOGI(ABMY("PAT"),"I",1)_"*"  ;abm*2.6*37 IHS/SD/SDR ADO81491
 ;end new abm*2.6*33 IHS/SD/SDR ADO60185
 I $D(ABMY("TYP")) W !?3,"- Billing Entity.....: ",ABMY("TYP","NM")
 I $D(ABMY("DT")) D
 .;start old code abm*2.6*4 NOHEAT
 .;W !?3,"- ",$S(ABMY("DT")="A":"Approval Dates from: ",ABMY("DT")="V":"Visit Dates from...: ",ABMY("DT")="P":"Payment Dates from.: ",ABMY("DT")="C":"Cancellation Dates from:",ABMY("DT")="X":"Closed Dates from:",1:"Export Dates from..: ")
 .;end old code start new code NOHEAT
 .;start old abm*2.6*31 IHS/SD/SDR CR11834
 .;W !?3,"- ",$S(ABMY("DT")="A":"Approval Dates from: ",ABMY("DT")="V":"Visit Dates from...: ",ABMY("DT")="P":"Payment Dates from.: ",ABMY("DT")="C":"Cancellation Dates from:",ABMY("DT")="M":"Closed Dates from:",1:"Export Dates from..: ")
 .;end old abm*2.6*31 IHS/SD/SDR CR11834
 .;end new code NOHEAT
 .;start new abm*2.6*31 IHS/SD/SDR CR11834
 .W !?3,"- "
 .I ABMY("DT")="A" W "Approval Dates from: "
 .I ABMY("DT")="V" W "Visit Dates from...: "
 .I ABMY("DT")="P" W "Payment Dates from.: "
 .I ABMY("DT")="C" W "Cancellation Dates from: "
 .I ABMY("DT")="M" W "Closed Dates from: "
 .I ABMY("DT")="H" W "Pended Dates from: "
 .I ABMY("DT")="T" W "Activity Dates from: "  ;abm*2.6*32 IHS/SD/SDR CR11501
 .;I ("^A^V^P^C^M^H^"'[("^"_ABMY("DT")_"^")) W "Export Dates from..: "  ;abm*2.6*32 IHS/SD/SDR CR11501
 .I ("^A^V^P^C^M^H^T^"'[("^"_ABMY("DT")_"^")) W "Export Dates from..: "  ;abm*2.6*32 IHS/SD/SDR CR11501
 ;end new abm*2.6*31 IHS/SD/SDR CR11834
 I  S X=ABMY("DT",1) X ABMY("X") W "  to: " S X=ABMY("DT",2) X ABMY("X")
 ;start new abm*2.6*32 IHS/SD/SDR CR11501
 I $G(ABMY("DT"))="T" D
 .I ($G(ABMY("DT",2))'[".") I $G(ABMY("DT",2))>DT W " - FUTURE date entered"
 .I ($G(ABMY("DT",2))[".") I $G(ABMY("DT",2))>$$NOW^XLFDT W " - FUTURE date entered"
 ;end new abm*2.6*32 IHS/SD/SDR CR11501
 I $G(ABMY("STATUS UPDATER"))'="" W !?3,"- Status Updater.....: ",$P($G(^VA(200,$G(ABMY("STATUS UPDATER")),0)),U)
 I $D(ABMY("APPR")) W !?3,"- Approving Official.: ",$P(^VA(200,ABMY("APPR"),0),U)
 I $D(ABMY("CANC")) W !?3,"- Cancelling Official.: ",$P(^VA(200,ABMY("CANC"),0),U)
 I $D(ABMY("CLOS")) W !?3,"- Closing Official.: ",$P(^VA(200,ABMY("CLOS"),0),U)  ;Closing
 ;start new abm*2.6*32 IHS/SD/SDR CR11501
 I $D(ABMY("NOTPOS")) W !?3,"- Billing Technician.: All billing staff"
 I $D(ABMY("POSONLY")) W !?3,"- Billing Technician.: All POS staff"
 I $D(ABMY("BOTHPOS")) W !?3,"- Billing Technician.: Both billing and POS staff"
 I $D(ABMY("BILLT")) D
 .S ABMA=0,ABMB=0
 .F  S ABMA=$O(ABMY("BILLT",ABMA)) Q:'ABMA  D
 ..I ABMB=0 W !?3,"- Billing Technician.: "
 ..E  W !?26
 ..W $P(^VA(200,ABMA,0),U)
 ..S ABMB=1
 ;end new abm*2.6*32 IHS/SD/SDR CR11501
 I $D(ABM("STA")) W !?3,"- Claim Status.......: ",ABM("STA","NM")
 I $D(ABMY("PRV")) W !?3,"- Provider...........: ",$P(^VA(200,ABMY("PRV"),0),U)
 I $G(ABMY("PTYP")) W !?3,"- Eligibility Status.: ",ABMY("PTYP","NM")
 ;I $D(ABMY("DX")) W !?3,"- Diagnosis Code from: ",ABMY("DX",1),"  to: ",ABMY("DX",2),"  (",$S($D(ABMY("DX","ALL")):"Check All Diagnosis",1:"Primary Diagnosis Only"),")"  ;abm*2.6*14 ICD10 009
 I $D(ABMY("DX",1)) W !?3,"- Diagnosis (ICD-9) Code from: ",ABM("DX",1),"  to: ",ABM("DX",2),"  (",$S($D(ABMY("DX","ALL")):"Check All Diagnosis",1:"Primary Diagnosis Only"),")"  ;abm*2.6*14 ICD10 009 and HEAT165197 (CR3109)
 I $D(ABMY("DX",3)) W !?3,"- Diagnosis (ICD-10) Code from: ",ABM("DX",3),"  to: ",ABM("DX",4),"  (",$S($D(ABMY("DX10","ALL")):"Check All Diagnosis",1:"Primary Diagnosis Only"),")"  ;abm*2.6*14 ICD10 009 and HEAT165197 (CR3109)
 I $D(ABMY("PX")) W !?3,"- CPT Range from.....: ",ABMY("PX",1),"  to: ",ABMY("PX",2)
 I $G(ABM("RTYP")) W !?3,"- Report Type........: ",ABM("RTYP","NM")
 I $G(ABM("RTYP","NM"))["VALIDATOR" W !?20,ABMPATH_ABMFN  ;abm*2.6*32 IHS/SD/SDR CR11501
 I $G(ABM("RFOR")) W !?3,"- Output Type........: ",ABM("RFOR","NM")  ;abm*2.6*21 IHS/SD/SDR HEAT241429
 I (+$G(ABM("RFOR"))=2) W !,?7,"Write file to ",ABM("RPATH")_ABM("RFN")  ;abm*2.6*21 IHS/SD/SDR HEAT241429
 ;
PARM ;
 ; Choose additional exclusion parameters
 K DIR
 S DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:DATE RANGE;4:"
 ;S DIR(0)=DIR(0)_$S($D(ABM("CANC")):"CANCELLING OFFICIAL",$D(ABM("CLOS")):"CLOSING OFFICIAL",($G(ABM("STA"))'="")&($G(ABM("STA"))'="P"):"CLAIM STATUS",$G(ABM("STA"))="P":"STATUS UPDATER",1:"APPROVING OFFICIAL")  ;abm*2.6*31 IHS/SD/SDR CR11834
 ;start old abm*2.6*32 IHS/SD/SDR CR11501
 ;S DIR(0)=DIR(0)_$S($D(ABM("CANC")):"CANCELLING OFFICIAL",$D(ABM("CLOS")):"CLOSING OFFICIAL",($G(ABM("STA"))'="")&($G(ABM("STA"))'="H"):"CLAIM STATUS",$G(ABM("STA"))="H":"STATUS UPDATER",1:"APPROVING OFFICIAL")
 ;end old abm*2.6*32 IHS/SD/SDR CR11501
 ;start new abm*2.6*32 IHS/SD/SDR CR11501
 S ABM0=$S($D(ABM("CANC")):"CANCELLING OFFICIAL",$D(ABM("CLOS")):"CLOSING OFFICIAL",$D(ABM("BILLT")):"BILLING TECHNICIAN",($G(ABM("STA"))'="")&($G(ABM("STA"))'="H"):"CLAIM STATUS",$G(ABM("STA"))="H":"STATUS UPDATER",1:"APPROVING OFFICIAL")
 S DIR(0)=DIR(0)_ABM0
 ;end new abm*2.6*32 IHS/SD/SDR CR11501
 ;S DIR(0)=DIR(0)_";5:PROVIDER;6:ELIGIBILITY STATUS"  ;abm*2.6*21 IHS/SD/SDR HEAT241429
 S DIR(0)=DIR(0)_";5:PROVIDER"_$S($D(ABM("NOSTAT")):"",1:";6:ELIGIBILITY STATUS")  ;abm*2.6*21 IHS/SD/SDR HEAT241429
 S DIR(0)=DIR(0)_$S($D(ABM("RFOR")):";6:OUTPUT TYPE",1:"")  ;abm*2.6*21 IHS/SD/SDR HEAT241429
 I '$D(ABM("NODX")) S DIR(0)=DIR(0)_";7:DIAGNOSIS RANGE;8:CPT RANGE"
 I $G(ABM("RTYP")) S DIR(0)=DIR(0)_";"_$S($D(ABM("NODX")):7,1:9)_":REPORT TYPE"
 S DIR("A")="Select ONE or MORE of the above EXCLUSION PARAMETERS"
 S DIR("?")="The report can be restricted to one or more of the listed parameters. A parameter can be removed by reselecting it and making a null entry."
 D ^DIR
 K DIR
 G XIT:$D(DIRUT)!$D(DIROUT)
 ;I Y<6 D @($S(Y=1:"LOC",Y=2:"TYP",Y=3:"DT",$G(ABM("STA"))="P"&(Y=4):"INC",Y=5:"PRV",$D(ABM("CANC")):"CANC",$D(ABM("CLOS")):"CLOS",$D(ABM("STA")):"STATUS",1:"APPR")_"^ABMDRSL1") G LOOP  ;Closed  ;abm*2.6*31 IHS/SD/SDR CR11834
 ;start old abm*2.6*32 IHS/SD/SDR 11501
 ;I Y<6 D @($S(Y=1:"LOC",Y=2:"TYP",Y=3:"DT",$G(ABM("STA"))="H"&(Y=4):"INC",Y=5:"PRV",$D(ABM("CANC")):"CANC",$D(ABM("CLOS")):"CLOS",$D(ABM("STA")):"STATUS",1:"APPR")_"^ABMDRSL1") G LOOP  ;Closed  ;abm*2.6*31 IHS/SD/SDR CR11834
 ;end old abm*2.6*32 IHS/SD/SDR 11501
 ;start new abm*2.6*32 IHS/SD/SDR CR11501
 I Y<6 D @($S(Y=1:"LOC",Y=2:"TYP",Y=3:"DT",$G(ABM("STA"))="H"&(Y=4):"INC",Y=5:"PRV",$D(ABM("CANC")):"CANC",$D(ABM("CLOS")):"CLOS",$D(ABM("BILLT")):"BILLT",$D(ABM("STA")):"STATUS",1:"APPR")_"^ABMDRSL1") G LOOP
 ;end new abm*2.6*32 IHS/SD/SDR CR11501
 I Y=6&($D(ABM("RFOR"))) D RFOR^ABMDRSL2  G LOOP  ;abm*2.6*21 IHS/SD/SDR HEAT241429
 I Y=6 D PTYP^ABMDRSL2 G LOOP
 I '$D(ABM("NODX")) D @($S(Y=7:"DX",Y=8:"PX",1:"RTYP")_"^ABMDRSL2") G LOOP
 D RTYP^ABMDRSL2 G LOOP
 ;
INS ;
 W !!?5,"You can RESTRICT the REPORT to either a SPECIFIC INSURER or",!?5,"else a TYPE of INSURER (i.e. PRIVATE INSURANCE, MEDICAID...).",!
 S DIR(0)="Y"
 S DIR("A")="Restrict Report to a SPECIFIC INSURER (Y/N)"
 S DIR("B")="N"
 D ^DIR
 G XIT:$D(DIRUT)
 D @($S(Y=1:"INS",1:"TYP")_"^ABMDRSL1")
 I '$D(DTOUT)!'$D(DUOUT)!'$D(DIROUT) G LOOP
 ;
XIT ;
 G XIT2:'$D(ABM("RTYP"))!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)
 ;start new abm*2.6*32 IHS/SD/SDR CR11501
 ;ask if they want to include visit types/clinics on report; if not skip that question
 I ($G(ABM("EMPP"))="EMP") D  I Y<1 Q
 .I ABM("RTYP")=3 S Y=0 Q
 .K DIR
 .S DIR(0)="Y"
 .S DIR("A")="Do you wish to include Visit Type or Clinic Type on Report"
 .S DIR("B")="N"
 .D ^DIR
 ;end new abm*2.6*32 IHS/SD/SDR CR11501
 W !
 K DIR
 S DIR(0)="SA^C:CLINIC;V:VISIT TYPE"
 S DIR("A")="Sort Report by [V]isit Type or [C]linic: "
 S DIR("B")="V"
 S DIR("?")="Enter 'V' to sort the report by Visit Type (inpatient, outpatient, etc.) or a 'C' to sort it by the Clinic associated with each visit."
 D ^DIR
 I '$D(DIROUT)&('$D(DIRUT)) D
 .S ABMY("SORT")=Y
 .I ABMY("SORT")="C" D CLIN,REASON:$D(ABM("REASON")) Q
 .;D VTYP,REASON:$D(ABM("REASON"))&($D(ABMY("VTYP")))  ;abm*2.6*21 IHS/SD/SDR HEAT186137
 .I ABMY("SORT")="V" D VTYP,REASON:$D(ABM("REASON"))  ;abm*2.6*21 IHS/SD/SDR HEAT186137
 .Q
 ;
XIT2 ;
 K ABMY("I"),ABMY("X"),DIR
 Q
 ;
CLIN ;SELECT CLINICS
 K ABMY("CLIN")
 S DIC="^DIC(40.7,"
 S DIC(0)="AEMQ"
 S DIC("A")="Select Clinic: ALL// "
 F  D  Q:+Y<0
 .I $D(ABMY("CLIN")) S DIC("A")="Select Another Clinic: "
 .D ^DIC
 .Q:+Y<0
 .S ABMY("CLIN",+Y)=""
 I '$D(ABMY("CLIN")) D
 .I $D(DUOUT) K ABMY("SORT") Q
 .W "ALL"
 K DIC
 Q
 ;
VTYP ;SELECT VISIT TYPES
 K ABMY("VTYP")
 S DIC="^ABMDVTYP("
 S DIC(0)="AEMQ"
 S DIC("A")="Select Visit Type: ALL// "
 F  D  Q:+Y<0
 .I $D(ABMY("VTYP")) S DIC("A")="Select Another Visit Type: "
 .D ^DIC
 .Q:+Y<0
 .S ABMY("VTYP",+Y)=""
 I '$D(ABMY("VTYP")) D
 .I $D(DUOUT) K ABMY("SORT") Q
 .W "ALL"
 K DIC
 Q
REASON ; select reasons (for cancelled and pending claim reports)
 K ABMY("REASON")
 S DIC=$S($G(ABM("REASON"))="PEND":"^ABMPSTAT(",1:"^ABMCCLMR(")
 S DIC(0)="AEMQ"
 S DIC("A")="Select Reason: ALL// "
 F  D  Q:+Y<0
 .I $D(ABMY("REASON")) S DIC("A")="Select Another Reason: "
 .D ^DIC
 .Q:+Y<0
 .S ABMY("REASON",+Y)=""
 I '$D(ABMY("REASON")) D
 .I $D(DUOUT) K ABMY("SORT") Q
 .W "ALL"
 K DIC
 Q
