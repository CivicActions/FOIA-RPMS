ABME5SV3 ; IHS/SD/SDR - 837 SV3 Segment 
 ;;2.6;IHS Third Party Billing System;**6,9,16,19,28,37**;NOV 12, 2009;Build 739
 ;Transaction Set Header
 ;IHS/SD/SDR 2.6*16 HEAT236242 - Updated to include coor. dx on line item
 ;IHS/SD/SDR 2.6*19 HEAT180453 - Made AREA OF ORAL CAVITY print in SV304
 ;IHS/SD/SDR 2.6*28 CR8718 Made WA MEDICAID DENTAL print units all the time
 ;IHS/SD/SDR 2.6*37 ADO76009 Added check for non-primary to use flat rate amount if populated
 ;
EP ;EP
 K ABMREC("SV3"),ABMR("SV3")
 S ABME("RTYPE")="SV3"
 D LOOP
 K ABME
 Q
LOOP ;LOOP HERE
 F I=10:10:120 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("SV3"))'="" S ABMREC("SV3")=ABMREC("SV3")_"*"
 .S ABMREC("SV3")=$G(ABMREC("SV3"))_ABMR("SV3",I)
 Q
10 ;segment
 S ABMR("SV3",10)="SV3"
 Q
20 ;SV301 - Composite Medical Procedure Identifier
 ;SV301-1 Product Service ID Qualifier
 ;SV301-2 Product Service ID (Procedure Code)
 S ABMR("SV3",20)="AD"
 S $P(ABMR("SV3",20),":",2)=$P(ABMRV(ABMI,ABMJ,ABMK),U,2)
 N I
 F I=3,4,12,22 D
 .Q:$P(ABMRV(ABMI,ABMJ,ABMK),U,I)=""
 .S ABMR("SV3",20)=ABMR("SV3",20)_":"_$P(ABMRV(ABMI,ABMJ,ABMK),U,I)
 I $P($G(ABMRV(ABMI,ABMJ,ABMK)),U,39)'="" S $P(ABMR("SV3",20),":",7)=$P($G(ABMRV(ABMI,ABMJ,ABMK)),U,39)  ;abm*2.6*9 NARR
 Q
30 ;SV302 - Monetary Amount (Charges)
 S ABMR("SV3",30)=$P(ABMRV(ABMI,ABMJ,ABMK),U,6)
 ;start new abm*2.6*37 IHS/SD/SDR ADO76009
 I (+$P(ABMB2,U,8)'=0) D
 .S ABMCDAYS=$S((+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U,3)'=0):$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U,3),1:1)
 .S ABMNCDYS=$S((+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),6)),U,6)'=0):$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),6)),U,6),1:0)
 .S ABMR("SV3",30)=$P(ABMB2,U,8)*(ABMCDAYS+ABMNCDYS)  ;flate rate amount
 ;end new abm*2.6*37 IHS/SD/SDR ADO76009
 S ABMR("SV3",30)=$J(ABMR("SV3",30),0,2)
 Q
40 ;SV303 - Place of service
 S ABMR("SV3",40)=""
 Q
50 ;SV304 - Oral Cavity Designation
 S ABMR("SV3",50)=""
 S ABMR("SV3",50)=$P($G(ABMRV(ABMI,ABMJ,ABMK)),U,40)  ;area of oral cavity  ;abm*2.6*19 IHS/SD/SDR HEAT180453
 Q
60 ;SV305 - Prothesis, Crown, or Inlay Code
 S ABMR("SV3",60)=""
 Q
70 ;SV306 - Quantity
 ;S ABMR("SV3",70)=$P(ABMRV(ABMI,ABMJ,ABMK),U,5)  ;abm*2.6*9 NOHEAT
 S ABMR("SV3",70)=""  ;abm*2.6*9 NOHEAT
 S:$P(ABMRV(ABMI,ABMJ,ABMK),U,5)>1 ABMR("SV3",70)=$P(ABMRV(ABMI,ABMJ,ABMK),U,5)  ;abm*2.6*9 NOHEAT
 ;I $P($G(^AUTNINS(ABMP("INS"),0)),U)["WASHINGTON MEDICAID" S ABMR("SV3",70)=$P(ABMRV(ABMI,ABMJ,ABMK),U,5)  ;IHS/SD/AML 12/27/12 HEAT95806  ;abm*2.6*28 IHS/SD/SDR CR8718
 I "^WASHINGTON MEDICAID^WA MEDICAID DENTAL^"[("^"_$P($G(^AUTNINS(ABMP("INS"),0)),U)_"^") S ABMR("SV3",70)=$P(ABMRV(ABMI,ABMJ,ABMK),U,5)  ;abm*2.6*28 IHS/SD/SDR CR8718
 Q
80 ;SV307 - Description
 S ABMR("SV3",80)=""
 Q
90 ;SV308 - Copay Status Code
 S ABMR("SV3",90)=""
 Q
100 ;SV309 - Provider Agreement Code
 S ABMR("SV3",100)=""
 Q
110 ;SV310 - not used
 S ABMR("SV3",110)=""
 Q
120 ;SV311 - Composite DX Code Pointer
 S ABMR("SV3",120)=""
 ;start new abm*2.6*16 IHS/SD/SDR HEAT236242
 S ABMR("SV3",120)=$P(ABMRV(ABMI,ABMJ,ABMK),U,11)
 S ABMR("SV3",120)=$TR(ABMR("SV3",120),",",":")
 S ABMR("SV3",120)=$P(ABMR("SV3",120),":",1,4)
 ;end new abm*2.6*16 IHS/SD/SDR HEAT236242
 Q
