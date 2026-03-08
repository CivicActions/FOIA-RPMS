APSPES3 ;IHS/MSC/PLS - SureScripts HL7 interface - con't;05-May-2021 14:15;MGH
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1008,1011,1013,1016,1023,1024,1025,1026,1028**;Sep 23, 2004;Build 50
 ; Send denial message
 ; Input:  ORID - ^OR(100 IEN
 ;        RXIEN - Prescription IEN
 ;          OCC - Order Control Code  (default to DF)
 ;       MSGTXT - optional
 ;          STA - Status (default to 3)
 ;IHS/GDIT/MSC/MGH EPCS changes to trim spaces DENY1+19 DENY1+30
 ;                      Quit if no message DENY1+35
 ;IHS/GDIT/MSC/MGH NCPDP Changed to send REPLACE messages
 ;                       Notifications sent for HLO errors
DENY(ORID,RXIEN,OCC,MSGTXT,STA) ;
 N RR
 S RR=$$VALUE^ORCSAVE2(+ORID,"SSRREQIEN")
 Q:'RR
DENY1 N DATA,HLMSGIEN,HLMSTATE,ARY,SEG,ACT,HLECH,HLFS
 N PARMS,ACK,ERR,I,FLG,LP,LOG,DNYC,DNYR,DFN,ACTUSR
 S ORID=+$G(ORID)
 S RXIEN=+$G(RXIEN)
 S ACT=$$GET1^DIQ(9009033.91,RR,.08,"I")
 S ACTUSR=$$GET1^DIQ(9009033.91,RR,.09,"I")
 S DFN=$$GET1^DIQ(9009033.91,RR,1.2,"I")
 ;S OCC=$G(OCC,"DF")
 S OCC=$S($G(OCC):OCC,ACT=3:"RP",ACT=4:"DF",1:"DF")
 S HLMSGIEN=$$GET1^DIQ(9009033.91,RR,.05)  ; Message ID
 ; TODO- Add logic to use the HL7 message text in the RR entry if HL7 message has been purged.
 Q:'HLMSGIEN
 S PARMS("ACK CODE")="AA"
 S PARMS("MESSAGE TYPE")="RRE"
 S PARMS("EVENT")="O26"
 S PARMS("VERSION")=2.5
 S PARMS("ACCEPT ACK TYPE")="AL"
 I $L($G(MSGTXT)) D
 .;IHS/GDIT/MSC/MGH EPCS trim spaces
 .S MSGTXT=$$TRIM^XLFSTR(MSGTXT)
 .;IHS/MSC/PLS - 09/01/2017 - CR8055
 .;I $L($P(MSGTXT,"-",1)) S DNYC=$P(MSGTXT,"-",1),MSGTXT=$P(MSGTXT,"-",2)
 .I $L($P(MSGTXT,"-",1)) S DNYC=$P(MSGTXT,"-",1),MSGTXT=$$TRIM^XLFSTR($P(MSGTXT,"-",2,10))
 .E  S DNYC="AF"
 E  D
 .S DNYR=$$VALUE^ORCSAVE2(+ORID,"SSDENYRSN")
 .I $L(DNYR) D
 ..S DNYC=$P(DNYR,"-")
 ..S MSGTXT=$$TRIM^XLFSTR($P(DNYR,"-",2,10))
 ..;S MSGTXT=$P(DNYR,"-",2)
 ..;IHS/GDIT/MSC/MGH EPCS trim spaces
 ..S MSGTXT=$$TRIM^XLFSTR(MSGTXT)
 .E  S DNYC="AF"
 I $L($G(MSGTXT))=0 S MSGTXT="Have patient return to clinic"
 S MSGTXT=$G(MSGTXT,"Have patient return to clinic.")
 D PARSE^APSPES2(.DATA,HLMSGIEN,.HLMSTATE)
 K FDA,ERR
 S:+$$GET1^DIQ(9009033.91,RR,.08,"I")'=3 FDA(9009033.91,RR_",",.02)="@"  ; Remove order ien
 I $$GET1^DIQ(9009033.91,RR,.03,"I")'=8 S FDA(9009033.91,RR_",",.03)=$S($G(STA):STA,1:3)  ; Set status to processed-denied
 S FDA(9009033.91,RR_",",.07)=$$NOW^XLFDT()
 S FDA(9009033.91,RR_",",4)=$G(DNYC)_"-"_$G(MSGTXT)
 I ACTUSR="" S FDA(9009033.91,RR_",",.09)=DUZ
 D FILE^DIE(,"FDA","ERR")
 K FDA,ERR
 ;IHS/GDIT/MSC/MGH EPCS QUIT IF NO MESSAGE
 I HLMSTATE("ID")="" D UPTRRACT(RR,$G(ERR,"Message no longer exists in HLO file.  Cannot process."))
 Q:HLMSTATE("ID")=""
 S HLFS=$G(DATA("HDR","FIELD SEPARATOR"))
 S HLECH=HLMSTATE("HDR","ENCODING CHARACTERS")
 I $$ACK^HLOAPI2(.HLMSTATE,.PARMS,.ACK,.ERR) D
 .D SETACK
 .I '$$SENDACK^HLOAPI2(.ACK,.ERR) D
 ..D NOTIF^APSPES4($G(RXIEN),"Unable to build HL7 message.","Unable to create HL7 message")
 ..D UPTRRACT(RR,$G(ERR,"There was a problem sending the HL7 message."))
 E  D
 .D NOTIF^APSPES4(RXIEN,"Unable to build HL7 message.","Unable to create HL7 message")
 .D UPTRRACT(RR,$G(ERR,"There was a problem generating the HL7 message."))
 ; Get original order prescription IEN
 I 'RXIEN D
 .N SEGIEN,SEGORC
 .D PARSE^APSPES2(.DATA,HLMSGIEN,.HLMSTATE)
 .S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"ORC")
 .I SEGIEN D
 ..M SEGORC=DATA(SEGIEN)
 ..S RXIEN=$$GET^HLOPRS(.SEGORC,2,1)
 ; Update activity log
 I RXIEN D
 .N LOG,RET,ACT,LACT
 .S LOG("REASON")="X"
 .S LOG("RX REF")=0
 .S LACT=$$LASTACT^APSPFNC6(RXIEN,"X")
 .S ACT=$S(LACT="F":"X",1:"T")
 .S ARY("TYPE")=ACT
 .S LOG("COM")="eRx denial response sent to "_$$PHMINFO^APSPES2A(RXIEN)
 .D UPTLOG^APSPFNC2(.RET,RXIEN,0,.LOG)
 I '$D(DUPDENY) D CHKDUP^APSPES11(RR)
 Q
SETACK ;Get original message to include in ack
 N PRV,ACT,NM,LP,VAL,INST,MRN
 D PREPARY^APSPES1(.DATA,"PID",.ARY)
 ;Get pt id
 D:$G(DFN) SET(.ARY,$$HRCNF^BDGF2(DFN,+$G(DUZ(2))),3,1)  ; Patient HRN
 S SEG=$$ADDSEG^HLOAPI(.ACK,.ARY)
 D SET(.ARY,OCC,1)  ; Order Control Code
 D PREPARY^APSPES1(.DATA,"ORC",.ARY)
 D SET(.ARY,OCC,1)  ; Order Control Code
 D SET(.ARY,$$HLDATE^HLFNC($$NOW^XLFDT()),9)  ; Written Date/Time
 D SET(.ARY,DNYC,16,1)  ; Order Control Code Reason Identifier
 D SET(.ARY,$E(MSGTXT,1,70),16,2)  ; Order Control Code Reason Text
 D SET(.ARY,"NCPDP1131",16,3)  ; Order Control Code Reason System
 D SET(.ARY,$$GET1^DIQ(4,+$G(DUZ(2)),.01),21)  ; Institution Name
 ;Get relates to message to put into ORC 3.2
 I +$G(RR) D
 .N HLO,RELATES,HLOIEN,HL7B
 .S HLB7=""
 .S HLO=$$GET1^DIQ(9009033.91,RR,.01)         ;Message ID
 .S RELATES=$$GET1^DIQ(9009033.91,RR,10)
 .D SET(.ARY,RELATES,3,2)
 ;End relates
 S PRV=$$GET1^DIQ(9009033.91,RR,1.3,"I")
 S ACT=$$GET1^DIQ(9009033.91,RR,.09,"I")
 I +PRV>.5 D
 .S NM=$$HLNAME^HLFNC($$GET1^DIQ(200,PRV,.01),HLECH)
 .F LP=1:1:$L(NM,$E(HLECH)) S VAL=$P(NM,$E(HLECH),LP) D
 ..D SET(.ARY,VAL,10,LP+1)  ; Entered provider
 I +PRV'=+ACT D
 .D SET(.ARY,ACT,19,1)
 .S NM=$$HLNAME^HLFNC($$GET1^DIQ(200,ACT,.01),HLECH)
 .F LP=1:1:$L(NM,$E(HLECH)) S VAL=$P(NM,$E(HLECH),LP) D
 ..D SET(.ARY,VAL,19,LP+1)  ; Acting provider
 S SEG=$$ADDSEG^HLOAPI(.ACK,.ARY)
 D PREPARY^APSPES1(.DATA,"RXE",.ARY)
 D SET(.ARY,0,12,1)  ; Refill count to zero
 ;Check
 S SEG=$$ADDSEG^HLOAPI(.ACK,.ARY)
 D PREPARY^APSPES1(.DATA,"RXR",.ARY)
 S SEG=$$ADDSEG^HLOAPI(.ACK,.ARY)
 ;D PREPARY^APSPES1(.DATA,"RXE",.ARY)
 ;S SEG=$$ADDSEG^HLOAPI(.ACK,.ARY)
 D PREPARY^APSPES1(.DATA,"RXD",.ARY)
 D SET(.ARY,0,8,1)  ; Refill count to zero
 S SEG=$$ADDSEG^HLOAPI(.ACK,.ARY)
 S LP=0
 S FLG=0 F I=1:1 D  Q:FLG
 .S LP=$$FSEGIEN^APSPES1(.DATA,"DG1",LP)
 .I LP=0 S FLG=1 Q
 .D PREPARY^APSPES1(.DATA,"DG1",.ARY,LP-1)
 .S SEG=$$ADDSEG^HLOAPI(.ACK,.ARY)
 Q
 ; Send accept,accept w/change or replace message
 ; Input:  ORID - ^OR(100 IEN
ACCEPT(RXIEN,ORID,MSGTXT) ;
 N RR,DATA,HLMSGIEN,HLMSTATE,ARY,SEG,SEGIEN,SEGRXO,DFN,PROV
 N PARMS,HLST,ERR,PRN,REF,REFILLS,I,FLG,LP,DISP,OCC,ACT,DRG
 N RX0,RX2,HLFS,HLECH,HL,SSNUM,RRPRV,COMMENTS,CHG,LOC,ORDER,CMP
 S REFILLS=$$GET1^DIQ(52,RXIEN,9,"I")
 S DFN=$$GET1^DIQ(52,RXIEN,2,"I")
 S RX0=^PSRX(RXIEN,0)
 S DRG=$P(RX0,U,6)
 S PROV=$P(RX0,U,4)
 S LOC=$P(RX0,U,5)
 S RX2=^PSRX(RXIEN,2)
 S DISP=REFILLS+1  ; Number of dispenses
 S COMMENTS=$$GETPRC^APSPES1()
 S RR=$$VALUE^ORCSAVE2(+ORID,"SSRREQIEN")
 Q:'RR
 S HLMSGIEN=$$GET1^DIQ(9009033.91,RR,.05)  ; Message ID
 ; TODO- Add logic to use the HL7 message text in the RR entry if HL7 message has been purged.
 Q:'HLMSGIEN
 S PARMS("ACK CODE")="AA"
 S PARMS("MESSAGE TYPE")="RRE"
 S PARMS("EVENT")="O26"
 S PARMS("VERSION")=2.5
 S PARMS("ACCEPT ACK TYPE")="AL"
 S MSGTXT=$G(MSGTXT,"")
 D PARSE^APSPES2(.DATA,HLMSGIEN,.HLMSTATE)
 S HLFS=$G(DATA("HDR","FIELD SEPARATOR"))
 S HLECH=$G(DATA("HDR","ENCODING CHARACTERS"))
 I $$ACK^HLOAPI2(.HLMSTATE,.PARMS,.HLST,.ERR) D
 .S PRN=$$GETVAL^APSPES2(HLMSGIEN,"ORC",7,7)="PRN"  ; Check for PRN value
 .S REF=+$$GETVAL^APSPES2(HLMSGIEN,"RXO",13,1)  ; incoming Refill count
 .S CMP=$$GETVAL^APSPES2(HLMSGIEN,"RXE",44,1)   ; Compound indicator
 .;Get PID information as for a new order
 .D PID^APSPES1(DFN)
 .;S OCC=$S(PRN:"AF",'REF:"AF",DISP'=REF:"CF",1:"AF")
 .S ACT=$$GET1^DIQ(9009033.91,RR,.08,"I")
 .;IHS/MSC/MGH Check for changes; Accept is not allowed if supervisor and provider changes were made
 .I ACT=1 D
 ..S CHG=$$RECHK^APSPES11(HLMSGIEN,PROV,RX2)
 ..I +CHG S ACT=2
 .S OCC=$S(ACT=1:"AF",ACT=2:"CF",ACT=5:"RO",1:"AF")   ;Added Replace patch 1024
 .D ORCNW^APSPES1(OCC,0)
 .S SSNUM=$$GET1^DIQ(9009033.91,RR,.1)
 .D SET(.ARY,SSNUM,3,1)   ;Set the surescripts number into ORC3
 .I OCC="CF"!(OCC="RO") D
 ..N NM,LP,VAL
 ..S RRPRV=$$GET1^DIQ(9009033.91,RR,1.3,"I")
 ..I PROV'=RRPRV D
 ...D SET(.ARY,$$SPI^APSPES1(PROV),19,1)
 ...S NM=$$HLNAME^HLFNC($$GET1^DIQ(200,PROV,.01),HLECH)
 ...F LP=1:1:$L(NM,$E(HLECH)) S VAL=$P(NM,$E(HLECH),LP) D
 ....D SET(.ARY,VAL,19,LP+1)  ; Acting provider
 ...D SET(.ARY,$$SPI^APSPES1(RRPRV),12,1)
 ...S NM=$$HLNAME^HLFNC($$GET1^DIQ(200,RRPRV,.01),HLECH)
 ...F LP=1:1:$L(NM,$E(HLECH)) S VAL=$P(NM,$E(HLECH),LP) D
 ....D SET(.ARY,VAL,12,LP+1)  ;Original Provider
 .S SEG=$$ADDSEG^HLOAPI(.HLST,.ARY)
 .D RXO^APSPES1(0,OCC)
 .D SET(.ARY,DISP,13,1)  ; Set refill count to # of dispenses
 .D SET(.ARY,COMMENTS,6,2)  ;Provider Comments Patch 1023
 .S SEG=$$ADDSEG^HLOAPI(.HLST,.ARY)
 .;D PREPARY^APSPES1(.DATA,"RXD",.ARY)
 .;D SET(.ARY,$$HLDATE^HLFNC($$NOW^XLFDT(),"DT"),3)
 .;D SET(.ARY,DISP,8,1)   ; Set refill count to # of dispenses
 .;S SE=$$ADDSEG^HLOAPI(.HLST,.ARY)
 .D ZCS^APSPES1(RX0,RXIEN)  ;patch 1023 add in controlled substance segment
 .D PREPARY^APSPES1(.DATA,"RXE",.ARY)
 .D SET(.ARY,DISP,12,1)
 .S SEG=$$ADDSEG^HLOAPI(.HLST,.ARY)
 .D RXR^APSPES1
 .;If renewal is for a compound med, send back the same RXC segments that were sent in
 .I $P($G(^PSDRUG(DRG,999999935)),U,1)=1 D
 ..I OCC="RO" D RXC^APSPES1
 ..E  D RNRXC
 .D DG1^APSPES1(.HLST,.ARY),AL1^APSPES1(.HLST,.ARY),OBX^APSPES5(.HLST,.ARY)
 .I '$$SENDACK^HLOAPI2(.HLST,.ERR) D
 ..D NOTIF^APSPES4(RXIEN,"Unable to build HL7 message.","Unable to create HL7 message")
 ..D UPTRRACT(RR,$G(ERR,"There was a problem sending the HL7 message."))
 E  D
 .D NOTIF^APSPES4(RXIEN,"Unable to build HL7 message.","Unable to create HL7 message")
 .D UPTRRACT(RR,$G(ERR,"There was a problem with generation of the HL7 message."))
 K FDA,ERR
 S FDA(9009033.91,RR_",",.03)=2  ; Set status to processed-accepted
 I +$G(RRPRV),PROV'=RRPRV S FDA(9009033.91,RR_",",1.13)=PROV
 S FDA(9009033.91,RR_",",.07)=$$NOW^XLFDT()
 D FILE^DIE("","FDA","ERR")
 I $D(ERR) D UPTRRACT(RR,$G(ERR(1),"Error updating status"))
 ; Update activity log
 I RXIEN D
 .N LOG,RET,LACT,ACT
 .S LOG("REASON")="X"
 .S LOG("RX REF")=0
 .S LACT=$$LASTACT^APSPFNC6(RXIEN,"X")
 .S ACT=$S(LACT="F":"X",1:"T")
 .S LOG("TYPE")=ACT
 .S LOG("COM")="eRx "_$$GET1^DIQ(9009033.91,RR,.08)_" response sent to "_$$PHMINFO^APSPES2A(RXIEN)
 .D UPTLOG^APSPFNC2(.RET,RXIEN,0,.LOG)
 .D ERX^APSPCSA(RXIEN,"TO")  ;Add call to update log for EPCS
 I '$D(DUPDENY) D CHKDUP^APSPES11(RR)
 ;IHS/MSC/MGH Patch 1024 Discontinue the original order
 D DCORIG^APSPES6(RXIEN)
 Q
 ;
SET(ARY,V,F,C,S,R) ;EP
 D SET^HLOAPI(.ARY,.V,.F,.C,.S,.R)
 Q
 ; Supports Refill Request Queue Deny message
 ; Input - IEN to APSP REFILL REQUEST file
DENYRPC(DATA,RR,MSGTXT) ;EP-
 N REQ
 S DATA=1
 Q:'$G(RR)
 S REQ=$$GET1^DIQ(9009033.91,RR,.12,"I")
 I REQ="C" D DENYCHG^APSPESC2(RR,MSGTXT)
 I REQ="R" D DENY1
 Q
 ; Update activity multiple of APSP Refill Request file
UPTRRACT(IEN,MSG) ;EP-
 N FDA,IENS,ERR,FN
 S IENS="+1,"_IEN_","
 S FN=9009033.916
 S FDA(FN,IENS,.01)=$$NOW^XLFDT()
 S FDA(FN,IENS,.02)=$E($G(MSG,"NO MESSAGE TEXT"),1,160)
 S FDA(FN,IENS,.03)=$G(DUZ)
 D UPDATE^DIE(,"FDA",,"ERR")
 Q
ARSPRRE ; EP - callback for RRE/O26 event
 N AACK,MSG,WHO,OPRV,ARY,RET,RXIEN,DATA,HLMSTATE,MSA
 N SEGIEN,SEGMSA,MSGIEN,SEGERR,ERRTXT,ORDCTL,TXT
 S MSGIEN=0
 D PARSE^APSPES2(.DATA,HLMSGIEN,.HLMSTATE)
 S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"MSA")
 I 'SEGIEN D  Q
 .D BADORP^APSPES4
 M SEGMSA=DATA(SEGIEN)
 S MSGIEN=+$P($$GET^HLOPRS(.SEGMSA,2)," ",2)
 S AACK=$$GET^HLOPRS(.SEGMSA,1)
 S TXT=$$GET^HLOPRS(.SEGMSA,3)
 I AACK'="AA" D
 .S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"ERR")
 .M SEGERR=DATA(SEGIEN)
 .S ERRTXT=$$GET^HLOPRS(.SEGERR,8)
 S RXIEN=$$RXIEN^APSPES2(MSGIEN)
 S OPRV=$$OPRV^APSPES2(MSGIEN)
 S ARY("REASON")="X"
 S ARY("RX REF")=0
 S ARY("USER")=OPRV
 I AACK'="AA" D  Q
 .D BADORP^APSPES4
 .;Only send notification if it was an Accept message
 .S ORDCTL=$$ORDCTL(MSGIEN)
 .I RXIEN D
 ..S ARY("TYPE")="F"
 ..S ARY("COM")=$S($L($G(ERRTXT)):ERRTXT,1:"ERROR: Electronic Prescription did not process.")
 ..D UPTLOG^APSPFNC2(.RET,RXIEN,0,.ARY)
 ..I ORDCTL="AF"!(ORDCTL="CF") D NOTIF^APSPES4(RXIEN,"ERROR: Electronic Prescription did not process.",$S($L($G(ERRTXT)):ERRTXT_"@D@"_MSGIEN,1:"Transmission was not accepted@D@"_MSGIEN))
 Q:'RXIEN
 S ARY("TYPE")="U"
 S ARY("COM")=$S(TXT'="":TXT,1:"eRx update: Prescription delivered to pharmacy.")
 ;"e-Pres update: Received STATUS update."
 D UPTLOG^APSPFNC2(.RET,RXIEN,0,.ARY)
 Q
ORDCTL(MSGIEN) ; EP
 N CTL,SEGORC
 D PARSE^APSPES2(.DATA,MSGIEN,.HLMSTATE)
 S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"ORC")
 Q:'SEGIEN 0
 M SEGORC=DATA(SEGIEN)
 S CTL=$$GET^HLOPRS(.SEGORC,1,1)
 Q CTL
 ;
DCORIG(RET,ORIEN) ; EP
 ;DC the original order on a deny message
 N ORGPKGID,ORXNUM,REA,MSG,DA,ORGIEN,PSCAN,STAT
 S RET=""
 S ORIEN=+$G(ORIEN)
 S ORGIEN=$$GET1^DIQ(100,ORIEN,9)
 Q:'+ORGIEN
 S STAT=$$GET1^DIQ(100,ORGIEN,5,"I")
 Q:STAT=1!(STAT=12)!(STAT=13)
 S ORGPKGID=+$$GET1^DIQ(100,ORGIEN,33,"I")
 Q:'ORGPKGID
 S ORXNUM=$$GET1^DIQ(52,ORGPKGID,.01)
 S REA="C",DA=ORGPKGID
 S MSG="Provider denied Surescripts refill request"
 S PSCAN(ORXNUM)=DA_"^C"
 D CAN^PSOCAN
 Q
ISRENEW(DATA,ORIEN) ;EP
 ;See if the new order is a auto-renewal order
 S DATA=$$GET1^DIQ(100,+$G(ORIEN),9)>0
 Q
RNRXC ;Send back renewal RXC segments
 N INTE,SEGRXC,SEG
 S SEGIEN=0
 F INTE=1:1 D  Q:'+SEGIEN
 .S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"RXC",SEGIEN)
 .Q:'+SEGIEN
 .D PREPARY^APSPES1(.DATA,"RXC",.ARY,SEGIEN-1)
 .S SEG=$$ADDSEG^HLOAPI(.HLST,.ARY)
 Q
