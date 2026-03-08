AUPNSOG2 ; IHS/OIT/FBD&NKD - SOGI Retrieval and Checking APIs ; 03/04/2020 ;
 ;;99.1;IHS DICTIONARIES (PATIENT);**28,29,30**;MAR 9, 1999;Build 1
 ;IHS/OIT/FBD&NKD AUPN*99.1*29 - PPN PARAMETER
 ;IHS/OIT/NKD AUPN*99.1*30 - EXTERNAL CODE
 ;
 Q  ;NO TOP-LEVEL CALL ALLOWED
 ;
 ;GETPREF(PAT,VAL) ;EP - Retrieve Preferred Name for a patient  ;IHS/OIT/FBD&NKD AUPN*99.1*29 - PPN PARAMETER
GETPREF(PAT,VAL,PAR) ;EP - Retrieve Preferred Name for a patient
 ;
 ; Type: Extrinsic Function
 ; Format: $$GETPREF^AUPNSOGI(PAT,VAL,PAR)
 ; Function: Retrieve Preferred Name for a patient
 ;   This retrieval API returns the value of the patient's Preferred Name.
 ;   The API can additionally include the patient's Name in the following formats:
 ;     PATIENT_NAME - PREFERRED_NAME*
 ;     PREFERRED_NAME^FAMILY^GIVEN^MIDDLE^SUFFIX
 ;   Note: When the patient's Name is requested, it is returned regardless of whether the Preferred
 ;     Name has been specified.
 ;   The Preferred Name value can be suppressed based on the AUPN DISPLAY PPN system parameter with the PAR parameter.
 ;   When PAR=1, the value is suppressed if AUPN DISPLAY PPN is disabled (NO), and not suppressed if AUPN DISPLAY
 ;     PPN is enabled (YES).
 ;   Note: Access to this API requires use of the AUPN DISPLAY PPN parameter functionality, by setting the PAR
 ;     parameter to 1. Infrastructure applications are exempt from this requirement.
 ; Input Parameters:
 ;   PAT: Patient IEN
 ;   VAL: I/default: Internal value(s)
 ;        E:         External value(s)
 ;        C:         Component value(s)
 ;   PAR: 0/default: Disable AUPN DISPLAY PPN parameter functionality
 ;        1:         Enable AUPN DISPLAY PPN parameter functionality
 ; Returned Values:
 ;   Successful (Dependent upon parameters):
 ;     AUPN DISPLAY PPN enabled
 ;     VAL|PAR   PREFERRED NAME EXISTS                     | NO PREFERRED NAME
 ;     I  |0   : PREFERRED_NAME                            | ""
 ;     E  |0   : PATIENT_NAME - PREFERRED_NAME*            | PATIENT_NAME
 ;     C  |0   : PREFERRED_NAME^FAMILY^GIVEN^MIDDLE^SUFFIX | ^FAMILY^GIVEN^MIDDLE^SUFFIX
 ;     I  |1   : PREFERRED_NAME                            | ""
 ;     E  |1   : PATIENT_NAME - PREFERRED_NAME*            | PATIENT_NAME
 ;     C  |1   : PREFERRED_NAME^FAMILY^GIVEN^MIDDLE^SUFFIX | ^FAMILY^GIVEN^MIDDLE^SUFFIX
 ;     AUPN DISPLAY PPN disabled
 ;     VAL|PAR   PREFERRED NAME EXISTS                     | NO PREFERRED NAME
 ;     I  |0   : PREFERRED_NAME                            | ""
 ;     E  |0   : PATIENT_NAME - PREFERRED_NAME*            | PATIENT_NAME
 ;     C  |0   : PREFERRED_NAME^FAMILY^GIVEN^MIDDLE^SUFFIX | ^FAMILY^GIVEN^MIDDLE^SUFFIX
 ;     I  |1   : ""                                        | ""
 ;     E  |1   : PATIENT_NAME                              | PATIENT_NAME
 ;     C  |1   : ^FAMILY^GIVEN^MIDDLE^SUFFIX               | ^FAMILY^GIVEN^MIDDLE^SUFFIX
 ;   Unsuccessful: "" Empty string
 ;
 ;S PAT=$G(PAT),VAL=$S($L($G(VAL)):VAL,1:"I") Q:'PAT ""  ;IHS/OIT/FBD&NKD AUPN*99.1*29 - PPN PARAMETER
 S PAT=$G(PAT),VAL=$S($L($G(VAL)):VAL,1:"I"),PAR=$G(PAR,0) Q:'PAT ""
 N R1,T2,C1,Q1 S R1=$P($G(^AUPNPAT(PAT,90)),U),T2=$P($G(^DPT(PAT,0)),U)
 S Q1=0 F C1=1:1:$L(VAL) Q:Q1  S:"IEC"[$E(VAL,C1) VAL=$E(VAL,C1),Q1=1 S:C1=$L(VAL)&'Q1 VAL="I"
 I PAR,'$$GET^XPAR("SYS","AUPN DISPLAY PPN") S R1=""  ;IHS/OIT/FBD&NKD AUPN*99.1*29 - PPN PARAMETER
 S:VAL["E" R1=T2_$S($L(R1):" - "_R1_"*",1:"")
 S:VAL["C" R1=R1_U_$$NAMEFMT^XLFNAME(T2,"H")
 Q R1
 ;
GETPRN(PAT,VAL) ;EP - Retrieve Pronouns for a patient
 ;
 ; Type: Extrinsic Function
 ; Format: $$GETPRN^AUPNSOGI(PAT,VAL)
 ; Function: Retrieve Pronouns for a patient
 ;   This retrieval API returns the value of the patient's Pronouns.
 ;   If no Pronouns have been specified, the empty string "" is returned.
 ;   The type of value returned for the Pronouns is configured with the VAL parameter.
 ;   If the patient has specified Other Pronouns, that value is returned for display values of
 ;     the VAL parameter, or appear alongside the internal value separated by the "^" delimiter.
 ; Input Parameters:
 ;   VAL: B/default: Brief Display value (3 pieces if OTHER)
 ;        D:         Expanded Display value (5 pieces if OTHER)
 ;        E:         External value
 ;        I:         Internal value
 ;        C:         Code value
 ;        X:         External Code value
 ; Returned Values:
 ;   Successful (Dependent upon parameters):
 ;     VAL
 ;     B       : ENTRY_brief (3 pieces if OTHER)
 ;     D       : ENTRY_expanded (5 pieces if OTHER)
 ;     E       : ENTRY_ext
 ;     I       : ENTRY_int^OTHER
 ;     C       : ENTRY_code
 ;     X       : ENTRY_external_code
 ;   Unsuccessful: "" Empty string
 ;
 S PAT=$G(PAT),VAL=$S($L($G(VAL)):VAL,1:"B") Q:'PAT ""
 N R1,I2,T1,C1,Q1 S I2=$P($G(^AUPNPAT(PAT,90)),U,2),T1=$P($G(^AUPNPAT(PAT,90)),U,3) Q:'I2 ""
 ;S Q1=0 F C1=1:1:$L(VAL) Q:Q1  S:"BDEIC"[$E(VAL,C1) VAL=$E(VAL,C1),Q1=1 S:C1=$L(VAL)&'Q1 VAL="B"  ;IHS/OIT/NKD AUPN*99.1*30
 S Q1=0 F C1=1:1:$L(VAL) Q:Q1  S:"BDEICX"[$E(VAL,C1) VAL=$E(VAL,C1),Q1=1 S:C1=$L(VAL)&'Q1 VAL="B"
 S R1=$$PN^AUTSOGI(I2,VAL)
 S:VAL["I" R1=R1_U_T1
 S:R1="OTH" R1=$S(VAL["B":$P(T1,",",1,3),VAL["D":$P(T1,",",1,5),1:R1)
 Q R1
 ;
GETLSEX(PAT,VAL,FMT,EDT) ;EP - Retrieve Legal Sex for a patient
 ;
 ; Type: Extrinsic Function
 ; Format: $$GETLSEX^AUPNSOGI(PAT,VAL,FMT,EDT)
 ; Function: Retrieve Legal Sex for a patient
 ;   This retrieval API returns values from the patient's Legal Sex.
 ;   If no Legal Sex has been specified, the empty string "" is returned.
 ;   The internal record (IEN) of the entry is returned with the values from the Legal Sex, Source,
 ;     and Date Entered fields separated by the "^" delimiter. The Source and Date Entered fields
 ;     can be suppressed with the VAL parameter.
 ;   The type of values returned for these fields is configured with the VAL parameter.
 ;   The FMT parameter can exclude the internal record (IEN) from the return value and use the ","
 ;     delimiter to separate values.
 ;   The EDT parameter if provided, is used to retrieve the patient's Legal Sex for past dates.
 ; Input Parameters:
 ;   PAT: Patient IEN
 ;   VAL: E/default: External value(s), Legal Sex, Source, Date Entered
 ;        I:         Internal value(s), Legal Sex, Source, Date Entered
 ;        C:         Code value, Legal Sex only
 ;   FMT: 0/default: Sub-entry IEN followed by values (^ delimiter)
 ;        P:         Values (, delimiter)
 ;   EDT: ""/default: Defaults to latest date entry
 ;        Date (int): Entry effective on that date
 ; Returned Values:
 ;   Successful (Dependent upon parameters):
 ;     VAL|FMT
 ;     E  |0   : SUB_IEN^LEGAL_SEX_ext^SOURCE_ext^DATE_ENTERED_ext
 ;     I  |0   : SUB_IEN^LEGAL_SEX_int^SOURCE_int^DATE_ENTERED_int
 ;     C  |0   : SUB_IEN^LEGAL_SEX_int
 ;     E  |P   : LEGAL_SEX_ext,SOURCE_ext,DATE_ENTERED_ext
 ;     I  |P   : LEGAL_SEX_int,SOURCE_int,DATE_ENTERED_int
 ;     C  |P   : LEGAL_SEX_int
 ;   Unsuccessful: "" Empty string
 ;
 S PAT=$G(PAT),VAL=$S($L($G(VAL)):VAL,1:"E"),FMT=$S($L($G(FMT)):FMT,1:0),EDT=$S(+$G(EDT):EDT+.0001,1:"") Q:'PAT ""
 N R1,G1,I1,C1,Q1 S G1="^AUPNPAT("_PAT_",92)" Q:'$D(@G1) ""
 S I1=$O(@G1@("B",EDT),-1) Q:'I1 ""
 S Q1=0 F C1=1:1:$L(VAL) Q:Q1  S:"EIC"[$E(VAL,C1) VAL=$E(VAL,C1),Q1=1 S:C1=$L(VAL)&'Q1 VAL="E"
 S Q1=0 F C1=1:1:$L(FMT) Q:Q1  S:"0P"[$E(FMT,C1) FMT=$E(FMT,C1),Q1=1 S:C1=$L(FMT)&'Q1 FMT=0
 S R1=$G(@G1@(I1,0))
 S:VAL["E" $P(R1,U,2)=$$EXTERNAL^DILFD(9000001.9201,1,,$P(R1,U,2)),$P(R1,U,3)=$$EXTERNAL^DILFD(9000001.9201,2,,$P(R1,U,3)),$P(R1,U,4)=$$FMTE^XLFDT($P(R1,U,4),5)
 S:VAL["C" R1=$P(R1,U,1,2)
 S:FMT["P" R1=$TR($P(R1,U,2,$L(R1,U)),U,",")
 Q R1
 ;
GETSO(PAT,VAL,FMT,EDT) ;EP - Retrieve Sexual Orientation for a patient
 ;
 ; Type: Extrinsic Function
 ; Format: $$GETSO^AUPNSOGI(PAT,VAL,FMT,EDT)
 ; Function: Retrieve Sexual Orientation for a patient
 ;   This retrieval API returns values from the patient's Sexual Orientation.
 ;   If no Sexual Orientation has been specified, the empty string "" is returned.
 ;   The internal record (IEN) of the entry is returned with the values from the Sexual Orientation multiple
 ;     and Other Sexual Orientation field, separated by the "^" delimiter.
 ;   The type of values returned for these fields is configured with the VAL parameter.
 ;   If the patient has specified Other Sexual Orientation, that value is returned when external values are
 ;     requested in the format: OTHER_SEXUAL_ORIENTATION (OTH). Additionally, the Other Sexual Orientation will
 ;     be appended to the return value when internal values are requested, separated by the "^" delimiter.
 ;   The FMT parameter can exclude the internal record (IEN) from the return value and use the ","
 ;     delimiter to separate values.
 ;   The EDT parameter if provided, is used to retrieve the patient's Sexual Orientation for past dates.
 ; Input Parameters:
 ;   PAT: Patient IEN
 ;   VAL: E/default: External value(s) (Free-text OTHER included)
 ;        I:         Internal value(s)
 ;        C:         Code value(s)
 ;        S:         Snomed code value(s)
 ;        X:         External Code value
 ;   FMT: 0/default: Sub-entry IEN followed by values (^ delimiter)
 ;        P:         Values (, delimiter)
 ;   EDT: ""/default: Defaults to latest date entry
 ;        Date (int): Entry effective on that date
 ; Returned Values:
 ;   Successful (Dependent upon parameters):
 ;     VAL|FMT
 ;     E  |0   : SUB_IEN^ENTRY_ext^ENTRY_ext
 ;     I  |0   : SUB_IEN^ENTRY_int^ENTRY_int^OTHER
 ;     C  |0   : SUB_IEN^ENTRY_code^ENTRY_code
 ;     S  |0   : SUB_IEN^ENTRY_snomed^ENTRY_snomed
 ;     X  |0   : SUB_IEN^ENTRY_external_code^ENTRY_external_code
 ;     E  |P   : ENTRY_ext,ENTRY_ext
 ;     I  |P   : ENTRY_int,ENTRY_int,OTHER
 ;     C  |P   : ENTRY_code,ENTRY_code
 ;     S  |P   : ENTRY_snomed,ENTRY_snomed
 ;     X  |P   : ENTRY_external_code,ENTRY_external_code
 ;   Unsuccessful: "" Empty string
 ;
 S PAT=$G(PAT),VAL=$S($L($G(VAL)):VAL,1:"E"),FMT=$S($L($G(FMT)):FMT,1:0),EDT=$S(+$G(EDT):EDT+.0001,1:"") Q:'PAT ""
 N R1,G1,G2,C1,Q1 S G1="^AUPNPAT("_PAT_",93)",G2="^AUTTSO" Q:'$D(@G1) ""
 ;S Q1=0 F C1=1:1:$L(VAL) Q:Q1  S:"EICS"[$E(VAL,C1) VAL=$E(VAL,C1),Q1=1 S:C1=$L(VAL)&'Q1 VAL="E"  ;IHS/OIT/NKD AUPN*99.1*30
 S Q1=0 F C1=1:1:$L(VAL) Q:Q1  S:"EICSX"[$E(VAL,C1) VAL=$E(VAL,C1),Q1=1 S:C1=$L(VAL)&'Q1 VAL="E"
 S Q1=0 F C1=1:1:$L(FMT) Q:Q1  S:"0P"[$E(FMT,C1) FMT=$E(FMT,C1),Q1=1 S:C1=$L(FMT)&'Q1 FMT=0
 S R1=$$G9394(G1,G2,VAL,EDT)
 S:FMT["P" R1=$TR($P(R1,U,2,$L(R1,U)),U,",")
 Q R1
 ;
GETGI(PAT,VAL,FMT,EDT) ;EP - Retrieve Gender Identity for a patient
 ;
 ; Type: Extrinsic Function
 ; Format: $$GETGI^AUPNSOGI(PAT,VAL,FMT,EDT)
 ; Function: Retrieve Gender Identity for a patient
 ;   This retrieval API returns values from the patient's Gender Identity.
 ;   If no Gender Identity has been specified, the empty string "" is returned.
 ;   The internal record (IEN) of the entry is returned with the values from the Gender Identity multiple
 ;     and Other Gender Identity field, separated by the "^" delimiter.
 ;   The type of values returned for these fields is configured with the VAL parameter.
 ;   If the patient has specified Other Gender Identity, that value is returned when external values are
 ;     requested in the format: OTHER_GENDER_IDENTITY (OTH). Additionally, the Other Gender Identity will
 ;     be appended to the return value when internal values are requested, separated by the "^" delimiter.
 ;   The FMT parameter can exclude the internal record (IEN) from the return value and use the ","
 ;     delimiter to separate values.
 ;   The EDT parameter if provided, is used to retrieve the patient's Gender Identity for past dates.
 ; Input Parameters:
 ;   PAT: Patient IEN
 ;   VAL: E/default: External value(s) (Free-text OTHER included)
 ;        I:         Internal value(s)
 ;        C:         Code value(s)
 ;        S:         Snomed code value(s)
 ;        M:         Gender marker value(s)
 ;        X:         External Code value
 ;   FMT: 0/default: Sub-entry IEN followed by values (^ delimiter)
 ;        P:         Values (, delimiter)
 ;   EDT: ""/default: Defaults to latest date entry
 ;        Date (int): Entry effective on that date
 ; Returned Values:
 ;   Successful (Dependent upon parameters):
 ;     VAL|FMT
 ;     E  |0   : SUB_IEN^ENTRY_ext^ENTRY_ext
 ;     I  |0   : SUB_IEN^ENTRY_int^ENTRY_int^OTHER
 ;     C  |0   : SUB_IEN^ENTRY_code^ENTRY_code
 ;     S  |0   : SUB_IEN^ENTRY_snomed^ENTRY_snomed
 ;     M  |0   : SUB_IEN^ENTRY_marker^ENTRY_marker
 ;     X  |0   : SUB_IEN^ENTRY_external_code^ENTRY_external_code
 ;     E  |P   : ENTRY_ext,ENTRY_ext
 ;     I  |P   : ENTRY_int,ENTRY_int,OTHER
 ;     C  |P   : ENTRY_code,ENTRY_code
 ;     S  |P   : ENTRY_snomed,ENTRY_snomed
 ;     M  |P   : ENTRY_marker,ENTRY_marker
 ;     X  |P   : ENTRY_external_code,ENTRY_external_code
 ;   Unsuccessful: "" Empty string
 ;
 S PAT=$G(PAT),VAL=$S($L($G(VAL)):VAL,1:"E"),FMT=$S($L($G(FMT)):FMT,1:0),EDT=$S(+$G(EDT):EDT+.0001,1:"") Q:'PAT ""
 N R1,G1,G2,C1,Q1 S G1="^AUPNPAT("_PAT_",94)",G2="^AUTTGI" Q:'$D(@G1) ""
 ;S Q1=0 F C1=1:1:$L(VAL) Q:Q1  S:"EICSM"[$E(VAL,C1) VAL=$E(VAL,C1),Q1=1 S:C1=$L(VAL)&'Q1 VAL="E"  ;IHS/OIT/NKD AUPN*99.1*30
 S Q1=0 F C1=1:1:$L(VAL) Q:Q1  S:"EICSMX"[$E(VAL,C1) VAL=$E(VAL,C1),Q1=1 S:C1=$L(VAL)&'Q1 VAL="E"
 S Q1=0 F C1=1:1:$L(FMT) Q:Q1  S:"0P"[$E(FMT,C1) FMT=$E(FMT,C1),Q1=1 S:C1=$L(FMT)&'Q1 FMT=0
 S R1=$$G9394(G1,G2,VAL,EDT)
 S:FMT["P" R1=$TR($P(R1,U,2,$L(R1,U)),U,",")
 Q R1
 ;
HISTLSEX(PAT,VAL,FMT,ARY) ;EP - Retrieve Legal Sex history for a patient
 ;
 ; Type: Extrinsic Function
 ; Format: $$HISTLSEX^AUPNSOGI(PAT,VAL,FMT,.ARY)
 ; Function: Retrieve Legal Sex history for a patient
 ;   This retrieval API returns the historical Legal Sex records for a patient in a local array passed by reference.
 ;   NOTE: This array is cleaned out (KILLed) before records are loaded.
 ;   If an array is not provided, this extrinsic function will provide the number of Legal Sex records, the date of the
 ;     most recent effective Legal Sex record (FileMan internal date), and the date of the earliest effective Legal Sex record
 ;     (FileMan internal date) separated by the "^" delimiter.
 ;   Each node in the array corresponds to a Legal Sex record using the internal record IEN:
 ;     ARY(RECORD_IEN)
 ;   The value of each node in the array is formatted according to the VAL and FMT parameters using the $$GETLSEX^AUPNSOGI API:
 ;     ARY(RECORD_IEN)=$$GETLSEX(PAT,VAL,FMT,RECORD_IEN)
 ; Input Parameters:
 ;   PAT: Patient IEN
 ;   VAL: E/default: Pass-through parameter to VAL in $$GETLSEX^AUPNSOGI, Defaults to E
 ;   FMT: 0/default: Pass-through parameter to FMT in $$GETLSEX^AUPNSOGI, Defaults to 0
 ;  .ARY: Return array passed by reference
 ; Returned Values:
 ;   Successful:   # of records^Most recent effective record date^Earliest effective record date
 ;   Unsuccessful: 0
 ;   Return array on success:
 ;                 ARY=# of records^Most recent effective record date^Earliest effective record date
 ;                 ARY(RECORD_IEN)=Return value from $$GETLSEX^AUPNSOGI(PAT,VAL,FMT,RECORD_IEN) (Dependent upon parameters)
 ;
 S PAT=$G(PAT),VAL=$S($L($G(VAL)):VAL,1:"E"),FMT=$S($L($G(FMT)):FMT,1:0),ARY=$G(ARY) K ARY Q:'PAT 0
 N R1,G1,I1 S R1=0,G1="^AUPNPAT("_PAT_",92)" Q:'$D(@G1) R1
 S I1="" F  S I1=$O(@G1@("B",I1),-1) Q:'I1  D
 . S $P(R1,U)=$P(R1,U)+1,$P(R1,U,2)=$S('$P(R1,U,2):I1,1:$P(R1,U,2)),$P(R1,U,3)=I1
 . S ARY=R1,ARY(I1)=$$GETLSEX(PAT,VAL,FMT,I1)
 Q R1
 ;
HISTSO(PAT,VAL,FMT,ARY) ;EP - Retrieve Sexual Orientation history for a patient
 ;
 ; Type: Extrinsic Function
 ; Format: $$HISTSO^AUPNSOGI(PAT,VAL,FMT,.ARY)
 ; Function: Retrieve Sexual Orientation history for a patient
 ;   This retrieval API returns the historical Sexual Orientation records for a patient in a local array passed by reference.
 ;   NOTE: This array is cleaned out (KILLed) before records are loaded.
 ;   If an array is not provided, this extrinsic function will provide the number of Sexual Orientation records, the date of the
 ;     most recent Sexual Orientation record (FileMan internal date), and the date of the earliest Sexual Orientation record
 ;     (FileMan internal date) separated by the "^" delimiter.
 ;   Each node in the array corresponds to a Sexual Orientation record using the internal record IEN:
 ;     ARY(RECORD_IEN)
 ;   The value of each node in the array is formatted according to the VAL and FMT parameters using the $$GETSO^AUPNSOGI API:
 ;     ARY(RECORD_IEN)=$$GETSO(PAT,VAL,FMT,RECORD_IEN)
 ; Input Parameters:
 ;   PAT: Patient IEN
 ;   VAL: E/default: Pass-through parameter to VAL in $$GETSO^AUPNSOGI, Defaults to E
 ;   FMT: 0/default: Pass-through parameter to FMT in $$GETSO^AUPNSOGI, Defaults to 0
 ;  .ARY: Return array passed by reference
 ; Returned Values:
 ;   Successful:   # of records^Most recent record date^Earliest record date
 ;   Unsuccessful: 0
 ;   Return array on success:
 ;                 ARY=# of records^Most recent record date^Earliest record date
 ;                 ARY(RECORD_IEN)=Return value from $$GETSO^AUPNSOGI(PAT,VAL,FMT,RECORD_IEN) (Dependent upon parameters)
 ;
 S PAT=$G(PAT),VAL=$S($L($G(VAL)):VAL,1:"E"),FMT=$S($L($G(FMT)):FMT,1:0),ARY=$G(ARY) K ARY Q:'PAT 0
 N R1,G1,I1 S R1=0,G1="^AUPNPAT("_PAT_",93)" Q:'$D(@G1) R1
 S I1="" F  S I1=$O(@G1@("B",I1),-1) Q:'I1  D
 . S $P(R1,U)=$P(R1,U)+1,$P(R1,U,2)=$S('$P(R1,U,2):I1,1:$P(R1,U,2)),$P(R1,U,3)=I1
 . S ARY=R1,ARY(I1)=$$GETSO(PAT,VAL,FMT,I1)
 Q R1
 ;
HISTGI(PAT,VAL,FMT,ARY) ;EP - Retrieve Gender Identity history for a patient
 ;
 ; Type: Extrinsic Function
 ; Format: $$HISTGI^AUPNSOGI(PAT,VAL,FMT,.ARY)
 ; Function: Retrieve Gender Identity history for a patient
 ;   This retrieval API returns the historical Gender Identity records for a patient in a local array passed by reference.
 ;   NOTE: This array is cleaned out (KILLed) before records are loaded.
 ;   If an array is not provided, this extrinsic function will provide the number of Gender Identity records, the date of the
 ;     most recent Gender Identity record (FileMan internal date), and the date of the earliest Gender Identity record
 ;     (FileMan internal date) separated by the "^" delimiter.
 ;   Each node in the array corresponds to a Gender Identity record using the internal record IEN:
 ;     ARY(RECORD_IEN)
 ;   The value of each node in the array is formatted according to the VAL and FMT parameters using the $$GETGI^AUPNSOGI API:
 ;     ARY(RECORD_IEN)=$$GETGI(PAT,VAL,FMT,RECORD_IEN)
 ; Input Parameters:
 ;   PAT: Patient IEN
 ;   VAL: E/default: Pass-through parameter to VAL in $$GETGI^AUPNSOGI, Defaults to E
 ;   FMT: 0/default: Pass-through parameter to FMT in $$GETGI^AUPNSOGI, Defaults to 0
 ;  .ARY: Return array passed by reference
 ; Returned Values:
 ;   Successful:   # of records^Most recent record date^Earliest record date
 ;   Unsuccessful: 0
 ;   Return array on success:
 ;                 ARY=# of records^Most recent record date^Earliest record date
 ;                 ARY(RECORD_IEN)=Return value from $$GETGI^AUPNSOGI(PAT,VAL,FMT,RECORD_IEN) (Dependent upon parameters)
 ;
 S PAT=$G(PAT),VAL=$S($L($G(VAL)):VAL,1:"E"),FMT=$S($L($G(FMT)):FMT,1:0),ARY=$G(ARY) K ARY Q:'PAT 0
 N R1,G1,I1 S R1=0,G1="^AUPNPAT("_PAT_",94)" Q:'$D(@G1) R1
 S I1="" F  S I1=$O(@G1@("B",I1),-1) Q:'I1  D
 . S $P(R1,U)=$P(R1,U)+1,$P(R1,U,2)=$S('$P(R1,U,2):I1,1:$P(R1,U,2)),$P(R1,U,3)=I1
 . S ARY=R1,ARY(I1)=$$GETGI(PAT,VAL,FMT,I1)
 Q R1
 ;
CHKPRN(PAT,VAL) ;EP - Check if a specific Pronouns exists for a patient
 ;
 ; Type: Extrinsic Function
 ; Format: $$CHKPRN^AUPNSOGI(PAT,VAL)
 ; Function: Check if a specific Pronouns exists for a patient
 ;   This retrieval API checks if a patient has a specific Pronouns entry.
 ;   A return value of 1 means the patient has the specified entry.
 ;   A return value of 0 means the patient does not, or the patient has not specified their Pronouns.
 ;   The value to check for must be an internal, external, or code value of an existing Pronouns entry.
 ; Input Parameters:
 ;   PAT: Patient IEN
 ;   VAL: Value to look for (Internal, Code, Name)
 ; Returned Values:
 ;   Successful:   1
 ;   Unsuccessful: 0
 ;
 S PAT=$G(PAT),VAL=$G(VAL) Q:'PAT!'$L(VAL) 0
 N R2,G1,G2 S G1="^AUPNPAT("_PAT_",90)",G2="^AUTTPRN" Q:'$D(@G1) 0
 S R2=$$PN^AUTSOGI(VAL,"I") Q:'R2 0
 Q $S($P($G(@G1),U,2)=R2:1,1:0)
 ;
CHKSO(PAT,VAL,EDT) ;EP - Check if a specific Sexual Orientation exists for a patient
 ;
 ; Type: Extrinsic Function
 ; Format: $$CHKSO^AUPNSOGI(PAT,VAL,EDT)
 ; Function: Check if a specific Sexual Orientation exists for a patient
 ;   This retrieval API checks if a patient has a specific Sexual Orientation entry.
 ;   A return value of 1 means the patient has the specified entry.
 ;   A return value of 0 means the patient does not, or the patient has not specified their Sexual Orientation.
 ;   The value to check for must be an internal, external, or code value of an existing Sexual Orientation entry.
 ;   The EDT parameter if provided, is used to check the patient's Sexual Orientation for past dates.
 ; Input Parameters:
 ;   PAT: Patient IEN
 ;   VAL: Value to look for (Internal, Code, Name)
 ;   EDT: ""/default: Defaults to latest date entry
 ;        Date (int): Entry effective on that date
 ; Returned Values:
 ;   Successful:   1
 ;   Unsuccessful: 0
 ;
 S PAT=$G(PAT),VAL=$G(VAL),EDT=$S(+$G(EDT):EDT+.0001,1:"") Q:'PAT!'$L(VAL) 0
 N R2,G1,G2 S G1="^AUPNPAT("_PAT_",93)",G2="^AUTTSO" Q:'$D(@G1) 0
 S R2=$$SO^AUTSOGI(VAL,"I") Q:'R2 0
 Q $S('$O(@G1@("B",EDT),-1):0,$D(@G1@($O(@G1@("B",EDT),-1),1,R2)):1,1:0)
 ;
CHKGI(PAT,VAL,EDT) ;EP - Check if a specific Gender Identity exists for a patient
 ;
 ; Type: Extrinsic Function
 ; Format: $$CHKGI^AUPNSOGI(PAT,VAL,EDT)
 ; Function: Check if a specific Gender Identity exists for a patient
 ;   This retrieval API checks if a patient has a specific Gender Identity entry.
 ;   A return value of 1 means the patient has the specified entry.
 ;   A return value of 0 means the patient does not, or the patient has not specified their Gender Identity.
 ;   The value to check for must be an internal, external, or code value of an existing Gender Identity entry.
 ;   The EDT parameter if provided, is used to check the patient's Gender Identity for past dates.
 ; Input Parameters:
 ;   PAT: Patient IEN
 ;   VAL: Value to look for (Internal, Code, Name)
 ;   EDT: ""/default: Defaults to latest date entry
 ;        Date (int): Entry effective on that date
 ; Returned Values:
 ;   Successful:   1
 ;   Unsuccessful: 0
 ;
 S PAT=$G(PAT),VAL=$G(VAL),EDT=$S(+$G(EDT):EDT+.0001,1:"") Q:'PAT!'$L(VAL) 0
 N R2,G1,G2 S G1="^AUPNPAT("_PAT_",94)",G2="^AUTTGI" Q:'$D(@G1) 0
 S R2=$$GI^AUTSOGI(VAL,"I") Q:'R2 0
 Q $S('$O(@G1@("B",EDT),-1):0,$D(@G1@($O(@G1@("B",EDT),-1),1,R2)):1,1:0)
 ;
G9394(G1,G2,VAL,EDT) ; INTERNAL SUBROUTINE TO GET VALUES FROM PATIENT 93 AND 94 NODE
 S G1=$G(G1),G2=$G(G2),VAL=$G(VAL),EDT=$G(EDT) Q:'$L(G1)!'$L(G2) ""
 N R1,I1,I2 S (R1,I1)=$O(@G1@("B",EDT),-1) Q:'I1 ""
 S I2=0 F  S I2=$O(@G1@(I1,1,I2)) Q:'I2  D
 . S:G2["SO" R1=$G(R1)_U_$S(VAL["E"&($$SO^AUTSOGI(I2,"C")="OTH"):$P($G(@G1@(I1,0)),U,2)_" (OTH)",1:$$SO^AUTSOGI(I2,VAL))
 . S:G2["GI" R1=$G(R1)_U_$S(VAL["E"&($$GI^AUTSOGI(I2,"C")="OTH"):$P($G(@G1@(I1,0)),U,2)_" (OTH)",1:$$GI^AUTSOGI(I2,VAL))
 S:VAL["I" R1=$G(R1)_U_$P($G(@G1@(I1,0)),U,2)
 Q R1
 ;
