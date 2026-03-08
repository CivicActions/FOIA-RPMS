BIDX1 ;IHS/HS/BEE- RISK FOR FLU & PNEUMO, CHECK FOR DIAGNOSES - Overflow Routine; MAY 10, 2010 [ 06/18/2025  3:27 PM ]
 ;;8.5;IMMUNIZATION;**22,25,26,31**;OCT 24,2011;Build 137
 ;
 Q
 ;
HASDX(BIDFN,BITAX,BINUM,BIBD,BIED,BISUBSET,BINPLDC) ;EP
 ;
 ;This call is made to determine if a patient (BIDFN) has had
 ;BINUM number of diagnoses within taxonomy BITAX or subset
 ;BISUBSET in V POV or PROBLEM during the time period BIBD to BIED.
 ;
 ;Parameters:
 ;1 - BIDFN  (req) Patient DFN.
 ;2 - BITAX  (req) Name of the Taxonomy e.g. "BI HIGH RISK FLU"
 ;3 - BINUM  (req) The number of diagnoses the patient has to have had.
 ;4 - BIBD   (opt) Beginning date (earliest) date to search for diagnoses.
 ;                 If null, use patient's DOB.
 ;5 - BIED   (opt) Date (latest) date to search for diagnoses.
 ;                 If null, use DT.
 ;6 - BISUBSET (opt) The SNOMED subset to search in
 ;
 ;Return values:  1 if patient has had the diagnoses
 ;                0 if patient has NOT had the diagnoses
 ;               -1^error message   if error occurred
 ;
 ;Example: To find if patient has had at least 2 diagnoses in past 3 years for a condition
 ;         making them a high risk for Pneumo, make the following call:
 ; S Y=+$$HASDX(BIDFN,"BI HIGH RISK PNEUMO",2,$$FMADD^XLFDT(DT,-(3*365)),DT,"PXRM IMHR PNEUMO")
 ;
 ; I Y=1 Then yes they had the diagnoses, I Y=0 then no they didn't
 ;
 ;*Note - Due to the heavy use of this call, direct global reads have been used instead of
 ;        FileMan API calls
 ;
 ;Input checking
 I '$G(BIDFN) Q "-1^Patient DFN invalid"
 S BITAX=$G(BITAX) S:BITAX="" BITAX=" "
 S BINUM=+$G(BINUM)
 S BINPLDC=$G(BINPLDC)
 I $G(BIBD)="" S BIBD=$$DOB^AUPNPAT(BIDFN)
 I $G(BIED)="" S BIED=DT
 S BISUBSET=$G(BISUBSET) S:BISUBSET="" BISUBSET=" "
 ;
 NEW BIIBD,BIIED,BISD,BIIDT,COUNT,VPVIEN,ICD,SMD,BIPIEN,BIPRBLST,IPL,NODE0,BIFOUND,EDT,VIEN,TXSB
 ;
 ;Check for daily ^XTMP("BI_TERMS") build - quit if couldn't check
 Q:$$UPDT()=-1 "-1"
 ;
 S BIIBD=9999999-BIBD  ;inverse of beginning date
 S BIIED=9999999-BIED  ;inverse of ending date
 S BISD=BIIED-1  ;start one day later for $O
 ;
 ;Check ICD10/SNOMED in V POV
 S COUNT=0
 S BIIDT=BISD F  S BIIDT=$O(^AUPNVPOV("AA",BIDFN,BIIDT)) Q:(BIIDT="")!(BIIDT>BIIBD)!(COUNT'<BINUM)  D
 . S VPVIEN=0 F  S VPVIEN=$O(^AUPNVPOV("AA",BIDFN,BIIDT,VPVIEN)) Q:'VPVIEN  D  Q:(COUNT'<BINUM)
 .. ;
 .. S BIFOUND=$$VPOV(VPVIEN,BITAX,BISUBSET,.BIPRBLST) Q:'BIFOUND
 .. S COUNT=COUNT+1
 ;
 ;If max not reached, loop through PROBLEM file entries for patient
 I COUNT<BINUM S BIPIEN=0 F  S BIPIEN=$O(^AUPNPROB("AC",BIDFN,BIPIEN)) Q:BIPIEN=""  D  Q:(COUNT'<BINUM)
 .;
 .;Look in taxonomy and subset - Quit if not found
 .S BIFOUND=$$PROB(BIPIEN,BITAX,BISUBSET,.BIPRBLST,BINPLDC) Q:'BIFOUND
 .;
 .;Check against problem date
 .I BINPLDC G C1
 .S EDT=$$PRBDT(BIPIEN) Q:'EDT
 .I EDT<BIBD Q   ;Entry date is less than beginning date
 .I EDT>BIED Q   ;Entry date is after ending date
 .;
C1 .;Update counter
 .S COUNT=COUNT+1
 ;
 I COUNT<BINUM Q 0  ;patient did not meet the required # of diagnoses
 Q 1
 ;
PRBDT(BIPIEN) ;Return problem date
 ;
 ;Input: Problem IEN
 ;Output: Problem date
 ;
 I '$G(BIPIEN) Q ""
 ;
 NEW EDT,NODE0
 ;
 S NODE0=$G(^AUPNPROB(BIPIEN,0))
 ;
 S EDT="" D
 .;First look at DATE OF ONSET (#.13)
 .S EDT=$P(NODE0,U,13) Q:EDT
 .;
 .;Then look at DATE ENTERED (#.08)
 .S EDT=$P(NODE0,U,8) Q:EDT
 .;
 .;Finally look at DATE LAST MODIFIED (#.03)
 .S EDT=$P(NODE0,U,3) Q:EDT
 ;
 S EDT=$P(EDT,".")
 Q EDT
 ;
PROB(BIPIEN,BITAX,BISUBSET,BIPRBLST,BINPLDC) ;Look in IPL for for ICD in taxonomy or SNOMED in subset
 ;
 ;Return whether ICD in taxonomy or SNOMED in subset
 ;
 ;Input
 ; BIPIEN - Pointer to PROBLEM file entry
 ; BITAX - Taxonomy (Multiples separated by ";")
 ; BISUBSET - SNOMED subset name (Multiples separated by ";")
 ; BIPRBLST - PROBLEM file IEN list
 ;
 ;Output - Found entry (1)/Not found (0)
 ;
 NEW BIFOUND,PAIEN,ICD,SMD,TXSB
 ;
 S BIFOUND=0
 S BINPLDC=$G(BINPLDC)
 ;
 I '$G(BIPIEN) Q BIFOUND
 ;
 ;Skip entries already covered in VPOV
 I $D(BIPRBLST("P",BIPIEN)) Q BIFOUND
 ;
 ;Skip deleted problems
 I $P($G(^AUPNPROB(BIPIEN,2)),U,2)]"" Q BIFOUND
 I $P($G(^AUPNPROB(BIPIEN,0)),U,12)="D" Q BIFOUND  ;ihs/cmi/lab - older problems may only have status, not the 2 node
 I $P($G(^AUPNPROB(BIPIEN,0)),U,12)="" Q BIFOUND
 ;ihs/cmi/lab - if BINPLDC is 1 then skip inactive problems
 I BINPLDC,$P($G(^AUPNPROB(BIPIEN,0)),U,12)="I" Q BIFOUND
 ;
 ;Look for SNOMED first
 S SMD=$P($G(^AUPNPROB(BIPIEN,800)),U)
 I SMD D  Q:BIFOUND BIFOUND
 . F TXSB=1:1:$L(BISUBSET,";") I $D(^XTMP("BI_TERMS","DXSUB",$P(BISUBSET,";",TXSB),SMD)) D  Q
 .. S BIFOUND=1
 ;
 ;Get the ICD
 S ICD=$P($G(^AUPNPROB(BIPIEN,0)),U)
 ;
 ;Skip if no SNOMED (entered through PCC) and problem ICD already used as a POV (in PCC)
 I 'SMD,ICD,$D(BIPRBLST("I",ICD)) Q 0
 ;
 ;Next check if primary problem ICD in taxonomy
 I ICD D  Q:BIFOUND BIFOUND
 .F TXSB=1:1:$L(BITAX,";") I $D(^XTMP("BI_TERMS","DXTAX",$P(BITAX,";",TXSB),ICD)) D  Q
 .. S BIFOUND=1
 ;
 ;Now look at additional DX entries
 S PAIEN=0 F  S PAIEN=$O(^AUPNPROB(BIPIEN,12,PAIEN)) Q:'PAIEN  D  Q:BIFOUND
 . ;
 . ;Retrieve Additional ICD
 . S ICD=$P($G(^AUPNPROB(BIPIEN,12,PAIEN,0)),U)
 . ;
 . ;See if in taxonomy
 . I ICD D  Q:BIFOUND
 .. F TXSB=1:1:$L(BITAX,";") I $D(^XTMP("BI_TERMS","DXTAX",$P(BITAX,";",TXSB),ICD)) D
 ... S BIFOUND=1
 ;
 Q BIFOUND
 ;
V2DM(BIDFN,BDATE,EDATE) ;EP - are there 2 visits with DM?
 ;
 ;Input parameters
 ; BIDFN - Patient DFN
 ; BDATE  - beginning date to look default is DOB
 ; EDATE - end date to look default is DT
 ;
 I '$G(BIDFN) Q ""
 I '$D(^AUPNVSIT("AC",BIDFN)) Q ""  ;patient has no visits
 ;
 I '$G(BDATE) S BDATE=$$DOB^AUPNPAT(BIDFN)
 I '$G(EDATE) S EDATE=DT
 ;
 NEW BIREF,IBDATE,IEDATE,COUNT,PDA,BIPRBLST,BIPIEN,VLIST,BIFOUND,VST,PIEN,EDT
 ;
 S IBDATE=9999999-BDATE
 S IEDATE=9999999-EDATE
 S COUNT=0
 ;
 ;Look for diabetes ICD or SNOMED
 S PDA=IEDATE-1 F  S PDA=$O(^AUPNVPOV("AA",BIDFN,PDA)) Q:'PDA!(PDA>IBDATE)!(COUNT>1)  D
 .S PIEN=0 F  S PIEN=$O(^AUPNVPOV("AA",BIDFN,PDA,PIEN)) Q:'PIEN  D
 ..;
 ..;Look in V POV for ICD or SNOMED
 ..S BIFOUND=$$VPOV(PIEN,"SURVEILLANCE DIABETES","PXRM IMHR SURVEIL DIABETES",.BIPRBLST) Q:'BIFOUND
 ..;
 ..;Get the VIEN
 ..S VST=$$GET1^DIQ(9000010.07,PIEN_",",.03,"I") Q:'VST
 ..;
 ..;ELIMINATE TELEPHONE CALLS, CHART REVIEWS, ETC
 ..Q:(",S,A,H,O,R,"'[(","_$P($G(^AUPNVSIT(VST,0)),U,7)_","))
 ..;
 ..;Only count visits once
 ..Q:$D(VLIST(VST))
 ..;
 ..;Log visit and increment counter
 ..S VLIST(VST)="",COUNT=COUNT+1
 ;
 ;Loop through PROBLEM file entries for patient
 I COUNT<2 S BIPIEN=0 F  S BIPIEN=$O(^AUPNPROB("AC",BIDFN,BIPIEN)) Q:BIPIEN=""  D  Q:(COUNT'<2)
 .;
 .;Look in taxonomy and subset
 .S BIFOUND=$$PROB(BIPIEN,"SURVEILLANCE DIABETES","PXRM IMHR SURVEIL DIABETES",.BIPRBLST) Q:'BIFOUND
 .;
 .;Check against problem date
 .S EDT=$$PRBDT(BIPIEN) Q:'EDT
 .I EDT<BDATE Q   ;Entry date is less than beginning date
 .I EDT>EDATE Q   ;Entry date is after ending date
 .;
 .;Update counter
 .S COUNT=COUNT+1
 ;
 Q $S(COUNT<2:"",1:1)
 ;
VPOV(VPIEN,BITAX,BISUBSET,BIPRBLST) ;Look in V POV for ICD in taxonomy or SNOMED in subset
 ;
 ;Return whether ICD in taxonomy or SNOMED in subset
 ;
 ;Input
 ; VPIEN - V POV IEN
 ; BITAX - Taxonomy (multiples separated by ";")
 ; BISUBSET - SNOMED subset name (multiples separated by ";")
 ; BIPRBLST - PROBLEM file IEN list (gets updated)
 ;
 ;Output - Found entry (1)/Not found (0)
 ;
 I +$G(VPIEN)=0 Q 0
 ;
 NEW NODE0,IPL,SMD,BIFOUND,TXSB,VISIT,ICD
 ;
 ;Pull node into local
 S NODE0=$G(^AUPNVPOV(VPIEN,0))
 ;
 S BIFOUND=0
 ;
 ;Get the problem list entry
 S IPL=$P(NODE0,U,16)
 ;
 ;Next look for SNOMED
 S SMD=$P($G(^AUPNVPOV(VPIEN,11)),U)
 I SMD D  Q:BIFOUND BIFOUND
 . F TXSB=1:1:$L(BISUBSET,";") I $D(^XTMP("BI_TERMS","DXSUB",$P(BISUBSET,";",TXSB),SMD)) D  Q:BIFOUND
 .. ;
 .. ;An IPL entry could generate multiple V POV entries for a visit - only count as 1
 .. S VISIT=$P($G(^AUPNVPOV(VPIEN,0)),U,3)
 .. I VISIT,IPL,$D(BIPRBLST("V",IPL,VISIT)) Q
 .. ;
 .. ;New entry found
 .. S BIFOUND=1
 .. ;
 .. ;Log for duplicate checking
 .. I IPL]"" D
 ... I VISIT S BIPRBLST("V",IPL,VISIT)=""
 ... S BIPRBLST("P",IPL)=""
 ;
 ;Then look for ICD9/ICD10
 S ICD=$P(NODE0,U)
 I ICD D  Q:BIFOUND BIFOUND
 . F TXSB=1:1:$L(BITAX,";") I $D(^XTMP("BI_TERMS","DXTAX",$P(BITAX,";",TXSB),ICD)) D  Q:BIFOUND
 .. S BIFOUND=1
 .. S:IPL]"" BIPRBLST("P",IPL)=""  ;Saved so only count 1 per IPL entry/Visit
 .. S BIPRBLST("I",ICD)=""  ;Saved for checking on VPOV/IPL through PCC
 ;
 Q BIFOUND
 ;
UPDT(TAX) ;Build the requested taxonomies and subsets
 ;
 ;If not passed in, default to "BI_TAX"
 I $G(TAX)="" S TAX="TERMS"
 ;
 I '$D(^ICDS(0)) Q -1
 I $T(^ATXAPI)="" Q -1
 ;
 ;Lock the entry - current update in progress
 L +^XTMP("BI"_TAX):10 E  Q -1
 ;
 NEW BITXTI,BITXIEN,BITEXT,BITAX,BITYPE,BIREF,BITREF
 NEW BISUBI,BISUB,BISBIEN,BICONC,BISCNT,STAX,TTAX
 ;
 ;Define reference
 S BITREF="BI_"_TAX
 ;
 ;See if already processed for day
 I $G(^XTMP(BITREF,"COMP"))'<DT G XUPDT
 ;
 ;Need to recompile
 S ^XTMP(BITREF,0)=DT_U_DT_U_TAX_" TAXONOMIES AND SUBSETS"
 ;
 ;Define tag references
 S STAX="S"_TAX
 S TTAX="T"_TAX
 ;
 ;Loop through DX taxonomies and build ^XTMP
 K ^XTMP(BITREF,"DXTAX")
 S ^XTMP(BITREF,"DXTAX")="DX codes reflecting "_TAX
 F BITXTI=1:1 S BITEXT=$P($T(@TTAX+BITXTI),";;",2,99) S BITAX=$P(BITEXT,";") Q:BITAX="END"  D
 . S BITAX=$P(BITEXT,";")
 . S BITYPE=$P(BITEXT,";",2)
 . S BITXIEN=$O(^ATXAX("B",BITAX,0)) I 'BITXIEN Q
 . I $D(^ICDS(0)),$T(^ATXAPI)]"" D
 .. K ^TMP($J,"BITAX")
 .. S BIREF=$NA(^TMP($J,"BITAX"))
 .. D BLDTAX^ATXAPI(BITAX,BIREF,BITXIEN)
 .. M ^XTMP(BITREF,"DXTAX",BITAX)=^TMP($J,"BITAX")
 .. K ^TMP($J,"BITAX")
 ;
 ;Loop through subsets and build ^XTMP
 K ^XTMP(BITREF,"DXSUB")
 S BISCNT=0
 F BISUBI=1:1 S BITEXT=$P($T(@STAX+BISUBI),";;",2,99) S BISUB=$P(BITEXT,";") Q:BISUB="END"  D
 . S BISBIEN="" F  S BISBIEN=$O(^BSTS(9002318.4,"E",15,BISUB,BISBIEN)) Q:BISBIEN=""  D
 .. ;Retrieve Concept Id
 .. S BICONC=$P($G(^BSTS(9002318.4,BISBIEN,0)),U,2) Q:BICONC=""  ;Retrieve Concept Id
 .. S ^XTMP(BITREF,"DXSUB",BISUB,BICONC)=""
 .. S BISCNT=BISCNT+1
 S ^XTMP(BITREF,"DXSUB")="SNOMED Concept Ids reflecting "_TAX_" status"_U_BISCNT
 ;
 ;Update compiled date
 S ^XTMP(BITREF,"COMP")=DT
 ;
XUPDT L -^XTMP("BI"_TAX)
 Q 1
 ;
 ;----------
TTERMS ;;
 ;;BI HIGH RISK PNEUMO;D
 ;;BI HIGH RISK PNEUMO W/SMOKING;D
 ;;SURVEILLANCE DIABETES;D
 ;;BI HIGH RISK HEPA/B, CLD/HEPC;D
 ;;BI HIGH RISK FLU;D
 ;;END;
 ;
STERMS ;;
 ;;PXRM IMHR PNEUMO
 ;;PXRM IMHR PNEUMO WITH SMOKING
 ;;PXRM IMHR SURVEIL DIABETES
 ;;PXRM IMHR HEPA/B, CLD/HEPC
 ;;PXRM IMHR FLU
 ;;END;
 ;
TAX ;;
 ;;BQI CANCER DXS;D
 ;;BQI IMMUNE DEFICIENCY DXS;D
 ;;BQI TRANSPLANT DXS;D
 ;;END;
 ;
SUB ;;
 ;;PXRM BQI Immunocomp Full Set
 ;;END;
