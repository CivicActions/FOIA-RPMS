ABMP2631 ; IHS/SD/SDR - 3P BILLING 2.6 Patch 31 POST INIT ;  
 ;;2.6;IHS Third Party Billing;**31**;NOV 12, 2009;Build 615
 Q
POST ;
 D FTFIX
 D CORRACT
 D ECODES
 D QUESFIX
 D PENDDT
 D NEWWARN
 ;
 Q
 ;
FTFIX ; fix for <UNDEF>S+15^DIC3 in VWFE for CR11077
 ;fix fee table entries that are missing the subfile 0 node; occurs when the 'G' code wasn't included in the imported fee table for a CPT
 ;example:
 ; ^ABMDFEE(1,19,0)="^9002274.0119P^^"
 ; ^ABMDFEE(1,19,99214,1,0)="^9002274.1191DAI^1^1"
 ; ^ABMDFEE(1,19,99214,1,1,0)="3200101^444^123^321^3200106^1941"
 ; ^ABMDFEE(1,19,99214,1,"B",3200101,1)=""
 S ABMFT=0
 F  S ABMFT=$O(^ABMDFEE(ABMFT)) Q:'ABMFT  D
 .S ABMMLT=0
 .F  S ABMMLT=$O(^ABMDFEE(ABMFT,ABMMLT)) Q:'ABMMLT  D
 ..S ABMCPT=0
 ..F  S ABMCPT=$O(^ABMDFEE(ABMFT,ABMMLT,ABMCPT))  Q:'ABMCPT  D
 ...I +$G(^ABMDFEE(ABMFT,ABMMLT,ABMCPT,0))=0 S ^ABMDFEE(ABMFT,ABMMLT,ABMCPT,0)=ABMCPT
 Q
CORRACT ; Update CORRECTIVE ACTION on claim editor errors 17, 18 and 21 CR10044
 D ^XBFMK
 S DIE="^ABMDERR("
 F DA=17,18,21 D
 .I DA=17 S DR=".02////[J]ump to either Questions Page (3) or Inpatient Data Page (7) and [E]dit the Admission Type field so that it is specified."
 .I DA=18 S DR=".02////[J]ump to either Questions Page (3) or Inpatient Data Page (7) and [E]dit the Admission Source field so that it is specified."
 .I DA=21 S DR=".02////[J]ump to either Questions Page (3) or Inpatient Data Page (7) and [E]dit the Discharge Status field so that it is specified."
 .D ^DIE
 Q
 ;
QUESFIX ;CR8881 - move EDIT ROUTINE for questions 24-43 due to spliting routine
 D ^XBFMK
 S DIE="^ABMQUES("
 S DR="1////ABMDE3D"
 F DA=24:1:43 D ^DIE
 ;
 D ^XBFMK
 S DIK="^ABMQUES("
 S DA=44
 D ^DIK
 ;
 S ABMI=0
 F  S ABMI=$O(^ABMDEXP(ABMI)) Q:'ABMI  D
 .S ABMQUES=$P($G(^ABMDEXP(ABMI,0)),U,8)
 .I ABMQUES'["44" Q  ;we are just looking for question #44 to remove it
 .F ABMJ=1:1:$L(ABMQUES,",") D  ;loop thru questions
 ..I $P(ABMQUES,",",ABMJ)=44 D  ;if 44 is listed
 ...S $P(ABMQUES,",",ABMJ)=""  ;set that piece null
 ...I ABMQUES'["12" S $P(ABMQUES,",",ABMJ)=12  ;add question 12 in it's place if it isn't already on list
 ...S DIE="^ABMDEXP("
 ...S DA=ABMI
 ...S DR=".08////"_ABMQUES
 ...D ^DIE
 Q
ECODES ;for CRs 10027, 10064, 10381
 K DIC,X
 S U="^"
 F ABMI=1:1 S ABMLN=$P($T(ECODETXT+ABMI),";;",2) Q:ABMLN="END"  D
 .S ABMCODE=$P(ABMLN,U)
 .I $D(^ABMDCODE("AC","H",ABMCODE)) D  Q
 ..S DA=$O(^ABMDCODE("AC","H",ABMCODE,0))
 ..S $P(^ABMDCODE(DA,0),U,2)="H",$P(^(0),U,3)=$P(ABMLN,U,2)
 .S ABMDESC=$P(ABMLN,U,2)
 .S DIC="^ABMDCODE("
 .S DIC(0)="ML"
 .S X=ABMCODE
 .S DIC("DR")=".02///H"
 .S DIC("DR")=DIC("DR")_";.03///"_ABMDESC
 .K DD,DO
 .D FILE^DICN
 Q
ECODETXT ;
 ;;01^Pharmacy
 ;;04^Homeless Shelter
 ;;09^Prison/Correctional Facility
 ;;13^Assisted Living Facility
 ;;14^Group Home
 ;;16^Temporary Lodging
 ;;17^Walk-In Retail Health Clinic
 ;;18^Place of Employment-Worksite
 ;;20^Urgent Care Facility
 ;;49^Independent Clinic
 ;;57^Non-Residential Substance Abuse Treatment Facility
 ;;58^Non-Residential Opioid Treatment Facility
 ;;END
 ;
PENDDT ; CR11834 populate the pended date on claims that have a pending status using DATE LAST EDITED
 S ABMHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDCLM(DUZ(2))) Q:'DUZ(2)  D
 .S ABM=0
 .F  S ABM=$O(^ABMDCLM(DUZ(2),"AS","P",ABM)) Q:'ABM  D
 ..I $P($G(^ABMDCLM(DUZ(2),ABM,0)),U,20)'="" Q  ;already has a pended date
 ..S ABMDLE=$P($G(^ABMDCLM(DUZ(2),ABM,0)),U,10)  ;date last edited
 ..D ^XBFMK
 ..S DIE="^ABMDCLM(DUZ(2),"
 ..S DA=ABM
 ..S DR=".026////"_ABMDLE
 ..D ^DIE
 S DUZ(2)=ABMHOLD
 Q
NEWWARN ;CR10857
 ;258 - CPT code is inactive for part/all of the date span of visit
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=258
 S X="CPT code is inactive for part/all of the date span of visit"
 S DIC("DR")=".02///Confirm the CPT used is valid for the service date on the claim"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 D SITE(258)
 ;
 Q
 ;
SITE(ABMX) ;Add SITE multiple
 S DUZHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDCLM(DUZ(2))) Q:'+DUZ(2)  D
 .S DIC(0)="LX"
 .S DA(1)=ABMX
 .S DIC="^ABMDERR("_DA(1)_",31,"
 .S DIC("P")=$P(^DD(9002274.04,31,0),U,2)
 .S DINUM=DUZ(2)
 .S X=$P($G(^DIC(4,DUZ(2),0)),U)
 .S DIC("DR")=".03////"_$S(ABMX=256:"E",ABMX=21:"E",1:"W")
 .D ^DIC
 .K DA,DIC,DINUM
 S DUZ(2)=DUZHOLD
 K DUZHOLD,DLAYGO,ABMX
