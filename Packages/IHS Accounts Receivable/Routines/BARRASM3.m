BARRASM3 ; IHS/SD/LSL - Age Summary Report Print Logic ;7/28/2020
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**7,28,30**;OCT 26, 2005;Build 55
 ;COPIED FROM BARRASM2
 ;BAR*1.8*30 CR4968 - MODIFY UFMS REPORT SUMMARIZED BY BILL W/IN PAYER W/IN ALLOW CAT
 ;
 Q
 ; *********************************************************************
PRINT ; EP
 ; Print reports
 F I=1:1:6 K BAR(I)
 K BAR("SUB0")
 K BAR("SUB1"),BAR("SUB2"),BAR("SUB3"),BARTMP,BARTMPS,BARTMPS2,BARNAME
 S BAR("PG")=0
 S BARDASH="                    --------- --------- --------- --------- --------- ----------"
 S BAREQUAL="                    ========= ========= ========= ========= ========= =========="
 S:$G(BARY("RTYP"))'=3 BAR("COL")="W !,BARY(""STCR"",""NM""),?22,""CURRENT"",?34,""31-60"",?44,""61-90"",?53,""91-120"",?65,""120+"",?73,""BALANCE"""
 S:$G(BARY("RTYP"))=3 BAR("COL")="W !,BARY(""STCR"",""NM""),!,?3,""UFMS INVOICE NUMBER"",?30,""RPMS BILL NUMBER"",?52,""BALANCE"",?65,""CATEGORY"""
 I ",1,2,3,4,"[(","_BARY("STCR")_",") D STANDARD
 Q:$G(BAR("F1"))
 I $G(BARY("RTYP"))=1 D SUMMARY
 Q:$G(BAR("F1"))
 I $G(BARY("RTYP"))=2 D DETAIL
 Q:$G(BAR("F1"))
 I $G(BARY("RTYP"))=3 D BILL
 Q:$G(BAR("F1"))
 Q
 ; *********************************************************************
 ;
STANDARD ;
 ; Print report if user selected SORT CRITERIA a/r account, visit, or
 ; clinic
 ;
 D HDB                                     ; Page and column header
 I '$D(^TMP($J,"BAR-ASM")) D  Q           ; No data - quit
 .W !!!!!?25,"*** NO DATA TO PRINT ***"
 .;D EOP^BARUTL(0)  ;bar*1.8*28 IHS/SD/SDR CR8350 HEAT295594 -NOW WANT PAUSE IHS/DIT/CPC - 20180502 CR8350
 .I '$D(BARA),(XQY0'["UFMS") D EOP^BARUTL(0)  ;bar*1.8*28 IHS/SD/SDR CR8350 HEAT295594 -NOW WANT PAUSE IHS/DIT/CPC - 20180502 CR8350
 S BARHOLD("SUB0")=$O(^TMP($J,"BAR-ASM",""))
 S BAR("SUB0")=""
 F  S BAR("SUB0")=$O(^TMP($J,"BAR-ASM",BAR("SUB0"))) Q:BAR("SUB0")=""  D  Q:$G(BAR("F1"))
 .I BARHOLD("SUB0")'=BAR("SUB0") D HD
 .Q:$G(BAR("F1"))
 .S BARHOLD("SUB0")=BAR("SUB0")
 .I '$D(BARY("LOC")) W !,"*** VISIT Location: ",BAR("SUB0"),!
 .S BAR("SUB1")=""
 .F  S BAR("SUB1")=$O(^TMP($J,"BAR-ASM",BAR("SUB0"),BAR("SUB1"))) Q:BAR("SUB1")=""  D  Q:$G(BAR("F1"))
 ..I $Y>(IOSL-5),'$D(BARA),(XQY0'["UFMS") D EOP^BARUTL(0) D HD Q:$G(BAR("F1"))    ;-NO PAUSE IHS/DIT/CPC - 20180502 CR8350
 ..S BARTMP=$G(^TMP($J,"BAR-ASM",BAR("SUB0"),BAR("SUB1")))
 ..S BARTMP2=$G(^TMP($J,"BAR-ASMC",BAR("SUB0"),BAR("SUB1")))
 ..S BARNAME=BAR("SUB1")
 ..W !,$E(BARNAME,1,19)            ; clinic/vis typ/A/R acct/discharge svc
 ..W ?20,$J($P(BARTMP,U),9,2)      ; CURRENT
 ..W ?30,$J($P(BARTMP,U,2),9,2)    ; 31-60
 ..W ?40,$J($P(BARTMP,U,3),9,2)    ; 61-90
 ..W ?50,$J($P(BARTMP,U,4),9,2)    ; 90-120
 ..W ?60,$J($P(BARTMP,U,5),9,2)    ; 120+
 ..W ?70,$J($P(BARTMP,U,6),10,2)   ; BALANCE
 ..W !
 ..D CNTW^BARRASMC  ;LIST COUNTS
 .;
 .; Visit Location Totals
 .Q:$G(BAR("F1"))
 .W !,BARDASH
 .S BARTMP=$G(^TMP($J,"BAR-ASM",BAR("SUB0")))
 .S BARTMP2=$G(^TMP($J,"BAR-ASMC",BAR("SUB0")))
 .W !,"*** VISIT loc Total"
 .W ?20,$J($P(BARTMP,U),9,2)      ; CURRENT
 .W ?30,$J($P(BARTMP,U,2),9,2)     ; 31-60
 .W ?40,$J($P(BARTMP,U,3),9,2)     ; 61-90
 .W ?50,$J($P(BARTMP,U,4),9,2)     ; 90-120
 .W ?60,$J($P(BARTMP,U,5),9,2)     ; 120+
 .W ?70,$J($P(BARTMP,U,6),10,2)    ; BALANCE
 .W !
 .D CNTW^BARRASMC
 Q:$G(BAR("F1"))
 ;
 ; Report Totals
 W !,BAREQUAL
 S BARTMP=$G(^TMP($J,"BAR-ASM"))
 S BARTMP2=$G(^TMP($J,"BAR-ASMC"))
 W !,"*** Report Total"
 W !?20,$J($P(BARTMP,U),9,2)       ; CURRENT
 W ?30,$J($P(BARTMP,U,2),9,2)      ; 31-60
 W ?40,$J($P(BARTMP,U,3),9,2)      ; 61-90
 W ?50,$J($P(BARTMP,U,4),9,2)      ; 90-120
 W ?60,$J($P(BARTMP,U,5),9,2)      ; 120+
 W ?70,$J($P(BARTMP,U,6),10,2)     ; BALANCE
 W !
 D CNTW^BARRASMC
 ;D EOP^BARUTL(0) ;-NOW WANT PAUSE IHS/DIT/CPC - 20180502 CR8350
 I '$D(BARA),(XQY0'["UFMS") D EOP^BARUTL(0)  ;If not USM Pause IHS/DIT/CPC - 20180502 BAR*1.8*28 CR8350
 Q
 ; *********************************************************************
 ;
SUMMARY ;
 ; Print report if user selected SORT CRITERIA Billing Entity or
 ; Allowance Category and Report Type w/o payers
 ;
 D HDB                             ; Page and column header
 I '$D(^TMP($J,"BAR-ASMT")) D  Q           ; No data - quit
 .W !!!!!?25,"*** NO DATA TO PRINT ***"
 .;D EOP^BARUTL(0)  ;bar*1.8*28 IHS/SD/SDR CR8350 HEAT295594  -NOW WANT PAUSE IHS/DIT/CPC - 20180502 CR8350
 .I '$D(BARA),(XQY0'["UFMS") D EOP^BARUTL(0)  ;bar*1.8*28 IHS/SD/SDR CR8350 HEAT295594 -NOW WANT PAUSE IHS/DIT/CPC - 20180502 CR8350
 S BARHOLD("SUB0")=$O(^TMP($J,"BAR-ASMT",""))
 S BAR("SUB0")=""
 F  S BAR("SUB0")=$O(^TMP($J,"BAR-ASMT",BAR("SUB0"))) Q:BAR("SUB0")=""  D  Q:$G(BAR("F1"))
 .I BAR("SUB0")'=BARHOLD("SUB0") D HD
 .Q:$G(BAR("F1"))
 .S BARHOLD("SUB0")=BAR("SUB0")
 .I '$D(BARY("LOC")) W !,"*** VISIT Location: ",BAR("SUB0"),!
 .S BAR("SUB1")=""
 .F  S BAR("SUB1")=$O(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1"))) Q:BAR("SUB1")=""  D  Q:$G(BAR("F1"))
 ..I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 ..S BARTMP=$G(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1")))
 ..W !,$E(BAR("SUB1"),1,19)        ; Billing Entity/Allowance Category/Insurer Type
 ..D SUM2
 ..S BARTMP=$G(^TMP($J,"BAR-ASMC",BAR("SUB0"),BAR("SUB1"))) W !,$E("# of Claims",1,19)  ; /IHS/BEM/RAM - 10 JUN 14- SUM CLAIM #'S
 ..D SUM3^BARRASMC  W ! ; /IHS/BEM/RAM - 10 JUN 14- SUM CLAIM #'S
 .Q:$G(BAR("F1"))
 .S BARTMP=$G(^TMP($J,"BAR-ASMT",BAR("SUB0")))
 .W !,BARDASH,!,"*** VISIT Loc Total"
 .D SUM2
 .S BARTMP=$G(^TMP($J,"BAR-ASMC",BAR("SUB0"))) W !,$E("# of Claims",1,19) ; /IHS/BAO/RAM - 10 JUN 14- PRINT CLAIM #'S
 .D SUM3^BARRASMC  W ! ; /IHS/BEM/RAM - 10 JUN 14- SUM CLAIM #'S
 Q:$G(BAR("F1"))
 W !
 D TOTAL                           ; Report Totals
 D TOTAL3^BARRASMC            ; /IHS/BEM/RAM - 10 JUN 14 ; Report Claim # Totals
 ;I BARY("STCR")=5,'$D(BARY("ALL")) D ASM^BAREISS  ;bar*1.8*28 IHS/SD/SDR CR8350 HEAT295594
 I BARY("STCR")=5,'$D(BARY("ALL")),'$D(BARA) D ASM^BAREISS  ;BARA is defined in the USM report; if started there, it shouldn't run the EISS report  ;bar*1.8*28 IHS/SD/SDR CR8350 HEAT295594
 ;D EOP^BARUTL(0)  ;bar*1.8*28 IHS/SD/SDR CR8350 HEAT295594 -NOW WANT PAUSE IHS/DIT/CPC - 20180502 CR8350
 I '$D(BARA),(XQY0'["UFMS") D EOP^BARUTL(0)  ;If not USM Pause IHS/DIT/CPC - 20180502 BAR*1.8*28 CR8350
 Q
 ; *********************************************************************
 ;
DETAIL ;
 ; Print report if user selected SORT CRITERIA Billing Entity or
 ; Allowance Category and Report Type with payers
 ;
 D HDB                               ; Page and column header
 I '$D(^TMP($J,"BAR-ASMT")) D  Q           ; No data - quit
 .W !!!!!?25,"*** NO DATA TO PRINT ***"
 .;D EOP^BARUTL(0)  ;bar*1.8*28 IHS/SD/SDR CR8350 HEAT295594 -NOW WANT PAUSE IHS/DIT/CPC - 20180502 CR8350
 .I '$D(BARA),(XQY0'["UFMS") D EOP^BARUTL(0) D EOP^BARUTL(0)  ;bar*1.8*28 IHS/SD/SDR CR8350 HEAT295594 -NOW WANT PAUSE IHS/DIT/CPC - 20180502 CR8350
 ;
 S BARHOLD("SUB0")=$O(^TMP($J,"BAR-ASMT",""))
 S BAR("SUB0")=""
 F  S BAR("SUB0")=$O(^TMP($J,"BAR-ASMT",BAR("SUB0"))) Q:BAR("SUB0")=""  D  Q:$G(BAR("F1"))
 .I BAR("SUB0")'=BARHOLD("SUB0") D HD
 .Q:$G(BAR("F1"))
 .S BARHOLD("SUB0")=BAR("SUB0")
 .I '$D(BARY("LOC")) W !,"*** VISIT Location: ",BAR("SUB0"),!
 .S BAR("SUB1")=""
 .F  S BAR("SUB1")=$O(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1"))) Q:BAR("SUB1")=""  D  Q:$G(BAR("F1"))
 ..S BARTMP=$G(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1")))
 ..W !,$E(BAR("SUB1"),1,19)          ; Billing Entity/Allowance Category
 ..S BAR("SUB2")=""
 ..F  S BAR("SUB2")=$O(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1"),BAR("SUB2"))) Q:BAR("SUB2")=""  D  Q:$G(BAR("F1"))
 ...I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 ...S BARTMPS=$G(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1"),BAR("SUB2")))
 ...W !?1,$E(BAR("SUB2"),1,18)      ; A/R Account
 ...D ACCOUNT
 ...Q:$G(BAR("F1"))
 ..Q:$G(BAR("F1"))
 ..W !,BARDASH,!
 ..I BARY("STCR")=5 W "ALLOW CAT TOTAL"
 ..I BARY("STCR")=6 W "BILL ENTITY TOTAL"
 ..I BARY("STCR")=7 W "INS TYPE TOTAL"
 ..D SUM2              ; Subtotals by Billing Entity/Allowance Category
 .Q:$G(BAR("F1"))
 .S BARTMP=$G(^TMP($J,"BAR-ASMT",BAR("SUB0")))
 .W !,BARDASH,!,"*** VISIT Loc Total"
 .D SUM2
 Q:$G(BAR("F1"))
 W !
 D TOTAL               ; Report Totals
 ;D EOP^BARUTL(0)  ;bar*1.8*28 IHS/SD/SDR CR8350 HEAT295594 -NOW WANT PAUSE IHS/DIT/CPC - 20180502 CR8350
 I '$D(BARA),(XQY0'["UFMS") D EOP^BARUTL(0)  ;If not USM Pause IHS/DIT/CPC - 20180502 BAR*1.8*28 CR8350
 Q
 ; ********************************************************************
 ;
BILL ;
 ; Print report if user selected SORT CRITERIA Billing Entity or
 ; Allowance Category and Report Type with payers AND bills
 ;
 D HDB                                     ; Page and column header
 I '$D(^TMP($J,"BAR-ASMT")) D  Q           ; No data - quit
 .W !!!!!?25,"*** NO DATA TO PRINT ***"
 .I '$D(BARA),(XQY0'["UFMS") D EOP^BARUTL(0)  ;bar*1.8*28 IHS/SD/SDR CR8350 HEAT295594 - NO USM PAGE BREAKS IHS/DIT/CPC - 20180502
 ;
 S BARHOLD("SUB0")=$O(^TMP($J,"BAR-ASMT",""))
 S BAR("SUB0")=""
 F  S BAR("SUB0")=$O(^TMP($J,"BAR-ASMT",BAR("SUB0"))) Q:BAR("SUB0")=""  D  Q:$G(BAR("F1"))
 .I BAR("SUB0")'=BARHOLD("SUB0") D HD
 .Q:$G(BAR("F1"))
 .S BARHOLD("SUB0")=BAR("SUB0")
 .I '$D(BARY("LOC")) W !,"*** VISIT Location: ",BAR("SUB0"),!
 .S BAR("SUB1")=""
 .F  S BAR("SUB1")=$O(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1"))) Q:BAR("SUB1")=""  D  Q:$G(BAR("F1"))
 ..S BARTMP=$G(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1")))
 ..W $$EN^BARVDF("HIN")
 ..W !!,$$CJ^XLFSTR(BAR("SUB1"),IOM),!        ; Billing Entity/Allowance Category
 ..W $$EN^BARVDF("HIF")
 ..S BAR("SUB2")=""
 ..F  S BAR("SUB2")=$O(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1"),BAR("SUB2"))) Q:BAR("SUB2")=""  D  Q:$G(BAR("F1"))
 ...S BARTMPS=$G(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1"),BAR("SUB2")))
 ...W !?1,BAR("SUB2")      ; A/R Account
 ...S BAR("SUB3")=""
 ...F  S BAR("SUB3")=$O(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1"),BAR("SUB2"),BAR("SUB3"))) Q:BAR("SUB3")=""  D  Q:$G(BAR("F1"))
 ....I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 ....S BARTMPS2=$G(^TMP($J,"BAR-ASMT",BAR("SUB0"),BAR("SUB1"),BAR("SUB2"),BAR("SUB3")))
 ....W !?2,$E(BAR("SUB3"),1,17)
 ....W ?20,$J($P(BARTMPS2,U),9,2)     ; CURRENT
 ....W ?30,$J($P(BARTMPS2,U,2),9,2)    ; 31-60
 ....W ?40,$J($P(BARTMPS2,U,3),9,2)    ; 61-90
 ....W ?50,$J($P(BARTMPS2,U,4),9,2)    ; 90-120
 ....W ?60,$J($P(BARTMPS2,U,5),9,2)    ; 120+
 ....W ?70,$J($P(BARTMPS2,U,6),10,2)   ; BALANCE
 ...Q:$G(BAR("F1"))
 ...W !,BARDASH,!
 ...W "A/R ACCOUNT TOTAL"
 ...D ACCOUNT
 ...W !
 ..Q:$G(BAR("F1"))
 ..W BARDASH,!
 ..I BARY("STCR")=5 W "ALLOW CAT TOTAL"
 ..I BARY("STCR")=6 W "BILL ENTITY TOTAL"
 ..I BARY("STCR")=7 W "INS TYPE TOTAL"
 ..D SUM2              ; Subtotals by Billing Entity/Allowance Category
 .Q:$G(BAR("F1"))
 .S BARTMP=$G(^TMP($J,"BAR-ASMT",BAR("SUB0")))
 .W !,BARDASH,!,"*** VISIT Loc Total"
 .D SUM2
 Q:$G(BAR("F1"))
 W !
 D TOTAL               ; Report Totals
 I '$D(BARA),(XQY0'["UFMS") D EOP^BARUTL(0)  ;If not USM Pause IHS/DIT/CPC - 20180502 BAR*1.8*28 CR8350
 Q
 ; ********************************************************************
 ;
ACCOUNT ;
 ; Account line on Summary reports
 W ?20,$J($P(BARTMPS,U),9,2)     ; CURRENT
 W ?30,$J($P(BARTMPS,U,2),9,2)    ; 31-60
 W ?40,$J($P(BARTMPS,U,3),9,2)    ; 61-90
 W ?50,$J($P(BARTMPS,U,4),9,2)    ; 90-120
 W ?60,$J($P(BARTMPS,U,5),9,2)    ; 120+
 W ?70,$J($P(BARTMPS,U,6),10,2)   ; BALANCE
 ;ADD COUNT LINE HERE FOR SUB3
 Q
 ; ********************************************************************
 ;
SUM2 ;
 ; Billing Entity/Allowance Category Summary line
 W ?20,$J($P(BARTMP,U),9,2)      ; CURRENT
 W ?30,$J($P(BARTMP,U,2),9,2)    ; 31-60
 W ?40,$J($P(BARTMP,U,3),9,2)    ; 61-90
 W ?50,$J($P(BARTMP,U,4),9,2)    ; 90-120
 W ?60,$J($P(BARTMP,U,5),9,2)    ; 120+
 W ?70,$J($P(BARTMP,U,6),10,2)   ; BALANCE
 Q
 ; ********************************************************************
 ;
TOTAL ;
 ; Report totals for Billing Entity/Allowance Category Reports
 W BAREQUAL
 S BARTMP=$G(^TMP($J,"BAR-ASMT"))
 W !?20,$J($P(BARTMP,U),9,2)       ; CURRENT
 W ?30,$J($P(BARTMP,U,2),9,2)      ; 31-60
 W ?40,$J($P(BARTMP,U,3),9,2)      ; 61-90
 W ?50,$J($P(BARTMP,U,4),9,2)      ; 90-120
 W ?60,$J($P(BARTMP,U,5),9,2)      ; 120+
 W ?70,$J($P(BARTMP,U,6),10,2)     ; BALANCE
 Q
 ; ********************************************************************
 ;
HD ; EP
 ;D PAZ^BARRUTL  ;bar*1.8*28 IHS/SD/SDR CR8350 HEAT295594  IHS/DIT/CPC CR8350 BAR*1.8*28 20180502 Now they want the pause. 
 I XQY0'["UFMS" D PAZ^BARRUTL  ;only do pause for ASM, not USM  ;bar*1.8*28 IHS/SD/SDR CR8350 HEAT295594
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) S BAR("F1")=1 Q
 ; -------------------------------
 ;
HDB ; EP
 ; Page and column header
 S BAR("PG")=BAR("PG")+1
 S BAR("I")=""
 D WHD^BARRHD                   ; Report header
 X BAR("COL")
 S $P(BAR("DASH"),"=",$S($D(BAR(132)):132,1:80))=""
 W !,BAR("DASH"),!
 Q
ASUFAC(DUZ2,ARBILLIN) ;EP - GET ASUFACASUFAC3PIEN STRING
 S ARDOSBEG=$$GET1^DIQ(90050.01,ARBILLIN_",",102,"I") ;A/R BILL, DOS BEGIN
 S TPBIEN=$P($$FIND3PB^BARUTL(DUZ2,ARBILLIN),",",2)   ;GET 3PIEN
 S:TPBIEN="" TPBIEN="00000000"
 ;
 S PARSUFAC=$$GET1^DIQ(90050.01,ARBILLIN_",",8,"I") ;A/R BILL, PARENT LOCATION
 S PARSUFAC=$$CURASUFC^BARUFUT1(PARSUFAC,ARDOSBEG)
 ;
 S LARSUFAC=$$GET1^DIQ(90050.01,ARBILLIN_",",108,"I") ;A/R BILL, VISIT LOCATION
 S LARSUFAC=$$CURASUFC^BARUFUT1(LARSUFAC,ARDOSBEG)
 Q PARSUFAC_LARSUFAC_TPBIEN
