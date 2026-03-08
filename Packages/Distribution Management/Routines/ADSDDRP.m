ADSDDRP ;GDIT/HS/AEF - PRINT DD CHECKSUM REPORTS;Apr 20, 2023
 ;;1.0;DISTRIBUTION MANAGEMENT;**5,6**;Apr 23, 2020;Build 8
 ;
 ;New routine  
 ;Feature 80489 Mechanism to compare data dictionaries
 ;on a local instance to a standard image.
 ;
DESC ;----- ROUTINE DESCRIPTION
 ;;
 ;;This routine prints a list of data dictionaries and their checksums.
 ;;The checksum differences between the DTS "gold database" and the
 ;;local database are stored in the ADS DATA DICTIONARIES file.
 ;;The report lists the differences in three different sections:
 ;;1. DD entries in both RPMS and DTS with different CS values
 ;;2. DD entries in DTS, but not in RPMS (missing data dictionaries)
 ;;3. DD entries in RPMS, but not in DTS (local data dictionaries)
 ;; 
 ;;NOTE:  This report may take a few minutes to print.
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
 S XBRP="RPT^ADSDDRP"
 S XBRC="GET^ADSDDRP"
 S XBRX="XIT^ADSDDRP"
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
 ;Global format:
 ;^TMP("ADSDD",$J,TYPENAME,1,NAME)=NAME^FILENUM^FILENAME^FLDNUM^FLDNAME^LOCRSUM^LOCDT^DTSRSUM^DTSDT^TYPE
 ;
 N ADSD,CNT,IEN
 ;
 K ^TMP("ADSDD",$J)
 K ^TMP("ADSDDFF",$J)
 S CNT=0
 ;
 ;Build ADSD array containing excluded files:
 D NOFILE^ADSDDCS(.ADSD)  ;IHS/GDIT/AEF ADS*1.0*6 FID110410
 ;
 ;LOOP THRU ^ADSDD GLOBAL
 S IEN=0
 F  S IEN=$O(^ADSDD(IEN)) Q:'IEN  D
 . D ONE(IEN)
 . S CNT=CNT+1
 . ;
 . I '$D(ZTUEUED) W:'(CNT#1000) "."
 ;
 Q
ONE(IEN) ;
 ;----- PROCESS ONE DD
 ;
 N DATA,LOC,LOCDT,NAME,ZDTS,ZDTSDT
 ;
 S DATA=$G(^ADSDD(IEN,0))
 S NAME=$P(DATA,U)
 Q:NAME']""
 ;Don't include Lab files 63.04, 63.05:
 Q:$$NTF^ADSDDCS($P(NAME,":"))  ;IHS/GDIT/AEF ADS*1.0*6 FID110410
 S LOC=$P($G(^ADSDD(IEN,1)),U)
 ;S LOCDT=""
 ;I LOC S LOCDT=$P($G(^ADSDD(IEN,1)),U,2)
 S LOCDT=$P($G(^ADSDD(IEN,1)),U,2)
 I LOCDT S LOCDT=$$FMTE^XLFDT(LOCDT,5)
 S ZDTS=$P($G(^ADSDD(IEN,2)),U)
 S ZDTSDT=""
 I ZDTS S ZDTSDT=$P($G(^ADSDD(IEN,2)),U,2)
 I ZDTSDT S ZDTSDT=$$FMTE^XLFDT(ZDTSDT,5)
 ;Q:'LOC&('ZDTS)
 S $P(DATA,U,6)=LOC
 S $P(DATA,U,7)=LOCDT
 S $P(DATA,U,8)=ZDTS
 S $P(DATA,U,9)=ZDTSDT
 ;
 ;Both checksums match (1):
 I LOC,ZDTS,LOC=ZDTS D
 . D SETGLOB(1,"ZMATCH",NAME,DATA)
 ;
 ;Both have checksums, but don't match (2):
 I LOC,ZDTS,LOC'=ZDTS D
 . D SETGLOB(2,"MISMATCH",NAME,DATA)
 ;
 ;Only has ZDTS checksum (missing routines) (3):
 I 'LOC,ZDTS D
 . D SETGLOB(3,"DTSONLY",NAME,DATA)
 ;
 ;Only has local checksum (local routines)(4):
 I LOC,'ZDTS D
 . D SETGLOB(4,"LOCONLY",NAME,DATA)
 ;
 Q
SETGLOB(TYPE,TNAME,NAME,DATA) ;
 ;
 N FILE,FLD
 ;
 S ^TMP("ADSDD",$J,TNAME,1,NAME)=DATA_U_TYPE
 S ^TMP("ADSDD",$J,TNAME,0)=$G(^TMP("ADSDD",$J,TNAME,0))+1
 S FILE=$P(NAME,":"),FLD=$P(NAME,":",2)
 I 'FLD S ^TMP("ADSDDFF",$J,TNAME,FILE)=DATA_U_TYPE
 I FLD S ^TMP("ADSDDFF",$J,TNAME,FILE,FLD)=DATA_U_TYPE
 Q
RPT ;
 ;----- PRINT CHECKSUM REPORT
 ;Call after GET has been called to gather the data for the report
 ;
 N DIR,DIRUT,DIROUT,PAGE,OUT,TYPE,X,Y
 ;
 S (OUT,PAGE)=0
 ;
 ;Set TYPE array:
 S TYPE("MISMATCH")="CHECKSUM MISMATCHES"
 S TYPE("DTSONLY")="MISSING DDS"
 S TYPE("LOCONLY")="LOCAL DDS (NOT IN DTS)"
 ;
 ;Write initial header
 D HDR(.PAGE,.OUT)
 Q:OUT
 ;
 ;If no data found:
 I '$D(^TMP("ADSDDFF",$J)) D
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
 K ^TMP("ADSDD",$J)
 K ^TMP("ADSDDFF",$J)
 ;
 Q
LIST(TYPE,PAGE,OUT) ;
 ;----- PRINT REPORT
 ;
 N DATA,FILE,FLD,NAME
 ;
 W !!,TYPE(TYPE)_":"
 ;
 ;Loop thru ^TMP global and print data:
 S FILE=0
 F  S FILE=$O(^TMP("ADSDDFF",$J,TYPE,FILE)) Q:'FILE  D  Q:OUT
 . I $Y>(IOSL-5) D HDR(.PAGE,.OUT)
 . Q:OUT
 . S DATA=$G(^TMP("ADSDDFF",$J,TYPE,FILE))
 . I DATA]"" D WRITE1(DATA)
 . S FLD=0
 . F  S FLD=$O(^TMP("ADSDDFF",$J,TYPE,FILE,FLD)) Q:'FLD  D  Q:OUT
 . . I $Y>(IOSL-5) D HDR(.PAGE,.OUT)
 . . Q:OUT
 . . S DATA=^TMP("ADSDDFF",$J,TYPE,FILE,FLD)
 . . D WRITE2(DATA)
 ;
 Q:OUT
 W !,"TOTAL "_TYPE(TYPE)_":  "_+$G(^TMP("ADSDD",$J,TYPE,0))
 ;
 Q
WRITE1(DATA) ;
 ;-----WRITE THE FILE DATA
 ;
 W !,$P(DATA,U,2)
 W ?30,$E($P(DATA,U,3),1,29)
 W ?62,$P(DATA,U,6)
 W ?72,$P(DATA,U,8)
 ;
 Q
WRITE2(DATA) ;
 ;----- WRITE THE FIELD DATA
 ;
 W !,$P(DATA,U,2)_","_$P(DATA,U,4)
 W ?30,$E($P(DATA,U,5),1,29)
 W ?62,$P(DATA,U,6)
 W ?72,$P(DATA,U,8)
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
 W !,"DATA DICTIONARY CHECKSUM VALUES"
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
 S Y="FILE,FLD NUM"
 S $E(Y,31)="FILE/FLD NAME"
 S $E(Y,63)="LOC RSUM"
 S $E(Y,73)="DTS RSUM"
 ;
 Q Y
XIT ;
 ;
 K ^TMP("ADSDD",$J)
 K ^TMP("ADSDDFF",$J)
 ;
 Q
