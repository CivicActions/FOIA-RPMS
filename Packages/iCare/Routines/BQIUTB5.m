BQIUTB5 ;GDIT/HS/ALA-Table utilities ; 17 Dec 2014  9:14 AM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**1,3,5**;Mar 01, 2021;Build 20
 ;
 ;
USR(DATA,TYPE,FLAG) ;EP - Go through the User File
 ;
 ;Input
 ;  TYPE - "P" is for provider, otherwise it's a regular user
 ;
 S II=0
 S LENGTH=$$GET1^DID(200,.01,"","FIELD LENGTH","TEST1","ERR")
 S DLEN=$E("00000",$L(LENGTH)+1,5)_LENGTH
 S @DATA@(II)="I00010IEN^T"_DLEN_"^T00001PROVIDER"_$C(30)
 ;
 I TYPE="P" D  G DONE
 . NEW NAME,IEN,TRMDT
 . S NAME=""
 . F  S NAME=$O(^VA(200,"AK.PROVIDER",NAME)) Q:NAME=""  D
 .. S IEN=""
 .. F  S IEN=$O(^VA(200,"AK.PROVIDER",NAME,IEN)) Q:IEN=""  D
 ... I $G(^VA(200,IEN,0))="" Q
 ... I NAME'=$P(^VA(200,IEN,0),U,1) Q
 ... I IEN\1'=IEN Q
 ... I $P(^VA(200,IEN,0),"^",3)="" Q
 ... I $P($G(^VA(200,IEN,"PS")),U,4)'="",DT'>$P(^("PS"),U,4) Q
 ... ;I (+$P($G(^VA(200,IEN,0)),U,11)'>0&$P(^(0),U,11)'>DT)!(+$P($G(^VA(200,IEN,0)),U,11)>0&$P(^(0),U,11)>DT) D
 ... ;I (+$P($G(^VA(200,IEN,0)),U,11)'>0)!(+$P($G(^VA(200,IEN,0)),U,11)'<DT) D
 ... I $G(FLAG)=1 S NAME=NAME_" ("_$$CLS(IEN)_")"
 ... S TRMDT=+$P($G(^VA(200,IEN,0)),U,11)
 ... I TRMDT=0 D SAV Q
 ... I TRMDT'>DT D SAV Q
 ... I TRMDT>DT D SAV Q
 ;
 NEW IEN,NAME,PFLAG,TRMDT
 S IEN=.6
 F  S IEN=$O(^VA(200,IEN)) Q:'IEN  D
 . I $G(^VA(200,IEN,0))="" Q
 . I $P(^VA(200,IEN,0),"^",3)="" Q
 . I IEN\1'=IEN Q
 . ;I (+$P($G(^VA(200,IEN,0)),U,11)'>0&$P(^(0),U,11)'>DT)!(+$P($G(^VA(200,IEN,0)),U,11)>0&$P(^(0),U,11)>DT) D
 . ;I (+$P($G(^VA(200,IEN,0)),U,11)'>0)!(+$P($G(^VA(200,IEN,0)),U,11)'<DT) D
 . S NAME=$$GET1^DIQ(200,IEN_",",.01,"E")
 . I NAME="" Q
 . S PFLAG=$S($D(^VA(200,"AK.PROVIDER",NAME,IEN)):"P",1:"")
 . I $G(FLAG)=1 S NAME=NAME_" ("_$$CLS(IEN)_")"
 . S TRMDT=+$P($G(^VA(200,IEN,0)),U,11)
 . I TRMDT=0 D SAV1 Q
 . I TRMDT'>DT D SAV1 Q
 . I TRMDT>DT D SAV1 Q
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
SAV ;EP - Save record
 S II=II+1,@DATA@(II)=IEN_"^"_NAME_$C(30)
 Q
 ;
SAV1 ;EP - Save record
 S II=II+1,@DATA@(II)=IEN_"^"_NAME_"^"_PFLAG_$C(30)
 Q
 ;
PRCL(DATA) ;EP - Get providers with class
 D USR(.DATA,"P",1)
 Q
 ;
USCL(DATA) ;EP - Get users with class
 D USR(.DATA,"",1)
 Q
 ;
COMM(DATA,FILE,FLAG) ;EP - Get the Community Table
 NEW CIEN
 S II=0
 S @DATA@(II)="I00010IEN^T00050^T00005COUNT"_$C(30)
 ;
 I $O(^XTMP("BQICOMM",0))="" D COMM^BQINIGH1
 S CIEN=0
 F  S CIEN=$O(^XTMP("BQICOMM",CIEN)) Q:'CIEN  D
 . I 'FLAG,$P(^XTMP("BQICOMM",CIEN),U,3)=0 Q
 . S II=II+1,@DATA@(II)=^XTMP("BQICOMM",CIEN)_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
CLS(PR) ; Get user classification
 S USN="",TYPE=""
 F  S USN=$O(^USR(8930.3,"B",PR,USN),-1) Q:USN=""  D
 . I '$$CURRENT^USRLM(USN) Q
 . S TYPE=$P(^USR(8930.3,USN,0),U,2)
 . I TYPE'="" S TYPE=$S($P($G(^USR(8930,TYPE,0)),U,4)'="":$P($G(^USR(8930,TYPE,0)),U,4),1:$P($G(^USR(8930,TYPE,0)),U,1))
 Q TYPE
 ;
LOCA(DATA,FLAG) ;EP - Get table of hospital locations
 S II=0
 S LENGTH=$$GET1^DID(44,.01,"","FIELD LENGTH","TEST1","ERR")
 S DLEN=$E("00000",$L(LENGTH)+1,5)_LENGTH
 S @DATA@(II)="I00010IEN^T"_DLEN_"^T00002CLIN_CODE"_$C(30)
 S IEN=0
 F  S IEN=$O(^SC(IEN)) Q:'IEN  D
 . I $G(^SC(IEN,0))="" Q
 . ; If the clinic is inactive, show it with a '*'
 . I FLAG,$P($G(^SC(IEN,"I")),U,1)'="",$P($G(^SC(IEN,"I")),U,1)'>DT,$P($G(^SC(IEN,"I")),U,2)="" S II=II+1,@DATA@(II)=IEN_"^"_$$GET1^DIQ(44,IEN_",",.01,"E")_" *"_$C(30) Q
 . I 'FLAG,$P($G(^SC(IEN,"I")),U,1)'="",$P($G(^SC(IEN,"I")),U,1)'>DT,$P($G(^SC(IEN,"I")),U,2)="" Q
 . S II=II+1,@DATA@(II)=IEN_"^"_$$GET1^DIQ(44,IEN_",",.01,"E")_"^"_$$PTR^BQIUL2(44,8,$$GET1^DIQ(44,IEN_",",8,"I"),1)_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
LOC(DATA,FLAG) ;EP - get table of hospital locations
 NEW LENGTH,DLEN,IEN,LNAME,LVAL,TY,ORD,LNM
 S II=0
 S LENGTH=$$GET1^DID(44,.01,"","FIELD LENGTH","TEST1","ERR")
 S DLEN=$E("00000",$L(LENGTH)+1,5)_LENGTH
 S @DATA@(II)="I00010IEN^T"_DLEN_"^T00002CLIN_CODE^I00010SORTORD"_$C(30)
 S IEN=0
 F  S IEN=$O(^SC(IEN)) Q:'IEN  D
 . I $G(^SC(IEN,0))="" Q
 . S LNAME=$P(^SC(IEN,0),"^",1)
 . ; If the clinic is inactive, show it with a '*'
 . I FLAG,$P($G(^SC(IEN,"I")),U,1)'="",$P($G(^SC(IEN,"I")),U,1)'>DT,$P($G(^SC(IEN,"I")),U,2)="" S LVAL("[",LNAME)=IEN Q
 . I 'FLAG,$P($G(^SC(IEN,"I")),U,1)'="",$P($G(^SC(IEN,"I")),U,1)'>DT,$P($G(^SC(IEN,"I")),U,2)="" S LVAL(1,LNAME)=IEN Q
 . S LVAL(1,LNAME)=IEN
 ;
 S TY="",ORD=0 F  S TY=$O(LVAL(TY)) Q:TY=""  D
 . S LNM="" F  S LNM=$O(LVAL(TY,LNM)) Q:LNM=""  D
 .. S IEN=LVAL(TY,LNM),LNAME=LNM
 .. I TY="[" S LNAME="*"_LNAME
 .. S ORD=ORD+1
 .. S II=II+1,@DATA@(II)=IEN_"^"_LNAME_"^"_$$PTR^BQIUL2(44,8,$$GET1^DIQ(44,IEN_",",8,"I"),1)_"^"_ORD_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
NLOC(DATA,FLAG) ;EP - Get table of locations from Notes
 NEW LENGTH,DLEN,IEN,LNAME,LVAL,TY,ORD,LNM
 S II=0
 S LENGTH=$$GET1^DID(44,.01,"","FIELD LENGTH","TEST1","ERR")
 S DLEN=$E("00000",$L(LENGTH)+1,5)_LENGTH
 S @DATA@(II)="I00010IEN^T"_DLEN_"^T00002CLIN_CODE^I00010SORTORD"_$C(30)
 S IEN=0
 F  S IEN=$O(^TIU(8925,"ALOC",IEN)) Q:IEN=""  D
 . I $G(^SC(IEN,0))="" Q
 . S LNAME=$P(^SC(IEN,0),"^",1)
 . ; If the clinic is inactive, show it with a '*'
 . I FLAG,$P($G(^SC(IEN,"I")),U,1)'="",$P($G(^SC(IEN,"I")),U,1)'>DT,$P($G(^SC(IEN,"I")),U,2)="" S LVAL("[",LNAME)=IEN Q
 . I 'FLAG,$P($G(^SC(IEN,"I")),U,1)'="",$P($G(^SC(IEN,"I")),U,1)'>DT,$P($G(^SC(IEN,"I")),U,2)="" S LVAL(1,LNAME)=IEN Q
 . S LVAL(1,LNAME)=IEN
 ;
 S TY="",ORD=0 F  S TY=$O(LVAL(TY)) Q:TY=""  D
 . S LNM="" F  S LNM=$O(LVAL(TY,LNM)) Q:LNM=""  D
 .. S IEN=LVAL(TY,LNM),LNAME=LNM
 .. I TY="[" S LNAME="*"_LNAME
 .. S ORD=ORD+1
 .. S II=II+1,@DATA@(II)=IEN_"^"_LNAME_"^"_$$PTR^BQIUL2(44,8,$$GET1^DIQ(44,IEN_",",8,"I"),1)_"^"_ORD_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
FH80(DATA) ;EP - Get the Family History Version Subset of File 80
 NEW IEN,II
 S II=0
 S @DATA@(II)="I00010IEN^T00127"_$C(30)
 ;
 I $O(^XTMP("BQIFHDX",0))="" D FHDX^BQINIGH1
 S IEN=0
 F  S IEN=$O(^XTMP("BQIFHDX",IEN)) Q:'IEN  D
 . S II=II+1,@DATA@(II)=^XTMP("BQIFHDX",IEN)_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
FHREL(DATA) ;EP - Get the Family History Version Subset of File 9999999.36
 ;
 NEW IEN,II,REL
 ;
 S II=0
 ;
 S @DATA@(II)="I00010IEN^T00070"_$C(30)
 ;
 S REL="" F  S REL=$O(^AUTTRLSH("B",REL)) Q:REL=""  S IEN="" F  S IEN=$O(^AUTTRLSH("B",REL,IEN)) Q:'IEN  D
 . N N,PCC
 . S N=$G(^AUTTRLSH(IEN,0))
 . I $P(N,U,6)=1 Q  ; Quit if inactive
 . S PCC=$P($G(^AUTTRLSH(IEN,21)),U) Q:PCC'=1  ;Filter on USE FOR PCC FAMILY HISTORY field
 . S II=II+1,@DATA@(II)=IEN_U_$P(N,U)_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DONE S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
HFCAT(DATA) ; EP - Health Factor Categories
 K LVAL
 S II=0,LN=0
 S @DATA@(II)="I00010IEN^T00060^I00010SORTORD"_$C(30)
 F  S LN=$O(^AUTTHF(LN)) Q:'LN  D
 . I $P(^AUTTHF(LN,0),"^",10)'="C" Q
 . S NAME=$P(^AUTTHF(LN,0),"^",1)
 . I $P(^AUTTHF(LN,0),"^",13)=1 S LVAL("[",NAME)=LN Q
 . S LVAL(1,NAME)=LN
 ;
 S TY="",ORD=0 F  S TY=$O(LVAL(TY)) Q:TY=""  D
 . S LNM="" F  S LNM=$O(LVAL(TY,LNM)) Q:LNM=""  D
 .. S LN=LVAL(TY,LNM),LNAME=LNM
 .. I TY="[" S LNAME="*"_LNAME
 .. S ORD=ORD+1
 .. S II=II+1,@DATA@(II)=LN_"^"_LNAME_"^"_ORD_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 K LVAL,II,LN,TY,NAME,LNM,LN,ORD
 Q
 ;
HFAC(DATA) ;EP - Health Factors
 NEW LN
 S II=0,LN=0
 S @DATA@(II)="I00010IEN^T00060^I00010SORTORD"_$C(30)
 F  S LN=$O(^AUPNVHF("B",LN)) Q:LN=""  D
 . I $G(^AUPNVHF(LN,0))="" Q
 . I $P(^AUPNVHF(LN,0),U,3)="" Q
 . S NAME=$P(^AUTTHF(LN,0),"^",1)
 . I $P(^AUTTHF(LN,0),"^",13)=1 S LVAL("[",NAME)=LN Q
 . S LVAL(1,NAME)=LN
 ;
 S TY="",ORD=0 F  S TY=$O(LVAL(TY)) Q:TY=""  D
 . S LNM="" F  S LNM=$O(LVAL(TY,LNM)) Q:LNM=""  D
 .. S LN=LVAL(TY,LNM),LNAME=LNM
 .. I TY="[" S LNAME="*"_LNAME
 .. S ORD=ORD+1
 .. S II=II+1,@DATA@(II)=LN_"^"_LNAME_"^"_ORD_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 K LVAL,II,LN,TY,NAME,LNM,LN,ORD
 Q
 ;
HTIT(DATA,HFAC) ;EP - BQI GET HEALTH FACTOR ITEMS
 NEW UID,II,LN,RET,ZZ,TEXT,HFACN,HFACT
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIUTB5T",UID))
 K @DATA,ZZ
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIUTB1 D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S @DATA@(II)="I00010IEN^T00060"_$C(30)
 S HFACN=HFAC,HFACT=$P(^AUTTHF(HFACN,0),"^",1)
 S LN=0
 F  S LN=$O(^AUTTHF("AC",HFACN,LN)) Q:'LN  D
 . S RET=$G(^AUTTHF(LN,0))
 . I RET="" Q
 . I $P(RET,"^",13)'="" Q
 . I $P(RET,"^",10)="C" Q
 . S TEXT=$P(RET,"^",1),ZZ(TEXT)=LN
 S TEXT=""
 F  S TEXT=$O(ZZ(TEXT)) Q:TEXT=""  D
 . S LN=ZZ(TEXT)
 . S II=II+1,@DATA@(II)=LN_U_TEXT_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
WCLN(DATA) ;EP - Waitlist clinics
 NEW CIEN,II,LENGTH,DLEN,DIV
 S II=0
 S LENGTH=$$GET1^DID(44,.01,"","FIELD LENGTH","TEST1","ERR")
 S DLEN=$E("00000",$L(LENGTH)+1,5)_LENGTH
 S @DATA@(II)="I00010IEN^T"_DLEN_"^T00030SITE^I00010SORTORD"_$C(30)
 S CIEN=0
 F  S CIEN=$O(^BSDWL("B",CIEN)) Q:'CIEN  D
 . I $G(^SC(CIEN,0))="" Q
 . S LN=$O(^BSDWL("B",CIEN,""))
 . S NAME=$P(^SC(CIEN,0),"^",1),DIV=$P(^SC(CIEN,0),"^",4)
 . I DIV'="" S DNAM=$P(^DIC(4,DIV,0),"^",1)
 . I $P(^BSDWL(LN,0),"^",2)=1 S LVAL("[",DNAM,NAME)=LN Q
 . I $P($G(^SC(CIEN,"I")),U,1)'="",$P($G(^SC(CIEN,"I")),U,1)'>DT,$P($G(^SC(CIEN,"I")),U,2)="" S LVAL("[",DNAM,NAME)=LN Q
 . S LVAL(1,DNAM,NAME)=LN
 ;
 S TY="",ORD=0 F  S TY=$O(LVAL(TY)) Q:TY=""  D
 . S DNM="" F  S DNM=$O(LVAL(TY,DNM)) Q:DNM=""  D
 .. S LNM="" F  S LNM=$O(LVAL(TY,DNM,LNM)) Q:LNM=""  D
 ... S LN=LVAL(TY,DNM,LNM),LNAME=LNM
 ... I TY="[" S LNAME="*"_LNAME
 ... S ORD=ORD+1
 ... S II=II+1,@DATA@(II)=LN_"^"_LNAME_"^"_DNM_"^"_ORD_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 K LVAL,II,LN,TY,NAME,LNM,LN,ORD,LNAME,DNAM,DNM,DIV
 Q
 ;
WREAS(DATA,TYP) ; WaitList Reason
 NEW II,RIEN
 S II=0
 S @DATA@(II)="I00010IEN^T00030"_$C(30)
 S RIEN=0
 F  S RIEN=$O(^BSDWLR(RIEN)) Q:'RIEN  D
 . I $G(TYP)="A",$P(^BSDWLR(RIEN,0),"^",2)'="A" Q
 . I $G(TYP)="R",$P(^BSDWLR(RIEN,0),"^",2)'="R" Q
 . S II=II+1,@DATA@(II)=RIEN_"^"_$P(^BSDWLR(RIEN,0),"^",1)_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 K II,RIEN,TYP
 Q
 ;
WPROV(DATA) ; WaitList Providers
 NEW II,PN
 S II=0
 S @DATA@(0)="I00010IEN^T00050WAIT_PROVIDER"_$C(30)
 S PN=0
 F  S PN=$O(^XTMP("BQIWLPRV",PN)) Q:'PN  D
 . S II=II+1,@DATA@(II)=PN_"^"_$P($G(^VA(200,PN,0)),"^",1)_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
WUSER(DATA,TYPE) ;Waitlist Users
 NEW II,US,GLOB
 I TYPE="A" S GLOB="BQIWLUSA"
 I TYPE="R" S GLOB="BQIWLUSR"
 S @DATA@(0)="I00010IEN^T00030"_$S(GLOB="BQIWLUSA":"USER_ADDED",1:"USER_REMOVED")_$C(30)
 S US=0,II=0
 F  S US=$O(^XTMP(GLOB,US)) Q:'US  D
 . S II=II+1,@DATA@(II)=US_"^"_$P($G(^VA(200,US,0)),"^",1)_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
WPRI(DATA) ;Waitlist Priority
 NEW SDATA,II,BI
 S II=0
 S @DATA@(II)="I00010IEN^T00045"_$C(30)
 S SDATA=$P($G(^DD(9009017.11,.02,0)),U,3) I SDATA="" Q
 F BI=1:1:$L(SDATA,";")-1 D
 . S II=II+1,@DATA@(II)=$P($P(SDATA,";",BI),":",1)_"^"_$P($P(SDATA,";",BI),":",2)_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
