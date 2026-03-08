BLRLOINC ;IHS/OIT/MKK - IHS LAB LOINC REPORT ; [ 12/19/2002  7:25 AM ]
 ;;5.2;IHS LABORATORY;**1024,1054**;NOV 01, 1997;Build 20
 ;;
 ;; MSC/MKK - Modification - LR*5.2*1054 - Analyze Cosmic tests also.  Tweak logic.
 ;;
 ;;
EEP ; Ersatz EP
 W !!
 W ">>>>>>>>>>>>"
 W " USE LABEL "
 W "<<<<<<<<<<<<"
 W !!
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1054
 W $C(7),$C(7),$C(7),!
 W ?9,$$SHOUTMSG^BLRGMENU("Must use Line Labels to access subroutines",60)
 W $C(7),$C(7),$C(7),!
 ; ----- END IHS/MSC/MKK - LR*5.2*1054
 Q
 ;
EP ; EP -- Main Entry Point
PEP ; EP - Another Entry Point    ; IHS/MSC/MKK - LR*5.2*1054
 ; NEW CNTLOINC,PTRLOINC,CNTLT,CNTZZ
 ; NEW QFLG,SITESPEC,STR
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)     ; IHS/MSC/MKK - LR*5.2*1054
 ;
 D COMLOINC         ; Count Lab Tests with LOINC Codes
 ;
 D REPORT           ; Output Results
 ;
 Q
 ;
COMLOINC ; EP - Compile Listing of Tests with LOINC Codes
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1054
 D SETBLRVS
 S HEADER(1)="Logical Observation Identifiers"
 S HEADER(2)="Names and Codes (LOINC)"
 D HEADERDT^BLRGMENU
 W ?4,"Counting"
 ; ----- END IHS/MSC/MKK - LR*5.2*1054
 ;
 ; S (CNTLOINC,FLAG,CNTLT,TEST,CNTZZ)=0
 S (CNTLOINC,CNTNLOI,FLAG,CNTLT,TEST,CNTZZ)=0    ; IHS/MSC/MKK - LR*5.2*1054
 F  S TEST=$O(^LAB(60,TEST))  Q:TEST=""!(TEST'?.N)  D
 . S CNTLT=CNTLT+1                 ; Count # of Lab Tests in dictionary
 . ;
 . I (CNTLT#100)=0 W "."  W:$X>74 !,?4
 . ;
 . ; Count # of Lab Tests that have a Name that begin with Two Z's
 . ; I $E($P($G(^LAB(60,TEST,0)),"^",1),1,2)="ZZ" S CNTZZ=CNTZZ+1
 . I $$UP^XLFSTR($E($P($G(^LAB(60,TEST,0)),"^",1),1,2))="ZZ" S CNTZZ=CNTZZ+1   ; IHS/MSC/MKK - LR*5.2*1054
 . ;
 . ; LOINC Codes are stored in the SITE/SPECIMEN multiple, so have to
 . ; go through the multiple and determine if there is a LOINC Code.  
 . ; NOTE: to "qualify" as a LOINC'ed test, ALL Site/Specimen entries must have a LOINC.  ; IHS/MSC/MKK - LR*5.2*1054
 . ; S (FLAG,SITESPEC)=0
 . ; F  S SITESPEC=$O(^LAB(60,TEST,1,SITESPEC))  Q:SITESPEC=""!(SITESPEC'?.N)!(FLAG)  D
 . ; . I +$G(^LAB(60,TEST,1,SITESPEC,95.3))>0  S FLAG=1     ; LOINC
 . ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1054
 . S (CNTL,SITESPEC,SSCNT)=0
 . F  S SITESPEC=$O(^LAB(60,TEST,1,SITESPEC))  Q:SITESPEC=""!(SITESPEC'?.N)  D
 .. S SSCNT=SSCNT+1
 .. I +$G(^LAB(60,TEST,1,SITESPEC,95.3))>0 S CNTL=CNTL+1
 . ; ----- END IHS/MSC/MKK - LR*5.2*1054
 . ;
 . ; I FLAG S CNTLOINC=CNTLOINC+1
 . ;
 . ; ----- BEGIN IHS/MSC/MKK -- LR*5.2*1054
 . I $$GET1^DIQ(60,TEST,"SUBSCRIPIT","I")'="CH" D  Q
 .. I $$GET1^DIQ(60,TEST,999999902,"I") S CNTLOINC=CNTLOINC+1
 .. E  S CNTNLOI=CNTNLOI+1
 . ;
 . ; At this point, tests are "CH" subscripted.
 . ; If a panel, LOINC stored in the IHS LOINC field
 . I $$ISPANEL^BLRPOC(TEST) D  Q
 .. I $$GET1^DIQ(60,TEST,999999902,"I") S CNTLOINC=CNTLOINC+1
 .. E  S CNTNLOI=CNTNLOI+1
 . ;
 . ; Store Site/Specimen if no LOINC
 . K SITESPEC
 . S SITESPEC=0
 . F  S SITESPEC=$O(^LAB(60,TEST,1,SITESPEC))  Q:SITESPEC<1  D
 .. I $$GET1^DIQ(60.01,SITESPEC_","_TEST,95.3,"I")<1 S SITESPEC(SITESPEC)=""
 . ;
 . ; If ALL Site/Specimens have LOINCS, then count test as being "LOINCed"
 . I $O(SITESPEC(0))<1 S CNTLOINC=CNTLOINC+1  Q
 . ;
 . ; Not ALL Site/Specimens have LOINCs.  Count test as being non-LOINCed.
 . S CNTNLOI=CNTNLOI+1
 ;
 W !!
 D PRESSKEY^BLRGMENU
 W !!
 ; ----- END IHS/MSC/MKK -- LR*5.2*1054
 ;
 Q
 ;
REPORT ; EP - Results
 NEW LN,LRLRPT,TAB,TFLAG
 ;
 D BUILDARY        ; Build the Array
 ;
 D REPORTIT        ; Output the results
 ;
 Q
 ;
BUILDARY ; EP
 NEW NOLOINC
 ;
 S NOLOINC=CNTLT-CNTLOINC
 ;
 S TAB=$J("",5)
 S LN=0
 D ADDLNCJ($$LOC^XBFUNC,.LN)
 D ADDLNCJ("Logical Observation Identifiers",.LN,"YES","YES")
 D ADDLNCJ("Names and Codes (LOINC)",.LN)
 D ADDLNCJ("IHS Percentages Report",.LN)
 D ADDLNCJ($TR($J("",IOM)," ","-"),.LN)
 ;
 D ADDLINE(" ",.LN)
 ; D ADDLINE("Number of Lab Tests in Dictionary = "_CNTLT,.LN)
 D ADDLINE(TAB_"Number of Lab Tests in Dictionary = "_CNTLT,.LN)     ; IHS/MSC/MKK - LR*5.2*1054
 D ADDLINE(" ",.LN)
 ;
 I CNTLOINC<1 D
 . D ADDLINE(TAB_"Not a single Lab Test has a LOINC Code",.LN)
 . D ADDLINE(" ",.LN)
 ;
 I +$G(CNTZZ)>0 D
 . ; D ADDLINE(TAB_"Number of ZZ'ed Lab Tests in Dictionary = "_CNTZZ,.LN)
 . D ADDLINE(TAB_TAB_"Number of ZZ'ed Lab Tests in Dictionary = "_CNTZZ,.LN)   ; IHS/MSC/MKK - LR*5.2*1054
 . D ADDLINE(" ",.LN)
 ;
 D ADDLINE(TAB_"Number of Lab Tests in Dictionary with LOINC codes = "_CNTLOINC,.LN)
 D ADDLINE(" ",.LN)
 ;
 ; D ADDLINE(TAB_"Number of Lab Tests in Dictionary without LOINC codes = "_NOLOINC,.LN)
 D ADDLINE(TAB_"Number of Lab Tests in Dictionary without LOINC codes = "_CNTNLOI,.LN)   ; IHS/MSC/MKK - LR*5.2*1054
 D ADDLINE(" ",.LN)
 ;
 D ADDLINE(TAB_"Percentage of Lab Tests in File 60 with LOINC codes = "_($FN((CNTLOINC/CNTLT),"",3)*100)_"%",.LN)
 D ADDLINE(" ",.LN)
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1054 - Just comment out the following lines
 ; I (CNTLT-CNTZZ)>0 D
 ; . D ADDLINE(TAB_"Percentage of Non ZZ'ed Lab Tests in File 60 with LOINC codes = "_($FN((CNTLOINC/(CNTLT-CNTZZ)),"",3)*100)_"%",.LN)
 ; . D ADDLINE(" ",.LN)
 ; ----- END IHS/MSC/MKK - LR*5.2*1054
 Q
 ;
ADDLNCJ(MIDSTR,LN,LEFTSTR,RGHTSTR) ; EP
 S LN=LN+1
 S LRLRPT(LN)=$$CJ^XLFSTR(MIDSTR,IOM)
 ;
 ; Today's Date
 S:$G(LEFTSTR)'="" $E(LRLRPT(LN),1,13)="Date:"_$$HTE^XLFDT($H,"2DZ")
 ;
 ; Current Time
 S:$G(RGHTSTR)'="" $E(LRLRPT(LN),IOM-15)=$J("Time:"_$$UP^XLFSTR($P($$HTE^XLFDT($H,"2MPZ")," ",2,3)),16)
 ;
 ; Trim extra spaces
 S:$G(LEFTSTR)'=""!($G(RGHTSTR)'="") LRLRPT(LN)=$$TRIM^XLFSTR(LRLRPT(LN),"R"," ")
 ;
 Q
 ;
ADDLINE(ADDSTR,LN) ; EP
 S LN=LN+1
 S LRLRPT(LN)=$$LJ^XLFSTR(ADDSTR,IOM)
 Q
 ;
REPORTIT ; EP
 S %ZIS="Q"
 D ^%ZIS
 I POP D
 . W !!,?10,"DEVICE could not be selected.  Output will be to the screen.",!!
 ;
 I $D(IO("Q")) D  Q
 . S ZTRTN="DQ^BLRLOINC",ZTDESC="IHS LOINC Percentage Report"
 . S ZTSAVE("LR*")=""
 . S ZTSAVE("CNT*")=""
 . D ^%ZTLOAD,^%ZISC
 . W !,"Request ",$S($G(ZTSK):"Queued - Task #"_ZTSK,1:"NOT Queued"),!!
 . D BLREND
 . D PRESSIT
 ;
DQ ; EP
 ;
 U IO
 I $E(IOST,1,2)="C-" D ^XBCLS            ; If terminal, clear sceen & home cursor
 ; I IOST'["C-VT" W @IOF                 ; Form Feed if not terminal
 ;
 D EN^DDIOL(.LRLRPT)                     ; Display the array
 ;
 I $D(ZTQUEUED) Q                        ; If Queued, QUIT
 ;
 D ^%ZISC                                ; Close all the devices
 D PRESSIT
 ;
 Q
 ;
 ; Just Prompt and quit
PRESSIT ; EP
 D ^XBFMK
 S DIR("A")=$J("",10)_"Press RETURN Key"
 S DIR(0)="FO^1:1"
 D ^DIR
 Q
 ;
 ; Called when Queued
BLREND ; EP
 I $E(IOST,1,2)="P-" W @IOF
 I $D(ZTQUEUED) S ZTREQ="@"
 E  D ^%ZISC
 D KVA^VADPT
 Q
 ;
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1054
 ; ============================= UTILITIES =============================
 ;
JUSTNEW ; EP
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 Q
 ;
SETBLRVS(TWO) ; EP - Set the BLRVERN variable(s)
 K BLRVERN,BLRVERN2
 ;
 S BLRVERN=$P($P($T(+1),";")," ")
 S:$L($G(TWO)) BLRVERN2=$G(TWO)
 Q
 ;
 ; ----- END IHS/MSC/MKK - LR*5.2*1054
