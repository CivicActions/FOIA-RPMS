PSSSEE ;BIR/ASJ-SYNONYM DRUG ENTER/EDIT ROUTINE ; 01/21/00 13:30
 ;;1.0;PHARMACY DATA MANAGEMENT;**37**;09/30/97
 ;
 N PSDRUG,PSSFLAG
BEGIN S PSSFLAG=0 D ^PSSDEE2 F PSSXX=1:1 K DA D ASK Q:PSSFLAG
DONE D ^PSSDEE2 K PSSFLAG W @IOF Q
ASK W ! S DIC="^PSDRUG(",DIC(0)="QEAMN" D ^DIC K DIC I Y<0 S PSSFLAG=1 Q
 S DA=+Y,DISPDRG=DA L +^PSDRUG(DISPDRG):0 W:'$T !,$C(7),"Another person is editing this one." I $T D COMMON L -^PSDRUG(DISPDRG)
 Q
COMMON S DIE="^PSDRUG(",DR="[PSS SYNONYM]" D ^DIE K DIE,DR,DA,Y Q
 ;
INPUT ;Input transform for SYNONYM field (.01) contained in SYNONYM sub-file (#9) of the DRUG file (#50)
 I X?.N&($L(X)<6) S X="" Q
 I X?1"3"15N!(X?1"3"17N),123[$E(X,12) D
 .S X=$E(X,2,11)
 .D EN^DDIOL("This synonym entered ("_X_") matches the industry standard for",,"$C(7),!!?8")
 .D EN^DDIOL("medication identification and has been modified",,"!?8")
 Q
