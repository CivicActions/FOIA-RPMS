ABMPSAD3 ; IHS/SD/SDR - Add Pharmacy POS COB Bill Manually ; 
 ;;2.6;IHS Third Party Billing System;*36**;NOV 12, 2009;Build 698
 ;
 ;IHS/SD/SDR 2.6*36 ADO76247 New routine; create a manual COB bill for Pharmacy POS claims - create new bill
 Q
 ;
 ;*******************************
FILE ;
 W !!,"Transferring Data...."
 M ^ABMDBILL(DUZ(2),ABMP("BDFN"),0)=^ABMDBILL(DUZ(2),ABMP("OBDFN"),0)
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U)=$P(Y,U,2)  ;bill number
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,6)=ABMDATA("EXP")  ;export mode
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,7)=ABMDATA("VT")  ;visit type
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,8)=ABMDATA("INS")  ;active insurer
 ;
 M ^ABMDBILL(DUZ(2),ABMP("BDFN"),1)=^ABMDBILL(DUZ(2),ABMP("OBDFN"),1)
 D NOW^%DTC
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,4)=DUZ  ;approving official
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,5)=%  ;Date/Time approved = now
 ;
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),2),U)=ABMDATA("CBAMT")
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),2),U,2)=ABMDATA("ITYP")
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),2),U,3)=ABMDATA("CBAMT")
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),2),U,7)=$S((+$P($G(^ABMDBILL(DUZ(2),ABMP("OBDFN"),2)),U,7)'=0):$P($G(^ABMDBILL(DUZ(2),ABMP("OBDFN"),2)),U,7),1:$P($G(^ABMDBILL(DUZ(2),ABMP("OBDFN"),2)),U))  ;original bill amount
 ;
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),4),U,9)=ABMDATA("RESUB")
 ;
 M ^ABMDBILL(DUZ(2),ABMP("BDFN"),7)=^ABMDBILL(DUZ(2),ABMP("OBDFN"),7)
 ;
 M ^ABMDBILL(DUZ(2),ABMP("BDFN"),13)=^ABMDBILL(DUZ(2),ABMP("OBDFN"),13)
 S ABMI=($O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,999),-1))
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMI,0),U,3)="C"
 S ABMI=ABMI+1
 S ABMIREC=ABMDATA("INS")_U_ABMDATA("IPRI")_U_"I"
 S ABMA=0
 F  S ABMA=$O(ABML(ABMA)) Q:'ABMA  D
 .Q:'$D(ABML(ABMA,ABMDATA("INS")))
 .I $P(ABML(ABMA,ABMDATA("INS")),U,3)="P" S $P(ABMIREC,U,8)=$P(ABML(ABMA,ABMDATA("INS")),U,4)
 .I ($P(ABML(ABMA,ABMDATA("INS")),U,3)="M")!($P(ABML(ABMA,ABMDATA("INS")),U,3)="R") S $P(ABMIREC,U,4)=$P(ABML(ABMA,ABMDATA("INS")),U,4)
 .I $P(ABML(ABMA,ABMDATA("INS")),U,3)="D" S $P(ABMIREC,U,6)=$P(ABML(ABMA,ABMDATA("INS")),U,4),$P(ABMIREC,U,7)=$P(ABML(ABMA,ABMDATA("INS")),U,5)
 S ^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMI,0)=ABMIREC
 ;
 S ABMA=0
 F  S ABMA=$O(ABMDATA("DX",ABMA)) Q:'ABMA  D
 .S ^ABMDBILL(DUZ(2),ABMP("BDFN"),17,$G(ABMDATA("DX",ABMA)),0)=$G(ABMDATA("DX",ABMA))_U_ABMA_"^^^^1"
 ;
 M ^ABMDBILL(DUZ(2),ABMP("BDFN"),23)=^ABMDBILL(DUZ(2),ABMP("OBDFN"),23)
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,1,0),U,2)=ABMDATA("SL",.02)  ;rev code
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,1,0),U,3)=ABMDATA("SL",.03)  ;units
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,1,0),U,4)=ABMDATA("SL",.04)  ;unit cost
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,1,0),U,5)=ABMDATA("SL",.05)  ;dispensing fee
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,1,0),U,6)=ABMDATA("OTHBILLID")  ;RX# for other bill identifier
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,1,0),U,14)=ABMDATA("SL",.14)  ;service dt
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,1,0),U,19)=ABMDATA("SL",.19)  ;new/refill code
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,1,0),U,20)=ABMDATA("SL",.2)  ;days supply
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,1,0),U,24)=ABMDATA("SL",.24)  ;NDC
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),23,1,0),U,29)=ABMDATA("SL",.29)  ;CPT
 ;
 ;line item control number
 K DIC,DIE,DA,DR,X,Y
 S ABMBN=$$FMT^ABMERUTL(ABMP("BDFN"),"12NR")
 S ABMLNNUM=1
 S DA(1)=ABMP("BDFN")
 S ABMLNNUM=$$FMT^ABMERUTL(1,"4NR")
 S DA=1
 S ABMI=23
 S DIE="^ABMDBILL("_DUZ(2)_","_DA(1)_","_ABMI_","
 S DR="21////"_ABMBN_ABMI_ABMLNNUM
 D ^DIE
 ;
 M ^ABMDBILL(DUZ(2),ABMP("BDFN"),41)=^ABMDBILL(DUZ(2),ABMP("OBDFN"),41)
 ;
 S DIK="^ABMDBILL(DUZ(2),"
 S DA=ABMP("BDFN")
 D IX^DIK
 ;
 S ABMAPOK=1  ;Pass 3PB to A/R
 ;This DIE call needs to be done last.  It's the x-ref on this field that creates the bill in A/R from 3PB. It also defines the A/R
 ;location field on the 3P bill [DUZ(2),DA].
 K DIE,DA,DR
 S DIE="^ABMDBILL(DUZ(2),"
 S DA=ABMP("BDFN")
 S DR=".04////A"  ;Set bill status to A for approved
 D ^DIE
 ;
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=1 D ADDBENTR^ABMUCUTL("ABILL",ABMP("BDFN"))  ;add bill to UFMS Cashiering session
 D MSG^ABMERUTL("Bill Number "_$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U)_" Created.  (Export Mode: "_$P(^ABMDEXP(ABMDATA("EXP"),0),U)_")")
 ;
 K ABMDUZ2,ABMARPS,ABMHOLD,ABMAPOK,ABMBILL,ABMFLD,ABMULT,ABMPOS
 K DINUM,DIC,DA,DIE,X,Y,DD,DO,DLAYGO
 Q
