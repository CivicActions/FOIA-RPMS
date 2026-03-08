BARBLDR ; IHS/SD/SDR - LOCKED BATCHES WITH BALANCE REPORT - Driver
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**35**;OCT 26, 2005;Build 187
 ;IHS/SD/SDR 1.8*35 ADO77760 New routine
 ;
EP ;
 S BARP("RTN")="BARBLDR"
 S BAR("LOC")="BILLING"
 D ^BARRSEL
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) Q
 ;
 S BAR("HD",0)=$S(((BARY("RTYP")#2)=0):"SUMMARY",1:"DETAIL")_" REPORT OF LOCKED BATCHES"
 S BARC=1
 S BARSP="" F I=1:1:(80-($L($P($G(^DIC(4,DUZ(2),0)),U))+33)) S BARSP=BARSP_" "
 I $D(BARY("DT")) S BAR("HD",BARC)="For "_$S(BARY("DT")="FDT":"BATCH FINALIZED",1:"LOCKDOWN")_" DATES "_$$SDT^BARDUTL(BARY("DT",1))_" to "_$$SDT^BARDUTL(BARY("DT",2)),BARC=BARC+1
 S BAR("HD",BARC)="Location: "_$P($G(^DIC(4,DUZ(2),0)),U)_BARSP_" LOCKDOWN PERIOD: "_$S(($$IHS^BARUFUT(DUZ(2))):"6 MO",1:"NONE"),BARC=BARC+1
 ;
 S BAR("PG")=1
 ;
 M BART("ALLOC")=BARY("ALLOC")
 K BARY("ALLOC")
 S BARA=0
 F  S BARA=$O(BART("ALLOC",BARA)) Q:'BARA  D
 .S BARY("ALLOC",$S(BARA=1:"MCR",BARA=2:"MCD",BARA=3:"PVT",BARA=4:"V",1:"OTH"))=""
 K BART
 ;
 I $D(BARY("ALLOC")) D
 .S BARI=""
 .S BARU("TXT")=""
 .F  S BARI=$O(BARY("ALLOC",BARI)) Q:($G(BARI)="")  D
 ..I BARU("TXT")="" S BARU("TXT")=BARI
 ..E  S BARU("TXT")=BARU("TXT")_", "_BARI
 .S BARU("TXT")="For Allowance Category(s): "_BARU("TXT")
 .S BAR("HD",BARC)=BARU("TXT"),BARC=BARC+1
 ;
 I $D(BARY("COLPT")) D
 .S BARI=0
 .S BARU("TXT")=""
 .F  S BARI=$O(BARY("COLPT",BARI)) Q:'BARI  D
 ..I BARU("TXT")="" S BARU("TXT")=$P($G(^BAR(90051.02,DUZ(2),BARI,0)),U)
 ..E  S BARU("TXT")=BARU("TXT")_", "_$P($G(^BAR(90051.02,DUZ(2),BARI,0)),U)
 .S BARU("TXT")="For Collection Point(s): "_BARU("TXT")
 .S BAR("HD",BARC)=BARU("TXT"),BARC=BARC+1
 ;
 I BARY("RTYP")=3 D
 .W !!,"Note: Some batches may contain more than one item on the report."
 .S DIR("A")="Do you wish to print the batch balance amount for each item? "
 .S DIR("B")="NO"
 .S DIR(0)="Y"
 .D ^DIR
 .K DIR
 .S BARDET=Y  ; 0 if no, 1 if yes to print for each line
 ;
ASKDEV ;EP - ASK DEVICE 
 S %ZIS="AQ"
 W !
 D ^%ZIS
 Q:POP
 I $D(IO("Q")) D QUE Q
 D LOOP
 U IO
 I '$D(^XTMP("BARBLDR",$J)) D  Q
 .D WHD^BARBLDR2
 .W !!,"THERE IS NO DATA TO PRINT"
 .I (BARY("RTYP")>2) D ^%ZISC U 0
 .K DIR
 .S DIR(0)="E"
 .D ^DIR
 ;
 S BARRTN="PRINT^BARBLDR"_$S((BARY("RTYP")#2)=0:2,1:1)
 D @BARRTN
 D ^%ZISC
 D HOME^%ZIS
 Q
 ;
QUE ; EP - QUE THE BARBLDR REPORT
 S ZTRTN="PRINT^BARBLDR"_$S((BARY("RTYP")#2)=0:2,1:1)
 S ZTDESC="BATCH LOCKDOWN REPORT (BLDR)"
 S ZTSAVE("BAR*")=""
 D ^%ZTLOAD
 I $D(ZTSK)[0 W !!?5,"Report Cancelled!"
 E  W !!?5,"Report task #: ",$G(ZTSK)
 D HOME^%ZIS
 Q
 ;
LOOP ;
 K ^XTMP("BARBLDR",$J)
 I $G(BARY("DTYP"))="" D  ;default to lockdown if nothing was selected
 .S BARY("DTYP")="Lock"
 .S BARY("DT")="LDT"
 .S BARY("DT",1)=3051001  ;this is used to coincide with code in BARPST that says 'oldest collection date allowed (lockdown date)
 .S BARY("DT",2)=DT
 ;
 I '$$IHS^BARUFUT(DUZ(2)) Q  ;don't report any data for tribal location
 I $G(BARY("DTYP"))["Final" S BARX="C"  ;this is the OPENED DATE/TIME XREF if finalized date is selected
 S BARSDT=BARY("DT",1)
 S BARLSDT=$$FMADD^XLFDT(BARY("DT",1),-180)-.000001
 S BARLEDT=BARY("DT",2)  ;save date for comparing
 S (BAREDT)=$$FMADD^XLFDT(BARY("DT",2),180)+.999999  ;extend because we are using the 'open' xref
 I ((BARY("DTYP")="Lock")&('$$IHS^BARUFUT(DUZ(2)))) Q  ;don't check for tribal location and lockdown date; it should be 'NO DATA TO PRINT'
 F  S BARLSDT=$O(^BARCOL(DUZ(2),"C",BARLSDT)) Q:'BARLSDT!(BARLSDT>BAREDT)  D
 .S BARCBDFN=0
 .F  S BARCBDFN=$O(^BARCOL(DUZ(2),"C",BARLSDT,BARCBDFN)) Q:'BARCBDFN  D
 ..S BARCBFDT=$P($G(^BARCOL(DUZ(2),BARCBDFN,0)),U,25)
 ..I (BARY("DT")="FDT") I (BARCBFDT="") Q  ;batch hasn't been finalized yet
 ..I ((BARY("DT")="FDT")&(BARCBFDT<BARY("DT",1)!(BARCBFDT>(BARY("DT",2)+.999999)))) Q  ;batch was finalized before or after our selected range
 ..S BARCOLPT=$P($G(^BARCOL(DUZ(2),BARCBDFN,0)),U,2)  ;collection point
 ..S BARCBLDT=$$UNFRMDT^BARDUTL0($$GET1^DIQ(90051.01,BARCBDFN,31,"I"))  ;lockdown date in FM format
 ..;
 ..;I ((BARY("DT")="FDT")&(BARCBLDT>DT)) Q  ;batch is locked down before today  ;removed during beta; they want to see all finalized batches w/balance regardless of lockdown date
 ..;
 ..I ((BARY("DT")="LDT")&(BARCBLDT<BARSDT!(BARCBLDT>BARLEDT))) Q
 ..I ($D(BARY("COLPT"))&('$D(BARY("COLPT",BARCOLPT)))) Q  ;not a selected collection point
 ..S BARALC=$P($G(^BAR(90051.02,DUZ(2),BARCOLPT,0)),U,7)
 ..Q:($D(BARY("ALLOC"))&(BARALC=""))  ;not a selected allowance category
 ..I $D(BARY("ALLOC")) I ('$D(BARY("ALLOC",BARALC))) Q
 ..;
 ..;now loop thru items looking for ones with a balance
 ..D ITEMS
 Q
ITEMS ;
 S BARITM=0,BARITMC=0,BARITMT=0,BARITMB=0  ;ITMC=item count  ITMT=item total  ITMB=item balance
 K BARUNA
 F  S BARITM=$O(^BARCOL(DUZ(2),BARCBDFN,1,BARITM)) Q:'BARITM  D
 .I "^R^C^"[("^"_$P($G(^BARCOL(DUZ(2),BARCBDFN,1,BARITM,0)),U,17)_"^") Q  ;skip items that are ROLLED UP or CANCELLED
 .S IENS=BARITM_","_BARCBDFN_","
 .;
 .I (($$GET1^DIQ(90051.1101,IENS,19)>0)!($$GET1^DIQ(90051.1101,IENS,105)>0)) D
 ..;if it gets here it's our data
 ..I ((BARY("RTYP")#2)=1) S ^XTMP("BARBLDR",$J,"D",BARCOLPT,BARCBDFN,BARITM)=$$GET1^DIQ(90051.1101,IENS,102.5)_U_($$GET1^DIQ(90051.1101,IENS,19)+$$GET1^DIQ(90051.1101,IENS,105))_$S(($$GET1^DIQ(90051.1101,IENS,105)>0):"^*",1:"")
 ..S BARITMC=BARITMC+1  ;item count
 ..S BARITMT=BARITMT+$$GET1^DIQ(90051.1101,IENS,102.5)  ;item total
 ..S BARITMB=BARITMB+$$GET1^DIQ(90051.1101,IENS,19)+$$GET1^DIQ(90051.1101,IENS,105) ;item balance + item unallocated
 ..I $$GET1^DIQ(90051.1101,IENS,105)>0 S BARUNA=1
 .;
 .I BARITMB=0 Q  ;quit if there's no accumulated balance (meaning all the items are completely posted)
 .S ^XTMP("BARBLDR",$J,"S",BARCOLPT,BARCBDFN)=BARITMC_U_BARITMT_U_BARITMB_$S(($G(BARUNA)=1):"^*",1:"")
 Q
