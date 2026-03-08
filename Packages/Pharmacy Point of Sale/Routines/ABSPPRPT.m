ABSPPRPT ; /IHS/SD/SDR - ABSP PRESCRIPTION with new elig report ; 12/18/2024 ;
 ;;1.0;PHARMACY POINT OF SALE;**57,58**;01 JUN 2001;Build 131
 ;IHS/SD/SDR 1.0*57 ADO125991 New routine
 ;BEFORE-rpt displays RXs backbill chk WILL process
 ;AFTER-rpt RXs that WERE resubmitted for pymt/results
 ;IHS/SD/SDR 1.0*58 ADO132972 fixed <UNDEF>ELIG+27^ABSPPRPT; typo for plan name
 Q
BEFORE ;
 W !!?2,"This report will display prescriptions that dropped to paper and now"
 W !?2,"the patient has active eligibility for the fill date."
 W !!?2,"The 'Before' option contains prescriptions that could be resubmitted, either"
 W !?2,"manually or via the tasked option."
 W !!?2,"The 'After' option contains prescriptions that were resubmitted via the tasked"
 W !?2,"option. It will not contain prescriptions that were manually resubmitted.",!
 K ABSPY
 D ^XBFMK
 K DIR
 S DIR(0)="SO^B:Before Tasked Option Data;A:After Tasked Option Data"
 S DIR("A")="Select TYPE of DATA"
 S DIR("?",1)="Before will report what paper claims could be resubmitted and potentially payable"
 S DIR("?",2)="After will report claims that were resubmitted via the tasked option"
 D ^DIR
 K DIR
 Q:$D(DIRUT)
 S ABSPY("DATATYP")=Y
 D ^XBFMK
 S U="^"
 D DT
 Q:$D(DIRUT)
 D OUTPUT  ;simple or delimit
 Q:$D(DIRUT)
 D DEVICE  ;device OR path,filenm
 Q:$D(DIRUT)
 Q:$G(POP)
 Q
COMPUTE ;
 K ^XTMP("ABSP-BFBBL",$J)
 K ^XTMP("ABSP-BFBBL-S",$J)
 I ABSPY("DATATYP")="A" D AFTER^ABSPPRP2 Q
 S ABSP("BBLDT")=ABSPY("DT",1)-.0000001
 S ABSP("EBBLDT")=ABSPY("DT",2)+.999999
 F  S ABSP("BBLDT")=$O(^ABSPT("AI","PAPER",ABSP("BBLDT"))) Q:'ABSP("BBLDT")!((ABSP("BBLDT")>ABSP("EBBLDT")))  D
 .S ABSP("RXI")=0
 .F  S ABSP("RXI")=$O(^ABSPT("AI","PAPER",ABSP("BBLDT"),ABSP("RXI"))) Q:'ABSP("RXI")  D
 ..S ABSP("PDFN")=$P($G(^ABSPT(ABSP("RXI"),0)),U,6)  ;pt
 ..S ABSP("RXDFN")=$P($G(^ABSPT(ABSP("RXI"),1)),U,11)  ;RX DFN
 ..I $D(^XTMP("ABSP-BFBBL-S",$J,ABSP("RXDFN"))) Q
 ..I ($$GET1^DIQ(9002313.59,ABSP("RXI"),4.0099,"E")'="PAPER") S ^XTMP("ABSP-BFBBL-S",$J,ABSP("RXDFN"))=1 Q  ;only paper clms
 ..I ($$GET1^DIQ(9002313.59,ABSP("RXI"),4.0099,"E")["DUPLICATE") S ^XTMP("ABSP-BFBBL-S",$J,ABSP("RXDFN"))=1 Q  ;no dups
 ..I $$GET1^DIQ(9002313.59,ABSP("RXI"),202,"E")'["No insurance" S ^XTMP("ABSP-BFBBL",$J,"SKIP",ABSP("RXDFN"))=1 Q
 ..S ABSP("RSTTXT")=$$GET1^DIQ(9002313.59,ABSP("RXI"),202,"E")
 ..I (ABSP("RSTTXT")["Reversed paper claim") D  Q
 ...S ^XTMP("ABSP-BFBBL-S",$J,ABSP("RXDFN"))=1  ;keep track of ones to skip
 ...K ^XTMP("ABSP-BFBBL",$J,ABSP("RXDFN"),$P(^DPT(ABSP("PDFN"),0),U))
 ..I $$GET1^DIQ(9002313.59,ABSP("RXI"),4,"E")'="" Q  ;response
 ..I +$$GET1^DIQ(52,ABSP("RXDFN"),32.1,"I")'=0 Q  ;RTS (date)
 ..I $P($G(^AUPNPAT(ABSP("PDFN"),4)),U,7)'>(ABSP("BBLDT")) Q
 ..;By here pt was updated somehow, after RX was billed, chk for elig
 ..S ABSP("RLSDT")=$P($$GET1^DIQ(9002313.59,ABSP("RXI"),15,"I"),".")  ;start FM dt/tm
 ..S ABSP("BILLIT")=0
 ..I $$MCR^ABSPPAT(ABSP("PDFN"),ABSP("RLSDT"))=1 S ABSP("BILLIT")=1
 ..I $$RR^ABSPPAT(ABSP("PDFN"),ABSP("RLSDT"))=1 S ABSP("BILLIT")=1
 ..I $$MCD^ABSPPAT(ABSP("PDFN"),ABSP("RLSDT"))=1 S ABSP("BILLIT")=1
 ..I $$PI^ABSPPAT(ABSP("PDFN"),ABSP("RLSDT"))=1 S ABSP("BILLIT")=1
 ..Q:(ABSP("BILLIT")=0)  ;didn't find billable ins-stop here
 ..S ABSP("BILLIT")=1
 ..Q:(ABSP("BILLIT")=0)  ;0 means E PAYABLE; don't do again
 ..I $D(^XTMP("ABSP-BFBBL",$J,ABSP("RXI"),$P(^DPT(ABSP("PDFN"),0),U))) Q
 ..I $D(^XTMP("ABSP-BFBBL-S",$J,ABSP("RXI"))) K ^XTMP("ABSP-BFBBL",$J,ABSP("RXI"),$P(^DPT(ABSP("PDFN"),0),U)) Q
 ..S ^XTMP("ABSP-BFBBL",$J,ABSP("RXI"),$P(^DPT(ABSP("PDFN"),0),U),ABSP("RXI"))=""
 D PRINT
 K ^XTMP("ABSP-BFBBL",$J)
 Q
DT ;
 Q:$D(DIRUT)
 W !!," ============ Entry of TRANSACTION LAST UPDATED Range =============",!
 S DIR("A")="Enter STARTING TRANSACTION LAST UPDATED for Report"
 S DIR(0)="DO^:DT:EP"
 D ^DIR
 G DT:$D(DIRUT)
 S ABSPY("DT",1)=Y
 W !
 S DIR("A")="Enter ENDING DATE for Report"
 D ^DIR
 K DIR
 G DT:$D(DIRUT)
 S ABSPY("DT",2)=Y
 I ABSPY("DT",1)>ABSPY("DT",2) W !!,*7,"INPUT ERROR: Start Date is Greater than than the End Date, TRY AGAIN!",!! G DT
 Q
OUTPUT ;EP
 K DIR
 S DIR(0)="SO^1:Simple Output;2:Delimited Output"
 S DIR("A")="Select TYPE of LISTING"
 D ^DIR
 K DIR
 Q:$D(DIRUT)
 S ABSPY("RTYP")=Y
 S ABSPY("RTYP","NM")=Y(0)
 Q
DEVICE ;
 U IO
 I ABSPY("RTYP")=2 D  Q  ;delim
 .;path,filenm
 .K DIR
 .S DIR(0)="F"
 .S DIR("A")="Path"
 .D ^DIR
 .K DIR
 .Q:$D(DIRUT)
 .S ABSP("RPATH")=Y
 .K DIR
 .S DIR(0)="F"
 .S DIR("A")="Filename"
 .D ^DIR
 .K DIR
 .Q:$D(DIRUT)
 .S ABSP("RFN")=Y
 .D COMPUTE
 ;simple
 S %ZIS("A")="Output DEVICE: "
 S %ZIS="PQ"
 D ^%ZIS
 G XIT:POP
 I IO'=IO(0),IOT'="HFS" D  Q
 .D QUE
 .D HOME^%ZIS
 W:'$D(IO("S")) !!,"Printing..."
 D COMPUTE
 Q
QUE ;
 I IO=IO(0) W !,"Cannot Queue to Screen or Slave Printer!",! G DEVICE
 S ZTRTN="TSK^ABSPPRPT"
 S ZTDESC="ABSP Backbilling Needed Report"
 F ABSP="ZTRTN","ZTDESC","ABSPY(" S ZTSAVE(ABSP)=""
 D ^%ZTLOAD
 D ^%ZISC
 I $D(ZTSK) W !,"(Job Queued, Task Number: ",ZTSK,")"
 G XIT
 Q
TSK ;
 S ABMP("Q")=""
 D COMPUTE
 Q
PRINT ;
 I ABSPY("RTYP")=2 D DELIMIT Q
 S ABSPY("PG")=1
 S ABSP("BUSA")=$$LOG^BUSAAPI("A","S","","ABSPPRPT","ABSP: Prescriptions need backbill Report","")
 W $$EN^ABSPVDF("IOF")
 S ABSP("RXCNT")=0
 S ABSP("BAMT")=0
 D WHDR
 I '$D(^XTMP("ABSP-BFBBL",$J)) W !!,"NO DATA TO REPORT" Q
 S ABSPIEN=0
 F  S ABSPIEN=$O(^XTMP("ABSP-BFBBL",$J,ABSPIEN)) Q:'ABSPIEN  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .S ABSPNM=""
 .F  S ABSPNM=$O(^XTMP("ABSP-BFBBL",$J,ABSPIEN,ABSPNM)) Q:ABSPNM=""  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ..S ABSP("RXI")=0
 ..F  S ABSP("RXI")=$O(^XTMP("ABSP-BFBBL",$J,ABSPIEN,ABSPNM,ABSP("RXI"))) Q:'ABSP("RXI")  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ...I $Y>(IOSL-5) D PAZ Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  D WHDR Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W !," (cont.)",!
 ...W !,"      Patient: "_ABSPNM
 ...S ABSP("PDFN")=$P($G(^ABSPT(ABSP("RXI"),0)),U,6)  ;patient DFN
 ...W !," Chart Number: "_$P($G(^AUPNPAT(ABSP("PDFN"),41,DUZ(2),0)),U,2)
 ...W !,"       RX IEN: "_ABSPIEN
 ...W !,"         RX #: "_$P($G(^PSRX($P(ABSPIEN,"."),0)),U)
 ...W !,"         Drug: "_$P($G(^PSDRUG($P($G(^PSRX($P($G(^ABSPT(ABSP("RXI"),1)),U,11),0)),U,6),0)),U)  ;DRUG
 ...I $P($G(^PSDRUG($P($G(^PSRX($P($G(^ABSPT(ABSP("RXI"),1)),U,11),0)),U,6),0)),U,3)["9" W " (OTC)"
 ...S ABSP("RXR")=$P($G(^ABSPT(ABSP("RXI"),1)),U)
 ...S ABSP("FILLDT")=$P($G(^PSRX($P($G(^ABSPT(ABSP("RXI"),1)),U,11),1,ABSP("RXR"),0)),U)
 ...I +ABSP("FILLDT")=0 S ABSP("FILLDT")=$P($G(^PSRX($P($G(^ABSPT(ABSP("RXI"),1)),U,11),2)),U,2)
 ...W !,"    Fill Date: "_$$HUMDATE^ABSPUTL(ABSP("FILLDT"))
 ...W !,"  Bill Amount: $"_$FN($P($G(^ABSPT(ABSP("RXI"),5)),U,5),",",2)  ;TOTAL PRICE
 ...W !,"     Pharmacy: "_$$GET1^DIQ(9002313.59,ABSP("RXI"),1.07,"E")
 ...S ABSP("RXCNT")=ABSP("RXCNT")+1
 ...S ABSP("BAMT")=ABSP("BAMT")+$P($G(^ABSPT(ABSP("RXI"),5)),U,5)
 ...W !,"  Eligibility: "
 ...D ELIG
 ...I '$D(ABSP("ELIG")) W "No insurance"
 ...S ABSP("RXS")=0
 ...F  S ABSP("RXS")=$O(ABSP("ELIG",ABSP("RXS"))) Q:'ABSP("RXS")  D
 ....S ABSP("INS")=0
 ....F  S ABSP("INS")=$O(ABSP("ELIG",ABSP("RXS"),ABSP("INS"))) Q:'ABSP("INS")  D
 .....W ?15
 .....W $S($P($G(^AUTNINS(ABSP("INS"),2)),U,3)="P":"(POS) ",1:"")
 .....I ABSP("INS")=3 W $P(ABSP("ELIG",ABSP("RXS"),ABSP("INS")),U,3)_" "
 .....W $P($G(^AUTNINS(ABSP("INS"),0)),U)_" "
 .....I "^MEDICARE^RAILROAD RETIREMENT^"'[("^"_$P($G(^AUTNINS(ABSP("INS"),0)),U)_"^") D
 ......W $$HUMDATE^ABSPUTL($P(ABSP("ELIG",ABSP("RXS"),ABSP("INS")),U))_" - "_$S($P(ABSP("ELIG",ABSP("RXS"),ABSP("INS")),U,2)'="":$$HUMDATE^ABSPUTL($P(ABSP("ELIG",ABSP("RXS"),ABSP("INS")),U,2)),1:"<NO END DT>")
 .....I "^MEDICARE^RAILROAD RETIREMENT^"[("^"_$P($G(^AUTNINS(ABSP("INS"),0)),U)_"^") D
 ......S ABSPCT=""
 ......F  S ABSPCT=$O(ABSP("ELIG",ABSP("RXS"),ABSP("INS"),ABSPCT)) Q:(ABSPCT="")  D
 .......W !?17,"-"_ABSPCT_" "
 .......W $$HUMDATE^ABSPUTL($P(ABSP("ELIG",ABSP("RXS"),ABSP("INS"),ABSPCT),U))_" - "_$S($P(ABSP("ELIG",ABSP("RXS"),ABSP("INS"),ABSPCT),U,2)'="":$$HUMDATE^ABSPUTL($P(ABSP("ELIG",ABSP("RXS"),ABSP("INS"),ABSPCT),U,2)),1:"<NO END DT>")
 .....W !
 ...W !
 ...F ABSP=1:1:50 W "-"
 W !!,ABSP("RXCNT")_" Prescriptions for $"_$FN(ABSP("BAMT"),",",2)
 W !!,"E N D   O F   R E P O R T",!
 Q
WHDR ;
 W !,"WARNING: Confidential Patient Information, Privacy Act Applies",!
 D NOW^%DTC
HDR ;
 W !,"Prescriptions Needing Backbilling Report",?50 S Y=% X ^DD("DD") W Y,$S($G(ABSPY("RTYP"))=1:"  Page "_ABSPY("PG"),1:"")
 W !,"For Date Range "_$$HUMDATE^ABSPUTL(ABSPY("DT",1))_" to "_$$HUMDATE^ABSPUTL(ABSPY("DT",2)),!
 S ABSPY("PG")=+$G(ABSPY("PG"))+1
 I $G(ABSPY("RTYP"))=1 F ABSP=1:1:50 W "-"
 Q
DELIMIT ;
 D OPEN^%ZISH("ABSP",ABSP("RPATH"),ABSP("RFN"),"W")
 Q:POP
 U IO
 D WHDR
 W !,"Patient^Chart Number^DOB^RX IEN^RX#^Drug^Fill Date^Bill Amount^Pharmacy^Eligibility"
 I '$D(^XTMP("ABSP-BFBBL",$J)) W !!,"NO DATA TO REPORT" D CLOSE^%ZISH("ABSP") U 0 Q
 S ABSPIEN=0
 F  S ABSPIEN=$O(^XTMP("ABSP-BFBBL",$J,ABSPIEN)) Q:'ABSPIEN  D
 .S ABSPNM=""
 .F  S ABSPNM=$O(^XTMP("ABSP-BFBBL",$J,ABSPIEN,ABSPNM)) Q:ABSPNM=""  D
 ..S ABSP("RXI")=0
 ..F  S ABSP("RXI")=$O(^XTMP("ABSP-BFBBL",$J,ABSPIEN,ABSPNM,ABSP("RXI"))) Q:'ABSP("RXI")  D
 ...W !,ABSPNM_U  ;pt name
 ...S ABSP("PDFN")=$P($G(^ABSPT(ABSP("RXI"),0)),U,6)  ;PDFN
 ...W $P($G(^AUPNPAT(ABSP("PDFN"),41,DUZ(2),0)),U,2)_U  ;HRN
 ...W $$Y2KDT^ABSPUTL($P($G(^DPT(ABSP("PDFN"),0)),U,3))_U  ;DOB
 ...W ABSPIEN_U  ;RX IEN
 ...W $P($G(^PSRX($P(ABSPIEN,"."),0)),U)_U  ;RX#
 ...W $P($G(^PSDRUG($P($G(^PSRX($P($G(^ABSPT(ABSP("RXI"),1)),U,11),0)),U,6),0)),U)  ;DRUG
 ...I $P($G(^PSDRUG($P($G(^PSRX($P($G(^ABSPT(ABSP("RXI"),1)),U,11),0)),U,6),0)),U,3)["9" W " (OTC)"
 ...W U  ;for after drug and maybe OTC tag
 ...S ABSP("RXR")=$P($G(^ABSPT(ABSP("RXI"),1)),U)
 ...S ABSP("FILLDT")=$P($G(^PSRX($P($G(^ABSPT(ABSP("RXI"),1)),U,11),1,ABSP("RXR"),0)),U)
 ...I +ABSP("FILLDT")=0 S ABSP("FILLDT")=$P($G(^PSRX($P($G(^ABSPT(ABSP("RXI"),1)),U,11),2)),U,2)
 ...W $$HUMDATE^ABSPUTL(ABSP("FILLDT"))_U
 ...W $J($P($G(^ABSPT(ABSP("RXI"),5)),U,5),9,2)_U  ;TOTAL PRICE
 ...W $$GET1^DIQ(9002313.59,ABSP("RXI"),1.07,"E")_U
 ...D ELIG
 ...I '$D(ABSP("ELIG")) W "No insurance"_U
 ...S ABSP("RXS")=0
 ...;
 ...I '$D(ABSP("ELIG",1)) S ABSPR=U
 ...E  S ABSPR=""
 ...F  S ABSP("RXS")=$O(ABSP("ELIG",ABSP("RXS"))) Q:'ABSP("RXS")  D
 ....S ABSP("INS")=0
 ....F  S ABSP("INS")=$O(ABSP("ELIG",ABSP("RXS"),ABSP("INS"))) Q:'ABSP("INS")  D
 .....S ABSPREC=ABSPR_$S($P($G(^AUTNINS(ABSP("INS"),2)),U,3)="P":"(POS) ",1:"")
 .....I ABSP("INS")=3 S ABSPREC=ABSPREC_" "_$P(ABSP("ELIG",ABSP("RXS"),ABSP("INS")),U,3)_" "
 .....S ABSPREC=ABSPREC_$P($G(^AUTNINS(ABSP("INS"),0)),U)_" "
 .....I "^MEDICARE^RAILROAD RETIREMENT^"'[("^"_$P($G(^AUTNINS(ABSP("INS"),0)),U)_"^") D
 ......W ABSPREC
 ......W $$HUMDATE^ABSPUTL($P(ABSP("ELIG",ABSP("RXS"),ABSP("INS")),U))_" - "_$S($P(ABSP("ELIG",ABSP("RXS"),ABSP("INS")),U,2)'="":$$HUMDATE^ABSPUTL($P(ABSP("ELIG",ABSP("RXS"),ABSP("INS")),U,2)),1:"<NO END DT>")_U
 .....I "^MEDICARE^RAILROAD RETIREMENT^"[("^"_$P($G(^AUTNINS(ABSP("INS"),0)),U)_"^") D
 ......S ABSPCT=""
 ......F  S ABSPCT=$O(ABSP("ELIG",ABSP("RXS"),ABSP("INS"),ABSPCT)) Q:(ABSPCT="")  D
 .......W ABSPREC
 .......W "-"_ABSPCT_" "
 .......W $$HUMDATE^ABSPUTL($P(ABSP("ELIG",ABSP("RXS"),ABSP("INS"),ABSPCT),U))_" - "_$S($P(ABSP("ELIG",ABSP("RXS"),ABSP("INS"),ABSPCT),U,2)'="":$$HUMDATE^ABSPUTL($P(ABSP("ELIG",ABSP("RXS"),ABSP("INS"),ABSPCT),U,2)),1:"<NO END DT>")_U
 W !!,"E N D   O F   R E P O R T",!
 D CLOSE^%ZISH("ABSP")
 U 0
 Q
PAZ ;
 I '$D(IO("Q")),$E(IOST)="C",'$D(IO("S")) D
 .F  W ! Q:$Y+3>IOSL
 .K DIR
 .S DIR(0)="E"
 .D ^DIR
 .K DIR
 Q
 ;
XIT ;
 K ABSP,DIQ
 K ^XTMP("ABSP-BFBBL",$J)
 K ^XTMP("ABSP-BFBBL-S",$J)
 Q
ELIG ;
 K ABSP("ELIG")
 ;pi
 S ABSPPI=0
 F  S ABSPPI=$O(^AUPNPRVT(ABSP("PDFN"),11,ABSPPI)) Q:'ABSPPI  D
 .S ABSP("ISDT")=$P($G(^AUPNPRVT(ABSP("PDFN"),11,ABSPPI,0)),U,6)
 .S ABSP("IEDT")=$S($P($G(^AUPNPRVT(ABSP("PDFN"),11,ABSPPI,0)),U,7)'="":$P(^(0),U,7),1:9999999)
 .I ((ABSP("ISDT")>ABSP("FILLDT"))!(ABSP("FILLDT")>ABSP("IEDT"))) Q  ;fill dt before start or after end
 .S ABSP("INS")=$P($G(^AUPNPRVT(ABSP("PDFN"),11,ABSPPI,0)),U)
 .S ABSP("RXS")=$S($P($G(^AUTNINS(ABSP("INS"),2)),U,3)="P":1,1:2)
 .S ABSP("ELIG",ABSP("RXS"),ABSP("INS"))=ABSP("ISDT")_U_$S(ABSP("IEDT")'=9999999:ABSP("IEDT"),1:"")
 ;mcd
 S ABSPMCDI=0
 F  S ABSPMCDI=$O(^AUPNMCD("B",ABSP("PDFN"),ABSPMCDI)) Q:'ABSPMCDI  D
 .S ABSPPI=0
 .F  S ABSPPI=$O(^AUPNMCD(ABSPMCDI,11,ABSPPI)) Q:'ABSPPI  D
 ..S ABSP("ISDT")=$P($G(^AUPNMCD(ABSPMCDI,11,ABSPPI,0)),U)
 ..S ABSP("IEDT")=$S($P($G(^AUPNMCD(ABSPMCDI,11,ABSPPI,0)),U,2)'="":$P(^(0),U,2),1:9999999)
 ..I ((ABSP("ISDT")>ABSP("FILLDT"))!(ABSP("FILLDT")>ABSP("IEDT"))) Q  ;fill date before start or after end
 ..;S ABSP("INS")=+$P($G(^AUPNMCD(ABSPMCDI,0)),U,11)  ;plan name  ;absp*1.0*58 ADO132972
 ..S ABSP("INS")=+$P($G(^AUPNMCD(ABSPMCDI,0)),U,10)  ;plan name  ;absp*1.0*58 ADO132972
 ..S ABSP("ST")=$P($G(^AUPNMCD(ABSPMCDI,0)),U,4)  ;absp*1.0*58 ADO132972
 ..I ABSP("INS")=0 D
 ...S ABSP("INS")=$P($G(^AUPNMCD(ABSPMCDI,0)),U,2)
 ...;S ABSP("ST")=$P($G(^AUPNMCD(ABSPMCDI,0)),U,4)  ;absp*1.0*58 ADO132972
 ...I $D(^AUTNINS(ABSP("INS"),13,ABSP("ST"),0)) D
 ....S ABSP("INS")=+$P($G(^AUTNINS(ABSP("INS"),13,ABSP("ST"),0)),U,2)
 ..S:ABSP("INS")=0 ABSP("INS")=$P($G(^AUPNMCD(ABSPMCDI,0)),U,2)
 ..S ABSP("RXS")=$S($P($G(^AUTNINS(ABSP("INS"),2)),U,3)="P":1,1:2)
 ..S ABSP("ELIG",ABSP("RXS"),ABSP("INS"))=ABSP("ISDT")_U_$S(ABSP("IEDT")'=9999999:ABSP("IEDT"),1:"")_U_$P($G(^DIC(5,ABSP("ST"),0)),U,2)
 ;mcr
 S ABSP("INS")=$P($G(^AUPNMCR(ABSP("PDFN"),0)),U,2)
 S ABSPPI=0
 F  S ABSPPI=$O(^AUPNMCR(ABSP("PDFN"),11,ABSPPI)) Q:'ABSPPI  D
 .S ABSP("ISDT")=+$P($G(^AUPNMCR(ABSP("PDFN"),11,ABSPPI,0)),U)
 .Q:(ABSP("ISDT")=0)  ;no start dt (saw this during alpha); skip these
 .S ABSP("IEDT")=$S($P($G(^AUPNMCR(ABSP("PDFN"),11,ABSPPI,0)),U,2)'="":$P(^(0),U,2),1:9999999)
 .I ((ABSP("ISDT")>ABSP("FILLDT"))!(ABSP("FILLDT")>ABSP("IEDT"))) Q  ;fill date before start or after end
 .S ABSP("RXS")=$S($P($G(^AUTNINS(ABSP("INS"),2)),U,3)="P":1,1:2)
 .S ABSP("ELIG",ABSP("RXS"),ABSP("INS"),$P($G(^AUPNMCR(ABSP("PDFN"),11,ABSPPI,0)),U,3))=ABSP("ISDT")_U_$S(ABSP("IEDT")'=9999999:ABSP("IEDT"),1:"")
 ;rr
 S ABSP("INS")=$P($G(^AUPNRRE(ABSP("PDFN"),0)),U,2)
 S ABSPPI=0
 F  S ABSPPI=$O(^AUPNRRE(ABSP("PDFN"),11,ABSPPI)) Q:'ABSPPI  D
 .S ABSP("ISDT")=$P($G(^AUPNRRE(ABSP("PDFN"),11,ABSPPI,0)),U)
 .S ABSP("IEDT")=$S($P($G(^AUPNRRE(ABSP("PDFN"),11,ABSPPI,0)),U,2)'="":$P(^(0),U,2),1:9999999)
 .I ((ABSP("ISDT")>ABSP("FILLDT"))!(ABSP("FILLDT")>ABSP("IEDT"))) Q  ;fill date before start or after end
 .S ABSP("RXS")=$S($P($G(^AUTNINS(ABSP("INS"),2)),U,3)="P":1,1:2)
 .S ABSP("ELIG",ABSP("RXS"),ABSP("INS"),$P($G(^AUPNRRE(ABSP("PDFN"),11,ABSPPI,0)),U,3))=ABSP("ISDT")_U_$S(ABSP("IEDT")'=9999999:ABSP("IEDT"),1:"")
 Q
