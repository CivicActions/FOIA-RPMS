ABME8L10 ; IHS/ASDST/DMJ - Header [ 09/18/2003  5:28 PM ]
 ;;2.5;IHS 3P BILLING SYSTEM;**1,3,4,8,10,11,12**;APR 05, 2002
 ;Header Segments
 ;
 ; IHS/SD/EFG - V2.5 P8 - IM16385
 ;    Modified to print dental services
 ;
 ; IHS/SD/SDR - v2.5 p8 - IM20395
 ;   Split out lines bundled by rev code
 ;
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ;
 ; IHS/SD/SDR - v2.5 p12 - IM25247
 ;   Added missing REF segment for TIN if NPI ONLY
 ;
EP ;START HERE
 S ABMLXCNT=0
 K ABM
 D FRATE^ABMDF11
 D ^ABMERGRV
 ;start old code IHS/SD/EFG V2.5 P8 IM16385
 ;S ABMREV=0
 ;F  S ABMREV=$O(ABMRV(ABMREV)) Q:'+ABMREV  D
 ;end old code start new code
 S ABMREV=""
 F  S ABMREV=$O(ABMRV(ABMREV)) Q:ABMREV=""  D
 .;end new code IHS/SD/EFG V2.5 P8 IM16385
 .Q:ABMREV=9999
 .S ABMCODE=-1
 .;F  S ABMCODE=$O(ABMRV(ABMREV,ABMCODE)) Q:ABMCODE=""  D LOOP  ;abm*2.5*10 IM20395
 .;start new code abm*2.5*10 IM20395
 .F  S ABMCODE=$O(ABMRV(ABMREV,ABMCODE)) Q:ABMCODE=""  D
 ..S ABMCNTR=0
 ..F  S ABMCNTR=$O(ABMRV(ABMREV,ABMCODE,ABMCNTR)) Q:ABMCNTR=""  D
 ...D LOOP
 ;end new code IM20395
 ;K ABMREV,ABMCODE  ;abm*2.5*10 IM20395
 K ABMREV,ABMCODE,ABMCNTR  ;abm*2.5*10 IM20395
 Q
 ;
LOOP ;
 ;start old code IHS/SD/EFG V2.5 P8 IM16385
 ;; Quit if dental line item
 ;I $P(ABMRV(ABMREV,ABMCODE),U,2)]"",$P(ABMRV(ABMREV,ABMCODE),U,9)]"" Q
 ;end old code IHS/SD/EFG V2.5 P8 IM16385
 S ABMLXCNT=ABMLXCNT+1
 D EP^ABME8LX
 D WR^ABMUTL8("LX")
 D EP^ABME8SV2
 D WR^ABMUTL8("SV2")
 ;I $P(ABMRV(ABMREV,ABMCODE),"^",14)'="" D
 ;.D EP^ABME8SV4
 ;.D WR^ABMUTL8("SV4")
 ; There is 
 ;D EP^ABME8PWK
 ;D WR^ABMUTL8("PWK")
 ;start old code abm*2.5*10 IM20395
 ;I $P(ABMRV(ABMREV,ABMCODE),"^",10) D
 ;.D EP^ABME8DTP("472","D8",$P(ABMRV(ABMREV,ABMCODE),"^",10))
 ;I '$P(ABMRV(ABMREV,ABMCODE),"^",10) D
 ;end old code start new code IM20395
 I $P(ABMRV(ABMREV,ABMCODE,ABMCNTR),U,10) D
 .D EP^ABME8DTP("472","D8",$P(ABMRV(ABMREV,ABMCODE,ABMCNTR),U,10))
 I '$P(ABMRV(ABMREV,ABMCODE,ABMCNTR),U,10) D
 .;end new code IM20395
 .D EP^ABME8DTP(472,"D8",$P(ABMB7,"^",1))
 D WR^ABMUTL8("DTP")
 ;D EP^ABME8DTP(" ")
 ;D WR^ABMUTL8("DTP")
 ;D EP^ABME8AMT(" ")
 ;D WR^ABMUTL8("AMT")
 ;D EP^ABME8AMT(" ")
 ;D WR^ABMUTL8("AMT")
 ;
 ; Loop 2420A - Attending Physician
 ;start old code abm*2.5*10 IM20395
 ;I $P($G(ABMRV(ABMREV,ABMCODE)),U,15) D
 ;.S ABM("PRV")=$P(ABMRV(ABMREV,ABMCODE),U,15)
 ;end old code start new code IM20395
 I $P($G(ABMRV(ABMREV,ABMCODE,ABMCNTR)),U,15) D
 .S ABM("PRV")=$P(ABMRV(ABMREV,ABMCODE,ABMCNTR),U,15)
 .;end new code IM20395
 .Q:ABM("PRV")=$O(ABMP("PRV","A",0))
 .D EP^ABME8NM1("71")
 .D WR^ABMUTL8("NM1")
 .;D EP^ABME8PRV("AT",ABM("PRV"))
 .;D WR^ABMUTL8("PRV")
 .;start old code abm*2.5*11 NPI
 .;D EP^ABME8REF(ABMP("RTYPE"),200,ABM("PRV"))
 .;D WR^ABMUTL8("REF")
 .;end old code start new code NPI
 .I ABMNPIU="N" D  ;abm*2.5*12 IM25247
 ..D EP^ABME8REF("EI",9999999.06,DUZ(2))  ;abm*2.5*12 IM25247
 ..D WR^ABMUTL8("REF")  ;abm*2.5*12 IM25247
 .I ABMNPIU'="N" D
 ..D EP^ABME8REF(ABMP("RTYPE"),200,ABM("PRV"))
 ..D WR^ABMUTL8("REF")
 .;end new code NPI
 ;
 ; Loop 2420B - Operating Physician Name
 ;start old code abm*2.5*10 IM20395
 ;I $P($G(ABMRV(ABMREV,ABMCODE)),U,16) D
 ;.S ABM("PRV")=$P(ABMRV(ABMREV,ABMCODE),U,16)
 ;end old code start new code IM20395
 I $P($G(ABMRV(ABMREV,ABMCODE,ABMCNTR)),U,16) D
 .S ABM("PRV")=$P(ABMRV(ABMREV,ABMCODE,ABMCNTR),U,16)
 .;end new code IM20395
 .Q:ABM("PRV")=$O(ABMP("PRV","O",0))
 .D EP^ABME8NM1("72")
 .D WR^ABMUTL8("NM1")
 .;D EP^ABME8PRV("OP",ABM("PRV"))
 .;D WR^ABMUTL8("PRV")
 .;start old code abm*2.5*11 NPI
 .;D EP^ABME8REF(ABMP("RTYPE"),200,ABM("PRV"))
 .;D WR^ABMUTL8("REF")
 .;end old code start new code NPI
 .I ABMNPIU="N" D  ;abm*2.5*12 IM25247
 ..D EP^ABME8REF("EI",9999999.06,DUZ(2))  ;abm*2.5*12 IM25247
 ..D WR^ABMUTL8("REF")  ;abm*2.5*12 IM25247
 .I ABMNPIU'="N" D
 ..D EP^ABME8REF(ABMP("RTYPE"),200,ABM("PRV"))
 ..D WR^ABMUTL8("REF")
 .;end new code NPI
 ;
 ; Loop 2420C - Other Physician Name
 ;start old code abm*2.5*10 IM20395
 ;I $P($G(ABMRV(ABMREV,ABMCODE)),U,18) D
 ;.S ABM("PRV")=$P(ABMRV(ABMREV,ABMCODE),U,18)
 ;end old code start new code IM20395
 I $P($G(ABMRV(ABMREV,ABMCODE,ABMCNTR)),U,18) D
 .S ABM("PRV")=$P(ABMRV(ABMREV,ABMCODE,ABMCNTR),U,18)
 .;end new code IM20395
 .Q:ABM("PRV")=$O(ABMP("PRV","T",0))
 .D EP^ABME8NM1("73")
 .D WR^ABMUTL8("NM1")
 .;I $E(ABMP("BTYP"),2)=3 D
 .;.;D EP^ABME8PRV("PE",ABM("PRV"))
 .;I $E(ABMP("BTYP"),2)'=3 D
 .;.;D EP^ABME8PRV("OT",ABM("PRV"))
 .;D WR^ABMUTL8("PRV")
 .;start old code abm*2.5*11 NPI
 .;D EP^ABME8REF(ABMP("RTYPE"),200,ABM("PRV"))
 .;D WR^ABMUTL8("REF")
 .;end old code start new code NPI
 .I ABMNPIU="N" D  ;abm*2.5*12 IM25247
 ..D EP^ABME8REF("EI",9999999.06,DUZ(2))  ;abm*2.5*12 IM25247
 ..D WR^ABMUTL8("REF")  ;abm*2.5*12 IM25247
 .I ABMNPIU'="N" D
 ..D EP^ABME8REF(ABMP("RTYPE"),200,ABM("PRV"))
 ..D WR^ABMUTL8("REF")
 .;end new code NPI
 ;
 ; Loop 2420D - Referring Physician Name
 ;start old code abm*2.5*10 IM20395
 ;I $P($G(ABMRV(ABMREV,ABMCODE)),U,17) D
 ;.S ABM("PRV")=$P(ABMRV(ABMREV,ABMCODE),U,17)
 ;end old code start new code IM20395
 I $P($G(ABMRV(ABMREV,ABMCODE,ABMCNTR)),U,17) D
 .S ABM("PRV")=$P(ABMRV(ABMREV,ABMCODE,ABMCNTR),U,17)
 .;end new code IM20395
 .Q:ABM("PRV")=$O(ABMP("PRV","F",0))
 .D EP^ABME8NM1("DN")
 .D WR^ABMUTL8("NM1")
 .D EP^ABME8PRV("RF",ABM("PRV"))
 .D WR^ABMUTL8("PRV")
 .;start old code abm*2.5*11 NPI
 .;D EP^ABME8REF(ABMP("RTYPE"),200,ABM("PRV"))
 .;D WR^ABMUTL8("REF")
 .;end old code start new code NPI
 .I ABMNPIU="N" D  ;abm*2.5*12 IM25247
 ..D EP^ABME8REF("EI",9999999.06,DUZ(2))  ;abm*2.5*12 IM25247
 ..D WR^ABMUTL8("REF")  ;abm*2.5*12 IM25247
 .I ABMNPIU'="N" D
 ..D EP^ABME8REF(ABMP("RTYPE"),200,ABM("PRV"))
 ..D WR^ABMUTL8("REF")
 .;end new code NPI
 Q
