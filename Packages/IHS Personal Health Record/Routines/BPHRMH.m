BPHRMH ;GDIT/HCS/BEE-Med Refill History - task list ; 09 Apr 2020  8:53 AM
 ;;2.1;IHS PERSONAL HEALTH RECORD;**6**;Apr 01, 2014;Build 6
 ;
EN ; -- main entry point for BPHR MED REFILL HISTORY
 ;
 NEW CONT,TEMP,AUTOSEL,NMBR,DIR,X,Y,VALMEVL
 ;
 S AUTOSEL=""
 ;
 ;Write formfeed
 I $G(IOF)]"" W @IOF
 ;
 ;Define temp global
 S TEMP=$NA(^TMP("BPHRMH",$J))
 K @TEMP
 ;
 ;Get earliest date
 S CONT=$$RDT(TEMP) I CONT'=1 Q
 ;
 ;See if filtering on successful 0 refills
 S CONT=$$SKPZ(TEMP) I CONT'=1 Q
 ;
 ;See if they want to filter by patient
 S CONT=$$GETPT(TEMP) I CONT=-1 Q
 ;
 D EN^VALM("BPHR MED REFILL HISTORY")
 Q
 ;
HDR ; -- header code
 ;
 S VALMHDR(1)="Review BPHR Med Refill Request History"
 ;
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
 NEW TEMP,LINE,TDT,TIEN,BEGIN
 ;
 ;Define temp global
 S TEMP=$NA(^TMP("BPHRMH",$J))
 K @TEMP@("LIST")
 K ^TMP("VALMAR",$J,0)
 ;
 ;Define header
 S VALMCAP=" Line    Task Run Date/Time  Ref Count Error Message                         "
 ;
 ;Loop through task entries
 S BEGIN=$G(@TEMP@("BEGIN"))
 S (LINE,VALMCNT)=0
 S TDT="" F  S TDT=$O(^BPHRMTSK("B",TDT),-1) Q:TDT<=BEGIN  D
 . S TIEN="" F  S TIEN=$O(^BPHRMTSK("B",TDT,TIEN),-1) Q:TIEN=""  D
 .. ;
 .. NEW COUNT,LINEVAR,ERROR
 .. ;
 .. ;Get the count
 .. S COUNT=$$GET1^DIQ(90670.3,TIEN_",",.02,"I")
 .. ;
 .. ;If patient specific, update counts
 .. I $G(@TEMP@("PATIENT")) D
 ... NEW IEN
 ... S COUNT=0
 ... S IEN="" F  S IEN=$O(^BPHRMREQ("TP",TIEN,@TEMP@("PATIENT"),IEN)) Q:'IEN  S COUNT=COUNT+1
 .. ;
 .. ;Get any error
 .. S ERROR=$$GET1^DIQ(90670.3,TIEN_",",2.01,"E")
 .. ;
 .. ;See if filtering out zero refills and no errors
 .. I $G(@TEMP@("ZFLTR")),'COUNT,ERROR="" Q
 .. ;
 .. ;If patient specific, skip if no patient refill
 .. I $G(@TEMP@("PATIENT")),'$D(^BPHRMREQ("TP",TIEN,@TEMP@("PATIENT"))) Q
 .. ;
 .. S LINE=LINE+1
 .. S LINEVAR=""
 .. S LINEVAR=$$SETFLD^VALM1(LINE,LINEVAR,"LINE")
 .. S LINEVAR=$$SETFLD^VALM1($$FMTE^XLFDT($E(TDT,1,12),"5ZY"),LINEVAR,"TASK RUN DATE/TIME")
 .. S LINEVAR=$$SETFLD^VALM1(COUNT,LINEVAR,"COUNT")
 .. S LINEVAR=$$SETFLD^VALM1(ERROR,LINEVAR,"ERRMSG")
 .. D SET^VALM10(LINE,LINEVAR)
 .. S @TEMP@("LIST",LINE)=TDT_U_TIEN_U_COUNT
 .. S VALMCNT=LINE
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
CHKSEL ;Evaluate selection if done by number
 N J,TMP,DIR,NUM,X,Y,TNMBR
 S VALMBCK="R"
 S NUM=$P($G(XQORNOD(0)),"=",2) ;get currently selected entries
 I NUM'="" D
 .I NUM=$G(NMBR) D DESELECT Q  ;If user selects same entry without taking an entry, unhighlight and stop processing
 .D DESELECT:$G(NMBR) ;If user previously selected entries but took no action, unhighlight before highlighting new choices
 .S NMBR=$P(XQORNOD(0),"=",2),DIR(0)="L^"_"1:"_VALMCNT,X=NMBR,DIR("V")="" D ^DIR K DIR
 .I $L(Y,",")>2 W !,"Please only select one entry." D AKEY K NMBR Q
 .I Y="" D FULL^VALM1 W !,"Invalid selection." D AKEY K NMBR Q  ;Selection out of range, stop processing
 .S TNMBR=""
 .F J=1:1:$L(NMBR,",")-1 S TMP=$P(NMBR,",",J) S TNMBR=TNMBR_TMP_"," D CNTRL^VALM10(TMP,1,+$G(VALMWD),IORVON,IORVOFF)
 .I TNMBR="" K NMBR Q
 .S NMBR=TNMBR
 ;
 ;See if AUTOSEL turned on for this template
 I +$P($G(NMBR),",")>0,$G(AUTOSEL)]"" D  Q
 . ;
 . NEW PROTOCOL,EXEC
 . ;
 . ;Get the protocol
 . S PROTOCOL=$O(^ORD(101,"B",AUTOSEL,"")) Q:PROTOCOL=""
 . ;
 . ;Get the ENTRY ACTION
 . S EXEC=$G(^ORD(101,PROTOCOL,20)) Q:EXEC=""
 . ;
 . ;Call it
 . D FULL^VALM1
 . W !!,$P($G(^ORD(101,PROTOCOL,0)),U,2)
 . X EXEC
 ;
 Q
 ;
DESELECT(SLCTLST) ;Un-highlight selected choices
 N J,TMP
 F J=1:1:$L($G(NMBR),",")-1 S TMP=$P(NMBR,",",J) D CNTRL^VALM10(TMP,1,+$G(VALMWD),IORVOFF,IORVOFF) K SLCTLST(TMP)
 S TMP="" F  S TMP=$O(SLCTLST(TMP)) Q:TMP=""  D CNTRL^VALM10(TMP,1,+$G(VALMWD),IORVOFF,IORVOFF) K SLCTLST(TMP)
 K NMBR
 Q
 ;
RDT(TEMP) ;Select the earliest run date
 ;
 NEW DIR,X,Y,DTOUT,DUOUT,DIROUT,DIRUT,X1,X2,PAST
 ;
 ;Get date 7 days ago
 S X1=DT,X2=-7 D C^%DTC
 S PAST=X
 ;
 S DIR(0)="D^:"_DT_":AEP"
 S DIR("B")=$$FMTE^XLFDT(PAST)
 S DIR("A")="Enter the earliest date to review"
 D ^DIR
 I $G(DTOUT)!$G(DUOUT)!$G(DIROUT) Q -1 ;Timed out or "^"
 I +$G(Y)>0 S @TEMP@("BEGIN")=+Y
 Q 1
 ;
SKPZ(TEMP) ;See if they want to filter out zero refills no errors
 ;
 NEW DIR,X,Y,DTOUT,DUOUT,DIROUT,DIRUT
 ;
 W !!
 S DIR(0)="Y"
 S DIR("B")="Yes"
 S DIR("A")="Skip tasks that ran with no refill requests or errors"
 D ^DIR
 I $G(DTOUT)!$G(DUOUT)!$G(DIROUT) Q -1 ;Timed out or "^"
 I +$G(Y)>0 S @TEMP@("ZFLTR")=1
 E  S @TEMP@("ZFLTR")=0
 Q 1
 ;
PATYN() ;See if they want to filter on a patient
 ;
 NEW DIR,X,Y,DTOUT,DUOUT,DIROUT,DIRUT
 ;
 W !!
 S DIR(0)="Y"
 S DIR("B")="No"
 S DIR("A")="See only tasks for a specific patient"
 D ^DIR
 I $G(DTOUT)!$G(DUOUT)!$G(DIROUT) Q -1 ;Timed out or "^"
 I +$G(Y)>0 Q 1
 E  Q 0
 Q 0
 ;
GETPT(TEMP) ;Return Patient
 ;
 NEW AUPNLK,APCDPAT,DIC,X,Y,CONT
 ;
 K @TEMP@("PATIENT")
 ;
 ;Check if they want to filter by patient
 S CONT=$$PATYN() I CONT'=1 Q CONT
 ;
 ;Get the patient
 D GETPAT^APCDDISP
 ;
 I '$G(APCDPAT) Q -1
 S @TEMP@("PATIENT")=APCDPAT
 ;
 Q 1
 ;
SEL ;
 ;
 NEW IRUN,TEMP,ND,DTOUT,DUOUT,DIROUT,DIRUT,X,Y,DIR,TIEN
 ;
 ;Define temp global
 S TEMP=$NA(^TMP("BPHRMH",$J))
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
 S TIEN=$P(ND,U,2) I TIEN="" W !!,"<Entry could not be found>" D AKEY G XSEL
 ;
 ;Mark the entry as selected
 S @TEMP@("SELECTED")=Y
 ;
 ;Display the detail
 D EN^BPHRMD
 ;
 S VALMSG=""
XSEL K @TEMP@("SELECTED")
 ;
 K VALMY S VALMBCK="R" D DESELECT(.SLCTLST)
 ;
 Q
 ;
HSEL ;
 ;
 NEW IRUN,TEMP,ND,DTOUT,DUOUT,DIROUT,DIRUT,X,Y,DIR,TIEN,DA,DIC
 ;
 ;Define temp global
 S TEMP=$NA(^TMP("BPHRMH",$J))
 ;
 I $P($G(NMBR),",")>0 S Y=$P(NMBR,",") G HSKPASK
 S DIR(0)="NO^1:"_+$G(VALMLST)
 S DIR("A")="Select the entry to review"
 D ^DIR
 I (Y="")!(Y'>0) G XHSEL
 I $G(DTOUT)!$G(DUOUT)!$G(DIROUT)!$G(DIRUT) G XHSEL
 ;
HSKPASK   ;Locate the entry
 ;
 S ND=$G(@TEMP@("LIST",+Y))
 S TIEN=$P(ND,U,2) I TIEN="" W !!,"<Entry could not be found>" D AKEY G XHSEL
 ;
 ;Mark the entry as selected
 S @TEMP@("SELECTED")=Y
 ;
 D FULL^VALM1
 ;
 ;Write formfeed
 I $G(IOF)]"" W @IOF
 ;
 ;Display the task entry
 S DA=TIEN,DIC="^BPHRMTSK(" D EN^DIQ
 ;
 D AKEY
 ;
 S VALMSG=""
XHSEL K @TEMP@("SELECTED")
 ;
 K VALMY S VALMBCK="R" D DESELECT(.SLCTLST)
 ;
 Q
 ;
AKEY ;Hit any key to continue
 NEW DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT,XQORNOD
 ;
 ;Prompt to continue
 W ! S DIR(0)="E",DIR("A")="Hit ENTER to continue" D ^DIR
 Q
 ;
 ;
VAR ;Initialize variables
 NEW AUTOSEL,IORVOFF,IORVON,VALMBCK,VALMCNT,VALMWD,XQORNOD,SLCTLST,NMBR,VALMCAP,VALMHDR
 NEW VALMLST,VALMSG,XQORM
 Q
