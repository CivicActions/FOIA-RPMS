APSPES9 ;IHS/MSC/PLS - Master File SPI Request;21-Nov-2019 13:04;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1008,1009,1010,1013,1014,1016,1023,1024**;Sep 23, 2004;Build 68
 ; Modified - IHS/MSC/PLS - 03/24/2011 - EN+20 (removed checks for DEA)
 ;                          09/14/2011 - Added support for service level
 ;                          01/29/2013 - Uncomment lines related to service level
 ;                          12/13/2018 - Updates for NCPDP 6.0
 Q
ADDPRV(PVD,MFNTYP,LST) ;
 Q:'$G(PVD)
 N HLPM,HLST,ERR,ARY,AP,WHO,ERR,APSPQ,HL1
 S HLPM("MESSAGE TYPE")="MFN"
 S HLPM("EVENT")="M02"
 S HLPM("VERSION")=2.5
 I '$$NEWMSG^HLOAPI(.HLPM,.HLST,.ERR) W !,ERR,0
 S HLFS=HLPM("FIELD SEPARATOR")
 S HLECH=HLPM("ENCODING CHARACTERS")
 S HL1("ECH")=HLECH
 S HL1("FS")=HLFS
 S HL1("Q")=""
 S HL1("VER")=HLPM("VERSION")
 I MFNTYP="" S MFNTYP=$$FNDTYP(PVD)
 D MFI
 D MFE(.LST)
 ;D STF
 ;D ORG
 ;D PRA
 S AP("SENDING APPLICATION")="APSP RPMS"
 S AP("ACCEPT ACK TYPE")="AL"  ; Commit ACK
 S AP("APP ACK TYPE")="AL"
 S AP("QUEUE")="RPMS SPI"
 S AP("FAILURE RESPONSE")="FAILURE^APSPES9"
 S WHO("RECEIVING APPLICATION")="SURESCRIPTS"
 S WHO("FACILITY LINK NAME")="APSP EPRES"
 I '$$SENDONE^HLOAPI1(.HLST,.AP,.WHO,.ERR) W !,ERR
 Q
 ;
MFI ;EP
 N MFI,SLC,ENT,PAR,APSPLST,NUM,IEN,TYP,VALUE,NODE,CNT,ANS
 ;S SLC=NEWRX_"~"_REFRX_"~"_RXFILL_"~"_CS ;Service Level code
 D SET(.ARY,"MFI",0)
 D SET(.ARY,"STF",1)  ; Master File Identifier
 ;D SET(.ARY,SLC,1,4)
 ;D SET(.ARY,SLC,1,4)
 D SET(.ARY,"UPD",3)  ; Update record
 D SET(.ARY,$$HLDATE^HLFNC($$NOW^XLFDT()),4)  ; Entered Date/Time
 D SET(.ARY,"MF",6)   ; Response level code
 S MFI=$$ADDSEG^HLOAPI(.HLST,.ARY)
 Q
MFE(APSPLST) ;EP
 N MFE,PKV
 S PKV=PVD_":"_DUZ(2)_":1"
 D SET(.ARY,"MFE",0)
 D SET(.ARY,MFNTYP,1)  ; Record-level event code
 D SET(.ARY,PKV,2)    ; MFN Control ID - DUZ.DUZ(2).1
 D SET(.ARY,PKV,4)    ; Primary Key Value
 S MFE=$$ADDSEG^HLOAPI(.HLST,.ARY)
 I MFE D
 .D STF(PKV,.APSPLST)
 .D PRA(PKV)
 .D ORG
 Q
STF(PKV,APSPLST) ;EP
 N STF,NM,LP,VAL,PHONE,FAX,CNT,NODE,IEN,TYP,VALUE
 S NM=$$HLNAME^HLFNC($$GET1^DIQ(200,+PKV,.01))
 D SET(.ARY,"STF",0)
 D SET(.ARY,PKV,1)  ; Primary Key value
 D SET(.ARY,"NEW PERSON",1,3)  ; Coding System - File Name
 D SET(.ARY,+PKV,2) ; Staff ID (DUZ)
 F LP=1:1:$L(NM,$E(HLECH)) S VAL=$P(NM,$E(HLECH),LP) D
 .D SET(.ARY,VAL,3,LP)
 D SET(.ARY,"A",7)  ; Active/Inactive Flag
 ;D GETLST^XPAR(.APSPLST,"USR.`"_+PKV,"APSP NCPDP USER SERVICE LEVEL")
 S CNT=0,SLC=0
 ;S NUM="" F  S NUM=$O(APSPLST(NUM)) Q:NUM=""  D
 ;.S NODE=$G(APSPLST(NUM))
 ;.S IEN=$P(NODE,U,1),ANS=$P(NODE,U,2)
 ;.S TYP=$$GET1^DIQ(9009033.75,IEN,.01)
 ;.S VALUE=$P(NODE,U,2)
 ;.I VALUE=1 D
 ;..S CNT=CNT+1
 ;..D SET(.ARY,TYP,9,1,,CNT)
 S TYP="" F  S TYP=$O(APSPLST(TYP)) Q:TYP=""  D
 .S CNT=CNT+1
 .D SET(.ARY,TYP,9,1,,CNT)
 S PHONE=$$GET1^DIQ(200,+PKV,.132)
 S:'$L(PHONE) PHONE=$$GET1^DIQ(9999999.06,DUZ(2),.13)  ; Default to Location phone
 D SET(.ARY,$$HLPHONE^HLFNC(PHONE),10,1)  ; Work Phone
 D SET(.ARY,"WPH",10,2)
 D SET(.ARY,"PH",10,3)
 S FAX=$$GET1^DIQ(200,+PKV,.136)
 D SET(.ARY,$$HLPHONE^HLFNC(FAX),10,1,,2)  ; Fax
 D SET(.ARY,"WPN",10,2,,2)
 D SET(.ARY,"FX",10,3,,2)
 D SET(.ARY,$$GET1^DIQ(200,+PKV,.151),10,4)  ; email address
 D SET(.ARY,$$GET1^DIQ(4,DUZ(2),1.01),11,1)  ; Institution Address 1
 D SET(.ARY,$$GET1^DIQ(4,DUZ(2),1.02),11,2)  ; Institution Address 2
 D SET(.ARY,$$GET1^DIQ(4,DUZ(2),1.03),11,3)  ; Institution City
 D SET(.ARY,$$GET1^DIQ(5,$$GET1^DIQ(4,DUZ(2),.02,"I"),1),11,4)  ; Institution State Abbreviation
 D SET(.ARY,$E($$GET1^DIQ(4,DUZ(2),1.04,"I"),1,5),11,5)  ; Institution 5 digit Zip Code
 D SET(.ARY,"O",11,7)  ; Address Type
 D SET(.ARY,"O",16)  ; Preferred method of contact
 D SET(.ARY,$$GET1^DIQ(200,+PKV,8),18)  ; Job Title
 D SET(.ARY,$$GET1^DIQ(200,+PKV,53.5,"I"),19,1)  ; Job Code/Class
 D SET(.ARY,$$GET1^DIQ(200,+PKV,53.5),19,2)
 S STF=$$ADDSEG^HLOAPI(.HLST,.ARY)
 Q
ORG ;EP
 Q
PRA(PKV) ;EP
 N PRA,NM,LP,VAL,DEA,NPI,SPI,NADEAN,NAME
 S SPI=""
 S DEA=$$PRVDEA(PKV)
 ;S DEA=$$GET1^DIQ(200,+PKV,53.2)  ; New Person DEA#
 S NPI=$$GET1^DIQ(200,+PKV,41.99) ; New Person NPI
 S SPI=$$SPI^APSPES1(+PKV)        ;New Person SPI
 S NAME=$$GET1^DIQ(4,DUZ(2),.01)
 I '$L(DEA) D
 .S DEA=$$GET1^DIQ(4,DUZ(2),52)  ; Institution DEA
 .S DEA=DEA_"-"_NPI   ;$$GET1^DIQ(9999999.06,DUZ(2),.12)  ;CHANGED TO USE NPI INSTEAD OF ASUFAC CODE
 S NADEAN=$$GET1^DIQ(200,+PKV,53.11)  ;DEA X number
 D SET(.ARY,"PRA",0)
 D SET(.ARY,PKV,1)  ; Primary Key value
 D SET(.ARY,DEA,6,1,1,1)
 D SET(.ARY,"DEA",6,2,,1)
 D SET(.ARY,NPI,6,1,,2)
 D SET(.ARY,"NPI",6,2,,2)
 D SET(.ARY,"NADEAN",6,2,,3)
 D SET(.ARY,NADEAN,6,1,,3)
 I +SPI D
 .D SET(.ARY,"SPI",6,2,,4)
 .D SET(.ARY,SPI,6,1,,4)
 D SET(.ARY,NAME,9)    ;Add institution name
 S PRA=$$ADDSEG^HLOAPI(.HLST,.ARY)
 Q
SET(ARY,V,F,C,S,R) ;EP
 D SET^HLOAPI(.ARY,.V,.F,.C,.S,.R)
 Q
 ; Failed Transmission Callback
FAILURE ; EP
 N ARY,SEGIEN
 D PARSE^APSPES2(.DATA,HLMSGIEN,.HLMSTATE)
 S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"MFN")
 Q:'SEGIEN
 D NOTIF($$GET1^DIQ(200,+PKV,.01)_": Unable to transmit SPI request.")
 Q
 ; Process MFK acknowledgement
MFK ; EP -
 N ARY,SEGIEN,SEGDAT,PVD,PKV,SPI,SLC,TYPE,SL
 D PARSE^APSPES2(.DATA,HLMSGIEN,.HLMSTATE)
 S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"MFI")
 Q:'SEGIEN
 M SEGDAT=DATA(SEGIEN)
 S SPI=$$GET^HLOPRS(.SEGDAT,1)
 S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"MFA")
 Q:'SEGIEN
 M SEGDAT=DATA(SEGIEN)
 S TYPE=$$GET^HLOPRS(.SEGDAT,1)
 S PKV=+$$GET^HLOPRS(.SEGDAT,2)
 I $$GET^HLOPRS(.SEGDAT,4)'="S" D
 .S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"ERR")
 .I SEGIEN D
 ..M SEGDAT=DATA(SEGIEN)
 ..S ERR=$$GET^HLOPRS(.SEGDAT,8)
 ..D:$L(ERR) NOTIF($$GET1^DIQ(200,+PKV,.01)_": "_$P(ERR,":"))
 E  D
 .S ENT="USR.`"_+PKV,PAR="APSP NCPDP USER SERVICE LEVEL"
 .D NDEL^XPAR(ENT,"APSP NCPDP USER SERVICE LEVEL",.ERR)  ;Remove all current entries
 .I TYPE="MAD"!(TYPE="MUP") D
 ..S CNT=1
 ..F  S SL=$$GET^HLOPRS(.SEGDAT,5,"","",CNT) Q:SL=""  D
 ...S CNT=CNT+1
 ...D ADD^XPAR(ENT,"APSP NCPDP USER SERVICE LEVEL",SL,"Y",.ERR)
 ...;S SLC=$$GET^HLOPRS(.SEGDAT,1,4)  ;Service Level code
 .I TYPE="MAD" D NOTIF($$GET1^DIQ(200,+PKV,.01)_": Please assign SPI "_SPI_" to user. Service levels were added")
 .I TYPE="MDC" D NOTIF($$GET1^DIQ(200,+PKV,.01)_": User's SPI was deactivated")
 Q
 ; Notify SPI mail group
NOTIF(MSG) ; EP -
 N RET
 S XQAMSG=MSG
 S XQA("G.SPI NOTIFICATION")=""
 D SETUP^XQALERT
 Q
 ; Main entry point for selection of user
EN ; EP -
 N USR,APSPPOP,CHK,RXFILL,CS,APSPLST,UTYP,ARR,APSPPRV,TYP,VTYP,ENT,INST,ERR,X,ARR,DEACT
 W @IOF
 W !,"Surescripts Provider ID Request Utility",!
 S USR=$$GETIEN1^APSPUTIL(200,"Select Provider: ",-1,,"I $S('$D(^VA(200,Y,0)):0,Y<1:1,$L($P(^(0),U,3)):1,1:0),$P($G(^VA(200,Y,""PS"")),U)")
 Q:USR<1
 S APSPQ=0,ERR=""
 W !!,"Processing request for: "_$$GET1^DIQ(200,+USR,.01)
 ; Check for active user
 I '$$ACTIVE^XUSER(+USR) D  Q
 .W !,"User is not an active RPMS user.",!
 .D DIRZ
 ; Ensure that selected user has an NPI
 N DA,DIE,DR,DTOUT
 I '$$GET1^DIQ(200,+USR,41.99) D  I X=""!($D(DTOUT)) D DIRZ Q
 .W !,"The selected user must have an NPI assigned.",!
 .S DA=+USR,DIE=200
 .S DR="41.99" D ^DIE
 ; If needed, indicate that Institutional DEA will be used.
 ;I '$L($$GET1^DIQ(200,+USR,53.2)) D
 ;.W !,"This provider lacks an individual DEA number."
 ;.W !,"The facility DEA number will be used to request the SPI number."
 ;.D DIRZ
 ;I '$L($$GET1^DIQ(4,DUZ(2),52)) D  Q
 ;.W !,"The selected facility, "_$$GET1^DIQ(4,DUZ(2),.01)_" lacks a Facility DEA number."
 ;.W !,"This will need to be corrected before you can continue with the request."
 ;.D DIRZ
 N DTOUT
 I '$L($$GET1^DIQ(200,+USR,.136)) D  I X=""!($D(DTOUT)) D DIRZ Q
 .W !,"The user lacks a fax number. This will need to be corrected before you can"
 .W !,"continue with the request."
 .S DA=+USR,DIE=200
 .S DR=".136" D ^DIE
 N DTOUT
 I '$L($$GET1^DIQ(200,+USR,.151)) D  I X=""!($D(DTOUT)) D DIRZ Q
 .W !,"The user lacks an email address. This will need to be corrected before you can"
 .W !,"continue with the request."
 .S DA=+USR,DIE=200
 .S DR=".151" D ^DIE
 I '$L($$GET1^DIQ(9999999.06,DUZ(2),.13)) D  Q
 .W !,"The selected facility, "_$$GET1^DIQ(4,DUZ(2),.01)_" lacks a phone number."
 .W !,"This will need to be corrected before you can continue with the request."
 .D DIRZ
 ; Check for existing SPI
 S CHK=0
 I $$SPI^APSPES1(+USR) D
 .W !,"User has already been assigned an SPI number.",!
 .S CHK=$$DIR^APSPUTIL("S^1:Update;2:Deactivate","Action Choice",1,,.APSPQ)
 .Q:APSPQ
 E  S CHK=3
 D GETLST^XPAR(.APSPLST,"ALL","APSP NCPDP SITE SERVICE LEVEL")
 ;S ENT="USR.`"_+USR,PAR="APSP NCPDP USER SERVICE LEVEL"
 ;D NDEL^XPAR(ENT,"APSP NCPDP USER SERVICE LEVEL",.ERR)  ;Remove all current entries
 I CHK=2 D
 .S APSPQ=""
 .S DEACT=$$DIRYN^APSPUTIL("Are you sure you want to deactivate this provider","No","Enter a 'Y' OR 'YES' to proceed",APSPQ)
 .I +DEACT D ADDPRV(USR,"MDC") W !!,"A deactivate message has been sent." Q
 S STOP=0
 I CHK=1!(CHK=3) D  I +STOP G QUIT
 .W !,"Updates overwrite existing entries so please answer all questions"
 .S NUM="" F  S NUM=$O(APSPLST(NUM)) Q:NUM=""!(+STOP)  D
 ..S NODE=$G(APSPLST(NUM))
 ..S IEN=$P(NODE,U,1),ANS=$P(NODE,U,2)
 ..Q:'ANS
 ..S TYP=$$GET1^DIQ(9009033.75,IEN,.01)
 ..Q:TYP="RxFillIndicatorChange"
 ..S VTYP=$S(TYP="Refill":"Renew",TYP="RxFill":"Fill/Dispense",TYP="ControlledSubstance":"Controlled Substance",1:TYP)
 ..S ACTIVE=$$ACTLVL(USR,IEN)
 ..S ACTIVE=$S(ACTIVE=1:"YES",1:"NO")
 ..S VALUE=$$DIR^APSPUTIL("Y","Will provider be doing "_VTYP_" messages electronically",ACTIVE,,.APSPQ)
 ..I VALUE=1 S ARR(TYP)=""
 ..I VALUE="^" S STOP=1 Q
 ..;I TYP="RxFill" S ARR("RxFillIndicatorChange")=""
 ;..K ERR
 ;..D ADD^XPAR(ENT,"APSP NCPDP USER SERVICE LEVEL",TYP,VALUE,.ERR)
 I CHK=3 D
 .W !
 .S CONT=$$DIRYN^APSPUTIL("Are you sure you have selected the correct service levels for this provider","Yes","Enter a 'Y' OR 'YES' to proceed",APSPQ)
 .I +CONT D
 ..I $$DIRYN^APSPUTIL("Request SPI","YES",,.APSPPOP) D
 ...D ADDPRV(USR,"MAD",.ARR)
 ...W !!,"An SPI number has been requested. A Kernel Alert will be sent to"
 ...W !,"the SPI NOTIFICATION group when the SPI number is received."
 I CHK=1 D
 .W !
 .S CONT=$$DIRYN^APSPUTIL("Are you sure you want to update this provider","Yes","Enter a 'Y' OR 'YES' to proceed",APSPQ)
 .I +CONT D
 ..D ADDPRV(USR,"MUP",.ARR)
 ..W !!,"An update message has been sent."
 Q
 ;
DIRZ ;EP - Prompt to continue
 D DIRZ^APSPUTIL("Press ENTER to continue")
 Q
 ;
FNDTYP(IEN) ;EP - Determine if a new or update message should be sent
 ;If MFNTYP exists, no need to do the lookup
 Q:$D(MFNTYP) MFNTYP
 N TD,ENTER,ACTIVE,RES
 S TD=$$DT^XLFDT()
 S ENTER=$P($G(^VA(200,IEN,1)),U,7)  ; Date Entered
 I TD>ENTER S RES="MUP1"
 I ENTER=TD D
 .I $P($G(^VA(200,IEN,1.1)),U,1)'="" S RES="MUP1"
 .I $P($G(^VA(200,IEN,1.1)),U,1)="" S RES="MAD"
 I $P($G(^VA(200,IEN,0)),U,11)!($P($G(^VA(200,IEN,"PS")),U,4)) S RES="MDC"
 Q RES
 ;
ADDPTL(PVD) ;EP - Entry point for APSP ERX MFN UPDATE protocol
 ;Additional business rules to be added here
 D ADDPRV(PVD)
 Q
PRVDEA(PKV) ;EP-
 N DEA,NPI
 S DEA=$$GET1^DIQ(200,+PKV,53.2)  ; New Person DEA#
 S NPI=$$GET1^DIQ(200,+PKV,41.99) ; New Person NPI
 I '$L(DEA) D
 .S DEA=$$GET1^DIQ(4,DUZ(2),52)  ; Institution DEA
 .S DEA=DEA_"-"_NPI
 Q DEA
DETOX(RXIEN,PRV,DRUG) ;EP
 ;Send the Detox number to Surescripts if needed
 N DETOX,DETOXDRG,CICODE,DATA,DESC,SUB,IN,ORDER,FLG
 S DETOX=""
 S ORDER=$$GET1^DIQ(52,RXIEN,39.3)
 I +$$DETOXDR^APSPFNC6(DRUG) D
 .S CICODE=$$VALUE^ORCSAVE2(ORDER,"SNMDCNPTID")
 .I CICODE D
 ..S DATA=$$CONC^BSTSAPI(CICODE)
 ..S DESC=$P(DATA,U,3)
 ..S SUB="PXRM EPCS DRUG DETOX"
 ..I DESC'="" D
 ...S IN=DESC_U_SUB_U_U_1
 ...S FLG=$$VSBTRMF^BSTSAPI(IN)
 ...I FLG=1 D
 ....S DETOX="NADEAN: "_$$GET1^DIQ(200,PRV,53.11)
 Q DETOX
VIEWSPI ;EP Return a user's list of service levels
 W !,"Surescripts Provider's SPI Service Levels",!
 N USR,NUM,NODE,IEN,TYP,APSPQ,SPI,CONT,EMAIL
 S APSPQ=""
 S USR=$$GETIEN1^APSPUTIL(200,"Select Provider: ",-1,,"I $S('$D(^VA(200,Y,0)):0,Y<1:1,$L($P(^(0),U,3)):1,1:0),$P($G(^VA(200,Y,""PS"")),U)")
 Q:+USR<1
 S FAX=$$GET1^DIQ(200,USR,.136)
 S EMAIL=$$GET1^DIQ(200,USR,.151)
 S NPI=$$GET1^DIQ(200,USR,41.99)
 W !,"NPI: "_NPI
 W !,"FAX: "_FAX,?40,"EMAIL: "_EMAIL
 S SPI=$$SPI^APSPES1(+USR)
 I SPI="" W !,"Provider does not have an SPI number",! G QUIT
 I +SPI W !,"SPI: "_SPI,!
 W !,"Service Level TYPE",?30,"VALUE"
 D GETLST^XPAR(.APSPPRV,"USR.`"_+USR,"APSP NCPDP USER SERVICE LEVEL")
 S NUM=0 F  S NUM=$O(APSPPRV(NUM)) Q:NUM=""  D
 .S NODE=$G(APSPPRV(NUM))
 .S IEN=$P(NODE,U,1),TYP=$$GET1^DIQ(9009033.75,IEN,.01)
 .S V=$P(NODE,U,2)
 .S VALUE=$S(V=0:"Inactive",1:"Active")
 .I TYP="ControlledSubstance" S TYP="Controlled Substances"
 .W !,TYP,?30,VALUE
 W !
QUIT S CONT=$$DIR^APSPUTIL("Y","Would you like to check another provider","Yes",,.APSPQ)
 I CONT=1 G VIEWSPI
 Q
SERLEV(RESULT,ENT,PAR,LEVEL) ;Check for the correct service level being on
 N APSPPAR,NUM,NODE,TYP,VALUE
 S RESULT=0,APSPPAR=""
 D GETLST^XPAR(.APSPPAR,ENT,PAR)
 S NUM=0 F  S NUM=$O(APSPPAR(NUM)) Q:'+NUM!(RESULT=1)  D
 .S NODE=$G(APSPPAR(NUM))
 .S IEN=$P(NODE,U,1),TYP=$$GET1^DIQ(9009033.75,IEN,.01)
 .S VALUE=$P(NODE,U,2)
 .I VALUE=1&(TYP=LEVEL) S RESULT=1
 Q
ACTLVL(PRV,LEVEL) ;Check to see if a service level is active
 N NUM,NODE,IEN,V,RET
 S RET=0
 D GETLST^XPAR(.APSPPRV,"USR.`"_+PRV,"APSP NCPDP USER SERVICE LEVEL")
 S NUM=0 F  S NUM=$O(APSPPRV(NUM)) Q:NUM=""!(RET=1)  D
 .S NODE=$G(APSPPRV(NUM))
 .S IEN=$P(NODE,U,1)
 .S V=$P(NODE,U,2)
 .I V=1&(IEN=LEVEL) S RET=1
 Q RET
