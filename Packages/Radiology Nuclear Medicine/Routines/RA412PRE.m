RA412PRE ;IHS/HQW/SCR - Patch 12 check for complete conversions  [ 01/11/2002  8:23 AM ]
 ;;4.0;RADIOLOGY;**12**;NOV 20,1997
 ;
 ;First check to be sure DUZ and DUZ(0) are still defined
 ;
 I '$G(DUZ) D NODUZ Q
 I $G(DUZ(0))'="@" D NODUZ Q
 ;
 ;If the conversions have allready been performed, continue
 I $G(^RA("IHSPATCH10",0))="CONVERSIONS COMPLETED" Q
 ;
 ;Set RA variables to the value of each conversion node
 ;
 S RA200=$G(^RA("IHSPATCH10","VA_FILE200_CONVERSION",0))
 S RAHL7=$G(^RA("IHSPATCH10","VA_HL7_CONVERSION",0))
 S RAATS=$G(^RA("IHSPATCH10","VA_ATS_CONVERSION",0))
 ;
 I RA200="DONE"&(RAHL7="DONE")&(RAATS="DONE") D  Q
 .S ^RA("IHSPATCH10",0)="CONVERSIONS COMPLETED"
 .D BMES^XPDUTL("Conversions have completed successfully. Ready to complete installation")
 .D CLEAN
 I RA200="FAILED" D CLEAN,ABORT Q
 I RAHL7'="DONE" D CLEAN,ABORT Q
 I RAATS'="DONE" D CLEAN,ABORT Q
 ;
CLEAN ;
 K RA200,RAATS,RAHL7,RASTRNG
 Q
NODUZ ;
 ;Allow user to set DUZ correctly without wiping out transport global
 ;
 D BMES^XPDUTL("Please be sure your DUZ is defined and you have programmer access before continuing with this installation")
 S XPDQUIT=2
 Q
 ;
ABORT ;
 ;abort all transport globals in distribution and kill them from ^XTMP
 ;
 D BMES^XPDUTL("Installation will be aborted.")
 D BMES^XPDUTL("Contact IHS Support Center: 1-888-830-7280")
 S ^RA("IHSPATCH10",0)="FAILED"
 S XPDABORT=1
 Q
