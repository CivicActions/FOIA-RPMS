BEHOEPOX ; IHS/MSC/MGH - CONTROLLED SUBSTANCE ORDER EXPORT ;02-Oct-2018 13:35;DU
 ;;1.1;BEH COMPONENTS;**070001**;Sep 23, 2004;Build 74
 ;
 ; IHS/MSC/MGH - 06/O1/2018^ - New report
EN ;EP
 N BEHBD,BEHED,BEHBDF,BEHEDF,BEHDIV,BEHRTYP,BEHDOSE,BEHQ,BEHDSUB,BEHOUT
 N BEHDCT,BEHDCTN,BEHDRG,BEHDET,BEHPROV,BEHPRV
 N BEHPAT,BEHRTOT,BEHCMOP,BEHERX,PRV,CNT,BEHTEST
 S BEHDIV="",BEHDRG="",BEHQ=0,BEHDSUB=0,BEHDOSE=0,BEHPRV=""
 S BEHPAT=""
 S CNT=0
 W @IOF
 W !!,"Digitally Signed Controlled Substance Order Export"
 W !,"This report is designed for Export ONLY."
 W !,"The data will be created in XML format for uploading into EXCEL or"
 W !,"uploaded into some other database."
 W !!,"   *** Provider Selection ***"
 S BEHPROV=+$$GETIEN1^BEHOEPUT(200,"Select Prescriber: ","-1","B")
 I BEHPROV<1 S BEHQ=1 Q
 D ASKDATES^BEHOEPUT(.BEHBD,.BEHED,.BEHQ,$$FMADD^XLFDT(DT,-1),$$FMADD^XLFDT(DT,-1))
 Q:BEHQ
 S BEHBDF=$P($TR($$FMTE^XLFDT(BEHBD,"5Z"),"@"," "),":",1,2)
 S BEHEDF=$P($TR($$FMTE^XLFDT(BEHED,"5Z"),"@"," "),":",1,2)
 S BEHBD=BEHBD-.01,BEHED=BEHED+.99
 S BEHTEST=$$DIR^APSPUTIL("Y","Include TEST Patients","No",,.BEHQ)
 Q:BEHQ
 D DEV
 Q
DEV ;
 N XBRP,XBNS
 S XBRP="OUT^BEHOEPOX"
 S XBNS="BEH*"
 D ^XBDBQUE
 Q
OUT ;EP
 U IO
 D FIND(BEHBD,BEHED,BEHPROV)
 D END
 Q
END K ^TMP("CSOUT",$J),^TMP("CS"),^TMP("STOUT",$J),BEHRTOT
 Q
 ;
FIND(SDT,EDT,PROV) ;EP
 N ORIEN,ORPROV,ACTIEN,RTSDT,FILLDT,PRVNAME,A0,FDTLP,IEN,CMOP,RXNUM,LOOP
 S FDTLP=SDT-.01
 S PRVNAME=$$GET1^DIQ(200,PROV,.01)
 I +$D(^ORPA(101.52,"C",PROV)) D DATES(PROV)
 Q
DATES(ORPROV) ;Get the selected dates
 N S1,S3,DATA0,DATA1,DATA3,DATA4,ORRX,ORDTE,PRV,ORPT,ORDEA,ORPNM,ORDRUG,DRGCT,DRCL
 N DA,DIC,DR,DIQ,DATA5,DATA2,DATA6,DIROUT,ORIFN,ORS,PRVNME,STR,ORDCT
 S ORDCT=0
 D HDRXML
 S S1=BEHBD
 F  S S1=$O(^ORPA(101.52,"C",ORPROV,S1)) Q:'S1!(S1>BEHED)  D
 .S PRVNME=$$GET1^DIQ(200,ORPROV,.01)
 .S S3=0
 .F  S S3=$O(^ORPA(101.52,"C",ORPROV,S1,S3)) Q:'S3  D
 ..S DATA0=$G(^ORPA(101.52,S3,0))
 ..S ORIFN=$P(DATA0,"^"),ORRX=$P(DATA0,"^",2)
 ..Q:'+ORIFN
 ..I 'BEHTEST Q:+$$TESTPT(ORIFN)   ;don't include test patients
 ..W !,$$TAG("Rx_data")
 ..S ORDCT=ORDCT+1
 ..D SET(S3)
 I ORDCT=0 W !,$$TAG("NoOrds",2,"No CS Orders Found")
 W !,$$TAG("Export",1)
 W !,$$TAG("Report",1)
 Q
SET(S3) ;Set the variables into XML
 N ERR,IENS,FLD,ADDR,NODE,ROUTE,STRENGTH,FORM,HASH,HIEN,DIG,USE,SIG,RX,BACKDOOR,IND,HARDCPY,DIR,TXT,CNT
 S DATA0=$G(^ORPA(101.52,S3,0)),DATA1=$G(^ORPA(101.52,S3,1)),DATA3=$G(^ORPA(101.52,S3,3)),DATA5=$G(^ORPA(101.52,S3,5))
 S DATA2=$G(^ORPA(101.52,S3,2)),DATA4=$G(^ORPA(101.52,S3,4)),DATA6=$G(^ORPA(101.52,S3,6))
 S IND=""
 S RX=$P(DATA0,U,2)
 W !,$$TAG("Order",2,$P(DATA0,U,1))
 I +RX D
 .S BACKDOOR=$P($G(^PSRX(RX,"PKI")),U,2)
 .I BACKDOOR=1 S IND="Backdoor"
 .S HARDCPY=$P($G(^PSRX(RX,999999941)),U,2)
 .I HARDCPY=1 S IND="Hardcopy"
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
 W !,$$TAG("Drug",2,$P(DATA1,U,2))
 W !,$$TAG("Issue_Date",2,$$FMTE^XLFDT($P(DATA1,U,1),"5Z"))
 W !,$$TAG("DEA_Sch",2,+$P(DATA1,U,4))
 W !,$$TAG("Quant",2,$P(DATA1,U,5))
 W !,$$TAG("Refills",2,$P(DATA1,U,6))
 S NODE=""
 W !,$$TAG("Dir_Lst")
 S USE=0 F  S USE=$O(^ORPA(101.52,S3,2,USE)) Q:USE=""  D
 .S NODE=$G(^ORPA(101.52,S3,2,USE,0))
 .W !,$$TAG("Directions")
 .W !,$$TAG("Schedule",2,$P(NODE,"|",2))
 .W !,$$TAG("Dosage",2,$P($P(NODE,"|",1),"&",5))
 .I $P(NODE,"|",3)'="" W !,$$TAG("Length",2,$P(NODE,"|",3))
 .I $P(NODE,"|",4)'="" D
 ..S CONJ=$P(NODE,"|",4)
 ..W !,$$TAG("Conjunction",2,$S(CONJ="S":"Then",1:"And"))
 .S ROUTE=$P(NODE,"|",5)
 .W !,$$TAG("Route",2,$$GET1^DIQ(51.2,ROUTE,.01))
 .W !,$$TAG("Directions",1)
 W !,$$TAG("Dir_Lst",1)
 W !,$$TAG("NotDigSig",2,IND)
 S DIR=""
 S IEN=$O(^OR(100,ORIFN,4.5,"ID","SIG",""))
 I +IEN D
 .S CNT=0
 .F  S CNT=$O(^OR(100,ORIFN,4.5,IEN,2,CNT)) Q:'+CNT  D
 ..S TXT=$G(^OR(100,ORIFN,4.5,IEN,2,CNT,0))
 ..I DIR="" S DIR=TXT
 ..E  S DIR=DIR_TXT
 W !,$$TAG("SIG",2,DIR)
 S HIEN=""
 S HASH=$P(DATA0,U,3)
 I HASH'="" S HIEN=$O(^XUSSPKI(8980.2,"B",$E(HASH,1,30),""))
 S SIG=""
 I HIEN'="" D
 .S DIG=0 F  S DIG=$O(^XUSSPKI(8980.2,HIEN,1,DIG)) Q:DIG=""  D
 ..I SIG="" S SIG=$G(^XUSSPKI(8980.2,HIEN,1,DIG,0))
 ..E  S SIG=SIG_$G(^XUSSPKI(8980.2,HIEN,1,DIG,0))
 I SIG'="" W !,$$TAG("DigSig",2,SIG)
 W !,$$TAG("Rx_data",1)
 Q
HDRXML ;EP - XML Header
 W $$XMLHDR^MXMLUTL()  ;"<?xml version='1.0'?>"
 W !,$$TAG("Report")
 W !,$$TAG("ReportName",2,"Provider Controlled Substance Export.")
 W !,$$TAG("ReportDate",2,$P($TR($$FMTE^XLFDT($$NOW^XLFDT,"5Z"),"@"," "),":",1,2))
 W !,$$TAG("ReportCriteria")
 W !,$$TAG("InclusiveDates",2,BEHBDF_" to "_BEHEDF)
 W !,$$TAG("Prescriber",2,"Provider: "_$$GET1^DIQ(200,BEHPROV,.01))
 W !,$$TAG("TestPts",2,$S(BEHTEST:"Included",1:"Not Included"))
 W !,$$TAG("TypeData",2,"Type of Data: SENSITIVE (CUI:PRVCY),(CUI:HLTH)")
 W !,$$TAG("ReportCriteria",1)
 W !,$$TAG("Export")
 Q
TESTPT(ORDER) ;find if testpt
 N TEST,DFN,IND,SSN,NAME
 S TEST=0
 S DFN=+$P($G(^OR(100,ORDER,0)),U,2)
 Q:'+DFN 0
 S IND=$$GET1^DIQ(2,DFN,.6)
 S SSN=$$GET1^DIQ(2,DFN,.09)
 S NAME=$$GET1^DIQ(2,DFN,.01)
 I (IND="YES")!(SSN?5"0".E)!(NAME?1"DEMO,PATIENT".E)!(NAME?1"DEMO,GIMC".E) S TEST=1
 Q TEST
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
