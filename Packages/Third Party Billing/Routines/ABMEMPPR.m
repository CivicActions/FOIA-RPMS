ABMEMPPR ; IHS/SD/SDR - Employee Productivity Listing ;
 ;;2.6;IHS 3P BILLING SYSTEM;**32**;NOV 12, 2009;Build 621
 ;Original;SDR;
 ;IHS/SD/SDR 2.6*32 CR11501 New report
 ;
 K ABM,ABMY,ABMXR,ABMPRINT,ABMPATH,ABMFN
 D ^XBFMK
 S ABM("BILLT",DUZ)=""
 S ABM("EMPP")="EMP"
 S ABM("RTYP")=2  ;default report type #2 Summary
 S ABM("RTYP","NM")="STATISTICAL SUMMARY ONLY"
 D ^ABMDRSEL
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("HD",0)="EMP PRODUCTIVITY REPORT run by "_$E($P($G(^VA(200,DUZ,0)),U),1,16)
 D ^ABMDRHD
 S ABM("PRIVACY")=1
 ;
 I ABM("RTYP")=3 S ABMPRINT="H"  ;this forces validator to HFS file
 ;
 I ABM("RTYP")'=3 D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)  ;for detail and summary prompt if it should print or go to HFS file
 .S DIR(0)="S^P:Print Report;H:Print Delimited Report to the HOST FILE"
 .S DIR("A")="<P> to Print, <H> to Host File"
 .S DIR("B")="P"
 .D ^DIR K DIR Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .S ABMPRINT=$P(Y,U)
 ;
 I ABMPRINT="H" D  Q
 .I ABM("RTYP")'=3 D  Q:POP
 ..D ^XBFMK
 ..S POP=0
 ..S DIR(0)="F"
 ..S DIR("A")="Enter Path"
 ..S DIR("B")=$P($G(^ABMDPARM(DUZ(2),1,4)),"^",7)
 ..D ^DIR K DIR
 ..I $G(Y)["^" S POP=1 Q
 ..S ABMPATH=$S($G(Y)="":ABMPATH,1:Y)
 ..D ^XBFMK
 ..S DIR(0)="F"
 ..S DIR("A")="Enter filename"
 ..D ^DIR K DIR
 ..I $G(Y)["^" S POP=1 Q
 ..S ABMFN=Y
 .I 1
 .D COMPUTE^ABMEMPPR
 .S ABMROUTN="PRINT^ABMEMPP"_ABM("RTYP")
 .D @ABMROUTN
 ;
 S ABMQ("RC")="COMPUTE^ABMEMPPR"
 S ABMQ("RX")="POUT^ABMDRUTL"
 S ABMQ("NS")="ABM"
 S ABMQ("RP")="PRINT^ABMEMPP"_ABM("RTYP")
 D ^ABMDRDBQ
 ;
 Q
 ;
COMPUTE ;EP - Entry Point for Setting up Data
 S ABM("SUBR")="ABM-EMPR"
 K ^TMP("ABM-EMPR",$J)
 S ABMP("RTN")="ABMEMPPR"
 D LOOP^ABMEMPCK
 Q
 ;
DATA ;EP
 ;
 ;summary is location, biller, p1-approv.bills p2-export.bills p3-cxl'd.claims p4-cxl'd.bills p5-pend.claims p6-open.claims p7-closed.claims
 ;
 ;detail is biller^activity.date^location^approv.bills^export.bills^cxl'd.claims^cxl'd.bills^pend.claims^open.claims^closed.claims
 ;
 ;validator is location^biller^activity.date^service.date^clinic^visit.type^active.insurer^claim/bill.number^type.of.record
 ;     type.of.record will be (BILLED CLAIM/EXPORT BILL/CXL CLAIM/CXL BILL/PEND CLM/OPEN CLAIM/CLOSE CLAIM
 ;
 Q:($G(ABM("RECTYP"))="")
 ;
 I +$G(ABM("A"))'=0 S ABMA=""_$P($G(^VA(200,ABM("A"),0)),U)_""
 E  S ABMA="<NoBillTech>"
 S ABML=$P($G(^DIC(4,ABM("L"),0)),U)_"+"_ABM("L")
 ;
 ;summary
 S $P(^TMP("ABM-EMPR",$J,"SUM",ABML,ABMA),U,ABM("RECTYP"))=$P($G(^TMP("ABM-EMPR",$J,"SUM",ABML,ABMA)),U,ABM("RECTYP"))+1  ;summary
 I $G(ABMY("SORT"))'="" D
 .I ABMY("SORT")="V",$D(ABMY("VTYP")),'$D(ABMY("VTYP",ABM("V"))) Q
 .I ABMY("SORT")="C",$D(ABMY("CLIN")),'$D(ABMY("CLIN",ABM("C"))) Q
 .S ABM("S")=$S($G(ABMY("SORT"))="V":ABM("V"),$G(ABMY("SORT"))="C":ABM("C"),1:"")
 .I $G(ABMY("SORT"))'="" S $P(^TMP("ABM-EMPR",$J,"SUMSRT",ABML,ABMA,ABM("S")),U,ABM("RECTYP"))=$P($G(^TMP("ABM-EMPR",$J,"SUMSRT",ABML,ABMA,ABM("S"))),U,ABM("RECTYP"))+1
 ;
 ;detail
 S $P(^TMP("ABM-EMPR",$J,"DETHDR",ABMA),U,ABM("RECTYP"))=$P($G(^TMP("ABM-EMPR",$J,"DETHDR",ABMA)),U,ABM("RECTYP"))+1  ;detail
 S $P(^TMP("ABM-EMPR",$J,"DET",ABMA,$P(ABM("ACTDT"),"."),ABML),U,ABM("RECTYP"))=$P($G(^TMP("ABM-EMPR",$J,"DET",ABMA,$P(ABM("ACTDT"),"."),ABML)),U,ABM("RECTYP"))+1  ;detail
 I $G(ABMY("SORT"))'="" D
 .I ABMY("SORT")="V",$D(ABMY("VTYP")),'$D(ABMY("VTYP",ABM("V"))) Q
 .I ABMY("SORT")="C",$D(ABMY("CLIN")),'$D(ABMY("CLIN",ABM("C"))) Q
 .S ABM("S")=$S($G(ABMY("SORT"))="V":ABM("V"),$G(ABMY("SORT"))="C":ABM("C"),1:"")
 .I $G(ABMY("SORT"))'="" S $P(^TMP("ABM-EMPR",$J,"DETSRT",ABMA,$P(ABM("ACTDT"),"."),ABML,ABM("S")),U,ABM("RECTYP"))=$P($G(^TMP("ABM-EMPR",$J,"DETSRT",ABMA,$P(ABM("ACTDT"),"."),ABML,ABM("S"))),U,ABM("RECTYP"))+1
 ;
 ;validator
 S ABM("RECTYP")=$S(ABM("RECTYP")=1:"Approved",ABM("RECTYP")=2:"Exported",ABM("RECTYP")=3:"CxlClaim",ABM("RECTYP")=4:"CxlBill",ABM("RECTYP")=5:"Pending",ABM("RECTYP")=6:"Open",1:"Closed")
 S ABM("IO")=$P($G(^AUTNINS(ABM("I"),0)),U)
 S ABMRECO=ABM("V")_"-"_$P($G(^ABMDVTYP(ABM("V"),0)),U)_U_ABM("C")_"-"_$P($G(^DIC(40.7,ABM("C"),0)),U)_U_$$BDT^ABMDUTL(ABM("D"))_U_ABM("IO")_U_ABM("RECTYP")
 S ABMRECO=ABMRECO_U_$J($FN(+$G(ABM("BAMT")),",",2),12)  ;include amount billed if there is one
 S ABMRECO=ABMRECO_U_$P($G(^DPT(ABM("P"),0)),U)  ;patient
 S ABMRECO=ABMRECO_U_$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABM("I"),".211","I"),".01","E")  ;insurer type
 S ABMRECO=ABMRECO_U_$S(ABM("ELGST")="I":"INELIGIBILE",ABM("ELGST")="D":"DIRECT ONLY",ABM("ELGST")="C":"CHS & DIRECT",1:"PENDING VERIFICATION")  ;eligibility status
 I $D(ABMY("PRV")) S ABMRECO=ABMRECO_U_$P($G(^VA(200,ABMY("PRV"),0)),U)_U_ABM("PT")  ;provider and provider type
 I $D(ABMY("PX")) S ABMRECO=ABMRECO_U_ABM("CPT")  ;CPT
 I $D(ABMY("DX")) S ABMRECO=ABMRECO_U_$P($G(^ICD9(ABM("DX"),0)),U)  ;DX 
 S ^TMP("ABM-EMPR",$J,"VAL",ABML,ABMA,$$BDT^ABMDUTL(ABM("ACTDT")),$S($G(ABM("BNUM"))'="":ABM("BNUM"),1:ABM),ABMRECO)=""
 ;
 Q
 ;
XIT K ABM,ABMY,ABMP
 Q
