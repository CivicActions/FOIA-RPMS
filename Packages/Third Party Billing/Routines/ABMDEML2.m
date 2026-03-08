ABMDEML2 ; IHS/SD/SDR - Edit Utility - FOR MULTIPLES ;   
 ;;2.6;IHS Third Party Billing;**1,2,3,6,8,9,10,11,13,14,18,21,23,27,28,32**;NOV 12, 2009;Build 621
 ;
 ;IHS/SD/SDR 2.6*28 split from routine ABMDEML due to size
 ;IHS/SD/SDR 2.6*32 CR8942 Smartened up revenue code check and moved it here; if new code it should check CPT file for default,
 ;  then use page default; if editing an existing entry it should put what is in the field first, and then do the other two
 ;  checks should it be blank (like editing a CPT after the exp mode was changed)
 ;
39 ;EP - dr string for anesthesia page
 S ABMZ("DR")=ABMZ("DR")_";.07:.08"  ;abm*2.6*1 HEAT6566  ;IHS/SD/AML 7/20/2012 HEAT76189 - REMOVE DUPLICATE POS FIELD
 Q
MILEAGE ;
 ;I (ABMZ("SUB")=47)!(ABMZ("SUB")=43),"A0888^A0425"[$P($$CPT^ABMCVAPI(ABMX("Y"),ABMP("VDT")),U,2) D  ;CSV-c  ;abm*2.6*10
 I (ABMZ("SUB")=47)!(ABMZ("SUB")=43),"^A0888^A0425^"[("^"_$P($$CPT^ABMCVAPI(ABMX("Y"),ABMP("VDT")),U,2)_"^") D  ;CSV-c  ;abm*2.6*10
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DA=ABMP("CDFN")
 .S ABMIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),"B",ABMX("Y"),0))
 .Q:+ABMIEN=0  ;abm*2.6*11 HEAT88601
 .I $P($$CPT^ABMCVAPI(ABMX("Y"),ABMP("VDT")),U,2)="A0425" S DR=".128////"_$S(+$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,8)=0:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMIEN,0)),U,3),1:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,8))  ;CSV-c
 .I $P($$CPT^ABMCVAPI(ABMX("Y"),ABMP("VDT")),U,2)="A0888" S DR=".129////"_$S(+$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,9)=0:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMIEN,0)),U,3),1:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,9))  ;CSV-c
 .D ^DIE
 Q
 ;start new abm*2.6*32 IHS/SD/SDR CR8942
REVN ;EP
 S ABMT("REV")=""
 ;first check if there's a rev code already on the line and use it
 I "^23^27^33^35^37^39^43^47^"[("^"_ABMZ("SUB")_"^") D
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMZIEN,0)),U,2)'="" S ABMT("REV")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMZIEN,0)),U,2)
 I ABMZ("SUB")=21 D
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMZIEN,0)),U,3)'="" S ABMT("REV")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),ABMZIEN,0)),U,3)
 ;
 ;if there's not, get the CPT DEFAULT REVENUE CODE
 I ABMT("REV")="" D
 .;change to IHSCPT^ABMCVAPI P3
 .I +$P($$IHSCPT^ABMCVAPI(ABMZIEN,ABMP("VDT")),U,3)'=0 S ABMT("REV")=+$P($$IHSCPT^ABMCVAPI(ABMZIEN,ABMP("VDT")),U,3)
 ;
 ;default to page rev code
 I ABMT("REV")="" S ABMT("REV")=$P(ABMZ("REVN"),"//",2)  ;default page rev code
 ;
 S ABMZ("DR")=ABMZ("DR")_$P(ABMZ("REVN"),"//")_"//"_ABMT("REV")
 Q
 ;end new abm*2.6*32 IHS/SD/SDR CR8942
