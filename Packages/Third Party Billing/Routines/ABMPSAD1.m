ABMPSAD1 ; IHS/SD/SDR - Add Pharmacy POS COB Bill Manually ;   
 ;;2.6;IHS Third Party Billing;**36,37**;NOV 12, 2009;Build 739
 ;
 ;IHS/SD/SDR 2.6*36 ADO76247 New routine; create a manual COB bill for Pharmacy POS claims - eligibility
 ;IHS/SD/SDR 2.6*37 ADO76009 Updated array ABMPL to match other COB changes
 ;
MSG ;
 W !!?2,"This option is intended to create a bill for a Pharmacy POS bill after"
 W !?2,"it has been billed and posted to the primary insurer.  You'll be prompted"
 W !?2,"to select a Patient/Bill#/RX# and then update the data and approve to"
 W !?2,"the next bill number (i.e., if you select an A-bill and approve it, you"
 W !?2,"you will get a B-bill)."
 W !!?2,$$EN^ABMVDF("HIN"),"WARNING: ",$$EN^ABMVDF("HIF")
 W "coverage must be active and a diagnosis code is needed to"
 W !?2,"approve the bill.  You will be able to change the bill amount but"
 W !?2," remember the bill amount and the payments/adjustments must balance"
 W !?2,"for an 837 claim or it will reject."
 W !!?2,$$EN^ABMVDF("HIN"),"Finally ",$$EN^ABMVDF("HIF"),"changes made will not be saved until you select 'Approve'."
 W !?2,"If you 'Quit' from a bill you will lose any edits that were made."
 Q
SETVARS ;
 S ABMBNUM=+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U)
 S (ABMP("VDT"),ABMVDT)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U)
 S ABMDISDT=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U,2)
 S (ABMP("PDFN"),DFN)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,5)
 S ABMP("LDFN")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,3)
 S ABMP("EXP")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,6)
 S ABMDATA("OTHBILLID")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),1)),U,15)
 ;
 ; Loop through the insurer multiple, if the insurer is active and is
 ; the same as the active insurer, mark that insurer as complete.
 S DA=0
 S I=0
 F  S I=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I)) Q:'I  D
 .I $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I,0),"^",3)="I",$P(^(0),"^",1)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),"^",8) S DA=I
 .I $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I,0),"^",3)="I",$P(^(0),"^",11)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),"^",8) S DA=I
 ;
 S ABMDATA("INS")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,8)
 S ABMDATA("ITYP")=$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABMDATA("INS"),".211","I"),1,"I")
 S (ABMP("VTYP"),ABMDATA("VT"))=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,7)
 S ABMDATA("EXP")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,6)
 S ABMDATA("RESUB")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),4)),U,9)
 S ABMDATA("BAMT")=+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),2)),U,7)  ;original bill amount
 S:(ABMDATA("BAMT")=0) ABMDATA("BAMT")=$FN($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),2)),U),",",2)
 S ABMP("OBAMT")=ABMDATA("BAMT")
 ;
SETVAR2 ;
 S ABMINS=0
 F  S ABMINS=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMINS)) Q:+ABMINS=0  D
 .S ABMIIEN=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMINS,0)),U)
 .S ABMPRI=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMINS,0)),U,2)
 .S ABMSTAT=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMINS,0)),U,3)
 .Q:ABMSTAT'="I"&(ABMSTAT'="C")
 .;S ABMPL(ABMPRI,ABMIIEN)=ABMINS_"^"_ABMSTAT  ;abm*2.6*37 IHS/SD/SDR ADO76009
 .S ABMPL(ABMPRI,ABMIIEN,1)=ABMIIEN_"^C"  ;abm*2.6*37 IHS/SD/SDR ADO76009
 ;;
 S ABMI=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,99),-1)
 S ABMDATA("IPRI")=($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMI,0)),U,2)+1)
 S ABMDATA("CBAMT")=+$G(ABMP("CBAMT"))
 K ABMFLG("ABMPSADD")
 Q
ELG ;
 S ABM("VACHK")=0
 S Y=^AUPNPAT(DFN,0)
 S ABM("EMPLOYED")=+$P(Y,U,21)
 I ABM("EMPLOYED")=3 S ABM("EMPLOYED")=0
 F ABM("PROC")=5,3,2,4,7,6 D
 .S (ABM("COV"),ABM("MDFN"))=""
 .K ABM("FLG"),ABM("XIT")
 .D @ABM("PROC")
 ;
 I $D(ABML(1)) D
 .I $O(ABML(1,$O(ABML(1,"")))) D
 ..S P=96
 ..F  S P=$O(ABML(P),-1) Q:'P  D
 ...S I=0
 ...F  S I=$O(ABML(P,I)) Q:'I  D
 ....I I'=ABM("PRIMARY") D
 .....M ABML(P+1,I)=ABML(P,I)
 .....K ABML(P,I)
 .K ABML(97),ABML(99)  ;we only want to see billable options
 ;
 ;this is a list of active insurers the user can select to bill
 K ABMLST
 S ABMA=0
 F  S ABMA=$O(ABML(ABMA)) Q:'ABMA  D
 .S ABMB=0
 .F  S ABMB=$O(ABML(ABMA,ABMB)) Q:'ABMB  D
 ..I $P($G(ABML(ABMA,ABMB)),U,2)=""!(ABMP("VDT")'>$P($G(ABML(ABMA,ABMB)),U,2)) S ABMLST(ABMB)=$P($G(ABML(ABMA,ABMB)),U,6)
XIT ; XIT
 K ABM,ABMLX
 Q
2 ; Medicare Elig Chk
 K ABM("XIT")
 S ABM("PRI")=$S(ABM("EMPLOYED")=5:1,1:3)
 S ABM("TYP")="M"
 D PRIO^ABMDLCK
 ;After setting priority we check medicare eligibility file
 Q:'$D(^AUPNMCR(DFN,0))
 S ABM("INS")=$$MCRIEN(ABMVDT)
 K ABM("REC")
 ;Node 11 has the Medicare Part A and/or B eligibility
 S ABMELGDT=0
 S ABM("MDFN")=0
 F  S ABM("MDFN")=$O(^AUPNMCR(DFN,11,ABM("MDFN"))) Q:'ABM("MDFN")  D 23
 I 'ABMELGDT D  Q
 .I '$D(ABML(ABM("PRI"),ABM("INS"))) D
 ..I '$D(ABML(99,ABM("INS"))) D
 ...S $P(ABML(99,ABM("INS")),U)=$G(DFN)
 ...S $P(ABML(99,ABM("INS")),U,2)=$G(ABM("MDFN"))
 ...S $P(ABML(99,ABM("INS")),U,3)="M"
 ..S $P(ABML(99,ABM("INS")),U,6)=34
 E  I $D(ABML(ABM("PRI"),ABM("INS"))),ABM("PRI")<97 D
 .I $G(ABM("XIT"))="A" K ABML(ABM("PRI"),ABM("INS"),"COV",ABM("CV"))
 Q
 ;
MCRIEN(X) ;EP - determine medicare fi on visit date
 N I,Y
 S Y=0
 S I=0
 F  S I=$O(^AUTNINS(2,12,I)) Q:'I  D
 .S ABM0=^AUTNINS(2,12,I,0)
 .Q:'$P(ABM0,"^",2)
 .Q:$P(ABM0,"^",2)>X
 .I $P(ABM0,"^",3),$P(ABM0,"^",3)<X Q
 .S Y=I
 I 'Y S Y=$O(^AUTNINS("B","MEDICARE",0))
 Q Y
 ;
23 ;
 S ABM("REC")=^AUPNMCR(DFN,11,ABM("MDFN"),0)
 I $P(ABM("REC"),U,1)>$P($S(ABMDISDT:ABMDISDT,1:ABMVDT),".",1) Q
 I $P(ABM("REC"),U,2)]"" Q:$P(ABM("REC"),U,2)<$P(ABMVDT,".",1)
 S ABMELGDT=1
 S COV=$P(ABM("REC"),U,3)
 ;For A or B get ien from ^AUTTPIC file
 I COV]"" S ABM("COV")=$O(^AUTTPIC("AC",ABM("INS"),COV,""))
 E  S ABM("COV")=""
 I ABM("COV")'="" S ABM("COV")=$P($G(^AUTTPIC(ABM("COV"),0)),U,3)
 I '$D(ABML(ABM("PRI"),ABM("INS"))) S ABML(ABM("PRI"),ABM("INS"))=$P(ABM("REC"),U,1)_U_$P(ABM("REC"),U,2)_U_"M"_U_ABM("MDFN")_U_U_ABM("COV")
 E  S $P(ABML(ABM("PRI"),ABM("INS")),U,6)=$P(ABML(ABM("PRI"),ABM("INS")),U,6)_","_ABM("COV")
 K CV
 Q
3 ; RailRoad Elig Chk
 K ABM("XIT")
 S ABM("PRI")=$S(ABM("EMPLOYED")=5:1,1:3)
 S ABM("TYP")="R"
 D PRIO^ABMDLCK
 Q:'$D(^AUPNRRE(DFN,0))
 S ABM("INS")=$O(^AUTNINS("B","RAILROAD RETIREMENT",""))
 I '+ABM("INS") S ABME(168)="" Q
 K ABM("REC")
 K ABMGOOD
 S ABM("MDFN")=0
 F  S ABM("MDFN")=$O(^AUPNRRE(DFN,11,ABM("MDFN"))) Q:'ABM("MDFN")  D
 .D 33
 I '$G(ABMGOOD) D
 .S $P(ABML(99,ABM("INS")),"^",6)=35
 K COV
 Q
 ;
33 ;
 S ABM("REC")=^AUPNRRE(DFN,11,ABM("MDFN"),0)
 ; 35 ; RailRoad coverage; visit outside eligibility dates
 I $P(ABM("REC"),U,1)>$P($S(ABMDISDT:ABMDISDT,1:ABMVDT),".",1) Q
 I $P(ABM("REC"),U,2)]"",$P(ABM("REC"),U,2)<$P(ABMVDT,".",1) Q
 S ABMGOOD=1
 S COV=$P(ABM("REC"),U,3)
 I COV]"" S ABM("COV")=$O(^AUTTPIC("AC",ABM("INS"),COV,""))
 E  S ABM("COV")=""
  I ABM("COV")'="" S ABM("COV")=$P($G(^AUTTPIC(ABM("COV"),0)),U,3)
 I '$D(ABML(ABM("PRI"),ABM("INS"))) S ABML(ABM("PRI"),ABM("INS"))=$P(ABM("REC"),U,1)_U_$P(ABM("REC"),U,2)_U_"R"_U_DFN_U_U_ABM("COV")
 E  S $P(ABML(ABM("PRI"),ABM("INS")),U,6)=$P(ABML(ABM("PRI"),ABM("INS")),U,6)_","_ABM("COV")
 Q
4 ;EP - Medicaid Elig Chk
 S ABM("PRI")=4
 S ABM("TYP")="D"
 D PRIO^ABMDLCK
 S ABM("INS")=$O(^AUTNINS("B","MEDICAID",""))
 I '+ABM("INS") S ABME(167)="" Q
 S ABM("MDFN")=""
 F  S ABM("MDFN")=$O(^AUPNMCD("B",DFN,ABM("MDFN"))) Q:'ABM("MDFN")  D 43
 Q
 ;
43 ;
 Q:$P($G(^AUPNMCD(ABM("MDFN"),0)),U)=""
 Q:$P($G(^AUPNMCD(ABM("MDFN"),0)),U,2)=""
 Q:$P($G(^AUPNMCD(ABM("MDFN"),0)),U,4)=""
 N ABMINS
 S ABM("REC")=$G(^AUPNMCD(ABM("MDFN"),0))
 S ABMINS=$P(ABM("REC"),U,2)
 D  Q:'ABM("INS")
 .Q:'$P(ABM("REC"),U,4)
 .S ABM("STATE")=$P(ABM("REC"),U,4)
 .I '$D(^AUTNINS(ABMINS,13,ABM("STATE"),0)) S ABME(101)=$P(^DIC(5,ABM("STATE"),0),U) Q
 .S ABM("INS")=$P(^AUTNINS(ABMINS,13,ABM("STATE"),0),U,2)
 .Q:'$P(ABM("REC"),"^",10)
 .S ABMPLAN=$$GET1^DIQ(9000004,ABM("MDFN"),.11)   ; Plan name
 .I ABMINS=3,ABM("STATE")=3,ABMPLAN["KIDS" S ABM("INS")=$P(ABM("REC"),U,10)
 .I ABMINS=3,ABM("STATE")=3,ABMPLAN["CHIP" S ABM("INS")=$P(ABM("REC"),U,10)
 .; Piece 5 in the 3P ins file is USE PLAN NAME? field
 .Q:'$P($G(^ABMNINS(DUZ(2),ABM("INS"),0)),"^",5)
 .; Piece 10 of Medicaid eligible file is Plan Name
 .S ABM("INS")=$P(ABM("REC"),U,10)
 ;If the insurer has been merged to another insurer use the one merged
 ;to.
 I $P($G(^AUTNINS(ABM("INS"),2)),U,7)]"" S ABM("INS")=$P(^(2),U,7)
 K ABM("SUB")
 S ABM("NDFN")=""
 ;If subfile 11 does not exist then no elig start and end date
 ; 39 ; Medicaid coverage; no eligibility date
 I '+$O(^AUPNMCD(ABM("MDFN"),11,0)) D   Q
 .S ABM("XIT")=1
 S ABMELGDT=0
 S ABM("NDFN")=0
 F  S ABM("NDFN")=$O(^AUPNMCD(ABM("MDFN"),11,ABM("NDFN"))) Q:'ABM("NDFN")  D
 .S ABM("SUB")=^AUPNMCD(ABM("MDFN"),11,ABM("NDFN"),0)
 .D 44
 Q
 ;
44 ;
 ;ABM("NDFN") is the start date.  2nd piece of ABM("SUB") is end date
 Q:ABM("NDFN")>$P($S(ABMDISDT:ABMDISDT,1:ABMVDT),".",1)
 I $P(ABM("SUB"),U,2)]"",$P(ABM("SUB"),U,2)<$P(ABMVDT,".",1) Q
 S ABMELGDT=1
 S ABM("COV")=$P(ABM("SUB"),U,3)
 ;This is the coverage type from the 11 multiple from Medicaid elg file
 ;This must match the plan code in coverage type file.
 K ABM("XIT")
 S ABML(ABM("PRI"),ABM("INS"))=$P(ABM("SUB"),U)_U_$P(ABM("SUB"),U,2)_U_"D"_U_ABM("MDFN")_U_ABM("NDFN")_U_ABM("COV")
 Q
5 ; Private Ins chk
 S ABM("PRI")=$S(ABM("EMPLOYED")=5:3,ABM("EMPLOYED")=1:1,1:2)
 I ABM("VACHK")=1 S ABM("PRI")=5
 S ABM("TYP")="P"
 Q:'$D(^AUPNPRVT(DFN))
 S ABM("MDFN")=0
 F  S ABM("MDFN")=$O(^AUPNPRVT(DFN,11,ABM("MDFN"))) Q:'ABM("MDFN")  D 53
 Q
 ;
53 ;
 K ABM("XIT")
 Q:$P($G(^AUPNPRVT(DFN,11,ABM("MDFN"),0)),U)=""
 Q:'$D(^AUTNINS($P(^AUPNPRVT(DFN,11,ABM("MDFN"),0),U),0))
 S ABM("REC")=^AUPNPRVT(DFN,11,ABM("MDFN"),0)
 S ABM("INS")=$P(ABM("REC"),U)
 I (ABM("VACHK")=0),($$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,+ABM("INS"),".211","I"),1,"I")="V") Q
 I (ABM("VACHK")=1),($$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,+ABM("INS"),".211","I"),1,"I")'="V") Q
 D PRIO^ABMDLCK
 I $P(ABM("REC"),U,6)>$P(ABMVDT,".",1) D  Q
 .S $P(ABML(99,ABM("INS")),U,2)=ABM("MDFN")
 .S $P(ABML(99,ABM("INS")),U,3)="P"
 .S $P(ABML(99,ABM("INS")),U,6)=37
 I $P(ABM("REC"),U,7)]"",$P(ABM("REC"),U,7)<$P(ABMVDT,".",1) D  Q
 .S $P(ABML(99,ABM("INS")),U,2)=ABM("MDFN")
 .S $P(ABML(99,ABM("INS")),U,3)="P"
 .S $P(ABML(99,ABM("INS")),U,6)=37
 Q:$P(ABM("REC"),U,8)=""  ;quit if no policy holder
 S ABM("COV")=$P($G(^AUPN3PPH($P(ABM("REC"),U,8),0)),U,5)
 I ABM("COV"),$P($G(^AUTTPIC(ABM("COV"),0)),U,5) D
 .S ABM("MSUP",ABM("INS"))=""
 .S ABM("OPRI")=ABM("PRI")
 .S ABM("PRI")=4
 I $D(ABM("OPRI")) D
 .S ABM("PRI")=ABM("OPRI")
 .K ABM("OPRI")
 S ABML(ABM("PRI"),ABM("INS"))=$P(ABM("REC"),U,6)_U_$P(ABM("REC"),U,7)_U_"P"_U_ABM("MDFN")_U_U_$S(ABM("COV"):$P($G(^AUTTPIC(ABM("COV"),0)),U,3),1:"")
 Q
6 ; Non-beneficiary Patient
 K ABM("XIT")
 S ABM("PRI")=6
 S ABM("TYP")="N"
 D PRIO^ABMDLCK
 S ABM("INS")=$O(^AUTNINS("B","NON-BENEFICIARY PATIENT",""))
 I '+ABM("INS") S ABME(169)="" Q
 ;Piece 12 of node 11 is indian eligibility status.  I means ineligible
 G 8:'$D(^AUPNPAT(DFN,11)),8:($P(^(11),U,12)'="I")
 S (ABM("COV"),ABM("MDFN"))=""
 S ABML(ABM("PRI"),ABM("INS"))=""
 Q
7 ;EP - VMBP Elig Chk
 S ABM("TYP")="P"
 S ABM("PRI")=5
 ;After setting priority we check VAMB eligibility file
 S ABM("VACHK")=1 D 5  ;check AUPNPRVT for VA entries
 S ABM("TYP")="V"
 S ABM("PRI")=5
 D PRIO^ABMDLCK2
 Q:'$D(^AUPNVAMB(DFN,0))
 D FIND^DIC(9999999.18,"","@;.01;.211","CP","V","*",,"I $$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,Y,"".211"",""I""),1,""I"")=""V""","","ABMIL")
 I +$O(ABMIL("DILIST",0))=0 S ABME(252)="" Q
 S ABM("INS")=$P($G(^AUPNVAMB(DFN,0)),U,2)
 K ABM("REC")
 ;Node 11 has eligibility dates
 S ABMELGDT=0
 S ABM("MDFN")=0
 F  S ABM("MDFN")=$O(^AUPNVAMB(DFN,11,ABM("MDFN"))) Q:'ABM("MDFN")  D 73
 K COV
 Q
 ;
73 ;
 S ABM("REC")=^AUPNVAMB(DFN,11,ABM("MDFN"),0)
 I $P(ABM("REC"),U,1)>$P($S(ABMDISDT:ABMDISDT,1:ABMVDT),".",1) Q
 I $P(ABM("REC"),U,2)]"" Q:$P(ABM("REC"),U,2)<$P(ABMVDT,".",1)
 S ABMELGDT=1
 S COV=$P(ABM("REC"),U,3)
 ;For A or B get ien from ^AUTTPIC file
 I COV]"" S ABM("COV")=$O(^AUTTPIC("AC",ABM("INS"),COV,""))
 E  S ABM("COV")=""
 S ABML(ABM("PRI"),ABM("INS"))=$P(ABM("REC"),U,6)_U_$P(ABM("REC"),U,7)_U_"P"_U_ABM("MDFN")_U_U_$S(ABM("COV"):$P($G(^AUTTPIC(ABM("COV"),0)),U,3),1:"")
 Q
8 ; Beneficiary Patient
 K ABM("XIT")
 ;Piece 18 of 0 node is the "bill all pats" field
 N ABMBBENP,ABMPRI
 S ABMBBENP=$P($G(^ABMDPARM(DUZ(2),1,0)),U,18),ABMBDISP=$P($G(^(0)),"^",10)
 Q:'ABMBBENP
 S ABMPRI=$O(ABML(0))
 Q:ABMPRI>0&(ABMPRI<97)&('ABMBDISP)      ;Quit if other insurer found
 ;Don't put an entry in ABML for bene pat if there another entry
 ;If bill all inpats check for visit type
 Q:ABMBBENP=2&$D(SERVCAT)&("HID"'[$G(SERVCAT))
 Q:ABMBBENP=2&$D(ABMP("VTYP"))&($G(ABMP("VTYP"))'=111)
 ;S ABM("PRI")=6  ;abm*2.6*21 IHS/SD/SDR VMBP RQMT_90
 S ABM("PRI")=7  ;abm*2.6*21 IHS/SD/SDR VMBP RQMT_90
 S ABM("TYP")="I"
 D PRIO^ABMDLCK2
 S ABM("INS")=$O(^AUTNINS("B","BENEFICIARY PATIENT (INDIAN)",""))
 I '+ABM("INS") Q
 S (ABM("COV"),ABM("MDFN"))=""
 S ABML(ABM("PRI"),ABM("INS"))=""
 Q
