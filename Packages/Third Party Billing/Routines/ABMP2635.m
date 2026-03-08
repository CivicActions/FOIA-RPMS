ABMP2635 ; IHS/SD/SDR - 3P BILLING 2.6 Patch 35 PRE INIT ;  
 ;;2.6;IHS Third Party Billing;**35**;NOV 12, 2009;Build 659
 Q
 ;
 ;
PRE ;
 ;this is the 3P Claim Data file DESTINATION field; it has some bad cross references sometimes which cause the lookup into the Patient
 ;file to not work correctly; this will kill the DD for the field, and then the install will recreate it correctly with the whole
 ;3P Claim Data file being included in the KIDS.  This is part of ADO60702
 K ^DD(9002274.3,.127)
 Q
