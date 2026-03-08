ABMEMPP3 ; IHS/SD/SDR - Employee Productivity Report - Validator ;
 ;;2.6;IHS 3P BILLING SYSTEM;**32**;NOV 12, 2009;Build 621
 ;Original;SDR;
 ;IHS/SD/SDR 2.6*32 CR11501 New report
 ;
PRINT ;EP for writing data
 D OPEN^%ZISH("ABM",ABMPATH,ABMFN,"W")
 Q:POP
 U IO
 D HDB
 ;
 I '$D(^TMP("ABM-EMPR",$J,"VAL")) D  Q  ;no data to report
 .U IO W !!,"NO DATA EXISTS"
 .D CLOSE^%ZISH("ABM")
 ;
 S ABM("L")=""
 F  S ABM("L")=$O(^TMP("ABM-EMPR",$J,"VAL",ABM("L"))) Q:ABM("L")=""  D
 .S ABM("A")=""
 .F  S ABM("A")=$O(^TMP("ABM-EMPR",$J,"VAL",ABM("L"),ABM("A"))) Q:($G(ABM("A"))="")  D
 ..S ABM("ADT")=0
 ..F  S ABM("ADT")=$O(^TMP("ABM-EMPR",$J,"VAL",ABM("L"),ABM("A"),ABM("ADT"))) Q:'ABM("ADT")  D
 ...S ABM=""
 ...F  S ABM=$O(^TMP("ABM-EMPR",$J,"VAL",ABM("L"),ABM("A"),ABM("ADT"),ABM)) Q:$G(ABM)=""  D
 ....S ABMREC=""
 ....F  S ABMREC=$O(^TMP("ABM-EMPR",$J,"VAL",ABM("L"),ABM("A"),ABM("ADT"),ABM,ABMREC)) Q:$G(ABMREC)=""  D
 .....S ABM("LO")=$P(ABM("L"),"+")
 .....S ABM("AO")=ABM("A")
 .....W !,ABM("LO")_U_ABM("AO")_U_$S(ABM("ADT")["1900":"<no date>",1:ABM("ADT"))_U_ABM_U_ABMREC
 D CLOSE^%ZISH("ABM")
 ;
 U IO(0) W !!,"REPORT COMPLETE",!
 S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 Q
HD ;
HDB S ABM("PG")=1 D WHD^ABMDRHD
 W !,"Location^Billing Technician^Activity Date^Claim/Bill Number^Visit Type^Clinic^Service Date^Active Insurer^Record Type^Amount Billed^Patient^Insurer Type^Eligibility Status"
 I $D(ABMY("PRV")) W "^Provider^Provider Type"
 I $D(ABMY("PX")) W "^CPT"
 I $D(ABMY("DX")) W "^DX"
 Q
XIT ;EXIT POINT
 Q
