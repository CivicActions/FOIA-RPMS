ABMDE7A ; IHS/SD/SDR - Edit Page 7 - Inpatient Display Screen ;
 ;;2.6;IHS Third Party Billing System;**2,14,34**;NOV 12, 2009;Build 645
 ;
 ;IHS/SD/SDR 2.5*8 IM14016/IM15234/IM15615 Fix to Prior Authorization field
 ;
 ;IHS/SD/SDR v2.6 CSV
 ;IHS/SD/SDR 2.6*2 NO HEAT - Fix for <UNDEF>ICDDX+1^ABMCVAPI
 ;IHS/SD/SDR 2.6*14 Added '+' to DX^ABMCVAPI call to ensure numeric
 ;IHS/SD/SDR 2.6*34 ADO60694 CR7384 Updated display to include primary DX description and new DRG, and to be more readable;
 ;  removed Prof Comp Days display (not needed anymore)
 ;
DISP ;EP - Entry Point for displaying Inpatient info
 S ABMZ("TITL")="INPATIENT DATA",ABMZ("PG")=7
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)  I 1
 E  D SUM^ABMDE1
 ;
CNODES S ABM("C5")=$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),ABM("C6")=$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),6)),ABM("C7")=$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7))
 ;
 ; Hosp Info
ADMIT W !,"[1] Admission Date...: ",$$HDT^ABMDUTL($P(ABM("C6"),U,1))
AHR W ?40,"[2] Admission Hour....: ",$P(ABM("C6"),U,2)
 I $Y>(IOSL-6) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
TYPE W !,"[3] Admission Type...: " S ABM(1)=$P(ABM("C5"),U,1) I ABM(1)]"" S ABM(1)=$E($P(^ABMDCODE(ABM(1),0),U,3),1,49) W $E((100+$P(^(0),U,1)),2,3)," (",ABM(1),")"
 I $P(ABM("C5"),U,10) W ?40,"[3a] Newborn Days...: ",$P(ABM("C5"),U,10)
SRC W !,"[4] Admission Source.: " S ABM(1)=$P(ABM("C5"),U,2) I ABM(1)]"" S ABM(1)=$E($P(^ABMDCODE(ABM(1),0),U,3),1,49) W $E((100+$P(^(0),U,1)),2,3)," (",ABM(1),")"
 W ! F ABMT=1:1:80 W "-"  ;abm*2.6*34 IHS/SD/SDR ADO60694
DX ;W !,"[5] Admitting Diag...: " S ABM(1)=$P(ABM("C5"),U,9) I ABM(1)]"",$D(^ICD9(ABM(1),0)) S ABM(1)=$P($$DX^ABMCVAPI(ABM(1),ABMP("VDT")),U,2) W ABM(1)," (",$E($$ICDDX^ABMCVAPI(ABM(1),ABMP("VDT")),1,49),")"  ;CSV-c  ;abm*2.6*2 NOHEAT
 ;W !,"[5] Admitting Diag...: " S ABM(1)=$P(ABM("C5"),U,9) I ABM(1)]"",$D(^ICD9(ABM(1),0)) S ABM(1)=$P($$DX^ABMCVAPI(ABM(1),ABMP("VDT")),U,2) W ABM(1)," (",$E($P($$DX^ABMCVAPI(ABM(1),ABMP("VDT")),U,4),1,49),")"  ;CSV-c  ;abm*2.6*2  ;abm*2.6*14
 ;start old abm*2.6*34 IHS/SD/SDR ADO60694
 ;W !,"[5] Admitting Diag...: " S ABM(1)=$P(ABM("C5"),U,9) I ABM(1)]"",$D(^ICD9(ABM(1),0)) S ABM(1)=$P($$DX^ABMCVAPI(+ABM(1),ABMP("VDT")),U,2) W ABM(1)," (",$E($P($$DX^ABMCVAPI(ABM(1),ABMP("VDT")),U,4),1,49),")"  ;CSV-c  ;abm*2.6*14 +'d IEN
 ;I $Y>(IOSL-6) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 ;DISCH ;
 ;W !!,"[6] Discharge Date...: ",$$HDT^ABMDUTL($P(ABM("C6"),U,3))
 ;DHR W ?40,"[7] Discharge Hour....: ",$P(ABM("C6"),U,4)
 ;STAT W !,"[8] Discharge Status.: " S ABM(1)=$P(ABM("C5"),U,3) I ABM(1)]"" S ABM(1)=$P(^ABMDCODE(ABM(1),0),U,3) W $E((100+$P(^(0),U,1)),2,3)," (",ABM(1),")"
 ;I $Y>(IOSL-6) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 ;W ! F ABMT=1:1:80 W "-"  ;abm*2.6*34 IHS/SD/SDR ADO60694
 ;FROM W !,"[9] Service From Date: ",$$HDT^ABMDUTL($P(ABM("C7"),U,1))
 ;THRU W ?40,"[10] Service Thru Date: ",$$HDT^ABMDUTL($P(ABM("C7"),U,2))
 ;I $Y>(IOSL-6) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 ;CVD W !,"[11] Covered Days...: ",$P(ABM("C7"),U,3)
 ;NONCOVD W ?40,"[12] Non-Cvd Days...: ",$P(ABM("C6"),U,6)
 ;W !  ;abm*2.6*34 IHS/SD/SDR ADO60694
 ;AUTH W !,"[13] Prior Auth Number.....: ",$P(ABM("C5"),U,12)
 ;PCOMP D
 ;.Q:'$D(ABMP("VTYP",999))
 ;.Q:'$D(ABMP("FLAT"))
 ;.W !,"[14] Prof Comp Days..: ",$P(ABM("C5"),U,7)
 ;end old start new abm*2.6*34 IHS/SD/SDR ADO60694
 W !,"[5] Admitting Diag...: " S ABM(1)=$P(ABM("C5"),U,9) I ABM(1)]"",$D(^ICD9(ABM(1),0)) S ABMCD=$P($$DX^ABMCVAPI(+ABM(1),ABMP("VDT")),U,2) W ABMCD," (",$E($P($$DX^ABMCVAPI(+ABM(1),ABMP("VDT")),U,4),1,46),")"
 I '$G(ABMP("PDX")) D PRIMDX^ABMDE5  ;get primary DX if we don't have it already
 W !?4,"Primary Diagnosis: " I +$G(ABMP("PDX")) S ABMCD=$P($$DX^ABMCVAPI(ABMP("PDX"),ABMP("VDT")),U,2) W $E(ABMCD_" ("_$E($P($$DX^ABMCVAPI(ABMP("PDX"),ABMP("VDT")),U,4),1,45),1,56)_")"
 W !,"[6] DRG..............: "
 I +$P(ABM("C5"),U,13)'=0 W $$EN^ABMVDF("RVN"),$P(ABM("C5"),U,13),$$EN^ABMVDF("RVF")," ("_$E($G(^ICD($P(ABM("C5"),U,13),1,1,0)),1,50)_")"
 W ! F ABMT=1:1:80 W "-"
DISCH ;
 W !,"[7] Discharge Date...: ",$$HDT^ABMDUTL($P(ABM("C6"),U,3))
DHR W ?40,"[8] Discharge Hour....: ",$P(ABM("C6"),U,4)
STAT W !,"[9] Discharge Status.: " S ABM(1)=$P(ABM("C5"),U,3) I ABM(1)]"" S ABM(1)=$P(^ABMDCODE(ABM(1),0),U,3) W $E((100+$P(^(0),U,1)),2,3)," (",ABM(1),")"
 I $Y>(IOSL-6) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 W ! F ABMT=1:1:80 W "-"
FROM W !,"[10] Service From Date: ",$$HDT^ABMDUTL($P(ABM("C7"),U,1))
THRU W ?40,"[11] Service Thru Date: ",$$HDT^ABMDUTL($P(ABM("C7"),U,2))
 I $Y>(IOSL-6) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
CVD W !,"[12] Covered Days...: ",$P(ABM("C7"),U,3)
NONCOVD W ?40,"[13] Non-Cvd Days...: ",$P(ABM("C6"),U,6)
 W !
AUTH W !,"[14] Prior Auth Number.....: ",$P(ABM("C5"),U,12)
 ;end new abm*2.6*34 IHS/SD/SDR ADO60694
 Q
 ;
 ;
V1 ;EP - Entry Point for Inpatient View Command
 S ABMZ("TITL")="PAGE 7 - VIEW OPTION" D SUM^ABMDE1
 D ^ABMDERR
 Q
