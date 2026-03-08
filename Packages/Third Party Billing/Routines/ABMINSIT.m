ABMINSIT ; IHS/SD/SDR - Budget Activity Input Transform
 ;;2.6;IHS Third Party Billing System;**11,21,36**;NOV 12, 2009;Build 698
 ;IHS/SD/SDR 2.6*21 VMBP RQMT_106 released in p11 but adding note with Serence ref#
 ;IHS/SD/SDR 2.6*36 ADO76247 Removed write statement; it was writing the insurer type to the screen when it shouldn't
 ;
EN ; EP
 N DIC,DIE,DIR,DA,Y,DO
 S DIC="^AUTTINTY("
 S DIC(0)="MQX"
 D ^DIC
 K DIC
 I +Y<0 K X Q
 S X=$$GET1^DIQ(9999999.181,+Y,"1")
 ;W "  "_X  ;abm*2.6*36 IHS/SD/SDR ADO76247
 Q
