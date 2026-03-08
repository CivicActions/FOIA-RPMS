ABMEMPP1 ; IHS/SD/SDR - Employee Productivity Report - Detail ; 
 ;;2.6;IHS 3P BILLING SYSTEM;**32**;NOV 12, 2009;Build 621
 ;Original;SDR;
 ;IHS/SD/SDR 2.6*32 CR11501 New report
 ;
PRINT ;EP for writing data
 ;
 I ABMPRINT="H" D  ;HFS file
 .D OPEN^%ZISH("ABM",ABMPATH,ABMFN,"W")
 .Q:POP
 .U IO
 ;
 S ABM("PG")=0 D HDB
 ;
 I '$D(^TMP("ABM-EMPR",$J,"DET")) D  Q  ;no data to report
 .U IO W !!,"NO DATA EXISTS"
 .D CLOSE^%ZISH("ABM")
 ;
 S (ABM("LTOT"),ABM("CNT2"),ABM("CNT"),ABM("TOT1"),ABM("TOT2"),ABM("TOT"))=0
 S (ABM("TXT"),ABM("APPR"),ABM("EXP"),ABM("XCLM"),ABM("XBILL"),ABM("PEND"),ABM("OPEN"),ABM("CLOS"))=""
 S ABM("A")=""
 S ABMFIRST=0
 F  S ABM("A")=$O(^TMP("ABM-EMPR",$J,"DET",ABM("A"))) Q:($G(ABM("A"))="")  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .S ABM("STXT")=$G(^TMP("ABM-EMPR",$J,"DETHDR",ABM("A")))
 .S ABM("APPR")=+$P(ABM("STXT"),U)
 .S ABM("EXP")=+$P(ABM("STXT"),U,2)
 .S ABM("XCLM")=+$P(ABM("STXT"),U,3)
 .S ABM("XBILL")=+$P(ABM("STXT"),U,4)
 .S ABM("PEND")=+$P(ABM("STXT"),U,5)
 .S ABM("OPEN")=+$P(ABM("STXT"),U,6)
 .S ABM("CLOS")=+$P(ABM("STXT"),U,7)
 .I ABMPRINT="P" D  ;printer, not delimited
 ..W !!?3,$E(ABM("A"),1,25)
 ..W ?31,$J(ABM("APPR"),6)
 ..W ?38,$J(ABM("EXP"),6)
 ..W ?45,$J(ABM("XCLM"),6)
 ..W ?52,$J(ABM("XBILL"),6)
 ..W ?59,$J(ABM("PEND"),6)
 ..W ?66,$J(ABM("OPEN"),6)
 ..W ?73,$J(ABM("CLOS"),6)
 ..W !!,ABM("A")
 .;
 .S ABM("ADT")=0
 .F  S ABM("ADT")=$O(^TMP("ABM-EMPR",$J,"DET",ABM("A"),ABM("ADT"))) Q:'ABM("ADT")  D  G:$D(DTOUT)!$D(DUOUT)!$D(DIROUT) XIT
 ..I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  D SUBHD W:(ABMPRINT="P") " (cont)"
 ..S ABM("L")=""
 ..F  S ABM("L")=$O(^TMP("ABM-EMPR",$J,"DET",ABM("A"),ABM("ADT"),ABM("L"))) Q:ABM("L")=""  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ...;
 ...S ABM("TXT")=$G(^TMP("ABM-EMPR",$J,"DET",ABM("A"),ABM("ADT"),ABM("L")))
 ...S ABM("APPR")=+$P(ABM("TXT"),U)
 ...S ABM("EXP")=+$P(ABM("TXT"),U,2)
 ...S ABM("XCLM")=+$P(ABM("TXT"),U,3)
 ...S ABM("XBILL")=+$P(ABM("TXT"),U,4)
 ...S ABM("PEND")=+$P(ABM("TXT"),U,5)
 ...S ABM("OPEN")=+$P(ABM("TXT"),U,6)
 ...S ABM("CLOS")=+$P(ABM("TXT"),U,7)
 ...;
 ...I ABMPRINT="P" D  ;printer
 ....W !?2,$S(ABM("ADT")'=2007:$$SDT^ABMDUTL(ABM("ADT")),1:"<no date>")
 ....W ?14,$P($G(^AUTTLOC($P(ABM("L"),"+",2),0)),U,7)
 ....W ?31,$J(ABM("APPR"),6)
 ....W ?38,$J(ABM("EXP"),6)
 ....W ?45,$J(ABM("XCLM"),6)
 ....W ?52,$J(ABM("XBILL"),6)
 ....W ?59,$J(ABM("PEND"),6)
 ....W ?66,$J(ABM("OPEN"),6)
 ....W ?73,$J(ABM("CLOS"),6)
 ...;
 ...I ABMPRINT="H" D  ;HFS
 ....W !,ABM("A")
 ....W U_$P($G(^AUTTLOC($P(ABM("L"),"+",2),0)),U,7)
 ....W U_$S(ABM("ADT")'=2007:$$SDT^ABMDUTL(ABM("ADT")),1:"<no date>")
 ....W:($G(ABMY("SORT"))'="") U_"SUMMARY"
 ....W U_$J(ABM("APPR"),6)
 ....W U_$J(ABM("EXP"),6)
 ....W U_$J(ABM("XCLM"),6)
 ....W U_$J(ABM("XBILL"),6)
 ....W U_$J(ABM("PEND"),6)
 ....W U_$J(ABM("OPEN"),6)
 ....W U_$J(ABM("CLOS"),6)
 ...;
 ...S ABM("LTOT","APPR")=+$G(ABM("LTOT","APPR"))+ABM("APPR")
 ...S ABM("LTOT","EXP")=+$G(ABM("LTOT","EXP"))+ABM("EXP")
 ...S ABM("LTOT","XCLM")=+$G(ABM("LTOT","XCLM"))+ABM("XCLM")
 ...S ABM("LTOT","XBILL")=+$G(ABM("LTOT","XBILL"))+ABM("XBILL")
 ...S ABM("LTOT","PEND")=+$G(ABM("LTOT","PEND"))+ABM("PEND")
 ...S ABM("LTOT","OPEN")=+$G(ABM("LTOT","OPEN"))+ABM("OPEN")
 ...S ABM("LTOT","CLOS")=+$G(ABM("LTOT","CLOS"))+ABM("CLOS")
 ...;
 ...;this next section is if they selected visit type or clinc as a sort
 ...S ABM("S")=""
 ...F  S ABM("S")=$O(^TMP("ABM-EMPR",$J,"DETSRT",ABM("A"),ABM("ADT"),ABM("L"),ABM("S"))) Q:'ABM("S")  D  G:$D(DTOUT)!$D(DUOUT)!$D(DIROUT) XIT
 ....I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W:(ABMPRINT="P") " (cont)"
 ....S ABM("TXT")=$G(^TMP("ABM-EMPR",$J,"DETSRT",ABM("A"),ABM("ADT"),ABM("L"),ABM("S")))
 ....S ABM("APPR")=+$P(ABM("TXT"),U)
 ....S ABM("EXP")=+$P(ABM("TXT"),U,2)
 ....S ABM("XCLM")=+$P(ABM("TXT"),U,3)
 ....S ABM("XBILL")=+$P(ABM("TXT"),U,4)
 ....S ABM("PEND")=+$P(ABM("TXT"),U,5)
 ....S ABM("OPEN")=+$P(ABM("TXT"),U,6)
 ....S ABM("CLOS")=+$P(ABM("TXT"),U,7)
 ....;
 ....I ABMPRINT="P" D
 .....W !?4,$E($S(ABMY("SORT")="V":ABM("S")_"-"_$P($G(^ABMDVTYP(ABM("S"),0)),U),1:ABM("S")_"-"_$P($G(^DIC(40.7,ABM("S"),0)),U)),1,22)
 .....W ?31,$J(ABM("APPR"),6)
 .....W ?38,$J(ABM("EXP"),6)
 .....W ?45,$J(ABM("XCLM"),6)
 .....W ?52,$J(ABM("XBILL"),6)
 .....W ?59,$J(ABM("PEND"),6)
 .....W ?66,$J(ABM("OPEN"),6)
 .....W ?73,$J(ABM("CLOS"),6)
 ....;
 ....I ABMPRINT="H" D
 .....W !,ABM("A")
 .....W U_$P($G(^AUTTLOC($P(ABM("L"),"+",2),0)),U,7)
 .....W U_$S(ABM("ADT")'=2007:$$SDT^ABMDUTL(ABM("ADT")),1:"<no date>")
 .....W U_$S(ABMY("SORT")="V":ABM("S")_"-"_$P($G(^ABMDVTYP(ABM("S"),0)),U),1:ABM("S")_"-"_$P($G(^DIC(40.7,ABM("S"),0)),U))
 .....W U_$J(ABM("APPR"),6)
 .....W U_$J(ABM("EXP"),6)
 .....W U_$J(ABM("XCLM"),6)
 .....W U_$J(ABM("XBILL"),6)
 .....W U_$J(ABM("PEND"),6)
 .....W U_$J(ABM("OPEN"),6)
 .....W U_$J(ABM("CLOS"),6)
 ...;
 ...I (ABMPRINT="P"),($O(^TMP("ABM-EMPR",$J,"DETSRT",ABM("A"),ABM("ADT"),ABM("L"),""))'="") W !
 ; 
 I ABMPRINT="H" D CLOSE^%ZISH("ABM")
 Q
 ;
HD ;
 Q:(ABMPRINT="H")&(+$G(ABM("PG"))>1)
 D PAZ^ABMDRUTL I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) S ABM("F1")=1 Q
HDB ;
 Q:(ABMPRINT="H")&(+$G(ABM("PG"))>0)
 S ABM("PG")=+$G(ABM("PG"))+1 D WHD^ABMDRHD
 I ABMPRINT="P" D
 .W !?32,"APPRV",?38,"EXPORT",?45,"CXL'D",?52,"CXL'D",?60,"PEND",?67,"OPEN",?73,"CLOSE"
 .W !?3,"BILLING TECHNICIAN"
 .W ?32,"BILLS",?38,"BILLS",?45,"CLAIMS",?52,"BILLS",?59,"CLAIMS",?66,"CLAIMS",?73,"CLAIMS"
 .S $P(ABM("LINE"),"-",80)="" W !,ABM("LINE") K ABM("LINE")
 I ABMPRINT="H" D
 .W !,"Billing Technician^Location^Activity Date^"_$S($G(ABMY("SORT"))="V":"Visit Type^",$G(ABMY("SORT"))="C":"Clinic^",1:"")_"Approved Bills^Exported Bills^Cancelled Claims^Cancelled Bills^Pending Claims^Open Claims^Closed Claims"
 Q
SUBHD ;EP
 Q:(ABMPRINT="H")
 W !!,ABM("A")
 Q
XIT ;EXIT POINT
 Q
