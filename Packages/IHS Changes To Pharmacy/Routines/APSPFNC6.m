APSPFNC6 ;IHS/MSC/PLS - Prescription Creation Support ;01-Dec-2021 13:02;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1011,1012,1016,1017,1018,1021,1023,1024,1027,1029**;Sep 23, 2004;Build 50
 ;=================================================================
 ;Returns string containing the possible pickup locations
 ;IHS/MSC/MGH Patch 1023 Added DETOXDR,DUPCII,NEEDSUP entry point
 ;                       Updated ERXUSER for EPCS
 ;            Patch 1024 Updated for NCPDP 6.0
GPKUP(DATA,USR,OI,ORDER) ; EP -
 N AUTORX,RET,C,CRX,RSCH,OKERX,AUTOOR
 S ORDER=$G(ORDER),AUTOOR=-1
 ;IHS/MSC/MGH 1016 If the order number is sent in and the order is e-prescribed, then renewals must be electronic.
 S:ORDER'="" AUTOOR=$$CHKERX(ORDER)
 S C=$$GET^XPAR("ALL","APSP AUTO RX CII PRESCRIBING")
 S CRX=$$GET^XPAR("ALL","APSP AUTO RX ERX OF CS II")
 S AUTORX=+$$GET^XPAR("ALL","APSP AUTO RX")
 S RSCH=$$GET^XPAR("ALL","APSP AUTO RX SCHEDULE RESTRICT")
 I AUTORX=0 D  ;Internal Pharmacy
 .S RET="CMW"
 E  I AUTORX=1 D  ;Internal and External Pharmacy
 .S OKERX=$$OKTOUSE(OI,RSCH)
 .I '$$ERXUSER(USR,OI) D  ;User not able to select E
 ..S RET=$S(OKERX=2:"P",AUTOOR>0:"CP",1:"CMWP")
 .E  D
 ..;IHS/MSC/MGH Patch 1016 Changes to incorporate ERX field
 ..I '+OKERX D
 ...S RET=$S(AUTOOR>0:"CP",'AUTOOR:"CMW",1:"CMWP")
 ..E  D
 ...S RET=$S(OKERX=2:"P",AUTOOR>0:"CP",'AUTOOR:"CMW",1:"CMWP")
 ...I AUTOOR'=0 S RET=RET_$S(OKERX>0:"E",$L(RSCH)&($$ERXOI(OI,RSCH)):"",$$ERXOI(OI,"2"):$S(CRX:"E",1:""),1:"E")
 E  I AUTORX=2 D  ;External Pharmacy
 .S OKERX=$$OKTOUSE(OI,RSCH)
 .I '$$ERXUSER(USR,OI) D  ;User not able to select E
 ..S RET=$S(OKERX=2:"P",1:"CP")
 .E  D
 ..;IHS/MSC/MGH Patch 1016 Changes to incorporate ERX field
 ..I '+OKERX D
 ...S RET=$S(OKERX=2:"P",1:"CP")
 ..E  D
 ...S RET=$S(OKERX=2:"P",1:"CP")
 ...S RET=RET_$S(OKERX>0:"E",$L(RSCH)&($$ERXOI(OI,RSCH)):"",$$ERXOI(OI,"2"):$S(CRX:"E",1:""),1:"E")
 S DATA=RET
 Q
 ; Returns ability of user to e-prescribe
 ; Input: USR - IEN to New Person File
 ;        OI - orderable item
 ; Output:   0 = e-Prescribing is not available to user
 ;           1 = e-Prescribing is available to user
ERXUSER(USR,OI) ; EP
 N RET,PSOI,DIEN,DATA,RETURN,DS,SERV,ENT,PAR,LEVEL
 D ERXUSER^APSPFNC2(.RET,USR)
 ;IHS/GDIT/MSC/MGH changes to check that provider is EPCS provider if CS drug
 I RET D             ;User can do eRx
 .I $G(OI) D
 ..S DATA=0
 ..S PSOI=+$P($G(^ORD(101.43,+OI,0)),U,2)  ; Pharmacy Orderable Item
 ..S DIEN=0 F  S DIEN=$O(^PSDRUG("ASP",PSOI,DIEN)) Q:'DIEN!(DATA=1)  D
 ...S DS=+$P(^PSDRUG(DIEN,0),U,3)
 ...I (DS>0)&(DS<6) S DATA=1
 ..I +DATA D
 ...D PKISITE^ORWOR(.RETURN)
 ...I RETURN=0 S RET=0    ;if site is off no eRx for this drug
 ...E  D                  ;if site is on check provider
 ....S RETURN=0
 ....D PKIUSE^ORWOR(.RETURN,USR)
 ....I RET=2 S SERV=1
 ....I +RET'=2 D
 .....S ENT="USR.`"_+USR,PAR="APSP NCPDP USER SERVICE LEVEL"
 .....S LEVEL="ControlledSubstance",SERV=0
 .....D SERLEV^APSPES9(.SERV,ENT,PAR,LEVEL)
 ....I +RETURN=0!(+SERV=0) S RET=0
 ....E  D
 .....S RETURN=0
 .....D VRFYPHSH^BEHOEP5(.RETURN,USR)
 .....I RETURN=1 S RET=0
 Q RET
 ; Returns match of orderable item to drug schedule
 ; Input: OIIEN - Orderable Item IEN
 ;          SCH - SCHEDULE
 ;          TPL - Invert return value
ERXOI(OIIEN,SCH,TPL) ; EP
 N RET
 S TPL=+$G(TPL,0)
 D ERXOI^APSPFNC2(.RET,OIIEN,SCH)
 Q $S(TPL:RET,1:'RET)
 ; Retransmit eRX order
 ; Input: ORD - IEN to Order File (100)
 ; Output: 1 = resent
RESEND(DATA,ORD,RXNUM,MSGID) ;EP -
 N PHARM,RX,ERROR,X1,DUPDENY
 S ORD=$G(ORD),RXNUM=$G(RXNUM),MSGID=$G(MSGID)
 S DUPDENY=1
 I ORD D
 .S PHARM=+$$VALUE^ORCSAVE2(+ORD,"PHARMACY")
 .S RX=+$G(^OR(100,ORD,4))
 .I $P($G(^PSRX(RX,0)),U)=RXNUM D
 ..D EN^APSPELRX(RX,PHARM)
 ..D ERX^APSPCSA(RX,"RT")
 E  I $L(MSGID) D
 .S RXIEN=$$RXIEN^APSPES2(MSGID)
 .I RXIEN D
 ..S X1=$$RESEND^HLOAPI3(MSGID,.ERROR)
 ..N LOG,RET
 ..S LOG("REASON")="X"
 ..S LOG("RX REF")=0
 ..S LOG("TYPE")="X"
 ..S LOG("COM")="eRx denial response sent to "_$$PHMINFO^APSPES2A(RXIEN)
 ..D UPTLOG^APSPFNC2(.RET,RXIEN,0,.LOG)
 .E  D
 ..S X1=$$RESEND^HLOAPI3(MSGID,.ERROR)
 S DATA=1
 K DUPDENY
 Q
 ; Returns boolean value representing presence of reason and type in activity log.
 ;  Allows optional check of a comment string
 ;  STR Format: String<~><n><A> - <n> defaults to 1. Example: DDrg~1A Comment starts with STR and ignores case
CKRXACT(RX,REASON,TYPE,RXREF,STR) ;-
 N RES,LP,PR,PT,NOD0
 S (LP,RES)=0
 Q:'$G(RX) RES
 Q:'$L($G(REASON)) RES
 S TYPE=$G(TYPE)
 S RXREF=$G(RXREF)
 S STR=$G(STR)  ;P1024
 F  S LP=$O(^PSRX(RX,"A",LP)) Q:'LP  D  Q:RES
 .S NOD0=^PSRX(RX,"A",LP,0)
 .S PR=$P(NOD0,U,2)
 .Q:PR'=REASON
 .S PT=$P($G(^PSRX(RX,"A",LP,9999999)),U,2)
 .Q:PT=""
 .S:TYPE[PT RES=1
 .I RES,$L(RXREF) D
 ..S RES=RXREF=$P(NOD0,U,4)
 .I RES,$L(STR) D
 ..;RULE: 1 - Starts with (Default) ; 2 - Contains; 3 - Equals
 ..;       Append an 'A' to the number if case is to be ignored
 ..N C1,RULE,COM,CASE,C2
 ..S C1=$P(STR,"~"),RULE=$P(STR,"~",2)
 ..S CASE=RULE'["A"
 ..S RULE=$S(RULE="":1,1:+RULE)
 ..S COM=$P(NOD0,U,5) S:'CASE COM=$$UP^XLFSTR(COM)
 ..S:'CASE C1=$$UP^XLFSTR(C1)
 ..I RULE=1 D
 ...S RES=$E(COM,1,$L(C1))=C1
 ..E  I RULE=2 D
 ...S RES=COM[C1
 ..E  I RULE=3 D
 ...S RES=COM=C1
 Q RES
 ;Returns if this drug is OK to send as a eRX
OKTOUSE(OI,RSCH) ;function call
 N RES,IEN,STOP,POI,NODE
 S RES=1
 I $L(RSCH)&($$ERXOI(OI,RSCH)) Q 0
 S POI=$P($P($G(^ORD(101.43,OI,0)),U,2),";",1)
 I POI="" Q RES
 S IEN="" F  S IEN=$O(^PSDRUG("ASP",POI,IEN)) Q:IEN=""!(RES=0)  D
 .S NODE=$G(^PSDRUG(IEN,0))
 .Q:NODE=""
 .I $P($G(^PSDRUG(IEN,999999935)),U,3)=1 S RES=0
 .I $P($G(^PSDRUG(IEN,999999935)),U,1)=1 S RES=0
 .I $$ERXONLY(IEN) S RES=2
 Q RES
CHKERX(ORDER) ;Find out if ORDER was an eRX one
 N VALUE,RX
 S VALUE=0,ORDER=$P(ORDER,";")
 S RX="" S RX=$O(^PSRX("APL",ORDER,RX))
 Q:RX="" VALUE
 S VALUE=+$$GET1^DIQ(52,RX,9999999.23,"I")
 Q VALUE
 ; Return ERX only of drug
 ; Input: Order File IEN
 ; Output: Boolean
ERXONLY(DRUG) ;EP- Patch 1021
 N VAL
 S VAL=$P($G(^PSDRUG(DRUG,999999935)),U,3)
 Q VAL=2
 ; Return long name of drug
 ; Input: Order File IEN
GETLONG(RET,ORDER) ;EP-
 N DRUG
 S RET=""
 S DRUG=$$VALUE^ORCSAVE2(ORDER,"DRUG")
 Q:'+DRUG
 S RET=$$GETLNGDG(DRUG)
 Q
 ; Return long name of drug
 ; Input: Drug File IEN
GETLNGDG(DRUG) ;EP-
 Q $$GET1^DIQ(50,DRUG,9999999.352)
 ;
 ; Find a site
LOC(ORIEN) ;
 N PSOLOC,PSOINS,PSOSITE
 S PSOLOC=$P($G(^OR(100,ORIEN,0)),U,10)
 S PSOSITE=$$GET^XPAR("LOC.`"_PSOLOC_U_"DIV.`"_DUZ(2)_"^SYS","APSP AUTO RX DIV")
 I 'PSOSITE D
 .S PSOSITE=0
 .I PSOLOC["SC" D
 ..S PSOLOC=+PSOLOC
 ..S PSOINS=$P($G(^SC(PSOLOC,0)),U,4)
 ..Q:'PSOINS
 ..S PSOSITE=$$DIV(PSOINS)
 .S:'PSOSITE PSOSITE=$$DIV(DUZ(2))
 .S:'PSOSITE PSOSITE=$$DIV(+$$SITE^VASITE)
 Q $S($G(PSOSITE):PSOSITE,1:0)
 ; This screen is used by the APSP AUTO RX DIV parameter.
 ; Input: DIV - Pointer to Institution (4) file
DIVSCN(ENT) ;
 I $G(ENT)["DIC(4," Q ''$$DIV(+ENT)
 I $G(ENT)["DIC(4.2," Q 1
 I $G(ENT)["SC(" Q 1
 Q 0
 ; Return Pharmacy Division
DIV(INS) Q $O(^PS(59,"D",+INS,0))
 ;
 ; Returns the last activity type for requested reason
LASTACT(RX,REASON) ;EP-
 N RES,LP,PR,PT,FLG
 S FLG=0,RES=""
 S LP=$C(1)
 Q:'$G(RX) RES
 Q:'$L($G(REASON)) RES
 F  S LP=$O(^PSRX(RX,"A",LP),-1) Q:'LP  D  Q:FLG
 .S PR=$P(^PSRX(RX,"A",LP,0),U,2)
 .Q:PR'=REASON
 .S FLG=1
 .S RES=$P($G(^PSRX(RX,"A",LP,9999999)),U,2)
 Q RES
HARDCPY(RXIEN,OR0) ;Store activity log data for hardcopy
 N PADD,ORIEN
 I RXIEN D
 .N LOG,RET,PADD
 .S LOG("REASON")="K"
 .S LOG("RX REF")=0
 .S ARY("TYPE")="U"
 .S LOG("COM")="Hard copy prescription was reviewed"
 .D UPTLOG^APSPFNC2(.RET,RXIEN,0,.LOG)
 .S ORIEN=$P(OR0,U,1)
 .S PADD=$$SUBSCRIB^ORDEA(ORIEN,RXIEN)   ;Add to ORDER DEA ARCHIVE FILE
 Q
 ; Returns result of DEA Special Handling Comparison
 ; Input : OIIEN = Orderable IEN
 ;           CLS = Drug class
DEAOICLS(DATA,OIIEN,CLS) ;EP-
 N PSOI,DIEN
 S CLS=$G(CLS,"2345")
 S DATA=0
 I $G(OIIEN) D
 .S PSOI=+$P($G(^ORD(101.43,+OIIEN,0)),U,2)  ; Pharmacy Orderable Item IEN
 .S DIEN=0 F  S DIEN=$O(^PSDRUG("ASP",PSOI,DIEN)) Q:'DIEN  D  Q:DATA
 ..S DATA=$$ISSCH^APSPFNC2(DIEN,CLS)
 Q
DETOXDR(DIEN) ;Return if this is a detox drug
 N INSUB,NDC,RXNORM,SUBSET,INPUT
 S INSUB=0
 S NDC=$$VANDC^PSSDEE(DIEN)
 S RXNORM=$$RXNORM^APSPFNC1(NDC,1)
 I '+RXNORM D
 .S RXNORM=$$GET1^DIQ(50,DIEN,9999999.27)
 I +RXNORM D
 .S SUBSET="RXNO EPCS DRUG DETOX"
 .S INPUT=+RXNORM_U_SUBSET_U_1552
 .S INSUB=$$CIDINSB^BEHORXSP(INPUT)
 Q INSUB
DETOXORD(DIEN,ORDER) ;Return if this order was done for detox purposes
 N CICODE,DATA,SUB,DESC,IN,FLG
 S FLG=0
 I +$$DETOXDR^APSPFNC6(DIEN) D
 .S CICODE=$$VALUE^ORCSAVE2(ORDER,"SNMDCNPTID")
 .I CICODE D
 ..S DATA=$$CONC^BSTSAPI(CICODE)
 ..S DESC=$P(DATA,U,3)
 ..S SUB="PXRM EPCS DRUG DETOX"
 ..I DESC'="" D
 ...S IN=DESC_U_SUB_U_U_1
 ...S FLG=$$VSBTRMF^BSTSAPI(IN)
 Q FLG
DUPCII(ORD) ;Check for duplicate C2 pending orders
 N CHK,DRG,ISSUE,DEA,EARLY,PLACER,NEWDT
 S CHK=0
 S PLACER=$P($G(^PS(52.41,ORD,0)),U,1)
 S ISSUE=$P($G(^PS(52.41,ORD,0)),U,6)
 S NEWDT=$$VALUE^ORCSAVE2(PLACER,"EARLIEST")
 I +NEWDT S ISSUE=NEWDT
 ;This is the second drug
 S DRG=$P(PSOSD(STA,DNM),"^",11)
 S DEA=+$P($G(^PSDRUG(DRG,0)),U,3)
 I DEA=2 D
 .S EARLY=$P(PSOSD(STA,DNM),"^",13)
 .I EARLY>ISSUE S CHK=1
 Q CHK
NEEDSUP(PROV,DRUG) ;Does this provider need a supervisor on their med order
 N XUP,LST,FOUND,CLS,ERR,SUP,USRCLS,CLASS,CLIEN
 S SUP=0,FOUND=0
 ;I '$$ISSCH^APSPFNC2(DRUG,"2345") Q SUP  ;IHS/MSC/PLS - 12/1/2021 - p1029
 D GETLST^XPAR(.LST,"ALL","BEHORX REQUIRE SUPERVISOR CS")
 S CLS=0 F  S CLS=$O(LST(CLS)) Q:CLS=""!(FOUND=1)  D
 .S CLIEN=$P($G(LST(CLS)),U,2)
 .S CLASS=$$GET1^DIQ(8930,CLIEN,.01)
 .S USRCLS=$$ISA^USRLM(PROV,CLASS,.ERR)
 .I USRCLS=1 S SUP=1,FOUND=1
 Q SUP
ERXON(DATA,USR) ;See if user can do eRX moved from APSPES2 because of size overrun
 N SITE,ENT
 S DATA=1,SITE=0
 I $G(USR) D
 .S DATA=''$L($$SPI^APSPES1(USR))
 .I DATA D
 ..S ENT="USR.`"_+USR
 ..D SERLEV^APSPES9(.SITE,ENT,"APSP NCPDP USER SERVICE LEVEL","New")
 ..I '+SITE S DATA=0
 .I 'DATA D
 ..S DATA=+$$GET^XPAR($$ENT^CIAVMRPC("APSP AUTO RX ELECTRONIC",.ENT,USR),"APSP AUTO RX ELECTRONIC")
 ..S:DATA DATA=2
 Q
PPSL(RXIEN,LEVEL) ;Check both provider and pharmacy for service level
 N USR,ENT,PAR,RESULT,PHAR,SIEN,APSPSVL,PHAR,APSPBIT,RESULT,STAT
 N EXDTE,CANDTE,DATA,SL
 S RESULT=1
 S SIEN=0 S SIEN=$O(^APSPNCP(9009033.75,"B",LEVEL,SIEN))
 Q:'+SIEN RESULT
 S USR=$P($G(^PSRX(RXIEN,0)),U,4)   ;Check the provider
 S PHAR=$P($G(^PSRX(RXIEN,999999921)),U,4)  ;Check the pharmacy
 Q:'+PHAR RESULT
 S ENT="USR.`"_+USR,PAR="APSP NCPDP USER SERVICE LEVEL"
 D SERLEV^APSPES9(.DATA,ENT,PAR,LEVEL)
 I +DATA D
 .Q:+$P($G(^APSPOPHM(PHAR,0)),U,11)   ;QUIT IF TEMPORARY PHARMACY
 .S SIEN=0 S SIEN=$O(^APSPNCP(9009033.75,"B",LEVEL,SIEN))  Q:'+SIEN  D
 ..S APSPSVL=$P($G(^APSPNCP(9009033.75,SIEN,0)),U,2)
 ..S APSPBIT=$P($G(^APSPOPHM(PHAR,0)),U,5)
 ..I $$AND^XUMF5AU(+APSPSVL,+APSPBIT)=+APSPSVL S RESULT=0
 Q RESULT
 ; Notify user of autofinish failure
 ; Input:  USR - User IEN
 ;         DFN - Patient IEN
 ;         ORIEN - Order IEN
 ;         MSG - Message text
 ;       ALRTD - Alert data
NOTIF(USR,DFN,ORIEN,MSG,ALRTD) ;EP -
 N XQA,XQAID,XQADATA,XQAMSG
 S XQA(USR)=""
 S XQAMSG="Autofinish Failure:"_$G(MSG)
 S XQAID="OR"_","_DFN_","_99003
 S:$G(ORIEN) XQADATA=ORIEN_"@"_$G(ALRTD)
 D SETUP^XQALERT
 Q
