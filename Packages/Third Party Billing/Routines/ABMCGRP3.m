ABMCGRP3 ; IHS/SD/SDR - Claim Generator Report
 ;;2.6;IHS Third Party Billing;**35,40**;NOV 12, 2009;Build 785
 ;IHS/SD/SDR 2.6*35 ADO60700 New report - delimited detailed output
 ;IHS/SD/SDR 2.6*40 ADO85530 Report visits w/o Loc. Of Encounter
PRINT ;
 U IO W !!,"Hold on please, I'm writing the report..."
 D OPEN^%ZISH("ABMF",ABMY("RPATH"),ABMY("RFN"),"W")
 Q:POP
 U IO
 D HDB
 S ABMCGI=0
 F  S ABMCGI=$O(^TMP("ABM-CGRPT",$J,"D",ABMCGI)) Q:'ABMCGI  D
 .;S ABMVLOC=0  ;abm*2.6*40 IHS/SD/SDR ADO85530
 .S ABMVLOC=""  ;abm*2.6*40 IHS/SD/SDR ADO85530
 .;F  S ABMVLOC=$O(^TMP("ABM-CGRPT",$J,"D",ABMCGI,ABMVLOC)) Q:'ABMVLOC  D  ;abm*2.6*40 IHS/SD/SDR ADO85530
 .F  S ABMVLOC=$O(^TMP("ABM-CGRPT",$J,"D",ABMCGI,ABMVLOC)) Q:(ABMVLOC="")  D  ;abm*2.6*40 IHS/SD/SDR ADO85530
 ..S ABMOPT=""
 ..F  S ABMOPT=$O(^TMP("ABM-CGRPT",$J,"D",ABMCGI,ABMVLOC,ABMOPT)) Q:$G(ABMOPT)=""  D
 ...S ABMVDFN=0
 ...F  S ABMVDFN=$O(^TMP("ABM-CGRPT",$J,"D",ABMCGI,ABMVLOC,ABMOPT,ABMVDFN)) Q:'ABMVDFN  D
 ....S ABMREC=$$BDT^ABMDUTL($P($G(^ABMCGAUD(ABMCGI,0)),U))
 ....;S ABMREC=ABMREC_U_ABMVLOC_"-"_$P($G(^AUTTLOC(ABMVLOC,0)),U,2)  ;Visit Location IEN and short name  ;abm*2.6*40 IHS/SD/SDR ADO85530
 ....S ABMREC=ABMREC_U_+ABMVLOC_"-"_$S(+ABMVLOC'=0:$P($G(^AUTTLOC(ABMVLOC,0)),U,2),1:"NONE")  ;Visit Location IEN and short name  ;abm*2.6*40 IHS/SD/SDR ADO85530
 ....S ABMREC=ABMREC_U_ABMOPT
 ....S ABMREC=ABMREC_U
 ....I +$P($G(^ABMCGAUD(ABMCGI,0)),U,3)'=0 S ABMREC=ABMREC_$P($G(^VA(200,$P($G(^ABMCGAUD(ABMCGI,0)),U,3),0)),U)  ;person who ran option
 ....S ABMREC=ABMREC_U_ABMVDFN
 ....S ABMREC=ABMREC_U_$$BDT^ABMDUTL($P($G(^AUPNVSIT(ABMVDFN,0)),U))
 ....S ABMREC=ABMREC_U_$G(^TMP("ABM-CGRPT",$J,"D",ABMCGI,ABMVLOC,ABMOPT,ABMVDFN))
 ....W !,ABMREC
 W !,"END OF REPORT"
 ;
XIT ;
 D CLOSE^%ZISH("ABMF")
 D PAZ^ABMDRUTL
 Q
 ;
HDB ;
 S ABM("PG")=ABM("PG")+1
 D WHD^ABMCGRP1
 W !,"CG Run Date^Visit Location^Type^Who Ran Option^Visit IEN^Visit Date/Time^Patient^HRN^BKMG'd Visit^Rechecked Visit^Hospital Location^Clinic^Service Category^Claim Status (THIRD PARTY BILLED)^Claims^Active Insurer"
 W "^Primary Provider^DXs^Review/Chart Audit Status Date^Review/Chart Audit Status"
 Q
