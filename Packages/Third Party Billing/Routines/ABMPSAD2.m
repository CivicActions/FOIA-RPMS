ABMPSAD2 ;IHS/SD/SDR - Add Pharmacy POS COB Bill Manually ;   
 ;;2.6;IHS Third Party Billing;**36**;NOV 12, 2009;Build 698
 ;
 ;IHS/SD/SDR 2.6*36 ADO76247 New routine; create a manual COB bill for Pharmacy POS claims - service line
 ;
HD ;
 ;
 W !?5,"REVN",?11,"CHARGE",?55,"DAYS",?72,"TOTAL"
 W !?5,"CODE",?11,"DATE",?30,"MEDICATION",?54,"SUPPLY",?63,"QTY",?72,"CHARGE"
 W !?5,"====",?11,"==========================================",?55,"====",?61,"=======",?70,"=========="
 S ABM("FEE")=0
 I +$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,0))=0 W $$EN^ABMVDF("ULN"),!?32,"<NONE>",?80,$$EN^ABMVDF("ULF") Q  ;there's no med on the selected bill
 ;
LOOP S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1),ABM)=0 F ABM("I")=1:1 S ABM=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,ABM)) Q:'ABM  S ABM("X")=ABM,ABMZ("NUM")=ABM("I") D PC1
 Q
PC1 S ABM("X0")=^ABMDBILL(DUZ(2),ABMP("BDFN"),23,ABM("X"),0)
 S ABM("X2")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,ABM("X"),2))
 ;
 I '$D(ABMDATA("SL")) D
 .S ABMDATA("SL",.01)=$P(ABM("X0"),U)  ;drug
 .S ABMDATA("SL",.03)=$P(ABM("X0"),U,3)  ;units
 .S:'+ABMDATA("SL",.03) ABMDATA("SL",.03)=1  ;units default
 .S ABMDATA("SL",.02)=$P(ABM("X0"),U,2)  ;rev code
 .S ABMDATA("SL",.14)=$P(ABM("X0"),U,14)  ;date filled
 .S ABMDATA("SL",.24)=$P($G(ABM("X0")),U,24)  ;NDC
 .S ABMDATA("SL",.2)=$P(ABM("X0"),U,20)  ;days supply
 .S ABMDATA("SL",.04)=$P(ABM("X0"),U,4)  ;unit cost
 .S ABMDATA("SL",.05)=$P(ABM("X0"),U,5)  ;dispensing fee
 .S ABMDATA("SL",.06)=$P(ABM("X0"),U,6)  ;prescription#
 .S ABMDATA("SL",.19)=$P(ABM("X0"),U,19)  ;new/refill code
 .S ABMDATA("SL",.29)=$P(ABM("X0"),U,29)  ;CPT code
 .S ABMP("TOT")=(ABMDATA("SL",.03)*ABMDATA("SL",.04))+ABMDATA("SL",.05)
 ;
 Q:'$D(^PSDRUG(+ABM("X0"),0))
 S ABMZ(ABM("I"))=ABMDATA("SL",".01")_U_ABM("X")_U_ABMDATA("SL",".02")
 W !,ABM("I")_". "
 I $P(ABM("X0"),U,14) D
 .W ?5,$$GETREV^ABMDUTL(ABMDATA("SL",".02"))  ;rev code
 .W ?11,$$CDT^ABMDUTL(ABMDATA("SL",".14"))  ;charge date
 .I $P(ABM("X0"),U,28)'="",($P(ABM("X0"),U,14)'=$P(ABM("X0"),U,28)) W "-",$$CDT^ABMDUTL($P(ABM("X0"),U,28))
 I $P(ABM("X0"),U,26)'="" W " (+)"  ;date disc
 I $P(ABM("X0"),U,27)'="" W " (*)"  ;RTS
 W ?30,$S(ABMDATA("SL",.06)'="":" Rx: "_ABMDATA("SL",.06)_" ",1:"<No Rx>")  ;Rx number
 I $P(ABM("X0"),U,29)'="" W ?40,"CPT: ",$P($$CPT^ABMCVAPI(+$P(ABM("X0"),U,29),ABMP("VDT")),U,2)
 S ABMZ("MOD")=""
 F ABM("M")=3,4,5 S:$P(ABM("X2"),U,ABM("M"))]"" ABMZ("MOD")=ABMZ("MOD")_"-"_$P(ABM("X2"),U,ABM("M"))
 W:ABMZ("MOD")]"" ABMZ("MOD")_" "
 S ABMRPRV=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,ABM("X"),"P","C","D",0))
 S:ABMRPRV="" ABMRPRV=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,ABM("X"),"P","C","R",0))
 I ABMRPRV'="" D  ;rendering provider on line item
 .W !?40," ("_$E($P($G(^VA(200,$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,ABM("X"),"P",ABMRPRV,0),U),0)),U),1,23)_"-"_$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,ABM("X"),"P",ABMRPRV,0),U,2)_")"
 .I $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,ABM("X"),"P",ABMRPRV,0),U,2)="D" D
 ..S ABMA("CSUB")=$P($G(^PSDRUG(+ABM("X0"),0)),U,3)
 ..I '((ABMA("CSUB")[2)!(ABMA("CSUB")[3)!(ABMA("CSUB")[4)!(ABMA("CSUB")[5)) Q
 ..W "  DEA# "_$P($G(^VA(200,$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,ABM("X"),"P",ABMRPRV,0),U),"PS")),U,2)
 W !,$$EN^ABMVDF("ULN")
 W ?4,$S(ABMDATA("SL",".24")]"":ABMDATA("SL",".24")_" ",1:"<NO NDC>        ")  ;NDC number
 N M7,M8,M9
 S M7=$P(ABM("X0"),U,7)  ;additive
 S M8=$P(ABM("X0"),U,8)  ;solution
 S M9=" "_$P(ABM("X0"),U,9)  ;narrative
 S ABMDESC=$P($G(^PSDRUG(ABMDATA("SL",".01"),0)),U)_$S(M7&($D(^PS(52.6,+M7,0))):$P(^PS(52.6,M7,0),U)_M9,M8&($D(^PS(52.7,+M8,0))):$P(^(0),U)_M9,1:"")
 W $E(ABMDESC,1,35)
 W ?56,$J(ABMDATA("SL",".2"),3)  ;days supply
 W ?60,$$FMT^ABMERUTL(ABMDATA("SL",".03"),"9R")  ;quantity
 ;W ?69,$J($FN(ABMDATA("BAMT"),",",2),11)  ;use bill amount
 W ?69,$J($FN(ABMP("TOT"),",",2),11)  ;units * unit charge + dispensing fee
 W ?80,$$EN^ABMVDF("ULF")
 I ABMDATA("SL",".06")]"" D
 .N DA S DA=$O(^PSRX("B",ABMDATA("SL",".06"),0)) Q:'DA
 .S DIC="^PSRX(",DR=12,DIQ="ABM(",DIQ(0)="E" D EN^DIQ1 K DIQ
 .Q:ABM(52,DA,12,"E")=""
 .S ABMU("TXT")=$G(ABMU("TXT"))_" Comments: "_ABM(52,DA,12,"E")
 Q
ERR ;
 I +$G(ABMPFLG)=0 W !,$$EN^ABMVDF("HIN"),"No posting has been done so this bill can NOT be approved.",$$EN^ABMVDF("HIF")
 I '$D(ABMDATA("DX")) W !,$$EN^ABMVDF("HIN"),"DXs must be added before bill can be approved.",$$EN^ABMVDF("HIF")
 I (+$G(ABMDATA("CBAMT"))<(.01)) W !,"ERROR: BALANCE MUST BE GREATER THAN ZERO AND NOT NEGATIVE"
 I (+$G(ABMDATA("SL",.02))<1)&($P($G(^ABMDEXP(ABMDATA("EXP"),0)),U)["UB") W !,"ERROR: PROCEDURE(S) MISSING CORRESPONDING REVENUE CODE(S)"
 Q
XIT K ABM,ABMMODE
 Q
