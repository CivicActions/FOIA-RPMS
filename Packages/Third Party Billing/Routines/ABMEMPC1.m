ABMEMPC1 ; IHS/SD/SDR - Report Utility to Check Parms ;  
 ;;2.6;IHS Third Party Billing;**32**;NOV 12, 2009;Build 621
 ;Original;SDR
 ;IHS/SD/SDR 2.6*32 CR11501 New routine for new employee productivity report
 ;
CLM ;EP for checking Claim file data parameters
 D DOTS^ABMEMPCK
 K ABM("RECTYP")
 S ABMV="CLM"
 Q:'$D(^ABMDCLM(DUZ(2),ABM,0))
 S ABM("V")=$P(^ABMDCLM(DUZ(2),ABM,0),U,7)  ;visit type
 S ABM("L")=$P(^ABMDCLM(DUZ(2),ABM,0),U,3)  ;visit location
 S ABM("I")=$P(^ABMDCLM(DUZ(2),ABM,0),U,8)  ;active insurer
 S ABM("P")=$P(^ABMDCLM(DUZ(2),ABM,0),U)  ;patient
 S ABM("D")=$P(^ABMDCLM(DUZ(2),ABM,0),U,2)  ;encounter date
 S ABM("C")=$P(^ABMDCLM(DUZ(2),ABM,0),U,6)  ;clinic
 Q:ABM("L")=""!(ABM("I")="")!(ABM("P")="")!(ABM("D")="")!(ABM("V")="")!(ABM("C")="")
 I $D(ABMY("NOTPOS")),ABM("V")=901 Q  ;no POS bills
 I $D(ABMY("POSONLY")),ABM("V")'=901 Q  ;POS bills only
 Q:'$D(^AUTNINS(ABM("I"),0))
 I $D(ABMY("DX")) S ABM("DX","HIT")=0,ABM("DX")="CLM" D DX^ABMEMPC3 Q:'ABM("DX","HIT")  ;diag
 I $D(ABMY("PX")) S ABM("PX","HIT")=0,ABM("PX")="CLM" D PX^ABMEMPC3 Q:'ABM("PX","HIT")  ;proc
 ;
 I $D(ABMY("PRV")),'$D(^ABMDCLM(DUZ(2),ABM,41,"B",ABMY("PRV"))) Q
  I $D(ABMY("PRV")) D
 .S ABM("PT")=$O(^ABMDCLM(DUZ(2),ABM,41,"B",ABMY("PRV"),0))
 .S ABM("PT")=$P($G(^ABMDCLM(DUZ(2),ABM,41,ABM("PT"),0)),U,2)
 .S ABM("PT")=$S(ABM("PT")="A":"Attending",ABM("PT")="O":"Operating",ABM("PT")="T":"Other",ABM("PT")="F":"Referring",ABM("PT")="R":"Rendering",ABM("PT")="P":"Purchased Service",1:"Supervising")
 ;
 I $D(ABMY("PAT")),ABMY("PAT")'=ABM("P") Q
 I $D(ABMY("LOC")),ABMY("LOC")'=ABM("L") Q
 I $D(ABMY("INS")),ABMY("INS")'=ABM("I") Q
 ;
 S ABM("ELGST")=$P($G(^AUPNPAT(ABM("P"),11)),U,12)
 I $G(ABMY("PTYP"))=2,$P($G(^AUPNPAT(ABM("P"),11)),U,12)'="I" Q
 I $G(ABMY("PTYP"))=1,$P($G(^AUPNPAT(ABM("P"),11)),U,12)="I" Q
 I $D(ABMY("TYP")) Q:ABMY("TYP")'[("^"_$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABM("I"),".211","I"),1,"I")_"^")
 ;
 I $P($G(^ABMDCLM(DUZ(2),ABM,0)),U,4)="P" D
 .I $G(ABMXR)="AB" Q  ;if a claim was pending and open/closed it was counting it twice in pending
 .S ABM("RECTYP")=5
 .S ABM("A")=$P($G(^ABMDCLM(DUZ(2),ABM,0)),U,19)  ;rec type and pending official
 .I $D(ABMY("BILLT")),'$D(ABMY("BILLT",ABM("A"))) Q
 .S ABM("ACTDT")=$P($G(^ABMDCLM(DUZ(2),ABM,0)),U,20)
 .D DATA^ABMEMPPR
 ;
 I $G(ABMXR)="AB" D
 .S ABM("CIEN")=+$O(^ABMDCLM(DUZ(2),ABM,69,"B",ABMP("DT"),0))
 .Q:'ABM("CIEN")
 .S ABMCSTAT=$P($G(^ABMDCLM(DUZ(2),ABM,69,ABM("CIEN"),0)),U,3)
 .S ABM("RECTYP")=$S(ABMCSTAT="O":6,1:7)
 .S ABM("ACTDT")=ABMP("DT")
 .S ABM("A")=$P($G(^ABMDCLM(DUZ(2),ABM,69,ABM("CIEN"),0)),U,2)
 .I $D(ABMY("BILLT")),'$D(ABMY("BILLT",ABM("A"))) Q
 .D DATA^ABMEMPPR
 ;
 I $G(ABMXR)="" D  ;this is if it's looping though the whole file with no date range selected
 .S ABM("CIEN")=0
 .F  S ABM("CIEN")=$O(^ABMDCLM(DUZ(2),ABM,69,ABM("CIEN"))) Q:'ABM("CIEN")  D
 ..S ABMCSTAT=$P($G(^ABMDCLM(DUZ(2),ABM,69,ABM("CIEN"),0)),U,3)
 ..S ABM("RECTYP")=$S(ABMCSTAT="O":6,1:7)
 ..S ABM("ACTDT")=$P($G(^ABMDCLM(DUZ(2),ABM,69,ABM("CIEN"),0)),U)
 ..S ABM("A")=$P($G(^ABMDCLM(DUZ(2),ABM,69,ABM("CIEN"),0)),U,2)
 ..I $D(ABMY("BILLT")),'$D(ABMY("BILLT",ABM("A"))) Q
 ..D DATA^ABMEMPPR
 ;
 Q
