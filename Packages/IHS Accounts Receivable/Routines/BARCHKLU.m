BARCHKLU ; IHS/SD/LSL - Look up Collection Information for Insurance Company by Check Number ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**30,31**;OCT 26, 2005;Build 90
 ;
 ;BAR*1.8*31 10.28.20 IHS/OIT/FCJ CR#9729 Modified to display status, added changes to this
 ;                                        routine to keep in sync with BARZCHKL
 ; IHS/SD/LSL - 11/14/02 - V1.7 - NOIS XCA-0802-200093
 ;      Modify code that $O thru the "D" x-ref to check for checks
 ;      in all upper case if check entered in lower case and lower case
 ;      check fails.
 ;
 ; ********************************************************************
 ;
 ;** Collection Batch information by check number
 ;** option Check Posting Summary (CPS)**
 ;
ONE ;EP
 G ONE^BARZCHKL  ;*** TESTING - AEF ***
 N DIC,BARCHKNO,BARCBDA,BARITMNO
 ;
 ; -------------------------------
ASK W !!
 ;BAR*1.8*30 10550 START OLD CODE
 ;S DIC=$$DIC^XBDIQ1(90051.01)
 ;S DIC(0)="AEQZ"
 ;S D="D"
 ;S DIC("A")="Select Check Number: "
 ;D IX^DIC
 ;I X=" " W !,"  Must enter a Check Number " G ASK
 ;Q:+Y<0
 ;S BARCHKNO=X   
 ;S BARCBDA=+Y
 ;S BARCBNM=$P(Y,U,2)
 ;S BARCHKNO=$E(X,1,50)
 ;I $F(BARCHKNO,"  ")>0 S BARCHKNO=$E(BARCHKNO,1,$F(BARCHKNO,"  ")-3)
 ;I $E(BARCHKNO,$L(BARCHKNO))=" " S BARCHKNO=$E(BARCHKNO,$L(BARCHKNO)-1)
 ;I '$D(^BARCOL(DUZ(2),BARCBDA,1,"C",BARCHKNO)) D
 ;.S BARCHKNO=$$UPC^BARUTL(BARCHKNO)
 ;.S BARCHKNO=$O(^BARCOL(DUZ(2),BARCBDA,1,"C",BARCHKNO))
 ;.S X=$$PRTFMTEX^BARCHKU1(BARCHKNO,51)
 ;BAR*1.8*30 CR10550  START NEW CODE
 K DIR,DIC,V,X,Y,Z,TEST
 S DIR(0)="FAO^1:50"
 S DIR("A")="Select Check Number: "
 S DIR("?")="Enter a full or partial check number."
 S DIR("??")="^D CHKLIST^BARCHKU1"
 D ^DIR
 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)!(Y="")
 ;I $L(X)>20 S X=""""_X_""""
 ;S X=X_" "
 N ITM    ;BAR*1.8*31 IHS/OIT/FCJ CR#9729
 S TEST=X,X="",Z=0
 K DIR
 S DIR(0)=""
 F  S X=$O(^BARCOL(DUZ(2),"D",X)) Q:X']""  I $E(X,1,$L(TEST))=TEST D
 .S V=""
 .F  S V=$O(^BARCOL(DUZ(2),"D",X,V)) Q:V']""  D
 ..S Y=""
 ..F  S Y=$O(^BARCOL(DUZ(2),"D",X,V,Y)) Q:Y']""  D
 ...S Z=Z+1,TEST(Z)=X_U_V_U_$P(^BARCOL(DUZ(2),V,0),U,1)_U_Y
 ...S ITM=0,ITM=$O(^BARCOL(DUZ(2),V,Y,"C",X,ITM))    ;BAR*1.8*31 IHS/OIT/FCJ CR#9729
 ...;S DIR("L",Z)=Z_":  "_X_":  "_$P(^BARCOL(DUZ(2),V,0),U,1)     ;BAR*1.8*31 IHS/OIT/FCJ CR#9729
 ...S DIR("L",Z)=Z_":  "_X_":  "_$P(^BARCOL(DUZ(2),V,0),U,1)_" ITEM "_ITM_" "_$$VAL^XBDIQ1(90051.1101,"V,ITM",17)   ;BAR*1.8*31 IHS/OIT/FCJ CR#9729
 ...S DIR(0)=DIR(0)_Z_": "_X_";"
 I Z<1 W "??",! G ASK
 I Z>1 D
 .S DIR("L")=DIR("L",Z) K DIR("L",Z)
 .S DIR("A")="Enter the line number representing the correct check number"
 .S DIR(0)="SO^"_$E(DIR(0),1,$L(DIR(0))-1)_"^K:X>Z X"
 .D ^DIR
 I Y<1,(Z'=1) Q
 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 I Z=1 S Y=Z
 S BARCHKNO=$P(TEST(Y),U,1)
 S BARCBDA=$P(TEST(Y),U,2)
 S BARCBNM=$P(TEST(Y),U,3)
 ;BAR*1.8*30 10550 END NEW CODE
 S BARITMNO=0
 S BARITMNO=$O(^BARCOL(DUZ(2),BARCBDA,1,"C",BARCHKNO,BARITMNO))
 I BARITMNO="" D  I BARITMNO="" K BARCBDA,BARITMNO,BARCHKNO G ASK
 . S BARCHKNO=$$UPC^BARUTL(X)
 . S BARCBDA=+Y
 . S BARITMNO=0
 . S BARITMNO=$O(^BARCOL(DUZ(2),"D",X,BARCBDA,BARITMNO))
 . I BARITMNO="" W !,"Couldn't find ITEM for this CHECK NUMBER.  Please select again."
 ;BAR*1.8*30 10550 END
 I '$D(^BARCOL(DUZ(2),BARCBDA,1,BARITMNO,0)) D  G ASK
 . W !,"PROBLEM WITH THIS ITEM SET UP CONTACT YOUR SUPPORT PERSONNEL"
 . K BARCBDA,BARITMNO,BARCHKNO
 I '$D(^BARCOL(DUZ(2),BARCBDA,1,BARITMNO,1)) D  G ASK
 . W !,"PROBLEM WITH THIS ITEM SET UP CONTACT YOUR SUPPORT PERSONNEL"
 . K BARCBDA,BARITMNO,BARCHKNO
 I '$D(^BARCOL(DUZ(2),BARCBDA,1,BARITMNO,2)) D  G ASK
 . W !,"PROBLEM WITH THIS ITEM SET UP CONTACT YOUR SUPPORT PERSONNEL"
 . K BARCBDA,BARITMNO,BARCHKNO
 S (BARCKAMT,BARINSNM,BARITMPD,BARITMBL,BARITMUD,BARITMUA,BARITMRF)=0
 S BARCKAMT=$P(^BARCOL(DUZ(2),BARCBDA,1,BARITMNO,1),"^")
 S BARINSNM=$P(^BARCOL(DUZ(2),BARCBDA,1,BARITMNO,2),"^")
 S BARITMST=$E($$VAL^XBDIQ1(90051.1101,"BARCBDA,BARITMNO",17),1,3)   ;BAR*1.8*31 IHS/OIT/FCJ CR#9729
 S BARITMPD=$$VAL^XBDIQ1(90051.1101,"BARCBDA,BARITMNO",18)
 S BARITMBL=$$VAL^XBDIQ1(90051.1101,"BARCBDA,BARITMNO",19)
 S BARITMUD=$P(^BARCOL(DUZ(2),BARCBDA,1,BARITMNO,1),"^",3)
 S BAR23=1
 S BARITMUA=$$ITT^BARCBC(BARCBDA,BARITMNO,"UN-ALLOCATED")
 K BAR23
 S BARITMRF=$$ITT^BARCBC(BARCBDA,BARITMNO,"REFUND")*-1
 I $L(BARCHKNO)<23 W !,"Check No: ",BARCHKNO,?25,"From: ",$E(BARINSNM,1,30),?55,"For: ",$J(BARCKAMT,10,2),!    ;Item Check # BAR*1.8*30 CR10550
 E  W !,"Check No: ",BARCHKNO,!,"From: ",$E(BARINSNM,1,30),?33,"For: ",$J(BARCKAMT,10,2),!
 K DIR
 S DIR(0)="Y"
 S DIR("A")="  CORRECT "
 S DIR("B")="YES"
 D ^DIR
 K DIR
 I Y'=1 G ASK
 D PRINT
 Q
 ; *********************************************************************
 ;
HEADER ;
 I IOSL=6000 D
 .W $$EN^BARVDF("IOF")
 .W !?5,"Collection Batch: ",BARCBNM
 .W ?50,"Item Number: ",BARITMNO
 .W ?68,"Status: ",BARITMST     ;BAR*1.8*31 IHS/OIT/FCJ CR#9729
 .W !,"Check Number: ",BARCHKNO
 .I $L(BARCHKNO)>40 W !,"Issued By: ",BARINSNM  ;Item Check # BAR*1.8*30 CR10550
 .E  W ?32,"Issued By: ",BARINSNM
 .W !,"Check Amount: ",$J(BARCKAMT,10,2)
 .W ?27,"Amount Posted : ",$J(BARITMPD,10,2)
 .W ?55,"Balance : ",$J(BARITMBL,10,2)
 .W !,"Un-Allocated: ",$J(BARITMUA,10,2)
 .W ?55,"Refunded: ",$J(BARITMRF,10,2),!
 .W !,"Patient Name",?15,"3P Bill DT",?24,"Bill Name",?42,"DOS",?60,"Paid Amt.",?70,"Adjust",!
 .D EBARPG
 I IOSL<6000 D BARHDR
 ;
 ; -------------------------------
DETAILS ;
 ; Collect information on what bills this check applied to
 S BARBCNT=0
 S (BARDTTM,BARCHKPD)=0
 F  S BARDTTM=$O(^BARTR(DUZ(2),"AD",BARCBDA,BARDTTM)) Q:BARDTTM'>0  D  Q:($G(DIROUT)!$G(DUOUT)!$G(DTOUT)!$G(DROUT))
 .I $P(^BARTR(DUZ(2),BARDTTM,0),"^",15)'=BARITMNO Q
 .I '$D(^BARTR(DUZ(2),BARDTTM,1)) Q
 .I $P(^BARTR(DUZ(2),BARDTTM,1),"^")'=40 Q
 .S (BARBLDA,BARBLPT,BARPDAMT)=0
 .S (BARBLNM,BARBLPTN)=""
 .S BARPDAMT=$P(^BARTR(DUZ(2),BARDTTM,0),U,2)
 .S BARBLDA=$P(^BARTR(DUZ(2),BARDTTM,0),U,4)
 .S BARBLPT=$P(^BARTR(DUZ(2),BARDTTM,0),U,5)
 .S BARBLPTN=$E($$VAL^XBDIQ1(90050.01,BARBLDA,101),1,25)
 .S BARDOSB=$$VALI^XBDIQ1(90050.01,BARBLDA,102)
 .S BARDOSE=$$VALI^XBDIQ1(90050.01,BARBLDA,103)
 .S BARDOSEF=$$SDT^BARDUTL(BARDOSE)
 .S BARDOSBF=$$SDT^BARDUTL(BARDOSB)  ;Y2000
 .S BARBLNM=$E($$VAL^XBDIQ1(90050.01,BARBLDA,.01),1,15)
 .S BAR3PAP=$$SDT^BARDUTL($P($G(^BARBL(DUZ(2),BARBLDA,0)),U,18))
 .W !,$E(BARBLPTN,1,18)
 .W ?19,BAR3PAP
 .W ?30,$E(BARBLNM,1,17)
 .W ?48,BARDOSBF_"-"_BARDOSEF
 .W ?70,$J(BARPDAMT,10,2)
 .S BARBCNT=BARBCNT+1
 .S BARCHKPD=BARCHKPD+BARPDAMT
 .D PG
 .Q
 W !!?27,"Bill Count: ",BARBCNT,?50,"TOTALS:",?60,$J(BARCHKPD,12,2),?72,$J($G(BZXTADJ),8,2),!
 D EBARPG
 I $E(IOST)="C",IOT["TRM" D EOP^BARUTL(0)
 Q
 ; *********************************************************************
 ;
PRINT ;**Print   
 ;
 ; GET DEVICE (QUEUEING ALLOWED)
 S Y=$$DIR^XBDIR("S^P:PRINT Output;B:BROWSE Output on Screen","Do you wish to ","P","","","",1)
 K DA
 Q:$D(DIRUT)
 I Y="B" D  Q
 . S XBFLD("BROWSE")=1
 . S BARIOSL=IOSL
 . S IOSL=600
 . D VIEWR^XBLM("HEADER^BARCHKLU")
 . D FULL^VALM1
 . W $$EN^BARVDF("IOF")
 .D CLEAR^VALM1  ;clears out all list man stuff
 .K XQORNEST,VALMKEY,VALM,VALMAR,VALMBCK,VALMBG,VALMCAP,VALMCNT,VALMOFF
 .K VALMCON,VALMDN,VALMEVL,VALMIOXY,VALMLFT,VALMLST,VALMMENU,VALMSGR
 .K VALMUP,VALMWD,VALMY,XQORS,XQORSPEW,VALMCOFF
 .;
 .; ------------------------------
DEVE .;
 .S IOSL=BARIOSL
 .K BARIOSL
 .Q
 S XBRP="HEADER^BARCHKLU"
 S XBNS="BAR*"
 S XBRX="EXIT^BARCHKLU"
 D ^XBDBQUE
ENDJOB Q
 ; *********************************************************************
PG ;**page controller      
BARPG ;EP PAGE CONTROLLER   
 ; This utility uses variables BARPG("HDR"),BARPG("DT"),BARPG("LINE"),BARPG("PG")
 ; kill variables by D EBARPG
 ;
 Q:($Y<(IOSL-6))!($G(DOUT)!$G(DFOUT))
 S:'$D(BARPG("PG")) BARPG("PG")=0
 S BARPG("PG")=BARPG("PG")+1
 I $E(IOST)="C",IOT["TRM" D EOP^BARUTL(0)  Q:($G(DIROUT)!$G(DUOUT)!$G(DTOUT)!$G(DROUT))
 ;
 ; -------------------------------
Q ;
 Q:($G(DIROUT)!$G(DUOUT)!$G(DTOUT)!$G(DROUT))
 ;
 ; -------------------------------
BARHDR ; Write the Report Header
 S BARPG("HDR")="Check Posting Summary"
 W:$Y @IOF
 W !
 Q:'$D(BARPG("HDR"))
 S:'$D(BARPG("LINE")) $P(BARPG("LINE"),"-",IOM-2)=""
 S:'$D(BARPG("PG")) BARPG("PG")=1
 I '$D(BARPG("DT")) D
 . S %H=$H
 . D YX^%DTC
 . S BARPG("DT")=Y
 U IO
 W ?(IOM-$L(BARPG("HDR"))/2),BARPG("HDR")
 W !?(IOM-75),BARPG("DT"),?(IOM-15),"PAGE: ",BARPG("PG")
 W !,BARPG("LINE")
 ;
 ; -------------------------------
BARHD ;EP
 ; Write column header / message
 W !?5,"Collection Batch: ",BARCBNM
 W ?50,"Item Number: ",BARITMNO
 W ?68,"Status: ",BARITMST     ;BAR*1.8*31 IHS/OIT/FCJ CR#9729
 W !,"Check Number: ",BARCHKNO
 I $L(BARCHKNO)>30 W !,"Issued By: ",BARINSNM
 E  W ?32,"Issued By: ",BARINSNM
 W !,"Check Amount: ",$J(BARCKAMT,10,2)
 W ?27,"Amount Posted : ",$J(BARITMPD,10,2)
 W ?55,"Balance : ",$J(BARITMBL,10,2),!
 W "Un-Allocated: ",$J(BARITMUA,10,2)
 W ?55,"Refunded: ",$J(BARITMRF,10,2),!
 W !,"Patient Name"
 W ?15,"3P Bill DT"
 W ?24,"Bill Name"
 W ?42,"DOS"
 W ?62,"Paid Amt.",!
 W ?74,"Adjust"
 I ($G(DIROUT)!$G(DUOUT)!$G(DTOUT)!$G(DROUT)) S BARQUIT=1
 Q
 ; *********************************************************************
 ;
EBARPG ;
 K BARPG("LINE"),BARPG("PG"),BARPG("HDR"),BARPG("DT")
 Q
 ; *********************************************************************
 ;
EXIT ; Exit routine
 Q
