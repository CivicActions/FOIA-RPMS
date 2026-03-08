ABMERGR3 ; IHS/SD/SDR - GET ANCILLARY SVCS REVENUE CODE INFO ; 
 ;;2.6;IHS Third Party Billing;**1,3,6,8,9,14,21,23,29**;NOV 12, 2009;Build 562
 ;Original;DMJ;03/20/96 9:07 AM
 ;
 ;IHS/SD/SDR 2.5 p9 split routine for size
 ;IHS/SD/SDR 2.5 p10 IM20395 Split out lines bundled by Rev code
 ;IHS/SD/SDR 2.5 p10 IM21539 Made anes amt just use base charge
 ;IHS/SD/SDR 2.5 p12 IM24093 Put description in array if J-code
 ;
 ;IHS/SD/SDR 2.6 CSV
 ;IHS/SD/SDR 2.6*1 HEAT6566 Populate anes based on MCR/non-MCR
 ;IHS/SD/SDR 2.6*3 HEAT12742 Correction to MCR/non-MCR; removed all HEAT6566 changes
 ;IHS/SD/SDR 2.6*6 5010 added 5010 prompts to 43 multiple
 ;IHS/SD/SDR 2.6*21 HEAT106899 Get operating and rendering provider for 43 mult.
 ;IHS/SD/SDR 2.6*21 HEAT120880 Added code for SERVICE DATE TO in ABMRV array for all multiples.
 ;IHS/SD/AML 2.6*23 HEAT247169 For 43 subfile add NDC to array
 ;IHS/SD/SDR 2.6*23 HEAT347035 Changed subscripts if there is a print order to be used
 ;IHS/SD/SDR 2.6*29 split routine to ABMERGR6 and ABMERGR7 due to routine size
 ;IHS/SD/AML 2.6*29 CR10888 Mods for Medi-Cal to print 0 or 00 for units,charges based on DOS
 ;IHS/SD/SDR 2.6*29 CR10410 Medicare non-covered changes
 ;
37 ;EP - Laboratory
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,DA)) Q:'DA  D
 .F J=1:1:8 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,DA,0),"^",J)
 .S:'+ABM(3) ABM(3)=1
 .S ABM(1)=$S(ABM(1):$P($$CPT^ABMCVAPI(ABM(1),ABMP("VDT")),U,2),1:0)  ; CPT Code  ;CSV-c
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U)=ABM(2)  ;Revenue code IEN
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,2)=ABM(1)  ;CPT Code
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,3)=ABM(6)  ;Modifier
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,4)=ABM(7)  ;2nd modifier
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,5)=ABM(3)  ;units
 .;S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,6)=(ABM(3)*ABM(4))  ;charges  ;abm*2.6*29 IHS/SD/SDR CR10410
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,8)=ABM(4)  ;Unit Charge
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,10)=ABM(5)  ;Date/Time
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,12)=ABM(8)  ;3rd Modifier
 .D GYCHK^ABMDESM1(+ABM(2),ABM(1),ABMLCNT,ABM(3),ABM(4))  ;covered vs non-covered charges  ;abm*2.6*29 IHS/SD/SDR CR10410
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,27)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,DA,0)),U,12)  ;abm*2.6*21 HEAT120880
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,DA,2)),U)  ;abm*2.6*8 5010 LICN
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,39)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,DA,2)),U,2)  ;abm*2.6*9 NARR
 .;start new abm*2.6*23 HEAT347035
 .I +$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,DA,0)),U,23)'=0 D
 ..I $P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,24)'="Y" Q  ;don't do print order if parameter is off
 ..S ABMPO=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,DA,0)),U,23)
 ..S ABMRV(ABMPO,ABMPO,ABMPO)=$G(ABMRV(+ABM(2),ABM(1),ABMLCNT))
 ..K ABMRV(+ABM(2),ABM(1),ABMLCNT)
 ..;start old abm*2.6*29 IHS/SD/AML CR10888
 ..;I +$P(ABMRV(ABMPO,ABMPO,ABMPO),U,6)=0 S $P(ABMRV(ABMPO,ABMPO,ABMPO),U)=0,$P(ABMRV(ABMPO,ABMPO,ABMPO),U,5)=0
 ..;I $$RCID^ABMUTLP(ABMP("INS"))["61044",$P(ABMRV(ABMPO,ABMPO,ABMPO),U,5)=0 S $P(ABMRV(ABMPO,ABMPO,ABMPO),U,5)="00"
 ..;end old start new abm*2.6*29 IHS/SD/AML CR10888
 ..I (($P($G(^AUTNINS(ABMP("INS"),0)),U)["O/P MEDI-CAL"))&(ABMP("VDT")<3190101) D
 ...I +$P(ABMRV(ABMPO,ABMPO,ABMPO),U,6)=0 S $P(ABMRV(ABMPO,ABMPO,ABMPO),U)=0,$P(ABMRV(ABMPO,ABMPO,ABMPO),U,5)=0
 ...I $$RCID^ABMUTLP(ABMP("INS"))["61044",$P(ABMRV(ABMPO,ABMPO,ABMPO),U,5)=0 S $P(ABMRV(ABMPO,ABMPO,ABMPO),U,5)="00"
 ...;end new abm*2.6*29 IHS/SD/AML CR10888
 .;end new abm*2.6*23 HEAT347035
 Q
39 ;EP - Anesthesia
 S DA=0
 F  S DA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),39,DA)) Q:'DA  D
 .F J=1:1:6,11,14,19 S ABM(J)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),39,DA,0),"^",J)
 .S ABM(1)=$S(ABM(1):$P($$CPT^ABMCVAPI(ABM(1),ABMP("VDT")),U,2),1:0)  ;CPT Code  ;CSV-c
 .S ABMLCNT=+$G(ABMLCNT)+1
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U)=ABM(2)  ;Revenue code IEN
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,2)=ABM(1)  ;CPT code
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,3)=ABM(6)  ;Modifier
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,4)=ABM(14)  ;2nd Modifier
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,5)=1  ;units
 .;S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,6)=ABM(4)  ;charges  ;abm*2.6*1 HEAT6566  ;abm*2.6*29 IHS/SD/SDR CR10410
 .;I ($G(ABMP("ITYP"))'="R")!($G(ABMP("ITYPE"))'="R") S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,6)=ABM(4)  ;charges  ;abm*2.6*1 HEAT6566  abm*2.6*3 HEAT12742
 .;I ($G(ABMP("ITYP"))="R")!($G(ABMP("ITYPE"))="R") S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,6)=ABM(4)  ;charges  ;abm*2.6*3 HEAT12742
 .;I ($G(ABMP("ITYP"))="R")!($G(ABMP("ITYPE"))="R") S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,6)=ABM(3)+ABM(4)  ;charges  ;abm*2.6*1 HEAT6566 ;abm*2.6*3 HEAT12742
 .;I ($G(ABMP("ITYP"))'="R")!($G(ABMP("ITYPE"))'="R") S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,6)=ABM(3)+ABM(4)  ;charges  ;abm*2.6*3 HEAT12742
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,10)=ABM(5)  ;Date/time of service
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,12)=ABM(19)  ;3rd Modifier
 .D GYCHK^ABMDESM1(+ABM(2),ABM(1),ABMLCNT,ABM(4),1)  ;covered vs non-covered charges  ;abm*2.6*29 IHS/SD/SDR CR10410
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,18)=ABM(11)  ;Other Provider
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,27)=ABM(5)  ;abm*2.6*21 IHS/SD/SDR HEAT120880
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,38)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),39,DA,2)),U)  ;abm*2.6*8 5010 LICN
 .S $P(ABMRV(+ABM(2),ABM(1),ABMLCNT),U,39)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),39,DA,2)),U,2)  ;abm*2.6*9 NARR
 .;start new abm*2.6*23 IHS/SD/SDR HEAT347035
 .I +$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),39,DA,0)),U,23)'=0 D
 ..I $P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,24)'="Y" Q  ;don't do print order if parameter is off
 ..S ABMPO=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),39,DA,0)),U,23)
 ..S ABMRV(ABMPO,ABMPO,ABMPO)=$G(ABMRV(+ABM(2),ABM(1),ABMLCNT))
 ..K ABMRV(+ABM(2),ABM(1),ABMLCNT)
 ..;start old abm*2.6*29 IHS/SD/AML CR10888
 ..;I +$P(ABMRV(ABMPO,ABMPO,ABMPO),U,6)=0 S $P(ABMRV(ABMPO,ABMPO,ABMPO),U)=0,$P(ABMRV(ABMPO,ABMPO,ABMPO),U,5)=0
 ..;I $$RCID^ABMUTLP(ABMP("INS"))["61044",$P(ABMRV(ABMPO,ABMPO,ABMPO),U,5)=0 S $P(ABMRV(ABMPO,ABMPO,ABMPO),U,5)="00"
 ..;end old start new abm*2.6*29 IHS/SD/AML CR10888
 ..I (($P($G(^AUTNINS(ABMP("INS"),0)),U)["O/P MEDI-CAL"))&(ABMP("VDT")<3190101) D
 ...I +$P(ABMRV(ABMPO,ABMPO,ABMPO),U,6)=0 S $P(ABMRV(ABMPO,ABMPO,ABMPO),U)=0,$P(ABMRV(ABMPO,ABMPO,ABMPO),U,5)=0
 ...I $$RCID^ABMUTLP(ABMP("INS"))["61044",$P(ABMRV(ABMPO,ABMPO,ABMPO),U,5)=0 S $P(ABMRV(ABMPO,ABMPO,ABMPO),U,5)="00"
 ...;end new abm*2.6*29 IHS/SD/AML CR10888
 .;end new abm*2.6*23 HEAT347035
 Q
