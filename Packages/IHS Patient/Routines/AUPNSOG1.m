AUPNSOG1 ; IHS/OIT/FBD&NKD - SOGI General Retrieval APIs ; 03/04/2020 ;
 ;;99.1;IHS DICTIONARIES (PATIENT);**28,29**;MAR 9, 1999;Build 1
 ;IHS/OIT/FBD&NKD AUPN*99.1*29 - PPN PARAMETER
 ;
 Q  ;NO TOP-LEVEL CALL ALLOWED
 ;
 ;GET(PAT,VAL,FMT,EDT,ARY)  ; - Retrieve bundled patient demographic data relevant to SOGI  ;IHS/OIT/FBD&NKD AUPN*99.1*29 - PPN PARAMETER
GET(PAT,VAL,FMT,EDT,ARY,PAR)  ;PEP - Retrieve bundled patient demographic data relevant to SOGI
 ;
 ; Type: Extrinsic Function
 ; Format: $$GET^AUPNSOGI(PAT,VAL,FMT,EDT,.ARY,PAR)
 ; Function: Retrieve bundled patient demographic data relevant to SOGI
 ;   This general retrieval API returns a list of patient demographic data, including SOGI data, in a 12-piece "^" delimited string.
 ;   This includes the formatted name, formatted gender, date of birth, health record number, formatted pronouns, patient name,
 ;     preferred name, patient sex, gender identity, legal sex, sexual orientation, and patient pronouns.
 ;   The extrinsic return value of this API is not affected by parameters, and data for these fields are returned in a static
 ;     format intended for display. This includes a mix of internal/brief/code values and is detailed below.
 ;   NOTE: As of AUPN*99.1*29, the PAR parameter can affect the extrinsic return value of this API.
 ;   An optional return array can be provided and configured to receive additional values for these fields. This local array
 ;     must be passed by reference, and will always include the extrinsic return value of the API in ARY("C").
 ;   NOTE: This array is cleaned out (KILLed) at the beginning of each call.
 ;   The following nodes in the return array are configured with the VAL parameter (which accepts multiple values).
 ;     I.E. $$GET^AUPNSOGI(PAT,"EI",FMT,EDT,.ARY,PAR) populates ARY("E") and ARY("I") along with the default ARY("C").
 ;   External values are returned in ARY("E") with a format intended for detailed display. This node is set to a 12-piece "^" delimited
 ;     string in the same order as the extrinsic return value of the API. This includes a mix of external/expanded values and is detailed below.
 ;   Internal values are returned in ARY("I") with a format intended for complex display/processing. This node is set to a 12-piece ";"
 ;     delimited string in the same order as the extrinsic return value of the API. This includes a mix of internal/brief values and is detailed below.
 ;   NOTE: Internal values of SOGI data are often "^" delimited and include the sub-file record IEN, warranting the ";" delimiter.
 ;   Gender and Pronouns data can be accompanied with a "*" indicator in certain cases. This indicator can be suppressed by using the FMT parameter,
 ;     and only applies to the "E" and "I" nodes in the return array. The extrinsic return value and ARY("C") is not affected by this
 ;     parameter.
 ;   The EDT parameter if provided, is used to retrieve the patient's SOGI data for past dates.
 ;   The Preferred Name value can be suppressed based on the AUPN DISPLAY PPN system parameter with the PAR parameter. See GETPREF for details
 ;     regarding the use of this parameter.
 ;   Note: Access to this API requires use of the AUPN DISPLAY PPN parameter functionality, by setting the PAR
 ;     parameter to 1. Infrastructure applications are exempt from this requirement.
 ; Input Parameters:
 ;   PAT: Patient IEN
 ;   VAL: Optional parameter, creates an additional node in the return array for each character
 ;        E:         External values, separated by the "^" delimiter
 ;        I:         Internal values, separated by the ";" delimiter
 ;   FMT: Optional parameter used with VAL parameter, formats the values in the return array
 ;        P:         No star indicator applied to Gender or Pronouns
 ;   EDT: ""/default: Defaults to latest date entry
 ;        Date (int): Entry effective on that date
 ;  .ARY: Return array passed by reference
 ;   PAR: 0/default: Disable AUPN DISPLAY PPN parameter functionality
 ;        1:         Enable AUPN DISPLAY PPN parameter functionality
 ; Returned Values:
 ;   Successful (Dependent upon parameters):
 ;
 ;     Returns an 12 piece string delimited by "^", ARY("C") is set to this value:
 ;     PIECE  DESCRIPTION         VALUE
 ;         1  Name                Patient Full Name with Preferred: LAST,FIRST MIDDLE SUFFIX - PREFERRED*
 ;                                Enables AUPN DISPLAY PPN parameter functionality if PAR=1
 ;         2  Gender              Gender Identity, sex-based Gender Identity matching: GENDER or GENDER*
 ;         3  Date of Birth       External format: MM/DD/YYYY
 ;         4  Health Record #     Internal format: ######
 ;         5  Pronouns            Patient Pronouns, if none Gender Pronouns, Brief Display format: PRONOUNS_brief or GENDER_PRONOUNS_brief*
 ;         6  Patient Name        Patient Full Name: LAST,FIRST MIDDLE SUFFIX
 ;         7  Preferred Name      Internal value: PREFERRED_NAME
 ;                                Enables AUPN DISPLAY PPN parameter functionality if PAR=1
 ;         8  Patient Sex         Internal format: M/F/U
 ;         9  Gender Identity     Code value, Print format: ENTRY_code,ENTRY_code
 ;        10  Legal Sex           Code value, Print format: LEGAL_SEX_int
 ;        11  Sexual Orientation  Code value, Print format: ENTRY_code,ENTRY_code
 ;        12  Patient Pronouns    Brief Display value: ENTRY_brief (3 pieces if OTHER)
 ;
 ;     ARY("E") is set to the following 12 piece string delimited by "^", when VAL parameter contains "E":
 ;     PIECE  DESCRIPTION         VALUE
 ;         1  Name                Patient Full Name with Preferred: LAST,FIRST MIDDLE SUFFIX - PREFERRED*
 ;                                Enables AUPN DISPLAY PPN parameter functionality if PAR=1
 ;         2  Gender              Gender Identity, sex-based Gender Identity matching: GENDER or GENDER*
 ;                                No star indicator if FMT contains "P": GENDER
 ;         3  Date of Birth       External format: MM/DD/YYYY
 ;         4  Health Record No.   External format: ABR ######
 ;         5  Pronouns            Patient Pronouns, if none Gender Pronouns, Expanded Display format: PRONOUNS_expanded or GENDER_PRONOUNS_expanded*
 ;                                No star indicator if FMT contains "P": PRONOUNS_expanded or GENDER_PRONOUNS_expanded
 ;         6  Patient Name        Patient Full Name: LAST,FIRST MIDDLE SUFFIX
 ;         7  Preferred Name      Internal value: PREFERRED_NAME
 ;                                Enables AUPN DISPLAY PPN parameter functionality if PAR=1
 ;         8  Patient Sex         External format: MALE/FEMALE/UNKNOWN
 ;         9  Gender Identity     External value, Print format: ENTRY_ext,ENTRY_ext
 ;        10  Legal Sex           External value, Print format: LEGAL_SEX_ext,SOURCE_ext,DATE_ENTERED_ext
 ;        11  Sexual Orientation  External value, Print format: ENTRY_ext,ENTRY_ext
 ;        12  Patient Pronouns    Expanded Display value: ENTRY_expanded (5 pieces if OTHER)
 ;
 ;     ARY("I") is set to the following 12 piece string delimited by ";", when VAL parameter contains "I":
 ;     PIECE  DESCRIPTION         VALUE
 ;         1  Name                Patient Full Name with Preferred: LAST,FIRST MIDDLE SUFFIX - PREFERRED*
 ;                                Enables AUPN DISPLAY PPN parameter functionality if PAR=1
 ;         2  Gender              Gender Identity, sex-based Gender Identity matching: GENDER or GENDER*
 ;                                No star indicator if FMT contains "P": GENDER
 ;         3  Date of Birth       Internal format: FileMan Internal Date format
 ;         4  Health Record No.   Internal format: ######
 ;         5  Pronouns            Patient Pronouns, if none Gender Pronouns, Brief Display format: PRONOUNS_brief or GENDER_PRONOUNS_brief*
 ;                                No star indicator if FMT contains "P": PRONOUNS_brief or GENDER_PRONOUNS_brief
 ;         6  Patient Name        Patient Full Name: LAST,FIRST MIDDLE SUFFIX
 ;         7  Preferred Name      Internal value: PREFERRED_NAME
 ;                                Enables AUPN DISPLAY PPN parameter functionality if PAR=1
 ;         8  Patient Sex         Internal format: M/F/U
 ;         9  Gender Identity     Internal value: SUB_IEN^ENTRY_int^ENTRY_int^OTHER
 ;        10  Legal Sex           Internal value: SUB_IEN^LEGAL_SEX_int^SOURCE_int^DATE_ENTERED_int
 ;        11  Sexual Orientation  Internal value: SUB_IEN^ENTRY_int^ENTRY_int^OTHER
 ;        12  Patient Pronouns    Internal value: ENTRY_int^OTHER
 ;   Unsuccessful: "" Empty string
 ;
 ;S PAT=$G(PAT),VAL=$G(VAL),FMT=$G(FMT),EDT=$S(+$G(EDT):EDT,1:""),ARY=$G(ARY) K ARY Q:'PAT ""  ;IHS/OIT/FBD&NKD AUPN*99.1*29 - PPN PARAMETER
 S PAT=$G(PAT),VAL=$G(VAL),FMT=$G(FMT),EDT=$S(+$G(EDT):EDT,1:""),ARY=$G(ARY),PAR=$G(PAR,0) K ARY Q:'PAT ""
 ;
 S ARY("C")=""
 ;S $P(ARY("C"),U,1)=$$GETPREF^AUPNSOGI(PAT,"E")           ;  1.NAME ($$GETPREF^AUPNSOGI) - VAL=E  ;IHS/OIT/FBD&NKD AUPN*99.1*29 - PPN PARAMETER
 S $P(ARY("C"),U,1)=$$GETPREF^AUPNSOGI(PAT,"E",PAR)       ;  1.NAME ($$GETPREF^AUPNSOGI) - VAL=E PAR=0|1
 S $P(ARY("C"),U,2)=$$GENDER(PAT,,,EDT)                   ;  2.GENDER ($$GENDER^AUPNSOGI) - DEFAULT
 S $P(ARY("C"),U,3)=$$DOB^AUPNPAT(PAT,"S")                ;  3.DOB (#2: #.03 field) - EXTERNAL
 S $P(ARY("C"),U,4)=$$HRN^AUPNPAT(PAT,$G(DUZ(2)))         ;  4.HRN (#9000001: #4101 multiple) - INTERNAL
 S $P(ARY("C"),U,5)=$$PRONOUN(PAT,,,EDT)                  ;  5.PRONOUNS ($$PRONOUN^AUPNSOGI) - DEFAULT
 S $P(ARY("C"),U,6)=$P($G(^DPT(PAT,0)),U)                 ;  6.PATIENT NAME (#2: #.01 field)
 ;S $P(ARY("C"),U,7)=$$GETPREF^AUPNSOGI(PAT)               ;  7.PREFERRED NAME (#9000001: #9001 field) - DEFAULT  ;IHS/OIT/FBD&NKD AUPN*99.1*29 - PPN PARAMETER
 S $P(ARY("C"),U,7)=$$GETPREF^AUPNSOGI(PAT,,PAR)          ;  7.PREFERRED NAME (#9000001: #9001 field) - DEFAULT PAR=0|1
 S $P(ARY("C"),U,8)=$$GENDER(PAT,0)                       ;  8.PATIENT SEX (#2: #.02 field) - VAL=0
 S $P(ARY("C"),U,9)=$$GETGI^AUPNSOGI(PAT,"C","P",EDT)     ;  9.GENDER IDENTITY (#9000001: #9401 multiple) - VAL=C FMT=P
 S $P(ARY("C"),U,10)=$$GETLSEX^AUPNSOGI(PAT,"C","P",EDT)  ; 10.LEGAL SEX (#9000001: #9201 multiple) - VAL=C FMT=P
 S $P(ARY("C"),U,11)=$$GETSO^AUPNSOGI(PAT,"C","P",EDT)    ; 11.SEXUAL ORIENTATION (#9000001: #9301 multiple) - VAL=C FMT=P
 S $P(ARY("C"),U,12)=$$GETPRN^AUPNSOGI(PAT)               ; 12.PATIENT PRONOUNS (#9000001: #9002/#9003 fields) - DEFAULT
 ;
 I VAL["E" D
 . S ARY("E")=""
 . S $P(ARY("E"),U,1)=$P(ARY("C"),U,1)                                       ;  1.NAME - NO CHANGE
 . S $P(ARY("E"),U,2)=$S(FMT["P":$$GENDER(PAT,,"P",EDT),1:$P(ARY("C"),U,2))  ;  2.GENDER - NO CHANGE, UNLESS FMT
 . S $P(ARY("E"),U,3)=$P(ARY("C"),U,3)                                       ;  3.DOB - NO CHANGE
 . S $P(ARY("E"),U,4)=$$HRN^AUPNPAT(PAT,$G(DUZ(2)),2)                        ;  4.HRN - INCLUDE FACILITY ABBR
 . S $P(ARY("E"),U,5)=$$PRONOUN(PAT,,1_$E("P",FMT["P"),EDT)                  ;  5.PRONOUNS - FMT=1|1P
 . S $P(ARY("E"),U,6)=$P(ARY("C"),U,6)                                       ;  6.PATIENT NAME - NO CHANGE
 . S $P(ARY("E"),U,7)=$P(ARY("C"),U,7)                                       ;  7.PREFERRED NAME - NO CHANGE
 . S $P(ARY("E"),U,8)=$$EXTERNAL^DILFD(2,.02,,$P(ARY("C"),U,8))              ;  8.PATIENT SEX - EXTERNAL
 . S $P(ARY("E"),U,9)=$$GETGI^AUPNSOGI(PAT,"E","P",EDT)                      ;  9.GENDER IDENTITY - VAL=E FMT=P
 . S $P(ARY("E"),U,10)=$$GETLSEX^AUPNSOGI(PAT,"E","P",EDT)                   ; 10.LEGAL SEX - VAL=E FMT=P
 . S $P(ARY("E"),U,11)=$$GETSO^AUPNSOGI(PAT,"E","P",EDT)                     ; 11.SEXUAL ORIENTATION - VAL=E FMT=P
 . S $P(ARY("E"),U,12)=$$GETPRN^AUPNSOGI(PAT,"D")                            ; 12.PATIENT PRONOUNS - VAL=D
 ;
 I VAL["I" D
 . S ARY("I")=""
 . S $P(ARY("I"),";",1)=$P(ARY("C"),U,1)                                        ;  1.NAME - NO CHANGE
 . S $P(ARY("I"),";",2)=$S(FMT["P":$$GENDER(PAT,,"P",EDT),1:$P(ARY("C"),U,2))   ;  2.GENDER - NO CHANGE, UNLESS FMT
 . S $P(ARY("I"),";",3)=$$DOB^AUPNPAT(PAT)                                      ;  3.DOB - INTERNAL
 . S $P(ARY("I"),";",4)=$P(ARY("C"),U,4)                                        ;  4.HRN - NO CHANGE
 . S $P(ARY("I"),";",5)=$S(FMT["P":$$PRONOUN(PAT,,"P",EDT),1:$P(ARY("C"),U,5))  ;  5.PRONOUNS - NO CHANGE, UNLESS FMT
 . S $P(ARY("I"),";",6)=$P(ARY("C"),U,6)                                        ;  6.PATIENT NAME - NO CHANGE
 . S $P(ARY("I"),";",7)=$P(ARY("C"),U,7)                                        ;  7.PREFERRED NAME - NO CHANGE
 . S $P(ARY("I"),";",8)=$P(ARY("C"),U,8)                                        ;  8.PATIENT SEX - NO CHANGE
 . S $P(ARY("I"),";",9)=$$GETGI^AUPNSOGI(PAT,"I",,EDT)                          ;  9.GENDER IDENTITY - VAL=I
 . S $P(ARY("I"),";",10)=$$GETLSEX^AUPNSOGI(PAT,"I",,EDT)                       ; 10.LEGAL SEX - VAL=I
 . S $P(ARY("I"),";",11)=$$GETSO^AUPNSOGI(PAT,"I",,EDT)                         ; 11.SEXUAL ORIENTATION - VAL=I
 . S $P(ARY("I"),";",12)=$$GETPRN^AUPNSOGI(PAT,"I")                             ; 12.PATIENT PRONOUNS - VAL=I
 ;
 Q ARY("C")
 ;
GENDER(PAT,VAL,FMT,EDT) ;PEP - Retrieve formatted Gender for a patient
 ;
 ; Type: Extrinsic Function
 ; Format: $$GENDER^AUPNSOGI(PAT,VAL,FMT,EDT)
 ; Function: Retrieve formatted gender for a patient.
 ;   This general retrieval API returns a single Gender marker for a patient (M/F/U/N).
 ;   This value can be limited to the patient Sex only, or include the patient's Gender Identity.
 ;   The internal value of the patient Sex field is returned in the following cases:
 ;     Parameter VAL=0
 ;     No patient Gender Identity data
 ;     Gender Identity = Unknown or Declined to Answer
 ;   When the patient's Gender Identity is used in the calculation, the Gender Marker field of their Gender Identity is retrieved.
 ;   If a patient has multiple Gender Identity entries:
 ;     Gender Marker fields match => Use that value
 ;       Ex. Male (M), Transgender Male (M) => Use 'M'
 ;     Gender Marker fields do not match => Use 'N'
 ;       Ex. Male (M), Female (F) => Use 'N'
 ;   If the resulting Gender Marker does not match the internal value of the patient Sex field, the return value is marked with a '*' 
 ;     to indicate the discrepancy.
 ;   By default, the VAL parameter further restricts the matching to sex-based Gender Identities only.
 ;     Ex. Patient Sex (M), Gender Identity (Identifies as Male) => M
 ;     Ex. Patient Sex (M), Gender Identity (Transgender Male) => M*
 ;     Ex. Patient Sex (F), Gender Identity (Identifies as Female) => F
 ;     Ex. Patient Sex (F), Gender Identity (Transgender Female) => F*
 ;   The indicator can be suppressed independently by using the FMT parameter.
 ;   The EDT parameter if provided, is used to retrieve the patient's Gender Identity for past dates.
 ; Input Parameters:
 ;   PAT: Patient IEN
 ;   VAL: 0:         Patient Sex Only, no Gender Identity
 ;        1/default: Gender Identity, sex-based Gender Identity matching
 ;        2:         Gender Identity, all Gender Identity matching
 ;   FMT: 0/default: Star indicator when Gender Identity does not match Patient Sex
 ;        P:         No star indicator
 ;   EDT: ""/default: Defaults to latest date entry
 ;        Date (int): Entry effective on that date
 ; Returned Values:
 ;   Successful (Dependent upon parameters):
 ;     VAL|FMT   MATCHES     | NO MATCH
 ;     0  |0   : PATIENT_SEX | PATIENT_SEX
 ;     1  |0   : GENDER      | GENDER*
 ;     2  |0   : GENDER      | GENDER*
 ;     0  |P   : PATIENT_SEX | PATIENT_SEX
 ;     1  |P   : GENDER      | GENDER
 ;     2  |P   : GENDER      | GENDER
 ;   Unsuccessful: "" Empty string
 ;
 S PAT=$G(PAT),VAL=$S($L($G(VAL)):VAL,1:1),FMT=$S($L($G(FMT)):FMT,1:0),EDT=$S(+$G(EDT):EDT,1:"") Q:'PAT ""
 N R1,R2,T1,T2,F1,F2,C1,Q1
 S Q1=0 F C1=1:1:$L(VAL) Q:Q1  S:"012"[$E(VAL,C1) VAL=$E(VAL,C1),Q1=1 S:C1=$L(VAL)&'Q1 VAL=1
 S Q1=0 F C1=1:1:$L(FMT) Q:Q1  S:"0P"[$E(FMT,C1) FMT=$E(FMT,C1),Q1=1 S:C1=$L(FMT)&'Q1 FMT=0
 S (R1,R2)="",T1=$$SEX^AUPNPAT(PAT),T2=$$GETGI^AUPNSOGI(PAT,"I",,EDT),F1=0
 ;
 I VAL D
 . F C1=2:1:($L(T2,U)-1) S R2=$G(R2)_$$GI^AUTSOGI($P(T2,U,C1),"M"),F1=$S($L($$GI^AUTSOGI($P(T2,U,C1),"C"))>1:1,1:F1)
 . S R2=$S(($L(T2,U)-2)'=$L(R2):"",R2?1"M"."M":"M",R2?1"F"."F":"F",1:"N"),F2=$L(R2)
 ;
 S:VAL=0 R1=T1
 S:VAL=1 R1=$S(F2:R2_$S(T1=R2&'F1:"",1:"*"),1:T1)
 S:VAL=2 R1=$S(F2:R2_$S(T1=R2:"",1:"*"),1:T1)
 S:FMT["P" R1=$TR(R1,"*")
 Q R1
 ;
PRONOUN(PAT,VAL,FMT,EDT) ;PEP - Retrieve formatted Pronouns for a patient
 ;
 ; Type: Extrinsic Function
 ; Format: $$PRONOUN^AUPNSOGI(PAT,VAL,FMT,EDT)
 ; Function: Retrieve formatted pronouns for a patient.
 ;   This general retrieval API returns the Pronouns specified by the patient in Brief or Expanded display format.
 ;   If the patient has not specified Pronouns, a suggested set of Pronouns mapped to the patient Gender can be returned.
 ;   These entries are marked with a '*' to indicate the return value is a suggestion in the absence of patient specified Pronouns.
 ;     Gender:M => Masculine Pronouns: He,Him,His,His,Himself
 ;     Gender:F => Feminine Pronouns: She,Her,Her,Hers,Herself
 ;     Gender:N/U => Neutral Pronouns: They,Them,Their,Theirs,Themselves
 ;   The indicator can be suppressed independently by using the FMT parameter.
 ;   The EDT parameter if provided, is used to calculate the patient Gender for past dates.
 ; Input Parameters:
 ;   PAT: Patient IEN
 ;   VAL: 0:         Patient Pronouns Only
 ;        1/default: Patient Pronouns, if none specified Pronouns based on Gender
 ;   FMT: 0/default: Brief Display, star indicator: 3 Pronouns
 ;        1:         Expanded Display, star indicator: 5 Pronouns
 ;        0P:        Brief Display, no star indicator: 3 Pronouns
 ;        1P:        Expanded Display, no star indicator: 5 Pronouns
 ;   EDT: ""/default: Defaults to latest date entry
 ;        Date (int): Entry effective on that date
 ; Returned Values:
 ;   Successful (Dependent upon parameters):
 ;     VAL|FMT   PRONOUNS                  | NO PRONOUNS
 ;     0  |0   : PRONOUNS_brief    | ""
 ;     0  |1   : PRONOUNS_expanded | ""
 ;     1  |0   : PRONOUNS_brief    | GENDER_PRONOUNS_brief*
 ;     1  |1   : PRONOUNS_expanded | GENDER_PRONOUNS_expanded*
 ;     0  |0P  : PRONOUNS_brief    | ""
 ;     0  |1P  : PRONOUNS_expanded | ""
 ;     1  |0P  : PRONOUNS_brief    | GENDER_PRONOUNS_brief
 ;     1  |1P  : PRONOUNS_expanded | GENDER_PRONOUNS_expanded
 ;   Unsuccessful: "" Empty string
 ;
 S PAT=$G(PAT),VAL=$S($L($G(VAL)):VAL,1:1),FMT=$S($L($G(FMT)):FMT,1:0),FMT=$S(FMT["1":"1"_$E("P",FMT["P"),1:"0"_$E("P",FMT["P")),EDT=$S(+$G(EDT):EDT,1:"") Q:'PAT ""
 N R1,T1,T2,F1,C1,Q1
 S Q1=0 F C1=1:1:$L(VAL) Q:Q1  S:"01"[$E(VAL,C1) VAL=$E(VAL,C1),Q1=1 S:C1=$L(VAL)&'Q1 VAL=1
 S R1="",T1=$$GETPRN^AUPNSOGI(PAT,$S(+FMT:"D",1:"B")),T2=$TR($$GENDER(PAT,,"P",EDT),"U","N")
 S T1=$S(T1="UNK"!(T1="ASKU"):$$PN^AUTSOGI(T1,"E"),1:T1),F1=$L(T1)
 ;
 S:VAL=0 R1=T1
 S:VAL=1 R1=$S('F1:$$PN^AUTSOGI(T2,$S(+FMT:"D",1:"B"))_"*",1:T1)
 S:FMT["P" R1=$TR(R1,"*")
 Q R1
 ;
