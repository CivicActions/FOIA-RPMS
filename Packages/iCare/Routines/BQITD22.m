BQITD22 ;GDIT/HS/ALA - Prediabetes ; 12 Aug 2024  3:13 PM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**7**;Mar 01, 2021;Build 14
 ;
 ;
POP(BQARY,TGLOB) ; EP -- By population
 ;
 ;Description
 ;  Finds all patients who meet the criteria for PreDiabetes
 ;Input
 ;  BQARY - Array of taxonomies and other information
 ;  TGLOB - Global where data is to be stored and passed back
 ;          to calling routine
 ;          Structure:
 ;          TGLOB(DFN,"CRITERIA",criteria or taxonomy,visit or problem ien)=date/time
 I $D(@BQARY) D
 . D POP^BQITDGN(BQARY,TGLOB)
 ;
 ; Finish with all the logic and have a list of patients to file
 NEW TDFN,TDXNCN
 S TDFN=""
 F  S TDFN=$O(@TGLOB@(TDFN)) Q:'TDFN  D
 . NEW I,TEXT
 . F I=1:1 S TEXT=$T(TAG+I) Q:TEXT=" Q"  D
 .. S TDXNCN=$P(TEXT,";;",2) D
 ... I $$ATAG^BQITDUTL(TDFN,TDXNCN) K @TGLOB@(TDFN)
 Q
 ;
PAT(DEF,BTGLOB,BDFN) ; EP -- By patient
 NEW DXOK,BQDXN,BQREF
 S DXOK=0
 S BQDXN=$$GDXN^BQITUTL(DEF)
 ;
 S BQREF="BQIRY"
 D GDF^BQITUTL(BQDXN,BQREF)
 S DXOK=$$PAT^BQITDGN(BQREF,BTGLOB,BDFN)
 ;
 ; if the person has already been identified with Diabetes
 NEW I,TEXT
 F I=1:1 S TEXT=$T(TAG+I) Q:TEXT=" Q"  D
 . S TDXNCN=$P(TEXT,";;",2) D
 .. I $$ATAG^BQITDUTL(BDFN,TDXNCN) S DXOK=0
 Q DXOK
 ;
TAG ;EP
 ;;Diabetes
 Q
