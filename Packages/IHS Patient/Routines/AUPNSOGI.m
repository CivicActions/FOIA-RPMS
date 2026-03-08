AUPNSOGI ; IHS/OIT/FBD&NKD - SOGI APIs ; 03/04/2020 ;
 ;;99.1;IHS DICTIONARIES (PATIENT);**28,29**;MAR 9, 1999;Build 1
 ;IHS/OIT/FBD&NKD AUPN*99.1*29 - PPN PARAMETER
 ;
 Q  ;NO TOP-LEVEL CALL ALLOWED
 ;
 ; General Retrieval APIs
 ;GET(PAT,VAL,FMT,EDT,ARY)  ; - Retrieve bundled patient demographic data relevant to SOGI  ;IHS/OIT/FBD&NKD AUPN*99.1*29 - PPN PARAMETER
 ;Q $$GET^AUPNSOG1($G(PAT),$G(VAL),$G(FMT),$G(EDT),.ARY)
GET(PAT,VAL,FMT,EDT,ARY,PAR)  ;PEP - Retrieve bundled patient demographic data relevant to SOGI
 Q $$GET^AUPNSOG1($G(PAT),$G(VAL),$G(FMT),$G(EDT),.ARY,$G(PAR))
GENDER(PAT,VAL,FMT,EDT) ;PEP - Retrieve formatted Gender for a patient
 Q $$GENDER^AUPNSOG1($G(PAT),$G(VAL),$G(FMT),$G(EDT))
PRONOUN(PAT,VAL,FMT,EDT) ;PEP - Retrieve formatted Pronouns for a patient
 Q $$PRONOUN^AUPNSOG1($G(PAT),$G(VAL),$G(FMT),$G(EDT))
 ;
 ; Retrieval and Checking APIs
 ;GETPREF(PAT,VAL) ; - Retrieve Preferred Name for a patient  ;IHS/OIT/FBD&NKD AUPN*99.1*29 - PPN PARAMETER
 ;Q $$GETPREF^AUPNSOG2($G(PAT),$G(VAL))
GETPREF(PAT,VAL,PAR) ;PEP - Retrieve Preferred Name for a patient
 Q $$GETPREF^AUPNSOG2($G(PAT),$G(VAL),$G(PAR))
GETPRN(PAT,VAL) ;PEP - Retrieve Pronouns for a patient
 Q $$GETPRN^AUPNSOG2($G(PAT),$G(VAL))
GETLSEX(PAT,VAL,FMT,EDT) ;PEP - Retrieve Legal Sex for a patient
 Q $$GETLSEX^AUPNSOG2($G(PAT),$G(VAL),$G(FMT),$G(EDT))
GETSO(PAT,VAL,FMT,EDT) ;PEP - Retrieve Sexual Orientation for a patient
 Q $$GETSO^AUPNSOG2($G(PAT),$G(VAL),$G(FMT),$G(EDT))
GETGI(PAT,VAL,FMT,EDT) ;PEP - Retrieve Gender Identity for a patient
 Q $$GETGI^AUPNSOG2($G(PAT),$G(VAL),$G(FMT),$G(EDT))
HISTLSEX(PAT,VAL,FMT,ARY) ;PEP - Retrieve Legal Sex history for a patient
 Q $$HISTLSEX^AUPNSOG2($G(PAT),$G(VAL),$G(FMT),.ARY)
HISTSO(PAT,VAL,FMT,ARY) ;PEP - Retrieve Sexual Orientation history for a patient
 Q $$HISTSO^AUPNSOG2($G(PAT),$G(VAL),$G(FMT),.ARY)
HISTGI(PAT,VAL,FMT,ARY) ;PEP - Retrieve Gender Identity history for a patient
 Q $$HISTGI^AUPNSOG2($G(PAT),$G(VAL),$G(FMT),.ARY)
CHKPRN(PAT,VAL) ;PEP - Check if a specific Pronouns exists for a patient
 Q $$CHKPRN^AUPNSOG2($G(PAT),$G(VAL))
CHKSO(PAT,VAL,EDT) ;PEP - Check if a specific Sexual Orientation exists for a patient
 Q $$CHKSO^AUPNSOG2($G(PAT),$G(VAL),$G(EDT))
CHKGI(PAT,VAL,EDT) ;PEP - Check if a specific Gender Identity exists for a patient
 Q $$CHKGI^AUPNSOG2($G(PAT),$G(VAL),$G(EDT))
 ;
 ; Editing APIs
SETPREF(PAT,VAL) ;PEP - Set Preferred Name for a patient
 Q $$SETPREF^AUPNSOG3($G(PAT),$G(VAL))
SETPRN(PAT,VAL,OTH) ;PEP - Set Pronouns for a patient
 Q $$SETPRN^AUPNSOG3($G(PAT),$G(VAL),$G(OTH))
SETLSEX(PAT,VAL,SRC,EDT,DEDT) ;PEP - Set Legal Sex for a patient
 Q $$SETLSEX^AUPNSOG3($G(PAT),$G(VAL),$G(SRC),$G(EDT),$G(DEDT))
SETSO(PAT,VAL,OTH,EDT) ;PEP - Set Sexual Orientation for a patient
 Q $$SETSO^AUPNSOG3($G(PAT),$G(VAL),$G(OTH),$G(EDT))
SETGI(PAT,VAL,OTH,EDT) ;PEP -Set Gender Identity for a patient
 Q $$SETGI^AUPNSOG3($G(PAT),$G(VAL),$G(OTH),$G(EDT))
 ;
