ABMDVE04 ; IHS/ASDST/DMJ - Recreate cancelled claim from PCC ;
 ;;2.6;IHS 3P BILLING SYSTEM;**35,37**;NOV 12, 2009;Build 739
 ;Allows user to look up visit by patient and reset .04 field in visit file and creates ABILL X-ref so claim will be
 ;recreated by claim generator
 ;
 ;IHS/SD/SDR 2.6*35 ADO60700 Added API calls for clalim generator report
 ;IHS/SD/SDR 2.6*37 ADO81491 Updated preferred name PPN to use XPAR site parameter
 ;
START ;EP
 S DIC="^AUPNPAT("
 S DIC(0)="AEMQ"
 S DIC("S")="I $D(^AUPNVSIT(""AC"",Y))"
 D ^DIC
 I Y<0 G Q
 S DFN=+Y
 ;I $$GETPREF^AUPNSOGI(DFN,"I",1)'="" D  ;abm*2.6*37 IHS/SD/SDR ADO81491
 ;.W !?3,"Preferred Name: ",$$EN^ABMVDF("RVN"),$$GETPREF^AUPNSOGI(DFN,"I",1),$$EN^ABMVDF("RVF"),!  ;actually write the preferred name in header  ;abm*2.6*37 IHS/SD/SDR ADO81491
 S DIC="^AUPNVSIT("
 S DIC(0)="AEQ"
 S DIC("S")="I $D(^AUPNVSIT(""AC"",DFN,Y))&'$P(^AUPNVSIT(Y,0),U,11)"
 D ^DIC
 I Y<0 G Q
 S ABMV=+Y
 S Y=^AUPNVSIT(ABMV,0)
 N ABMDTC,ABMDTM
 S ABMDTC=$P(Y,U,2)
 S ABMDTM=$P(Y,U,13)
 I $P(Y,U,4)=1 D
 .S DIE=DIC
 .S DR=".04///@"
 .S DA=ABMV
 .D ^DIE
 I '$D(^AUPNVSIT("ABILL",ABMDTC,ABMV)),'$D(^AUPNVSIT("ABILL",+ABMDTM,ABMV)) D
 .S ^AUPNVSIT("ABILL",ABMDTC,ABMV)=""     ;Set ABILL X-ref
 .S ABMCGIEN=$$EN^ABMCGAPI("","RCCP")  ;abm*2.6*35 IHS/SD/SDR ADO60700
 .D VISIT^ABMCGAPI(ABMV,ABMCGIEN)  ;abm*2.6*35 IHS/SD/SDR ADO60700
 W !!,"Claim will be created for this visit next time claim generator runs."
 G START
 ;
Q K DIC,DIE,ABMV,DR
 Q
