RA410CNV ;IHS/HQW/SCR - IHS patch 10 conversion checks [ 01/11/2002  8:59 AM ]
 ;;4.0;RADIOLOGY;**10**;NOV 20, 1997
 ;
 ;This routine drives two conversions performed in RA*4.0*10
 ;It is intended to be a post-init only running after flags are set
 ;that show successful completion of the CONATRAST MEDIA ALLERGY *MOCK*
 ;conversions, and verification of no HL7 data performed
 ;by the pre-init routine RA410MCK.
 ;
 ;If conversions have already been completed quit
 I ^RA("IHSPATCH10",0)="CONVERSIONS COMPLETED" Q
 ;
 ;if environment check did not pass, abort install
 I '$D(^RA("IHSPATCH10",0)) D BMES^XPDUTL("Can not perform conversions until current packages are installed") Q
 ;
 ;
 I ^RA("IHSPATCH10","MOCK","HL7",0)'="DONE" D BMES^XPDUTL("HL7 data may exist on your system. Please call for Radiology support. Installation will now abort") S XPDABORT=1 Q
 I $P(^RA("IHSPATCH10","MOCK","ATS_CONVERSION",0),U)'="DONE" D BMES^XPDUTL("**MOCK** ATS conversion did not complete. Installation will now abort.") S XPDABORT=1 Q
 ;
 S ^RA("IHSPATCH10","VA_HL7_CONVERSION",0)=""
 S ^RA("IHSPATCH10","VA_ATS_CONVERSION",0)=""
 ;
 D STPJRNL,HL7,ATS,RMSG,STRTJN,CLEAN
 Q
 ;
STRTJN ;
 D BMES^XPDUTL("Journaling will now be restored to original conditions")
 S G=$$UCIJOURN^ZIBGCHAR("RADPT") I G S ^RA("IHSPATCH10","JRNLERROR","RADPT")=$$ERR^ZIBGCHAR(G)
 S G=$$UCIJOURN^ZIBGCHAR("GMR") I G S ^RA("IHSPATCH10","JRNLERROR","GMR")=$$ERR^ZIBGCHAR(G)
 ;
 ;NOTE: ^RAH was eliminated during conversion and won't be journaled...
 S G=$$UCIJOURN^ZIBGCHAR("HL") I G S ^RA("IHSPATCH10","JRNLERROR","HL")=$$ERR^ZIBGCHAR(G)
 Q
 ;
CLEAN ;
 K ^RADTMP,^GMRTMP,RAHLBYT,RAHLGLOB,RAIEN,RAREINDX
 Q
 ;
RMSG ;
 D BMES^XPDUTL("Please look for two screen messages saying two conversions have completed successfully.")
 S DIR(0)="Y",DIR("B")="YES",DIR("A")="Have both conversions completed?"
 D ^DIR
 Q:Y
 G:$D(DTOUT) RMSG
 D BMES^XPDUTL("Messages should have been printed to screen. There might have been a problem with one of the MOCK conversions")
 D BMES^XPDUTL("Please call for RADIOLOGY support: 1-888-830-7280")
 D BMES^XPDUTL("Enter '^' if you want to abort install now")
 D MES^XPDUTL("You will have to enable any options that have been disabled")
 I $D(DUOUT) S XPDABORT=1 Q
 G RMSG
 Q
ATS ;
 ;VA RA patch 18 associates RADIOLOGY allergies with Allergy Tracking
 ;System version 3. The following code mimics the pre-init for that
 ;conversion.
 ;
 S X="GMRARAD" X ^%ZOSF("TEST") K X I '$T  D  Q
 .S ^RA("IHSPATCH10","VA_ATS_CONVERSION")="NO ROUTINE"
 .S ^RA("IHSPATCH10","VA_ATS_CONVERSION",0)="FAILED"
 .D BMES^XPDUTL("Missing routine GMRARAD from GMRA*3*5. Can not install RADIOLOGY v4.0 patch 10")
 D BMES^XPDUTL("Allergy Tracking is installed. Proceeding with file update.")
 ;The next line performs the conversion and is original VA code modified
 ;to write to screen as well as sending a mail bulletin at completion.
 ;Also, "dots" are written to the screen to show progress.
 ;
 D ENQ^RAAFCV
 ;
 Q
 ;
HL7 ;
 I $D(^RAH(77.1,0)) D RUNHL7 Q  ;There is no Radiology HL7 global-- no problem
 S RAIEN=$O(^RA(77.1,"B","RADIOLOGY",0))
 I RAIEN="" S ^RA("IHSPATCH10","VA_HL7_CONVERSION")=0 D RUNHL7 Q  ;The global exists, but there is no data to convert -- no problem.
 S ^RA("IHSPATCH10","VA_HL7_CONVERSION")=1,^RA("IHSPATCH10","VA_HL7_CONVERSION","RAHLCV","FIRST_IEN")=RAIEN D RUNHL7 Q  ;There is data to convert 
 ;
RUNHL7 ;
 D ^RAHLCV
 Q
 ;
STPJRNL ;
 ;Want to stop journaling of globals affected by conversion
 ;
 S G=$$NOJOURN^ZIBGCHAR("RADPT") I G S ^RA("IHSPATCH10","JRNLERROR","RADPT")=$$ERR^ZIBGCHAR(G)
 S G=$$NOJOURN^ZIBGCHAR("GMR") I G S ^RA("IHSPATCH10","JRNLERROR","GMR")=$$ERR^ZIBGCHAR(G)
 S G=$$NOJOURN^ZIBGCHAR("RAH") I G S ^RA("IHSPATCH10","JRNLERROR","RAH")=$$ERR^ZIBGCHAR(G)
 S G=$$NOJOURN^ZIBGCHAR("HL") I G S ^RA("IHSPATCH10","JRNLERROR","HL")=$$ERR^ZIBGCHAR(G)
 D BMES^XPDUTL("Journaling of ^RADPT and ^GMR has been stopped for this install")
 D BMES^XPDUTL("Journaling of ^RAH and ^HL has been stopped for this install")
 Q
