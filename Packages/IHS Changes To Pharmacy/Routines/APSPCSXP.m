APSPCSXP ; IHS/MSC/MGH - CONTROLLED SUBSTANCE PRESCRIPTION EXPORT ;20-Sep-2018 13:21;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1023**;Sep 23, 2004;Build 121
 ;
 ; IHS/MSC/MGH - 06/O1/2018^ - New report
EN ;EP
 N APSPBD,APSPED,APSPBDF,APSPEDF,APSPDIV,APSPRTYP,APSPQ,APSPDSUB,APSPOUT,APSPTEST
 N APSPDCT,APSPDCTN,APSPDRG,APSPDET,APSPDOSE,APSPPROV,APSPPRV
 N APSPPAT,APSPRTOT,APSPCMOP,APSPERX,PRV,CNT
 S APSPDIV="",APSPDRG="",APSPQ=0,APSPDSUB=0,APSPDOSE=0,APSPPRV=""
 S APSPPAT=""
 S CNT=0
 W @IOF
 W !!,"Digitally Signed Controlled Substance Pharmacy Export"
 W !,"This report is designed for Export ONLY."
 W !,"The data will be created in XML format for uploading into EXCEL or"
 W !,"uploaded into some other database."
 W !!,"   *** Provider Selection ***"
 S APSPPROV=+$$GETIEN1^APSPUTIL(200,"Select Prescriber: ","-1","B")
 I APSPPROV<1 S APSPQ=1 Q
 D ASKDATES^APSPUTIL(.APSPBD,.APSPED,.APSPQ,$$FMADD^XLFDT(DT,-1),$$FMADD^XLFDT(DT,-1))
 Q:APSPQ
 S APSPBDF=$P($TR($$FMTE^XLFDT(APSPBD,"5Z"),"@"," "),":",1,2)
 S APSPEDF=$P($TR($$FMTE^XLFDT(APSPED,"5Z"),"@"," "),":",1,2)
 S APSPBD=APSPBD-.01,APSPED=APSPED+.99
 S APSPTEST=$$DIR^APSPUTIL("Y","Include TEST Patients","No",,.APSPQ)
 Q:APSPQ
 D DEV
 Q
DEV ;
 N XBRP,XBNS
 S XBRP="OUT^APSPCSXP"
 S XBNS="APSP*"
 D ^XBDBQUE
 Q
OUT ;EP
 U IO
 D FIND(APSPBD,APSPED,APSPPROV)
 D END
 Q
END K ^TMP("CSOUT",$J),^TMP("CS"),^TMP("STOUT",$J),APSPRTOT
 Q
 ;
FIND(SDT,EDT,PROV) ;EP
 N ORIEN,ORPROV,ACTIEN,RTSDT,FILLDT,PRVNAME,A0,FDTLP,IEN,CMOP,RXNUM,LOOP
 S FDTLP=SDT-.01
 S PRVNAME=$$GET1^DIQ(200,PROV,.01)
 I +$D(^ORPA(101.52,"C",PROV)) D DATES(PROV)
 Q
DATES(ORPROV) ;Get the selected dates
 N S1,S3,DATA0,DATA1,DATA3,DATA4,ORDTE,PRV,ORPT,ORDEA,ORPNM,ORDRUG,DRGCT,DRCL
 N DA,DIC,DR,DIQ,DATA5,DATA2,DATA6,DIROUT,ORIFN,ORS,PRVNME,STR,RX,DFN,RX,DRGCT
 S DRGCT=0
 D HDRXML
 S S1=APSPBD
 F  S S1=$O(^ORPA(101.52,"C",ORPROV,S1)) Q:'S1!(S1>APSPED)  D
 .S PRVNME=$$GET1^DIQ(200,ORPROV,.01)
 .S S3=0
 .F  S S3=$O(^ORPA(101.52,"C",ORPROV,S1,S3)) Q:'S3  D
 ..S DATA0=$G(^ORPA(101.52,S3,0))
 ..S ORIFN=$P(DATA0,"^")
 ..Q:'+ORIFN
 ..S RX=$P(DATA0,U,2)
 ..Q:'+RX     ;Must have prescription to count
 ..S DFN=+$P($G(^OR(100,ORIFN,0)),U,2)
 ..I 'APSPTEST Q:+$$TESTPT^APSPUTIL(ORIFN)   ;don't include test patients
 ..W !,$$TAG("Rx_data")
 ..D SET(S3,RX)
 I DRGCT=0 W !,$$TAG("Nodrgs",2,"No CS Prescriptions Found")
 W !,$$TAG("Export",1)
 W !,$$TAG("Report",1)
 Q
SET(S3,RX) ;Set the data into XML
 N ERR,IENS,FLD,ADDR,NODE,ROUTE,STRENGTH,FORM,HASH,HIEN,DIG,SIG,ORDER,CONJ
 N EARLY,USE,DOSE,BACKDOOR,IND,DIR,IEN,TXT,UPD,NOUN,IND,BACKDOOR,HARDCPY,UNITS
 S DATA0=$G(^ORPA(101.52,S3,0)),DATA1=$G(^ORPA(101.52,S3,1)),DATA3=$G(^ORPA(101.52,S3,3)),DATA5=$G(^ORPA(101.52,S3,5))
 S DATA2=$G(^ORPA(101.52,S3,2)),DATA4=$G(^ORPA(101.52,S3,4)),DATA6=$G(^ORPA(101.52,S3,6))
 S ORDER=$P(DATA0,U,1)
 S IND=""
 ;Get the patient information
 W !,$$TAG("Patient",2,$P(DATA5,U,1))
 S ADDR=$P(DATA6,U,1)_" "_$P(DATA6,U,2)_" "_$P(DATA6,U,3)
 W !,$$TAG("Pt_Address",2,ADDR)
 W !,$$TAG("Pt_City",2,$P(DATA6,U,4))
 W !,$$TAG("Pt_State",2,$P(DATA6,U,5))
 W !,$$TAG("Pt_ZIP",2,$P(DATA6,U,6))
 ;Get the provider information
 W !,$$TAG("Provider",2,$P(DATA3,U,3))
 W !,$$TAG("Provider_DEA",2,$P(DATA3,U,1))
 I $P(DATA3,U,2)'="" W !,$$TAG("Provider_DEA_X",2,$P(DATA3,U,2))
 S ADDR=$P(DATA4,U,1)_" "_$P(DATA4,U,2)_" "_$P(DATA4,U,3)
 W !,$$TAG("Prov_Address",2,ADDR)
 W !,$$TAG("Prov_City",2,$P(DATA4,U,4))
 W !,$$TAG("Prov_State",2,$P(DATA4,U,5))
 W !,$$TAG("Prov_ZIP",2,$P(DATA4,U,6))
 ;Medication Information
 W !,$$TAG("RX",2,$P($G(^PSRX(RX,0)),U,1))
 W !,$$TAG("Drug",2,$P(DATA1,U,2))
 W !,$$TAG("Issue_Date",2,$$FMTE^XLFDT($P(DATA1,U,1),"5Z"))
 W !,$$TAG("DEA_Sch",2,+$P(DATA1,U,4))
 W !,$$TAG("Quant",2,$P(DATA1,U,5))
 W !,$$TAG("Refills",2,$P(DATA1,U,6))
 S EARLY=$$VALUE^ORCSAVE2(ORDER,"EARLIEST")
 I EARLY'="" W !,$$TAG("Earliest",2,$$FMTE^XLFDT(EARLY,"5Z"))
 W !,$$TAG("Dir_Lst")
 S USE=0 F  S USE=$O(^PSRX(RX,6,USE)) Q:USE=""  D
 .S NODE=$G(^PSRX(RX,6,USE,0))
 .W !,$$TAG("Directions")
 .W !,$$TAG("Schedule",2,$P(NODE,U,8))
 .S DOSE=$P(NODE,U,1)
 .W !,$$TAG("Dosage",2,DOSE)
 .S UNITS=$P(NODE,U,3)
 .I UNITS'="" W !,$$TAG("Units",2,$$GET1^DIQ(50.607,UNITS,.01))
 .S UPD=$P(NODE,U,2)
 .W !,$$TAG("UnitsPerDose",2,UPD)
 .S NOUN=$P(NODE,U,4)
 .W !,$$TAG("DoseForm",2,NOUN)
 .I $P(NODE,U,5)'="" W !,$$TAG("Duration",2,$P(NODE,U,5))
 .S CONJ=$P(NODE,U,6)
 .I CONJ'="" W !,$$TAG("Conjunction",2,$S(CONJ="T":"Then",1:"And"))
 .S ROUTE=$P(NODE,U,7)
 .W !,$$TAG("Route",2,$$GET1^DIQ(51.2,ROUTE,.01))
 .W !,$$TAG("Directions",1)
 W !,$$TAG("Dir_Lst",1)
 S IND=""
 S BACKDOOR=$P($G(^PSRX(RX,"PKI")),U,2)
 I BACKDOOR=1 S IND="Backdoor"
 S HARDCPY=$P($G(^PSRX(RX,999999941)),U,2)
 I HARDCPY=1 S IND="Hardcopy"
 I IND'="" W !,$$TAG("NoDigSig",2,IND)
 S DIR=""
 S CNT=0 F  S CNT=$O(^PSRX(RX,"SIG1",CNT)) Q:'+CNT  D
 .S TXT=$G(^PSRX(RX,"SIG1",CNT,0))
 .I DIR="" S DIR=TXT
 .E  S DIR=DIR_TXT
 W !,$$TAG("SIG",2,DIR)
 S HIEN="",SIG=""
 S HASH=$P(DATA0,U,3)
 I HASH'="" S HIEN=$O(^XUSSPKI(8980.2,"B",$E(HASH,1,30),""))
 I HIEN'="" D
 .S DIG=0 F  S DIG=$O(^XUSSPKI(8980.2,HIEN,1,DIG)) Q:DIG=""  D
 ..I SIG="" S SIG=$G(^XUSSPKI(8980.2,HIEN,1,DIG,0))
 ..E  S SIG=SIG_$G(^XUSSPKI(8980.2,HIEN,1,DIG,0))
 I SIG'="" W !,$$TAG("DigSig",2,SIG)
 W !,$$TAG("Rx_data",1)
 Q
HDRXML ;EP - XML Header
 N S
 W $$XMLHDR^MXMLUTL()  ;"<?xml version='1.0'?>"
 W !,$$TAG("Report")
 W !,$$TAG("ReportName",2,"Provider Controlled Substance Prescription Export.")
 W !,$$TAG("ReportDate",2,$P($TR($$FMTE^XLFDT($$NOW^XLFDT,"5Z"),"@"," "),":",1,2))
 W !,$$TAG("ReportCriteria")
 W !,$$TAG("InclusiveDates",2,APSPBDF_" to "_APSPEDF)
 W !,$$TAG("Prescriber",2,"Provider: "_$$GET1^DIQ(200,APSPPROV,.01))
 W !,$$TAG("TestPts",2,$S(APSPTEST:"Included",1:"Not Included"))
 W !,$$TAG("TypeData",2,"Type of Data: SENSITIVE (CUI:PRVCY),(CUI:HLTH)")
 W !,$$TAG("ReportCriteria",1)
 W !,$$TAG("Export")
 Q
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
IND ;Entry point for an individual order number
 N APSPIEN,APSPOR
 W !!,"Controlled Substance Individual Pharmacy Export"
 W !,"This report is designed for Export ONLY of one digitally signed controlled"
 W !,"substance order. The data will be created in XML format for uploading into"
 W !,"EXCEL or uploaded into some other database."
 W !!,"   *** Order Selection ***"
 S APSPOR=+$$GETIEN1^APSPUTIL(100,"Select Order: ","-1","B")
 S APSPIEN=$O(^ORPA(101.52,"B",APSPOR,""))
 I '+APSPIEN W !,"Unable to find that order number" Q
 D DEV2
 Q
DEV2 ;Get the device
 N XBRP,XBNS
 S XBRP="OUT2^APSPCSXP"
 S XBNS="APSP*"
 D ^XBDBQUE
 Q
OUT2 ;EP
 U IO
 D GET(APSPIEN)
 D END
 Q
GET(APSPIEN) ;Get the data for this order
 N RX
 D INDXML
 W !,$$TAG("Rx_data")
 W !,$$TAG("Order",2,APSPOR)
 S RX=$P($G(^ORPA(101.52,APSPIEN,0)),U,2)
 I +RX D SET(APSPIEN,RX)
 W !,$$TAG("Rx_data")
 W !,$$TAG("Order",2,"Sample")
 W !,$$TAG("Rx_data",1)
 W !,$$TAG("Orders",1)
 W !,$$TAG("Report",1)
 Q
INDXML ;EP - XML Header
 N S
 W $$XMLHDR^MXMLUTL()  ;"<?xml version='1.0'?>"
 W !,$$TAG("Report")
 W !,$$TAG("ReportCriteria")
 W !,$$TAG("ReportName",2,"One Prescription Export")
 W !,$$TAG("TypeData",2,"Type of Data: SENSITIVE (CUI:PRVCY),(CUI:HLTH)")
 W !,$$TAG("ReportCriteria",1)
 W !,$$TAG("Orders")
 Q
