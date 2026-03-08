ABMP2636 ; IHS/SD/SDR - 3P BILLING 2.6 Patch 36 PRE INIT ;  
 ;;2.6;IHS Third Party Billing;**36**;NOV 12, 2009;Build 698
 Q
 ;
 ;
PRE ;
 ;this is the identifier on the 3P TX Status file BILLING CLERK field. It is still using file 3 which is being deleted
 ;in ava*93.2*27, and causes a programming error in RCEM and in a FM Inquire into the 3P TX Status file, <UNDEF>W1+1^DICQ1.
 ;The install will add the identifier back on correctly, using file 200. This is part of ADO87558
 S A="^DD(9002274.6,0,""ID"",.05)"
 K @A
 Q
