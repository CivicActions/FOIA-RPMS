BCERECK4 ;GDIT/HCSD/ALA - BCER ENVIRONMENT CHECKER FOR CHIT ; 19 Dec 2019  5:37 PM
 ;;4.0;BCER;**1**;Aug 28, 2020;Build 1
 ;
 ;
MAIN ;EP
 NEW XUNAME,XUFMT,XUFLAG,XUDLM
 I '$G(DUZ) U IO W !,"DUZ UNDEFINED OR 0." Q
 I '$L($G(DUZ(0))) U IO W !,"DUZ(0) UNDEFINED OR NULL." Q
 S X=$P(^VA(200,DUZ,0),U)
 S XUNAME=X,XUFMT="G",XUFLAG="S",XUDLM=" "
 U IO W !!,$$CJ^XLFSTR("Hello, "_$$NAMEFMT^XLFNAME1(XUNAME,XUFMT,XUFLAG,XUDLM),IOM)
 U IO W !!,$$CJ^XLFSTR("Checking Environment for 2015 Certified Health IT (CHIT) Software",IOM)
 U IO W !,$$CJ^XLFSTR("SEPTEMBER 2020",IOM),!
 ;U IO W !,$$CJ^XLFSTR("For Facility "_$P($G(^DIC(4,DUZ(2),0)),U),IOM),!!
 NEW FTEXT,CT
 S N=0,CT=0 F  S N=$O(^AGFAC(N)) Q:'N  D
 . I $P(^AGFAC(N,0),"^",21)="Y",$P(^AUTTLOC(N,0),"^",21)="" S FTEXT=$P(^DIC(4,N,0),"^",1) D
 .. S CT=CT+1 I CT=1 U IO W !,$$CJ^XLFSTR("For: "_FTEXT,IOM)
 .. E  U IO W !,$$CJ^XLFSTR("     "_FTEXT,IOM)
 U IO W !!
 ; Start checker
 NEW BI,TEXT,ZYES,ZNO,SYSVER,EXEC,FLAG,BVER,QFL
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BCERECK3"
 ;S EXEC="S SYSVER=$SYSTEM.Version.GetISCProduct()" X EXEC
 ;I SYSVER'=3 W !,"This system is not HealthShare" Q
 ;I SYSVER=3,$P($$VERSION^%ZOSV(),".",1)'>2016 W !,"This IS HealthShare but the version is not 2017 or higher" Q
 S BVER=$$VERSION^%ZOSV(),BVER=$$STRIP(BVER," "),QFL=0
 I BVER="2017.2.2" U IO W !,?5,"HealthShare System version is "_BVER,!
 I BVER'="2017.2.2" D
 . I $P(BVER,".",1)>2017 Q
 . ;I $P($$VERSION^%ZOSV(),".",1)'>2016,$P($$VERSION^%ZOSV(),".",2)'>1 W !,"HealthShare System version is not 2017.2 or higher"
 . I BVER'="2017.2.2" U IO W !,"HealthShare System is not the needed minimum version of 2017.2.2" S QFL=1
 ;
 I QFL Q
 ; BMW 2020.3
 I $G(^BMW("Version"))="2020.3" W !,?5,"BMW Version 2020.3 IS installed",! S FLAG=0
 E  W !,?5,"BMW Version 2020.3 is NOT installed",! S FLAG=1
 ;
 NEW EXEC,BPEXIST
 S EXEC="SET BPEXIST=##class(%Dictionary.CompiledClass).%ExistsId(""BMW.BSF.SP.AgSetPatientGenderIdentity"")"
 X EXEC
 I BPEXIST=1 W !,?5,"BPRM IS installed"
 E  W !,?5,"BPRM is NOT installed" S FLAG=1
 W !!
 ;
 F BI=1:1 S TEXT=$T(LIST+BI) Q:TEXT=" Q"  D
 . S TEXT=$P(TEXT,";;",2)
 . I $$PATCH^XPDUTL(TEXT) S ZYES(TEXT)="" Q
 . S ZNO(TEXT)=""
 ;
 I $O(^XPD(9.7,"B","EHR*1.1*28",""))'="" S ZYES("EHR*1.1*28")=""
 E  S ZNO("EHR*1.1*28")=""
 I $O(^XPD(9.7,"B","EHR*1.1*29",""))'="" S ZYES("EHR*1.1*29")=""
 E  S ZNO("EHR*1.1*29")=""
 ;
 I $$VERSION^XPDUTL("BEDD")'="" D
 . I $$PATCH^XPDUTL("BEDD*2.0*5") S ZYES("BEDD*2.0*5")=""
 . E  S ZNO("BEDD*2.0*5")=""
 ;
 ; Removed for t2 build 8/28/2020 ALA
 ;NEW PVL,PENT
 ;S PVL=$O(^XTV(8989.51,"B","APSP AUTO RX","")) D
 ;. I PVL="" Q
 ;. S PENT="" F  S PENT=$O(^XTV(8989.5,"AC",PVL,PENT)) Q:PENT=""  D
 ;.. I '$$GET^XPAR(PENT,"APSP AUTO RX DIV") Q
 ;.. I $$PATCH^XPDUTL("BEPR*2.0*3") S ZYES("BEPR*2.0*3")=""
 ;.. E  S ZNO("BEPR*2.0*3")=""
 ;
 ;APCM V2.0, BCCD v2.0, BYIM v3.0, BCOM v1.0
 I $$VERSION^XPDUTL("APCM")="2.0" S ZYES("APCM v2.0")=""
 E  S ZNO("APCM v2.0")=""
 I $$VERSION^XPDUTL("BCCD")="2.0" S ZYES("BCCD v2.0")=""
 E  S ZNO("BCCD v2.0")=""
 I $$VERSION^XPDUTL("BYIM")="3.0" S ZYES("BYIM v3.0")=""
 E  S ZNO("BYIM v3.0")=""
 I $$VERSION^XPDUTL("BCOM")="1.0" S ZYES("BCOM v1.0")=""
 E  S ZNO("BCOM v1.0")=""
 ;
 S TEXT="",FLAG=0 F  S TEXT=$O(ZNO(TEXT)) Q:TEXT=""  D
 . U IO W !,"You DO NOT HAVE patch "_TEXT_" installed!" S FLAG=1
 U IO W !!
 S TEXT="" F  S TEXT=$O(ZYES(TEXT)) Q:TEXT=""  D
 . U IO W !,"You HAVE patch "_TEXT_" installed" Q
 ;
 I FLAG=1 U IO W !!!!,"**You do NOT have all the installs needed for 2015 CHIT requirements.**"
 I FLAG=0 D
 . U IO W !!!!,"**This database has all of the installs released to date by IHS for 2015 Edition Certified EHR Technology (CEHRT)."
 . W !,"Check with your Promoting Interoperability Coordinator to identify the CEHRT requirements for any incentive or"
 . W !,"quality programs in which your facility or clinicians may participate.**"
 . W !!,"IHS 2015 Certified HealthIT Certification Criteria / Clinical Quality Measures include the following:"
 . F BI=1:1 S TEXT=$T(MEAS+BI) Q:TEXT=" Q"  D
 .. S TEXT=$P(TEXT,";;",2)
 .. W !?5,TEXT
 Q
 ;
ERR ;EP
 D ^%ZTER
 Q
 ;
STRIP(STR,VAL) ;EP
 I $G(STR)="" Q ""
 I $G(VAL)="" Q ""
 ;
 NEW LV
 S LV=$L(VAL)
 I $E(STR,$L(STR)-(LV-1),$L(STR))=VAL S STR=$E(STR,1,$L(STR)-LV)
 ;
 Q STR
 ;
LIST ;List of installs needed
 ;;APCL*3.0*32
 ;;APSP*7.0*1025
 ;;BCQM*1.0*6
 ;;DI*22.0*1020
 ;;XT*7.3*1019
 ;;XU*8.0*1020
 ;;AG*7.1*15
 ;;APSP*7.0*1026
 ;;AUPN*99.1*28
 ;;AUT*98.1*29
 ;;AVA*93.2*25
 ;;AVA*93.2*26
 ;;BI*8.5*19
 ;;BJPC*2.0*24
 ;;BPHR*2.1*4
 ;;BQI*2.8*1
 ;;BSTS*2.0*3
 ;;BUSA*1.0*3
 ;;LR*5.2*1047
 ;;RA*5.0*1008
 ;;BI*8.5*19
 ;;TIU*1.0*1022
 ;;APSP*7.0*1026
 ;;AUM*20.0*3
 Q
 ;
MEAS ; List of measures
 ;;> 170.315 (a)(1): Computerized Provider Order Entry (CPOE) - Medications
 ;;> 170.315 (a)(2): CPOE - Laboratory
 ;;> 170.315 (a)(3): CPOE - Diagnostic Imaging
 ;;> 170.315 (a)(4): Drug-Drug, Drug-Allergy Interaction Checks for CPOE
 ;;> 170.315 (a)(5): Demographics
 ;;> 170.315 (a)(9): Clinical Decision Support
 ;;> 170.315 (a)(10): Drug-Formulary and Preferred Drug List Checks
 ;;> 170.315 (a)(12): Family Health History
 ;;> 170.315 (a)(13): Patient-Specific Education Resources
 ;;> 170.315 (a)(14): Implantable Device List
 ;;> 170.315 (b)(1): Transitions of Care
 ;;> 170.315 (b)(2): Clinical Information Reconciliation and Incorporation
 ;;> 170.315 (b)(6): Data Export
 ;;> 170.315 (c)(1): Clinical quality measures (CQMs) - record and export
 ;;> 170.315 (c)(2): Clinical quality measures (CQMs) - import and calculate
 ;;> 170.315 (c)(3): Clinical quality measures (CQMs) - report
 ;;> 170.315 (d)(1): Authentication, Access Control, Authorization
 ;;> 170.315 (d)(2): Auditable Events and Tamper-Resistance
 ;;> 170.315 (d)(3): Audit Report(s)
 ;;> 170.315 (d)(4): Amendments
 ;;> 170.315 (d)(5): Automatic Access Time-out
 ;;> 170.315 (d)(6): Emergency Access
 ;;> 170.315 (d)(7): End-User Device Encryption
 ;;> 170.315 (d)(8): Integrity
 ;;> 170.315 (d)(9): Trusted Connection
 ;;> 170.315 (d)(12): Encrypt authentication credentials
 ;;> 170.315 (d)(13): Multi-factor authentication
 ;;> 170.315 (e)(1): View, Download, and Transmit to 3rd Party
 ;;> 170.315 (e)(2): Secure Messaging
 ;;> 170.315 (e)(3): Patient Health Information Capture
 ;;> 170.315 (f)(1): Transmission to immunization registries
 ;;> 170.315 (f)(2): Transmission to Public Health Agencies - Syndromic Surveillance
 ;;> 170.315 (f)(3): Transmission to public health agencies - reportable laboratory tests and value/results
 ;;> 170.315 (f)(5): Transmission to public health agencies - electronic case reporting
 ;;> 170.315 (g)(2): Automated Measure Calculation
 ;;> 170.315 (g)(3): Safety-Enhanced Design
 ;;> 170.315 (g)(4): Quality Management System
 ;;> 170.315 (g)(5): Accessibility-Centered Design
 ;;> 170.315 (g)(6): Consolidated CDA Creation
 ;;> 170.315 (g)(7): Application Access - Patient Selection
 ;;> 170.315 (g)(8): Application Access - Data Category Request
 ;;> 170.315 (g)(9): Application Access - All Data Request
 ;;> 170.315 (h)(1): Direct Project
 Q
