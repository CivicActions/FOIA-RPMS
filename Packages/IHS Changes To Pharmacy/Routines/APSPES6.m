APSPES6 ;IHS/MSC/PLS - SureScripts HL7 interface  ;18-Aug-2021 13:03;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1024,1026,1027,1028**;Sep 23, 2004;Build 50
 ;====================================================================
 Q
 ; Build Cancel HL7 segments for Surescripts
 ; Input: RXIEN - File 52 IEN
 ;        RTMID - ResponseToMessageID
CANCEL(RXIEN) ;EP
 N HLPM,HLST,ERR,ARY,HLECH,HLFS,APPARMS,EXPDTE,CANDTE
 N RX0,RX2,DFN,LN,HL1,HL,RTMID
 S EXPDTE=$$GET1^DIQ(52,RXIEN,26,"I")
 S CANDTE=$$GET1^DIQ(52,RXIEN,26.1,"I")
 Q:DT>EXPDTE     ;Do not send on expired meds
 S LN=0
 S HLPM("MESSAGE TYPE")="OMP"
 S HLPM("EVENT")="O09"
 S HLPM("VERSION")=2.5
 I '$$NEWMSG^HLOAPI(.HLPM,.HLST,.ERR) D  Q
 .D NOTIF^APSPES4(RXIEN,"Unable to build HL7 message.","Unable to create HL7 message")
 .S ARY("REASON")="X"
 .S ARY("RX REF")=0
 .S ARY("COM")="eRx request failed"
 .S ARY("TYPE")="F"
 .D UPTLOG^APSPFNC2(.RET,RXIEN,0,.ARY)
 S HLFS=HLPM("FIELD SEPARATOR")
 S HLECH=HLPM("ENCODING CHARACTERS")
 S HL1("ECH")=HLECH
 S HL1("FS")=HLFS
 S HL1("Q")=""
 S HL1("VER")=HLPM("VERSION")
 S RX0=^PSRX(RXIEN,0)
 S RX2=^PSRX(RXIEN,2)
 S DFN=$P(RX0,U,2)
 ;Create segments
 ;
 D PID^APSPES1(DFN),ORCNW("DC",1),RXO^APSPES1(1,"DC"),RXR^APSPES1,RXC^APSPES1
 ; Define sending and receiving parameters
 S APPARMS("SENDING APPLICATION")="APSP RPMS"
 S APPARMS("ACCEPT ACK TYPE")="AL"  ;Commit ACK type
 ;S APPARMS("APP ACK RESPONSE")="AACK^APSPES1"  ;Callback when 'application ACK' is received
 S APPARMS("ACCEPT ACK RESPONSE")="CACK^APSPES1"  ;Callback when 'commit ACK' is received
 S APPARMS("APP ACK TYPE")="AL"  ;Application ACK type
 S APPARMS("QUEUE")="APSP ERX"   ;Incoming QUEUE
 S APPARMS("FAILURE RESPONSE")="FAILURE^APSPES4"  ;Callback for transmission failures (i.e. - No 'commit ACK' received or message not sendable.
 S WHO("RECEIVING APPLICATION")="SURESCRIPTS"
 S WHO("FACILITY LINK NAME")="APSP EPRES"
 I '$$SENDONE^HLOAPI1(.HLST,.APPARMS,.WHO,.ERR) D
 .D NOTIF^APSPES4(RXIEN,"Unable to build HL7 message.","Unable to send request")
 .S ARY("REASON")="X"
 .S ARY("RX REF")=0
 .S ARY("COM")="eRx request failed"
 .S ARY("TYPE")="F"
 .D UPTLOG^APSPFNC2(.RET,RXIEN,0,.ARY)
 .D ERX^APSPCSA(RXIEN,"UN")   ;Add call to update log for EPCS
 E  D  ; Update activity log
 .N LACT,ACT
 .S ARY("REASON")="X"
 .S ARY("RX REF")=0
 .S LACT=$$LASTACT^APSPFNC6(RXIEN,"X")
 .S ACT=$S(LACT="F":"X",1:"T")
 .S ARY("TYPE")=ACT
 .S ARY("COM")="eRx Cancel RX request sent to "_$$PHMINFO^APSPES2A(RXIEN)
 .D UPTLOG^APSPFNC2(.RET,RXIEN,0,.ARY)
 .S RTMID=$$GET1^DIQ(778,$G(HLST("IEN")),.01)
 .D ERX^APSPCSA(RXIEN,"TO")  ;Add call to update log for EPCS
 Q
 ;
 ; Create ORC segment
ORCNW(OCC,ADD) ;EP
 N ORC,INST,NM,LP,VAL,IMMSUP,IMMNPI,ORDER,RRIEN,SSNUM,HLO,HLOIEN,HLB7,RELATES,DIG,EARLY,SSREL
 S ADD=$G(ADD,1)
 D SET(.ARY,"ORC",0)
 D SET(.ARY,OCC,1)
 D SET(.ARY,RXIEN,2,1)
 D SET(.ARY,"OP7.0",2,2)
 S SSREL=$$GET1^DIQ(52,RXIEN,9999999.45)    ;Add relates to message ID
 D SET(.ARY,SSREL,3,2)
 D SET(.ARY,"D"_$P(RX0,U,8),7,3)
 D ORC7^APSPES1
 D SET(.ARY,$$HLDATE^HLFNC($P(RX0,U,13),"DT"),9)   ;Issue Date
 D SET(.ARY,+$P(RX0,U,16),10,1)  ;Entered By IEN
 I +$P(RX0,U,16)>.5 D
 .S NM=$$HLNAME^HLFNC($$GET1^DIQ(200,$P(RX0,U,16),.01),HLECH)
 .F LP=1:1:$L(NM,$E(HLECH)) S VAL=$P(NM,$E(HLECH),LP) D
 ..D SET(.ARY,VAL,10,LP+1)
 S IMMSUP=$$GET1^DIQ(49,$$GET1^DIQ(200,+$P(RX0,U,4),29,"I"),2,"I")
 S IMMNPI=$$GET1^DIQ(200,+IMMSUP,41.99) ; Immediate Supervisor NPI
 D SET(.ARY,IMMNPI,11)
 S NM=$$HLNAME^HLFNC($$GET1^DIQ(200,IMMSUP,.01),HLECH)
 F LP=1:1:$L(NM,$E(HLECH)) S VAL=$P(NM,$E(HLECH),LP) D
 .D SET(.ARY,VAL,11,LP+1)  ;Immediate Supervisor (Chief of service)
 D SET(.ARY,$$PRVDEA^APSPES9(IMMSUP),11,10)  ; SUP DEA Patch 1023
 D SET(.ARY,$$SPI^APSPES1(+$P(RX0,U,4)),12)
 S NM=$$HLNAME^HLFNC($$GET1^DIQ(200,$P(RX0,U,4),.01),HLECH)
 F LP=1:1:$L(NM,$E(HLECH)) S VAL=$P(NM,$E(HLECH),LP) D
 .D SET(.ARY,VAL,12,LP+1)  ;Provider
 D SET(.ARY,$$PRVDEA^APSPES9(+$P(RX0,U,4)),12,10)  ; DEA
 D SET(.ARY,$$DETOX^APSPES9(RXIEN,$P(RX0,U,4),$P(RX0,U,6)),12,13)  ;IHS/MSC/MGH Patch 1023 Detox
 D SET(.ARY,+$P(RX0,U,5),13,1)
 D SET(.ARY,$$GET1^DIQ(44,+$P(RX0,U,5),.01),13,2)  ;Clinic
 D SET(.ARY,$$HLPHONE^HLFNC($$GET1^DIQ(44,+$P(RX0,U,5),99)),14)  ;Clinic Phone
 D:ADD SET(.ARY,"DC",16)
 S INST=+$$GETRINST^APSPES1($P(RX2,U,9))
 S:'INST INST=+$G(DUZ(2))
 D SET(.ARY,$$GET1^DIQ(4,INST,.01),21)  ; Institution Name
 D SET(.ARY,$$HLPHONE^HLFNC($$GET1^DIQ(9999999.06,INST,.13)),23,1)
 D SET(.ARY,"WPN",23,2)
 D SET(.ARY,"PH",23,3)
 D SET(.ARY,$$GET1^DIQ(4,INST,1.01),24,1)  ; Institution Address 1
 D SET(.ARY,$$GET1^DIQ(4,INST,1.02),24,2)  ; Institution Address 2
 D SET(.ARY,$$GET1^DIQ(4,INST,1.03),24,3)  ; Institution City
 D SET(.ARY,$$GET1^DIQ(5,$$GET1^DIQ(4,INST,.02,"I"),1),24,4)  ; Institution State Abbreviation
 D SET(.ARY,$E($$GET1^DIQ(4,INST,1.04,"I"),1,5),24,5)  ; Institution 5 digit Zip Code
 ;Code added to return Surescripts number if a new order following a deny
 S ORDER=$$GET1^DIQ(52,RXIEN,39.3)
 ;IHS/GDIT/MSC/MGH add documentation for digitally signed
 S DIG=$$DIG^APSPFUNC(ORDER,RXIEN)  ;EPCS PATCH
 D SET(.ARY,DIG,30,1)
 S EARLY=$$VALUE^ORCSAVE2(ORDER,"EARLIEST")
 I +EARLY D SET(.ARY,$$HLDATE^HLFNC(EARLY,"DT"),15)
 E  D SET(.ARY,$$HLDATE^HLFNC($P(RX2,U,13),"DT"),15)  ;Fill Date
 S RRIEN=$$VALUE^ORCSAVE2(ORDER,"SSRREQIEN")
 I +$G(RRIEN) D
 .S HLB7=""
 .S SSNUM=$$GET1^DIQ(9009033.91,RRIEN,.1)
 .S HLO=$$GET1^DIQ(9009033.91,RRIEN,.01)         ;Message ID
 .;S RELATES=$$GET1^DIQ(9009033.91,RRIEN,10,":",1)
 .;S HLOIEN=$O(^HLB("B",HLO,""))
 .;I +HLOIEN S HLB7=RELATES_":"_$P($G(^HLB(HLOIEN,0)),U,7)  ;add relates
 .D SET(.ARY,SSNUM,3,1)
 .;D SET(.ARY,HLB7,3,2)
 S:ADD ORC=$$ADDSEG^HLOAPI(.HLST,.ARY)
 Q
 ; Create ORC Refill Request segment
 ; Input: IORC = Incoming ORC segment
SET(ARY,V,F,C,S,R) ;EP
 D SET^HLOAPI(.ARY,.V,.F,.C,.S,.R)
 Q
DCORIG(RXIEN) ;Discontinue the original order when processing a request
 N ORDER,MSG,PLACER,RRIEN,RELRX,RELOR,RET,RX0,PROV,LOC,PSODFN,REA,COM
 S RX0=^PSRX(RXIEN,0)
 S PROV=$P(RX0,U,4)
 S LOC=$P(RX0,U,5)
 S ORDER=$$GET1^DIQ(52,RXIEN,39.3)
 S PSODFN=$$GET1^DIQ(52,RXIEN,2,"I")
 S RRIEN=$$VALUE^ORCSAVE2(ORDER,"SSRREQIEN")
 Q:'+RRIEN
 S RELRX=$P($$GET1^DIQ(9009033.91,RRIEN,10),":",1)
 Q:'+RELRX
 S RELOR=$$GET1^DIQ(52,RELRX,39.3)
 ;D DC^ORWDXA(.RET,RELOR,PROV,LOC,14,0,0)
 N DA,RX,PSCAN
 S DA=RELRX,REA="C"
 S RX=$P(^PSRX(DA,0),"^")
 S PSCAN(RX)=DA_"^"_REA
 S MSG="DC due to Surescripts request"
 D CAN1^PSOCAN3
 Q
UNDOACTN(RET,RRIEN) ;Rollback the action when an unsigned SS order is deleted before signing
 N FDA,ERR,FN,TYP
 S FN=9009033.91
 S RET="",ERR=""
 S FDA(FN,RRIEN_",",.02)="@"      ; Remove order
 S TYP=$$GET1^DIQ(9009033.91,RRIEN,.12,"I")
 I TYP="R" S FDA(FN,RRIEN_",",.03)=6
 I TYP="C" D
 .S FDA(FN,RRIEN_",",.03)=0        ;Set to mapping complete
 .S FDA(FN,RRIEN_",",8)="@"        ;Remove RxChange XML content
 S FDA(FN,RRIEN_",",.08)="@"      ;Remove activity action
 D FILE^DIE("K","FDA","ERR")
 I ERR S RET="-1^Unable to  rollback entry"
 E  S RET=1
 ;Next remove the 4.5 node and replace it with the original node
 K ^APSPRREQ(RRIEN,4.5)
 ;I TYP="R" D
 M ^APSPRREQ(RRIEN,4.5)=^APSPRREQ(RRIEN,4.6)
 D UPDFLDS^APSPESG3(RRIEN) ;Reset field values
 Q
APSPSIG(IEN) ;Get the sig from the APSP SURESCRIPTS file
 N SIGI,SIGDAT
 S SIGDAT="",SIGI=0
 F  S SIGI=$O(^APSPRREQ(IEN,3,SIGI)) Q:'+SIGI  D
 .I SIGDAT="" S SIGDAT=$G(^APSPRREQ(IEN,3,SIGI,0))
 .E  S SIGDAT=SIGDAT_" "_$G(^APSPRREQ(IEN,3,SIGI,0))
 Q SIGDAT
FORMAT(TEXT,SIGARR) ;Format the sig in the ZMR segment
 N Z0,Z1,CNT,CHAR,TOT,STR,I
 S CNT=0,TOT=0,STR=""
 S Z0=$L(TEXT," ")
 Q:Z0=""
 F I=1:1:Z0 D
 .S Z1=$P(TEXT," ",I) Q:Z1=""  D
 .S CHAR=$L(Z1)+1
 .S TOT=TOT+CHAR
 .I TOT>200 D
 ..S CNT=CNT+1
 ..I CNT=1 S SIGARR(CNT,0)=STR
 ..E  S SIGARR(CNT,0)=$G(SIGARR(CNT,0))_" "_STR
 ..S TOT=0,STR=Z1,CHAR=0
 .E  D
 ..I I=1 S STR=Z1
 ..E  S STR=STR_" "_Z1
 S CNT=CNT+1
 S SIGARR(CNT,0)=STR
 Q
REFNULL(RET,APSPIEN) ;Return a 1 or 0 depending on a renewal having null refills
 N HLOIEN,TYPE,DATA
 S RET=0
 S HLOIEN=$$GET1^DIQ(9009033.91,APSPIEN,.05,"I")
 S TYPE=$$GET1^DIQ(9009033.91,APSPIEN,.12,"I")
 I TYPE="R"&+HLOIEN D
 .D PARSE^APSPES2(.DATA,HLOIEN,.HLMSTATE)
 .S FILLS=$$GETVAL^APSPES2(HLOIEN,"RXD",8,1)
 .I FILLS="" S RET=1
 Q
