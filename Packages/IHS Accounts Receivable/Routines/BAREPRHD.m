BAREPRHD ; IHS/SD/LSL - Report Header Generator ; 07/28/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**35*;OCT 26, 2005;Build 187
 ;
 ;IHS/SD/SDR 1.8*35 ADO59950 New routine for PPR Emp Prod Report
 ;*********************************************************************
 ;
HD ;EP for setting Report Header
 S BAR("LVL")=0
 S BAR("TXT")=$S(BARY("RTYP","NM")["BRIEF":"Brief Listing",1:BARY("RTYP","NM")),BAR("CONJ")="" D CHK K BAR("TXT")
 I (($D(BARY("ALLPOST")))!($D(BARY("PTECH")))) D PTECH,CHK
 I ($D(BARY("TYP"))!$D(BARY("ACCT"))!$D(BARY("PAT"))) D BIL,CHK   ;Billing entity parameters and A/R Account
 I $D(BARY("ITYP")) D ITYP,CHK
 I $D(BARY("ALL")) D ALLOW,CHK
 D LOC      ;Location parameters
 D:$D(BARY("DT")) DT        ;Date parameters
 I (BARY("RTYP")=1) S BAR("CONJ")="" S BAR("TXT")="* - Denotes entries were posted using the ERA        " D CHK
 Q
 ;*******************************************************************
PTECH ;
 S BAR("CONJ")="for "
 I $D(BARY("ALLPOST"))!('$D(BARY("PTECH"))) S BAR("TXT")="ALL Posting Staff"
 I $D(BARY("PTECH")) D
 .S BARI=0
 .F  S BARI=$O(BARY("PTECH",BARI)) Q:'BARI  D
 ..I $G(BAR("TXT"))'="" S BAR("TXT")=BAR("TXT")_", "_$P($G(^VA(200,BARI,0)),U)
 ..E  S BAR("TXT")=$P($G(^VA(200,BARI,0)),U)
 Q
 ;
BIL ; EP
 ;Billing entity parameters
 S BAR("CONJ")="for "
 S BAR("TXT")="ALL"
 I $D(BARY("PAT")) S BAR("TXT")=$P(^DPT(BARY("PAT"),0),U) Q
 I $D(BARY("ACCT")) S BAR("TXT")=$G(BARY("ACCT","NM")) Q
 I $D(BARY("TYP")) S BAR("TXT")=BARY("TYP","NM")
 ;.I (BARY("TYP")["^R^") S BAR("TXT")="MEDICARE" Q
 ;.I (BARY("TYP")["^D^") S BAR("TXT")="MEDICAID" Q
 ;.I (BARY("TYP")["^W^") S BAR("TXT")="WORKMEN'S COMP" Q
 ;.I (BARY("TYP")["^H^M^P^F^W^") S BAR("TXT")="PRIVATE+WORKMEN'S COMP" Q
 ;.I (BARY("TYP")["^P^") S BAR("TXT")="PRIVATE INSURANCE" Q
 ;.I (BARY("TYP")["^N^") S BAR("TXT")="NON-BENEFICIARY PATIENTS" Q
 ;.I (BARY("TYP")["^I^") S BAR("TXT")="BENEFICIARY PATIENTS" Q
 ;.I (BARY("TYP")["^K^") S BAR("TXT")="CHIP" Q
 ;.I (BARY("TYP")["^V^") S BAR("TXT")="VETERANS" Q
 ;.I (BARY("TYP")["^G^") S BAR("TXT")="OTHER" Q
 ;.S BAR("TXT")="UNSPECIFIED"
 I '$D(BARY("TYP")) S BAR("TXT")="UNSPECIFIED"
 S BAR("TXT")=BAR("TXT")_" BILLING SOURCE(S)"
 Q
 ;*********************************************************************
 ;
ITYP ; EP
 S BAR("CONJ")="for "
 S BAR("TXT")="ALL"
 S:$D(BARY("ITYP")) BAR("TXT")=BARY("ITYP","NM")
 S BAR("TXT")=BAR("TXT")_" INSURER TYPE(S)"
 Q
 ;*********************************************************************
 ;
ALLOW ; EP
 ; Allowance Category Parameters
 S BAR("CONJ")="for "
 S BAR("TXT")="ALL"
 I $D(BARY("ALL")) D
 .I (BARY("ALL")="R") S BAR("TXT")="MEDICARE" Q
 .I (BARY("ALL")="D") S BAR("TXT")="MEDICAID" Q
 .I (BARY("ALL")="P") S BAR("TXT")="PRIVATE INSURANCE" Q
 .I (BARY("ALL")="V") S BAR("TXT")="VETERANS" Q
 .I (BARY("ALL")="O") S BAR("TXT")="OTHER" Q
 .S BAR("TXT")="OTHER"
 S BAR("TXT")=BAR("TXT")_" ALLOWANCE CATEGORY(S)"
 S BAR("TXT")=BAR("TXT")_$$TEXTCK^BARDRST()   ;formatting if delimited file
 Q
 ;
 ;*********************************************************************
LOC ; EP
 ; Location
 I $D(BARY("LOC")) S BAR("TXT")=$P(^DIC(4,BARY("LOC"),0),U)
 E  S BAR("TXT")="ALL"
 I BAR("LOC")="BILLING" D
 .S BAR("TXT")=BAR("TXT")_" Visit location under "
 .S BAR("TXT")=BAR("TXT")_$P(^DIC(4,DUZ(2),0),U)
 .S BAR("TXT")=BAR("TXT")_" Billing Location"
 E  S BAR("TXT")=BAR("TXT")_" Visit location regardless of Billing Location"
 S BAR("CONJ")="at "
 D CHK
 Q
 ;*********************************************************************
 ;
DT ; EP
 ;Date
 S BAR("CONJ")="with "
 I BARY("DT")="A" S BAR("TXT")="ACTIVITY DATES"
 D CHK
 S BAR("CONJ")="from "
 S BAR("TXT")=$$SDT^BARDUTL(BARY("DT",1))
 D CHK
 S BAR("CONJ")="to "
 S BAR("TXT")=$$SDT^BARDUTL(BARY("DT",2))
 D CHK
 Q
 ;*********************************************************************
 ;
XIT ;
 K BAR("CONJ"),BAR("TXT"),BAR("LVL")
 Q
 ;*********************************************************************
 ;
CHK ; EP
 I ($L(BAR("HD",BAR("LVL")))+1+$L(BAR("CONJ"))+$L(BAR("TXT")))<($S($D(BAR(132)):104,1:52)+$S(BAR("LVL")>0:28,1:0)) D
 .S BAR("HD",BAR("LVL"))=BAR("HD",BAR("LVL"))_" "_BAR("CONJ")_BAR("TXT")
 .Q
 E  S BAR("LVL")=BAR("LVL")+1,BAR("HD",BAR("LVL"))=BAR("CONJ")_BAR("TXT")_$$TEXTCK^BARDRST()
 ;S BAR("LVL")=BAR("LVL")+1
 Q
 ;*********************************************************************
 ;
WHD ;EP for writing Report Header
 W $$EN^BARVDF("IOF"),!     ;not a delimited file
 K BAR("LINE")
 S $P(BAR("LINE"),"=",$S($D(BAR(133)):132,$D(BAR(180)):181,1:81))=""
 W BAR("LINE"),!
 I $G(BARTEXT)'=1 W BAR("HD",0),?$S($D(BAR(132)):102,$D(BAR(180)):150,1:51)
 I $G(BARTEXT)=1 W BAR("HD",0),"^^^^"
 D NOW^%DTC
 S Y=%
 X ^DD("DD")
 W $P(Y,":",1,2),"   Page ",BAR("PG")
 I $G(BARTEXT)=1 W "^"
 S BAR("TMPLVL")=0
 F  S BAR("TMPLVL")=$O(BAR("HD",BAR("TMPLVL"))) Q:'BAR("TMPLVL")&(BAR("TMPLVL")'=0)  W:$G(BAR("HD",BAR("TMPLVL")))]"" !,BAR("HD",BAR("TMPLVL"))
 W !,BAR("LINE")
 K BAR("LINE")
 Q
 ;*********************************************************************
 ;EOR
