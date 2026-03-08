BARRSL2 ; IHS/SD/LSL - Selective Report Parameters-PART 3 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**6,19,23,35**;OCT 26, 2005;Build 187
 ;
 ;IHS/ASDS/LSL 04/10/02 Routine created
 ;IHS/SD/LSL 1.7*1 02/20/02 Add DSCHSVC line tag to sort reports by Discharge Service
 ;
 ;IHS/SD/PKD 1.8*19 5/10/10 ADDED TAG CANC PTYP for CANCELLATION REPORT
 ;IHS/SD/POT MAR 2013 ADDED NEW VA billing
 ;IHS/SD/SDR 1.8*35 ADO60910 Updated to display PPN preferred name
 Q
 ;**********************************************
 ;
ARACCT ; EP
 ; Select A/R Accounts to sort by
 K BARY("ARACCT")
 S DIC="^BARAC(DUZ(2),"
 S DIC("W")="D DICWACCT^BARUTL0(Y)"  ;bar*1.8*35 IHS/SD/SDR ADO60910
 S DIC(0)="AEMQ"
 S DIC("A")="Select A/R Account: ALL// "
 F  D  Q:+Y<0
 .S DIC("W")="D DICWACCT^BARUTL0(Y)"  ;bar*1.8*35 IHS/SD/SDR ADO60910
 .I $D(BARY("ARACCT")) S DIC("A")="Select Another A/R Account: "
 .D ^DIC
 .Q:+Y<0
 .S BARY("ARACCT",+Y)=""
 I '$D(BARY("ARACCT")) D
 .I $D(DUOUT) K BARY("SORT") Q
 .W "ALL"
 K DIC
 Q
 ;**********************************************
 ;
DSCHSVC ;EP
 ;Select Discharge Service to sort by (really comes from the
 ;FACILITY TREATING SPECIALTY File ^DIC(45.7)
 K BARY("DSCH")
 S DIC="^DIC(45.7,"
 S DIC(0)="AEMQ"
 S DIC("A")="Select Discharge Service: ALL// "
 F  D  Q:+Y<0
 .I $D(BARY("DSCH")) S DIC("A")="Select Another Discharge Service: "
 .D ^DIC
 .Q:+Y<0
 .S BARY("DSCH",+Y)=""
 I '$D(BARY("DSCH")) D
 .I $D(DUOUT) K BARY("SORT") Q
 .W "ALL"
 K DIC
 Q
 ;**********************************************
 ;
CONVERT(BARA) ;EP
 ;Convert Allowance Categories from numbers to letters
 ;Where BARA is the number needing conversion
 I '$D(BARA) Q "O"
 S BARTMP="O"
 S:BARA=1 BARTMP="R"
 S:BARA=2 BARTMP="D"
 S:BARA=3 BARTMP="P"
 S:BARA=4 BARTMP="V"  ;P.OTT
 S:BARA=5 BARTMP="O"  ;
 S BARA=BARTMP
 K BARTMP
 Q BARA
 ;START BAR*1.8*19 PKD  5/7/10 
 ;       
APPR  ;EP Approving Official
CANC  ;EP 3PB Cancelling Official 
 K BARY("CANC"),BARY("APPR")
 W !
 S DIC="^VA(200,"
 S DIC(0)="QEAM"
 D ^DIC
 I +Y>0 D
 .I BAR("OPT")="CXL" S BARY("CANC")=+Y Q
 .I BAR("OPT")="PAY" S BARY("APPR")=+Y,BARY("APPR","NM")=$P(Y,U,2)
 Q
 ;
 ;PKD BAR*1.8*19  5/7/10 
PTYP ;EP  Eligibility Question
 K DIR
 S DIR(0)="SO^1:INDIAN BENEFICIARY PATIENTS;2:NON-BENEFICIARY PATIENTS"
 S DIR("A")="Select the PATIENT ELIGIBILITY STATUS"
 S DIR("?")="Selection of an Eligibility Status will restrict the report to only those visits in which the patient is of the type designated."
 D ^DIR
 K DIR
 Q:$D(DIRUT)
 S BARY("PTYP")=Y
 S BARY("PTYP","NM")=Y(0)
 Q
 ;
TDN  ; Multiple TDN's can be entered IHS/BAR/PKD 1.8*19 6/1/10
 ; 
 I BAR("OPT")="TDN" K BARY("DT")  ; Date Range OR TDN list
 K BARY("TDN") N BARTDN
 S DIC="^BARCOL(DUZ(2),"
 S DIC(0)="AEQ"
 S DIC("A")="Select TDN**: "
 F  D  Q:+Y<0!(X="^")
 .S D="E"  ; Index to search
 .I $D(BARY("TDN")) S DIC("A")="Select Another TDN: "
 .D IX^DIC
 .Q:+Y<0
 .S BARTDN=X  ; X is TDN
 .S BARY("TDN",BARTDN)=""
 .D DISP^BARRSEL
 K DIC
 Q
CLNC  ; Clinic - One or All
 K BARY("CLNC")
 S DIC="^DIC(40.7,"
 S DIC(0)="AEMQ"
 S DIC("A")="Select Clinic: ALL// "
 D ^DIC
 Q:+Y<0
 S BARY("CLNC",+Y)="",BARY("CLNC","NM")=$P(Y,U,2)
 K DIC
 Q
ADJTY  ; Adjustment Type One or All
 W !,"IN PROCESS  ******************************************",*7
 Q
