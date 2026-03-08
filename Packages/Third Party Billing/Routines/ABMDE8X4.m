ABMDE8X4 ; IHS/SD/SDR - Page 8 - ERROR CHECKS-CONT ;
 ;;2.6;IHS 3P BILLING SYSTEM;**8,9,13,14,21,28,33,37**;NOV 12, 2009;Build 739
 ;IHS/SD/SDR 2.5*8 task 6 Added page 8K error checks; also added to page 8H error checks for ambulance billing
 ;IHS/SD/SDR 2.5*9 task 1 Added check for provider address
 ;IHS/SD/SDR 2.5*10 IM20394 Added new error 217
 ;IHS/SD/SDR 2.5*11 NPI Added NPI errors 220 and 221
 ;
 ;IHS/SD/SDR 2.6 CSV
 ;IHS/SD/SDR 2.6*13 Added check for new export mode 35
 ;IHS/SD/SDR 2.6*14 ICD10 008 Added warning if service lines cross over ICD10 EFFECTIVE DATE
 ;IHS/SD/SDR 2.6*14 HEAT163747 Updated error 217 so it only displays one for ea service line, no matter how many coor dx are present
 ;IHS/SD/SDR 2.6*21 HEAT135540 Added error 200 so it will display if there is a 90 modifier but the referring CLIA is blank.
 ;IHS/SD/SDR 2.6*28 CR10648 Added check for 35 exp mode to all warning 241 references; split from routine ABMDE8X1 due to routine size
 ;IHS/SD/SDR 2.6*33 ADO60186/CR12024 Changed warning 241 to match new DD (changed from Y/N to C/R/B options); Added new warning 259 for possible DEA# needed
 ;IHS/SD/SDR 2.6*37 ADO89299 Updated 259 to check new DEA_VA_USPHS field; added warning 261
 ;
H1 ;EP - Entry Point Page 8H error checks cont
 S ABMX("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMX,0)
 ;start new abm*2.6*14 ICD10 008
 S ABMP("SLFDT")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMX,0)),U,7)
 S ABMP("SLTDT")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMX,0)),U,12)
 I (ABMP("ICD10")>ABMP("SLFDT"))&(ABMP("ICD10")<ABMP("SLTDT")) S ABME(249)=$S($G(ABME(249))="":ABMX,1:$G(ABME(249))_","_ABMX)
 ;end new ICD10 008
 I ^ABMDEXP(ABMMODE(8),0)["UB" D
 .I $P(ABMX("X0"),U,2)="" S ABME(121)=""
 I (^ABMDEXP(ABMMODE(8),0)["HCFA")!(^ABMDEXP(ABMMODE(8),0)["CMS") D
 .I $P(ABMX("X0"),"^",6)="" S ABME(122)=""
 .S ABMCODXS=$P(ABMX("X0"),U,6)
 .I ABMCODXS'="" D
 ..F ABMJ=1:1 S ABMCODX=$P(ABMCODXS,",",ABMJ) Q:+$G(ABMCODX)=0  D
 ...;I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") S ABME(217)=$G(ABME(217))_","_ABMX("I")  ;abm*2.6*14 HEAT163747
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") Q:ABME(217)[(ABMX("I"))  S ABME(217)=$G(ABME(217))_","_ABMX("I")  ;abm*2.6*14 HEAT163747
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))="") S ABME(217)=ABMX("I")
 I $P(ABMX("X0"),U,3)="" S ABME(123)=""
 I $P(ABMX("X0"),U,4)="" S ABME(126)=""
 I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",$P(ABMX("X0"),U)))&($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMX,2)),U,2)="") D  ;abm*2.6*9 NARR
 .;Q:$P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["5010"  ;abm*2.6*9 NARR  ;abm*2.6*28 IHS/SD/SDR CR10648
 .;I ($P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["5010")&(ABMP("EXP")'=35) Q  ;abm*2.6*28 IHS/SD/SDR CR10648  ;abm*2.6*33 IHS/SD/SDR CR12024
 .I ($P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["5010")&(ABMP("EXP")'=35)&(ABMP("EXP")'=28) Q  ;abm*2.6*28 IHS/SD/SDR CR10648  ;abm*2.6*33 IHS/SD/SDR CR12024
 .K ABMP("CPTNT") S ABMP("CPTNT")=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",$P(ABMX("X0"),U),0))  ;abm*2.6*9 NARR
 .Q:($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMP("CPTNT"),0)),U,2)'="Y")  ;abm*2.6*9 NARR
 .S ABME(241)=$S('$D(ABME(241)):ABMX("I"),1:ABME(241)_","_ABMX("I"))  ;abm*2.6*9 NARR
 I $P($G(^DIC(40.7,ABMP("CLN"),0)),U,2)["A3" D
 .S ABMCIEN=0
 .F  S ABMCIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,"B",ABMCIEN)) Q:ABMCIEN=""  D
 ..I $P($$CPT^ABMCVAPI(ABMCIEN,ABMP("VDT")),U,2)="J3490",($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),10)),U)="") S ABME(210)=""  ;CSV-c
 ..S ABMIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,"B",ABMCIEN,0))
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMIEN,0)),U,5)="QL" S ABME(212)=""
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMIEN,0)),U,8)="QL" S ABME(212)=""
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMIEN,0)),U,9)="QL" S ABME(212)=""
 ;I ABMMODE(8)=22!(ABMMODE(8)=27) D ;abm*2.6*13 export mode 35
 I ABMMODE(8)=22!(ABMMODE(8)=27)!(ABMMODE(8)=35) D  ;abm*2.6*13 export mode 35
 .S ABMPIEN=0
 .F  S ABMPIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMX,"P",ABMPIEN)) Q:+ABMPIEN=0  D
 ..S ABMNPIUS=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 ..S ABMPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMX,"P",ABMPIEN,0)),U)
 ..;start new abm*2.6*8 NOHEAT
 ..I ABMNPIUS="N",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(220)=$S('$D(ABME(220)):ABMX("I"),1:ABME(220)_","_ABMX("I"))
 ..I ABMNPIUS="B",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(221)=$S('$D(ABME(221)):ABMX("I"),1:ABME(221)_","_ABMX("I"))
 ..;end new
 ..Q:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMX,"P",ABMPIEN,0)),U,2)'="D"
 ..S ABMPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMX,"P",ABMPIEN,0)),U)
 ..I $P($G(^VA(200,ABMPRV,.11)),U)="" S ABME(216)=ABMX  ;provider street
 ..I $P($G(^VA(200,ABMPRV,.11)),U,4)="" S ABME(216)=ABMX  ;city
 ..I $P($G(^VA(200,ABMPRV,.11)),U,5)="" S ABME(216)=ABMX  ;state
 ..I $P($G(^VA(200,ABMPRV,.11)),U,6)="" S ABME(216)=ABMX  ;zip
 K ABMPIEN
 ;start new abm*2.6*33 IHS/SD/SDR CR12024
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMX,0)),U,19)'="" D
 .I $P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,25)'="Y" Q  ;abm*2.6*37 IHS/SD/SDR ADO89299
 .I (($P($G(^ABMDEXP(ABMP("8H"),0)),U)'["HCFA")&($P($G(^ABMDEXP(ABMP("8H"),0)),U)'["1500")) Q  ;abm*2.6*37 ADO89299
 .I '$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMX,"P","C","D")) D  ;abm*2.6*37 IHS/SD/SDR ADO89299
 ..S ABME(261)=$S('$D(ABME(261)):ABMX("I"),1:ABME(261)_","_ABMX("I"))  ;abm*2.6*37 IHS/SD/SDR ADO89299
 .S ABM("DIEN")=$O(^PSDRUG("ZNDC",$TR($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMX,0)),U,19),"-"),0))
 .I +$G(ABM("DIEN"))'=0 D
 ..S ABMT("CSUB")=$P($G(^PSDRUG(ABM("DIEN"),0)),U,3)  ;DEA, SPECIAL HDLG
 ..I (ABMT("CSUB")[2)!(ABMT("CSUB")[3)!(ABMT("CSUB")[4)!(ABMT("CSUB")[5) D
 ...;S ABME(259)=$S('$D(ABME(259)):ABMX("I"),1:ABME(259)_","_ABMX("I"))  ;abm*2.6*37 IHS/SD/SDR ADO89299
 ...I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMX,2)),U,6)="" S ABME(259)=$S('$D(ABME(259)):ABMX("I"),1:ABME(259)_","_ABMX("I"))  ;abm*2.6*37 IHS/SD/SDR ADO89299
 ;end new abm*2.6*33 IHS/SD/SDR CR12024
 Q
 ;
 ;start new abm*2.6*33 IHS/SD/SDR CR12024
D3 ;EP
 ;I ($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABMX,0)),U,24)'="") D  ;abm*2.6*37 IHS/SD/SDR ADO89299
 I ($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABMX,0)),U,24)'="") D  ;abm*2.6*37 IHS/SD/SDR ADO89299
 .I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),1)),U,25)'="Y" Q  ;abm*2.6*37 IHS/SD/SDR ADO89299
 .I (($P($G(^ABMDEXP(ABMP("8D"),0)),U)'["HCFA")&($P($G(^ABMDEXP(ABMP("8D"),0)),U)'["1500")) Q  ;warning for HCFAs only  ;abm*2.6*37 IHS/SD/SDR ADO89299
 .I '$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABMX,"P","C","D")) D  ;abm*2.6*37 IHS/SD/SDR ADO89299
 ..S ABME(261)=$S('$D(ABME(261)):ABMX("I"),1:ABME(261)_","_ABMX("I"))  ;abm*2.6*37 IHS/SD/SDR ADO89299
 .;S ABM("DIEN")=$O(^PSDRUG("ZNDC",$TR($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABMX,0)),U,24),"-"),0))  ;abm*2.6*37 IHS/SD/SDR ADO89299
 .S ABM("DIEN")=$O(^PSDRUG("ZNDC",$TR($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABMX,0)),U,24),"-"),0))  ;abm*2.6*37 IHS/SD/SDR ADO89299
 .I +$G(ABM("DIEN"))'=0 D
 ..S ABMT("CSUB")=$P($G(^PSDRUG(ABM("DIEN"),0)),U,3)  ;DEA, SPECIAL HDLG
 ..I (ABMT("CSUB")[2)!(ABMT("CSUB")[3)!(ABMT("CSUB")[4)!(ABMT("CSUB")[5) D
 ...I (($P($G(^ABMDEXP(ABMP("8D"),0)),U)'["HCFA")&($P($G(^ABMDEXP(ABMP("8D"),0)),U)'["1500")) Q  ;warning for HCFAs only  ;abm*2.6*37 IHS/SD/SDR ADO89299
 ...;S ABME(259)=$S('$D(ABME(259)):ABMX("I"),1:ABME(259)_","_ABMX("I"))  ;abm*2.6*37 IHS/SD/SDR ADO89299
 ...I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABMX,2)),U,6)="" S ABME(259)=$S('$D(ABME(259)):ABMX("I"),1:ABME(259)_","_ABMX("I"))  ;abm*2.6*37 IHS/SD/SDR ADO89299
 ..;I '$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABMX,"P","C","D")) D  ;abm*2.6*37 IHS/SD/SDR ADO89299
 ..;.S ABME(261)=$S('$D(ABME(261)):ABMX("I"),1:ABME(261)_","_ABMX("I"))  ;abm*2.6*37 IHS/SD/SDR ADO89299
 I ($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABMX,0)),U,24)="") D
 .S ABMT("CSUB")=$P($G(^PSDRUG($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABMX,0)),U),0)),U,3)
 .I (ABMT("CSUB")[2)!(ABMT("CSUB")[3)!(ABMT("CSUB")[4)!(ABMT("CSUB")[5) D
 ..I (($P($G(^ABMDEXP(ABMP("8D"),0)),U)'["HCFA")&($P($G(^ABMDEXP(ABMP("8D"),0)),U)'["1500")) Q  ;warning for HCFAs only  ;abm*2.6*37 IHS/SD/SDR ADO89299
 ..;S ABME(259)=$S('$D(ABME(259)):ABMX("I"),1:ABME(259)_","_ABMX("I"))  ;abm*2.6*37 IHS/SD/SDR ADO89299
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABMX,2)),U,6)="" S ABME(259)=$S('$D(ABME(259)):ABMX("I"),1:ABME(259)_","_ABMX("I"))  ;abm*2.6*37 IHS/SD/SDR ADO89299
 Q
 ;end new abm*2.6*33 IHS/SD/SDR CR12024
