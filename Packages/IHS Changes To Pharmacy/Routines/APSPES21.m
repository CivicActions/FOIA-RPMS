APSPES21 ;IHS/MSC/PLS - SureScripts HL7 interface - con't;22-Apr-2020 16:44;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1024,1025,1026**;Sep 23, 2004;Build 47
 ; Set sig to accomodate several components in one field for very large SIGs
 ;IHS/MSC/MGH P1026 added change codes
GETSIG(ARY,OCC) ;EP
 N LP,RET,CNT,SEGIEN,SEGDAT,SL,ORID,TXT
 S RET=""
 I OCC="NW"!(OCC="RO")!(OCC="DC")!(OCC="XR")!(OCC="XC") D
 .S LP=0 F  S LP=$O(^PSRX(RXIEN,"SIG1",LP)) Q:'LP  D
 ..S RET=RET_$G(^PSRX(RXIEN,"SIG1",LP,0))
 .D RESET(RET)
 I OCC="AF"!(OCC="CF") D
 .D PARSE^APSPES2(.DATA,HLMSGIEN,.HLMSTATE)
 .S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"RXD")
 .Q:'SEGIEN
 .M SEGDAT=DATA(SEGIEN)
 .S CNT=1,RET=""
 .F  S SL=$$GET^HLOPRS(.SEGDAT,9,"","",CNT) Q:SL=""  D
 ..D SET^APSPES1(.ARY,SL,7,1,,CNT)
 ..S CNT=CNT+1
 Q
RESET(RET) ;Redo the string and send it back
 ;EPCS trim spaces
 N CNTP,LEN,LEFT,STR
 S CNTP=0
 S RET=$$TRIM^XLFSTR(RET,"L")
 S RET=$$TRIM^XLFSTR(RET,"R")
 S LEN=$L(RET)
 I LEN<201  D
 .S CNTP=CNTP+1
 .D SET^APSPES1(.ARY,RET,7,1,,CNTP)
 E  D
 .F  D  Q:$L(RET)=0
 ..S STR=$E(RET,1,200)
 ..S CNTP=CNTP+1
 ..D SET^APSPES1(.ARY,STR,7,1,,CNTP)
 ..S LEFT=$E(RET,201,$L(RET))
 ..S RET=LEFT
 Q
RXNORMOI(RET,RXN) ;Return a drug based on the Rxnorm code
 N ORD,DRG
 S RET=$$DTSLK^APSPES4(RXN) ;Return orderable item based on RxNorm
 I $P(RET,U,2)'="" D
 .S DRG=$P(RET,U,2)
 .S RET=RET_U_$$GET1^DIQ(50,DRG,.01,"E")
 Q
