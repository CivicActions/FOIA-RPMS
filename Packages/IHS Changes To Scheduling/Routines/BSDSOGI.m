BSDSOGI ;IHS/CMI/MAW - PIMS Preferred Name Utilities; 
 ;;5.3;PIMS;**1022**;MAY 28, 2004;Build 18
 ;
PREF(DF) ;-- get the external preferred name
 S BSDNM=$$GETPREF^AUPNSOGI(DF,"E",1)
 Q $G(BSDNM)
 ;
