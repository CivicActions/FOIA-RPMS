ABMDE8X1 ; IHS/SD/SDR - Page 8 - ERROR CHECKS-CONT ;
 ;;2.6;IHS 3P BILLING SYSTEM;**8,9,13,14,21,28**;NOV 12, 2009;Build 513
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
 ;IHS/SD/SDR 2.6*28 CR10648 Added check for 35 exp mode to all warning 241 references
 ;
E1 ;EP - Entry Point Page 8E error checks cont
 S ABMX("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABMX,0)
 ;start new abm*2.6*14 ICD10 008
 S ABMP("SLFDT")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABMX,0)),U,5)
 S ABMP("SLTDT")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABMX,0)),U,12)
 I (ABMP("ICD10")>ABMP("SLFDT"))&(ABMP("ICD10")<ABMP("SLTDT")) S ABME(249)=$S($G(ABME(249))="":ABMX,1:$G(ABME(249))_","_ABMX)
 ;end new ICD10 008
 I ^ABMDEXP(ABMMODE(5),0)["UB" D
 .I $P(ABMX("X0"),U,2)="" S ABME(121)=""
 I (^ABMDEXP(ABMMODE(5),0)["HCFA")!(^ABMDEXP(ABMMODE(5),0)["CMS") D
 .I $P(ABMX("X0"),"^",9)="" S ABME(122)=""
 .;start new abm*2.6*21 IHS/SD/SDR HEAT135540
 .I $P(ABMX("X0"),U,6,8)["90",$P(ABMX("X0"),U,14)="" D
 ..I $G(ABME(200))'="" S ABME(200)=$G(ABME(200))_","_ABMX("I")
 ..I $G(ABME(200))="" S ABME(200)=ABMX("I")
 .;end new abm*2.6*21 IHS/SD/SDR HEAT135540
 .S ABMCODXS=$P(ABMX("X0"),U,9)
 .I ABMCODXS'="" D
 ..F ABMJ=1:1 S ABMCODX=$P(ABMCODXS,",",ABMJ) Q:+$G(ABMCODX)=0  D
 ...;start new abm*2.6*8 NOHEAT
 ...;I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") S ABME(217)=$G(ABME(217))_","_ABMX("I")  ;abm*2.6*14 HEAT163747
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") Q:ABME(217)[(ABMX("I"))  S ABME(217)=$G(ABME(217))_","_ABMX("I")  ;abm*2.6*14 HEAT163747
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))="") S ABME(217)=ABMX("I")
 ...;end new
 I $P(ABMX("X0"),U,3)="" S ABME(123)=""
 I $P(ABMX("X0"),U,4)="" S ABME(126)=""
 I +$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),4,"B",$P(ABMX("X0"),U),0))'=0 D
 .Q:ABMMODE(5)'=22  ;837P only
 .Q:'$D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),4,"B",$P(ABMX("X0"),U)))
 .S ABMIIEN=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),4,"B",$P(ABMX("X0"),U),0))
 .Q:$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),4,ABMIIEN,0)),U,2)'="Y"  ;quit if not required
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABMX,0)),U,19)="" S ABME(233)=""
 .I +$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABMX,0)),U,21)=0 S ABME(233)=""  ;lab result req'd
 I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",$P(ABMX("X0"),U)))&($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABMX,2)),U,2)="") D  ;abm*2.6*9 NARR
 .;Q:$P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["5010"  ;abm*2.6*9 NARR  ;abm*2.6*28 IHS/SD/SDR CR10648
 .I ($P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["5010")&(ABMP("EXP")'=35) Q  ;abm*2.6*28 IHS/SD/SDR CR10648
 .K ABMP("CPTNT") S ABMP("CPTNT")=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",$P(ABMX("X0"),U),0))  ;abm*2.6*9 NARR
 .Q:($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMP("CPTNT"),0)),U,2)'="Y")  ;abm*2.6*9 NARR
 .S ABME(241)=$S('$D(ABME(241)):ABMX("I"),1:ABME(241)_","_ABMX("I"))  ;abm*2.6*9 NARR
 ;I ABMMODE(5)=22!(ABMMODE(5)=27) D  ;abm*2.6*13 export mode 35
 I ABMMODE(5)=22!(ABMMODE(5)=27)!(ABMMODE(5)=35) D  ;abm*2.6*13 export mode 35
 .S ABMPIEN=0
 .F  S ABMPIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABMX,"P",ABMPIEN)) Q:+ABMPIEN=0  D
 ..S ABMNPIUS=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 ..S ABMPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABMX,"P",ABMPIEN,0)),U)
 ..;start new abm*2.6*8 NOHEAT
 ..I ABMNPIUS="N",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(220)=$S('$D(ABME(220)):ABMX("I"),1:ABME(220)_","_ABMX("I"))
 ..I ABMNPIUS="B",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(221)=$S('$D(ABME(221)):ABMX("I"),1:ABME(221)_","_ABMX("I"))
 ..;end new
 ..Q:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABMX,"P",ABMPIEN,0)),U,2)'="D"
 ..S ABMPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABMX,"P",ABMPIEN,0)),U)
 ..I $P($G(^VA(200,ABMPRV,.11)),U)="" S ABME(216)=ABMX  ;provider street
 ..I $P($G(^VA(200,ABMPRV,.11)),U,4)="" S ABME(216)=ABMX  ;city
 ..I $P($G(^VA(200,ABMPRV,.11)),U,5)="" S ABME(216)=ABMX  ;state
 ..I $P($G(^VA(200,ABMPRV,.11)),U,6)="" S ABME(216)=ABMX  ;zip
 K ABMPIEN
 Q
 ;
F1 ;EP - Entry Point Page 8F error checks cont
 S ABMX("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),35,ABMX,0)
 ;start new abm*2.6*14 ICD10 008
 S ABMP("SLFDT")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),35,ABMX,0)),U,9)
 S ABMP("SLTDT")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),35,ABMX,0)),U,12)
 I (ABMP("ICD10")>ABMP("SLFDT"))&(ABMP("ICD10")<ABMP("SLTDT")) S ABME(249)=$S($G(ABME(249))="":ABMX,1:$G(ABME(249))_","_ABMX)
 ;end new ICD10 008
 I ^ABMDEXP(ABMMODE(6),0)["UB" D
 .I $P(ABMX("X0"),U,2)="" S ABME(121)=""
 I (^ABMDEXP(ABMMODE(6),0)["HCFA")!(^ABMDEXP(ABMMODE(6),0)["CMS") D
 .I $P(ABMX("X0"),"^",8)="" S ABME(122)=""
 .S ABMCODXS=$P(ABMX("X0"),U,8)
 .I ABMCODXS'="" D
 ..F ABMJ=1:1 S ABMCODX=$P(ABMCODXS,",",ABMJ) Q:+$G(ABMCODX)=0  D
 ...;start new abm*2.6*8 NOHEAT
 ...;I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") S ABME(217)=$G(ABME(217))_","_ABMX("I")  ;abm*2.6*14 HEAT163747
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") Q:ABME(217)[(ABMX("I"))  S ABME(217)=$G(ABME(217))_","_ABMX("I")  ;abm*2.6*14 HEAT163747
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))="") S ABME(217)=ABMX("I")
 ...;end new
 I $P(ABMX("X0"),U,3)="" S ABME(123)=""
 I $P(ABMX("X0"),U,4)="" S ABME(126)=""
 I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",$P(ABMX("X0"),U)))&($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),35,ABMX,2)),U,2)="") D  ;abm*2.6*9 NARR
 .;Q:$P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["5010"  ;abm*2.6*9 NARR  ;abm*2.6*28 IHS/SD/SDR CR10648
 .I ($P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["5010")&(ABMP("EXP")'=35) Q  ;abm*2.6*28 IHS/SD/SDR CR10648
 .K ABMP("CPTNT") S ABMP("CPTNT")=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",$P(ABMX("X0"),U),0))  ;abm*2.6*9 NARR
 .Q:($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMP("CPTNT"),0)),U,2)'="Y")  ;abm*2.6*9 NARR
 .S ABME(241)=$S('$D(ABME(241)):ABMX("I"),1:ABME(241)_","_ABMX("I"))  ;abm*2.6*9 NARR
 ;I ABMMODE(6)=22!(ABMMODE(6)=27) D  ;abm*2.6*13 export mode 35
 I ABMMODE(6)=22!(ABMMODE(6)=27)!(ABMMODE(6)=35) D  ;abm*2.6*13 export mode 35
 .S ABMPIEN=0
 .F  S ABMPIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),35,ABMX,"P",ABMPIEN)) Q:+ABMPIEN=0  D
 ..S ABMNPIUS=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 ..S ABMPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),35,ABMX,"P",ABMPIEN,0)),U)
 ..;start new abm*2.6*8 NOHEAT
 ..I ABMNPIUS="N",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(220)=$S('$D(ABME(220)):ABMX("I"),1:ABME(220)_","_ABMX("I"))
 ..I ABMNPIUS="B",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(221)=$S('$D(ABME(221)):ABMX("I"),1:ABME(221)_","_ABMX("I"))
 ..;end new
 ..Q:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),35,ABMX,"P",ABMPIEN,0)),U,2)'="D"
 ..S ABMPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),35,ABMX,"P",ABMPIEN,0)),U)
 ..I $P($G(^VA(200,ABMPRV,.11)),U)="" S ABME(216)=ABMX  ;provider street
 ..I $P($G(^VA(200,ABMPRV,.11)),U,4)="" S ABME(216)=ABMX  ;city
 ..I $P($G(^VA(200,ABMPRV,.11)),U,5)="" S ABME(216)=ABMX  ;state
 ..I $P($G(^VA(200,ABMPRV,.11)),U,6)="" S ABME(216)=ABMX  ;zip
 K ABMPIEN
 Q
 ;
G1 ;EP - Entry Point Page 8G error checks cont
 S ABMX("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABMX,0)
 ;start new abm*2.6*14 ICD10 008
 S ABMP("SLFDT")=$P($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABMX,0)),U,7),".")
 S ABMP("SLTDT")=$P($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABMX,0)),U,8),".")
 I (ABMP("ICD10")>ABMP("SLFDT"))&(ABMP("ICD10")<ABMP("SLTDT")) S ABME(249)=$S($G(ABME(249))="":ABMX,1:$G(ABME(249))_","_ABMX)
 ;end new ICD10 008
 I ^ABMDEXP(ABMMODE(7),0)["UB" D
 .I $P(ABMX("X0"),U,2)="" S ABME(121)=""
 I (^ABMDEXP(ABMMODE(7),0)["HCFA")!(^ABMDEXP(ABMMODE(7),0)["CMS") D
 .I $P(ABMX("X0"),"^",10)="" S ABME(122)=""
 .S ABMCODXS=$P(ABMX("X0"),U,10)
 .I ABMCODXS'="" D
 ..F ABMJ=1:1 S ABMCODX=$P(ABMCODXS,",",ABMJ) Q:+$G(ABMCODX)=0  D
 ...;start new abm*2.6*8 NOHEAT
 ...;I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") S ABME(217)=$G(ABME(217))_","_ABMX("I")  ;abm*2.6*14 HEAT163747
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") Q:ABME(217)[(ABMX("I"))  S ABME(217)=$G(ABME(217))_","_ABMX("I")  ;abm*2.6*14 HEAT163747
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))="") S ABME(217)=ABMX("I")
 ...;end new
 I $P(ABMX("X0"),U,3)="" S ABME(132)=""
 I $P(ABMX("X0"),U,4)="" S ABME(126)=""
 I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",$P(ABMX("X0"),U)))&($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABMX,2)),U,2)="") D  ;abm*2.6*9 NARR
 .;Q:$P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["5010"  ;abm*2.6*9 NARR  ;abm*2.6*28 IHS/SD/SDR CR10648
 .I ($P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["5010")&(ABMP("EXP")'=35) Q  ;abm*2.6*28 IHS/SD/SDR CR10648
 .K ABMP("CPTNT") S ABMP("CPTNT")=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",$P(ABMX("X0"),U),0))  ;abm*2.6*9 NARR
 .Q:($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMP("CPTNT"),0)),U,2)'="Y")  ;abm*2.6*9 NARR
 .S ABME(241)=$S('$D(ABME(241)):ABMX("I"),1:ABME(241)_","_ABMX("I"))  ;abm*2.6*9 NARR
 I ABMMODE(7) D
 .S ABMPIEN=0
 .F  S ABMPIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABMX,"P",ABMPIEN)) Q:+ABMPIEN=0  D
 ..S ABMNPIUS=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 ..S ABMPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABMX,"P",ABMPIEN,0)),U)
 ..;start new abm*2.6*8 NOHEAT
 ..I ABMNPIUS="N",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(220)=$S('$D(ABME(220)):ABMX("I"),1:ABME(220)_","_ABMX("I"))
 ..I ABMNPIUS="B",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(221)=$S('$D(ABME(221)):ABMX("I"),1:ABME(221)_","_ABMX("I"))
 ..;end new
 ..Q:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABMX,"P",ABMPIEN,0)),U,2)'="D"
 ..S ABMPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABMX,"P",ABMPIEN,0)),U)
 ..I $P($G(^VA(200,ABMPRV,.11)),U)="" S ABME(216)=ABMX  ;provider street
 ..I $P($G(^VA(200,ABMPRV,.11)),U,4)="" S ABME(216)=ABMX  ;city
 ..I $P($G(^VA(200,ABMPRV,.11)),U,5)="" S ABME(216)=ABMX  ;state
 ..I $P($G(^VA(200,ABMPRV,.11)),U,6)="" S ABME(216)=ABMX  ;zip
 K ABMPIEN
 Q
