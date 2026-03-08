ABMDES1 ; IHS/SD/SDR - Display Summarized UB-82/92 Info ; 
 ;;2.6;IHS 3P BILLING SYSTEM;**10,29,30**;NOV 12, 2009;Build 585
 ;
 ;IHS/SD/SDR 2.5*9 IM16660 4-digit revenue codes
 ;IHS/SD/SDR 2.5*10 IM20227 Changed hardset of 001 rev code to 0001
 ;IHS/SD/SDR 2.5*10 IM21581 Added line to print active insurer in summary
 ;
 ;IHS/SD/SDR 2.6*29 CR10888 Added anesthesia minutes
 ;IHS/SD/SDR 2.6*29 CR10410 Added non-covered flat rate billing changes
 ;IHS/SD/SDR 2.6*30 CR8870 Updated display so it won't wrap if units are maxed out, including 3 decimal places
 ;
UB82 ;EP for printing UB-82/92 charge summary
 ;
 D HD
 S ABMS="" F ABMS("I")=0:1 S ABMS=$O(ABMS(ABMS)) Q:'ABMS  D  Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 .I $Y>(IOSL-7) S DIR(0)="EO" D ^DIR Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)  D HD
 .;start old abm*2.6*30 IHS/SD/SDR CR8870
 .;W !,$S($P($G(ABMP("FLAT")),U,6)]"":$P(ABMP("FLAT"),U,6),1:$P($G(^AUTTREVN(ABMS,0)),U,2)),?29,"|"
 .;W $S($D(ABMS("CPT")):$P(ABMS("CPT",1),U,2),$P($G(ABMP("FLAT")),U,7)]"":$P(ABMP("FLAT"),U,7),$P(ABMS(ABMS),U,3)]"":$J($P(ABMS(ABMS),U,3),7,2),1:"")
 .;end old start new abm*2.6*30 IHS/SD/SDR CR8870
 .W !,$S($P($G(ABMP("FLAT")),U,6)]"":$P(ABMP("FLAT"),U,6),1:$E($P($G(^AUTTREVN(ABMS,0)),U,2),1,18))  ;rev desc
 .W ?20,"|"
 .W $S($D(ABMS("CPT")):$P(ABMS("CPT",1),U,2),$P($G(ABMP("FLAT")),U,7)]"":$P(ABMP("FLAT"),U,7),$P(ABMS(ABMS),U,3)]"":$J($P(ABMS(ABMS),U,3),7,2),1:"")  ;flat rate, CPT, or blank
 .;end new abm*2.6*30 IHS/SD/SDR CR8870
 .;W ?43,$$GETREV^ABMDUTL(ABMS),?51,$J($P(ABMS(ABMS),U,2),3),?58,$J($FN($P(ABMS(ABMS),U),",",2),9)  ;HEAT60484
 .;W ?43,$$GETREV^ABMDUTL(ABMS),?51,$P(ABMS(ABMS),U,2),?58,$J($FN($P(ABMS(ABMS),U),",",2),9)  ;HEAT60484  ;abm*2.6*29 IHS/SD/SDR CR10888
 .;start old abm*2.6*30 IHS/SD/SDR CR8870
 .;start new abm*2.6*29 IHS/SD/SDR CR10888
 .;W ?43,$$GETREV^ABMDUTL(ABMS)
 .;W ?51,$P(ABMS(ABMS),U,2),$S((+$G(ABMANESF(ABMS))=1):"*",1:"")
 .;W ?58,$J($FN($P(ABMS(ABMS),U),",",2),9)
 .;end new abm*2.6*29 IHS/SD/SDR CR10888
 .;end old start new abm*2.6*30 IHS/SD/SDR CR8870
 .W ?31,$$GETREV^ABMDUTL(ABMS)  ;rev code
 .W ?39,$$FMT^ABMERUTL($P(ABMS(ABMS),U,2),"8R"),$S((+$G(ABMANESF(ABMS))=1):"*",1:"")  ;units
 .W ?50,$J($FN($P(ABMS(ABMS),U),",",2),14)  ;total charge
 .;end new abm*2.6*30 IHS/SD/SDR CR8870
 .;I $D(ABMP("FLAT")),'ABMS("I") W ?70,$J($FN($P(ABMS(ABMS),U,5),",",2),9) ;abm*2.6*29 IHS/SD/SDR CR10410
 .I $D(ABMP("FLAT")),'ABMS("I") W ?70,$J($FN(($P(ABMS(ABMS),U,5)+($G(ABMP("21NC")))),",",2),9) ;abm*2.6*29 IHS/SD/SDR CR10410
 ;start old abm*2.6*30 IHS/SD/SDR CR8870
 ;I $D(ABMS("CPT")) S ABMS=1 F  S ABMS=$O(ABMS("CPT",ABMS)) Q:ABMS=""  W !,$P(ABMS("CPT",ABMS),U),?29,"|",$P(ABMS("CPT",ABMS),U,2),?43,$P(ABMS("CPT",ABMS),U,3),?51,$J($P(ABMS("CPT",ABMS),U,4),3),?58,$J($FN($P(ABMS("CPT",ABMS),U,5),",",2),9)
 ;W !?58,"---------"
 ;end old start new abm*2.6*30 IHS/SD/SDR CR8870
 I $D(ABMS("CPT")) D
 .S ABMS=1
 .F  S ABMS=$O(ABMS("CPT",ABMS)) Q:ABMS=""  D
 ..W !,$E($P(ABMS("CPT",ABMS),U),1,18)  ;rev desc
 ..W ?20,"|",$P(ABMS("CPT",ABMS),U,2)
 ..W ?34,$P(ABMS("CPT",ABMS),U,3)
 ..W ?42,$J($P(ABMS("CPT",ABMS),U,4),"8R")  ;units
 ..W ?50,$J($FN($P(ABMS("CPT",ABMS),U,5),",",2),14)  ;total charge
 W !?50,"--------------"
 ;end new abm*2.6*30 IHS/SD/SDR CR8870
TOT ;
 ;W !?10,"TOTAL CHARGE",?43,"0001",?58,$J($FN(ABMS("TOT"),",",2),9)  ;abm*2.6*30 IHS/SD/SDR CR8870
 W !?10,"TOTAL CHARGE",?31,"0001",?50,$J($FN(ABMS("TOT"),",",2),14)  ;abm*2.6*30 IHS/SD/SDR CR8870
 S ABMP("TOT")=ABMP("TOT")+ABMS("TOT")
 F  W ! Q:$Y+4>IOSL
 S DIR(0)="E" D ^DIR K DIR
 Q
 ;
 D PREV^ABMDFUTL
 I $D(ABMP("FLAT")) S ABMP("RESP")=ABMP("RESP")-$P(ABMS($P(ABMP("FLAT"),U,2)),U,5) W !?39,"Non-Covd Charges:",?57,$J("("_$FN($P(ABMS($P(ABMP("FLAT"),U,2)),U,5),",",2),10),")"
 S:ABMP("RESP")<1 ABMP("RESP")=0
 I ABMP("PD")!ABMP("WO") D
 .W !?38,"Previous Payments:",?57,$J("("_$FN(ABMP("PD"),",",2),10),")"
 .W:ABMP("WO") !?39,"Write-off Amount:",?57,$J("("_$FN(ABMP("WO"),",",2),10),")"
 .W !?58,"---------",!,?37,"Est. Responsibility:",?58,$J(($FN(ABMP("RESP"),",",2)),9)
 Q
 ;
HD ;HEADER
 W $$EN^ABMVDF("IOF")
 S ABMP("FORM")=$P(^ABMDEXP(ABMP("EXP"),0),U)
 S ABMP("HEADER")="***** "_ABMP("FORM")_" CHARGE SUMMARY *****"
 W !?22,ABMP("HEADER")
 W !!,"Active Insurer: ",$P($G(^AUTNINS(ABMP("INS"),0)),U),!
 I $D(ABMANESF) W !,"* - Indicates time (minutes) instead of units",!  ;abm*2.6*29 IHS/SD/SDR CR10888
 ;start old abm*2.6*30 IHS/SD/SDR CR8870
 ;W !?42,"Revn",?60,"Total" I $D(ABMP("FLAT")) W ?71,"Non-cvd"
 ;W !?10,"  Description",?42,"Code",?50,"Units",?59,"Charges" I $D(ABMP("FLAT")) W ?71,"Charges"
 ;end old start new abm*2.6*30 IHS/SD/SDR CR8870
 W !?31,"Revn",?53,"Total" I $D(ABMP("FLAT")) W ?71,"Non-cvd"
 W !?10,"  Description",?31,"Code",?42,"Units",?53,"Charges" I $D(ABMP("FLAT")) W ?71,"Charges"
 ;end new abm*2.6*30 IHS/SD/SDR CR8870
 S ABMS("I")="",$P(ABMS("I"),"-",80)="" W !,ABMS("I")
 Q
