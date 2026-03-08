BQICAUT2 ;GDIT/HCSD/ALA - Care mgmt utility program ; 27 Apr 2023  11:17 AM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**5**;Mar 01, 2021;Build 20
 ;
ITM(SFROM,STHRU,TAX,PTDFN,FREF,TREF) ;EP
 ; Find value for a taxonomy (TAX) or list of taxonomies (TREF)
 ; Input
 ;   TMFRAME - Timeframe to search for data
 ;   TAX     - Taxonomy
 ;   NIT     - Number of iterations
 ;   PTDFN   - Patient IEN
 ;   FREF    - File number reference
 ;   PRB     - If Active Problem okay
 ;   SAME    - If NIT is allowed for the same 30 days or not (1 same 30 days okay)
 ;   TREF    - Multiple same resulting taxonomies (e.g. MEDs) built
 ;             into reference (usually global)
 ;
 NEW RESULT,GREF,ENDT,IEN,TIEN,TEMP,QFL,VFL,SRCTYP,RVBT,RVET,VALUE,VSDTM
 S RESULT=0,TREF="TREF"
 I $G(TAX)'="" D
 . S TREF=$NA(^TMP("BQITAX",$J))
 . K @TREF
 . D BLD^BQITUTL(TAX,TREF)
 S GREF=$$ROOT^DILFD(FREF,"",1)
 S TEMP=$NA(^TMP("BQITEMP",$J)) K @TEMP
 ;
 I $G(SFROM)'="" S RVBT=9999999-STHRU,RVET=9999999-SFROM
 I $G(SFROM)="" S RVBT=9999999-DT,RVET=9999999-$O(^AUPNVSIT("B",""))\1
 S VFL=$O(^BQI(90508.6,"B",FREF,""))
 I VFL'="" S SRCTYP=$P(^BQI(90508.6,VFL,0),U,3)
 ;
 I SRCTYP=1 D  Q
 . F  S RVBT=$O(@GREF@("AA",PTDFN,RVBT)) Q:RVBT=""!(RVBT>RVET)  D
 .. S IEN=""
 .. F  S IEN=$O(@GREF@("AA",PTDFN,RVBT,IEN)) Q:IEN=""  D
 ... S TIEN=$$GET1^DIQ(FREF,IEN,.01,"I") I TIEN="" Q
 ... I '$D(@TREF@(TIEN)) Q
 ... S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 ... I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 ... S VSDTM=$P($G(^AUPNVSIT(VISIT,0)),"^",1)\1 I VSDTM=0 Q
 ... S VALUE=$$GET1^DIQ(FREF,IEN,.04,"E")
 ... ; Set temporary
 ... S @TEMP@(VSDTM,VISIT,IEN)=VALUE
 ;
 I SRCTYP=2 D
 . S TIEN="" F  S TIEN=$O(@TREF@(TIEN)) Q:TIEN=""  D
 .. F  S RVBT=$O(@GREF@("AA",PTDFN,TIEN,RVBT)) Q:RVBT=""!(RVBT>RVET)  D
 ... S IEN=""
 ... F  S IEN=$O(@GREF@("AA",PTDFN,TIEN,RVBT,IEN)) Q:IEN=""  D
 .... S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") I VISIT="" Q
 .... I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 .... S VSDTM=$P($G(^AUPNVSIT(VISIT,0)),"^",1)\1 I VSDTM=0 Q
 .... S VALUE=$$GET1^DIQ(FREF,IEN,.04,"E")
 .... S @TEMP@(VSDTM,VISIT,IEN)=VALUE
 ;
 S VSDTM="",QFL=0
 S VSDTM=$O(@TEMP@(VSDTM),-1)
 I VSDTM="" Q 0
 K @TREF
 Q VSDTM
