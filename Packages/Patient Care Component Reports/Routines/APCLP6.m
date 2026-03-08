APCLP6 ;IHS/CMI/LAB - post init to patch 5  [ 01/16/05  2:40 PM ]
 ;;3.0;IHS PCC REPORTS;**18**;FEB 05, 1997
 ;
 ;add new report to menu
 NEW X
 S X=$$ADD^XPDMENU("APCL M MAN ALL REPORTS","APCL CNTS GENERAL/DENTAL","GCDC")
 I 'X W "Attempt to add General/Dental Report option failed." H 3
 Q
