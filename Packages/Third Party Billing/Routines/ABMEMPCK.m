ABMEMPCK ; IHS/SD/SDR - Report Utility to Check Parms ;  
 ;;2.6;IHS Third Party Billing;**32**;NOV 12, 2009;Build 621
 ;Original;SDR
 ;IHS/SD/SDR 2.6*32 CR11501 New routine for new employee productivity report
 ;
LOOP ;EP for Looping thru Bill File
 ;S ABMP("X")=$S($G(ABMY("DT"))="V":"AD",$G(ABMY("DT"))="T":"T",$D(ABMY("INS")):"AJ",$D(ABMY("PAT")):"D",1:1)
 S ABMP("X")=$S($G(ABMY("DT"))="V":"AD",$G(ABMY("DT"))="T":"T",1:1)
 I $D(ABMY("DT")) D
 .I +$P(ABMY("DT",2),".",2)'=0 S ABMP("DT",2)=ABMY("DT",2)
 .E  S ABMP("DT",2)=(ABMY("DT",2)+.999999)
 ;
 ;start new abm*2.6*32 IHS/SD/SDR CR11501
 I $D(ABMY("PX")) D
 .S ABMY("CPX",1)=$$NUM^ABMCVAPI(ABMY("PX",1))
 .S ABMY("CPX",2)=$$NUM^ABMCVAPI(ABMY("PX",2))
 ;end new abm*2.6*32 IHS/SD/SDR CR11501
 ;
 ;loop thru all bills if no visit date, activity date, insurer, or patient selected
ALLBILLS ;
 I ABMP("X") D  Q
 .;loop for 3P Bills
 .S ABM=0
 .F  S ABM=$O(^ABMDBILL(DUZ(2),ABM)) Q:'ABM  D BILL
 .K ABM("BNUM"),ABM("BAMT")
 .;loop for 3P Claims
 .S ABM=0
 .F  S ABM=$O(^ABMDCLM(DUZ(2),ABM)) Q:'ABM  D CLM^ABMEMPC1
 .;loop for 3P Cancelled Claims
 .S ABM=0
 .F  S ABM=$O(^ABMCCLMS(DUZ(2),ABM)) Q:'ABM  D CANCEL^ABMEMPC2
 .;add loop for 3P TX Status and then bill
 ;
VISITDT ;
 ;if visit date - loop through cancelled claims, claims and bills visit multiple
 I $G(ABMY("DT"))]"","V"[ABMY("DT") S ABMP("DT")=ABMY("DT",1)-.0000001 D  Q
 .F  S ABMP("DT")=$O(^ABMDBILL(DUZ(2),ABMP("X"),ABMP("DT"))) Q:'ABMP("DT")!(ABMP("DT")>(ABMP("DT",2)))  D
 ..S ABM=""
 ..F  S ABM=$O(^ABMDBILL(DUZ(2),ABMP("X"),ABMP("DT"),ABM)) Q:'ABM  D BILL
 .K ABM("BNUM"),ABM("BAMT")
 .;loop for 3P Claim visits
 .S ABMP("DT")=ABMY("DT",1)-.0000001
 .F  S ABMP("DT")=$O(^ABMDCLM(DUZ(2),"AD",ABMP("DT"))) Q:'ABMP("DT")!(ABMP("DT")>(ABMP("DT",2)))  D
 ..S ABM=""
 ..F  S ABM=$O(^ABMDCLM(DUZ(2),"AD",ABMP("DT"),ABM)) Q:'ABM  D CLM^ABMEMPC1
 .;
 .;loop for 3P Cancelled Claim visits
 .S ABMP("DT")=ABMY("DT",1)-.0000001
 .F  S ABMP("DT")=$O(^ABMCCLMS(DUZ(2),"AD",ABMP("DT"))) Q:'ABMP("DT")!(ABMP("DT")>(ABMP("DT",2)))  D
 ..S ABM=0
 ..F  S ABM=$O(^ABMCCLMS(DUZ(2),"AD",ABMP("DT"),ABM)) Q:'ABM  D CANCEL^ABMEMPC2
 ;
ACTIVITY ;
 ;if activity date - loop through cancelled claims, claims (pending and open/closed), bills (approved, exported and cancelled)
 I $G(ABMY("DT"))="T" S ABMP("DT")=ABMY("DT",1)-.0000001 D  Q
 .;
 .;loop for 3P Claims
 .F ABMXR="AH","AB" D  ;AH is pending; AB is open/closed
 ..S ABMP("DT")=ABMY("DT",1)-.0000001
 ..F  S ABMP("DT")=$O(^ABMDCLM(DUZ(2),ABMXR,ABMP("DT"))) Q:'ABMP("DT")!(ABMP("DT")>(ABMP("DT",2)))  D
 ...S ABM=0
 ...F  S ABM=$O(^ABMDCLM(DUZ(2),ABMXR,ABMP("DT"),ABM)) Q:'ABM  D CLM^ABMEMPC1
 .;
 .;loop for 3P Cancelled Claims
 .S ABMP("DT")=ABMY("DT",1)-.0000001
 .F  S ABMP("DT")=$O(^ABMCCLMS(DUZ(2),"AC",ABMP("DT"))) Q:'ABMP("DT")!(ABMP("DT")>(ABMP("DT",2)))  D
 ..S ABM=0
 ..F  S ABM=$O(^ABMCCLMS(DUZ(2),"AC",ABMP("DT"),ABM)) Q:'ABM  D CANCEL^ABMEMPC2
 .;
 .;loop for 3P Bills for approved and cancelled
 .F ABMXR="AH","AP" D  ;AH is cancelled; AP is approved
 ..S ABMP("DT")=ABMY("DT",1)-.0000001
 ..F  S ABMP("DT")=$O(^ABMDBILL(DUZ(2),ABMXR,ABMP("DT"))) Q:'ABMP("DT")!(ABMP("DT")>(ABMP("DT",2)))  D
 ...S ABM=0
 ...F  S ABM=$O(^ABMDBILL(DUZ(2),ABMXR,ABMP("DT"),ABM)) Q:'ABM  D BILL
 Q
 ;
BILL ;EP for checking Bill File data parameters
 D DOTS
 K ABM("RECTYP"),ABM("ACTDT")
 S ABMV="BILL"
 Q:'$D(^ABMDBILL(DUZ(2),ABM,0))!('$D(^(1)))
 S ABM("BSTAT")=$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,4)  ;bill status
 S ABM("V")=$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,7)  ;visit type
 S ABM("L")=$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,3)  ;visit loc
 S ABM("I")=$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,8)  ;active ins
 S ABM("P")=$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,5)  ;patient
 S ABM("D")=$P($G(^ABMDBILL(DUZ(2),ABM,7)),U)  ;service dt from
 S ABM("A")=$P($G(^ABMDBILL(DUZ(2),ABM,1)),U,4)  ;appr. official
 S ABM("XBY")=$P($G(^ABMDBILL(DUZ(2),ABM,1)),U,11)  ;cancelling official
 S (ABM("XDT"),ABM("PXDT"))=$P($G(^ABMDBILL(DUZ(2),ABM,1)),U,12)  ;cancellation date
 ;if there's no cancellation date default this; makes the output 7//1900 that will be replaced later with <no date>
 I ((ABM("BSTAT")="X")&(+$G(ABM("XDT"))=0)) S ABM("XDT")=2007
 I +$P($G(ABMY("DT",1)),".",2)=0 S ABM("XDT")=$P(ABM("XDT"),".")  ;to compare only date
 S ABM("C")=$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,10)  ;clinic
 S (ABM("AD"),ABM("PAD"))=$P($G(^ABMDBILL(DUZ(2),ABM,1)),U,5)  ;date/time appr
 I +$P($G(ABMY("DT",1)),".",2)=0 S ABM("AD")=$P(ABM("AD"),".")  ;to compare only date
 S ABM("TD")=$P($G(^ABMDBILL(DUZ(2),ABM,1)),U,7)  ;export number (ptr)
 S ABM("BAMT")=$P($G(^ABMDBILL(DUZ(2),ABM,2)),U)  ;amount billed
 S ABM("BNUM")=$P($G(^ABMDBILL(DUZ(2),ABM,0)),U)  ;bill number
 K ABM("TCLRK"),ABM("TDT")
 I ABM("TD")'="" D
 .S (ABM("TDT"),ABM("PTDT"))=$P($G(^ABMDTXST(DUZ(2),ABM("TD"),0)),U)  ;3P Tx Status Export Date/Time
 .I +$P($G(ABMY("DT",1)),".",2)=0 S ABM("TDT")=$P(ABM("TDT"),".")  ;to compare only date
 .S ABM("TCLRK")=$P($G(^ABMDTXST(DUZ(2),ABM("TD"),0)),U,5)  ;3P Tx Status Billing Clerk
 .I +$G(ABM("TCLRK"))=0 D
 ..S I=$O(^ABMDTXST(DUZ(2),ABM("TD"),3,0))
 ..I +$G(I)'=0 S ABM("TCLRK")=$P($G(^ABMDTXST(DUZ(2),ABM("TD"),3,I,0)),U,4)
 I +$G(ABM("TCLRK"))=0 S ABM("TCLRK")="<NOCLRK>"  ;default to zero
 Q:ABM("L")=""!(ABM("I")="")!(ABM("P")="")!(ABM("D")="")
 ;
 I $D(ABMY("NOTPOS")),(ABM("V")=901) Q  ;no POS bills
 I $D(ABMY("POSONLY")),(ABM("V")'=901) Q  ;POS bills only
 Q:'$D(^AUTNINS(ABM("I"),0))
 Q:($D(ABMY("VYTP"))&(ABM("V")=""))
 Q:($D(ABMY("CLIN"))&(ABM("C")=""))
 I $D(ABMY("LOC")),ABMY("LOC")'=ABM("L") Q
 I $D(ABMY("PAT")),ABMY("PAT")'=ABM("P") Q
 I $D(ABMP("FORM")),+ABMP("FORM")'=$P(^ABMDBILL(DUZ(2),ABM,0),U,6) Q  ;export mode
 ;
 I $D(ABMY("PRV")),'$D(^ABMDBILL(DUZ(2),ABM,41,"B",ABMY("PRV"))) Q  ;provider
 I $D(ABMY("PRV")) D
 .S ABM("PT")=$O(^ABMDBILL(DUZ(2),ABM,41,"B",ABMY("PRV"),0))
 .S ABM("PT")=$P($G(^ABMDBILL(DUZ(2),ABM,41,ABM("PT"),0)),U,2)
 .S ABM("PT")=$S(ABM("PT")="A":"Attending",ABM("PT")="O":"Operating",ABM("PT")="T":"Other",ABM("PT")="F":"Referring",ABM("PT")="R":"Rendering",ABM("PT")="P":"Purchased Service",1:"Supervising")
 ;
 I $D(ABMY("DX")) S ABM("DX","HIT")=0,ABM("DX")="BILL" D DX^ABMEMPC3 Q:'ABM("DX","HIT")  ;diag
 I $D(ABMY("PX")) S ABM("PX","HIT")=0,ABM("PX")="BILL" D PX^ABMEMPC3 Q:'ABM("PX","HIT")  ;proc
 ;
 ;eligibility status checks
 S ABM("ELGST")=$P($G(^AUPNPAT(ABM("P"),11)),U,12)
 I $G(ABMY("PTYP"))=2,$P($G(^AUPNPAT(ABM("P"),11)),U,12)'="I" Q
 I $G(ABMY("PTYP"))=1,$P($G(^AUPNPAT(ABM("P"),11)),U,12)="I" Q
 ;
 I $D(ABMY("INS")),ABMY("INS")'=ABM("I") Q
 I $D(ABMY("TYP")) Q:("^"_ABMY("TYP")_"^")'[("^"_$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABM("I"),".211","I"),1,"I")_"^")  ;abm*2.6*10 HEAT73780  ;abm*2.6*21 IHS/SD/SDR VMBP RQMT_96
 ;
 K ABM("QUIT")
 ;
 ;if they selected an activity date range
 I ($G(ABMY("DT"))="T") D  Q
 .;approval date
 .I (ABMY("DT",1)=ABM("AD"))!(ABMY("DT",2)=ABM("AD"))!(ABM("AD")>ABMY("DT",1)&(ABM("AD")<ABMP("DT",2))) D
 ..Q:(ABMXR="AH")&(ABMY("DT")="T")  ;don't count when looking for cancelled bills
 ..I $D(ABMY("BILLT")),'$D(ABMY("BILLT",ABM("A"))) Q
 ..S ABM("RECTYP")=1
 ..S ABM("ACTDT")=ABM("PAD")
 ..D DATA^ABMEMPPR
 .;
 .;export date
 .I ($G(ABM("TDT"))'="") D
 ..I (ABMY("DT",1)=ABM("TDT"))!(ABMY("DT",2)=ABM("TDT"))!(ABM("TDT")>ABMY("DT",1)&(ABM("TDT")<ABMP("DT",2))) D
 ...Q:(ABMXR="AH")&(ABMY("DT")="T")  ;don't count when looking for cancelled bills
 ...I $D(ABMY("BILLT")),'$D(ABMY("BILLT",ABM("TCLRK"))) Q
 ...S ABM("RECTYP")=2
 ...S ABM("ACTDT")=ABM("PTDT")
 ...S ABM("A")=ABM("TCLRK")
 ...D DATA^ABMEMPPR
 .;
 .;cancellation date
 .I (ABMY("DT",1)=ABM("XDT"))!(ABMY("DT",2)=ABM("XDT"))!(ABM("XDT")>ABMY("DT",1)&(ABM("XDT")<ABMP("DT",2))) D
 ..Q:(ABMXR="AP")&(ABMY("DT")="T")  ;don't count when looking for approved bills
 ..I $D(ABMY("BILLT")),'$D(ABMY("BILLT",ABM("XBY"))) Q
 ..S ABM("RECTYP")=4
 ..S ABM("ACTDT")=ABM("PXDT")
 ..S ABM("A")=ABM("XBY")
 ..D DATA^ABMEMPPR
 ;
 ;if they selected a visit date range
 I ($G(ABMY("DT"))="V") D  Q
 .I (ABMY("DT",1)=ABM("D"))!(ABMY("DT",2)=ABM("D"))!(ABM("D")>ABMY("DT",1)&(ABM("D")<ABMP("DT",2))) D
 ..;I $D(ABMY("BILLT")),$D(ABMY("BILLT",ABM("A"))) D
 ..I ($D(ABMY("BILLT"))&$D(ABMY("BILLT",ABM("A"))))!('$D(ABMY("BILLT"))) D
 ...S ABM("RECTYP")=1
 ...S ABM("ACTDT")=ABM("PAD")
 ...D DATA^ABMEMPPR
 ..;I $D(ABMY("BILLT")),$D(ABMY("BILLT",+$G(ABM("TCLRK")))) D
 ..I ($D(ABMY("BILLT"))&$D(ABMY("BILLT",+$G(ABM("TCLRK")))))!('$D(ABMY("BILLT"))) D
 ...I $G(ABM("TDT"))="" Q  ;not exported
 ...S ABM("RECTYP")=2
 ...S ABM("ACTDT")=ABM("PTDT")
 ...S ABM("A")=ABM("TCLRK")
 ...D DATA^ABMEMPPR
 ..;I $D(ABMY("BILLT")),$D(ABMY("BILLT",+$G(ABM("XBY")))) D
 ..I ($D(ABMY("BILLT"))&$D(ABMY("BILLT",+$G(ABM("XBY")))))!('$D(ABMY("BILLT"))) D
 ...I $G(ABM("XDT"))="" Q  ;not cancelled
 ...S ABM("RECTYP")=4
 ...S ABM("ACTDT")=ABM("PXDT")
 ...S ABM("A")=ABM("XBY")
 ...D DATA^ABMEMPPR
 ;
 I $D(ABMY("BILLT")),$D(ABMY("BILLT",ABM("A"))) S ABM("RECTYP")=1,ABM("ACTDT")=ABM("PAD") D DATA^ABMEMPPR  ;our approving official
 I $D(ABMY("BILLT")),$G(ABM("XBY")),$D(ABMY("BILLT",ABM("XBY"))) S ABM("A")=ABM("XBY"),ABM("RECTYP")=4,ABM("ACTDT")=ABM("PXDT") D DATA^ABMEMPPR  ;cancelling official
 I +$G(ABM("TD"))'=0,$G(ABM("TCLRK")),$D(ABMY("BILLT")),$D(ABMY("BILLT",ABM("TCLRK"))) S ABM("A")=ABM("TCLRK"),ABM("RECTYP")=2,ABM("ACTDT")=ABM("PTDT") D DATA^ABMEMPPR  ;exporting/billing clerk
 ;
 ;by here it should only be if a date range isn't selected and groups (all billing or all POS)
 I $D(ABMY("NOTPOS"))!$D(ABMY("POSONLY"))!$D(ABMY("BOTHPOS")) D
 .I +$G(ABM("AD"))'=0 S ABM("RECTYP")=1,ABM("ACTDT")=ABM("PAD") D DATA^ABMEMPPR  ;date/time approved
 .I +$G(ABM("TDT"))'=0 S ABM("RECTYP")=2,ABM("ACTDT")=ABM("PTDT"),ABM("A")=ABM("TCLRK") D DATA^ABMEMPPR  ;3P TX Status Export date/time
 .I +$G(ABM("XDT"))'=0 S ABM("RECTYP")=4,ABM("ACTDT")=ABM("PXDT"),ABM("A")=ABM("XBY") D DATA^ABMEMPPR  ;cancellation date
 Q
 ;
DOTS ;
 S ABMCNT=+$G(ABMCNT)+1
 I ABMCNT=1 U IO(0) W !
 I (ABMCNT#1000&(IOST["C")) U IO(0) W "."
 ;
 Q
