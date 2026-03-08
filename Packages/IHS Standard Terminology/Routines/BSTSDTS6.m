BSTSDTS6 ;GDIT/HS/BEE-Standard Terminology DTS Calls/Processing ; 5 Nov 2012  9:53 AM
 ;;2.0;IHS STANDARD TERMINOLOGY;**4,7**;Dec 01, 2016;Build 8
 ;
 Q
 ;
 ;GDIT/HS/BEE;FEATURE#112749;New subset handling. New OOD, CLR, UPD tags
 ;
OOD(NMID) ;Mark codeset subsets as out of date
 ;
 I 'NMID Q
 ;
 NEW NMIEN,SBIEN
 ;
 ;Get internal codeset IEN
 S NMIEN=$O(^BSTS(9002318.1,"B",NMID,"")) Q:'NMIEN
 ;
 ;Mark subsets as out of date
 S SBIEN=0 F  S SBIEN=$O(^BSTS(9002318.1,NMIEN,2,SBIEN)) Q:'SBIEN  D
 . ;
 . NEW UPD,ERR,DA,IENS
 . ;
 . S DA(1)=NMIEN,DA=SBIEN,IENS=$$IENS^DILF(.DA)
 . S UPD(9002318.12,IENS,.04)=1
 . D FILE^DIE("","UPD","ERR")
 ;
 Q
 ;
UPD(NMID,SLIST) ;Update subsets in BSTS CODESETS
 ;
 I '$G(NMID) Q
 I $G(SLIST)="" Q
 ;
 NEW NMIEN,II,NODE,SUBSET,SUBID,SUBTYP,SIEN
 ;
 ;Get internal codeset IEN
 S NMIEN=$O(^BSTS(9002318.1,"B",NMID,"")) Q:'NMIEN
 ;
 ;Loop through and update
 S II="" F  S II=$O(@SLIST@(II)) Q:II=""  D
 . NEW UPD,ERR,DA,IENS
 . ;
 . S NODE=@SLIST@(II)
 . ;
 . ;Get the subset
 . S SUBSET=$P(NODE,U) Q:SUBSET=""
 . ;
 . ;Get the subset id
 . S SUBID=$P(NODE,U,2) Q:SUBID=""
 . ;
 . ;Get the subset type
 . S SUBTYP=$P(NODE,U,3) Q:SUBTYP=""
 . ;
 . ;Look for existing entry
 . S SIEN=$O(^BSTS(9002318.1,NMIEN,2,"C",SUBSET,""))
 . ;
 . ;Create new entry if necessary
 . I SIEN="" D  Q:'SIEN
 .. NEW DA,X,DIC,Y,DLAYGO
 .. S DIC(0)="L",DA(1)=NMIEN
 .. S DIC="^BSTS(9002318.1,"_DA(1)_",2,"
 .. S X=SUBSET
 .. K DO,DD D FILE^DICN
 .. S SIEN=0 I +$G(Y)>0 S SIEN=+Y
 . ;
 . ;Update remaining fields
 . S DA(1)=NMIEN,DA=SIEN,IENS=$$IENS^DILF(.DA)
 . S UPD(9002318.12,IENS,.02)=SUBID
 . S UPD(9002318.12,IENS,.03)=SUBTYP
 . S UPD(9002318.12,IENS,.04)="0"
 . D FILE^DIE("","UPD","ERR")
 ;
 ;Now clear out any subsets that were not updated (no longer exist)
 S SIEN=0 F  S SIEN=$O(^BSTS(9002318.1,NMIEN,2,SIEN)) Q:'SIEN  D
 . NEW OOD,DA,DIK
 . ;
 . ;Quit if not out of date
 . I $P($G(^BSTS(9002318.1,NMIEN,2,SIEN,0)),U,4)'=1 Q
 . ;
 . ;Remove the entry
 . S DA(1)=NMIEN,DA=SIEN
 . S DIK="^BSTS(9002318.1,"_DA(1)_",2,"
 . D ^DIK
 ;
 Q
 ;
SBINFO(SUBSET,NMID) ;Return subset information
 ;
 NEW NMIEN,SBTYP,SBID,SIEN,SNODE
 ;
 I $G(SUBSET)="" Q "0^P"
 I $G(NMID)'>0 Q "0^P"
 ;
 ;Get internal codeset IEN
 S NMIEN=$O(^BSTS(9002318.1,"B",NMID,"")) Q:'NMIEN "0^P"
 ;
 ;Find the subset
 S SIEN=$O(^BSTS(9002318.1,NMIEN,2,"C",SUBSET,"")) Q:'SIEN "0^P"
 ;
 ;Retrieve the subset information
 S SNODE=$G(^BSTS(9002318.1,NMIEN,2,SIEN,0))
 S SBID=$P(SNODE,U,2)
 S SBTYP=$P(SNODE,U,3)
 I (SBID="")!(SBTYP="") Q "0^P"
 Q SBID_U_SBTYP
 ;
ISA(GL,NMID,CVRSN,CONCDA,BSTSC,INMID) ;Save SNOMED ISA
 ;
 ;Called by UPDATE^BSTSDTS0
 ;
 ;Clear out existing entries
 D
 . NEW ISA
 . S ISA=0 F  S ISA=$O(^BSTS(9002318.4,CONCDA,5,ISA)) Q:'ISA  D
 .. NEW DA,DIK
 .. S DA(1)=CONCDA,DA=ISA
 .. S DIK="^BSTS(9002318.4,"_DA(1)_",5," D ^DIK
 ;
 ;Now add the new entries
 I $D(@GL@("ISA"))>1 D
 . ;
 . N ISACT
 . S ISACT="" F  S ISACT=$O(@GL@("ISA",ISACT)) Q:ISACT=""  D
 .. ;
 .. ;Save/update each ISA entry
 .. ;
 .. ;First see if IsA code saved
 .. N DAISA,DA,IENS,DTSID,ISACD,NEWISA,DIC,Y,X,DLAYGO
 .. S ISACD=$P($G(@GL@("ISA",ISACT,0)),U) Q:ISACD=""
 .. S (NEWISA,DAISA)=$O(^BSTS(9002318.4,"D",NMID,ISACD,""))
 .. ;
 .. ;Not found - add partial entry to concept
 .. I DAISA="" S DAISA=$$NEWC^BSTSDTS0()
 .. S BSTSC(9002318.4,DAISA_",",.08)=$G(ISACD)
 .. I NEWISA="" S BSTSC(9002318.4,DAISA_",",.03)="P"
 .. S BSTSC(9002318.4,DAISA_",",.07)=INMID ;Code Set
 .. S BSTSC(9002318.4,DAISA_",",.04)=CVRSN ;Version
 .. I NEWISA="" S BSTSC(9002318.4,DAISA_",",.11)="N" ;Up to Date
 .. I NEWISA="" S BSTSC(9002318.4,DAISA_",",.12)=DT ;Update date
 .. S BSTSC(9002318.4,DAISA_",",1)=$G(@GL@("ISA",ISACT,1))
 .. ;
 .. ;Now add IsA pointer in current conc entry
 .. S DA(1)=CONCDA
 .. S DIC(0)="L",DIC="^BSTS(9002318.4,"_DA(1)_",5,",X=DAISA
 .. S DLAYGO=9002318.45 D ^DIC I +Y<0 Q
 .. ;
 .. ;Save add IsA fields
 .. S DA(1)=CONCDA,DA=+Y,IENS=$$IENS^DILF(.DA)
 .. S BSTSC(9002318.45,IENS,".02")=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("ISA",ISACT,1,0)),U,2))
 ;
 Q
 ;
CHILD(GL,NMID,CVRSN,CONCDA,BSTSC,INMID) ;Save children Children (subconcepts)
 ;
 ;Called by UPDATE^BSTSDTS0
 ;
 ;Clear out existing entries
 D
 . NEW CHD
 . S CHD=0 F  S CHD=$O(^BSTS(9002318.4,CONCDA,6,CHD)) Q:'CHD  D
 .. NEW DA,DIK
 .. S DA(1)=CONCDA,DA=CHD
 .. S DIK="^BSTS(9002318.4,"_DA(1)_",6," D ^DIK
 ;
 ;Now add the new entries
 I $D(@GL@("SUBC"))>1 D
 . ;
 . N SUBCCT
 . S SUBCCT="" F  S SUBCCT=$O(@GL@("SUBC",SUBCCT)) Q:SUBCCT=""  D
 .. ;
 .. ;Save/update each SubConcept entry
 .. ;
 .. ;First see if Subconcept code saved
 .. N DASUBC,DA,IENS,DTSID,SUBCCD,NEWSUBC,DIC,Y,X,DLAYGO
 .. S SUBCCD=$P($G(@GL@("SUBC",SUBCCT,0)),U) Q:SUBCCD=""
 .. S (NEWSUBC,DASUBC)=$O(^BSTS(9002318.4,"D",NMID,SUBCCD,""))
 .. ;
 .. ;Not found - add partial entry to conc file
 .. I DASUBC="" S DASUBC=$$NEWC^BSTSDTS0()
 .. S BSTSC(9002318.4,DASUBC_",",.08)=$G(SUBCCD)
 .. I NEWSUBC="" S BSTSC(9002318.4,DASUBC_",",.03)="P"
 .. S BSTSC(9002318.4,DASUBC_",",.07)=INMID ;Code Set
 .. S BSTSC(9002318.4,DASUBC_",",.04)=CVRSN ;Version
 .. I NEWSUBC="" S BSTSC(9002318.4,DASUBC_",",.11)="N" ;Up to Date
 .. I NEWSUBC="" S BSTSC(9002318.4,DASUBC_",",.12)=DT ;Update Date 
 .. S BSTSC(9002318.4,DASUBC_",",1)=$G(@GL@("SUBC",SUBCCT,1))
 .. ;
 .. ;Now add SUBC pointer in current conc
 .. S DA(1)=CONCDA
 .. S DIC(0)="L",DIC="^BSTS(9002318.4,"_DA(1)_",6,",X=DASUBC
 .. S DLAYGO=9002318.46 D ^DIC I +Y<0 Q
 .. ;
 .. ;Save additional SUBC fields
 .. S DA(1)=CONCDA,DA=+Y,IENS=$$IENS^DILF(.DA)
 .. S BSTSC(9002318.46,IENS,".02")=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("SUB",SUBCCT,1,0)),U,2))
 ;
 Q
