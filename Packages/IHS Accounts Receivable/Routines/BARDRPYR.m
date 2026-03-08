BARDRPYR ; IHS/SD/LSL - DCM RESTRICT PAYERS ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**35**;OCT 26, 2005;Build 187
 ;
 ;IHS/SD/LSL V1.8 04/06/04 Routine created.  Modified version of BBMDC3 to move to AR namespace and use AR Site Parameters fields.
 ;IHS/SD/SDR 1.8*35 ADO60910 Updated to display PPN preferred name
 ;
 ; ********************************************************************
 ;
EP ; EP
 D:'$D(BARUSR) INIT^BARUTL           ;Set up basic A/R Variables
 K DIC,DR,DA,DIE,BARMULT
 W !!
 S DIC="^BAR(90052.06,DUZ(2),"
 S DIC(0)="AEMQZ"
 K DD,DO
 D ^DIC
 Q:+Y<1
 W !!
 S BARSITE=+Y
 K DIC,DR,DA,DIE
 S DA(1)=BARSITE
 S DIC="^BAR(90052.06,DUZ(2),"_DA(1)_",13,"
 S DIC("A")="Select A/R Account to Restrict Transmission: "
 S DIC(0)="AEMQLZ"  ;bar*1.8*35 IHS/SD/SDR ADO60910
 S DIC("P")=$P(^DD(90052.06,1300,0),U,2)
 S DIC("DR")=".02////1"
 S DLAYGO=90052
 K Y
 S BARDONE=0
 F  D  Q:+BARDONE
 .S DIC("W")="D DICWACCT^BARUTL0(X)"  ;bar*1.8*35 IHS/SD/SDR ADO60910
 .I $D(BARMULT) S DIC("A")="Select Another A/R Account to Restrict Transmission: "
 .K DD,DO
 .D ^DIC
 .I +Y<1 S BARDONE=1 Q
 .S BARMULT=1
 .S DA=+Y
 .S DIE=DIC
 .S DR=".01;.02"
 .D ^DIE
 .W !
 Q
