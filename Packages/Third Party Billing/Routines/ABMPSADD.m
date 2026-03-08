ABMPSADD ; IHS/SD/SDR - Add Pharmacy POS COB Bill Manually ;   
 ;;2.6;IHS Third Party Billing;**36**;NOV 12, 2009;Build 698
 ;IHS/SD/SDR 2.6*36 ADO76247 New routine; create a manual COB bill for Pharmacy POS claims - driver
START ;
 D MSG^ABMPSAD1
SEL ;
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=1 D  Q:+$G(ABMUOPNS)=0
 .S ABMUOPNS=$$FINDOPEN^ABMUCUTL(DUZ)
 .I +$G(ABMUOPNS)=0 D  Q
 ..W !!,"* * YOU MUST SIGN IN TO BE ABLE TO PERFORM BILLING FUNCTIONS! * *",!
 ..S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 ;
 D ^XBFMK
 K ABMDX,ABMDATA,ABMZ,ABMP,ABME,ABM,ABMSAVE,ABMPL,ABMPP
 ;flag if they approved; this makes it prompt for next bill instead of
 ;redisplaying previous bill and prompting for next bill
 S ABMAFLG=0
 ;
 D ^ABMDBDIC
 G XIT:'$G(ABMP("BDFN"))
 S ABM("SUB")="BILL"
 S DA=ABMP("BDFN")
 I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,4)="X" W !!,"Bill "_$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U)_" is cancelled and therefore not eligible for billing." H 1 G SEL
 I +$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,0))=0 D  G SEL  ;there's no med on the selected bill
 .W !!,"Bill "_$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U)_" doesn't have a medication on it."
 .W !,"Use the BLRX option to pair this bill to its appropriate"
 .W !,"prescription/medication and then it will be available in ADPS."
 .D PAZ^ABMDRUTL
 D SETVARS^ABMPSAD1
 ;
DISPLAY ;
 I ABMAFLG=1 G SEL  ;if they have approved one it prompts for next one
 W $$EN^ABMVDF("IOF"),!
 F ABM=1:1:30 W "~"
 W "(Manual COB billing)"
 F ABM=1:1:30 W "~"
 W !
 W "Patient: ",$P(^DPT(ABMP("PDFN"),0),U)," ",$$HRN^ABMDUTL(ABMP("PDFN"))
 W ?56,"RX: ",$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),1)),U,15)
 W !,$$EN^ABMVDF("ULN"),?3,"Visit Loc: ",$P($G(^AUTTLOC(ABMP("LDFN"),0)),U,2),?55,"DOS: ",$$SDT^ABMDUTL(ABMP("VDT")),?80,$$EN^ABMVDF("ULF")
 D ACTBILLS
 I ABMBN'="" D
 .W !
 .S ABMU("TXT")="Active bills: "_ABMBN
 .S ABMU("RM")=80
 .S ABMU("LM")=1
 .D ^ABMDWRAP
 D ELGDPLY  ;pt's eligibility
 D HD^ABMPSAD2  ;displays charge
 D FLDS  ;lower third of display
 D ERR^ABMPSAD2  ;warnings and errors
 ;
 S ABMP("OPT")="CEQ"
 I '$D(ABMDATA("DX")) S ABMP("OPT")="EQ"
 I ($G(ABMDATA("SL",.02))="")&($P($G(^ABMDEXP(ABMDATA("EXP"),0)),U)["UB") S ABMP("OPT")="EQ"
 I +$G(ABMPFLG)=0 S ABMP("OPT")="Q"
 S ABMP("DFLT")="Q"
 S ABMP("SCRN")=123,ABMZ("PG")=123
 D SEL^ABMDEOPT
 I "CE"'[$E(Y) G XIT
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("DO")=$S($E(Y)="C":"APPR",$E(Y)="E":"EDIT",1:"XIT") D @ABM("DO") G DISPLAY
 Q
XIT ;
 I +$G(ABMD("DFN")) L -^ABMDBILL(DUZ(2),ABMD("DFN"))
 K DIR
 S DIR(0)="E"
 D ^DIR
 K ABMD,ABMAPOK
 Q
ACTBILLS ;
 S ABMBN=""
 S ABMPFLG=0
 K ABMPL
 S ABMPRI=1
 S ABMOBNUM=+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U)
 S ABMBNUM=+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U)_" "
 F  S ABMBNUM=$O(^ABMDBILL(DUZ(2),"B",ABMBNUM)) Q:(($G(ABMBNUM)="")!(ABMBNUM'[ABMOBNUM))  D
 .S ABMA=0
 .F  S ABMA=$O(^ABMDBILL(DUZ(2),"B",ABMBNUM,ABMA)) Q:'ABMA  D
 ..S ABMTXT=""
 ..I $P($G(^ABMDBILL(DUZ(2),ABMA,0)),U,4)="X" S ABMTXT="*"  ;if cancelled add '*' after bill#
 ..S ABMTXT=ABMTXT_"("_$P($G(^AUTNINS($P($G(^ABMDBILL(DUZ(2),ABMA,0)),U,8),0)),U)_")"  ;insurer name
 ..;next two lines build the active insurer string
 ..I ABMBN'="" S ABMBN=ABMBN_", "_ABMBNUM_ABMTXT
 ..I ABMBN="" S ABMBN=ABMBNUM_ABMTXT
 ..I ((+$O(^ABMDBILL(DUZ(2),ABMA,3,0))'=0)&($P($G(^ABMDBILL(DUZ(2),ABMA,0)),U,4)'="X")) S ABMPFLG=ABMA
 ..I ((+$O(^ABMDBILL(DUZ(2),ABMA,3,0))=0)&($P($G(^ABMDBILL(DUZ(2),ABMA,0)),U,4)'="X")) S ABMPFLG=0
 ..S:$P($G(^ABMDBILL(DUZ(2),ABMA,0)),U,4)'="X" ABMPL(ABMPRI,$P($G(^ABMDBILL(DUZ(2),ABMA,0)),U,8))=$P($G(^ABMDBILL(DUZ(2),ABMA,0)),U,8)_"^"_"C"
 ..S ABMPRI=ABMPRI+1
 ..S ABMACTI($P($G(^ABMDBILL(DUZ(2),ABMA,0)),U,8))=""
 ;posting from last bill to figure current bill amt prior to page A calculations
 ;it could change based on what they do on COB page later on in process
 S ABMPSTF=0
 S ABMDATA("CBAMT")=0
 I (+$G(ABMPFLG)'=0) D
 .S ABMTR=0
 .F  S ABMTR=$O(^ABMDBILL(DUZ(2),ABMPFLG,3,ABMTR)) Q:'ABMTR  D
 ..S ABMDATA("CBAMT")=ABMDATA("CBAMT")+$P($G(^ABMDBILL(DUZ(2),ABMPFLG,3,ABMTR,0)),U,3)+$P($G(^ABMDBILL(DUZ(2),ABMPFLG,3,ABMTR,0)),U,4)
 Q
ELGDPLY ;
 K ABML
 D ELG^ABMPSAD1  ;gather pt's eligibility based on DOS
 I $D(ABML) D
 .W !,"Available insurance for DOS:"
 .W !,?30,"Ins",?35,"Cov",!
 .W ?4,$$EN^ABMVDF("ULN"),"Insurer",$$EN^ABMVDF("ULF")
 .W ?30,$$EN^ABMVDF("ULN"),"Type",$$EN^ABMVDF("ULF")
 .W ?35,$$EN^ABMVDF("ULN"),"Type",$$EN^ABMVDF("ULF")
 .W ?41,$$EN^ABMVDF("ULN"),"RX Bill Stat",$$EN^ABMVDF("ULF")
 .W ?63,$$EN^ABMVDF("ULN"),"Elig Dates",$$EN^ABMVDF("ULF")
 .I '$D(ABML) W !,"<NONE>" Q
 .S ABMA=0
 .F  S ABMA=$O(ABML(ABMA)) Q:'ABMA!(ABMA>97)  D
 ..S ABMB=0
 ..F  S ABMB=$O(ABML(ABMA,ABMB)) Q:'ABMB  D
 ...W !
 ...I +$O(ABML(ABMA))=0!(+$O(ABML(ABMA))>97) W $$EN^ABMVDF("ULN")
 ...W $E($P($G(^AUTNINS(ABMB,0)),U),1,28)
 ...W ?31,$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABMB,".211","I"),1,"E")
 ...W ?35,$E($P($G(ABML(ABMA,ABMB)),U,6),1,3)  ;coverage type
 ...W ?40,$E($$GET1^DIQ(9999999.18,ABMB,".23","E"),1,14)  ;rx stat
 ...I $G(ABML(ABMA,ABMB))'="" D
 ....W ?55,$$SDT^ABMDUTL($P(ABML(ABMA,ABMB),U))_" to "
 ....I $P(ABML(ABMA,ABMB),U,2)'="" W $$SDT^ABMDUTL($P(ABML(ABMA,ABMB),U,2))
 ....E  W "<OPEN>"
 ...I +$O(ABML(ABMA))=0!(+$O(ABML(ABMA))>97) W ?80,$$EN^ABMVDF("ULF")
 Q
FLDS ;
 I $G(ABME(1))="" D GETDATA
 ;write lower third of page
 F ABM("I")=1:1:6 D
 .S ABML=$P($G(ABME(ABM("I"))),U)
 .S ABMR=$P($G(ABME(ABM("I"))),U,2)
 .W !
 .I ABML["$" W $P(ABML,"$"),?30,$P(ABML,"$",2)
 .I ABML["%" W $P(ABML,"%"),?11,$P(ABML,"%",2) I 1
 .I ABML'["$"&(ABML'["%") W ABML
 .I ABM("I")'=1 W ?40,"|"
 .I ABMR["#" W $P(ABMR,"#"),?60,$P(ABMR,"#",2)
 .E  W $TR(ABMR,"*"," ")
 W !
 F ABM("I")=1:1:80 W "-"
 Q
GETDATA ;EP
 S ABME(1)="2. Active Insurer: "_$P($G(^AUTNINS(ABMDATA("INS"),0)),U)
 S ABME(2)="3.     Visit Type: "_$E($P($G(^ABMDVTYP(ABMDATA("VT"),0)),U),1,21)
 S ABME(3)="4.    Export Mode: "_$P($G(^ABMDEXP(ABMDATA("EXP"),0)),U)
 S ABME(4)="5.  Resubmission#: "_ABMDATA("RESUB")
 S ABME(5)="      Bill Amount: "_$J($FN(ABMDATA("BAMT"),",",2),8)
 S ABME(6)="Current Bill Amnt: "_$J($FN(ABMDATA("CBAMT"),",",2),8)
 S $P(ABME(2),U,2)="6. Diagnosis Code(s):"
DXS ;
 K ABMDX
 I +$O(ABMDX(0))=0 D
 .S ABMP=0
 .F  S ABMP=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,"C",ABMP)) Q:'ABMP  D
 ..S ABM=0
 ..F  S ABM=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,"C",ABMP,ABM)) Q:'ABM  D
 ...S ABMDATA("DX",ABMP)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,ABM,0)),U)
 I '$D(ABMDATA("DX")) S $P(ABME(3),U,2)="  <NONE>"  ;no DXs on bill
 D DXABME
 Q
DXABME ;
 K ABMT
 S ABMP=0
 F  S ABMP=$O(ABMDATA("DX",ABMP)) Q:'ABMP  D
 .I ABMP<4 S $P(ABMT(3),"*",ABMP)=$$FMT^ABMERUTL(("  "_ABMP_")"_$P($G(^ICD9($G(ABMDATA("DX",ABMP)),0)),U)),11) Q
 .I ABMP<7 S $P(ABMT(4),"*",ABMP-3)=$$FMT^ABMERUTL("  "_ABMP_")"_$P($G(^ICD9($G(ABMDATA("DX",ABMP)),0)),U),11) Q
 .I ABMP<10 S $P(ABMT(5),"*",ABMP-6)=$$FMT^ABMERUTL("  "_ABMP_")"_$P($G(^ICD9($G(ABMDATA("DX",ABMP)),0)),U),11) Q
 .S $P(ABMT(6),"*",ABMP-9)=$$FMT^ABMERUTL(" "_ABMP_")"_$P($G(^ICD9($G(ABMDATA("DX",ABMP)),0)),U),11)
 F ABM=3:1:6 D
 .Q:'$D(ABMT(ABM))
 .S $P(ABME(ABM),U,2)=ABMT(ABM)
 Q
APPR ;
 I $D(ABMACTI(ABMDATA("INS"))) D  Q:(Y<1)!$D(DUOUT)!$D(DIROUT)!$D(DTOUT)!$D(DIRUT)
 .W !!,"The ACTIVE INSURER has already been billed."
 .D ^XBFMK
 .S DIR(0)="YO"
 .S DIR("A")="Are you sure you want to continue and approve?"
 .D ^DIR
 .K DIR
 ;
 D COB^ABMPSAD4
 Q:($G(ABMSFLG)=1)
 ;create next bill entry; (if editing an A-bill create B-bill, if editing a B-bill create C-bill, etc)
 D ^XBFMK
 W !
 S DIR(0)="Y"
 S DIR("A")="Do You Wish to APPROVE this Claim for Billing"
 S DIR("?")="If Claim is accurate and Transfer to Accounts Receivable File is Desired"
 D ^DIR
 K DIR
 G:$D(DIRUT)!$D(DIROUT)!(Y'=1) XIT
 S ABMAFLG=1
 S ABMB=+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U)
 S ABMP("OBDFN")=ABMP("BDFN")
 K ABMP("BDFN"),ABMP("OVER")
 S ABMB("Y")="B"
 S ABMB("OUT")=0
 F  Q:'$D(^ABMDBILL(DUZ(2),"B",ABMB_ABMB("Y")))  S ABMB("Y")=$C($A(ABMB("Y"))+1)
 S X=+ABMB_ABMB("Y")
 S DIC="^ABMDBILL(DUZ(2),"
 S DIC(0)="L"
 K DD,DO
 K Y
 D FILE^DICN
 I +Y<1 D  Q
 .D MSG^ABMERUTL("ERROR: BILL NOT CREATED, ensure your Fileman ACCESS CODE contains a 'V'.")
 .S ABMB("OUT")=1
 L +^ABMDBILL(DUZ(2),+Y):1 I '$T D MSG^ABMERUTL("ERROR: Bill File is Locked by another User, Try Later!") Q
 S ABMP("BDFN")=+Y
 D FILE^ABMPSAD3
 Q
COB ;
 S ABMP("CDFN")=+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U)
 S:'+$G(ABMP("TOT")) ABMP("TOT")=0
 F ABMP("EXP")=1,10,11,2,3,13,14,15,16,17,19,20,21,22,24,27,28,31,32,35,51 I $D(ABMP("EXP",ABMP("EXP"))) D  ;abm*2.6*13 export mode 35
 .D ^ABMDESM1
 .S ABMP("EXP",ABMP("EXP"))=+ABMS("TOT")
 .I $P(^ABMDEXP(ABMP("EXP"),0),U)["UB" D  Q
 ..S ABMP("NC")=$S($P($G(ABMP("FLAT")),U,2):$P(ABMS($P(ABMP("FLAT"),U,2)),U,5),1:0)
 ..S ABMP("COVD")=$S($P($G(ABMP("FLAT")),U,2):$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,3)*$P(ABMS($P(ABMP("FLAT"),U,2)),U,3),1:0)  ;abm*2.6*33 IHS/SD/SDR ADO60189
 ..I ABMS("TOT"),'$G(ABMQUIET) D ^ABMDES1,^ABMPPADJ
 .Q:'ABMS("TOT")
 .Q:$G(ABMQUIET)
 .I $P($G(^ABMDEXP(ABMP("EXP"),1)),U)]"" D @("^"_$P(^(1),U)),^ABMPPADJ Q
 .D @("^ABMDES"_ABMP("EXP")),^ABMPPADJ
 Q:($G(ABMSFLG)=1)
 S ABMP("EXP")=ABMP("TMP-EXP") K ABMP("TMP-EXP")
 I $G(ABMTFLAG)=1 S (ABMP("TOT"),ABMP("EXP",ABMEXPMS))=+$G(ABMP("CBAMT")) Q  ;don't do summary below if 2NDARY with one export mode
 S ABMDATA("CBAMT")=ABMP("CBAMT")
 Q
EDIT ;
 S ABMP("FLDS")=6
 D FLDS^ABMDEOPT
 W !
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 F ABM("I")=1:1 S ABM=$P(ABMP("FLDS"),",",ABM("I")) Q:'ABM  D  Q:$G(Y)[U
 .D ^XBFMK
 .D @ABM
 Q
1 ;
 W !,"[1] Medication: ",$P($G(^PSDRUG(ABMDATA("SL",".01"),0)),U)  ;drug
 S ABM=.01
 F  S ABM=$O(ABMDATA("SL",ABM)) Q:'ABM  D  Q:$D(DUOUT)!$D(DIROUT)!$D(DTOUT)
 .D ^XBFMK
 .I ABM=".02" S DIR(0)="PO^AUTTREVN(",DIR("A")="Revenue Code",DIR("B")=$S($G(ABMDATA("SL",.02)):$P($G(^AUTTREVN(ABMDATA("SL",.02),0)),U),1:"") D ^DIR
 .Q:$D(DUOUT)!$D(DIROUT)!$D(DTOUT)
 .I ABM=".03" S DIR(0)="N^0:99999:3" S DIR("A")="Units",DIR("B")=$S($G(ABMDATA("SL",.03)):$FN(ABMDATA("SL",.03),",",2),1:"") D ^DIR
 .Q:$D(DUOUT)!$D(DIROUT)!$D(DTOUT)
 .I ABM=".04" S DIR(0)="N^0:9999:5" S DIR("A")="Unit Cost",DIR("B")=$S($G(ABMDATA("SL",.04)):$FN(ABMDATA("SL",.04),",",2),1:"") D ^DIR
 .Q:$D(DUOUT)!$D(DIROUT)!$D(DTOUT)
 .I ABM=".05" S DIR(0)="NO^0:200:2" S DIR("A")="Dispensing Fee",DIR("B")=$S($G(ABMDATA("SL",.05)):$FN(ABMDATA("SL",.05),",",2),1:"") D ^DIR
 .Q:$D(DUOUT)!$D(DIROUT)!$D(DTOUT)
 .I ABM=".14" S DIR(0)="DO" S DIR("A")="Service Date",DIR("B")=$S(ABMDATA("SL",.14):$$SDT^ABMDUTL(ABMDATA("SL",.14)),1:"") D ^DIR
 .Q:$D(DUOUT)!$D(DIROUT)!$D(DTOUT)
 .I ABM=".19" S DIR(0)="NO^0:99" S DIR("A")="New/Refill Code",DIR("B")=$G(ABMDATA("SL",.19)) D ^DIR
 .Q:$D(DUOUT)!$D(DIROUT)!$D(DTOUT)
 .I ABM=".2" S DIR(0)="NO^1:999" S DIR("A")="Days Supply",DIR("B")=$S(+$G(ABMDATA("SL",.2)):$G(ABMDATA("SL",.2)),1:1) D ^DIR
 .Q:$D(DUOUT)!$D(DIROUT)!$D(DTOUT)
 .I ABM=".24" S DIR(0)="FO^1:15" S DIR("A")="NDC",DIR("B")=$G(ABMDATA("SL",.24)) D ^DIR
 .Q:$D(DUOUT)!$D(DIROUT)!$D(DTOUT)
 .I ABM=".29" S DIC="^ICPT(",DIC(0)="AEMQ",DIC("S")="I $$CHKCPT^ABMDUTL(Y)'=0",DIC("A")="CPT Code: ",DIC("B")=$S($G(ABMDATA("SL",.29)):$P($G(^ICPT(ABMDATA("SL",.29),0)),U),1:"") D ^DIC
 .Q:$D(DUOUT)!$D(DIROUT)!$D(DTOUT)
 .S:($G(Y)'="") ABMDATA("SL",ABM)=$P(Y,U)
 .I ((ABM=".02")!(ABM=".29"))&(+$G(Y)<0) S ABMDATA("SL",ABM)=""
 S (ABMP("TOT"),ABMDATA("BAMT"))=(ABMDATA("SL",.03)*ABMDATA("SL",.04))+ABMDATA("SL",.05)
 S ABME(5)="      Bill Amount: "_ABMDATA("BAMT")
 Q
2 ;
 D ^XBFMK
 F  D  Q:(+Y>0)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!$D(DIRUT)
 .S DIC="^AUTNINS("
 .S DIC(0)="AEQM"
 .S DIC("S")="I $D(ABMLST(Y))"
 .S DIC("A")="[2] Active Insurer: "
 .S DIC("B")=$P($G(^AUTNINS(ABMDATA("INS"),0)),U)
 .D ^DIC
 I +Y>0 D
 .S ABMDATA("INS")=+Y,$P(ABME(1),U)="2. Active Insurer: "_$P($G(^AUTNINS(+Y,0)),U)
 .S ABMDATA("ITYP")=$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABMDATA("INS"),".211","I"),1,"I")
 .;figure out export mode for ins/vtyp and use default 1500 if there's none set up
 .S ABMT=0
 .S ABMT=+$P($G(^ABMNINS(DUZ(2),ABMDATA("INS"),1,ABMDATA("VT"),0)),U,4)
 .I ABMT=0 D
 ..S ABMT=$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,9)
 ..S:ABMT=5 ABMT=35
 ..S:ABMT=4 ABMT=27
 ..S:ABMT=3 ABMT=14
 ..S:ABMT=2 ABMT=3
 ..S:ABMT=1 ABMT=2
 .S ABMDATA("EXP")=ABMT,$P(ABME(3),U)="4.    Export Mode: "_$P($G(^ABMDEXP(+ABMT,0)),U)
 Q
3 ;
 D ^XBFMK
 S DIR(0)="P^ABMDVTYP("
 S DIR("A")="[3] Visit Type"
 S DIR("B")=$P($G(^ABMDVTYP(ABMDATA("VT"),0)),U)
 D ^DIR
 I +Y>0 S ABMDATA("VT")=+Y,$P(ABME(2),U)="3.     Visit Type: "_$E($P($G(^ABMDVTYP(+Y,0)),U),1,21)
 S ABMT=$S(+$P($G(^ABMNINS(DUZ(2),ABMDATA("INS"),1,ABMDATA("VT"),0)),U,4)'=0:$P($G(^ABMNINS(DUZ(2),ABMDATA("INS"),1,ABMDATA("VT"),0)),U,4),1:ABMDATA("EXP"))
 S ABMDATA("EXP")=ABMT,$P(ABME(3),U)="4.    Export Mode: "_$P($G(^ABMDEXP(+ABMT,0)),U)
 Q
4 ;
 D ^XBFMK
 F  D  Q:(+Y>0)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!$D(DIRUT)
 .S DIC="^ABMDEXP("
 .S DIC(0)="AEQM"
 .S DIC("S")="I +$P(^(0),U,11)=0"  ;only active export modes to choose from
 .S DIC("A")="[4] Export Mode: "
 .S DIC("B")=$P($G(^ABMDEXP(ABMDATA("EXP"),0)),U)
 .D ^DIC
 I +Y>0 S ABMDATA("EXP")=+Y,$P(ABME(3),U)="4.    Export Mode: "_$P($G(^ABMDEXP(+Y,0)),U)
 Q
5 ;
 D ^XBFMK
 S DIR(0)="FO^1:29"
 S DIR("A")="[5] Resubmission#: "
 S DIR("B")=ABMDATA("RESUB")
 D ^DIR
 I $G(Y)'="" S ABMDATA("RESUB")=Y,$P(ABME(4),U)="5.  Resubmission#: "_ABMDATA("RESUB")
 I $G(Y)="" S ABMDATA("RESUB")="",$P(ABME(4),U)="5.  Resubmission#: "
 Q
6 ;
 K ABMSAVE
 I $D(ABMDATA("DX")) D
 .W !,"Note: this order reflects the coordinating diagnoses"
 .W !,"[6] Diagnosis Codes:"
 .S ABMF=0
 .F ABM=1:1:12 D  Q:ABMF
 ..I +$G(ABMDATA("DX",ABM))=0 S ABMF=1 Q
 ..W !?3,ABM_") "_$P($G(^ICD9($G(ABMDATA("DX",ABM)),0)),U)
 .W !!,"Type '^' or '^^' to leave the existing DXs in place; typing anything"
 .W !,"else will remove ALL the DXs and you'll start over"
 ;
 D ^XBFMK
 M ABMSAVE("DX")=ABMDATA("DX")
 K ABMD
 K ABMDATA("DX")
 F ABM=1:1:12 D  Q:(+Y<0)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!$D(DIRUT)
 .S DIC="^ICD9("
 .S DIC("A")="Select "_$S('$D(ABMD):"a",1:"another")_" DX code: "
 .S DIC(0)="AEMQ"
 .S DIC("S")="I $P($$DX^ABMCVAPI(+Y,ABMP(""VDT"")),U,20)=30"  ;ICD9 or ICD10 is selectable based on DOS
 .D ^DIC
 .Q:(+Y<0)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!$D(DIRUT)
 .I $D(ABMD(+Y)) W !,"Each DX can only be entered once" H 1 Q
 .S ABMD(+Y)="",ABMDATA("DX",ABM)=+Y
 I $D(DUOUT)!$D(DIROUT) M ABMDATA("DX")=ABMSAVE("DX") Q  ;don't remove the existing DXs if the user types '^' or '^^'
 F ABM=3:1:6 D
 .S $P(ABME(ABM),U,2)=""
 D DXABME  ;this loaded DXs into ABME array for display
 Q
