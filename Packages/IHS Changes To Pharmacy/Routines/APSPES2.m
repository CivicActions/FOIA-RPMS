APSPES2 ;IHS/MSC/PLS - SureScripts HL7 interface - con't;03-Nov-2022 10:07;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1008,1011,1016,1018,1023,1024,1026,1027,1028,1032**;Sep 23, 2004;Build 26
 ; Return array of message data
 ; Input: MIEN - IEN to HLO MESSAGES and HLO MESSAGE BODY files
 ; Output: DATA
 ;         HLMSTATE
 ; Modified  12/21/2017 IHS/MSC/MGH Patch 1023 ADDRR+26,ADDRR+58,ADDRR+86,RXIEN+8,REFRES+11
PARSE(DATA,MIEN,HLMSTATE) ;EP
 N SEG,CNT
 Q:'$$STARTMSG^HLOPRS(.HLMSTATE,MIEN)
 M DATA("HDR")=HLMSTATE("HDR")
 S CNT=0
 F  Q:'$$NEXTSEG^HLOPRS(.HLMSTATE,.SEG)  D
 .S CNT=CNT+1
 .M DATA(CNT)=SEG
 Q
 ; Process incoming RDS message
DISP ;EP
 D DISP^APSPES5
 Q
 ; Return Ordering Provider for HL7 Message
OPRV(MSGIEN) ; EP
 N RXIEN,VAL,RELATE
 S VAL=0,RELATE=""
 S RXIEN=+$$RXIEN(MSGIEN)
 Q:'RXIEN ""
 Q +$P($G(^PSRX(RXIEN,0)),U,16)
 ; Return RX IEN
 ; Input: MSGIEN - HLO Message IEN
 ;           TGL - default to 0, 1=return numeric value in HL7 message
RXIEN(MSGIEN,TGL) ; EP
 N RET,RXN,RXNP,RELATE
 S TGL=$G(TGL,0)
 D PARSE(.DATA,MSGIEN,.HLMSTATE)
 S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"ORC")
 Q:'SEGIEN ""
 M SEGORC=DATA(SEGIEN)
 S (RXN,RXNP)=$$GET^HLOPRS(.SEGORC,2,1)
 ;IHS/GDIT/MSC/MGH patch 1023
 S RELATE=$P($$GET^HLOPRS(.SEGORC,4,1),":",1)
 S RXN=$S(RXN?1N.N:RXN,RXN="":RXN,1:"invalid") ;P1026
 I RXN="invalid" S INVAL=RXNP
 I RELATE'[":" S RELATE=RXN      ;P1027
 ;We have a PON
 I +RXN=0 D
 .I +RELATE&(+RXN'=+RELATE) S RET=0  ;Items are both numbers but don't match
 .I '+RELATE S RELATE=RXN  ;Use PON as relate if its there
 I '+RXN D  ;Don't have a PON or its  not a number
 .I +RELATE S RXN=RELATE  ;Use relate if its there
 S RET=$S(TGL:RXNP,$D(^PSRX(+RXN,0)):RXN,'$D(^PSRX(+RXN,0)):RXN,1:0)
 Q RET
 ; Return Pharmacy Info for Activity Log
 ; Input - RXIEN - Prescription IEN
REFRES ; EP - Refill request callback
 ;Build response to Refill Request
 N DATA,PARMS,SEG,ACK,ARY,ERR,ORID,SEGRX0,SEGORC,REFILL,RR,ORITM,PRV,DFN
 N RXIEN,FN,DEA,MATCHK,CSMED,RELATE,DEA,INTYP,MSGID,RXTEXT,INVAL
 S MATCHK="",RELATE="",CSMED=0,INVAL=""
 D PARSE^APSPES2(.DATA,$G(HLMSGIEN),.HLMSTATE)
 ; Create entry in APSP SURESCRIPTS REQUEST file
 S FN=9009033.91
 S RR=$$ADDRR(+$G(HLMSGIEN),"R","")
 I $$GET1^DIQ(9009033.91,RR,.03,"I")=8 D STOREID^APSPES11(RR,$G(PRV),$G(DFN)) Q  ;Do not process duplicate record
 I $$GET1^DIQ(9009033.91,RR,.03,"I")=3 D STOREID^APSPES11(RR,$G(PRV),$G(DFN)) Q   ;IHS/GDIT/MSC/MGH P1023 Message was already denied
 I $$GET1^DIQ(9009033.91,RR,.1)="" D ERR900^APSPES4(RR,,"No SS Number-Invalid request") Q   ;Do not process items with no surescripts number
 S RXIEN=+$$GET1^DIQ(9009033.91,RR,.06,"I")
 S DEA=""
 S DEA=$$DEA^APSPES2A($P($G(^PSRX(RXIEN,0)),U,6))
 S MSGID=$$GETVAL^APSPES2(HLMSGIEN,"ORC",4,1)
 I RR,RXIEN D
 .;Allow automap if patient and provider match and there is an order
 .I MATCHK["P"&(MATCHK["D")&(MATCHK["M") D
 ..;Item is ready for provider - necessary items were mapped
 ..S:ORITM FDA(FN,RR_",",1.1)=+ORITM
 ..I +PRV S FDA(FN,RR_",",1.3)=PRV
 ..I +DFN S FDA(FN,RR_",",1.2)=DFN  ;Patient IEN
 ..;S FDA(FN,RR_",",1.6)=$G(LOC) ;Patient location
 ..S FDA(FN,RR_",",.11)=MATCHK
 ..S FDA(FN,RR_",",.03)=6  ;Set to mapping complete
 ..I MATCHK["Z" S FDA(FN,RR_",",.03)=5
 ..I MSGID="" S FDA(FN,RR_",",10)=RXIEN
 ..E  S FDA(FN,RR_",",10)=MSGID
 ..D FILE^DIE("K","FDA")
 ..D UPTRRACT^APSPES3(RR,"Request filed")
 ..D:PRV GSSNOTIF^APSPESM(+PRV)  ;P1026
 .E  D  ;Items could not be mapped so it needs to go to the queue
 ..S:ORITM FDA(FN,RR_",",1.1)=+ORITM
 ..I +PRV S FDA(FN,RR_",",1.3)=PRV
 ..I +DFN S FDA(FN,RR_",",1.2)=DFN  ;Patient IEN
 ..;S FDA(FN,RR_",",1.6)=$G(LOC) ;Patient location
 ..S FDA(FN,RR_",",.11)=MATCHK
 ..S FDA(FN,RR_",",.03)=5  ;Set to ready to be mapped
 ..I MSGID="" S FDA(FN,RR_",",10)=RXIEN
 ..E  S FDA(FN,RR_",",10)=MSGID
 ..D FILE^DIE("K","FDA")
 ..D UPTRRACT^APSPES3(RR,"Request filed")
 E  D
 .N HL7PON,ERRFLG
 .S HL7PON=$$RXIEN(HLMSGIEN,1) ;Get PON sent in HL7 request
 .I HL7PON?1.N,'(MATCHK["O") S ERRFLG=1
 .S:$G(ORITM) FDA(FN,RR_",",1.1)=+ORITM
 .I +$G(DFN) S FDA(FN,RR_",",1.2)=DFN  ;Patient IEN
 .I +$G(PRV) S FDA(FN,RR_",",1.3)=PRV  ;Provider IEN
 .I MATCHK["P"&(MATCHK["D")&(MATCHK["M") S FDA(FN,RR_",",.03)=6
 .E  S FDA(FN,RR_",",.03)=5
 .I MATCHK["Z" S FDA(FN,RR_",",.03)=5
 .I $G(ERRFLG) S FDA(FN,RR_",",.03)=9
 .S FDA(FN,RR_",",.11)=MATCHK
 .S FDA(FN,RR_",",10)=MSGID
 .D FILE^DIE("K","FDA")
 .D UPTRRACT^APSPES3(RR,"Request filed")
 .I $G(ERRFLG) D
 ..D UPTRRACT^APSPES3(RR,"PON does not match our records")
 ..D NOTIF^APSPES4("","PON does not match our records","PON:"_HL7PON,$G(DFN),$G(PRV))
 D:$G(PRV) GSSNOTIF^APSPESM(+PRV)  ;P1032 Ensure notification API is called
 Q
SET(ARY,V,F,C,S,R) ;EP
 D SET^HLOAPI(.ARY,.V,.F,.C,.S,.R)
 Q
 ; Add entry to REFILL REQUEST file
ADDRR(MSGIEN,INTYP,CTYPE) ; EP -
 N FDA,FN,I,ERR,IENS,SPI,RXIEN,DAYS,ACTSPI,NOTES,DRGCHK,ORIFN,CTYP,RXTEXT
 N FILLS,HMSG,PHARM,SSNUM,DXCODE,DX,FIEN,DAW,NEW,DEA,FQUAL,REQCHG,VITLCHK
 S DEA=""
 S FN=9009033.91,I="+1,",DFN=0,FIEN=0
 S FDA(FN,I,.01)=$$GET1^DIQ(778,MSGIEN,.01) ;Message ID
 S FDA(FN,I,.04)=+$$GET1^DIQ(778,MSGIEN,.16,"I")  ;Message D/T ;p26 added '+'
 S FDA(FN,I,.05)=MSGIEN  ;HLO Message IEN
 S FDA(FN,I,.07)=$$NOW^XLFDT() ;Last Update D/T
 S FDA(FN,I,.12)=INTYP
 ;Check for PON
 S RXIEN=$$RXIEN^APSPES2(MSGIEN)
 S RXTEXT=RXIEN
 S RXIEN=+RXIEN
 ;MSC/MGH Moved Z check to before O check 1028
 I +RXIEN D
 .I '$D(^PSRX(RXTEXT,0)) S MATCHK=MATCHK_"Z"
 .E  S MATCHK=MATCHK_"O"
 .S RELATE=+RXIEN
 E  D
 .I RXTEXT'="" D
 ..I RXTEXT="invalid" S MATCHK=MATCHK_"Z"
 ..E  I '$D(^PSRX(RXTEXT,0)) S MATCHK=MATCHK_"Z"
 ;Patient check for matching pts
 S:'DFN DFN=$$HRCNF^APSPFUNC($$GETVAL(MSGIEN,"PID",3,1))
 I 'RXIEN!(RXIEN'=RXTEXT) D
 .I DFN=-1 S DFN=$$CHKNME^APSPES4(MSGIEN)
 .E  S DFN=$$CHKOPT^APSPES4(DFN,MSGIEN)
 E  D
 .;check the pt in the order against the pt in the PID segment
 .S DFN=$$GET1^DIQ(52,RXIEN,2,"I")
 .S DFN=$$CHKOPT^APSPES4(DFN,MSGIEN,RXIEN)
 I +DFN D
 .S MATCHK=MATCHK_"P"  ;Patients match
 ;
 I INTYP="C"&(MATCHK["O") S ORITM=$$GETORD^APSPESC3(RXIEN)  ;MSC/MGH 1028
 E  S ORITM=$$FNDORD^APSPES4(MSGIEN,INTYP)
 I +ORITM D
 .S MATCHK=MATCHK_"M"  ;Drugs match
 .S FDA(FN,I,1.1)=$P(ORITM,U,1) ;Orderable item
 .S FDA(FN,I,1.8)=$P(ORITM,U,2) ;Drug IHS/MSC/MGH Patch 1023
 .I $P(ORITM,U,2) S DEA=$$DEA^APSPES2A($P(ORITM,U,2))
 ;Provider check
 S SPI=$$GETVAL(MSGIEN,"ORC",12,1)
 S PRV=$$FIND1^DIC(200,,"O",SPI,"ASPI")
 S ACTSPI=1
 I +PRV D
 .S ACTSPI=$$EFF^APSPES2A(PRV)
 .;IHS/MSC/MGH EPCS check for controlled substance and mark item if not allowed to eRx
 .I +ORITM D
 ..S REQCHG=$$CHKMED^APSPES5(+PRV,ORITM,MSGIEN,"",RXIEN)
 ..I REQCHG>2 S FDA(FN,I,1.11)=REQCHG
 ;END EPCS
 I 'RXIEN&(+PRV)&(+ACTSPI) S MATCHK=MATCHK_"D"
 I +RXIEN&(+PRV)&(+ACTSPI)&(PRV=$$GET1^DIQ(52,RXIEN,4,"I")) S MATCHK=MATCHK_"D"
 S SSNUM=$$GETVAL(MSGIEN,"ORC",3,1)
 S FILLS=$S(INTYP="R":$$GETVAL(MSGIEN,"RXD",8,1),1:$$GETVAL(MSGIEN,"RXE",12,1))  ;Number of fills requested
 S FQUAL=$S(INTYP="R":$$GETVAL(MSGIEN,"RXD",8,2),1:"")  ;Refill qualifier
 I CTYPE="R" D
 .I FILLS=""!(FILLS=0) S FILLS=1
 I DEA=2 S FILLS=1  ;No refills for C2
 I (DEA=3!(DEA=4))&(FILLS>5) S FILLS=6  ;Only 5 refills for C3&4
 ;IHS/MSC/MGH If fills is listed as PRN remove the drug matching item
 I (DEA>2)&(FQUAL="PRN") D
 .S FILLS=""  ;Don't allow match if PRN sent for fills
 .I MATCHK["M" S MATCHK=$TR(MATCHK,"M","")
 S:RXIEN FDA(FN,I,.06)=RXIEN  ;Original Prescription
 S PHARM=$$GETPHM^APSPES2A()
 S:PHARM FDA(FN,I,1.7)=PHARM
 S DAYS=$S(INTYP="R":$$GETVAL(MSGIEN,"RXD",22,1),1:$$GETVAL(MSGIEN,"ORC",7,3))   ; Days Supply
 S DAW=$S(INTYP="R":$$GETVAL(MSGIEN,"RXD",11,1),1:$$GETVAL(MSGIEN,"RXE",9,1))    ; DAW
 S DAW=$S(DAW="G":0,DAW="T":0,1:1)
 I +DAYS S FDA(FN,I,1.5)=DAYS
 S FDA(FN,I,1.4)=$S(INTYP="R":$$GETVAL(MSGIEN,"RXD",4,1),1:$$GETVAL(MSGIEN,"RXE",10,1))  ; Quantity
 S FDA(FN,I,1.9)=FILLS  ;Number of fills
 S FDA(FN,I,.1)=SSNUM   ;Surescripts number
 S FDA(FN,I,1.12)=DAW
 S FDA(FN,I,7.6)=$$GET1^DIQ(52,RXIEN,9999999.02,"I")  ;Add Chronic Med indicator Patch 1027
 ;Add Diagnosis
 D DIAG^APSPES2A(MSGIEN,RXIEN)
 ;Add Notes to Pharmacist
 S NOTES=$$GETVAL(MSGIEN,"RXE",21,1)
 S FDA(FN,I,4.2)=NOTES
 S FIEN=$$CHKSSNUM^APSPES4(SSNUM,MSGIEN,CTYPE)
 ;S FDA(FN,I,.03)=$S(FIEN:8,1:0) ;Status
 S FDA(FN,I,.03)=0
 I +RXIEN,$P($G(^PSRX(RXIEN,0)),U,5) S FDA(FN,I,1.6)=$P($G(^PSRX(RXIEN,0)),U,5)
 E  D  ;P1026 - Added default
 .N XLOC
 .S XLOC=+$$GET^XPAR("ALL","APSP SS REQ HOSP LOC DEF")
 .S:XLOC FDA(FN,I,1.6)=XLOC
 D UPDATE^DIE(,"FDA","IENS","ERR")
 K ERR
 S I=+IENS(1)_","
 D GETHMSG(MSGIEN,.HMSG)
 S FDA(FN,I,5)=HMSG  ;HL7 Message
 D FILE^DIE("K","FDA","ERR")
 D SIG^APSPES2A(+IENS(1),INTYP)
 D DOSES(+IENS(1))
 ;I RXTEXT'="" D
 ;.I '$D(^PSRX(RXTEXT,0)) D
 ;..D UPTRRACT^APSPES3(+IENS(1),"PON does not match our records")
 ;..I RXTEXT="invalid" S RXTEXT=INVAL
 ;..D NOTIF^APSPES4("","PON does not match our records","PON:"_INVAL,$G(DFN),$G(PRV))
 ;..S DATA2="",DUPDENY=1
 ;..S MSGTXT="ZZ-PON is invalid in our system"
 ;..D DENYRPC^APSPES3(.DATA2,+IENS(1),MSGTXT)
 I FIEN D
 .S NEW=+IENS(1)
 .Q:'NEW
 .N S,DATA2,CHECK,DUPDENY,CNT,OLDIEN
 .S OLDIEN=0,CNT=0
 .;IHS/MSC/MGH 7/12/2019 changed to find latest request, not first for an order
 .F  S OLDIEN=$O(^APSPRREQ("G",SSNUM,OLDIEN)) Q:'OLDIEN!(OLDIEN=NEW)  D
 ..S S=$$GET1^DIQ(9009033.91,OLDIEN,.03,"I")  ;Status
 ..;IHS/MSC/MGH changes to send denies after parent has been processed
 ..I S=2!(S=3) D
 ...;If duplicate already processed, order for same pt
 ...S CHECK=$$CHKDATA^APSPES11(OLDIEN,DFN,ORITM,MSGIEN,SSNUM,CTYPE)  ;Is it a match?
 ...I CHECK=1 D  ;Yes, its a duplicate
 ....S FDA(9009033.91,NEW_",",.03)=8
 ....S FDA(9009033.91,NEW_",",.08)=4
 ....D FILE^DIE("","FDA","ERR")
 ....D SETDUP^APSPES4(FIEN,NEW,CTYPE,MSGIEN)
 ....D NOTIF^APSPES4("","Duplicate SS Request received","DUP:"_+IENS(1),$$GET1^DIQ(9009033.91,OLDIEN,1.2,"I"),$$GET1^DIQ(9009033.91,OLDIEN,1.3,"I"),OLDIEN,0)
 ....S MSGTXT="AF-Duplicate Request Already Processed"
 ..E  D
 ...Q:S=8
 ...D SETDUP^APSPES7(SSNUM,OLDIEN,NEW,CTYPE,MSGIEN)
 ...D SETDUP^APSPES4(FIEN,NEW,CTYPE,MSGIEN)
 Q +$G(IENS(1))
 ; Extract data from segment
 ; Input: MSG - Message ien
 ;        SEG - Segment name
 ;        FLD - Field #
 ;        OFF - Offset in field (default to 1)
 ;        SUB
 ;        REP
GETVAL(MSG,SEG,FLD,OFF,SUB,REP) ;EP -
 N DATA,HLMSTATE,ARY,SEGIEN,SEGARY
 S OFF=$G(OFF,1)
 S SUB=$G(SUB,1)
 S REP=$G(REP,1)
 D PARSE(.DATA,MSG,.HLMSTATE)
 Q:'$D(DATA) ""
 S SEGIEN=$$FSEGIEN^APSPES1(.DATA,SEG)
 Q:'SEGIEN ""
 M SEGARY=DATA(SEGIEN)
 Q $$GET^HLOPRS(.SEGARY,FLD,OFF,SUB,REP)
DOSES(IEN) ;Get dosage fields
 N HLMSG,HLDATA,APSPORC,SEG,CNT,I,FDA,AIEN,ERR,FN,MUL,N,D,RTE,ROUTE,TYPE,FORM,QQFMT,CONJ,DUR,SCHED
 N SUBSCH
 S HLMSG=$$GHLDAT^APSPESG(IEN)
 S SEG=$S(INTYP="R":$$GETSEG^APSPESG(.HLDATA,"RXD"),1:"")
 ;S SEG=$P(APSPORC,"|",8)
 ;S CNT=$L(SEG,"~")
 S FN=9009033.912
 ;F I=2:1:CNT D
 ;.S MUL=$P(SEG,"~",I)
 ;.S MUL2=$P(MUL,U)
 S AIEN="+1,"_IEN_","
 ;IHS/MSC/MGH changes for patch 1024
 S MUL=$P(SEG,"|",18)
 I MUL="" S MUL="See Sig"
 S FDA(FN,AIEN,1.1)=$P(SEG,"|",17)
 ;changes
 S SCHED=$P(SEG,"|",10,1)
 I SCHED="" S SCHED="AS WRITTEN"
 S FDA(FN,AIEN,1.8)=SCHED
 ;I CNT>2 D
 ;.S CONJ=$P(MUL,"^",9)
 ;.S FDA(FN,AIEN,1.6)=$S(CONJ="S":"T",1:"A")
 ;Get the quantity qualifier
 S TYPE=$$GETVAL(MSGIEN,"RXD",5,1)
 S QQFMT=""
 I TYPE'="" D
 .S FORM=$O(^APSPNCP(9009033.7,"D",TYPE,""))
 .I FORM'="" S QQFMT=$P($G(^APSPNCP(9009033.7,FORM,0)),U,2)
 .S FDA(FN,AIEN,1.3)=$$UPPER^APSPES5(QQFMT)
 S FDA(FN,AIEN,.01)=$P(SEG,"|",17)_"&"_MUL_"&&"_QQFMT_"&"_$P(SEG,"|",17)_MUL
 ;S FDA(FN,AIEN,.01)=MUL_"&&&"_QQFMT_"&"_$P(ORITM,U,2)_"&"_MUL
 ;Lookup the route
 S RTE=""
 S ROUTE=$$GETVAL(MSGIEN,"RXD",15,2)
 I ROUTE'="" S RTE=$O(^PS(51.2,"B",ROUTE,""))
 I RTE="" D
 .S RTE=$O(^PS(51.2,"B","SEE SIG",""))
 S FDA(FN,AIEN,1.7)=RTE
 D UPDATE^DIE(,"FDA","AIEN","ERR")
 K FDA,ERR
 Q
SIG(IEN) ;Store sig
 D SIG^APSPES2A(IEN)
 Q
 ;
PREPPTXT(RET,RRIEN) ;Return prepared text from Pharmacy
 N M,C
 S RRIEN=$G(RRIEN,0)
 S M=$P(^APSPRREQ(RRIEN,0),U,5)
 S @RET@(1)="Pharmacy: "_$$GETVAL(M,"RXE",40,2)_" ("_$$FMTPHN($$GETVAL(M,"RXE",45))_")"
 S @RET@(2)="Drug description: "_$$GETVAL(M,"RXE",2,2)
 S @RET@(3)="Quantity: "_$$GETVAL(M,"RXE",10)_" "_$$GET1^DIQ(9009033.7,$$FIND1^DIC(9009033.7,,,$$GETVAL(M,"RXE",6)),1)
 S @RET@(4)="Days Supply: "_$$GETVAL(M,"ORC",7,3)
 S @RET@(5)="Sig-Directions: "_$$GETVAL(M,"RXE",7,2)
 S @RET@(6)="Note: "_$$GETVAL(M,"RXE",21,1)
 S @RET@(7)="Refills: "_+$$GETVAL(M,"RXE",12,1)
 S @RET@(8)="Substitution allowed: "_$$ESUBST($$GETVAL(M,"RXE",9))
 S @RET@(9)="Last fill date: "_$$FMTE^XLFDT($$FMDATE^HLFNC($$GETVAL(M,"ORC",27,1)),"5DZ0")
 S @RET@(10)=" "
 S @RET@(11)="Diagnosis: "_$$GETVAL(M,"DG1",3,2)
 Q
 ; Return full HL7 message
GETHMSG(MSGIEN,DATA) ;EP
 N MSG,SEG,CNT
 S DATA=$NA(^TMP("REFREQ",$J))
 K @DATA
 Q:'$$GETMSG^HLOMSG(MSGIEN,.MSG)
 S CNT=1
 S SEG(1)=MSG("HDR",1)_MSG("HDR",2)
 D ADD(.SEG)
 F  Q:'$$HLNEXT^HLOMSG(.MSG,.SEG)  D
 .D ADD(.SEG)
 Q
 ; Return external text for Substitution
ESUBST(VAL) ;
 Q $S(VAL="N":"Not Authorized",VAL="T":"Allow therapeutic",1:"Allowed Generic")
I() ;EP -
 S CNT=CNT+1
 Q CNT
 ; Add data to array
ADD(SEG) ; EP -
 N I
 S I=0 F  S I=$O(SEG(I)) Q:'I  S @DATA@($$I())=SEG(I)
 S @DATA@($$I())=""
 Q
ADD1(SEG) ;
 N QUIT,I,J,LINE
 S QUIT=0
 S (I,J)=1
 S LINE(1)=$E(SEG(1),1,255),SEG(1)=$E(SEG(1),81,9999)
 I SEG(1)="" K SEG(1)
 D SHIFT(.I,.J)
 S @VALMAR@($$I,0)=LINE(1)
 S I=1
 F  S I=$O(LINE(I)) Q:'I  D
 .S @VALMAR@($$I,0)=LINE(I)
 Q
 ;
SHIFT(I,J) ;
 I '$D(SEG(I)) S I=$O(SEG(0)) Q:'I
 I $L(LINE(J))<255 D
 .N LEN
 .S LEN=$L(LINE(J))
 .S LINE(J)=LINE(J)_$E(SEG(I),1,255-LEN)
 .S SEG(I)=$E(SEG(I),256-LEN,9999)
 .I SEG(I)="" K SEG(I)
 E  D
 .S J=J+1
 .S LINE(J)="-"
 D SHIFT(.I,.J)
 Q
 ; Return formatted phone number
FMTPHN(X) ;EP
 N RES
 I $E(X,1,10)?10N Q "("_$E(X,1,3)_")"_$E(X,4,6)_"-"_$E(X,7,10)_$S($L($E(X,11,20)):"  "_$E(X,11,20),1:"")
 I $E(X,1,7)?7N Q $E(X,1,3)_"-"_$E(X,4,7)_"  "_$E(8,20)
 I X?10N1" ".6UN Q "("_$E(X,1,3)_")"_$E(X,4,6)_"-"_$E(X,7,10)_$S($L($E(X,11,20)):"  "_$E(X,11,20),1:"")
 I X?3N1"-"3N1"-"4N.1" ".A Q "("_$E(X,1,3)_")"_$E(X,5,12)_"  "_$E(X,13,20)
 I X?3N1"-"4N Q X
 I X?3N1"-"4N.1" ".6UN Q X
 Q X
RREQSTAT(DATA,IEN,STA) ; EP -
 D RREQSTAT^APSPES2A(.DATA,.IEN,.STA)
 Q
ACK(HLMSGIEN,MSGTXT) ; Generate APP Ack
 N PARMS,ACK,ERR,OCC,DNYC
 S PARMS("ACK CODE")="AE"
 S PARMS("ERROR MESSAGE")=MSGTXT
 D PARSE^APSPES2(.DATA,HLMSGIEN,.HLMSTATE)
 I $$ACK^HLOAPI2(.HLMSTATE,.PARMS,.ACK,.ERR) D
 .S OCC="UF",DNYC="AF"
 .D SETACK^APSPES3
 .I '$$SENDACK^HLOAPI2(.ACK,.ERR)&(+RR) D UPTRRACT^APSPES3(RR,$G(ERR,"There was a problem generating the HL7 message"))
 Q
