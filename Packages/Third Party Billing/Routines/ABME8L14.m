ABME8L14 ; IHS/ASDST/DMJ - Header [ 10/16/2003  9:46 AM ]
 ;;2.5;IHS 3P BILLING SYSTEM;**1,3,8,11,12**;APR 05, 2002
 ;Header Segments
 ;
 ; IHS/SD/SDR - V2.5 P8 - IM12418/IM14732/IM16264/IM16363/IM16618
 ;    Treat rendering/attending the same
 ;
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ;
 ; IHS/SD/SDR - v2.5 p12 - IM25247
 ;   Add missing REG segment for TIN if NPI ONLY
 ;
EP ;START HERE
 N ABM
 D GETPRV^ABMEEPRV             ; Build Claim Level Provider array
 ;
 ; Loop 2310A - Referring Physician Name
 I $D(ABMP("PRV","F")) D
 .S ABM("PRV")=$O(ABMP("PRV","F",0))
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
 ;
 ; Loop 2310B - Rendering Physician Name
 ;start old code IHS/SD/SDR V2.5 P8 IM12418
 ;I $D(ABMP("PRV","R")) D
 ;.S ABM("PRV")=$O(ABMP("PRV","R",0))
 ;end old code start new code
 I $D(ABMP("PRV","R"))!($D(ABMP("PRV","A"))) D
 .S ABM("PRV")=$S($D(ABMP("PRV","R")):$O(ABMP("PRV","R",0)),1:$O(ABMP("PRV","A",0)))
 .;end new code IHS/SD/SDR V2. 5P8 IM12418
 .D EP^ABME8NM1("82")
 .D WR^ABMUTL8("NM1")
 .D EP^ABME8PRV("PE",ABM("PRV"))
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
 ;
 ; Loop 2310C - Service Facility Name
 I "21^22^31^35"[$$POS^ABMERUTL() D
 .D EP^ABME8NM1("FA")
 .D WR^ABMUTL8("NM1")
 .;start old code abm*2.5*11 NPI
 .;I ABMP("ITYPE")="R" D
 .;.D EP^ABME8REF("1C",9999999.06,ABMP("LDFN"))
 .;.D WR^ABMUTL8("REF")
 .;I ABMP("ITYPE")="D"!(ABMP("ITYPE")="K") D
 .;.D EP^ABME8REF("1D",9999999.06,ABMP("LDFN"))
 .;.D WR^ABMUTL8("REF")
 .;end old code start new code NPI
 .I ABMNPIU'="N" D
 ..I ABMP("ITYPE")="R" D
 ...D EP^ABME8REF("1C",9999999.06,ABMP("LDFN"))
 ...D WR^ABMUTL8("REF")
 ..I ABMP("ITYPE")="D"!(ABMP("ITYPE")="K") D
 ...D EP^ABME8REF("1D",9999999.06,ABMP("LDFN"))
 ...D WR^ABMUTL8("REF")
 .;end new code NPI
 Q
