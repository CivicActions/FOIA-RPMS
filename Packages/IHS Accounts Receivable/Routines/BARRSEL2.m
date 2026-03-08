BARRSEL2  ;IHS/SD/SDR - Selective Report Parameters CONT ; 12/30/10
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**35**;OCT 26, 2005;Build 187
 ;IHS/SD/SDR 1.8*35 ADO77760 New routine
BLDR ;
 S:BARSEL=1 BARTAG="DTYP"
 S:BARSEL=2 BARTAG="COLPT"
 S:BARSEL=3 BARTAG="ALLC"
 S:BARSEL=4 BARTAG="RTYP"
 I $G(BARTAG)]"" D
 .S BARTAG=BARTAG_"^BARRSEL2"
 .D @BARTAG
 .Q
 E  S BARDONE2=1
 Q
DTYP ;
 D ^XBFMK
 K BARY("DT"),BARY("DTYP")
 S DIR(0)="S^1:Lockdown Date;2:Date Batch Finalized"
 S DIR("A")="Select TYPE of DATE Desired"
 D ^DIR
 I Y<1 D  Q  ;back to defaults (lockdown and date range) if they exit this prompt
 .S BARY("DTYP")="Lock"
 .S BARY("DT")="LDT"
 .S BARY("DT",1)=3051001  ;this is used to coincide with code in BARPST that says 'oldest collection date allowed (lockdown date)
 .S BARY("DT",2)=DT
 I Y=2 S BARY("DT")="FDT"
 E  S BARY("DT")="LDT"
 S (BARY("DTYP"),Y)=$S(Y=2:"Date Batch Finalized",1:"Lockdown Date")
 K Y S BARFUDT=$$BLDRDT^BARDUTL0()  ;this makes it exactly 6 months from today
DATES ;
 W !!," ============ Entry of ",BARY("DTYP")," Range =============",!
 S BARSTART=$$DATE(1)
 I BARSTART<1 I $D(DIRUT) G DTYP E  W !!,"A date range is required" G DATES
 I ((BARY("DT")="FDT")&(BARSTART>DT)) W *7,!,"Future dates invalid.  Please re-enter." G DATES
 S BAREND=$$DATE(2)
 I BAREND<1 W ! G DATES
 I ((BARY("DT")="FDT")&(BAREND>DT)) W *7,!,"Future dates invalid.  Please re-enter." G DATES
 I BAREND<BARSTART D  G DATES
 .W *7
 .W !!,"The END date must not be before the START date, or Future Date.",!
 S BARY("DT",1)=BARSTART
 S BARY("DT",2)=BAREND
 S BAREND=BAREND+.9
 Q
DATE(X) ;EP - ask beginning and ending date
 S DIR(0)="D^3051001:"_$S(BARY("DT")="LDT":BARFUDT,1:"DT")_":%DT"
 S DIR("A")="Select "_$P("Beginning^Ending","^",X)_" Date"
 S DIR("?")="^D HELP^%DTC"
 S DIR("??")="^D HELP^%DTC"
 S DIR("???")="^D HELP^%DTC"
 S DIR("????")="^D HELP^%DTC"
 D ^DIR
 Q Y
COLPT ; EP
 ; Select Collection Point(s)
 K BARY("COLPT")
 S DIC="^BAR(90051.02,DUZ(2),"
 S DIC(0)="ZQEAM"
 S DIC("A")="Select A/R COLLECTION POINT/IHS/NAME: ALL// "
 F  D  Q:+Y<0
 .I $D(BARY("COLPT")) S DIC("A")="Select Another A/R COLLECTION POINT/IHS/NAME: "
 .E  K DIC("B")
 .D ^DIC
 .Q:+Y<0
 .S BARY("COLPT",+Y)=""
 .Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))
 I '$D(BARY("COLPT")) D
 .W "ALL"
 Q
ALLC ; EP
 ; Select ALLOWANCE CATEGORY Inclusion Parameter
 K DIR,BARY("ALLOC")
 S DIR(0)="SO^1:MEDICARE              (INS TYPES R MD MH MC MMC)"
 S DIR(0)=DIR(0)_";2:MEDICAID              (INS TYPES D K FPL)"
 S DIR(0)=DIR(0)_";3:PRIVATE INSURANCE     (INS TYPES P H F M)"
 S DIR(0)=DIR(0)_";4:VETERANS              (INS TYPES V)"
 S DIR(0)=DIR(0)_";5:OTHER                 (INS TYPES W C N I G T SEP TSI)"
 S BARSV=DIR(0)
 S DIR(0)=DIR(0)_";6:ALL CATEGORIES"
 S DIR("A")="Select TYPE of ALLOWANCE CATEGORY to Display"
 S DIR("B")="ALL"
 S DIR("?")="Enter TYPE of ALLOWANCE CATEGORY to display, or press <return> for ALL"
 F  D  Q:(+Y<1)!(Y=6)
 .K Y
 .I $D(BARY("ALLOC")) S DIR("A")="Select Another Allowance Category",DIR(0)=BARSV
 .D ^DIR
 .I Y=6 K BARY("ALLOC") Q
 .Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))!(+Y<1)
 .S BARY("ALLOC",+Y)=""
 .K DIR("B")
 K DIR
 Q
RTYP ; EP
 ; Select Report Type Inclusion Parameter
 K DIR,BARY("RTYP")
 S DIR(0)="SO^1:Detail (Printer);2:Summary (Printer);3:Delimited Detail;4:Delimited Summary"
 S DIR("A")="Select TYPE of REPORT desired"
 S DIR("B")=2
 D ^DIR
 K DIR
 I $D(DUOUT)!$D(DTOUT) S BARY("RTYP")=2,BARY("RTYP","NM")="Summary (Printer)" Q
 S BARY("RTYP")=Y
 S BARY("RTYP","NM")=Y(0)
 Q
