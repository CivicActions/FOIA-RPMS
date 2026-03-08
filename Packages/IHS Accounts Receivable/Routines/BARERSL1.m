BARERSL1 ; IHS/SD/SDR - Selective Report Parameters-PART 2 ; 12/19/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**35**;OCT 26,2005;Build 187
 ;
 ;IHS/SD/SDR 1.8*35 ADO59950 New Employee Productivity Report
 ;
 Q
 ;******
 ;
 ; 
LOC ; EP
 ;Select Location inclusion parameters
 W !
 K DIC,BARY("LOC")
 S DIC="^BAR(90052.05,DUZ(2),"
 S DIC(0)="ZAEMQ"
 S DIC("A")="Select Visit LOCATION: "
 D ^DIC
 K DIC
 I $D(DTOUT)!($D(DUOUT)) S BARDONE=1 Q
 Q:+Y<1
 S BARY("LOC")=+Y
 S BARY("LOC","NM")=Y(0,0)
 Q
 ;**************
BENT ; EP
 ;Select BILLING ENTITY Inclusion Parameter
 ;May not specify both billing entity and a/r account
 K DIR,BARY("BENT"),BARY("ACCT"),BARY("PAT"),BARY("ITYP"),BARY("ALL")
 ;bar*1.8*23 UPDATED DISPATCH TABLE
 S DIR(0)="SO^1:MEDICARE"
 S DIR(0)=DIR(0)_";2:MEDICAID"
 S DIR(0)=DIR(0)_";3:PRIVATE INSURANCE"
 S DIR(0)=DIR(0)_";4:NON-BENEFICIARY PATIENTS"
 S DIR(0)=DIR(0)_";5:BENEFICIARY PATIENTS"
 S DIR(0)=DIR(0)_";6:SPECIFIC A/R ACCOUNT"
 S DIR(0)=DIR(0)_";7:SPECIFIC PATIENT"
 S DIR(0)=DIR(0)_";8:WORKMEN'S COMP"
 S DIR(0)=DIR(0)_";9:PRIVATE + WORKMEN'S COMP"
 S DIR(0)=DIR(0)_";10:CHIP"
 S DIR(0)=DIR(0)_";11:VETERANS ADMINISTRATION"
 S DIR(0)=DIR(0)_";12:OTHER"
 S DIR("A")="Select TYPE of BILLING ENTITY to Display"
 S DIR("?")="Enter TYPE of BILLING ENTITY to display, or press <return> for ALL"
 D ^DIR
 K DIR
 I $D(DUOUT)!($D(DTOUT)) S BARDONE=1 K DIRUT Q
 I Y<1 K DIRUT Q
 G ACCT:Y=6,PAT:Y=7
  S:Y=1 BARY("TYP")="^R^MH^MD^MC^MMC^"
 S:Y=2 BARY("TYP")="^D^K^FPL^"
 S:Y=3 BARY("TYP")="^H^M^P^F^"
 S:Y=4 BARY("TYP")="^N^"
 S:Y=5 BARY("TYP")="^I^"
 S:Y=8 BARY("TYP")="^W^"
 S:Y=9 BARY("TYP")="^H^M^P^F^W^"
 S:Y=10 BARY("TYP")="^K^"
 S:Y=11 BARY("TYP")="^V^"
 S:Y=12 BARY("TYP")="^W^C^N^I^T^G^SEP^TSI^"
 S BARY("TYP","NM")=Y(0)
 Q
 ;***********
ACCT ; 
 ;Specific insurer of billing entity parameter
 K DIC
 K BARY("ITYP"),BARY("ACCT"),BARY("ALL"),BARY("BENT")
 S DIC="^BARAC(DUZ(2),"
 S DIC("W")="D DICWACCT^BARUTL0(Y)"
 S DIC(0)="ZQEAM"
 D ^DIC
 K DIC
 Q:$D(DTOUT)!($D(DUOUT))
 Q:+Y<0
 S BARY("ACCT")=+Y
 S BARY("ACCT","NM")=Y(0,0)
 Q
 ;*******
PAT ;
 ;Specific patient of billing entity parameter
 K BARY("ITYP"),BARY("PAT")
 D ^XBFMK
 S DIC="^AUPNPAT("
 S DIC(0)="IZQEAM"
 S DIC("W")="D DICWPAT^BARUTL0(1)"
 D ^DIC
 K DIC
 Q:$D(DTOUT)!($D(DUOUT))
 K AUPNLK("ALL")
 Q:+Y<0
 S BARY("PAT")=+Y
 S BARY("PAT","NM")=Y(0,0)
 Q
 ;**********
ALLC ; EP
 ;bar*1.8*23 Select ALLOWANCE CATEGORY Inclusion Parameter
 K DIR,BARY("ALL"),BARY("ITYP"),BARY("BENT"),BARY("ACCT"),BARY("PAT"),BARY("TYP")
 S DIR(0)="SO^1:MEDICARE              (INS TYPES R MD MH MC MMC)" ;JULY 2003 
 S DIR(0)=DIR(0)_";2:MEDICAID              (INS TYPES D K FPL)"
 S DIR(0)=DIR(0)_";3:PRIVATE INSURANCE     (INS TYPES P H F M)"
 S DIR(0)=DIR(0)_";4:VETERANS              (INS TYPES V)"
 S DIR(0)=DIR(0)_";5:OTHER                 (INS TYPES W C N I G T SEP TSI)"
 S DIR("A")="Select TYPE of ALLOWANCE CATEGORY to Display"
 S DIR("?")="Enter TYPE of ALLOWANCE CATEGORY to display, or press <return> for ALL"
 D ^DIR
 K DIR
 I $D(DUOUT)!($D(DTOUT)) K DIRUT Q
 I $A(Y)<1 K DIRUT Q
 S BARY("ALL")=$$CONVERT^BARRSL2(Y)
 S BARY("ALL",Y)=""
 Q
 ;*******************
DT ;EP
 ;Select Date
 S BARY("DT")="A"
 W !!," ============ Entry of Activity Date Range =============",!
 S DIR("A")="Enter STARTING ACTIVITY DATE for the Report"
 S DIR(0)="DO^:NOW:ETX"
 S DIR("?")="This response must be a date or date/time and cannot be in the future."
 D ^DIR
 I $D(DIRUT)!$D(DUOUT)!$D(DTOUT)!$D(DIROUT) K BARY("DT"),DIRUT Q
 S BARY("DT",1)=Y
 W !
 S DIR("A")="Enter ENDING ACTIVITY DATE for the Report"
 S DIR(0)="DO^:NOW:ETX"
 D ^DIR
 K DIR
 G DT:$D(DIRUT)
 S BARY("DT",2)=Y
 I BARY("DT",1)>BARY("DT",2) W !!,*7,"INPUT ERROR: Start Date is Greater than the End Date, TRY AGAIN!",!! G DT
 Q
 ;********************
TECH ;EP
 ;Select A/R Technician Inclusion Parameter
 S BARPTCK=0
 S BARPTKEY=$O(^DIC(19.1,"B","BARZ EMP PROD RPT",0))
 I +$G(BARPTKEY)'=0 I $G(^VA(200,DUZ,51,BARPTKEY,0))'="" S BARPTCK=1
 I BARPTCK=0 D  Q
 .W !!,"Only a user with security key BARZ EMP PROD RPT can run this report for"
 .W !,"anyone other than themselves",!
 .H 2
 ;
 K BARY("PTECH"),BARY("ALLPOST")
 D ^XBFMK
 S DIR(0)="SO^1:One Person's Activity;2:All posting staff"
 S DIR("A")="Select"
 D ^DIR
 ;if they don't answer this prompt default back to the person running the report and go back to inclusion parameters
 I $D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT) S BARY("PTECH")=1,BARY("PTECH",DUZ)="" K DIRUT Q
 ;
 I $D(DUOUT)!$D(DTOUT) S BARDONE=1 Q
 I Y=1 D  ;one person's activity
 .K BARY("PTECH")
 .F  D  Q:+Y<0
 ..W !
 ..S DIC="^VA(200,"
 ..S DIC(0)="QEAM"
 ..D ^DIC
 ..S:+Y>0 BARY("PTECH",+Y)="",BARY("PTECH")=1
 ;
 I Y=2 S BARY("ALLPOST")=""  ;all posting staff
 ;
 I '$D(BARY("PTECH"))&('$D(BARY("ALLPOST"))) S BARY("PTECH")=1,BARY("PTECH",DUZ)=""  ;default to person running report if they don't select anyone in one person option
 Q
 ;*************
RTYP ; EP
 ;Select Report Type Inclusion Parameter
 K DIR,BARY("RTYP")
 S DIR(0)="SO^1:BRIEF LISTING (80 width);2:STATISTICAL SUMMARY ONLY;3:DELIMITED DETAIL (HFS);4:VALIDATOR (delimited HFS file)"
 S DIR("A")="Select TYPE of REPORT desired"
 S DIR("B")=1
 D ^DIR
 K DIR
 I $D(DUOUT)!$D(DTOUT) S BARDONE=1 Q
 S BARY("RTYP")=Y
 S BARY("RTYP","NM")=Y(0)
 Q
 ;****************
ITYP ;EP
 ;Ask Insurer Type
 K DIR,BARY("ITYP"),BARY("ACCT"),BARY("PAT"),BARY("ALL"),BARY("TYP"),BARY("BENT")
 K BARY("COLPT")
 ;PRIV
 S DIR(0)="SO^H:HMO"
 S DIR(0)=DIR(0)_";M:MEDICARE SUPPL."
 S DIR(0)=DIR(0)_";P:PRIVATE INSURANCE"
 S DIR(0)=DIR(0)_";F:FRATERNAL ORGANIZATION"
 ;OTHER
 S DIR(0)=DIR(0)_";T:THIRD PARTY LIABILITY"
 S DIR(0)=DIR(0)_";W:WORKMEN'S COMP"
 S DIR(0)=DIR(0)_";C:CHAMPUS"
 S DIR(0)=DIR(0)_";N:NON-BENEFICIARY (NON-INDIAN)"
 S DIR(0)=DIR(0)_";I:INDIAN PATIENT"
 S DIR(0)=DIR(0)_";G:GUARANTOR"
 S DIR(0)=DIR(0)_";SEP:STATE EXCHANGE PLAN"
 S DIR(0)=DIR(0)_";TSI:TRIBAL SELF INSURED"
 ;MEDICAID 
 S DIR(0)=DIR(0)_";D:MEDICAID FI"
 S DIR(0)=DIR(0)_";K:CHIP (KIDSCARE)"
 S DIR(0)=DIR(0)_";FPL:FPL 133 PERCENT"
 ;MEDICARE
 S DIR(0)=DIR(0)_";R:MEDICARE FI"
 S DIR(0)=DIR(0)_";MD:MEDICARE PART D"
 S DIR(0)=DIR(0)_";MC:MEDICARE PART C"
 S DIR(0)=DIR(0)_";MH:MEDICARE HMO"
 S DIR(0)=DIR(0)_";MMC:MEDICARE MANAGED CARE"
 ;VETERANS
 S DIR(0)=DIR(0)_";V:VETERANS ADMINISTRATION"
 ;
 S DIR("A")="Select INSURER TYPE to Display"
 S DIR("?")="Enter TYPE of INSURER to display, or press <return> for ALL"
 D ^DIR
 K DIR
 I $D(DUOUT)!($D(DTOUT))!($D(DIRUT)) K DIRUT Q
 S BARY("ITYP")=Y
 S BARY("ITYP","NM")=Y(0)
 Q
 ;EOR
