BIPATUP3 ;IHS/CMI/MWR - UPDATE PATIENT DATA 2; DEC 15, 2011 [ 07/14/2025  11:12 PM ] ; 27 Aug 2025  11:09 PM
 ;;8.5;IMMUNIZATION;**22,26,31**;OCT 24,2011;Build 137
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  IHS FORECAST. UPDATE PATIENT DATA, IMM FORECAST IN ^BIPDUE(.
 ;;  HOLDING RTN IN CASE H1N1 (OR SIMILAR) FORECASTING IS NEEDED IN THE FUTURE.
 ;;  PATCH 1: Clarify Report explanation.  IHSZOS+19
 ;;  PATCH 4, v8.5: Use newer Related Contraindications call to determine
 ;;                 contraindicaton.  IHSZOS+29
 ;;  PATCH 14: Move IHSPNEU & IHSHEPB call here from BIPATUP1 IHSPNEU+00
 ;;  PATCH 17: Ensure and document High Risk Pneumo only satisfied by CVX 33. IHSPNEU+50
 ;;  PATCH 22: COVID Immunocompromised forecasting.  IHSCOV
 ;
 ;
 ;
 ;********** PATCH 14, v8.5, AUG 01,2017, IHS/CMI/MWR
 ;---> Move IHSPNEU & IHSHEPB calls from rtn BIPATUP1 and add BIADDND to pass
 ;---> back IHS Addendum text.
 ;----------
IHSPNEU(BIDFN,BIFLU,BIFFLU,BINF,BIFDT,BIAGE,BIDUZ2,BIRISKF,BIADDND) ;EP
 ;---> IHS Pneumo Forecast.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient IEN.
 ;     2 - BIFLU   (req) Pneumo History array: BIFLU(CVX,INVDATE).
 ;     3 - BIFFLU  (req) If =2, for force Pneumo regardless of age.
 ;     4 - BINF    (opt) Array of Vaccine Grp IEN'S that should not be forecast.
 ;     5 - BIFDT   (req) Forecast Date (date used for forecast).
 ;     6 - BIAGE   (req) Patient Age in years for this Forecast Date.
 ;     7 - BIDUZ2  (req) User's DUZ(2) indicating Immserve Forc Rules.
 ;     5 - BIRISKF (req) 1=Patient has High Risk of Pneumo; otherwise 0.
 ;     8 - BIADDND (ret) IHS forecasting addendum (to be added to TCH Report).
 ;
 ;---> NOTE: This call does NOT even get made if TCH has already forecast Pneumo
 ;--->       (LDFORC+72^BIPATUP1).
 ;
 ;---> Quit if Forecasting turned off for Pneumo.
 Q:$D(BINF(11))
 ;
 ;---> Quit if this patient has a contraindication to Pneumo.
 ;********** PATCH 4, v8.5, DEC 01,2012, IHS/CMI/MWR
 N BICT D CONTRA^BIUTL11(BIDFN,.BICT)
 Q:$D(BICT(33))   ;suryam said to leave this alone for now per email late January
 ;**********
 ;
 ;---> Quit if this Pt Age <5 yrs or >65 yrs, regardless of risk.
 Q:((BIAGE<5)!(BIAGE>64))
 ;
 ;---> Flag to indicate Pneumo already set.
 N BIFLAG S BIFLAG=0
 ;
 ;---> EARLY PNEUMO * * *
 ;---> Forecast Early Pneumo per Site Parameter.
 D
 .;---> Quit if patient has had ANY Pneumo (NOT just 33 for High Risk).
 .N A,Z
 .S Z=0
 .S A=0
 .F  S X=$O(^BIVARR("PNEU",A)) Q:'Z  D
 ..I $D(BIFLU(A)) S Z=1
 .;Q:Z
 .;---> BIPNAGE=Site Parameter Age to forecast Pneumo ("Pneumo Age") in years.
 .N BIPNAGE
 .S BIPNAGE=$P($$PNMAGE^BIPATUP2(BIDUZ2),U)
 .;---> Quit if patient is less than site parameter age.
 .Q:(BIAGE<BIPNAGE)
 .;---> Set patient due for Pneumo.
 .D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(33)_U_BIFDT)
 .S BIADDND=$G(BIADDND)_" | PNEUMO       Added per Site Parameter #11 (early Pneumo: "
 .S BIADDND=BIADDND_BIPNAGE_" yrs)."
 .S BIFLAG=1
 .S BIRISKF=1,BIRPROF(+$$BIRPROF(33))=1
 ;
 Q:BIFLAG
 ;
 ;********** PATCH 17, v8.5, MAR 01,2019, IHS/CMI/MWR
 ;---> Confirm and document High Risk Pneumo  satisfied by CVX 33, 215, 216.
 ;---> If 33, 215, 216 is in Imm Hx, BIFLU(33), BIFLU(215), BIFLU(216), IHSPOST+70^BIPATUP1, this call is never made.
 ;
 ;---> HIGH RISK * * *
 ;---> Forecast Pneumo if patient has high risk medical conditions and no previous 33, 215, 216.
 ;
 ;---> NOTE: BIFFLU=4 "Disregard Risk Factors" checked at IHSPOST+52^BIPATUP1.
 ;---> If High Risk Pneumo or Forecast for this patient regardless of Age.
 I BIRISKF!(BIFFLU=2) D
 .D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(33)_U_BIFDT)
 .I BIRISKF S BIADDND=$G(BIADDND)_" | PNEUMO       Added for High Risk Medical Conditions.|||" Q
 .S BIADDND=$G(BIADDND)_" | PNEUMO       Added due to manual edit of High Risk for this patient.|||"
 .S BIRISKF=1,BIRPROF(+$$BIRPROF(33))=1
 ;
 Q
 ;
 ;
 ;----------
IHSHEPB(BIDFN,BINF,BIFDT,BIADDNT,BIADDND) ;EP
 ;---> HS Forecast Hep B.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient IEN.
 ;     2 - BINF    (opt) Array of Vaccine Grp IEN'S that should not be forecast.
 ;     3 - BIFDT   (req) Forecast Date (date used for forecast).
 ;     4 - BIADDNT (opt) Addendum Note parameter: 1=Diabetes, 2=CLD/HepC.
 ;     5 - BIADDND (ret) IHS forecasting addendum (to be added to TCH Report).
 ;
 ;---> Quit if Forecasting turned off for Hep B.
 Q:$D(BINF(4))
 ;
 ;---> Quit if this patient has a contraindication to Hep B.
 N BICT
 D CONTRA^BIUTL11(BIDFN,.BICT)
 Q:$D(BICT(45))
 ;
 D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(45)_U_BIFDT)
 S BIADDND=$G(BIADDND)_" | Hep B        Added for High Risk"
 I $G(BIADDNT)=1 S BIADDND=BIADDND_" due to Diabetes.|||"
 I $G(BIADDNT)=2 S BIADDND=BIADDND_" due to CLD/Hep C.|||"
 S BIRISKF=1,BIRPROF(+$$BIRPROF(45))=1
 Q
 ;
 ;
 ;----------
IHSHEPA(BIDFN,BINF,BIFDT,BIADDNT,BIADDND) ;EP
 ;---> IHS Forecast Hep A.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient IEN.
 ;     2 - BINF    (opt) Array of Vaccine Grp IEN'S that should not be forecast.
 ;     3 - BIFDT   (req) Forecast Date (date used for forecast).
 ;     4 - BIADDNT (opt) Addendum Note parameter: not used for Hep A at this time.
 ;     5 - BIADDND (ret) IHS forecasting addendum (to be added to TCH Report).
 ;
 ;---> Quit if Forecasting turned off for Hep A.
 Q:$D(BINF(9))
 ;
 ;---> Quit if this patient has a contraindication to Hep B.
 N BICT D CONTRA^BIUTL11(BIDFN,.BICT)
 Q:$D(BICT(85))
 ;
 D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(85)_U_BIFDT)
 S BIADDND=$G(BIADDND)_" | Hep A        Added for High Risk due to CLD/Hep C.|||"
 S BIRISKF=1,BIRPROF(+$$BIRPROF(85))=1
 Q
 ;
 ;********** PATCH 22, v8.5, OCT 24,2011, IHS/CMI/MWR
 ;---> IHS COVID Immunocompromised forecasting.
 ;
 ;----------
IHSCOV(BIDFN,BINF,BIFDT,BICVX,BIADDND) ;EP
 ;---> IHS Forecast COVID Immunocompromised.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient IEN.
 ;     2 - BINF    (opt) Array of Vaccine Grp IEN'S that should not be forecast.
 ;     3 - BIFDT   (req) Forecast Date (date used for forecast).
 ;     4 - BICVX   (opt) CVX of specific COVID Vaccine to be forecast (Mod or Pfz).
 ;     5 - BIADDND (ret) IHS forecasting addendum (to be added to TCH Report).
 ;
 ;---> Quit if Forecasting turned off for COVID.
 Q:$D(BINF(21))
 ;
 ;---> Quit if this patient has a contraindication to COVID.
 N BICT
 D CONTRA^BIUTL11(BIDFN,.BICT)
 Q:$D(BICT(213))
 ;
 ;---> If COVID CVX not specified, forecast COVID,NOS.
 S:'$G(BICVX) BICVX=213
 ;
 D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(BICVX)_U_BIFDT)
 S BIADDND=$G(BIADDND)_" | "_$$HL7TX^BIUTL2(BICVX,2)_"      Added for Immunocompromised.|||"
 S (BIRISKF,BIRISKC)=1,BIRPROF(+$$BIRPROF(213))=1
 Q
 ;
 ;
 ;----------
IHSH1N1(BIDFN,BIFLU,BIFFLU,BIRISKI,BINF,BIFDT,BIAGE,BIIMMH1,BILIVE) ;EP
 ;---> IHS H1N1 Forecast.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient IEN.
 ;     2 - BIFLU   (req) Influ, Pneumo, and H1N1 History array: BIFLU(CVX,INVDATE).
 ;     3 - BIFFLU  (req) * NOT USED FOR NOW! *
 ;                       Value (0-4) for force Flu/Pneumo regardless of age.
 ;     4 - BIRISKI (req) 1=Patient has Risk of Influenza; otherwise 0.
 ;     5 - BINF    (opt) Array of Vaccine Grp IEN'S that should not be forecast.
 ;     6 - BIFDT   (req) Forecast Date (date used for forecast).
 ;     7 - BIAGE   (req) Patient Age in months for this Forecast Date.
 ;     8 - BIIMMH1 (opt) BIIMMFL=1 means Immserve already forecast H1N1.
 ;     9 - BILIVE  (opt) 1-Patient received a LIVE vaccine <28 days before
 ;                       the forecast date.
 ;
 ;---> Quit if Forecasting turned off for H1N1.
 Q:$D(BINF(18))
 ;
 ;---> Quit if Immserve already forecast H1N1.
 Q:$G(BIIMMH1)
 ;
 ;***********************************************************
 ;********** PATCH 4, v8.3, DEC 30,2009, IHS/CMI/MWR
 ;---> PATCH: No longer consider live vaccine factor in H1N1 forecasting.
 ;---> Quit if patient received a LIVE vaccine <28 days before forecast date.
 ;---> Also quit if patient received Flu-nasal CVX 111 on the Forecast Date.
 ;Q:$G(BILIVE)
 ;***********************************************************
 ;
 ;---> Set numeric Year, Month, and MonthDay.
 N BIYEAR,BIMTH,BIMDAY
 S BIYEAR=$E(BIFDT,1,3),BIMTH=$E(BIFDT,4,5),BIMDAY=+$E(BIFDT,4,7)
 ;
 ;---> Quit if the Forecast Date is not between Oct 1 and April 30.
 Q:((BIMDAY<1001)&(BIMDAY>430))
 ;
 ;---> Quit if this patient has a contraindication to H1N1.
 N BICONTR D CONTRA^BIUTL11(BIDFN,.BICONTR)
 Q:$D(BICONTR(125))
 ;
 ;---> Change: Quit if patient is <6 months.
 Q:BIAGE<6
 ;
 ;---> Get value for forced Influenza regardless of age.
 ;S:(31'[BIFFLU) BIFFLU=0
 ;
 ;---> Quit if over 65 yrs old and no previous H1N1 dose (regardless of risk).
 Q:((BIAGE>779)&('$D(BIFLU(125))))
 ;
 ;---> Forecast H1N1 up to 25 yrs old, and over 50 yrs.
 ;---> Quit if not age appropriate and no risk and not forced and no previous H1N1 dose.
 Q:((BIAGE>299)&('BIRISKI)&('BIFFLU)&('$D(BIFLU(125))))
 ;
 ;***********************************************************
 ;********** PATCH 4, v8.3, DEC 30,2009, IHS/CMI/MWR
 ;
 ;---> Quit if patient is 10yrs or older and has a one H1N1 already.
 ;Q:((BIAGE>120)&($D(BIFLU(125))))
 Q:((BIAGE'<120)&($D(BIFLU(125))))
 ;
 ;---> PATCH: Quit if the patient has had 2 doses.
 N M,N S M=0,N=0
 F  S M=$O(BIFLU(125,M)) Q:'M  S N=N+1
 Q:(N>1)
 ;***********************************************************
 ;
 N X,X1,X2
 S X1=BIFDT,X2=9999999-$O(BIFLU(125,0)) S:X2=9999999 X2=0
 D ^%DTC
 ;---> Quit if patient received a H1N1 shot today.
 Q:X=0
 ;---> Quit if patient had a H1N1 vac <28 days prior to Forecast date.
 Q:((X>0)&(X<28))
 ;
 ;---> X must be either null (never had flu shot) or negative (had
 ;---> a shot recently, but AFTER the Forecast Date).
 ;
 ;---> If not Jan, Feb, or March, then due date=Apr 30 of the new year.
 S:BIMDAY>430 BIYEAR=BIYEAR+1
 ;---> Due by April 30.
 N BIDUEDT S BIDUEDT=BIYEAR_0430
 ;---> Set CVX 127 due by April 30.
 D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(127)_U_U_BIYEAR_"0430")
 S BIRISKF=1,BIRPROF(+$$BIRPROF(127))=1
 Q
 ;
 ;
OUTFLU(BIFDT,BIDUZ2) ;EP
 ;---> Return 1 if Forecast Date is outside of Flu Dates.
 ;     1 - BIFDT  (req) Forecast Date (date used for forecast).
 ;     2 - BIDUZ2 (req) User's DUZ(2) indicating site parameters.
 ;
 Q:'BIFDT 0
 S:'$G(BIDUZ2) BIDUZ2=$G(DUZ(2))
 Q:'BIDUZ2 0
 ;
 N A,B,C,D S A=$E(BIFDT,4,7),B=$$FLUDATS^BIUTL8(BIDUZ2)
 S C=$TR($P(B,"%"),"/"),D=$TR($P(B,"%",2),"/")
 I (A<C)&(A>(D-1)) Q 1
 Q 0
 ;=====
 ;
 ;V8.5 PATCH 31 FID-98855 RZV HR EVALUATION
RZV(BIDFN,BIFLU,BIFFLU,BINF,BIFDT,BIYRS,BIDUZ2,BIRISKF) ;EP
 ;---> IHS RZV Forecast.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient IEN.
 ;     2 - BIFLU   (req) RZV History array: BIFLU(CVX,INVDATE).
 ;     3 - BIFFLU  (req) If =2, for force RZV regardless of age.
 ;     4 - BINF    (opt) Array of Vaccine Grp IEN'S that should
 ;                       not be forecast.
 ;     5 - BIFDT   (req) Forecast Date (date used for forecast).
 ;     6 - BIYRS   (req) Patient Age in years for this Forecast Date.
 ;     7 - BIDUZ2  (req) User's DUZ(2) indicating Immserve Forc Rules.
 ;     5 - BIRISKF (req) 1=Patient has High Risk of RZV; otherwise 0.
 ;
 ;---> NOTE: This call does NOT even get made if TCH has already forecast RZV
 ;--->       (LDFORC+72^BIPATUP1).
 ;
 ;---> Quit if Forecasting turned off for RZV.
 ;Q:$D(BINF(11))
 ;
 ;N BICT
 ;D CONTRA^BIUTL11(BIDFN,.BICT)
 ;Q:$D(BICT(33))   ;suryam said to leave this alone for now per email late January
 ;**********
 ;
 ;---> Quit if this Pt Age <19 yrs or >49 yrs, regardless of risk.
 Q:((BIYRS<19)!(BIYRS>49))
 ;
 ;---> Flag to indicate RZV already set.
 N BIFLAG
 S BIFLAG=0
 ;
 ;---> EARLY PNEUMO * * *
 ;---> Forecast Early RZV per Site Parameter.
 D
 .;---> Quit if patient has had more than 1 RZV
 .N A,Z,J
 .S Z=0
 .S A=0
 .F  S A=$O(^BIVARR("ZOS",A)) Q:'A  D
 ..I $D(BIFLU(A)) S J=J+1
 ..S:J>1 Z=1
 .Q:Z
 .;---> Set patient due for RZV.
 .D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(187)_U_BIFDT)
 .S BIRISKF=1,BIRPROF(+$$BIRPROF(187))=1
 Q
 ;=====
 ;
BIRPROF(CVX) ;EP;SET VACCINE GROUP FOR *HR*
 N VG,VGO,VDA,I0
 S CVX=+$G(CVX)
 S VG=0
 S VGO=0
 S VDA=+$O(^AUTTIMM("C",CVX,0))
 S I0=$G(^AUTTIMM(VDA,0))
 S VG=+$P(I0,U,9)
 S VGO=+$P($G(^BISERT(VG,0)),U,2)
 Q VGO
 ;=====
 ;
