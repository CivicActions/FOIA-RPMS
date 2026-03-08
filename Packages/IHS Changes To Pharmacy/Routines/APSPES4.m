APSPES4 ;IHS/MSC/PLS - SureScripts HL7 interface - con't;12-Aug-2020 13:50;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1016,1017,1018,1020,1023,1024,1026,1027**;Sep 23, 2004;Build 31
 ; Return array of message data
 ; Input: MIEN - IEN to HLO MESSAGES and HLO MESSAGE BODY files
 ; Output: DATA
 ;         HLMSTATE
 ;Handle the extra segment data from APSPES1
 ;Create RXR segment
RXR ;EP
 N RX6
 D SET(.ARY,"RXR",0)
 S RX6=$O(^PSRX(RXIEN,6,0))
 I RX6 D
 .S RX6=^PSRX(RXIEN,6,RX6,0)
 .D SET(.ARY,$S($P(RX6,U,7):$$GROUTE^APSPES1($P(RX6,U,7)),1:"OTH"),1)
 S RX6=$$ADDSEG^HLOAPI(.HLST,.ARY)
 Q
RXC ;Do the RXC segment
 N DIEN
 S DIEN=$P(RX0,U,6)
 ;Compounding medication
 I $P($G(^PSDRUG(DIEN,999999935)),U,1)=1 D CMP
 Q
CMP ; Get compound data
 N ING,NODE,CDRUG,CNDC,IND,AMT,UNIT,STR,SUNIT,RXNORM,RXCOM,VAP
 S ING=0 F  S ING=$O(^PSDRUG(DIEN,999999936,ING)) Q:'+ING  D
 .S NODE=$G(^PSDRUG(DIEN,999999936,ING,0))
 .S CDRUG=$P(NODE,U,1)
 .S VAP=$$NDC(CDRUG)
 .S CNDC=$P(VAP,U,1)
 .S IND=$P(NODE,U,4)
 .S AMT=$P(NODE,U,2)
 .S UNIT=$P($G(^PS(50.607,$P(NODE,U,3),0)),U,1)
 .S SUNIT=$P(VAP,U,3)
 .S IND=$S(IND=1:"B",1:"A")
 .D SET(.ARY,"RXC",0)
 .D SET(.ARY,IND,1,1)   ;Additive/Base field
 .D SET(.ARY,CNDC,2,1)  ; NDC Value
 .D SET(.ARY,$$GET1^DIQ(50,CDRUG,.01),2,2)  ; Drug Name
 .D SET(.ARY,"NDC",2,3)  ; Coding System
 .D SET(.ARY,AMT,3,1)   ; Amt
 .D SET(.ARY,UNIT,4,1)   ; Units
 .S STR=$P(VAP,U,2)
 .D SET(.ARY,STR,5,1)    ;Strength
 .D SET(.ARY,SUNIT,6,1)  ;Strength Units
 .I CNDC'="" S RXNORM=$$RXNORM^APSPFNC1(CNDC)
 .E  S RXNORM=$$RXNORDRG^APSPFNC1(CDRUG)
 .D SET(.ARY,RXNORM,7,1)     ;RxNorm as alt id
 .D SET(.ARY,"RXNORM",7,3)   ;Code List
 .S RXCOM=$$ADDSEG^HLOAPI(.HLST,.ARY)
 Q
 ;
SET(ARY,V,F,C,S,R) ;EP
 D SET^HLOAPI(.ARY,.V,.F,.C,.S,.R)
 Q
FNDORD(MSGIEN,REQ) ;Find the orderable item for this request
 N ORITM,RXNORM,NDC,NNDC,I,DRNM,POICT
 S (NDC,RXNORM,ORITM)=""
 I REQ="R" S NDC=$$GETVAL^APSPES2(MSGIEN,"RXD",2,1)
 I REQ="C" S NDC=$$GETVAL^APSPES2(MSGIEN,"RXE",2,1)
 I NDC'="" S ORITM=$$FNDDRG(NDC)
 I ORITM="" D
 .S RXNORM=$$GETVAL^APSPES2(MSGIEN,"RXD",25,1)
 .I RXNORM="" S RXNORM=$$GETVAL^APSPES2(MSGIEN,"RXE",31,1)
 .;IHS/GDIT/MSC/MGH Patch 1023
 .I RXNORM'="" S ORITM=$$DTSLK(RXNORM)  ;Try DTS lookup
 ;If all this still fails, try a name lookup
 I ORITM="" D
 .I REQ="R" S DRNM=$$GETVAL^APSPES2(MSGIEN,"RXD",2,2)
 .I REQ="C" S DRNM=$$GETVAL^APSPES2(MSGIEN,"RXE",2,2)
 .Q:DRNM=""
 .S ORITM=$$DRGNMOI($$UP^XLFSTR(DRNM))
 Q ORITM
FNDDRG(NDC,TYP) ;Get the drug, and orderable items
 N DRG,OI,ID,RET2
 S OI="",RET2=""
 I $G(TYP)="" S TYP=""
 ;IHS/MSC/MGH patch 1023 added drug to the return string
 S DRG="" F  S DRG=$O(^PSDRUG("ZNDC",NDC,DRG)) Q:DRG=""!(OI'="")  D
 .Q:+$$GET1^DIQ(50,DRG,100,"I")
 .S OI=$$FNDOI(DRG)
 .I TYP="G" W DRG=$$CHK(DRG)
 .S RET2=OI_U_DRG
 I OI="" D
 .S OI=$$PRODNDC(NDC)
 .S RET2=OI
 I OI="" D
 .I $L(NDC=11) D
 ..S NDC="0"_NDC
 ..S OI=$$PRODNDC(NDC)
 ..S RET2=OI
 Q RET2
 ;Try the lookup from the VA PRODUCT FILE
PRODNDC(NDC) ;product NDC
 N VA,PROD,OI2
 S OI2=""
 S VA="" S VA=$O(^PSNDF(50.67,"NDC",NDC,VA))
 I VA="" Q OI2
 S PROD=$$GET1^DIQ(50.67,VA,5,"E")
 S PROD=$E(PROD,1,30)
 S DRG="" F  S DRG=$O(^PSDRUG("VAPN",PROD,DRG)) Q:DRG=""!(OI2'="")  D
 .Q:+$$GET1^DIQ(50,DRG,100,"I")
 .S OI2=$$FNDOI(DRG)
 .I OI2'="" S OI2=OI2_U_DRG
 Q OI2
FNDOI(DRG) ;find orderable item from drug
 N POI,OI
 S OI=""
 I $G(TYP)="" S TYP=""
 S POI=$P($G(^PSDRUG(DRG,2)),U,1)
 I POI'="" D
 .Q:$$GET1^DIQ(50.7,POI,.04)
 .S ID=POI_";99PSP"
 .S OI="" S OI=$O(^ORD(101.43,"ID",ID,OI))
 Q OI
NMPOI(DRNM) ;Match on name
 N POICT,POI,POIARR,OI3,ID
 S POICT=0,OI3=""
 S POI="" F  S POI=$O(^PS(50.7,"B",DRNM,POI)) Q:POI=""  D
 .S POICT=POICT+1
 .S POIARR(POICT)=POI
 ;Only allowed one match so that we can't have different dose forms
 I POICT=1 D
 .S POI=$G(POIARR(POICT))
 .Q:$$GET1^DIQ(50.7,POI,.04)
 .S ID=POI_";99PSP"
 .S OI3="" S OI3=$O(^ORD(101.43,"ID",ID,OI3))
 Q OI3
 ; Match on Drug File entries
DRGNMOI(DNM) ;EP-
 N IEN,LNM,NM,UDNM,OI3,CDNM,POI,OID,SAVIEN
 S UDNM=$$UP^XLFSTR(DNM)
 S OI3="",SAVIEN=""
 S SAVIEN=$$FNDHASH^APSPESUT(DNM)
 I SAVIEN=0 D
 .S IEN=0 F  S IEN=$O(^PSDRUG("B",DNM,IEN)) Q:'IEN!(+OI3)  D
 ..S NM=$P($G(^PSDRUG(IEN,0)),U)
 ..Q:UDNM'=NM  ;names must match
 ..S SAVIEN=IEN
 I +SAVIEN D
 .Q:$G(^PSDRUG(SAVIEN,"I"))  ;inactive drug
 .S POI=$P($G(^PSDRUG(SAVIEN,2)),U)
 .Q:'POI  ;no linked pharmacy orderable item
 .Q:$$GET1^DIQ(50.7,POI,.04)  ;POI is inactive
 .S OID=POI_";99PSP"
 .S OI3=$O(^ORD(101.43,"ID",OID,OI3))
 Q OI3_"^"_SAVIEN
GETDSP(RET,IEN) ;Get the dispensed data from the Refill request IEN
 D GETDSP^APSPES5(.RET,IEN)
 Q
CHKNME(MSGIEN) ;Check names if there is no order
 N HLNAME,HFNAME,HLDOB,HLSEX,MATCH,AGE,PT,SEX,NAME,FIRSTN,LOOK
 ;Match on birth dates and last names
 S MATCH=0
 D HLPID
 S LOOK=HLNAME
 F  S LOOK=$O(^DPT("B",LOOK)) Q:LOOK=""!(MATCH>0)  D
 .Q:($P(LOOK,",")'=HLNAME)
 .S PT=""
 .F  S PT=$O(^DPT("B",LOOK,PT)) Q:PT=""!(MATCH>0)  D
 ..S NAME=$$GET1^DIQ(2,PT,.01)
 ..S FIRSTN=$P($P(NAME,",",2)," ",1)
 ..Q:FIRSTN'=HFNAME
 ..S AGE=$$GET1^DIQ(2,PT,.03,"I")
 ..S AGE=$$HLDATE^HLFNC(AGE,"DT")
 ..S SEX=$$GET1^DIQ(2,PT,.02,"I")
 ..I AGE=HLDOB&(SEX=HLSEX) S MATCH=PT
 Q MATCH
CHKOPT(PAT,MSGIEN,RXIEN) ;Find the match for the order patient
 N HL7NAME,HLNAME,HFNAME,HLDOB,HLSEX,MATCH,AGE,LASTN,FIRSTN,NAME
 N AGE,SEX,HLDOB,HLSEX
 S MATCH=0,RXIEN=$G(RXIEN)
 D HLPID
 S NAME=$$GET1^DIQ(2,PAT,.01)
 S LASTN=$P(NAME,",",1)
 S FIRSTN=$P($P(NAME,",",2)," ",1)
 I (LASTN=HLNAME)&(FIRSTN=HFNAME) D
 .S AGE=$$GET1^DIQ(2,PAT,.03,"I")
 .S AGE=$$HLDATE^HLFNC(AGE,"DT")
 .S SEX=$$GET1^DIQ(2,PAT,.02,"I")
 .I AGE=HLDOB&(SEX=HLSEX) S MATCH=PAT
 ;I MATCH=0&(RXIEN'="") S MATCHK=MATCHK_"Z"
 Q MATCH
HLPID ;Find the hl7 name data
 S HLNAME=$$UP^XLFSTR($$GETVAL^APSPES2(MSGIEN,"PID",5,1))
 S HFNAME=$$UP^XLFSTR($$GETVAL^APSPES2(MSGIEN,"PID",5,2))
 S HLDOB=$$GETVAL^APSPES2(MSGIEN,"PID",7)
 I $L(HLDOB)>8 S HLDOB=$E(HLDOB,1,8)
 S HLSEX=$$GETVAL^APSPES2(MSGIEN,"PID",8)
 Q
CHKDRG(MSGIEN,RXIEN,ITEM) ;Check the drug
 N HLOI,RXOI,DRG
 ;S HLOI=$P($$FNDORD(MSGIEN),U,1)  ;P1023 Only need 1st piece
 S DRG=$P($G(^PSRX(RXIEN,0)),U,6)
 S RXOI=$$FNDOI(DRG)
 S RXOI=$P(RXOI,U,1)
 Q $S(RXOI=ITEM:1,1:0)  ;P1023 add drug
CHK(DRG) ; Look for other drugs on this orderable item
 N POI,IEN,STOP
 S STOP=0
 S POI=$P($G(^PSDRUG(DRG,2)),U,1)
 S IEN="" F  S IEN=$O(^PSDRUG("ASP",POI,IEN)) Q:'+IEN!(STOP=1)  D
 .I IEN'=DRG S STOP=1
 Q IEN
 ; APSPES4 SNDE900 RPC Support
SNDE900(RET,RRIEN) ;EP-
 D ERR900($P(RRIEN,":",2),"Request has already been viewed.")
 S RET=1
 Q
 ; Send error message back
ERR900(RR,MSGTXT,HLMSGIEN) ;EP-
 N PARMS,ACK,ERR,HLMSGIEN,HLMSTATE,ACT,SEG
 K ACK
 S ACT=$$GET1^DIQ(9009033.91,RR,.08,"I")
 S OCC=$S($G(OCC):OCC,ACT=3:"RP",ACT=4:"DF",1:"DF")
 I HLMSGIEN="" D
 .I +RR S HLMSGIEN=$$GET1^DIQ(9009033.91,RR,.05)  ; Message ID
 Q:'HLMSGIEN
 S PARMS("ACK CODE")="AE"
 S PARMS("MESSAGE TYPE")="RRE"
 S PARMS("EVENT")="O12"
 S PARMS("VERSION")=2.5
 S PARMS("ACCEPT ACK TYPE")="AL"
 S PARMS("ERROR MESSAGE")=MSGTXT
 D PARSE^APSPES2(.DATA,HLMSGIEN,.HLMSTATE)
 S HLFS=$G(DATA("HDR","FIELD SEPARATOR"))
 S HLECH=HLMSTATE("HDR","ENCODING CHARACTERS")
 Q:'$$ACK^HLOAPI2(.HLMSTATE,.PARMS,.ACK,.ERR)
 D SET^HLOAPI(.SEG,"ERR",0)
 D SET^HLOAPI(.SEG,MSGTXT,8)
 Q:'$$ADDSEG^HLOAPI(.ACK,.SEG)
 I '$$SENDACK^HLOAPI2(.ACK,.ERR) D UPTRRACT^APSPES3(RR,$G(ERR,"There was a problem sending the HL7 message."))
 Q
 ; Generate Renew Order
GENRENEW(MSGIEN,RXIEN,OPRV,REFILL,RRIEN) ;EP -
 N ORIFN,VAL,DFN,LOC,RET,FLDS,ORLST,DEA,RXSTS,PAT,ORDERPT,HLITM
 Q:'RXIEN "0^Prescription IEN not provided."
 S VAL=""
 S DFN=$P($G(^PSRX(RXIEN,0)),U,2)
 Q:'DFN "0^Patient not found for supplied prescription IEN."
 S ORIFN=+$P($G(^PSRX(RXIEN,"OR1")),U,2)
 S RXSTS=$$GET1^DIQ(52,RXIEN,100,"I")
 I ",12,14,15,"[(","_RXSTS_",") S VAL="Original order has been discontinued."
 D:VAL="" VALID^ORWDXA(.VAL,ORIFN,"RN",OPRV)
 Q:$L(VAL) 0_U_VAL  ;Order can't be renewed. VAL contains refusal explanation
 K VAL
 S ORLST(1)=ORIFN
 D RENEW^ORWDXC(.VAL,DFN,.ORLST)
 S LOC=+$P($G(^OR(100,ORIFN,0)),U,10)
 D RNWFLDS^ORWDXR(.RET,ORIFN)
 S FLDS(1)=$G(RET(0))
 S $P(FLDS(1),U,6)=$$GET1^DIQ(9009033.91,RRIEN,1.7,"I")  ; Set Pharmacy
 S FLDS("ORCHECK")=0
 S:$G(RRIEN) FLDS("SSRREQIEN")=$G(RRIEN)
 S FLDS("SSREFREQ")=1
 D PREPPTXT^APSPES2($NA(FLDS("SSREFREQ")),$G(RRIEN))
 S DEA=$$DEA^APSPES2A($P($G(^PSRX(RXIEN,0)),U,6))
 ;S $P(FLDS(1),U,4)=$S($$DEACLS(DEA,"2345"):0,REFILL:1,1:0)  ; Refill
 S $P(FLDS(1),U,4)=$$GET1^DIQ(9009033.91,RRIEN,1.9)-1   ; Refills equal Fills -1
 S FLDS(2)=$$GET1^DIQ(9009033.91,RRIEN,4.2)             ; Notes to Pharmacist
 K RET
 D RENEW^ORWDXR(.RET,.ORIFN,DFN,OPRV,LOC,.FLDS)
 ;CHECK FOR NEW ORDER
 D:$G(ORIFN) EN^OCXOERR(DFN_U_+ORIFN_U_OPRV_"^^^^^1")
 Q +$P($P($G(RET(1)),U),"~",2)
 ;
 ;SSNUM exists?
CHKSSNUM(SSNUM,MSGIEN,CTYPE) ;EP-
 N ORGIEN,STAT,SAVIEN,DUPIEN
 I SSNUM="" Q 0
 S ORGIEN=0,DUPIEN=0,SAVIEN=""
 F  S ORGIEN=$O(^APSPRREQ("G",SSNUM,ORGIEN)) Q:ORGIEN=""!(+SAVIEN)  D
 .S STAT=$$GET1^DIQ(9009033.91,ORGIEN,.03,"I")
 .Q:STAT=8
 .;If the subtyp is a U, then check to see if its really a duplicate
 .I CTYPE'="" D
 ..S SAVIEN=$$UDUPCHK^APSPES11(MSGIEN,SSNUM,CTYPE,"")
 .E  S SAVIEN=ORGIEN
 I CTYPE="U" D
 .I +SAVIEN S ORGIEN=SAVIEN
 .E  S ORGIEN=0
 E  I +SAVIEN S ORGIEN=SAVIEN
 Q ORGIEN
 ; Add related item to parent
SETDUP(OLDIEN,NEWIEN,CTYP,MSGIEN) ;EP-
 D SETDUP^APSPES11(OLDIEN,NEWIEN,CTYP,MSGIEN)
 Q
 ;Compare SIG of PON Request with HL7 SIG
COMPSIG(RET,ORIEN,RRIEN) ;EP
 N MATCH,SIG,TXT,RXTXT,RETXT,STR,DEL,HLMSG,MSGID,HLECH,I,RXIEN,PNDC,DNDC,TYP
 S RET=0,RXIEN=""
 S HLECH="^~\&"
 S RRIEN=$G(RRIEN,0)
 I 'RRIEN S RET=1 Q
 S TYP=$$GET1^DIQ(9009033.91,RRIEN,.12,"I")
 I TYP="C" S RET=1 Q
 S RXIEN=$$GET1^DIQ(9009033.91,RRIEN,.06,"I")
 ;I 'RXIEN S RET=1 Q
 ;If there is an order, get data from the order
 I RXIEN D
 .S RXTXT="",RETXT=""
 .;S SIG=+$O(^OR(100,+ORIEN,4.5,"ID","SIG",0))
 .S TXT=0 F  S TXT=$O(^PSRX(RXIEN,"SIG1",TXT)) Q:'+TXT  D
 ..S STR=$G(^PSRX(RXIEN,"SIG1",TXT,0))
 ..S RXTXT=RXTXT_STR
 .S PNDC=$TR($P($G(^PSRX(RXIEN,2)),"^",7),"-","")
 F I=1:1:4 D
 .S HLECH(I)=$E(HLECH,I)
 S MSGID=$$GET1^DIQ(9009033.91,RRIEN,.01,"E"),HLMSG=$$GHLDAT^APSPESG1(RRIEN)
 S DEL="|"
 D SHLVARS^APSPESG
 ;Get the dispensed data
 S DNDC=$P($P(APSPRXD,DEL,3),"^",1)
 S RETXT=$P(APSPRXD,DEL,10)
 ;If no order, use the RXO vs the RXD
 I 'RXIEN D
 .S RXTXT=$P($P(APSPRXO,DEL,8),HLECH(1),2)
 .S PNDC=$P($P(APSPRXO,DEL,2),"^",1)
 I $L(PNDC)=11&($L(DNDC)=12) S PNDC="0"_PNDC
 I (RXTXT=RETXT)&(PNDC=DNDC) S RET=1
 Q
 ;;Add patient instructions and compare
 ;S PITXT=$$PITXT(ORIEN)
 ;I $L(PITXT) D
 ;.S ORTXT=ORTXT_" "_PITXT
 ;.I ORTXT=RETXT S RET=1
 ;Q
 ; Return PITXT
PITXT(ORIEN) ;EP-
 N PI,TXT,STR,PITXT
 S PITXT=""
 S PI=+$O(^OR(100,+ORIEN,4.5,"ID","PI",0))
 S TXT=0 F  S TXT=$O(^OR(100,+ORIEN,4.5,PI,2,TXT)) Q:'+TXT  D
 .S STR=$G(^OR(100,+ORIEN,4.5,PI,2,TXT,0))
 .S PITXT=PITXT_STR
 Q PITXT
 ; Return NDC code for Drug File Entry
NDC(DRG) ; EP -
 ;1016 IHS/MSC/MGH get NDF from PSNDF file
 N NDF,CODE,STR,UNIT  ;,SCODE,SNAME
 S CODE=""
 S NDF=$P($G(^PSDRUG(DRG,"ND")),U,3)
 I NDF'="" S CODE=$P($G(^PSNDF(50.68,NDF,1)),U,7)
 I CODE="" S CODE=$TR($P($G(^PSDRUG(DRG,2)),U,4),"-","")
 S:$L(CODE)=12 CODE=$E(CODE,2,12)
 S STR=$$GET1^DIQ(50.68,NDF,2)
 S UNIT=$$GET1^DIQ(50.68,NDF,3)  ;,"I")
 ;S SNAME=$$GET1^DIQ(50.607,UNIT,.01)
 ;S SCODE=$$GET1^DIQ(50.607,UNIT,9999999.02)
 Q CODE_U_STR_U_UNIT   ;$S($L(SCODE):SCODE,1:SNAME)
 ;
BADORP ; EP - Send bulletin regarding bad ORP acknowledgement message
 S MSG(1)="HL7 Message "_$G(^HLB(MSGIEN,1))_$G(^HLB(MSGIEN,2))
 S MSG(2)=" "
 S MSG(3)="did not receive a valid NEWRX acknowledgement."
 S MSG(4)=" "
 S MSG(5)="Acknowledgement code: "_$G(AACK)
 S MSG(6)="Error: "_$G(ERRTXT)
 S MSG(7)=" "
 S WHO("G.APSP EPRESCRIBING")=""
 S:$G(OPRV) WHO(OPRV)=""
 D BULL^APSPES2A("HL7 ERROR","APSP eRx Interface",.WHO,.MSG)
 Q
 ; Send Notification to Ordering Provider
 ; Input: RXN = IEN to Prescription File
 ;        MSG = Main message
 ;      ALRTD = Alert data
 ;        DFN = Patient IEN (optional)
 ;     PVDIEN = Provider to received notification (optional)
 ;       FIEN = Duplicate File IEN
 ;       CHK  = Indicate wrong pt (optional)
 ;      TYPE  = Deny indicator
NOTIF(RXN,MSG,ALRTD,DFN,PVDIEN,FIEN,CHK,TYPE) ;EP
 N PNAM,RET,DUPORD,DUPDRUG
 N XQA,XQAID,XQADATA,XQAMSG,XQALERR,XQATEXT
 S FIEN=$G(FIEN),CHK=$G(CHK),TYPE=$G(TYPE)
 S:'$G(DFN) DFN=+$$GET1^DIQ(52,$G(RXN),2,"I")
 I $G(DFN) S PNAM=$E($$GET1^DIQ(2,DFN,.01)_"         ",1,9)
 E  S PNAM="Unknown patient"
 S XQAMSG=PNAM_" "_"("_$$HRC^APSPFUNC(DFN)_")"
 S:'$G(PVDIEN) PVDIEN=$$GET1^DIQ(52,$G(RXN),4,"I")
 ;P1023 IHS/MSC/MGH added for missing Rx
 I +PVDIEN S XQA(PVDIEN)=""
 E  S XQA("S.APSP EPRESCRIBING")=""
 S XQAMSG=XQAMSG_$G(MSG)
 ;I $G(RXN) S XQAID="OR"_","_DFN_","_99003
 I TYPE=4!($G(RXN)="") D
 .S XQAID="OR"_","_DFN_","_99006
 .I ALRTD'="" S XQATEXT(1,0)=ALRTD
 E  S XQAID="OR"_","_DFN_","_99003
 I +$G(RXN) S XQADATA=$$GET1^DIQ(52,$G(RXN),39.3,"I")_"@"_$G(ALRTD)
 E  D
 .I TYPE=1 S XQADATA="@"_$G(ALRTD)
 .E  S XQADATA=$G(HL7PON)_"@"_$G(ALRTD)
 I +FIEN D
 .S DUPORD=$$GET1^DIQ(9009033.91,FIEN,.02)
 .S DUPDRUG=$$GET1^DIQ(9009033.91,FIEN,1.1)
 .I +CHK=1 D
 ..S XQATEXT(1,0)="Duplicate request for order "_DUPORD_" for "_DUPDRUG
 ..S XQATEXT(2,0)="This SS number belongs to a different pt and "
 ..S XQATEXT(3,0)="will not be presented to you for processing. Please"
 ..S XQATEXT(4,0)="contact the receiving pharmacy if you have questions."
 .E  D
 ..S XQATEXT(1,0)="Duplicate request for order "_DUPORD_" for "_DUPDRUG
 ..S XQATEXT(2,0)="was already processed and will not be presented to you"
 ..S XQATEXT(3,0)="for processing. Please contact the receiving pharmacy"
 ..S XQATEXT(4,0)="if you have questions."
 I $G(ALRTD)["PON" D
 .S XQATEXT(1,0)="An invalid refill request, RX number: "_$P(ALRTD,":",2)_", for "_$$GET1^DIQ(2,DFN,.01)
 .S XQATEXT(2,0)="was received.  Request was denied or sent to the queue for processing."
 .S XQATEXT(3,0)="Contact the receiving pharmacy if you have questions."
 .S XQATEXT(3,0)=MSG
 D SETUP^XQALERT
 Q
DTSLK(RXN) ;Return orderable item based on RxNorm
 ;
 N CIEN,IEN,RET,STS,VAR
 ;
 I $G(RXN)="" Q ""
 ;
 ;Make sure the RxNorm is available in local cache
 S STS=$$CNCLKP^BSTSAPI("VAR",RXN_"^1552^2")
 ;
 ;Lookup concept
 S CIEN=$O(^BSTS(9002318.4,"C",1552,RXN,"")) I CIEN="" Q ""
 ;
 ;Retrieve NDC list
 S RET="",IEN=0 F  S IEN=$O(^BSTS(9002318.4,CIEN,7,IEN)) Q:'+IEN  D
 .Q:$P(RET,U,1)]""
 .N NDC,DA,IENS
 .S DA(1)=CIEN,DA=IEN,IENS=$$IENS^DILF(.DA)
 .S NDC=$$GET1^DIQ(9002318.47,IENS,.01,"I") Q:NDC=""
 .;Try to find orderable item
 .S RET=$$FNDDRG(NDC)
 ;
 Q RET
