BRARIS ;ihs/cmi/maw - Add/Edit Radiology Interpreting Site
 ;;5.0;Radiology/Nuclear Medicine;**1008**;May 1, 2020;Build 14
 Q
 ;
RIS ;-- add/edit interpreting site
 K DIC,DIE,DR,DA
 S DIC="^RAMIS(73.99,",DIC(0)="AELMQZ",DIC("A")="Radiology Interpreting Site: "
 D ^DIC
 I Y<0 D  Q
 . K DIE,DIC,DA,DR
 S RARIS=+Y
 S DIE=DIC
 S DA=RARIS
 S DR=".02;.03;.04;.05;.06;1"
 D ^DIE
 K DIE,DR,DA,DIC
 Q
 ;
