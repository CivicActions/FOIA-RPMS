BIREPL ;IHS/CMI/MWR - REPORT, ADULT IMM; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**26,31**;OCT 24,2011;Build 137
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW ADULT IMMUNIZATION REPORT: PARAMETERS VIEW MENU
 ;
 ;
 ;----------
START ;EP
 ;---> Listman Screen for printing Immunization Due Letters.
 D SETVARS^BIUTL5 N BIRTN
 ;
 ;---> If Vaccine Table is not standard, display Error Text and quit.
 I $D(^BISITE(-1)) D ERRCD^BIUTL2(503,,1) Q
 ;
 D EN
 D EXIT
 Q
 ;
 ;
 ;----------
EN ;EP
 ;---> Main entry point for BI LETTER PRINT DU
 D EN^VALM("BI REPORT ADULT IMM")
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 S VALM("TITLE")=$$LMVER^BILOGO
 S VALMSG="Select a left column number to change an item."
 N BILINE,X S BILINE=0
 D WRITE(.BILINE)
 S X=IOUON_"ADULT IMMUNIZATION REPORT" D CENTERT^BIUTL5(.X,42)
 D WRITE(.BILINE,X_IOINORM)
 K X
 ;
 ;---> Date.
 D WRITE(.BILINE)
 S:'$G(BIQDT) BIQDT=$G(DT)
 D DATE^BIREP(.BILINE,"BIREPL",1,BIQDT,"Quarter Ending Date",,,,1)
 ;
 ;---> Current Community.
 D DISP^BIREP(.BILINE,"BIREPL",.BICC,"Community",2,1)
 ;
 ;---> Health Care Facility.
 N A,B S A="Health Care Facility",B="Facilities"
 D DISP^BIREP(.BILINE,"BIREPL",.BIHCF,A,3,2,,,,B) K A,B
 ;
 ;---> Beneficiary Type.
 S:$O(BIBEN(0))="" BIBEN(1)=""   ;vvv83
 D DISP^BIREP(.BILINE,"BIREPL",.BIBEN,"Beneficiary Type",4,4)
 ;
 ;---> Include CPT Coded Visits.
 S:'$D(BICPTI) BICPTI=0
 S X="     5 - Include CPT Coded Visits...: "
 S X=X_$S($G(BICPTI):"YES",1:"NO")
 D WRITE(.BILINE,X,1)
 K X
 ;
 ;---> User Population.
 D:($G(BIUP)="")
 .I $$GPRAIEN^BIUTL6 S BIUP="a" Q
 .S BIUP="u"
 ;
 S X="     6 - Patient Population Group...: "
 D
 .I BIUP="r" S X=X_"Registered Patients (All)" Q
 .I BIUP="i" S X=X_"Immunization Register Patients (Active)" Q
 .I BIUP="u" S X=X_"User Population (1 visit, 3 yrs)" Q
 .I BIUP="a" S X=X_"Active Users (2+ visits, 3 yrs)" Q
 D WRITE(.BILINE,X,1)
 K X
 ;
 ;---> Finish up Listmanager List Count.
 S VALMCNT=BILINE
 S BIRTN="BIREPL"
 Q
 ;
 ;
 ;----------
WRITE(BILINE,BIVAL,BIBLNK) ;EP
 ;---> Write lines to ^TMP (see documentation in ^BIW).
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# written.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;     3 - BIBLNK (opt) Number of blank lines to add after line sent.
 ;
 Q:'$D(BILINE)
 D WL^BIW(.BILINE,"BIREPL",$G(BIVAL),$G(BIBLNK))
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> Update partition for return to Listmanager.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT Q
 ;
 ;
 ;----------
HELP ;EP
 ;---> Help code.
 N BIX S BIX=X
 D FULL^VALM1
 W !!?5,"Enter ""V"" to view this report on screen, ""P"" to print it,"
 W !?5,"or ""H"" to view the Help Text for this report and its parameters."
 D DIRZ^BIUTL3("","     Press ENTER/RETURN to continue")
 D:BIX'="??" RE^VALM4
 Q
 ;
 ;
 ;----------
HELP1 ;EP
 ;----> Explanation of this report.
 N BITEXT D TEXT1(.BITEXT)
 D START^BIHELP("ADULT IMMUNIZATION REPORT - HELP",.BITEXT)
 Q
 ;
 ;
 ;----------
TEXT1(BITEXT) ;EP
 ;;
 ;;
 D LOADTX("ADULT REPORT",,.BITEXT)
 Q
 ;
 ;
 ;----------
LOADTX(BILINL,BITAB,BITEXT) ;EP
 Q:$G(BILINL)=""
 ;N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 ;F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  S BITEXT(I)=T_$P(X,";;",2)
 NEW I,T,X,DIWR,Z,J,BIZ,BII,BIR
 S T="" S:'$D(BITAB) BITAB=5
 S BII=$O(^BIRPHTXT("B",BILINL,0))
 I 'BII S BITEXT(1)="Help text not available, notify IT." Q
 S BIR=80
 I BITAB S R=BITAB-1
 F J=1:1:BITAB S T=T_" "
 K ^UTILITY($J,"W")
 S BIZ=0 F  S BIZ=$O(^BIRPHTXT(BII,11,BIZ)) Q:BIZ'=+BIZ  S X=T_^BIRPHTXT(BII,11,BIZ,0)  D
 .S DIWL=0,DIWR=BIR D ^DIWP
 S J=0 S X=0 F  S X=$O(^UTILITY($J,"W",0,X)) Q:X'=+X  S J=J+1,BITEXT(J)=^UTILITY($J,"W",0,X,0)
 K ^UTILITY($J,"W")
 Q
 ;
 ;
 ;----------
EXIT ;EP
 ;---> End of job cleanup.
 D KILLALL^BIUTL8(1)
 K ^TMP("BIREPL",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
 ;
