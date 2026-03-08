ABMEMPC2 ; IHS/SD/SDR - Report Utility to Check Parms ;  
 ;;2.6;IHS Third Party Billing;**32**;NOV 12, 2009;Build 621
 ;Original;SDR
 ;IHS/SD/SDR 2.6*32 CR11501 New routine for new employee productivity report
 ;
CANCEL ;EP for checking Claim file data parameters
 D DOTS^ABMEMPCK
 K ABM("RECTYP")
 S ABMV="CANCEL"
 Q:'$D(^ABMCCLMS(DUZ(2),ABM,0))
 S ABMCREC=$G(^ABMCCLMS(DUZ(2),ABM,0))
 S ABM("V")=$P(ABMCREC,U,7)  ;visit type
 S ABM("L")=$P(ABMCREC,U,3)  ;visit location
 S ABM("I")=$P(ABMCREC,U,8)  ;active insurer
 S ABM("P")=$P(ABMCREC,U)  ;patient
 S ABM("D")=$P(ABMCREC,U,2)  ;encounter date
 S ABM("C")=$P(ABMCREC,U,6)  ;clinic
 S ABM("A")=$P($G(^ABMCCLMS(DUZ(2),ABM,1)),U,4)  ;cancelling official
 S ABM("CDT")=$P($G(^ABMCCLMS(DUZ(2),ABM,1)),U,5)  ;date/time cancelled
 S ABM("CR")=$P($G(^ABMCCLMS(DUZ(2),ABM,1)),U,8)  ;cancel reason
 I $D(ABMY("REASON")) Q:'$D(ABMY("REASON",ABM("CR")))
 Q:ABM("L")=""!(ABM("I")="")!(ABM("P")="")!(ABM("CDT")="")!(ABM("V")="")!(ABM("C")="")
 I $D(ABMY("NOTPOS")),ABM("V")=901 Q  ;no POS bills
 I $D(ABMY("POSONLY")),ABM("V")'=901 Q  ;POS bills only
 Q:'$D(^AUTNINS(ABM("I"),0))
 I $D(ABMY("DX")) S ABM("DX","HIT")=0,ABM("DX")="BILL" D DX^ABMEMPC3 Q:'ABM("DX","HIT")  ;diag
 I $D(ABMY("PX")) S ABM("PX","HIT")=0,ABM("PX")="BILL" D PX^ABMEMPC3 Q:'ABM("PX","HIT")  ;proc
 ;
 I $D(ABMY("PRV")),'$D(^ABMCCLMS(DUZ(2),ABM,41,"B",ABMY("PRV"))) Q
 I $D(ABMY("PRV")) D
 .S ABM("PT")=$O(^ABMCCLMS(DUZ(2),ABM,41,"B",ABMY("PRV"),0))
 .S ABM("PT")=$P($G(^ABMCCLMS(DUZ(2),ABM,41,ABM("PT"),0)),U,2)
 .S ABM("PT")=$S(ABM("PT")="A":"Attending",ABM("PT")="O":"Operating",ABM("PT")="T":"Other",ABM("PT")="F":"Referring",ABM("PT")="R":"Rendering",ABM("PT")="P":"Purchased Service",1:"Supervising")
 ;
 I $D(ABMY("PAT")),ABMY("PAT")'=ABM("P") Q
 I $D(ABMY("LOC")),ABMY("LOC")'=ABM("L") Q
 I $D(ABMY("INS")),ABMY("INS")'=ABM("I") Q
 S ABM("ELGST")=$P($G(^AUPNPAT(ABM("P"),11)),U,12)
 I $G(ABMY("PTYP"))=2,$P($G(^AUPNPAT(ABM("P"),11)),U,12)'="I" Q
 I $G(ABMY("PTYP"))=1,$P($G(^AUPNPAT(ABM("P"),11)),U,12)="I" Q
 I $D(ABMY("TYP")) Q:ABMY("TYP")'[$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABM("I"),".211","I"),1,"I")
 I $D(ABMY("BILLT")),$D(ABMY("BILLT")),'$D(ABMY("BILLT",ABM("A"))) Q
 S ABM("RECTYP")=3,ABM("ACTDT")=ABM("CDT")
 D DATA^ABMEMPPR
 Q
