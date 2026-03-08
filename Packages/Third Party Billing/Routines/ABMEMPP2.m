ABMEMPP2 ; IHS/SD/SDR - Employee Productivity Report-Summary ;
 ;;2.6;IHS 3P BILLING SYSTEM;**32**;NOV 12, 2009;Build 621
 ;Original;SDR;
 ;IHS/SD/SDR 2.6*32 CR11501 New report
 ;
PRINT ;EP for writing data
 I ABMPRINT="H" D  ;HFS file
 .D OPEN^%ZISH("ABM",ABMPATH,ABMFN,"W")
 .Q:POP
 .U IO
 ;
 S ABM("PG")=0 D HDB
 ;
 I '$D(^TMP("ABM-EMPR",$J,"SUM")) D  Q  ;no data to report
 .U IO W !!,"NO DATA EXISTS"
 .D CLOSE^%ZISH("ABM")
 ;
 S (ABM("LTOT"),ABM("CNT2"),ABM("CNT"),ABM("TOT1"),ABM("TOT2"),ABM("TOT"))=0
 S (ABM("TXT"),ABM("APPR"),ABM("EXP"),ABM("XCLM"),ABM("XBILL"),ABM("PEND"),ABM("OPEN"),ABM("CLOS"))=""
 S ABM("L")=""
 S ABMFIRST=0
 F  S ABM("L")=$O(^TMP("ABM-EMPR",$J,"SUM",ABM("L"))) Q:ABM("L")=""  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .S ABMFIRST=1
 .D SUBHD
 .S ABM("A")=""
 .F  S ABM("A")=$O(^TMP("ABM-EMPR",$J,"SUM",ABM("L"),ABM("A"))) Q:($G(ABM("A"))="")  D  G:$D(DTOUT)!$D(DUOUT)!$D(DIROUT) XIT
 ..I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  D SUBHD W:(ABMPRINT="P") " (cont)"
 ..S ABM("TXT")=$G(^TMP("ABM-EMPR",$J,"SUM",ABM("L"),ABM("A")))
 ..S ABM("APPR")=+$P(ABM("TXT"),U)
 ..S ABM("EXP")=+$P(ABM("TXT"),U,2)
 ..S ABM("XCLM")=+$P(ABM("TXT"),U,3)
 ..S ABM("XBILL")=+$P(ABM("TXT"),U,4)
 ..S ABM("PEND")=+$P(ABM("TXT"),U,5)
 ..S ABM("OPEN")=+$P(ABM("TXT"),U,6)
 ..S ABM("CLOS")=+$P(ABM("TXT"),U,7)
 ..;
 ..I ABMPRINT="H" D
 ...W !,$P(ABM("L"),"+")
 ...W U_ABM("A")
 ...W:($G(ABMY("SORT"))'="") U_"SUMMARY"
 ...W U_$J(ABM("APPR"),6)
 ...W U_$J(ABM("EXP"),6)
 ...W U_$J(ABM("XCLM"),6)
 ...W U_$J(ABM("XBILL"),6)
 ...W U_$J(ABM("PEND"),6)
 ...W U_$J(ABM("OPEN"),6)
 ...W U_$J(ABM("CLOS"),6)
 ..;
 ..I ABMPRINT="P" D
 ...W !?3,$E(ABM("A"),1,25)
 ...W ?31,$J(ABM("APPR"),6)
 ...W ?38,$J(ABM("EXP"),6)
 ...W ?45,$J(ABM("XCLM"),6)
 ...W ?52,$J(ABM("XBILL"),6)
 ...W ?59,$J(ABM("PEND"),6)
 ...W ?66,$J(ABM("OPEN"),6)
 ...W ?73,$J(ABM("CLOS"),6)
 ..;
 ..;location totals (subtotals)
 ..S ABM("LTOT","APPR")=+$G(ABM("LTOT","APPR"))+ABM("APPR")
 ..S ABM("LTOT","EXP")=+$G(ABM("LTOT","EXP"))+ABM("EXP")
 ..S ABM("LTOT","XCLM")=+$G(ABM("LTOT","XCLM"))+ABM("XCLM")
 ..S ABM("LTOT","XBILL")=+$G(ABM("LTOT","XBILL"))+ABM("XBILL")
 ..S ABM("LTOT","PEND")=+$G(ABM("LTOT","PEND"))+ABM("PEND")
 ..S ABM("LTOT","OPEN")=+$G(ABM("LTOT","OPEN"))+ABM("OPEN")
 ..S ABM("LTOT","CLOS")=+$G(ABM("LTOT","CLOS"))+ABM("CLOS")
 ..;
 ..;biller totals for all locations
 ..S ABM("LBTOT",ABM("A"),"APPR")=+$G(ABM("LBTOT",ABM("A"),"APPR"))+ABM("APPR")
 ..S ABM("LBTOT",ABM("A"),"EXP")=+$G(ABM("LBTOT",ABM("A"),"EXP"))+ABM("EXP")
 ..S ABM("LBTOT",ABM("A"),"XCLM")=+$G(ABM("LBTOT",ABM("A"),"XCLM"))+ABM("XCLM")
 ..S ABM("LBTOT",ABM("A"),"XBILL")=+$G(ABM("LBTOT",ABM("A"),"XBILL"))+ABM("XBILL")
 ..S ABM("LBTOT",ABM("A"),"PEND")=+$G(ABM("LBTOT",ABM("A"),"PEND"))+ABM("PEND")
 ..S ABM("LBTOT",ABM("A"),"OPEN")=+$G(ABM("LBTOT",ABM("A"),"OPEN"))+ABM("OPEN")
 ..S ABM("LBTOT",ABM("A"),"CLOS")=+$G(ABM("LBTOT",ABM("A"),"CLOS"))+ABM("CLOS")
 ..;
 ..;report totals
 ..S ABM("TOT","APPR")=+$G(ABM("TOT","APPR"))+ABM("APPR")
 ..S ABM("TOT","EXP")=+$G(ABM("TOT","EXP"))+ABM("EXP")
 ..S ABM("TOT","XCLM")=+$G(ABM("TOT","XCLM"))+ABM("XCLM")
 ..S ABM("TOT","XBILL")=+$G(ABM("TOT","XBILL"))+ABM("XBILL")
 ..S ABM("TOT","PEND")=+$G(ABM("TOT","PEND"))+ABM("PEND")
 ..S ABM("TOT","OPEN")=+$G(ABM("TOT","OPEN"))+ABM("OPEN")
 ..S ABM("TOT","CLOS")=+$G(ABM("TOT","CLOS"))+ABM("CLOS")
 ..;
 ..;this next section is if they selected visit type or clinc as a sort
 ..S ABM("S")=""
 ..F  S ABM("S")=$O(^TMP("ABM-EMPR",$J,"SUMSRT",ABM("L"),ABM("A"),ABM("S"))) Q:'ABM("S")  D  G:$D(DTOUT)!$D(DUOUT)!$D(DIROUT) XIT
 ...I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W:(ABMPRINT="P") " (cont)"
 ...S ABM("TXT")=$G(^TMP("ABM-EMPR",$J,"SUMSRT",ABM("L"),ABM("A"),ABM("S")))
 ...S ABM("APPR")=+$P(ABM("TXT"),U)
 ...S ABM("EXP")=+$P(ABM("TXT"),U,2)
 ...S ABM("XCLM")=+$P(ABM("TXT"),U,3)
 ...S ABM("XBILL")=+$P(ABM("TXT"),U,4)
 ...S ABM("PEND")=+$P(ABM("TXT"),U,5)
 ...S ABM("OPEN")=+$P(ABM("TXT"),U,6)
 ...S ABM("CLOS")=+$P(ABM("TXT"),U,7)
 ...;
 ...I ABMPRINT="P" D
 ....W !?5,$E($S(ABMY("SORT")="V":ABM("S")_"-"_$P($G(^ABMDVTYP(ABM("S"),0)),U),1:ABM("S")_"-"_$P($G(^DIC(40.7,ABM("S"),0)),U)),1,24)
 ....W ?31,$J(ABM("APPR"),6)
 ....W ?38,$J(ABM("EXP"),6)
 ....W ?45,$J(ABM("XCLM"),6)
 ....W ?52,$J(ABM("XBILL"),6)
 ....W ?59,$J(ABM("PEND"),6)
 ....W ?66,$J(ABM("OPEN"),6)
 ....W ?73,$J(ABM("CLOS"),6)
 ...;
 ...I ABMPRINT="H" D
 ....W !,$P(ABM("L"),"+")
 ....W U_ABM("A")
 ....W U_$S(ABMY("SORT")="V":ABM("S")_"-"_$P($G(^ABMDVTYP(ABM("S"),0)),U),1:ABM("S")_"-"_$P($G(^DIC(40.7,ABM("S"),0)),U))
 ....W U_$J(ABM("APPR"),6)
 ....W U_$J(ABM("EXP"),6)
 ....W U_$J(ABM("XCLM"),6)
 ....W U_$J(ABM("XBILL"),6)
 ....W U_$J(ABM("PEND"),6)
 ....W U_$J(ABM("OPEN"),6)
 ....W U_$J(ABM("CLOS"),6)
 .;
 .D SUBT
 ;
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 D TOT
 ;
 I ABMPRINT="H" D CLOSE^%ZISH("ABM")
 Q
 ;
HD ;
 Q:(ABMPRINT="H")&(+$G(ABM("PG"))>1)
 D PAZ^ABMDRUTL I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) S ABM("F1")=1 Q
HDB ;
 Q:(ABMPRINT="H")&(+$G(ABM("PG"))>1)
 S ABM("PG")=ABM("PG")+1 D WHD^ABMDRHD
 I ABMPRINT="P" D
 .W !?32,"APPRV",?38,"EXPORT",?45,"CXL'D",?52,"CXL'D",?60,"PEND",?67,"OPEN",?73,"CLOSE"
 .W !?3,"BILLING TECHNICIAN"
 .W ?32,"BILLS",?38,"BILLS",?45,"CLAIMS",?52,"BILLS",?59,"CLAIMS",?66,"CLAIMS",?73,"CLAIMS"
 .S $P(ABM("LINE"),"-",80)="" W !,ABM("LINE") K ABM("LINE")
 I ABMPRINT="H" D
 .W !,"Location^Billing Technician^"_$S($G(ABMY("SORT"))="V":"Visit Type^",$G(ABMY("SORT"))="C":"Clinic^",1:"")_"Approved Bills^Exported Bills^Cancelled Claims^Cancelled Bills^Pending Claims^Open Claims^Closed Claims"
 Q
SUBHD ;EP
 Q:ABMPRINT="H"
 W !!,$P(ABM("L"),"+")
 Q
SUBT ;
 Q:'$D(ABM("LTOT"))
 Q:ABMPRINT="H"
 W !?31,"------",?38,"------",?45,"------",?52,"------",?59,"------",?66,"------",?73,"------"
 W !,$E($P(ABM("L"),"+"),1,21)_" totals:"
 W ?31,$J(ABM("LTOT","APPR"),6)
 W ?38,$J(ABM("LTOT","EXP"),6)
 W ?45,$J(ABM("LTOT","XCLM"),6)
 W ?52,$J(ABM("LTOT","XBILL"),6)
 W ?59,$J(ABM("LTOT","PEND"),6)
 W ?66,$J(ABM("LTOT","OPEN"),6)
 W ?73,$J(ABM("LTOT","CLOS"),6)
 K ABM("LTOT")
 Q
TOT ;
 Q:'$D(ABM("TOT"))
 Q:ABMPRINT="H"
 W !!!,"ALL LOCATIONS GRAND TOTAL"
 S ABM("A")=""
 F  S ABM("A")=$O(ABM("LBTOT",ABM("A"))) Q:($G(ABM("A"))="")  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W:(ABMPRINT="P") " GRAND TOTAL (cont)"
 .W !?3,$E(ABM("A"),1,25)
 .W ?31,$J(ABM("LBTOT",ABM("A"),"APPR"),6)
 .W ?38,$J(ABM("LBTOT",ABM("A"),"EXP"),6)
 .W ?45,$J(ABM("LBTOT",ABM("A"),"XCLM"),6)
 .W ?52,$J(ABM("LBTOT",ABM("A"),"XBILL"),6)
 .W ?59,$J(ABM("LBTOT",ABM("A"),"PEND"),6)
 .W ?66,$J(ABM("LBTOT",ABM("A"),"OPEN"),6)
 .W ?73,$J(ABM("LBTOT",ABM("A"),"CLOS"),6)
 ;
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 W !?31,"======",?38,"======",?45,"======",?52,"======",?59,"======",?66,"======",?73,"======"
 W !,"ALL LOCATIONS totals:"
 W ?31,$J(ABM("TOT","APPR"),6)
 W ?38,$J(ABM("TOT","EXP"),6)
 W ?45,$J(ABM("TOT","XCLM"),6)
 W ?52,$J(ABM("TOT","XBILL"),6)
 W ?59,$J(ABM("TOT","PEND"),6)
 W ?66,$J(ABM("TOT","OPEN"),6)
 W ?73,$J(ABM("TOT","CLOS"),6)
 Q
 ;
XIT ;EXIT POINT
 Q
