BCCDUTL2 ;GDIT/HS/BEE-BCCD Utilities routine 2 ; 08 Apr 2013  9:28 AM
 ;;2.0;CCDA;**1,2,4,5**;Aug 12, 2020;Build 204
 ;
 Q
 ;
SUBLST(SUBSET) ;EP - Return a list of entries in a subset
 ;
 NEW CNT,VAR,STS,RES
 ;
 S STS=$$SUBLST^BSTSAPI("VAR",SUBSET_"^^")
 S CNT=0,RES="" F  S CNT=$O(VAR(CNT)) Q:CNT=""  D
 . NEW CONC
 . S CONC=$P($G(VAR(CNT)),"^")
 . Q:CONC=""
 . S RES=RES_$S(RES="":"",1:",")_CONC
 Q RES
 ;
 ;GDIT/HS/BEE;FEATURE#76183;PBI#82985;02/09/22;Filter out particular stop codes
ELGVST(VIEN,SCSKIP) ;Return if an eligible visit by stop code
 ;
 ;Returns 1 if eligible visit, otherwise 0
 ;
 ;Validate visit
 I +$G(VIEN)=0 Q 0
 ;
 ;Verify list was passed in - if no list return eligible
 S SCSKIP=$G(SCSKIP) Q:SCSKIP="" 1
 S SCSKIP=","_SCSKIP_","
 ;
 NEW SC,HL,ELG,CL,CD
 ;
 ;Get HL
 S ELG=1
 S HL=$$GET1^DIQ(9000010,VIEN_",",.22,"I") I HL]"" D  Q ELG
 . ;
 . ;Get STOP CODE
 . S SC=$$GET1^DIQ(44,HL_",",8,"I") Q:SC=""
 . S SC=$$GET1^DIQ(40.7,SC_",",1,"E") Q:SC=""
 . ;
 . ;Return 0 if stop code in list
 . I SCSKIP[(","_SC_",") S ELG=0 Q
 ;
 ;Check CLINIC
 S CL=$$GET1^DIQ(9000010,VIEN_",",.08,"I") Q:CL="" ELG
 S CD=$$GET1^DIQ(40.7,CL_",",1,"I") Q:CD="" ELG
 I SCSKIP[(","_CD_",") S ELG=0 Q ELG
 ;
 Q 1
 ;
CNCLKP(OUT,IN) ; Similar to CNCLKP^BSTSAPI but only gets what BCCD needs
 N SEARCH,NMID,LOCAL,RESULT,BSTSD,BSTSWS,BSTSR
 K @OUT
 S SEARCH=$P(IN,U) I SEARCH="" Q "0^Invalid Concept Id"
 S NMID=$P(IN,U,2) S:NMID="" NMID=36 S:NMID=30 NMID=36
 S LOCAL=$P(IN,U,4),LOCAL=$S(LOCAL=2:"",1:"1")
 ;
 S BSTSWS("SEARCH")=SEARCH
 S BSTSWS("STYPE")="F"
 S BSTSWS("NAMESPACEID")=NMID
 S BSTSWS("SUBSET")=""
 S BSTSWS("SNAPDT")=""
 S BSTSWS("INDATE")=""
 S BSTSWS("MAXRECS")=""
 S BSTSWS("BCTCHRC")=""
 S BSTSWS("BCTCHCT")=""
 S BSTSWS("RET")="PSCBIXAV"
 S BSTSWS("DAT")=""
 S BSTSWS("MPPRM")=""
 ;
 S BSTSR=1
 S BSTSD=$$CNC^BSTSLKP("RESULT",.BSTSWS)
 ;If local search and no results try doing DTS lookup
 I $D(RESULT)<10 S BSTSR=$$CNCSR^BSTSWSV("RESULT",.BSTSWS,"") S:+BSTSR $P(BSTSR,U)=2
 ;Get the detail for the record
 S BSTSD=0
 I $D(RESULT)>1 D
 . S BSTSWS("STYPE")="F"
 . S BSTSD=$$DETAIL(OUT,.BSTSWS,.RESULT)
 S $P(BSTSR,U)=$S(BSTSD=0:0,(+BSTSR)>0:+BSTSR,1:1)
 Q BSTSR
 ;
DETAIL(OUT,BSTSWS,RESULT) ; Similar to DETAIL^BSTSCDET but only gets what BCCD needs
 N XNMID,RET,NCNT,CNT,CONC,CIEN,RDT,CNT,DA,SBIEN,BCNT,TYP,TRM
 S XNMID=$G(BSTSWS("NAMESPACEID"))
 S RET=$G(BSTSWS("RET"))
 S NCNT=0,CNT="" F  S CNT=$O(RESULT(CNT)) Q:CNT=""  D
 . S CONC=$P(RESULT(CNT),U)
 . S CIEN=$$CIEN^BSTSLKP(CONC,XNMID) Q:CIEN=""
 . S RDT=$$GET1^DIQ(9002318.4,CIEN,".06","I")
 . S NCNT=NCNT+1
 . S @OUT@(NCNT,"XRDT")=RDT
 . S (BCNT,SBIEN)=0 F  S SBIEN=$O(^BSTS(9002318.4,CIEN,4,SBIEN)) Q:'SBIEN  D
 .. S DA(1)=CIEN,DA=SBIEN,IENS=$$IENS^DILF(.DA)
 .. S SUB=$$GET1^DIQ(9002318.44,IENS,".01","I") Q:SUB=""
 .. S BCNT=BCNT+1
 .. S @OUT@(NCNT,"SUB",BCNT,"SUB")=SUB
 . S SCNT=0,TIEN="" F  S TIEN=$O(^BSTS(9002318.3,"C",XNMID,CIEN,TIEN),-1) Q:TIEN=""  D
 .. S TYP=$$GET1^DIQ(9002318.3,TIEN_",",.09,"I") Q:TYP=""
 .. S TRM=$$GET1^DIQ(9002318.3,TIEN_",",1) Q:TRM=""
 .. ;Preferred term
 .. I RET["P",TYP="P" S @OUT@(NCNT,"PRE","TRM")=TRM
 Q NCNT
 ;
TRIAFFDT(IEN,FLD,TRIAFF) ; Get the tribal affiliation date/time from the AUDIT file
 ; IEN=DFN,FLD=1108 for TRIBAL AFFILIATION
 ; IEN=DFN_","_SubfileIEN,FLD="4301,.01" for OTHER TRIBE
 Q:$G(IEN)=""
 Q:$G(FLD)=""
 N AUDIEN,NEWCODE,QUIT,DATE
 S AUDIEN="",QUIT="",DATE=""
 F  S AUDIEN=$O(^DIA(9000001,"B",IEN,AUDIEN),-1) Q:AUDIEN=""  D  Q:DATE'=""
 . I $P($G(^DIA(9000001,AUDIEN,0)),"^",3)=FLD D  Q
 .. I $G(TRIAFF)'="" S NEWCODE=$P($G(^DIA(9000001,AUDIEN,3.1)),"^") Q:NEWCODE=""!(NEWCODE'=TRIAFF)
 .. S DATE=$P($G(^DIA(9000001,AUDIEN,0)),"^",2)
 Q DATE
