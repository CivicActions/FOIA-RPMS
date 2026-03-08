APSPCSM2 ; IHS/MSC/PLS - CONTROLLED SUBSTANCE MANAGEMENT REPORT ;24-Sep-2019 16:35;MGH
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1023,1024**;Sep 23, 2004;Build 68
 ;=====================================================================
 ;IHS/GDIT/MSC/MGH added report for EPCS
 ;
 Q
 ; Print the line
PRINT2(DATA) ; EP -
 N RX,DFN,HRN,SIGNED
 S RX=+DATA
 S SIGNED=""
 S DFN=$$GET1^DIQ(52,RX,2,"I")
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 D STATS^APSPCSM(DATA)
 I APSPXML D
 .W !,$$TAG("Dispense")
 .W !,$$TAG("SignDate",2,$P($TR($$FMTE^XLFDT($P(DATA,U,18),"5Z"),"@"," "),":",1,2))
 .W !,$$TAG("Type",2,$P(DATA,U,9))
 .W !,$$TAG("PatientName",2,$$GET1^DIQ(2,DFN,.01))
 .W !,$$TAG("PatientHRN",2,HRN)
 .W !,$$TAG("PrescriptionNumber",2,$$GET1^DIQ(52,RX,.01))
 .W !,$$TAG("DrugName",2,$P(DATA,U,8))
 .W !,$$TAG("QTY",2,$P(DATA,U,6))
 .W !,$$TAG("DaysSupply",2,$P(DATA,U,13))
 .W !,$$TAG("DrugSchedule",2,$P(DATA,U,7))
 .;W !,$$TAG("Provider",2,$$GET1^DIQ(200,$P($P(DATA,U,14),"|",1),.01))
 .;W !,$$TAG("ProviderDEA",2,$$GET1^DIQ(200,$P(DATA,U,14),53.2))
 .;W !,$$TAG("Pharmacist",2,$$GET1^DIQ(200,$P(DATA,U,15),.01))
 .W !,$$TAG("RefillsRemaining",2,$P(DATA,U,16))
 .;Patch 1024 EPCS data
 .I $P(DATA,U,21)'="" W !,$$TAG("DigSigned",2,$P(DATA,U,21))
 .I $P(DATA,U,22)'="" W !,$$TAG("HardCopy",2,$P(DATA,U,22))
 .I $P(DATA,U,23)'="" W !,$$TAG("BackDoor",2,$P(DATA,U,23))
 .I $P(DATA,U,21)=""&($P(DATA,U,22)="")&($P(DATA,U,23)="") W !,$$TAG("Clinic",2,"Clinic")
 .;IHS/MSC/MGH Patch 1015
 .W !,$$TAG("CMOP",2,$P(DATA,U,17))
 .W !,$$TAG("Pharmacy",2,$P(DATA,U,19))
 .;W !,$$TAG("Nature",2,$P(DATA,U,20))
 .W !,$$TAG("Dosing",2,$$GETSIG^APSPCSM1(RX))
 .W !,$$TAG("Dispense",1)
 E  D
 .;IHS/MSC/MGH Patch 1015 added CMOP field
 .I $P(DATA,U,21)'="" S SIGNED="Dig Sig"
 .I $P(DATA,U,22)'="" S SIGNED="Hardcopy"
 .I $P(DATA,U,23)'="" S SIGNED="Backdoor"
 .I $P(DATA,U,21)=""&($P(DATA,U,22)="")&($P(DATA,U,23)="") S SIGNED="Clinic"
 .W !,?2,$P($TR($$FMTE^XLFDT($P(DATA,U,18),"5Z"),"@"," "),":",1,2),?22,$E($P(DATA,U,8),1,24),?50,$E($$GET1^DIQ(2,DFN,.01),1,16),?75,HRN,?85,$$GET1^DIQ(52,RX,.01),?95,$P(DATA,U,7)
 .W !,?5,SIGNED,?15,$P(DATA,U,6),?25,$P(DATA,U,13),?37,$P(DATA,U,16),?50,$P(DATA,U,17),?60,$P(DATA,U,19)
 .W !,?5,"Dosing:" D OUTSIG^APSPCSM1($$GETSIG^APSPCSM1(RX),IOM,12)
 .D PRINT3 ;check page length
 Q
 ; Check page length and optionally print blank line
 ;
PRINT3 ;EP
 D:$Y+8>IOSL HDR^APSPCSM1
 Q
 ;
 ; Returns formatted tag
 ; Input: TAG - Name of Tag
 ;        TYPE - (-1) = empty 0 =start <tag>   1 =end </tag>  2 = start -VAL - end
 ;        VAL - data value
TAG(TAG,TYPE,VAL) ;EP
 S TYPE=$G(TYPE,0)
 S:$L($G(VAL)) VAL=$$SYMENC^MXMLUTL(VAL)
 I TYPE<0 Q "<"_TAG_"/>"  ;empty
 E  I TYPE=1 Q "</"_TAG_">"
 E  I TYPE=2 Q "<"_TAG_">"_$G(VAL)_"</"_TAG_">"
 Q "<"_TAG_">"
 ;
HDRXML ;EP - XML Header
 W $$XMLHDR^MXMLUTL()  ;"<?xml version='1.0'?>"
 W !,$$TAG("Report")
 W !,$$TAG("ReportName",2,"Controlled Substance Management Report-EPCS Provider")
 W !,$$TAG("ReportDate",2,$P($TR($$FMTE^XLFDT($$NOW^XLFDT,"5Z"),"@"," "),":",1,2))
 W !,$$TAG("ReportCriteria")
 W !,$$TAG("InclusiveDates",2,APSPBDF_" to "_APSPEDF)
 W !,$$TAG("PharmacyDivision",2,$S(APSPDIV:$$GET1^DIQ(59,APSPDIV,.01),1:"All"))
 W !,$$TAG("DrugClass",2,APSPDCTN(APSPDCLS))
 W !,$$TAG("SortBy","Prescriber, Sign Date, Drug Name then Patient")
 I APSPPRV W !,$$TAG("Prescriber sort restricted to "_$$GET1^DIQ(200,APSPPRV,.01),2)
 W !,$$TAG("CMOP",2,$S(APSPCMOP=1:"CMOP Included",1:"CMOP Not Included"))
 W !,$$TAG("TestPts",2,$S(APSPTEST:"Included",1:"Not Included"))
 W !,$$TAG("ReportCriteria",1)
 W !,$$TAG("Dispenses")
 Q
 ;
DASH ;EP
 N DASH
 W ! F DASH=1:1:IOM W "-"
 W !
 Q
 ;
 ; Returns formatted tag
 ; Input: TAG - Name of Tag
 ;        TYPE - (-1) = empty 0 =start <tag>   1 =end </tag>  2 = start -VAL - end
 ;        VAL - data value
 ;EP
 S TYPE=$G(TYPE,0)
 S:$L($G(VAL)) VAL=$$SYMENC^MXMLUTL(VAL)
 I TYPE<0 Q "<"_TAG_"/>"  ;empty
 E  I TYPE=1 Q "</"_TAG_">"
 E  I TYPE=2 Q "<"_TAG_">"_$G(VAL)_"</"_TAG_">"
 Q "<"_TAG_">"
