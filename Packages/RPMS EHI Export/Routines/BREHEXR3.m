BREHEXR3 ;GDIT/HS/BEE-BREH Custom Routine 4 Looping Calls
 ;;1.0;RPMS EHI EXPORT;**2**;Jun 15, 2023;Build 5
 ;
 Q
 ;
F65(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT,SFARRY) ;Return the next BLOOD INVENTORY (#65) entry for the patient
 ;
 ;^LRD(65,"E",7314,1,6769774.9075)=""
 ;                   6778884.99)=""
 NEW IEN,LIEN
 ;
 ;Check for DFN
 I +$G(DFN)=0 Q ""
 ;
 ;Get the previous entry
 S KEY=$G(KEY)
 S LIEN=+KEY
 ;
 K SFARRY
 ;
 ;Look for the next entry
 S IEN="",KEY=""
 ;
 ;Get next institution
 F  S LIEN=$O(^LRD(65,"E",DFN,LIEN)) Q:LIEN=""  D  Q:$D(SFARRY)
 . ;
 . NEW UIEN
 . ;
 . ;Get the patients next UIEN
 . S UIEN=0 F  S UIEN=$O(^LRD(65,"E",DFN,LIEN,UIEN)) Q:'UIEN  D
 .. S SFARRY(65.03,UIEN_","_LIEN_",")=""
 .. S SFARRY(65.03)=""
 ;
 ;Return if one found
 I $D(SFARRY) S KEY=LIEN,IEN=LIEN Q IEN
 ;
 S KEY="",IEN=""
 Q IEN
 ;
 ;
BLRA(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT,SFARRY) ;Return the next BLRAU ANTIMICROBIAL USE LOG 9009026.82 entry
 ;
 ;^BLRAULOG("C",DFN,DA(1),DA)=""
 ;
 ;                   6778884.99)=""
 NEW IEN,RIEN
 ;
 ;Check for DFN
 I +$G(DFN)=0 Q ""
 ;
 ;Get the previous entry
 S KEY=$G(KEY)
 S RIEN=+KEY
 ;
 K SFARRY
 ;
 ;Look for the next entry
 S IEN="",KEY=""
 ;
 ;Get next institution
 F  S RIEN=$O(^BLRAULOG("C",DFN,RIEN)) Q:RIEN=""  D  Q:$D(SFARRY)
 . ;
 . NEW UIEN
 . ;
 . ;Get the patients next UIEN
 . S UIEN=0 F  S UIEN=$O(^BLRAULOG("C",DFN,RIEN,UIEN)) Q:'UIEN  D
 .. S SFARRY(9009026.8212,UIEN_","_RIEN_",")=""
 .. S SFARRY(9009026.8212)=""
 ;
 ;Return if one found
 I $D(SFARRY) S KEY=RIEN,IEN=RIEN Q IEN
 ;
 S KEY="",IEN=""
 Q IEN
