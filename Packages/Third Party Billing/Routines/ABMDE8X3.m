ABMDE8X3 ; IHS/SD/SDR - Page 8 - ERROR CHECKS-CONT ;
 ;;2.6;IHS 3P BILLING SYSTEM;**8,9,13,14,28**;NOV 12, 2009;Build 513
 ;IHS/SD/SDR 2.6*13 Added check for new export mode 35
 ;IHS/SD/SDR 2.6*14 ICD10 008 Added warning if service lines cross over ICD10 EFFECTIVE DATE
 ;IHS/SD/SDR 2.6*14 HEAT163747 Updated error 217 so it only displays one for ea service line, no matter how many coor dx are present
 ;IHS/SD/SDR 2.6*28 CR10648 Added check for 35 exp mode to warning 241
 ;
K1 ;EP - Entry Point Page 8K error checks cont
 S ABMX("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),47,ABMX,0)
 ;start new abm*2.6*14 ICD10 008
 S ABMP("SLFDT")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),47,ABMX,0)),U,7)
 S ABMP("SLTDT")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),47,ABMX,0)),U,12)
 I (ABMP("ICD10")>ABMP("SLFDT"))&(ABMP("ICD10")<ABMP("SLTDT")) S ABME(249)=$S($G(ABME(249))="":ABMX,1:$G(ABME(249))_","_ABMX)
 ;end new ICD10 008
 I ^ABMDEXP(ABMMODE(8),0)["UB" D
 .I $P(ABMX("X0"),U,2)="" S ABME(121)=""
 I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",$P(ABMX("X0"),U)))&($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),47,ABMX,2)),U,2)="") D  ;abm*2.6*9 NARR
 .;Q:$P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["5010"  ;abm*2.6*9 NARR  ;abm*2.6*28 IHS/SD/SDR CR10648
 .I ($P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["5010")&(ABMP("EXP")'=35) Q  ;abm*2.6*28 IHS/SD/SDR CR10648
 .K ABMP("CPTNT") S ABMP("CPTNT")=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",$P(ABMX("X0"),U),0))  ;abm*2.6*9 NARR
 .Q:($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMP("CPTNT"),0)),U,2)'="Y")  ;abm*2.6*9 NARR
 .S ABME(241)=$S('$D(ABME(241)):ABMX("I"),1:ABME(241)_","_ABMX("I"))  ;abm*2.6*9 NARR
 I (^ABMDEXP(ABMMODE(8),0)["HCFA")!(^ABMDEXP(ABMMODE(8),0)["CMS") D
 .I $P(ABMX("X0"),"^",6)="" S ABME(122)=""
 .S ABMCODXS=$P(ABMX("X0"),U,6)
 .I ABMCODXS'="" D
 ..F ABMJ=1:1 S ABMCODX=$P(ABMCODXS,",",ABMJ) Q:+$G(ABMCODX)=0  D
 ...;start old abm*2.6*8 NOHEAT
 ...;I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") S ABME(217)=$G(ABME(217))_","_ABMX
 ...;I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))="") S ABME(217)=ABMX
 ...;end old start new
 ...;I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") S ABME(217)=$G(ABME(217))_","_ABMX("I")  ;abm*2.6*14 HEAT163747
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") Q:ABME(217)[(ABMX("I"))  S ABME(217)=$G(ABME(217))_","_ABMX("I")  ;abm*2.6*14 HEAT163747
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))="") S ABME(217)=ABMX("I")
 ...;end new
 I $P(ABMX("X0"),U,3)="" S ABME(123)=""
 I $P(ABMX("X0"),U,4)="" S ABME(126)=""
 I $P(ABMX("X0"),U,5)="" D
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,14)="",($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,16)="") S ABME(209)=""
 I $P($G(^DIC(40.7,ABMP("CLN"),0)),U,2)["A3" D
 .S ABMIEN=0
 .F  S ABMIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),47,ABMIEN)) Q:ABMIEN=""  D
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),47,ABMIEN,0)),U,5)="QL" S ABME(212)=""
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),47,ABMIEN,0)),U,8)="QL" S ABME(212)=""
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),47,ABMIEN,0)),U,9)="QL" S ABME(212)=""
 Q
