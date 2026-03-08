ABMDES4 ; IHS/SD/SDR - ADA Form Dental Charge Summary ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**11,14,28,30,37**;NOV 12, 2009;Build 739
 ;
 ;IHS/SD/EFG 2.5*8 IM16385 Fix header wrapping; include misc services
 ;IHS/SD/SDR 2.5*10 IM20395 Split out lines bundled by rev code
 ;IHS/SD/SDR 2.5*10 IM21581 Added active insurer print to summary
 ;
 ;IHS/SD/SDR v2.6 CSV
 ;IHS/SD/SDR 2.6*14 5/8/14 HEAT163277 Made change for RX multiple so charges would be counted in total sooner
 ;IHS/SD/SDR 2.6*28 CR8340 Added 3 modifiers to summary
 ;IHS/SD/SDR 2.6*30 CR8870 Updated display so it won't wrap if units are maxed out, including 3 decimal places
 ;IHS/SD/SDR 2.6*37 ADO76036 Added ABMP("TOT") var for COB page Current Charges
 ;
 N ABM
 Q:'$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),33,0))&('$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,0)))
 D HD
 G XIT:$D(DUOUT)
 D WRT
 Q:$G(ABMQUIET)
 F  W ! Q:$Y+4>IOSL
 S DIR(0)="E"
 D ^DIR
 K DIR
 ;
XIT ;
 K DUOUT
 Q
 ;
HD ;
 ; SCREEN HEADER
 Q:$G(ABMQUIET)
 W $$EN^ABMVDF("IOF")
 W !?15,"***** ADA FORM DENTAL CHARGE SUMMARY *****"
 W !!,"Active Insurer: ",$P($G(^AUTNINS(ABMP("INS"),0)),U),!
 ;W !!?2,"Tooth",?9,"Surface",?20,"Description of Service",?52,"Date",?60,"ADA Code",?73,"Fee"  ;abm*2.6*28 IHS/SD/SDR CR8340
 ;W !!?2,"Tooth",?9,"Surface",?20,"Description of Service",?47,"Date",?57,"ADA Code",?73,"Fee"  ;abm*2.6*28 IHS/SD/SDR CR8340  ;abm*2.6*30 IHS/SD/SDR CR8870
 ;start new abm*2.6*30 IHS/SD/SDR CR8870
 W !!,?18,"Description"
 W !?1,"Tooth",?7,"Surface",?18,"Of Service",?41,"Date",?51,"ADA Code",?72,"Fee"  ;abm*2.6*28 IHS/SD/SDR CR8340  ;abm*2.6*30 IHS/SD/SDR CR8870
 ;end new abm*2.6*30 IHS/SD/SDR CR8870
 W !,"-------------------------------------------------------------------------------"
 Q
 ;
WRT ;
 ;start new code abm*2.6*11 HEAT117086
 S ABM("TCHRG")=0
 S ABM=0
 I '$G(ABMQUIET) W !
 F  S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABM)) Q:'ABM  S ABM(0)=^(ABM,0)  D
 .I $P($$CPT^ABMCVAPI(+ABM(0),ABMP("VDT")),U,2)'="T1015" Q  ;CSV-c
 .S ABM("CHRG")=$P(ABM(0),U,4)
 .S ABM("CHRG")=ABM("CHRG")*$P($G(ABM(0)),U,3)
 .S ABM("TCHRG")=ABM("TCHRG")+ABM("CHRG")
 .Q:$G(ABMQUIET)
 .I $Y+5>IOSL D HD Q:$D(DUOUT)
 .W !
 .;start old abm*2.6*28 IHS/SD/SDR CR8340
 .;W ?18,$E($P($$CPT^ABMCVAPI(+ABM(0),ABMP("VDT")),U,3),1,30)  ;CSV-c
 .;W ?50,$$HDT^ABMDUTL($P(ABM(0),U,7))
 .;W ?62,$P($$CPT^ABMCVAPI(+ABM(0),ABMP("VDT")),U,2)  ;CSV-c
 .;W ?70,$J($FN(ABM("CHRG"),",",2),8)
 .;start old abm*2.6*30 IHS/SD/SDR CR8870
 .;end old start new abm*2.6*28 IHS/SD/SDR CR8340
 .;W ?18,$E($P($$CPT^ABMCVAPI(+ABM(0),ABMP("VDT")),U,3),1,25)
 .;W ?44,$$HDT^ABMDUTL($P(ABM(0),U,7))
 .;W ?56,$P($$CPT^ABMCVAPI(+ABM(0),ABMP("VDT")),U,2)  ;CSV-c
 .;F ABMI=5,8,9 D
 .;.W $S($P(ABM(0),U,ABMI)'="":"-"_$P(ABM(0),U,ABMI),1:"")
 .;W ?71,$J($FN(ABM("CHRG"),",",2),8)
 .;end new abm*2.6*28 IHS/SD/SDR CR8340
 .;end old start new abm*2.6*30 IHS/SD/SDR CR8870
 .W ?17,$E($P($$CPT^ABMCVAPI(+ABM(0),ABMP("VDT")),U,3),1,20)
 .W ?39,$$HDTO^ABMDUTL($P(ABM(0),U,7))
 .W ?49,$P($$CPT^ABMCVAPI(+ABM(0),ABMP("VDT")),U,2)  ;CSV-c
 .F ABMI=5,8,9 D
 ..W $S($P(ABM(0),U,ABMI)'="":"-"_$P(ABM(0),U,ABMI),1:"")
 .W ?67,$J($FN(ABM("CHRG"),",",2),13)
 ;end new abm*2.6*30 IHS/SD/SDR CR8870
 ;end new code HEAT117086
 ;
 ;S (ABM("C"),ABM,ABM("TCHRG"))=0  ;abm*2.6*11 HEAT117086
 S (ABM("C"),ABM)=0  ;abm*2.6*11 HEAT117086
 F  S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),33,ABM)) Q:'ABM  S ABM(0)=^(ABM,0) D  Q:$D(DUOUT)
 .S ABM("CHRG")=$P(ABM(0),U,8)
 .S ABM("CHRG")=ABM("CHRG")*$P($G(ABM(0)),U,9)
 .S ABM("TCHRG")=ABM("TCHRG")+ABM("CHRG")
 .Q:$G(ABMQUIET)
 .I $Y+5>IOSL D HD Q:$D(DUOUT)
 .W !
 .I $P(ABM(0),U,5) D
 ..S ABMOPS=$P(ABM(0),U,5)
 ..S ABMTMP=$P($G(^ADEOPS(ABMOPS,88)),U)
 ..S:ABMTMP["D" ABMTMP=$P($G(^ADEOPS(ABMOPS,0)),U,4)
 ..I (($D(^ABMDREC(ABMP("INS"))))&($P($G(^ABMDREC(ABMP("INS"),0)),U,3)="Y")&($L(ABMTMP)=1)&(+ABMTMP'=0)) S ABMTMP="0"_ABMTMP  ;abm*2.6*37 IHS/SD/SDR ADO76301
 ..W ?2,ABMTMP  ;tooth
 .;W ?9,$P(ABM(0),U,6)  ;surface  ;abm*2.6*30 IHS/SD/SDR CR8870
 .W ?8,$P(ABM(0),U,6)  ;surface  ;abm*2.6*30 IHS/SD/SDR CR8870
 .;start old abm*2.6*28 IHS/SD/SDR CR8340
 .;W ?18,$E($P(^AUTTADA(+ABM(0),0),U,2),1,30)
 .;W ?50,$$HDT^ABMDUTL($P(ABM(0),U,7))
 .;W ?62,$P(^AUTTADA(+ABM(0),0),U)
 .;W ?70,$J($FN(ABM("CHRG"),",",2),8)
 .;end old start new abm*2.6*28 IHS/SD/SDR CR8340
 .;start old abm*2.6*30 IHS/SD/SDR CR8870
 .;W ?18,$E($P(^AUTTADA(+ABM(0),0),U,2),1,25)
 .;W ?44,$$HDT^ABMDUTL($P(ABM(0),U,7))
 .;W ?56,$P(^AUTTADA(+ABM(0),0),U)
 .;F ABMI=13,14,15 D
 .;.W $S($P(ABM(0),U,ABMI)'="":"-"_$P(ABM(0),U,ABMI),1:"")
 .;W ?71,$J($FN(ABM("CHRG"),",",2),8)
 .;end new abm*2.6*28 IHS/SD/SDR CR8340
 .;end old start new abm*2.6*30 IHS/SD/SDR CR8870
 .W ?17,$E($P(^AUTTADA(+ABM(0),0),U,2),1,20)  ;desc
 .W ?39,$$HDTO^ABMDUTL($P(ABM(0),U,7))  ;date
 .W ?49,$P(^AUTTADA(+ABM(0),0),U)  ;ADA code
 .F ABMI=13,14,15 D  ;modifiers
 ..W $S($P(ABM(0),U,ABMI)'="":"-"_$P(ABM(0),U,ABMI),1:"")
 .W ?67,$J($FN(ABM("CHRG"),",",2),13)  ;fee
 I ABMP("EXP")=33 S ABMP("TOT")=$S($D(ABMP("FLAT")):+ABMP("FLAT"),1:ABM("TCHRG"))  ;set this for 837D only; otherwise the charge summary is doubled  ;abm*2.6*37 IHS/SD/SDR ADO76036
 ;end new abm*2.6*30 IHS/SD/SDR CR8870
 ;
 S ABM=0
 I '$G(ABMQUIET) W !
 F  S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABM)) Q:'ABM  S ABM(0)=^(ABM,0)  D
 .I $P($$CPT^ABMCVAPI(+ABM(0),ABMP("VDT")),U,2)="T1015" Q  ;CSV-c  ;abm*2.6*11 HEAT117086
 .S ABM("CHRG")=$P(ABM(0),U,4)
 .S ABM("CHRG")=ABM("CHRG")*$P($G(ABM(0)),U,3)
 .S ABM("TCHRG")=ABM("TCHRG")+ABM("CHRG")
 .Q:$G(ABMQUIET)
 .I $Y+5>IOSL D HD Q:$D(DUOUT)
 .W !
 .;start old abm*2.6*28 IHS/SD/SDR CR8340
 .;W ?18,$E($P($$CPT^ABMCVAPI(+ABM(0),ABMP("VDT")),U,3),1,30)  ;CSV-c
 .;W ?50,$$HDT^ABMDUTL($P(ABM(0),U,7))
 .;W ?62,$P($$CPT^ABMCVAPI(+ABM(0),ABMP("VDT")),U,2)  ;CSV-c
 .;W ?70,$J($FN(ABM("CHRG"),",",2),8)
 .;start old abm*2.6*30 IHS/SD/SDR CR8870
 .;end old start new abm*2.6*28 IHS/SD/SDR CR8340
 .;W ?18,$E($P($$CPT^ABMCVAPI(+ABM(0),ABMP("VDT")),U,3),1,25)  ;CSV-c
 .;W ?44,$$HDT^ABMDUTL($P(ABM(0),U,7))
 .;W ?56,$P($$CPT^ABMCVAPI(+ABM(0),ABMP("VDT")),U,2)  ;CSV-c
 .;F ABMI=5,8,9 D
 .;.W $S($P(ABM(0),U,ABMI)'="":"-"_$P(ABM(0),U,ABMI),1:"")
 .;W ?71,$J($FN(ABM("CHRG"),",",2),8)
 .;end new abm*2.6*28 IHS/SD/SDR CR8340
 .;end old start new abm*2.6*30 IHS/SD/SDR CR8870
 .W ?17,$E($P($$CPT^ABMCVAPI(+ABM(0),ABMP("VDT")),U,3),1,20)  ;CSV-c
 .W ?39,$$HDTO^ABMDUTL($P(ABM(0),U,7))
 .W ?49,$P($$CPT^ABMCVAPI(+ABM(0),ABMP("VDT")),U,2)  ;CSV-c
 .F ABMI=5,8,9 D
 ..W $S($P(ABM(0),U,ABMI)'="":"-"_$P(ABM(0),U,ABMI),1:"")
 .W ?67,$J($FN(ABM("CHRG"),",",2),13)
 ;end new abm*2.6*30 IHS/SD/SDR CR8870
 ;
 ; Include RX charges
 I '$G(ABMQUIET) W !
 N ABMRV
 S DA=0
 F  S DA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA)) Q:'DA  D
 .F J=1:1:5 S ABM(J)=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0),U,J)
 .S ABMCNTR=+$O(ABMRV(+ABM(2),ABM(1),0))
 .S $P(ABMRV(+ABM(2),ABM(1),ABMCNTR),U)=ABM(2)  ; revenue code IEN
 .S $P(ABMRV(+ABM(2),ABM(1),ABMCNTR),U,5)=$P(ABMRV(+ABM(2),ABM(1),ABMCNTR),U,5)+ABM(3)  ; cumulative units
 .S ABM(6)=ABM(3)*ABM(4)+ABM(5)  ; units * units cost + dispense fee
 .S ABM(6)=$J(ABM(6),1,2)
 .S $P(ABMRV(+ABM(2),ABM(1),ABMCNTR),U,6)=$P(ABMRV(+ABM(2),ABM(1),ABMCNTR),U,6)+ABM(6)   ; cumulative charges
 .S $P(ABMRV(+ABM(2),ABM(1),ABMCNTR),U,9)=$P($G(^PSDRUG(ABM(1),2)),U,4)_" "_$P($G(^(0)),U)  ; NDC generic name
 ;
 ;S ABMRCD=0  ;abm*2.6*14 HEAT163277
 S ABMRCD=-1  ;abm*2.6*14 HEAT163277
 F  S ABMRCD=$O(ABMRV(ABMRCD)) Q:'+ABMRCD  D
 .S ABMED=0
 .F  S ABMED=$O(ABMRV(ABMRCD,ABMED)) Q:'+ABMED  D  Q:$D(DUOUT)
 ..;S ABMCNTR=0  ;abm*2.6*14 HEAT163277
 ..S ABMCNTR=-1  ;abm*2.6*14 HEAT163277
 ..F  S ABMCNTR=$O(ABMRV(ABMRCD,ABMED,ABMCNTR)) Q:ABMCNTR=""  D
 ...S ABMRXCHG=$P(ABMRV(ABMRCD,ABMED,ABMCNTR),U,6)  ;Charge
 ...S ABM("TCHRG")=ABM("TCHRG")+ABMRXCHG
 ...Q:$G(ABMQUIET)
 ...S ABMRX=$P(ABMRV(ABMRCD,ABMED,ABMCNTR),U,9)  ;NDC# name
 ...S ABMRXDT=$P(ABMRV(ABMRCD,ABMED,ABMCNTR),U,10)  ;date/time
 ...S ABMRXQTY=$P(ABMRV(ABMRCD,ABMED,ABMCNTR),U,5)  ;quantity
 ...I $Y+5>IOSL D HD Q:$D(DUOUT)
 ...W !
 ...;start old abm*2.6*30 IHS/SD/SDR CR8870
 ...;W ?2,$E(ABMRX,1,48)
 ...;W ?50,$$HDT^ABMDUTL(ABMRXDT)
 ...;W ?62,"QTY "_ABMRXQTY
 ...;;W ?70,$J($FN(ABMRXCHG,",",2),8)  ;abm*2.6*28 IHS/SD/SDR CR8340
 ...;W ?71,$J($FN(ABMRXCHG,",",2),8)  ;abm*2.6*28 IHS/SD/SDR CR8340
 ...;end old start new abm*2.6*30 IHS/SD/SDR CR8870
 ...W ?1,$E(ABMRX,1,40)
 ...W ?43,$$HDTO^ABMDUTL(ABMRXDT)
 ...W ?52,"QTY "_ABMRXQTY
 ...W ?67,$J($FN(ABMRXCHG,",",2),13)  ;abm*2.6*28 IHS/SD/SDR CR8340
 ;end old abm*2.6*30 IHS/SD/SDR CR8870
 ;
 I '$G(ABMQUIET) D
 .;W !?71,"========"  ;abm*2.6*28 IHS/SD/SDR CR8340
 .;W !?71,"========="  ;abm*2.6*28 IHS/SD/SDR CR8340  ;abm*2.6*30 IHS/SD/SDR CR8870
 .W !?67,"============="  ;abm*2.6*28 IHS/SD/SDR CR8340  ;abm*2.6*30 IHS/SD/SDR CR8870
 .;W !?10,"TOTAL CHARGE",?69,$J($FN(ABM("TCHRG"),",",2),9)  ;abm*2.6*28 IHS/SD/SDR CR8340
 .;W !?10,"TOTAL CHARGE",?70,$J($FN(ABM("TCHRG"),",",2),9)  ;abm*2.6*28 IHS/SD/SDR CR8340  ;abm*2.6*30 IHS/SD/SDR CR8870
 .W !?10,"TOTAL CHARGE",?66,$J($FN(ABM("TCHRG"),",",2),14)  ;abm*2.6*28 IHS/SD/SDR CR8340  ;abm*2.6*30 IHS/SD/SDR CR8870
 I $D(ABMP("FLAT")) D
 .S ABM("TCHRG")=$P(ABMP("FLAT"),U)
 .Q:$G(ABMQUIET)
 .W !!?49,"Flat Rate Applied:",?69,$J($FN(ABM("TCHRG"),",",2),9)
 S:ABM("TCHRG") ABMP("EXP",ABMP("EXP"))=ABM("TCHRG")
 Q
