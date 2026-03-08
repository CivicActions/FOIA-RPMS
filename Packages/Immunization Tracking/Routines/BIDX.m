BIDX ;IHS/CMI/MWR - RISK FOR FLU & PNEUMO, CHECK FOR DIAGNOSES.; MAY 10, 2010 ; 30 Jun 2025  3:48 PM
 ;;8.5;IMMUNIZATION;**22,25,26,31**;OCT 24,2011;Build 137
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  CHECK FOR DIAGNOSES IN A TAXONOMY RANGE, WITHIN A GIVE DATE RANGE.
 ;;  FROM LORI BUTCHER, 9-18-05
 ;;  PATCH 5: New code to check for Smoking Health Factors.   HFSMKR+23
 ;;  PATCH 9: Changes to include Hep B Risk.  RISK+9, RISK+41
 ;;  PATCH 13: Changes to check for Flu High Risk.   RISK+25, HASDX+38
 ;;  PATCH 15: Changes to check for Flu High Risk (removed in p14).   RISKAB+19
 ;;  PATCH 22: Changes to check for Immunocompromised.  RISKC+0, UPDTC
 ;;  PATCH 31: Add BIRPROF(BIVGO) variable for patient risk profile
 ;;            to use for adding *HR* flag to forecast display
 ;
 ;
 ;********** PATCH 14, v8.5, AUG 01,2017, IHS/CMI/MWR
 ;----------
RISKP(BIDFN,BIFDT,BIAGE,BISMKR,BIRISKF) ;EP Return Pneumo High Risk.
 ;---> Determine if this patient is in the Pneumo Risk Taxonomy.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient IEN.
 ;     2 - BIFDT   (opt) Forecast Date (date used for forecast).
 ;     3 - BIAGE   (req) Patient Age in years for this Forecast Date.
 ;     4 - BISMKR  (opt) 1=Include Smoking Factors.
 ;     5 - BIRISKF (ret) 1=Patient has Risk of Pneumo; otherwise 0.
 ;     6 - BINPLDC (opt) 1=don't check problem list dates, just check active or inactive
 ;
 S BIRISKF=0
 Q:'$G(BIDFN)
 ;---> Quit if this Pt Age <5 yrs or >65 yrs, regardless of risk.
 Q:((BIAGE<5)!(BIAGE>64))
 S:'$G(BIFDT) BIFDT=$G(DT)
 N BIBEGDT,Y S BIBEGDT=$$FMADD^XLFDT(BIFDT,-(3*365))
 ;
 ;---> Check Pneumo Risk (2 Pneumo Dx's over 3-year range).
 ;GDIT/HS/BEE 06/24/22;BI*8.5*22;FEATURE#75583;Added subset reference
 ;ihs/cmi/lab - changed 2 dx to 1 per email 1/5/23
 S Y=+$$HASDX(BIDFN,"BI HIGH RISK PNEUMO",1,BIBEGDT,BIFDT,"PXRM IMHR PNEUMO",1)
 I Y S BIRISKF=1,BIRPROF(11)=1 Q
 ;
 ;add immunocompromised check patch 26 ihs/cmi/lab
 ;
 S Y=+$$IMMUNPNU(BIDFN,BIFDT)
 I Y S BIRISKF=1,BIRPROF(11)=1 Q
 ;---> Quit if site parameter says don't include Smoking.
 Q:'$G(BISMKR)
 ;GDIT/HS/BEE 06/24/22;BI*8.5*22;FEATURE#75583;Added subset reference
 ;ihs/cmi/lab - changed 2 dx to 1 per email 1/5/23
 S Y=+$$HASDX(BIDFN,"BI HIGH RISK PNEUMO W/SMOKING",1,BIBEGDT,BIFDT,"PXRM IMHR PNEUMO WITH SMOKING",1)
 I Y S BIRISKF=1,BIRPROF(11)=1 Q
 ;
 ;---> Check for Smoking Health Factor in the last 2 years.
 S BIRISKF=$$HFSMKR(BIDFN,BIFDT)
 I Y S BIRISKF=1,BIRPROF("SMOKE")=1
 Q
 ;
 ;********** PATCH 22, v8.5, JAN 01,2022, IHS/CMI/MWR
 ;---> Return whether patient is considered to be immunocompromised
 ;
RISKC(BIDFN,BIFDT,BIMD,BIRISKC) ;PEP - Return whether considered immunocompromised, 1=Yes, 0=No.
 ;Determine if this patient is considered to be immunocompromised.
 ;Parameters:
 ; 1 - BIDFN   (req) Patient IEN.
 ; 2 - BIFDT   (opt) Forecast Date (date used for forecast).
 ; 3 - BIMD    (opt) Null=both Meds and Dx's, 1=Meds only, 2=Dx's only.
 ; 4 - BIRISKC (ret) 1=Patient is immunocompromised; otherwise 0.
 ;
 ;Input checking
 S BIRISKC=0
 Q:'$G(BIDFN)
 S:'$G(BIFDT) BIFDT=$G(DT)
 S BIMD=$G(BIMD) I BIMD'="",BIMD'=1,BIMD'=2 Q
 ;
 NEW BIIBD,TXDIEN,TXRIEN,BIIDT,VPVIEN,ICD,SMD,IDRUG,RX,BIDFDT,BIIDFDT
 ;
 ;Check for daily ^XTMP("BI_RISKC") build - quit if couldn't check
 Q:$$UPDTC()=-1
 ;
 ;Get drug look back date - 90 days
 S BIDFDT=$$FMADD^XLFDT(BIFDT,-90)
 S BIIDFDT=9999999-BIDFDT ;determine inverse date
 ;
 ;Get start date (back 1 year from forecast date)
 S $E(BIFDT,2,3)=$E(BIFDT,2,3)-1 S:$E(BIFDT,5,7)="229" $E(BIFDT,5,7)="228"
 S BIIBD=9999999-BIFDT ;determine inverse date
 ;
 ;Check ICD10/SNOMED in V POV
 I BIMD'=1 D  I (BIMD=2)!(BIRISKC) Q
 . S BIIDT=0 F  S BIIDT=$O(^AUPNVPOV("AA",BIDFN,BIIDT)) Q:(BIIDT="")!(BIIDT>BIIBD)  D  Q:BIRISKC
 .. S VPVIEN=0 F  S VPVIEN=$O(^AUPNVPOV("AA",BIDFN,BIIDT,VPVIEN)) Q:'VPVIEN  D  Q:BIRISKC
 ... ;
 ... ;First look for ICD10
 ... S ICD=$P($G(^AUPNVPOV(VPVIEN,0)),U)
 ... I ICD,$D(^XTMP("BI_RISKC","DXTAX",ICD)) S BIRISKC=1 Q
 ... ;
 ... ;Next look for SNOMED
 ... S SMD=$P($G(^AUPNVPOV(VPVIEN,11)),U)
 ... I SMD,$D(^XTMP("BI_RISKC","DXSUB",SMD)) S BIRISKC=1
 ;
 ;Check medications
 I BIMD'=2 D
 . ;
 . ;Retrieve drug/RxNorm taxonomy IENs
 . S TXDIEN=$O(^ATXAX("B","ATX IMMUNOSUPPRESS DRUGS",0))
 . S TXRIEN=$O(^ATXAX("B","ATX IMMUNOSUPPRESS RXNORM",0))
 . ;
 . ;Check for drug/RxNorm in V MEDICATION
 . S BIIDT=0 F  S BIIDT=$O(^AUPNVMED("AA",BIDFN,BIIDT)) Q:(BIIDT="")!(BIIDT>BIIDFDT)  D  Q:BIRISKC
 .. S VPVIEN=0 F  S VPVIEN=$O(^AUPNVMED("AA",BIDFN,BIIDT,VPVIEN)) Q:'VPVIEN  D  Q:BIRISKC
 ... ;
 ... ;First look for drug IEN
 ... S IDRUG=$P($G(^AUPNVMED(VPVIEN,0)),U) Q:IDRUG=""
 ... I TXDIEN,$D(^ATXAX(TXDIEN,21,"B",IDRUG)) S BIRISKC=1 Q
 ... ;
 ... ;Next look for RxNorm
 ... S RX=$P($G(^PSDRUG(IDRUG,999999924)),U,4)
 ... I RX,TXRIEN,$D(^ATXAX(TXRIEN,21,"B",RX)) S BIRISKC=1
 ;
 Q
 ;
 ;----------
RISKB(BIDFN,BIFDT,BIAGE,BIRISKF) ;EP Return Hep B High Risk.
 ;---> Determine if this patient is in the Hep B due to Diabetes Risk Taxonomy.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient IEN.
 ;     2 - BIFDT   (opt) Forecast Date (date used for forecast).
 ;     3 - BIAGE   (req) Patient Age in years for this Forecast Date.
 ;     4 - BIRISKF (ret) 1=Patient has Risk of Hep B due to Diabetes; otherwise 0.
 ;
 S BIRISKF=0
 Q:'$G(BIDFN)
 S:'$G(BIFDT) BIFDT=$G(DT)
 N Y
 ;
 ;---> Check Hep B Risk (2 Diabetes Dx's from DOB to Forecast Date).
 Q:(BIAGE>59)
 N Y S Y=+$$V2DM(BIDFN,,BIFDT)
 I Y=1 S BIRISKF=1,BIRPROF(4)=1
 Q
 ;----------
RISKAB(BIDFN,BIFDT,BIRISKF) ;EP Return Hep A & Hep B High Risk.
 ;---> Determine if this patient is in the CLD/HepC Risk Taxonomy.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient IEN.
 ;     2 - BIFDT   (opt) Forecast Date (date used for forecast).
 ;     3 - BIRISKF (ret) 1=Patient has Risk of HepA&B; otherwise 0.
 ;
 S BIRISKF=0
 Q:'$G(BIDFN)
 S:'$G(BIFDT) BIFDT=$G(DT)
 N BIBEGDT,Y,J S BIBEGDT=$$FMADD^XLFDT(BIFDT,-(3*365))
 ;
 ;---> Check CLD/HepC Risk (1 CLD/HepC Dx's over 3-year range).
 ;GDIT/HS/BEE 06/24/22;BI*8.5*22;FEATURE#75583;Added subset reference
 S Y=+$$HASDX(BIDFN,"BI HIGH RISK HEPA/B, CLD/HEPC",1,BIBEGDT,BIFDT,"PXRM IMHR HEPA/B, CLD/HEPC")
 I Y=1 S BIRISKF=1 F J=9,12,14 S BIRPROF(J)=1
 Q
 ;
 ;
 ;********** PATCH 15, v8.5, SEP 30,2017, IHS/CMI/MWR
 ;---> Return Flu High Risk Value.
 ;----------
RISKF(BIDFN,BIFDT,BIRISKF) ;EP Return Flu High Risk.
 ;---> Determine if this patient is in the Flu High Risk Taxonomy.
 ;---> Generally patients passed are >18 yrs and <50 yrs.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient IEN.
 ;     2 - BIFDT   (opt) Forecast Date (date used for forecast).
 ;     3 - BIRISKF (ret) 1=Patient has Risk of Influenza; otherwise 0.
 ;
 ;---> Check Flu Risk Taxonomy(2 Dx's within 3 yrs prior to the date passed).
 S BIRISKF=0
 Q:'$G(BIDFN)
 S:'$G(BIFDT) BIFDT=$G(DT)
 N BIBEGDT,Y,J S BIBEGDT=$$FMADD^XLFDT(BIFDT,-(3*365))
 ;GDIT/HS/BEE 06/24/22;BI*8.5*22;FEATURE#75583;Added subset reference
 S Y=+$$HASDX(BIDFN,"BI HIGH RISK FLU",2,BIBEGDT,BIFDT,"PXRM IMHR FLU")
 I Y S BIRISKF=1 F J=10,18 S BIRPROF(J)=1
 Q
 ;**********
IMMUNPNU(BIDFN,BIFDT) ;EP - Return whether considered immunocompromised, 1=Yes, 0=No.
 ;IHS/CMI/LAB - copied RISKC, removed med check, added problem list check for active problem, changed to 3 year look back for pneumo
 ;Determine if this patient is considered to be immunocompromised.
 ;Parameters:
 ; 1 - BIDFN   (req) Patient IEN.
 ; 2 - BIFDT   (opt) Forecast Date (date used for forecast).
 ; 4 - BIRISKC (ret) 1=Patient is immunocompromised; otherwise 0.
 ;
 ;Input checking
 S BIRISKC=0
 I '$G(BIDFN) Q 0
 S:'$G(BIFDT) BIFDT=$G(DT)
 ;
 NEW BIIBD,TXDIEN,TXRIEN,BIIDT,VPVIEN,ICD,SMD,IDRUG,RX,BIDFDT,BIIDFDT,PRIEN
 ;
 ;Check for daily ^XTMP("BI_RISKC") build - quit if couldn't check
 I $$UPDTC()=-1 Q 0
 ;
 ;Get start date (back 3 years from forecast date)
 S $E(BIFDT,2,3)=$E(BIFDT,2,3)-3 S:$E(BIFDT,5,7)="229" $E(BIFDT,5,7)="228"
 S BIIBD=9999999-BIFDT ;determine inverse date
 ;
 ;Check ICD10/SNOMED in V POV
 S BIIDT=0 F  S BIIDT=$O(^AUPNVPOV("AA",BIDFN,BIIDT)) Q:(BIIDT="")!(BIIDT>BIIBD)!(BIRISKC)  D
 . S VPVIEN=0 F  S VPVIEN=$O(^AUPNVPOV("AA",BIDFN,BIIDT,VPVIEN)) Q:'VPVIEN!(BIRISKC)  D
 .. ;
 .. ;First look for ICD10
 .. S ICD=$P($G(^AUPNVPOV(VPVIEN,0)),U)
 .. I ICD,$D(^XTMP("BI_RISKC","DXTAX",ICD)) S BIRISKC=1 Q
 .. ;
 .. ;Next look for SNOMED
 .. S SMD=$P($G(^AUPNVPOV(VPVIEN,11)),U)
 .. I SMD,$D(^XTMP("BI_RISKC","DXSUB",SMD)) S BIRISKC=1
 ;
 I BIRISKC Q BIRISKC
 ;NOW CHECK PROBLEM LIST
 S PRIEN=0 F  S PRIEN=$O(^AUPNPROB("AC",BIDFN,PRIEN)) Q:PRIEN'=+PRIEN!(BIRISKC)  D
 .Q:'$D(^AUPNPROB(PRIEN,0))  ;no zero node
 .Q:$P(^AUPNPROB(PRIEN,0),U,12)=""
 .Q:"ID"[$P(^AUPNPROB(PRIEN,0),U,12)  ;no deleted or inactive
 .I $P($G(^AUPNPROB(PRIEN,2)),U,2)]"" Q
 .;Look for ICD
 .S ICD=$P($G(^AUPNPROB(PRIEN,0)),U)
 .I ICD,$D(^XTMP("BI_RISKC","DXTAX",ICD)) S BIRISKC=1 Q
 .;now SNOMED
 .S SMD=$P($G(^AUPNPROB(PRIEN,800)),U)
 .I SMD,$D(^XTMP("BI_RISKC","DXSUB",SMD)) S BIRISKC=1
 .Q
 Q BIRISKC
 ;----------
 ;GDIT/HS/BEE 06/24/22;BI*8.5*22;FEATURE#75583;Added subset reference and moved to new routine
HASDX(BIDFN,BITAX,BINUM,BIBD,BIED,BISUBSET,BINPLDC) ;EP
 ;
 Q $$HASDX^BIDX1(BIDFN,$G(BITAX),$G(BINUM),$G(BIBD),$G(BIED),$G(BISUBSET),$G(BINPLDC))
 ;
 ;----------
HFSMKR(BIDFN,BIFDT) ;EP
 ;---> Return 1 if Patient has Last Health Factor in the TOBACCO category
 ;---> with a date of <2 years.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient's IEN (DFN).
 ;     2 - BIFDT   (req) Forecast Date (date used for forecast).
 ;
 ;********** PATCH 5, v8.5, JUL 01,2013, IHS/CMI/MWR
 ;---> New code to check for Smoking Health Factors.
 ;
 ;---> Return 0 if routine APCLAPIU is not in the namespace.
 ;---> APCLAPIU is from ;;2.0;IHS PCC SUITE;**2,6**;MAY 14, 2009.
 Q:('$L($T(^APCLAPIU))) 0
 Q:'$G(BIDFN) 0
 S:'$G(BIFDT) BIFDT=$G(DT)
 ;
 N Y S Y=$$LASTHF^APCLAPIU(BIDFN,"TOBACCO (SMOKING)",$$FMADD^XLFDT(BIFDT,-730),BIFDT)
 ;---> If there's a hit it looks like this:
 ;--->     3110815^HF: CURRENT SMOKER, SOME DAY^^2580^9000010.23^2, otherwise null.
 ;---> So, if there's a leading date, then patient has an HF "TOBACCO (SMOKING)" Category.
 ;---> Looking for these Health Factors:
 ;
 Q:(Y["CURRENT SMOKER, STATUS UNKNOWN") 1
 Q:(Y["CURRENT SMOKER, EVERY DAY") 1
 Q:(Y["CURRENT SMOKER, SOME DAY") 1
 Q:(Y["CESSATION-SMOKER") 1
 Q:(Y["HEAVY TOBACCO SMOKER") 1
 Q:(Y["LIGHT TOBACCO SMOKER") 1
 ;
 ;---> Patient does NOT have a SMOKER Health Factor 2 years prior to the Forecast Date.
 Q 0
 ;**********
 ;
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> New code from Lori Butcher to check for Diabetes (rtn: CIMZDMCK).
V2DM(P,BDATE,EDATE) ;EP - are there 2 visits with DM?
 ;P is Patient DFN
 ;BDATE  - beginning date to look default is DOB
 ;EDATE - end date to look default is DT
 ;
 ;GDIT/HS/BEE 06/24/22;BI*8.5*22;FEATURE#75583;Moved to new routine
 Q +$$V2DM^BIDX1(BIDFN,,BIFDT)
 ;
 I '$G(P) Q ""
 I '$D(^AUPNVSIT("AC",P)) Q ""  ;patient has no visits
 I '$G(BDATE) S BDATE=$$DOB^AUPNPAT(P)
 I '$G(EDATE) S EDATE=DT
 NEW T,BIREF,PDA,PIEN,CDX,VST,VDT,IBDATE,IEDATE,V,G  ;IHS/CMI/LAB/maw - modified and added lines to speed up the process
 ;K ^TMP($J,"A")
 ;S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 ;I '$D(^TMP($J,"A",1)) Q ""  ;no visits returned
 S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q ""
 ;IHS/CMI/LAB - added lines below for icd10
 ;MWRZZZ  COMMENT OUT NEXT LINE, ADD ONE AFTER.
 ;I $D(^ICDS(0)) D
 I $D(^ICDS(0)),$T(^ATXAPI)]"" D
 .K ^TMP($J,"BITAX")  ;IHS/CMI/LAB - clean out old nodes just in case
 .S BIREF=$NA(^TMP($J,"BITAX"))  ;IHS/CMI/LAB
 .D BLDTAX^ATXAPI("SURVEILLANCE DIABETES",BIREF,T)
 S IBDATE=9999999-BDATE
 S IEDATE=9999999-EDATE
 S G=0
 K V
 S PDA=IEDATE-1 F  S PDA=$O(^AUPNVPOV("AA",P,PDA)) Q:'PDA!(PDA>IBDATE)!(G>1)  D
 . S PIEN=0 F  S PIEN=$O(^AUPNVPOV("AA",P,PDA,PIEN)) Q:'PIEN  D
 .. S CDX=$P($G(^AUPNVPOV(PIEN,0)),U)
 .. Q:'CDX
 .. I $D(^TMP($J,"BITAX")) Q:'$D(^TMP($J,"BITAX",CDX))
 .. I '$D(^TMP($J,"BITAX")) Q:'$$ICD^ATXCHK(CDX,T,9)
 .. S VST=$P($G(^AUPNVPOV(PIEN,0)),U,3)
 .. Q:'VST  ;HAPPENS
 .. Q:'$D(^AUPNVSIT(VST,0))
 .. Q:"SAHOR"'[$P(^AUPNVSIT(VST,0),U,7)  ;ELIMINATE TELEPHONE CALLS, CHART REVIEWS, ETC
 .. I '$D(V(VST)) S V(VST)="",G=G+1
 K ^TMP($J,"BITAX")
 ;Q 1  ;for testing a positive hit on Diabetes.
 Q $S(G<2:"",1:1)
 ;**********
 ;
 ;----------
TEST ;
 ;D ^%T
 ;S P=0 F  S P=$O(^AUPNPAT(P)) Q:P'=+P  S X=$$HASDX(P,"BI HIGH RISK PNEUMO",2,3020101,DT) W ".",X
 ;S P=0 F  S P=$O(^AUPNPAT(P)) Q:P'=+P  S X=$$V2DM(P,,) I X S ^LORIHAS(P)="" W ".",P
 ;D ^%T
 ;Q
 ;
 ;
UPDTC() ;Build the RISKC DX related taxonomies and subsets
 ;
 ;Lock the entry - current update in progress
 L +^XTMP("BI_RISKC"):10 E  Q -1
 ;
 ;See if already processed for day
 I $G(^XTMP("BI_RISKC","COMP"))'<DT G XUPDTTS
 ;
 ;Need to recompile
 S ^XTMP("BI_RISKC",0)=DT_U_DT_U_"RISKC TAXONOMIES AND SUBSETS"
 ;
 NEW BITXTI,BITXIEN,BITEXT,BITAX,BITYPE,BIREF
 NEW BISUBI,BISUB,BISBIEN,BICONC,BISCNT
 ;
 ;Loop through DX taxonomies and build ^XTMP
 K ^XTMP("BI_RISKC","DXTAX")
 S ^XTMP("BI_RISKC","DXTAX")="DX codes reflecting immunocompromised status"
 F BITXTI=1:1 S BITEXT=$P($T(TAX+BITXTI),";;",2,99) S BITAX=$P(BITEXT,";") Q:BITAX="END"  D
 . S BITAX=$P(BITEXT,";")
 . S BITYPE=$P(BITEXT,";",2)
 . S BITXIEN=$O(^ATXAX("B",BITAX,0)) I 'BITXIEN Q
 . I $D(^ICDS(0)),$T(^ATXAPI)]"" D
 .. K ^TMP($J,"BITAX")
 .. S BIREF=$NA(^TMP($J,"BITAX"))
 .. D BLDTAX^ATXAPI(BITAX,BIREF,BITXIEN)
 .. M ^XTMP("BI_RISKC","DXTAX")=^TMP($J,"BITAX")
 .. K ^TMP($J,"BITAX")
 ;
 ;Loop through subsets and build ^XTMP
 K ^XTMP("BI_RISKC","DXSUB")
 S BISCNT=0
 F BISUBI=1:1 S BITEXT=$P($T(SUB+BISUBI),";;",2,99) S BISUB=$P(BITEXT,";") Q:BISUB="END"  D
 . S BISBIEN="" F  S BISBIEN=$O(^BSTS(9002318.4,"E",15,BISUB,BISBIEN)) Q:BISBIEN=""  D
 .. ;Retrieve Concept Id
 .. S BICONC=$P($G(^BSTS(9002318.4,BISBIEN,0)),U,2) Q:BICONC=""  ;Retrieve Concept Id
 .. S ^XTMP("BI_RISKC","DXSUB",BICONC)=""
 .. S BISCNT=BISCNT+1
 S ^XTMP("BI_RISKC","DXSUB")="SNOMED Concept Ids reflecting immunocompromised status"_U_BISCNT
 ;
 ;Update compiled date
 S ^XTMP("BI_RISKC","COMP")=DT
 ;
XUPDTTS L -^XTMP("BI_RISKC")
 Q 1
 ;=====
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
