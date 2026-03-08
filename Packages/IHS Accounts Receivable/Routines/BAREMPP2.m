BAREMPP2 ; IHS/SD/SDR - Employee Productivity Report-Summary ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**35**;OCT 26, 2005;Build 187
 ;Original;SDR;
 ;IHS/SD/SDR 1.8*35 ADO59950 New employee productivity report
 ;
PRINT ;EP for writing data
 S BAR("PG")=0 D HDB
 ;
 I '$D(^TMP("BAR-EMPR",$J,"SUM")) D  Q  ;no data to report
 .U IO W !!,"NO DATA EXISTS"
 .D XIT
 ;
 S (BAR("LTOT"),BAR("CNT2"),BAR("CNT"),BAR("TOT1"),BAR("TOT2"),BAR("TOT"))=0
 S BAR("L")=""
 S BARFIRST=0
 F  S BAR("L")=$O(^TMP("BAR-EMPR",$J,"SUM",BAR("L"))) Q:BAR("L")=""  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .S BARFIRST=1
 .D SUBHD
 .S BAR("A")=""
 .F  S BAR("A")=$O(^TMP("BAR-EMPR",$J,"SUM",BAR("L"),BAR("A"))) Q:($G(BAR("A"))="")  D  G:$D(DTOUT)!$D(DUOUT)!$D(DIROUT) XIT
 ..I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  D SUBHD W " (cont)"
 ..S BAR("TXT")=$G(^TMP("BAR-EMPR",$J,"SUM",BAR("L"),BAR("A")))
 ..S BAR("PYMT")=+$P(BAR("TXT"),U)
 ..S BAR("ACRDT")=+$P(BAR("TXT"),U,2)
 ..S BAR("ADBT")=+$P(BAR("TXT"),U,3)
 ..S BAR("UNALC")=+$P(BAR("TXT"),U,4)
 ..S BAR("RFND")=+$P(BAR("TXT"),U,5)
 ..S BAR("MSG")=+$P(BAR("TXT"),U,6)
 ..;
 ..W !?3,$E(BAR("A"),1,25)
 ..W ?28,$J(BAR("PYMT"),6)
 ..W ?37,$J(BAR("ACRDT"),6)
 ..W ?46,$J(BAR("ADBT"),6)
 ..W ?55,$J(BAR("UNALC"),6)
 ..W ?64,$J(BAR("RFND"),6)
 ..W ?73,$J(BAR("MSG"),6)
 ..;
 ..;location totals (subtotals)
 ..S BAR("LTOT","PYMT")=+$G(BAR("LTOT","PYMT"))+BAR("PYMT")
 ..S BAR("LTOT","ADBT")=+$G(BAR("LTOT","ADBT"))+BAR("ADBT")
 ..S BAR("LTOT","ACRDT")=+$G(BAR("LTOT","ACRDT"))+BAR("ACRDT")
 ..S BAR("LTOT","UNALC")=+$G(BAR("LTOT","UNALC"))+BAR("UNALC")
 ..S BAR("LTOT","RFND")=+$G(BAR("LTOT","RFND"))+BAR("RFND")
 ..S BAR("LTOT","MSG")=+$G(BAR("LTOT","MSG"))+BAR("MSG")
 ..;
 ..;biller totals for all locations
 ..S BAR("LBTOT",BAR("A"),"PYMT")=+$G(BAR("LBTOT",BAR("A"),"PYMT"))+BAR("PYMT")
 ..S BAR("LBTOT",BAR("A"),"ADBT")=+$G(BAR("LBTOT",BAR("A"),"ADBT"))+BAR("ADBT")
 ..S BAR("LBTOT",BAR("A"),"ACRDT")=+$G(BAR("LBTOT",BAR("A"),"ACRDT"))+BAR("ACRDT")
 ..S BAR("LBTOT",BAR("A"),"UNALC")=+$G(BAR("LBTOT",BAR("A"),"UNALC"))+BAR("UNALC")
 ..S BAR("LBTOT",BAR("A"),"RFND")=+$G(BAR("LBTOT",BAR("A"),"RFND"))+BAR("RFND")
 ..S BAR("LBTOT",BAR("A"),"MSG")=+$G(BAR("LBTOT",BAR("A"),"MSG"))+BAR("MSG")
 ..;
 ..;report totals
 ..S BAR("TOT","PYMT")=+$G(BAR("TOT","PYMT"))+BAR("PYMT")
 ..S BAR("TOT","ADBT")=+$G(BAR("TOT","ADBT"))+BAR("ADBT")
 ..S BAR("TOT","ACRDT")=+$G(BAR("TOT","ACRDT"))+BAR("ACRDT")
 ..S BAR("TOT","UNALC")=+$G(BAR("TOT","UNALC"))+BAR("UNALC")
 ..S BAR("TOT","RFND")=+$G(BAR("TOT","RFND"))+BAR("RFND")
 ..S BAR("TOT","MSG")=+$G(BAR("TOT","MSG"))+BAR("MSG")
 .;
 .D SUBT
 ;
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 D TOT
 ;
 W !!,"<END OF REPORT>"
 D PAZ^BARRUTL
 Q
 ;
HD ;
 D PAZ^BARRUTL I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) S BAR("F1")=1 Q
HDB ;
 S BAR("PG")=BAR("PG")+1 D WHD^BARRHD
 W !?39,"ADJUSTMENTS",?55,"UN-"
 W !?3,"A/R TECHNICIAN"
 W ?28,"PAYMNT",?36,"CREDIT",?46,"DEBIT",?55,"ALLOC",?64,"REFUND",?73,"MESSGE"
 S $P(BAR("LINE"),"-",80)="" W !,BAR("LINE") K BAR("LINE")
 Q
SUBHD ;EP
 W !!,$P(BAR("L"),"+")
 Q
SUBT ;
 Q:'$D(BAR("LTOT"))
 W !?28,"------",?37,"------",?46,"------",?55,"------",?64,"------",?73,"------"
 W !,$E($P(BAR("L"),"+"),1,21)_" totals:"
 W ?28,$J(BAR("LTOT","PYMT"),6)
 W ?37,$J(BAR("LTOT","ACRDT"),6)
 W ?46,$J(BAR("LTOT","ADBT"),6)
 W ?55,$J(BAR("LTOT","UNALC"),6)
 W ?64,$J(BAR("LTOT","RFND"),6)
 W ?73,$J(BAR("LTOT","MSG"),6)
 K BAR("LTOT")
 Q
TOT ;
 Q:'$D(BAR("TOT"))
 W !!!,"ALL LOCATIONS GRAND TOTAL"
 S BAR("A")=""
 F  S BAR("A")=$O(BAR("LBTOT",BAR("A"))) Q:($G(BAR("A"))="")  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W " GRAND TOTAL (cont)"
 .W !?3,$E(BAR("A"),1,25)
 .W ?28,$J(BAR("LBTOT",BAR("A"),"PYMT"),6)
 .W ?37,$J(BAR("LBTOT",BAR("A"),"ACRDT"),6)
 .W ?46,$J(BAR("LBTOT",BAR("A"),"ADBT"),6)
 .W ?55,$J(BAR("LBTOT",BAR("A"),"UNALC"),6)
 .W ?64,$J(BAR("LBTOT",BAR("A"),"RFND"),6)
 .W ?73,$J(BAR("LBTOT",BAR("A"),"MSG"),6)
 ;
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 W !?28,"======",?37,"======",?46,"======",?55,"======",?64,"======",?73,"======"
 W !,"ALL LOCATIONS totals:"
 W ?28,$J(BAR("TOT","PYMT"),6)
 W ?37,$J(BAR("TOT","ACRDT"),6)
 W ?46,$J(BAR("TOT","ADBT"),6)
 W ?55,$J(BAR("TOT","UNALC"),6)
 W ?64,$J(BAR("TOT","RFND"),6)
 W ?73,$J(BAR("TOT","MSG"),6)
 Q
 ;
XIT ;EXIT POINT
 W !!,"<END OF REPORT>"
 D PAZ^BARRUTL
 Q
