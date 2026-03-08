BIREPC2 ;IHS/CMI/MWR - REPORT, COVID IMM;  OCT 15,2010
 ;;8.5;IMMUNIZATION;**24**;OCT 24,2011;Build 15
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW COVID IMMUNIZATION REPORT, GATHER DATA.
 ;
 ;
 ;----------
HEAD(BIQDT,BICC,BIHCF,BICM,BIBEN,BIUP) ;EP
 ;---> Produce Header array for Quarterly Immunization Report.
 ;---> Parameters:
 ;     1 - BIQDT  (req) Quarter Ending Date.
 ;     2 - BICC   (req) Current Community array.
 ;     3 - BIHCF  (req) Health Care Facility array.
 ;     4 - BICM   (req) Case Manager array.
 ;     5 - BIBEN  (req) Beneficiary Type array.
 ;     6 - BIUP   (req) User Population/Group (Registered, Imm, User, Active).
 ;
 ;---> Check for required Variables.
 Q:'$G(BIQDT)
 Q:'$D(BICC)
 Q:'$D(BIHCF)
 Q:'$D(BICM)
 Q:'$D(BIBEN)
 Q:'$D(BIUP)
 ;
 K VALMHDR
 N BILINE,X S BILINE=0
 ;
 N X S X=""
 ;---> If Header array is NOT being for Listmananger include version.  vvv83
 S:'$D(VALM("BM")) X=$$LMVER^BILOGO()
 ;
 D WH^BIW(.BILINE,X)
 S X=$$REPHDR^BIUTL6(DUZ(2)) D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 ;
 S X="*  Standard COVID Immunization Report  *"
 D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 ;
 S X=$$SP^BIUTL5(27)_"Report Date: "_$$SLDT1^BIUTL5(DT)
 D WH^BIW(.BILINE,X)
 ;
 S X=$$SP^BIUTL5(19)_"Quarter Ending Date: "_$$SLDT2^BIUTL5(BIQDT)
 D WH^BIW(.BILINE,X,1)
 ;
 S X=" "_$$BIUPTX^BIUTL6(BIUP),X=$$PAD^BIUTL5(X,48)
 D WH^BIW(.BILINE,X)
 ;
 D WH^BIW(.BILINE,$$SP^BIUTL5(79,"-"))
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
 .;
 .S X=$$SP^BIUTL5(13)_"|"_$$SP^BIUTL5(4)_"      Age in years on "
 .S X=X_$$SLDT2^BIUTL5(BIQDT)_$$SP^BIUTL5(12)_"       |"
 .D WH^BIW(.BILINE,X)
 .;
 .S X="             |"_$$SP^BIUTL5(55,"-")_"| Totals"
 .D WH^BIW(.BILINE,X)
 .S X="             |      Pediatric -  Adolescent  |   Adult Population"
 .S X=$$PAD^BIUTL5(X,69)_"|"
 .D WH^BIW(.BILINE,X)
 .;
 . S X="             |    <2     2-4    5-11   12-17 | 18-49   50-64     65+"
 .S X=$$PAD^BIUTL5(X,69)_"|"
 .D WH^BIW(.BILINE,X)
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
 ;----------
START(BIQDT,BICC,BIHCF,BICM,BIBEN,BIUP) ;EP
 ;---> Produce array for Quarterly Immunization Report.
 ;---> Parameters:
 ;     1 - BIQDT  (req) Quarter Ending Date.
 ;     2 - BICC   (req) Current Community array.
 ;     3 - BIHCF  (req) Health Care Facility array.
 ;     4 - BICM   (req) Case Manager array.
 ;     5 - BIBEN  (req) Beneficiary Type array.
 ;     6 - BIUP   (req) User Population/Group (Registered, Imm, User, Active).
 ;
 K ^TMP("BIREPC1",$J),BITMP
 N BILINE,BITMP,X S BILINE=0,BIPOP=0
 N BIDNOM
 ;
 ;---> Check for required Variables.
 ;
 I '$G(BIQDT) D ERRCD^BIUTL2(622,.X) D WRITERR(BILINE,X) Q
 I '$D(BICC) D ERRCD^BIUTL2(614,.X) D WRITERR(BILINE,X) Q
 I '$D(BIHCF) D ERRCD^BIUTL2(625,.X) D WRITERR(BILINE,X) Q
 I '$D(BICM) D ERRCD^BIUTL2(615,.X) D WRITERR(BILINE,X) Q
 I '$D(BIBEN) D ERRCD^BIUTL2(662,.X) D WRITERR(BILINE,X) Q
 S:$G(BIUP)="" BIUP="u"
 ;
 ;---> Compute Report Stats.
 D AGETOT^BIREPC3(.BILINE,.BICC,.BIHCF,.BICM,.BIBEN,BIQDT,.BIPOP,BIUP,.BIDNOM,.BIDNOMH)
 Q:BIPOP
 ;
 ;---> Write Approp for Age and Vaccine Group lines.
 ;D APPROP^BIREPC3(.BILINE)
 ;
 ;---> Write Statistics lines for each Vaccine Group (BIVGRP).
 ;F BIVGRP=1,2,6,3,4,7,9,11,15 D VGRP^BIREPC3(.BILINE,BIVGRP)
 ;---> For COVID.
 S BIVGRP=21
 D VGRP^BIREPC3(.BILINE,BIDNOM,BIDNOMH)
 ;
 S VALMCNT=BILINE
 Q
 ;
 ;
 ;----------
WRITERR(BILINE,X) ;EP
 ;---> Write error line to report.
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# written.
 ;     2 - BIVAL  (req) Error text.
 ;
 S:'$D(X) X="No error text."
 S:'$D(BILINE) BILINE=1
 D WRITE^BIREPC3(.BILINE,X) S VALMCNT=BILINE
 Q
