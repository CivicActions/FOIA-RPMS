BLRIPLUI ; IHS/MSC/MKK - INTERMEC IPL UID Barcoded Initialization ; 08/05/2022 ; MKK
 ;;5.2;IHS LABORATORY;**1052**;NOV 01, 1997;Build 17
 ;
 ; MSC/MKK - LR*5.2*1052 - Item 75431 - Add long form UID barcode to Lab Label printer.
 ;
 ; Initializes IPL capable printers.  NO BINARY CODE VERSION.
 ; 
 ; Sets up UID to be barcoded, NOT, repeat NOT, the Accession's Number
 ; Uses format Barcode 128.
 ; 
 ; Cloned from BLRP41UI
 ;
FMT ;EP - E3;F3 erases format 3 (BARCODE) and accesses form #
 ;     E2;F2 erases format 2 (PLAIN) and accesses form #
 ;
ZIS ; EP
 K %ZIS
 S %ZIS="QN"
 D ^%ZIS I POP W !?7,*7,"NO DEVICE SELECTED ",! D ^%ZISC Q
 ;
 S ZTIO=ION
 S ZTDTH=$H
 S ZTDESC="BAR CODE FORMAT DOWN LOAD"
 S ZTRTN="BAR^BLRIPLUI"
 D ^%ZTLOAD
 D ^%ZISC W !!?5,"Barcode Formating Program",$S($G(ZTSK):" Queued ",1:" NOT QUEUED"),!!
 D ^%ZISC
 K ZTSK
 Q
 ;
BAR ; EP
 NEW SHIFT
 ;
 S:$D(ZTQUEUED) ZTREQ="@"
 S X=0 X ^%ZOSF("RM")
 ;
 ; S SHIFT=+$$GET1^DIQ(9009029,DUZ(2),404)
 ;
 S SHIFT=+$O(^BLRIPLUI("SHIFT",0))
 S BARCSIZE=+$O(^BLRIPLUI("BARCODE SIZE",0))
 S:BARCSIZE<1 BCARSIZE=3.5
 D BARCODEI(SHIFT,BARCSIZE)             ; Initializes format F3: accession # barcoded
 ;
 D PLAININI(SHIFT)             ; Initializes format F2: no barcode
 W "<STX>R<ETX>"               ; "Exit" Program Mode
 ;
 D ^%ZISC
 Q
 ;
PROGINIT ; EP -- SHIFT Prompt.
 NEW SHIFT
 ;
 D ^XBFMK
 S SHIFT=+$O(^BLRIPLUI("SHIFT",0))
 S DIR(0)="NOA^-900:900"
 S DIR("A")="SHIFT Parameter (-900 to 900): "
 S DIR("B")=SHIFT
 D ^DIR
 I +$G(DIRUT) D  Q
 . W !!,?4,"Quit Entered.  Routine Ends."
 . D PRESSKEY^BLRGMENU(9)
 ;
 S SHIFT=+$G(Y)
 ;
 D ^XBFMK
 S BARCSIZE=+$O(^BLRIPLUI("BARCODE SIZE",0))
 S:BARCSIZE<1 BARCSIZE=3.5
 S DIR(0)="NOA^::1"
 S DIR("A")="Barcode Size: "
 S DIR("B")=BARCSIZE
 D ^DIR
 I +$G(DIRUT) D  Q
 . W !!,?4,"Quit Entered.  Routine Ends."
 . D PRESSKEY^BLRGMENU(9)
 ;
 S BARCSIZE=+$G(Y)
 ;
 ; Following trick necessary to avoid
 ;     2.2.3.2.3  KILL of unsubscripted global
 ; flag from AZHLSC SAC Checker
 NEW WOTKILL
 S WOTKILL="^BLRIPLUI"
 K @WOTKILL
 ; 
 ; Store entered paramaters
 S ^BLRIPLUI("SHIFT",SHIFT)=""
 S ^BLRIPLUI("BARCODE SIZE",BARCSIZE)=""
 ;
 K %ZIS
 S %ZIS="QN"
 D ^%ZIS I POP W !?7,*7,"NO DEVICE SELECTED ",! D ^%ZISC Q
 ;
 S ZTSAVE("SHIFT")=""
 S ZTSAVE("BARCSIZE")=""  ; IHS/MSC/MKK - LR*5.2*1035
 S ZTIO=ION
 S ZTDTH=$H
 S ZTDESC="SHIFT BAR CODE FORMAT DOWN LOAD"
 S ZTRTN="PROGBAR^BLRIPLUI"
 D ^%ZTLOAD
 D ^%ZISC W !!?5,"SHIFT Barcode Formating Program",$S($G(ZTSK):" Queued ",1:" NOT QUEUED"),!!
 D ^%ZISC
 K ZTSK
 Q
 ;
PROGBAR ; EP - SHIFT Initialization
 S:$D(ZTQUEUED) ZTREQ="@"
 S X=0 X ^%ZOSF("RM")
 ;
 D BARCODEI(SHIFT,BARCSIZE)    ; Initializes format F3: accession # barcoded
 D PLAININI(SHIFT)             ; Initializes format F2: no barcode
 W "<STX>R<ETX>"               ; "Exit" Program Mode
 ;
 D ^%ZISC
 Q
 ;
BARCODEI(SHIFT,BARCSIZE) ; EP - Bar code format, By ROWs
 W "<STX><ESC>C<ETX>"
 W "<STX><ESC>P<ETX>"
 W "<STX>E3;F3<ETX>"
 W "<STX>F3;H1;o165,"_(575-SHIFT)_";f1;c2;h1;w1;d0,32<ETX>"             ; Test(s)              (01)
 W "<STX>F3;H2;o148,"_(575-SHIFT)_";f1;c2;h1;w1;d0,20<ETX>"             ; Provider             (02)
 W "<STX>F3;H3;o148,"_(325-SHIFT)_";f1;c2;h1;w1;d0,11<ETX>"             ; Top/Specimen         (03)
 W "<STX>F3;H4;o130,"_(575-SHIFT)_";f1;c2;h1;w1;d0,14<ETX>"             ; UID String           (04)
 W "<STX>F3;H5;o130,"_(370-SHIFT)_";f1;c2;h1;w1;d0,16<ETX>"             ; Date/Time            (05)
 W "<STX>F3;B6;o67,"_(575-SHIFT)_";f1;c6;h60;w"_BARCSIZE_";d0,10<ETX>"  ; UID Barcode 128      (06)
 W "<STX>F3;H7;o47,"_(575-SHIFT)_";f1;c2;h1;w1;d0,13<ETX>"              ; Order #              (07)
 W "<STX>F3;H8;o47,"_(330-SHIFT)_";f1;c2;h1;w1;d0,12<ETX>"              ; Location             (08)
 W "<STX>F3;H9;o30,"_(575-SHIFT)_";f1;c2;h1;w1;d0,7<ETX>"               ; Health Record Number (09)
 W "<STX>F3;H10;o30,"_(470-SHIFT)_";f1;c2;h1;w1;d0,15<ETX>"             ; Date of Birth        (10)
 W "<STX>F3;H11;o30,"_(260-SHIFT)_";f1;c2;h1;w1;d0,4<ETX>"              ; Urgency              (11)
 W "<STX>F3;H12;o0,"_(575-SHIFT)_";f1;c2;h2;w1;d0,25<ETX>"              ; Patient Name         (12)
 W "<STX>F3;H13;o0,"_(265-SHIFT)_";f1;c2;h1;w1;d0,5<ETX>"               ; Sex                  (13)
 Q
 ;
PLAININI(SHIFT) ; EP -- PLAIN format - By ROWs,
 W "<STX><ESC>C<ETX>"
 W "<STX><ESC>P<ETX>"
 W "<STX>E2;F2<ETX>"
 W "<STX>F2;H14;o165,"_(575-SHIFT)_";f1;c2;h1;w1;d0,32<ETX>"   ; Test(s)              (01)
 W "<STX>F2;H15;o146,"_(575-SHIFT)_";f1;c2;h1;w1;d0,11;<ETX>"  ; Top/Specimen         (02)
 W "<STX>F2;H16;o146,"_(330-SHIFT)_";f1;c2;h1;w1;d0,12<ETX>"   ; Location             (03)
 W "<STX>F2;H17;o127,"_(575-SHIFT)_";f1;c2;h1;w1;d0,28<ETX>"   ; Provider             (04)
 W "<STX>F2;H18;o108,"_(575-SHIFT)_";f1;c2;h1;w1;d0,16<ETX>"   ; Date/Time            (05)
 W "<STX>F2;H19;o72,"_(575-SHIFT)_";f1;c2;h2;w1;d0,14<ETX>"    ; UID String           (06)
 W "<STX>F2;H20;o51,"_(575-SHIFT)_";f1;c2;h1;w1;d0,13;<ETX>"   ; Order #              (07)
 W "<STX>F2;H21;o51,"_(350-SHIFT)_";f1;c2;h1;w1;d0,5<ETX>"     ; Sex                  (08)
 W "<STX>F2;H22;o35,"_(200-SHIFT)_";f0;c0;h3;w3;b2;d0,4<ETX>"  ; Urgency              (09)
 W "<STX>F2;H23;o32,"_(575-SHIFT)_";f1;c2;h1;w1;d0,7;<ETX>"    ; Health Record Number (10)
 W "<STX>F2;H24;o32,"_(460-SHIFT)_";f1;c2;h1;w1;d0,15<ETX>"    ; Date of Birth        (11)
 W "<STX>F2;H25;o0,"_(575-SHIFT)_";f1;c2;h2;w1;d0,32<ETX>"     ; Patient Name         (12)
 Q
 ;
TEST ; EP - Tests formats
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 S BLRVERN=$P($P($T(+1),";")," ")
 ;
 D ADDTMENU^BLRGMENU("BOTHTEST^BLRIPLUI","Barcode & Plain Label Test")
 D ADDTMENU^BLRGMENU("BARCTEST^BLRIPLUI","Barcode Label Test")
 D ADDTMENU^BLRGMENU("PLAINTST^BLRIPLUI","Plain Label Test")
 D ADDTMENU^BLRGMENU("EN^LRLABXT","Reprint Accession Label")
 D ADDTMENU^BLRGMENU("PROGINIT^BLRIPLUI","Re-Initialize Printer")
 ;
 D MENUDRVR^BLRGMENU("RPMS Laboratory Module","Intermec Label Printer Test Utilities")
 ; D MENUDRFM^BLRGMENU("RPMS Laboratory Module","Intermec Label Printer Test Utilities")
 Q
 ;
BOTHTEST ; EP - Print Both Barcode & Plain Test Labels
 Q:$$HOWMANY()="Q"
 ;
 ; Sets variables to be used with the test labels
 D SETVARS
 ;
 D ^%ZIS
 I POP D  Q
 . W !!,"DEVICE ISSUE.  ROUTINE STOPPING.",!!
 ;
 U IO
 F CNT=1:1:HOWMANY D
 . D BARCLABL
 . D PLAINLBL
 ; W "<STX><FF><ETX>"
 D ^%ZISC
 Q
 ;
BARCTEST ; EP - Just print BARCODEd Test Label
 Q:$$HOWMANY()="Q"
 ;
 ; Sets variables to be used with the test labels
 D SETVARS
 ;
 D ^%ZIS
 I POP D  Q
 . W !!,"DEVICE ISSUE.  ROUTINE STOPPING.",!!
 ;
 U IO
 F CNT=1:1:HOWMANY D BARCLABL
 W "<STX><FF><ETX>"
 D ^%ZISC
 Q
 ;
PLAINTST ; EP - Just print Plain Test Labels
 Q:$$HOWMANY()="Q"
 ;
 ; Sets variables to be used with the test labels
 D SETVARS
 ;
 D ^%ZIS
 I POP D  Q
 . W !!,"DEVICE ISSUE.  ROUTINE STOPPING.",!!
 ;
 U IO
 F CNT=1:1:HOWMANY D PLAINLBL
 W "<STX><FF><ETX>"
 D ^%ZISC
 Q
 ;
HOWMANY() ; EP - Ask How Many Times To Print Test Labels
 W !!
 D ^XBFMK
 S DIR(0)="NO"
 S DIR("A")="How Many Test Label(s)"
 S DIR("B")=1
 D ^DIR
 I +$G(Y)<1!(+$G(DIRUT)) D  Q "Q"
 . S HOWMANY=0
 . W !!,?4,"Zero or Quit Entered.  Routine Ends."
 . D PRESSKEY^BLRGMENU(9)
 ;
 S HOWMANY=+$G(Y)
 Q 1
 ;
BARCLABL ; Prints TEST label with UID # barcoded
 ;
 S LRDAT=$TR($$HTE^XLFDT($H,"2MZ"),"@"," ")      ; Now Date/Time
 ;
 S X=0 X ^%ZOSF("RM")
 W "<STX>R<ETX>"                                 ; "Exit" Program Mode
 ;
 W "<STX><ESC>E3<CAN><ETX>"                      ; Format 3 -- Barcode
 W "<STX><CR>"_$G(LRTXT)_"<ETX>"                 ; Test(s)              (01)
 W "<STX><CR>Prov:"_$G(LRPROV)_"<ETX>"           ; Provider             (02)
 W "<STX><CR>"_$G(LRTOP)_"<ETX>"                 ; Top/Specimen         (03)
 W "<STX><CR>UID:"_$G(LRUID)_"<ETX>"             ; UID String           (04)
 W "<STX><CR>"_$G(LRDAT)_"<ETX>"                 ; Date/Time            (05)
 W "<STX><CR>"_$G(LRUID)_"<ETX>"                 ; UID # -- Bar Coded   (06)
 W "<STX><CR>Ord#:"_$G(LRCE)_"<ETX>"             ; Order Number         (07)
 W "<STX><CR>"_$G(LRLLOC)_" "_$G(LRRB)_"<ETX>"   ; Location             (08)
 W "<STX><CR>"_$G(HRCN)_"<ETX>"                  ; Health Record Number (09)
 W "<STX><CR>DoB:"_$G(DOB)_"<ETX>"               ; Date of Birth        (10)
 W "<STX><CR>",$G(LRURG)_"<ETX>"                 ; Urgency              (11)
 W "<STX><CR>",$E($G(PNM),1,27)_"<ETX>"          ; Patient Name         (12)
 W "<STX><CR>Sex:",$G(SEX)_"<ETX>"               ; Sex                  (13)
 ;
 W "<STX><ETB><SI>S30<ETX>"                      ; Ending WITHOUT Form Feed
 Q
 ;
PLAINLBL ; Prints TEST label WITHOUT a barcoded UID number
 S LRDAT=$TR($$HTE^XLFDT($H,"2MZ"),"@"," ")     ; Now Date/Time
 ;
 W "<STX><ESC>E2<CAN><ETX>"                     ; Format 2 -- Plain
 W "<STX><CR>"_$G(LRTXT)_"<ETX>"                ; Test(s)              (01)
 W "<STX><CR>"_$G(LRTOP)_"<ETX>"                ; Top/Specimen         (02)
 W "<STX><CR>"_$G(LRLLOC)_" "_$G(LRRB)_"<ETX>"  ; Location             (03)
 W "<STX><CR>Prov:"_$G(LRPROV)_"<ETX>"          ; Provider             (04)
 W "<STX><CR>"_$G(LRDAT)_"<ETX>"                ; Date/Time            (05)
 W "<STX><CR>UID:"_$G(LRUID)_"<ETX>"            ; UID String           (06)
 W "<STX><CR>Ord#:"_$G(LRCE)_"<ETX>"            ; Order Number         (07)
 W "<STX><CR>Sex:"_$G(SEX)_"<ETX>"              ; Sex                  (08)
 W "<STX><CR>"_$G(LRURG)_"<ETX>"                ; Urgency              (09)
 W "<STX><CR>"_$G(HRCN)_"<ETX>"                 ; Health Record Number (10)
 W "<STX><CR>DoB:"_$G(DOB)_"<ETX>"              ; Date of Birth        (11)
 W "<STX><CR>"_$E($G(PNM),1,32)_"<ETX>"         ; Patient Name         (12)
 ;
 W "<STX><ETB><SI>S30<ETX>"                     ; Ending WITH Form Feed
 Q
 ;
SETVARS ; EP - Initialize variables for testing
 S LRTXT="CHEM 7,GLUCOSE,A1C.K,IRON"
 S LRTOP="MARBLED RED"
 S LRCE=$TR($J($R(1000000),6)," ","0")
 S LRAS="CH 1008 87"
 S LRAN=87
 S HRCN=$TR($J($R(10000000),7)," ","0")
 S LRLLOC="TTLAB"
 S PNM="DO NOT USE,TEST LABEL LABEL LABEL LABELX"
 S LRURG="URGT"
 S LRUID=$TR($J($R(10000000000),10)," ","0")
 S NUMBER="00087"
 ;
 S SEX="M"
 S LRPROV="DOCTOR,DOCTOR DOCTOR"
 S DOB="10/30/1955"
 ;
 S LRACCAP="SURG 1008 999"
 S LRSPEC="WOUND TISSUE"
 S LRRB="B:22"
 ;
 Q
