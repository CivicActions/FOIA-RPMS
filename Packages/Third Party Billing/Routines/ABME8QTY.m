ABME8QTY ; IHS/ASDST/DMJ - 837 QTY Segment [ 02/04/2003  11:07 AM ]
 ;;2.5;IHS 3P BILLING SYSTEM;**1**;APR 05, 2002
 ;Transaction Set Header
 ;
EP(X) ;EP
 ;x=qualifier
 K ABMREC("QTY"),ABMR("QTY")
 S ABMEIC=X
 S ABME("RTYPE")="QTY"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:50 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("QTY"))'="" S ABMREC("QTY")=ABMREC("QTY")_"*"
 .S ABMREC("QTY")=$G(ABMREC("QTY"))_ABMR("QTY",I)
 Q
10 ;segment
 S ABMR("QTY",10)="QTY"
 Q
20 ;QTY01 - Quantity Qualifier
 S ABMR("QTY",20)=ABMEIC
 Q
30 ;QTY02 - Quantity
 S ABMR("QTY",30)=""
 I ABMEIC="NA" D
 .S ABMR("QTY",30)=$P(ABMB6,"^",6)
 I ABMEIC="CA" D
 .S ABMR("QTY",30)=$P(ABMB7,"^",3)
 Q
40 ;QTY03 - Composite Unit of Measure
 S ABMR("QTY",40)="DA"
 Q
50 ;QTY04 - Free-Form Message
 S ABMR("QTY",50)=""
 Q
