BIPATUP ;IHS/CMI/MWR - UPDATE PATIENT FORECAST; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**22,25,26,29,30**;OCT 24,2011;Build 125
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  UPDATE PATIENT FORECAST DATA, IMM PROFILE IN ^BIP(DFN,
 ;;  AND IMM FORECAST IN ^BIPDUE(.
 ;;  PATCH 8: Changes to accommodate new TCH Forecaster  UPDATE+81,+99, LDPROF+18, BIDE+6
 ;;  PATCH 9: Insert patient name and DOB at top of Report Text (for EHR).  LDPROF+28
 ;;           Add DUZ2 so that BIXTCH can retrieve IP address for TCH.
 ;;  PATCH 14: Add IHS Addendum to TCH Report.  UPDATE+118
 ;;  PATCH 18: Changes to for ICE Forecaster.
 ;;  PATCH 19: Add timeout to Patient Lock command. UPDATE+41
 ;
 ;
 ;----------
UPDATE(BIDFN,BIFDT,BIERR,BINOP,BIDUZ2,BIPDSS) ;EP
 ;---> Update Patient Imms Due (in ^BIPDUE) using Immserve Utility.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient IEN.
 ;     2 - BIFDT  (opt) Forecast Date (date used for forecast).
 ;     3 - BIERR  (ret) String returning text of error code.
 ;     4 - BINOP  (opt) If BINOP=1 do not retrieve Imm Profile.
 ;     5 - BIDUZ2 (opt) User's DUZ(2) to indicate Immserve Forecasting
 ;                      Rules in Patient History data string.
 ;     6 - BIPDSS (ret) Returned string of Visit IEN's that are
 ;                      Problem Doses, according to TCH.
 ;
 N BIERRC,BIICE,BITEST
 ;---> Set BITEST here to leave sending and return XML files on the HFS.
 ;S BITEST=1
 S BIERR=""
 ;
 S:'$G(BIDUZ2) BIDUZ2=$G(DUZ(2))
 ;
 ;---> Pull forecaster to use from BI SITE PARAMETER -> 0/""=ICE, 1=TCH
 ;S BIICE='+$P($G(^BISITE(BIDUZ2,0)),U,34)
 S BIICE=1
 ;
 ;---> If Vaccine global (^AUTTIMM) is not standard, set Error Text
 ;---> in patient's Profile global, return Error Text and quit.
 I $D(^BISITE(-1)) D  Q
 .K ^BIP(BIDFN,1)
 .D ERRCD^BIUTL2(503,.BIERR)
 .S ^BIP(BIDFN,1,1,0)=BIERR
 .S ^BIP(BIDFN,1,0)=U_U_1_U_1_U_DT
 ;
 I '$G(BIDFN) D ERRCD^BIUTL2(201,.BIERR) Q
 ;
 ;---> Return 1 if Forecasting is enabled.
 I '$$FORECAS^BIUTL2(BIDUZ2) D ERRCD^BIUTL2(314,.BIERR) Q
 ;
 ;---> If no Forecast Date passed, set it equal to today.
 S:'$G(BIFDT) BIFDT=DT
 ;
 ;---> If BINOP not specified, retrieve and store Imm Profile.
 S:'$G(BINOP) BINOP=0
 ;
 ;
 ;********** PATCH 19, v8.5, JUN 01,2020, IHS/CMI/MWR
 ;---> Add 10-second timeout to lock command.
 ;---> Quit if this patient is Locked (being edited by another user).
 L +^BIP(BIDFN):10 I '$T D ERRCD^BIUTL2(212,.BIERR) Q
 ;**********
 ;
 ;---> Set required variables, kill ^BITMP($J).
 D SETVARS^BIUTL5 K ^BITMP($J)
 ;
 ;---> Set the patient temp global.
 S ^BITMP($J,1,BIDFN)=""
 ;
 ;---> Gather Immunization History for this patient (into ^BITMP) .
 ;---> Parameters:
 ;     1 - BIFMT  (req) Format: 1=ASCII, 2=HL7, 3=IMM/SERVE
 ;     2 - BIDE   (req) Data Elements array (null if HL7)
 ;     3 - BIMM   (req) Array of Imms to be passed to forecasting.
 ;     4 - BIFDT  (opt) Forecast Date (date used to calc Imms due).
 ;     5 - BISKIN (opt) ""=Do not retrieve Skin Tests.
 ;     6 - BIDUZ2 (opt) User's DUZ(2) to indicate Immserve Forecasting
 ;                      Rules in Patient History data string.
 ;     7 - BINF   (opt) Array of Vaccines that should not be forecast.
 ;
 ;
 ;---> Build local array of Vaccines Group IEN's that should not be forecast,
 ;---> according to this site's BI TABLE VACCINE GROUP (SERIES TYPE) File.
 N BINF
 D NOFORC(.BINF)
 ;
 N BIDE
 S BIDE=""
 D BIDE(.BIDE) N BIMM
 S BIMM("ALL")=""
 ;
 ;---> Gather Patient Imm History in ^BITMP.
 ;********** PATCH 18, v8.5, JUL 01,2019, IHS/CMI/MWR
 ;---> Only call BIEXPRT3 for TCH.
 ;---> For now continue to call Imm Hx here for IHSPOST^BIPATUP1
 D HISTORY^BIEXPRT3(3,.BIDE,.BIMM,BIFDT,,BIDUZ2,.BINF)
 ;**********
 ;
 ;---> Retrieve data for this patient from ^BITMP, return in BIHX.
 ;---> Parameters:
 ;     1 - BIEXP    (req) Export: 0=screen, 1=host file, 2=string
 ;     2 - BIFMT    (req) Format: 1=ASCII, 2=HL7, 3=IMM/SERVE
 ;     3 - BIFLNM   (opt) File name
 ;     4 - BIPATH   (opt) BI Path name for host files
 ;     5 - BIHX     (ret) Immunization History in "^"-delimited string
 ;
 N BIHX
 S BIHX=""
 ;********** PATCH 18, v8.5, JUL 01,2019, IHS/CMI/MWR
 ;---> Only call BIEXPRT4 for TCH.
 ;---> For now continue to call Imm Hx here for IHSPOST^BIPATUP1
 D WRITE^BIEXPRT4(2,3,,,.BIHX)
 ;**********
 ;
 ;********** PATCH 18, v8.5, AUG 01,2019, IHS/CMI/MWR
 ;---> Build array of contraindicated CVX Codes for this Patient: BICT(CVX).
 ;---> (Previously at TCHHIST+59^BIEXPRT6 in setting No Forecast fields for TCH.)
 N BICT
 D CONTRA^BIUTL11(BIDFN,.BICT)
 ;**********
 ;
 ;---> Check for precise Date of Birth.
 I 'BIICE N X S X=$P(BIHX,U,8) I ('$E(X,1,4))!('$E(X,5,6))!('$E(X,7,8)) D ERRCD^BIUTL2(215,.BIERR) Q
 ;
 ;---> Use Immunization History (in BIHX) to obtain Immserve Forecast.
 ;---> Parameters:
 ;     1 - BIHX   (req) String contain Patient's Immunization History.
 ;     2 - BIPROF (ret) String returning text version of Report/Profile.
 ;     3 - BIFORC (ret) String returning data version of forecast.
 ;     4 - BIERR  (ret) String returning text of error code.
 ;
 N BIPROF,BIFORC
 S (BIPROF,BIFORC)=""
 ;
 ;---> Call Forcaster to get Forecast and Profile.
 ;
 ;********** PATCH 18, v8.5, JUL 01,2019, IHS/CMI/MWR
 ;---> Call ICE or TCH Forecaster.  TCH to be removed.
 ;---> Leave XML files on HFS.
 D RUN^BIVWXICE(BIDFN,BIFDT,BIDUZ2,.BINF,.BICT,.BIFORC,.BIPROF,,.BIERR)
 ;**********
 ;
 I BIERR]"" D UNLOCK(BIDFN) Q
 ;
 ;---> Load Forecast into BI PATIENT IMMUNIZATIONS DUE File (^BIPDUE).
 ;---> Pass BIHX (history) and BIFDT to check for >65yrs need for Pneumo.
 ;
 ;********** PATCH 14, v8.5, AUG 01,2017, IHS/CMI/MWR
 ;---> Add IHS Addendum to TCH Report.
 N BIADDND
 D LDFORC^BIPATUP1(BIDFN,BIFORC,BIHX,BIFDT,BIDUZ2,.BINF,.BIPDSS,.BIADDND,.BIPROF)
 ;
 D:'BIICE
 .;---> Below preserves some ending character on TCH Report String.
 .N X,Y
 .I $G(BIADDND)="" D  Q
 ..S BIPROF=BIPROF_"|||---------------------------|||No IHS Addendum|||"_$G(Y)
 .S BIPROF=BIPROF_"|||---------------------------|||IHS Addendum: |||"_BIADDND_"|||"_$G(Y)
 ;
 ;**********
 ;
 ;---> Load Report Text into patient WP global (^BIP(DFN,1,).
 D:'BINOP LDPROF(BIDFN,BIPROF)
 ;
 ;---> Unlock patient.
 D UNLOCK(BIDFN)
 Q
 ;
 ;
 ;----------
LDPROF(BIDFN,BIPROF,BIERR) ;EP
 ;---> Entry point to load Immserve Profile into Patient's global.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient IEN.
 ;     2 - BIPROF (req) String containing text of Patient's Imm Profile.
 ;     3 - BIERR  (ret) String returning text of error code.
 ;
 S BIERR=""
 I '$G(BIDFN) D ERRCD^BIUTL2(201,.BIERR) Q
 ;
 ;---> Quit if Patient does not exist in Immunization Register.
 I '$D(^BIP(BIDFN,0)) D ERRCD^BIUTL2(204,.BIERR) Q
 ;
 ;---> Load Report Text into Patient's WP Node.
 D SETVARS^BIUTL5
 K ^BIP(BIDFN,1)
 ;
 N X
 S X=$L(BIPROF,"|||")
 ;
 ;---> Insert patient name and DOB at top of Report Text (for EHR).
 S ^BIP(BIDFN,1,1,0)=" "
 S ^BIP(BIDFN,1,2,0)="Patient: "_$$NAME^BIUTL1(BIDFN)_"    DOB: "_$$DOBF^BIUTL1(BIDFN,$G(BIFDT))
 S ^BIP(BIDFN,1,3,0)=" "
 F I=1:1:X S ^BIP(BIDFN,1,(I+3),0)=$P(BIPROF,"|||",I)
 ;
 S ^BIP(BIDFN,1,0)=U_U_X_U_X_U_DT
 Q
 ;
 ;
 ;----------
BIDE(BIDE) ;EP
 ;---> Set Data Elements for TCH Format.
 ;---> (Old v7.x: 6=Dose#, 23=Date of Visit, 25=HL7 Code.)
 ;---> 25=CVX Code, 65=Dose Override, 88=TCH Date of Visit.
 K BIDE
 ;
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> Pull TCH date format instead of Immserve.
 ;N I F I=23,25,65 S BIDE(I)=""
 ;N I F I=25,65,88 S BIDE(I)=""  ;IHS/CMI/LAB - pull vis/admin in tch format
 N I F I=25,65,94 S BIDE(I)=""
 ;**********
 Q
 ;
 ;
 ;----------
UNLOCK(BIDFN) ;EP
 ;---> Unlock BI PATIENT global for this patient.
 ;---> Parameters:
 ;     1 - BIDFN (req) Patient DFN to unlock.
 ;
 Q:'$G(BIDFN)
 N I F I=1:1:5 L -^BIP(BIDFN)
 Q
 ;
 ;
 ;----------
NOFORC(BINF) ;EP
 ;---> Build local array of Vaccines Group IEN's that Site has
 ;---> specified should not be forecast.
 ;---> Parameters:
 ;     1 - BINF (ret) Array of Vaccine Group IEN's that should not be forecast.
 ;
 N N S N=0
 F  S N=$O(^BISERT(N)) Q:'N  D
 .I '$P(^BISERT(N,0),U,5) S BINF(N)=""
 Q
