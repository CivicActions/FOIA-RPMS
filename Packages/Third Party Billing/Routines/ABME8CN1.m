ABME8CN1 ; IHS/ASDST/DMJ - 837 CN1 Segment [ 02/04/2003  11:07 AM ]
 ;;2.5;IHS 3P BILLING SYSTEM;**1**;APR 05, 2002
 ;Transaction Set Header
 ;
START ;START HERE
 K ABMREC("CN1"),ABMR("CN1")
 S ABME("RTYPE")="CN1"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:70 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("CN1"))'="" S ABMREC("CN1")=ABMREC("CN1")_"*"
 .S ABMREC("CN1")=$G(ABMREC("CN1"))_ABMR("CN1",I)
 Q
10 ;segment
 S ABMR("CN1",10)="CN1"
 Q
20 ;CN101 - Contract Type Code
 S ABMR("CN1",20)=""
 Q
30 ;CN102 - Monetary Amount
 S ABMR("CN1",30)=""
 Q
40 ;CN103 - Percent
 S ABMR("CN1",40)=""
 Q
50 ;CN104 - Reference Identification
 S ABMR("CN1",50)=""
 Q
60 ;CN105 - Terms Discount Percent
 S ABMR("CN1",60)=""
 Q
70 ;CN106 - Version Identifier
 S ABMR("CN1",70)=""
 Q
