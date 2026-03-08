ABME5AMT ; IHS/ASDST/DMJ - 837 AMT Segment 
 ;;2.6;IHS Third Party Billing System;**6,8,10,31,37**;NOV 12, 2009;Build 739
 ;Transaction Set Header
 ;
 ;IHS/SD/AML 2.6*31 CR10374 Added code for A8 and EAF segments
 ;IHS/SD/SDR 2.6*37 ADO76009 Fixed pymt to be insurer specific by mult, in case same insurer twice
 ;
EP(X) ;EP HERE
 ; x=entity identifier
 S ABMEIC=X
 K ABMREC("AMT"),ABMR("AMT")
 S ABME("RTYPE")="AMT"
 D LOOP
 K ABME,ABM,ABMEIC
 Q
LOOP ;LOOP HERE
 F I=10:10:40 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("AMT"))'="" S ABMREC("AMT")=ABMREC("AMT")_"*"
 .S ABMREC("AMT")=$G(ABMREC("AMT"))_ABMR("AMT",I)
 Q
10 ;segment
 S ABMR("AMT",10)="AMT"
 Q
20 ;AMT01 - Amount Qualifier Code
 S ABMR("AMT",20)=ABMEIC
 Q
30 ;AMT02 - Monetary Amount
 ; prior payment - actual
 I ABMEIC="D" D
 .D PAYED^ABMERUTL
 .;S ABMR("AMT",30)=$G(ABMP("PAYED",+$G(ABMP("INS",ABMPST))))  ;pymt for that insurer  ;abm*2.6*37 IHS/SD/SDR ADO76009
 .S ABMR("AMT",30)=$G(ABMP("PAYED",+$G(ABMP("INS",ABMPST)),$S(+$P($G(ABMP("INS",ABMPST)),U,8)'=0:$P(ABMP("INS",ABMPST),U,8),1:1)))  ;pymt for that insurer  ;abm*2.6*37 IHS/SD/SDR ADO76009
 ;
 ; payer estimated amount
 I ABMEIC="C5" D
 .D PAYED^ABMERUTL
 .S ABMR("AMT",30)=$P(ABMB2,U)
 .S ABMR("AMT",30)=ABMR("AMT",30)-$G(ABMP("PAYED"))
 .S ABMR("AMT",30)=ABMR("AMT",30)-$P(ABMB9,"^",9)
 ;
 ; patient paid amount
 I ABMEIC="F5" S ABMR("AMT",30)=$P(ABMB7,"^",23)
 ;
 I ABMEIC="F2" D
 .S ABMR("AMT",30)=ABMF2AMT
 ;
 I ABMEIC="B6" S ABMR("AMT",30)=ABMAMT  ;abm*2.6*10 COB billing
 ;
 ;start new abm*2.6*31 IHS/SD/AML CR10374
 I ABMEIC="A8" S ABMR("AMT",30)=$P(ABMB2,U)  ;2/23/2018 HEAT347723
 ;
 ;I ABMEIC="EAF" S ABMR("AMT",30)=+$G(ABMP(+ABMLINE,"EAF"))  ;abm*2.6*37 IHS/SD/SDR ADO76009
 I ABMEIC="EAF" S ABMR("AMT",30)=+$G(ABMP(+ABMLINE,ABMM,"EAF"))  ;abm*2.6*37 IHS/SD/SDR ADO76009
 ;end new abm*2.6*31 IHS/SD/AML CR10374
 ;
 S ABMR("AMT",30)=$FN(ABMR("AMT",30),"-")
 ;S ABMR("AMT",30)=$J(ABMR("AMT",30),0,2)  ;abm*2.6*10 COB billing
 ;
 Q
40 ;AMT03 - Credit/Debit Flag Code-not used
 S ABMR("AMT",40)=""
 Q
