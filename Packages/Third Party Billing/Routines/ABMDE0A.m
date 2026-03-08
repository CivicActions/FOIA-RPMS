ABMDE0A ; IHS/SD/SDR - Claim Summary-Part 2 ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**31**;NOV 12, 2009;Build 615
 ;
 ;IHS/SD/SDR 10/10/02 2.5*2 OVA-0801-190113 Modified so Number of Errors Found field would be populated with
 ;   a number instead of "Y"
 ;IHS/SD/SDR 2.5*9 task 2 Added code for warning message if Immunization CPT exists
 ;
 ;IHS/SD/SDR 2.6*31 CR11832 Updated display to include PCC Visit Data section and move Pg3 to the top-right
 ;
 ; *********************************************************************
DISP ;EP - Entry Point from ABMDE0 for displaying claim summary
 S ABMZ("TITL")="CLAIM SUMMARY"
 S ABMZ("PG")=0
 D SUM^ABMDE1
 ;start old abm*2.6*31 IHS/SD/SDR CR11832
 ;I ABM("CNT2")>13&(ABM("CNT3")+ABM("CNT1")<14) D
 ;.S ABM("CNT2")=ABM("CNT2")-ABM("CNT3")
 ;.S ABM("CNT1")=ABM("CNT1")+ABM("CNT3")
 ;.S ABM("CNT3")=9
 ;D IDEN^ABMDE0B
 ;S ABM("C")=$S(ABM("CNT1")<12:7,1:6)
 ;D INS^ABMDE0B
 ;S ABM("C")=$S(ABM("CNT1")<12:ABM("C")+1,1:ABM("C"))
 ;D QUES^ABMDE0B
 ;S ABM("C2")=0
 ;F ABM="ACC","EMRG","PROG","EMPL" I @("ABM("""_ABM_""")")="YES" D
 ;.S ABM("C2")=ABM("C2")+1
 ;.S ABMZ(ABM("C"))=$S(ABM("C2")#2=1:"W !",1:ABMZ(ABM("C"))_",?20")_$P($T(@ABM),";;",2)
 ;.I ABM("C2")#2=0 D
 ;..S ABMZ(ABM("C"))=ABMZ(ABM("C"))_",?40,""|"""
 ;..D CNT
 ;I ABM("C2")#2=1 D
 ;.S ABMZ(ABM("C"))=ABMZ(ABM("C"))_",?40,""|"""
 ;.D CNT
 ;S ABM=$S(ABM("OPRV")]"":3,1:2)
 ;I ABM("CNT3")'=9 S ABM("C")=1
 ;I ABM("C")+ABM>14 S ABM("C")=1
 ;F ABM("I")=0:1:ABM-1 D
 ;.S ABMZ(ABM("C"))=$S(ABM("C")<5:ABMZ(ABM("C")),1:"W !")_$P($T(PRV+ABM("I")),";;",2)_$S(ABM("C")<5:"",1:",?40,""|""")
 ;.D CNT
 ;I ABM("C")>9 S ABM("C")=1
 ;F ABM("I")=4:1:13 S:'$D(ABMZ(ABM("I"))) ABMZ(ABM("I"))="W !?40,""|"""
 ;I ABMP("VTYP")=998&'$D(ABMP("FLAT")) G PRC
 ;S ABM("C")=$S(ABM("C")=1:1,ABM("CNT2")<6:ABM("C")+3,ABM("CNT2")<9:ABM("C")+2,ABM("CNT2")<12:ABM("C")+1,1:ABM("C"))
 ;F ABM("I")=0:1:5 D
 ;.I ABM("I")<1!($D(ABM("D"_ABM("I")))) D
 ;..S ABMZ(ABM("C"))=ABMZ(ABM("C"))_$P($T(DX+ABM("I")),";;",2)
 ;..D CNT
 ;;
 ;PRC ;
 ;S ABM("C")=$S(ABM("C")=1:1,ABM("CNT2")<6:ABM("C")+3,ABM("CNT2")<8:ABM("C")+2,ABM("CNT2")<12:ABM("C")+1,1:ABM("C"))
 ;S ABMZ(ABM("C"))=ABMZ(ABM("C"))_",""_______"_$S(ABMP("VTYP")=998&'$D(ABMP("FLAT")):" Pg-6 (Dental Services) ",ABMP("PX")="C":"_ Pg-8 (CPT Procedures) _",1:" Pg-5B (ICD Procedures) ")_"_______"""
 ;D CNT
 ;F ABM("I")=1:1:12 Q:ABM("C")>12  D
 ;.I $D(ABM("P"_ABM("I"))) D
 ;..S ABMZ(ABM("C"))=ABMZ(ABM("C"))_","_""" "_ABM("I")_") "_ABM("P"_ABM("I"))_""""
 ;..D CNT
 ;I ABM("C")>12,$D(ABM("P"_ABM("I"))) S ABMZ(13)=ABMZ(13)_","_$S('$D(ABM("P"_(ABM("I")+1))):""" "_ABM("I")_") "_ABM("P"_ABM("I"))_"""",1:""" *** additional procedures exist ***""")
 ;;
 ;S ABMZ(14)="W !,""________________________________________|_______________________________________"""
 ;F ABM("I")=1:1:14 X ABMZ(ABM("I"))
 ;end old start new abm*2.6*31 IHS/SD/SDR CR11832
 D IDEN^ABMDE0B
 D INS^ABMDE0B
 D PCC^ABMDE0B
 ;
 ;Questions
 S ABMZ(1)=ABMZ(1)_U_"__________ Pg-3 (Questions) ___________"
 S ABMZ(2)=ABMZ(2)_U_"Release Info: "_ABM("RELS")_"  Assign Benef: "_ABM("ASGN")
 ;
 ;Questions (cont)
 S ABMCNT=0
 F ABM="ACC","EMRG","PROG","EMPL" I @("ABM("""_ABM_""")")="YES" D
 .I ABMCNT<1 S ABMZ(3)=ABMZ(3)_$S(ABMZ(3)["^":"#",1:U)_$P($T(@ABM),";;",2)_ABM(ABM) S ABMCNT=ABMCNT+.5 Q
 .I ABMCNT<2 S ABMZ(4)=ABMZ(4)_$S(ABMZ(4)["^":"#",1:U)_$P($T(@ABM),";;",2)_ABM(ABM) S ABMCNT=ABMCNT+.5 Q
 .E  S ABMZ(5)=ABMZ(5)_$S(ABMZ(5)["^":"#",1:U)_$P($T(@ABM),";;",2)_ABM(ABM)
 .S ABMCNT=ABMCNT+.5
 ;
PRV ;
 ;Providers
 S $P(ABMZ(5),U,2)="__________ Pg-4 (Providers) ___________"
 S $P(ABMZ(6),U,2)="Attn: "_$G(ABM("APRV"))
 I $G(ABM("OPRV"))'="" S $P(ABMZ(7),U,2)="Oper: "_ABM("OPRV")
 ;
 ;Pxs
 ;I ABM("C")>9 S ABM("C")=1
 ;F ABM("I")=4:1:14 S:'$D(ABMZ(ABM("I"))) ABMZ(ABM("I"))="W !?40,""|"""
 ;I ABMP("VTYP")=998&'$D(ABMP("FLAT")) G PRC
 ;S ABM("C")=$S(ABM("C")=1:1,ABM("CNT2")<6:ABM("C")+3,ABM("CNT2")<9:ABM("C")+2,ABM("CNT2")<12:ABM("C")+1,1:ABM("C"))
 ;Dxs
DX ;
 S $P(ABMZ(8),U,2)="__________ Pg-5A (Diagnosis) __________"
 F ABM=1:1:3 D
 .I $D(ABM("D"_ABM)) S $P(ABMZ(8+ABM),U,2)=ABM_") "_ABM("D"_ABM)
 ;
PRC ;
 S $P(ABMZ(12),U,2)="_______"_$S(ABMP("VTYP")=998:" Pg-6 (Dental Services) ",ABMP("PX")="C":"_ Pg-8 (CPT Procedures) _",1:" Pg-5B (ICD Procedures) ")_"_______"
 F ABM("I")=1:1:3 D
 .I $G(ABM("P"_ABM("I")))'="" D
 ..S $P(ABMZ(12+ABM("I")),U,2)=ABM("I")_") "_ABM("P"_ABM("I"))
 I $G(ABM("P4"))'="" S $P(ABMZ(15),U,2)=" *** additional procedures exist ***"
 ;
 ;write page 0 detail lines
 F ABM("I")=1:1:15 D
 .S ABML=$P($G(ABMZ(ABM("I"))),U)
 .S ABMR=$P($G(ABMZ(ABM("I"))),U,2)
 .W !
 .I ABM("I")=15 W $$EN^ABMVDF("ULN")
 .I ABML["$" W $P(ABML,"$"),?30,$P(ABML,"$",2)
 .I ABML["%" W $P(ABML,"%"),?11,$P(ABML,"%",2) I 1
 .I ABML'["$"&(ABML'["%") W ABML
 .W ?40,"|"
 .I ABMR["#" W $P(ABMR,"#"),?60,$P(ABMR,"#",2)
 .E  W ABMR
 .I ABM("I")=15 W ?80,$$EN^ABMVDF("ULF")
 ;end new abm*2.6*31 IHS/SD/SDR CR11832
 ;
 ;
 ;
 I +$O(ABME(0)) D
 .S ABME("CHK")=""
 .D ^ABMDERR
 .I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,5)'=0 D
 ..S DIE="^ABMDCLM(DUZ(2),"
 ..S DA=ABMP("CDFN")
 ..S DR=".05////"_$G(ABM("ERR"))
 ..D ^DIE
 ..K DR
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),4)),U,2)="Y" D
 .W !,"***PCC Data was Edited without automatic Claim Update (check claim accuracy)***"
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DA=ABMP("CDFN")
 .S DR=".42///@"
 .D ^DIE
 .K DR
 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,4)="U" D  Q
 .W *7,!?5
 .W "Claim is CLOSED until a Payment is Posted for the Billed Insurer."
 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,4)="X" D  Q
 .W *7,!?5
 .W "Claim is CLOSED and therefore uneditable."
 ;
DUP ;check for duplicate claims
 S ABMPV=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,"AC","P",0))
 S I=0 F  S I=$O(^ABMDCLM(I)) Q:'I  D
 .Q:'ABMPV
 .Q:I=DUZ(2)
 .Q:'$D(^ABMDCLM(I,"AV",ABMPV))
 .S ABMCLNM=$O(^ABMDCLM(I,"AV",ABMPV,0))
 .W !,*7,"WARNING: Potential duplicate claim detected. Claim number "
 .W ABMCLNM,!,"Location ",$P(^DIC(4,I,0),U)
 K ABMCLNM,ABMPV
 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,5) W *7,!?5,"*** Claim File ERRORS exist use the VIEW command to list them. ***"
 ;
 F ABMCPT=90656,90658,90732,90746,90747,"G0008","G0009","G0010" S ABMLIST(ABMCPT)=""
 I $G(ABMVDFN)'="" S ABMCFLG=$$CPTCHK^ABMCPTCK(ABMVDFN,.ABMLIST)
 I $G(ABMCFLG)=1,$P($G(^AUTNINS(ABMP("INS"),0)),U)["MEDICARE" W !!,"THESE SERVICES MUST BE ITEMIZED AND BILLED SEPARATELY FROM THE ALL-INCLUSIVE RATE VISIT",!
 K ABMLIST
XIT ;
 Q
 ;
 ;start old abm*2.6*31 IHS/SD/SDR CR11832
 ;EMRG ;;,"Emrg Related: ",ABM("EMRG")
 ;PROG ;;,"Spcl Program: ",ABM("PROG")
 ;ACC ;;,"Accident Rel: ",ABM("ACC")
 ;EMPL ;;,"Empl Related: ",ABM("EMPL")
 ;;
 ;PRV ;;,"__________ Pg-4 (Providers) ___________"
 ;;;," Attn: ",ABM("APRV")
 ;;;," Oper: ",ABM("OPRV")
 ;;
 ;DX ;;,"__________ Pg-5A (Diagnosis) __________"
 ;;;," 1) ",ABM("D1")
 ;;;," 2) ",ABM("D2")
 ;;;," 3) ",ABM("D3")
 ;;;;," 4) ",ABM("D4")
 ;;;;," 5) ",ABM("D5")
 ;end old start new abm*2.6*31 IHS/SD/SDR CR11832
EMRG ;;Emrg Related: 
PROG ;;Spcl Program: 
ACC ;;Accident Rel: 
EMPL ;;Empl Related: 
 ;
 ;end new abm*2.6*2 IHS/SD/SDR CR11832
 ;
CNT S ABM("C")=ABM("C")+1
 Q
