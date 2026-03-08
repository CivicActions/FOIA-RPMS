BDWCOVAD ;ihs/cmi/maw - BDW COVID ADT Data
 ;;1.0;IHS DATA WAREHOUSE;**7**;JAN 23, 2006;Build 65
 ;
 Q
 ;
FT() ;-- get the facility type
 Q $S($O(^DGPM("B",""),-1)>3200101:"HOSPITAL",1:"HEALTH CENTER")
 ;
AUTHBEDS ;-- get the authorized beds
 ; this is for the ZHB segment
 ; BDWBED("ICU")=ICU BEDS
 ; BDWBED("ALL")=ALL BEDS
 S BDWBED("ICU")=0
 S BDWBED("ALL")=0
 S BDGED=DT-1
 D NEWAUTH^BDGM202A
 S BDWBED("ICU")=+$G(DGBED("IC"))
 S BDWBED("ALL")=$$CNTBED(.DGBED)
 S BDW("AUTH")=BDWBED("ALL")_U_BDWBED("ICU")
 S BDW("AUTHT")=BDWBED("ALL")+BDWBED("ICU")
 Q
 ;
CNTBED(BED) ;-- count all beds authorized
 N BDWDA,BCNT,TCNT
 S TCNT=0
 S BDWDA=0 F  S BDWDA=$O(BED(BDWDA)) Q:BDWDA=""  D
 . S BCNT=$G(BED(BDWDA))
 . S TCNT=TCNT+BCNT
 Q $G(TCNT)
 ;
CHKBED(DATE) ;-- lets loop through AMV1 from Jan 1 and see who is still on ward at DATE
 N BD,ED,PT,DIEN,DSCM,DDT,LTXN,WD,BED
 K BEDU,COVC
 S BEDU("OTH")=0
 S BEDU("IC")=0
 S BEDC("OTH")=0
 S BEDC("IC")=0
 S BEDU("TOT")=0
 S BEDC("TOT")=0
 S ED=DATE+.999999
 S BD=3160101  ;for testing
 ;S BD=3200101
 F  S BD=$O(^DGPM("AMV1",BD)) Q:BD>ED!('$G(BD))  D
 . S PT=0 F  S PT=$O(^DGPM("AMV1",BD,PT)) Q:'PT  D
 ..I $$DEMO^BDWHUTL(PT,"E") Q
 .. S DIEN=0 F  S DIEN=$O(^DGPM("AMV1",BD,PT,DIEN)) Q:'DIEN  D
 ... S DSCM=$P($G(^DGPM(DIEN,0)),U,17)
 ... I DSCM S DDT=$P($G(^DGPM(DSCM,0)),U)
 ... I DSCM Q:DDT<DATE  ;not an inpatient on that date
 ... ;lets find the last transaction for this patient so we can determine the bed
 ... S LTXN=+$$LASTTXN^BDGF1(DIEN,PT)
 ... ;if last txn is a transfer get that bed, if not then get the bed from the admission which is DIEN
 ... I LTXN,$P($G(^DGPM(LTXN,0)),U,2)=2 D  Q
 .... S WD=$P($G(^DGPM(LTXN,0)),U,6)
 .... D WARD(WD,PT,DATE)
 ... S WD=$P($G(^DGPM(DIEN,0)),U,6)
 ... D WARD(WD,PT,DATE)
 S BDW("BEDOCC")=BEDU("OTH")_U_BEDU("IC")
 S BDW("BEDCOV")=BEDC("OTH")_U_BEDC("IC")
 S BDW("BEDOCCT")=BEDU("OTH")+BEDU("IC")
 S BDW("BEDCOVT")=BEDC("OTH")+BEDC("IC")
 S BDW("BEDOPEN")=BDW("AUTHT")-BDW("BEDOCCT")
 S BDW("BEDICUOPEN")=BDWBED("ICU")-BEDU("IC")
 Q
 ;
WARD(WD,PAT,ED) ;-- get if this bed is ICU or not
 N IEN,NODE,TYPE,COVP,DATE
 Q:$G(WD)=""
 S HL=+$G(^DIC(42,WD,44))
 I HL,$P($G(^SC(HL,0)),U,19)="N" Q  ;dont count wards not at this facility
 S IEN=0 F  S IEN=$O(^BDGWD(WD,2,IEN)) Q:'IEN  D
 . S NODE=$G(^BDGWD(WD,2,IEN,0))
 . S DATE=$P(NODE,U) Q:DATE>ED
 . S TYPE=$P(NODE,U,2)
 . I TYPE'="IC" S TYPE="OTH"
 . Q:$D(BEDU(TYPE,PAT))  ;dont count patient twice
 . S BEDU(TYPE,PAT)=""  ;dont count patient twice
 . S BEDU(TYPE)=BEDU(TYPE)+1
 . S COVP=$$COVPOS^BDWCOV1(PAT,ED,"")  ;lori this needs to be updated for a date
 . I COVP D
 .. Q:$D(BDWCOVP(PAT))  ;dont count patient twice
 .. S BDWCOVP(PAT)=1  ;dont count patient twice
 .. S BEDC(TYPE)=BEDC(TYPE)+1
 Q
 ;
DISC(ED) ;-- lets get the discharges for the day and see who is covid positive
 ; this is data for the ZPD segment
 ; DTYP("TRANSFER") = PATIENTS TRANSFERRED OUT
 ; DTYP("DEATH") = PATIENTS EXPIRED
 ; DTYP("DISCHARGE") = ALL OTHER DISCHARGES
 S DTYP("TRANSFER")=0
 S DTYP("DEATH")=0
 S DTYP("DISCHARGE")=0
 N DIS,BD,PAT
 S BD=ED-.0001
 S ED=ED+.9999
 S DIS=BD F  S DIS=$O(^AUPNVINP("B",DIS)) Q:DIS>ED!('$G(DIS))  D
 . S DIEN=0 F  S DIEN=$O(^AUPNVINP("B",DIS,DIEN)) Q:'DIEN  D
 .. S PAT=$P($G(^AUPNVINP(DIEN,0)),U,2)
 .. I $$DEMO^BDWHUTL(PAT,"E") Q
 .. I PAT,$$COVPOS^BDWCOV1(PAT,ED,1) D
 ... S DTYP=$$GET1^DIQ(9000010.02,DIEN,.06)
 ... I DTYP["TRANSFER" D  Q
 .... S DTYP("TRANSFER")=DTYP("TRANSFER")+1
 ... I DTYP["DEATH" D  Q
 .... S DTYP("DEATH")=DTYP("DEATH")+1
 ... S DTYP("DISCHARGE")=DTYP("DISCHARGE")+1
 ;now get expired from er
 N ER,ERI,EPT
 S ER=BD F  S ER=$O(^AMERVSIT("B",ER)) Q:ER>ED!('$G(ER))  D
 . S ERI=0 F  S ERI=$O(^AMERVSIT("B",ER,ERI)) Q:'ERI  D
 .. S EPT=$P($G(^AMERVSIT(ERI,0)),U,2)
 .. I $$DEMO^BDWHUTL(EPT,"E") Q
 .. Q:'$P($G(^AMERVSIT(ERI,6)),U)
 .. I $$GET1^DIQ(9009080,ERI,6.1)="EXPIRED" D
 ... S DTYP("DEATH")=DTYP("DEATH")+1
 .. I $$GET1^DIQ(9009080,ERI,6.1)="DEATH" D
 ... S DTYP("DEATH")=DTYP("DEATH")+1
 Q
 ;
SET ;-- set variables for export
 S BDWZHB=BDW("AUTHT")_U_BDW("BEDOCCT")_U_BDW("BEDOPEN")
 S BDWZIC=BDWBED("ICU")_U_BEDU("IC")_U_BDW("BEDICUOPEN")
 S BDWZCP=BDW("BEDCOVT")_U_BEDC("IC")
 S BDWZPD=DTYP("DISCHARGE")_U_DTYP("TRANSFER")_U_DTYP("DEATH")
 Q
 ;
