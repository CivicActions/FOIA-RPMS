BQIUTB1 ;PRXM/HC/ALA-Table Utilities continued ; 13 Jul 2006  3:47 PM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**1,5**;Mar 01, 2021;Build 20
 ;
 Q
 ;
SBRG(DATA,REG) ; EP -- BQI GET SUBREGISTERS
 ;Description
 ;  To return a list of register types for a registry
 ;Input
 ;  REG - Register IEN from the ICARE REGISTER INDEX file (#90507)
 NEW UID,II,FILE,X,FILE,GLBREF,IEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQITABLE",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIUTB1 D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 I $G(REG)="" S BMXSEC="No register selected" Q
 S @DATA@(II)="I00010SUBREG_IEN^T00030SUBREG_NAME^I00010REG_IEN"_$C(30)
 S FILE=$$GET1^DIQ(90507,REG_",",.12,"E")
 I FILE="" G DONE
 I '$$VFILE^DILFD(FILE) S BMXSEC="Table doesn't exist in RPMS" Q
 S GLBREF=$$ROOT^DILFD(FILE,"",1)
 ;
 S IEN=0
 F  S IEN=$O(@GLBREF@(IEN)) Q:'IEN  D
 . I $G(@GLBREF@(IEN,0))="" Q
 . I $P(@GLBREF@(IEN,0),U,1)="" Q
 . S II=II+1
 . S @DATA@(II)=IEN_"^"_$P(@GLBREF@(IEN,0),U,1)_"^"_REG_$C(30)
 ;
DONE S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
REGSTAT(DATA,REG) ; EP -- BQI GET REGISTER STATUS
 ;
 ;Description:
 ;  Returns the list of statuses associated with the register selected.
 ;  If no register is passed statuses for all registers will be returned.
 ;
 ;RPC:  BQI GET REGISTER STATUS
 ;
 ;Input:
 ;  REG - Optional register IEN from the ICARE REGISTER INDEX file (#90507)
 ;  
 ;Output:
 ;  ^TMP("BQIREG",UID,#) = Register ^ status code=description_$C(28)_status code...
 ;  where UID will be either $J or "Z" plus the Task
 ;
 N UID,X,II
 S II=0
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIREG",UID))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIUTB1 D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S II=II+1,@DATA@(II)="I00010REG_IEN^T00010STATUS_CODE^T00040STATUS_NAME"_$C(30) ;Header
 ;Retrieve set of codes for Status
 S REG=$G(REG)
 I REG D SET(REG) G RDNE
 S REG=0 F  S REG=$O(^BQI(90507,REG)) Q:'REG  D SET(REG)
 ;
RDNE S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
SET(REG) ;EP
 N FILE,FIELD,SET,I,PC
 I REG=3 D  Q
 . S II=II+1,@DATA@(II)=REG_"^A^ACTIVE"_$C(30)
 . S II=II+1,@DATA@(II)=REG_"^I^INACTIVE"_$C(30)
 S FILE=$$GET1^DIQ(90507,REG_",",.15,"E")
 S FIELD=$$GET1^DIQ(90507,REG_",",.14,"E")
 D FIELD^DID(FILE,.FIELD,,"POINTER","SET")
 Q:'$D(SET("POINTER"))
 F I=1:1:$L(SET("POINTER"),";") S PC=$P(SET("POINTER"),";",I) I PC'="" D
 . S II=II+1,@DATA@(II)=REG_"^"_$TR(PC,":","^")_$C(30)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DHLP(DATA,DXCN,COL) ;EP -- BQI GET DX CAT HELP TEXT
 ; 
 ; COL - Width of output (e.g. 132 for 132 character width)
 ; 
 NEW UID,II,DXN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQITABLE",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIUTB1 D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S DXCN=$G(DXCN,"")
 S COL=$G(COL,"")
 S @DATA@(II)="T00010DIAG_IEN^T00040DIAG_CAT^T00015DX_CAT^T01024DESC_TEXT"_$C(30)
 ;
 I DXCN'="" D  G DNE
 . I DXCN'?.N S DXN=$O(^BQI(90506.2,"B",DXCN,""))
 . I DXCN?.N S DXN=DXCN,DXCN=$P(^BQI(90506.2,DXN,0),"^",1)
 . D GDATA(DXN,COL)
 ;
 I DXCN="" D
 . F  S DXCN=$O(^BQI(90506.2,"B",DXCN)) Q:DXCN=""  D
 .. S DXN=""
 .. F  S DXN=$O(^BQI(90506.2,"B",DXCN,DXN)) Q:DXN=""  D
 ... I $P(^BQI(90506.2,DXN,0),"^",3)=1 Q
 ... I $P(^BQI(90506.2,DXN,0),"^",5)=1 Q
 ... D GDATA(DXN,COL)
DNE ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
GDATA(DXN,COL) ;EP - Get tooltip
 NEW TEXT,LEN,DXCAT,DC,ARR,I
 S DXCAT=$$GET1^DIQ(90506.2,DXN_",",.07,"E")
 S DC=0,TEXT=""
 S II=II+1
 S @DATA@(II)=DXN_"^"_DXCN_"^"_DXCAT_"^"
 I COL D  S II=II+1,@DATA@(II)=$C(30) Q
 .S DC=$O(^BQI(90506.2,DXN,3,DC)) Q:'DC
 .S II=II+1,@DATA@(II)=^BQI(90506.2,DXN,3,DC,0)
 .F  S DC=$O(^BQI(90506.2,DXN,3,DC)) Q:'DC  D
 .. S TEXT=^BQI(90506.2,DXN,3,DC,0)
 .. I TEXT="AND"!(TEXT="OR")!(TEXT?." "1AN1".".E) D UPD Q
 .. I $G(@DATA@(II))="AND"!($G(@DATA@(II))="OR") D UPD Q
 .. I $L($G(@DATA@(II)))+$L($P(TEXT," "))>COL D UPD Q
 .. S LEN=$L(@DATA@(II))+$L(TEXT)
 .. I LEN<COL S @DATA@(II)=@DATA@(II)_" "_TEXT Q
 .. F I=$L(TEXT," "):-1:1 S LEN=$L(@DATA@(II))+$L($P(TEXT," ",1,I)) I LEN<COL D  Q
 ... S @DATA@(II)=@DATA@(II)_" "_$P(TEXT," ",1,I)_$C(10)
 ... S II=II+1,@DATA@(II)=$P(TEXT," ",I+1,99)
 ;
 F  S DC=$O(^BQI(90506.2,DXN,3,DC)) Q:'DC  D
 . S II=II+1,@DATA@(II)=^BQI(90506.2,DXN,3,DC,0)_$C(10)
 S II=II+1,@DATA@(II)=$C(30)
 Q
 ;
UPD ; Update temporary global
 S @DATA@(II)=@DATA@(II)_$C(10)
 S II=II+1,@DATA@(II)=TEXT
 Q
 ;
IUSR(DATA,TYPE) ;EP - Retrieve a list of iCare Users/Employer Health Key Holding Users
 ;
 ;Input
 ;  TYPE - "I" - All iCare users
 ;         "E" - All Employer Health iCare users
 ;
 S II=0
 S LENGTH=$$GET1^DID(200,.01,"","FIELD LENGTH","TEST1","ERR")
 S DLEN=$E("00000",$L(LENGTH)+1,5)_LENGTH
 S @DATA@(II)="I00010IEN^T"_DLEN_"^T00001PROVIDER"_$C(30)
 ;
 NEW IEN,NAME,PFLAG,EFLAG,TRMDT
 S IEN=0
 F  S IEN=$O(^BQICARE(IEN)) Q:'IEN  D
 . I $G(^VA(200,IEN,0))="" Q
 . I $P(^VA(200,IEN,0),"^",3)="" Q
 . I IEN\1'=IEN Q
 . ;I (+$P($G(^VA(200,IEN,0)),U,11)'>0&$P(^(0),U,11)'>DT)!(+$P($G(^VA(200,IEN,0)),U,11)>0&$P(^(0),U,11)>DT) D
 . S TRMDT=+$P($G(^VA(200,IEN,0)),U,11)
 . I TRMDT=0 D SAV Q
 . I TRMDT'>DT D SAV Q
 . I TRMDT>DT D SAV Q
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
SAV ; Save value
 S NAME=$$GET1^DIQ(200,IEN_",",.01,"E")
 I NAME="" Q
 ;
 ;Select only Employer Health iCare users
 I TYPE="E",'$D(^XUSEC("BQIZEMPHLTH",IEN)) Q
 ;
 S PFLAG=$S($D(^VA(200,"AK.PROVIDER",NAME,IEN)):"P",1:"")
 S II=II+1,@DATA@(II)=IEN_"^"_NAME_"^"_PFLAG_$C(30)
 Q
 ;
INS(DATA) ;EP - Insurance plans
 NEW IEN,NAME
 S @DATA@(II)="T00060NAME"_$C(30)
 S NAME=""
 F  S NAME=$O(^BQIPAT("AI",NAME)) Q:NAME=""  D
 . S II=II+1,@DATA@(II)=NAME_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
IMUNO(DATA) ; EP - Immunocompromised Conditions
 NEW NAME
 S @DATA@(II)="T00060IEN^T00060"_$C(30)
 S NAME=""
 F  S NAME=$O(^BQI(90505.3,"C",NAME)) Q:NAME=""  D
 . S II=II+1,@DATA@(II)=NAME_"^"_NAME_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
HRSK(DATA) ;EP - High Risk Conditions
 NEW NAME
 S @DATA@(II)="T00060IEN^T00060"_$C(30)
 S NAME=""
 F  S NAME=$O(^BQIPAT("AH",NAME)) Q:NAME=""  D
 . S II=II+1,@DATA@(II)=NAME_"^"_NAME_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DOCC(DATA) ;EP - Class
 NEW NAME,IEN
 S @DATA@(II)="I00010IEN^T00060CLASS"_$C(30)
 S IEN="" F  S IEN=$O(^TIU(8925.1,"AT","CL",IEN)) Q:IEN=""  D
 . S NAME=$P(^TIU(8925.1,IEN,0),"^",1) I $$GET1^DIQ(8925.1,IEN_",",.07,"E")="INACTIVE" S NAME=" * "_NAME
 . S II=II+1,@DATA@(II)=IEN_"^"_NAME_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DOCD(DATA) ;EP - Document Class
 NEW NAME,IEN
 S @DATA@(II)="I00010IEN^T00060DOC_CLASS"_$C(30)
 S IEN="" F  S IEN=$O(^TIU(8925.1,"AT","DC",IEN)) Q:IEN=""  D
 . S NAME=$P(^TIU(8925.1,IEN,0),"^",1) I $$GET1^DIQ(8925.1,IEN_",",.07,"E")="INACTIVE" S NAME=" * "_NAME
 . S II=II+1,@DATA@(II)=IEN_"^"_NAME_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DOCT(DATA) ;EP - Document Title
 NEW NAME,IEN
 K ^TMP("BQIDOCT",$J)
 S @DATA@(II)="I00010IEN^T00060DOC_TITLE"_$C(30)
 S IEN=0 F  S IEN=$O(^TIU(8925,"B",IEN)) Q:IEN=""  D
 . ;S NAME=$P(^TIU(8925.1,IEN,0),"^",1) I $$GET1^DIQ(8925.1,IEN_",",.07,"E")="INACTIVE" S NAME=" * "_NAME
 . S NAME=$P($G(^TIU(8925.1,IEN,0)),"^",1) I $$GET1^DIQ(8925.1,IEN_",",.07,"E")="INACTIVE" Q
 . I NAME="" Q
 . S ^TMP("BQIDOCT",$J,NAME)=IEN
 S NAME="" F  S NAME=$O(^TMP("BQIDOCT",$J,NAME)) Q:NAME=""  D
 . S IEN=^TMP("BQIDOCT",$J,NAME)
 . S II=II+1,@DATA@(II)=IEN_"^"_NAME_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 K ^TMP("BQIDOCT",$J)
 Q
 ;
DOCS(DATA) ;EP - Document Status
 NEW NAME,IEN
 S @DATA@(II)="I00010IEN^T00030STATUS"_$C(30)
 S IEN=0 F  S IEN=$O(^TIU(8925.6,IEN)) Q:'IEN  D
 . S NAME=$P(^TIU(8925.6,IEN,0),"^",1)
 . I $P(^TIU(8925.6,IEN,0),"^",4)="DEF" Q
 . S II=II+1,@DATA@(II)=IEN_"^"_NAME_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
PFCAT(DATA) ; Patient Flag Categories
 S II=0
 S @DATA@(II)="T00010IEN^T000TITLE^I00010SORTORD"_$C(30)
 S II=II+1,@DATA@(II)="N^National^1"_$C(30)
 S II=II+1,@DATA@(II)="L^Local^2"_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
PFNAM(DATA,CAT) ; Patient Flag Names
 NEW FILE,FN,STAT
 I TYPE="N" S FILE=26.15,NUM=1
 I TYPE="L" S FILE=26.11,NUM=2
 S II=0
 S @DATA@(II)="T00010CAT^T00030TYPE^T00030NAME^I00010SORTORD"_$C(30)
 S NUM=1,FILE=26.15,FN=0
 F  S FN=$O(^DGPF(FILE,FN)) Q:'FN  D
 . S STAT=$P(^DGPF(FILE,FN,0),"^",3),NAME=$P(^(0),"^",1)
 . I 'STAT S LVAL("[",NUM,NAME)=FN
 . I STAT S LVAL(1,NUM,NAME)=FN
 S NUM=2,FILE=26.11,FN=0
 F  S FN=$O(^DGPF(FILE,FN)) Q:'FN  D
 . S STAT=$P(^DGPF(FILE,FN,0),"^",3),NAME=$P(^(0),"^",1)
 . I 'STAT S LVAL("[",NUM,NAME)=FN
 . I STAT S LVAL(1,NUM,NAME)=FN
 Q
