ADSRTNRP ;GDIT/HS/AEF - PRINT ROUTINE CHECKSUM REPORTS; May 18, 2022
 ;;1.0;DISTRIBUTION MANAGEMENT;**4**;Apr 23, 2020;Build 24
 ;New Routine:  Feature 82446 Mechanism to compare routines on a local instance
 ;to a standard image.
 ;
DESC ;----- ROUTINE DESCRIPTION
 ;;
 ;;This routine prints a list of routines and their checksums.
 ;;The routines in the ^ROUTINE global are compared with the 
 ;;routines in the ADS ROUTINES file and differences are printed
 ;;in three different sections:
 ;;1. Routines in both RPMS and DTS with different CS values
 ;;2. Routines in DTS, but not in RPMS (missing routines)
 ;;3. Routines in RPMS, but not in DTS (local routines)
 ;;
 ;;$$END
 ;
 N I,X F I=1:1 S X=$P($T(DESC+I),";;",2) Q:X["$$END"  D EN^DDIOL(X)
 Q
 ;
EN ;EP  -- MAIN ENTRY POINT
 ;
 N DIR,DIROUT,DIRUT,TYPE,OUT,X,XBHDR,XBIOP,XBRC,XBRP,XBRX,Y
 ;
 S OUT=0
 D ^XBKVAR
 D HOME^%ZIS
 ;
 D DESC
 ;
 ;Ask if print or browse:
 S DIR(0)="S^P:PRINT;B:BROWSE"
 S DIR("A")="Do you wish to"
 S DIR("B")="P"
 D ^DIR
 I $D(DIRUT)!($D(DIROUT))!(Y[U) S OUT=1
 Q:OUT
 S TYPE=Y
 ;
 ;Set variables for printing via ^XBDBQUE:
 S XBRP="RPT^ADSRTNRP"
 S XBRC="GET^ADSRTNRP"
 S XBRX="XIT^ADSRTNRP"
 ;
 ;Set browser variables:
 I TYPE="B" D
 . S XBHDR=$$HDR1
 . S XBRP="VIEWR^XBLM("_""""_XBRP_""""_","_""""_XBHDR_""""_")"
 . S XBIOP=0
 ;
 ;Browse/print:
 I "PB"[$G(TYPE) D ^XBDBQUE
 ;
 Q
GET ;
 ;----- CREATE GLOBAL WITH CHECKSUM MATCHES/MISMATCHES
 ;
 N IEN
 ;
 K ^TMP("ADSROU",$J)
 ;
 ;LOOP THRU ^ADSROU GLOBAL
 S IEN=0
 F  S IEN=$O(^ADSROU(IEN)) Q:'IEN  D
 . D ONE(IEN)
 ;
 Q
ONE(IEN) ;
 ;----- PROCESS ONE ROUTINE
 ;
 N LOC,LOCDT,ROU,ZDTS,ZDTSDT
 ;
 ;Quit if it is an init routine:
 Q:$$GET1^DIQ(9002293.1,IEN_",",.02,"I")
 ;
 S ROU=$P($G(^ADSROU(IEN,0)),U)
 Q:ROU']""
 S LOC=$P($G(^ADSROU(IEN,1)),U)
 S LOCDT=""
 I LOC S LOCDT=$P($G(^ADSROU(IEN,1)),U,2)
 I LOCDT S LOCDT=$$FMTE^XLFDT(LOCDT,5)
 S ZDTS=$P($G(^ADSROU(IEN,2)),U)
 S ZDTSDT=""
 I ZDTS S ZDTSDT=$P($G(^ADSROU(IEN,2)),U,2)
 I ZDTSDT S ZDTSDT=$$FMTE^XLFDT(ZDTSDT,5)
 Q:'LOC&('ZDTS)
 ;
 ;Both checksums match (1):
 I LOC,ZDTS,LOC=ZDTS D
 . S ^TMP("ADSROU",$J,"ZMATCH",1,ROU)=IEN_U_LOC_U_LOCDT_U_ZDTS_U_ZDTSDT_U_1
 . S ^TMP("ADSROU",$J,"ZMATCH",0)=$G(^TMP("ADSROU",$J,"ZMATCH",0))+1
 ;
 ;Both have checksums, but don't match (2):
 I LOC,ZDTS,LOC'=ZDTS D
 . S ^TMP("ADSROU",$J,"MISMATCH",1,ROU)=IEN_U_LOC_U_LOCDT_U_ZDTS_U_ZDTSDT_U_2
 . S ^TMP("ADSROU",$J,"MISMATCH",0)=$G(^TMP("ADSROU",$J,"MISMATCH",0))+1
 ;
 ;Only has ZDTS checksum (missing routines) (3):
 I 'LOC,ZDTS D
 . S ^TMP("ADSROU",$J,"DTSONLY",1,ROU)=IEN_U_LOC_U_LOCDT_U_ZDTS_U_ZDTSDT_U_3
 . S ^TMP("ADSROU",$J,"DTSONLY",0)=$G(^TMP("ADSROU",$J,"DTSONLY",0))+1
 ;
 ;Only has local checksum (local routines)(4):
 I LOC,'ZDTS D
 . S ^TMP("ADSROU",$J,"LOCONLY",1,ROU)=IEN_U_LOC_U_LOCDT_U_ZDTS_U_ZDTSDT_U_4
 . S ^TMP("ADSROU",$J,"LOCONLY",0)=$G(^TMP("ADSROU",$J,"LOCONLY",0))+1
 ; 
 Q
RPT ;
 ;----- CHECKSUM REPORT
 ;
 N DIR,DIRUT,DIROUT,PAGE,OUT,TYPE,X,Y
 ;
 S (OUT,PAGE)=0
 ;
 ;Set TYPE array:
 S TYPE("MISMATCH")="CHECKSUM MISMATCHES"
 S TYPE("DTSONLY")="MISSING ROUTINES"
 S TYPE("LOCONLY")="LOCAL ROUTINES (NOT IN DTS)"
 ;
 ;Write initial header
 D HDR(.PAGE,.OUT)
 Q:OUT
 ;
 ;If no data found:
 I '$D(^TMP("ADSROU",$J)) D
 . W !!,"NO DATA FOUND!"
 . S OUT=1
 Q:OUT
 ;
 ;Loop through the ^TMP global types:
 F TYPE="MISMATCH","DTSONLY","LOCONLY" D  Q:OUT
 . D LIST(.TYPE,.PAGE,.OUT)
 Q:OUT
 ;
 ;End of report, final out to pause before returning to menu:
 I $E(IOST)="C",$G(PAGE) D
 . K DIR
 . S DIR(0)="E"
 . D ^DIR
 ;
 Q
LIST(TYPE,PAGE,OUT) ;
 ;----- PRINT REPORT
 ;
 N DATA,ROU
 ;
 ;Loop thru ^TMP global and print data:
 W !!,TYPE(TYPE)_":"
 S ROU=""
 F  S ROU=$O(^TMP("ADSROU",$J,TYPE,1,ROU)) Q:ROU']""  D  Q:OUT
 . I $Y>(IOSL-5) D HDR(.PAGE,.OUT)
 . Q:OUT
 . S DATA=^TMP("ADSROU",$J,TYPE,1,ROU)
 . Q:DATA']""
 . W !,ROU
 . W ?16,$P(DATA,U,2)
 . W ?30,$P(DATA,U,3)
 . W ?44,$P(DATA,U,4)
 . W ?58,$P(DATA,U,5)
 Q:OUT
 W !,"TOTAL "_TYPE(TYPE)_":  "_+$G(^TMP("ADSROU",$J,TYPE,0))
 ;
 Q
HDR(PAGE,OUT) ;
 ;----- PRINT PAGE HEADER
 ;
 N DIR,DIROUT,DIRUT,I,X,Y
 ;
 Q:$D(XBHDR)
 ;
 I $E(IOST)="C",$G(PAGE) D
 . S DIR(0)="E"
 . D ^DIR
 . I 'Y S OUT=1
 Q:$G(OUT)
 ;
 S PAGE=$G(PAGE)+1
 W @IOF
 ;
 W !,"ROUTINE CHECKSUM VALUES"
 W ?45,$$FMTE^XLFDT($$NOW^XLFDT)
 W "    PAGE ",$J(PAGE,2)
 W !
 W $$HDR1
 W !
 F I=1:1:IOM W "-"
 ;
 Q
HDR1() ;
 ;----- SET BROWSER HEADER
 ;
 N Y
 ;
 S Y="ROUTINE"
 S $E(Y,17)="LOCAL RSUM"
 S $E(Y,31)="L RSUM DT"
 S $E(Y,45)="DTS RSUM"
 S $E(Y,59)="D RSUM DT"
 ;
 Q Y
XIT ;
 ;
 K ^TMP("ADSROU",$J)
 ;
 Q
