BAREMPCK ; IHS/SD/SDR - Employee Productivity Report Utility to Check Parms ;  
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**35**;OCT 26, 2005;Build 187
 ;Original;SDR
 ;IHS/SD/SDR 1.8*35 ADO59950 New routine for new employee productivity report
 ;
LOOP ;Loop thru transaction file
 I $D(BARY("DT")) D
 .I +$P(BARY("DT",1),".",2)'=0 S BARP("DT",1)=(BARY("DT",1)-.0001)_99
 .E  S BARP("DT",1)=(BARY("DT",1)-.000001)
 .I +$P(BARY("DT",2),".",2)'=0 S BARP("DT",2)=BARY("DT",2)_"99"
 .E  S BARP("DT",2)=(BARY("DT",2)+.999999)
 I '$D(BARY("DT")) S BARP("DT",1)=0,BARP("DT",2)=99999999999999999
 ;
 ;This next section finds BENEFICIARY PATIENT and NON-BENEFICIARY PATIENT (INDIAN) in case of a PATIENT MESSAGE that doesn't have an A/R Account.
 ;We will use the appropriate A/R Account so the message is counted this way since there is no A/R Bill so no A/R Account
 S BARBEN=$O(^AUTNINS("B","BENEFICIARY PATIENT (INDIAN)",0))
 S BARBEN=$O(^BARAC(DUZ(2),"B",BARBEN_";AUTNINS(",0))
 S BARNONB=$O(^AUTNINS("B","NON-BENEFICIARY PATIENT",0))
 S BARNONB=$O(^BARAC(DUZ(2),"B",BARNONB_";AUTNINS(",0))
 ;
 ;loop thru transactions
 F  S BARP("DT",1)=$O(^BARTR(DUZ(2),"C",BARP("DT",1))) Q:((+$G(BARP("DT",1))=0)!(BARP("DT",1)>BARP("DT",2)))  D
 .S BARTR=0
 .F  S BARTR=$O(^BARTR(DUZ(2),"C",BARP("DT",1),BARTR)) Q:'BARTR  D TRANS
 Q
 ; 
TRANS ;
 ;
 D DOTS
 K BARTR(0),BARTR(1),BARTMP,BARTR("TYP"),BARTR("ITYP"),BARTR("ALL"),BARTR("TTYP"),BARTR("PAT"),BARTR("PTECH"),BARTR("ADJ CAT"),BARTR("ADJ TYPE")
 K BARTR("ACCT"),BARTR("AR")
 ;
 S BARP("HIT")=0
 S:$G(BAR("SUBR"))="" BAR("SUBR")=$S($G(BAR("RTN"))'="":BAR("RTN"),1:"UNKNOWN CALL")
 I '$D(^BARTR(DUZ(2),BARTR,0)) Q
 S BARTR(0)=$G(^BARTR(DUZ(2),BARTR,0))  ;A/R Transaction 0 node
 S BARTR(1)=$G(^BARTR(DUZ(2),BARTR,1))  ;A/R Transaction 1 node
 ;
 S BARTR("T")=$P(BARTR(1),U)            ;Transaction type
 I ((+BARTR("T")=0)&(+$P(BARTR(0),U,7)=0)) Q  ;No transaction type and not a message - QUIT
 I "^49^108^115^117^"[("^"_BARTR("T")_"^") Q  ;skip these - BILL NEW, 3P CREDIT, COL BAT TO ACC POST and COL BAT TO FACILITY
 ;
 I $P(BARTR(0),U,7)=1 K BARTMP S BARTMP=$$GET1^DIQ(90050.03,BARTR,1001,"I","BARTMP")
 I $P(BARTR(0),U,7)=1 I (($G(BARTMP(1))["GCN:")!($G(BARTMP(1))["Upload")) Q  ;messages from export and updated bills - skip them
 ;
 S BARTR("DATA SRC")=$S($P(BARTR(1),U,6)'="":$P(BARTR(1),U,6),1:"m")  ;A/R Transaction DATA SOURCE (e=ERA posted)
 S BARTR("CR-DB")=$$GET1^DIQ(90050.03,BARTR,3.5)
 S BAR=$P(BARTR(0),U,4)              ;A/R Bill IEN
 K BAR(0),BAR(1)
 I +BAR,$D(^BARBL(DUZ(2),BAR)) D
 .S BAR(0)=$G(^BARBL(DUZ(2),BAR,0))  ;A/R Bill 0 node
 .S BAR(1)=$G(^BARBL(DUZ(2),BAR,1))  ;A/R Bill 1 node
 K BAR("QUIT")
 S BARTR("I")=$P(BARTR(0),U,6)       ;A/R Account
 I (($P(BARTR(0),U,7)=1)&(+BARTR("I")=0)) S BARTR("I")=$P($G(BAR(0)),U,3)  ;there's no A/R Account on the message transaction so use one from A/R Bill
 S BARTR("L")=$P(BARTR(0),U,11)      ;Visit location
 I +BARTR("L")=0 S BARTR("L")=$P(BARTR(0),U,8)  ;use parent loc if visit loc is blank/bad
 S BARTMP=BARTR("I")
 S BARTR("TTYP")=$P(BARTR(1),U)  ;transaction type
 ;
 S BARTR("PAT")=$P(BARTR(0),U,5)  ;patient
 I $D(BARY("PAT")),BARTR("PAT")'=BARY("PAT") Q
 ;
 S BARTR("AR")=$P(BARTR(0),U,13)        ;Entry by (AR Clerk)
 S:BARTR("AR")="" BARTR("AR")=9999999
 I $D(BARY("PTECH")),'$D(BARY("PTECH",BARTR("AR"))) Q       ;Not chosen AR Clerk
 ;
 S BARTR("ADJ CAT")=$P(BARTR(1),U,2)    ;Adjustment Category
 S BARTR("ADJ TYPE")=$P(BARTR(1),U,3)   ;Adjustment Type
 S:BARTR("T")="" BARTR("T")="NULL"
 S:BARTR("ADJ CAT")="" BARTR("ADJ CAT")="NULL"
 S:BARTR("ADJ TYPE")="" BARTR("ADJ TYPE")="NULL"
 ;
 S BARTR("BIA FLG")=1  ;this will get set to 1 if billing entity, insurer type or allowance category match the selection
 ;
 ;A/R Account check
 ;
 S BARTR("ACCT")=$$GET1^DIQ(90050.03,BARTR,6,"I")
 I BARTR("ACCT")="" S BARTR("ACCT")=$$GET1^DIQ(90050.01,BAR,3,"I")
 ;
 ;If there is no A/R Account (because there's no A/R Bill, like on a patient message
 I +$G(BARTR("ACCT"))=0 D
 .Q:$P(BARTR(0),U,7)'=1  ;only message transactions
 .I $P($G(^AUPNPAT(BARTR("PAT"),11)),U,12)="I" S BARTR("ACCT")=BARNONB,(BARTR("TYP"),BARTR("ITYP"))="N"
 .I $P($G(^AUPNPAT(BARTR("PAT"),11)),U,12)'="I" S BARTR("ACCT")=BARBEN,(BARTR("TYP"),BARTR("ITYP"))="I"
 ;
 I ($D(BARY("ACCT"))&($G(BARY("ACCT"))'=BARTR("ACCT"))) S BARTR("BIA FLG")=0
 ;
 ;billing entity check
 S BARTR("TYP")=""
 S (D0,BARTMP)=BARTR("ACCT")
 ;I $G(BAR(0))'="" S BARTR("TYP")=$P($G(^ABMDBILL($P(BAR(0),U,22),$P(BAR(0),U,17),2)),U,2)
 I $G(BAR(0))'="" S BARTPDUZ=$P(BAR(0),U,22),BARTPIEN=$P(BAR(0),U,17)
 I ((+$G(BARTPDUZ))&(+$G(BARTPIEN))) S BARTR("TYP")=$P($G(^ABMDBILL(BARTPDUZ,BARTPIEN,2)),U,2)
 I $G(BAR(0))="" D
 .Q:$P(BARTR(0),U,7)'=1  ;only message transactions
 .I +$G(BARTR("ACCT"))'=0 Q:($P($G(^BARAC(DUZ(2),BARTR("ACCT"),0)),U)'["AUTNINS")  ;make sure it is an Insurer entry
 I +$G(BARTR("ACCT"))'=0 D
 .S BARTR("TYP")=$$GET1^DIQ(90050.02,BARTR("ACCT"),1.08,"I")
 .I ($G(BARTR("TYP"))'="") S BARTR("TYP")=$O(^AUTTINTY("B",BARTR("TYP"),0))
 .I +BARTR("TYP")'=0 S (BARTR("TYP"),BARTR("ITYP"))=$P($G(^AUTTINTY(BARTR("TYP"),0)),U,2)
 ;
 I $G(BARTR("TYP"))=""  S BARTR("TYP")="No Billing Entity"
 I BARTR("TYP")'="No Billing Entity" D
 .S BARTR("ALL")="O"                                               ;Other Allow Cat
 .I ",R,MH,MD,MC,MMC,"[(","_BARTR("TYP")_",") S BARTR("ALL")="R" Q  ;MCR 
 .I ",D,K,FPL,"[(","_BARTR("TYP")_",") S BARTR("ALL")="D" Q         ;MCD 
 .I ",F,M,H,P,"[(","_BARTR("TYP")_",") S BARTR("ALL")="P" Q         ;Private
 .I ",V,"[(","_BARTR("TYP")_",") S BARTR("ALL")="V" Q               ;VETERANS
 I ((BARTR("TYP")'="No Billing Entity")&$D(BARY("TYP"))&($G(BARY("TYP"))'[("^"_BARTR("TYP")_"^"))) S BARTR("BIA FLG")=0
 ;
 ;insurer type
 S BARTR("ITYP")=""
 S BARTR("ITYP")=$S(($G(BARTR("TYP"))'=""&(BARTR("TYP")'["No Billing")):BARTR("TYP"),1:"")
 I $D(BARY("ITYP")),BARTR("ITYP")'=BARY("ITYP") S BARTR("BIA FLG")=0
 ;
 ;allowance category
 I $G(BARTR("ALL"))=""  S BARTR("ALL")="No Allowance Category"
 I $D(BARY("ALL")),(+BARY("ALL")=BARY("ALL")) S BARY("ALL")=$$CONVERT^BARRSL2(BARY("ALL"))
 I $D(BARY("ALL")),BARY("ALL")'=BARTR("ALL") S BARTR("BIA FLG")=0
 ;
 I BARTR("BIA FLG")=0 Q  ;it wasn't out BENT/ITYP/ALLC
 ;
 S BARTR("DT")=$P(BARTR(0),U,18)
 K BAR("QUIT")
 ;
 I +BARTR("L")=0 S BARTR("L")=DUZ(2)  ;default to parent location if no visit location on transaction
 ;
 I $D(BARY("LOC")),BARY("LOC")'=BARTR("L") Q      ;Not chosen location
 I $D(BARY("ARACCT")),'$D(BARY("ARACCT",BARTR("I"))) Q  ;Not chosn acct
 I $D(BARY("ACCT")),BARY("ACCT")'=BARTR("I") Q    ;Not chosen A/R acct
 ;
 ;
 S (BARTR("ADBT"),BARTR("ADBTAMT"),BARTR("ACRDT"),BARTR("ACRDTAMT"),BARTR("MSG"),BARTR("UNALC"),BARTR("UNALCAMT"),BARTR("RFND"),BARTR("RFNDAMT"),BARTR("PMT"),BARTR("PMTAMT"))=""
 S (BARTR("PSCDBT"),BARTR("PSCCRDT"),BARTR("PSCDBTAMT"),BARTR("PSCCRDTAMT"),BARTR("RMKCD"))=""
 ;pymt
 I (BARTR("TTYP")=40) D
 .S BARTR("PMTAMT")=$$GET1^DIQ(90050.03,BARTR,"3.5")
 .I BARTR("PMTAMT")'="" S BARTR("PMT")=1
 ;adjustments
 I (BARTR("TTYP")=43) D
 .S BARTR("ACRDTAMT")=$$GET1^DIQ(90050.03,BARTR,2)
 .S BARTR("ADBTAMT")=$$GET1^DIQ(90050.03,BARTR,3)
 .I (($G(BARTR("ACRDTAMT"))'="")&((BARTR("ADBTAMT")="")!(BARTR("ADBTAMT")=0))) S BARTR("ACRDT")=1
 .I (($G(BARTR("ADBTAMT"))'="")&((BARTR("ACRDTAMT")="")!(BARTR("ACRDTAMT")=0))) S BARTR("ADBT")=1
 ;post status changes (PSCs)
 I (BARTR("TTYP")=993) D
 .S BARTR("PSCCRDTAMT")=$$GET1^DIQ(90050.03,BARTR,2)
 .S BARTR("PSCDBTAMT")=$$GET1^DIQ(90050.03,BARTR,3)
 .I (($G(BARTR("PSCCRDTAMT"))'="")&((BARTR("PSCDBTAMT")="")!(BARTR("PSCDBTAMT")=0))) S BARTR("PSCCRDT")=1
 .I (($G(BARTR("PSCDBTAMT"))'="")&((BARTR("PSCCRDTAMT")="")!(BARTR("PSCCRDTAMT")=0))) S BARTR("PSCDBT")=1
 ;unallocated
 I (BARTR("TTYP")=100) D
 .S BARTR("UNALCAMT")=$$GET1^DIQ(90050.03,BARTR,2)
 .I $G(BARTR("UNALCAMT"))'="" S BARTR("UNALC")=1
 ;refunds
 I (BARTR("TTYP")=39) D
 .S BARTR("RFNDAMT")=$$GET1^DIQ(90050.03,BARTR,3)
 .I $G(BARTR("RFNDAMT"))'="" S BARTR("RFND")=1
 ;messages
 I ($P(BARTR(0),U,7)=1) Q:($G(BARTMP(1))="")  ;it says message but there's no text - not complete entry
 I ($P(BARTR(0),U,7)=1) I ((BARTMP(1)'["GCN:")&(BARTMP(1)'["Upload")) S BARTR("MSG")=$P(BARTR(0),U,7)  ;skip GCN msgs and Upload msgs
 ;remark codes
 I (BARTR("TTYP")=505) D
 .S BARTR("RMKCD")=1
 ;
 D DATA^BAREMPPR
 Q
GETBI(D0) ;keep D0 intact
 I D0="" Q ""
 Q $$VALI^BARVPM(8)   ;Insurer Type CODE
 ;
 ;EOR
 ;
DOTS ;
 S BARCNT=+$G(BARCNT)+1
 I BARCNT=1 U IO(0) W !
 I (BARCNT#1000000&(IOST["C")) U IO(0) W "."
 ;
 Q
