ABSPPRP2 ; /IHS/SD/SDR - ABSP PRESCRIPTION with new elig report ; 12/18/2024 ;
 ;;1.0;PHARMACY POINT OF SALE;**57,58**;01 JUN 2001;Build 131
 ;IHS/SD/SDR 1.0*57 ADO125991 New routine
 ;  The BEFORE^ABSPPRPT is for the report to display prescriptions that the backbilling check WILL process,
 ;  if it is tasked to run.
 ;  The AFTER^ABSPPRP2 is to report prescriptions that WERE resubmitted for payment and the results
 ;IHS/SD/SDR 1.0*58 ADO132972 - fixed <UNDEF>ELIG+27^ABSPPRPT; wasn't using right piece to get plan name
 Q
AFTER ;
COMPUTE ;
 K ^XTMP("ABSP-BFBBL",$J)
 S ABSP("BBLDT")=ABSPY("DT",1)-.0000001  ;this is the start date-a tiny bit back to get the whole day
 S ABSP("EBBLDT")=ABSPY("DT",2)+.999999  ;include the whole day
 ;
 F  S ABSP("BBLDT")=$O(^ABSPTPCK(ABSP("BBLDT"))) Q:'ABSP("BBLDT")!((ABSP("BBLDT")>ABSP("EBBLDT")))  D
 .S ABSP("PDFN")=0
 .F  S ABSP("PDFN")=$O(^ABSPTPCK(ABSP("BBLDT"),ABSP("PDFN"))) Q:'ABSP("PDFN")  D
 ..S ABSP("RXI")=0
 ..F  S ABSP("RXI")=$O(^ABSPTPCK(ABSP("BBLDT"),ABSP("PDFN"),ABSP("RXI"))) Q:'ABSP("RXI")  D
 ...S ABSP("RXDFN")=$P($G(^ABSPT(ABSP("RXI"),1)),U,11)  ;prescription DFN
 ...S ABSP("PDFN")=$P($G(^ABSPT(ABSP("RXI"),0)),U,6)  ;patient
 ...S ^XTMP("ABSP-BFBBL",$J,ABSP("BBLDT"),$P(^DPT(ABSP("PDFN"),0),U),ABSP("RXI"))=""
 D PRINT
 Q
 ;
PRINT ;
 I ABSPY("RTYP")=2 D DELIMIT Q  ;delimited output
 S ABSPY("PG")=1
 S ABSP("BUSA")=$$LOG^BUSAAPI("A","S","","ABSPPPRPT","ABSP: Prescriptions needed backbill Report","")
 W $$EN^ABSPVDF("IOF")
 S ABSP("RXCNT")=0
 S ABSP("BAMT")=0
 D WHDR
 I '$D(^XTMP("ABSP-BFBBL",$J)) W !!,"NO DATA TO REPORT" Q
 S ABSPSDT=0
 F  S ABSPSDT=$O(^XTMP("ABSP-BFBBL",$J,ABSPSDT)) Q:'ABSPSDT  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .S ABSPNM=""
 .F  S ABSPNM=$O(^XTMP("ABSP-BFBBL",$J,ABSPSDT,ABSPNM)) Q:ABSPNM=""  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ..S ABSP("RXI")=0
 ..F  S ABSP("RXI")=$O(^XTMP("ABSP-BFBBL",$J,ABSPSDT,ABSPNM,ABSP("RXI"))) Q:'ABSP("RXI")  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ...I $Y>(IOSL-5) D PAZ Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  D WHDR Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W !," (cont.)",!
 ...W !,"      Patient: "_ABSPNM
 ...S ABSPIEN=$P($G(^ABSPT(ABSP("RXI"),1)),U,11)  ;Prescription DFN
 ...S ABSP("PDFN")=$P($G(^ABSPT(ABSP("RXI"),0)),U,6)  ;patient DFN
 ...S ABSP("CDFN")=$$GET1^DIQ(9002313.59,ABSP("RXI"),"3.1","I"),ABSP("CLMP")=$$GET1^DIQ(9002313.59,ABSP("RXI"),"14","I")
 ...I (+ABSP("CDFN")) D
 ....S ABSP("TLDFN")=0
 ....S ABSP("TLF")=0
 ....F  S ABSP("TLDFN")=$O(^ABSPTL("AE",ABSP("CDFN"),ABSP("TLDFN"))) Q:'ABSP("TLDFN")!(ABSP("TLF")=1)  D  Q:(ABSP("TLF")=1)
 .....I ($P($G(^ABSPTL(ABSP("TLDFN"),0)),U,9)'=ABSP("CLMP")) Q
 .....S ABSP("TLF")=1
 ...S:(+ABSP("CDFN")=0) ABSP("TLDFN")=0
 ...W !," Chart Number: "_$P($G(^AUPNPAT(ABSP("PDFN"),41,DUZ(2),0)),U,2)
 ...W !,"       RX IEN: "_ABSP("RXI")
 ...W !,"         RX #: "_$P($G(^PSRX(ABSPIEN,0)),U)
 ...W !,"         Drug: "_$P($G(^PSDRUG($P($G(^PSRX($P($G(^ABSPT(ABSP("RXI"),1)),U,11),0)),U,6),0)),U)  ;DRUG
 ...I $P($G(^PSDRUG($P($G(^PSRX($P($G(^ABSPT(ABSP("RXI"),1)),U,11),0)),U,6),0)),U,3)["9" W " (OTC)"  ;label as OTC
 ...S ABSP("RXR")=$P($G(^ABSPT(ABSP("RXI"),1)),U)
 ...S ABSP("FILLDT")=$P($G(^PSRX($P($G(^ABSPT(ABSP("RXI"),1)),U,11),1,ABSP("RXR"),0)),U)
 ...I +ABSP("FILLDT")=0 S ABSP("FILLDT")=$P($G(^PSRX($P($G(^ABSPT(ABSP("RXI"),1)),U,11),2)),U,2)
 ...W !,"    Fill Date: "_$$HUMDATE^ABSPUTL(ABSP("FILLDT"))
 ...W !,"  Amount Paid: $"_$FN($$GET1^DIQ(9002313.57,+$G(ABSP("TLDFN")),"9999.96","E"),",",2)  ;TOTAL AMOUNT PAID
 ...W !,"     Pharmacy: "_$$GET1^DIQ(9002313.59,ABSP("RXI"),1.07,"E")  ;pharmacy
 ...W !,"       Result: "_$$GET1^DIQ(9002313.59,ABSP("RXI"),4.0099,"E")  ;result
 ...;
 ...I $$GET1^DIQ(9002313.59,ABSP("RXI"),4.0099,"E")["E PAYABLE" D
 ....S ABSP("RXCNT")=ABSP("RXCNT")+1
 ....S ABSP("BAMT")=ABSP("BAMT")+$$GET1^DIQ(9002313.57,ABSP("TLDFN"),"9999.96","E")
 ...;
 ...I $$GET1^DIQ(9002313.59,ABSP("RXI"),4.0099,"E")["E REJECT" D
 ....S ABSPCLM=$P($G(^ABSPT(ABSP("RXI"),0)),U,4)
 ....S ABSPRXI=$O(^ABSPTL("AE",ABSPCLM,0))
 ....W !," Reject codes: "_$$GET1^DIQ(9002313.57,ABSPRXI,10511,"E")
 ...;W !,"Transaction Last Updated: "_$$HUMDTIME^ABSPUTL($P($G(^ABSPTL(ABSP("RXI"),0)),U,8))  ;date and time
 ...;W !,"Registration Last Updated: "_$$HUMDTIME^ABSPUTL($P($G(^AUPNPAT($P($G(^ABSPTL(ABSP("RXI"),0)),U,6),4)),U,7))  ;date and time
 ...W !," Eligibility: "
 ...D ELIG
 ...I '$D(ABSP("ELIG")) W "No insurance"
 ...S ABSP("RXS")=0
 ...F  S ABSP("RXS")=$O(ABSP("ELIG",ABSP("RXS"))) Q:'ABSP("RXS")  D
 ....S ABSP("INS")=0
 ....F  S ABSP("INS")=$O(ABSP("ELIG",ABSP("RXS"),ABSP("INS"))) Q:'ABSP("INS")  D
 .....W ?15
 .....W $S($P($G(^AUTNINS(ABSP("INS"),2)),U,3)="P":"(POS) ",1:"")  ;'POS' if RX BILLING STATUS is P
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
 W !!,ABSP("RXCNT")_" E-PAYABLE Prescriptions for $"_$FN(ABSP("BAMT"),",",2)
 W !!,"E N D   O F   R E P O R T",!
 Q
WHDR ;
 W !,"WARNING: Confidential Patient Information, Privacy Act Applies",!
 D NOW^%DTC
HDR ;
 W !,"Prescriptions Backbilled Report",?50 S Y=% X ^DD("DD") W Y,$S($G(ABSPY("RTYP"))=1:"  Page "_ABSPY("PG"),1:"")
 W !,"For Date Range "_$$HUMDATE^ABSPUTL(ABSPY("DT",1))_" to "_$$HUMDATE^ABSPUTL(ABSPY("DT",2)),!
 S ABSPY("PG")=+$G(ABSPY("PG"))+1
 I $G(ABSPY("RTYP"))=1 F ABSP=1:1:50 W "-"
 Q
DELIMIT ;
 D OPEN^%ZISH("ABSP",ABSP("RPATH"),ABSP("RFN"),"W")
 Q:POP
 U IO
 D WHDR
 W !,"Patient^Chart Number^DOB^RX IEN^RX#^Drug^Fill Date^Amount Paid^Pharmacy^Result^Reject codes^Eligibility"
 I '$D(^XTMP("ABSP-BFBBL",$J)) W !!,"NO DATA TO REPORT" D CLOSE^%ZISH("ABSP") U 0 Q
 S ABSPSDT=0
 F  S ABSPSDT=$O(^XTMP("ABSP-BFBBL",$J,ABSPSDT)) Q:'ABSPSDT  D
 .S ABSPNM=""
 .F  S ABSPNM=$O(^XTMP("ABSP-BFBBL",$J,ABSPSDT,ABSPNM)) Q:ABSPNM=""  D
 ..S ABSP("RXI")=0
 ..F  S ABSP("RXI")=$O(^XTMP("ABSP-BFBBL",$J,ABSPSDT,ABSPNM,ABSP("RXI"))) Q:'ABSP("RXI")  D
 ...W !,ABSPNM_U  ;patient name
 ...S ABSP("PDFN")=$P($G(^ABSPT(ABSP("RXI"),0)),U,6)  ;patient DFN
 ...S ABSPIEN=$P($G(^ABSPT(ABSP("RXI"),1)),U,11)  ;Prescription DFN
 ...S ABSP("PDFN")=$P($G(^ABSPT(ABSP("RXI"),0)),U,6)
 ...S ABSP("CDFN")=$$GET1^DIQ(9002313.59,ABSP("RXI"),"3.1","I"),ABSP("CLMP")=$$GET1^DIQ(9002313.59,ABSP("RXI"),"14","I")
 ...I (+ABSP("CDFN")) D
 ....S ABSP("TLDFN")=0
 ....S ABSP("TLF")=0
 ....F  S ABSP("TLDFN")=$O(^ABSPTL("AE",ABSP("CDFN"),ABSP("TLDFN"))) Q:'ABSP("TLDFN")!(ABSP("TLF")=1)  D  Q:(ABSP("TLF")=1)
 .....I ($P($G(^ABSPTL(ABSP("TLDFN"),0)),U,9)'=ABSP("CLMP")) Q
 .....S ABSP("TLF")=1
 ...S:(+ABSP("CDFN")=0) ABSP("TLDFN")=0
 ...W $P($G(^AUPNPAT(ABSP("PDFN"),41,DUZ(2),0)),U,2)_U  ;HRN
 ...W $$Y2KDT^ABSPUTL($P($G(^DPT(ABSP("PDFN"),0)),U,3))_U  ;DOB
 ...W ABSP("RXI")_U  ;RX IEN
 ...W $P($G(^PSRX(ABSPIEN,0)),U)_U  ;RX#
 ...W $P($G(^PSDRUG($P($G(^PSRX($P($G(^ABSPT(ABSP("RXI"),1)),U,11),0)),U,6),0)),U)  ;DRUG
 ...I $P($G(^PSDRUG($P($G(^PSRX($P($G(^ABSPT(ABSP("RXI"),1)),U,11),0)),U,6),0)),U,3)["9" W " (OTC)"  ;label as OTC
 ...W U
 ...S ABSP("RXR")=$P($G(^ABSPT(ABSP("RXI"),1)),U)
 ...S ABSP("FILLDT")=$P($G(^PSRX($P($G(^ABSPT(ABSP("RXI"),1)),U,11),1,ABSP("RXR"),0)),U)
 ...I +ABSP("FILLDT")=0 S ABSP("FILLDT")=$P($G(^PSRX($P($G(^ABSPT(ABSP("RXI"),1)),U,11),2)),U,2)
 ...W $$HUMDATE^ABSPUTL(ABSP("FILLDT"))_U
 ...I +$G(ABSP("TLDFN")) W $FN($$GET1^DIQ(9002313.57,+$G(ABSP("TLDFN")),"9999.96","E"),",",2)_U  ;TOTAL AMOUNT PAID
 ...E  W $FN(0,",",2)_U  ;so it writes a zero
 ...W $$GET1^DIQ(9002313.59,ABSP("RXI"),1.07,"E")_U  ;pharmacy
 ...S ABSPRX=$P($G(^ABSPT(ABSP("RXI"),0)),U)
 ...S ABSPRXI=$O(^ABSPT("B",ABSPRX,999999999999999999),-1)
 ...W $$GET1^DIQ(9002313.59,ABSPRXI,4.0099,"E")_U  ;result
 ...I $$GET1^DIQ(9002313.59,ABSP("RXI"),4.0099,"E")["E REJECT" D
 ....S ABSPCLM=$P($G(^ABSPT(ABSP("RXI"),0)),U,4)
 ....S ABSPRXI=$O(^ABSPTL("AE",ABSPCLM,0))
 ...W $S($$GET1^DIQ(9002313.57,ABSPRXI,10511,"E")'="":$$GET1^DIQ(9002313.57,ABSPRXI,10511,"E"),1: "NONE")_U
 ...D ELIG
 ...I '$D(ABSP("ELIG")) W "No insurance"_U
 ...S ABSP("RXS")=0
 ...;
 ...I '$D(ABSP("ELIG",1)) S ABSPR=U
 ...E  S ABSPR=""
 ...;
 ...F  S ABSP("RXS")=$O(ABSP("ELIG",ABSP("RXS"))) Q:'ABSP("RXS")  D
 ....S ABSP("INS")=0
 ....F  S ABSP("INS")=$O(ABSP("ELIG",ABSP("RXS"),ABSP("INS"))) Q:'ABSP("INS")  D
 .....W $S($P($G(^AUTNINS(ABSP("INS"),2)),U,3)="P":"(POS) ",1:"")  ;'POS' if RX BILLING STATUS is P
 .....I ABSP("INS")=3 W " "_$P(ABSP("ELIG",ABSP("RXS"),ABSP("INS")),U,3)_" "
 .....W $P($G(^AUTNINS(ABSP("INS"),0)),U)_" "
 .....I "^MEDICARE^RAILROAD RETIREMENT^"'[("^"_$P($G(^AUTNINS(ABSP("INS"),0)),U)_"^") D
 ......W $$HUMDATE^ABSPUTL($P(ABSP("ELIG",ABSP("RXS"),ABSP("INS")),U))_" - "_$S($P(ABSP("ELIG",ABSP("RXS"),ABSP("INS")),U,2)'="":$$HUMDATE^ABSPUTL($P(ABSP("ELIG",ABSP("RXS"),ABSP("INS")),U,2)),1:"<NO END DT>")
 .....I "^MEDICARE^RAILROAD RETIREMENT^"[("^"_$P($G(^AUTNINS(ABSP("INS"),0)),U)_"^") D
 ......S ABSPCT=""
 ......F  S ABSPCT=$O(ABSP("ELIG",ABSP("RXS"),ABSP("INS"),ABSPCT)) Q:(ABSPCT="")  D
 .......W "-"_ABSPCT_" "
 .......W $$HUMDATE^ABSPUTL($P(ABSP("ELIG",ABSP("RXS"),ABSP("INS"),ABSPCT),U))_" - "_$S($P(ABSP("ELIG",ABSP("RXS"),ABSP("INS"),ABSPCT),U,2)'="":$$HUMDATE^ABSPUTL($P(ABSP("ELIG",ABSP("RXS"),ABSP("INS"),ABSPCT),U,2)),1:"<NO END DT>")
 .....W U
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
 Q
ELIG ;
 ;ABSP("FILLDT")
 K ABSP("ELIG")
 ;private
 S ABSPPI=0
 F  S ABSPPI=$O(^AUPNPRVT(ABSP("PDFN"),11,ABSPPI)) Q:'ABSPPI  D
 .S ABSP("ISDT")=$P($G(^AUPNPRVT(ABSP("PDFN"),11,ABSPPI,0)),U,6)
 .S ABSP("IEDT")=$S($P($G(^AUPNPRVT(ABSP("PDFN"),11,ABSPPI,0)),U,7)'="":$P(^(0),U,7),1:9999999)
 .I ((ABSP("ISDT")>ABSP("FILLDT"))!(ABSP("FILLDT")>ABSP("IEDT"))) Q  ;fill date is before start or after end
 .S ABSP("INS")=$P($G(^AUPNPRVT(ABSP("PDFN"),11,ABSPPI,0)),U)
 .S ABSP("RXS")=$S($P($G(^AUTNINS(ABSP("INS"),2)),U,3)="P":1,1:2)
 .S ABSP("ELIG",ABSP("RXS"),ABSP("INS"))=ABSP("ISDT")_U_$S(ABSP("IEDT")'=9999999:ABSP("IEDT"),1:"")
 ;medicaid
 S ABSPMCDI=0
 F  S ABSPMCDI=$O(^AUPNMCD("B",ABSP("PDFN"),ABSPMCDI)) Q:'ABSPMCDI  D
 .S ABSPPI=0
 .F  S ABSPPI=$O(^AUPNMCD(ABSPMCDI,11,ABSPPI)) Q:'ABSPPI  D
 ..S ABSP("ISDT")=$P($G(^AUPNMCD(ABSPMCDI,11,ABSPPI,0)),U)
 ..S ABSP("IEDT")=$S($P($G(^AUPNMCD(ABSPMCDI,11,ABSPPI,0)),U,2)'="":$P(^(0),U,2),1:9999999)
 ..I ((ABSP("ISDT")>ABSP("FILLDT"))!(ABSP("FILLDT")>ABSP("IEDT"))) Q  ;fill date is before start or after end
 ..;S ABSP("INS")=+$P($G(^AUPNMCD(ABSPMCDI,0)),U,11)  ;plan name  ;absp*1.0*58 IHS/SD/SDR ADO132972
 ..S ABSP("INS")=+$P($G(^AUPNMCD(ABSPMCDI,0)),U,10)  ;plan name  ;absp*1.0*58 IHS/SD/SDR ADO132972
 ..S ABSP("ST")=$P($G(^AUPNMCD(ABSPMCDI,0)),U,4)  ;absp*1.0*58 IHS/SD/SDR FID132972
 ..;
 ..I ABSP("INS")=0 D
 ...S ABSP("INS")=$P($G(^AUPNMCD(ABSPMCDI,0)),U,2)
 ...;S ABSP("ST")=$P($G(^AUPNMCD(ABSPMCDI,0)),U,4)  ;absp*1.0*58 IHS/SD/SDR FID132972
 ...I $D(^AUTNINS(ABSP("INS"),13,ABSP("ST"),0)) D
 ....S ABSP("INS")=+$P($G(^AUTNINS(ABSP("INS"),13,ABSP("ST"),0)),U,2)
 ..S:ABSP("INS")=0 ABSP("INS")=$P($G(^AUPNMCD(ABSPMCDI,0)),U,2)
 ..;
 ..S ABSP("RXS")=$S($P($G(^AUTNINS(ABSP("INS"),2)),U,3)="P":1,1:2)
 ..S ABSP("ELIG",ABSP("RXS"),ABSP("INS"))=ABSP("ISDT")_U_$S(ABSP("IEDT")'=9999999:ABSP("IEDT"),1:"")_U_$P($G(^DIC(5,ABSP("ST"),0)),U,2)
 ;medicare
 S ABSP("INS")=$P($G(^AUPNMCR(ABSP("PDFN"),0)),U,2)
 S ABSPPI=0
 F  S ABSPPI=$O(^AUPNMCR(ABSP("PDFN"),11,ABSPPI)) Q:'ABSPPI  D
 .S ABSP("ISDT")=$P($G(^AUPNMCR(ABSP("PDFN"),11,ABSPPI,0)),U)
 .S ABSP("IEDT")=$S($P($G(^AUPNMCR(ABSP("PDFN"),11,ABSPPI,0)),U,2)'="":$P(^(0),U,2),1:9999999)
 .I ((ABSP("ISDT")>ABSP("FILLDT"))!(ABSP("FILLDT")>ABSP("IEDT"))) Q  ;fill date is before start or after end
 .S ABSP("RXS")=$S($P($G(^AUTNINS(ABSP("INS"),2)),U,3)="P":1,1:2)
 .S ABSP("ELIG",ABSP("RXS"),ABSP("INS"),$P($G(^AUPNMCR(ABSP("PDFN"),11,ABSPPI,0)),U,3))=ABSP("ISDT")_U_$S(ABSP("IEDT")'=9999999:ABSP("IEDT"),1:"")
 ;railroad
 S ABSP("INS")=$P($G(^AUPNRRE(ABSP("PDFN"),0)),U,2)
 S ABSPPI=0
 F  S ABSPPI=$O(^AUPNRRE(ABSP("PDFN"),11,ABSPPI)) Q:'ABSPPI  D
 .S ABSP("ISDT")=$P($G(^AUPNRRE(ABSP("PDFN"),11,ABSPPI,0)),U)
 .S ABSP("IEDT")=$S($P($G(^AUPNRRE(ABSP("PDFN"),11,ABSPPI,0)),U,2)'="":$P(^(0),U,2),1:9999999)
 .I ((ABSP("ISDT")>ABSP("FILLDT"))!(ABSP("FILLDT")>ABSP("IEDT"))) Q  ;fill date is before start or after end
 .S ABSP("RXS")=$S($P($G(^AUTNINS(ABSP("INS"),2)),U,3)="P":1,1:2)
 .S ABSP("ELIG",ABSP("RXS"),ABSP("INS"),$P($G(^AUPNRRE(ABSP("PDFN"),11,ABSPPI,0)),U,3))=ABSP("ISDT")_U_$S(ABSP("IEDT")'=9999999:ABSP("IEDT"),1:"")
 Q
