BLRPRE51 ; IHS/MSC/MKK - RPMS Lab Patch LR*5.2*1051 Routine ; 05-May-2022 14:55 ; MKK
 ;;5.2;IHS LABORATORY;**1051**;NOV 01, 1997;Build 19
 ;
POST ; EP - Post Install MailMan Message
 NEW STR
 ;
 S STR(1)=" "
 S STR(2)=$J("",10)_"POST INSTALL of BLRPRE51 Routine."
 S STR(3)=" "
 S STR(4)=$J("",15)_"Laboratory Patch LR*5.2*1051 INSTALL completed."
 S STR(5)=" "
 ;
 ; Send E-Mail to LMI Mail Group & Installer
 D MAILALMI^BLRUTIL3("Laboratory Patch LR*5.2*1051 INSTALL complete.",.STR,"BLRPRE51")
 Q
