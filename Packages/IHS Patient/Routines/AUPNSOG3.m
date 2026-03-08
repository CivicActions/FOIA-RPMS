AUPNSOG3 ; IHS/OIT/FBD&NKD - SOGI Editing APIs ; 03/04/2020 ;
 ;;99.1;IHS DICTIONARIES (PATIENT);**28**;MAR 9, 1999;Build 1
 ;
 Q  ;NO TOP-LEVEL CALL ALLOWED
 ;
SETPREF(PAT,VAL) ;EP - Set Preferred Name for a patient
 ;
 ; Type: Extrinsic Function
 ; Format: $$SETPREF^AUPNSOGI(PAT,VAL)
 ; Function: Set the Preferred Name field (#9001) for a patient.
 ;   If the VAL parameter is blank or '@', this will delete the value stored in the Preferred Name field.
 ;   Return value will be '0^ERROR MESSAGE' for errors, '@' for deletions, or the result of $$GETPREF^AUPNSOGI(PAT).
 ; Input Parameters:
 ;   PAT: Patient IEN
 ;   VAL: Preferred Name
 ; Returned Values:
 ;   Successful  : @ or PREFERRED_NAME
 ;   Unsuccessful: 0^ERROR MESSAGE
 ;
 S PAT=$G(PAT),VAL=$S($L($G(VAL)):VAL,1:"@")
 N FDA,IENS,ERR,X,Y
 S IENS=PAT_","
 S FDA(9000001,IENS,9001)=VAL  ; PREFERRED NAME (#9001)
 D FILE^DIE(,"FDA","ERR")
 ;
 Q $S($D(ERR):"0^"_$G(ERR("DIERR","1","TEXT",1)),VAL="@":VAL,1:$$GETPREF^AUPNSOGI(PAT))
 ;
SETPRN(PAT,VAL,OTH) ;EP - Set Pronouns for a patient
 ;
 ; Type: Extrinsic Function
 ; Format: $$SETPRN^AUPNSOGI(PAT,VAL,OTH)
 ; Function: Set the Pronouns field (#9002) and the Pronouns Other field (#9003) for a patient.
 ;   If the VAL parameter is blank or '@', this will delete the value stored in the Pronouns field.
 ;   If the VAL parameter does not match the 'OTHER' Pronouns entry, the value stored in the Pronouns Other field will automatically be deleted.
 ;   Return value will be '0^ERROR MESSAGE' for errors, '@' for deletions, or the result of $$GETPRN^AUPNSOGI(PAT,"I").
 ; Input Parameters:
 ;   PAT: Patient IEN
 ;   VAL: Pronoun (Internal/External/Code)
 ;   OTH: Free-text Other
 ; Returned Values:
 ;   Successful  : @ or PRONOUNS_int^PRONOUNS_OTHER_int
 ;   Unsuccessful: 0^ERROR MESSAGE
 ;
 S PAT=$G(PAT),VAL=$$PN^AUTSOGI($G(VAL),"I"),VAL=$S('VAL:"@",1:VAL),OTH=$G(OTH)
 N FDA,IENS,ERR,X,Y
 S IENS=PAT_","
 S FDA(9000001,IENS,9002)=VAL  ; PRONOUNS (#9002)
 S FDA(9000001,IENS,9003)=$S($$PN^AUTSOGI(VAL,"C")="OTH":OTH,1:"")  ; PRONOUNS OTHER (#9003)
 D FILE^DIE(,"FDA","ERR")
 ;
 Q $S($D(ERR):"0^"_$G(ERR("DIERR","1","TEXT",1)),VAL="@":VAL,1:$$GETPRN^AUPNSOGI(PAT,"I"))
 ;
SETLSEX(PAT,VAL,SRC,EDT,DEDT) ;EP - Set Legal Sex for a patient
 ;
 ; Type: Extrinsic Function
 ; Format: $$SETLSEX^AUPNSOGI(PAT,VAL,SRC,EDT,DEDT)
 ; Function: Set the Effective Date (#.01), Legal Sex (#1), Source (#2), and Date Entered (#3) fields of Legal Sex sub-file
 ;     (#9000001.9201) for a patient.
 ;   If the VAL parameter is '@', this will delete the entry stored on the EDT parameter date in the Legal Sex sub-file.
 ;   Return value will be '0^ERROR MESSAGE' for errors, '@^IEN' for deletions, or the result of $$GETLSEX^AUPNSOGI(PAT,"I").
 ; Input Parameters:
 ;   PAT: Patient IEN
 ;   VAL: Legal Sex (Internal)
 ;   SRC: Source (Internal)
 ;   EDT: Effective Date (defaults to TODAY)
 ;  DEDT: Date Entered (defaults to TODAY)
 ; Returned Values:
 ;   Successful  : @^IEN or IEN^LEGAL_SEX_int^SOURCE_int^DATE_ENTERED_int
 ;   Unsuccessful: 0^ERROR MESSAGE
 ;
 S PAT=$G(PAT),VAL=$G(VAL),SRC=$G(SRC),EDT=$S(+$G(EDT):EDT,1:$$DT^XLFDT),DEDT=$S(+$G(DEDT):DEDT,1:$$DT^XLFDT)
 N FDA,SF,IENS,CNT,RES,ERR,X,Y
 S SF=9000001.9201,IENS=$S($D(^AUPNPAT(PAT,92,EDT)):EDT,1:"+1")_","_PAT_","
 Q:($E(IENS,1,2)="+1")&(VAL="@") "0^Entry "_EDT_" not found to delete."
 I VAL="@" S FDA(SF,IENS,.01)=VAL  ; EFFECTIVE DATE (#.01)
 E  D
 . S FDA(SF,IENS,.01)=EDT  ; EFFECTIVE DATE (#.01)
 . S FDA(SF,IENS,1)=VAL    ; LEGAL SEX (#1)
 . S FDA(SF,IENS,2)=SRC    ; SOURCE (#2)
 . S FDA(SF,IENS,3)=DEDT   ; DATE ENTERED (#3)
 S RES(1)=EDT              ; ENTRY DINUM'ED BY DATE
 D UPDATE^DIE(,"FDA","RES","ERR")
 Q $S($D(ERR):"0^"_$G(ERR("DIERR","1","TEXT",1)),VAL="@":VAL_U_EDT,1:$$GETLSEX^AUPNSOGI(PAT,"I",,EDT))
 ;
SETSO(PAT,VAL,OTH,EDT) ;EP - Set Sexual Orientation for a patient
 ;
 ; Type: Extrinsic Function
 ; Format: $$SETSO^AUPNSOGI(PAT,VAL,OTH,EDT)
 ; Function: Set the Date (#.01), Sexual Orientation (#1), and Other (#2) fields of Sexual Orientation sub-file (#9000001.9301) for a patient.
 ;   If the VAL parameter is '@', this will delete the entry stored on the EDT parameter date in the Sexual Orientation sub-file.
 ;   If the VAL parameter doesn't include the 'OTHER' Sexual Orientation entry, the value stored in the Other field will automatically be deleted.
 ;   Return value will be '0^ERROR MESSAGE' for errors, '@^IEN' for deletions, or the result of $$GETSO^AUPNSOGI(PAT,"I").
 ; Input Parameters:
 ;   PAT: Patient IEN
 ;   VAL: List of Sexual Orientations (Internal/External/Code) (^ delimiter) (@ to delete)
 ;   OTH: Free-text Other
 ;   EDT: Entry date (defaults to TODAY)
 ; Returned Values:
 ;   Successful  : @^IEN or IEN^ENTRY_int^ENTRY_int^etc^OTHER
 ;   Unsuccessful: 0^ERROR MESSAGE
 ;
 S PAT=$G(PAT),VAL=$G(VAL),OTH=$G(OTH),EDT=$S(+$G(EDT):EDT,1:$$DT^XLFDT)
 N F1,G1,R1,CNT,RES S F1=9000001.9301,G1="^AUPNPAT("_PAT_",93)",R1=0
 I VAL'="@" F CNT=1:1:$L(VAL,U) S $P(VAL,U,CNT)=$$SO^AUTSOGI($P(VAL,U,CNT),"I") I $L(OTH),$$SO^AUTSOGI($P(VAL,U,CNT),"C")="OTH" S R1=1
 S RES=$$S9394(F1,G1,PAT,VAL,$S(R1:OTH,1:""),EDT)
 Q $S('RES:RES,1:$$GETSO^AUPNSOGI(PAT,"I",,EDT))
 ;
SETGI(PAT,VAL,OTH,EDT) ;EP - Set Gender Identity for a patient
 ;
 ; Type: Extrinsic Function
 ; Format: $$SETGI^AUPNSOGI(PAT,VAL,OTH,EDT)
 ; Function: Set the Date (#.01), Gender Identity (#1), and Other (#2) fields of Gender Identity sub-file (#9000001.9401) for a patient.
 ;   If the VAL parameter is '@', this will delete the entry stored on the EDT parameter date in the Gender Identity sub-file.
 ;   If the VAL parameter doesn't include the 'OTHER' Gender Identity entry, the value stored in the Other field will automatically be deleted.
 ;   Return value will be '0^ERROR MESSAGE' for errors, '@^IEN' for deletions, or the result of $$GETGI^AUPNSOGI(PAT,"I").
 ; Input Parameters:
 ;   PAT: Patient IEN
 ;   VAL: List of Gender Identities (Internal/External/Code) (^ delimiter) (@ to delete)
 ;   OTH: Free-text Other
 ;   EDT: Entry date (defaults to TODAY)
 ; Returned Values:
 ;   Successful  : @^IEN or IEN^ENTRY_int^ENTRY_int^etc^OTHER
 ;   Unsuccessful: 0^ERROR MESSAGE
 ;
 S PAT=$G(PAT),VAL=$G(VAL),OTH=$G(OTH),EDT=$S(+$G(EDT):EDT,1:$$DT^XLFDT)
 N F1,G1,R1,CNT,RES S F1=9000001.9401,G1="^AUPNPAT("_PAT_",94)",R1=0
 I VAL'="@" F CNT=1:1:$L(VAL,U) S $P(VAL,U,CNT)=$$GI^AUTSOGI($P(VAL,U,CNT),"I") I $L(OTH),$$GI^AUTSOGI($P(VAL,U,CNT),"C")="OTH" S R1=1
 S RES=$$S9394(F1,G1,PAT,VAL,$S(R1:OTH,1:""),EDT)
 Q $S('RES:RES,1:$$GETGI^AUPNSOGI(PAT,"I",,EDT))
 ;
S9394(F1,G1,PAT,VAL,OTH,EDT) ; INTERNAL SUBROUTINE TO SET VALUES FROM PATIENT 93 AND 94 NODE
 S F1=$G(F1),G1=$G(G1),PAT=$G(PAT),VAL=$G(VAL),OTH=$G(OTH),EDT=$G(EDT)
 N FDA,SF,IENS,CNT,RES,ERR,X,Y
 S SF=F1,IENS=$S($D(@G1@(EDT)):EDT,1:"+1")_","_PAT_","
 Q:($E(IENS,1,2)="+1")&(VAL="@") "0^Entry "_EDT_" not found to delete."
 S FDA(SF,IENS,.01)=$S(VAL="@":VAL,1:EDT)  ; DATE (#.01)
 S:VAL'="@" FDA(SF,IENS,2)=OTH  ; OTHER (#2)
 S RES(1)=EDT  ; ENTRY DINUM'ED BY DATE
 D UPDATE^DIE(,"FDA","RES","ERR")
 Q:$D(ERR) ("0^"_$G(ERR("DIERR","1","TEXT",1)))
 Q:'$L(VAL) EDT
 Q:VAL="@" VAL_U_EDT
 ;
 K FDA,RES,ERR
 S SF=F1_"1",IENS=","_EDT_","_PAT_","
 F CNT=1:1:$L(VAL,U) Q:'$P(VAL,U,CNT)  S (FDA(SF,"?+"_CNT_IENS,.01),RES(CNT))=$P(VAL,U,CNT)
 S CNT=0 F  S CNT=$O(@G1@(EDT,1,CNT)) Q:'CNT  I (U_VAL_U)'[(U_CNT_U) S FDA(SF,CNT_IENS,.01)="@"
 D UPDATE^DIE(,"FDA","RES","ERR")
 ;
 Q $S($D(ERR):"0^"_$G(ERR("DIERR","1","TEXT",1)),1:EDT)  ; ERROR: 0^MESSAGE, SUCCESS: IEN (DATE)
 ;
