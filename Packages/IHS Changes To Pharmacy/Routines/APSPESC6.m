APSPESC6 ;IHS/MSC/PLS - SureScripts Interface Support;19-May-2021 16:30;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1028**;Sep 23, 2004;Build 50
 Q
 ;
CDETAIL(RET,IEN) ;put order details into XML format
 N HLMSG,DLM,APSPMSH,APSPPID,APSPORC,APSPRXO,APSPRXE,APSPRXR,DFN,SEX,DOB,VTYP,I
 N PAT,QTY,PROVDAT,PROV,DRUG,INST,STR,UNITS,ROUTE,NOUN,CNT,WTDT,HTDT,AGE,DAYS,NOTES
 N USCHDUR,MEDUNITS,REFILLS,PHARM,SIGDAT,HLECH,DONE,DUR,WRITTEN,EFF,TYPE,FORM
 N IPHONE,IADD,IST,IZIP,ICITY,NPI,HTYP,WTYP,WVALUE,HVALUE,WUNIT,HUNIT,WDTE,HDTE
 S HLECH=$P($G(APSPMSH),"|",2) I '$L(HLECH) S HLECH="^~\&"
 S RET=$$TMPGBL
 S CNT=0
 ;Patient information
 S (AGE,WVALUE,HVALUE,WTDT,HTDT)=""
 F I=1:1:4 D
 .S HLECH(I)=$E(HLECH,I)
 S HLMSG=$$GHLDAT^APSPESLP(IEN)
 D SHLVARS^APSPESLP
 S DLM="|"
 S PAT=$$PATNAME^APSPESLP(APSPPID) I '$L(PAT) S PAT="**UNKNOWN**"
 S DFN=$$GET1^DIQ(9009033.91,IEN,1.2,"I")
 S AGE=$$AGE^AUPNPAT(DFN)
 S SEX=$P($G(APSPPID),DLM,9)
 S DOB=$$FMTE^XLFDT($$FMDATE^HLFNC($P($G(APSPPID),DLM,8)))
 ;Provider data
 S PROVDAT=$P(APSPORC,DLM,13),PROV=$P(PROVDAT,HLECH(1),2)_","_$P(PROVDAT,HLECH(1),3)
 S NPI=$P(PROVDAT,HLECH(1),1)
 D INST
 ;Medication data
 S DRUG=$P($P($G(APSPRXE),DLM,3),U,2)
 S QTY=$P($P(APSPRXE,DLM,11),HLECH(1),1)
 S DAYS=$P($P(APSPORC,DLM,8),HLECH(1),3)
 S STR=$P($G(APSPRXE),DLM,3)
 S TYPE=$P($P($G(APSPRXE),DLM,12),HLECH(1),1)
 S UNITS=""
 I TYPE'="" D
 .S FORM=$O(^APSPNCP(9009033.7,"D",TYPE,""))
 .I FORM'="" S UNITS=$P($G(^APSPNCP(9009033.7,FORM,0)),U,2)
 S NOUN=$P($G(APSPRXO),DLM,6) I $L(NOUN) S NOUN=$O(^APSPNCP(9009033.7,"B",NOUN,0)),NOUN=$$GET1^DIQ(9009033.7,NOUN,1,"E")
 S USCHDUR=$P($G(APSPORC),DLM,8),MEDUNITS=$P($P($G(APSPRXO),DLM,20),HLECH(1),2)
 S REFILLS=$P(APSPRXE,DLM,13)
 S NOTES=$P(APSPRXE,DLM,22)
 S NOTES=$$SIGTXT^APSPESG1(NOTES)
 S PHARM=$$GET1^DIQ(9009033.91,IEN,1.7,"E")
 S SIGDAT=$P(APSPRXE,DLM,8)
 S SIGDAT=$$SIGTXT^APSPESG1(SIGDAT)
 S EFF=$P($P(APSPORC,DLM,16),HLECH(1),1)
 I +EFF S EFF=$$FMTE^XLFDT($$FMDATE^HLFNC(EFF))
 S WRITTEN=$P($P(APSPRXE,DLM,2),HLECH(1),4)
 I +WRITTEN S WRITTEN=$$FMTE^XLFDT($$FMDATE^HLFNC(WRITTEN))
 S (VTYP,WTYP,HTYP)=""
 I AGE<18 D OBX
 S VTYP=""
 ;Add the data into the tags
 D XMLHDR
 D ADD($$TAG("RxChangeConfirm",0))
 D ADD($$TAG("Pharmacy",0))
 D ADD($$TAG("Name",2,PHARM))
 D ADD($$TAG("Pharmacy",1))
 D ADD($$TAG("Patient",0))
 D ADD($$TAG("Name",0))
 D ADD($$TAG("Full",2,PAT))
 D ADD($$TAG("Name",1))
 D ADD($$TAG("Gender",2,SEX))
 D ADD($$TAG("Age",2,AGE))
 D ADD($$TAG("DateOfBirth",0))
 D ADD($$TAG("Date",2,DOB))
 D ADD($$TAG("DateOfBirth",1))
 D ADD($$TAG("Address",0))
 D ADD($$TAG("AddressLine1",2,$P($P($G(APSPPID),DLM,12),HLECH(1),1)))
 D ADD($$TAG("City",2,$P($P($G(APSPPID),DLM,12),HLECH(1),3)))
 D ADD($$TAG("StateProvince",2,$P($P($G(APSPPID),DLM,12),HLECH(1),4)))
 D ADD($$TAG("PostalCode",2,$P($P($G(APSPPID),DLM,12),HLECH(1),5)))
 D ADD($$TAG("CountryCode",2,"US"))
 D ADD($$TAG("Address",1))
 D ADD($$TAG("CommunicationNumbers",0))
 D ADD($$TAG("PrimaryTelephone",0))
 D ADD($$TAG("Number",2,$P($P($P(APSPPID,DLM,14),"~",1),U,1)))
 D ADD($$TAG("PrimaryTelephone",1))
 D ADD($$TAG("CommunicationNumbers",1))
 I WTYP="WEIGHT"!(HTYP="HEIGHT") D
 .D ADD($$TAG("Observations",0))
 .I WTYP="WEIGHT" D
 ..D ADD($$TAG("Observation",0))
 ..D ADD($$TAG("Type",2,"WT"))
 ..D ADD($$TAG("Date",2,WDTE))
 ..D ADD($$TAG("Value",2,$J(WVALUE,5,2)_" "_WUNIT))
 ..D ADD($$TAG("Observation",1))
 .I HTYP="HEIGHT" D
 ..D ADD($$TAG("Observation",0))
 ..D ADD($$TAG("Type",2,"HT"))
 ..D ADD($$TAG("Date",2,HDTE))
 ..D ADD($$TAG("Value",2,$J(HVALUE,5,2)_" "_HUNIT))
 ..D ADD($$TAG("Observation",1))
 .D ADD($$TAG("Observations",1))
 D ADD($$TAG("Patient",1))
 D ADD($$TAG("Prescriber",0))
 D ADD($$TAG("Name",0))
 D ADD($$TAG("Full",2,PROV))
 D ADD($$TAG("NPI",2,NPI))
 D ADD($$TAG("Name",1))
 D ADD($$TAG("Address",0))
 I IADD'="" D ADD($$TAG("AddressLine1",2,IADD))
 I ICITY'="" D ADD($$TAG("City",2,ICITY))
 I IST'="" D ADD($$TAG("StateProvince",2,IST))
 I IZIP'="" D ADD($$TAG("PostalCode",2,IZIP))
 D ADD($$TAG("CountryCode",2,"US"))
 D ADD($$TAG("Address",1))
 D ADD($$TAG("CommunicationNumbers",0))
 D ADD($$TAG("PrimaryTelephone",0))
 D ADD($$TAG("Number",2,IPHONE))
 D ADD($$TAG("PrimaryTelephone",1))
 D ADD($$TAG("CommunicationNumbers",1))
 D ADD($$TAG("Prescriber",1))
 D ADD($$TAG("Medication",0))
 D ADD($$TAG("DrugDescription",2,DRUG))
 D ADD($$TAG("Quantity",0))
 D ADD($$TAG("Value",2,QTY))
 D ADD($$TAG("QuantityUnitOfMeasure",0))
 D ADD($$TAG("Code",2,UNITS))
 D ADD($$TAG("QuantityUnitOfMeasure",1))
 D ADD($$TAG("Quantity",1))
 D ADD($$TAG("DaysSupply",2,DAYS))
 D ADD($$TAG("WrittenDate",0))
 D ADD($$TAG("Date",2,WRITTEN))
 D ADD($$TAG("WrittenDate",1))
 I EFF'="" D
 .D ADD($$TAG("EffectiveDate",0))
 .D ADD($$TAG("Date",2,EFF))
 .D ADD($$TAG("EffectiveDate",1))
 D ADD($$TAG("Substitutions",2,$P(APSPRXE,DLM,10)="G"))
 D ADD($$TAG("Sig",0))
 D ADD($$TAG("SigText",2,SIGDAT))
 D ADD($$TAG("Sig",1))
 D ADD($$TAG("RefillsRemaining",2,REFILLS))
 D ADD($$TAG("NoteToPharmacy",2,$P(APSPRXE,DLM,22)))
 D ADD($$TAG("Medication",1))
 D ADD($$TAG("RxChangeConfirm",1))
 Q
 ; Add XML Header to return array
XMLHDR ;
 D ADD("<?xml version=""1.0"" ?>")
 D ADD("<!DOCTYPE Change>")
 Q
 ; Add data to array
ADD(VAL) ;EP-
 S CNT=CNT+1
 S @RET@(CNT)=VAL
 Q
 ; Returns formatted tag
 ; Input: TAG - Name of Tag
 ;        TYPE - (-1) = empty 0 =start <tag>   1 =end </tag>  2 = start
 ;        VAL - data value
TAG(TAG,TYPE,VAL) ;EP -
 S TYPE=$G(TYPE,0)
 S:$L($G(VAL)) VAL=$$SYMENC^MXMLUTL(VAL)
 I TYPE<0 Q "<"_TAG_"/>"  ;empty
 E  I TYPE=1 Q "</"_TAG_">"
 E  I TYPE=2 Q "<"_TAG_">"_$G(VAL)_"</"_TAG_">"
 Q "<"_TAG_">"
INST ;Get institution data
 S IPHONE=$P($P(APSPORC,DLM,24),HLECH(1),1)
 S IADD=$P($P(APSPORC,DLM,25),HLECH(1),1)
 S ICITY=$P($P(APSPORC,DLM,25),HLECH(1),3)
 S IST=$P($P(APSPORC,DLM,25),HLECH(1),4)
 S IZIP=$P($P(APSPORC,DLM,25),HLECH(1),5)
 Q
OBX ;Get any OBX segments
 N DLM,HLMSGIEN,HLMSTATE,MSGID,DATA
 K DATA
 S DLM="|"
 S MSGID=$$GET1^DIQ(9009033.91,IEN,.01)
 S HLMSGIEN=$O(^HLB("B",MSGID,""))
 Q:'+HLMSGIEN
 D PARSE^APSPES2(.DATA,$G(HLMSGIEN),.HLMSTATE)
 S CNT=0 F  S CNT=$O(DATA(CNT)) Q:CNT=""  D
 .I $G(DATA(CNT,"SEGMENT TYPE"))="OBX" D
 ..;Observation data
 ..S VTYP=$G(DATA(CNT,4,1,1,1))
 ..I VTYP="29463-7" D
 ...S WTYP="WEIGHT"
 ...S WVALUE=$G(DATA(CNT,6,1,1,1))
 ...S WUNIT=$G(DATA(CNT,7,1,2,1))
 ...S WDTE=$$FMTE^XLFDT($$FMDATE^HLFNC($G(DATA(CNT,15,1,1,1))))
 ..I VTYP="8302-2" D
 ...S HTYP="HEIGHT"
 ...S HVALUE=$G(DATA(CNT,6,1,1,1))
 ...S HUNIT=$G(DATA(CNT,7,1,2,1))
 ...S HDTE=$$FMTE^XLFDT($$FMDATE^HLFNC($G(DATA(CNT,15,1,1,1))))
 Q
 ; Return temp global reference
TMPGBL() N GBL
 S GBL=$NA(^TMP("APSPESC",$J))
 K @GBL
 Q GBL
