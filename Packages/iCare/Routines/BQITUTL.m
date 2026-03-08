BQITUTL ;PRXM/HC/ALA-Diagnoses Category Utility Program ; 02 Mar 2006  1:21 PM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**1,3,5,7**;Mar 01, 2021;Build 14
 Q
 ;
BLD(TAX,REF,BQTTYP) ;PEP - Build a taxonomy
 NEW BQTXN,FLREF
 ;Input
 ;  TAX - Taxonomy name
 ;  REF - reference where list will reside
 I '$$PATCH^XPDUTL("ATX*5.1*11") D BLDTAX^BQITUIX(TAX,REF) Q
 S BQTTYP=$G(BQTTYP,"")
 I BQTTYP="" D
 . S BQQN=$O(^BQI(90508,1,10,"B",TAX,""))
 . I BQQN'="" S BQQY=$P(^BQI(90508,1,10,BQQN,0),U,3)
 . S BQTTYP=$S($G(BQQY)=5:"L",1:"")
 I BQTTYP="L" S BQTXN=$O(^ATXLAB("B",TAX,""))
 E  S BQTXN=$O(^ATXAX("B",TAX,0))
 I BQTXN="" Q
 S FLREF=$S(BQTTYP="":$P(^ATXAX(BQTXN,0),"^",15),1:60)
 I FLREF=9999999.64 D  Q
 . NEW IEN
 . S IEN=$O(^ATXAX(BQTXN,21,"B","")) I IEN'?.N D BLDTAX^ATXAPI(TAX,REF,BQTXN,BQTTYP) Q
 . S IEN="" F  S IEN=$O(^ATXAX(BQTXN,21,"B",IEN)) Q:IEN=""  S @REF@(IEN)=$P(^AUTTHF(IEN,0),"^",1)
 D BLDTAX^ATXAPI(TAX,REF,BQTXN,BQTTYP)
 K BQTTYP,BQQY
 Q
 ;
BLDSV(FILEREF,TVAL,TARGET) ;PEP - Add a single value to a taxonomy
 ;Description
 ;  Use this if no taxonomy was given but an individual code
 ;Input
 ;  FILEREF - File where the code resides
 ;  TVAL - Value
 ;  TARGET - reference where entry is to be placed
 ;
 ; The LOINC x-ref in LAB does not use the check digit (piece 2).
 I FILEREF=95.3 S FILE="^LAB(60)",INDEX="AF",TVAL=$P(TVAL,"-")
 I FILEREF=80 S FILE="^ICD9",INDEX="BA"
 I FILEREF=80.1 S FILE="^ICD0",INDEX="BA"
 I FILEREF=81 S FILE="^ICPT",INDEX="BA"
 S END=TVAL_$S(FILEREF=95.3:TVAL,1:TVAL_" ")
 ;
 ; Backup one entry so loop can find all the entries in the range.
 S TVAL=$O(@FILE@(INDEX,TVAL),-1)
 F  S TVAL=$O(@FILE@(INDEX,TVAL)) Q:TVAL=""  Q:$$CHECK(TVAL,END)  D
 .S IEN=""
 .F  S IEN=$O(@FILE@(INDEX,TVAL,IEN)) Q:IEN=""  D
 ..S NAME=$P($G(@FILE@(IEN,0)),U,1)
 ..S @TARGET@(IEN)=NAME
 ;
 K FILEREF,FILE,INDEX,TVAL,END,NAME,IEN
 Q
 ;
SNOM(SUB,REF) ;PEP - Build a SNOMED subset
 NEW BQIOK,TTREF
 S TTREF=$NA(^TMP("BQISNOM",$J)) K @TTREF
 S BQIOK=$$SUBLST^BSTSAPI(TTREF,SUB_"^36^1")
 S BQN="" F  S BQN=$O(@TTREF@(BQN)) Q:BQN=""  S CID=$P(@TTREF@(BQN),U,1),@REF@(CID)=$P(@TTREF@(BQN),U,3)
 K @TTREF
 Q
 ;
CHECK(V,E) ;EP
 N Z
 I V=E Q 0
 S Z(V)=""
 S Z(E)=""
 I $O(Z(""))=E Q 1
 Q 0
 ;
ARY(DEF,REF) ;EP - Build an array from a definition
 ;Input
 ;  DEF - Definition name
 ;  REF - array name
 ;
 NEW IEN,BN,BDXN,DIC,X,Y,DATA,ADD,REM
 S DIC(0)="NZ",X=DEF,DIC="^BQI(90506.2,"
 D ^DIC
 S BDXN=+Y I BDXN<1 Q
 ;
 S BN=0
 F  S BN=$O(^BQI(90506.2,BDXN,5,"B",BN)) Q:'BN  D
 . S IEN=0
 . F  S IEN=$O(^BQI(90506.2,BDXN,5,"B",BN,IEN)) Q:'IEN  D
 .. S DATA=^BQI(90506.2,BDXN,5,IEN,0)
 .. ; If the taxonomy check only flag is set, do not include
 .. I $P(DATA,U,11)=1 Q
 .. ; Exclude the SEARCH ORDER field and only take pieces 2-10
 .. S @REF@(BN)=$P(DATA,U,2,10)
 .. I $D(^BQI(90506.2,BDXN,5,IEN,1)) D
 ... S ADD="",CD="" F  S CD=$O(^BQI(90506.2,BDXN,5,IEN,1,"B",CD)) Q:CD=""  S ADD=ADD_CD_"|"
 ... S ADD=$$TKO^BQIUL1(ADD,"|")
 .. I $D(^BQI(90506.2,BDXN,5,IEN,2)) D
 ... S REM="",CD="" F  S CD=$O(^BQI(90506.2,BDXN,5,IEN,2,"B",CD)) Q:CD=""  S REM=REM_CD_"|"
 ... S REM=$$TKO^BQIUL1(REM,"|")
 .. S $P(@REF@(BN),"^",10)=$G(ADD),$P(@REF@(BN),"^",11)=$G(REM)
 Q
 ;
GDF(BQDN,BQREF) ;EP - Get basic Definition information
 ;  used mainly for the subdefinitions which can be called
 ;  by the code in the main diagnosis category executable program
 ;
 ;Input
 ;  BQDN  - Diag Cat definition internal entry number
 ;  BQREF - Array reference
 ;Output
 ;  BQDEF  - Definition name
 ;  BQEXEC - Diag Cat special executable program
 ;  BQPRG  - Diag Cat standard executable program
 ;  BQGLB  - Temporary global reference
 ;
 ;  If it's inactive, ignore
 I $$GET1^DIQ(90506.2,BQDN_",",.03,"I")=1 Q
 S BQDEF=$$GET1^DIQ(90506.2,BQDN_",",.01,"E")
 S BQEXEC=$$GET1^DIQ(90506.2,BQDN_",",1,"E")
 S BQPRG=$$GET1^DIQ(90506.2,BQDN_",",.04,"E")
 ;I $G(BQREF)="" S BQREF="BQIRY"
 K @BQREF
 D ARY(BQDEF,BQREF)
 S BQGLB=$NA(^TMP("BQIPOP",UID))
 K @BQGLB
 Q
 ;
GDXN(DEF) ;EP - Get IEN of a definition
 ;Input
 ;  DEF - Diagnosis Category definition name
 ;Output
 ;  Returns the internal entry number of the category definition
 NEW DIC,X,Y
 S DIC(0)="NZ",X=DEF,DIC="^BQI(90506.2,"
 D ^DIC
 Q +Y
 ;
MEAS(BQDFN,MEAS) ;EP - Get measurement
 NEW VALUE,RVDT,QFL,IEN,RES,VISIT,RESULT,VDATE
 I MEAS'?.N S MEAS=$$FIND1^DIC(9999999.07,,"MX",MEAS)
 S VALUE=0
 S RVDT="",QFL=0
 F  S RVDT=$O(^AUPNVMSR("AA",BQDFN,MEAS,RVDT)) Q:RVDT=""  D  Q:QFL
 . S IEN=""
 . F  S IEN=$O(^AUPNVMSR("AA",BQDFN,MEAS,RVDT,IEN)) Q:IEN=""  D  Q:QFL
 .. ; if the new ENTERED IN ERROR field exists, exclude the record if it is marked as an error
 .. I $$VFIELD^DILFD(9000010.01,2) Q:$$GET1^DIQ(9000010.01,IEN_",",2,"I")=1
 .. S RES=$G(^AUPNVMSR(IEN,0)),VISIT=$P(RES,U,3),RESULT=$P(RES,U,4),VDATE=""
 .. I $P($G(^AUPNVMSR(IEN,2)),U,1)=1 Q
 .. I VISIT'="" S VDATE=$P(^AUPNVSIT(VISIT,0),U,1)\1
 .. S VALUE="1^"_VDATE_U_RESULT_U_VISIT_U_IEN,QFL=1
 Q VALUE
 ;
EXAM(BQDFN,EXAM) ;EP - Get exam
 NEW VALUE,RVDT,QFL,IEN,RES,VISIT,RESULT,VDATE
 I EXAM'?.N S EXAM=$$FIND1^DIC(9999999.15,,"MX",EXAM)
 S VALUE=0
 S RVDT="",QFL=0
 F  S RVDT=$O(^AUPNVXAM("AA",BQDFN,EXAM,RVDT)) Q:RVDT=""  D  Q:QFL
 . S IEN=""
 . F  S IEN=$O(^AUPNVXAM("AA",BQDFN,EXAM,RVDT,IEN)) Q:IEN=""  D  Q:QFL
 .. S RES=$G(^AUPNVXAM(IEN,0)),VISIT=$P(RES,U,3),RESULT=$P(RES,U,4),VDATE=""
 .. I VISIT'="" S VDATE=$P(^AUPNVSIT(VISIT,0),U,1)\1
 .. S VALUE="1^"_VDATE_U_RESULT_U_VISIT_U_IEN,QFL=1
 Q VALUE
 ;
RXNM(BQISUB,REF) ; EP - Get drugs for RXNORM subset
 NEW BQILIST,BQSN,RI,CODE,LIEN,RXN,DN
 I $E(BQISUB,1,4)'="RXNO" Q
 I $E(BQISUB,1,4)="RXNO" S BQTY=1552
 S BQILIST=$NA(^TMP("BQISNSB",$J)) K @BQILIST
 S OK=$$SUBLST^BSTSAPI(BQILIST,BQISUB_"^"_BQTY_"^1")
 ;
 S BQSN=0,RI=0
 F  S BQSN=$O(@BQILIST@(BQSN)) Q:BQSN=""  D
 . S CODE=$P(@BQILIST@(BQSN),"^",1)
 . S LIEN=$O(^BSTS(9002318.4,"C",BQTY,CODE,""))
 . S RXN=$P(^BSTS(9002318.4,LIEN,0),"^",2)
 . S DN="" F  S DN=$O(^PSDRUG("RXCUI",RXN,DN)) Q:DN=""  D
 .. S RI=RI+1,@REF@(DN)=$P(^PSDRUG(DN,0),"^",1)
 K @BQILIST
 Q
