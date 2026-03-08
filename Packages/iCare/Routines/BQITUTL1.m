BQITUTL1 ;GDIT/HCSD/ALA - Tax/Subset Utility ; 11 May 2023  10:11 AM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**5**;Mar 01, 2021;Build 20
 ;
PROB(TAX,SNSUB,ITER,TYPE,BDFN) ;
 ;   TAX     - Taxonomy
 ;   SNSUB   - SNOMED subset
 ;   ITER    - Iteration Type (PR=Problem, PV=POV, Null=Both)
 ;   TYPE    - D=Date, Y=Y/N
 ;   BDFN    - Patient DFN
 ;
 S RESULT=""
 I $G(TAX)'="" D
 . S TREF=$NA(^TMP("BQITAX",UID))
 . K @TREF
 . D BLD^BQITUTL(TAX,TREF)
 ;
 I $G(SNSUB)'="" D
 . S REF=$NA(^TMP("BQISNO",UID))
 . K @REF
 . D SNOM^BQITUTL(SNSUB,REF)
 ;
 K BQPZZ,BQVZZ,BQZZ
 I $G(ITER)="PR" D PRB
 I $G(ITER)="PV" D POV
 I $G(ITER)="" D PRB,POV
 I $G(TYPE)="Y" D
 . I $D(BQPZZ)!($D(BQVZZ)) S RESULT="YES" Q
 . S RESULT="NO"
 I $G(TYPE)="D" D
 . NEW PRD,PVD
 . S PRD=$O(BQPZZ(""),-1),PVD=$O(BQVZZ(""),-1)
 . I PRD="",PVD="" Q
 . I PRD>PVD S RESULT=$$FMTMDY^BQIUL1(PRD)_" (IPL)" Q
 . I PVD>PRD S RESULT=$$FMTMDY^BQIUL1(PVD)_" (POV)" Q
 . I PRD=PVD S RESULT=$$FMTMDY^BQIUL1(PRD)_" (IPL/POV)"
 Q RESULT
 ;
PRB ;
 I $D(TREF) S DN="" F  S DN=$O(@TREF@(DN)) Q:DN=""  D
 . S PRN="" F  S PRN=$O(^AUPNPROB("B",DN,PRN)) Q:PRN=""  D
 .. I BDFN'=$P($G(^AUPNPROB(PRN,0)),"^",2) Q
 .. S STAT=$P(^AUPNPROB(PRN,0),"^",12) I STAT="D"!(STAT="")!(STAT="I") Q
 .. S DOO=$$PROB^BQIUL1(PRN)\1
 .. S BQPZZ(DOO,DN)="ICD"
 ;
 I $D(REF) S SN="" F  S SN=$O(@REF@(SN)) Q:SN=""  D
 . S SNID=SN,PRN=""
 . F  S PRN=$O(^AUPNPROB("ASCT",SNID,PRN)) Q:PRN=""  D
 .. I BDFN'=$P($G(^AUPNPROB(PRN,0)),"^",2) Q
 .. S STAT=$P(^AUPNPROB(PRN,0),"^",12) I STAT="D"!(STAT="")!(STAT="I") Q
 .. S DOO=$$PROB^BQIUL1(PRN)\1
 .. S BQPZZ(DOO,SNID)="SNO"
 Q
 ;
POV ;
 I $D(REF) S DN="" F  S DN=$O(@TREF@(DN)) Q:DN=""  D
 . S PRN="" F  S PRN=$O(^AUPNVPOV("B",DN,PRN)) Q:PRN=""  D
 .. I BDFN'=$P($G(^AUPNVPOV(PRN,0)),"^",2) Q
 .. S VIS=$P(^AUPNVPOV(PRN,0),"^",3)
 .. S DOO=$P(^AUPNVSIT(VIS,0),"^",1)\1
 .. S BQVZZ(DOO,DN)="ICD"
 ;
 I $D(REF) S SN="" F  S SN=$O(@REF@(SN)) Q:SN=""  D
 . S SNID=$P(@REF@(SN),"^",1),PRN=""
 . F  S PRN=$O(^AUPNVPOV("ASCI",SNID,PRN)) Q:PRN=""  D
 .. I BDFN'=$P($G(^AUPNVPOV(PRN,0)),"^",2) Q
 .. S VIS=$P(^AUPNVPOV(PRN,0),"^",3)
 .. S DOO=$P(^AUPNVSIT(VIS,0),"^",1)\1
 .. S BQVZZ(DOO,DN)="SNO"
 Q
