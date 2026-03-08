ABMDVPAT ; IHS/ASDST/DMJ - CLAIM FOR ONE PAT ;
 ;;2.6;IHS 3P BILLING SYSTEM;**11,33,37**;NOV 12, 2009;Build 739
 ;;Y2K/OK - IHS/ADC/JLG 12-03-97
 ;IHS/SD/SDR 2.6*33 ADO60185 CR11502 Added preferred name to display all the time
 ;IHS/SD/SDR 2.6*37 ADO81491 Changed PPN to standardize display
 ;
 S DIC="^AUPNPAT("
 S DIC(0)="AEMQ"
 S DIC("S")="I $D(^AUPNVSIT(""AC"",Y))"
 S AUPNLK("ALL")=""  ;universal lookup  ;abm*2.6*11 NOHEAT6
 S DIC("W")="S Z=+Y D DICW^ABMDEMRG"  ;abm*2.6*37 IHS/SD/SDR ADO81491
 D ^DIC
 ;start new abm*2.6*33 IHS/SD/SDR ADO60185
 ;I $$GETPREF^AUPNSOGI(+Y,"")'="" D  ;abm*2.6*37 IHS/SD/SDR ADO81491
 ;.W !?5,"Preferred Name: ",$$EN^ABMVDF("RVN"),$$GETPREF^AUPNSOGI(+Y,""),$$EN^ABMVDF("RVF")  ;abm*2.6*37 IHS/SD/SDR ADO81491
 ;end new abm*2.6*33 IHS/SD/SDR ADO60185
 I Y<1 D  Q
 .W !,"No patient selected."
 W !
 D QUEUE
 W !
 S DIR(0)="Y",DIR("A")="Another patient",DIR("B")="NO"
 D ^DIR
 I Y G ABMDVPAT
 K DIC,DIR,Y,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
 Q
 ;
QUEUE ;EP - requires patient DFN in Y
 S ZTSAVE("ABMDFN")=+Y
 S ZTRTN="^ABMDVCK",ZTIO=""
 S ZTDESC="Generate Third Party Billing Claim for one patient."
 S ZTDTH=$H
 D ^%ZTLOAD
 I $D(ZTSK)[0 W !,"Claim generator not run." Q
 E  W !,"Claim generator queued for selected patient."
 K DIR
 S DIR(0)="E"
 D ^DIR
 Q
