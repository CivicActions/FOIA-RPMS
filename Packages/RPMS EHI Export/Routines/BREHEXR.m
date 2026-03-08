BREHEXR ;GDIT/HS/BEE-BREH Custom Routine Looping Calls
 ;;1.0;RPMS EHI EXPORT;**2**;Jun 15, 2023;Build 5
 ;
 Q
 ;
F35693(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT) ;Return the next file 356.93 entry for the patient
 ;
 ;^IBT(356.93,""AMVD"",X,+$P(^(0),U,3),DA)="""""
 NEW AFILE,AIEN,PMOV,ADAT,PPFILE,EXEC
 ;
 ;Get the alternate file
 S AFILE=$$GET1^DIQ(90314.01,FIEN_",",.04,"I") Q:AFILE="" ""
 ;
 ;See if file has already been processed
 I '$D(^BREHEXP("FILE",COUNT,DFN,AFILE)) D  Q:$D(^TMP("BREH_EXPORT",$J,"QUIT")) ""
 . NEW STS,PFILE
 . ;
 . ;File has not been processed, process it now
 . S PFILE=$O(^BREHFDEF("B",AFILE,"")) Q:PFILE=""
 . S STS=$$PROC^BREHEXL(SCHEMA,COUNT,DFN,PFILE,.OUTPUT)
 . I $P(STS,"|")=-1 S ^TMP("BREH_EXPORT",$J,"QUIT")=STS
 ;
 ;Get the last values
 S PMOV=$P(KEY,"|")
 S ADAT=$P(KEY,"|",2)
 S AIEN=$P(KEY,"|",3)
 ;
 ;Look for next entry for index
 I PMOV]"",ADAT]"" S AIEN=$O(^IBT(356.93,"AMVD",PMOV,ADAT,AIEN)) I AIEN]"" S KEY=PMOV_"|"_ADAT_"|"_AIEN Q AIEN
 ;
 ;No entry - get next date
 S AIEN=""
 I PMOV]"" S ADAT=$O(^IBT(356.93,"AMVD",PMOV,ADAT)) I ADAT]"" D  I AIEN]"" S KEY=PMOV_"|"_ADAT_"|"_AIEN Q AIEN
 . ;
 . ;Now get the next entry
 . S AIEN=$O(^IBT(356.93,"AMVD",PMOV,ADAT,""))
 ;
 ;No more for date - get next movement by looping through patient's 405 entries
 S AIEN="",ADAT=""
 S EXEC="S PPFILE=$NA(^||BREHFIEN)" X EXEC
 F  S PMOV=$O(@PPFILE@("IENS",COUNT,DFN,AFILE,PMOV)) Q:PMOV=""  D  I AIEN]"" Q
 . ;
 . ;Found movement, now get the next date
 . F  S ADAT=$O(^IBT(356.93,"AMVD",PMOV,ADAT)) Q:ADAT=""  D  I AIEN]"" Q
 .. ;
 .. ;Found date, now get the next entry
 .. S AIEN=$O(^IBT(356.93,"AMVD",PMOV,ADAT,""))
 ;
 ;See if entry found
 I AIEN]"" S KEY=PMOV_"|"_ADAT_"|"_AIEN Q AIEN
 ;
 ;No entry found
 S KEY=""
 ;
 Q ""
 ;
F100(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT) ;Return the next file 100 entry for the patient
 ;
 I +DFN=0 Q ""
 ;
 NEW ORD,FIEN
 ;
 S KEY=$G(KEY)
 ;
 ;Get the last key
 S FIEN=$P(KEY,"|",2)
 ;
 ;Get the last order
 S ORD=$P(KEY,"|")
 ;
 ;Look for next entry for order
 I ORD]"" S FIEN=$O(^OR(100,"AC",DFN_";DPT(",ORD,FIEN)) I FIEN]"" S KEY=ORD_"|"_FIEN Q FIEN
 ;
 ;No entry - get next ORD
 S ORD=$O(^OR(100,"AC",DFN_";DPT(",ORD)) I ORD="" S KEY="" Q ""
 ;
 ;Relation found - get next entry
 S FIEN=$O(^OR(100,"AC",DFN_";DPT(",ORD,"")) I FIEN]"" S KEY=ORD_"|"_FIEN Q FIEN
 ;
 S KEY=""
 ;
 Q ""
 ;
F52(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT) ;Return the next file 52 entry for the patient
 ;
 I +DFN=0 Q ""
 ;
 NEW IEN
 ;
 S KEY=+$G(KEY)
 S IEN=""
 ;
 ;Loop through PHARMACY PATIENT to get prescriptions
 S KEY=$O(^PS(55,DFN,"P",KEY)) S:'KEY KEY=""
 I KEY]"" S IEN=$P($G(^PS(55,DFN,"P",KEY,0)),U)
 ;
 Q IEN
 ;
FHREL(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT) ;Return the next file 9000014.1 entry for the patient
 ;
 NEW REL,FIEN
 ;
 S KEY=$G(KEY)
 ;
 ;Get the last key
 S FIEN=$P(KEY,"|",2)
 ;
 ;Get the last relation
 S REL=$P(KEY,"|")
 ;
 ;Look for next entry for relation
 I REL]"" S FIEN=$O(^AUPNFHR("AA",DFN,REL,FIEN)) I FIEN]"" S KEY=REL_"|"_FIEN Q FIEN
 ;
 ;No entry - get next relation
 S REL=$O(^AUPNFHR("AA",DFN,REL)) I REL="" S KEY="" Q ""
 ;
 ;Relation found - get next entry
 S FIEN=$O(^AUPNFHR("AA",DFN,REL,"")) I FIEN]"" S KEY=REL_"|"_FIEN Q FIEN
 ;
 S KEY=""
 ;
 Q ""
 ;
LR63(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT) ;Return the file 63 entry (should only be one)
 ;
 NEW LRDFN
 ;
 ;If already found, clear and quit
 I $G(KEY)'="" S KEY="" Q ""
 ;
 S LRDFN=$P($G(^DPT(DFN,"LR")),U) Q:LRDFN="" ""
 ;
 ;Set key equal to LRDFN
 S KEY=LRDFN
 ;
 Q KEY
 ;
SF69(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT,SFARRY) ;Return the next file 69 specimen entry references for the patient
 ;
 NEW SDATE,SIEN,LRDFN
 ;
 ;Check for DFN
 I +$G(DFN)=0 Q ""
 ;
 ;Reset array of patient specimens
 K SFARRY
 ;
 ;Get LRDFN - Quit if not found
 S LRDFN=$P($G(^DPT(DFN,"LR")),U) Q:LRDFN="" ""
 ;
 ;Get the last one returned
 S (SDATE,KEY)=$G(KEY)
 ;
 ;Look for the next specimen date
 S SDATE=$O(^LRO(69,"D",LRDFN,SDATE)) I SDATE="" S KEY="" Q ""
 S KEY=SDATE
 ;
 ;Now retrieve specimens on that date for that patient
 S SFARRY(69.01)="",SIEN=0 F  S SIEN=$O(^LRO(69,"D",LRDFN,SDATE,SIEN)) Q:'SIEN  S SFARRY(69.01,SIEN_","_SDATE_",")=""
 ;
 Q KEY
 ;
BLRA(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT,SFARRY) ;Return the next file 9009026.82 entry reference
 ;
 Q $$BLRA^BREHEXR3($G(SCHEMA),$G(COUNT),$G(FIEN),$G(DFN),.KEY,OUTPUT,.SFARRY)
 ;
F65(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT,SFARRY) ;Return the next file 9009018.1 entry reference
 ;
 Q $$F65^BREHEXR3($G(SCHEMA),$G(COUNT),$G(FIEN),$G(DFN),.KEY,OUTPUT,.SFARRY)
 ;
BDGSPT(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT,SFARRY) ;Return the next file 9009018.1 entry reference
 ;
 Q $$BDGSPT^BREHEXR1($G(SCHEMA),$G(COUNT),$G(FIEN),$G(DFN),.KEY,OUTPUT,.SFARRY)
 ;
BSDWL(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT,SFARRY) ;Return the next file 9009017.1 entry reference
 ;
 Q $$BSDWL^BREHEXR1($G(SCHEMA),$G(COUNT),$G(FIEN),$G(DFN),.KEY,OUTPUT,.SFARRY)
 ;
ASDWL(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT,SFARRY) ;Return the next file 9009015 entry reference
 ;
 Q $$ASDWL^BREHEXR1($G(SCHEMA),$G(COUNT),$G(FIEN),$G(DFN),.KEY,OUTPUT,.SFARRY)
 ;
ACHSDEF(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT,SFARRY) ;Return the next file 9002066 entry reference
 ;
 Q $$ACHSDEF^BREHEXR1($G(SCHEMA),$G(COUNT),$G(FIEN),$G(DFN),.KEY,OUTPUT,.SFARRY)
 ;
ACHSDEN(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT,SFARRY) ;Return the next file 9002071 entry reference
 ;
 Q $$ACHSDEN^BREHEXR1($G(SCHEMA),$G(COUNT),$G(FIEN),$G(DFN),.KEY,OUTPUT,.SFARRY)
 ;
AMHGROUP(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT,SFARRY) ;Return the next file 9002011.67 entry reference
 ;
 Q $$AMHGROUP^BREHEXR1($G(SCHEMA),$G(COUNT),$G(FIEN),$G(DFN),.KEY,OUTPUT,.SFARRY)
 ;
PCD(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT) ;Return the next file 3PCD entry reference
 ;
 Q $$PCD^BREHEXR1($G(SCHEMA),$G(COUNT),$G(FIEN),$G(DFN),.KEY,.OUTPUT)
 ;
PCCD(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT) ;Return the next file 3PCD entry reference
 ;
 Q $$PCCD^BREHEXR1($G(SCHEMA),$G(COUNT),$G(FIEN),$G(DFN),.KEY,.OUTPUT)
 ;
PBILL(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT) ;Return the next file 3P BILL entry reference
 ;
 Q $$PBILL^BREHEXR1($G(SCHEMA),$G(COUNT),$G(FIEN),$G(DFN),.KEY,.OUTPUT)
 ;
BARBL(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT) ;Return the next file A/R BILL/IHS entry reference
 ;
 Q $$BARBL^BREHEXR1($G(SCHEMA),$G(COUNT),$G(FIEN),$G(DFN),.KEY,.OUTPUT)
 ;
BARAC(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT) ;Return the next file A/R BILL/IHS entry reference
 ;
 Q $$BARAC^BREHEXR1($G(SCHEMA),$G(COUNT),$G(FIEN),$G(DFN),.KEY,.OUTPUT)
 ;
BARTR(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT) ;Return the next file A/R BILL/IHS entry reference
 ;
 Q $$BARTR^BREHEXR1($G(SCHEMA),$G(COUNT),$G(FIEN),$G(DFN),.KEY,.OUTPUT)
 ;
BARPPAY(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT) ;Return the next file A/R PREPAYMENT entry reference
 ;
 Q $$BARPPAY^BREHEXR1($G(SCHEMA),$G(COUNT),$G(FIEN),$G(DFN),.KEY,.OUTPUT)
 ;
MCCLM(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT,SFARRY) ;Return the next file MEDICAID CLAIM 1800071 entry reference
 ;
 Q $$MCCLM^BREHEXR2($G(SCHEMA),$G(COUNT),$G(FIEN),$G(DFN),.KEY,OUTPUT,.SFARRY)
 ;
ASMT(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT,SFARRY) ;Return the next file THIRD PARTY ELIGIBLE 1800008 entry reference
 ;
 Q $$ASMT^BREHEXR2($G(SCHEMA),$G(COUNT),$G(FIEN),$G(DFN),.KEY,OUTPUT,.SFARRY)
 ;
BARBLER(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT) ;Return the next file THIRD PARTY ELIGIBLE 1800008 entry reference
 ;
 Q $$BARBLER^BREHEXR2($G(SCHEMA),$G(COUNT),$G(FIEN),$G(DFN),.KEY,.OUTPUT)
 ;
FRP(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT,SFARRY) ;Return the next file A/R FLAT RATE POSTING 90054.01 entry reference
 ;
 Q $$FRP^BREHEXR2($G(SCHEMA),$G(COUNT),$G(FIEN),$G(DFN),.KEY,OUTPUT,.SFARRY)
 ;
CLST(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT) ;Return the next file A/R EDI CLAIM STATUS 90056.08 entry reference
 ;
 Q $$CLST^BREHEXR2($G(SCHEMA),$G(COUNT),$G(FIEN),$G(DFN),.KEY,.OUTPUT)
 ;
CDMISCC(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT,SFARRY) ;Return the next file CDMIS CLIENT CATEGORY entry references for the patient
 ;
 Q $$CDMISCC^BREHEXR2($G(SCHEMA),$G(COUNT),$G(FIEN),$G(DFN),.KEY,OUTPUT,.SFARRY)
 ;
CCR(SCHEMA,COUNT,FIEN,DFN,KEY,OUTPUT,SFARRY) ;Return the next file CHS CHEF REGISTRY entry references for the patient
 ;
 Q $$CCR^BREHEXR2($G(SCHEMA),$G(COUNT),$G(FIEN),$G(DFN),.KEY,OUTPUT,.SFARRY)
