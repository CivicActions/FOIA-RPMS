BRAPCC1 ; IHS/ITSC/PDW,CLS - RADIOLOGY PCC LINK ; 06 Dec 2016  8:19 AM
 ;;5.0;Radiology/Nuclear Medicine;**1009**;Mar 16, 1998;Build 21
 ; 20220414 cmi/maw - split BRAPCC due to size
 ;
 Q
 ;
MRG ;PEP >> PRIVATE ENTRY POINT between RA and PCC
 ;IHS/CMI/LAB PATCH 1009 04/12/21 CR 10047, FIX VISIT IEN IF VISIT MERGED
 ;This routine is called by the PCC Visit Merge Utility.
 ;The input variables are:  APCDVMF - Merge from visit ifn
 ;                          APCDVMT - Merge to visit ifn
 ;
 ;This routine finds the patient involved, scans for this merged visit
 ;among the occurrences for this patient, and updates the visit.
 ;
 N DIE,DA,DR,BRAP,X,Y,BRAI,BRAD,RAFDA
 Q:'$D(APCDVMF)  Q:'$D(APCDVMT)
 I '$D(^AUPNVSIT(APCDVMF,0)) Q
 I '$D(^AUPNVSIT(APCDVMT,0)) Q
 S BRAP=$P(^AUPNVSIT(APCDVMT,0),U,5)  ;PATIENT DFN
 I 'BRAP Q
 ;loop through this patient's exam and look for APCDVMF, if it is there change to APCDVMT
 S BRAD=0 F  S BRAD=$O(^RADPT(BRAP,"DT",BRAD)) Q:BRAD'=+BRAD  D
 .S BRAI=0 F  S BRAI=$O(^RADPT(BRAP,"DT",BRAD,"P",BRAI)) Q:BRAI'=+BRAI  D
 ..S BRAV=$P($G(^RADPT(BRAP,"DT",BRAD,"P",BRAI,"PCC")),U,3)
 ..I BRAV=APCDVMF D
 ...S RAFDA($J,70.03,""_BRAI_","_BRAD_","_BRAP_",",197)=APCDVMT
 ...D FILE^DIE("E","RAFDA($J)","RAFDA($J,""ERR"")")
 ;
 Q
EDITEX ;EP - CALLED TO UPDATE PCC WHEN AN EXAM IS EDITED
 D EDITEX1
 Q
EDITEX1 ;EP - CALLED TO UPDATE PCC WHEN AN EXAM IS EDITED
 NEW PCCVRAD,PCCVSIT,C,APCDALVR,AUPNVSIT
 I '$G(RADFN) Q
 I '$G(RADTI) Q
 I '$G(RACNI) Q
 ;get v rad ien, if none quit
 S PCCVRAD=$P($G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"PCC")),U,2)
 I 'PCCVRAD Q    ;NO VRAD ENTRY TO EDIT
 I '$D(^AUPNVRAD(PCCVRAD,0)) Q  ;SOMEBODY DELETED THE V RAD
 ;FIRST UPDATE CPT AND PROC MODIFIERS
 S RAXM=RACNI
 D EN^BRAPCC2
 ;now check clinic and change in visit and 1213 IF visit created by an RA Option
 S PCCVSIT=$P(^AUPNVRAD(PCCVRAD,0),U,3)  ;$P($G(^RADPT(RADFN,"DT",RADTI,"P",RAXM,"PCC")),U,3)
 I 'PCCVSIT Q
 I $E($$VAL^XBDIQ1(9000010,PCCVSIT,.24),1,2)'="RA" Q  ;MUST HAVE BEEN CREATED BY RADIOLOGY
 K APCDALVR
 ;---> CATEGORY
 S X=$S($P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),U,4)="I":"I",1:"A")
 ;
 ;IHS/ANMC/LJF 11/28/2001 if observation patient use A (PIMS v5.3)
 I X="I" D
 .NEW DAT,CA S DAT=9999999.9999-RADTI  ;convert date
 .S CA=$$INPT1^BDGF1(RADFN,DAT)  ;admission ien
 .I CA,$$GET1^DIQ(405,+$$PRIORTXN^BDGF1(DAT,CA,RADFN),.09)["OBSERVATION" S X="A"
 .;IHS/ANMC/LJF 11/28/2001 end of new code
 S APCDALVR("APCDCAT")=X K X
 ;
 D CLINIC
 I $G(APCDALVR("APCDCLN"))="" K APCDALVR Q
 S C=$P(APCDALVR("APCDCLN"),"`",2)
 I C=$$VALI^XBDIQ1(9000010,PCCVSIT,.08) Q  ;did not change
 ;UPDATE V RAD 1203/1218
 K DIE,DA,DR,DQ,DO
 S DIE="^AUPNVRAD(",DA=PCCVRAD,DR="1203///"_APCDALVR("APCDCLN")_";1218////"_$$NOW^XLFDT
 L +^AUPNVRAD(PCCVRAD):0 I '$T Q
 D ^DIE
 L -^AUPNVRAD(PCCVRAD)
 K DIR,DIE,DA,DR,DQ,DO
 ;
 ;UPDATE VISIT .08
 I $P($G(^AUPNVSIT(PCCVSIT,0)),U,11)   ;VISIT HAS BEEN DELETED??
 K DIE,DA,DR,DQ,DO
 S DIE="^AUPNVSIT(",DA=PCCVSIT,DR=".08///"_APCDALVR("APCDCLN")
 L +^AUPNVSIT(PCCVSIT):0 I '$T Q
 D ^DIE
 L -^AUPNVSIT(PCCVSIT)
 K DIR,DIE,DA,DR,DQ,DO
 ;
 S AUPNVSIT=PCCVSIT
 I +AUPNVSIT D MOD^AUPNVSIT
 K AUPNVSIT
 Q
 ;
CLINIC ;
 ; Identify radiology clinic rather than stuff a value
 ;IHS/HQW/PMF - 05/30/01 **8**
 ;
 ;retrieve the clinic number
 N RACLINIC
 ;first get the hospital location pointer from the rad patient file
 S RACLINIC=$P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),U,8)
 ;if that pointer is not null, get the stop code number from the
 ;hospital location file, if it's there.
 ;if not there, clinic will be null
 I RACLINIC'="" S RACLINIC=$P($G(^SC(+RACLINIC,0)),U,7)
 ;
 ;if we got one, set the arrays and stop.
 ;
 I RACLINIC S (APCDALVR("APCDTCLN"),APCDALVR("APCDCLN"))="`"_RACLINIC Q
 ;
 ;if that didn't work, and this is NOT a category A, stop
 ;
 I APCDALVR("APCDCAT")'="A" Q
 ;if we got this far, use the ein of the Radiology clinic stop
 S RACLINIC=$O(^DIC(40.7,"B","RADIOLOGY",""))
 I RACLINIC S (APCDALVR("APCDTCLN"),APCDALVR("APCDCLN"))="`"_RACLINIC
 Q
 ;End changes to identify correct clinic -IHS/HWQ/PWF -05/30/01 **8**
 ;
