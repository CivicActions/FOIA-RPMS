BIPATUP1 ;IHS/CMI/MWR - UPDATE PATIENT DATA; DEC 15, 2011 [ 05/23/2025  9:36 PM ] ; 18 Aug 2025  4:15 PM
 ;;8.5;IMMUNIZATION;**22,26,28,29,30,31**;OCT 24,2011;Build 137
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  UPDATE PATIENT DATA, IMM FORECAST IN ^BIPDUE(.
 ;;  PATCH 21: For Td,NOS (139) use REC Date, regardless of site parameter.  DDUE2+90
 ;;  PATCH 22: Changes to check for COVID High Risk.  IHSPOST, DDUE2
 ;
 ;
 ;---> IHS Forecast Addendum to TCH Report.
 ;----------
LDFORC(BIDFN,BIFORC,BIHX,BIFDT,BIDUZ2,BINF,BIPDSS,BIADDND,BIPROF) ;EP
 ;---> Load Immserve Data (Immunizations Due) into ^BIPDUE(.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient IEN.
 ;     2 - BIFORC (req) String containing Patient's Imms Due.
 ;     3 - BIHX   (req) String containing Patient's Imm History.
 ;     4 - BIFDT  (opt) Forecast Date (date used for forecast).
 ;     5 - BIDUZ2 (opt) User's DUZ(2) indicating site parameters.
 ;     6 - BINF   (opt) Array of Vaccine Grp IEN'S tO'' should not be forecast.
 ;     7 - BIPDSS (ret) Returned string of V IMM IEN's that are
 ;                      Problem Doses, according to ImmServe.
 ;     8 - BIADDND(ret) IHS forecasting addendum (to be added to TCH Report).
 ;     9 - BIPROF (req) String containing text of Patient's Imm Report so far.
 ;
 Q:'$G(BIDFN)
 Q:$G(BIFORC)=""
 Q:$G(BIHX)=""
 ;---> If no Forecast Date passed, set it equal to today.
 S:'$G(BIFDT) BIFDT=DT
 S:'$D(BINF) BINF=""
 ;
 ;---> Get Patient's Age
 N BIAGE,BIAGEYRS,BIAGEMTS,BIAGEDYS
 S BIAGE=$$AGE^BIUTL1(BIDFN,1,BIFDT)
 S BIAGEYRS=+BIAGE
 S BIAGEMTS=$P(BIAGE,U,2)
 S BIAGEDYS=$P(BIAGE,U,3)
 ;
 ;---> Clear out previously set Immunizations Due and
 ;---> Forecasting Errors for this patient.
 D KILLDUE^BIPATUP2(BIDFN)
 ;
 S:'$G(BIDUZ2) BIDUZ2=$G(DUZ(2))
 ;
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> Check for any input doses that TCH identified as problems.
 ;---> Build and return a string of "V IMM IEN_%_CVX" problem doses,
 ;---> as identified in the TCH Input Doses segment.
 D DPROBS^BIPATUP2(BIFORC,.BIPDSS)
 ;**********
 ;
 ;---> Seed BITCHAF to collect already forecasted Pneumo, HepB(45/189), HepA(85).
 N BITCHAF
 S BITCHAF=""
 ;
 ;---> Parse Doses Due from Forecaster string (BIFORC), perform any
 ;---> necessary translations, and set as due in patient global ^BIPDUE(.
 D DDUE(BIFORC,BIHX,.BINF,BIDUZ2,BIFDT,.BITCHAF,BIDFN,.BIPROF)
 ;
 ;---> After loading (SETDUE) TCH forecast, perform any follow-up forecasting
 ;---> needed for High Risk.
 D IHSPOST^BIPATUP4(BIDFN,BIHX,BIFDT,BIDUZ2,.BINF,BITCHAF,.BIADDND,.BIPROF)
 ;
 ;---> Remove BIICE condition next version.
 ;I $G(BIICE) D
 ;.I $G(BIADDND)="" S BIPROF=BIPROF_" | None|||" Q
 ;.S BIPROF=BIPROF_BIADDND
 ;
 I $G(BIICE) D
 .I $G(BIADDND)="" D  Q
 .. S BIPROF=BIPROF_" | None|||"
 .. D FSUPPN^BIPATUP5
 .S BIPROF=BIPROF_BIADDND
 .D FSUPPN^BIPATUP5
 Q
 ;
 ;
 ;----------
DDUE(BIFORC,BIHX,BINF,BIDUZ2,BIFDT,BITCHAF,BIDFN,BIPROF) ;EP
 ;---> Parse Doses Due from Immserve string (BIFORC), perform any
 ;---> necessary translations, and set as due in patient global ^BIPDUE.
 ;---> Parameters:
 ;     1 - BIFORC  (req) Forecast string coming back from TCH.
 ;     2 - BIHX    (req) String containing Patient's Imm History.
 ;     3 - BINF    (opt) Array of Vaccine Grp IEN'S that should not be forecast.
 ;     4 - BIDUZ2  (opt) User's DUZ(2) indicating site parameters.
 ;     5 - BIFDT   (opt) Forecast Date (date used for forecast).
 ;     6 - BITCHAF (ret) [1=ICE already forecast Pneumo (33), [2=HepB(45), [3=HepA(85)
 ;                       [4=COVID
 ;     7 - BIDFN   (req) Patient IEN.
 ;     8 - BIPROF  (req) String containing text of Patient's Imm Report so far.
 ;
 N BIFORC1,BIDOSE,N
 S BIFORC1=$P(BIFORC,"~~~",3)
 ;
 ;---> Get Minimum vs Recommended Age Parameter: 1=Minimum Acceptable, 0=Recommended.
 N BIMIN
 S BIMIN=$$MINAGE^BIUTL2($G(BIDUZ2))
 ;
 F N=1:1 S BIDOSE=$P(BIFORC1,"|||",N) Q:(BIDOSE="")  D
 .D DDUE2(BIDOSE,BIHX,.BINF,BIDUZ2,BIFDT,.BITCHAF,BIDFN,BIMIN,.BIPROF)
 Q
 ;
 ;
 ;----------
DDUE2(BIDOSE,BIHX,BINF,BIDUZ2,BIFDT,BITCHAF,BIDFN,BIMIN,BIPROF) ;EP
 ;---> Parse Doses.
 ;---> Parameters: See DDUE immediately above!
 ;
 ;V8.5 PATCH 31 - FID-98853 Check for min/earliest date for HPV
 N A,BI,BIQUIT,D,X,HPV
 S X=BIDOSE,BIQUIT=""
 S HPV=$S($P($G(^BISITE(+$G(BIDUZ2),0)),U,19)[7:1,1:0)
 ;
 ;---> A=CVX Code
 S A=+$P(X,U)
 ;
 ;---> *** 6-WEEK EARLISET FOR FIRST DOSES:
 ;--->     --------------------------------
 ;---> 6 wk+ Forecast Earliest/Minimum for FIRST dose of some Vaccine Groups,
 ;---> regardless of Min vs Rec site parameter.
 I 'BIMIN D
 .;---> Quit if age not at least 42 days or over 65 days.
 .Q:((BIAGEDYS<42)!(BIAGEDYS>65))
 .;---> Get Vaccine Group IEN for this CVX.
 .N G
 .S G=$$HL7TX^BIUTL2(A,1)
 .;---: Quit if Vaccine Group is not DT,POLIO,HIB,PNEUMO,ROTA
 .Q:((G'=1)&(G'=2)&(G'=3)&(G'=11)&(G'=15))
 .;---> Get Minimum/earliest date for this dose.
 .S BIMIN=1
 ;
 ;
 ;---> *** 4TH DOSE DTAP AT 12 MONTHS:
 ;--->     ---------------------------
 ;---> If DTaP and age is 12 mths, take Earliest Date from ICE.
 I $D(^BIVARR("DT",A)),(BIAGEDYS>364) S BIMIN=1
 I $D(^BIVARR("HPV",A)),$G(HPV) S BIMIN=1
 ;
 ;---> "PAST"=Past Due Indicator
 S BI("PAST")=$P(X,U,3)
 ;
 ;---> Get Fileman formats of Due Dates.
 ;
 ;---> "REC"=Recommended Date Due
 S BI("REC")=$$TCHFMDT^BIUTL5($P(X,U,5)) S:('BI("REC")) BI("REC")=""
 ;
 ;---> "MIN"=Minimum Date Due (if null, set equal to REC).
 S BI("MIN")=$$TCHFMDT^BIUTL5($P(X,U,4)) S:('BI("MIN")) BI("MIN")=BI("REC")
 ;
 ;---> "EXC"=Exceeds Date Due
 S BI("EXC")=$$TCHFMDT^BIUTL5($P(X,U,6)) S:('BI("EXC")) BI("EXC")=""
 ;
 ;---> Determine whether to set Due Date = Rec Age or Min Accepted Age
 ;---> based on Site Parameter.
 S BI("DUE")=BI("REC")
 I BIMIN S BI("DUE")=BI("MIN")
 ;---> Quit if the Forecast Date is before the Due Date.
 Q:(BIFDT<BI("DUE"))
 ;
 ;
 ;---> If this dose is past due (BI("PAST")=1), D(2) will stuff DATE PAST DUE;
 ;---> Otherwise, D(1) will stuff RECOMMENDED DATE DUE.
 S (D(1),D(2))="" D
 .I BI("PAST") S D(2)=BI("EXC") Q
 .S D(1)=BI("DUE")
 ;
 ;---> *** TRANSLATIONS OF INCOMING IMMSERVE VACCINES:
 ;--->     -------------------------------------------
 ;
 ;********** PATCH 17, v8.5, MAR 01,2019, IHS/CMI/MWR
 ;---> If TCH passes CVX 171 for Flu, change to 88, Flu,NOS.
 S:A=171 A=88
 ;
 ;---> Check to see if Site does not forecast this Vaccine Group.
 Q:$D(BINF($$HL7TX^BIUTL2(A,1)))
 ;
 ;---> Filter for Site Parameter Flu Season Dates.
 I A=88 Q:$$OUTFLU^BIPATUP3(BIFDT,BIDUZ2)
 I $D(^BIVARR("INFLU",A)) Q:$$OUTFLU^BIPATUP3(BIFDT,BIDUZ2)
 ;
 ;********** PATCH 17, v8.5, JUL 01,2019, IHS/CMI/MWR
 ;---> Do not forecast Men-B if site parameter has it turned off.
 I '$$VGROUP^BIUTL2(19,3) Q:$D(^BIVARR("MEN",A,19))
 ;**********
 ;
 ;********** PATCH 18, v8.5, JUL 01,2019, IHS/CMI/MWR
 ;---> Do not forecast MMR or Varicella if Patient is >18 yrs.
 I $D(^BIVARR("MMRV",A)) Q:(BIAGEYRS>18)
 ;
 ;********** PATCH 21, v8.5, APR 01,2021, IHS/CMI/MWR
 ;---> For Td,NOS (139) use Recommended Date, regardless of site parameter.
 I $D(^BIVARR("TD","NOS",A)) Q:(BIFDT<BI("REC"))
 ;**********
 ;
 ;---> *** TDAP-TD FORECASTING:
 ;--->     --------------------
 ;---> If DTAP-Td-Tdap forecast, check & translate as needed.
 ;V8.5 PATCH 29 - FID-107546 Adjust Td,NOS forecast
 I $D(^BIVARR("DT",A))!$D(^BIVARR("TDAP",A))!$D(^BIVARR("TD",A)),BIAGEYRS>18 D TDAP
 Q:BIQUIT
 ;**********
 ;
 ;---> *** DROP-THROUGH TO HERE TO SET DUE:
 ;--->     --------------------------------
 ;---> Add this Immunization Due.
 D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(A)_U_U_D(1)_U_D(2))
 ;
 ;---> Use BITCHAF to track TCH forecasting of Pneumo, Hep A and Hep B.
 ;
 ;---> Pneumo 33 OR 133 was forecast by TCH.
 ;I (A=33)!(A=133) S BITCHAF=BITCHAF_1
 I $D(^BIVARR("PNEU",A)) S BITCHAF=BITCHAF_1
 ;---> Hep B was forecast by TCH.
 ;I (A=45)!(A=189) S BITCHAF=BITCHAF_2
 I $D(^BIVARR("HEP B",A)) S BITCHAF=BITCHAF_2
 ;---> Hep A was forecast by TCH.
 ;I A=85 S BITCHAF=BITCHAF_3
 I $D(^BIVARR("HEP A",A)) S BITCHAF=BITCHAF_3
 ;
 ;********** PATCH 22, v8.5, OCT 24,2011, IHS/CMI/MWR
 ;---> COVID was forecast by ICE.
 I $D(^BIVARR("COV",A)) S BITCHAF=BITCHAF_4
 I $$HL7TX^BIUTL2(A,1)=21 S BITCHAF=BITCHAF_4
 ;
 ;****** PATCH 26, v8.5, IHS/CMI/LAB
 ;----> MEN B was forecast by ICE.
 I $D(^BIVARR("MEN B",A)) S BITCHAF=BITCHAF_5
 I $$HL7TX^BIUTL2(A,1)=19 S BITCHAF=BITCHAF_5
 ;
 Q
 ;=====
 ;
TDAP ;---> If DTAP-Td-Tdap forecast, check & translate as needed.
 ;V8.5 PATCH 29 - FID-107546 Adjust Td,NOS forecast
 N BIARRD,BIARRV,BIDOZE,BIHXX,N
 S BIHXX=$P(BIHX,"~~~",2)
 F N=1:1 S BIDOZE=$P(BIHXX,"|||",N) Q:(BIDOZE="")  D
 .;
 .;---> Quit (discount dose) if Dose Override=Invalid, pc 4=2.
 .Q:($P(BIDOZE,U,4)=2)
 .;
 .;---> Set up 2 arrays: (CVX,Date) and (Date,CVX).
 .;---> e.g., BIARRD(20000301,115)=""
 .N BIV,BID
 .S BIV=$P(BIDOZE,U,2)
 .S BID=$P(BIDOZE,U,3)
 .;
 .;S:$D(^BIVARR("TDAP",BIV))!$D(^BIVARR("TD",BIV))!$D(^BIVARR("DT",BIV)) BIARRV(BIV,+BID)="",BIARRD(+BID,BIV)=""
 .S:$D(^BIVARR("GRP",8,BIV)) BIARRV(BIV,+BID)="",BIARRD(+BID,BIV)=""
 ;
 ;---> If pt never had Tdap, ICE will forecast it properly 6 mths after
 ;---> any previous Td.  So, if no Tdap hx, just quit.
 Q:'$O(BIARRV(0))
 ;
 ;---> Patient is >18, had Tdap (115), 10 yrs since, forecast Td_Adult (9).
 N X
 S X=($O(BIARRD(99999999),-1)-16900000)
 ;
 ;I X<BIFDT S A=115 Q
 I X<BIFDT S A=139 Q
 ;---> Not yet 10 yrs since a Tdap, block this dose.
 S BIQUIT=1
 Q
 ;=====
 ;
