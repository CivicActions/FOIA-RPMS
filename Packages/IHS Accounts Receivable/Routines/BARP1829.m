BARP1829 ; IHS/SD/CPC - Post init for V1.8 Patch 29;02/01/2020
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**29**;OCT 26,2005;Build 66
 ;
 ;IHS/SD/CPC BAR*1.8*29 Pre/Post install routine.
 Q
 ; ********************************************************************
 ;
PRE ; EP 
 ;Change/Add A/R EDI EDI ERROR CODES
 N BARTST,BARCD,BARDESC,X,Y
 F I=1:1:5 L +^BARERR:2 S X=$T Q:X
 I 'X W "Cannot obtain a lock" Q  ;HOW TO BLOW UP INSTALL?
 K DIC,DIE,DIR,DA,DR,X
 S DIC=90056.21 ;A/R EDI EDI CLAIM ERROR CODE
 S DIC(0)="B"
 S X="MM"
 D ^DIC
 I +Y<0 D
 .S BARCD=0
 .F BARCD="CD","CT","CD" D
 ..S DA=0
 ..S DA=$O(^BARERR("B",BARCD,DA))
 ..S DIE=$$DIC^XBDIQ1(90056.21)
 ..S DR=".01///Z"_BARCD
 ..D:+DA>0 ^DIE
 .K DA,DR,DIE,DIC,DIR,X
 .F X="CT","CD","BA","MM","MMO","BAO","CDO" D
 ..S DIC=$$DIC^XBDIQ1(90056.21)
 ..S DIC(0)="NXL"
 ..S DLAYGO=90056.21
 ..K DD,DO
 ..D FILE^DICN
 ..I +Y<0 W "SOMETHING WENT WRONG - ABORTING" Q  ;
 ..S BARDESC=$S(X="CT":"BILL NUMBER/RX NOT FOUND IN RPMS",X="CD":"DATE OF SERVICE DOESN'T MATCH RPMS",1:"")
 ..S:BARDESC="" BARDESC=$S(X="BA":"BILL AMOUNT DOESN'T MATCH RPMS",X="MM":"Manual Matching Done",1:"")
 ..S:BARDESC="" BARDESC=$S(X="BAO":"Manual Match Amount Override",X="CDO":"Manual Match Date Override",1:"")
 ..S:BARDESC="" BARDESC=$S(X="MMO":"Manual Match without BA or CD override",1:"")
 ..Q:BARDESC=""
 ..S DA=+Y
 ..S DIE=$$DIC^XBDIQ1(90056.21)
 ..S DR=".02///"_BARDESC
 ..D ^DIE
 ..K DA,DR,DIE,DIC,DIR
 K X,Y
 Q
 ; 
POST ;EP
 ;Needed for IB18 REMOVE FOR RELEASE
 Q
 S RSNCDIEN=0
 S RSNCDIEN=$O(^BARERR("B","MMO",RSNCDIEN))
 I RSNCDIEN']0 D
 .S X="MMO"
 .S DIC=$$DIC^XBDIQ1(90056.21)
 .S DIC(0)="NXL"
 .S DLAYGO=90056.21
 .K DD,DO
 .D FILE^DICN
 .I +Y>0 S DA=+Y,DIE=$$DIC^XBDIQ1(90056.21) D
 ..S DR=".02///Manual Match without BA or CD override"
 ..D ^DIE
 ..K DA,DR,DIE,DIC,DIR
 K X,Y,RSNCDIEN
 Q
