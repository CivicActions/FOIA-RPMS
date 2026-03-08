ABMDESM1 ; IHS/SD/SDR - Display Summarized Claim Info ; 
 ;;2.6;IHS Third Party Billing;**1,6,8,11,13,14,23,27,28,29,30**;NOV 12, 2009;Build 585
 ;
 ;IHS/SD/SDR 2.5*2 5/9/02 - NOIS HQW-0302-100190 Modified to display 2nd and 3rd modifiers and units
 ;IHS/SD/SDR 2.5*5 5/18/04 Modified to put POS and TOS by line item
 ;IHS/SD/EFG 2.5*8 IM16385 Added code for misc services if dental visit type
 ;IHS/SD/SDR 2.5*8 IM10618/IM11164 Prompt/display provider
 ;IHS/SD/SDR 2.5*8 task 6 Modified to check for ambulance services
 ;IHS/SD/SDR 2.5*9 task 1 Use new service line provider multiple
 ;IHS/SD/SDR 2.5*9 IM19707 Make sure ABMP("CLN") is defined before using
 ;IHS/SD/SDR 2.5*10 IM19843 Added SERVICE TO DATE/TIME
 ;IHS/SD/SDR 2.5*11 NPI
 ;IHS/SD/SDR 2.5*12 IM25331 Made change to print Taxonomy if NPI ONLY
 ;IHS/SD/SDR,AML 2.5*13 IM25899 Alignment changes
 ;
 ;IHS/SD/SDR 2.6 CSV
 ;IHS/SD/SDR 2.6*1 HEAT7884 display if visit type 731
 ;IHS/SD/SDR 2.6*6 HEAT28973 if 55 modifier present use '1' for units when calculating charges
 ;IHS/SD/SDR 2.6*6 NOHEAT Swing bed changes
 ;IHS/SD/SDR 2.6*13 Added check for new export mode 35
 ;IHS/SD/SDR 2.6*14 HEAT161263 Changed to use $$GET^DIQ so output transform will execute for SNOMED/Provider Narrative
 ;IHS/SD/AML 2.6*23 HEAT247169 Gather line items from 8D and 8H if visit type is 997
 ;IHS/SD/AML 2.6*27 CR8897 Added check if not Medi-Cal and not bill type 731 to be treated like flat rate
 ;IHS/SD/SDR 2.6*28 CR10648 Added CPT Narrative
 ;IHS/SD/SDR 2.6*29 CR10410 Added check for Medicare and condition code 21 - non-covered charges
 ;IHS/SD/SDR 2.6*29 CR10888 Fixed units for Charge Summary screen
 ;IHS/SD/SDR 2.6*30 CR11053 -fix <SUBSCR>MSH+21^ABMDESM1 when CPT doesn't have CPT CATEGORY populated
 ;
 K ABMS
 K ABMP("21NC")  ;abm*2.6*29 IHS/SD/SDR CR10410
 ;
 ; ABMS(revn)=Totl Charge^units^Unit Charge^CPT Code^Non-Cvd Amount
 ;
 S ABMS("TOT")=0,ABMS("I")=1
 G ITEM:'$D(ABMP("FLAT"))
 I $P(^ABMDEXP(ABMP("EXP"),0),U)'["UB",$P(ABMP("FLAT"),U,8) Q
 I $P(^ABMDEXP(ABMP("EXP"),0),U)["UB" D  G XIT
 .;S ABMX=$P($G(@(ABMP("GL")_"6)")),U,6)+$P($G(^(7)),U,3) S:$E(ABMP("BTYP"),2)'<3 ABMX=1  ;abm*2.6*1 HEAT7884
 .S ABMX=$P($G(@(ABMP("GL")_"6)")),U,6)  ;abm*2.6*1 HEAT7884
 .S ABMX=ABMX+$S((ABMP("VTYP")=999&(ABMP("BTYP")=731)&($P($G(^AUTNINS(ABMP("INS"),0)),U)["MONTANA MEDICAID")):$P($G(@(ABMP("GL")_"5)")),U,7),1:$P($G(@(ABMP("GL")_"7)")),U,3))  ;abm*2.6*1 HEAT7884
 .;S:($E(ABMP("BTYP"),2)'<3&'(ABMP("VTYP")=999&(ABMP("BTYP")=731)&($P($G(^AUTNINS(ABMP("INS"),0)),U)["MONTANA MEDICAID"))) ABMX=1  ;abm*2.6*1 HEAT7884  ;abm*2.6*6 Swing bed
 .;S:($E(ABMP("BTYP"),2)'<3&'(ABMP("VTYP")=999&(ABMP("BTYP")=731)&($P($G(^AUTNINS(ABMP("INS"),0)),U)["MONTANA MEDICAID"))&(ABMP("BTYP")'=181)) ABMX=1  ;abm*2.6*1 HEAT7884  ;abm*2.6*6 Swing bed  ;abm*2.6*27 IHS/SD/AML CR8897
 .S:(($$RCID^ABMUTLP(ABMP("INS"))'["61044"&(ABMP("BTYP")'=731))&$E(ABMP("BTYP"),2)'<3&'(ABMP("VTYP")=999&(ABMP("BTYP")=731)&($P($G(^AUTNINS(ABMP("INS"),0)),U)["MONTANA MEDICAID"))&(ABMP("BTYP")'=181)) ABMX=1  ;abm*2.6*27 IHS/SD/AML CR8897
 .S:ABMX=0 ABMX=1 S ABMS($P(ABMP("FLAT"),U,2))=$P(ABMP("FLAT"),U)*ABMX_U_ABMX_U_$P(ABMP("FLAT"),U)_U_U_($P($G(@(ABMP("GL")_"6)")),U,6)*$P(ABMP("FLAT"),U))
 .S ABMS("TOT")=+ABMS($P(ABMP("FLAT"),U,2)) G ^ABMDESMC:(ABMP("BTYP")=831)
 .;start new abm*2.6*29 IHS/SD/SDR CR10410
 .D CNDCD21
 .I +$G(ABMCND21)=1 S ABMP("21NC")=$P(ABMP("FLAT"),U)
 .;end new abm*2.6*29 IHS/SD/SDR CR10410
 .I $D(ABMP("FLAT",170)) S ABMX=ABMP("FLAT",170),ABMS(170)=$P(ABMP("FLAT"),U)*ABMX_U_ABMX_U_$P(ABMP("FLAT"),U)_U_U_($P($G(@(ABMP("GL")_"6)")),U,6)*$P(ABMP("FLAT"),U)),ABMS("TOT")=ABMS("TOT")+ABMS(170)
 ; I flat rate HCFA ...
 I ($P(^ABMDEXP(ABMP("EXP"),0),U)["HCFA")!($P(^ABMDEXP(ABMP("EXP"),0),U)["CMS") D  G XIT
 .S (ABMS("TOT"),ABMS(1))=$P(ABMP("FLAT"),U)*$P(ABMP("FLAT"),U,3)
 .S ABMS(1)=ABMS(1)_U_$$HDT^ABMDUTL($P(@(ABMP("GL")_"7)"),U))_U_$$HDT^ABMDUTL($P(@(ABMP("GL")_"7)"),U,2))_U
 .S ABMS(1)=ABMS(1)_$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),"^",16)
 .S ABMS(1)=ABMS(1)_U_U_$P(ABMP("FLAT"),U,3)_U_U_$P(ABMP("FLAT"),U,6)
 .I $$K24^ABMDFUTL D
 ..Q:'$G(ABMP("BDFN"))
 ..S ABMAPRV=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C","A",0))
 ..S ABMAPRV=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,ABMAPRV,0),U)
 ..S $P(ABMS(1),U,9)=$$K24N^ABMDFUTL(ABMAPRV)
 ..S $P(ABMS(ABMS("I")),U,11)=$P($$NPI^XUSNPI("Individual_ID",ABMAPRV),U)
 ..;Below line for South Dakota Urban (SD Urban)
 ..S ABMTLOC=$$GET1^DIQ(9999999.06,ABMP("LDFN"),.05,"E")  ;abm*2.6*8 NOHEAT
 ..I ((ABMTLOC["PIERRE URBAN")!(ABMTLOC["SOUTH DAKOTA URBAN"))&($P($G(^AUTNINS(ABMP("INS"),0)),U)="SOUTH DAKOTA MEDICAID") S $P(ABMS(ABMS("I")),U,11)=$P($$NPI^XUSNPI("Organization_ID",ABMP("LDFN")),U)  ;abm*2.6*8 NOHEAT
 ..I $G(ABMP("NPIS"))="N" S $P(ABMS(1),U,9)=$$PTAX^ABMEEPRV(ABMAPRV)
 I ABMP("PAGE")'[8 G XIT
ITEM ;itemized
 D CNDCD21  ;if Medicare look for Condition Code 21 - Billing for denial notice  ;abm*2.6*29 IHS/SD/SDR CR10410
 I ABMP("VTYP")=998 D ^ABMDESMD,^ABMDESMU,^ABMDESMX,^ABMDESML,^ABMDESMR,ER G XIT
 ;I ABMP("VTYP")=997 D ^ABMDESMR G XIT  ;abm*2.6*23 IHS/SD/AML HEAT247169
 I ABMP("VTYP")=997 D ^ABMDESMR,MISC^ABMDESMU G XIT  ;abm*2.6*23 IHS/SD/AML HEAT247169
 I ABMP("VTYP")=996 D ^ABMDESML G XIT
 I ABMP("VTYP")=995 D ^ABMDESMX G XIT
 I $G(ABMP("CLN"))'="",($P($G(^DIC(40.7,ABMP("CLN"),0)),U,2)="A3") D MISC^ABMDESMU,AMB^ABMDESMB G XIT
 D MS,^ABMDESMM,^ABMDESMX,^ABMDESML,^ABMDESMA,^ABMDESMD,^ABMDESMR,ER,ROO^ABMDESMU,MISC^ABMDESMU,REVN^ABMDESMU,SUP^ABMDESMU
 ;
 ;start new code abm*2.6*11 HEAT117086
 I (($G(ABMP("ITYPE"))="D")!($G(ABMP("ITYP"))="D")) D
 .S ABMIL=0
 .F  S ABMIL=$O(ABMS(ABMIL)) Q:'ABMIL  D
 ..I $P($G(ABMS(ABMIL)),U,4)'="T1015" Q
 ..S ABMTMP("TMP")=$G(ABMS(1))
 ..S ABMS(1)=$G(ABMS(ABMIL))
 ..S ABMS(ABMIL)=$G(ABMTMP("TMP"))
 K ABMIL,ABMTMP
 ;end new code HEAT117086
 ;
 G XIT
 ;
 ;start new abm*2.6*29 IHS/SD/SDR CR10410
CNDCD21 ;EP
 K ABMCND21
 I "^28^31^"'[("^"_ABMP("EXP")_"^") Q  ;UB-04 and 837I only
 I $G(ABMP("GL"))="" S ABMP("GL")="^ABMDBILL(DUZ(2),"_ABMP("BDFN")_","  ;default to bill if not defined
 K ABMP("21NC")
 ;if Medicare look for Condition Code 21 - Billing for denial notice
 I ((($G(ABMP("ITYPE"))="R")!($G(ABMP("ITYP"))="R"))&($E(ABMP("BTYP"),3)=0)) D
 .S ABMCND21=0
 .S ABMX=0
 .F ABMS("I")=1:1 S ABMX=$O(@(ABMP("GL")_"53,"_ABMX_")")) Q:'ABMX  S ABMX("X")=ABMX D
 ..S ABMX(0)=@(ABMP("GL")_"53,"_ABMX("X")_",0)")
 ..I +$G(ABMX(0))'=0 I $P($G(^ABMDCODE($P(+$G(ABMX(0)),U),0)),U)=21 S ABMCND21=1
 Q
CNCD21CK ;EP
 I "^28^31^"'[("^"_ABMP("EXP")_"^") Q  ;UB-04 and 837I only
 I (($G(ABMP("ITYPE"))="R")!($G(ABMP("ITYP"))="R")) D
 .I ((($G(ABMCND21)=1)&($E(ABMP("BTYP"),3)=0))!(ABMCNDCK["GY")) S ABMP("21NC")=+$G(ABMP("21NC"))+ABMX("SUB")
 Q
GYCHK(ABM1,ABM2,ABM3,ABM4,ABM5,ABM6) ;EP
 S ABMPC=6
 I (($G(ABMP("ITYPE"))="R")!($G(ABMP("ITYP"))="R")) D
 .I "^28^31^"'[("^"_ABMP("EXP")_"^") Q  ;UB-04 and 837I only
 .;I '(($E(ABMP("BTYP"),3)=0)&(+$G(ABMCND21)=1)) S ABMPC=6
 .I (($E(ABMP("BTYP"),3)=0)&(+$G(ABMCND21)=1)&(ABMP("EXP")=31)&(+$G(ABMY("FORM"))=0)) Q  ;skip modifier part if whole claim already labeled as non-covered
 .I ($P(ABMRV(ABM1,ABM2,ABM3),U,3)="GY") S ABMPC=7
 .I ($P(ABMRV(ABM1,ABM2,ABM3),U,4)="GY") S ABMPC=7
 .I ($P(ABMRV(ABM1,ABM2,ABM3),U,12)="GY") S ABMPC=7
 .;I (($E(ABMP("BTYP"),3)=0)&(+$G(ABMCND21)=1)&(+$G(ABMY("FORM"))=28)) S ABMPC=7  ;whole claim is non-covered so put all charges there
 .I (($E(ABMP("BTYP"),3)=0)&(+$G(ABMCND21)=1)) S ABMPC=7  ;whole claim is non-covered so put all charges there
 S $P(ABMRV(ABM1,ABM2,ABM3),U,ABMPC)=(ABM4*ABM5+$G(ABM6))  ;cumulative charges
 Q
 ;end new abm*2.6*29 IHS/SD/SDR CR10410
MS ;
 S ABMCAT=21 D PCK^ABMDESM1 Q:$G(ABMQUIT)
 S ABMX="""""" F ABMS("I")=ABMS("I"):1 S ABMX=$O(@(ABMP("GL")_"21,""C"","_ABMX_")")) Q:'ABMX  S ABMX("X")=$O(^(ABMX,"")) D MS1
 Q
 ;
MS1 ;
 ;S ABMX(0)=@(ABMP("GL")_"21,"_ABMX("X")_",0)"),ABMX(1)=$G(^(1))  ;abm*2.6*28 IHS/SD/SDR CR10648
 S ABMX(0)=@(ABMP("GL")_"21,"_ABMX("X")_",0)")  ;abm*2.6*28 IHS/SD/SDR CR10648
 S ABMX(1)=$G(@(ABMP("GL")_"21,"_ABMX("X")_",1)"))  ;abm*2.6*28 IHS/SD/SDR CR10648
 S ABMX(2)=$G(@(ABMP("GL")_"21,"_ABMX("X")_",2)"))  ;abm*2.6*28 IHS/SD/SDR CR10648
 S ABMX("SUB")=$P(ABMX(0),"^",7)*$P(ABMX(0),"^",13)
 S:'+ABMX("SUB") ABMX("SUB")=$P(ABMX(0),U,7)
 I ($P(ABMX(0),U,9)=55!($P(ABMX(0),U,11)=55)!($P(ABMX(0),U,12)=55)) S ABMX("SUB")=$P(ABMX(0),U,7)  ;IHS/SD/SDR 2/15/11 HEAT28973
 S ABMX("R")=$P(ABMX(0),U,3)
 I +$P(ABMX(0),U,7)=0!(ABMX("R")=""&($P(^ABMDEXP(ABMP("EXP"),0),U)["UB")) S ABMS("I")=ABMS("I")-1 Q
MS2 S ABMS("TOT")=ABMS("TOT")+ABMX("SUB")
 ;start new abm*2.6*29 IHS/SD/SDR CR10410
 S ABMCNDCK=U_$P(ABMX(0),U,9)_U_$P(ABMX(0),U,11)_U_$P(ABMX(0),U,12)
 D CNCD21CK^ABMDESM1
 ;end new abm*2.6*29 IHS/SD/SDR CR10410
 I $P(^ABMDEXP(ABMP("EXP"),0),U)'["UB" G MSH
 I ABMX("R")="" S ABMS("I")=ABMS("I")-1 Q
MSU S ABMS(ABMX("R"))=+$G(ABMS(ABMX("R")))+ABMX("SUB")
 S:$P(ABMS(ABMX("R")),U,4)="" $P(ABMS(ABMX("R")),U,4)=$P(ABMX(0),U)
 S $P(ABMS(ABMX("R")),U,2)=+$P(ABMS(ABMX("R")),U,2)+$P(ABMX(0),U,13)  ;abm*2.6*29 IHS/SD/SDR CR10888
 Q
 ;
MSH S ABMS(ABMS("I"))=ABMX("SUB")
 S ABMS(ABMS("I"))=ABMS(ABMS("I"))_U_$$HDT^ABMDUTL($P(ABMX(0),U,5))
 S $P(ABMS(ABMS("I")),U,3)=$S($P(ABMX(0),U,19)'="":$$HDT^ABMDUTL($P(ABMX(0),U,19)),1:$P(ABMS(ABMS("I")),U,2))
 S ABMX("C")=$P(ABMX(0),U)
 D CPT
 S $P(ABMS(ABMS("I")),U,4)=ABMX("C")_$S($P(ABMX(0),U,9)]"":"-"_$P(ABMX(0),U,9),1:"")
 S $P(ABMS(ABMS("I")),U,4)=$P(ABMS(ABMS("I")),U,4)_$S($P(ABMX(0),U,11)]"":"-"_$P(ABMX(0),U,11),1:"")
 S $P(ABMS(ABMS("I")),U,4)=$P(ABMS(ABMS("I")),U,4)_$S($P(ABMX(0),U,12)]"":"-"_$P(ABMX(0),U,12),1:"")
 S $P(ABMS(ABMS("I")),U,4)=$P(ABMS(ABMS("I")),U,4)_$S($P(ABMX(1),U)]"":"-"_$P(ABMX(1),U),1:"")
 S $P(ABMS(ABMS("I")),U,4)=$P(ABMS(ABMS("I")),U,4)_$S($P(ABMX(1),U,2)]"":"-"_$P(ABMX(1),U,2),1:"")
 ;I ABMP("EXP")=27 D  ;abm*2.6*13 export mode 35
 I ABMP("EXP")=27!(ABMP("EXP")=35) D  ;abm*2.6*13 export mode 35
 .S $P(ABMS(ABMS("I")),U,4)=ABMX("C")_$S($P(ABMX(0),U,9)]"":"   "_$P(ABMX(0),U,9),1:"")
 .S $P(ABMS(ABMS("I")),U,4)=$P(ABMS(ABMS("I")),U,4)_$S($P(ABMX(0),U,11)]"":" "_$P(ABMX(0),U,11),1:"")
 .S $P(ABMS(ABMS("I")),U,4)=$P(ABMS(ABMS("I")),U,4)_$S($P(ABMX(0),U,12)]"":" "_$P(ABMX(0),U,12),1:"")
 .S $P(ABMS(ABMS("I")),U,4)=$P(ABMS(ABMS("I")),U,4)_$S($P(ABMX(1),U)]"":" "_$P(ABMX(1),U),1:"")
 .S $P(ABMS(ABMS("I")),U,4)=$P(ABMS(ABMS("I")),U,4)_$S($P(ABMX(1),U,2)]"":" "_$P(ABMX(1),U,2),1:"")
 S $P(ABMS(ABMS("I")),U,5)=$P(ABMX(0),U,4)
 S $P(ABMS(ABMS("I")),U,6)=$P(ABMX(0),U,13)
 I $P(ABMX(0),U,16) D
 .S $P(ABMS(ABMS("I")),U,7)=$P($G(^ABMDCODE($P(ABMX(0),U,16),0)),U)
 ;E  S $P(ABMS(ABMS("I")),U,7)=$S($P(^DIC(81.1,$P($$CPT^ABMCVAPI(+ABMX(0),ABMP("VDT")),U,4),0),U,3)=2:2,1:1)  ;CSV-c  ;abm*2.6*30 IHS/SD/SDR CR11053
 ;start new abm*2.6*30 IHS/SD/SDR CR11053
 E  D
 .S $P(ABMS(ABMS("I")),U,7)=1
 .I +$P($$CPT^ABMCVAPI(+ABMX(0),ABMP("VDT")),U,4)'=0 I $P(^DIC(81.1,$P($$CPT^ABMCVAPI(+ABMX(0),ABMP("VDT")),U,4),0),U,3)=2 S $P(ABMS(ABMS("I")),U,7)=2
 ;end new abm*2.6*30 IHS/SD/SDR CR11053
 S $P(ABMS(ABMS("I")),U,10)=$P($G(ABMX(0)),U,15)  ;POS
 ;S $P(ABMS(ABMS("I")),U,8)=$P(^AUTNPOV($P(ABMX(0),U,6),0),U)  ;abm*2.6*14 HEAT161263
 S $P(ABMS(ABMS("I")),U,8)=$$GET1^DIQ(9999999.27,$P(ABMX(0),U,6),"01","E")  ;abm*2.6*14 HEAT161263
 S ABMX(0)=@(ABMP("GL")_"21,"_ABMX("X")_",0)")
 S ABMDPRV=$O(@(ABMP("GL")_"21,"_ABMX_",""P"",""C"",""R"",0)"))
 S:+ABMDPRV'=0 ABMDPRV=$P($G(@(ABMP("GL")_"21,"_ABMX_",""P"","_ABMDPRV_",0)")),U)
 I $G(ABMDPRV)="" S ABMDPRV=$$GETPRV^ABMDFUTL
 I +$G(ABMDPRV)'=0 D
 .Q:'$$K24^ABMDFUTL
 .S $P(ABMS(ABMS("I")),U,9)=$$K24N^ABMDFUTL(ABMDPRV)
 .S $P(ABMS(ABMS("I")),U,11)=$P($$NPI^XUSNPI("Individual_ID",ABMDPRV),U)
 .I $G(ABMP("NPIS"))="N" S $P(ABMS(ABMS("I")),U,9)=$$PTAX^ABMEEPRV(ABMDPRV)
 I "^35^"[("^"_ABMP("EXP")_"^") S $P(ABMS(ABMS("I")),U,12)=$P(ABMX(2),U,2)  ;abm*2.6*28 IHS/SD/SDR CR10648
 Q
 ;
ER ;
 S ABMX("ER")=+$P($G(@(ABMP("GL")_"8)")),U,10) I 'ABMX("ER") Q
 I $P(^ABMDEXP(ABMP("EXP"),0),U)["UB" S $P(ABMS(450),U)=$S($D(ABMS(450)):$P(ABMS(450),U)+ABMX("ER"),1:ABMX("ER")) G HER
 S ABMS(ABMS("I"))=ABMX("ER")
 S X=$S($P($G(@(ABMP("GL")_"6)")),U)]"":$P(@(ABMP("GL")_"6)"),U),1:$P($G(@(ABMP("GL")_"7)")),U))
 S $P(ABMS(ABMS("I")),U,2)=$$HDT^ABMDUTL(X)
 S $P(ABMS(ABMS("I")),U,3)=$P(ABMS(ABMS("I")),U,2)
 S $P(ABMS(ABMS("I")),U,8)="EMERGENCY ROOM CHARGE"
 S ABMS("I")=ABMS("I")+1
HER S ABMS("TOT")=ABMS("TOT")+ABMX("ER")
 Q
 ;
CPT S:ABMX("C") ABMX("C")=$P($$CPT^ABMCVAPI(ABMX("C"),ABMP("VDT")),U,2) Q  ;CSV-c
 ;
XIT K ABMX
 Q
 ;
HDT ;EP for date format
 S ABMDTF=$P($G(@(ABMP("GL")_"7)")),U)
 S ABMDTT=$P($G(@(ABMP("GL")_"7)")),U,2)
 I '$G(ABMCAT) D  Q
 .S $P(ABMS(ABMS("I")),U,2)=$$HDT^ABMDUTL(ABMDTF)
 .S $P(ABMS(ABMS("I")),U,3)=$$HDT^ABMDUTL(ABMDTT)
 I ABMCAT=21 D
 .Q:$P(ABMX(0),U,5)=""
 .S ABMDTF=$P(ABMX(0),U,5)
 .S ABMDTT=$S($P(ABMX(0),U,19)'="":$P(ABMX(0),U,19),1:$P(ABMX(0),U,5))
 I ABMCAT=23 D
 .Q:$P(ABMX(0),U,14)=""
 .S (ABMDTF,ABMDTT)=$P(ABMX(0),U,14)
 I ABMCAT=25 D
 .Q:$P(ABMX(0),U,4)=""
 .S (ABMDTF,ABMDTT)=$P(ABMX(0),U,4)
 I ABMCAT=27 D
 .Q:$P(ABMX(0),U,7)=""
 .S ABMDTF=$P(ABMX(0),U,7)
 .S ABMDTT=$S($P(ABMX(0),U,12)'="":$P(ABMX(0),U,12),1:$P(ABMX(0),U,7))
 I ABMCAT=33 D
 .Q:$P(ABMX(0),U,7)=""
 .S (ABMDTF,ABMDTT)=$P(ABMX(0),U,7)
 I ABMCAT=35 D
 .Q:$P(ABMX(0),U,9)=""
 .S ABMDTF=$P(ABMX(0),U,9)
 .S ABMDTT=$S($P(ABMX(0),U,12)'="":$P(ABMX(0),U,12),1:$P(ABMX(0),U,9))
 I ABMCAT=37 D
 .Q:$P(ABMX(0),U,5)=""
 .S ABMDTF=$P(ABMX(0),U,5)
 .S ABMDTT=$S($P(ABMX(0),U,12)'="":$P(ABMX(0),U,12),1:$P(ABMX(0),U,5))
 I ABMCAT=39 D
 .Q:'$P(ABMX(0),U,8)
 .S ABMDTT=$P(ABMX(0),U,8)
 .S ABMDTT=$P(ABMDTT,".",1)
 .S ABMDTF=$P(ABMX(0),U,7)
 .S ABMDTF=$P(ABMDTF,".")
 I ABMCAT=43 D
 .Q:$P(ABMX(0),U,7)=""
 .S ABMDTF=$P(ABMX(0),U,7)
 .S ABMDTT=$S($P(ABMX(0),U,12)'="":$P(ABMX(0),U,12),1:$P(ABMX(0),U,7))
 I ABMCAT=45 D
 .Q:$P(ABMX(0),U,2)=""
 .S (ABMDTF,ABMDTT)=$P(ABMX(0),U,2)
 I ABMCAT=47 D
 .Q:$P(ABMX(0),U,7)=""
 .S ABMDTF=$P(ABMX(0),U,7)
 .S ABMDTT=$S($P(ABMX(0),U,12)'="":$P(ABMX(0),U,12),1:$P(ABMX(0),U,7))
 S $P(ABMS(ABMS("I")),U,2)=$$HDT^ABMDUTL(ABMDTF)
 S $P(ABMS(ABMS("I")),U,3)=$$HDT^ABMDUTL(ABMDTT)
 K ABMDTF,ABMDTT,ABMPC,ABMCAT
 Q
PCK ;EP - PAGE CHECK
 K ABMQUIT
 Q:ABMP("GL")'["ABMDCLM"
 S ABMPC=$F("27^21^25^23^37^35^39^43^33^45^47",ABMCAT)/3
 S ABMEXM=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),70)),"^",ABMPC)
 S:ABMEXM="" ABMEXM=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,14)
 Q:ABMEXM=""
 S:ABMEXM'=ABMP("EXP") ABMQUIT=1
 K ABMEXM,ABMPC
 Q
