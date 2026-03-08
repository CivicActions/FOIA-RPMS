ABME8PAT ; IHS/ASDST/DMJ - 837 PAT Segment [ 02/04/2003  11:07 AM ]
 ;;2.5;IHS 3P BILLING SYSTEM;**1**;APR 05, 2002
 ;Patient Information
 ;
START ;START HERE
 K ABMREC("PAT"),ABMR("PAT")
 S ABME("RTYPE")="PAT"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:100 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("PAT"))'="" S ABMREC("PAT")=ABMREC("PAT")_"*"
 .S ABMREC("PAT")=$G(ABMREC("PAT"))_ABMR("PAT",I)
 Q
10 ;segment
 S ABMR("PAT",10)="PAT"
 Q
20 ;PAT01 - Individual Relationship Code
 S ABMR("PAT",20)=$$REL^ABMUTLP(ABMP("BDFN"))
 Q
30 ;PAT02 - Patient Location Code
 S ABMR("PAT",30)=""
 Q
40 ;PAT03 - Employment Status Code
 S ABMR("PAT",40)=""
 Q
50 ;PAT04 - Student Status Code
 S ABMR("PAT",50)=""
 Q
60 ;PAT05 - Date Time Period Format Qualifier
 S ABMR("PAT",60)=""
 Q
70 ;PAT06 - Date Time Period
 S ABMR("PAT",70)=""
 Q
80 ;PAT07 - Unit or Basis for Measurement Code
 S ABMR("PAT",80)=""
 Q
90 ;PAT08 - Weight
 S ABMR("PAT",90)=""
 Q
100 ;PAT09 - Pregnancy Indicator
 S ABMR("PAT",100)=""
 Q
