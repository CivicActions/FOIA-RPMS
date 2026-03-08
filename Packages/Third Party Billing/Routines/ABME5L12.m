ABME5L12 ; IHS/SD/SDR - Header 
 ;;2.6;IHS Third Party Billing System;**6,8,9,10,11,22,23,25,28,29,32,33,37,40**;NOV 12, 2009;Build 785
 ;Header Segments
 ;IHS/SD/SDR 2.6*22 HEAT335246 check new parameter for itemized but with the flat rate on first line, zeros for the rest
 ;IHS/SD/AML 2.6*23 HEAT247169 if the subfile is 43 and there's a NDC print segments LIN and CTP for medication
 ;IHS/SD/SDR 2.6*25 CR10008 commented out code that writes purchased service provider loop; piece 19 of array is used for something else, and we don't
 ;   capture the purchased service provider at this time anyway.
 ;IHS/SD/SDR 2.6*28 CR10551 Added NDC for 25(rev) and 27 (medical); also but IMMUNIZATION LOT/BATCH NUMBER segments back in
 ;IHS/SD/SDR 2.6*29 CR10404 made check new field in 3P Insurer 4 multiple to require CLIA; stop REF*F4 from printing if no CLIA number to print
 ;IHS/SD/SDR 2.6*32 CR10210 Removed ALL INCLUSIVE PRINT NDC prompt
 ;IHS/SD/SDR 2.6*33 ADO60186 Added code for ordering provider DEA number if med is a controlled substance (determined in ABMERGR2)
 ;IHS/SD/SDR 2.6*37 ADO89299 Updated to use DEA# from service line (not ordering provider)
 ;IHS/SD/SDR 2.6*40 ADO108243 Removed hardcoding for OKLAHOMA MEDICAID to print date range for DTP*472. Switched to use
 ;   insurer/visit type parameter so any insurer can do it. Medi-Cal needed the same ability.
 ;
EP ;START HERE
 S ABMLXCNT=0
 K ABM
 D ^ABMEHGRV
 ;start old abm*2.6*32 IHS/SD/SDR CR10210
 ;S ABMITMZ=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),"^",12)  ;abm*2.6*22 IHS/SD/SDR HEAT335246
 ;I +ABMITMZ&($P($G(^ABMNINS(DUZ(2),ABMP("INS"),0)),U,14)="Y")&(+$G(ABMP("FLAT"))'=0) D START^ABMEHGR4  ;abm*2.6*22 IHS/SD/SDR HEAT335246
 ;end old abm*2.6*32 IHS/SD/SDR CR10210
 S ABMI=0
 F  S ABMI=$O(ABMRV(ABMI)) Q:'+ABMI  D
 .S ABMJ=-1
 .F  S ABMJ=$O(ABMRV(ABMI,ABMJ)) Q:'+ABMJ  D
 ..S ABMK=0
 ..F  S ABMK=$O(ABMRV(ABMI,ABMJ,ABMK)) Q:'+ABMK  D
 ...D LOOP
 K ABMI,ABMJ,ABMK
 Q
 ;
LOOP ;
 S ABMLXCNT=ABMLXCNT+1
 S ABMLOOP=2400
 D EP^ABME5LX
 D WR^ABMUTL8("LX")
 D EP^ABME5SV1
 D WR^ABMUTL8("SV1")
 I +$P(ABMRV(ABMI,ABMJ,ABMK),U,33) D
 .D EP^ABME5SV5
 .D WR^ABMUTL8("SV5")
 ;PWK segment goes here
 ;start old abm*2.6*40 IHS/SD/SDR ADO108243
 ;I $P(ABMRV(ABMI,ABMJ,ABMK),U,10) D
 ;.I $P(ABMRV(ABMI,ABMJ,ABMK),U,27)'="",($P($P(ABMRV(ABMI,ABMJ,ABMK),U,10),".")'=$P($P(ABMRV(ABMI,ABMJ,ABMK),U,27),".")) D EP^ABME5DTP(472,"RD8",$P(ABMRV(ABMI,ABMJ,ABMK),U,10),$P(ABMRV(ABMI,ABMJ,ABMK),U,27))
 ;.E  D EP^ABME5DTP(472,"D8",$P(ABMRV(ABMI,ABMJ,ABMK),U,10))
 ;I '$P(ABMRV(ABMI,ABMJ,ABMK),U,10) D
 ;.D EP^ABME5DTP(472,"D8",$P(ABMB7,U))
 ;end old start new abm*2.6*40 IHS/SD/SDR ADO108243
 I $P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),0)),U,16)="R" D
 .I $P(ABMRV(ABMI,ABMJ,ABMK),U,10) D
 ..D EP^ABME5DTP("472","RD8",$P(ABMRV(ABMI,ABMJ,ABMK),U,10),$S($P(ABMRV(ABMI,ABMJ,ABMK),U,27):$P(ABMRV(ABMI,ABMJ,ABMK),U,27),1:$P(ABMRV(ABMI,ABMJ,ABMK),U,10)))
 .I '$P(ABMRV(ABMI,ABMJ,ABMK),U,10) D
 ..D EP^ABME5DTP(472,"RD8",$P(ABMB7,U),$P(ABMB7,U,2))
 I $P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),0)),U,16)'="R" D
 .I $P(ABMRV(ABMI,ABMJ,ABMK),U,10) D
 ..D EP^ABME5DTP("472","D8",$P(ABMRV(ABMI,ABMJ,ABMK),U,10))
 .I '$P(ABMRV(ABMI,ABMJ,ABMK),U,10) D
 ..D EP^ABME5DTP(472,"D8",$P(ABMB7,U))
 ..;end new abm*2.6*40 IHS/SD/SDR ADO108243
 D WR^ABMUTL8("DTP")
 I $P(ABMRV(ABMI,ABMJ,ABMK),U,32)'="" D
 .D EP^ABME5DTP(471,"D8",$P(ABMRV(ABMI,ABMJ,ABMK),U,32))
 .D WR^ABMUTL8("DTP")
 I ABMI=37,$P(ABMRV(ABMI,ABMJ,ABMK),U,34)'="" D
 .D EP^ABME5DTP(738,"D8",$P(ABMRV(ABMI,ABMJ,ABMK),U,34))
 .D WR^ABMUTL8("DTP")
 I +$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,18)>1 D
 .D EP^ABME5QTY("PT")
 .D WR^ABMUTL8("QTY")
 I ABMI=37 D  ;lab multiple
 .Q:$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,ABMJ,0)),U,21)=""  ;no lab result
 .D ^ABME5MEA
 .D WR^ABMUTL8("MEA")
 ;D EP^ABME5REF("6R","")   ;line item control number  ;abm*2.6*11 HEAT92070
 ;D WR^ABMUTL8("REF")  ;abm*2.6*11 HEAT92070
 ;start new code abm*2.6*11 HEAT92070
 I $P($G(ABMRV(ABMI,ABMJ,ABMK)),U,38)'="" D
 .D EP^ABME5REF("6R","")
 .D WR^ABMUTL8("REF")   ;line item control number
 ;end new code HEAT92070
 ;start new code abm*2.6*8 HEAT31238
 ;mammography cert number
 ;I (($P(ABMRV(ABMI,ABMJ,ABMK),U,2)>77050)&($P(ABMRV(ABMI,ABMJ,ABMK),U,2)<77060)) D  ;abm*2.6*10 HEAT65066
 ;I (($P(ABMRV(ABMI,ABMJ,ABMK),U,2)>77050)&($P(ABMRV(ABMI,ABMJ,ABMK),U,2)<77060))!$P(ABMRV(ABMI,ABMJ,ABMK),U,2)=76083!($P(ABMRV(ABMI,ABMJ,ABMK),U,2)=76092)!($P(ABMRV(ABMI,ABMJ,ABMK),U,2)="G0202") D  ;abm*2.6*10 ;abm*2.6*11 IHS/SD/AML HEAT95824
 I (($P(ABMRV(ABMI,ABMJ,ABMK),U,2)>77050)&($P(ABMRV(ABMI,ABMJ,ABMK),U,2)<77060))!($P(ABMRV(ABMI,ABMJ,ABMK),U,2)=76083)!($P(ABMRV(ABMI,ABMJ,ABMK),U,2)=76092)!($P(ABMRV(ABMI,ABMJ,ABMK),U,2)="G0202") D  ;abm*2.6*11 IHS/SD/AML HEAT95824
 .Q:ABMP("CLIN")=72  ;don't write if clinic is mammography; cert# already written for claim
 .Q:$P($G(^ABMDPARM(ABMP("LDFN"),1,5)),U,4)=""  ;no cert#
 .D EP^ABME8REF("EW")
 .D WR^ABMUTL8("REF")
 ;end new code HEAT31238
 ;I (($P(ABMRV(ABMI,ABMJ,ABMK),U,2)>79999)&($P(ABMRV(ABMI,ABMJ,ABMK),U,2)<90000))!($E($P(ABMRV(ABMI,ABMJ,ABMK),U,2))="G0107") D  ;abm*2.6*8 HEAT40295
 ;I (($P(ABMRV(ABMI,ABMJ,ABMK),U,2)>79999)&($P(ABMRV(ABMI,ABMJ,ABMK),U,2)<90000))!($E($P(ABMRV(ABMI,ABMJ,ABMK),U,2))="G") D  ;abm*2.6*8 HEAT40295  ;abm*2.6*29 IHS/SD/SDR CR10404
 ;start new abm*2.6*29 IHS/SD/SDR CR10404
 S ABMP("CPTIEN")=+$$CPT^ABMCVAPI($P(ABMRV(ABMI,ABMJ,ABMK),U,2),ABMP("VDT"))
 S ABMP("CLIAREQ")=0
 D CLIANUM^ABMDEMLB(ABMP("CPTIEN"))
 I ($P(ABMRV(ABMI,ABMJ,ABMK),U,2)>79999&($P(ABMRV(ABMI,ABMJ,ABMK),U,2)<90000))!(ABMP("CLIAREQ")=1) D
 .;end new abm*2.6*29 IHS/SD/SDR CR10404
 .;Q:ABMI'=37  ;abm*2.6*10 HEAT73027  ;abm*2.6*29 IHS/SD/SDR CR10404
 .I ABMI'=37&(ABMI'=43) Q  ;abm*2.6*10 HEAT73027  ;abm*2.6*29 IHS/SD/SDR CR10404
 .;Q:($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),ABMI,ABMJ,0)),U,13)="")  ;abm*2.6*10 HEAT72789  ;abm*2.6*11 HEAT85498
 .S ABMCLIA="SV"
 .I $G(ABMOUTLB)'=1 D
 ..;I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),ABMI,ABMJ,0)),U,13)'="",($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),ABMI,ABMJ,0)),U,13)=($P($G(ABMB9),U,22))) Q  ;abm*2.6*8  ;abm*2.6*11 HEAT85498
 ..I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),ABMI,ABMJ,0)),U,13)="" Q  ;abm*2.6*11 HEAT85498
 ..I ($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),ABMI,ABMJ,0)),U,13)=($P($G(ABMB9),U,22))) Q  ;abm*2.6*11 HEAT85498
 ..D EP^ABME5REF("X4","1SV","1SV")
 ..Q:$G(ABMR("REF",30))=""  ;abm*2.6*9 HEAT64640
 ..D WR^ABMUTL8("REF")
 .I $G(ABMOUTLB)=1 D  ;if reference lab
 ..I ($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),ABMI,ABMJ,0)),U,14)="")&($P($G(ABMB9),U,23)="") Q  ;if both are blank skip segment  ;abm*2.6*29 CR10404
 ..;I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),ABMI,ABMJ,0)),U,14)'="",($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),ABMI,ABMJ,0)),U,14)=($P($G(ABMB9),U,23))) Q  ;abm*2.6*10 HEAT72789
 ..D EP^ABME5REF("F4",1,1)
 ..D WR^ABMUTL8("REF")
 ;D EP^ABME5REF("BT")  ;immunization batch number
 ;D WR^ABMUTL8("REF")
 ;start new abm*2.6*28 IHS/SD/SDR CR10551
 I $P($G(ABMRV(ABMI,ABMJ,ABMK)),U,37)'="" D
 .D EP^ABME5REF("BT")  ;immunization batch number
 .D WR^ABMUTL8("REF")
 ;end new abm*2.6*28 IHS/SD/SDR CR10551
 ;Loop 2410 - Drug Identification
 S ABMLOOP=2410
 I ABMI=23 D
 .I $P($P(ABMRV(ABMI,ABMJ,ABMK),U,9)," ")'="" D
 ..D EP^ABME5LIN
 ..D WR^ABMUTL8("LIN")
 .;I +$P(ABMRV(ABMI,ABMJ,ABMK),U,5)!($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),0)),U,14)="Y") D  ;abm*2.6*22 IHS/SD/SDR HEAT335246  ;abm*2.6*32 IHS/SD/SDR CR10210
 .I +$P(ABMRV(ABMI,ABMJ,ABMK),U,5) D  ;abm*2.6*22 IHS/SD/SDR HEAT335246  ;abm*2.6*32 IHS/SD/SDR CR10210
 ..D EP^ABME5CTP
 ..D WR^ABMUTL8("CTP")
 .;I $P(ABMRV(ABMI,ABMJ,ABMK),U,13)'="" D  ;abm*2.6*10 HEAT78446
 .I $P(ABMRV(ABMI,ABMJ,ABMK),U,28)'="" D  ;abm*2.6*10 HEAT78446
 ..;D EP^ABME5REF("XZ",$P(ABMRV(ABMI,ABMJ,ABMK),U,13))  ;abm*2.6*10 HEAT78446
 ..D EP^ABME5REF("XZ",$P(ABMRV(ABMI,ABMJ,ABMK),U,28))  ;abm*2.6*10 HEAT78446
 ..D WR^ABMUTL8("REF")
 ;start new abm*2.6*23 IHS/SD/AML HEAT247169
 ;add NDC for page 8H
 ;I ABMI=43 D  ;abm*2.6*28 IHS/SD/SDR CR10551
 I "^25^27^43^"[("^"_ABMI_"^") D  ;abm*2.6*28 IHS/SD/SDR CR10551
 .I $P(ABMRV(ABMI,ABMJ,ABMK),U,19)'="" D
 ..D EP^ABME5LIN
 ..D WR^ABMUTL8("LIN")
 ..D EP^ABME5CTP
 ..D WR^ABMUTL8("CTP")
 ;end new abm*2.6*23 IHS/SD/AML HEAT247169
 ;
 ; Loop 2420A - Rendering Physician
 S ABMLOOP="2420A"
 ;I $P($G(ABMRV(ABMI,ABMJ,ABMK)),U,13) D  ;abm*2.6*9 NOHEAT
 I ((ABMI'=23&$P($G(ABMRV(ABMI,ABMJ,ABMK)),U,13))!(ABMI=23&$P($G(ABMRV(ABMI,ABMJ,ABMK)),U,22))) D  ;abm*2.6*9 NOHEAT
 .Q:$G(ABMP("VTYP"))=831&($G(ABMP("ITYPE"))="R")  ;don't write provider info for ASC
 .Q:$G(ABMP("CLIN"))="A3"
 .;S ABM("PRV")=$P(ABMRV(ABMI,ABMJ,ABMK),U,13)  ;abm*2.6*9 NOHEAT
 .S ABM("PRV")=$S(ABMI'=23:$P(ABMRV(ABMI,ABMJ,ABMK),U,13),1:$P(ABMRV(ABMI,ABMJ,ABMK),U,22))  ;abm*2.6*9 NOHEAT
 .Q:ABM("PRV")=$O(ABMP("PRV","D",0))
 .Q:$D(ABMP("PRV","A",ABM("PRV")))!($D(ABMP("PRV","R",ABM("PRV"))))
 .D EP^ABME5NM1(82,ABM("PRV"))
 .D WR^ABMUTL8("NM1")
 .D EP^ABME5PRV("PE",ABM("PRV"))
 .D WR^ABMUTL8("PRV")
 .Q:$P($G(^AUTNINS(ABMP("INS"),0)),U)["OKLAHOMA MEDICAID"
 .;D EP^ABME5REF("EI",9999999.06,DUZ(2))
 .;Q:((ABMRCID="99999")!(ABMRCID="AHCCCS866004791"))  ;AZ Medicaid
 .;D WR^ABMUTL8("REF")
 ;
 ; Loop 2420B - Purchased Service Physician Name
 S ABMLOOP="2420B"
 ;abm*2.6*25 IHS/SD/SDR 12/18/17 - note about below code.  Should be changed from p19 since that is being used for something else.
 ;  that is what is causing the error to occur, but we don't capture a purchased service provider at this time.
 ;I $P($G(ABMRV(ABMI,ABMJ,ABMK)),U,19) D  ;abm*2.6*25 IHS/SD/SDR CR10008
 ;.S ABM("PRV")=$P(ABMRV(ABMI,ABMJ,ABMK),U,19)
 ;.Q:ABM("PRV")=$O(ABMP("PRV","P",0))
 ;.D EP^ABME5NM1("QB",ABM("PRV"))
 ;.D WR^ABMUTL8("NM1")
 ;.;D EP^ABME5REF("EI",9999999.06,DUZ(2))
 ;.;D WR^ABMUTL8("REF")
 ;
 ; Loop 2420C - Service Facility Location
 S ABMLOOP="2420C"
 I $G(ABMOUTLB)=1 D  ;reference lab
 .S ABMOTLBN=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),ABMI,ABMJ,0),"^",14)
 .I $G(ABMOTLBN)'="" D
 ..D EP^ABME5NM1(77,ABMOTLBN)
 ..D WR^ABMUTL8("NM1")
 ..D EP^ABME5N3(9002274.35,ABMOTLBN)
 ..D WR^ABMUTL8("N3")
 ..D EP^ABME5N4(9002274.35,ABMOTLBN)
 ..D WR^ABMUTL8("N4")
 ;
 ; Loop 2420D - Supervising Physician Name
 S ABMLOOP="2420D"
 I $P($G(ABMRV(ABMI,ABMJ,ABMK)),U,20) D
 .S ABM("PRV")=$P(ABMRV(ABMI,ABMJ,ABMK),U,20)
 .Q:ABM("PRV")=$O(ABMP("PRV","S",0))
 .D EP^ABME5NM1("DQ",ABM("PRV"))
 .D WR^ABMUTL8("NM1")
 .;D EP^ABME5REF("EI",9999999.06,DUZ(2))
 .;D WR^ABMUTL8("REF")
 ;
 ; Loop 2420E - Ordering Physician Name
 S ABMLOOP="2420E"
 I $P($G(ABMRV(ABMI,ABMJ,ABMK)),U,21) D
 .S ABM("PRV")=$P(ABMRV(ABMI,ABMJ,ABMK),U,21)
 .;NOTE:below line was added for patch 10 but removed during testing because site was
 .;reporting payer was requiring it
 .S ABMLOOP="2420E"
 .D EP^ABME5NM1("DK",ABM("PRV"))
 .D WR^ABMUTL8("NM1")
 .D EP^ABME5N3(200,ABM("PRV"))
 .D WR^ABMUTL8("N3")
 .D EP^ABME5N4(200,ABM("PRV"))
 .D WR^ABMUTL8("N4")
 .;D EP^ABME5REF("EI",9999999.06,DUZ(2))
 .;D WR^ABMUTL8("REF")
 .;start new abm*2.6*33 IHS/SD/SDR ADO60186
 .I +$G(ABMRVCSB(ABMI,ABMJ,ABMK))=1 D
 ..;D EP^ABME5REF("G2",200,$P(ABMRV(ABMI,ABMJ,ABMK),U,21))  ;abm*2.6*37 IHS/SD/SDR ADO89299
 ..I $P($G(ABMRV(ABMI,ABMJ,ABMK)),U,41)'="" D EP^ABME5REF("G2",0,$P(ABMRV(ABMI,ABMJ,ABMK),U,41))  ;abm*2.6*37 IHS/SD/SDR ADO89299
 ..D WR^ABMUTL8("REF")
 .;end new abm*2.6*33 IHS/SD/SDR ADO60186
 .K ABMLOOP
 ;
 ; Loop 2420F Referring Provider Name
 S ABMLOOP="2420F"
 I $P($G(ABMRV(ABMI,ABMJ,ABMK)),U,18) D
 .S ABM("PRV")=$P(ABMRV(ABMI,ABMJ,ABMK),U,18)
 .Q:ABM("PRV")=$O(ABMP("PVR","F",0))
 .D EP^ABME5NM1("DN",ABM("PRV"))
 .D WR^ABMUTL8("NM1")
 .;D EP^ABME5REF("EI",9999999.06,DUZ(2))
 .;D WR^ABMUTL8("REF")
 Q
