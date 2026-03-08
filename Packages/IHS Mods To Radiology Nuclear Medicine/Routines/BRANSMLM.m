BRANSMLM ;IHS/MSC/MKK IHS/OIT/NST - IHS RAD List Manager Routine ; 01 Aug 2024 10:24 AM
 ;;5.0;Radiology/Nuclear Medicine;**1012**;Mar 16, 1998;Build 1
 ;;
 Q
 ;
EN(ICDFLAG) ; -- main entry point for BLR SNOMED SELECT
 S ICDFLAG=$G(ICDFLAG,0)
 D EN^VALM("BRA SNOMED SELECT")
 Q
 ;
SELECT ; EP - Do the Selection
 N X
 K DIR
 S DIR(0)="N^"_VALMBG_":"_VALMLST_":0"
 D ^DIR
 I $G(X)="^^^^^"  S Y=99999999  G QUIT     ; Trick to exit
 S WHICHONE=+$G(Y)
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$G(^TMP("BRA SNOMED GET",$J,"HDR"))
 Q
 ;
INIT ; -- init variables and list array
 N LINE,LINEVAR,NUM,SNOMEDSC,ICDCODE
 S (LINE,NUM)=0
 F  S NUM=$O(VARS(NUM))  Q:NUM<1  D
 . ; If ICDFLAG, then SNOMED must also have an ICD CODE associated with it
 . Q:ICDFLAG&($L($G(VARS(NUM,"ICD",1,"COD")))<1&($L($G(VARS(NUM,"10D",1,"COD")))<1))
 . ;
 . S SNOMED=$G(VARS(NUM,"PRB","DSC"))
 . S SNOMEDSC=$G(VARS(NUM,"PRB","TRM"))
 . S ICDCODE=$G(VARS(NUM,"ICD",1,"COD"))
 . ;
 . S LINE=LINE+1
 . ;
 . S LINEVAR=""
 . S LINEVAR=$$SETFLD^VALM1($J(LINE,2)_") "_SNOMED,LINEVAR,"SNOMED")
 . S LINEVAR=$$SETFLD^VALM1(SNOMEDSC,LINEVAR,"SNOMED DESCRIPTION")
 . S LINEVAR=$$SETFLD^VALM1(ICDCODE,LINEVAR,"ICD")
 . ;
 . D SET^VALM10(LINE,LINEVAR)
 . S SNOMED(LINE)=SNOMED_"^"_SNOMEDSC_"^"_ICDCODE
 . Q
 S VALMCNT=LINE
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
 ;
QUIT ; EP -
 ;
 D CLEAR^VALM1
 K SNOMED,DA
 Q
