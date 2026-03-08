APSPESMH ;IHS/MSC/PLS - Surescripts Medical History Support;09-Apr-2021 10:35;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1027,1028**;Sep 23, 2004;Build 50
 Q
 ; Request a Medical History Report from Surescripts
REQMH(RET,DFN,PROV,SDT,EDT,XML) ;-
 N FDA,IENS,FN,AIEN,ERR,ISA
 S FN=9009033.85
 S IENS="+1,"
 S FDA(FN,IENS,.01)=$$NOW^XLFDT()
 S FDA(FN,IENS,.02)=DUZ
 S FDA(FN,IENS,.03)=DFN
 S FDA(FN,IENS,.04)="I"
 S FDA(FN,IENS,.05)=PROV
 S FDA(FN,IENS,.06)=SDT
 S FDA(FN,IENS,.07)=EDT
 D UPDATE^DIE(,"FDA","AIEN","ERR")
 S RET=$S($D(ERR):"-1^"_$G(ERR("DIERR",1,"TEXT",1)),1:$G(AIEN(1)))
 Q:RET<0
 ;Call API
 S ISA=$$ACTIVISA(DFN)
 ;D TEST(AIEN(1),$R($P(^APSPMHRS(0),U,3)))
 D  ;Place XML into field
 .N TCNT,I,TXT
 .S TCNT=1
 .S I="" F  S I=$O(XML(I)) Q:I=""  D
 ..S TXT(TCNT,0)=$G(XML(I))
 ..S TCNT=TCNT+1
 .D WP^DIE(9009033.85,+AIEN(1)_",",3,,"TXT","ERR")
 ;
 ;Pass Patient and Provider IENs and let API gather other needed info.
 Q
 ;Store Eligibility/Benefit result
 ;Input: REQIEN - Request IEN making the request
 ;         NODE - Global reference containing 270 information
 ;         NODE1 - Global reference containing 271 information
MHELIG(REQIEN,NODE,NODE1) ;-
 ;Access global passed back from BEPR
 N FDA,IENS,FN,AIEN,ERR
 S FN=9009033.87
 S FDA(FN,"+1,",.01)=$$NOW^XLFDT()
 S FDA(FN,"+1,",.02)=$$GET1^DIQ(9009033.85,REQIEN,.05,"I")  ;Provider
 S FDA(FN,"+1,",.03)=$$GET1^DIQ(9009033.85,REQIEN,.03,"I")  ;Patient
 S:$L(NODE) FDA(FN,"+1,",1)=NODE  ;$NA(^TMP($J,270,"WP"))  ;todo - pass as the node reference
 S:$L(NOD1) FDA(FN,"+1,",2)=NODE1  ;$NA(^TMP($J,271,"WP"))
 D UPDATE^DIE(,"FDA","AIEN","ERR")
 S AIEN=+$G(AIEN(1))
 K FDA,ERR
 I AIEN D
 .S FDA(9009033.85,REQIEN_",",2)=AIEN
 .S FDA(9009033.85,REQIEN_",",.04)="B"
 .D FILE^DIE(,"FDA","ERR")
 Q
 ;Store Medical History result
 ;Input: REQIEN - Request IEN being resulted
 ;         NODE - Global reference containing result information
MHRES(REQIEN,NODE) ;-
 ;Access global passed back from BEPR
 N FDA,IENS,FN,AIEN,ERR
 S FN=9009033.86
 S FDA(FN,"+1,",.01)=$$NOW^XLFDT()
 S FDA(FN,"+1,",.02)=$$GET1^DIQ(9009033.85,REQIEN,.02,"I")  ;Requestor
 S FDA(FN,"+1,",.03)=$$GET1^DIQ(9009033.85,REQIEN,.03,"I")  ;Patient
 S:$L(NODE) FDA(FN,"+1,",1)=NODE  ;$NA(^TMP($J,"WP"))  ;todo - pass as the node reference
 D UPDATE^DIE(,"FDA","AIEN","ERR")
 S AIEN=+$G(AIEN(1))
 K FDA,ERR
 I AIEN D
 .S FDA(9009033.85,REQIEN_",",1)=AIEN
 .S FDA(9009033.85,REQIEN_",",.04)="C"
 .D FILE^DIE(,"FDA","ERR")
 .D FIREINFO(REQIEN)
 Q
 ; Return Med History Result XML
GETMHRES(DATA,REQIEN) ;-
 N LP,RESIEN
 S DATA=$$TMPGBL^CIAVMRPC("_MHRESULT")
 K @DATA
 S RESIEN=+$$GET1^DIQ(9009033.85,REQIEN,1,"I")
 Q:'RESIEN
 S LP=0 F  S LP=$O(^APSPMHRS(RESIEN,1,LP)) Q:'LP  D
 .D ADD(^APSPMHRS(RESIEN,1,LP,0))
 Q
 ;
ADD(STR) ;-
 S CNT=$G(CNT)+1
 S @DATA@(CNT)=STR
 Q
 ; Return NCPDP Codes for a context
NCPDPCOD(DATA,CONTEXT) ;-
 N LP,CNT,NOD0
 S DATA=$$TMPGBL^CIAVMRPC("_NCPDP")
 K @DATA
 S CNT=0
 S LP=0 F  S LP=$O(^APSPNCP(9009033.7,LP)) Q:'LP  D
 .S NOD0=^APSPNCP(9009033.7,LP,0)
 .Q:$P(NOD0,U,5)  ;Inactive
 .Q:$P(NOD0,U,3)'=CONTEXT
 .S CNT=CNT+1
 .;S DATA(CNT)=LP_U_$P(NOD0,U,4)_U_$P(NOD0,U,1)_U_$P(NOD0,U,2)
 .D ADD(LP_U_$P(NOD0,U,4)_U_$P(NOD0,U,1)_U_$P(NOD0,U,2))
 Q
 ; Return availability of patient consent for summary request
HASCNSNT(DATA,DFN) ;-
 N REC,ACK
 S REC=$$GET1^DIQ(9000038,+$G(DFN),.02,"I")
 S ACK=$$GET1^DIQ(9000038,+$G(DFN),.04,"I")
 S DATA=(REC="Y"&(ACK="Y"))
 Q
 ; Return existing ISA if within range of 72 hours of current time
ACTIVISA(DFN) ;-
 N ISA,ISADT,IEN
 S ISA=""
 S ISADT=$O(^APSPMHEB("ISA",DFN,$C(1)),-1)
 I ISADT,($$ABS^XLFMTH($$FMDIFF^XLFDT($$NOW^XLFDT,ISADT,2))<259201) D
 .S IEN=$O(^APSPMHEB("ISA",DFN,ISADT,0))
 .I IEN S ISA=$P(^APSPMHEB(IEN,0),U,4)
 Q ISA
 ; Fire INFO event
FIREINFO(REQIEN) ;-
 N PTNM,TXT,USR,REQTOR
 S PTNM=$$GET1^DIQ(9009033.85,REQIEN,.03)
 S REQTOR=$$GET1^DIQ(9009033.85,REQIEN,.02,"I")
 I REQTOR D
 .S USR("DUZ",REQTOR)=""
 .S TXT="Results have been received from Surescripts for "_PTNM_"."
 .D BRDCAST^CIANBEVT("INFO","^^Open the SS MailBox to view report|Surescripts MedSummary|I|20^"_TXT,.USR)
 Q
TEST(REQIEN,RESIEN) ;-
 K FDA,ERR
 I REQIEN,RESIEN D
 .S FDA(9009033.85,REQIEN_",",1)=RESIEN
 .S FDA(9009033.85,REQIEN_",",.04)="C"
 .D FILE^DIE(,"FDA","ERR")
 .D FIREINFO(REQIEN)
 Q
 ; Generate string from WP entry
WPTOSTR(GBLROOT) ;
 N STR,LP
 S STR=""
 S LP=0 F  S LP=$O(@GBLROOT@(LP)) Q:'LP  S STR=STR_@GBLROOT@(LP,0)
 Q STR
 ;
L270(IEN) ;-
 N GBL,STR,IDX,LP,ND,DLM,RES,S
 S RES=""
 S GBL=$NA(^APSPMHEB(+IEN,1))
 S STR=$$WPTOSTR(GBL)
 S DLM=$$G270DLM(STR)
 S IDX=0
 F LP=1:1:$L(STR,"~") D  Q:IDX
 .S ND=$P(STR,"~",LP)
 .I $P(ND,DLM,4)="22" D
 ..S IDX=LP
 I IDX D
 .F LP=IDX+1:1:$L(STR,"~") D
 ..S S=$P(STR,"~",LP)
 ..I $P(S,DLM)="NM1" S $P(RES,U)=S
 ..I $P(S,DLM)="N3" S $P(RES,U,2)=S
 ..I $P(S,DLM)="N4" S $P(RES,U,3)=S
 ..I $P(S,DLM)="DMG" S $P(RES,U,4)=S
 Q RES
G270DLM(DAT) ;-
 N DLM,LP,FLG,ND
 S DLM="*",FLG=0
 F LP=1:1:$L(STR,"~") D  Q:FLG
 .S ND=$P(STR,"~",LP)
 .I $E(ND,1,3)="ISA" S QFLG=1,DLM=$E(ND,4) Q
 Q DLM
 ;Returns boolean indicating value in CHANGE FLAG field
HASCHFLG(DATA,REQIEN) ;-
 N EBIEN,RES
 S RES=0
 S RES="Y"=$$GET1^DIQ(9009033.85,REQIEN,"2:.05","I")
 S DATA=RES
 Q
 ; Returns subscriber information from 270 request
 ; Input: EBIEN = IEN to 9009033.87
G270SCBR(DATA,EBIEN) ;-
 S EBIEN=$$GET1^DIQ(9009033.85,EBIEN,2,"I")
 S DATA=$$L270(EBIEN)
 Q
 ; Returns 271 response content
G271RSP(DATA,REQIEN) ;-
 N GBL,EBIEN
 S EBIEN=+$$GET1^DIQ(9009033.85,REQIEN,2,"I")
 S GBL=$NA(^APSPMHEB(EBIEN,2))
 S DATA=$$WPTOSTR(GBL)
 Q
 ;NCPDP Test Portal Request Export
REQEXP ;
 N IEN,APSPPOP,%ZIS,IOP,POP,LP
 S APSPPOP=0
 W !,"NCPDP Med History Request Output Tool"
 S IEN=$$GETIEN1^APSPUTIL(9009033.85,"Select Request: ",,"B^C^D^E","I $D(^(3))")
 Q:$G(APSPPOP)
 D ^%ZIS
 I POP D  Q
 .W !,"Failed to open device."
 S LP=0
 F  S LP=$O(^APSPMHRQ(IEN,3,LP)) Q:'LP  U IO W ^(LP,0),!
 D CLOSE^%ZISH
 Q
 ;NCPDP Test Portal Result Import
RESIMP ;
 N REQIEN,APSPPOP,LP,FDA,IENS,FN,ERR,NIEN
 S APSPPOP=0
 W !,"NCPDP Med History Result Import Tool"
 W !,"Add results to the following request"
 S REQIEN=$$GETIEN1^APSPUTIL(9009033.85,"Select Request: ",,"B^C^D^E","I $D(^(3))")
 Q:$G(APSPPOP)!'REQIEN
 S FN=9009033.86
 S FDA(FN,"+1,",.01)=$$NOW^XLFDT()
 S FDA(FN,"+1,",.02)=$$GET1^DIQ(9009033.85,REQIEN,.02,"I")
 S FDA(FN,"+1,",.03)=$$GET1^DIQ(9009033.85,REQIEN,.03,"I")
 D UPDATE^DIE(,"FDA","IENS","ERR")
 K FDA,ERR
 S NIEN=IENS(1)
 K IENS
 I NIEN D
 .S FDA(9009033.85,REQIEN_",",1)=NIEN
 .S FDA(9009033.85,REQIEN_",",.04)="C"
 .D FILE^DIE(,"FDA","ERR")
 .S DIE=9009033.86,DA=NIEN,DR="1" D ^DIE
 Q
