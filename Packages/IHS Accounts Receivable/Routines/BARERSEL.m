BARERSEL ; IHS/SD/SDR - Selective Report Parameters for employee prod report ;08/26/2000
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**35**;OCT 26,2005;Build 187
 ;IHS/SD/SDR 1.8*35 ADO59950 New emp prod report
 ;********************************************
 ;
ASKAGAIN ;KEEP CURRENT BARY SELECTION
 K DIC,DIR
 ;
 S (BARASK,BARDONE)=0
 S BARMENU=$S($D(XQY0):$P(XQY0,U,2),1:$P($G(^XUTL("XQ",$J,"S")),U,3))
 D MSG
 F  D  Q:+$G(BARDONE2)!(+$G(BARDONE))!$D(DIRUT)
 .D DISP   ;Display current parameters
 .D PARM   ;Select additional parameters
 ;
 I $G(DUOUT) D ^BARVKL0 Q
 I '$D(BARY("DT")) W !!,"A DATE RANGE is required for this report",!,"Enter '^' to exit" D EOP^BARUTL(1) G ASKAGAIN
 I +BARDONE D ^BARVKL0 Q
 Q
 ;********************************************
 ;
MSG ; EP
 W !!,$$EN^BARVDF("RVN"),"NOTE:",$$EN^BARVDF("RVF")
 I $G(BAR("LOC"))="B" D MSG1
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
 W !!?3,"INCLUSION PARAMETERS in Effect for ",BARMENU,":"
 W !?3,"====================================================================="
 I $D(BARY("LOC")) W !?3,"- Visit Location........: ",BARY("LOC","NM")
 ;
 I $D(BARY("DT")) D
 .W !?3,"- "
 .W "Activity Dates from...: "
 .W $$CDT^BARDUTL(BARY("DT",1))
 .W "  to: "
 .W $$CDT^BARDUTL(BARY("DT",2))
 ;
 I $D(BARY("ALLPOST")) W !?3,"- A/R Technician.......: All posting staff"
 I $D(BARY("PTECH")) D
 .S BARA=0,BARB=0
 .F  S BARA=$O(BARY("PTECH",BARA)) Q:'BARA  D
 ..I BARB=0 W !?3,"- A/R Technician.......: "
 ..E  W !?28
 ..W $P(^VA(200,BARA,0),U)
 ..S BARB=1
 ;
 I $D(BARY("ACCT")) D
 .W !?3,"- Billing Entity........: ",BARY("ACCT","NM")
 .I $$GETPREF^AUPNSOGI(+$P(^BARAC(DUZ(2),BARY("ACCT"),0),U),"I",1)'="" W ?40," - "_$$GETPREF^AUPNSOGI(+$P(^BARAC(DUZ(2),BARY("ACCT"),0),U),"I",1)_"*"
 I $D(BARY("PAT")) D
 .W !?3,"- Billing Entity........: ",BARY("PAT","NM")
 .I $$GETPREF^AUPNSOGI(BARY("PAT"),"I",1)'="" W " - "_$$GETPREF^AUPNSOGI(BARY("PAT"),"I",1)_"*"
 ;
 I $D(BARY("TYP")) W !?3,"- Billing Entity........: ",BARY("TYP","NM")
 ;
 I $D(BARY("ITYP")) W !?3,"- Insurer Type...........: ",BARY("ITYP","NM")
 ;
 I $D(BARY("ALL")) D
 .S BARA=0,BARB=0
 .F  S BARA=$O(BARY("ALL",BARA)) Q:'BARA  D
 ..I BARB=0 W !?3,"- Allowance Categories: "
 ..E  W !?27
 ..W $S(BARA=1:"MEDICARE",BARA=2:"MEDICAID",BARA=3:"PRIVATE INSURANCE",BARA=4:"VETERANS",1:"OTHER")
 ..W:BARA=1 " (INS TYPES R MD MH MC MMC)"
 ..W:BARA=2 " (INS TYPES D K FPL)"
 ..W:BARA=3 " (INS TYPES P H F M)"
 ..W:BARA=4 " (INS TYPES V)"
 ..W:BARA=5 " (INS TYPES W C N I G T SEP TSI)"
 ..S BARB=1
 ;
 I $G(BARY("RTYP")) W !?3,"- Report Type..........: ",BARY("RTYP","NM")
 Q
 ;********************************************
 ;
PARM ;
 ;Choose additional inclusion parameters
 S (BARDONE2,BARDONE3)=0
 K DIR
 S DIR(0)="SO^1:LOCATION;2:ACTIVITY DATE RANGE;3:A/R TECHNICIAN;4:BILLING ENTITY;5:INSURER TYPE;6:ALLOWANCE CATEGORY;7:REPORT TYPE"
 S DIR("A")="Select ONE or MORE of the above INCLUSION PARAMETERS"
 D ^DIR
 K DIR
 I $E(Y)="^" S BARDONE=1 Q
 I $D(DTOUT)!($D(DUOUT)) S BARDONE2=1 Q
 S BARSEL=Y
 K BARTAG
 ;
 I $A(BARSEL)>32 D
 .S:BARSEL=1 BARTAG="LOC"
 .S:BARSEL=2 BARTAG="DT"
 .S:BARSEL=3 BARTAG="TECH"
 .S:BARSEL=4 BARTAG="BENT"
 .S:BARSEL=5 BARTAG="ITYP"
 .S:BARSEL=6 BARTAG="ALLC"
 .S:BARSEL=7 BARTAG="RTYP"
 .S BARTAG=BARTAG_"^BARERSL1"
 .D @BARTAG
 I +$G(BARDONE)=1 Q
 Q
