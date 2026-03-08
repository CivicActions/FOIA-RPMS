BADEUTIL ;IHS/MSC/PLS - Dentrix HL7 inbound interface  ;12-Feb-2010 09:35;PLS
 ;;1.0;DENTAL/EDR INTERFACE;**5,9,10**;FEB 22, 2010;Build 61
 ; Returns patient corresponding to 12 digit facility/hrn code
 ;; Modified - IHS/OIT/GAB 03/2016 **5** Check & Add POV's (ICD10 code) coming from Dentrix
 ;; Modified - IHS/OIT/GAB 08/2020 **7** Added function to find the clinic stop code for dental
 ;; Modified - IHS/GDIT/GAB 09/2024 **9** Added function to find the ADA code IEN for an active code
 ;; Modified - IHS/GDIT/GAB 07/2025 **10** Added function to check for active insurance policy & update phone numbers
HRCNF(HRCN12) ; EP
 N DFN,ASUFAC,HRN,Y
 S DFN=-1
 S ASUFAC=+$E(HRCN12,1,6),HRN=+$E(HRCN12,7,12)
 Q:'ASUFAC!'HRN DFN
 S ASUFAC=$$FIND1^DIC(9999999.06,,,ASUFAC,"C")
 Q:'ASUFAC DFN
 S Y=0 F  S Y=$O(^AUPNPAT("D",HRN,Y)) Q:'Y  Q:$D(^(Y,ASUFAC))
 S:Y DFN=Y
 Q DFN
 ;
 ; Enable/Disable a protocol
 ; Input: P-Protocol
 ;        T-Text - Null or not passed removes text.
EDPROT(P,T,ERR) ;EP
 N IENARY,PIEN,AIEN,FDA
 S T=$G(T,"")
 D
 .I '$L(P) S ERR="Missing input parameter" Q
 .S IENARY(1)=$$FIND1^DIC(101,"","",P)
 .I 'IENARY(1) S ERR="Unknown protocol name" Q
 .S FDA(101,IENARY(1)_",",2)=$S($L(T):T,1:"@")
 .D UPDATE^DIE("S","FDA","IENARY","ERR")
 Q
 ; Returns default user based on Location
DUSER(LOC) ;EP
 N RET
 S RET=$$GET^XPAR("DIV.`"_LOC_"^SYS","BADE EDR DEFAULT USER")
 Q RET
 ; Returns MERGED TO DFN, when present, traversing the chain
MRGTODFN(DFN) ;EP
 N RES
 S RES=DFN
 Q:'$D(^DPT(DFN,-9)) RES  ;DFN has not been merged
 F  S DFN=$P($G(^DPT(DFN,-9)),U) Q:'DFN  S RES=DFN Q:'$D(^DPT(DFN,-9))
 Q RES
GETPOV    ;IHS/OIT/GAB 03/2016 **5** ADDED THIS SEGMENT - GET THE POV FROM THE FT1 SEGMENT & ADD TO THE VISIT
 S CNT=1,NOPOV="",FIRST=""
 K CODE
 F CNT=1:1:4 D
 .Q:$G(SEGFT1(20,CNT,1,1))=""
 .S CODE(CNT)=(SEGFT1(20,CNT,1,1))
 .S POV=CODE(CNT)
 .I CNT=1 S FIRST=CODE(CNT)
 .Q:FIRST="V72.2"
 .D VALIDPOV^BADEUTIL(POV)
 .I YES=1 D
 ..I '$$HASPOV(APCDVSIT,POV) S APCDALVR("APCDATMP")="[APCDALVR 9000010.07 (ADD)]" D EN^APCDALVR
 ;I (FIRST="V72.2")&&('$$HASPOV(APCDVSIT,"ZZZ.999")) S APCDALVR("APCDTPOV")="ZZZ.999" S APCDALVR("APCDTEXK")=APCDTEXK S APCDALVR("APCDATMP")="[APCDALVR 9000010.07 (ADD)]" D EN^APCDALVR
 ;/IHS/GDIT/GAB **10** Comment above and added below to replace "&&" per XINDEX Checker
 I (FIRST="V72.2")&('$$HASPOV(APCDVSIT,"ZZZ.999")) S APCDALVR("APCDTPOV")="ZZZ.999" S APCDALVR("APCDTEXK")=APCDTEXK S APCDALVR("APCDATMP")="[APCDALVR 9000010.07 (ADD)]" D EN^APCDALVR
 I FIRST="" S NOPOV=1
 Q
VALIDPOV(POV)    ; IHS/OIT/GAB **5** ADD A CHECK FOR A VALID POV COMING FROM DENTRIX
 N STR,IEN
 S YES=""
 S STR=$$ICDDATA^ICDXCODE(30,POV,VISDT,"E")
 S IEN=$P(STR,"^") S:IEN<0 IEN=""
 I IEN="" S YES="" Q  ;SET DEFAULT CODE IF IEN DOES NOT EXIST, Not a valid code
 S YES=1
 S APCDALVR("APCDTPOV")=POV
 S APCDALVR("APCDTEXK")=APCDTEXK        ; add the EXKEY for the POV entry to associate with the procedure
 Q
HASPOV(V,Y)     ;EP  IHS/OIT/GAB **5** ADD A CHECK FOR DUPLICATE POV's
 ;V is visit ien
 ;Y is value of icd code, e.g. Z98.810
 I '$G(V) Q ""  ;not a valid visit ien
 I '$D(^AUPNVSIT(V,0)) Q ""  ;not a valid visit ien
 NEW X,G,I
 S (X,G)=0
 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X!(G)  D
 .S I=$$VAL^XBDIQ1(9000010.07,X,.01)  ;external value of .01 of V POV
 .I I=Y S G=X  ;if it equals Y quit on ien of the V POV, yes, we already have that V POV
 .Q
 Q G
SCODE   ;EP IHS/OIT/GAB **7** GET THE IEN OF THE CLINIC STOP CODE FOR DENTAL
 ;ZIEN is the return information = the IEN of the Dental stop code
 S ZIEN=""
 S DIC="^DIC(40.7,",X="DENTAL",DIC(0)=""
 D ^DIC
 I Y'="" S ZIEN=$P(Y,"^",1)
 Q
GETADIEN(ADCODE)  ;EP  /IHS/GDIT/GAB **9** FIND THE ADA CODE IEN & CHECK FOR AN ACTIVE CODE
 ;INPUT    ADCODE:  THE ADA CODE NUMBER (Example:  0190, D1351)
 ;OUTPUT   ADAIEN:  RETURN THE IEN FROM THE ADA CODE FILE, "I" IF INACTIVE or "-1" if not found
 ;Checks for active code in the ADA Code file, if not present, drops "D" (if present) and ck for 4-digit
 ; EXCEPT for D0190,D9130 and D9990, since the IHS Tracking codes: 0190,9130,9990 are different
 ;This accounts for sites that have the "D" codes and before the code file is updated
 K ADAIEN,DIC,X,Y,EXCODE
 S DIC="^AUTTADA("
 S DIC(0)="MO"   ;use the "B" x-ref and find exact match
 S X=ADCODE
 D ^DIC
 I Y>0  D
 .S ADAIEN=$P(Y,U,1)
 .I $P($G(^AUTTADA(ADAIEN,0)),"^",8) S ADAIEN="I" ;Found the IEN, return "I" if inactive
 I (Y<0)&($E(ADCODE,1,1)="D")  D
 .I (ADCODE="D0190")!(ADCODE="D9130")!(ADCODE="D9990") Q   ;Don't drop the "D" for 3 specific codes
 .S EXCODE=$E(ADCODE,2,$L(ADCODE))   ; Drop the "D"
 .D GETADIEN(EXCODE)                 ; Get the IEN of the 4-digit code if active
 I Y<0 S ADAIEN=-1
 Q ADAIEN
 ;
PHONE(DFN) ;/IHS/GDIT/GAB **10** - Add Cell Phone number to PID Segment,Field 13
 ;Example PID.14 Work & Cell Phone:  |(555)555-5555^WP^PH~(777)777-7777^MC^PH|
 N ALL,REP,FLD,LP,ALN,CNT,VAL,PART
 S (WORK,CELL)=""
 S HL("FS")="|"
 S HL("ECH")="^~\&"
 S CELL=$P($G(^DPT(DFN,.13)),"^",4)  ; Cell Phone number
 I $L(CELL)<10 S CELL=""                       ; must be 10 digits
 E  S CELL=$$HLPHONE^HLFNC($P(CELL,"^",1))     ; Change to HL7 format
 ;Home Phone Number (Sets PID Field 13)
 I $L($P(PID,HLFS,14)) D
 .D SET(.ARY,$P(PID,HLFS,14),13)
 .D SET(.ARY,"HP",13,2)
 .D SET(.ARY,"PH",13,3)
 ;REP:number of repeating phone#'s to add; LP: lines (1,2,3); VAL/PART: phone number
 ;Example:  ARY(14,1,1,1)=(555)555-5555  ARY(14,1,2,1)="WP"  ARY(14,1,3,1)="PH"
 I $L($P(PID,HLFS,15)) S WORK=$P(PID,HLFS,15)
 I $L(WORK)&$L(CELL)  D
 .S ALL=WORK_"~"_CELL
 .F REP=1:1:$L(ALL,$E(HLECH,2,2)) S PART=$P(ALL,$E(HLECH,2,2),REP) D
 ..F LP=1:1:$L(PART,$E(HLECH,2,2)) S VAL=$P(PART,$E(HLECH,2,2),LP) D
 ...D SET(.ARY,VAL,14,LP,,REP)
 ...I REP=1 D SET(.ARY,"WP",14,LP+1,,REP)   ;Work Phone
 ...I REP=2 D SET(.ARY,"MC",14,LP+1,,REP)   ;Cell/Mobile Phone
 ...D SET(.ARY,"PH",14,LP+2,,REP)
 E  I $L(WORK)!$L(CELL)  D
 .I $L(WORK)  D
 ..D SET(.ARY,WORK,14)
 ..D SET(.ARY,"WP",14,2)
 .I $L(CELL)  D
 ..D SET(.ARY,CELL,14)
 ..D SET(.ARY,"MC",14,2)
 .D SET(.ARY,"PH",14,3)
 Q
SET(ARY,V,F,C,S,R) ;EP
 D SET^HLOAPI(.ARY,.V,.F,.C,.S,.R)
 Q
CRTNULL ; Creates empty IN1/IN2
 D SET^BADEHL1(.ARY,"IN1",0)
 D SET^BADEHL1(.ARY,1,1)
 S IN1=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 I $D(ERR) D NOTIF^BADEHL1(DFN,"Can't create IN1. "_ERR) Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 D SET^BADEHL1(.ARY,"IN2",0)
 D SET^BADEHL1(.ARY,1,1)
 S IN2=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 I $D(ERR) D NOTIF^BADEHL1(DFN,"Can't create IN2. "_ERR) Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 Q
PTADDR(DFN) ;EP  ;/IHS/GDIT/GAB **10** moved to this routine (commented in BADEHLI, routine too large
 N HLQ,FLD,PID
 S HLQ=HL1("Q")
 S PID=$$EN^VAFHLPID(DFN,"11")
 S FLD=$P(PID,HLFS,12)
 Q FLD
PAUSE ;EP  ;/IHS/GDIT/GAB **10** add pause function
 Q:$E(IOST)'="C"!(IO'=IO(0))
 W ! S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
PHDR ;EP - Print parent menu header.
 S X=$P($G(^DIC(19,+^XUTL("XQ",$J,^XUTL("XQ",$J,"T")-1),0)),U,2)
 Q:'$L(X)
 S Y=+^XUTL("XQ",$J,^XUTL("XQ",$J,"T")-1)
 I Y=0 W !!,"PARENT MENU CANNOT BE FOUND IN XUTL!" Q
 S Y=$P($G(^DIC(19,Y,0)),U)
 Q
