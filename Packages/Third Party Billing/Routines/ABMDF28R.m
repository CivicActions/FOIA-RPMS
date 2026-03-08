ABMDF28R ; IHS/SD/SDR - PRINT UB-04 ;    
 ;;2.6;IHS Third Party Billing;**1,2,4,6,9,10,11,13,19,20,21,22,23,27,28,29,31,33,37**;NOV 12, 2009;Build 739
 ;IHS/SD/SDR-2.6*13-HEAT117086-T1015 should be top line for all Mcd
 ;IHS/SD/SDR-2.6*19-HEAT116949-If DUZ(2)=4610 (Chapa-De/Auburn), make FL56=1124150891
 ;IHS/SD/SDR-2.6*20-HEAT262141-Added code for AHCCCS RX.  Will print detail lines for all meds, but won't print price, only NDC, desc, date, and units.
 ;IHS/SD/SDR-2.6*21-HEAT205579-Made T1015 print first for ARBOR HEALTH PLAN
 ;IHS/SD/SDR-2.6*21-HEAT268438-check for 61044 from 61004 for Medi-Cal
 ;IHS/SD/SDR-2.6*21-HEAT240744-call to resort,print lines for Medi-Cal dialysis billing
 ;IHS/SD/SDR 2.6*22 HEAT335246 check new parm for printing itemized with first line printing flat rate and NDC.
 ;IHS/SD/AML 2.6*23 CR8897 HEAT314802 Made changes for Medi-Cal from-thru billing
 ;IHS/SD/SDR 2.6*23 HEAT347035 Changed how it was getting rev code
 ;IHS/SD/SDR 2.6*27 CR10170 Changed the Medi-Cal check for box 50 to check if insurer name contains O/P Medi-Cal as well as 61044 check
 ;IHS/SD/SDR 2.6*28 CR10387 Changed Medi-Cal so DOS starting 1/1/2019 will print a 4-digit rev code; anything before will be 3 digits
 ;IHS/SD/SDR 2.6*29 CR10410 If Medicare flat rate and non-covered don't print FL55
 ;IHS/SD/SDR 2.6*31 CR10340 Moved FL54 to the right one character
 ;IHS/SD/SDR 2.6*33 ADO60196 Moved FL55 left one character
 ;IHS/SD/SDR 2.6*37 ADO75349 Check new field EXPORT DATE; default to today
 ;
18A ;EP
 F ABMCTR=ABMCTR:1:22 W !  ;get to line 23
 S ABMDE="0001 TOTAL^^4"
 ;I $$RCID^ABMERUTL(ABMP("INS"))["61044"  S ABMDE="001 TOTAL^^4"  ;abm*2.6*21 HEAT268438  ;abm*2.6*28 IHS/SD/SDR CR10387
 I ($$RCID^ABMERUTL(ABMP("INS"))["61044")&(ABMP("VDT")<3190101)  S ABMDE="001 TOTAL^^4"  ;abm*2.6*21 HEAT268438  ;abm*2.6*28 IHS/SD/SDR CR10387
 D WRT^ABMDF28W
 S ABMDE=ABMPGCNT_"    "_ABMPGTOT_"^10^15"  ;PAGE ___ OF ___
 D WRT^ABMDF28W  ;#43
 ;S ABMDE=$$MDY^ABMDUTL($S($G(ABMP("PRINTDT"))="O":$P($G(^ABMDTXST(DUZ(2),$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,7),0)),U),$G(ABMP("PRINTDT"))="A":$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),1)),U,5),1:DT))_"^45^20"  ;create dt  ;IHS/SD/SDR ADO75349
 ;start new abm*2.6*37 IHS/SD/SDR ADO75349
 S ABMDE=""
 I ($G(ABMP("PRINTDT"))="O") D
 .I (+$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,7)'=0) S ABMDE=$P($G(^ABMDTXST(DUZ(2),$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,7),0)),U)  ;export number
 .I (ABMDE="") S ABMDE=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),1)),U,18)  ;export date
 I $G(ABMP("PRINTDT"))="A" S ABMDE=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),1)),U,5)  ;date/time approved
 I ABMDE="" S ABMDE=DT
 I ABMDE'="" S ABMDE=$$MDY^ABMDUTL(ABMDE)_"^45^20"
 ;end new abm*2.6*37 IHS/SD/SDR ADO75349
 D WRT^ABMDF28W
 S ABMDE=$TR($FN(ABMRV("ZZTOT"),"T",2),".")_"^60^10R"  ;Grand tot
 I ((+$G(ABMP("FLAT"))'=0)&(+$G(ABMCND21)=1)) S ABMDE="000^60^10R"  ;abm*2.6*29 IHS/SD/SDR CR10410
 D WRT^ABMDF28W  ;last item in desc section
 I +ABMRV("NCTOT") D
 .S ABMDE=$TR($FN(ABMRV("NCTOT"),"T",2),".")_"^69^10R"
 .D WRT^ABMDF28W  ;Grand tot-noncovered items
 .Q
 S ABMP("NCTOT")=+$G(ABMRV("NCTOT"))  ;abm*2.6*29 IHS/SD/SDR CR10410
 K ABMRV
 W !
 S ABMLNPI=$S($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,8)'="":$P(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1),U,8),$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,12)'="":$P(^ABMDPARM(ABMP("LDFN"),1,2),U,12),1:ABMP("LDFN"))
 S ABMDE=$S($P($$NPI^XUSNPI("Organization_ID",ABMLNPI),U)>0:$P($$NPI^XUSNPI("Organization_ID",ABMLNPI),U),1:"")  ;NPI-#56
 I DUZ(2)=4610,($$GET1^DIQ(9999999.18,ABMP("INS"),".01","E")="EDS/CDP") S ABMDE=1124150891
 S ABMDE=ABMDE_"^68^15"
 D WRT^ABMDF28W
 Q
42 ;
 ;Lines 42 - 44
 K ABMP("SET")
 D ^ABMER30  ;get ins, pymt data
 N I
 F I=1:1:3 D  ;check for blank entries; if any, move others up
 .I '$D(ABMREC(30,I)) D
 ..S ABMREC(30,I)=$G(ABMREC(30,(I+1)))
 ..S ABMREC(31,I)=$G(ABMREC(31,(I+1)))
 F I=1:1:3 D
 .W !
 .;Q:'$D(ABMREC(30,I))  ;HEAT144755
 .Q:$TR(ABMREC(30,I),"")=""  ;HEAT144755
 .;Ins name_" "_Payor Sub ID
 .S ABMDE=$S($E(ABMREC(30,I),54,78)["RAILROAD":"RAILROAD MEDICARE",1:$E(ABMREC(30,I),54,78))_" "_$E(ABMREC(30,I),31,34)_"^^22"
 .;I $$RCID^ABMERUTL(+$G(ABMP("INS",I)))=61044 S ABMDE="O/P MEDI-CAL^^22"  ;abm*2.6*19 HEAT116949
 .;I $$RCID^ABMERUTL(+$G(ABMP("INS",I)))["61044" S ABMDE="O/P MEDI-CAL^^22"  ;abm*2.6*19 HEAT116949  ;abm*2.6*27 IHS/SD/SDR CR10170
 .I (($$RCID^ABMERUTL(+$G(ABMP("INS",I)))["61044")&($E(ABMREC(30,I),54,78)["O/P MEDI-CAL")) S ABMDE="O/P MEDI-CAL^^22"  ;abm*2.6*27 IHS/SD/SDR CR10170
 .D WRT^ABMDF28W  ;#50
 .S ABMDE=$E(ABMREC(30,I),160,172)_"^23^15"  ;Provider ID (blank)
 .I $P($G(^AUTNINS(ABMP("INS"),0)),U)="IOWA MEDICAID" S ABMDE="^23^15"
 .D WRT^ABMDF28W  ;#51
 .S ABMDE=$E(ABMREC(30,I),142)_"^38^1"  ;Release code
 .D WRT^ABMDF28W  ;#52
 .S ABMDE=$E(ABMREC(30,I),143)_"^41^1"  ;Ben Assgn Indicator
 .D WRT^ABMDF28W  ;#53
 .;S ABMDE=+$E(ABMREC(30,I),173,182)_" ^43^10R"  ;3PB pymt receive  ;abm*2.6*31 IHS/SD/SDR CR10340
 .S ABMDE=+$E(ABMREC(30,I),173,182)_" ^44^10R"  ;3PB pymt receive  ;abm*2.6*31 IHS/SD/SDR CR10340
 .I +ABMDE D WRT^ABMDF28W  ;#54
 .;S ABMDE=+$E(ABMREC(30,I),183,192)_" ^55^10R"  ;Est 3PB amt due  ;abm*2.6*29 IHS/SD/SDR CR10410
 .;start new abm*2.6*29 IHS/SD/SDR CR10410
 .;Est 3PB amt due
 .S ABMDE=+$E(ABMREC(30,I),183,192)
 .I $P(ABMP("INS",I),U,2)="R" S ABMDE=ABMDE-($$FMT^ABMERUTL($G(ABMP("NCTOT")),"10NRJ2"))
 .;-(ABMP("NCTOT"))  ;estimated amt due-Medicare non-covered
 .I (+$G(ABMCND21)=1) S ABMDE="000"
 .;S ABMDE=ABMDE_"^55^10R"  ;abm*2.6*33 IHS/SD/SDR ADO60196
 .S ABMDE=ABMDE_" ^55^10R"  ;abm*2.6*33 IHS/SD/SDR ADO60196
 .;end new abm*2.6*29 IHS/SD/SDR CR10410
 .I +ABMDE D WRT^ABMDF28W  ;#55
 .I (('ABMDE)&(+$G(ABMCND21)=1)&(ABMREC(30,I)["MEDICARE")) D WRT^ABMDF28W  ;#55  ;abm*2.6*29 IHS/SD/SDR CR10410
 .I I=1 D  ;other prov ID-#57
 ..S Y=$P($G(^ABMNINS(ABMP("LDFN"),+ABMP("INS",I),1,ABMP("VTYP"),0)),U,8)
 ..S:Y="" Y=$P($G(^AUTNINS(+ABMP("INS",I),15,ABMP("LDFN"),0)),U,2)
 ..S:Y="" Y=$TR($P($G(^AUTTLOC(DUZ(2),0)),U,18),"-")
 ..Q:$P($G(^AUTNINS(ABMP("INS"),0)),U)["VMBP"  ;abm*2.6*11 IHS/SD/AML 7/30/2013 RQMT_94
 ..S ABMDE=Y_"^67^15"
 ..I $P($G(^AUTNINS(ABMP("INS"),0)),U)="IOWA MEDICAID" S ABMDE="^67^15"
 ..I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,8)=2 D PRIMECK^ABMDF28V  ;abm*2.6*21 HEAT97615
 ..I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,8)=2,$G(ABMTSIFG)=1 Q  ;don't write #57 if Medicare & TSI billed  ;abm*2.6*21 HEAT97615
 ..D WRT^ABMDF28W
 K ABMR
 Q
