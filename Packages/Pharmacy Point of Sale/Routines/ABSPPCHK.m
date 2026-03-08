ABSPPCHK ; /IHS/SD/SDR - ABSP TASKED PRESCRIPTION with new elig check ; 12/18/2024 ;
 ;;1.0;PHARMACY POINT OF SALE;**57**;01 JUN 2001;Build 131
 ;IHS/SD/SDR 1.0*57 ADO125991 New routine
 Q
EN ;
 K ^XTMP("ABSP-BFBBL",$J)
 S U="^"
 S ABSPSET=$$LOG^BUSAAPI("A","S","","ABSPPCHK","ABSP: Tasked prescription backbilling check","")
 S ABSP("BBL")=+$P($G(^ABSP(9002313.99,1,6000)),U,4)
 I ABSP("BBL")=0 S ABSP("BBL")=90  ;default to 90 days if it answered
 ;
 S X1=DT  ;today
 S X2=-ABSP("BBL")
 D C^%DTC
 S ABSP("BBLDT")=X-.0000001  ;this is the start date-a tiny bit to get the whole day
 S ABSP("EBBLDT")=DT+.999999
 ;
 F  S ABSP("BBLDT")=$O(^ABSPT("AI","PAPER",ABSP("BBLDT"))) Q:'ABSP("BBLDT")!((ABSP("BBLDT")>ABSP("EBBLDT")))  D
 .S ABSP("RXI")=0
 .F  S ABSP("RXI")=$O(^ABSPT("AI","PAPER",ABSP("BBLDT"),ABSP("RXI"))) Q:'ABSP("RXI")  D
 ..S ABSP("PDFN")=$P($G(^ABSPT(ABSP("RXI"),0)),U,6)  ;patient
 ..S ABSP("RXDFN")=$P($G(^ABSPT(ABSP("RXI"),1)),U,11)  ;prescription DFN
 ..;
 ..I $D(^XTMP("ABSP-BFBBL",$J,"SKIP",ABSP("RXDFN"))) Q
 ..S ABSPRSLT=$$GET1^DIQ(9002313.59,ABSP("RXI"),4.0099,"E")
 ..I ABSPRSLT'="PAPER" S ^XTMP("ABSP-BFBBL",$J,"SKIP",ABSP("RXDFN"))=1 Q  ;only paper claims
 ..I ABSPRSLT["DUPLICATE" S ^XTMP("ABSP-BFBBL",$J,"SKIP",ABSP("RXDFN"))=1 Q  ;no duplicates
 ..I $$GET1^DIQ(9002313.59,ABSP("RXI"),202,"E")'["No insurance" S ^XTMP("ABSP-BFBBL",$J,"SKIP",ABSP("RXDFN"))=1 Q
 ..I +$P($G(^ABSPT(ABSP("RXI"),1)),U,6)'=0 S ^XTMP("ABSP-BFBBL",$J,"SKIP",ABSP("RXDFN"))=1 Q  ;they have an insurer
 ..;
 ..S ABSP("RSTTXT")=$$GET1^DIQ(9002313.59,ABSP("RXI"),202,"E")
 ..I (ABSP("RSTTXT")["Reversed paper claim") D  Q
 ...S ^XTMP("ABSP-BFBBL",$J,"SKIP",ABSP("RXDFN"))=1  ;keep track of ones to skip
 ...K ^XTMP("ABSP-BFBBL",$J,ABSP("RXDFN"),$P(^DPT(ABSP("PDFN"),0),U))
 ..I $$GET1^DIQ(9002313.59,ABSP("RXI"),4,"E")'="" Q  ;entry has a response
 ..I +$$GET1^DIQ(52,ABSP("RXDFN"),32.1,"I")'=0 Q  ;this is RETURNED TO STOCK (it's a date)
 ..I $P($G(^AUPNPAT(ABSP("PDFN"),4)),U,7)'>(ABSP("BBLDT")) Q
 ..;
 ..;if it gets here the patient was updated somehow, after the prescription was billed
 ..;check if they have eligibility now
 ..S ABSP("RLSDT")=$P($$GET1^DIQ(9002313.59,ABSP("RXI"),15,"I"),".")  ;state date/time in FM format
 ..S ABSP("BILLIT")=0
 ..I $$MCR^ABSPPAT(ABSP("PDFN"),ABSP("RLSDT"))=1 S ABSP("BILLIT")=1
 ..I $$RR^ABSPPAT(ABSP("PDFN"),ABSP("RLSDT"))=1 S ABSP("BILLIT")=1
 ..I $$MCD^ABSPPAT(ABSP("PDFN"),ABSP("RLSDT"))=1 S ABSP("BILLIT")=1
 ..I $$PI^ABSPPAT(ABSP("PDFN"),ABSP("RLSDT"))=1 S ABSP("BILLIT")=1
 ..Q:(ABSP("BILLIT")=0)  ;didn't find a billable insurer so quit - stop here
 ..;
 ..S ABSP("BILLIT")=1
 ..I $D(^XTMP("ABSP-BFBBL",$J,ABSP("RXDFN"),ABSP("PDFN"))) Q
 ..S ^XTMP("ABSP-BFBBL",$J,ABSP("RXDFN"),ABSP("PDFN"),ABSP("RXI"))=+$P($G(^ABSPT(ABSP("RXI"),1)),U,1)
 ..;
 ..;W !,ABSP("RXI")_" "_$P($G(^ABSPTL(ABSP("RXI"),0)),"^")
 ;
 S ABSP("RXDFN")=0
 F  S ABSP("RXDFN")=$O(^XTMP("ABSP-BFBBL",$J,ABSP("RXDFN"))) Q:'ABSP("RXDFN")  D
 .S ABSP("PDFN")=0
 .F  S ABSP("PDFN")=$O(^XTMP("ABSP-BFBBL",$J,ABSP("RXDFN"),ABSP("PDFN"))) Q:'ABSP("PDFN")  D
 ..S ABSP("RXI")=0
 ..F  S ABSP("RXI")=$O(^XTMP("ABSP-BFBBL",$J,ABSP("RXDFN"),ABSP("PDFN"),ABSP("RXI"))) Q:'ABSP("RXI")  D
 ...S ^ABSPTPCK(DT,ABSP("PDFN"),ABSP("RXI"))=""
 ...;set vars and call ABSP entry point to create claim
 ...S RXI=$P($G(^ABSPT(ABSP("RXI"),1)),U,11)  ;prescription IEN
 ...S RXR=$G(^XTMP("ABSP-BFBBL",$J,ABSP("RXDFN"),ABSP("PDFN"),ABSP("RXI")))  ;refill
 ...D CLAIM^ABSPOSRX(RXI,RXR)
 ...H 1
 D POKE^ABSPOS2D  ;just to make sure it is going at the end
 K ^XTMP("ABSP-BFBBL",$J)
 Q
