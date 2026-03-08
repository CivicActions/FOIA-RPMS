BAREMPP4 ; IHS/SD/SDR - Employee Productivity Report - Validator ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**35**;OCT 26, 2005;Build 187
 ;Original;SDR;
 ;IHS/SD/SDR 1.8*35 ADO59950 New employee productivity report
 ;
PRINT ;EP for writing data
 D HDB
 ;
 I '$D(^TMP("BAR-EMPR",$J,"VAL")) D  Q  ;no data to report
 .U IO W !!,"NO DATA EXISTS"
 .D CLOSE^%ZISH("BAR")
 ;
 S BAR("PTECH")=""
 F  S BAR("PTECH")=$O(^TMP("BAR-EMPR",$J,"VAL",BAR("PTECH"))) Q:BAR("PTECH")=""  D
 .S BARTR=""
 .F  S BARTR=$O(^TMP("BAR-EMPR",$J,"VAL",BAR("PTECH"),BARTR)) Q:$G(BARTR)=""  D
 ..W !,$G(^TMP("BAR-EMPR",$J,"VAL",BAR("PTECH"),BARTR))
 ;
 U IO(0) W !!,"REPORT COMPLETE",!
 D CLOSE^%ZISH("BAR")
 ;
 S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 Q
HD ;
HDB S BAR("PG")=1 D WHD^BARRHD
 W !
 W "Session ID^Transaction IEN^Transaction Date^Location^A/R Technician^Bill Number^Patient^Transaction Type^Transaction Amount^Adjustment Category^Adjustment Type"
 W "^A/R Account^Collection Batch^Item^TDN^Insurer Type^Allowance Category^ERA Flag"
 Q
XIT ;EXIT POINT
 Q
