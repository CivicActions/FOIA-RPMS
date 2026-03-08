ABME5SV1 ; IHS/SD/SDR - 837 SV1 Segment 
 ;;2.6;IHS Third Party Billing System;**6,9,10,29,37**;NOV 12, 2009;Build 739
 ;Transaction Set Header
 ;IHS/SD/SDR 2.6*29 CR10404 ABMOUTLB (the variable for ref lab CLIA) was being set but never reset for the next service line.
 ;IHS/SD/SDR 2.6*37 ADO76009 Made SV202 check FLAT RATE AMOUNT for secondary billing
 ;
EP ;EP
 K ABMREC("SV1"),ABMR("SV1")
 S ABME("RTYPE")="SV1"
 D LOOP
 K ABME
 Q
LOOP ;LOOP HERE
 F I=10:10:220 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("SV1"))'="" S ABMREC("SV1")=ABMREC("SV1")_"*"
 .S ABMREC("SV1")=$G(ABMREC("SV1"))_ABMR("SV1",I)
 Q
10 ;segment
 S ABMR("SV1",10)="SV1"
 Q
20 ;SV101 - Composite Medical Procedure Identifier
 ;SV101-1 Product Service ID Qualifier
 ;SV101-2 Product Service ID (Procedure Code)
 I $P(ABMRV(ABMI,ABMJ,ABMK),U,2)'="" D
 .S ABMR("SV1",20)="HC"
 .S $P(ABMR("SV1",20),":",2)=$P(ABMRV(ABMI,ABMJ,ABMK),U,2)
 I $P(ABMRV(ABMI,ABMJ,ABMK),U,2)="" D
 .S ABMR("SV1",20)=""
 .Q:$P(ABMRV(ABMI,ABMJ,ABMK),U,15)=""
 .S ABM("NDC")=$P(ABMRV(ABMI,ABMJ,ABMK),U,15)
 .I ABM("NDC")?4N1"-"4N1"-"2N S ABMR("SV1",20)="N1"
 .I ABM("NDC")?5N1"-"3N1"-"2N S ABMR("SV1",20)="N2"
 .I ABM("NDC")?5N1"-"4N1"-"1N S ABMR("SV1",20)="N3"
 .I ABM("NDC")?5N1"-"4N1"-"2N S ABMR("SV1",20)="N4"
 .S $P(ABMR("SV1",20),":",2)=ABM("NDC")
 N I
 S ABMOUTLB=0  ;abm*2.6*29 IHS/SD/SDR CR10404
 ;F I=3,4,12,22 D  ;abm*2.6*9
 F I=3,4,12 D  ;abm*2.6*9
 .I ($P($G(^AUTNINS(ABMP("INS"),0)),U)["NORTH CAROLINA MEDICAID"),$P(ABMRV(ABMI,ABMJ,ABMK),U,2)="T1015" S $P(ABMR("SV1",20),":",3)="SE"  ;abm*2.6*10 IHS/SD/AML HEAT73336
 .Q:$P(ABMRV(ABMI,ABMJ,ABMK),U,I)=""
 .S ABMR("SV1",20)=ABMR("SV1",20)_":"_$P(ABMRV(ABMI,ABMJ,ABMK),U,I)
 .I $P(ABMRV(ABMI,ABMJ,ABMK),U,I)=90 S ABMOUTLB=1
 I $P($G(ABMRV(ABMI,ABMJ,ABMK)),U,39)'="" S $P(ABMR("SV1",20),":",7)=$P($G(ABMRV(ABMI,ABMJ,ABMK)),U,39)  ;abm*2.6*9 NARR
 Q
30 ;SV102 - Monetary Amount (Charges)
 S ABMR("SV1",30)=$P(ABMRV(ABMI,ABMJ,ABMK),U,6)
 ;start new code abm*2.6*10 COB billing
 I ABMPSQ'=1,$D(ABMP("FLAT")) D
 .;start old abm*2.6*37 IHS/SD/SDR ADO76009
 .;I ABMPSQ'=1,(+$P(ABMB2,U,3)'=0) S ABMR("SV2",40)=$P(ABMB2,U,3)
 .;I ABMPSQ'=1,(+$P(ABMB2,U,7)>+$P(ABMB2,U,3)) S ABMR("SV2",40)=+$P(ABMB2,U,7)
 .;end old start new abm*2.6*37 IHS/SD/SDR ADO76009
 .I ABMPSQ'=1,(+$P(ABMB2,U,3)'=0) S ABMR("SV1",30)=$P(ABMB2,U,3)  ;gross bill amount
 .I ABMPSQ'=1,(+$P(ABMB2,U,7)>+$P(ABMB2,U,3)) S ABMR("SV1",30)=+$P(ABMB2,U,7)  ;original bill amount
 I (+$P(ABMB2,U,8)'=0) D
 .S ABMCDAYS=$S((+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U,3)'=0):$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U,3),1:1)
 .S ABMNCDYS=$S((+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),6)),U,6)'=0):$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),6)),U,6),1:0)
 .S ABMR("SV1",30)=$P(ABMB2,U,8)*(ABMCDAYS+ABMNCDYS)  ;flate rate amount  ;abm*2.6*37 IHS/SD/SDR ADO76009
 ;end new abm*2.6*37 IHS/SD/SDR ADO76009
 ;end new code COB billing
 ;S ABMR("SV1",30)=$$TRIM^ABMUTLP($J(ABMR("SV1",30),0,2),"L","0")  ;abm*2.6*9 HEAT64640
 S ABMR("SV1",30)=$S(ABMR("SV1",30)=0:ABMR("SV1",30),1:$$TRIM^ABMUTLP($J(ABMR("SV1",30),0,2),"L","0"))  ;abm*2.6*9 HEAT64640
 Q
40 ;SV103 - Unit or Basis for Measurement Code
 I ABMI=39 S ABMR("SV1",40)="MJ"
 E  S ABMR("SV1",40)="UN"
 Q
50 ;SV104 - Quantity
 S ABMR("SV1",50)=$S(ABMR("SV1",40)="UN":$P(ABMRV(ABMI,ABMJ,ABMK),U,5),1:$P(ABMRV(ABMI,ABMJ,ABMK),U,16))
 Q
60 ;SV105 - Facility Code Value (place of service)
 S ABMR("SV1",60)=""
 I $P($G(ABMRV(ABMI,ABMJ,ABMK)),U,25)'="" D
 .S ABMR("SV1",60)=$P($G(ABMRV(ABMI,ABMJ,ABMK)),U,25)
 .I ABMR("SV1",60)'="" S ABMR("SV1",60)=$P($G(^ABMDCODE(ABMR("SV1",60),0)),"^")
 E  S ABMR("SV1",60)=$$POS^ABMERUTL(ABMI)
 S ABMVALUE=$$OVER^ABMUTL8(37,3)  ;Fl override
 I ABMVALUE'="" S ABMR("SV1",60)=ABMVALUE
 I ABMR("SV1",60)=$$POS^ABMERUTL() S ABMR("SV1",60)="" ;5010 837P
 Q
70 ;SV106 - service type code
 S ABMR("SV1",70)=""
 Q
80 ;SV107 - Composite DX code pointer
 S ABMR("SV1",80)=$P(ABMRV(ABMI,ABMJ,ABMK),U,11)
 S ABMR("SV1",80)=$TR(ABMR("SV1",80),",",":")
 S ABMR("SV1",80)=$P(ABMR("SV1",80),":",1,4)
 Q
90 ;SV108 - Monetary Amount
 S ABMR("SV1",90)=""
 Q
100 ;SV109 - emergency indicator
 S ABMR("SV1",100)=$P(ABMB8,"^",5)
 Q
110 ;SV110 - Multiple Procedure Code
 S ABMR("SV1",110)=""
 Q
120 ;SV111 - epsdt
 S ABMR("SV1",120)=""
 Q
130 ;SV112 - Family Planning Indicator
 S ABMR("SV1",130)=""
 Q
140 ;SV113 - Review Code
 S ABMR("SV1",140)=""
 Q
150 ;SV114 - National or Local Assigned Review Value
 S ABMR("SV1",150)=""
 Q
160 ;SV115 - copay status code
 S ABMR("SV1",160)=""
170 ;SV116 - health care professional shortage area code     
 S ABMR("SV1",170)=""
180 ;SV117 - reference identification     
 S ABMR("SV1",180)=""
 Q
190 ;SV118 - postal code
 S ABMR("SV1",190)=""
 Q
200 ;SV119 - monetary amount
 S ABMR("SV1",200)=""
 Q
210 ;SV120 - level of care code
 S ABMR("SV1",210)=""
 Q
220 ;SV121 - provider agreement code
 S ABMR("SV1",220)=""
 Q
