BIPATUP4 ;IHS/CMI/MWR - UPDATE PATIENT DATA; DEC 15, 2011 [ 07/15/2025  10:27 PM ] ; 25 Aug 2025  2:40 PM
 ;;8.5;IMMUNIZATION;**22,26,29,30,31**;OCT 24,2011;Build 137
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  UPDATE PATIENT DATA, IMM FORECAST IN ^BIPDUE(.
 ;;  PATCH 22: Changes to check for COVID High Risk.  IHSPOST
 ;;  V8.5 P 29 FID-107546 106351 106359
 ;
 ;V8.5 PATCH 29 - FID-106359 Relocation MenB to BI Site Parameters
 ;V8.5 PATCH 31 - FID-116770 Expand to 23 yrs
 ;V8.5 PATCH 29 - FID-106351 Force RSV for 60-74
 ;V8.5 PATCH 31 - FID-118921 Nirsevimab 8-19 mts, Oct thru Mar
 ;----------
 ;
IHSPOST(BIDFN,BIHX,BIFDT,BIDUZ2,BINF,BITCHAF,BIADDND,BIPROF) ;EP
 ;---> Post forecast; after ICE forecast, perform any follow-up
 ;---> forecasting needed for High Risk.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient IEN.
 ;     2 - BIHX    (req) String containing Patient's Imm History.
 ;     3 - BIFDT   (req) Forecast Date (date used for forecast).
 ;     4 - BIDUZ2  (req) User's DUZ(2) for High Risk Site Parameter.
 ;     5 - BINF    (opt) Array of Vaccine Grp IEN'S that should not be forecast.
 ;     6 - BITCHAF (ret) [1=ICE already forecast Pneumo (33), [2=HepB(45), [3=HepA(85)
 ;                       [4=COVID
 ;     7 - BIADDND (ret) IHS forecasting addendum (to be added to TCH Report).
 ;     8 - BIPROF  (ret) String containing text of Patient's Imm Report so far.
 ;
 ;
 ;--->                  SET FORECAST DATE
 S:'$G(BIFDT) BIFDT=$G(DT)
 ;
 ;--->                  GET PATIENT AGE IN YEARS
 N BIAGE,BIYRS,BIMTS,BIDYS,BIRPROF
 S BIAGE=$$AGE^BIUTL1(BIDFN,1,BIFDT)
 ;QUIT IF DECEASED OR UNKNOWN
 Q:$E(BIAGE)?1U
 S BIYRS=+BIAGE
 S BIMTS=$P(BIAGE,U,2)
 S BIDYS=$P(BIAGE,U,3)
 ;
 ;--->                  GET SITE RISK FACTORS
 ;
 ;--->    1="Pneumo"
 ;--->    2="Hep B-DM"
 ;--->    3="Heb A&B"
 ;--->    4="COVID"
 ;--->    5="Men-B for 16-23"
 ;--->    6="RSV for 60-74"
 ;--->    7="HPV Early forecast at age 9"
 ;--->    8="RecombZV for 19 to 48 yrs"
 ;--->    S="Smoking"
 ;   
 ;---> Loop through RPMS History
 ;---> Collect for prior select IMMS
 ;
 D BIDOSE ;Put Imm HX in BIFLU(CVX,REVERSE DATE)
 ;
 ;--->                  Patient RIST FACTORS
 ;
 ;---> Forced Pneumo or Disregard Risk Factors.
 ;---> BIFFLU:
 ;     0=Normal
 ;     1=Influenze
 ;     2=Pneumococcal
 ;     3=Influenza and Pneumo
 ;     4=Disregard Risk Factors.
 ;
 N BIFFLU
 S BIFFLU=$$INFL^BIUTL11(BIDFN)
 ;
 ;---> Smoking - BIRISK includes 'S'
 N BIRISK
 S BIRISK=$$RISKP^BIUTL2(BIDUZ2)
 ;
 N BISMKR
 S BISMKR=$S(BIRISK["S":1,1:0)
 ;
 I BIRISK[1,BIYRS>18 D PNEUMO
 I BIRISK[2,BIYRS>18,BIYRS<60 D HEPBDIAB
 I BIRISK[3,BIYRS>18 D HEPABC
 I BIRISK[4,BIYRS>11 D COVID
 I BIRISK[5,BIYRS>15,BIYRS<24 D MENB
 I BIRISK[6,BIYRS>59,BIYRS<75 D RSV(BIDFN)
 I BIRISK[7,BIYRS>8,BIYRS<11 S BIRPROF(18)=1
 I BIRISK[8,BIYRS>18,BIYRS<50 D RZV(BIDFN,BIYRS,.BIFLU,BIRISK,"D")
 I BIRISK[9,BIDYS>249,BIDYS<598,+$E(BIFDT,4,5)>9!(+$E(BIFDT,4,5)<4) D RSV819(BIDFN)
 ;
 K ^BITMP($J,BIDFN,"BIRPROF")
 M ^BITMP($J,BIDFN,"BIRPROF")=BIRPROF
 Q
 ;
 ;---> * * * Forecast Pneumo for High Risk   * * *
PNEUMO ;---> High Risk for Pneumo         BIRISKPN=1
 ;
 N BIRISKPN
 D RISKP^BIDX(BIDFN,BIFDT,BIYRS,BISMKR,.BIRISKPN)
 Q:'BIRISKPN
 ;
 ;---> Forced Pneumo or Disregard Risk Factors.
 ;---> BIFFLU:
 ;     0=Normal
 ;     1=Influenze
 ;     2=Pneumococcal
 ;     3=Influenza and Pneumo
 ;     4=Disregard Risk Factors.
 ;
 N BIFFLU
 S BIFFLU=$$INFL^BIUTL11(BIDFN)
 ;
 ;---> * * * Forecast Pneumo for High Risk if needed. * * *
 ;
 ;---> Quit if CVX 33, 215 or 216 already in the history
 Q:($D(BIFLU(33)))
 Q:($D(BIFLU(215)))  ;ihs/cmi/lab p26 added 215
 Q:($D(BIFLU(216)))   ;ihs/cmi/lab p26 added 216
 ;
 ;---> Quit if TCH already forecast Pneumo (33).
 ;
 ;---> Check if Site Parameter includes Smoking (includes 9).
 N BIRISKF,BISMKR
 S BISMKR=$S(BIRISK["S":1,1:0)
 ;---> Check for High Risk.
 D RISKP^BIDX(BIDFN,BIFDT,BIYRS,BISMKR,.BIRISKF)
 D:BIRISKF
 .S BIRPROF(+$$BIRPROF^BIPATUP3(33))=1
 Q:(BITCHAF[1)
 ;
 ;---> Set Early Forecast or High Risk if needed.
 D IHSPNEU^BIPATUP3(BIDFN,.BIFLU,BIFFLU,.BINF,BIFDT,BIYRS,BIDUZ2,BIRISKF,.BIADDND)
 Q
 ;=====
 ;
HEPBDIAB ;---> * * * Forecast Hep B for Diabetes if needed. * * *
 ;---> High Risk for Hep B if BIRISKHB=1
 ;---> Quit if Hep B (45) is in the history, ever received a Hep B.
 ;---> Quit if Site Parameter does not include Hep B for Diabetes.
 Q:($D(BIFLU(45)))
 ;
 ;
 N BIRISKHB
 D RISKB^BIDX(BIDFN,BIFDT,BIYRS,.BIRISKHB)
 Q:'$G(BIRISKHB)
 S BIRPROF(+$$BIRPROF^BIPATUP3(45))=1
 ;
 ;---> Quit if TCH already forecast Hep B (45).
 Q:(BITCHAF[2)
 ;
 ;---> Set Early Forecast or High Risk if needed.
 D IHSHEPB^BIPATUP3(BIDFN,.BINF,BIFDT,1,.BIADDND)
 S BITCHAF=BITCHAF_2
 Q
 ;=====
 ;
 ;---> * * * Forecast Hep A & B for CLD/HepC * * *
HEPABC ;--->  * * * Forecast Hep A & B for CLD/HepC if needed. * * *
 ;---> No High Risk computation under 19 years.
 ;
 ;---> Quit if Site Parameter does not include Hep A&B for CLD/HepC.
 Q:(BIRISK'[3)
 ;
 ;---> Quit if Hep A (85) and Hep B (45) are BOTH in the history.
 Q:($D(BIFLU(85))&$D(BIFLU(45)))
 ;
 ;---> High Risk for Hep A & Hep B  BIRISKAB=1
 ;
 N BIRISKAB
 D RISKAB^BIDX(BIDFN,BIFDT,.BIRISKAB)
 Q:'BIRISKAB
 N CVX
 F CVX=45,85 S BIRPROF(+$$BIRPROF^BIPATUP3(CVX))=1
 ;
 ;---> If TCH did NOT already forecast Hep B (45), forecast Hep B for CLD/HepC.
 I '$D(BIFLU(45))&(BITCHAF'[2) D IHSHEPB^BIPATUP3(BIDFN,.BINF,BIFDT,2,.BIADDND)
 ;
 ;---> If TCH did NOT already forecast Hep A (85), forecast Hep A for CLD/HepC.
 I '$D(BIFLU(85))&(BITCHAF'[3) D IHSHEPA^BIPATUP3(BIDFN,.BINF,BIFDT,,.BIADDND)
 Q
 ;=====
 ;
 ;---> * * * Forecast COVID for Immunocompromised if needed. * * *
 ;
 N BIRISKC
 D RISKC^BIDX(BIDFN,BIFDT,,.BIRISKC)
 Q:'BIRISKC
 S BIRPROF(+$$BIRPROF^BIPATUP3(213))=1
 ;
 Q
 ;=====
 ;
BIDOSE ;---> Loop through RPMS History in BIHX1
 ;---> Collect for prior select IMMS
 ;---> Store in BIFLU by HL7 Code, inverse date.
 ;
 N BIDOSE,BIHX1,I,X,Y
 S BIHX1=$P(BIHX,"~~~",2) S ^BITMP("BIHX")=BIHX
 ;
 F I=1:1 S BIDOSE=$P(BIHX1,"|||",I) Q:BIDOSE=""  D BD1
 Q
 ;=====
 ;
BD1 ;---> For this Immunization, set A=CVX Code, D=Date.
 N A,D,IEN,I0,IGRP
 S A=$P(BIDOSE,U,2)
 S D=$P(BIDOSE,U,3)
 Q:'A!'D
 S IEN=+$O(^AUTTIMM("C",A,0))
 S I0=$G(^AUTTIMM(IEN,0))
 S IGRP=$P(I0,U,9)
 ;
 ;---> Quit if Dose Override is Invalid (1-4).
 I $P(BIDOSE,U,4),$P(BIDOSE,U,4)<9 Q
 ;
 ;---> If this is Hep B or Hep A,
 ;---> translate and store it in local array BIFLU(CVX,Inverse Fm date).
 ;
 ;---> For special case Twinrix 104, both HepA and HepB, save both
 ;---> and quit.  Prevent HepB 45 getting saved, but Hep A 85 lost.
 I A=104 D  Q
 .S BIFLU(45,9999999-$$TCHFMDT^BIUTL5(D))=""
 .S BIFLU(85,9999999-$$TCHFMDT^BIUTL5(D))=""
 ;**********
 ;
 ;---> Collect Hep B CVX's.
 I $D(^BIVARR("HEP B",A)) S BIFLU(45,9999999-$$TCHFMDT^BIUTL5(D))=""
 ;
 ;---> Collect Hep A CVX's.
 I $D(^BIVARR("HEP A",A)) S BIFLU(85,9999999-$$TCHFMDT^BIUTL5(D))=""
 ;
 ;---> Save any Pneumo's
 I IGRP=11 S BIFLU(A,9999999-$$TCHFMDT^BIUTL5(D))="" Q
 ;
 ;---> Add save of any RZV's
 I IGRP=20 S BIFLU(A,9999999-$$TCHFMDT^BIUTL5(D))="" Q
 ;
 ;---> Add save of any COVID's
 I IGRP=21 S BIFLU(A,9999999-$$TCHFMDT^BIUTL5(D))="" Q
 ;
 ;---> Save any RSV's
 I IGRP=24 S BIFLU(A,9999999-$$TCHFMDT^BIUTL5(D))="" Q
 ;
 ;********** PATCH 26, v8.5, JAN 31, 2023, IHS/CMI/LAB
 ;---> Add save of any MEN B.
 ;I A=162!(A=163) D
 ;I A=162!(A=163)!(A=316) D
 I $D(^BIVARR("MEN-B",A)) S BIFLU(A,9999999-$$TCHFMDT^BIUTL5(D))=""
 ;
 Q
 ;=====
 ;
 ;=====
 ;
COVID ;---> No Immunocompromised for under 12 years.
 ;
 N BIRISKC
 D RISKC^BIDX(BIDFN,BIFDT,,.BIRISKC)
 Q:'BIRISKC
 S BIRPROF(+$$BIRPROF^BIPATUP3(213))=1
 ;
 ;---> Quit if ICE already forecast COVID.
 ;
 Q:(BITCHAF[4)
 ;---> Quit if patient has received any COVID other than Mod or Pfz.
 N BILD,BILAST,COV,TOT
 ;BILD   = COV DATE
 ;BILAST = LAST COV DATE
 S (BILD,BILAST,TOT)=""
 S COV=0
 F  S COV=$O(BIFLU(COV)) Q:'COV  D:$D(^BIVARR("COV",COV))
 .S BIL=0
 .F  S BIL=$O(BIFLU(COV,BIL)) Q:'BIL  D
 ..S TOT=TOT+1
 ..S BILD=9999999-BIL
 ..S:BILD>BILAST BILAST=BILD
 I $G(TOT)>1 S BIRISKC=0 Q
 S:TOT<2 BIRISKC=1
 ;
 Q:'BIRISKC
 ;
 S BIRPROF(+$$BIRPROF^BIPATUP3(213))=1
 ;---> Determine which to forecast, Mod or Pfr.
 S BICVX=213
 ;
 ;---> Set COVID High Risk if needed.
 D IHSCOV^BIPATUP3(BIDFN,.BINF,BIFDT,BICVX,.BIADDND)
 Q
 ;=====
 ;
RSV(BIDFN) ;V8.5 PATCH 29 - FID-106351 CHECK RSV
 N X,Y,DOB,IEN,I0,X1,X2,RSVDT,QUIT,IMM,V0,VDT,CVX
 S VDT=""
 S IEN=9999999999
 F  S IEN=$O(^AUPNVIMM("AC",BIDFN,IEN),-1) Q:'IEN!VDT  D
 .S I0=$G(^AUPNVIMM(IEN,0))
 .S IDA=+I0
 .S IMM=$G(^AUTTIMM(IDA,0))
 .S CVX=$P(IMM,U,3)
 .Q:IMM'["RSV"
 .S V=$P(I0,U,3)
 .S V0=$G(^AUPNVSIT(V,0))
 .S VDT=$P($P(V0,U),".")
 Q:VDT
 S CVX=$O(^BIVARR("RSV","NOS",0))
 Q:'CVX
 D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(CVX)_U_BIFDT)
 S BIADDND=$G(BIADDND)_" | RSV          Added for High Risk|||"
 N NOS
 S NOS=0
 S NOS=0
 F  S NOS=$O(^BIVARR("RSV","NOS",NOS)) Q:'NOS  D
 .S BIRPROF(+$$BIRPROF^BIPATUP3(NOS))=1
 Q
 ;=====
 ;
MENB ;V8.5 PATCH 29 - FID-106359 MEN B
 ;
 ;---> * * * FORECAST FIRST MEN B IF 16-23 YRS AND NEVER HAD MEN B * * *
 ;
 ;---> Quit if MEN-B already forecast by ICE
 ;
 ;---> Quit if MEN-B CVX already in the history
 N MENB,QUIT
 S QUIT=0
 S MENB=0
 F  S MENB=$O(^BIVARR("MEN-B",MENB)) Q:'MENB!QUIT  S:$D(BIFLU(MENB)) QUIT=1
 Q:QUIT
 ;
 ;CHECK FOR EXISTING MEN B FOR THE PATIENT
 N X,Y,CVX,I0,V0,MENB
 S MENB=0
 S X=0
 F  S X=$O(^AUPNVIMM("AC",BIDFN,X)) Q:'X  S I0=$G(^AUPNVIMM(X,0)) D:I0
 .S IMM=+I0
 .S CVX=+$P($G(^AUTTIMM(IMM,0)),U,3)
 .S:$D(^BIVARR("MEN-B",CVX)) MENB=1
 Q:MENB
 ;
 S CVX=$O(^BIVARR("MEN-B","NOS",0))
 Q:'CVX
 S BIRPROF(+$$BIRPROF^BIPATUP3(CVX))=1
 ;
 Q:(BITCHAF[5)
 ;
 D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(CVX)_U_BIFDT)
 S BIADDND=$G(BIADDND)_" | MEN B        Added for High Risk|||"
 Q
 ;=====
 ;
RSV819(BIDFN) ;
 N X,Y,DOB,IEN,I0,X1,X2,RSVDT,QUIT,IM0,V0,VDT,CVX
 S VDT=""
 S IEN=9999999999
 F  S IEN=$O(^AUPNVIMM("AC",BIDFN,IEN),-1) Q:'IEN!VDT  D
 .S I0=$G(^AUPNVIMM(IEN,0))
 .S IDA=+I0
 .S IM0=$G(^AUTTIMM(IDA,0))
 .S CVX=$P(IM0,U,3)
 .Q:CVX'=307
 .S V=$P(I0,U,3)
 .S V0=$G(^AUPNVSIT(V,0))
 .S VDT=$P($P(V0,U),".")
 Q:VDT
 S CVX=315
 D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(CVX)_U_BIFDT)
 S BIADDND=$G(BIADDND)_" | RSV          Added for High Risk|||"
 S BIRPROF(+$$BIRPROF^BIPATUP3(315))=1
 Q
 ;=====
 ;
 ;V8.5 P31 FID-98855 
 ;DETERMINE IF PT NEEDS RZV
 ;
RZV(BIDFN,BIYRS,BIFLU,BIRISKF,BITYP) ;EP; EVALUATE CURRENT RZV STATUS
 ;BIDFN   = (REQ) PATIENT DFN
 ;BIYRS   = PATIENT AGE IN YRS
 ;BIFLU   = ARRAY of imm history
 ;BIRISKF = (Ret)
 ;          1 at risk
 ;          0 no risk
 ;BITYP   = (OPT)
 ;          D = ADD TO DUE LIST
 ;          R = SET REPORT CATEGORY TO DUE
 ;
 S BIRISKF=0
 S:$G(BITYP)="" BITYP="D"
 ;
 ;EVAL 1
 ;Age check, not at risk <19 or >49 yrs
 Q:(BIYRS<19)!(BIYRS>49)
 ;
 ;EVAL 2
 ;Quit if more than 1 RZV and >27 DAYS apart
 Q:$$RZVCOMP(BIDFN)
 ;
 ;Eval 3
 ;---> Check if Immune Compromised and RZV risk
 ;BIRISKF=1 if compromised
 D RISKRZV^BIDX2(BIDFN,BIFDT,BIYRS,.BIRISKF)
 Q:'$G(BIRISKF)
 ;
 ;---> Set Early Forecast or High Risk if needed.
 S BIRPROF(87)=1
 ;
 ;If RZV alread in patient due list, don't add again
 ;
 Q:$$RZVAD(BIDFN)
 ;
 D:BITYP="D"  ;setdue if for due list skip if for report eval
 .S CVX=187
 .D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(CVX)_U_BIFDT)
 .S BIADDND=$G(BIADDND)_" | RecombZV     Added for "_$S($G(BIRISKF):"High Risk",1:"Age")_"|||"
 .S BIRPROF(+$$BIRPROF^BIPATUP3(187))=1
 Q
 ;=====
 ;
RZVAD(BIDFN) ;EP;RZV already on patient due list
 ;0 = RZV on due list, so not due
 ;1 = RZV not on due list, so due for RZV
 ;
 N AD,AD0,X
 S AD=0
 S X=0
 F  S X=$O(^BIPDUE("B",BIDFN,X)) Q:'X!AD  D
 .S AD0=$G(^BIPDUE(X,0))
 .S:$P(AD0,U,2)=291 AD=1
 Q AD
 ;=====
 ;
RZVCOMP(BIDFN) ;EP;Eval Patient RZV's status
 ;1  = RZV's complete
 ;0  = RZV's due
 N BICOMP,RZV,CNT,IEN,I0,IDA,VDA,V0,D1,D2,X1,X2
 K RZVLAST
 S BICOMP=0
 S CNT=0
 S IEN=0
 F  S IEN=$O(^AUPNVIMM("AC",BIDFN,IEN)) Q:'IEN  D
 .S I0=$G(^AUPNVIMM(IEN,0))
 .S IDA=+I0
 .S VDA=+$P(I0,U,3)
 .S V0=$G(^AUPNVSIT(VDA,0))
 .S CVX=$P($G(^AUTTIMM(IDA,0)),U,3)
 .Q:'CVX
 .Q:'$D(^BIVARR("ZOS",CVX))
 .S IDT=$P($P(V0,U),".")
 .S CNT=CNT+1
 .S RZV(IDT)=""
 .S RZVLAST(IDT)=""
 I CNT=1 D
 .S X2=$O(RZV(0))
 .S X1=BIFDT
 .D ^%DTC
 .I X<28 S BICOMP=1
 I CNT>1 D
 .S D1=$O(RZV(0))
 .S D2=$O(RZV(9999999999),-1)
 .Q:'D1!'D2
 .S X1=D1,X2=+27
 .D C^%DTC
 .I X<D2 S BICOMP=1
 S RZVLAST=$O(RZVLAST(9999999999),-1)
 ;If pt had 2 RZV's greater than 4 wks apart doesn't need another RZV
 Q BICOMP_U_RZVLAST
 ;=====
 ;
