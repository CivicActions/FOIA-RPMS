BARRSEL ; IHS/SD/LSL - Selective Report Parameters ;08/26/2000
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**6,16,19,20,23,24,28,29,35**;OCT 26,2005;Build 187
 ;
 ;IHS/ASDS/LSL 08/26/00 Routine created
 ;IHS/ASDS/LSL 01/16/01 Add Allowance Category Parameter for Period Summary Report at the request of Finance/AR group
 ;IHS/ASDS/SDH 11/21/01 A/R Statistical Report Modified to check if it is the statistical report and only show related choices
 ;IHS/SD/LSL 1.6*2 05/16/02 Modified to display message based on Location type for reports parameter
 ;
 ;IHS/SD/LSL 1.8 03/12/04 Added reports to use inclusion parameters
 ;IHS/SD/SDR 1.8*6 DD 4.1.3 Added negative balance
 ;IHS/SD/PKD 1.8*19 05/07/10 CXL;TDN;PAY reports- Added inclusion parameters
 ;IHS/SD/TMM 1.8*19 07/20/2010 Add Group Plan
 ;IHS/SD/PKD 1.8*20 1/26/11 Move code from tags: DISP; CLIN; VTYP to BARRSEL1
 ;IHS/SD/POT 1.8*23 JUN 2013 MOD FOR ICD9/10 DX (DROPPED 'PRIMARY')
 ;IHS/SD/POT 1.8*23 SEP 2013 made selection of DXs BAR(DX) mandatory for IPDR report; ASKAGAIN replaced by ASKAGAI1 (to keep the current selection in BARY()
 ;IHS/SD/POT 1.8*24 HEAT150941 Allow ALL DX9/10 2/9/2014: if no DX selected: show ALL DX of ALL available coding systems; 3/10/2014
 ;IHS/SD/SDR 1.8*28 Updated p23, p24 documentation'
 ;IHS/SD/POT 1.8*28 MADE DT SELECTION MANDATORY FOR IPDR REPORT
 ;IHS/SD/CPC 1.8*29 CR9028 Fix for continuous loop in Top Payer and TDN report
 ;IHS/SD/CPC 1.8*29 CR10586 Fix for IPDR displaying incorrect prompts. Also affects STA, ADT, TAR, BLS, PAY, TDN, TSR, TAR, NEG, DAYS, LBL, SBL, and PRP reports
 ;IHS/SD/SDR 1.8*35 ADO77760 Added for the BLDR Locked Batch Report
 ;********************************************
 ;
 ;start old bar*1.8*23 IHS/SD/POT
 ;ASKAGAIN ;EP - IHS/SD/TPF BAR*1.8*6 DD 4.1.5
 ;K DIC,DIR,BARY
 ;end old start new bar*1.8*23 IHS/SD/POT
ASKAGAIN ;EP
 K BARY
 ;start new bar*1.8*24 IHS/SD/POT
 ;DEFAULT DX VALUES   ;3/10/2014
 I BARP("RTN")="BARRIDR"!(BARP("RTN")="BARRPAY") D
 .I $T(+1^ICDEX)="" S BARY("DX-ICDVER")="9",BARY("DX9")="ALL"
 .I $T(+1^ICDEX)]"" S BARY("DX-ICDVER")="B",BARY("DX9")="ALL",BARY("DX10")="ALL"
 ;end new bar*1.8*24 IHS/SD/POT
ASKAGAI1 ;KEEP CURRENT BARY SELECTION
 K DIC,DIR
 ;end new bar*1.8*23 IHS/SD/POT
 S BARY("X")="W $$SDT^BARDUTL(X)"
 S (BARASK,BARDONE)=0
 S BARMENU=$S($D(XQY0):$P(XQY0,U,2),1:$P($G(^XUTL("XQ",$J,"S")),U,3))
 S BAR("OPT")="LIST"  ;Default
 S:BARMENU["Negative" BAR("OPT")="NEG"
 S:BARMENU["Transaction" BAR("OPT")="TAR"
 S:BARMENU["Age Detail" BAR("OPT")="AGE"
 S:BARMENU["Statistical" BAR("OPT")="STA"
 S:BARMENU["Inpatient" BAR("OPT")="IPDR"
 S:BARMENU["Payment" BAR("OPT")="PRP"
 S:BARMENU["Transaction" BAR("OPT")="TAR"
 S:BARMENU["Days in AR" BAR("OPT")="DAYS"
 I BARMENU["Cancelled Bills Report" D  ;Set Defaults
 .S BAR("OPT")="CXL"
 .I '$D(BARY("OBAL")) D OBAL^BARRCXL
 .I '$G(BARY("RTYP")) S BARY("RTYP")=1,BARY("RTYP","NM")="DETAIL"
 S:BARMENU="Payment Summary Report by TDN" BAR("OPT")="TDN"
 S:BARMENU="Top Payer Report" BAR("OPT")="PAY"
 I BAR("OPT")="TDN"!(BAR("OPT")="PAY") S BAR("RTYP")=1,BAR("RTYP","NM")="Summary"
 I BARMENU["Transaction Statistical" D
 .S BAR("OPT")="TSR"
 .S BARY("RTYP")=1
 .S BARY("RTYP","NM")="DETAIL"
 .S BARY("TRANS TYPE",40)="PAYMENT"
 .S BARY("DATA SRC")="BOTH"
 I BARMENU["Large" D
 .S BAR("OPT")="LBL"
 .S BARY("LBL")=5000
 I BARMENU["Small" D
 .S BAR("OPT")="SBL"
 .S BARY("SBL")=5
 I ",TAR,AGE,LIST,"[(","_BAR("OPT")_",") D
 .S BARY("RTYP")=1
 .S BARY("RTYP","NM")="Detail"
 ;start new bar*1.8*35 IHS/SD/SDR ADO77760
 I BARMENU["Lockdown" D
 .S BAR("OPT")="BLDR"
 .S BARY("RTYP")=2
 .S BARY("RTYP","NM")="Summary (Printer)"
 .I $G(BARY("DTYP"))="" D  ;default to lockdown if nothing was selected
 ..S BARY("DTYP")="Lock"
 ..S BARY("DT")="LDT"
 ..S BARY("DT",1)=3051001  ;this is used to coincide with code in BARPST that says 'oldest collection date allowed (lockdown date)
 ..S BARY("DT",2)=DT
 ;end new bar*1.8*35 IHS/SD/SDR ADO77760
 D MSG
 ;F  D  Q:+BARDONE2!(+BARDONE)!$D(DIRUT)  ;bar*1.8*28 IHS/SD/SDR HEAT204148
 F  D  Q:+$G(BARDONE2)!(+$G(BARDONE))  ;bar*1.8*29 IHS/SD/CPC 
 .;Q:$G(DIRUT)  ;bar*1.8*28 IHS/SD/POT HEAT182240 ;bar*1.8*29 IHS/SD/CPC
 .D DISP   ;Display current parameters
 .D PARM   ;Select additional parameters
 I $G(DUOUT) D ^BARVKL0 Q  ;bar*1.8*28 IHS/SD/POT HEAT182240  
 I +BARDONE D ^BARVKL0 Q
 ;start old bar*1.8*24 IHS/SD/POT
 ;;start new bar*1.8*23 IHS/SD/POT
 ;I BAR("OPT")="IPDR" I '$D(BARY("DX9")) I '$D(BARY("DX10")) D  G ASKAGAI1
 ;.W !!,"The 'Inpatient Primary Diagnosis Report' requires you enter"
 ;.W !,"a diagnosis.",!!
 ;.Q
 ;;end new bar*1.8*23 IHS/SD/POT
 ;end old bar*1.8*24 IHS/SD/POT
 ;
 I BAR("OPT")="IPDR"&('$D(BARY("DT"))) D  G ASKAGAI1  ;bar*1.8*28 IHS/SD/POT HEAT182240
 .W !,"A date range is required for this report.",!!
 .D EOP^BARUTL(1) ;BAR*1.8*29 IHS/SD/CPC CR10586
 .Q
 Q:BAR("OPT")="IPDR"!(BAR("OPT")="PRP")
 Q:BAR("OPT")="BLDR"  ;bar*1.8*35 IHS/SD/SDR ADO77760
 ;I (BAR("OPT")="DAYS"),'$D(BARY("DT")) D  G ASKAGAIN  ;CR10586 IHS/SD/CPC BAR*1.8*29
 I (BAR("OPT")="DAYS"),'$D(BARY("DT")) D  G ASKAGAI1  ;CR10586 IHS/SD/CPC BAR*1.8*29
 .W !!,"The 'Days in AR' report requires you to enter"
 .W !,"a Visit date range."
 .W !!
 .D ^XBFMK  ;bar*1.8*28 IHS/SD/SDR HEAT224215
 .H 1  ;bar*1.8*28 IHS/SD/SDR HEAT224215
 .Q  ;bar*1.8*24 IHS/SD/POT
 ;I BAR("OPT")="PAY"&('$D(BARY("DT"))) D  G ASKAGAIN  ;bar*1.8*23 IHS/SD/POT
 I BAR("OPT")="PAY"&('$D(BARY("DT"))) D  G ASKAGAI1  ;bar*1.8*23 IHS/SD/POT
 .W !!,"This is a required response. Enter '^' to exit.",!,*7," A Date Range must be entered for the report."
 .D EOP^BARUTL(1) ;CR9028 IHS/SD/CPC BAR*1.8*29
 .S DUOUT=1 ;CR9028 IHS/SD/CPC BAR*1.8*29
 .Q   ;CR9028 IHS/SD/CPC BAR*1.8*29
TDNCHK ;
 ;I BAR("OPT")="TDN"&('$D(BARY("DT"))&('$D(BARY("TDN")))) D  G ASKAGAIN
 I BAR("OPT")="TDN"&('$D(BARY("DT"))&('$D(BARY("TDN")))) D  G ASKAGAI1   ;CR10586 IHS/SD/CPC BAR*1.8*29
 .W !!,"This is a required response. Enter '^' to exit."
 .W !," A Date Range must be entered for the report.",!!  ;bar*1.8*24 IHS/SD/POT
 .D EOP^BARUTL(1)  ;CR9028 IHS/SD/CPC BAR*1.8*29
 .S DUOUT=1  ;CR9028 IHS/SD/CPC BAR*1.8*29
 .Q  ;bar*1.8*24 IHS/SD/POT
 ;I ((BAR("OPT")="TSR"))&('$D(BARY("TRANS TYPE"))) D  G ASKAGAIN
 I ((BAR("OPT")="TSR"))&('$D(BARY("TRANS TYPE"))) D  G ASKAGAI1  ;CR10586 IHS/SD/CPC BAR*1.8*29
 .W !!,"The 'Transaction Statistical Report' requires you enter"
 .W !,"a transaction type."
 I "TSR"[BAR("OPT") S BARY("SORT")="N"
 I ",LBL,SBL,NEG,"[(","_BAR("OPT")_",") D  Q
 .D ASKSORT
 .D:BARASK SORT
 D SORT
 Q
 ;********************************************
 ;
MSG ; EP      
 N X S X=$G(BAR("OPT")) Q:(X="PAY"!(X="TDN"))&($G(BARMSGPT)>1)
 W !!,$$EN^BARVDF("RVN"),"NOTE:",$$EN^BARVDF("RVF")
 I BAR("LOC")="BILLING" D MSG1
 E  D MSG2
 Q
 ;********************************************
 ;
MSG1 ;
 ; Message if Site Parameter "Location type for Reports" is BILLING
 W ?7,"This report will contain data for the BILLING location you are logged "
 W !?7,"into.  Selecting a Visit Location will allow you to run the report for"
 W !?7,"a specific VISIT location under this BILLING location."
 Q
 ;********************************************
 ;
MSG2 ;
 ; Message if Site Parameter "Location type for Reports" is VISIT
 W ?7,"This report will contain data for VISIT location(s) regardless of"
 W !?7,"BILLING location."
 Q
 ;********************************************
 ;
DISP ;
 ;Display current inclusion parameters
 ;IHS/SD/PKD 1.8*20 SAC size limitations: move code
 D DISP^BARRSEL1
 Q
 ;********************************************
 ;
PARM ;
 ;Choose additional inclusion parameters
 S (BARDONE2,BARDONE3)=0
 K DIR
 S DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:DATE RANGE;4:PROVIDER;5:REPORT TYPE"
 S:BAR("OPT")="AGE" DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:PROVIDER;4:REPORT TYPE"
 S:BAR("OPT")="TAR" DIR(0)="SO^1:LOCATION;2:TRANSACTION DATE RANGE;3:COLLECTION BATCH;4:COLLECTION BATCH ITEM;5:A/R ENTRY CLERK;6:PROVIDER;7:REPORT TYPE"
 S:BAR("OPT")="STA" DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:DATE RANGE;4:PROVIDER"
 ;S:BAR("OPT")="IPDR" DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:ALLOWANCE CATEGORY;4:DATE RANGE;5:PROVIDER;6:PRIMARY DIAGNOSIS;7:DISCHARGE SERVICE"  ;bar*1.8*24 IHS/SD/POT
 ;S:BAR("OPT")="IPDR" DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:ALLOWANCE CATEGORY;4:DATE RANGE;5:PROVIDER;6:DIAGNOSIS;7:DISCHARGE SERVICE"  ;bar*1.8*24 IHS/SD/POT
 S:BAR("OPT")="IPDR" DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:ALLOWANCE CATEGORY;4:DATE RANGE;5:PROVIDER;6:PRIMARY DIAGNOSIS;7:DISCHARGE SERVICE"  ;BAR*1.8*29 IHS/SD/CPC
 S:BAR("OPT")="LBL" DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:ALLOWANCE CATEGORY;4:LARGE BALANCE"
 S:BAR("OPT")="SBL" DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:ALLOWANCE CATEGORY;4:SMALL BALANCE"
 S:BAR("OPT")="PRP" DIR(0)="SO^1:LOCATION;2:COLLECTION POINT;3:INSURER TYPE"
 S:BAR("OPT")="NEG" DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:ALLOWANCE CATEGORY"
 I BAR("OPT")="TSR" D
 .S DIR(0)="SO^1:DATE RANGE;2:BILLING ENTITY;3:COLLECTION BATCH;4:COLLECTION BATCH ITEM;5:POSTING CLERK;6:LOCATION;7:PROVIDER;8:ALLOWANCE CATEGORY;9:TRANSACTION TYPE;10:REPORT TYPE;11:DATA SOURCE"
 S:BAR("OPT")="DAYS" DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:DATE RANGE;4:PROVIDER"
 I BAR("OPT")="CXL" D
 .S DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:DATE RANGE;4:CANCELLING OFFICIAL;5:PROVIDER;6:ELIGIBILITY STATUS;7:REPORT TYPE"
 S:BAR("OPT")="TDN" DIR(0)="SO^1:LOCATION;2:One or more TDN's;3:DATE RANGE"
 ;S:BAR("OPT")="PAY" DIR(0)="SO^1:LOCATION;2:DATE RANGE;3:PROVIDER;4:CLINIC;5:APPROVING OFFICIAL;6:PRIMARY DIAGNOSIS;7:ADJUSTMENT;8:ALLOWANCE CATEGORY"  ;bar*1.8*24 IHS/SD/POT
 S:BAR("OPT")="PAY" DIR(0)="SO^1:LOCATION;2:DATE RANGE;3:PROVIDER;4:CLINIC;5:APPROVING OFFICIAL;6:DIAGNOSIS;7:ADJUSTMENT;8:ALLOWANCE CATEGORY"  ;bar*1.8*24 IHS/SD/POT
 S:BAR("OPT")="BLDR" DIR(0)="SO^1:DATE RANGE;2:COLLECTION POINT;3:ALLOWANCE CATEGORY;4:REPORT TYPE"  ;bar*1.8*35 IHS/SD/SDR ADO77760
 ;END
 S DIR("A")="Select ONE or MORE of the above INCLUSION PARAMETERS"
 I BAR("OPT")="IPDR",('$D(BARY("DT"))) S DIR("A",1)="For this report you must select a date range as one of your inclusion parameters."
 S DIR("?")="The report can be restricted to one or more of the listed parameters. A parameter can be removed by reselecting it and making a null entry."
 D ^DIR
 K DIR
 ;I $D(DIRUT) Q  ;bar*1.8*28 IHS/SD/POT HEAT182240
 ;I $E(X)="^" S BARDONE=1 Q  ;bar*1.8*28 IHS/SD/POT HEAT182240
 I $E(Y)="^" S BARDONE=1 Q  ;bar*1.8*28 IHS/SD/POT HEAT182240
 ;I $D(DTOUT)!($D(DUOUT))!($D(DIRUT)) S BARDONE2=1 Q
 I $D(DTOUT)!($D(DUOUT)) S BARDONE2=1 Q  ;BAR*1.8*29 IHS/SD/CPC CR10586
 S BARSEL=Y
 K BARTAG
 ;
TSR I BAR("OPT")="TSR" D  Q  ;BAR*1.8*29 IHS/SD/CPC CR10586
 .I $A(BARSEL)>32 D
 ..S:BARSEL=1 BARTAG="DT"
 ..S:BARSEL=2 BARTAG="TYP"
 ..S:BARSEL=3 BARTAG="BATCH"
 ..S:BARSEL=4 BARTAG="ITEM"
 ..S:BARSEL=5 BARTAG="AR"
 ..S:BARSEL=6 BARTAG="LOC"
 ..S:BARSEL=7 BARTAG="PRV"
 ..S:BARSEL=8 BARTAG="ALL"
 ..S:BARSEL=9 BARTAG="TRANTYP"
 ..S:BARSEL=10 BARTAG="RTYP"
 ..S:BARSEL=11 BARTAG="DATASRC"
 ..S BARTAG=BARTAG_"^BARRSL1"
 ..D @BARTAG
 ..Q
 .E  D
 ..I '$D(BARY("TRANS TYPE")) D
 ...W !!,"The 'Transaction Statistical Report' requires you enter"
 ...W !,"a transaction type." D
 ...D EOP^BARUTL(1)
 ...Q
 ..E  S BARDONE2=1
 ..Q
 .Q
CXL I BAR("OPT")="CXL" D  Q
 .S BARTAG=$P("LOC^TYP^DT^CANC^PRV^PTYP^RTYP",U,BARSEL)
 .;I BARSEL=4!(BARSEL=6) S BARTAG=BARTAG_"^BARRSL2"
 .;E  S BARTAG=BARTAG_"^BARRSL1"
 .;Capture null input ;BAR*1.8*29 IHS/SD/CPC CR10586
 .;D @BARTAG
 .I $G(BARTAG)]"" D
 ..I BARSEL=4!(BARSEL=6) S BARTAG=BARTAG_"^BARRSL2"
 ..E  S BARTAG=BARTAG_"^BARRSL1"
 ..D @BARTAG
 ..Q
 .E  S BARDONE2=1
 .Q
 ;END NEW CODE
PAY I BAR("OPT")="PAY" D  Q
 .D PAY^BARRSEL1
 ;
TDN I BAR("OPT")="TDN" D  Q
 .D TDN^BARRSEL1
 ;
AGE I BAR("OPT")="AGE" D  Q
 .D AGE^BARRSEL1
 ;
TAR I BAR("OPT")="TAR" D  Q
 .;S BARTAG="RTYP" ;BAR*1.8*29 IHS/SD/CPC CR10586
 .S:BARSEL=1 BARTAG="LOC"
 .S:BARSEL=2 BARTAG="DT"
 .S:BARSEL=3 BARTAG="BATCH"
 .S:BARSEL=4 BARTAG="ITEM"
 .S:BARSEL=5 BARTAG="AR"
 .S:BARSEL=6 BARTAG="PRV"
 .S:BARSEL=7 BARTAG="RTYP"  ;BAR*1.8*29 IHS/SD/CPC CR10586
 .;S BARTAG=BARTAG_"^BARRSL1"
 .;Capture null input ;;BAR*1.8*29 IHS/SD/CPC CR10586
 .;D @BARTAG
 .I $G(BARTAG)]"" D
 ..S BARTAG=BARTAG_"^BARRSL1"
 ..D @BARTAG
 ..Q
 .E  S BARDONE2=1
 .Q
 ;END NEW CODE
 ;
IPDR I BAR("OPT")="IPDR" D  Q
 .D IPDR^BARRSEL1
 ;
LBLSBL I ",LBL,SBL,"[(","_BAR("OPT")_",") D  Q
 .D LBLSBL^BARRSEL1
 ;
PRP I BAR("OPT")="PRP" D  Q
 .D PRP^BARRSEL1
 ;
NEG I BAR("OPT")="NEG" D  Q
 .D NEG^BARRSEL1
 ;
 ;start new bar*1.8*35 IHS/SD/SDR ADO77760
BLDR ;
 I BAR("OPT")="BLDR" D  Q
 .D BLDR^BARRSEL2
 ;end new bar*1.8*35 IHS/SD/SDR ADO77760
 ;
ALLOTH S BARTAG="RTYP"
 D ALLOTH^BARRSEL1
 Q
 ;
ASKSORT ; EP
 W !
 K DIR
 S DIR(0)="Y^A"
 S DIR("A")="INCLUDE CLINIC OR VISIT TYPE? "
 S DIR("B")="N"
 D ^DIR
 S:Y BARASK=1
 K DIR
 Q
 ;********************************************
 ;
SORT ; EP
 ;Sort criteria
 Q:BAR("OPT")="TDN"!(BAR("OPT")="PAY")  ; Sort by TDN or Date ; END
 W !
 K DIR
 S DIR(0)="SA^C:CLINIC;V:VISIT TYPE"
 S DIR("A")="Sort Report by [V]isit Type or [C]linic: "
 S DIR("B")="V"
 S DIR("?")="Enter 'V' to sort the report by Visit Type (inpatient, outpatient, etc.) or a 'C' to sort it by the Clinic associated with each visit."
 D ^DIR
 K DIR
 I $D(DIROUT)!$D(DIRUT) S BARDONE=1 Q
 S BARY("SORT")=Y
 I BARY("SORT")="C" D CLIN Q
 D VTYP
 Q
 ;********************************************
 ;
CLIN ; EP
 ; Select clinics to sort by
 ; IHS/SD/PKD 1.8*20 Move Code SAC size
 D CLIN^BARRSEL1
 Q
 ;********************************************
 ;
VTYP ; EP
 ;Select Vitst Types to sort by
 D VTYP^BARRSEL1
 Q
