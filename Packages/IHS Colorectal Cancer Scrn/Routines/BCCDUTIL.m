BCCDUTIL ;GDIT/HS/BEE-BCCD Utilities ; 08 Apr 2013  9:28 AM
 ;;2.0;CCDA;**1,3**;Aug 12, 2020;Build 139
 ;
 Q
 ;
SESP ;Set 90310.02 field 4 index
 I $G(X)="" Q
 I $G(DA)="" Q
 I $G(DA(1))="" Q
 S ^BCCDS(90310.02,"C",X,DA(1),DA)=""
 Q
 ;
KESP ;Kill 90310.02 field 4 index
 I $G(X)="" Q
 I $G(DA)="" Q
 I $G(DA(1))="" Q
 K ^BCCDS(90310.02,"C",X,DA(1),DA)
 Q
 ;
PLKUP(CONCID,DFN) ;Return a problem IEN for the supplied SNOMED and DFN
 ;
 NEW PIEN
 ;
 ;Validate entry
 I $G(CONCID)="" Q ""
 I $G(DFN)="" Q ""
 ;
 ;Look for the problem entry
 S PIEN=$O(^AUPNPROB("APCT",DFN,CONCID,""))
 ;
 ;Ignore deleted problems
 I PIEN]"" D
 . I $$GET1^DIQ(9000011,PIEN_",",.12,"I")="D" S PIEN="" Q   ;Status
 . I $$GET1^DIQ(9000011,PIEN_",",2.01,"I")]"" S PIEN="" Q   ;Deleted by
 . I $$GET1^DIQ(9000011,PIEN_",",2.02,"I")]"" S PIEN="" Q   ;Deleted date/time
 ;
 Q PIEN
 ;
PLOOK(DATE) ;EP - Return Pending Look back days
 ;
 NEW X1,X2,X
 ;
 S X1=DATE,X2=-365 D C^%DTC
 Q X
 ;
ERVST(VLIST) ;Return ER visit prior up to 72 hours before hospital visit
 ;
 NEW VIEN,PVDT,SEVENTY2,PVIEN,PVDAY,TFAR,DFN,PVIEN
 ;
 S (PVDT,VIEN)="" F  S VIEN=$O(VLIST(VIEN)) Q:VIEN=""  D  I PVDT]"" Q
 . I $$GET1^DIQ(9000010,VIEN_",",.07,"I")'="H" Q
 . S PVDT=$$GET1^DIQ(9000010,VIEN_",",.01,"I")
 . S PVIEN=VIEN
 I PVDT="" Q ""
 ;
 ;Get patient
 S DFN=$$GET1^DIQ(9000010,PVIEN_",",.05,"I") I DFN="" Q ""
 ;
 ;Go back 72 hours (3 days)
 S SEVENTY2=$$FMADD^XLFDT(PVDT,"",-72,"","")
 ;
 ;Now loop through patient visits and look for most recent ER/Urgent Care visit
 ;
 ;Calculate where to start from by converting current visit date/time
 S PVDT=(9999999-$P(PVDT,"."))_"."_$P(PVDT,".",2)
 S PVIEN="",PVDAY=$P(PVDT,".")
 ;
 ;Loop backwards by date. If date changes, go get the next date.
ERV1 S TFAR="" F  S PVDT=$O(^AUPNVSIT("AA",DFN,PVDT),-1) Q:PVDT=""  Q:($P(PVDT,".")'=PVDAY)  D  I (PVIEN'="")!TFAR Q
 . S VIEN="" F  S VIEN=$O(^AUPNVSIT("AA",DFN,PVDT,VIEN),-1) Q:VIEN=""  D  I (PVIEN'="")!TFAR Q
 .. NEW CLINIC,ADMT
 .. ;
 .. ;Determine if too far back
 .. S ADMT=$$GET1^DIQ(9000010,VIEN_",",.01,"I")
 .. I ADMT<SEVENTY2 S TFAR=1 Q
 .. ;
 .. ;Locate ER/Urgent Care visits
 .. S CLINIC=$$GET1^DIQ(9000010,VIEN_",",".08","E")
 .. I CLINIC'="EMERGENCY MEDICINE",CLINIC'="URGENT CARE",CLINIC'="TRIAGE" Q
 .. ;
 .. ;Skip deleted visits
 .. I $$GET1^DIQ(9000010,VIEN_",",".11","I") Q
 .. ;
 .. ;Found a visit
 .. S PVIEN=VIEN
 ;
 ;Quit if visit found
 I PVIEN'="" G XERV
 ;
 ;The previous visit was not found in this date range. Get the next date
 ;in the index and send back to the loop to order by visit time.
 S PVDT=PVDAY_".9999"
 S PVDT=$O(^AUPNVSIT("AA",DFN,PVDT))
 I PVDT="" G XERV
 S PVDAY=$P(PVDT,"."),PVDT=$P(PVDT,".")_".9999" G ERV1
 ;
 ;If we didn't find a previous provider visit, use the most recent visit.
XERV Q PVIEN
 ;
LOINC(ACCN,PRTIEN,LCLIST) ;EP - Return a list of LOINC values for an accession number
 ;
 I $G(ACCN)="" Q
 ;
 NEW VLIEN
 ;
 S VLIEN="" F  S VLIEN=$O(^AUPNVLAB("ALR0",ACCN,VLIEN)) Q:VLIEN=""  D
 . NEW LOINC,PIEN
 . ;
 . ;Make sure the parent IEN matches
 . I $$GET1^DIQ(9000010.09,VLIEN_",",1208,"I")'=PRTIEN Q
 . ;
 . ;Get the LOINC
 . S LOINC=$$GET1^DIQ(9000010.09,VLIEN_",",1113,"E") Q:LOINC=""
 . S LCLIST(LOINC)=""
 Q
 ;
VSTLST(DFN,BCCDVLST) ;EP - Return list of visits for a patient
 ;
 ;Input
 ;      DFN - Patient IEN
 ; BCCDVLST - Array to return VIEN list in
 ;
 ;Output
 ; Total VIENs returned
 ;
 I +$G(DFN)<1 Q 0
 ;
 NEW BCCDIEN,BCCDCNT
 ;
 ;Set up array
 S BCCDIEN="",BCCDCNT=0 F  S BCCDIEN=$O(^AUPNVSIT("AC",DFN,BCCDIEN)) Q:BCCDIEN=""  D
 . S BCCDVLST(BCCDIEN)=""
 . S BCCDCNT=BCCDCNT+1
 Q BCCDCNT
 ;
ICDDX(CIEN,CDT) ;EP - Retrieve ICD DX information
 ;
 S:$G(U)="" U="^"
 S DT=$$DT^XLFDT
 ;
 ;Call AUPN API to retrieve ICD info
 Q $$ICDDX^AUPNVUTL(CIEN,CDT)
 ;
ICDOP(CIEN,CDT) ;EP - Retrieve ICD OP information
 ;
 S:$G(U)="" U="^"
 S DT=$$DT^XLFDT
 ;
 ;Call AUPN API to retrieve ICD info
 Q $$ICDOP^AUPNVUTL(CIEN,CDT)
 ;
 ;GDIT/HS/BEE;FEATURE#76183;PBI#82985;02/09/22;Filter out particular stop codes
ELGVST(VIEN,SCSKIP) ;Return if an eligible visit by stop code
 ;
 Q $$ELGVST^BCCDUTL2($G(VIEN),$G(SCSKIP))
 ;
PRVVST(DFN,VLIST,STDT,ENDT,SCSKIP) ;EP - Return the previous provider visit IEN if one exists;
 ; otherwise, return the most recent previous visit
 ;
 ; If no visit list, the return most recent provider visit if one exists; otherwise,
 ; return the most recent visit. Skip deleted visits unless it's the most recent.
 ;
 ;Input:
 ;  DFN - Patient DFN
 ;  VLIST - List of patient visits to look at
 ;  STDT - Earliest visit date and time
 ;  ENDT - Latest visit date and time
 ;SCSKIP - Skip visits with Stop Codes
 ;
 NEW PVIEN,VIEN,PVDT,NVLIST,PVDAY,SCAT,VDTM,MRVIEN,QUIT
 ;
 I $G(DFN)="" Q ""
 S STDT=$G(STDT)
 S ENDT=$G(ENDT)
 S SCSKIP=$G(SCSKIP)
 ;
 I STDT]"" D
 . NEW STIME
 . S STIME=$P(STDT,".",2)
 . S STDT=9999999-$P(STDT,".")
 . I STIME]"" S STDT=STDT_"."_STIME
 ;
 ;Look for end date
 S PVDT=""
 I ENDT]"" D
 . S PVDT=ENDT
 . I $P(ENDT,".",2)]"" S PVDT=PVDT_"."_$P(ENDT,".",2)+".0000001"
 . E  S PVDT=PVDT_".99999999"
 ;
 ;Loop through visit list and get dates
 I PVDT="" D
 . S VIEN="" F  S VIEN=$O(VLIST(VIEN)) Q:VIEN=""  D
 .. S VDTM=$$GET1^DIQ(9000010,VIEN_",",.01,"I") Q:VDTM=""
 .. S NVLIST(VDTM,VIEN)=""
 . ;
 . ;Pull the earliest visit date/time in the list.
 . ;If none found, we are going to return the latest visit.
 . S PVDT=$O(NVLIST(""))
 . I PVDT="" D  Q:PVDT=""
 .. S PVDT=$O(^AUPNVSIT("AA",DFN,"")) Q:PVDT=""
 .. S PIEN=$O(^AUPNVSIT("AA",DFN,PVDT,""),-1) I PIEN="" S PVDT="" Q
 .. S PVDT=$$GET1^DIQ(9000010,PIEN_",",.01,"I") Q:PVDT=""
 .. S PVDT=$P(PVDT,".")_".99999999"
 ;
 I PVDT="" S PVDT=DT_".99999999"
 ;
 ;Loop through and grab the previous visit and the last provider visit.
 ;Since the "AA" index is reversed-timed by date with the visit time tacked on
 ;to the end of the value, the index cannot be looped straight through because
 ;the date portion will be okay chronologically, but within each date those entries
 ;will be in reverse order.  We therefore have to loop through by date and within
 ;each date move backwards by visit time.
 ;
 ;Calculate where to start from by converting current visit date/time
 S PVDT=(9999999-$P(PVDT,"."))_"."_$P(PVDT,".",2)
 S PVIEN="",PVDAY=$P(PVDT,".")
 ;
 ;Loop backwards by date. If date changes, go get the next date.
 S MRVIEN=""
PRV1 F  S PVDT=$O(^AUPNVSIT("AA",DFN,PVDT),-1) Q:PVDT=""  Q:($P(PVDT,".")'=PVDAY)  D  I PVIEN'="" Q
 . S QUIT="" I STDT]"",PVDT]"" D  Q:QUIT
 .. NEW PVDAT,PVTIM
 .. S PVDAT=$P(PVDT,".")
 .. S PVTIM=+("."_$P(PVDT,".",2))
 .. I PVDAT>$P(STDT,".") S PVDT="" S QUIT=1
 .. I PVDAT=$P(STDT,"."),PVTIM<(+("."_$P(STDT,".",2))) S PVDT="" S QUIT=1
 . ;
 . S VIEN="" F  S VIEN=$O(^AUPNVSIT("AA",DFN,PVDT,VIEN),-1) Q:VIEN=""  D  I PVIEN'="" Q
 .. NEW PPRVFND,HL,SKIP
 .. S SCAT=$$GET1^DIQ(9000010,VIEN_",",".07","I")
 .. ;
 .. ;Skip deleted visits
 .. I $$GET1^DIQ(9000010,VIEN_",",".11","I") Q
 .. ;
 .. ;GDIT/HS/BEE;FEATURE#76183;PBI#82985;02/09/22;Filter out particular stop codes
 .. ;Hospital Location - Skip certain stop codes
 .. I '$$ELGVST(VIEN,SCSKIP) Q
 .. ;
 .. I MRVIEN="" S MRVIEN=VIEN
 .. ;
 .. ;Add skipped visits to the list
 .. S VLIST(VIEN)=""
 .. ;
 .. ;Skip non-provider service categories
 .. I SCAT'="A",SCAT'="O",SCAT'="S",SCAT'="R",SCAT'="I",SCAT'="H" Q
 .. S PVIEN=VIEN
 ;
 ;Quit if visit found
 I PVIEN'="" G XPRV
 ;
 ;The previous visit was not found in this date range. Get the next date
 ;in the index and send back to the loop to order by visit time.
 S PVDT=PVDAY_".9999"
 S PVDT=$O(^AUPNVSIT("AA",DFN,PVDT))
 ;
 ;Check against start date if defined
 I STDT]"",PVDT]"" D
 . NEW PVDAT,PVTIM
 . S PVDAT=$P(PVDT,".")
 . S PVTIM=+("."_$P(PVDT,".",2))
 . I PVDAT>$P(STDT,".") S PVDT="" Q
 . I PVDAT=$P(STDT,"."),PVTIM<(+("."_$P(STDT,".",2))) S PVDT=""
 I PVDT="" G XPRV
 ;
 S PVDAY=$P(PVDT,"."),PVDT=$P(PVDT,".")_".9999" G PRV1
 ;
 ;If we didn't find a previous provider visit, use the most recent visit.
XPRV IF PVIEN="" S PVIEN=MRVIEN
 Q PVIEN
 ;
KILL(NODE) ;EP - Clear out ^TMP scratch global entry
 K ^TMP(NODE,$J)
 Q 1
 ;
TRVAL(S1,S2,S3,S4) ;EP - Return value
 I $G(S4)]"" Q $G(^TMP("BCCDRESULTS",$J,S1,S2,S3,S4))
 I $G(S3)]"" Q $G(^TMP("BCCDRESULTS",$J,S1,S2,S3))
 I $G(S2)]"" Q $G(^TMP("BCCDRESULTS",$J,S1,S2))
 Q $G(^TMP("BCCDRESULTS",$J,S1))
 ;
TRSET(VIEN,VAL,S1,S2,S3,S4,S5) ;EP - Set Result Scratch Entry
 NEW VLIST
 ;
 ;5 LEVELS
 I $G(S5)]"" D  Q 1
 . S VLIST=$P($G(^TMP("BCCDRESULTS",$J,S1,S2,S3,S4,S5)),"^",2)
 . S ^TMP("BCCDRESULTS",$J,S1,S2,S3,S4,S5)=$G(VAL)_"^"_VLIST_$S(VLIST]"":"~",1:"")_$G(VIEN)
 ;
 ;4 LEVELS
 I $G(S4)]"" D  Q 1
 . S VLIST=$P($G(^TMP("BCCDRESULTS",$J,S1,S2,S3,S4)),"^",2)
 . S ^TMP("BCCDRESULTS",$J,S1,S2,S3,S4)=$G(VAL)_"^"_VLIST_$S(VLIST]"":"~",1:"")_$G(VIEN)
 ;
 ;3 LEVELS
 I $G(S3)]"" D  Q 1
 . S VLIST=$P($G(^TMP("BCCDRESULTS",$J,S1,S2,S3)),"^",2)
 . S ^TMP("BCCDRESULTS",$J,S1,S2,S3)=$G(VAL)_"^"_VLIST_$S(VLIST]"":"~",1:"")_$G(VIEN)
 ;
 ;2 LEVELS
 I $G(S2)]"" D  Q 1
 . S VLIST=$P($G(^TMP("BCCDRESULTS",$J,S1,S2)),"^")
 . S ^TMP("BCCDRESULTS",$J,S1,S2)=$G(VAL)_"^"_VLIST_$S(VLIST]"":"~",1:"")_$G(VIEN)
 ;
 ;1 LEVEL
 S VLIST=$P($G(^TMP("BCCDRESULTS",$J,S1)),"^")
 S ^TMP("BCCDRESULTS",$J,S1)=$G(VAL)_"^"_VLIST_$S(VLIST]"":"~",1:"")_$G(VIEN)
 Q 1
 ;
RDORDER(LVL,S1,S2,S3,S4) ;EP - Pull next scratch entry - Descending
 I LVL=4 Q $O(^TMP("BCCDRESULTS",$J,S1,S2,S3,S4),-1)
 I LVL=3 Q $O(^TMP("BCCDRESULTS",$J,S1,S2,S3),-1)
 I LVL=2 Q $O(^TMP("BCCDRESULTS",$J,S1,S2),-1)
 Q $O(^TMP("BCCDRESULTS",$J,S1),-1)
 ;
RAORDER(LVL,S1,S2,S3,S4) ;EP - Pull next scratch entry - Ascending
 I LVL=4 Q $O(^TMP("BCCDRESULTS",$J,S1,S2,S3,S4))
 I LVL=3 Q $O(^TMP("BCCDRESULTS",$J,S1,S2,S3))
 I LVL=2 Q $O(^TMP("BCCDRESULTS",$J,S1,S2))
 Q $O(^TMP("BCCDRESULTS",$J,S1))
 ;
APCHS6(APCHSICD) ;ICD9/ICD10 Significance Check
 ;
 NEW VAR
 ;
 I $G(APCHSICD)="" Q 0
 ;
 ;Need to set U since it is coming from BCCD method call
 S VAR="U" S @VAR="^"
 ;
 D HOSCHK^APCHS6
 ;
 I $G(APCHSICD)="" Q 0
 Q 1
 ;
AUDITHIE(VIEN,EDT) ;PEP-Get the first successful HIE transmission date/time for a visit
 ;
 ;Input
 ;      VIEN - Visit IEN; required
 ;      EDT  - Earliest extract date/time; optional; default = today
 ;
 ;Output
 ;      Date/time of the visit's first successful HIE transmission extracted after the given date/time
 ;      Null if no successful HIE transmission for an extract following the given date/time
 ;
 ;Call the class method to perform the logic
 Q @("##class(BCCD.Audit.AuditLog).AuditHIE($g(VIEN),$g(EDT))")
 ;
 ;GDIT/HS/BEE;05092022;Moved to BCCDUTL2
SUBLST(SUBSET) ;EP - Return a list of entries in a subset
 ;
 Q $$SUBLST^BCCDUTL2($G(SUBSET))
 ;
NPRINS(PROB,ETYPE) ;EP - Return the next problem IEN
 ;
 I $G(ETYPE)="" S ETYPE="BCCDINS"
 ;
 S PROB=$O(^TMP(ETYPE,$J,"I",$G(PROB)))
 I PROB]"" Q ^TMP(ETYPE,$J,"I",PROB)
 Q ""
 ;
SCP(PIEN,TYPE,VALUE,ENTRY,PROVIDER,TID) ;EP - Update CARE PLAN Scratch Global
 ;
 I $G(PIEN)="" Q
 I $G(TYPE)="" Q
 I $G(VALUE)="" Q
 ;
 I TYPE="I" D  Q
 . S ^TMP("BCCDCP",$J,"D",PIEN)=VALUE  ;Set up entry
 . S ^TMP("BCCDCP",$J,"I",VALUE)=PIEN  ;Set up index
 ;
 ;Save CARE PLAN entries
 I (TYPE="P")!(TYPE="G") D  Q
 . I $G(TID)]"" S ^TMP("BCCDCP",$J,"D",PIEN,TYPE,PROVIDER,ENTRY,0)=TID
 . S ^TMP("BCCDCP",$J,"D",PIEN,TYPE,PROVIDER,ENTRY)=$G(^TMP("BCCDCP",$J,"D",PIEN,TYPE,PROVIDER,ENTRY))+1
 . S ^TMP("BCCDCP",$J,"D",PIEN,TYPE,PROVIDER,ENTRY,^TMP("BCCDCP",$J,"D",PIEN,TYPE,PROVIDER,ENTRY))=VALUE
 ;
 Q
 ;
ASCP(PIEN,TYPE,VALUE,ENTRY,PROVIDER,TID) ;EP - Update CARE PLAN Scratch Global
 ;
 I $G(PIEN)="" Q
 I $G(TYPE)="" Q
 I $G(VALUE)="" Q
 ;
 I TYPE="I" D  Q
 . X "S ^||Assessment(""D"",PIEN)=VALUE"  ;Set up entry
 . X "S ^||Assessment(""I"",VALUE)=PIEN"  ;Set up index
 ;
 ;Save CARE PLAN entries
 I (TYPE="P")!(TYPE="G") D  Q
 . I $G(TID)]"" X "S ^||Assessment(""D"",PIEN,TYPE,PROVIDER,ENTRY,0)=TID"
 . X "S ^||Assessment(""D"",PIEN,TYPE,PROVIDER,ENTRY)=$G(^||Assessment(""D"",PIEN,TYPE,PROVIDER,ENTRY))+1"
 . X "S ^||Assessment(""D"",PIEN,TYPE,PROVIDER,ENTRY,^||Assessment(""D"",PIEN,TYPE,PROVIDER,ENTRY))=VALUE"
 ;
 Q
 ;
CPTU(TYPE,TEST,DATE,VALUE) ;EP - Add test to scratch global
 ;S ^TMP("BCCDCP",$J,TYPE,TEST_"^"_DATE)=$G(VALUE)
 S ^TMP("BCCDCP",$J,TYPE,$E(TEST_"^"_DATE,1,120))=$G(VALUE)
 S ^TMP("BCCDCP",$J,TYPE,$E(TEST_"^"_DATE,1,120),0)=TEST_"^"_DATE
 Q 1
 ;
CPTN(TYPE,NEXT) ;EP - Get the next test for the type
 ;
 Q $O(^TMP("BCCDCP",$J,TYPE,$G(NEXT)))
 ;
CPTS(TYPE,NEXT) ;EP - Get the full subscript value for the passed in entry
 I TYPE="" Q ""
 I NEXT="" Q ""
 Q $G(^TMP("BCCDCP",$J,TYPE,NEXT,0))
 ;
CPTD(TYPE,ENTRY) ;EP - Get the value for the entry
 Q $G(^TMP("BCCDCP",$J,TYPE,ENTRY))
 ;
NCP(PIEN,TYPE,PROV,ENTRY,EINS) ;EP - Return the next entry for type
 ;
 NEW VAL
 ;
 ;Retrieve Value Level information
 I $G(EINS)]"" D  Q VAL
 . ;
 . S VAL=""
 . S EINS=$O(^TMP("BCCDCP",$J,"D",PIEN,TYPE,PROV,ENTRY,EINS))
 . I EINS]"" S VAL=$G(^TMP("BCCDCP",$J,"D",PIEN,TYPE,PROV,ENTRY,EINS))
 ;
 ;Retrieve Entry Level Node
 I $G(ENTRY)]"" D  Q VAL
 . ;
 . ;S VAL=""
 . S VAL=$G(^TMP("BCCDCP",$J,"D",PIEN,TYPE,PROV,ENTRY,0))
 . S ENTRY=$O(^TMP("BCCDCP",$J,"D",PIEN,TYPE,PROV,ENTRY))
 ;
 ;Retrieve Next Provider
 I $G(PROV)]"" D  Q VAL
 . ;
 . S VAL=""
 . S PROV=$O(^TMP("BCCDCP",$J,"D",PIEN,TYPE,PROV))
 ;
 Q ""
 ;
ANCP(PIEN,TYPE,PROV,ENTRY,EINS) ;EP - Return the next entry for type
 ;
 NEW VAL
 ;
 ;Retrieve Value Level information
 I $G(EINS)]"" D  Q VAL
 . ;
 . S VAL=""
 . X "S EINS=$O(^||Assessment(""D"",PIEN,TYPE,PROV,ENTRY,EINS))"
 . I EINS]"" X "S VAL=$G(^||Assessment(""D"",PIEN,TYPE,PROV,ENTRY,EINS))"
 ;
 ;Retrieve Entry Level Node
 I $G(ENTRY)]"" D  Q VAL
 . ;
 . ;S VAL=""
 . X "S VAL=$G(^||Assessment(""D"",PIEN,TYPE,PROV,ENTRY,0))"
 . X "S ENTRY=$O(^||Assessment(""D"",PIEN,TYPE,PROV,ENTRY))"
 ;
 ;Retrieve Next Provider
 I $G(PROV)]"" D  Q VAL
 . ;
 . S VAL=""
 . X "S PROV=$O(^||Assessment(""D"",PIEN,TYPE,PROV))"
 ;
 Q ""
