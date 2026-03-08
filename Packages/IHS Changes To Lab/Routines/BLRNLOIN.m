BLRNLOIN ;IHS/OIT/MKK - IHS LAB NO LOINC REPORT ; 01-Dec-2015 15:07 ; MKK
 ;;5.2;IHS LABORATORY;**1024,1054**;NOV 01, 1997;Build 20
 ;
 ; MSC/MKK - Modification - LR*5.2*1054 - Analyze Cosmic tests also.  Tweak logic.
 ;
EEP ; Ersatz EP
 ; W !!
 ; W ">>>>>>>>>>>>"
 ; W " USE LABEL "
 ; W "<<<<<<<<<<<<"
 ; W !!
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
 NEW CNTLOINC,PTRLOINC,CNTLT,CNTZZ,CNTNLOI
 NEW QFLG,SITESPEC,STR
 NEW LABTNME,NOLOINC
 ;
 D NCNTLNC         ; Count Lab Tests without LOINC Codes
 ;
 I CNTNLOI<1 D  Q
 . W !,"All Tests in File 60 Have LOINC Codes.",!
 . W "Program Finished",!!
 . D PRESSIT
 ;
 ; D REPORT          ; Output Results
 Q:$$REPORT()="Q"    ; Output Results -- IHS/MSC/MKK - LR*5.2*1054
 ;
 D PRESSIT         ; Press RETURN key
 ;
 Q
 ;
NCNTLNC ; EP -- Compile listing of tests without LOINC codes
 D NCNTLNCI        ; Initialize variables
 ;
 F  S TEST=$O(^LAB(60,TEST))  Q:TEST=""!(TEST'?.N)  D
 . ; Warm fuzzy to user
 . ; W "."         ; Comment out line -- IHS/MSC/MKK - LR*5.2*1054
 . ; I $X>78 W !   ; Comment out line -- IHS/MSC/MKK - LR*5.2*1054
 . ;
 . ; Skip all COSMIC tests  -- I don't belive you can LOINC panels
 . ; I +$O(^LAB(60,TEST,2,0))>0 Q
 . ;
 . S CNTLT=CNTLT+1                 ; Count # of Lab Tests in dictionary
 . ;
 . I (CNTLT#100)=0 W "."  I $X>74 W !,?4     ; IHS/MSC/MKK - LR*5.2*1054
 . ;
 . ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1054
 . I $$GET1^DIQ(60,TEST,.01)="" S CNTNNAME=1+CNTNNAME  ; Skip any test that does *NOT* have a Name.
 . ;
 . ; Count # of Lab Tests that have a Name that begin with Two Z's
 . ; I $E($P($G(^LAB(60,TEST,0)),"^",1),1,2)="ZZ" S CNTZZ=CNTZZ+1
 . I $$UP^XLFSTR($E($P($G(^LAB(60,TEST,0)),"^",1),1,2))="ZZ" S CNTZZ=CNTZZ+1   ; IHS/MSC/MKK - LR*5.2*1043
 . ;
 . ; If not a "CH" subscripted test, LOINC has to be stored in the IHS LOINC field
 . I $$GET1^DIQ(60,TEST,"SUBSCRIPT","I")'="CH" D  Q
 .. I $$GET1^DIQ(60,TEST,"IHS LOINC","I") S CNTLOINC=CNTLOINC+1
 .. E  D NOLOINIT(TEST)
 . ;
 . ; At this point, all are "CH" subscripted tests
 . ;
 . ; If a panel, LOINC stored in the IHS LOINC field.  Field was created after LR*5.2*1024.
 . I $$ISPANEL^BLRPOC(TEST) D  Q
 .. I +$$GET1^DIQ(60,TEST,"IHS LOINC","I")  S CNTLOINC=CNTLOINC+1
 .. E  D NOLOINIT(TEST)
 . ;
 . ; At this point, test is an ATOMIC test.
 . ; LOINCs are stored at the SITE/SPECIMEN level; all SITE/SPECIMEN entries must
 . ; have a LOINC in order for the test to be classified as begin LOINCed.
 . ;
 . K SITESPEC
 . S SITESPEC=0
 . F  S SITESPEC=$O(^LAB(60,TEST,1,SITESPEC))  Q:SITESPEC<1  D
 .. I $$GET1^DIQ(60.01,SITESPEC_","_TEST,95.3,"I")<1 S SITESPEC(SITESPEC)=""   ; Store non-LOINCed site/specimens
 . ;
 . ; If ALL Site/Specimens have LOINCs, then count test as being LOINCed.
 . ; I $O(SITESPEC(0))<1 S CNTLOINC=CNTLOINC+1
 . I $O(SITESPEC(0))<1 S CNTLOINC=CNTLOINC+1  Q   ; IHS/MSC/MKK - LR*5.2*1054
 . ;
 . ; Not ALL Site/Specimens have LOINCS.  Count test as non-LOINCed.
 . D NOLOINIT(TEST)
 ;
 W !,?4,"Compilation complete."
 W !!,?4,$FN(CNTLT,",")," LABORATORY TEST (#60) File entries analyzed."
 W:CNTZZ !!,?9,$FN(CNTZZ,",")," ZZ'ed entries."
 ; ----- END IHS/MSC/MKK - LR*5.2*1054
 Q
 ;
NCNTLNCI        ; EP -- Initialize variables
 W !
 S (CNTLOINC,FLAG,CNTLT,TEST,CNTZZ,CNTNLOI)=0
 S CNTNNAME=0
 ; D ^XBCLS
 ; W $$CJ^XLFSTR("Going through LAB TEST FILE (# 60)",IOM),!!
 D COMPHEAD   ; IHS/MSC/MKK - LR*5.2*1054
 Q
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1054
NOLOINIT(TEST) ; EP - Store & Count Non LOINCed test
 S NOLOINC($$GET1^DIQ(60,TEST,.01))=TEST
 S CNTNLOI=CNTNLOI+1
 Q
 ;
COMPHEAD ; EP - Compilation Header
 NEW HEADER
 ;
 S HEADER(1)="LABORATORY TEST (#60) File"
 S HEADER(2)="Tests Without LOINCs"
 D HEADERDT^BLRGMENU
 W ?4,"Compilation of data begins"
 Q
 ; ----- END IHS/MSC/MKK - LR*5.2*1054
 ;
 ;
REPORT() ; EP - Results
 NEW LN,LRLRPT,TAB,TFLAG
 NEW HEADER,PG,QFLAG,LINES,MAXLINES
 NEW STR                ; IHS/MSC/MKK - LR*5.2*1043
 ;
 ; I $$OKAYGO'="Y" Q      ; Want to go on?
 I $$OKAYGO'="Y" Q "Q"    ; Want to go on? -- IHS/MSC/MKK - LR*5.2*1054
 ;
 D BUILDARY             ; Build the array for output
 ;
 D REPORTIT             ; Output the results
 ;
 ; Q
 Q "OK"                 ; IHS/MSC/MKK - LR*5.2*1054
 ;
 ;
OKAYGO() ; EP
 W !!
 ; W "There are ",CNTNLOI," Lab Tests WITHOUT LOINC codes"
 W ?4,$FN(CNTNLOI,",")," LABORATORY TEST (#60) File entries WITHOUT LOINCs"   ; IHS/MSC/MKK - LR*5.2*1054
 W !!
 ; W ?5,"The Detailed report will be approximately ",(CNTNLOI\55)," printed pages long"
 ;
 W ?9,"The Detailed report will be approximately ",(CNTNLOI\46)," printed pages long."
 W !!,?9,"If printed to the screen, approximately ",(CNTNLOI\12)," 'pages' long."  ; IHS/MSC/MKK - LR*5.2*1054
 W !!
 D ^XBFMK
 ; S DIR("A")="Do you want to continue"
 S DIR("A")="     Do you want to continue"  ; IHS/MSC/MKK - LR*5.2*1054
 S DIR("B")="NO"
 S DIR(0)="YO"
 D ^DIR
 ; I $E($$UP^XLFSTR(X),1,1)="N"!(+$G(DUOUT))  D  Q "NO"
 ;. W !!
 ;. W ?10,"Program exiting",!
 ;
 I +$G(DIRUT)!(+Y=0) Q "NO"  ; IHS/MSC/MKK - LR*5.2*1054
 Q "Y"
 ;
BUILDARY ; EP -- Build the output array
 S TAB=$J("",5)
 S LN=0
 D ADDLNCJ($$LOC^XBFUNC,.LN)
 D ADDLNCJ("Logical Observation Identifiers",.LN)
 D ADDLNCJ("Names and Codes (LOINC)",.LN)
 D ADDLNCJ("IHS Lab Test File (# 60)",.LN)
 D ADDLNCJ("Tests WITHOUT LOINC Codes",.LN)
 D ADDLINE(" ",.LN)
 D ADDLINE(TAB_"File 60",.LN)
 ; D ADDLINE(TAB_"Number"_"   File 60 Description",.LN)
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1054
 S STR=TAB_"Number"_"   File 60 Description"
 S $E(STR,70)="Is Panel"
 D ADDLINE(STR,.LN)
 ; ----- END IHS/MSC/MKK - LR*5.2*1054
 ;
 D ADDLNCJ($TR($J("",IOM)," ","-"),.LN)
 ;
 S LABTNME=""
 F  S LABTNME=$O(NOLOINC(LABTNME))  Q:LABTNME=""  D
 . S TEST=$G(NOLOINC(LABTNME))
 . ; D ADDLINE("    "_$J(TEST,8)_"  "_$E(LABTNME,1,55),.LN)
 . ;
 . ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1054
 . S STR="    "_$J(TEST,8)_"  "_$E(LABTNME,1,40)
 . S ISPANEL=$$ISPANEL^BLRPOC(TEST)
 . I ISPANEL S $E(STR,70)="Yes",CNTPANEL=1+$G(CNTPANEL)
 . D ADDLINE(STR,.LN)
 . ; ----- END IHS/MSC/MKK - LR*5.2*1054
 ;
 D ADDLINE(" ",.LN)
 D ADDLINE("Number of Lab Tests Without LOINC Code = "_CNTNLOI,.LN)
 D ADDLINE(" ",.LN)
 ;
 D ADDLINE(TAB_"Number of Lab Tests in Dictionary = "_CNTLT,.LN)
 D ADDLINE(" ",.LN)
 ;
 D ADDLINE(TAB_"Number of Lab Tests in Dictionary with LOINC codes = "_CNTLOINC,.LN)
 D ADDLINE(" ",.LN)
 ;
 I +$G(CNTZZ)>0 D
 . D ADDLINE(TAB_"Number of ZZ'ed Lab Tests in Dictionary = "_CNTZZ,.LN)
 . D ADDLINE(" ",.LN)
 ;
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
REPORTIT ; EP -- Report the data
 S %ZIS="Q"
 D ^%ZIS
 I POP D
 . W !!,?10,"DEVICE could not be selected.  Output will be to the screen.",!!
 ;
 I $D(IO("Q")) D  Q
 . S ZTRTN="DEVRPT^BLRNLOIN",ZTDESC="IHS Non LOINC Lab Tests Report"
 . S ZTSAVE("LR*")=""
 . S ZTSAVE("CNT*")=""
 . D ^%ZTLOAD,^%ZISC
 . W !,"Request ",$S($G(ZTSK):"Queued - Task #"_ZTSK,1:"NOT Queued"),!!
 . D BLREND
 ;
DEVRPT ; EP
 D DEVRPTIN
 ;
 U IO
 F  Q:$G(LRLRPT(J))=""!(QFLAG="Q")  D
 . I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLAG,"NO")  I QFLAG="Q" Q
 . ;
 . S J=J+1
 . W $G(LRLRPT(J))
 . S LINES=LINES+1
 ;
 D ^%ZISC
 ;
 Q
 ;
DEVRPTIN ; EP -- Initialize variables
 D SETBLRVS
 S (PG,CNT)=0
 S MAXLINES=IOSL-3
 S LINES=MAXLINES+10
 S QFLAG="NO"
 K HEADER
 F J=2:1:8 S HEADER(J-1)=LRLRPT(J)
 ;
 S J=10
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
