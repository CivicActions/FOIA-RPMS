ABME8CAS ; IHS/ASDST/DMJ - 837 CAS Segment [ 02/04/2003  11:07 AM ]
 ;;2.5;IHS 3P BILLING SYSTEM;**1,10,13**;APR 05, 2002
 ;Transaction Set Header
 ;
 ; IHS/SD/SDR - v2.5 p13 - IM25471
 ;   Added code for CO when SAR=A2
 ;
EP ;EP - START HERE  ;abm*2.5*10 COB issue--changed tag from START to EP
 ; for consistency with other routines
 K ABMREC("CAS"),ABMR("CAS")
 S ABME("RTYPE")="CAS"
 S ABMCNT=1  ;abm*2.5*10 COB issue
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 ;F I=10:10:30 D  ;abm*2.5*10 COB issue
 F I=10:10:200 D  ;abm*2.5*10 COB issue
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("CAS"))'="" S ABMREC("CAS")=ABMREC("CAS")_"*"
 .S ABMREC("CAS")=$G(ABMREC("CAS"))_ABMR("CAS",I)
 Q
10 ;segment
 S ABMR("CAS",10)="CAS"
 Q
20 ;CAS01 - Claim Adjustment Group Code
 S ABMR("CAS",20)=""
 S ABMR("CAS",20)=ABML  ;abm*2.5*10 COB issue
 Q
30 ;CAS02 - Claim Adjustment Reason Code
 S ABMR("CAS",30)=""
 ;S ABMR("CAS",30)=$P($G(^BARADJ($P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U),0)),U)  ;abm*2.5*10 COB issue  ;abm*2.5*13 IM25471
 S ABMR("CAS",30)=$P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U)  ;abm*2.5*13 IM25471
 Q
40 ;CAS03 - Monetary Amount
 S ABMR("CAS",40)=""
 S ABMR("CAS",40)=$FN($P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U,2),"-")  ;abm*2.5*10 COB issue
 I ABML="PR" S ABMF2AMT=$FN($P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U,2),"-")  ;abm*2.5*10 COB issue
 Q
50 ;CAS04 - Quantity
 S ABMR("CAS",50)=""
 S ABMR("CAS",50)=$P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U,3)  ;abm*2.5*10 COB issue
 S ABMCNT=ABMCNT+1  ;abm*2.5*10 COB issue
 Q
60 ;CAS05 - Claim Adjustment Reason Code
 S ABMR("CAS",60)=""
 ;start new code abm*2.5*10 COB issue
 Q:'$D(ABMP(+ABMLINE,ABML,ABMCNT))
 ;S ABMR("CAS",60)=$P($G(^BARADJ($P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U),0)),U)  ;abm*2.5*13 IM25471
 S ABMR("CAS",60)=$P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U)  ;abm*2.5*13 IM25471
 ;end new code abm*2.5*10 COB issue
 Q
70 ;CAS06 - Monetary Amount
 S ABMR("CAS",70)=""
 ;start new code abm*2.5*10 COB issue
 Q:'$D(ABMP(+ABMLINE,ABML,ABMCNT))
 S ABMR("CAS",70)=$FN($P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U,2),"-")
 I ABML="PR" S ABMF2AMT=$FN($P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U,2),"-")
 ;end new code abm*2.5*10 COB issue
 Q
80 ;CAS07 - Quantity
 S ABMR("CAS",80)=""
 ;start new code abm*2.5*10 COB issue
 Q:'$D(ABMP(+ABMLINE,ABML,ABMCNT))
 S ABMR("CAS",80)=$P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U,3)
 S ABMCNT=ABMCNT+1
 ;end new code abm*2.5*10 COB issue
 Q
90 ;CAS08 - Claim Adjustment Reason Code
 S ABMR("CAS",90)=""
 ;start new code abm*2.5*10 COB issue
 Q:'$D(ABMP(+ABMLINE,ABML,ABMCNT))
 ;S ABMR("CAS",90)=$P($G(^BARADJ($P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U),0)),U)  ;abm*2.5*13 IM25471
 S ABMR("CAS",90)=$P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U)  ;abm*2.5*13 IM25471
 ;end new code abm*2.5*10 COB issue
 Q
100 ;CAS09 - Monetary Amount
 S ABMR("CAS",100)=""
 ;start new code abm*2.5*10 COB issue
 Q:'$D(ABMP(+ABMLINE,ABML,ABMCNT))
 S ABMR("CAS",100)=$FN($P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U,2),"-")
 I ABML="PR" S ABMF2AMT=$FN($P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U,2),"-")
 ;end new code abm*2.5*10 COB issue
 Q
110 ;CAS10 - Quantity
 S ABMR("CAS",110)=""
 ;start new code abm*2.5*10 COB issue
 Q:'$D(ABMP(+ABMLINE,ABML,ABMCNT))
 S ABMR("CAS",110)=$P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U,3)
 S ABMCNT=ABMCNT+1
 ;end new code abm*2.5*10 COB issue
 Q
120 ;CAS11 - Claim Adjustment Reason Code
 S ABMR("CAS",120)=""
 ;start new code abm*2.5*10 COB issue
 Q:'$D(ABMP(+ABMLINE,ABML,ABMCNT))
 ;S ABMR("CAS",120)=$P($G(^BARADJ($P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U),0)),U)  ;abm*2.5*13 IM25471
 S ABMR("CAS",120)=$P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U)  ;abm*2.5*13 IM25471
 ;end new code abm*2.5*10 COB issue
 Q
130 ;CAS12 - Monetary Amount
 S ABMR("CAS",130)=""
 ;start new code abm*2.5*10 COB issue
 Q:'$D(ABMP(+ABMLINE,ABML,ABMCNT))
 S ABMR("CAS",130)=$FN($P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U,2),"-")
 I ABML="PR" S ABMF2AMT=$FN($P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U,2),"-")
 ;end new code abm*2.5*10 COB issue
 Q
140 ;CAS13 - Quantity
 S ABMR("CAS",140)=""
 ;start new code abm*2.5*10 COB issue
 Q:'$D(ABMP(+ABMLINE,ABML,ABMCNT))
 S ABMR("CAS",140)=$P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U,3)
 S ABMCNT=ABMCNT+1
 ;end new code abm*2.5*10 COB issue
 Q
150 ;CAS14 - Claim Adjustment Reason Code
 S ABMR("CAS",150)=""
 ;start new code abm*2.5*10 COB issue
 Q:'$D(ABMP(+ABMLINE,ABML,ABMCNT))
 ;S ABMR("CAS",150)=$P($G(^BARADJ($P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U),0)),U)  ;abm*2.5*13 IM25471
 S ABMR("CAS",150)=$P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U)  ;abm*2.5*13 IM25471
 ;end new code abm*2.5*10 COB issue
 Q
160 ;CAS15 - Monetary Amount
 S ABMR("CAS",160)=""
 ;start new code abm*2.5*10 COB issue
 Q:'$D(ABMP(+ABMLINE,ABML,ABMCNT))
 S ABMR("CAS",160)=$FN($P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U,2),"-")
 I ABML="PR" S ABMF2AMT=$FN($P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U,2),"-")
 ;end new code abm*2.5*10 COB issue
 Q
170 ;CAS16 - Quantity
 S ABMR("CAS",170)=""
 ;start new code abm*2.5*10 COB issue
 Q:'$D(ABMP(+ABMLINE,ABML,ABMCNT))
 S ABMR("CAS",170)=$P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U,3)
 S ABMCNT=ABMCNT+1
 ;end new code abm*2.5*10 COB issue
 Q
180 ;CAS17 - Claim Adjustment Reason Code
 S ABMR("CAS",180)=""
 ;start new code abm*2.5*10 COB issue
 Q:'$D(ABMP(+ABMLINE,ABML,ABMCNT))
 ;S ABMR("CAS",180)=$P($G(^BARADJ($P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U),0)),U)  ;abm*2.5*13 IM25471
 S ABMR("CAS",180)=$P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U)  ;abm*2.5*13 IM25471
 ;end new code abm*2.5*10 COB issue
 Q
190 ;CAS18 - Monetary Amount
 S ABMR("CAS",190)=""
 ;start new code abm*2.5*10 COB issue
 Q:'$D(ABMP(+ABMLINE,ABML,ABMCNT))
 S ABMR("CAS",190)=$FN($P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U,2),"-")
 I ABML="PR" S ABMF2AMT=$FN($P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U,2),"-")
 ;end new code abm*2.5*10 COB issue
 Q
200 ;CAS19 - Quantity
 S ABMR("CAS",200)=""
 ;start new code abm*2.5*10 COB issue
 Q:'$D(ABMP(+ABMLINE,ABML,ABMCNT))
 S ABMR("CAS",200)=$P($G(ABMP(+ABMLINE,ABML,ABMCNT)),U,3)
 S ABMCNT=ABMCNT+1
 ;end new code abm*2.5*10 COB issue
 Q
