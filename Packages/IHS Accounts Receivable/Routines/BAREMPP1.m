BAREMPP1 ; IHS/SD/SDR - Employee Productivity Report - Detail ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**35**;OCT 26, 2005;Build 187
 ;Original;SDR;
 ;IHS/SD/SDR 1.8*35 ADO59950 New employee productivity report
 ;
PRINT ;EP for writing data
 ;
 S BAR("PG")=0 D HDB
 ;
 I '$D(^TMP("BAR-EMPR",$J,"SUM")) D  Q  ;no data to report
 .U IO W !!,"NO DATA EXISTS"
 .D XIT
 ;
 S (BAR("LTOT"),BAR("CNT2"),BAR("CNT"),BAR("TOT1"),BAR("TOT2"),BAR("TOT"))=0
 S (BAR("LTOT","PMT"),BAR("LTOT","PMTAMT"),BAR("LTOT","ACRDT"),BAR("LTOT","ACRDTAMT"),BAR("LTOT","ADBT"),BAR("LTOT","ADBTAMT"),BAR("LTOT","RFND"),BAR("LTOT","RFNDAMT"))=0
 S (BAR("TXT"),BAR("APPR"),BAR("EXP"),BAR("XCLM"),BAR("XBILL"),BAR("PEND"),BAR("OPEN"),BAR("CLOS"))=""
 S BAR("PTECH")=""
 S BARFIRST=0
 F  S BAR("PTECH")=$O(^TMP("BAR-EMPR",$J,"SUM",BAR("PTECH"))) Q:($G(BAR("PTECH"))="")  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .S BAR("STXT")=$G(^TMP("BAR-EMPR",$J,"SUM",BAR("PTECH")))
 .S BAR("PMT")=+$P(BAR("STXT"),U)
 .S BAR("ACRDT")=+$P(BAR("STXT"),U,2)
 .S BAR("ADBT")=+$P(BAR("STXT"),U,3)
 .S BAR("RFND")=+$P(BAR("STXT"),U,5)
 .S BAR("PMTAMT")=+$P(BAR("STXT"),U,7)
 .S BAR("ACRDTAMT")=+$P(BAR("STXT"),U,8)
 .S BAR("ADBTAMT")=+$P(BAR("STXT"),U,9)
 .S BAR("RFNDAMT")=+$P(BAR("STXT"),U,10)
 .W !!?2,$E(BAR("PTECH"),1,12)
 .W ?16,$J(BAR("PMT"),5)
 .W ?23,$J($FN(BAR("PMTAMT"),",",2),10)
 .W ?33,$J(BAR("ACRDT"),6)
 .W ?39,$J($FN(BAR("ACRDTAMT"),",",2),11)
 .W ?51,$J(BAR("ADBT"),6)
 .W ?53,$J($FN(BAR("ADBTAMT"),",",2),11)
 .W ?69,$J(BAR("RFND"),2)
 .W ?72,$J($FN(BAR("RFNDAMT"),",",2),8)
 .I $G(^TMP("BAR-EMPR",$J,"SUM",BAR("PTECH")))="0^0^0^0^0^0^0^0^0^0" Q  ;the poster had no activity so top line only
 .W !!,BAR("PTECH")
 .D DTLP
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT)!$D(DIRUT) G XIT
 D TOTAL
 Q
DTLP ;
 S BAR("DT")=0
 F  S BAR("DT")=$O(^TMP("BAR-EMPR",$J,"DET",BAR("PTECH"),BAR("DT"))) Q:($G(BAR("DT"))="")  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!$D(DIRUT)
 .S BAR("LOC")=0
 .F  S BAR("LOC")=$O(^TMP("BAR-EMPR",$J,"DET",BAR("PTECH"),BAR("DT"),BAR("LOC"))) Q:($G(BAR("LOC"))="")  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!$D(DIRUT)
 ..S BAR("DSRC")=""
 ..F  S BAR("DSRC")=$O(^TMP("BAR-EMPR",$J,"DET",BAR("PTECH"),BAR("DT"),BAR("LOC"),BAR("DSRC"))) Q:($G(BAR("DSRC"))="")  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!$D(DIRUT)
 ...I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!$D(DIRUT)  D SUBHD W " (cont)"
 ...S BAR("STXT")=$G(^TMP("BAR-EMPR",$J,"DET",BAR("PTECH"),BAR("DT"),BAR("LOC"),BAR("DSRC")))
 ...S BAR("PMT")=+$P(BAR("STXT"),U)
 ...S BAR("ACRDT")=+$P(BAR("STXT"),U,2)
 ...S BAR("ADBT")=+$P(BAR("STXT"),U,3)
 ...S BAR("RFND")=+$P(BAR("STXT"),U,5)
 ...S BAR("PMTAMT")=+$P(BAR("STXT"),U,7)
 ...S BAR("ACRDTAMT")=+$P(BAR("STXT"),U,8)
 ...S BAR("ADBTAMT")=+$P(BAR("STXT"),U,9)
 ...S BAR("RFNDAMT")=+$P(BAR("STXT"),U,10)
 ...W !?1,$$SHDT^BARDUTL(BAR("DT"))
 ...I BAR("DSRC")="e" W "*"  ;to indicate ERA posting
 ...W ?10,BAR("LOC")
 ...W ?16,$J(BAR("PMT"),5)
 ...W ?23,$J($FN(BAR("PMTAMT"),",",2),10)
 ...W ?33,$J(BAR("ACRDT"),6)
 ...W ?39,$J($FN(BAR("ACRDTAMT"),",",2),11)
 ...W ?51,$J(BAR("ADBT"),6)
 ...W ?53,$J($FN(BAR("ADBTAMT"),",",2),11)
 ...W ?69,$J(BAR("RFND"),2)
 ...W ?72,$J($FN(BAR("RFNDAMT"),",",2),8)
 ...;
 ...S BAR("LTOT","PMT")=+$G(BAR("LTOT","PMT"))+BAR("PMT")
 ...S BAR("LTOT","PMTAMT")=+$G(BAR("LTOT","PMTAMT"))+BAR("PMTAMT")
 ...S BAR("LTOT","ACRDT")=+$G(BAR("LTOT","ACRDT"))+BAR("ACRDT")
 ...S BAR("LTOT","ACRDTAMT")=+$G(BAR("LTOT","ACRDTAMT"))+BAR("ACRDTAMT")
 ...S BAR("LTOT","ADBT")=+$G(BAR("LTOT","ADBT"))+BAR("ADBT")
 ...S BAR("LTOT","ADBTAMT")=+$G(BAR("LTOT","ADBTAMT"))+BAR("ADBTAMT")
 ...S BAR("LTOT","RFND")=+$G(BAR("LTOT","RFND"))+BAR("RFND")
 ...S BAR("LTOT","RFNDAMT")=+$G(BAR("LTOT","RFNDAMT"))+BAR("RFNDAMT")
 Q
 ;
HD ;
 D PAZ^BARRUTL I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) S BAR("F1")=1 Q
HDB ;
 S BAR("PG")=+$G(BAR("PG"))+1 D WHD^BARRHD
 W !?2,"A/R TECHNICIAN"
 W !?3,"DATE",?11,"LOC",?20,"PAYMENTS",?47,"ADJUSTMENTS",?71,"REFUNDS"
 W !?41,"CREDITS",?58,"DEBITS"
 S $P(BAR("LINE"),"-",80)="" W !,BAR("LINE") K BAR("LINE")
 Q
SUBHD ;EP
 W !!,BAR("PTECH")
 Q
TOTAL ;
 W !
 F B=1:1:80 W "-"
 W !,"TOTALS:"
 W ?16,$J(BAR("LTOT","PMT"),5)
 W ?23,$J($FN(BAR("LTOT","PMTAMT"),",",2),10)
 W ?33,$J(BAR("LTOT","ACRDT"),6)
 W ?39,$J($FN(BAR("LTOT","ACRDTAMT"),",",2),11)
 W ?51,$J(BAR("LTOT","ADBT"),6)
 W ?53,$J($FN(BAR("LTOT","ADBTAMT"),",",2),11)
 W ?69,$J(BAR("LTOT","RFND"),2)
 W ?72,$J($FN(BAR("LTOT","RFNDAMT"),",",2),8)
XIT ;EXIT POINT
 W !!,"<END OF REPORT>"
 D PAZ^BARRUTL
 Q
