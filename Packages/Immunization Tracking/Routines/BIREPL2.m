BIREPL2 ;IHS/CMI/MWR - REPORT, ADULT IMM; MAY 10, 2010 ; 21 May 2025  12:59 PM [ 05/21/2025  11:59 AM ]
 ;;8.5;IMMUNIZATION;**12,26,27,29,30,31**;OCT 24,2011;Build 137
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW ADULT IMMUNIZATION REPORT, GATHER DATA.
 ;
HEAD(BIQDT,BICC,BIHCF,BIBEN,BICPTI,BIUP) ;EP
 ;---> Produce Header array for ADULT Immunization Report.
 ;---> Parameters:
 ;     1 - BIQDT  (req) Quarter Ending Date.
 ;     2 - BICC   (req) Current Community array.
 ;     3 - BIHCF  (req) Health Care Facility array.
 ;     4 - BIBEN  (req) Beneficiary Type array.
 ;     5 - BICPTI (req) 1=Include CPT Coded Visits, 0=Ignore CPT
 ;     6 - BIUP    (req) User Population/Group (Registered, Imm, User, Active).
 Q:'$G(BIQDT)
 Q:'$D(BICC)
 Q:'$D(BIHCF)
 Q:'$D(BIBEN)
 I '$D(BICPTI) S BICPTI=0
 Q:'$D(BIUP)
 ;
 K VALMHDR
 N BILINE,X
 S BILINE=0
 ;
 N X
 S X=""
 ;---> If Header array is NOT being for Listmananger include version.
 S:'$D(VALM("BM")) X=$$LMVER^BILOGO()
 ;
 I $G(BISPD)'="CSV" D WH^BIW(.BILINE,X)
 S X=$$REPHDR^BIUTL6(DUZ(2)) I $G(BISPD)'="CSV" D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 ;
 S X="*  Adult Immunization Report  *" I $G(BISPD)'="CSV" D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 ;
 S:$G(BISPD)'="CSV" X=$$SP^BIUTL5(27)_"Report Date: "_$$SLDT1^BIUTL5(DT) S:$G(BISPD)="CSV" X="Report Date: "_$$SLDT1^BIUTL5(DT)
 D WH^BIW(.BILINE,X,$S($G(BISPD)="CSV":"",1:1))
 ;
 ;
 S:$G(BISPD)'="CSV" X=$$SP^BIUTL5(30)_"End Date: "_$$SLDT1^BIUTL5(BIQDT) S:$G(BISPD)="CSV" X="End Date: "_$$SLDT1^BIUTL5(BIQDT)
 D WH^BIW(.BILINE,X,$S($G(BISPD)="CSV":"",1:1))
 ;
 ;S X=$$SP^BIUTL5(27)_"Report Date: "_$$SLDT1^BIUTL5(DT)
 ;D WH^BIW(.BILINE,X,1)
 ;
 ;**********
 ;
 S X=" "_$$BIUPTX^BIUTL6(BIUP)
 I BICPTI S X=$$PAD^BIUTL5(X,52)_"* CPT Coded Visits Included"
 D WH^BIW(.BILINE,X)
 I $G(BISPD)'="CSV" D WH^BIW(.BILINE,$$SP^BIUTL5(79,"-"))
 ;
 D
 .;---> If specific Communities were selected (not ALL), then print
 .;---> the Communities in a subheader at the top of the report.
 .D SUBH^BIOUTPT5("BICC","Community",,"^AUTTCOM(",.BILINE,.BIERR,,13)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 .;
 .;---> If specific Health Care Facilities, print subheader.
 .D SUBH^BIOUTPT5("BIHCF","Facility",,"^DIC(4,",.BILINE,.BIERR,,13)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 .;
 .;---> If specific Beneficiary Types, print Beneficiary Type subheader.
 .D SUBH^BIOUTPT5("BIBEN","Beneficiary Type",,"^AUTTBEN(",.BILINE,.BIERR,,13)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 .;
 .I $G(BISPD)'="CSV" S X=$$SP^BIUTL5(59)_"Number   Percent" D WH^BIW(.BILINE,X)
 ;
 D:$D(VALM("BM"))
 .S VALM("TM")=BILINE+3
 .S VALM("LINES")=VALM("BM")-VALM("TM")+1
 .;---> Safeguard to prevent divide/0 error.
 .S:VALM("LINES")<1 VALM("LINES")=1
 Q
 ;
 ;
 ;----------
START(BIQDT,BICC,BIHCF,BIBEN,BICPTI,BIUP) ;EP
 ;---> Produce array for ADULT Immunization Report.
 ;---> Parameters:
 ;     1 - BIQDT  (req) Quarter Ending Date.
 ;     2 - BICC   (req) Current Community array.
 ;     3 - BIHCF  (req) Health Care Facility array.
 ;     4 - BIBEN  (req) Beneficiary Type array.
 ;     5 - BICPTI (req) 1=Include CPT Coded Visits, 0=Ignore CPT (default).
 ;     6 - BIUP    (req) User Population/Group (Registered, Imm, User, Active).
 ;
 N BILINE,BITMP,X
 S BILINE=0
 K ^TMP("BIREPL1",$J)
 ;
 ;---> Check for required Variables.
 ;---> Fix for v8.1 by adding .X to error calls below.
 I '$G(BIQDT) D ERRCD^BIUTL2(623,.X) D WRITE(.BILINE,X) Q
 I '$D(BICC) D ERRCD^BIUTL2(614,.X) D WRITE(.BILINE,X) Q
 I '$D(BIHCF) D ERRCD^BIUTL2(625,.X) D WRITE(.BILINE,X) Q
 I '$D(BIBEN) D ERRCD^BIUTL2(662,.X) D WRITE(.BILINE,X) Q
 I '$D(BICPTI) S BICPTI=0
 S:$G(BIUP)="" BIUP="u"
 ;
 D GETSTATS^BIREPL3(BIQDT,.BICC,.BIHCF,.BIBEN,BICPTI,BIUP,.BITOTS)
 D DISPLAY(.BITOTS,.BILINE)
 S VALMCNT=BILINE
 Q
 ;
 ;
 ;----------
DISPLAY(BITOTS,BILINE) ;EP
 ;---> Write Adult Stats for display.
 ;---> Parameters:
 ;     1 - BITOTS (req) 
 ;     1 - BILINE (ret) Number of lines written to Listman scroll area.
 ;
 I '$D(BITOTS) D ERRCD^BIUTL2(667,.X) D WRITE(.BILINE,X) Q
 I $G(BISPD)="CSV" D CSV^BIREPL5(.BITOTS,.BILINE) Q
 ;
 ;
 S X=$$PAD("  Total Number of Patients 19 years and older",56)_": "
 S X=X_$$C(BITOTS("PTS19+"),0,8) D WRITE(.BILINE,X,1)
 ;
 S X=$$PAD("    TETANUS: # patients Tdap EVER",56)
 S X=X_": "_$$C(BITOTS("19+TDAPEVER"),0,8)
 I BITOTS("PTS19+") S X=X_$J((BITOTS("19+TDAPEVER")/BITOTS("PTS19+"))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    TETANUS: # patients Tdap EVER AND",56)
 D WRITE(.BILINE,X)
 S X=$$PAD("      [Td OR Tdap in past 10 years]",56)
 S X=X_": "_$$C(BITOTS("19+TDAP&TD10YR"),0,8)
 I BITOTS("PTS19+") S X=X_$J((BITOTS("19+TDAP&TD10YR")/BITOTS("PTS19+"))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;
 ;---> HEP B
 S X=$$PAD("  Total Number of Patients 19-59",56)_": "
 S X=X_$$C(BITOTS("PTS19-59"),0,8) D WRITE(.BILINE,X,1)
 ;
 S X=$$PAD("    HEP B: # patients - Series initiated",56)
 S X=X_": "_$$C(BITOTS("19-59HEPB1"),0,8)  ;p26 piece 3
 I BITOTS("PTS19-59") S X=X_$J((BITOTS("19-59HEPB1")/BITOTS("PTS19-59"))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    HEP B: # patients - Dose 2 initiated",56)
 S X=X_": "_$$C(BITOTS("19-59HEPB2"),0,8)  ;p26 piece 3
 I BITOTS("PTS19-59") S X=X_$J((BITOTS("19-59HEPB2")/BITOTS("PTS19-59"))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    HEP B: # patients - Series completed",56)
 S X=X_": "_$$C(BITOTS("19-59HEPBC"),0,8)  ;p26 piece 3
 I BITOTS("PTS19-59") S X=X_$J((BITOTS("19-59HEPBC")/BITOTS("PTS19-59"))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;
 ;;---> HPV
 S X=$$PAD("  Total Number of Patients age 19-26",56)
 S X=X_": "_$$C(BITOTS("PTS19-26"),0,8)
 I BITOTS("PTS19+") S X=X_$J((BITOTS("PTS19-26")/BITOTS("PTS19+"))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;
 S X=$$PAD("    HPV: # patients - Series initiated",56)
 S X=X_": "_$$C(BITOTS("19-26HPV1"),0,8)
 I BITOTS("PTS19-26") S X=X_$J((BITOTS("19-26HPV1")/BITOTS("PTS19-26"))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    HPV: # patients - Dose 2 initiated",56)
 S X=X_": "_$$C(BITOTS("19-26HPV2"),0,8)
 I BITOTS("PTS19-26") S X=X_$J((BITOTS("19-26HPV2")/BITOTS("PTS19-26"))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    HPV: # patients - Series completed",56)
 S X=X_": "_$$C(BITOTS("19-26HPVC"),0,8)
 I BITOTS("PTS19-26") S X=X_$J((BITOTS("19-26HPVC")/BITOTS("PTS19-26"))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;
 ;---> Total patients over 50 and shingrix
 S X=$$PAD("  Total Number of Patients 50 years and older",56)
 S X=X_": "_$$C(BITOTS("PTS50+"),0,8)
 I BITOTS("PTS19+") S X=X_$J((BITOTS("PTS50+")/BITOTS("PTS19+"))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;
 ;V8.5 PATCH 29 - FID-  Edit display spelling
 S X=$$PAD("    Shingrix: # patients - Series initiated",56)
 S X=X_": "_$$C(BITOTS("50+SHINGRIX1"),0,8)
 I BITOTS("PTS50+") S X=X_$J((BITOTS("50+SHINGRIX1")/BITOTS("PTS50+"))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    Shingrix: # patients - Series completed",56) ;THL 6/28/23 Typo corrected
 S X=X_": "_$$C(BITOTS("50+SHINGRIXC"),0,8)
 I BITOTS("PTS50+") S X=X_$J((BITOTS("50+SHINGRIXC")/BITOTS("PTS50+"))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;
 ;19-64 lines
 S X=$$PAD("  Total Number of Patients age 19-64",56)
 S X=X_": "_$$C(BITOTS("PTS19-64"),0,8)
 I BITOTS("PTS19+") S X=X_$J((BITOTS("PTS19-64")/BITOTS("PTS19+"))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;
 S X=$$PAD("    PCV13 and PPSV23: # patients - fully vaccinated",56)
 S X=X_": "_$$C(BITOTS("19-64PCV13PPSV23"),0,8)
 I BITOTS("PTS19-64") S X=X_$J((BITOTS("19-64PCV13PPSV23")/BITOTS("PTS19-64"))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    PCV20: # patients - fully vaccinated",56)
 S X=X_": "_$$C(BITOTS("19-64PCV20"),0,8)
 I BITOTS("PTS19-64") S X=X_$J((BITOTS("19-64PCV20")/BITOTS("PTS19-64"))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    PPSV23 and PCV15: # patients - fully vaccinated",56)
 S X=X_": "_$$C(BITOTS("19-64PCV15PPSV23"),0,8)
 I BITOTS("PTS19-64") S X=X_$J((BITOTS("19-64PCV15PPSV23")/BITOTS("PTS19-64"))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;
 ;65 and older lines
 S X=$$PAD("  Total Number of Patients 65 years and older",56)
 S X=X_": "_$$C(BITOTS("PTS65+"),0,8)
 I BITOTS("PTS19+") S X=X_$J((BITOTS("PTS65+")/BITOTS("PTS19+"))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;
 S X=$$PAD("    Tetanus: # patients w/Td/Tdap in past 10 years",56)
 S X=X_": "_$$C(BITOTS("65+TDAP/TD10YR"),0,8)
 I BITOTS("PTS65+") S X=X_$J((BITOTS("65+TDAP/TD10YR")/BITOTS("PTS65+"))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    PCV13 and PPSV23: # patients - fully vaccinated",56)
 S X=X_": "_$$C(BITOTS("65+PCV13PPSV23"),0,8)
 I BITOTS("PTS65+") S X=X_$J((BITOTS("65+PCV13PPSV23")/BITOTS("PTS65+"))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    PCV20: # patients - fully vaccinated",56)
 S X=X_": "_$$C(BITOTS("65+PCV20"),0,8)
 I BITOTS("PTS65+") S X=X_$J((BITOTS("65+PCV20")/BITOTS("PTS65+"))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    PPSV23 and PCV15: # patients - fully vaccinated",56)
 S X=X_": "_$$C(BITOTS("65+PCV15PPSV23"),0,8)
 I BITOTS("PTS65+") S X=X_$J((BITOTS("65+PCV15PPSV23")/BITOTS("PTS65+"))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;
 S X="  Total Patients included who had Refusals on record....:"_$J(BITOTS("REFUSALS"),8)
 D WRITE(.BILINE,X,2)
 ;
 S X=$$PAD("  * * * NEW GPRA COMPOSITE MEASURE SECTION * * *")
 D WRITE(.BILINE,X,1)
 ;
 ;IHS/CMI/LAB - BI*8.5*29  - added HPV lines patch 29
 ;;---> HPV
 S X=$$PAD("  Total Number of Patients ages 19 through 26 years",56)
 S X=X_": "_$$C(BITOTS("PTS19-26"),0,8)
 D WRITE(.BILINE,X,1)
 ;
 S X=$$PAD("    Received HPV Series complete",56)
 S X=X_": "_$$C(BITOTS("19-26HPVC"),0,8)
 I BITOTS("PTS19-26") S X=X_$J((BITOTS("19-26HPVC")/BITOTS("PTS19-26"))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;
 ;composite for 19-49 years
 S X=$$PAD("  Total Number of Patients ages 19 through 49 years",56)_": "
 S X=X_$$C(BITOTS("PTS19-49"),0,8) D WRITE(.BILINE,X,1)
 ;
 S X=$$PAD("    Received 1 dose of Tdap ever",56)
 S X=X_": "_$$C(BITOTS("19-49TDAPEVER"),0,8)
 I BITOTS("PTS19-49") S X=X_$J((BITOTS("19-49TDAPEVER")/BITOTS("PTS19-49"))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    Received 1 dose of Tdap or Td < 10 years",56)
 S X=X_": "_$$C(BITOTS("19-49TDAP/TD10YR"),0,8)
 I BITOTS("PTS19-49") S X=X_$J((BITOTS("19-49TDAP/TD10YR")/BITOTS("PTS19-49"))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    Received 1 dose of Tdap ever AND Tdap or Td < 10 yrs",56)
 S X=X_": "_$$C(BITOTS("19-49TDAP&TD10YR"),0,8)
 I BITOTS("PTS19-49") S X=X_$J((BITOTS("19-49TDAP&TD10YR")/BITOTS("PTS19-49"))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    Received HEP B Series complete",56)
 S X=X_": "_$$C(BITOTS("19-49HEPBC"),0,8)  ;p26 piece 3
 I BITOTS("PTS19-49") S X=X_$J((BITOTS("19-49HEPBC")/BITOTS("PTS19-49"))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;
 S X=$$PAD("    Received ALL of the above (appropriately vaccinated)",56)
 S X=X_": "_$$C(BITOTS("19-49ALL"),0,8)  ;p26 piece 3
 I BITOTS("PTS19-49") S X=X_$J((BITOTS("19-49ALL")/BITOTS("PTS19-49"))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;
 ; composite 50-59
 S X=$$PAD("  Total Number of Patients ages 50 through 59 years",56)_": "
 S X=X_$$C(BITOTS("PTS50-59"),0,8) D WRITE(.BILINE,X,1)
 ;
 S X=$$PAD("    Received 1 dose of Tdap ever",56)
 S X=X_": "_$$C(BITOTS("50-59TDAPEVER"),0,8)
 I BITOTS("PTS50-59") S X=X_$J((BITOTS("50-59TDAPEVER")/BITOTS("PTS50-59"))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    Received 1 dose of Tdap or Td < 10 years",56)
 S X=X_": "_$$C(BITOTS("50-59TDAP/TD10YR"),0,8)
 I BITOTS("PTS50-59") S X=X_$J((BITOTS("50-59TDAP/TD10YR")/BITOTS("PTS50-59"))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    Received 1 dose of Tdap ever AND Tdap or Td < 10 yrs",56)
 S X=X_": "_$$C(BITOTS("50-59TDAP&TD10YR"),0,8)
 I BITOTS("PTS50-59") S X=X_$J((BITOTS("50-59TDAP&TD10YR")/BITOTS("PTS50-59"))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    Received HEP B Series complete",56)
 S X=X_": "_$$C(BITOTS("50-59HEPBC"),0,8)  ;p26 piece 3
 I BITOTS("PTS50-59") S X=X_$J((BITOTS("50-59HEPBC")/BITOTS("PTS50-59"))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    Received Shingrix series complete",56)
 S X=X_": "_$$C(BITOTS("50-59SHINC"),0,8)  ;p26 piece 3
 I BITOTS("PTS50-59") S X=X_$J((BITOTS("50-59SHINC")/BITOTS("PTS50-59"))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;
 S X=$$PAD("    Received ALL of the above (appropriately vaccinated)",56)
 S X=X_": "_$$C(BITOTS("50-59ALL"),0,8)  ;p26 piece 3
 I BITOTS("PTS50-59") S X=X_$J((BITOTS("50-59ALL")/BITOTS("PTS50-59"))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;
 ; composite 60-65
 S X=$$PAD("  Total Number of Patients ages 60 through 65 years",56)_": "
 S X=X_$$C(BITOTS("PTS60-65"),0,8) D WRITE(.BILINE,X,1)
 ;
 S X=$$PAD("    Received 1 dose of Tdap ever",56)
 S X=X_": "_$$C(BITOTS("60-65TDAPEVER"),0,8)
 I BITOTS("PTS60-65") S X=X_$J((BITOTS("60-65TDAPEVER")/BITOTS("PTS60-65"))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    Received 1 dose of Tdap or Td < 10 years",56)
 S X=X_": "_$$C(BITOTS("60-65TDAP/TD10YR"),0,8)
 I BITOTS("PTS60-65") S X=X_$J((BITOTS("60-65TDAP/TD10YR")/BITOTS("PTS60-65"))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    Received 1 dose of Tdap ever AND Tdap or Td < 10 yrs",56)
 S X=X_": "_$$C(BITOTS("60-65TDAP&TD10YR"),0,8)
 I BITOTS("PTS60-65") S X=X_$J((BITOTS("60-65TDAP&TD10YR")/BITOTS("PTS60-65"))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    Received Shingrix series complete",56)
 S X=X_": "_$$C(BITOTS("60-65SHINC"),0,8)  ;p26 piece 3
 I BITOTS("PTS60-65") S X=X_$J((BITOTS("60-65SHINC")/BITOTS("PTS60-65"))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;
 S X=$$PAD("    Received ALL of the above (appropriately vaccinated)",56)
 S X=X_": "_$$C(BITOTS("60-65ALL"),0,8)  ;p26 piece 3
 I BITOTS("PTS60-65") S X=X_$J((BITOTS("60-65ALL")/BITOTS("PTS60-65"))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;COMPOSITE 66+
 D MORE^BIREPL4
 G E
 ;
 S X=$$PAD("  Total Number of Patients 19 years and older",56)_": "
 S X=X_$$C(BIV(33),0,8) D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    Total Patients 19 years and older appropriately ",52)
 D WRITE(.BILINE,X)
 S X=$$PAD("    vaccinated per age recommendations",56)
 S X=X_": "_$$C(BIV(34),0,8)
 I BIV(33) S X=X_$J((BIV(34)/BIV(33))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;
 S VALMCNT=BILINE
E Q
 ;
WRITE(BILINE,BIVAL,BIBLNK) ;EP
 ;---> Write lines to ^TMP (see documentation in ^BIW).
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# written.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;     3 - BIBLNK (opt) Number of blank lines to add after line sent.
 ;
 Q:'$D(BILINE)
 D WL^BIW(.BILINE,"BIREPL1",$G(BIVAL),$G(BIBLNK))
 ;
 ;--->Set VALMCNT (Listman line count) for errors calls above.
 S VALMCNT=BILINE
 Q
 ;
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
 ;
PAD(D,L,C) ;EP
 Q $$PAD^BIUTL5($G(D),$G(L),".")
