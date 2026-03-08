ABME5NTE ; IHS/ASDST/DMJ - 837 NTE Segment 
 ;;2.6;IHS Third Party Billing System;**6,40**;NOV 12, 2009;Build 785
 ;Transaction Set Header
 ;IHS/SD/SDR 2.6*40 ADO111599 Check for VA CONTRACT#
 ;
EP(X) ;EP - start here
 ;x=parameter
 K ABMREC("NTE"),ABMR("NTE")
 S ABME("RTYPE")="NTE"
 S ABMEIC=X
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:30 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("NTE"))'="" S ABMREC("NTE")=ABMREC("NTE")_"*"
 .S ABMREC("NTE")=$G(ABMREC("NTE"))_ABMR("NTE",I)
 Q
10 ;segment
 S ABMR("NTE",10)="NTE"
 Q
20 ;NTE01 - Note Reference Code
 S ABMR("NTE",20)=ABMEIC
 Q
30 ;NTE02 - Description
 S ABMR("NTE",30)=""
 I ABMEIC="ADD" D
 .;start new abm*2.6*40 IHS/SD/SDR ADO111599
 .I $P($G(^AUTNINS(ABMP("INS"),0)),U)="VA MEDICAL BENEFIT (VMBP)" D
 ..S ABMR("NTE",30)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),U,27)
 .I ABMR("NTE",30)'="" Q  ;there's a VA CONTRACT#, so stop
 .;end new abm*2.6*40 IHS/SD/SDR ADO11159
 .S ABMR("NTE",30)=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),61,1,0))
 .Q:'$D(^ABMDBILL(DUZ(2),ABMP("BDFN"),61,2,0))
 .S ABMR("NTE",30)=ABMR("NTE",30)_" "_^ABMDBILL(DUZ(2),ABMP("BDFN"),61,2,0)
 S ABMR("NTE",30)=$TR(ABMR("NTE",30),":","-")
 I ABMR("NTE",30)="" D
 .S ABMR("NTE",30)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),10)),U)
 S ABMR("NTE",30)=$E(ABMR("NTE",30),1,80)
 Q
