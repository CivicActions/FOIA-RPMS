APSPESC ;IHS/MSC/PLS - SureScripts HL7 interface  ;05-May-2021 15:27;MGH
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1024,1025,1026,1027,1028**;Sep 23, 2004;Build 50
 ;====================================================================
 Q
 ;Change requests
CHANGE ;Process an inbound request from Surescripts to change the order
 ;Build response to Change Request
 N DATA,PARMS,SEG,ACK,ARY,ERR,ORID,SEGRX0,SEGORC,REFILL,RR,ORITM,PRV,DFN
 N RXIEN,FN,DEA,MATCHK,CSMED,RELATE,DEA,INTYP,SUBTYP,DUPS,INVAL
 S MATCHK="",RELATE="",CSMED=0,INVAL=""
 D PARSE^APSPES2(.DATA,$G(HLMSGIEN),.HLMSTATE)
 ;Store the data
 S CTYPE=$$GETVAL^APSPES2(+$G(HLMSGIEN),"RXE",31,1)
 S SUBTYP=$$GETVAL^APSPES2(+$G(HLMSGIEN),"ZSF",1,1)
 ; Create entry in APSP SURESCRIPTS REQUEST file
 S FN=9009033.91
 S RR=$$ADDRR^APSPES2(+$G(HLMSGIEN),"C",CTYPE)
 I +PRV S FDA(FN,RR_",",1.3)=PRV
 I +DFN S FDA(FN,RR_",",1.2)=DFN   ; Patient IEN
 S FDA(FN,RR_",",.11)=MATCHK
 S DUPS=$$GET1^DIQ(9009033.91,RR,.03,"I")
 I DUPS'=8 D
 .I MATCHK["P"&(MATCHK["D")&(MATCHK'["Z") S FDA(FN,RR_",",.03)=0
 .E  S FDA(FN,RR_",",.03)=5
 S FDA(FN,RR_",",10)=RELATE
 S FDA(FN,RR_",",7.4)=CTYPE
 D FILE^DIE("K","FDA")
SIG(IEN) ;Store SIG
 N FN,FDA,AIEN,ERR,X,X1,X2
 S X2=""
 S FN=9009033.913
 S AIEN="+1,"_IEN_","
 S X=$$GETVAL^APSPES2(MSGIEN,"RXE",6,1)  ; SIG
 S X1=1 F  S X2=$P(X,"^",X1) Q:X2=""  D
 .S FDA(FN,AIEN,.01)=X2
 .D UPDATE^DIE(,"FDA","AIEN","ERR")
 K ERR
 Q
 ;Return the medication(s) requested
GETREQ(RET,RRIEN) ;EP-
 N MSG,DATA,HLDATA,HLMSTATE,SEGIEN,CTYPE,CNT,REASON,SPI,PRV,PHARM
 S CNT=0
 S RET=$$TMPGBL
 S MSG=$P(^APSPRREQ(RRIEN,0),U,5)
 D PARSE^APSPES2(.DATA,$G(MSG),.HLMSTATE)
 Q:'$D(DATA) ""
 D XMLHDR
 D ADD($$TAG("Change",0))
 S SPI=$$GETVAL^APSPES2(MSG,"ORC",12,1)
 S PRV=$$FIND1^DIC(200,,"O",SPI,"ASPI")
 S PHARM=$$GET1^DIQ(9009033.91,RRIEN,1.7)
 D ADD($$TAG("Pharmacy",2,PHARM))
 S CTYPE=$$GETVAL^APSPES2(MSG,"RXE",31,1)
 D ADD($$TAG("ReqTyp",2,CTYPE))
 D ORIG
 I CTYPE="P" D PRIOR Q
 I CTYPE="U" D PROVAUTH(PRV) Q
 D REQDRG
 Q
 ; Return temp global reference
TMPGBL() N GBL
 S GBL=$NA(^TMP("APSPESC",$J))
 K @GBL
 Q GBL
REQDRG ;Get the requested change drugs from HL7 msg
 N SEGZMR,SEGZDU,MEDNAME,RXNORM,NDC,SEQID,QUAT,DAYS,REFILL,SIG,ROUTE,REASON,ORITM,QUANT,NOTE,RET2
 N DS,DP,AR,IN,IN2,LINE,OK
 D ADD($$TAG("MedList",0))
 S SEGIEN=""
 F  S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"ZMR",SEGIEN) Q:'+SEGIEN  D
 .K SEGZMR
 .S ORITM=""
 .D ADD($$TAG("Medication",0))
 .M SEGZMR=DATA(SEGIEN)
 .S SEQID=$$GET^HLOPRS(.SEGZMR,1,1)
 .D ADD($$TAG("SeqID",2,SEQID))
 .S MEDNAME=$$GET^HLOPRS(.SEGZMR,2,2)
 .S RXNORM=$$GET^HLOPRS(.SEGZMR,2,4)
 .D ADD($$TAG("RxNorm",2,RXNORM))
 .I RXNORM'="" S ORITM=$$DTSLK^APSPES4(RXNORM)  ;Try DTS lookup
 .S NDC=$$GET^HLOPRS(.SEGZMR,2,1)
 .D ADD($$TAG("NDC",2,NDC))
 .I ORITM=""&(NDC'="") S ORITM=$$FNDDRG^APSPES4(NDC)
 .I +ORITM D
 ..S OK=$$OKTOUSE(+ORITM)   ;Check for CS med and provider credentals
 ..I '+OK D
 ...S ORITM="$"_ORITM
 ...S MEDNAME="$"_MEDNAME
 .D ADD($$TAG("OrderableItem",2,ORITM))
 .D ADD($$TAG("MedName",2,MEDNAME))
 .S QUANT=$$GET^HLOPRS(.SEGZMR,3,1)
 .D ADD($$TAG("Quantity",2,QUANT))
 .S DAYS=$$GET^HLOPRS(.SEGZMR,4,1)
 .D ADD($$TAG("DaysSupply",2,DAYS))
 .S REFILL=$$GET^HLOPRS(.SEGZMR,5,1)
 .D ADD($$TAG("Refills",2,REFILL))
 .S SIG=$$GET^HLOPRS(.SEGZMR,6,1)
 .D ADD($$TAG("SIG",2,SIG))
 .S ROUTE=$$GET^HLOPRS(.SEGZMR,7,1)
 .S NOTE=$$GET^HLOPRS(.SEGZMR,9,1)
 .D ADD($$TAG("Notes",2,NOTE))
 .;S MED=$$GETVAL^APSPES2
 .D ADD($$TAG("Medication",1))
 D ADD($$TAG("MedList",1))
 S REASON=$$GETVAL^APSPES2(MSG,"NTE",3,1)
 S LINE=""
 F  S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"ZDU",SEGIEN) Q:'+SEGIEN  D
 .K SEGZDU
 .M SEGZDU=DATA(SEGIEN)
 .S (DS,DP,AR)=""
 .S IN=0 F  S IN=$O(SEGZDU(2,IN)) Q:IN=""  D
 ..S (DS,DP,AR)=""
 ..S IN2=0 F  S IN2=$O(SEGZDU(2,IN,IN2)) Q:IN2=""  D
 ...I IN2=1 D
 ....S DS=$G(SEGZDU(2,IN,IN2,1))
 ....S DS=$$GETDESC(DS,"DS")
 ...I IN2=2 D
 ....S DP=$G(SEGZDU(2,IN,IN2,1))
 ....S DP=$$GETDESC(DP,"DP")
 ...I IN2=3 S AR=$G(SEGZDU(2,IN,IN2,1))
 ..S LINE=LINE_$$FMTDUELN^APSPESC4($G(DS),$G(DP),$G(AR))
 S REASON=REASON_$S($L(LINE):" "_"<div style=""overflow-y:auto;height:40px;color:red;"""_LINE_"</div>",1:"")
 D ADD($$TAG("Reason",2,REASON))
 D ADD($$TAG("Change",1))
 Q
GETDESC(CODE,TYP) ;Get the description of the due code to show provider
 N CIEN,MATCH,CONTEXT
 S CIEN=0,MATCH=0
 F  S CIEN=$O(^APSPNCP(9009033.7,"B",CODE,CIEN)) Q:'+CIEN!(MATCH=1)  D
 .S CONTEXT=$$GET1^DIQ(9009033.7,CIEN,2,"I")
 .Q:TYP'=CONTEXT
 .S MATCH=1
 .S CODE=$$GET1^DIQ(9009033.7,CIEN,1)
 Q CODE
OKTOUSE(ITM) ;Check to see if ths is a CS med and if user can order it
 N RET2,FAIL,TWOFA,ENT,PAR,LEVEL
 S OK=1
 D DEAOICLS^APSPFNC6(.RET2,+ORITM,"2345")
 I RET2 D   ;This is a CS med; Check user
 .D FAILDEA^ORWDPS1(.FAIL,+ITM,DUZ,"O")
 .I +FAIL S OK=0
 .I FAIL=0 D
 ..S TWOFA=$$AUTHON^APSPELRX(DUZ)
 ..I TWOFA'=1 S OK=0
 ..S ENT="USR.`"_+DUZ,PAR="APSP NCPDP USER SERVICE LEVEL",LEVEL="ControlledSubstance"
 ..D SERLEV^APSPES9(.DATA,ENT,PAR,LEVEL)
 ..I '+DATA S OK=0
 Q OK
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
PRIOR ;EP -Entry point to do prior authorization
 N SEGIEN,SEGINS,REASON
 D ADD($$TAG("PriorAuth",0))
 S SEGIEN=""
 S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"IN1",SEGIEN)
 M SEGINS=DATA(SEGIEN)
 D ADD($$TAG("PayorData",0))
 D ADD($$TAG("PayorID",2,$$GET^HLOPRS(.SEGINS,2,1)))
 D ADD($$TAG("PayorName",2,$$GET^HLOPRS(.SEGINS,4,1)))
 D ADD($$TAG("ProcessorID",2,$$GET^HLOPRS(.SEGINS,36,1)))
 D ADD($$TAG("IINNumber",2,$$GET^HLOPRS(.SEGINS,3,1)))
 D ADD($$TAG("ContactInfo",2,$$GET^HLOPRS(.SEGINS,7,1)))
 D ADD($$TAG("PayorData",1))
 D ADD($$TAG("CardHolder",0))
 D ADD($$TAG("CardHolderID",2,$$GET^HLOPRS(.SEGINS,49,1)))
 D ADD($$TAG("CardHolderName",0))
 D ADD($$TAG("LastName",2,$$GET^HLOPRS(.SEGINS,16,1)))
 D ADD($$TAG("FirstName",2,$$GET^HLOPRS(.SEGINS,16,2)))
 D ADD($$TAG("CardHolderName",1))
 D ADD($$TAG("Group",0))
 D ADD($$TAG("GroupID",2,$$GET^HLOPRS(.SEGINS,8,1)))
 D ADD($$TAG("GroupName",2,$$GET^HLOPRS(.SEGINS,9,1)))
 D ADD($$TAG("Group",1))
 D ADD($$TAG("CardHolder",1))
 D ADD($$TAG("PriorAuth",1))
 S REASON=$$GETVAL^APSPES2(MSG,"NTE",3,1)
 D ADD($$TAG("Reason",2,REASON))
 D ADD($$TAG("Change",1))
 Q
PROVAUTH(PRV) ;EP- Entry point to do provider authorization
 N AUTHTYP,SEGIEN,SEGSTF,SUB
 D ADD($$TAG("ProvAuth",0))
 S SEGIEN=""
 S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"ZSF",SEGIEN) Q:'+SEGIEN  D
 .K SEGSTF
 .M SEGSTF=DATA(SEGIEN)
 .S AUTHTYP=$$GET^HLOPRS(.SEGSTF,1,1)
 .D ADD($$TAG("PVATypeList",0))
 .D ADD($$TAG("Codes",2,AUTHTYP))
 .F I=1:1:$L(AUTHTYP) S SUB="AUTH"_$E(AUTHTYP,I,I) D
 ..D ADD($$TAG("PVAType",0))
 ..D @SUB
 ..D ADD($$TAG("PVAType",1))
 .D ADD($$TAG("PVATypeList",1))
 D ADD($$TAG("ProvAuth",1))
 S REASON=$$GETVAL^APSPES2(MSG,"NTE",3,1)
 D ADD($$TAG("Reason",2,REASON))
 D ADD($$TAG("Change",1))
 Q
AUTHA ;State Registration license
 N STATE,SIEN,SNAME,NUMBER,ABB
 S STATE=$$STATE^APSPESC4
 D ADD($$TAG("Code",2,"A"))
 D ADD($$TAG("Name",2,"Prescriber must confirm their State license status"))
 I +STATE D
 .S SIEN=$O(^VA(200,PRV,"PS1","B",STATE,""))
 .I +SIEN D
 ..S SNAME=$$GET1^DIQ(5,STATE,.01)
 ..S NUMBER=$P($G(^VA(200,PRV,"PS1",SIEN,0)),U,2)
 ..D ADD($$TAG("State",2,SNAME))
 ..D ADD($$TAG("Value",2,NUMBER))
 .E  D                        ;Take the first one
 ..S (SNAME,NUMBER)=""
 ..S STATE=$P($G(^VA(200,PRV,"PS1",1,0)),U,1)
 ..S SNAME=$$GET1^DIQ(5,STATE,.01)
 ..S NUMBER=$P($G(^VA(200,PRV,"PS1",1,0)),U,2)
 ..D ADD($$TAG("State",2,SNAME))
 ..D ADD($$TAG("Value",2,NUMBER))
 E  D
 .D ADD($$TAG("State",2,""))
 .D ADD($$TAG("Value",2,""))
 Q
AUTHB ;State DEA License
 N DEA,EXP,STATE
 S STATE=$$STATE^APSPESC4
 D ADD($$TAG("Code",2,"B"))
 D ADD($$TAG("Name",2,"Prescriber must confirm their DEA License status in prescribing state"))
 ;S DEA=$$STDEA^APSPESC4(PRV,STATE)
 ;D ADD($$TAG("Value",2,DEA))
 ;I +STATE D
 ;.S SNAME=$$GET1^DIQ(5,STATE,.01)
 ;.D ADD($$TAG("State",2,SNAME))
 D ADD("<Value />")
 D ADD("<State />")
 Q
AUTHC ;DEA classes
 N DEA,EXP,DDRG,DEACL,STR,STATE,SNAME
 S STATE=$$STATE^APSPESC4
 D ADD($$TAG("Code",2,"C"))
 S DEA=$$GET1^DIQ(200,PRV,53.2)
 S EXP=$$GET1^DIQ(200,PRV,747.44,"I")
 I EXP<DT S DEA=""
 S DDRG=$$GET1^DIQ(9009033.91,RRIEN,1.8,"I")
 S DEACL=$$GET1^DIQ(50,DDRG,3)
 S STR="Prescriber must confirm their DEA registration by DEA class"
 D ADD($$TAG("Name",2,STR))
 D ADD($$TAG("Value",2,DEA))
 Q
AUTHD ;State CS registration
 D ADD($$TAG("Code",2,"D"))
 D ADD($$TAG("Name",2,"Prescriber must confirm their State Controlled Substance Registration license status"))
 D ADD("<Value />")
 Q
AUTHE ;State DEA class
 N DEA,EXP,DDRG,DEACL
 D ADD($$TAG("Code",2,"E"))
 ;S DEA=$$GET1^DIQ(200,PRV,53.2)
 ;S EXP=$$GET1^DIQ(200,PRV,747.44,"I")
 ;I EXP<DT S DEA=""
 ;S DDRG=$$GET1^DIQ(9009033.91,RRIEN,1.8,"I")
 ;S DEACL=$$GET1^DIQ(50,DDRG,3)
 D ADD($$TAG("Name",2,"Prescriber must confirm their registration by State Controlled Substance Registration class"))
 D ADD("<Value />")
 D ADD("<State />")
 Q
AUTHF ;NADEAN Number
 N NADEAN
 D ADD($$TAG("Code",2,"F"))
 D ADD($$TAG("Name",2,"Prescriber must confirm their NADEAN license status"))
 S NADEAN=$$GET1^DIQ(200,PRV,53.11)
 D ADD($$TAG("Value",2,NADEAN))
 ;D ADD($$TAG("Date",2,$TR($$FMTE^XLFDT(DT,9)," ","-")))
 Q
AUTHG ;NPI number
 N NPI
 D ADD($$TAG("Code",2,"G"))
 D ADD($$TAG("Name",2,"Prescriber must obtain/validate Type 1 NPI"))
 S NPI=$$GET1^DIQ(200,PRV,41.99)
 D ADD($$TAG("Value",2,NPI))
 Q
AUTHH ;Reenroll with pharmacy benefit plan
 D ADD($$TAG("Code",2,"H"))
 D ADD($$TAG("Name",2,"Prescriber must enroll/re-enroll with prescription benefit plan"))
 D ADD($$TAG("Date",2,$TR($$FMTE^XLFDT(DT,9)," ","-")))
 Q
AUTHI ;prescriptive authority criteria for prescribed medication is met
 N CLASS,EFF,ACT,NODE,PCLASS,CODE,VALUE
 S ACT=0
 S CLASS=0 F  S CLASS=$O(^VA(200,PRV,"USC1",CLASS)) Q:CLASS=""!(+ACT)  D
 .S NODE=$G(^VA(200,PRV,"USC1",CLASS,0))
 .S PCLASS=$P(NODE,U,1)
 .S EXP=$P(NODE,U,3)
 .I EXP=""!(EXP>DT) D
 ..S ACT=1
 ..S VALUE=$$GET1^DIQ(8932.1,PCLASS,.01)
 ..S CODE=$P($G(^USC(8932.1,PCLASS,0)),U,7)
 ..D ADD($$TAG("Code",2,"I"))
 ..D ADD($$TAG("Name",2,"Prescriber must confirm prescriptive authority criteria for prescribed medication is met"))
 ..D ADD($$TAG("Value",2,VALUE))
 ..D ADD($$TAG("ValueIEN",2,PCLASS))
 ..D ADD($$TAG("Class",2,CODE))
 I ACT=0 D
 .S VALUE=""
 .D ADD($$TAG("Code",2,"I"))
 .D ADD($$TAG("Name",2,"Prescriber must confirm prescriptive authority criteria for prescribed medication is met"))
 .D ADD($$TAG("Value",2,VALUE))
 .D ADD($$TAG("ValueIEN",2,""))
 Q
AUTHJ ;Confirm enrollment with REMS
 D ADD($$TAG("Code",2,"J"))
 D ADD($$TAG("Name",2,"Prescriber must enroll/re-enroll in REMS"))
 D ADD($$TAG("Date",2,$TR($$FMTE^XLFDT(DT,9)," ","-")))
 Q
AUTHK ;Confirm lock-in provider
 D ADD($$TAG("Code",2,"K"))
 D ADD($$TAG("Name",2,"Prescriber must confirm their assignment as patients' lock-in prescriber"))
 D ADD($$TAG("Date",2,$TR($$FMTE^XLFDT(DT,9)," ","-")))
 Q
AUTHL ;Validate Supervisor
 N SUP,SNAME
 D ADD($$TAG("Code",2,"L"))
 D ADD($$TAG("Name",2,"Prescriber must obtain/validate their supervising prescriber"))
 S SUP=$$GET1^DIQ(49,$$GET1^DIQ(200,PRV,29,"I"),2,"I")
 S SNAME=$$GET1^DIQ(200,SUP,.01)
 D ADD($$TAG("Value",2,SNAME))
 Q
AUTHM ;Certificate to prescribe
 D ADD($$TAG("Code",2,"M"))
 D ADD($$TAG("Name",2,"Prescriber must confirm their Certificate to Prescribe Number status"))
 D ADD("<Value />")
 Q
 ;
ORIG ;Get original order information
 N DRUG,DET,SIG,IND
 D ADD($$TAG("OrigOrder",0))
 S DRUG=$$GET1^DIQ(9009033.91,RRIEN,1.8)
 D ADD($$TAG("Med",2,DRUG))
 S SIG=$$GETSIG^APSPESG(RRIEN)
 D ADD($$TAG("SIG",2,SIG))
 S DET=$$ORD(RRIEN)
 D ADD($$TAG("DispInfo",2,DET))
 S IND=$$IND(RRIEN)
 D ADD($$TAG("Indication",2,IND))
 D ADD($$TAG("OrigOrder",1))
 Q
 ;
STORE(RET,RRIEN,XML,FLG) ;Store the XML data for a change request
 N I,TCNT,TXT,ERR,FDA,CODE,STAT
 S TCNT=0,RET=0
 S TCNT=TCNT+1
 S TXT(TCNT,0)="<?xml version=""1.0"" ?>"
 S TCNT=TCNT+1
 S TXT(TCNT,0)=("<!DOCTYPE Change>")
 S CODE=$$GET1^DIQ(9009033.91,RRIEN,7.4)
 I CODE="P"!(CODE="U") S STAT=2
 E  S STAT=6
 S I="" F  S I=$O(XML(I)) Q:I=""  D
 .S TCNT=TCNT+1
 .S TXT(TCNT,0)=$G(XML(I))
 D WP^DIE(9009033.91,RRIEN_",",8,,"TXT","ERR")
 S FDA(9009033.91,RRIEN_",",.03)=STAT
 D FILE^DIE("","FDA","ERR")
 I $D(ERR)=0 D RESPONSE^APSPESC3(.RET,RRIEN)   ;Create the new order
 Q
ORD(IEN) ;Order details D:30 QTY:30 RF:2 DAW:No
 N SUP,QTY,REF,DAW,IND,SNO
 S SUP=+$$GET1^DIQ(9009033.91,RRIEN,1.5)
 S QTY=+$$GET1^DIQ(9009033.91,RRIEN,1.4)
 S REF=+$$GET1^DIQ(9009033.91,RRIEN,1.9)
 S DAW=$$GET1^DIQ(9009033.91,RRIEN,1.12)
 Q "D:"_SUP_" QTY:"_QTY_" RF:"_REF_" DAW:"_DAW
IND(IEN) ;Do the indication
 N SNO,IND
 S IND=$$GET1^DIQ(9009033.91,RRIEN,7.3)
 S SNO=$P($$CONC^BSTSAPI(IND),U,4)
 Q SNO
