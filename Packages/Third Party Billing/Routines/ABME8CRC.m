ABME8CRC ; IHS/ASDST/DMJ - 837 CRC Segment [ 02/04/2003  11:07 AM ]
 ;;2.5;IHS 3P BILLING SYSTEM;**1,8,10**;APR 05, 2002
 ;Transaction Set Header
 ;
 ; IHS/SD/SDR v2.5 p8 - task 6
 ;    Added code for ambulance
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20076
 ;   Added code for EPSDT
 ;
EP ;EP - START HERE
 K ABMREC("CRC"),ABMR("CRC")
 S ABME("RTYPE")="CRC"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:80 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("CRC"))'="" S ABMREC("CRC")=ABMREC("CRC")_"*"
 .S ABMREC("CRC")=$G(ABMREC("CRC"))_ABMR("CRC",I)
 Q
10 ;segment
 S ABMR("CRC",10)="CRC"
 Q
20 ;CRC01 - Code Category
 ;S ABMR("CRC",20)=""  ;IHS/SD/SDR v2.5 p8 task 6
 ;S ABMR("CRC",20)="07"  ;IHS/SD/SDR v2.5 p8 task 6  ;abm*2.5*10 IM20076
 I $G(ABMP("CLIN"))="A3" S ABMR("CRC",20)="07"  ;abm*2.5*10 IM20076
 I $G(ABMSPIEN)'="" S ABMR("CRC",20)="ZZ"  ;abm*2.5*10 IM20076
 Q
30 ;CRC02 - Yes/No Condition or Response Code
 S ABMR("CRC",30)=""
 ;S ABMR("CRC",30)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,15)  ;IHS/SD/SDR v2.5 p8 task 6  abm*2.5*10 IM20076
 I $G(ABMP("CLIN"))="A3" S ABMR("CRC",30)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,15)  ;abm*2.5*10 IM20076
 I $G(ABMSPIEN)'="" S ABMR("CRC",30)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),59,ABMSPIEN,0)),U,2)  ;abm*2.5*10 IM20076
 Q
40 ;CRC03 - Condition Indicator
 S ABMR("CRC",40)=""
 ;start new code IHS/SD/SDR v2.5 p8 task 6
 ;I ABMR("CRC",30)="Y" D  ;abm*2.5*10 IM20076
 I ABMR("CRC",30)="Y",(ABMR("CRC",30)="Y") D  ;abm*2.5*10 IM20076
 .S ABMCIEN=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),14,0))
 .Q:+ABMCIEN=0
 .S ABMR("CRC",40)=$P($G(^ABMCNDIN($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),14,ABMCIEN,0)),0)),U)
 ;end new code task 6
 ;start new code abm*2.5*10 IM20076
 I $G(ABMPSIEN)'="" D
 .I ABMR("CRC",30)="N" S ABMR("CRC",40)="NU" Q
 .S ABMRIEN=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),59,ABMSPIEN,1,0))
 .Q:+ABMRIEN=0
 .S ABMR("CRC",40)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),59,ABMSPIEN,1,ABMRIEN,0)),U)
 ;end new code IM20076
 Q
50 ;CRC04 - Condition Indicator
 S ABMR("CRC",50)=""
 ;start new code IHS/SD/SDR v2.5 p8 task 6
 ;I ABMR("CRC",30)="Y" D  ;abm*2.5*10 IM20076
 I ABMR("CRC",30)="Y",(ABMR("CRC",30)="Y") D  ;abm*2.5*10 IM20076
 .Q:+ABMCIEN=0
 .S ABMCIEN=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),14,ABMCIEN))
 .Q:+ABMCIEN=0
 .S ABMR("CRC",50)=$P($G(^ABMCNDIN($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),14,ABMCIEN,0)),0)),U)
 ;end new code task 6
 ;start new code abm*2.5*10 IM20076
 I $G(ABMSPIEN)'="" D
 .Q:+$G(ABMRIEN)=0
 .S ABMRIEN=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),59,ABMSPIEN,1,ABMRIEN))
 .Q:+ABMRIEN=0
 .S ABMR("CRC",50)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),59,ABMSPIEN,1,ABMRIEN,0)),U)
 ;end new code IM20076
 Q
60 ;CRC05 - Condition Indicator
 S ABMR("CRC",60)=""
 ;start new code IHS/SD/SDR v2.5 p8 task 6
 ;I ABMR("CRC",30)="Y" D  ;abm*2.5*10 IM20076
 I ABMR("CRC",30)="Y",(ABMR("CRC",30)="Y") D  ;abm*2.5*10 IM20076
 .Q:+ABMCIEN=0
 .S ABMCIEN=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),14,ABMCIEN))
 .Q:+ABMCIEN=0
 .S ABMR("CRC",60)=$P($G(^ABMCNDIN($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),14,ABMCIEN,0)),0)),U)
 ;end new code task 6
 ;start new code abm*2.5*10 IM20076
 I $G(ABMSPIEN)'="" D
 .Q:+$G(ABMRIEN)=0
 .S ABMRIEN=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),59,ABMSPIEN,1,ABMRIEN))
 .Q:+ABMRIEN=0
 .S ABMR("CRC",60)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),59,ABMSPIEN,1,ABMRIEN,0)),U)
 ;end new code IM20076
 Q
70 ;CRC06 - Condition Indicator
 ;S ABMR("CRC",80)=""  ;IHS/SD/SDR v2.5 p8 task 6
 ;start new code IHS/SD/SDR v2.5 p8 task 6
 S ABMR("CRC",70)=""
 ;I ABMR("CRC",30)="Y" D  ;abm*2.5*10 IM20076
 I ABMR("CRC",30)="Y",(ABMR("CRC",30)="Y") D  ;abm*2.5*10 IM20076
 .Q:+ABMCIEN=0
 .S ABMCIEN=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),14,ABMCIEN))
 .Q:+ABMCIEN=0
 .S ABMR("CRC",70)=$P($G(^ABMCNDIN($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),14,ABMCIEN,0)),0)),U)
 ;end new code task 6
 Q
80 ;CRC07 - Condition Indicator
 ;S ABMR("CRC",30)=""  ;IHS/SD/SDR v2.5 p8 task 6
 ;start new code IHS/SD/SDR v2.5 p8 task 6
 S ABMR("CRC",80)=""
 ;I ABMR("CRC",30)="Y" D  ;abm*2.5*10 IM20076
 I ABMR("CRC",30)="Y",(ABMR("CRC",30)="Y") D  ;abm*2.5*10 IM20076
 .Q:+ABMCIEN=0
 .S ABMCIEN=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),14,ABMCIEN))
 .Q:+ABMCIEN=0
 .S ABMR("CRC",80)=$P($G(^ABMCNDIN($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),14,ABMCIEN,0)),0)),U)
 ;end new code task 6
 Q
