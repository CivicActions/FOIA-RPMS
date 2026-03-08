ABSPP55 ;IHS/SD/SDR - PRE/POST ROUTINE FOR PATCH 55
 ;;1.0;PHARMACY POINT OF SALE;**55**;JUN 01, 2001;Build 103
 ;
PRE ;
 D BMES^XPDUTL("Options ELIG and PRIV are being reactivated automatically in this patch....")
 S DA=$O(^DIC(19,"B","ABSP MEDICARE PART D ELIG CHK",0))
 I +$G(DA)'=0 D
 .S DIE="^DIC(19,"
 .S DR="2////@"
 .D ^DIE
 .S ABSP=$$LOG^BUSAAPI("A","S","","ABSPP55","ABSP: Reactivation of ELIG option with patch install","")
 ;
 S DA=$O(^DIC(19,"B","ABSP PRIVATE INS ELIG CHECK",0))
 I +$G(DA)'=0 D
 .S DIE="^DIC(19,"
 .S DR="2////@"
 .D ^DIE
 S ABSP=$$LOG^BUSAAPI("A","S","","ABSPP55","ABSP: Reactivation of PRIV option with patch install","")
 Q
POST ;
 D NOHTPOST^ABSPP54  ;ADO117693 to set DEFAULT DIAL OUT in the ABSP Set Up file
 Q
