BIREPL4 ;IHS/CMI/MWR - REPORT, ADULT IMM; OCT 15, 2010 ; 30 May 2025  10:36 AM
 ;;8.5;IMMUNIZATION;**26,29,30,31**;OCT 24,2011;Build 137
 ;;  GATHER DATA FOR ADULT IMMUNIZATION REPORT.
 ;
 ;----------
GETVAL ;get value for each line on the report for this patient
 S (BIVAL,BI19P,BI60P,BI65P,BI1926,BI1959,BITDAPEV,BITD10YR,BITDBOTH,BIALLAPP,BI66APN,BI65APN)=0
 S (BIHEPB1,BIHEPB2,BIHEPBC,BIHPVD,BIHPVF1,BIHPVF2,BIHPVFC,BISHIN1,BISHINC,BIPCV13,BIPPSV23,BIPCV20,BIPCV15,BIREFUS)=0
 S (BI19P,BI60P,BI65P,BI1926,BI1959,BI50P,BI1964,BI1949,BI5059,BI6065,BI66P)=0
 N X,Y,I,J,T,D,G,V,BD,ED
 ;set age variables
 S BI19P=1  ;19+
 S:BIAGE>59 BI60P=1  ;60+
 S:BIAGE>64 BI65P=1  ;66+
 I BIAGE<27 S BI1926=1  ;19-26
 I BIAGE<60 S BI1959=1  ;19-59
 I BIAGE>49 S BI50P=1  ;50+ FOR SHINGRIX
 I BIAGE<64 S BI1964=1
 I BIAGE<50 S BI1949=1
 I BIAGE>49,BIAGE<60 S BI5059=1
 I BIAGE>59,BIAGE<66 S BI6065=1
 I BIAGE>65 S BI66P=1
 ;---> TETANUS STATS ******************************
TDS ;---> If Tdap EVER.
 I $$TD(BIDFN,BICPTI,BIQDT,2) S BITDAPEV=1  ;tdap ever
 I $$TD(BIDFN,BICPTI,BIQDT) S BITD10YR=1  ;TDAP OR TD IN past 10 years
 I BITDAPEV,BITD10YR S BITDBOTH=1
HEPBS ;
 I BI1959 D
 .S X=$$HEPB(BIDFN,BICPTI,BIQDT)
 .I X=1 S BIHEPB1=1
 .I X=2 S BIHEPB2=1
 .I X>2 S BIHEPBC=1
 ;
HPVS ;HPV STATS
 I BI1926 D
 .N BIHPVD S BIHPVD=$$HPV(BIDFN,BICPTI,BIQDT)
 .S:BIHPVD=1 BIHPVF1=1
 .S:BIHPVD=2 BIHPVF2=1
 .S:BIHPVD>2 BIHPVFC=1
 ;
SHINS ;---> Shingrix stats ************
 I BI50P D
 .S X=$$SHINGRIX(BIDFN,BICPTI,BIQDT)
 .I X=1 S BISHIN1=1
 .I X>1 S BISHINC=1
 ;
PNEUMOS ;---> Pneumo stats  ******
 ;set pcv13, PCV15, PCV20,PPSV23
 S BIPCV13=$$PCV13^BIREPL1(BIDFN,BICPTI,BIQDT)
 S BIPCV15=$$PCV15^BIREPL1(BIDFN,BICPTI,BIQDT)
 S BIPCV20=$$PCV20^BIREPL1(BIDFN,BICPTI,BIQDT)
 S BIPPSV23=$$PPSV23^BIREPL1(BIDFN,BICPTI,BIQDT)
REFS ;
 ;---> Add refusals, if any.
 N Z D REFUSAL^BIUTL13(BIDFN,.Z) I $O(Z(0)) S BIREFUS=1
 Q
 ;
 ;
 ;----------
TD(BIDFN,BICPTI,BIQDT,BITDAP) ;EP
 ;---> Return 1 if patient received TD during 10 years prior to QDT.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient DFN
 ;     2 - BICPTI (opt) 1=Include CPT Coded Visits, 0=Ignore CPT.
 ;     3 - BIQDT  (opt) Quarter Ending Date (ignore Visits after this date).
 ;     4 - BITDAP (opt) 1=Tdap ONLY during 10 years prior to QDT.
 ;                      2=Tdap ONLY and EVER (no prior date restriction).
 ;
 ;---> Check V Imms for TD's.
 N BICVXS,BIDATE
 S BIDATE=0 S:('$G(BIQDT)) BIQDT=$G(DT)
 S BITDAP=+$G(BITDAP)
 S BICVXS="9,113,115,138,139"
 S:BITDAP BICVXS="115,113"
 ;V8.5 PATCH 31 - FID-
 S BIDATE=$$LASTIMM^BIUTL11(BIDFN,BICVXS,BIQDT)
 ;
 ;---> So, BIDATE is the latest TD in V Imm (but not after the QDT).
 ;
 ;---> Check (if requested) V CPTs for TD's.
 D:$G(BICPTI)
 .N BICPTS,Y
 .S BICPTS="90714,90715"
 .S:BITDAP BICPTS=90715
 .S Y=$$LASTCPT^BIUTL11(BIDFN,BICPTS,BIQDT)
 .S:Y>$G(BIDATE) BIDATE=Y
 ;
 ;********** PATCH 12, v8.5, OCT 24,2011, IHS/CMI/MWR
 ;---> If BITDAP=2, return 1 if Tdap EVER.
 I BITDAP=2 Q $S(BIDATE:1,1:0)
 ;**********
 ;
 ;---> Return 0 if last Td was MORE than 10 yrs prior to QDT (or never);
 ;---> otherwise return 1.
 Q $S((BIDATE+100000)<BIQDT:0,1:1)
 ;
 ;
 ;----------
 ;----------
SHINGRIX(BIDFN,BICPTI,BIQDT) ;EP
 ;---> Return # shingrix doses
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient DFN
 ;     2 - BICPTI (opt) 1=Include CPT Coded Visits, 0=Ignore CPT.
 ;     3 - BIQDT  (opt) Quarter Ending Date (ignore Visits after this date).
 ;
 ;---> Check V Imms for Shingrix
 N BICVXS,BIDATE,BIABD,J,I,C,BICPTS,Y,BIDOSES
 S BIDATE=0 S:('$G(BIQDT)) BIQDT=$G(DT)
 S BICVXS="187,188"
 S BIDATE=$$LASTIMM^BIUTL11(BIDFN,BICVXS,BIQDT,1)
 ;set array by date
 F I=1:1 S J=$P(BIDATE,",",I) Q:J=""  S BIABD(J)=""
 ;
 ;---> Check (if requested) V CPTs for Shingrix.
 D:$G(BICPTI)
 .S BICPTS="90750"
 .S Y=$$LASTCPT^BIUTL11(BIDFN,BICPTS,BIQDT,1)
 .F I=1:1 S J=$P(BIDATE,",",I) Q:J=""  S BIABD(J)=""
 ;
 ;---> Return # of doses
 S BIDOSES=0
 S J=0 F  S J=$O(BIABD(J)) Q:J'=+J  S BIDOSES=BIDOSES+1
 Q BIDOSES
 ;
 ;
 ;----------
HPV(BIDFN,BICPTI,BIQDT) ;EP
 ;---> Return number of HPV's patient received, concat
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient DFN
 ;     2 - BICPTI (opt) 1=Include CPT Coded Visits, 0=Ignore CPT.
 ;     3 - BIQDT  (opt) Quarter Ending Date (ignore Visits after this date).
 ;
 ;---> Check V Imms for FLU's.
 N BICVXS,BIDATE,BIDOSES,I,J,BIABD,T,D,BD,ED,G,V,X,ON2,F
 S BIDATE=0,BIDOSES=0,J=0,ON2=""
 S:('$G(BIQDT)) BIQDT=$G(DT)
 ;set up array by date
 ;GET FIRST ONE'S DATE
 ;now get all of them
 S BICVXS="62,118,137,165"
 S BIDATE=$$LASTIMM^BIUTL11(BIDFN,BICVXS,BIQDT,1)
 ;set up array by date
 F I=1:1 S J=$P(BIDATE,",",I) Q:J=""  S BIABD(J)=""
 ;
 ;---> Check (if requested) V CPTs for HPV's.
 D:$G(BICPTI)
 .N BICPTS,J S J=0
 .S BICPTS="90649,90650,90651"
 .S BIDATE=$$LASTCPT^BIUTL11(BIDFN,BICPTS,BIQDT,1)
 .F I=1:1 S J=$P(BIDATE,",",I) Q:J=""  S BIABD(J)=""
 ;
 S G="" F I=1:1 S J=$P(BIDATE,",",I) Q:J=""  S:G="" G=J S:J<G G=J
 I G,$$AGE^AUPNPAT(BIDFN,G)<15 S ON2=1  ;if had ONE before age 15 pt only needs 2
 S J=0 F  S J=$O(BIABD(J)) Q:J'=+J  S BIDOSES=BIDOSES+1
 I BIDOSES>2 Q 3
 I ON2,BIDOSES>1 Q 3
 Q BIDOSES
HEPB(BIDFN,BICPTI,BIQDT) ;EP
 ;get all immunizations
 NEW BIABD,I,J,T,D,BD,ED,G,V,X
 ;check 2 dose first
 S BICVXS="189"
 S D=$$LASTIMM^BIUTL11(BIDFN,BICVXS,BIQDT,1)
 ;set up array by date
 F I=1:1 S J=$P(D,",",I) Q:J=""  S BIABD(J)=""
 ;go through and set into array if 10 days apart
 ;now get cpts
 G:'BICPTI HEPB21
 S ED=9999999-BIQDT,BD=9999999-$$DOB^AUPNPAT(BIDFN),G=0
 F  S ED=$O(^AUPNVSIT("AA",BIDFN,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",BIDFN,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U) S Z=$P($$CPT^ICPTCOD(Y),U,2) I Z=90743 S BIABD(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Z=$P($$CPT^ICPTCOD(Y),U,2) I Z=90743 S BIABD(9999999-$P(ED,"."))=""
HEPB21 ;
 S BIABD=0,X=0 F  S X=$O(BIABD(X)) Q:X'=+X  S BIABD=BIABD+1
 I BIABD>1 Q 3   ;2 DOSE MEANS COMPLETE SERIES SO SET TO 3
 ;
 ;CHECK 3 DOSE
 S BICVXS="8,42,43,44,45,51,102,104,110,132,146,189,193,198,220"
 S D=$$LASTIMM^BIUTL11(BIDFN,BICVXS,BIQDT,1)
 ;set up array by date
 F I=1:1 S J=$P(D,",",I) Q:J=""  S BIABD(J)=""
 ;go through and set into array if 10 days apart
 ;now get cpts
 G:'BICPTI HEPB1
 S ED=9999999-BIQDT,BD=9999999-$$DOB^AUPNPAT(BIDFN),G=0
 S T=$O(^ATXAX("B","BGP HEPATITIS CPTS",0))
 F  S ED=$O(^AUPNVSIT("AA",BIDFN,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",BIDFN,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U) S Z=$P($$CPT^ICPTCOD(Y),U,2) I $$ICD^ATXAPI(Y,T,1) S BIABD(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Z=$P($$CPT^ICPTCOD(Y),U,2) I $$ICD^ATXAPI(Y,T,1) S BIABD(9999999-$P(ED,"."))=""
HEPB1 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BIABD(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BIABD(X) Q
 .S Y=X
 ;now count them and see if there are 3 of them
 S BIABD=0,X=0 F  S X=$O(BIABD(X)) Q:X'=+X  S BIABD=BIABD+1
 Q BIABD
 ;
MORE ;EP - called from birepl2
 ; composite 66+
 S X=$$PAD("  Total Number of Patients 66 years and older",56)_": "
 S X=X_$$C(BITOTS("PTS66+"),0,8) D WRITE^BIREPL2(.BILINE,X,1)
 ;
 S X=$$PAD("    Received 1 dose of Tdap ever",56)
 S X=X_": "_$$C(BITOTS("66+TDAPEVER"),0,8)
 I BITOTS("PTS66+") S X=X_$J((BITOTS("66+TDAPEVER")/BITOTS("PTS66+"))*100,7,1)
 D WRITE^BIREPL2(.BILINE,X)
 ;
 S X=$$PAD("    Received 1 dose of Tdap or Td < 10 years",56)
 S X=X_": "_$$C(BITOTS("66+TDAP/TD10YR"),0,8)
 I BITOTS("PTS66+") S X=X_$J((BITOTS("66+TDAP/TD10YR")/BITOTS("PTS66+"))*100,7,1)
 D WRITE^BIREPL2(.BILINE,X)
 ;
 S X=$$PAD("    Received 1 dose of Tdap ever AND Tdap or Td < 10 yrs",56)
 S X=X_": "_$$C(BITOTS("66+TDAP&TD10YR"),0,8)
 I BITOTS("PTS66+") S X=X_$J((BITOTS("66+TDAP&TD10YR")/BITOTS("PTS66+"))*100,7,1)
 D WRITE^BIREPL2(.BILINE,X)
 ;
 S X=$$PAD("    Received Shingrix series complete",56)
 S X=X_": "_$$C(BITOTS("66+SHINC"),0,8)  ;p26 piece 3
 I BITOTS("PTS66+") S X=X_$J((BITOTS("66+SHINC")/BITOTS("PTS66+"))*100,7,1)
 D WRITE^BIREPL2(.BILINE,X,1)
 ;
 S X=$$PAD("   Must meet ONE of the following:")
 D WRITE^BIREPL2(.BILINE,X)
 ;
 S X=$$PAD("    Received 1 dose of PCV13 AND 1 dose PPSV23",56)
 S X=X_": "_$$C(BITOTS("66+PCV13PPSV23"),0,8)
 I BITOTS("PTS66+") S X=X_$J((BITOTS("66+PCV13PPSV23")/BITOTS("PTS66+"))*100,7,1)
 D WRITE^BIREPL2(.BILINE,X)
 ;
 S X=$$PAD("    Received 1 dose of PCV20",56)
 S X=X_": "_$$C(BITOTS("66+PCV20"),0,8)
 I BITOTS("PTS66+") S X=X_$J((BITOTS("66+PCV20")/BITOTS("PTS66+"))*100,7,1)
 D WRITE^BIREPL2(.BILINE,X)
 ;
 S X=$$PAD("    Received 1 dose of PCV15 AND 1 dose of PPSV23",56)
 S X=X_": "_$$C(BITOTS("66+PCV15PPSV23"),0,8)
 I BITOTS("PTS66+") S X=X_$J((BITOTS("66+PCV15PPSV23")/BITOTS("PTS66+"))*100,7,1)
 D WRITE^BIREPL2(.BILINE,X)
 ;
 S X=$$PAD("    Received 1 of the above - fully vaccinated for Pneumo",56)
 S X=X_": "_$$C(BITOTS("66+ANYPNEU"),0,8)
 I BITOTS("PTS66+") S X=X_$J((BITOTS("66+ANYPNEU")/BITOTS("PTS66+"))*100,7,1)
 D WRITE^BIREPL2(.BILINE,X,1)
 ;
 S X=$$PAD("   Must meet ONE of the following:")
 D WRITE^BIREPL2(.BILINE,X)
 ;
 S X=$$PAD("   Received 1 dose of Tdap AND Tdap/Td <10 years AND Shingrix")
 D WRITE^BIREPL2(.BILINE,X)
 S X=$$PAD("   series complete and 1 dose PCV13 AND 1 dose PPSV23",56)
 S X=X_": "_$$C(BITOTS("66+MET1"),0,8)
 I BITOTS("PTS66+") S X=X_$J((BITOTS("66+MET1")/BITOTS("PTS66+"))*100,7,1)
 D WRITE^BIREPL2(.BILINE,X)
 ;
 S X=$$PAD("   Received 1 dose of Tdap AND Tdap/Td <10 years AND Shingrix")
 D WRITE^BIREPL2(.BILINE,X)
 S X=$$PAD("   series complete and 1 dose PCV20",56)
 S X=X_": "_$$C(BITOTS("66+MET2"),0,8)
 I BITOTS("PTS66+") S X=X_$J((BITOTS("66+MET2")/BITOTS("PTS66+"))*100,7,1)
 D WRITE^BIREPL2(.BILINE,X)
 ;
 S X=$$PAD("   Received 1 dose of Tdap AND Tdap/Td <10 years AND Shingrix")
 D WRITE^BIREPL2(.BILINE,X)
 S X=$$PAD("   series complete and 1 dose PCV15 AND 1 dose PPSV23",56)
 S X=X_": "_$$C(BITOTS("66+MET3"),0,8)
 I BITOTS("PTS66+") S X=X_$J((BITOTS("66+MET3")/BITOTS("PTS66+"))*100,7,1)
 D WRITE^BIREPL2(.BILINE,X,1)
 ;
 S X=$$PAD("    Met one of the above (fully vaccinated)",56)
 S X=X_": "_$$C((BITOTS("66+MET1")+BITOTS("66+MET2")+BITOTS("66+MET3")),0,8)
 I BITOTS("PTS66+") S X=X_$J(((BITOTS("66+MET1")+BITOTS("66+MET2")+BITOTS("66+MET3"))/BITOTS("PTS66+"))*100,7,1)
 D WRITE^BIREPL2(.BILINE,X,2)
 ;
 S X=$$PAD("  Total Number of Patients 19 years and older",56)_": "
 S X=X_$$C(BITOTS("PTS19+"),0,8) D WRITE^BIREPL2(.BILINE,X,1)
 ;
 S X=$$PAD("   Total Patients 19 years and older appropriately")
 D WRITE^BIREPL2(.BILINE,X)
 S X=$$PAD("   vaccinated per age recommendations",56)
 S X=X_": "_$$C(BITOTS("ALLAPP"),0,8)
 I BITOTS("PTS19+") S X=X_$J((BITOTS("ALLAPP")/BITOTS("PTS19+"))*100,7,1)
 D WRITE^BIREPL2(.BILINE,X)
 Q
 ;
 ;
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
 ;
 ;
 ;----------
PAD(D,L,C) ;EP
 Q $$PAD^BIUTL5($G(D),$G(L),".")
