ACHSTXUT ; IHS/ITSC/PMF - DATA TRANMISSION SUBROUTINES ;  [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**32**;JUN 11, 2001;Build 39
 ;ACHS*3.1*32 12.12.24 IHS.OIT.FCJ REMOVE CALL TO THE IHS TRANSMISSION LOG FILE AND REPLACED WITH CHS AO FILE TRANSMISSION
 W !!,*7,"NOT AN ENTRY POINT"
 Q
 ;
TXLOGADD ;EP - Add entry to transmission log.;ACHS*3.1*32 NO LONGER USED
 ;
TXLOG ;EP - Add entry to CHS transmission log. ;ACHS*3.1*32 NEW SUB
 ;;ACHSEXFS=FILE NAME TO BE ADDED TO TX LOG FILE
 S DIC(0)="ZML"
 K DA,X,Y
 I '$D(ACHSEXFS) G ABEND
 I '$D(DUZ(2)) G ABEND
 I '$D(^ACHSAOFI(DUZ(2))) S X=$$LOC^ACHS,DIC="^ACHSAOFI(" D ^DIC
L2 ;
 I $D(^ACHSAOFI(DUZ(2),1,0)) G L3
 LOCK +^ACHSAOFI(DUZ(2),1,0):3
 E  W *7,!!,"FILE IN USE BY ANOTHER USER",! G ABEND:'$$DIR^XBDIR("E"),L2
 S ^ACHSAOFI(DUZ(2),1,0)=$$ZEROTH^ACHS(9002077.1,1)
L3 ;
 S DIC="^ACHSAOFI("_DUZ(2)_",1,",X=ACHSEXFS,DA(1)=DUZ(2)
 D ^DIC
 S ACHSY=+Y
 LOCK -^ACHSAOFI(DUZ(2),1,0):3
 Q
 ;ACHS*3.1*32 END OF CHANGES
 ;
ABEND ;
 S (Y,ACHSY)=-1
 Q
 ;
PT ;EP - From Option.  Mark Patient for re-export.
 N DFN
 D PTLK^ACHS
 Q:'$G(DFN)
 W !!,$P(^DPT(DFN,0),U),!
 I '$D(^ACHSF(DUZ(2),"PB",DFN)) W "This patient has no CHS documents on file." Q
 I '$P(^AUPNPAT(DFN,0),U,15) W "has already been marked for export with the next P.O. for them." Q
 W "was last exported on ",$$FMTE^XLFDT($P(^AUPNPAT(DFN,0),U,15)),"."
 Q:'$$DIR^XBDIR("Y","R U Sure you want to mark '"_$P(^DPT(DFN,0),U)_"' for export","N")
 N DIE,DA,DR
 S DIE="^AUPNPAT(",DA=DFN,DR=".15///@"
 D ^DIE
 Q
 ;
VEN ;EP - From Option.  Mark Vendor for re-export.
 N DIC,DA
 S DIC="^AUTTVNDR(",DIC(0)="AEZQM",DIC("A")="Enter Provider/Vendor: "
 D ^DIC
 Q:Y<1
 S DA=+Y
 W !!,$P(^AUTTVNDR(DA,0),U),!
 I '$D(^ACHSF(DUZ(2),"VB",DA)) W "This vendor has no CHS documents on file.",! Q
 I '$P(^AUTTVNDR(DA,11),U,12) W "has already been marked for export with the next P.O. for them." Q
 W "was last exported on ",$$FMTE^XLFDT($P(^AUTTVNDR(DA,11),U,12)),"."
 Q:'$$DIR^XBDIR("Y","R U Sure you want to mark '"_$P(^AUTTVNDR(DA,0),U)_"' for export","N")
 N DIE,DR
 S DIE="^AUTTVNDR(",DR="1112///@"
 D ^DIE
 Q
 ;
