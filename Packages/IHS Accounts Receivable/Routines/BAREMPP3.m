BAREMPP3 ; IHS/SD/SDR - Employee Productivity Report - Validator ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**35**;OCT 26, 2005;Build 187
 ;Original;SDR;
 ;IHS/SD/SDR 1.8*35 ADO59950 New employee productivity report
 ;
PRINT ;EP for writing data
 ;
 U IO
 D HDB
 ;
 I '$D(^TMP("BAR-EMPR",$J,"DET")) D  Q  ;no data to report
 .U IO W !!,"NO DATA EXISTS"
 .D CLOSE^%ZISH("BAR")
 ;
 S BAR("PTECH")=""
 F  S BAR("PTECH")=$O(^TMP("BAR-EMPR",$J,"DET",BAR("PTECH"))) Q:($G(BAR("PTECH"))="")  D
 .S BAR("DT")=""
 .F  S BAR("DT")=$O(^TMP("BAR-EMPR",$J,"DET",BAR("PTECH"),BAR("DT"))) Q:$G(BAR("DT"))=""  D
 ..S BAR("L")=""
 ..F  S BAR("L")=$O(^TMP("BAR-EMPR",$J,"DET",BAR("PTECH"),BAR("DT"),BAR("L"))) Q:BAR("L")=""  D
 ...S BARSESID=""
 ...F  S BARSESID=$O(^TMP("BAR-EMPR",$J,"DET",BAR("PTECH"),BAR("DT"),BAR("L"),BARSESID)) Q:($G(BARSESID)="")  D
 ....W !
 ....W BARSESID_U_$$SDT^BARDUTL(BAR("DT"))_U_BAR("L")_U_BAR("PTECH")_U_$G(^TMP("BAR-EMPR",$J,"DET",BAR("PTECH"),BAR("DT"),BAR("L"),BARSESID))
 ;
 U IO(0) W !!,"REPORT COMPLETE",!
 D CLOSE^%ZISH("BAR")
 ;
 S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 Q
HD ;
HDB S BAR("PG")=1 D WHD^BARRHD
 W !
 W "Session ID^Transaction Date^Location^A/R Technician^Payment Count^Payment Amount (Dollars)^Credit Count^Credit Amount (Dollars)^Debit Count^Debit Amount (Dollars)^Refund Count^Refund Amount (Dollars)^ERA Ind"
 W "^Message Count^Remark Code Count^Post Status Change Credit Count^Post Status Change Credit Amount^Post Status Change Debit Count^Post Status Change Debit Amount^Unallocated Count^Unallocated Amount"
 Q
XIT ;EXIT POINT
 Q
