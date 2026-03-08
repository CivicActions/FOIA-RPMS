ABMDE3X ; IHS/SD/SDR - Edit Page 3 - ERROR CHK ;
 ;;2.6;IHS 3P BILLING SYSTEM;**6,8,10,13,14,30,31**;NOV 12, 2009;Build 615
 ;
 ;03/10/04 2.5*5 837 Modifications Added errror code 192 for imprecise accident dates
 ;IHS/SD/SDR 2.5*5 5/17/2004 Added code to check for error 193
 ;IHS/SD/SDR 2.5*6 7/16/04 Modified code for 193; added code for 201 and 202
 ;IHS/SD/SDR 2.5*8 IM15677 Modified to only display error 193 when export mode is 837
 ;IHS/SD/SDR 2.5*8 IM12246/IM17548 Added code for 199 and 200
 ;IHS/SD/SDR 2.5*9 IM19291 Error 215 added for Supervising Provider UPIN
 ;IHS/SD/SDR 2.5*9 IM16729 Correction ot taxonomy lookup (<SUBSCRIPT>ABMDE3X+29^ABMDE3X
 ;IHS/SD/SDR 2.5*9 IM18516 Delayed Reason Code
 ;IHS/SD/SDR 2.5*11 NPI
 ;IHS/SD/SDR 2.5*12 IM23474 Added warning if clinic is ER and admitting DX is missing
 ;
 ;IHS/SD/SDR 2.6*6 5010 Added warning 238 if both disability dates aren't populated
 ;IHS/SD/SDR 2.6*13 Added check for new export mode 35
 ;IHS/SD/SDR 2.6*14 ICD10 admit dx error checks (245 and 246) if wrong code set is used.
 ;IHS/SD/SDR 2.6*30 CR10215 Added check for error 21 for missing discharge status
 ;IHS/SD/SDR 2.6*31 CR10044 Added warning/errors 17 Admit Type, 18 Admit Source, 21 Patient (Discharge) Status if any of them are missing
 ;
 ; Rel of info, Assign of Benefits
 D QUES^ABMDE3:'$D(ABM("QU"))
 I $D(ABM("QU",1)),$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),$P(^(7),U,4)'="Y" S ABME(58)=""
 I $D(ABM("QU",2)),$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),$P(^(7),U,5)'="Y" S ABME(59)=""
 ;start new abm*2.6*14 ICD10 admit dx
 I $D(ABM("QU",24)) D
 .Q:(+$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),U,9)=0)  ;no admit dx
 .I ((ABMP("ICD10")>ABMP("VDT"))&($P($$DX^ABMCVAPI($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),U,9),ABMP("VDT")),U,20)=30)) S ABME(245)=""  ;should be ICD9, but is ICD10
 .I ((ABMP("ICD10")<ABMP("VDT"))&($P($$DX^ABMCVAPI($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),U,9),ABMP("VDT")),U,20)'=30)) S ABME(246)=""  ;should be ICD10, but is ICD9
 ;end new ICD10 admit dx
 ;
 ;start new abm*2.6*30 IHS/SD/SDR CR10215
 I "^28^31^"[("^"_ABMP("EXP")_"^") D
 .S ABMDSCST=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),U,3)
 .S:(ABMDSCST'="") ABMDSCST=$$UPC^ABMERUTL($P($G(^ABMDCODE(ABMDSCST,0)),U,3))  ;discharge status
 .I ABMDSCST["EXPIRED" S ABME(257)=""
 .I ABMDSCST="" D
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,6)=30 S ABME(21)=""  ;emergency medicine
 ..I $E($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,12),1,2)=11 S ABME(21)=""  ;bill type is 11#
 ..S ABMTV=0
 ..F  S ABMTV=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,ABMTV)) Q:'ABMTV  D
 ...I "^I^H^"[("^"_$P($G(^AUPNVIST(ABMTV,0)),U,7)_"^") S ABME(21)=""
 ;end new abm*2.6*30 IHS/SD/SDR CR10215
 ;
 ;start new abm*2.6*31 IHS/SD/SDR CR10044
 I "^28^31^"[("^"_ABMP("EXP")_"^") D
 .S ABMX("C5")=$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5))
 .I $D(ABM("QU",21)),$P(ABMX("C5"),U,1)="" S ABME(17)=""
 .I $D(ABM("QU",22)),$P(ABMX("C5"),U,2)="" S ABME(18)=""
 .I $D(ABM("QU",23)),$P(ABMX("C5"),U,3)="" S ABME(21)=""
 ;end new abm*2.6*31 IHS/SD/SDR CR10044
 ;
 ; Having a date of accident and accident type determine Accident Related
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,3) D
 .I ($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,3)=5)&($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,2)=""!($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,4)="")!($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,16)="")) S ABME(19)=""  ;abm*2.6*10 HEAT72979
 .I +$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,2),$E($P(^(8),U,2),6,7)="00" S ABME(192)=""
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,8)'="" D
 .;I ABMP("EXP")=21!(ABMP("EXP")=22)!(ABMP("EXP")=23) D  ;abm*2.6*8 5010
 .I ABMP("EXP")=21!(ABMP("EXP")=22)!(ABMP("EXP")=23)!(ABMP("EXP")=31)!(ABMP("EXP")=32)!(ABMP("EXP")=33) D  ;abm*2.6*8 5010
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,11)'="",(($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,13)="")&($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,14)="")&($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,15)="")) S ABME(193)=""
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,13)'="" D  ;Person class
 ...I $G(^ABMPTAX("AUSC",$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,13)))="" S ABME(201)=""
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,14)'="" D  ;Provider Class
 ...S ABMPTAX=$P($G(^DIC(7,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),8),U,14),9999999)),U)
 ...I $G(ABMPTAX)="" S ABME(202)=""
 ...I $G(ABMPTAX),$G(^ABMPTAX("A7",ABMPTAX))="" S ABME(202)=""
 .;I ABMP("EXP")=21!(ABMP("EXP")=22)!(ABMP("EXP")=23)!(ABMP("EXP")=27)!(ABMP("EXP")=28)!(ABMP("EXP")=29) D  ;abm*2.6*8 5010
 .;I ABMP("EXP")=21!(ABMP("EXP")=22)!(ABMP("EXP")=23)!(ABMP("EXP")=27)!(ABMP("EXP")=28)!(ABMP("EXP")=29)!(ABMP("EXP")=31)!(ABMP("EXP")=32)!(ABMP("EXP")=33) D  ;abm*2.6*8 5010  ;abm*2.6*13 export mode 35
 .I ABMP("EXP")=21!(ABMP("EXP")=22)!(ABMP("EXP")=23)!(ABMP("EXP")=27)!(ABMP("EXP")=28)!(ABMP("EXP")=29)!(ABMP("EXP")=31)!(ABMP("EXP")=32)!(ABMP("EXP")=33)!(ABMP("EXP")=35) D  ;abm*2.6*8 5010  ;abm*2.6*13 export mode 35
 ..S ABMNPIU=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 ..I ABMNPIU="N"!(ABMNPIU="B"),$D(ABM("QU",12)),($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,17)="") S ABME(223)=""  ;Ref prv NPI missing
 ..I ABMNPIU="N"!(ABMNPIU="B"),$D(ABM("QU",25)),($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,12)'=""),($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,25)="") S ABME(224)=""  ;sup prv NPI missing
 S ABMLABT=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,0))  ;check for lab charges
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,8)="",(+ABMLABT>0),(ABMP("EXP")=22!(ABMP("EXP")=23)) S ABME(199)=""
 I ($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,22)="")&($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,23)="") D
 .I ABMP("EXP")'=3,(ABMP("EXP")'=14),(ABMP("EXP")'=22),(ABMP("EXP")'=23),(ABMP("EXP")'=25) Q
 .I +ABMLABT>0 S ABME(200)=""
 S ABMNPIU=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 I ABMNPIU'="N",($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,12)'=""),($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,24)=""),("^3^14^15^22"[ABMP("EXP")) S ABME(215)=""
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,16)'="" D
 .I $P($G(^ABMDCODE($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,16),0)),U)=11 S ABME(198)=""
 .I '$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),61,0)) S ABME(214)=""  ;no remarks to go w/delayed reason code
 I $P($G(^DIC(40.7,ABMP("CLN"),0)),U)="EMERGENCY MEDICINE",($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),U,9)="") S ABME(230)=""
 ;start new code abm*2.6*6 5010
 S ABMP("DISSTDT")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,15)
 S ABMP("DISENDDT")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,16)
 I $G(ABMP("DISSTDT"))'=""&($G(ABMP("DISENDDT"))="") S ABME(238)=""
 I $G(ABMP("DISSTDT"))=""&($G(ABMP("DISENDDT"))'="") S ABME(238)=""
 ;end new code 5010
 ;
XIT Q
ERR D ABMDE3X
 S ABME("TITL")="PAGE 3 - QUESTIONS"
 G XIT
