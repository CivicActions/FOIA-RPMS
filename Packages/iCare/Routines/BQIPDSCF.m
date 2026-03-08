BQIPDSCF ;VNGT/HS/BEE-Panel Description Utility ; 7 Apr 2008  4:28 PM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**1,4,6,7**;Mar 01, 2021;Build 14
 ;
FILTER(OWNR,PLIEN,FPARMS,FPORDN,FPORDO) ;EP - Include filter description
 D FILTER^BQIPDSCB(OWNR,PLIEN,.FPARMS,.FPORDN,.FPORDO)
 Q
 ;
GVAL(PTYP,FILN,IENS,SRC,NM) ; EP - Get value of parameter/filter
 N VALUE,BQFIL,PEXE,LABR,VL
 ;Table
 I PTYP="T" D
 . S VALUE=$$GET1^DIQ(FILN,IENS,.03,"E")
 . I VALUE[";" D  Q
 .. NEW PGL
 .. S PGL="^"_$P(VALUE,";",2),PGL=$$TKO^BQIUL1(PGL,"(")
 .. S VALUE=$P(@PGL@($P(VALUE,";",1),0),U,1)
 . S BQFIL=$$FILN^BQIDCDF(SRC,NM) Q:BQFIL=""
 . I BQFIL=9002318.4&((NM="RFSNOM")!(NM="CDSNOM")) D  Q
 .. NEW IDD
 .. I VALUE="" Q
 .. S IDD=$O(^BSTS(9002318.4,"C",36,VALUE,"")) I IDD="" S VALUE="" Q
 .. S VALUE=$G(^BSTS(9002318.4,IDD,1))
 . I NM="LAB",VALUE'="",VALUE'["_" S LABR=$$LSET^BQIDCAH3(VALUE)
 . I NM="LAB",VALUE'="",VALUE["_" S LABR=$$LSET^BQIDCAH3($P(VALUE,"_",2))
 . I NM="MEAS",VALUE'="" S VALUE=$$GET1^DIQ(BQFIL,VALUE_",",.01,"E") Q
 . I NM="VACC",VALUE'="" S VALUE=$$GET1^DIQ(BQFIL,VALUE_",",.02,"E") Q
 . I NM="GPMEAS",VALUE'="" S VL=$O(^BQI(90506.1,"B",VALUE,"")) I VL'="" S VALUE=$P(^BQI(90506.1,VL,0),"^",3)
 . S VALUE=$$GET1^DIQ(BQFIL,VALUE_",",.01,"E")
 ;
 ;Non-table
 I PTYP'="T" D
 . S VALUE=$$GET1^DIQ(FILN,IENS,.02,"E")
 . I NM="LAB",VALUE'="",VALUE'["_" S LABR=$$LSET^BQIDCAH3(VALUE)
 . I NM="LAB",VALUE'="",VALUE["_" S LABR=$$LSET^BQIDCAH3($P(VALUE,"_",2))
 . I NM="GPMEAS",VALUE'="" S VL=$O(^BQI(90506.1,"B",VALUE,"")) I VL'="" S VALUE=$P(^BQI(90506.1,VL,0),"^",3)
 I PTYP="D" S VALUE=$$UP^XLFSTR($$FMTE^XLFDT(VALUE,1))
 Q VALUE_$S($G(LABR)'="":"|"_LABR,1:"")
 ;
GMVAL(PTYP,FILN,IENS,SRC,NM) ; EP - Get value for multiples
 N VALUE,BQFIL,LABR,VL
 I PTYP="T" D
 . S VALUE=$$GET1^DIQ(FILN,IENS,.02,"E")
 . S BQFIL=$$FILN^BQIDCDF(SRC,NM) Q:BQFIL=""
 . I BQFIL=9002318.4&((NM="RFSNOM")!(NM="CDSNOM"))  D  Q
 .. NEW IDD
 .. I VALUE="" Q
 .. S IDD=$O(^BSTS(9002318.4,"C",36,VALUE,"")) I IDD="" S VALUE="" Q
 .. S VALUE=$G(^BSTS(9002318.4,IDD,1))
 . ;B:NM="LAB"
 . ;I NM="LAB",VALUE'="",VALUE'["_" S LABR=$$LSET^BQIDCAH3(VALUE)
 . ;I NM="LAB",VALUE'="",VALUE["_" S LABR=$$LSET^BQIDCAH3($P(VALUE,"_",2))
 . I NM="VACC",VALUE'="" S VALUE=$$GET1^DIQ(BQFIL,VALUE_",",.02,"E") Q
 . I NM="GPMEAS",VALUE'="" S VL=$O(^BQI(90506.1,"B",VALUE,"")) I VL'="" S VALUE=$P(^BQI(90506.1,VL,0),"^",3)
 . S VALUE=$$GET1^DIQ(BQFIL,VALUE,.01,"E")
 I PTYP'="T" D
 . S VALUE=$$GET1^DIQ(FILN,IENS,.01,"E")
 . I NM="LAB" S LABR=$$LSET^BQIDCAH3($P(VALUE,"_",2))
 . ;I NM="LAB",VALUE'="",VALUE'["_" S LABR=$$LSET^BQIDCAH3(VALUE)
 . ;I NM="LAB",VALUE'="",VALUE["_" S LABR=$$LSET^BQIDCAH3($P(VALUE,"_",2))
 . I NM="GPMEAS",VALUE'="" S VL=$O(^BQI(90506.1,"B",VALUE,"")) I VL'="" S VALUE=$P(^BQI(90506.1,VL,0),"^",3)
 Q VALUE_$S($G(LABR)'="":"|"_LABR,1:"")
 ;
DLM(FPARMS,FNAME,FLD) ;EP - Determine delimiter between multiple entries
 NEW OVAL,OR
 S OVAL=$O(FPARMS(PORD,FNAME,"")),VALUE=""
 S OPER=$S(OVAL="&":", AND ",1:", OR ")
 I FLD="PROB" D
 . I '$D(FPORDN("PROB")),$D(FPORDN("PROBS")) S FLD="PROBS"
 NEW PORD,FENT,OFNAME
 S (FND,PORD)="" F  S PORD=$O(FPARMS(PORD)) Q:'PORD  D
 . S OFNAME="" F  S OFNAME=$O(FPARMS(PORD,OFNAME)) Q:OFNAME=""  D
 .. I OFNAME=FLD D  Q
 ... S FENT="" F  S FENT=$O(FPARMS(PORD,OFNAME,FENT)) Q:FENT=""  D
 .... I OFNAME="LAB",FENT["_" D  Q
 ..... S OR=FENT I FENT["|" S OR=$P(OR,"|",1)
 ..... I FPARMS(PORD,FLD,FENT)'["_" S VALUE=VALUE_FPARMS(PORD,FLD,FENT)_OPER Q
 ..... I FPARMS(PORD,FLD,FENT)["_" S IDD=$P(^LAB(60,$P(OR,"_",2),0),"^",1),VALUE=VALUE_IDD_OPER
 .... I OFNAME="PROBS",FENT?.N D  Q
 ..... S IDD=$$CID(FENT,36),VALUE=VALUE_IDD_OPER
 .... S VALUE=VALUE_FPARMS(PORD,OFNAME,FENT)_OPER
 S VALUE=$$TKO^BQIUL1(VALUE,OPER)
 Q
 ;
AGE(FVAL,VALUE) ; Format FPARMS("AGE") or FMPARMS("AGE")
 NEW AGE,EXT,OP,AGE1,AGE2
 I '$D(FPARMS(PORD,"AGE")) D  Q
 . S AGE=$G(VALUE)
 . S EXT=$S($E(AGE)="'":2,1:1),OP=$E(AGE,1,EXT),AGE=$E(AGE,EXT+1,99)
 . S AGE=$S(OP="=":AGE,OP=">":"older than "_AGE,OP="<":"younger than "_AGE,OP="'<":AGE_" or older",1:AGE_" or younger")
 . I AGE["YRS" S AGE=$P(AGE,"YRS")_" years"_$P(AGE,"YRS",2,99)
 . I AGE["MOS" S AGE=$P(AGE,"MOS")_" months"_$P(AGE,"MOS",2,99)
 . I AGE["DYS" S AGE=$P(AGE,"DYS")_" days"_$P(AGE,"DYS",2,99)
 . S VALUE=AGE
 ;
 ;Two Age values - must be exclusive or inclusive
 S AGE2=$G(VALUE)
 S EXT=$S($E(AGE2)="'":2,1:1),OP=$E(AGE2,1,EXT),AGE2=$E(AGE2,EXT+1,99)
 I AGE2["YRS" S AGE2=$P(AGE2,"YRS")_" years"_$P(AGE2,"YRS",2,99)
 I AGE2["MOS" S AGE2=$P(AGE2,"MOS")_" months"_$P(AGE2,"MOS",2,99)
 I AGE2["DYS" S AGE2=$P(AGE2,"DYS")_" days"_$P(AGE2,"DYS",2,99)
 ;
 ;Inclusive
 S AGE1=$O(FPARMS(PORD,"AGE","")) Q:AGE1=""
 I AGE1["or older"!(AGE1["or younger") D  Q
 . K FPARMS(PORD,"AGE",AGE1)
 . I AGE1["or older" S AGE1=$P(AGE1," or older")
 . E  S AGE1=$P(AGE1," or younger")
 . S VALUE="between (inclusive) "_AGE1_" and "_AGE2
 ;
 ;Exclusive
 K FPARMS(PORD,"AGE",AGE1)
 I AGE1["younger than" S AGE1=$P(AGE1,"younger than ",2)
 E  S AGE1=$P(AGE1,"older than ",2)
 S VALUE="younger than "_AGE1_" or older than "_AGE2
 Q
 ;
DXCAT ;EP - Diagnosis Category
 NEW I,STR,DXSTAT
 S ASTR=$G(ASTR,"")
 F I=1:1:$L(ASTR,$C(26)) D
 . NEW AINFO,ANAME,AVAL,NVAL,VAL,PC
 . S AINFO=$P(ASTR,$C(26),I)
 . S ANAME=$P(AINFO,$C(28)) Q:ANAME=""
 . S AVAL=$P(AINFO,$C(28),2) Q:AVAL=""
 . S NVAL=""
 . F PC=1:1:$L(AVAL,$C(29)) D
 .. S VAL=$P(AVAL,$C(29),PC) Q:VAL=""
 .. S VAL=$S(VAL="A":"Accepted",VAL="P":"Proposed",VAL="N":"Not Accepted",VAL="V":"No Longer Valid",VAL="S":"Superseded",1:"")
 .. S:VAL]"" NVAL=NVAL_$S(NVAL]"":", ",1:"")_VAL
 . I ANAME]"",NVAL]"" S @ANAME=NVAL
 ;
 S STR="Diagnostic Tag "_VALUE
 S:$G(DXSTAT)]"" STR=STR_" (Diagnostic Tag Status "_DXSTAT_")"
 S VALUE=STR
 Q
 ;
DEC(FVAL,VALUE) ;EP - Format Patient status
 ;Deceased
 I FNAME="DEC" S VALUE=$S($G(FVAL)="Y":"are Deceased",1:"")
 I FNAME="DECFDT" S VALUE="from "_FVAL
 I FNAME="DECTDT" S VALUE="thru "_FVAL
 I FNAME="DECCOD" D
 . NEW FN,CD,CIEN,CDATE
 . S FN=FPORDN("DECCOD"),VALUE=""
 . S CD="" F  S CD=$O(FPARMS(FN,FNAME,CD)) Q:CD=""  D
 .. S CIEN=$O(^ICD9("BA",CD_" ","")) I CIEN="" Q
 .. S CDATE=$O(^ICD9(CIEN,68,"B",""),-1) I CDATE="" Q
 .. S CN=$O(^ICD9(CIEN,68,"B",CDATE,"")) I CN="" Q
 .. S VALUE=VALUE_^ICD9(CIEN,68,CN,1)_", "
 . S VALUE=$$TKO^BQIUL1(VALUE,", ")
 ;
 ;Living
 I FNAME="LIV" S VALUE=$S($G(FVAL)="Y":"are Living",1:"")
 ;
 ;Inactive
 I FNAME="INAC" S VALUE=$S($G(FVAL)="Y":"are Inactive",1:"")
 ;
 ;DEMO
 I FNAME="DEMO" S VALUE=$S($G(FVAL)="E":"Excludes",$G(FVAL)="O":"are Only",1:"Includes")_" DEMO patients"
 Q
 ;
PLIDEN(FVAL,VALUE) ; Format FPARMS("PLIDEN") or FMPARMS("PLIDEN")
 NEW PLOWNR,PLNAME
 S VALUE=""
 I FNAME="PLIDEN" D
 . I $D(FPARMS(PORD,FNAME))>9 D  Q
 .. S OR="" F  S OR=$O(FPARMS(PORD,FNAME,OR)) Q:OR=""  D
 ... S PLOWNR=$P(OR,$C(26),1),PLNAME=$P(OR,$C(26),2)
 ... S PLOWNR=$$GET1^DIQ(200,PLOWNR_",",.01,"E")
 ... I PLOWNR'="" S PLOWNR="(Owner: "_PLOWNR_")"
 ... S VALUE=VALUE_PLNAME_$S(PLNAME]"":" ",1:"")_PLOWNR_", "
 S VALUE=$$TKO^BQIUL1(VALUE,", ")
 Q
 ;
LABTX(FVAL,VALUE) ;EP - Assemble lab taxonomy values
 NEW TREF,VAL,MD,CT,LEN
 I FVAL="" Q
 S TREF=$NA(^XTMP("BQIPDSC",$J)) K @TREF
 D BLD^BQITUTL(FVAL,.TREF,"L")
 S VALUE="Taxonomy "_FVAL,LEN=1
 S VAL=" : (",MD=""
 F  S MD=$O(@TREF@(MD)) Q:MD=""!(LEN>255)  D
 . S VAL=VAL_@TREF@(MD)_", ",LEN=$L(VAL)
 S VAL=$$TKO^BQIUL1(VAL,", ")
 I LEN>255 S VAL=$$TRUNC^BQIPDSCM(VAL)
 S:VAL["(" VAL=VAL_")"
 S VALUE=VALUE_VAL
 Q
 ;
TAX(FVAL,VALUE) ;EP - Assemble Taxonomy values
 NEW TREF,VAL,MD,CT,LEN
 I FVAL="" Q
 S TREF=$NA(^XTMP("BQIPDSC",$J)) K @TREF
 D BLD^BQITUTL(FVAL,.TREF)
 S VALUE="Taxonomy "_FVAL,LEN=1
 S VAL=": (",MD=""
 F  S MD=$O(@TREF@(MD)) Q:MD=""!(LEN>255)  D
 . S VAL=VAL_$P(@TREF@(MD),"^",1)_", ",LEN=$L(VAL)
 S VAL=$$TKO^BQIUL1(VAL,", ")
 I LEN>255 S VAL=$$TRUNC^BQIPDSCM(VAL)
 S:VAL["(" VAL=VAL_")"
 S VALUE=VALUE_VAL
 Q
 ;
SNOM(FVAL,VALUE) ;EP - Assemble SNOMED subset
 NEW BQILIST,BQTY,OK,BQSN,CODE,LIEN
 S BQILIST=$NA(^TMP("BQISNOMG",$J)) K @BQILIST
 S BQTY=$S($E(FVAL,1,4)="RXNO":1552,1:36)
 S OK=$$SUBLST^BSTSAPI(BQILIST,FVAL_"^"_BQTY_"^1")
 S VALUE=$S(BQTY=1552:"RXNORM ",1:"SNOMED ")_FVAL,LEN=1
 S VAL=": ("
 S BQSN=0
 F  S BQSN=$O(@BQILIST@(BQSN)) Q:BQSN=""!(LEN>255)  D
 . S CODE=$P(@BQILIST@(BQSN),"^",1),DESC=$P(@BQILIST@(BQSN),"^",3)
 . S LIEN=$O(^BSTS(9002318.4,"C",BQTY,CODE,""))
 . I $P(^BSTS(9002318.4,LIEN,0),"^",16)=1 Q
 . S VAL=VAL_DESC_", ",LEN=$L(VAL)
 S VAL=$$TKO^BQIUL1(VAL,", ")
 I LEN>255 S VAL=$$TRUNC^BQIPDSCM(VAL)
 S:VAL["(" VAL=VAL_")"
 S VALUE=VALUE_VAL
 Q
 ;
CID(CODE,BQTY) ;Concept ID
 S LIEN=$O(^BSTS(9002318.4,"C",BQTY,CODE,""))
 Q $P($G(^BSTS(9002318.4,LIEN,1))," (",1)
 ;
GETVAL(OWNR,PLIEN,FLD) ;EP - Retrieve Single field value
 N DECIEN,DA,IEN,IENS
 S IEN=$O(^BQICARE(OWNR,1,PLIEN,15,"B",FLD,"")) Q:IEN="" ""
 S DA(2)=OWNR,DA(1)=PLIEN,DA=IEN,IENS=$$IENS^DILF(.DA)
 Q $$GET1^DIQ(90505.115,IENS,.02,"I")
 ;
ICD(FVAL,VALUE) ;EP - Return ICD Information
 NEW ICD
 S ICD=""
 ;Pull appropriate ICD-9/ICD-10 code
 ;ICD-9
 I $$VERSION^XPDUTL("AICD")<4.0 D
 . NEW STR
 . I '$L($T(ICDDX^ICDCODE)) D  Q
 .. S ICD=$$GET1^DIQ(80,ICDIEN_",",.03,"I")_U_$$GET1^DIQ(80,ICDIEN_",",.01,"I")
 . S STR=$$ICDDX^ICDCODE(ICDIEN) I $P(STR,U)="-1" Q
 . S ICD=$P(STR,U,4)_U_$P(STR,U,2)
 ;
 ;ICD-9 or ICD-10
 I $$VERSION^XPDUTL("AICD")>3.51 D
 . ;First try to locate ICD-10
 . I $$IMP^ICDEXA(30)'>DT D  Q:ICD]""
 .. NEW STR
 .. S STR=$$ICDDATA^ICDXCODE(30,ICDIEN,DT,"E") I $P(STR,U)="-1" Q
 .. S ICD=$P(STR,U,4)_U_$P(STR,U,2)
 . ;If not an ICD-10 code try ICD-9 (could be before date or a historical entry)
 . I $G(ICD)="" D
 .. NEW STR
 .. S STR=$$ICDDATA^ICDXCODE(1,ICDIEN,DT,"E") I $P(STR,U)="-1" Q
 .. S ICD=$P(STR,U,4)_U_$P(STR,U,2)
 Q $S(ICD]"":($P(ICD,U)_" ("_$P(ICD,U,2)_")"),1:"")
 ;
PRST(PVAL) ;EP - Problem statuses
 NEW FILE,FLD
 S FILE=9000011,FLD=.12,PVALUE=""
 S PVALUE=$$STC^BQIUL2(FILE,FLD,PVAL)
 Q PVALUE
