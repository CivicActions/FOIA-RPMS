ABME5SV2 ; IHS/SD/SDR - 837 SV2 Segment 
 ;;2.6;IHS Third Party Billing System;**6,8,9,10,20,23,25,29,33,37**;NOV 12, 2009;Build 739
 ;Transaction Set Header
 ;IHS/SD/SDR - 2.6*20 - HEAT262141 - Made units print 1 and nothing in SV02 for AZ Medicaid visit type 997 pharmacy
 ;IHS/SD/SDR 2.6*23 HEAT347035 Changed how it was getting rev code to use actual piece, not subscript; also changed format of $0 for Medi-Cal;
 ;   Also made units 0 if Medi-Cal and the charges is 0.
 ;IHS/SD/SDR 2.6*25 CR10016 Made it so flat rate only prints on first line if AZ Medicaid and visit type 997
 ;IHS/SD/AML 2.6*29 CR10888 For Medi-Cal DOS on/after 1/1/2019 print the units (used to print 0 if the charges were 0)
 ;IHS/SD/SDR 2.6*29 CR10410 Medicare non-covered changes
 ;IHS/SD/SDR 2.6*33 ADO60189/CR9512 Updated SV2-04 to be 'DA' if the bill type is 11#, 12#, or 18# and the rev code is between 0100 and 0219 (inclusive);
 ;   Also corrected CPT range for PI to 0219 while reviewing spec with Adrian so they work the same.
 ;IHS/SD/SDR 2.6*37 ADO76009 Made SV202 check FLAT RATE AMOUNT for secondary billing
 ;
EP ;EP
 K ABMREC("SV2"),ABMR("SV2")
 S ABME("RTYPE")="SV2"
 D LOOP
 K ABME
 Q
LOOP ;LOOP HERE
 F I=10:10:110 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("SV2"))'="" S ABMREC("SV2")=ABMREC("SV2")_"*"
 .S ABMREC("SV2")=$G(ABMREC("SV2"))_ABMR("SV2",I)
 Q
10 ;segment
 S ABMR("SV2",10)="SV2"
 Q
20 ;SV201 - Product/Service ID
 ; Revenue code
 ;S ABMR("SV2",20)=$P($G(^AUTTREVN(ABMI,0)),U)  ;abm*2.6*23 IHS/SD/SDR HEAT347035
 S ABMR("SV2",20)=$P($G(^AUTTREVN($P(ABMRV(ABMI,ABMJ,ABMK),U),0)),U)  ;abm*2.6*23 IHS/SD/SDR HEAT347035
 ;S ABMR("SV2",20)=$$FMT^ABMERUTL(ABMR("SV2",20),"4NR")  ;abm*2.6*23 IHS/SD/SDR HEAT347035
 I +$G(ABMR("SV2",20))'=0 S ABMR("SV2",20)=$$FMT^ABMERUTL(ABMR("SV2",20),"4NR")  ;abm*2.6*23 IHS/SD/SDR HEAT347035
 Q
30 ;SV202 - Composite Medical Procedure Identifier
 ;SV202-1 Product Service ID Qualifier
 ;SV202-2 Product Service ID (Procedure Code)
 S ABMR("SV2",30)=""
 I $P(ABMRV(ABMI,ABMJ,ABMK),U,2)'="" D
 .S ABMR("SV2",30)="HC"
 .S $P(ABMR("SV2",30),":",2)=$P(ABMRV(ABMI,ABMJ,ABMK),U,2)
 .;modifiers
 .N I,J
 .S J=2
 .F I=3,4,12,13 D
 ..Q:$P(ABMRV(ABMI,ABMJ,ABMK),U,I)=""
 ..S J=J+1
 ..S $P(ABMR("SV2",30),":",J)=$P(ABMRV(ABMI,ABMJ,ABMK),U,I)
 .;SV202-7 Description (Not used)
 I $P($G(ABMRV(ABMI,ABMJ,ABMK)),U,39)'="" S $P(ABMR("SV2",30),":",7)=$P($G(ABMRV(ABMI,ABMJ,ABMK)),U,39)  ;abm*2.6*9 NARR
 I $$RCID^ABMERUTL(ABMP("INS"))=99999,(ABMP("VTYP")=997) S ABMR("SV2",30)=""  ;abm*2.6*20 IHS/SD/SDR HEAT262141
 Q
40 ;SV203 - Monetary Amount (Charges)
 S ABMR("SV2",40)=$P(ABMRV(ABMI,ABMJ,ABMK),U,6)
 I +ABMR("SV2",40)=0 S ABMR("SV2",40)=$P(ABMRV(ABMI,ABMJ,ABMK),U,7)  ;abm*2.6*29 IHS/SD/SDR CR10410
 ;start new code abm*2.6*10 COB billing
 I ABMPSQ'=1,$D(ABMP("FLAT")) D
 .I ($$RCID^ABMERUTL(ABMP("INS"))=99999&(ABMP("VTYP")=997)) Q  ;abm*2.6*25 IHS/SD/SDR CR10016
 .I ABMPSQ'=1,(+$P(ABMB2,U,3)'=0) S ABMR("SV2",40)=$P(ABMB2,U,3)
 .I ABMPSQ'=1,(+$P(ABMB2,U,7)>+$P(ABMB2,U,3)) S ABMR("SV2",40)=+$P(ABMB2,U,7)
 I (+$P(ABMB2,U,8)'=0) D  ;abm*2.6*37 IHS/SD/SDR ADO76009
 .S ABMCDAYS=$S((+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U,3)'=0):$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U,3),1:1)  ;abm*2.6*37 IHS/SD/SDR ADO76009
 .S ABMNCDYS=$S((+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),6)),U,6)'=0):$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),6)),U,6),1:0)  ;abm*2.6*37 IHS/SD/SDR ADO76009
 .S ABMR("SV2",40)=$P(ABMB2,U,8)*(ABMCDAYS+ABMNCDYS)  ;flate rate amount  ;abm*2.6*37 IHS/SD/SDR ADO76009
 ;end new code COB billing
 I (($$RCID^ABMUTLP(ABMP("INS"))["61044")&(+$G(ABMR("SV2",40))=0)) Q  ;don't format for Medi-Cal when amount is $0  ;abm*2.6*23 IHS/SD/SDR HEAT347035
 S ABMR("SV2",40)=$$TRIM^ABMUTLP($J(ABMR("SV2",40),0,2),"L","0")
 Q
50 ;SV204 - Unit or Basis for Measurement Code
 S ABMR("SV2",50)="UN"
 ;I ABMP("ITYPE")="P",((ABMI>"0100")&(ABMI<"0229")) S ABMR("SV2",50)="DA"  ;abm*2.6*33 IHS/SD/SDR CR9512
 I ABMP("ITYPE")="P",((ABMI>"0099")&(ABMI<"0220")) S ABMR("SV2",50)="DA"  ;abm*2.6*33 IHS/SD/SDR CR9512
 I ("^11^12^18^"[("^"_$E(ABMP("BTYP"),1,2)_"^")),((ABMI>"0099")&(ABMI<"0220")) S ABMR("SV2",50)="DA"  ;abm*2.6*33 IHS/SD/SDR CR9512
 Q
60 ;SV205 - Quantity
 S ABMR("SV2",60)=$P(ABMRV(ABMI,ABMJ,ABMK),U,5)
 I $$RCID^ABMERUTL(ABMP("INS"))=99999,(ABMP("VTYP")=997) S ABMR("SV2",60)=1  ;abm*2.6*20 IHS/SD/SDR HEAT262141
 ;I (($$RCID^ABMUTLP(ABMP("INS"))["61044")&(+$G(ABMR("SV2",40))=0)) S ABMR("SV2",60)=0  ;make unit zero if charges is zero and Medi-Cal  ;abm*2.6*23 IHS/SD/SDR HEAT347035  ;abm*2.6*29 IHS/SD/AML CR10888
 I (($P($G(^AUTNINS(ABMP("INS"),0)),U)["O/P MEDI-CAL")&(ABMP("VDT")>3181231)) S ABMR("SV2",60)=$P(ABMRV(ABMI,ABMJ,ABMK),U,5) Q  ;abm*2.6*29 IHS/SD/AML CR10888
 I ABMP("VDT")<3190101,(($$RCID^ABMUTLP(ABMP("INS"))["61044")&(+$G(ABMR("SV2",40))=0)) S ABMR("SV2",60)=0  ;make unit zero if charges is zero and Medi-Cal ;abm*2.6*29 IHS/SD/AML CR10888
 Q
70 ;SV206 - Unit Rate
 S ABMR("SV2",70)=""
 Q
80 ;SV207 - Monetary Amount (Non covered charges)
 S ABMR("SV2",80)=""
 I (+$P(ABMRV(ABMI,ABMJ,ABMK),U,7)=0) Q  ;abm*2.6*29 IHS/SD/SDR CR10410
 S ABMR("SV2",80)=$P(ABMRV(ABMI,ABMJ,ABMK),U,7)  ;abm*2.6*29 IHS/SD/SDR CR10410
 S ABMR("SV2",80)=$$TRIM^ABMUTLP($J(ABMR("SV2",80),0,2),"L","0")  ;abm*2.6*29 IHS/SD/SDR CR10410
 Q
90 ;SV208 - Yes/No Condition or Response Code (Not used)
 S ABMR("SV2",90)=""
 Q
100 ;SV209 - Nursing Home Residential Status Code (Not used)
 S ABMR("SV2",100)=""
 Q
110 ;SV210 - Leve of Care Code (Not used)
 S ABMR("SV2",110)=""
 Q
