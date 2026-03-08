BIREPC4 ;IHS/CMI/MWR - REPORT, COVID IMM; OCT 15,2010 ; 18 Jan 2022  2:32 PM
 ;;8.5;IMMUNIZATION;**24,26**;OCT 24,2011;Build 33
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  COVID IMM REPORT, GATHER/STORE PATIENTS.
 ;
 ;
 ;----------
GETPATS(BIBEGDT,BIENDDT,BIAGRP,BICC,BIHCF,BICM,BIBEN,BIQDT,BIUP) ;EP
 ;---> Get patients from VA PATIENT File, ^DPT(.
 ;---> Parameters:
 ;     1 - BIBEGDT (req) Begin DOB for this group.
 ;     2 - BIENDDT (req) End DOB for this group.
 ;     3 - BIAGRP  (req) Node/number for this Age Group.
 ;     4 - BICC    (req) Current Community array.
 ;     5 - BIHCF   (req) Health Care Facility array.
 ;     6 - BICM    (req) Case Manager array.
 ;     7 - BIBEN   (req) Beneficiary Type array.
 ;     8 - BIQDT   (req) Quarter Ending Date.
 ;     9 - BIUP    (req) User Population/Group (Registered, Imm, User, Active).
 ;
 ;---> Set begin and end dates for search through PATIENT File.
 ;
 Q:'$G(BIBEGDT)  Q:'$G(BIENDDT)  Q:'$G(BIAGRP)  ;Q:'$G(BIYEAR)
 ;---> Start 1 day prior to Begin Date and $O into the desired DOB's.
 N N S N=BIBEGDT-1
 F  S N=$O(^DPT("ADOB",N)) Q:(N>BIENDDT!('N))  D
 .S BIDFN=0
 .F  S BIDFN=$O(^DPT("ADOB",N,BIDFN)) Q:'BIDFN  D
 ..D CHKSET(BIDFN,.BICC,.BIHCF,.BICM,.BIBEN,BIAGRP,BIQDT,BIUP)
 Q
 ;
 ;
 ;----------
CHKSET(BIDFN,BICC,BIHCF,BICM,BIBEN,BIAGRP,BIQDT,BIUP) ;EP
 ;---> Check if this patient fits criteria; if so, set DFN
 ;---> in ^TMP("BIREPC1".
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient IEN.
 ;     2 - BICC   (req) Current Community array.
 ;     3 - BIHCF  (req) Health Care Facility array.
 ;     4 - BICM   (req) Case Manager array.
 ;     5 - BIBEN  (req) Beneficiary Type array.
 ;     6 - BIAGRP (req) Node/number for this Age Group.
 ;     7 - BIQDT  (req) Quarter Ending Date.
 ;     8 - BIUP   (req) User Population/Group (Registered, Imm, User, Active).
 ;
 Q:'$G(BIDFN)
 Q:'$D(BICC)
 Q:'$D(BIHCF)
 Q:'$D(BICM)
 Q:'$D(BIBEN)
 Q:'$G(BIAGRP)
 Q:'$G(BIQDT)
 Q:$G(BIUP)=""
 ;
 ;---> Quit if patient is not in the Register.
 ;Q:'$D(^BIP(BIDFN,0))
 ;
 ;---> Filter for standard Patient Population parameter.
 Q:'$$PPFILTR^BIREP(BIDFN,.BIHCF,BIQDT,BIUP)
 ;
 ;---> If not selecting "Registered Patients (All)", the quit if patient became
 ;---> Inactive before the Quarter Ending Date.
 I BIUP'="r" N X S X=$$INACT^BIUTL1(BIDFN) I X]"" Q:X<BIQDT
 ;
 ;---> Quit if Current Community doesn't match.
 Q:$$CURCOM^BIEXPRT2(BIDFN,.BICC)
 ;
 ;---> Quit if Case Manager doesn't match.
 Q:$$CMGR^BIDUR(BIDFN,.BICM)
 ;
 ;---> Quit if Beneficiary Type doesn't match.
 Q:$$BENT^BIDUR1(BIDFN,.BIBEN)
 ;
 ;---> Return COVID High Risk Value (1 or 0).
 N BIRISK S BIRISK=0
 D RISKC^BIDX(BIDFN,BIQDT,,.BIRISK)
 ;
 ;---> Return Pregnancy indicator (1 or 0).
 N BIPREG S BIPREG=0
 ;---> Possible call to determine pregnancy.
 ;---> If pregnant at on any date that a COVID vaccine received, SET BIPREG=1.
 ;D RISKPREG^BIDX(BIDFN,BIQDT,,.BIPREG)
 ;
 ;
 ;---> Uncomment next lines to test High Risk and/or Pregnancy.
 ;S:(BIDFN=30) BIRISK=1  ;MWRZZZ
 ;S:(BIDFN=20) BIRISK=1  ;MWRZZZ
 ;S:(BIDFN=60) BIRISK=1  ;MWRZZZ
 ;S:(BIDFN=70) BIRISK=1  ;MWRZZZ
 ;S:(BIDFN=72) BIRISK=1  ;MWRZZZ
 ;S:(BIDFN=80) BIRISK=1  ;MWRZZZ
 ;S:(BIDFN=15) BIRISK=1  ;MWRZZZ
 ;S:(BIDFN=35) BIRISK=1  ;MWRZZZ HIGH RISK & PREG
 ;S:(BIDFN=35) BIPREG=1  ;MWRZZZ HIGH RISK & PREG
 ;S:(BIDFN=25) BIPREG=1  ;MWRZZZ
 ;S:(BIDFN=44) BIPREG=1  ;MWRZZZ
 ;
 ;---> If High Risk: BIRISK=1, if Pregnancy: BIRISK=2, if both: BIRISK=12.
 I BIPREG S BIRISK=BIRISK_2
 ;
 ;---> Store Patient in Age Group for denominators.
 S ^TMP("BIREPC1",$J,"PATS",BIAGRP,BIDFN)=BIRISK
 ;
 ;---> Set patient DEFAULT Value as "NOT CURRENT".
 ;---> For fully immunized below, set BIPCUR=2.
 N BIPCUR S BIPCUR=1
 ;
 ;
 ;---> RPC to gather Immunization History.
 N BI31,BIDE,BIRETVAL,BIRETERR,I S BI31=$C(31)_$C(31),BIRETVAL=""
 ;---> 25=CVX, 55=Vaccine Group IEN, 56=Date of Visit (Fileman), 65=Invalid Dose.
 F I=25,55,56,65 S BIDE(I)=""
 ;---> Fourth parameter=0: Do not return Skin Tests.
 ;---> Fifth parameter=0: Split out combinations as if given individually.
 D IMMHX^BIRPC(.BIRETVAL,BIDFN,.BIDE,0,0)
 ;
 ;---> If BIRETERR has a value, store it and quit.
 S BIRETERR=$P(BIRETVAL,BI31,2)
 Q:BIRETERR]""
 ;
 ;
 ;---> Add Contraindications, if any.
 ;N Z D CONTRA^BIUTL11(BIDFN,.Z,,1,BIQTR) I $O(Z(0)) D
 ;.---> If this is a contraindication is for a COVID vaccine, count it.
 ;.---> Update list of CVX's that count as COVID contraindication.
 N Z,Y,D,N,%
 S Z=0,%=0 F  S Z=$O(^BIPC("B",BIDFN,Z)) Q:Z'=+Z!(%)  D
 .Q:'$D(^BIPC(Z,0))
 .S D=$P(^BIPC(Z,0),U,4)
 .I D>BIQDT Q  ;documented after the quarter
 .S N=$P(^BIPC(Z,0),U,2)
 .Q:$$VAL^XBDIQ1(9999999.14,N,.09)'="COVID"  ;MUST BE COVID VACCINE
 .S %=1 D
 .S BITMP("STATS","Z_CONTRAS",BIAGRP)=$G(BITMP("STATS","Z_CONTRAS",BIAGRP))+1
 ;
 ;---> Add Refusals, if any.
 ;ihs/cmi/lab - commented this out and changed to look at AUPNPREF
 N Z,Y,D,N,%
 S Z=0,%=0 F  S Z=$O(^AUPNPREF("AA",BIDFN,9999999.14,Z)) Q:Z'=+Z!(%)  D
 .S D=0 F  S D=$O(^AUPNPREF("AA",BIDFN,9999999.14,Z,D)) Q:D'=+D!(%)  D
 ..I $$VAL^XBDIQ1(9999999.14,Z,.09)='"COVID" Q
 ..S Y=0 F  S Y=$O(^AUPNPREF("AA",BIDFN,9999999.14,Z,D,Y)) Q:Y'=+Y  D
 ...Q:$$VALI^XBDIQ1(9000022,Y,.03)>BIQDT  ;after quarter
 ...;Q:$$VALI^XBDIQ1(9000022,Y,.07)'="R"  ;refused only
 ...Q:'$$REF^BIUTL13(Y)
 ...S %=1
 ...S BITMP("STATS","Z_REFUSALS",BIAGRP)=$G(BITMP("STATS","Z_REFUSALS",BIAGRP))+1
 ;N Z D CONTRA^BIUTL11(BIDFN,.Z,1) I $O(Z(0)) D
 ;.;---> If this refusal is for a COVID vaccine, count it.
 ;.N N S N=0
 ;.F  S N=$O(Z(N)) Q:'N  I $$HL7TX^BIUTL2(N,1)=21 D  Q
 ;..S BITMP("STATS","Z_REFUSALS",BIAGRP)=$G(BITMP("STATS","Z_REFUSALS",BIAGRP))+1
 ;..;---> Subtract this refusal from the tally of legitimate contraindications.
 ;..I $G(BITMP("STATS","Z_CONTRAS",BIAGRP)) D
 ;...S BITMP("STATS","Z_CONTRAS",BIAGRP)=BITMP("STATS","Z_CONTRAS",BIAGRP)-1
 ;
 ;N Z D PCCREF^BIUTL11(BIDFN,.Z,1) I $O(Z(0)) D
 ;.;---> If this refusal is for a COVID vaccine, count it.
 ;.N N S N=0
 ;.F  S N=$O(Z(N)) Q:'N  I $$HL7TX^BIUTL2(N,1)=21 D  Q
 ;..S BITMP("STATS","Z_REFUSALS",BIAGRP)=$G(BITMP("STATS","Z_REFUSALS",BIAGRP))+1
 ;
 ;---> Gather patient Imm Hx.
 ;---> Set BIHX=to a valid Immunization History.
 N BIHX S BIHX=$P(BIRETVAL,BI31,1)
 ;
 ;---> Build local array BICHX of patient's imm Hx.
 N I,Y
 ;---> Loop through "^"-pieces of Imm History, getting COVID Imm data.
 ;---> Store COVID Hx in BICHX.  Also Data,CVX array in BICHXD.
 N BICHX,BICHXD
 F I=1:1 S Y=$P(BIHX,U,I) Q:Y=""  D
 .;
 .;---> Set this immunization in the STATS array.
 .N BICVX,BIDATE
 .S BICVX=$P(Y,"|",2),BIDATE=$P(Y,"|",4)
 .;
 .;---> Quit if this is not a COVID vaccine.
 .Q:($P(Y,"|",3)'=21)
 .;
 .;---> Quit if this dose is marked INVALID.
 .I $P(Y,"|",5),$P(Y,"|",5)<9 Q
 .;
 .;---> Quit (don't count) if Visit was AFTER the Quarter Ending Date.
 .Q:(BIDATE>BIQDT)
 .;
 .;---> Store this COVID vaccine in local array.
 .S BICHX(BICVX)=$G(BICHX(BICVX))+1
 .;
 .;---> Build Date,CVX array to determine if Janssen was the first dose.
 .S BICHXD(BIDATE,BICVX)=""
 ;
 ;---> If Janssen is the chronological first dose, then full series=1, otherwise=2.
 N BISER S BISER=2
 S Y=$O(BICHXD(0)) I Y I $O(BICHXD(Y,0))=212 S BISER=1
 ;
 ;--- Get maximum Dose#.
 N BIMAX,M,N S M=0,N=0
 F  S N=$O(BICHX(N)) Q:'N  S M=M+BICHX(N)
 S BIMAX=+M
 ;
 ;---> BICAT(EGORY) 0=None, 1=High Risk, 2=Pregnancy, 12=High Risk and Pregnancy.
 ;---> BISER 0=Unvaccinated, 1=J&J, 2=All other, 3=Additional (HR) ,4=Booster
 ;---> BIDOSE=Dose#
 ;---> BIAGRP=Age Group
 ;
 D
 .;---> If Unvaccinated, set stats and quit.
 .I BIMAX=0 D  Q
 ..D SET(0,0,BIAGRP,BIRISK)
 .;
 .;---> BIMAX must be >0.
 .;
 .;---> If Janssen 1-dose Series.
 .I BISER=1 D  Q
 ..;---> If 1 dose of Janssen, set as "Complete 1-dose-series".
 ..D SET(1,1,BIAGRP,BIRISK)
 ..;---> Store patient as "CURRENT".
 ..S BIPCUR=2
 ..;
 ..;---> If >1 doses of Janssen, set as Additional (HR) and/or Booster.
 ..I BIMAX>1 D  Q
 ...D SET(1,BIMAX,BIAGRP,BIRISK)
 .;
 .;---> If Mod/Pfr 2-dose Series.
 .I BISER=2 D  Q
 ..;---> Set first Mod/Pfr dose.
 ..D SET(2,1,BIAGRP,BIRISK)
 ..;
 ..;---> If 2 or more doses of Mod/Pfr, set 2nd dose.
 ..I BIMAX>1 D
 ...D SET(2,2,BIAGRP,BIRISK)
 ...;---> Store patient as "CURRENT".
 ...S BIPCUR=2
 ..;
 ..;---> If 2 or more doses of Mod/Pfr, set as Additional (HR) or Booster.
 ..I BIMAX>2 D
 ...D SET(2,BIMAX,BIAGRP,BIRISK)
 ;
 ;
 ;---> X=1 is NOT Current; X=2 IS Current (fully immunized).
 D STOR(BIDFN,BIQDT,$G(BIPCUR))
 Q
 ;
 ;
SET(BISER,BIDOSE,BIAGRP,BIRISK) ;EP
 ;---> Set local array of Stats.
 ;---> Parameters:
 ;     1 - BISER  (req) BISER 0=Unvaccinated, 1=J&J, 2=All other,
 ;                      3=Additional(High Risk) ,4=Booster
 ;     2 - BIDOSE (req) Dose
 ;     3 - BIAGRP (req) Age Group
 ;     4 - BIRISK (req) If High Risk: BIRISK=1, if Pregnancy: BIRISK=2, if both: BIRISK=12.
 ;
 ;---> Category node (0=Total, 1=High Risk, 7=Pregnancy).
 ;
 I BIDOSE'>BISER D  Q
 .;---> Total Population, Category=0.
 .D SET1(0,BISER,BIDOSE,BIAGRP)
 .;
 .;---> If High Risk Population, Category=1.
 .I BIRISK[1 D SET1(1,BISER,BIDOSE,BIAGRP)
 .;
 .;---> If Prenancy Population, Category=7.
 .I BIRISK[2 D SET1(7,BISER,BIDOSE,1)
 ;
 ;
 ;---> BIDOSE>BISER: evaluate whether this is an Additional or a Booster.
 ;
 ;---> If NOT High Risk, this must be a Booster for General Population.
 I BIRISK'[1 D  Q
 .D SET1(0,4,1,BIAGRP)
 .;---> Pregnancy.
 .I BIRISK[2 D SET1(7,4,1,1)
 ;
 ;---> If this IS High Risk and BIDOSE>BISER, then this is an Additional Dose
 ;---> for High Risk.
 I BIDOSE>BISER D
 .D SET1(1,3,1,BIAGRP)
 .;---> Pregnancy.
 .I BIRISK[2 D SET1(7,3,1,1)
 ;
 ;---> If this IS High Risk and BIDOSE>BISER+1, then this is a High Risk Booster.
 I BIDOSE>(BISER+1) D  Q
 .D SET1(1,4,1,BIAGRP)
 .;---> Also set this Booster for the General Population.
 .D SET1(0,4,1,BIAGRP)
 .;---> Pregnancy.
 .I BIRISK[2 D SET1(7,4,1,1)
 ;
 Q
 ;
 ;
SET1(BICAT,BISER,BIDOSE,BIAGRP) ;EP
 ;---> Set local array of Stats.
 N Z S Z=$G(BITMP("STATS",BICAT,BISER,BIDOSE,BIAGRP))
 S BITMP("STATS",BICAT,BISER,BIDOSE,BIAGRP)=Z+1
 Q
 ;
 ;
 ;----------
STOR(BIDFN,BIQDT,BIVAL) ;EP
 ;---> Store in ^TMP for displaying List of Patients.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient IEN.
 ;     2 - BIQDT  (req) Quarter Ending Date.
 ;     3 - BIVAL  (opt) Value to set ^TMP(Pat...) node equal to.
 ;
 Q:'$G(BIDFN)  S:'$G(BIQDT) BIQDT=DT
 ;D UPDATE^BIPATUP(BIDFN,DT,,1)
 D STORE^BIDUR1(BIDFN,BIQDT,1,,$G(BIVAL))
 Q
