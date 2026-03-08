BARDMINQ ; IHS/SD/SDR - A/R Debt Letter Inquire ;08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**39**;OCT 26, 2005;Build 231
 ;IHS/SD/SDR 1.8*39 ADO111593 New routine to inquire about debt letter bills, print
 ;********************************************************************
 ;
 Q
DIC ;
 D ^XBFMK
 W !
 S DIC="^BARDM(DUZ(2),"
 S DIC(0)="QEAM"
 D ^DIC
 G XIT:X=""!(X["^")!$D(DUOUT)!$D(DTOUT)
 I +Y<1 G DIC
 S BARY("DA")=+Y
 ;
 W !!
 S %ZIS("A")="Output DEVICE: "
 S %ZIS="PQ"
 D ^%ZIS
 G XIT:POP
 I IO'=IO(0),IOT'="HFS" D  Q
 .D QUE2
 .D HOME^%ZIS
 U IO(0)
 W:'$D(IO("S")) !!,"Printing..."
 S BARP(1)=$$GET1^DIQ(90050.01,$P($G(^BARDM(DUZ(2),BARY("DA"),0)),U),"101","I")  ;PDFN
 S BARDMB=$$LOG^BUSAAPI("A","P","P","BARDMINQ","BAR: Debt Letter Inquiry","BARP")
 U IO
 D ENT
 G DIC
 ;
QUE2 ;
 I IO=IO(0) W !,"Cannot Queue to Screen or Slave Printer!",! G DIC
 S ZTRTN="TSK^BARDMINQ"
 S ZTDESC="A/R Debt Management Bill Inquiry."
 F BAR="ZTRTN","ZTDESC","BAR(","BARY(" S ZTSAVE(BAR)=""
 D ^%ZTLOAD
 I $D(ZTSK) W !,"(Job Queued, Task Number: ",ZTSK,")"
 G OUT
 ;
TSK ; Taskman Entry Point
 S BARP("Q")=""
 ;
ENT ;
 D ^XBFMK
 W $$EN^BARVDF("IOF")
 W !?19,"*** A/R DEBT MANAGEMENT LETTER FILE INQUIRY ***",!
 S DIC="^BARDM(DUZ(2),"
 S DA=$G(BARY("DA"))
 S DR=0
 D EN^DIQ
 ;
 D ^XBFMK
 S DA(1)=BARY("DA")
 S DIC="^BARDM(DUZ(2),"_DA(1)_",50,"
 S DA=0 F  S DA=$O(^BARDM(DUZ(2),DA(1),50,DA)) Q:'DA  D
 .D EN^DIQ
 ;
 D ^XBFMK
 S DA(1)=BARY("DA")
 S DIC="^BARDM(DUZ(2),"_DA(1)_",100,"
 S DA=0 F  S DA=$O(^BARDM(DUZ(2),DA(1),100,DA)) Q:'DA  D
 .D EN^DIQ
 ;
OUT ;
 D ^%ZISC
 ;
XIT ;
 K BARP,BARY,DIQ
 Q
