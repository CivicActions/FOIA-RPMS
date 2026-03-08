BJMD10E4 ;VNGT/HS/GCD-Environment Check Routine; 25 Jun 2013
 ;;1.0;CDA/C32;**4**;Feb 08, 2011
 ;
 ; Check for EHR 1.1 patch 13 by checking for one of its constituent patches
 I '$$PATCH^XPDUTL("BEHO*1.1*001010") D BMES^XPDUTL("EHR patch 13 is required.") S XPDQUIT=2
 Q
