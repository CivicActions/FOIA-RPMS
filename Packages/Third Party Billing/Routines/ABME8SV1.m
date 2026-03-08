ABME8SV1 ; IHS/ASDST/DMJ - 837 SV1 Segment [ 03/09/2004  1:16 PM ]
 ;;2.5;IHS 3P BILLING SYSTEM;**1,4,5,6,8,9,10,11**;APR 05, 2002
 ;Transaction Set Header
 ;
 ; IHS/SD/SDR - V2.5 P5 - Fix to put only 4 cooresponding Dxs on claim
 ;
 ; IHS/SD/SDR - v2.5 p5 - Modified to put POS and TOS by line item
 ;
 ; IHS/SD/SDR - v2.5 p6 - IM14042 - Correction so POS would look up correctly
 ;
 ; IHS/SD/SDR - v2.5 p6 - 7/13/04 - Fixed so FL override works correctly
 ;
 ; IHS/SD/SDR - v2.5 p6 - IM14079 - 7/19/04 - Removed code for SV106
 ;
 ; IHS/SD/SDR - v2.5 p8 - IM13693/IM17856
 ;    Remove leading zeros
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM17729
 ;    Anesthesia minutes
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20395
 ;   Split out lines bundled by rev code
 ;
 ; IHS/SD/SDR - v2.5 p11 - IM21946
 ;    Made change for CLIA number
 ;
EP ;EP
 K ABMREC("SV1"),ABMR("SV1")
 S ABME("RTYPE")="SV1"
 D LOOP
 K ABME
 Q
LOOP ;LOOP HERE
 F I=10:10:220 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("SV1"))'="" S ABMREC("SV1")=ABMREC("SV1")_"*"
 .S ABMREC("SV1")=$G(ABMREC("SV1"))_ABMR("SV1",I)
 Q
10 ;segment
 S ABMR("SV1",10)="SV1"
 Q
20 ;SV101 - Composite Medical Procedure Identifier
 ;SV102-1 Product Service ID Qualifier
 ;SV102-2 Product Service ID (Procedure Code)
 ;I $P(ABMRV(ABMI,ABMJ),"^",2)'="" D  ;abm*2.5*10 IM20395
 I $P(ABMRV(ABMI,ABMJ,ABMK),U,2)'="" D  ;abm*2.5*10 IM20395
 .S ABMR("SV1",20)="HC"
 .;S $P(ABMR("SV1",20),":",2)=$P(ABMRV(ABMI,ABMJ),U,2)  ;abm*2.5*10 IM20395
 .S $P(ABMR("SV1",20),":",2)=$P(ABMRV(ABMI,ABMJ,ABMK),U,2)  ;abm*2.5*10 IM20395
 ;I $P(ABMRV(ABMI,ABMJ),"^",2)="" D  ;abm*2.5*10 IM20395
 I $P(ABMRV(ABMI,ABMJ,ABMK),U,2)="" D  ;abm*2.5*10 IM20395
 .S ABMR("SV1",20)=""
 .;Q:$P(ABMRV(ABMI,ABMJ),"^",15)=""  ;abm*2.5*10 IM20395
 .Q:$P(ABMRV(ABMI,ABMJ,ABMK),U,15)=""  ;abm*2.5*10 IM20395
 .;S ABM("NDC")=$P(ABMRV(ABMI,ABMJ),U,15)  ;abm*2.5*10 IM20395
 .S ABM("NDC")=$P(ABMRV(ABMI,ABMJ,ABMK),U,15)  ;abm*2.5*10 IM20395
 .I ABM("NDC")?4N1"-"4N1"-"2N S ABMR("SV1",20)="N1"
 .I ABM("NDC")?5N1"-"3N1"-"2N S ABMR("SV1",20)="N2"
 .I ABM("NDC")?5N1"-"4N1"-"1N S ABMR("SV1",20)="N3"
 .I ABM("NDC")?5N1"-"4N1"-"2N S ABMR("SV1",20)="N4"
 .S $P(ABMR("SV1",20),":",2)=ABM("NDC")
 N I
 F I=3,4,12,22 D
 .;start old code abm*2.5*10 IM20395
 .;Q:$P(ABMRV(ABMI,ABMJ),"^",I)=""
 .;S ABMR("SV1",20)=ABMR("SV1",20)_":"_$P(ABMRV(ABMI,ABMJ),"^",I)
 .;end old code start new code IM20395
 .Q:$P(ABMRV(ABMI,ABMJ,ABMK),U,I)=""
 .S ABMR("SV1",20)=ABMR("SV1",20)_":"_$P(ABMRV(ABMI,ABMJ,ABMK),U,I)
 .I $P(ABMRV(ABMI,ABMJ,ABMK),U,I)=90 S ABMOUTLB=1  ;abm*2.5*11 IM21946
 .;end new code IM20395
 Q
30 ;SV102 - Monetary Amount (Charges)
 ;S ABMR("SV1",30)=$P(ABMRV(ABMI,ABMJ),U,6)  ;abm*2.5*10 IM20395
 S ABMR("SV1",30)=$P(ABMRV(ABMI,ABMJ,ABMK),U,6)  ;abm*2.5*10 IM20395
 ;S ABMR("SV1",30)=$J(ABMR("SV1",30),0,2)  ;IM13693
 S ABMR("SV1",30)=$$TRIM^ABMUTLP($J(ABMR("SV1",30),0,2),"L","0")  ;IM13693
 Q
40 ;SV103 - Unit or Basis for Measurement Code
 ;S ABMR("SV1",40)="UN"  ;abm*2.5*9 IM17729
 ;start new code abm*2.5*9 IM17729
 I ABMI=39 S ABMR("SV1",40)="MJ"
 E  S ABMR("SV1",40)="UN"
 ;end new code abm*2.5*9 IM17729
 Q
50 ;SV104 - Quantity
 ;S ABMR("SV1",50)=$P(ABMRV(ABMI,ABMJ),U,5)  ;abm*2.5*9 IM17729
 ;S ABMR("SV1",50)=$S(ABMR("SV1",40)="UN":$P(ABMRV(ABMI,ABMJ),U,5),1:$P(ABMRV(ABMI,ABMJ),U,16))  ;abm*2.5*9 IM17729  ;abm*2.5*10 IM20395
 S ABMR("SV1",50)=$S(ABMR("SV1",40)="UN":$P(ABMRV(ABMI,ABMJ,ABMK),U,5),1:$P(ABMRV(ABMI,ABMJ,ABMK),U,16))  ;abm*2.5*10 IM20395
 Q
60 ;SV105 - Facility Code Value (place of service)
 S ABMR("SV1",60)=""
 ; IHS/SD/SDR 5/18/04 start new code
 ;I $P($G(ABMRV(ABMI,ABMJ)),U,25)'="" D  ;abm*2.5*10 IM20395
 I $P($G(ABMRV(ABMI,ABMJ,ABMK)),U,25)'="" D  ;abm*2.5*10 IM20395
 .;S ABMR("SV1",60)=$P($G(ABMRV(ABMI,ABMJ)),U,25)  ;abm*2.5*10 IM20395
 .S ABMR("SV1",60)=$P($G(ABMRV(ABMI,ABMJ,ABMK)),U,25)  ;abm*2.5*10 IM20395
 .I ABMR("SV1",60)'="" S ABMR("SV1",60)=$P($G(^ABMDCODE(ABMR("SV1",60),0)),"^")  ;IHS/SD/SDR 7/9/04 v2.5 p6
 E  S ABMR("SV1",60)=$$POS^ABMERUTL(ABMI)
 ;I ABMR("SV1",60)'="" S ABMR("SV1",60)=$P($G(^ABMDCODE(ABMR("SV1",60),0)),"^")  ;IHS/SD/SDR 7/9/04  v2.5 p6
 ;D OVER^ABMUTL8(37,3)  ;Fl override  ;IHS/SD/SDR 7/13/04 v2.5 p6
 S ABMVALUE=$$OVER^ABMUTL8(37,3)  ;Fl override  ;IHS/SD/SDR 7/13/04 v2.5 p6
 I ABMVALUE'="" S ABMR("SV1",60)=ABMVALUE
 ; IHS/SD/SDR 5/18/04 end new code
 Q
70 ;SV106 - service type code
 S ABMR("SV1",70)=""
 ; start old code IHS/SD/SDR 7/19/04
 ; IHS/SD/SDR 5/18/04 start new code
 ;I $P($G(ABMRV(ABMI,ABMJ)),U,26)'="" D
 ;. S ABMR("SV1",70)=$P($G(ABMRV(ABMI,ABMJ)),U,26)
 ;. S ABMR("SV1",70)=$P($G(^ABMDCODE(ABMR("SV1",70),0)),"^")
 ;E  S ABMR("SV1",70)=$$TOS^ABMERUTL(ABMI)
 ;D OVER^ABMUTL8(37,4)  ;FL override  ;IHS/SD/SDR 7/13/04 v2.5 p6
 ;S ABMVALUE=$$OVER^ABMUTL8(37,4)  ;FL override  ;IHS/SD/SDR 7/13/04 v2.5 p6
 ;I ABMVALUE'="" S ABMR("SV1",70)=ABMVALUE
 ; IHS/SD/SDR 5/18/04 end new code
 ; end old code IHS/SD/SDR 7/19/04
 Q
80 ;SV107 - Composite DX code pointer
 ;S ABMR("SV1",80)=$P(ABMRV(ABMI,ABMJ),"^",11)  ;abm*2.5*10 IM20395
 S ABMR("SV1",80)=$P(ABMRV(ABMI,ABMJ,ABMK),U,11)  ;abm*2.5*10 IM20395
 S ABMR("SV1",80)=$TR(ABMR("SV1",80),",",":")
 S ABMR("SV1",80)=$P(ABMR("SV1",80),":",1,4)  ;IHS/SD/SDR V2.5 P5
 Q
90 ;SV108 - Monetary Amount
 S ABMR("SV1",90)=""
 Q
100 ;SV109 - emergency indicator
 S ABMR("SV1",100)=$P(ABMB8,"^",5)
 Q
110 ;SV110 - Multiple Procedure Code
 S ABMR("SV1",110)=""
 Q
120 ;SV111 - epsdt
 S ABMR("SV1",120)=""
 Q
130 ;SV112 - Family Planning Indicator
 S ABMR("SV1",130)=""
 Q
140 ;SV113 - Review Code
 S ABMR("SV1",140)=""
 Q
150 ;SV114 - National or Local Assigned Review Value
 S ABMR("SV1",150)=""
 Q
160 ;SV115 - copay status code
 S ABMR("SV1",160)=""
170 ;SV116 - health care professional shortage area code     
 S ABMR("SV1",170)=""
180 ;SV117 - reference identification     
 S ABMR("SV1",180)=""
 Q
190 ;SV118 - postal code
 S ABMR("SV1",190)=""
 Q
200 ;SV119 - monetary amount
 S ABMR("SV1",200)=""
 Q
210 ;SV120 - level of care code
 S ABMR("SV1",210)=""
 Q
220 ;SV121 - provider agreement code
 S ABMR("SV1",220)=""
 Q
