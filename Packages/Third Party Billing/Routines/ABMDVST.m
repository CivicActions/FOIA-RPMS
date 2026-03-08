ABMDVST ; IHS/ASDST/DMJ - PCC Visit Stuff ;     
 ;;2.6;IHS 3P BILLING SYSTEM;**10,19,22,35,36,38,40**;NOV 12, 2009;Build 785
 ;Original;TMD;08/19/96 4:45 PM
 ;
 ;IHS/SD/SDR 2.5*8 IM12246/IM17548 Added code to put defaults on claim for CLIAs
 ;IHS/SD/SDR 2.5*8 task 8 Added tag for insurer replace and splitting routine
 ;IHS/SD/SDR 2.5*10 IM19717/IM20374 Added to check for when to merge visits into one claim
 ;IHS/SD/SDR 2.5*10 IM20610 Fix Medicare Part B check so only one claim will generate
 ;IHS/SD/SDR 2.5*10 task order item 1 Calls for ChargeMaster added to national code.  Calls were supplied by Lori Butcher
 ;IHS/SD/SDR 2.5*10 IM21500 Added code to check new V Med field POINT OF SALE BILLING STATUS
 ;    and only generate claim if at least one med wasn't billed by POS or was billed and rejected
 ;
 ;IHS/SD/SDR 2.6*19 HEAT251217 Made change to populate SERVICE DATE FROM and SERVICE DATE TO all the time.
 ;IHS/SD/SDR 2.6*22 HEAT335246 Added call to claim splitter
 ;IHS/SD/SDR 2.6*35 ADO60700 Added counter for how many claims a visit generates
 ;IHS/SD/SDR 2.6*36 ADO76247 Smarten up BILLED POS check to still generate claim if other charges besides RX or RX rejected in POS
 ;IHS/SD/SDR 2.6*38 ADO97221 Check V Lab file for entries so a claim will generate if there are just labs on a visit; between p36
 ;   and now it was skipping lab only visits (no claim created); Also updated check for BILLED POS to make sure there were meds
 ;   on visit
 ;IHS/SD/SDR 2.6*40 ADO111599 Added VA Contract# to claim if VA MEDICAL BENEFIT (VMBP) is an insurer on claim
 ;**********************
VAR ;
 N ABMSRC,DA,DIE,DIK
 K ABMP("DUP"),ABMP("NEWBORN")
 I '$D(ABMP("VTYP")) D
 .S ABMP("VTYP")=$$VTYP^ABMDVCK1(ABMVDFN,SERVCAT,ABMP("INS"),ABMP("CLN"))
 I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,7)="N" D  Q
 .S DIE="^AUPNVSIT("
 .S DA=ABMVDFN
 .S DR=".04////22"
 .D ^DIE
 .D VISIT^ABMCGAPI(ABMVDFN,ABMCGIEN,22)  ;abm*2.6*35 IHS/SD/SDR ADO60700
 ;Find new Claim ien if ien null
 ;Not sure what will happen here if the claim is a split claim.
 ;Clearly only one claim will be updated.
 I '$G(ABMP("CDFN")) S ABMP("CDFN")=$O(^ABMDCLM(DUZ(2),"AV",ABMVDFN,""))
 I ABMP("CDFN")<1 S ABM=0 F  S ABM=$O(^ABMDCLM(DUZ(2),"B",ABMP("PDFN"),ABM)) Q:'ABM  D  Q:ABMP("CDFN")
 .I '$D(^ABMDCLM(DUZ(2),ABM,0)) K ^ABMDCLM(DUZ(2),"B",ABMP("PDFN"),ABM) Q
 .Q:$P($G(^ABMDCLM(DUZ(2),ABM,0)),U,2)'=ABMP("VDT")  ;encounter(visit) date
 .Q:$P($G(^ABMDCLM(DUZ(2),ABM,0)),U,3)'=ABMP("LDFN")  ;visit location
 .Q:$P($G(^ABMDCLM(DUZ(2),ABM,0)),U,7)'=ABMP("VTYP")  ;visit type
 .Q:$P($G(^ABMDCLM(DUZ(2),ABM,0)),U,6)'=ABMP("CLN")  ;clinic
 .D GETPPRV  ;get primary provider
 .D GETPPOV  ;find primary DX
 .I ABMVPRV'=0,(ABMCPRV=ABMVPRV),(ABMVICD'=0),(ABMCICD=ABMVICD) S ABMP("CDFN")=ABM
 I ABMARPS,ABMP("CDFN")<1 D  Q:$G(ABMP("NOKILLABILL"))=2
 .S ABMP("CDFN")=$O(^ABMDCLM(ABMP("LDFN"),"AV",ABMVDFN,""))
 .I ABMP("CDFN"),'$D(^ABMDCLM(ABMP("LDFN"),ABMP("CDFN"),0)) D
 ..K ^ABMDCLM(ABMP("LDFN"),"AV",ABMVDFN,ABMP("CDFN"))
 ..S ABMP("CDFN")=0
 .Q:ABMP("CDFN")<1
 .S ABMP("NOKILLABILL")=2
 G NEW:ABMP("CDFN")<1
 Q:$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0))=""
 ;25= Existing claim modified
 N R
 S R=$P(^AUPNVSIT(ABMVDFN,0),U,4)
 I R'=24!((R=24)&('$D(ABMNFLG))),R'=25 D
 .S DIE="^AUPNVSIT("
 .S DA=ABMVDFN
 .S DR=".04////25"
 .D ^DIE
 .D VISIT^ABMCGAPI(ABMVDFN,ABMCGIEN,25)  ;abm*2.6*35 IHS/SD/SDR ADO60700
 L +^ABMDCLM(DUZ(2),ABMP("CDFN")):10 E  S ABMP("LOCKFAIL")=1 Q
 S DR=""
 S Y=^ABMDCLM(DUZ(2),ABMP("CDFN"),0)
 I $P(Y,U,10)'=DT D
 .S DR=".1////"_DT
 I $P(Y,U,2)'=ABMP("VDT") D
 .S DR=".02////"_ABMP("VDT")_$S(DR]"":";"_DR,1:"")
 S DR=$S(DR]"":DR_";",1:"")_".06////"_ABMP("CLN")
 I $P(Y,U,7)'=ABMP("VTYP"),$D(ABMP("PRIMVSIT")) D
 .S DR=$S(DR]"":DR_";",1:"")_".07////"_ABMP("VTYP")
 ;The following works because the only way that 97 will be the value is
 ;if the primary insurer is billed elswhere (e.g. Data Center)
 I ABMP("PRI")=97 S DR=$S(DR]"":DR_";",1:"")_".04////U;.08////"_ABMP("INS")
 ;The next line checks the active insurer field.  If it is null & the
 ;insurer in ABMP("INS") is the primary insurer set and the mode of 
 ;export
 I $P(Y,U,8)="",DR'[".08",'$O(ABML(ABMP("PRI")),-1),$O(ABML(ABMP("PRI"),""))=ABMP("INS") D
 .N ABMMODE
 .S ABMMODE=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,4)
 .S DR=$S(DR]"":DR_";",1:"")_".08////"_ABMP("INS")_$S(ABMMODE:";.14///"_ABMMODE,1:"")
 I DR]"" D
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DA=ABMP("CDFN")
 .D ^DIE
 D VSIT
 D FRATE
 D OTHER
 ;if routine BCMZINHO exists and there are tran codes in the table run BCMZINHO
 I $T(^BCMZINHO)]"",$O(^BCMTCA(0)) D:$D(^AUPNVSIT("AD",ABMVDFN)) ^BCMZINHO  ;IHS/CMI/LAB-chargemaster call
 I $O(^ABMDBILL(DUZ(2),"AV",ABMVDFN,0)),$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,4)'="U" D  Q:ABM("OUT")
 .S ABM("OUT")=1
 .Q:$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"B",ABMP("INS")))
 .S DA=$O(^ABMDBILL(DUZ(2),"AV",ABMVDFN,0))
 .S ABM=$P($G(^ABMDBILL(DUZ(2),DA,0)),U,8)   ; Active Insurer
 .Q:'ABM
 .;I $P($G(^AUTNINS(ABM,2)),U)="I" D   ;Type of ins = Indian Pat  ;abm*2.6*10 HEAT73780
 .I $$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABM,".211","I"),1,"I")="I" D   ;Type of ins = Indian Pat  ;abm*2.6*10 HEAT73780
 ..S ABM("OUT")=0
 ..S DIE="^ABMDBILL(DUZ(2),"
 ..S DR=".04////X"                           ;Mark bill as cancelled
 ..D ^ABMDDIE
 ..S DIE="^ABMDCLM(DUZ(2),"
 ..S DA=ABMP("CDFN")
 ..S DR=".04////F;.08////"_ABMP("INS")
 ..D ^ABMDDIE
 I $D(^ABMDBILL(DUZ(2),"AS",ABMP("CDFN"))) Q
 Q
 ;
 ;*********************
NEW ;CREATE NEW CLAIM
 S ABMVCC=0  ;abm*2.6*35 IHS/SD/SDR ADO60700
 I $D(^ABMDBILL(DUZ(2),"AV",ABMVDFN)) D  Q
 .S DIE="^AUPNVSIT("
 .S DA=ABMVDFN
 .S DR=".04////20"
 .D ^DIE
 .D VISIT^ABMCGAPI(ABMVDFN,ABMCGIEN,20)  ;abm*2.6*35 IHS/SD/SDR ADO60700
 ;BILLED POS insurer?
 ;start old abm*2.6*38 IHS/SD/SDR ADO97221
 ;I $P($G(^AUTNINS(ABMP("INS"),2)),U,3)="P" D
 ;.S ABMVMIEN=0
 ;.;start old abm*2.6*36 IHS/SD/SDR ADO76247
 ;.;F  S ABMVMIEN=$O(^AUPNVMED("AD",ABMVDFN,ABMVMIEN)) Q:+ABMVMIEN=0  D  Q:$G(ABMPSFLG)=1
 ;.;.I $P($G(^AUPNVMED(ABMVMIEN,11)),U,6)'=1 S ABMPSFLG=1
 ;.;end old start new abm*2.6*36 IHS/SD/SDR ADO76247
 ;.S ABMPSFLG=1
 ;.S ABMVMC=0  ;abm*2.6*38 IHS/SD/SDR ADO97221
 ;.F  S ABMVMIEN=$O(^AUPNVMED("AD",ABMVDFN,ABMVMIEN)) Q:+ABMVMIEN=0  D  Q:$G(ABMPSFLG)=0  ;there's still an RX to bill
 ;..S ABMVMC=ABMVMC+1  ;abm*2.6*38 IHS/SD/SDR ADO97221
 ;..I $P($G(^AUPNVMED(ABMVMIEN,11)),U,6)="" S ABMPSFLG=0  ;POINT OF SALE BILLING STATUS is blank so we should try billing it
 ;S X=$$CPT^AUPNCPT(ABMVDFN)
 ;I +$O(AUPNCPT(0))'=0 S ABMPSFLG=0
 ;I +$O(^AUPNVDEN("AD",ABMVDFN,0))'=0 S ABMPSFLG=0
 ;end old abm*2.6*38 IHS/SD/SDR ADO97221
 ;end new abm*2.6*36 IHS/SD/SDR ADO76247
 ;I $D(^AUPNVMED("AD",ABMVDFN)),$P($G(^AUTNINS(ABMP("INS"),2)),U,3)="P",($G(ABMPSFLG)'=1) D  Q  ;abm*2.6*36 IHS/SD/SDR ADO76247
 ;if active insurer RX BILLING STATUS is 'P' for 'BILLED POINT OF SALE' and there's only meds that were all billed POS
 ;I ($P($G(^AUTNINS(ABMP("INS"),2)),U,3)="P")&($G(ABMPSFLG)=1) D  Q  ;abm*2.6*36 IHS/SD/SDR ADO76247  ;abm*2.6*38 IHS/SD/SDR ADO97221
 ;.K ABMPSFLG  ;abm*2.6*38 IHS/SD/SDR ADO97221
 ;.D PCFL^ABMDVCK(62)  ;billed POS  ;abm*2.6*38 IHS/SD/SDR ADO97221
 ;start new abm*2.6*38 IHS/SD/SDR ADO97221
 D START^ABMDVSTA
 I ABMPSFLG=0 D PCFL^ABMDVCK(61) Q  ;Inpatient CODING COMPLETE is NO, meaning it is not complete
 I (+$G(ABMHIEN)=0) I (($P($G(^AUTNINS(ABMP("INS"),2)),U,3)="P")&(ABMVMC>0)&(ABMLF=0)&(ABMCF=0)&(ABMDF=0)&(ABMTF=0)) D PCFL^ABMDVCK(62) Q  ;if BILLED POS and only meds
 I (+$G(ABMHIEN)=0) I ((ABMMF=0)&(ABMLF=0)&(ABMCF=0)&(ABMDF=0)&(ABMTF=0)) D PCFL^ABMDVCK(16) Q  ;there are no billable charges
 ;end new abm*2.6*38 IHS/SD/SDR ADO97221
 S DINUM=$$NXNM^ABMDUTL
 I DINUM="" S ABMP("NOKILLABILL")=1 Q
 K DIC
 S DIC="^ABMDCLM(DUZ(2),"
 S DIC(0)="L"
 S X=ABMP("PDFN")
 K DD,DO
 D FILE^DICN
 I Y<1 S ABMP("NOKILLABILL")=1 Q
 S ABMP("CDFN")=+Y
 L +^ABMDCLM(DUZ(2),+Y):1 E  S ABMP("LOCKFAIL")=1 Q
 S ABMVCC=$S(+$G(ABMVCC)'=0:+$G(ABMVCC)_"/",1:"")_+$G(ABMP("CDFN"))  ;abm*2.6*35 IHS/SD/SDR ADO60700
 S DA=+Y
 S DIE=DIC
 S DR=".02////"_$P($P(ABMP("V0"),U),".")_";.03////"_ABMP("LDFN")
 S DR=DR_";.04////"_"F"_";.06////"_ABMP("CLN")_";.07////"_ABMP("VTYP")
 ;No active insurer if one insurer billed elsewhere
 I '$D(ABML(97)) S DR=DR_";.08////"_ABMP("INS")
 S DR=DR_";.1////"_DT_";.17////"_DT
 S DR=DR_";.71////"_$P($P(ABMP("V0"),U),".")_";.72////"_$P($P(ABMP("V0"),U),".")  ;abm*2.6*19 IHS/SD/SDR HEAT251217
 D ^DIE
 S DIE="^AUPNVSIT("
 S DA=ABMVDFN
 S DR=".04////24"
 D ^DIE
 D VISIT^ABMCGAPI(ABMVDFN,ABMCGIEN,24)  ;abm*2.6*35 IHS/SD/SDR ADO60700
 D VSIT
 S ABMNFLG=1
 D FRATE
 D OTHER
 ;
 ;start new abm*2.6*40 IHS/SD/SDR ADO111599
 K ABMVAFLG
 S ABMT("I")=0
 F  S ABMT("I")=$O(ABML(ABMT("I"))) Q:'ABMT("I")  D
 .Q:(ABMT("I")>97)
 .S ABMT("IN")=$O(ABML(ABMT("I"),0))
 .I $P($G(^AUTNINS(ABMT("IN"),0)),U)="VA MEDICAL BENEFIT (VMBP)" S ABMVAFLG=1
 I $G(ABMVAFLG)=1 D
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DA=ABMP("CDFN")
 .S DR="927////"_$P($G(^ABMDPARM(DUZ(2),1,3)),U,13)  ;SITM VA CONTRACT#
 .D ^DIE
 ;end new abm*2.6*40 IHS/SD/SDR ADO111599
 ;
 ;if routine BCMZINHO exists and there are tran codes in the table run BCMZINHO
 I $T(^BCMZINHO)]"",$O(^BCMTCA(0)) D:$D(^AUPNVSIT("AD",ABMVDFN)) ^BCMZINHO  ;IHS/CMI/LAB-chargemaster call
 K X,Y
 D ^ABMPSPLT  ;abm*2.6*22 IHS/SD/SDR HEAT335246
 D MAIN^ABMASPLT(ABMP("CDFN"))
 ;I $P($G(^AUTNINS(+ABMP("INS"),2)),U)="R" D  ;abm*2.6*10 HEAT73780
 I $$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,+ABMP("INS"),".211","I"),1,"I")="R" D  ;abm*2.6*10 HEAT73780
 .S ABMBONLY=$S($P($G(^ABMDPARM(ABMP("LDFN"),1,5)),U)'="":$P(^ABMDPARM(ABMP("LDFN"),1,5),U),1:2)
 .I (ABMBONLY'=2) Q
 .D MAIN^ABMDSPLB(ABMP("CDFN"))
 D CLAIM^ABMCGAPI(ABMCGVI,ABMCGIEN,ABMVCC,+ABMP("INS"))  ;abm*2.6*35 IHS/SD/SDR ADO60700
 Q
 ;
 ;*******************************
VSIT ;
 S DA(1)=ABMP("CDFN")
 S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",11,"
 S DIC(0)="LE"
 I $D(@(DIC_ABMVDFN_")")),'$D(ABMP("PRIMVSIT")) Q
 ;This section needs to be done for non-new claims
 ;Direct set into the claim file
 S DIC("P")=$P(^DD(9002274.3,11,0),U,2)
 K DD,DO,DR,DIC("DR")
 I $D(ABMP("PRIMVSIT")) S DIC("DR")=".02////P"
 S (X,DINUM)=ABMVDFN
 I '$D(@(DIC_ABMVDFN_")")) D
 .D FILE^DICN
 E  D
 .S DIE=DIC
 .S DR=DIC("DR")
 .S DA=DINUM
 .D ^DIE
 .K DIE,DR,DINUM
 K DIC
 Q
 ;
 ;***************************
FRATE ;
 ;I need code to prevent 2nd visit on claim from undoing eligibility
 N V,INSADD,INSSKIP
 S V=0
 F  S V=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,V)) Q:'V  D  Q:$D(INSADD)
 .I V'=ABMVDFN,$D(^TMP($J,"PROC",V)) D
 ..S IEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"B",ABMP("INS"),""))
 ..I 'IEN S INSADD="" Q
 ..I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,IEN,0),U,3)?1(1"P",1"I"),ABMP("PRI")>96 S INSSKIP=""
 I '$D(INSSKIP),$D(ABMP("OPONADMIT")) D
 .Q:$P(ABML(ABMP("PRI"),ABMP("INS")),U,3)'?1(1"M",1"R")
 .Q:ABMP("PRI")<97
 .;If the patient has B but not A don't skip.
 .I $G(ABML(ABMP("PRI"),ABMP("INS"),"COV",+$O(ABML(ABMP("PRI"),ABMP("INS"),"COV",""))))="B" Q
 . I $P(ABML(ABMP("PRI"),ABMP("INS")),U,6)=44 S INSSKIP=""
 I '$D(INSSKIP) D ADDCHK^ABMDE2E
 S ABMP("C0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),0)
 S ABMX("INS")=ABMP("INS")
 D:'$D(ABMP("BTYP")) BTYP^ABMDEVAR
 D FRATE^ABMDE2X1
 D EXP^ABMDE2X5
 I ABMP("EXP")=22!(ABMP("EXP")=23)!(ABMP("EXP")=3)!(ABMP("EXP")=14)!(ABMP("EXP")=25) D
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DA=ABMP("CDFN")
 .S DR=".922////"_$P($G(^ABMDPARM(ABMP("LDFN"),1,4)),U,11)
 .S DR=DR_";.923///"_$P($G(^ABMDPARM(ABMP("LDFN"),1,4)),U,12)
 .D ^DIE
 K ABMV,ABMX
 Q
 ;
OTHER ;RUN OTHER STUFFING ROUTINES
 ;ABMDVST1 - Purpose of visit
 ;ABMDVST2 - Provider
 ;ABMDVST3 - ICD Procedure
 ;ABMDVST4 - Hospitalization
 ;ABMDVST5 - Pharmacy
 ;ABMDVST6 - Dental
 ;ABMDVST7 - Not used
 ;ABMDVST8 - Not used    
 ;ABMDVST9 - IV Pharmacy
 ;ABMDVS10 - Not used 
 ;ABMDVS11 - Lab
 ;ABMDVS12 - Not used        
 ;ABMDVS13 - CPT CODES
 S ABMACTVI=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,8)
 I ABMACTVI="" S ABMACTVI=ABMP("INS")
 K ABM("DONE")
 F ABM("COUNTER")=1:1 D  Q:$G(ABM("DONE"))
 .S ABM("ROUTINE")=$S(ABM("COUNTER")<10:"ABMDVST"_ABM("COUNTER"),1:"ABMDVS"_ABM("COUNTER"))
 .Q:(ABM("COUNTER")<5!(ABM("COUNTER")>6))&(ABMACTVI'=ABMP("INS"))&(ABM("COUNTER")<14)
 .S X=ABM("ROUTINE")
 .X ^%ZOSF("TEST") E  S:ABM("COUNTER")>13 ABM("DONE")=1 Q
 .I  D @("^"_ABM("ROUTINE"))
 I ABMACTVI=ABMP("INS") S ABMIDONE=1
 I $T(^BCMDVS01)]"",$O(^BCMTCA(0)) D ^BCMDVS01  ;IHS/CMI/LAB-chargemaster call
 Q
GETPPRV ;
 ;get attending/operating provider from claim
 S ABMCPRV=+$O(^ABMDCLM(DUZ(2),ABM,41,"C","A",0))
 S:ABMCPRV=0 ABMCPRV=+$O(^ABMDCLM(DUZ(2),ABM,41,"C","O",0))
 I ABMCPRV'=0 S ABMCPRV=$P($G(^ABMDCLM(DUZ(2),ABM,41,ABMCPRV,0)),U)
 ;get provider from visit
 S ABMV=0
 F  S ABMV=$O(^AUPNVPRV("AD",ABMVDFN,ABMV)) Q:+ABMV=0  D  Q:+$G(ABMVPRV)'=0
 .Q:$P($G(^AUPNVPRV(ABMV,0)),U,4)'="P"
 .S ABMVPRV=$P($G(^AUPNVPRV(ABMV,0)),U)
 I $G(ABMVPRV)="" S ABMVPRV=0
 Q
GETPPOV ;
 ;get Primary/first entry from claim
 S ABMCICD=+$O(^ABMDCLM(DUZ(2),ABM,17,0))
 ;get Primary or first entry from claim
 S ABMV=0
 K ABMVFST
 S ABMVFST=""
 F  S ABMV=$O(^AUPNVPOV("AD",ABMVDFN,ABMV)) Q:+ABMV=0  D  Q:+$G(ABMVICD)'=0
 .I $G(ABMVFST)="" S ABMVFST=$P($G(^AUPNVPOV(ABMV,0)),U)
 .Q:$P($G(^AUPNVPOV(ABMV,0)),U,12)'="P"
 .S ABMVICD=$P($G(^AUPNVPOV(ABMV,0)),U)
 I +$G(ABMVICD)=0 S ABMVICD=ABMVFST
 Q
