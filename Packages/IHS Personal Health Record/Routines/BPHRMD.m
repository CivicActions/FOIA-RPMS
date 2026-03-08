BPHRMD ;GDIT/HCS/BEE-Med Refill History - task med details ; 09 Apr 2020  8:53 AM
 ;;2.1;IHS PERSONAL HEALTH RECORD;**6**;Apr 01, 2014;Build 6
 ;
EN ; -- main entry point for BPHR MED REFILL DETAIL
 ;
 NEW CONT,TEMP,AUTOSEL,NMBR
 ;
 S AUTOSEL="BPHR MED REFILL DETAIL SELECT"
 ;
 ;Write formfeed
 I $G(IOF)]"" W @IOF
 ;
 D EN^VALM("BPHR MED REFILL DETAIL")
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="Review BPHR Med Refill Task Detail"
 Q
 ;
PHDR ;
 S VALMSG="Select one entry"
 S XQORM("#")=$$FIND1^DIC(101,,"BX","BPHR MED REFILL MENU")
 D SHOW^VALM
 Q
 ;
INIT ; -- init variables and list array
 ;
 NEW SEL,MIEN,TIEN,LINE
 ;
 ;Define temp global
 S TEMP=$NA(^TMP("BPHRMD",$J))
 K @TEMP
 K ^TMP("VALMAR",$J,1)
 ;
 S VALMCAP=" Line Patient                         Drug                            "
 ;Mark the entry as selected
 S (LINE,VALMCNT)=0
 S SEL=$G(^TMP("BPHRMH",$J,"SELECTED")) I 'SEL W !!,"<No selected entry>" D AKEY^BPHRMH Q
 S TIEN=$P($G(^TMP("BPHRMH",$J,"LIST",SEL)),U,2) I 'TIEN W !!,"No TIEN found>" D AKEY^BPHRMH Q
 ;
 ;Loop through entries for that task
 S MIEN="" F  S MIEN=$O(^BPHRMREQ("M",TIEN,MIEN)) Q:MIEN=""  D
 . ;
 . NEW PAT,LINEVAR,XPAT,XDRUG
 . ;
 . ;Get patient
 . S PAT=+$$GET1^DIQ(90670.4,MIEN_",",.02,"I")
 . ;
 . ;If looking for specific patient, skip if not patient
 . I $D(^TMP("BPHRMH",$J,"PATIENT")),PAT'=$G(^TMP("BPHRMH",$J,"PATIENT")) Q
 . ;
 . S XPAT=$$GET1^DIQ(90670.4,MIEN_",",.02,"E") S:XPAT="" XPAT="<ISSUE WITH REFILL REQUEST>"
 . ;
 . ;Get drug
 . S XDRUG=$$GET1^DIQ(90670.4,MIEN_",",1.04,"E")
 . ;
 . S LINE=LINE+1
 . S LINEVAR=""
 . S LINEVAR=$$SETFLD^VALM1(LINE,LINEVAR,"LINE")
 . S LINEVAR=$$SETFLD^VALM1(XPAT,LINEVAR,"PATIENT")
 . S LINEVAR=$$SETFLD^VALM1(XDRUG,LINEVAR,"DRUG")
 . D SET^VALM10(LINE,LINEVAR)
 . S @TEMP@("LIST",LINE)=MIEN_U_LINE_U_PAT_U_XPAT
 . S VALMCNT=LINE
 Q
 ;
SEL ;
 ;
 NEW IRUN,TEMP,ND,DTOUT,DUOUT,DIROUT,DIRUT,X,Y,DIR,MIEN,DA,DIC
 ;
 ;Define temp global
 S TEMP=$NA(^TMP("BPHRMD",$J))
 ;
 I $P($G(NMBR),",")>0 S Y=$P(NMBR,",") G SKPASK
 S DIR(0)="NO^1:"_+$G(VALMLST)
 S DIR("A")="Select the entry to review"
 D ^DIR
 I (Y="")!(Y'>0) G XSEL
 I $G(DTOUT)!$G(DUOUT)!$G(DIROUT)!$G(DIRUT) G XSEL
 ;
SKPASK   ;Locate the entry
 ;
 S ND=$G(@TEMP@("LIST",+Y))
 S MIEN=$P(ND,U) I MIEN="" W !!,"<Entry could not be found>" D AKEY^BPHRMH G XSEL
 ;
 D FULL^VALM1
 ;
 ;Write formfeed
 I $G(IOF)]"" W @IOF
 ;
 ;Mark the entry as selected
 S @TEMP@("SELECTED")=MIEN
 S DA=+MIEN,DIC="^BPHRMREQ(" D EN^DIQ
 ;
 D AKEY^BPHRMH
 ;
 S VALMSG=""
XSEL K @TEMP@("SELECTED")
 ;
 K VALMY S VALMBCK="R" D DESELECT^BPHRMH(.SLCTLST)
 ;
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
VAR ;Initialize variables
 NEW SLCTLST,VALMBCK,VALMCAP,VALMCNT,VALMHDR,VALMLST,VALMST,XQORM,VALMSG
 Q
