HL39ENV ;ISCSF/JC-Patch 39 ENVIRONMENT CHECK ;10/06/99  08:52 [ 04/02/2003   8:37 AM ]
 ;;1.6;HEALTH LEVEL SEVEN;**1004**;APR 1, 2003
 ;;1.6;HEALTH LEVEL SEVEN;**39**;05/13/98
ENV ;Environment check     
 ;check if patch is already installed
 Q:'$$PATCH^XPDUTL("HL*1.6*39")
 ;don't load the logical links, kill global
 W !!,"A previous version of patch 39 was already installed.",!,"Removing patch data.",!
 K ^XTMP("XPDI",XPDA,"KRN",869.2),^(870)
 Q
