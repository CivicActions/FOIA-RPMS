ABMDVST5 ; IHS/ASDST/DMJ - PCC VISIT STUFF - PART 6 (PHARMACY) ;   
 ;;2.6;IHS Third Party Billing System;**2,4,36,37,38**;NOV 12, 2009;Build 756
 ;Original;TMD;08/19/96 5:01 PM
 ;
 ;IHS/SD/SDR 2.5*8 task 57 Removed check for OTC drugs and no entry in fee schedule.  Also
 ;    added code to populate dt disc. and RTS if flag is set.
 ;IHS/SD/SDR 2.5*9 IM19140 <SUBSCRIPT>ABMDVST5+29^ABMDVST5
 ;IHS/SD/SDR 2.5*10 IM21500 Added code to check new V Med field POINT OF SALE BILLING STATUS and only bill if blank or rejected
 ;
 ;IHS/SD/SDR 2.6*36 ADO76247 Smartened up the check so if a V Med POINT OF SALE BILLING STATUS is NOT 'POS BILLED' it will include on the claim
 ;IHS/SD/SDR 2.6*37 ADO89299 Capture DEA_VA_USPHS for ordering provider
 ;IHS/SD/SDR 2.6*38 ADO97221 Put code back so if the RX BILLING STATUS is 'P' no medications will cross over to claim
 ;
 I $G(ABMP("RXDONE")) Q
 I $G(ABMP("INS"))'="",($P($G(^AUTNINS(ABMP("INS"),2)),U,3)="U") Q
 I $G(ABMP("INS"))'="",($P($G(^AUTNINS(ABMP("INS"),2)),"^",3)="P") Q  ;abm*2.6*36 IHS/SD/SDR ADO76247  ;abm*2.6*38 IHS/SD/SDR ADO97221 put this line back
 ;start old abm*2.6*38 IHS/SD/SDR ADO97221
 ;;start new abm*2.6*36 IHS/SD/SDR ADO76247
 ;S ABMPSFLG=1
 ;S ABMVMIEN=0
 ;F  S ABMVMIEN=$O(^AUPNVMED("AD",ABMVDFN,ABMVMIEN)) Q:+ABMVMIEN=0  D  Q:$G(ABMPSFLG)=0  ;there's still an RX to bill
 ;.I $P($G(^AUPNVMED(ABMVMIEN,11)),U,6)="" S ABMPSFLG=0  ;POINT OF SALE BILLING STATUS blank so we should try billing it
 ;;if active insurer RX BILLING STATUS is 'P' for 'BILLED POINT OF SALE' and there's only meds that were all billed POS
 ;I ($G(ABMP("INS"))'="")&($P($G(^AUTNINS(ABMP("INS"),2)),U,3)="P")&($G(ABMPSFLG)=1) Q
 ;;end new abm*2.6*36 IHS/SD/SDR ADO76247
 ;end old abm*2.6*38 IHS/SD/SDR ADO97221
 S (ABM("TIME"),ABMR("TIME"))=$P(ABMP("V0"),U)
 ;
MED ;
 K DIC
 S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_",23,",DIC(0)="LE"
 S ABM=0 F  S ABM=$O(^AUPNVMED("AD",ABMVDFN,ABM)) Q:'ABM  D
 .Q:'$D(^AUPNVMED(ABM,0))
 .Q:$P(^AUPNVMED(ABM,0),"^",8)&($G(ABMRXFLG)'=1)
 .Q:$P($G(^AUPNVMED(ABM,11)),U,6)=1  ;POS BILLED so skip it  ;abm*2.6*36 IHS/SD/SDR ADO76247
 .S X=$P(^AUPNVMED(ABM,0),U)
 .S ABMSRC="14|"_ABM_"|RX"
 .D MEDCHK
 .Q:ABMR("QTY")=""&($G(ABMRXFLG)'=1)
 .Q:$G(ABMR("RTS"))&($G(ABMRXFLG)'=1)
 .D MEDSET
Q K DIC,ABMR,DR,DIE,X,Y
 Q
 ;
MEDCHK ;
 S ABMR("X")=$O(^PSRX("APCC",ABM,""))
 I ABMR("X")="" D NORX Q
 S ABMR("RX")=$P($G(^PSRX(ABMR("X"),0)),U)
 I ABMR("RX")="" D NORX Q
 S ABMR("DTWR")=$P(^PSRX(ABMR("X"),0),"^",13)
 S ABMR("DEA")=$P($G(^PSRX(ABMR("X"),999999931)),U,7)  ;DEA_VA_USPHS  ;abm*2.6*37 IHS/SD/SDR ADO89299
 S ABMR("REF")=$O(^PSRX("APCC",ABM,ABMR("X"),0))
 I ABMR("REF")="" D
 .S ABMR0=$G(^PSRX(ABMR("X"),0))
 .S ABMR2=$G(^PSRX(ABMR("X"),2))
 .S ABMR("QTY")=$P(ABMR0,"^",7)
 .S ABMR("RTS")=$P(ABMR2,"^",15)
 .S ABMR("DAYS")=$P(ABMR0,"^",8)
 .S ABMR("NDC")=$P(ABMR2,"^",7)
 .S ABMR("PROV")=$P(ABMR0,"^",4)
 I ABMR("REF")'="" D
 .S ABMR0=$G(^PSRX(ABMR("X"),1,ABMR("REF"),0))
 .S ABMR("QTY")=$P(ABMR0,"^",4)
 .S ABMR("RTS")=$P(ABMR0,"^",16)
 .S ABMR("DAYS")=$P(ABMR0,"^",10)
 .S ABMR("NDC")=$$NDCVAL^ABMPFUNC(ABMR("X"),ABMR("REF"))
 .S ABMR("PROV")=$P(ABMR0,"^",17)
 Q
NORX ;no entry in prescription file
 S ABMR("QTY")=$P(^AUPNVMED(ABM,0),"^",6)
 S ABMR("RX")=""
 Q
MEDSET ;FILE
 S DA=$O(^ABMDCLM(DUZ(2),DA(1),"ASRC",ABMSRC,0))
 I DA,'$D(@(DIC_DA_",0)")) S DA=""          ;For duplicates problem
 S ABMR("PPDU")=+$P($$ONE^ABMFEAPI(ABMP("FEE"),25,X,ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A  ;abm*2.6*4 NOHEAT
 S:'ABMR("PPDU") ABMR("PPDU")=+$P($G(^PSDRUG(X,660)),U,6)  ;abm*2.6*4 NOHEAT
 I (($P($$ONE^ABMFEAPI(ABMP("FEE"),25,X,ABMP("VDT")),U)=0)&('ABMR("PPDU"))&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y")) Q  ;abm*2.6*4 NOHEAT
 I 'DA D
 .S DIC("P")=$P(^DD(9002274.3,23,0),U,2)
 .; ADD DEFAULT REV CODE
 .S DIC("DR")=".02////250"
 .K DD,DO D FILE^DICN
 .K DIC("DR")
 .S DA=+Y
 S ABMT("SV")=DA  ;abm*2.6*37 IHS/SD/SDR ADO89299
 Q:DA<0  S DIE=DIC
 S ABMR("SURC")=$S(ABMP("VTYP")'=111:$P(^ABMDPARM(DUZ(2),1,0),U,3),1:$P($G(^ABMDPARM(DUZ(2),1,4)),U,6))
 ;X is the drug ien.  ABMDFEE is dinumed in this mult
 ;Q:($P($G(^ABMDFEE(ABMP("FEE"),25,X,0)),U,2)=0&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"))  ;abm*2.6*2 3PMS10003A
 ;Q:($P($$ONE^ABMFEAPI(ABMP("FEE"),25,X,ABMP("VDT")),U)=0&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"))  ;abm*2.6*2 3PMS10003A  ;abm*2.6*4 NOHEAT
 ;S ABMR("PPDU")=+$P($G(^ABMDFEE(ABMP("FEE"),25,X,0)),U,2)  ;abm*2.6*2 3PMS10003A
 ;S ABMR("PPDU")=+$P($$ONE^ABMFEAPI(ABMP("FEE"),25,X,ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A  ;abm*2.6*4 NOHEAT
 ;S:'ABMR("PPDU") ABMR("PPDU")=+$P($G(^PSDRUG(X,660)),U,6)  ;abm*2.6*4 NOHEAT
 K DR
 S DR=".03////"_ABMR("QTY")_";.04////"_ABMR("PPDU")_";.05////"_ABMR("SURC")_";.06////"_ABMR("RX")_";.14////"_ABMR("TIME")
 ;Next line set correspond diagnosis if only 1 POV
 I $D(ABMP("CORRSDIAG")) S DR=DR_";.13////1"
 S DR=DR_";.17////"_ABMSRC
 D ^DIE
 S DR=".22////"_ABMR("X")
 D ^DIE
 ;S DR=".23////"_$G(ABMR("PROV"))  ;abm*2.6*37 IHS/SD/SDR ADO89299
 ;D ^DIE  ;abm*2.6*37 IHS/SD/SDR ADO89299
 S DR=".24////"_$G(ABMR("NDC"))
 D ^DIE
 S DR=".2////"_$G(ABMR("DAYS"))
 D ^DIE
 S DR=".19////"_+$G(ABMR("REF"))
 D ^DIE
 S DR=".25////"_$G(ABMR("DTWR"))
 D ^DIE
 S ABMP("RXDONE")=1
 I $G(ABMRXFLG)=1 D
 .S DR=".26////"_$P($G(^AUPNVMED(ABM,0)),U,8)
 .S DR=DR_";.27////"_$G(ABMR("RTS"))
 .D ^DIE
 S DR="23////"_$G(ABMR("DEA"))  ;abm*2.6*37 IHS/SD/SDR ADO89299
 D ^DIE  ;abm*2.6*37 IHS/SD/SDR ADO89299
 ;start new abm*2.6*37 IHS/SD/SDR ADO89299
PROV ;
 I +$G(ABMR("PROV"))=0 Q  ;no ordering provider
 S ABMT("DIC")=DIC
 K DIC,DIE,DA,X,Y,DR
 S DA(2)=ABMP("CDFN"),DA(1)=ABMT("SV")
 S DIC="^ABMDCLM(DUZ(2),"_DA(2)_",23,"_DA(1)_",""P"","
 S DIC(0)="LM"
 S DIC("P")=$P(^DD(9002274.3023,.18,0),U,2)
 S DIC("DR")=".02////D"
 S X="`"_ABMR("PROV")
 D ^DIC
 K DA
 S DA(1)=ABMP("CDFN")
 S DIC=ABMT("DIC")
 ;end new abm*2.6*37 IHS/SD/SDR ADO89299
 Q
 ;
MED3 ;EP
 ; 4/26/01 - This code is no longer called...  leaving in routine for
 ; version just in case...
 Q:$P($G(^AUTNINS(ABMP("INS"),2)),U,3)="U"
 Q:$D(ABMP("MEDSCHKD"))
 S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_",23,",DIC(0)="LE"
 S ABM("D")=ABMCHVDT-1
 ;ABM("ED") is the discharge date if it exists
 S ABM("ED")=$S($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),6)),U,3):$P(^(6),U,3),1:ABMCHVDT)+.24
 F  S ABM("D")=$O(^PSRX("AD",ABM("D"))) Q:'ABM("D")!(ABM("D")>ABM("ED"))  D
 .S ABM("X")=0 F  S ABM("X")=$O(^PSRX("AD",ABM("D"),ABM("X"))) Q:'ABM("X")  I $P($G(^PSRX(ABM("X"),0)),U,2)=ABMP("PDFN") D MED3CK
 K DIC
 Q
 ;
MED3CK I $D(^PSRX("AD",ABM("D"),ABM("X")))=11 S ABM("REF")=$O(^PSRX("AD",ABM("D"),ABM("X"),""))
 E  S ABM("REF")=""
 S X=$P(^PSRX(ABM("X"),0),U,6),ABM("RX")=$P(^(0),U),ABM("QTY")=$S('+ABM("REF"):$P(^(0),U,7),1:$P($G(^(1,ABM("REF"),0)),U,4))
 S ABMSRC="PSRX|"_ABM("X")_"|RX"
 Q:ABM("QTY")=""
 Q:'$D(^PSDRUG(X,0))
 Q:$P(^PSDRUG(X,0),"^",3)[9   ;OTC DRUG
 S DA=$O(^ABMDCLM(DUZ(2),DA(1),"ASRC",ABMSRC,0))
 I DA,'$D(@(DIC_DA_",0)")) S DA=""          ;For duplicates problem
 I 'DA D
 .S ABMP("MEDSCHKD")=1
 .S DIC("P")=$P(^DD(9002274.3,23,0),U,2)
 .S DIC("DR")=".02////250"
 .K DD,DO D FILE^DICN
 .K DIC("DR")
 .S DA=+Y
 Q:DA<0  S DIE=DIC
 S ABM("SURC")=$S(ABMP("VTYP")'=111:+$P(^ABMDPARM(DUZ(2),1,0),U,3),1:+$P($G(^ABMDPARM(DUZ(2),1,4)),"^",6))
 ;Q:($P($G(^ABMDFEE(ABMP("FEE"),25,X,0)),U,2)&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"))  ;abm*2.6*2 3PMS10003A
 Q:($P($$ONE^ABMFEAPI(ABMP("FEE"),25,X,ABMP("VDT")),U)&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"))  ;abm*2.6*2 3PMS10003A
 ;S ABM("PPDU")=+$P($G(^ABMDFEE(ABMP("FEE"),25,X,0)),"^",2)  ;abm*2.6*2 3PMS10003A
 S ABM("PPDU")=+$P($$ONE^ABMFEAPI(ABMP("FEE"),25,X,ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 S:'ABM("PPDU") ABM("PPDU")=+$P($G(^PSDRUG(X,660)),"^",6)
 K DR
 S DR=".03////"_ABM("QTY")_";.04////"_ABM("PPDU")_";.05////"_ABM("SURC")_";.06////"_ABM("RX")_";.14////"_ABM("TIME")
 ;Next line set correspond diagnosis if only 1 POV
 I $D(ABMP("CORRSDIAG")) S DR=DR_";.13////1"
 S DR=DR_";.17////"_ABMSRC
 D ^DIE
 Q
