BIREPD2 ;IHS/CMI/MWR - REPORT, ADOLESCENT RATES; DEC 15, 2011
 ;;8.5;IMMUNIZATION;**17,31**;OCT 24,2011;Build 137
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW ADOLESCENT IMMUNIZATION RATES REPORT, GATHER DATA.
 ;   PATCH 1: Clarify Report explanation.  START+121
 ;;  PATCH 3: Include new "1-Td 1-Men 3-HPV" lines. START+69
 ;;  PATCH 5: Return Patient Totals for queued reports.  START+0
 ;;  PATCH 17: Extensive changes to enhance Adol HPV & Tdap Reporting. START+60
 ;
 ;
 ;----------
HEAD(BIQDT,BIDAR,BIAGRPS,BICC,BIHCF,BICM,BIBEN,BIUP) ;EP - Header for Adolescent Report.
 ;---> Produce Header array for Adolescent Report.
 ;---> Parameters:
 ;     1 - BIQDT   (req) Quarter Ending Date.
 ;     2 - BIDAR   (req) Adolescent Report Age Range: "11-18^1" (years).
 ;     3 - BIAGRPS (req) String of Age Groups ("1112,1313,1317").
 ;     4 - BICC    (req) Current Community array.
 ;     5 - BIHCF   (req) Health Care Facility array.
 ;     6 - BICM    (req) Case Manager array.
 ;     7 - BIBEN   (req) Beneficiary Type array.
 ;     8 - BIUP    (req) User Population/Group (Registered, Imm, User, Active).
 ;
 ;---> Check for required Variables.
 Q:'$G(BIQDT)
 Q:'$D(BICC)
 Q:'$D(BIHCF)
 Q:'$D(BICM)
 Q:'$D(BIBEN)
 Q:'$D(BIDAR)
 Q:'$G(BIAGRPS)
 Q:'$D(BIUP)
 ;
 K VALMHDR
 N BILINE,X,Y S BILINE=0
 ;
 S X=""
 ;---> If Header array is NOT being for Listmananger include version.
 S:'$D(VALM("BM")) X=$$LMVER^BILOGO()
 ;
 I BISPD'="CSV" D WH^BIW(.BILINE,X)
 S X=$$REPHDR^BIUTL6(DUZ(2)) I BISPD'="CSV" D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 ;
 S X="*  Adolescent Immunization Report (11-17 yrs)  *" I BISPD'="CSV" D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 ;
 S:BISPD'="CSV" X=$$SP^BIUTL5(27)_"Report Date: "_$$SLDT1^BIUTL5(DT) S:BISPD="CSV" X="Report Date: "_$$SLDT1^BIUTL5(DT)
 D WH^BIW(.BILINE,X,$S(BISPD="CSV":"",1:1))
 ;
 S:BISPD'="CSV" X=$$SP^BIUTL5(30)_"End Date: "_$$SLDT1^BIUTL5(BIQDT) S:BISPD="CSV" X="End Date: "_$$SLDT1^BIUTL5(BIQDT)
 D WH^BIW(.BILINE,X,$S(BISPD="CSV":"",1:1))
 ;
 S X=" "_$$BIUPTX^BIUTL6(BIUP)
 I BIUP="i" S X=" "_$$BIUPTX^BIUTL6(BIUP,1)_" (Active)"
 I BISPD'="CSV" S X=$$PAD^BIUTL5(X,34)
 ;
 I BISPD'="CSV" D
 .S Y="Total Patients: "_$G(BITOTPTS)_"  (F:"_$G(BITOTFPT)_"  M:"_$G(BITOTMPT)_")"
 .S X=X_$J(Y,45)
 I BISPD="CSV" D
 .D WH^BIW(.BILINE,X)
 .S X="Total Patients: "_$G(BITOTPTS) D WH^BIW(.BILINE,X)
 .S X="Females: "_$G(BITOTFPT) D WH^BIW(.BILINE,X)
 .S X="Males: "_$G(BITOTMPT)
 D WH^BIW(.BILINE,X)
 I BISPD'="CSV" S X=$$SP^BIUTL5(79,"-") D WH^BIW(.BILINE,X)
 ;
 D
 .;---> If specific Communities were selected (not ALL), then print
 .;---> the Communities in a subheader at the top of the report.
 .D SUBH^BIOUTPT5("BICC","Community",,"^AUTTCOM(",.BILINE,.BIERR,,12)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 .;
 .;---> If specific Health Care Facilities, print subheader.
 .D SUBH^BIOUTPT5("BIHCF","Facility",,"^DIC(4,",.BILINE,.BIERR,,12)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 .;
 .;---> If specific Case Managers, print Case Manager subheader.
 .D SUBH^BIOUTPT5("BICM","Case Manager",,"^VA(200,",.BILINE,.BIERR,,12)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 .;
 .;---> If specific Beneficiary Types, print Beneficiary Type subheader.
 .D SUBH^BIOUTPT5("BIBEN","Beneficiary Type",,"^AUTTBEN(",.BILINE,.BIERR,,12)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 .;;---> Write Denominators subhead.
 .N I F I=1,3 D WH^BIW(.BILINE,$$HEAD2(I))
 ;
 ;---> If Header array is being built for Listmananger,
 ;---> reset display window margins for Communities, etc.
 D:$D(VALM("BM"))
 .S VALM("TM")=BILINE+3
 .S VALM("LINES")=VALM("BM")-VALM("TM")+1
 .;---> Safeguard to prevent divide/0 error.
 .S:VALM("LINES")<1 VALM("LINES")=1
 Q
 ;
 ;
HEAD2(L) ;EP
 ;---> Set text and totals for Age Group Denominators subheader.
 ;---> Parameters:
 ;     1 - L    (req) Line number below to return.
 I BISPD="CSV" G HEAD2CSV
 Q:(L=1) "  Age Group      |       11-12yrs      13yrs       13-17yrs"
 Q:(L=2) " Female + Male   |       11-12yrs      13yrs       13-17yrs"
 Q:(L'=3) "MISSING HEADER."
 N X S X="  Denominators   |     "_$J($G(BITOTPTS(1112)),7)_"      "
 S X=X_$J($G(BITOTPTS(1313)),7)_"      "_$J($G(BITOTPTS(1317)),7)
 Q X
 ;
HEAD2CSV ;
 Q:(L=1) ",11-12yrs,13yrs,13-17yrs"
 Q:(L=2) "Female + Male Denominators,11-12yrs,13yrs,13-17yrs"
 Q:(L'=3) "MISSING HEADER."
 N X S X="Age Group Denominators,"_+$G(BITOTPTS(1112))_","_+$G(BITOTPTS(1313))_","_+$G(BITOTPTS(1317))
 Q X
 ;----------
START(BIQDT,BIDAR,BIAGRPS,BICC,BIHCF,BICM,BIBEN,BISITE,BIUP,BITOTPTS,BITOTFPT,BITOTMPT) ;EP
 ;---> Produce array for Report.
 ;---> Parameters:
 ;     1 - BIQDT    (req) Quarter Ending Date.
 ;     2 - BIDAR    (opt) Adolescent Report Age Range: "11-18^1" (years).
 ;     3 - BIAGRPS  (req) String of Age Groups ("1112,1313,1317").
 ;     4 - BICC     (req) Current Community array.
 ;     5 - BIHCF    (req) Health Care Facility array.
 ;     6 - BICM     (req) Case Manager array.
 ;     7 - BIBEN    (req) Beneficiary Type array.
 ;     8 - BISITE   (req) Site IEN.
 ;     9 - BIUP     (req) User Population/Group (All, Imm, User, Active).
 ;    10 - BITOTPTS (ret) Total Patients.
 ;    11 - BITOTFPT (ret) Total Female Patients.
 ;    12 - BITOTMPT (ret) Total Male Patients.
 ;
 K ^TMP("BIREPD1",$J)
 N BILINE,BITMP,X S BILINE=0
 ;
 ;---> Check for required Variables.
 I '$G(BIQDT) D ERRCD^BIUTL2(623,.X) D WRITE^BIREPD3(.BILINE,X) Q
 I '$D(BIDAR)  D ERRCD^BIUTL2(613,.X) D WRITE^BIREPD3(.BILINE,X) Q
 I '$G(BIAGRPS) D ERRCD^BIUTL2(677,.X) D WRITE^BIREPD3(.BILINE,X) Q
 I '$D(BICC) D ERRCD^BIUTL2(614,.X) D WRITE^BIREPD3(.BILINE,X) Q
 I '$D(BIHCF) D ERRCD^BIUTL2(625,.X) D WRITE^BIREPD3(.BILINE,X) Q
 I '$D(BICM) D ERRCD^BIUTL2(615,.X) D WRITE^BIREPD3(.BILINE,X) Q
 I '$D(BIBEN)  D ERRCD^BIUTL2(662,.X) D WRITE^BIREPD3(.BILINE,X) Q
 I '$G(BISITE) S BISITE=$G(DUZ(2))
 I '$G(BISITE) D ERRCD^BIUTL2(109,.X) D WRITE^BIREPD3(.BILINE,X) Q
 S:$G(BIUP)="" BIUP="u"
 ;
 ;---> Gather data.
 D GETDATA^BIREPD3(.BICC,.BIHCF,.BICM,.BIBEN,BIQDT,BIDAR,BIAGRPS,BISITE,BIUP,.BITMP,.BIERR)
 I $G(BIERR)]"" D WRITE^BIREPD3(.BILINE,BIERR) Q
 ;
 ;
 ;---> BITOTPTS variables (total patients) not newed here because they are
 ;---> also used in the Report Header.
 ;---> Total.
 S BITOTPTS=+$G(BITMP("STATS","TOTLPTS"))
 S BITOTPTS(1112)=+$G(BITMP("STATS","TOTLPTS",1112))
 S BITOTPTS(1313)=+$G(BITMP("STATS","TOTLPTS",1313))
 S BITOTPTS(1317)=+$G(BITMP("STATS","TOTLPTS",1317))
 ;---> Females.
 S BITOTFPT=+$G(BITMP("STATS","TOTLFPTS"))
 S BITOTFPT(1112)=+$G(BITMP("STATS","TOTLFPTS",1112))
 S BITOTFPT(1313)=+$G(BITMP("STATS","TOTLFPTS",1313))
 S BITOTFPT(1317)=+$G(BITMP("STATS","TOTLFPTS",1317))
 ;---> Males.
 S BITOTMPT=+$G(BITMP("STATS","TOTLMPTS"))
 S BITOTMPT(1112)=+$G(BITMP("STATS","TOTLMPTS",1112))
 S BITOTMPT(1313)=+$G(BITMP("STATS","TOTLMPTS",1313))
 S BITOTMPT(1317)=+$G(BITMP("STATS","TOTLMPTS",1317))
 ;
 ;
 ;---> VACCINE GROUPS
 ;---> Write Statistics lines for each Vaccine Group (BIVGRP).
 ;---> NOTE: 132 is specific for Var-Hx of Chickenpox.
 ;--->       221 is for the specific vaccine Tdap.
 ;
 ;********** PATCH 17, v8.5, MAR 01,2019, IHS/CMI/MWR
 ;---> Don't write special Tdap line; all Td's filtered for Tdap only.
 ;F BIVGRP=4,6,7,132,221,8,9,16,10 D VGRP^BIREPD3(.BILINE,BIVGRP,BIAGRPS,.BITMP,,.BIERR)
 F BIVGRP=4,6,7,132,8,9,16,10 D VGRP^BIREPD3(.BILINE,BIVGRP,BIAGRPS,.BITMP,,.BIERR)
 I $G(BIERR)]"" D WRITE^BIREPD3(.BILINE,BIERR) Q
 ;
 ;
 ;---> VACCINE COMBINATIONS
 ;---> Write Statistics lines for each Vaccine Combinations.
 ;---> NOTE: These Combo strings are also used to set BITMP("STATS"
 ;---> nodes beginning at +130^BIREPD4.
 ;
 D VCOMB^BIREPD3(.BILINE,"8|1^4|3^6|2^7|1",BIAGRPS,.BITMP,,.BIERR)
 D VCOMB^BIREPD3(.BILINE,"8|1^4|3^6|2^16|1^7|2",BIAGRPS,.BITMP,,.BIERR)
 D VCOMB^BIREPD3(.BILINE,"8|1^16|1",BIAGRPS,.BITMP,,.BIERR)
 ;
 ;********** PATCH 3, v8.5, SEP 10,2012, IHS/CMI/MWR
 ;---> Include new "1-Td 1-Men 3-HPV" line for both sexes.
 D VCOMB^BIREPD3(.BILINE,"8|1^16|1^17|3",BIAGRPS,.BITMP,"B",.BIERR)
 ;**********
 ;
 ;
 ;********** PATCH 17, v8.5, MAR 01,2019, IHS/CMI/MWR
 ;---> Extensive changes below and in BIREPD3 and BIREPD4 in order to write
 ;---> Female and Male HPV stats for Fully Vac'd with 2 doses, 3 doses and combined.
 ;
 ;---> * * * Now HPV stats. * * *
 ;
 ;---> FEMALES * * *
 ;---> Break to write FEMALE Denominators subheader.
 D DENOMS(.BILINE,.BITOTFPT,1)
 ;
 ;---> Write Female Statistics lines for HPV Vaccine Group (BIVGRP=17-HPV).
 D VGRP^BIREPD3(.BILINE,17,BIAGRPS,.BITMP,"F",.BIERR)
 I $G(BIERR)]"" D WRITE^BIREPD3(.BILINE,BIERR) Q
 ;
 ;---> Next write Fully Vac'd lines.
 D
 .N BII F BII="F2","F3","F5" Q:($G(BIERR)]"")  D
 ..D VGRP^BIREPD3(.BILINE,17,BIAGRPS,.BITMP,BII,.BIERR)
 I $G(BIERR)]"" D WRITE^BIREPD3(.BILINE,BIERR) Q
 ;
 ;---> Now write FEMALE combos.
 ;
 ;********** PATCH 3, v8.5, SEP 10,2012, IHS/CMI/MWR
 ;---> Add "1-Td 1-Men 3-HPV" combo line for females.
 D VCOMB^BIREPD3(.BILINE,"8|1^16|1^17|3",BIAGRPS,.BITMP,"F",.BIERR)
 D VCOMB^BIREPD3(.BILINE,"8|1^4|3^6|2^16|1^7|2^17|3",BIAGRPS,.BITMP,"F",.BIERR)
 ;
 ;
 ;---> MALES * * *
 ;---> Break to write MALE Denominators subheader.
 D DENOMS(.BILINE,.BITOTMPT,0)
 ;
 ;---> Write Male Statistics lines for HPV Vaccine Group (BIVGRP=17-HPV).
 D VGRP^BIREPD3(.BILINE,17,BIAGRPS,.BITMP,"M",.BIERR)
 I $G(BIERR)]"" D WRITE^BIREPD3(.BILINE,BIERR) Q
 ;---> Next write Fully Vac'd lines.
 D
 .N BII F BII="M2","M3","M5" Q:($G(BIERR)]"")  D
 ..D VGRP^BIREPD3(.BILINE,17,BIAGRPS,.BITMP,BII,.BIERR)
 I $G(BIERR)]"" D WRITE^BIREPD3(.BILINE,BIERR) Q
 ;
 ;---> Now write MALE combos.
 ;
 ;********** PATCH 3, v8.5, SEP 10,2012, IHS/CMI/MWR
 ;---> Add "1-Td 1-Men 3-HPV" combo line for males.
 D VCOMB^BIREPD3(.BILINE,"8|1^16|1^17|3",BIAGRPS,.BITMP,"M",.BIERR)
 D VCOMB^BIREPD3(.BILINE,"8|1^4|3^6|2^16|1^7|2^17|3",BIAGRPS,.BITMP,"M",.BIERR)
 ;*******
 ;
 ;---> BOTH FEMALES + MALES * * *
 ;---> Now write HPV Fully Vac'd Totals for Female + Male combined.
 ;---> Rewrite the denominators for both Female + Male.
 I BISPD="CSV" S X=" " D WRITE^BIREPD3(.BILINE,X) D WRITE^BIREPD3(.BILINE,X)
 N I F I=2,3 D WRITE^BIREPD3(.BILINE,$$HEAD2(I))
 I BISPD'="CSV" D WRITE^BIREPD3(.BILINE,"                "_$$SP^BIUTL5(63,"-"))
 ;
 ;
 ;---> Write Female + Male Statistics lines for HPV Vaccine Group by dose.
 D VGRP^BIREPD3(.BILINE,17,BIAGRPS,.BITMP,"S",.BIERR)
 I $G(BIERR)]"" D WRITE^BIREPD3(.BILINE,BIERR) Q
 ;
 ;
 ;---> Next write Fully Vac'd lines for both Females + Males.
 D
 .N BII F BII="B2","B3","B5" Q:($G(BIERR)]"")  D
 ..D VGRP^BIREPD3(.BILINE,17,BIAGRPS,.BITMP,BII,.BIERR)
 ;
 ;
 I $G(BIERR)]"" D WRITE^BIREPD3(.BILINE,BIERR) Q
 ;
 ;---> Finish off report with totals lines at the bottom.
 I BISPD="CSV" D
 .S X=" " D WRITE^BIREPD3(.BILINE,X)
 .S X="Total Patients reviewed: ,"_BITOTPTS D WRITE^BIREPD3(.BILINE,X)
 .S X="Females: ,"_BITOTFPT D WRITE^BIREPD3(.BILINE,X)
 .S X="Males: ,"_BITOTMPT D WRITE^BIREPD3(.BILINE,X)
 I BISPD'="CSV" D
 .S X=" Total Patients reviewed: "_BITOTPTS
 .S X=X_"   Females: "_BITOTFPT_"   Males: "_BITOTMPT
 .D WRITE^BIREPD3(.BILINE,X)
 ;
 ;---> Now write total patients considered who had refusals.
 N M,N S (M,N)=0 F  S M=$O(BITMP("REFUSALS",M)) Q:'M  S N=N+1
 I BISPD'="CSV" S X=" Total Patients reviewed who had Refusals on record: "_N
 I BISPD="CSV" S X="Total Patients reviewed who had Refusals on record: ,"_N
 D WRITE^BIREPD3(.BILINE,X) I BISPD'="CSV" D WRITE^BIREPD3(.BILINE,$$SP^BIUTL5(79,"-"))
 ;
 D
 .I BIUP="r" S X="all Registered Patients who have an active health record." Q
 .I BIUP="i" S X="Immunization Register Patients with a status of Active." Q
 .I BIUP="u" S X="the User Population patients: 1 visit in the past 3 years." Q
 .I BIUP="a" S X="Active Clinical Users: 2 clinical visits in the past 3 years." Q
 ;
 S X=" *Denominators are "_X
 D WRITE^BIREPD3(.BILINE,X)
 ;
 ;********** PATCH 1, v8.5, JAN 03,2012, IHS/CMI/MWR
 ;---> Change text of explanation.
 ;S X=" *All patients (11-17yrs) with 1-Tdap_TD and 1-Mening are considered ""Current."""
 ;D WRITE^BIREPD3(.BILINE,X)
 ;S X=" *Patients 11-12yrs without 1-Tdap_TD and 1-Mening are listed as ""Not Current"""
 ;S X="  in order to support patient recall."
 ;
 Q:BISPD="CSV"
 ;********** PATCH 3, v8.5, SEP 10,2012, IHS/CMI/MWR
 ;---> Update "Current" explanation to include 3-HPV.
 ;S X=" *All patients (11-17yrs) with 1-Tdap_TD and 1-Mening are considered ""Current"";"
 S X=" *All patients (11-17yrs) with 1-Tdap, 1-MEN, 3/2-HPV are considered ""Current"";"
 ;**********
 ;
 D WRITE^BIREPD3(.BILINE,X)
 S X="  otherwise they are listed as ""Not Current"" in order to support patient recall."
 ;
 D WRITE^BIREPD3(.BILINE,X)
 D WRITE^BIREPD3(.BILINE,$$SP^BIUTL5(79,"-"))
 ;
 ;---> Set final VALMCNT (Listman line count).
 S VALMCNT=BILINE
 Q
 ;
 ;
 ;----------
DENOMS(BILINE,BITOTSPT,Z) ;EP
 ;---> Produce Female and Male Denominators subheader.
 ;---> Parameters:
 ;     1 - BILINE   (req) Line number in ^TMP Listman array.
 ;     2 - BITOTSPT (req) By Sex Total Patients-Age Group-Stats array.
 ;     3 - Z        (req) If Z=1, then female; Z=0, then male.
 ;
 ;---> Break to write Female or Male Denominators subheader.
 I BISPD'="CSV" S X=$S(Z:"    Female",1:"    Male  ") S X=X_"       |       11-12yrs      13yrs       13-17yrs"
 I BISPD="CSV" S X=" " D WRITE^BIREPD3(.BILINE,X),WRITE^BIREPD3(.BILINE,X) S X=",11-12yrs,13yrs,13-17yrs"
 D WRITE^BIREPD3(.BILINE,X)
 I BISPD'="CSV" S X="  Denominators   |     "_$J($G(BITOTSPT(1112)),7)_"      " S X=X_$J($G(BITOTSPT(1313)),7)_"      "_$J($G(BITOTSPT(1317)),7)
 I BISPD="CSV" S X=$S(Z:"Female Denominators,",1:"Male Denominators,")_+$G(BITOTSPT(1112))_","_+$G(BITOTSPT(1313))_","_+$G(BITOTSPT(1317))
 D WRITE^BIREPD3(.BILINE,X)
 I BISPD'="CSV" D WRITE^BIREPD3(.BILINE,"                "_$$SP^BIUTL5(63,"-"))
 Q
