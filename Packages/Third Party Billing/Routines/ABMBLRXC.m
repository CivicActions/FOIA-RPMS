ABMBLRXC ; IHS/SD/SDR - 3PB Pharmacy POS Bill Cleanup Compute for Report  
 ;;2.6;IHS Third Party Billing System;**36**;NOV 12, 2009;Build 698
 ;
 ;IHS/SD/SDR 2.6*36 ADO74860 New routine to report Pharmacy POS bills that are missing the medication
 ;
COMPUTE ;
 S ABM("SUBR")="ABM-BLRX"
 K ^TMP("ABM-BLRX",$J)
 I '$D(ABMY("LOC")) D
 .S ABMA=0 F  S ABMA=$O(^BAR(90052.05,ABM("PAR"),ABMA)) Q:'ABMA  S ABMY("LOC",ABMA)=""  ;put our locs in array if they accepted ALL
 ;
DATE ;
 S ABMHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(ABMY("LOC",DUZ(2))) Q:'DUZ(2)  D
 .S ABMSDT=ABMY("DT",1)-.000001
 .S ABMEDT=ABMY("DT",2)+.999999
 .;if approval date
 .I $G(ABMY("DT"))="A" D
 ..F  S ABMSDT=$O(^ABMDBILL(DUZ(2),"AP",ABMSDT)) Q:'ABMSDT!(ABMSDT>ABMEDT)  D
 ...S ABM=0
 ...F  S ABM=$O(^ABMDBILL(DUZ(2),"AP",ABMSDT,ABM)) Q:'ABM  D
 ....S ABMP("HIT")=0
 ....D BILL Q:'ABMP("HIT")
 ....S ABMLOC=$P($G(^AUTTLOC(ABM("L"),0)),U,2)  ;location short name
 ....S ABMINS=$P($G(^AUTNINS(ABM("I"),0)),U)  ;insurer
 ....S ABMBAMT=+$P($G(^ABMDBILL(DUZ(2),ABM,2)),U)  ;bill amount
 ....D SUMMARY  ;do counts every time
 ....I ABMY("RFOR")=1 D DETAIL
 .;if visit date
 .I $G(ABMY("DT"))="V" D
 ..F  S ABMSDT=$O(^ABMDBILL(DUZ(2),"AD",ABMSDT)) Q:'ABMSDT!(ABMSDT>ABMEDT)  D
 ...S ABM=0
 ...F  S ABM=$O(^ABMDBILL(DUZ(2),"AD",ABMSDT,ABM)) Q:'ABM  D
 ....S ABMP("HIT")=0
 ....D BILL Q:'ABMP("HIT")
 ....S ABMLOC=$P($G(^AUTTLOC(ABM("L"),0)),U,2)  ;location short name
 ....S ABMINS=$P($G(^AUTNINS(ABM("I"),0)),U)  ;insurer
 ....S ABMBAMT=+$P($G(^ABMDBILL(DUZ(2),ABM,2)),U)  ;bill amount
 ....D SUMMARY  ;do counts every time
 ....I ABMY("RFOR")=1 D DETAIL
 S DUZ(2)=ABMHOLD
 Q
SUMMARY ;
 S $P(^TMP("ABM-BLRX",$J,"TOT"),U)=+$P($G(^TMP("ABM-BLRX",$J,"TOT")),U)+1  ;count grand total
 S $P(^TMP("ABM-BLRX",$J,"TOT"),U,2)=+$P($G(^TMP("ABM-BLRX",$J,"TOT")),U,2)+ABMBAMT  ;bill amount grand total
 S $P(^TMP("ABM-BLRX",$J,"SUBT",ABMLOC),U)=+$P($G(^TMP("ABM-BLRX",$J,"SUBT",ABMLOC)),U)+1  ;count by location
 S $P(^TMP("ABM-BLRX",$J,"SUBT",ABMLOC),U,2)=+$P($G(^TMP("ABM-BLRX",$J,"SUBT",ABMLOC)),U,2)+ABMBAMT  ;bill amount by location
 S $P(^TMP("ABM-BLRX",$J,"SUBT",ABMLOC,ABMINS),U)=+$P($G(^TMP("ABM-BLRX",$J,"SUBT",ABMLOC,ABMINS)),U)+1  ;count by location,insurer
 S $P(^TMP("ABM-BLRX",$J,"SUBT",ABMLOC,ABMINS),U,2)=+$P($G(^TMP("ABM-BLRX",$J,"SUBT",ABMLOC,ABMINS)),U,2)+ABMBAMT  ;bill amount by location,insurer
 Q
DETAIL ;
 S ABMBILLN=$P(^ABMDBILL(DUZ(2),ABM,0),U)  ;bill#
 S ABMP("LDFN")=ABM("L")  ;needed for HRN to return correctly
 K ABMHRN,HRN
 S ABMHRN=$$HRN^ABMUTL8($P($G(^ABMDBILL(DUZ(2),ABM,0)),U,5))  ;HRN
 S ABMOTHI=$P($G(^ABMDBILL(DUZ(2),ABM,1)),U,15)  ;other bill identifier
 S ^TMP("ABM-BLRX",$J,"D",ABMLOC,ABMINS,ABMBILLN)=ABMHRN_U_$$SDT^ABMDUTL(ABM("D"))_U_ABMOTHI_U_$J($FN(+ABMBAMT,",",2),10)
 Q
BILL ;EP for checking Bill File data parameters
 Q:'$D(^ABMDBILL(DUZ(2),ABM,0))!('$D(^(1)))
 Q:$P(^ABMDBILL(DUZ(2),ABM,0),"^",4)="X"
 Q:$P(^ABMDBILL(DUZ(2),ABM,0),U,7)'=901  ;only Pharmacy POS visits
 Q:$G(^ABMDBILL(DUZ(2),ABM,23,1,0))'=""  ;the bill has a med - skip it
 S ABM("L")=$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,3)
 S ABM("I")=$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,8)
 S ABM("P")=$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,5)
 S ABM("D")=$P($G(^ABMDBILL(DUZ(2),ABM,7)),U)
 Q:ABM("L")=""!(ABM("I")="")!(ABM("P")="")!(ABM("D")="")
 Q:'$D(^AUTNINS(ABM("I"),0))
 I $D(ABMY("LOC")),'$D(ABMY("LOC",ABM("L"))) Q  ;this is different from original bill to allow multiple locations
 I $D(ABMY("PAT")),ABMY("PAT")'=ABM("P") Q
 I $G(ABMY("PTYP"))=2,$P($G(^AUPNPAT(ABM("P"),11)),U,12)'="I" Q
 I $G(ABMY("PTYP"))=1,$P($G(^AUPNPAT(ABM("P"),11)),U,12)="I" Q
 I $D(ABMY("INS")),ABMY("INS")'=ABM("I") Q
 I $D(ABMY("TYP")) Q:("^"_ABMY("TYP")_"^")'[("^"_$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABM("I"),".211","I"),1,"I")_"^")  ;abm*2.6*10 HEAT73780  ;abm*2.6*21 IHS/SD/SDR VMBP RQMT_96
 K ABM("QUIT")
 S ABMP("HIT")=1
 Q
