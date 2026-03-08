ABMDE0B ; IHS/SD/SDR - Claim Summary-Part 2 ; 
 ;;2.6;IHS 3P BILLING SYSTEM;**31**;NOV 12, 2009;Build 615
 ;IHS/SD/SDR 2.6*31 CR11832 Updated display to include PCC Visit Data section and move Pg3 to the
 ;   top-right; rewrite to make it easier to support (little or no counters)
 ;
 ; *********************************************************************
 ;start old abm*2.6*31 IHS/SD/SDR CR11832
 ;IDEN ;EP - Entry Point from ABMDE0A for Iden display
 ;S ABMZ(1)="W !,""_______ Pg-1 (Claim Identifiers) ________|"""
 ;S ABMZ(2)="W !,""Location..: "",ABM(1),?40,""|"""
 ;S ABMZ(3)="W !,""Clinic....: "",ABM(2),?40,""|"""
 ;S ABMZ(4)="W !,""Visit Type: "",ABM(3),?40,""|"""
 ;S ABMZ(5)="W !,""Bill From: "",ABM(4),"" Thru: "",ABM(5),?40,""|"""
 ;Q
 ;
 ; *********************************************************************
 ;start old abm*2.6*31 IHS/SD/SDR CR11832
 ;INS ;EP - Entry Point from ABMDE0A for Insurer display
 ;S ABMZ(ABM("C"))="W !,""________ Pg-2 (Billing Entity) _________|"""
 ;D CNT
 ;I '$D(ABM("I1")) D
 ;.S ABM("I1")="NO COVERAGE FOUND"
 ;.S ABM("I1S")=""
 ;S ABMZ(ABM("C"))="W !,ABM(""I1""),?30,ABM(""I1S""),?40,""|"""
 ;D CNT
 ;;
 ;I2 ;
 ;I $D(ABM("I2")),ABM("I2")]"" D
 ;.S ABMZ(ABM("C"))="W !,ABM(""I2""),?30,ABM(""I2S""),?40,""|"""
 ;.D CNT
 ;;
 ;I3 ;
 ;I $D(ABM("I3")),ABM("I3")]"" D
 ;.S ABMZ(ABM("C"))="W !,ABM(""I3""),?30,ABM(""I3S""),?40,""|"""
 ;.D CNT
 ;Q
 ;
 ; ***********************************************
 ;QUES ;EP - Entry Point from ABMDE0A for questions display
 ;S ABMZ(ABM("C"))="W !,""___________ Pg-3 (Questions) ___________|"""
 ;D CNT
 ;S ABMZ(ABM("C"))="W !,""Release Info: "",ABM(""RELS""),?20,""Assign Benef: "",ABM(""ASGN""),?40,""|"""
 ;D CNT
 ;Q
 ;end old start new abm*2.6*31 IHS/SD/SDR CR11832
IDEN ;EP - Entry Point from ABMDE0A for Iden display
 S ABMZ(1)="_______ Pg-1 (Claim Identifiers) _______"
 S ABMZ(2)="Location..: "_ABM(1)
 S ABMZ(3)="Clinic....: "_ABM(2)
 S ABMZ(4)="Visit Type: "_ABM(3)
 S ABMZ(5)="Bill From: "_ABM(4)_" Thru: "_ABM(5)
 Q
INS ;EP - Entry Point from ABMDE0A for Insurer display
 S ABMZ(6)="________ Pg-2 (Billing Entity) _________"
 I '$D(ABM("I1")) D
 .S ABM("I1")="NO COVERAGE FOUND"
 .S ABM("I1S")=""
 S ABMZ(7)=ABM("I1")_"$"_ABM("I1S")
 ;
I2 ;
 I $D(ABM("I2")),ABM("I2")]"" D
 .S ABMZ(8)=ABM("I2")_"$"_ABM("I2S")
 ;
I3 ;
 I $D(ABM("I3")),ABM("I3")]"" D
 .S ABMZ(9)=ABM("I3")_"$"_ABM("I3S")
 Q
PCC ;EP - Entry Point for PCC data
 D GETPCC  ;calculate PCC date for this section
 S ABMZ(10)="____________ PCC Visit Data ____________"
 ;
 I +$G(ABMT("PRIMV"))=0 D
 .S ABMZ(11)="No PCC data associated with this claim"
 ;
 I +$G(ABMT("PRIMV"))'=0 D
 .S ABMZ(11)="Prim Visit: "_ABMT("PVDTTM")_"$Count: "_ABMT("VCNT")
 .S ABMZ(12)="Srv Cat: "_ABMT("SC")_"%Hsp Loc: "_ABMT("HOSLOC")
 ;
 I ABMT("LSTVDTTM")="No Last Visit Found" D  Q
 .S ABMZ(13)="Last Visit: "_ABMT("LSTVDTTM")
 .S ABMZ(14)=""
 ;
 S ABMZ(13)="Last Visit: "_ABMT("LSTVDTTM")_"$Loc: "_ABMT("LSTVLOC")
 S ABMZ(14)="Srv Cat: "_ABMT("LSTSC")_"%Cl:"_ABMT("LSTCLN")_"  Hsp Loc: "_ABMT("LSTHOSLOC")
 Q
GETPCC ;
 S ABMT("VDFN")=0
 S ABMT("PRIMV")=0
 S ABMVFLG=0
 S ABMT("VCNT")=0
 F  S ABMT("VDFN")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,ABMT("VDFN"))) Q:'ABMT("VDFN")  D
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,ABMT("VDFN"),0)),U,2)="P" S ABMT("PRIMV")=ABMT("VDFN")
 .S ABMT("VCNT")=ABMT("VCNT")+1
 I +$G(ABMT("PRIMV"))'=0 D
 .S ABMT("PVDTTM")=$$CDT^ABMDUTL($P($G(^AUPNVSIT(ABMT("PRIMV"),0)),U))
 .S ABMT("SC")=$P($G(^AUPNVSIT(ABMT("PRIMV"),0)),U,7)
 .S ABMT("HOSLOC")="<none>"
 .S:+$P($G(^AUPNVSIT(ABMT("PRIMV"),0)),U,22)'=0 ABMT("HOSLOC")=$E($P($G(^SC($P($G(^AUPNVSIT(ABMT("PRIMV"),0)),U,22),0)),U),1,17)
 S ABMLVST=0 D LASTVST
 Q
LASTVST ;
 I +$G(ABMLVST)=0 S ABMLVST=0
 S ABMLVST=+$O(^AUPNVSIT("AA",ABMP("PDFN"),ABMLVST))
 I ABMLVST=0 S ABMT("LSTVDTTM")="No Last Visit Found" Q
 S ABMT("LASTVST")=+$O(^AUPNVSIT("AA",ABMP("PDFN"),ABMLVST,0))
 I $P($G(^AUPNVSIT(ABMT("LASTVST"),0)),U,11)=1 G LASTVST  ;visit deleted, go get another one
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,ABMT("LASTVST"))) G LASTVST  ;don't count visits on this claim
 I "^C^N^E^X^"[("^"_$P($G(^AUPNVSIT(ABMT("LASTVST"),0)),U,7)_"^") G LASTVST  ;skip Service Categories we don't bill
 I (+$G(ABMVDFN)'=0) I ($P($G(^AUPNVSIT(ABMT("LASTVST"),0)),U)>$P($G(^AUPNVSIT(ABMVDFN,0)),U)) G LASTVST  ;we want a DOS before the primary DOS on this claim
 I ABMT("LASTVST")=0 S ABMT("LSTVDTTM")="No Last Visit Found" Q
 I (+$G(ABMT("PRIMV"))'=0),(ABMT("LASTVST")=ABMT("PRIMV")) S ABMT("LSTVDTTM")="No Last Visit Found" Q
 S ABMT("LSTVDTTM")=$$CDT^ABMDUTL($P($G(^AUPNVSIT(ABMT("LASTVST"),0)),U))
 S ABMT("LSTSC")=$P($G(^AUPNVSIT(ABMT("LASTVST"),0)),U,7)
 S ABMT("LSTVLOC")=$P($G(^AUTTLOC($P($G(^AUPNVSIT(ABMT("LASTVST"),0)),U,6),0)),U,7)
 S ABMT("LSTCLN")=$S(+$P($G(^AUPNVSIT(ABMT("LASTVST"),0)),U,8)'=0:$P($G(^DIC(40.7,$P($G(^AUPNVSIT(ABMT("LASTVST"),0)),U,8),0)),U,2),1:"none")
 S ABMT("LSTHOSLOC")="<none>"
 S:+$P($G(^AUPNVSIT(ABMT("LASTVST"),0)),U,22)'=0 ABMT("LSTHOSLOC")=$E($P($G(^SC($P($G(^AUPNVSIT(ABMT("LASTVST"),0)),U,22),0)),U),1,11)
 Q
 ;end new abm*2.6*31 IHS/SD/SDR CR11832
 ;
 ;start old abm*2.6*31 IHS/SD/SDR CR11832
 ;; ***********************************************
 ;CNT ;
 ;S ABM("C")=ABM("C")+1
 ;Q
 ;end old abm*2.6*31 IHS/SD/SDR CR11832
