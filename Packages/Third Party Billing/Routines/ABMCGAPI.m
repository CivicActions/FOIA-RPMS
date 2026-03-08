ABMCGAPI ; IHS/SD/SDR - 3P Claim Generator Productivity API
 ;;2.6;IHS Third Party Billing System;**35,40**;NOV 12, 2009;Build 785
 ;IHS/SD/SDR 2.6*35 new routine; populate ^ABMCGAUD and ^ABMCGV globals with data
 ;   for the CGTM Claim Generator Productivity Report.
 ;IHS/SD/SDR 2.6*40 ADO85530 Fix for <SUBSCR>N5+16^DICN0 when Loc. Of Encounter is missing
 ;   from visit and stops claim generator from running
 ;
 Q
 ;
 ; *********************************************************************
EN(ABMCGIEN,ABMOPT,ABMBKMG,ABMPT,ABMFIN)   ;PEP - Create Audit entry for claim generator
 N X,Y,DIC,DIE,DIR
 I $G(ABMCGIEN)="" D
 .F I=1:1:5 L +^ABMCGAUD:3 S X=$T Q:X
 .S DIC="^ABMCGAUD("
 .S DIC(0)="L"
 .D NOW^%DTC
 .S (X,DINUM)=%
 .S DIC("DR")=".02////"_ABMOPT_";.03////"_DUZ  ;what option and who did it
 .I $G(ABMPT)'="" S DIC("DR")=DIC("DR")_";.05////"_ABMDFN  ;patient if CG1P
 .K DD,DO
 .D FILE^DICN
 .L -^ABMCGAUD
 .S ABMCGIEN=+Y
 I +ABMCGIEN>0 D  Q +ABMCGIEN
 .I $G(ABMFIN)=1 D
 ..D NOW^%DTC
 ..K DA,X,Y,DIC,DIE,DIR
 ..S DIE="^ABMCGAUD("
 ..S DA=ABMCGIEN
 ..S DR=".04////"_%
 ..D ^DIE
 Q 0
EDIT(ABMCGIEN,ABMOPT) ;PEP - edit existing audit entry
 N X,Y,DIC,DIE,DR
 S DA(1)=ABMCGIEN
 S DIC(0)="LM"
 I ABMOPT="BKMG" D
 .S DIC="^ABMCGAUD("_DA(1)_",1,"
 .S X=$P($G(^ABMDPARM(DUZ(2),1,0)),U,22)
 .S DIC("DR")=".02////"_DUZ(2)_";.03////"_$P($G(^ABMDPARM(DUZ(2),1,0)),U,21)_";.04////"_$P($G(^ABMDPARM(DUZ(2),1,0)),U,19)
 K DD,DO
 D FILE^DICN
 Q 0
 ;
VISIT(ABMVDFN,ABMCGIEN,ABMRSN,ABMDATA,ABMBKMG)   ;PEP - add visit to audit
 N DA,X,Y,DIC,DIE,DIR
 N DR  ;abm*2.6*40 IHS/SD/SDR ADO85530
 S DIC="^ABMCGV("
 S DIC(0)="LM"
 S X="`"_ABMVDFN
 S DINUM=ABMVDFN
 D ^DIC
 I +Y>0 D  Q
 .S ABMCGVI=+Y
 .K DA,X,Y,DIC,DIE,DIR
 .S DIE="^ABMCGV("
 .S DA=ABMCGVI
 .;S DR=".02////"_$P($G(^AUPNVSIT(ABMVDFN,0)),U,6)  ;visit loc  ;abm*2.6*40 IHS/SD/SDR ADO85530
 .S DR=".02////"_+$P($G(^AUPNVSIT(ABMVDFN,0)),U,6) ;visit loc; the '+' forces a zero, and then later for report will check for zero and put 'no loc'  ;abm*2.6*40 IHS/SD/SDR ADO85530
 .D ^DIE
 .K DA,X,Y,DIC,DIE,DIR
 .S DA(1)=ABMCGVI
 .S DIC="^ABMCGV("_DA(1)_",1,"
 .S DIC(0)="L"
 .S X=ABMCGIEN
 .D ^DIC
 .Q:Y<0
 .K DR
 .S DIE=DIC
 .S DA=+Y
 .I +$G(ABMRSN)'=0 S DR=".02////"_ABMRSN  ;reason no claim
 .I +$G(ABMBKMG)=1 S DR=$S($G(DR)'="":DR_";",1:"")_"11////Y"  ;BKMGd
 .I $G(DR)="" Q  ;no reason or BKMG
 .D ^DIE
 Q 0
CLAIM(ABMCGVI,ABMCGIEN,ABMVCC,ABMINS) ;PEP - add claim to audit
 K DA,X,Y,DIC,DIE,DIR
 S DA(1)=ABMCGVI
 S DA=ABMCGIEN
 S DIE="^ABMCGV("_DA(1)_",1,"
 S DR=".03////"_ABMVCC_";.04////"_ABMINS  ;claims created and active insurer
 D ^DIE
 Q
