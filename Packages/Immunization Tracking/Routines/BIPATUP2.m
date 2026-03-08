BIPATUP2 ;IHS/CMI/MWR - UPDATE PATIENT DATA 2; OCT 15, 2010 ; 22 Aug 2025  3:29 PM
 ;;8.5;IMMUNIZATION;**22,26,29,30,31**;OCT 24,2011;Build 137
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  IHS FORECAST. UPDATE PATIENT DATA, RETURN PROFILE.
 ;;  CALLED BY BIVWXICE.
 ;;
 ;;V8.5 PATCH 29 - FID-107546 Adjust Td,NOS forecast
 ;;V8.5 PATCH 31 - FID-98855 Force zoster valid
 ;
REPORT(BIDFN,BIFDT,BIDUZ2,BINF,BICT,BIH,BIFF,BIXMLV,BIPROF) ;EP
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN (DFN)
 ;     2 - BIFDT  (req) Forecast Date (date used for forecast).
 ;     3 - BIDUZ2 (req) User's DUZ(2) indicating site parameters.
 ;     4 - BINF   (opt) Array of Vaccine Grp IEN'S that should not be forecast.
 ;     5 - BICT   (opt) Array of patient's contraindications BICT(CVX)
 ;     6 - BIH    (req) Patient Imm History Evaluation from ICE.
 ;     7 - BIFF   (req) Patient Imm Forecast collated by Volume Group BIFF(VG,CVX).
 ;     8 - BIXMLV (req) ICE Version Number.
 ;     9 - BIPROF (ret) String containing Patient's ICE Report/Profile.
 ;
 ;---> Set base variables
 N BIAGE,BIDOB,BINMV,BIRP,I,BIFDTICE
 ;V8.5 PATCH 29 - FID-107546 Tdap age check
 S BIDOB=$P(^DPT(BIDFN,0),U,3)
 S BIAGE=+$$AGE^BIUTL1(BIDFN,1,BIFDT)
 S BINMV=$S(BIAGE>18:1,1:0)
 S BIFDTICE=BIFDT+17000000 ;FORECAST DATE IN YYYYMMDD/HL7 FORMAT
 ;
 ;--->Format Header
 N %
 D NOW^%DTC
 S BIRP(1)="HLN ICE Forecaster v"_BIXMLV_" for: "_$$SLDT2^BIUTL5($G(BIFDT))_"  (run: "_$$SLDT1^BIUTL5(%)_")"
 S BIRP(2)=" "
 ;
 ;---> * * * HISTORY * * *
 ;---> BITDAP   - If Pt has valid Tdap then = 1
 ;---> BITDLST  - Date of last Td/Tdap YYYYMMDD format
 ;---> BITDNXT  - Date of next Td/Tdap due YYYYMMDD format
 ;---> BITDEVL  - Td/Tdap evaluation
 ;---> BIDTPS=n - Number of Peds Series DT's
 ;---> BITDAS=n - Number of Adult Series Td's
 ;---> ADT      - Administered Date
 ;---> ADTFM    - Admin Date FileMan format YYYMMDD
 ;---> ADTICE   - Admin Date HL7 format YYYYMMDD
 ;---> VAL      - Validity Status - VALID/INVALID/ACCEPTED
 ;
 ;---> Collate by Volume Group, then date.
 N BITDAP,BITDLST,BITDNXT,BITDEVL,BIDTPS,BITDAS
 N I,ADT,VAL,ADTFM,ADTICE
 S (BITDAP,BIDTPS,BITDAS)=0
 S (BITDLST,BITDEVL,ADT,ADTFM,ADTICE)=""
 F J=5,10,27 S BITDNXT(J)=""
 ;---> Save latest DTaP, Td, or Tdap.
 S BITDLST=0
 N I,J,BIVG,BIVGO,BIHH,Y
 S I=0
 F  S I=$O(BIH(I)) Q:'I  D
 .N J
 .S J=0
 .F  S J=$O(BIH(I,J)) Q:'J  D
 ..;---> Concatenate Combo CVX.
 ..N BIS,BIVG,BIVGO,Y
 ..S BISP=$G(BIH(I,J,"SUPP"))
 ..S Y=BIH(I,J)
 ..S $P(Y,U,5)=$G(BIH(I,0))
 ..S CVX=+Y
 ..S ADTICE=$P(Y,U,2)      ;ADMIN DATE YYYYMMDD
 ..S VAL=$P(Y,U,3)         ;VALID/INVALID/ACCEPTED
 ..S ADTFM=ADTICE-17000000 ;ADMIN DATE FM FORMAT
 ..S BIVG=$$HL7TX^BIUTL2(CVX,1),BIVGO=$$VGROUP^BIUTL2(BIVG,4)
 ..S BIHH(BIVGO,$P(Y,U,2),$P(Y,U))=Y
 ..S BIHH(BIVGO,$P(Y,U,2),$P(Y,U),"SUPP")=$G(BISP)  ;20220131 76219
 ..Q:'BINMV
 ..Q:BIVG'=1&(BIVG'=8)
 ..Q:"VALIDACCEPTED"'[VAL
 ..S:$D(^BIVARR("GRP",1,CVX)) BIDTPS=BIDTPS+1,BIDTPS(BIDTPS)=ADTFM
 ..Q:'$D(^BIVARR("GRP",8,CVX))
 ..S BITDEVL=""
 ..S BITDAS=BITDAS+1
 ..S:ADTICE>BITDLST BITDLST=ADTICE
 ..S BITDAP(BITDAS)=ADTFM
 I BITDLST D
 .S BITDNXT(10)=BITDLST+100000
 .S BITDNXT(5)=BITDLST+50000
 .S X1=BITDNXT(10)-17000000
 .S X2=27
 .D C^%DTC
 .S BITDNXT(27)=X+17000000
 I BITDLST,$E(BITDLST,1,3)-$E(BIDOB,1,3)>11 Q
 I $O(BITDAP(0))!$O(BIDTPS(0)),$O(BITDAP(999),-1)<2&(BIDTPS<4) S BITDEVL="* Tdap assumed completed.    "
 ;
 N BILN
 S BILN=2
 S BILN=BILN+1,BIRP(BILN)="-- IMM HISTORY EVALUATION -----------------------------------------------"
 S BILN=BILN+1,BIRP(BILN)=""
 S BILN=BILN+1,BIRP(BILN)="  Date      CVX  Vaccine (combo)         Status - Reason"
 S BILN=BILN+1,BIRP(BILN)="----------  ---  --------------------    ------------------------------"
 ;
 ;---> Build History lines by Vaccine Group, then Date.
 ;;V8.5 PATCH 31 - FID-98855 Force zoster valid
 D RZVE ;EVALUATE RZV VAX'S
 N I,J,K
 S I=0
 F  S I=$O(BIHH(I)) Q:'I  D  S BILN=BILN+1,BIRP(BILN)=" "
 .;---> Vaccine Group Order.
 .S J=0
 .F  S J=$O(BIHH(I,J)) Q:'J  D
 ..;---> Date.
 ..S K=0
 ..F  S K=$O(BIHH(I,J,K)) Q:'K  D
 ...N BIHSU,Y,Z
 ...S Y=BIHH(I,J,K)
 ...S BIHSUP=$G(BIHH(I,J,K,"SUPP"))
 ...;---> Date Administered.
 ...S Z=$$DF($P(Y,U,2))
 ...;---> CVX and Vaccine Short Name.
 ...S Z=Z_$J($P(Y,U),5)_"  "_$$HL7TX^BIUTL2($P(Y,U),2)
 ...I $P(Y,U)'=$P(Y,U,5) S Z=Z_" ("_$$HL7TX^BIUTL2($P(Y,U,5),2)_")"
 ...S Z=$$PAD^BIUTL5(Z,41)
 ...;---> Status (Valid, etc.)
 ...S Z=Z_$P(Y,U,3)
 ...;
 ...;---> Reason (if too long, break at a space and write next line).
 ...N X1,X2,X3,X4
 ...D BRKSP^BIUTL12($P(Y,U,4),.X1,.X2,.X3,.X4)
 ...I X1]"" S Z=Z_": "_X1
 ...I X1="",$P(Y,U,3)="INVALID" S Z=Z_": Reason not given"
 ...S BILN=BILN+1,BIRP(BILN)=Z
 ...I X2]"" S BILN=BILN+1,BIRP(BILN)=$$SP^BIUTL5(41)_X2
 ...I X3]"" S BILN=BILN+1,BIRP(BILN)=$$SP^BIUTL5(41)_X3
 ...I X4]"" S BILN=BILN+1,BIRP(BILN)=$$SP^BIUTL5(41)_X4
 ...I $G(BIHSUP)]"" D HSUPP^BIPATUP5 ;20230201 76219
 ...;---> If another imm in this Vaccine Group follows, insert a space.
 ...I X2]"",$O(BIHH(I,J)) S BILN=BILN+1,BIRP(BILN)=""
 ;
 ;---> * * * FORECAST * * *
 N C,I
 S C=0,I=""
 F  S I=$O(BIFF(I)) Q:(I="")  D
 .N J
 .S J=0
 .F  S J=$O(BIFF(I,J)) Q:'J  D
 ..I $G(BIFF(I,J,"SUPP"))]"" D
 ...S BIFSUP(I,J,"SUPP")=$G(BIFF(I,J,"SUPP"))
 ;
 S BILN=BILN+1,BIRP(BILN)=" "
 S BILN=BILN+1,BIRP(BILN)=""
 S BILN=BILN+1,BIRP(BILN)="-- FORECAST -------------------------------------------------------------"
 S BILN=BILN+1,BIRP(BILN)="",BILN=BILN+1,BIRP(BILN)="DUE:"
 S BILN=BILN+1,BIRP(BILN)=" | Vaccine      Status          Earliest     Recommended   Overdue"
 S BILN=BILN+1,BIRP(BILN)=" | -----------  -------         ----------   -----------   ----------"
 ;
 ;---> Build Forecast lines.
 ;---> FIRST pass through BIFF: "RECOMMENDED"
 N C,I
 S C=0,I=""
 F  S I=$O(BIFF(I)) Q:(I="")  D
 .N J
 .S J=0
 .F  S J=$O(BIFF(I,J)) Q:'J  D
 ..N X,Y,Z
 ..S Y=BIFF(I,J)
 ..S FORC=$P(Y,U,5)
 ..S COMP=$P(Y,U,6)
 ..Q:FORC'="RECOMMENDED"
 ..;---> Pass I & J in case this node needs to be reset
 ..;---> to "FUTURE_RECOMMENDED".
 ..D VACLINE^BIPATUP5(Y,BIFDT,BIDUZ2,BITDEVL,.BITDNXT,.BINF,.Z,.C,I,J)
 ..Q:(Z="")
 ..S BILN=BILN+1,BIRP(BILN)=Z
 ;
 I 'C S BILN=BILN+1,BIRP(BILN)=" | None"
 S BILN=BILN+1,BIRP(BILN)=" "
 ;
 ;---> SECOND pass through BIFF: "FUTURE_RECOMMENDED"
 S BILN=BILN+1,BIRP(BILN)="FUTURE:"
 S BILN=BILN+1,BIRP(BILN)=" | Vaccine      Status          Earliest     Recommended   Overdue"
 S BILN=BILN+1,BIRP(BILN)=" | -----------  -------         ----------   -----------   ----------"
 N C,I
 S C=0,I=""
 F  S I=$O(BIFF(I)) Q:(I="")  D
 .N J S J=0
 .F  S J=$O(BIFF(I,J)) Q:'J  D
 ..N Y,Z,FORC
 ..S Y=BIFF(I,J)
 ..S FORC=$P(Y,U,5)
 ..S COMP=$P(Y,U,6)
 ..Q:FORC'="FUTURE_RECOMMENDED"
 ..D VACLINE^BIPATUP5(Y,BIFDT,BIDUZ2,BITDEVL,.BITDNXT,.BINF,.Z,.C,I,J)
 ..Q:(Z="")
 ..S BILN=BILN+1,BIRP(BILN)=Z
 ;
 I 'C S BILN=BILN+1,BIRP(BILN)=" | None"
 S BILN=BILN+1,BIRP(BILN)=" "
 ;
 ;---> THIRD pass through BIFF: "Complete"
 S BILN=BILN+1,BIRP(BILN)="COMPLETE:"
 S BILN=BILN+1,BIRP(BILN)=" | Vaccine      Status"
 S BILN=BILN+1,BIRP(BILN)=" | -----------  -------"
 N C,I
 S C=0,I=""
 F  S I=$O(BIFF(I)) Q:(I="")  D
 .N J S J=0
 .F  S J=$O(BIFF(I,J)) Q:'J  D
 ..N Y,Z
 ..S Y=BIFF(I,J)
 ..N BICVX,FORC,COMP
 ..S BICVX=$P(Y,U)
 ..S FORC=$P(Y,U,5)
 ..S COMP=$P(Y,U,6)
 ..Q:FORC'="NOT_RECOMMENDED"
 ..Q:COMP'="COMPLETE"
 ..;
 ..;---> Vaccine.
 ..S Z=" | "_$$PAD^BIUTL5($$HL7TX^BIUTL2($P(Y,U),2),13),C=1
 ..;
 ..;---> Status and Dates.
 ..N BIST
 ..S BIST=$S($P(Y,U,6)="COMPLETE":"Complete",1:$P(Y,U,6))
 ..S Z=Z_BIST
 ..S C=1
 ..S BILN=BILN+1,BIRP(BILN)=Z
 I 'C S BILN=BILN+1,BIRP(BILN)=" | None"
 S BILN=BILN+1,BIRP(BILN)=" "
 ;
 ;
 ;---> FOURTH, High Risk tacked on in IHSPOST^BIPATUP1.
 ;---> Header for: "High Risk:"
 S BILN=BILN+1,BIRP(BILN)="HIGH RISK:"
 S BILN=BILN+1,BIRP(BILN)=" | Vaccine      Status"
 S BILN=BILN+1,BIRP(BILN)=" | -----------  -------"
 ;
 ;---> Build Report data string.
 N I
 S I=0
 F  S I=$O(BIRP(I)) Q:'I  D
 .S BIPROF=BIPROF_BIRP(I)_"|||"
 Q
 ;=====
 ;
DPROBS(BIFORC,BIPDSS,BIID) ;EP
 ;---> Check for any Input Doses that have Dose Problems.
 ;---> If any exist, build the string BIPDSS, concatenating the
 ;---> Visit IEN's with U.
 ;---> Parameters:
 ;     1 - BIFORC (req) Forecast string coming back from TCH.
 ;     2 - BIPDSS (ret) Returned string of V IMM IEN Problem Doses.
 ;                      according to ImmServe.
 ;     3 - BIID   (ret) NO LONGER USED. Immserve "Number of Input Doses" (Field 109 in 2010).
 ;
 S BIPDSS=""
 ;
 ;---> NOTE: Pulling HX from TCH Output String (NOT RPMS Input string).
 N BIFORC1,BIDOSE,N
 S BIFORC1=$P(BIFORC,"~~~",3)
 ;
 F N=1:1 S BIDOSE=$P(BIFORC1,"|||",N) Q:(BIDOSE="")  D
 .;---> If this Input Dose was TCH-invalid (pc6), set V Imm IEN_%_CVX in
 .;---> Problem Doses string (BIPDSS).
 .;
 .;---> Mods to flag only problem components of combo vaccines.
 .;
 .;---> Quit if this is not a problem dose.
 .Q:('$P(BIDOSE,U,6))
 .;
 .N BICVXS S BICVXS=$P(BIDOSE,U,7)
 .;---> If piece 7 is null then not a combo, set BIPDSS and quit.
 .;---> Strip TCH's leading zero, so it matches RPMS CVX ("03"=3).
 .I 'BICVXS S BIPDSS=BIPDSS_$P(BIDOSE,U)_"%"_+$P(BIDOSE,U,2)_U Q
 .;
 .;--> Piece 7 equals one or more problem CVX's in this combo, delimited by comma.
 .N J
 .F J=1:1 S BICVX=$P(BICVXS,",",J) Q:'BICVX  D
 ..S BIPDSS=BIPDSS_$P(BIDOSE,U)_"%"_BICVX_U
 Q
 ;=====
 ;
KILLDUE(BIDFN) ;EP
 ;---> Clear out any previously set Immunizations Due and
 ;---> any Forecasting Errors for this patient.
 ;---> Hardcoded to improve performance during massive reports.
 ;---> Parameters:
 ;     1 - BIDFN (req) Patient IEN.
 ;
 Q:'BIDFN
 ;
 ;---> Clear previous Immunizations Due.
 D:$D(^BIPDUE("B",BIDFN))
 .N N
 .S N=0
 .F  S N=$O(^BIPDUE("B",BIDFN,N)) Q:'N  D
 ..N Y,Z S Y=$G(^BIPDUE(N,0))
 ..K ^BIPDUE(N),^BIPDUE("B",BIDFN,N)
 ..Q:Y=""
 ..S Z=$P(Y,U,4) K:Z ^BIPDUE("D",Z,N)
 ..S Z=$P(Y,U,5) K:Z ^BIPDUE("D",Z,N)
 ..S $P(^BIPDUE(0),U,4)=$P(^BIPDUE(0),U,4)-1
 ..;
 ..;********** PATCH 13, v8.5, AUG 01,2016, IHS/CMI/MWR
 ..;---> Kill "C" xref on 2nd pc, Vaccine IEN.
 ..S Z=$P(Y,U,2) K:Z ^BIPDUE("C",Z,N)
 ..;**********
 ..;
 .K ^BIPDUE("B",BIDFN),^BIPDUE("E",BIDFN)
 ;
 ;---> Clear previous Forecasting Errors.
 D:$D(^BIPERR("B",BIDFN))
 .N N
 .S N=0
 .F  S N=$O(^BIPERR("B",BIDFN,N)) Q:'N  D
 ..K ^BIPERR("B",BIDFN,N),^BIPERR(N)
 ..S $P(^BIPERR(0),U,4)=$P(^BIPERR(0),U,4)-1
 .K ^BIPERR("B",BIDFN)
 Q
 ;
 ;----------
IMMSDT(DATE) ;EP
 ;---> Convert Immserve Date (format MMDDYYYY) TO FILEMAN
 ;---> Internal format.
 Q:'$G(DATE) "NO DATE"
 Q ($E(DATE,5,9)-1700)_$E(DATE,1,2)_$E(DATE,3,4)
 ;=====
 ;
PNMAGE(BISITE) ;EP - Return Age Appropriate in years for Pneumo at this site.
 ;---> Parameters:
 ;     1 - BISITE (req) User's DUZ(2)
 ;
 Q:'$G(BISITE) "65"
 N Y
 S Y=$P($G(^BISITE(BISITE,0)),U,10) S:'Y Y=65
 Q Y
 ;=====
 ;
FLUALL(BISITE) ;EP - Return 1 to forecast Flu for ALL ages.
 ;---> Parameters:
 ;     1 - BISITE (req) User's DUZ(2)
 ;
 Q:'$G(BISITE) 1
 N Y S Y=$P($G(^BISITE(BISITE,0)),U,27)
 Q:(Y=0) 0
 Q 1
 ;=====
 ;
 ;
ZOSTER(BISITE) ;EP - Return 1 if Zostervax should be forecast.
 ;---> Parameters:
 ;     1 - BISITE (req) User's DUZ(2)
 ;
 Q:'$G(BISITE) 1
 N Y S Y=$P($G(^BISITE(BISITE,0)),U,29)
 Q:(Y=0) 0
 Q 1
 ;=====
 ;
SETDUE(BIDATA) ;EP
 ;---> Add this Immunization to BI PATIENT IMM DUE File #9002084.1.
 ;---> Parameters:
 ;     1 - BIDATA (req) Data string (5 fields) for 0-node.
 ;                      BIDFN^Vaccine IEN^Dose#^Recommended Date^Date Past Due
 ;
 Q:$G(BIDATA)=""
 N A,B,BIDFN,M,N
 S M=^BIPDUE(0),N=$P(M,U,3),M=$P(M,U,4) S:'N N=1
 F  Q:'$D(^BIPDUE(N))  S N=N+1
 S BIDFN=$P(BIDATA,U)
 Q:'BIDFN
 ;
 ;********** PATCH 19, v8.5, JUN 01,2020, IHS/CMI/MWR
 ;---> Set 6th piece equal to Date.Time (to seconds).
 ;S ^BIPDUE(N,0)=BIDATA
 N %,X
 D NOW^%DTC
 S ^BIPDUE(N,0)=BIDATA_"^"_%
 ;**********
 ;
 ;********** PATCH 1, v8.3.1, Dec 30,2008, IHS/CMI/MWR
 ;---> Add 6th pc, Date Forecast Calculated.
 ;S:$G(DT) $P(^BIPDUE(N,0),U,6)=DT
 ;**********
 ;
 S ^BIPDUE("B",BIDFN,N)=""
 S A=$P(BIDATA,U,4),B=$P(BIDATA,U,5)
 I A S ^BIPDUE("D",A,N)=""
 I B S ^BIPDUE("D",B,N)="",^BIPDUE("E",BIDFN,B,N)=""
 ;
 ;********** PATCH 13, v8.5, AUG 01,2016, IHS/CMI/MWR
 ;---> Add "C" xref on 2nd pc, Vaccine IEN.
 N V S V=$P(BIDATA,U,2)
 I V S ^BIPDUE("C",V,N)=""
 ;**********
 ;
 S $P(^BIPDUE(0),U,3,4)=N_U_(M+1)
 Q
 ;
DF(BIDT) ;EP
 Q $$ICEDATE^BIUTL5(BIDT)
 ;
RZVE ;V8.5 PATCH 31 - FID-98855 Force RZV valid
 N X,Y,A,X0,J
 S J=0
 S X=0
 F  S X=$O(BIHH(87,X)) Q:'X  D
 .S J=J+1
 .S X0=$G(BIHH(87,X,187))
 .S EVAL(J)=X0
 Q:J<2
 S E1=EVAL(1)
 S D1=$P(E1,U,2)
 S J2=$O(EVAL(99999),-1)
 S E2=EVAL(J2)
 S D2=$P(E2,U,2)
 S X1=D2-17000000
 S X2=D1-17000000
 D D^%DTC
 I X<28 D
 .S BIFF(87,187)="187^^INVALID^Interval between doses less than 4 weeks"
 .S $P(BIHH(87,D2,187),U,4)="Interval between doses less than 4 weeks"
 I X>27,$P(E1,U,3)="VALID" D
 .S BIFF(87,187)="187^^VALID^^NOT_RECOMMENDED^COMPLETE"
 .S BIHH(87,D2,187)=187_U_D2_U_"VALID^^187"
 Q
 ;=====
 ;
