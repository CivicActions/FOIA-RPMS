BARRASMC ; IHS/SD/LSL - Age Summary Report ; 04/23/2020
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**30,31**;OCT 26, 2005;Build 90
 ;;Adds Totals and Counts for reporting ;;Thanks to Roger Merchberger who developed while at Bemidji Area. ;CR10582 IHS/SD/CPC - BAR*1.8*30
 ;BAR*1.8*31;IHS/OIT/FCJ CR#6369 ADDED LINE FEED
 ;
 Q
ADDC ;; /IHS/BEM/RAM - ADD COUNTERS TO DISPLAY # OF CLAIMS
 ; COUNT TOTALS, NOT DOLLAR TOTALS HERE -- /IHS/BEM/RAM -- 10 JUN 2014
 I $G(^TMP($J,"BAR-ASMC",BAR("SUB0"),BAR("SUB1")))="" S ^TMP($J,"BAR-ASMC",BAR("SUB0"),BAR("SUB1"))=U
 S BARCNT=$G(^TMP($J,"BAR-ASMC",BAR("SUB0"),BAR("SUB1")))
 I BAR(1) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0"),BAR("SUB1")),U)=$P(BARCNT,U)+1
 I BAR(2) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0"),BAR("SUB1")),U,2)=$P(BARCNT,U,2)+1
 I BAR(3) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0"),BAR("SUB1")),U,3)=$P(BARCNT,U,3)+1
 I BAR(4) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0"),BAR("SUB1")),U,4)=$P(BARCNT,U,4)+1
 I BAR(5) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0"),BAR("SUB1")),U,5)=$P(BARCNT,U,5)+1
 I BAR(6) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0"),BAR("SUB1")),U,6)=$P(BARCNT,U,6)+1
 Q
 ;
 ;
ADDB ;; /IHS/BEM/RAM - ADD COUNTERS TO DISPLAY # OF CLAIMS
 ; COUNT TOTALS, NOT DOLLAR TOTALS HERE -- /IHS/BEM/RAM -- 10 JUN 2014
 I $G(^TMP($J,"BAR-ASMC",BAR("SUB0")))="" S ^TMP($J,"BAR-ASMC",BAR("SUB0"))=U
 S BARCNT=$G(^TMP($J,"BAR-ASMC",BAR("SUB0")))
 I BAR(1) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0")),U)=$P(BARCNT,U)+1
 I BAR(2) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0")),U,2)=$P(BARCNT,U,2)+1
 I BAR(3) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0")),U,3)=$P(BARCNT,U,3)+1
 I BAR(4) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0")),U,4)=$P(BARCNT,U,4)+1
 I BAR(5) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0")),U,5)=$P(BARCNT,U,5)+1
 I BAR(6) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0")),U,6)=$P(BARCNT,U,6)+1
 Q
 ;
ADDA ;; /IHS/BEM/RAM - ADD COUNTERS TO DISPLAY # OF CLAIMS
 ; COUNT TOTALS, NOT DOLLAR TOTALS HERE -- /IHS/BEM/RAM -- 10 JUN 2014
 I $G(^TMP($J,"BAR-ASMC"))="" S ^TMP($J,"BAR-ASMC")=U
 S BARCNT=$G(^TMP($J,"BAR-ASMC"))
 I BAR(1) S $P(^TMP($J,"BAR-ASMC"),U)=$P(BARCNT,U)+1
 I BAR(2) S $P(^TMP($J,"BAR-ASMC"),U,2)=$P(BARCNT,U,2)+1
 I BAR(3) S $P(^TMP($J,"BAR-ASMC"),U,3)=$P(BARCNT,U,3)+1
 I BAR(4) S $P(^TMP($J,"BAR-ASMC"),U,4)=$P(BARCNT,U,4)+1
 I BAR(5) S $P(^TMP($J,"BAR-ASMC"),U,5)=$P(BARCNT,U,5)+1
 I BAR(6) S $P(^TMP($J,"BAR-ASMC"),U,6)=$P(BARCNT,U,6)+1
 ; W "* ",BAR(1),?10,BAR(2),?20,BAR(3),?30,BAR(4),?40,BAR(5),?50,BAR(6),?60,BARCNT,!
 Q
 ; *********************************************************************
 ;
SUMC ;; /IHS/BEM/RAM - ADD COUNTERS TO DISPLAY # OF CLAIMS
 ; COUNT TOTALS, NOT DOLLAR TOTALS HERE -- /IHS/BEM/RAM -- 10 JUN 2014
 I $G(^TMP($J,"BAR-ASMC",BAR("SUB0"),BAR("SUB2")))="" S ^TMP($J,"BAR-ASMC",BAR("SUB0"),BAR("SUB2"))=U
 S BARCNT=$G(^TMP($J,"BAR-ASMC",BAR("SUB0"),BAR("SUB2")))
 I BAR(1) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0"),BAR("SUB2")),U)=$P(BARCNT,U)+1
 I BAR(2) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0"),BAR("SUB2")),U,2)=$P(BARCNT,U,2)+1
 I BAR(3) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0"),BAR("SUB2")),U,3)=$P(BARCNT,U,3)+1
 I BAR(4) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0"),BAR("SUB2")),U,4)=$P(BARCNT,U,4)+1
 I BAR(5) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0"),BAR("SUB2")),U,5)=$P(BARCNT,U,5)+1
 I BAR(6) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0"),BAR("SUB2")),U,6)=$P(BARCNT,U,6)+1
 Q
 ;
SUMB ;; /IHS/BEM/RAM - ADD COUNTERS TO DISPLAY # OF CLAIMS
 ; COUNT TOTALS, NOT DOLLAR TOTALS HERE -- /IHS/BEM/RAM -- 10 JUN 2014
 I $G(^TMP($J,"BAR-ASMC",BAR("SUB0")))="" S ^TMP($J,"BAR-ASMC",BAR("SUB0"))=U
 S BARCNT=$G(^TMP($J,"BAR-ASMC",BAR("SUB0")))
 I BAR(1) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0")),U)=$P(BARCNT,U)+1
 I BAR(2) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0")),U,2)=$P(BARCNT,U,2)+1
 I BAR(3) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0")),U,3)=$P(BARCNT,U,3)+1
 I BAR(4) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0")),U,4)=$P(BARCNT,U,4)+1
 I BAR(5) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0")),U,5)=$P(BARCNT,U,5)+1
 I BAR(6) S $P(^TMP($J,"BAR-ASMC",BAR("SUB0")),U,6)=$P(BARCNT,U,6)+1
 Q
 ;
SUMA ;; /IHS/BEM/RAM - ADD COUNTERS TO DISPLAY # OF CLAIMS
 ; COUNT TOTALS, NOT DOLLAR TOTALS HERE -- /IHS/BEM/RAM -- 10 JUN 2014
 I $G(^TMP($J,"BAR-ASMC"))="" S ^TMP($J,"BAR-ASMC")=U
 S BARCNT=$G(^TMP($J,"BAR-ASMC"))
 I BAR(1) S $P(^TMP($J,"BAR-ASMC"),U)=$P(BARCNT,U)+1
 I BAR(2) S $P(^TMP($J,"BAR-ASMC"),U,2)=$P(BARCNT,U,2)+1
 I BAR(3) S $P(^TMP($J,"BAR-ASMC"),U,3)=$P(BARCNT,U,3)+1
 I BAR(4) S $P(^TMP($J,"BAR-ASMC"),U,4)=$P(BARCNT,U,4)+1
 I BAR(5) S $P(^TMP($J,"BAR-ASMC"),U,5)=$P(BARCNT,U,5)+1
 I BAR(6) S $P(^TMP($J,"BAR-ASMC"),U,6)=$P(BARCNT,U,6)+1
 ; W "* ",BAR(1),?10,BAR(2),?20,BAR(3),?30,BAR(4),?40,BAR(5),?50,BAR(6),?60,BARCNT,!
 Q
 ; *********************************************************************
 ;
TOTAL3 ; /IHS/BEM/RAM -- 10 JUN 2014;
 ; Report totals for Billing Entity/Allowance Category Reports
 ;W !
 S BARTMP=$G(^TMP($J,"BAR-ASMC"))
 ;W $E("# of Claims",1,19)       ;BAR*1.8*31;IHS/OIT/FCJ CR#6369 ADDED LINE FEED
 W !,$E("# of Claims",1,19)      ;BAR*1.8*31;IHS/OIT/FCJ
 W !?20,$J($P(BARTMP,U),9)       ; CURRENT
 W ?30,$J($P(BARTMP,U,2),9)      ; 31-60
 W ?40,$J($P(BARTMP,U,3),9)      ; 61-90
 W ?50,$J($P(BARTMP,U,4),9)      ; 90-120
 W ?60,$J($P(BARTMP,U,5),9)      ; 120+
 W ?70,$J($P(BARTMP,U,6),10)     ; BALANCE
 Q
 ; ********************************************************************
 ;
SUM3 ; /IHS/BEM/RAM -- 10 JUN 2014;
 ; Billing Entity/Allowance Category Summary Line for # of claims
 W ?20,$J($P(BARTMP,U),9)      ; CURRENT
 W ?30,$J($P(BARTMP,U,2),9)    ; 31-60
 W ?40,$J($P(BARTMP,U,3),9)    ; 61-90
 W ?50,$J($P(BARTMP,U,4),9)    ; 90-120
 W ?60,$J($P(BARTMP,U,5),9)    ; 120+
 W ?70,$J($P(BARTMP,U,6),10)   ; BALANCE
 Q
 ; ********************************************************************
 ;
CNTW  ;/IHS/SD/CPC - BAR*1.8*30
 ; Write counts for sub lines
 W $E("# of Claims",1,19)
 W ?20,$J($P(BARTMP2,U),9)      ; CURRENT
 W ?30,$J($P(BARTMP2,U,2),9)    ; 31-60
 W ?40,$J($P(BARTMP2,U,3),9)    ; 61-90
 W ?50,$J($P(BARTMP2,U,4),9)    ; 90-120
 W ?60,$J($P(BARTMP2,U,5),9)    ; 120+
 W ?70,$J($P(BARTMP2,U,6),10)   ; BALANCE
 Q
