BQITD04 ;PRXM/HC/ALA-CVD Highest Risk ; 10 Apr 2006  4:29 PM
 ;;1.1;ICARE MANAGEMENT SYSTEM;**3**;Apr 03, 2008
 ;
 Q
 ;
POP(BQARY,TGLOB) ; EP
 ;
 ;Description
 ;  Finds all patients who meet the criteria for CVD Highest Risk
 ;Input
 ;  BQARY - Array of taxonomies and other information
 ;  TGLOB - Global where data is to be stored
 ;          Structure:
 ;          TGLOB(DFN,"CRITERIA",criteria or taxonomy,visit or problem ien)=date/time
 ;Variables
 ;  TAX - Taxonomy name
 ;  NIT - Number of iterations
 ;  TMFRAME - Timeframe
 ;  FREF - File number to search
 ;  GREF - Global reference of FREF
 ;  TREF - Taxonomy temporary global
 ;
 NEW TDFN,TDXNCN,TPPGLOB,DXNN,TDFN
 S DXNN=$$GDXN^BQITUTL("CVD Highest Risk"),TDFN=""
 F  S TDFN=$O(^BQIPAT("AB",DXNN,TDFN)) Q:TDFN=""  D
 . S DA(1)=TDFN,DA=DXNN,DIK="^BQIPAT("_DA(1)_",20,"
 . D ^DIK
 S TPPGLOB=$NA(^TMP("TEMPD",UID))
 K @TPPGLOB
 ;
 ;  If already tagged as Diabetes, then valid for Highest Risk
 S TDFN="",TDXNCN=$$GDXN^BQITUTL("Diabetes")
 F  S TDFN=$O(^BQIPAT("AB",TDXNCN,TDFN)) Q:'TDFN  D
 . S @TPPGLOB@(TDFN)=1
 . S @TPPGLOB@(TDFN,"CRITERIA","Diabetes Tag")=""
 ;
 ;  Check for ESRD
 I $D(@BQARY) D
 . D POP^BQITDGN(.BQARY,.TGLOB,1)
 ;
 S DFN=0
 F  S DFN=$O(@TPPGLOB@(DFN)) Q:'DFN  M @TGLOB@(DFN)=@TPPGLOB@(DFN)
 I $D(@TPPGLOB) K @TPPGLOB
 ;
 ; If already CVD Known, then cannot be at highest risk
 NEW TDFN,TDXNCN
 S TDFN="",TDXNCN=$$GDXN^BQITUTL("CVD Known")
 F  S TDFN=$O(@TGLOB@(TDFN)) Q:'TDFN  D
 . ; If the patient has been tagged as CVD Known, check if they had
 . ; previously been tagged as CVD Highest Risk as well has being tagged
 . ; now and remove the CVD Highest Risk
 . I $D(^BQIPAT("AB",TDXNCN,TDFN)) D
 .. NEW DXNN
 .. S DXNN=$$GDXN^BQITUTL("CVD Highest Risk")
 .. NEW DA,DIK
 .. S DA(1)=TDFN,DA=DXNN,DIK="^BQIPAT("_DA(1)_",20,"
 .. D ^DIK
 .. K @TGLOB@(TDFN)
 ;
 Q
 ;
PAT(DEF,BTGLOB,BDFN) ; EP -- By patient
 NEW DXOK,BQDXN,TGLOB,BQREF,TDXNCN,TDXNCN1,DXNN
 ; Check if patient is now CVD Known and clean up CVD Highest Risk
 S DXOK=0
 S DXNN=$$GDXN^BQITUTL("CVD Highest Risk"),TDXNCN=$$GDXN^BQITUTL("CVD Known")
 I $D(^BQIPAT("AB",TDXNCN,BDFN)) D  Q 0
 . NEW DA,DIK
 . S DA(1)=BDFN,DA=DXNN,DIK="^BQIPAT("_DA(1)_",20,"
 . D ^DIK
 ;
 S BQDXN=$$GDXN^BQITUTL(DEF)
 S BQREF="BQIRY"
 D GDF^BQITUTL(BQDXN,BQREF)
 ;
 S TDXNCN1=$$GDXN^BQITUTL("Diabetes")
 I $D(^BQIPAT("AB",TDXNCN1,BDFN)) D
 . S DXOK=1,@BTGLOB@(BDFN,"CRITERIA","Diabetes Tag")=""
 ;
 I $$PAT^BQITDGN(BQREF,BTGLOB,BDFN,1) S DXOK=1
 Q DXOK
