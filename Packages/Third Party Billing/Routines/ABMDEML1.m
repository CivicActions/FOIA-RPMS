ABMDEML1 ; IHS/SD/SDR - Edit Utility - FOR MULTIPLES ;   
 ;;2.6;IHS Third Party Billing;**1,2,3,6,8,9,10,11,13,14,18,21,23,27,28,29,31**;NOV 12, 2009;Build 615
 ;IHS/SD/SDR 2.6*31 CR10857 Split from ABMDEML due to routine size
 ;IHS/SD/SDR 2.6*31 CR11624 Fix for <SUBSCR>VLTCP+8^ICPTCOD when there are two entries in CPT file for one CPT
 ; *********************************
CAT(X) ;
 S ABMX("Y")=X
 S ABMX("DIC")=$S($E(ABMZ("DIC"),3,5)="CPT":ABMZ("CAT"),$E(ABMZ("DIC"),6,8)="ADA":21,1:31)
 I ABMX("DIC")=31 S Y=$E(Y,1,2)_"0"
 I $G(ABMZ("CAT"))=13 D
 .S ABMX("TST")=$P($G(^ICPT(ABMX("Y"),0)),U)
 .S ABMTF=0
 .F ABMT=1:1:($L(ABMX("TST"))) D  ;if there's an alpha char involved leave category as 13 for HCPCS
 ..I $A($E(ABMX("TST"),ABMT))>64 S ABMTF=1
 .I ABMTF=1 Q
 .;start old abm*2.6*31 IHS/SD/SDR CR10857
 .;S ABMX("Y")=ABMX("TST")
 .;I ABMX("Y")<2000 S ABMX("DIC")=23 Q
 .;I ABMX("Y")<70000 S ABMX("DIC")=11 Q
 .;I ABMX("Y")<80000 S ABMX("DIC")=15 Q
 .;I ABMX("Y")<90000 S ABMX("DIC")=17 Q
 .;I ABMX("Y")<100000 S ABMX("DIC")=19 Q
 .;end old start new abm*2.6*31 IHS/SD/SDR CR10857
 .I ABMX("TST")<2000 S ABMX("DIC")=23 Q
 .I ABMX("TST")<70000 S ABMX("DIC")=11 Q
 .I ABMX("TST")<80000 S ABMX("DIC")=15 Q
 .I ABMX("TST")<90000 S ABMX("DIC")=17 Q
 .I ABMX("TST")<100000 S ABMX("DIC")=19 Q
 ;end new abm*2.6*31 IHS/SD/SDR CR10857
 Q
