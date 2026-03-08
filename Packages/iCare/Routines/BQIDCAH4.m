BQIDCAH4 ;GDIT/HS/ALA-Ad Hoc continued ; 10 Dec 2012  3:23 PM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**1,3**;Mar 01, 2021;Build 32
 ;
PROB(FGLOB,TGLOB,PROB,PROBTX,FDT,TDT,MPARMS) ;EP - Problems
 NEW PRPT,CT,IEN,PB,PCT,PTAX,TREF
 I $G(PROBTX)'="" D
 . S TREF=$NA(MPARMS("PROB"))
 . K @TREF
 . S PTAX=$P(@("^"_$P(PROBTX,";",2)_$P(PROBTX,";",1)_",0)"),"^",1)
 . D BLD^BQITUTL(PTAX,TREF)
 ;
 I PROP="!" D
 . I $D(MPARMS("PROB")) S PROB="" F  S PROB=$O(MPARMS("PROB",PROB)) Q:PROB=""  D PRBB
 . I '$D(MPARMS("PROB")) D PRBB
 I PROP="&" D
 . K PRPT
 . S PROB="",CT=0 F  S PROB=$O(MPARMS("PROB",PROB)) Q:PROB=""  D PRBB S CT=CT+1
 . S IEN=""
 . F  S IEN=$O(PRPT(IEN)) Q:IEN=""  D
 .. S PCT=0,PB=""
 .. F  S PB=$O(PRPT(IEN,PB)) Q:PB=""  S PCT=PCT+1
 .. I PCT=CT S @TGLOB@(IEN)="" D  Q
 ... F  S PB=$O(PRPT(IEN,PB)) Q:PB=""  S PIEN=PRPT(IEN,PB),@CRIT@("PROB",IEN,PIEN)=""
 ;
 Q
 ;
PRBB ; Problem
 NEW DFN,IEN
 S TDT=$S(TDT'="":TDT,1:DT)
 ; If 'from' data global is populated, use those entries to filter by
 I $G(FGLOB)'="" D  Q
 . NEW IEN,PIEN,PB,STAT,VSDTM
 . S IEN=""
 . F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  D
 .. I $O(^AUPNPROB("AC",IEN,""))="" Q
 .. S PIEN=""
 .. F  S PIEN=$O(^AUPNPROB("AC",IEN,PIEN)) Q:PIEN=""  D
 ... S PB=$P($G(^AUPNPROB(PIEN,0)),U,1) I PB="" Q
 ... I $D(MPARMS("PROB")),'$D(MPARMS("PROB",PB)) Q
 ... I '$D(MPARMS("PROB")),PB'=PROB Q
 ... S STAT=$P($G(^AUPNPROB(PIEN,0)),U,12) I STAT="" Q
 ... I PRSTAT'="",STAT'=PRSTAT Q
 ... I $D(MPARMS("PRSTAT")),'$D(MPARMS("PRSTAT",STAT)) Q
 ... S VSDTM=$$PROB^BQIUL1(PIEN)
 ... I FDT'="",VSDTM<FDT!(VSDTM>TDT) Q
 ... I PROP="!" S @TGLOB@(IEN)="",@CRIT@("PROB",IEN,PIEN)="" Q
 ... I PROP="&" S PRPT(IEN,PROB)=PIEN
 ;
 ; if no additional entries to filter by, build list by problem only to filter on
 NEW IEN,DFN,VSDTM,STAT
 S IEN=""
 F  S IEN=$O(^AUPNPROB("B",PROB,IEN)) Q:IEN=""  D
 . S DFN=$P($G(^AUPNPROB(IEN,0)),U,2) I DFN="" Q
 . S VSDTM=$$PROB^BQIUL1(IEN)
 . I FDT'="",VSDTM<FDT!(VSDTM>TDT) Q
 . S STAT=$P(^AUPNPROB(IEN,0),U,12) I STAT="" Q
 . I PRSTAT'="",STAT'=PRSTAT Q
 . I $D(MPARMS("PRSTAT")),'$D(MPARMS("PRSTAT",STAT)) Q
 . I DFN'="",PROP="!" S @TGLOB@(DFN)="",@CRIT@("PROB",DFN,IEN)="" Q
 . I DFN'="",PROP="&" S PRPT(DFN,PROB)=IEN
 ;
 Q
 ;
NRV(FGLOB,TGLOB,FDT,TDT) ;EP - problems not reviewed
 NEW DFN,BGT,EDT,OK
 I $G(FGLOB)="" D
 . S DFN=0
 . F  S DFN=$O(^AUPNPAT(DFN)) Q:'DFN  D
 .. I $G(^AUPNPAT(DFN,0))="" Q
 .. I '$D(^AUPNVRUP("AA",DFN,1)) S @TGLOB@(DFN)="" Q
 .. S OK=0
 .. I FDT'="" D  Q
 ... S BGT=(9999999-TDT)-.0001,EDT=9999999-FDT
 ... F  S BGT=$O(^AUPNVRUP("AA",DFN,1,BGT)) Q:BGT=""!(BGT\1>EDT)  S OK=1
 .. I 'OK S @TGLOB@(DFN)=""
 ;
 I $G(FGLOB)'="" D
 . S DFN=""
 . F  S DFN=$O(@FGLOB@(DFN)) Q:DFN=""  D
 .. I '$D(^AUPNVRUP("AA",DFN,1)) S @TGLOB@(DFN)="" Q
 .. S OK=0
 .. I FDT'="" D
 ... S BGT=(9999999-TDT)-.0001,EDT=9999999-FDT
 ... F  S BGT=$O(^AUPNVRUP("AA",DFN,1,BGT)) Q:BGT=""!(BGT\1>EDT)  S OK=1
 .. I 'OK S @TGLOB@(DFN)=""
 Q
 ;
VCHK ;EP
 I '$D(^AUPNVRUP("AC",DFN)) S @TGLOB@(DFN)="" Q
 I '$D(^AUPNVRUP("AA",DFN,1)) S @TGLOB@(DFN)=""
 Q
 ;
NAC(FGLOB,TGLOB,FDT,TDT) ;EP - No active problems
 NEW DFN
 I $G(FGLOB)="" D
 . S DFN=0
 . F  S DFN=$O(^AUPNPAT(DFN)) Q:'DFN  D
 .. I $G(^AUPNPAT(DFN,0))="" Q
 .. I $D(^AUPNVRUP("AA",DFN,3)) D
 ... I FDT'="" D  Q
 .... S BGT=(9999999-TDT)-.0001,EDT=9999999-FDT
 .... F  S BGT=$O(^AUPNVRUP("AA",DFN,3,BGT)) Q:BGT=""!(BGT\1>EDT)  S @TGLOB@(DFN)=""
 ... S @TGLOB@(DFN)=""
 ;
 I $G(FGLOB)'="" D
 . S DFN=""
 . F  S DFN=$O(@FGLOB@(DFN)) Q:DFN=""  D
 .. I $D(^AUPNVRUP("AA",DFN,3)) D
 ... I FDT'="" D  Q
 .... S BGT=(9999999-TDT)-.0001,EDT=9999999-FDT
 .... F  S BGT=$O(^AUPNVRUP("AA",DFN,3,BGT)) Q:BGT=""!(BGT\1>EDT)  S @TGLOB@(DFN)=""
 ... S @TGLOB@(DFN)=""
 Q
 ;
NDC(FGLOB,TGLOB) ;EP - No documented problems
 NEW DFN
 I $G(FGLOB)="" D
 . S DFN=0
 . F  S DFN=$O(^AUPNPAT(DFN)) Q:'DFN  D
 .. I $G(^AUPNPAT(DFN,0))="" Q
 .. I '$D(^AUPNPROB("AC",DFN)) S @TGLOB@(DFN)=""
 I $G(FGLOB)'="" D
 . S DFN=""
 . F  S DFN=$O(@FGLOB@(DFN)) Q:DFN=""  D
 .. I '$D(^AUPNPROB("AC",DFN)) S @TGLOB@(DFN)=""
 Q
 ;
MND(FGLOB,TGLOB) ;EP - No documented medications
 NEW DFN
 I $G(FGLOB)="" D
 . S DFN=0
 . F  S DFN=$O(^AUPNPAT(DFN)) Q:'DFN  D
 .. I $G(^AUPNPAT(DFN,0))="" Q
 .. I '$D(^AUPNVMED("AC",DFN)) S @TGLOB@(DFN)=""
 I $G(FGLOB)'="" D
 . S DFN=""
 . F  S DFN=$O(@FGLOB@(DFN)) Q:DFN=""  D
 .. I '$D(^AUPNVMED("AC",DFN)) S @TGLOB@(DFN)=""
 Q
 ;
NAM(FGLOB,TGLOB,FDT,TDT) ;EP - no active medications
 NEW DFN
 I $G(FGLOB)="" D
 . S DFN=0
 . F  S DFN=$O(^AUPNPAT(DFN)) Q:'DFN  D
 .. I $G(^AUPNPAT(DFN,0))="" Q
 .. I $D(^AUPNVRUP("AA",DFN,7)) D
 ... I FDT'="" D  Q
 .... S BGT=(9999999-TDT)-.0001,EDT=9999999-FDT
 .... F  S BGT=$O(^AUPNVRUP("AA",DFN,7,BGT)) Q:BGT=""!(BGT\1>EDT)  S @TGLOB@(DFN)=""
 ... S @TGLOB@(DFN)=""
 ;
 I $G(FGLOB)'="" D
 . S DFN=""
 . F  S DFN=$O(@FGLOB@(DFN)) Q:DFN=""  D
 .. I $D(^AUPNVRUP("AA",DFN,7)) D
 ... I FDT'="" D  Q
 .... S BGT=(9999999-TDT)-.0001,EDT=9999999-FDT
 .... F  S BGT=$O(^AUPNVRUP("AA",DFN,7,BGT)) Q:BGT=""!(BGT\1>EDT)  S @TGLOB@(DFN)=""
 ... S @TGLOB@(DFN)=""
 Q
 ;
MLR(FGLOB,TGLOB,FDT,TDT) ;EP - medications not reviewed
 NEW DFN,BGT,EDT,OK
 I $G(FGLOB)="" D
 . S DFN=0
 . F  S DFN=$O(^AUPNPAT(DFN)) Q:'DFN  D
 .. I $G(^AUPNPAT(DFN,0))="" Q
 .. I '$D(^AUPNVRUP("AA",DFN,5)) S @TGLOB@(DFN)="" Q
 .. S OK=0
 .. I FDT'="" D  Q
 ... S BGT=(9999999-TDT)-.0001,EDT=9999999-FDT
 ... F  S BGT=$O(^AUPNVRUP("AA",DFN,5,BGT)) Q:BGT=""!(BGT\1>EDT)  S OK=1
 .. I 'OK S @TGLOB@(DFN)=""
 ;
 I $G(FGLOB)'="" D
 . S DFN=""
 . F  S DFN=$O(@FGLOB@(DFN)) Q:DFN=""  D
 .. I '$D(^AUPNVRUP("AA",DFN,5)) S @TGLOB@(DFN)="" Q
 .. S OK=0
 .. I FDT'="" D
 ... S BGT=(9999999-TDT)-.0001,EDT=9999999-FDT
 ... F  S BGT=$O(^AUPNVRUP("AA",DFN,5,BGT)) Q:BGT=""!(BGT\1>EDT)  S OK=1
 .. I 'OK S @TGLOB@(DFN)=""
 Q
 ;
EMP(FGLOB,TGLOB,EMPL,MPARMS) ;EP - Employer search
 I $G(TGLOB)="" Q
 I $G(EMPL)'="" D
 . S EMPL=""
 . F  S EMPL=$O(^BQI(90508,1,18,"B",EMPL)) Q:EMPL=""  D EMD
 Q
 ;
EMD ;EP
 NEW IEN,DFN
 I $G(FGLOB)'="" D
 . S IEN=""
 . F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  I $P($G(^AUPNPAT(IEN,0)),U,19)=EMPL S @TGLOB@(IEN)=""
 ;
 I $G(FGLOB)="" D
 . S DFN=""
 . F  S DFN=$O(^AUPNPAT("AF",EMPL,DFN)) Q:DFN=""  S @TGLOB@(DFN)=""
 Q
 ;
PNL(FGLOB,TGLOB,PLIDEN,MPARMS) ;EP - Panel search
 I $G(TGLOB)="" Q
 I PLIDEN]"" D PLD
 I $D(MPARMS("PLIDEN")) S PLIDEN="" F  S PLIDEN=$O(MPARMS("PLIDEN",PLIDEN)) Q:PLIDEN=""  D PLD
 Q
 ;
PLD ;EP
 NEW OWNR,PLNME,DA,IENS,PLIEN
 S OWNR=$P(PLIDEN,$C(26),1),PLNME=$P(PLIDEN,$C(26),2)
 S DA="",DA(1)=OWNR,IENS=$$IENS^DILF(.DA)
 S PLIEN=$$FIND1^DIC(90505.01,IENS,"X",PLNME,"","","ERROR")
 I PLIEN="" Q
 I $G(FGLOB)'="" D
 . S IEN=""
 . F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  D
 .. I $D(^BQICARE(OWNR,1,PLIEN,40,IEN)),$P(^BQICARE(OWNR,1,PLIEN,40,IEN,0),U,2)'="R" S @TGLOB@(IEN)=""
 ;
 NEW DFN,IEN
 I $G(FGLOB)="" D
 . S DFN=0
 . F  S DFN=$O(^BQICARE(OWNR,1,PLIEN,40,DFN)) Q:'DFN  D
 .. I $P(^BQICARE(OWNR,1,PLIEN,40,DFN,0),U,2)="R" Q
 .. S @TGLOB@(DFN)=""
 Q
 ;
HFCT(FGLOB,TGLOB,HFTX,HFCAT,HFACT,FDT,TDT,HFNOT,HFOP,MPARMS) ;EP - Health Factors
 ; NGLOB = Not have global
 ; HFGLOB = Operand global
 S NGLOB=$NA(^TMP("BQIDCHFAC",$J)) K @NGLOB
 S HFGLOB=$NA(^TMP("BQIHFOP",$J)) K @HFGLOB
 S HCGLOB=$NA(^TMP("BQIHFCOP",$J)) K @HCGLOB
 I $G(TGLOB)="" Q
 ;
 S TTT=0,TCT=0
 ; Taxonomy
 I $G(HFTX)'="" D
 . S TREF=$NA(MPARMS("HFACT"))
 . K @TREF
 . S PTAX=$P(@("^"_$P(HFTX,";",2)_$P(HFTX,";",1)_",0)"),"^",1)
 . D BLD^BQITUTL(PTAX,TREF)
 ;
 ; Single Category
 I $G(HFCAT)'="" D
 . I HFCAT?.N S HFCNM=$P(^AUTTHF(HFCAT,0),"^",1)
 . I HFCAT'?.N S HFCNM=HFCAT
 . D HFCY(HFCNM)
 ;
 ; Multiple categories
 I $O(MPARMS("HFCAT",""))'="" D
 . S HFCAT="" F  S HFCAT=$O(MPARMS("HFCAT",HFCAT)) Q:HFCAT=""  D
 .. I HFCAT?.N S HFCNM=$P(^AUTTHF(HFCAT,0),"^",1)
 .. I HFCAT'?.N S HFCNM=HFCAT
 .. S TTT=TTT+1
 .. D HFCY(HFCNM)
 ;
 S TCT=0
 I $G(HFACT)'="" D
 . S TCT=TCT+1
 . D HF(HFACT)
 ;
 I $D(MPARMS("HFACT"))>0 D
 . S HFACT="" F  S HFACT=$O(MPARMS("HFACT",HFACT)) Q:HFACT=""  S TCT=TCT+1 D HF(HFACT)
 ;
 ; If selection is 'OR', all found are good
 I HFOP="!"&(HFCOP="!") D
 . S IEN=""
 . F  S IEN=$O(@HFGLOB@(IEN)) Q:IEN=""  S @TGLOB@(IEN)=""
 ;
 ; if selection is 'AND' a patient must have all selections to be good
 I HFOP="&" D
 . NEW IEN,LCT,LB
 . S IEN="" F  S IEN=$O(@HFGLOB@(IEN)) Q:IEN=""  D
 .. S LCT=0,LB=""
 .. F  S LB=$O(@HFGLOB@(IEN,LB)) Q:LB=""  S LCT=LCT+1
 .. ; If patient count not equal to total count, do not include
 .. I LCT'=TCT K @CRIT@("HFACT",IEN) Q
 .. ; if patient count equal to total count include
 .. I LCT=TCT,'HFNOT S @TGLOB@(IEN)="" Q
 .. I LCT=TCT,HFNOT S @NGLOB@(IEN)="" K @CRIT@("HFACT",IEN)
 ;
 I HFCOP="&" D
 . S IEN="" F  S IEN=$O(@HCGLOB@(IEN)) Q:IEN=""  D
 .. S CCT=0,HC=""
 .. F  S HC=$O(@HCGLOB@(IEN,HC)) Q:HC=""  S CCT=CCT+1
 .. I CCT'=TTT K @CRIT@("HFACT",IEN) Q
 .. I CCT=TTT,'HFNOT S @TGLOB@(IEN)="" Q
 .. I CCT=TTT,HFNOT S @NGLOB@(IEN)="" K @CRIT@("HFACT",IEN)
 ;
 I HFNOT,$G(FGLOB)'="" D
 . S IEN="" F  S IEN=$O(@FGLOB@(IEN)) Q:IEN=""  D
 .. ;I $G(@NGLOB@(IEN))'=TCT S @TGLOB@(IEN)=""
 .. I HFOP="!",$G(@NGLOB@(IEN))="" S @TGLOB@(IEN)="" Q
 .. I HFOP="&",$G(@NGLOB@(IEN))'=TCT S @TGLOB@(IEN)=""
 I HFNOT,$G(FGLOB)="" D
 . S IEN=0 F  S IEN=$O(^AUPNPAT(IEN)) Q:'IEN  D
 .. I HFOP="!",$G(@NGLOB@(IEN))="" S @TGLOB@(IEN)="" Q
 .. I HFOP="&",$G(@NGLOB@(IEN))'=TCT S @TGLOB@(IEN)=""
 K @NGLOB,@HFGLOB
 Q
 ;
HF(HF) ;EP
 ; Check for dates/timeframe for search
 NEW DFN,IEN,BGT,BDT,ENT,VIS,VSDTM
 S TDT=$S(TDT'="":TDT,1:DT)
 ; if already a list of patients passed in, only check for those patients
 I $G(FGLOB)'="" D  Q
 . NEW IEN
 . S IEN=""
 . F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  D
 .. ; if timeframe was Ever
 .. I FDT="" D
 ... S BDT=""
 ... F  S BDT=$O(^AUPNVHF("AA",IEN,HF,BDT)) Q:BDT=""  D HFDT
 .. ; if timeframe or specific date range
 .. I FDT'="" D
 ... S BGT=9999999-FDT,ENT=9999999-TDT,BDT=ENT-1
 ... F  S BDT=$O(^AUPNVHF("AA",IEN,HF,BDT)) Q:BDT=""!(BDT>BGT)  D HFDT
 ;
 ; if no list of patients passed in, look at all patients
 S IEN=""
 F  S IEN=$O(^AUPNVHF("B",HF,IEN),-1) Q:IEN=""  D
 . I $G(^AUPNVHF(IEN,0))="" Q
 . S DFN=$P($G(^AUPNVHF(IEN,0)),U,2),VIS=$P($G(^AUPNVHF(IEN,0)),U,3),HFN=$P(^(0),U,1)
 . I VIS="" Q
 . I $G(^AUPNVSIT(VIS,0))="" Q
 . ; exclude Chart review, Telephone, Daily Hosp Data, Ancillary Package Daily
 . ;Q:"DXCT"[$P(^AUPNVSIT(VIS,0),U,7)
 . S VSDTM=$P(^AUPNVSIT(VIS,0),U,1)\1
 . I FDT'="",VSDTM<FDT!(VSDTM>TDT) Q
 . S HFCT=$P($G(^AUTTHF(HFN,0)),"^",3)
 . I HFCT'="" D
 .. I $G(HFCAT)'=""&(HFCT=HFCAT) D
 ... I 'HFNOT S @HCGLOB@(DFN,HFCT)=""
 .. I $D(MPARMS("HFCAT",HFCT)) D
 ... I 'HFNOT S @HCGLOB@(DFN,HFCT,IEN)=""
 . ;
 . I 'HFNOT D  Q
 .. S @HFGLOB@(DFN,HF,IEN)="",@CRIT@("HFACT",DFN,IEN)=""
 . I HFNOT D  Q
 .. S @NGLOB@(DFN)=$G(@NGLOB@(DFN))+1
 Q
 ;
HFDT ;EP
 S LIEN=""
 F  S LIEN=$O(^AUPNVHF("AA",IEN,HF,BDT,LIEN)) Q:LIEN=""  D
 . S VIS=$P($G(^AUPNVHF(LIEN,0)),U,3) I VIS="" Q
 . I $G(^AUPNVSIT(VIS,0))="" Q
 . ; exclude Chart review, Telephone, Daily Hosp Data, Ancillary Package Daily
 . ;Q:"DXCT"[$P(^AUPNVSIT(VIS,0),U,7)
 . S HFN=$P(^AUPNVHF(LIEN,0),U,1)
 . S HFCT=$P($G(^AUTTHF(HFN,0)),"^",3)
 . I HFCT'="" D
 .. I $G(HFCAT)'=""&(HFCT=HFCAT) D
 ... I 'HFNOT S @HCGLOB@(IEN,HFCT)=""
 .. I $D(MPARMS("HFCAT",HFCT)) D
 ... I 'HFNOT S @HCGLOB@(IEN,HFCT)=""
 . ;
 . I 'HFNOT D  Q
 .. S @HFGLOB@(IEN,HF,LIEN)="",@CRIT@("HFACT",IEN,LIEN)=""
 . I HFNOT D  Q
 .. S @NGLOB@(IEN)=$G(@NGLOB@(IEN))+1
 Q
 ;
HFCY(HFCNM) ;EP - Health Factor Category
 S N="" F  S N=$O(^AUTTHF("F",HFCNM,N)) Q:'N  S MPARMS("HFACT",N)=""
 Q
