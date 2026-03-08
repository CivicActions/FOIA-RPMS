BQIDCAH5 ;GDIT/HS/ALA-Ad Hoc Logic Continued ; 18 Jan 2013  6:42 AM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**1,2,4,7**;Mar 01, 2021;Build 14
 ;
DOB(FGLOB,TGLOB,DBFROM,DBTHRU) ;EP - Date of Birth search
 I $G(TGLOB)="" Q
 I $G(DBFROM)="" Q
 ;
 NEW IEN,PDOB
 S IEN=0
 I $G(FGLOB)'="" D
 . F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  D
 .. S PDOB=$P($G(^DPT(IEN,0)),U,3) I PDOB="" Q
 .. I PDOB<DBFROM!(PDOB>DBTHRU) Q
 .. S @TGLOB@(IEN)=""
 ;
 I $G(FGLOB)="" D
 . NEW FDT,TDT
 . S FDT=DBFROM-.001,TDT=DBTHRU F  S FDT=$O(^DPT("ADOB",FDT)) Q:FDT=""!(FDT>TDT)  D
 .. S IEN="" F  S IEN=$O(^DPT("ADOB",FDT,IEN)) Q:'IEN  S @TGLOB@(IEN)=""
 Q
 ;
DMON(FGLOB,TGLOB,DMON,MPARMS) ;EP - Birth Month search
 I $G(TGLOB)="" Q
 I $G(DMON)="" Q
 NEW IEN,PDOB
 S IEN=0
 I $G(FGLOB)'="" D
 . F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  D
 .. S PDOB=$P($G(^DPT(IEN,0)),U,3) I PDOB="" Q
 .. I DMON'=$E(PDOB,4,5) Q
 .. S @TGLOB@(IEN)=""
 ;
 I $G(FGLOB)="" D
 . S PDOB="" F  S PDOB=$O(^DPT("ADOB",PDOB)) Q:PDOB=""  D
 .. I DMON'=$E(PDOB,4,5) Q
 .. S IEN="" F  S IEN=$O(^DPT("ADOB",PDOB,IEN)) Q:IEN=""  S @TGLOB@(IEN)=""
 Q
 ;
GEN(FGLOB,TGLOB,GEN) ;EP - Gender search
 I $G(TGLOB)="" Q
 I $G(GEN)="" Q
 ;
 NEW IEN
 S IEN=0
 I $G(FGLOB)'="" D
 . F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  D GCHK
 ;
 I $G(FGLOB)="" D
 . F  S IEN=$O(^AUPNPAT(IEN)) Q:'IEN  D GCHK
 Q
 ;
GCHK ;EP  Gender check
 I $P($G(^DPT(IEN,0)),U,2)'=GEN Q
 S @TGLOB@(IEN)=""
 Q
 ;
PCOMM(FGLOB,TGLOB,PCOMM) ;EP - Preferred Communication search
 I $G(TGLOB)="" Q
 I $G(PCOMM)="" Q
 ;
 NEW IEN
 S IEN=0
 I $G(FGLOB)'="" D
 . F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  D PCHK
 ;
 I $G(FGLOB)="" D
 . F  S IEN=$O(^AUPNPAT(IEN)) Q:'IEN  D PCHK
 Q
 ;
PCHK ;EP
 I $P($G(^AUPNPAT(IEN,40)),U,2)'=PCOMM Q
 S @TGLOB@(IEN)=""
 Q
 ;
RACE(FGLOB,TGLOB,RACE,MPARMS) ;EP - Race search
 NEW RCN
 I $G(TGLOB)="" Q
 I $G(RACE)]"" S RCN=$G(RACE) D RCE
 I $D(MPARMS("RACE")) S RCN="" F  S RCN=$O(MPARMS("RACE",RCN)) Q:RCN=""  D RCE
 Q
 ;
RCE ;EP
 NEW IEN
 I $G(FGLOB)'="" D
 . S IEN=""
 . F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  D RCHK
 ;
 I $G(FGLOB)="" D
 . S IEN=0
 . F  S IEN=$O(^AUPNPAT(IEN)) Q:'IEN  D RCHK
 Q
 ;
RCHK ;EP
 ;I $G(RCN)?.N S RACE=$P(^DIC(10,RCN,0),U,1)
 ;I $P($$RCE^BQIPTDMG(IEN,.01),$C(28),2)'=RACE Q
 I $D(^DPT(IEN,.02,RCN)) S @TGLOB@(IEN)=""
 Q
 ;
ETHN(FGLOB,TGLOB,ETHN,MPARMS) ;EP - Ethnicity search
 NEW EN
 I $G(TGLOB)="" Q
 I $G(ETHN)]"" S EN=$G(ETHN) D ETH
 I $D(MPARMS("ETHN")) S EN="" F  S EN=$O(MPARMS("ETHN",EN)) Q:EN=""  D ETH
 Q
 ;
ETH ;EP
 NEW IEN
 S IEN=0
 I $G(FGLOB)'="" D
 . F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  D ECHK
 ;
 I $G(FGLOB)="" D
 . F  S IEN=$O(^AUPNPAT(IEN)) Q:'IEN  D ECHK
 Q
 ;
ECHK ;EP
 ;I EN?.N S ETHN=$P(^DIC(10.2,EN,0),U,1)
 ;I $P($$ETHN^BQIPTDMG(IEN,.01),$C(28),2)'=ETHN Q
 I $D(^DPT(IEN,.06,EN)) S @TGLOB@(IEN)=""
 Q
 ;
PLANG(FGLOB,TGLOB,PLANG) ;EP - Preferred Language search
 I $G(TGLOB)="" Q
 I $G(PLANG)="" Q
 ;
 NEW IEN
 S IEN=0
 I $G(FGLOB)'="" D
 . F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  D LCHK
 ;
 I $G(FGLOB)="" D
 . F  S IEN=$O(^AUPNPAT(IEN)) Q:'IEN  D LCHK
 Q
 ;
LCHK ;EP
 I PLANG?.N S PLANG=$P(^AUTTLANG(PLANG,0),U,1)
 I $$PFLNG^BQIULPT(IEN)'=PLANG Q
 S @TGLOB@(IEN)=""
 Q
 ;
EDU(FGLOB,TGLOB,EDUC,EDUTX,FDT,TDT,EDUNOT,MPARMS) ;EP - Education search
 NEW EDPT,TREF,ETAX,NGLOB,LN,RET,TOPN,TOP
 S NGLOB=$NA(^TMP("BQIDCEDUC",$J)) K @NGLOB
 I $G(TGLOB)="" Q
 I $G(EDUC)'="" D ED
 I $G(EDUTX)'="" D
 . S TREF=$NA(MPARMS("EDUC"))
 . K @TREF
 . S ETAX=$P(@("^"_$P(EDUTX,";",2)_$P(EDUTX,";",1)_",0)"),"^",1)
 . D BLD^BQITUTL(ETAX,TREF)
 I $G(EDUTOP)'="" D
 . S TOPN=EDUTOP,TOP=$P(^AUTTEDMT(TOPN,0),U,2)
 . S LN=0
 . F  S LN=$O(^AUTTEDT(LN)) Q:'LN  D
 .. S RET=$G(^AUTTEDT(LN,0))
 .. I RET="" Q
 .. I $P(RET,U,3)'="" Q
 .. I $P(RET,U,6)'=TOP Q
 .. S MPARMS("EDUC",LN)=""
 I $G(EDUPICK)'="" D
 . S LN=0
 . F  S LN=$O(^BGOEDTPR(EDUPICK,1,"B",LN)) Q:LN=""  D
 .. S RET=$G(^AUTTEDT(LN,0))
 .. I RET="" Q
 .. I $P(RET,U,3)'="" Q
 .. S MPARMS("EDUC",LN)=""
 ;
 I EDUOP="!" D
 . I $D(MPARMS("EDUC")) S EDUC="" F  S EDUC=$O(MPARMS("EDUC",EDUC)) Q:EDUC=""  D ED
 I EDUOP="&" D
 . K EDPT
 . S EDUC="",CT=0 F  S EDUC=$O(MPARMS("EDUC",EDUC)) Q:EDUC=""  D ED S CT=CT+1
 . S IEN=""
 . F  S IEN=$O(EDPT(IEN)) Q:IEN=""  D
 .. S MCT=0,ED=""
 .. F  S ED=$O(EDPT(IEN,ED)) Q:ED=""  S MCT=MCT+1
 .. I MCT=CT,'EDUNOT S @TGLOB@(IEN)="",MIEN=EDPT(IEN,ED),@CRIT@("EDUC",IEN,MIEN)="" Q
 .. I MCT=CT,EDUNOT S @NGLOB@(IEN)="" K @CRIT@("EDUC",IEN)
 ;
 I EDUNOT,$G(FGLOB)'="" D
 . S IEN="" F  S IEN=$O(@FGLOB@(IEN)) Q:IEN=""  D
 .. I '$D(@NGLOB@(IEN)) S @TGLOB@(IEN)=""
 I EDUNOT,$G(FGLOB)="" D
 . S IEN=0 F  S IEN=$O(^AUPNPAT(IEN)) Q:'IEN  I '$D(@NGLOB@(IEN)) S @TGLOB@(IEN)=""
 K @NGLOB
 Q
 ;
ED ;EP
 NEW DFN,IEN
 S TDT=$S(TDT'="":TDT,1:DT)
 I $G(FGLOB)'="" D  Q
 . NEW IEN,EDP
 . S IEN=""
 . F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  D
 .. I FDT="" D
 ... S BDT=""
 ... F  S BDT=$O(^AUPNVPED("AA",IEN,BDT)) Q:BDT=""  D EDDT
 .. I FDT'="" D
 ... S BGT=9999999-FDT,ENT=9999999-TDT,BDT=ENT-1
 ... F  S BDT=$O(^AUPNVPED("AA",IEN,BDT)) Q:BDT=""!(BDT>BGT)  D EDDT
 ;
 S IEN=""
 F  S IEN=$O(^AUPNVPED("B",EDUC,IEN)) Q:IEN=""  D
 . I $G(^AUPNVPED(IEN,0))="" Q
 . S DFN=$P(^AUPNVPED(IEN,0),U,2),VIS=$P(^AUPNVPED(IEN,0),U,3) I VIS="" Q
 . I $G(^AUPNVSIT(VIS,0))="" Q
 . Q:"DXCTI"[$P(^AUPNVSIT(VIS,0),U,7)
 . S VSDTM=$P(^AUPNVSIT(VIS,0),U,1)\1
 . I FDT'="",VSDTM<FDT!(VSDTM>TDT) Q
 . I DFN'="",EDUOP="!",EDUNOT S @NGLOB@(DFN)="" Q
 . I DFN'="",EDUOP="!",'EDUNOT S @TGLOB@(DFN)="",@CRIT@("EDUC",DFN,IEN)="" Q
 . I DFN'="",EDUOP="&" S EDPT(DFN,EDUC)=IEN
 Q
 ;
EDDT ;EP
 S MIEN=""
 F  S MIEN=$O(^AUPNVPED("AA",IEN,BDT,MIEN)) Q:MIEN=""  D
 . S EDP=$P($G(^AUPNVPED(MIEN,0)),U,1)
 . I EDUOP="!",EDP=EDUC,EDUNOT S @NGLOB@(IEN)="" Q
 . I EDUOP="!",EDP=EDUC,'EDUNOT S @TGLOB@(IEN)="",@CRIT@("EDUC",IEN,MIEN)="" Q
 . I EDUOP="&",EDP=EDUC S EDPT(IEN,EDUC)=MIEN
 Q
 ;
HRCOND(FGLOB,TGLOB,HRISK,HRNUM,MPARMS) ;EP - High Risk Conditions
 NEW NGLOB
 I $G(TGLOB)="" Q
 S NGLOB=$NA(^TMP("BQIDCHCOND",$J)) K @NGLOB
 ;
 ; Looking for number of high risk conditions
 I $G(HRNUM)'=""!($D(MPARMS("HRNUM"))) D
 . I $G(HRNUM)'="" S CRIT1=HRNUM,CRIT2=""
 . I $D(MPARMS("HRNUM")) D
 .. S CRIT1=$G(CRIT1,""),CRIT2=$G(CRIT2,"")
 .. S N="",N=$O(MPARMS("HRNUM",N)),CRIT1=N
 .. S N=$O(MPARMS("HRNUM",N)) I N'="" S CRIT2=N
 . D NHRC
 ;
 I $G(HRISK)'=""!($D(MPARMS("HRISK")))!($G(HRIMUNO)'="")!($D(MPARMS("HRIMUNO"))) D
 . I $G(FGLOB)="" D
 .. I $G(HRISK)'="" D STFC(HRISK) Q
 .. I $G(HRIMUNO)'="" D STIM(HRIMUNO) Q
 .. S HRIMUNO="" F  S HRIMUNO=$O(MPARMS("HRIMUNO",HRIMUNO)) Q:HRIMUNO=""  D STIM(HRIMUNO)
 .. S HRISK="" F  S HRISK=$O(MPARMS("HRISK",HRISK)) Q:HRISK=""  D STFC(HRISK)
 . I $G(FGLOB)'="" D
 .. I $G(HRISK)'="" D FNFC(HRISK) Q
 .. I $G(HRIMUNO)'="" D FNIM(HRIMUNO) Q
 .. S HRIMUNO="" F  S HRIMUNO=$O(MPARMS("HRIMUNO",HRIMUNO)) Q:HRIMUNO=""  D FNIM(HRIMUNO)
 .. S HRISK="" F  S HRISK=$O(MPARMS("HRISK",HRISK)) Q:HRISK=""  D FNFC(HRISK)
 . I HROP="&" D
 .. S HCNT=0,HRISK="" F  S HRISK=$O(MPARMS("HRISK",HRISK)) Q:HRISK=""  S HCNT=HCNT+1
 .. S HDFN="" F  S HDFN=$O(@NGLOB@(HDFN)) Q:HDFN=""  D
 ... S HCT=0,HVAL="" F  S HVAL=$O(@NGLOB@(HDFN,HVAL)) Q:HVAL=""  S HCT=HCT+1
 ... I HCT'=HCNT K @NGLOB@(HDFN),@CRIT@("HRISK",HDFN) Q
 ... I HCT=HCNT S @TGLOB@(HDFN)=""
 K @NGLOB,HCT,HCNT,HDFN,HVAL,HRISK,HRNUM,CRIT1,CRIT2,N,AVAL1,AVAL2
 Q
 ;
NHRC ; EP - Number of High Risk Conditions
 NEW OP1,OP2,HN
 S OP1=$E(CRIT1,1,1),OP2=$E(CRIT2,1,1)
 I $E(OP1,1,1)="'" S OP1=$E(CRIT1,1,2),AVAL1=$E(CRIT1,3,$L(CRIT1))
 E  S OP1=$E(CRIT1,1,1),AVAL1=$E(CRIT1,2,$L(CRIT1))
 I $E(OP2,1,1)="'" S OP2=$E(CRIT2,1,2),AVAL2=$E(CRIT2,3,$L(CRIT2))
 E  S OP2=$E(CRIT2,1,1),AVAL2=$E(CRIT2,2,$L(CRIT2))
 ;
 I $G(FGLOB)="" D
 . I $G(OP1)="=" D STFN(AVAL1) Q
 . I $G(OP1)="<" D  Q
 .. F  S AVAL1=$O(^BQIPAT("AI",AVAL1),-1) Q:AVAL1=""  D STFN(AVAL1)
 . I $G(OP1)=">" D  Q
 .. F  S AVAL1=$O(^BQIPAT("AI",AVAL1)) Q:AVAL1=""  D STFN(AVAL1)
 . ;
 . I $G(OP1)="'<",$G(OP2)="" D  Q
 .. S AVAL1=$O(^BQIPAT("AI",AVAL1),-1)
 .. F  S AVAL1=$O(^BQIPAT("AI",AVAL1)) Q:AVAL1=""  D STFN(AVAL1)
 . I $G(OP1)="'>",$G(OP2)="" D  Q
 .. S AVAL1=AVAL1+1
 .. F  S AVAL1=$O(^BQIPAT("AI",AVAL1),-1) Q:AVAL1=""  D STFN(AVAL1)
 . ;
 . ; In range
 . I $G(OP1)="'<",$G(OP2)="'>" D  Q
 .. S AVAL1=AVAL1-1 F  S AVAL1=$O(^BQIPAT("AI",AVAL1)) Q:AVAL1>AVAL2!(AVAL1="")  D STFN(AVAL1)
 . ; Out of range
 . I $G(OP1)="<",$G(OP2)=">" D  Q
 .. S AVAL1=AVAL1+1 F  S AVAL1=$O(^BQIPAT("AI",AVAL1),-1) Q:AVAL1=""  D STFN(AVAL1)
 .. S AVAL2=AVAL2-1 F  S AVAL2=$O(^BQIPAT("AI",AVAL2)) Q:AVAL2=""  D STFN(AVAL2)
 ;
 I $G(FGLOB)'="" D
 . I $G(OP1)="=" D FNFN(AVAL1)
 . I $G(OP1)="<" D  Q
 .. F  S AVAL1=$O(^BQIPAT("AI",AVAL1),-1) Q:AVAL1=""  D FNFN(AVAL1)
 . I $G(OP1)=">" D  Q
 .. F  S AVAL1=$O(^BQIPAT("AI",AVAL1)) Q:AVAL1=""  D FNFN(AVAL1)
 . ;
 . I $G(OP1)="'<",$G(OP2)="" D  Q
 .. S AVAL1=AVAL1+1 F  S AVAL1=$O(^BQIPAT("AI",AVAL1),-1) Q:AVAL1=""  D FNFN(AVAL1)
 . I $G(OP1)="'>",$G(OP2)="" D  Q
 .. S AVAL1=AVAL1-1 F  S AVAL1=$O(^BQIPAT("AI",AVAL1)) Q:AVAL1=""  D FNFN(AVAL1)
 . ;
 . ; In range
 . I $G(OP1)="'<",$G(OP2)="'>" D  Q
 .. S AVAL1=AVAL1-1 F  S AVAL1=$O(^BQIPAT("AI",AVAL1)) Q:AVAL1>AVAL2  D FNFN(AVAL1)
 . ; Out of range
 . I $G(OP1)="<",$G(OP2)=">" D  Q
 .. S AVAL1=AVAL1+1 F  S AVAL1=$O(^BQIPAT("AI",AVAL1),-1) Q:AVAL1=""  D FNFN(AVAL1)
 .. S AVAL2=AVAL2-1 F  S AVAL2=$O(^BQIPAT("AI",AVAL2)) Q:AVAL2=""  D FNFN(AVAL2)
 Q
 ;
STFN(VAL) ;EP - Store value if meet high risk number
 NEW HN
 S HN="" F  S HN=$O(^BQIPAT("AI",VAL,HN)) Q:HN=""  S @TGLOB@(HN)="" D
 . S HC="" F  S HC=$O(^BQIPAT(HN,5,"C",HC)) Q:HC=""  S HNN=$O(^BQIPAT(HN,5,"C",HC,"")),@CRIT@("HRCD",HN,HNN)=""
 Q
 ;
FNFN(VAL) ;EP - Find and store value if meet high risk number
 NEW HIEN
 S HIEN="" F  S HIEN=$O(^BQIPAT("AI",VAL,HIEN)) Q:HIEN=""  I $D(@FGLOB@(HIEN)) D
 . S @TGLOB@(HIEN)=""
 . S HC="" F  S HC=$O(^BQIPAT(HIEN,5,"C",HC)) Q:HC=""  S HNN=$O(^BQIPAT(HIEN,5,"C",HC,"")),@CRIT@("HRCD",HIEN,HNN)=""
 Q
 ;
STFC(VAL) ;EP - find and store if meet high risk condition
 NEW HN,HNN
 S HN="" F  S HN=$O(^BQIPAT("AH",VAL,HN)) Q:HN=""  D
 . I HROP="!" S @TGLOB@(HN)=""
 . I HROP="&" S @NGLOB@(HN,VAL)=""
 . S HNN="" F  S HNN=$O(^BQIPAT("AH",VAL,HN,HNN)) Q:HNN=""  D
 .. S @CRIT@("HRCD",HN,HNN)=""
 Q
 ;
STIM(VAL) ; EP - find and store if meet immunocompromised condition
 NEW IM,IMN
 S IM="" F  S IM=$O(^BQIPAT("AJ",VAL,IM)) Q:IM=""  D
 . S IMN="" F  S IMN=$O(^BQIPAT("AJ",VAL,IM,IMN)) Q:IMN=""  D
 .. S @TGLOB@(IM)="",@CRIT@("HRIMNO",IM,IMN)=""
 Q
 ;
FNFC(VAL) ;EP - find and store if meet high risk condition
 NEW HIEN,HNN
 S HIEN="" F  S HIEN=$O(^BQIPAT("AH",VAL,HIEN)) Q:HIEN=""  D
 . I $D(@FGLOB@(HIEN)) D
 .. I HROP="!" S @TGLOB@(HIEN)=""
 .. I HROP="&" S @NGLOB@(HIEN,VAL)=""
 .. S HNN="" F  S HNN=$O(^BQIPAT("AH",VAL,HIEN,HNN)) Q:HNN=""  D
 ... S @CRIT@("HRCD",HIEN,HNN)=""
 Q
 ;
FNIM(VAL) ;EP - find and store if meet immunocompromised condition
 NEW IDFN,IMN
 S IDFN="" F  S IDFN=$O(^BQIPAT("AJ",VAL,IDFN)) Q:IDFN=""  D
 . I $D(@FGLOB@(IDFN)) D
 .. S IMN="" F  S IMN=$O(^BQIPAT("AJ",VAL,IDFN,IMN)) Q:IMN=""  D
 ... S @TGLOB@(IDFN)="",@CRIT@("HRIMNO",IDFN,IMN)=""
 Q
