RA410MCK ;IHS/HQW/SCR 10/15/01 - MOCK Conversion set-up [ 02/01/2002  10:17 AM ]
 ;;4.0;RADIOLOGY;**10**;NOV 20, 1997
 ;
 ;This routine drives a MOCK conversion for Allergy Tracking data
 ;and looks for HL7 data before the two conversions performed in 
 ;RA*4.0*10. It is intended to be a "pre-init" routine with checks 
 ;that show successfull completion of MOCK conversions before 
 ;continuing with conversions real data in the "post-init" routine 
 ;RA410CNV
 ;
 ;If conversions have already been completed quit
 I ^RA("IHSPATCH10",0)="CONVERSIONS COMPLETED" Q
 ;
 ;FIRST want to be sure the FILE200 conversion for RA has been done
 ;
 I '$D(^RA(79.198,"B","1")) D  Q
 .S ^RA("IHSPATCH10","VA_FILE200_CONVERSION",0)="FAILED"
 .D BMES^XPDUTL("File 200 conversion has not taken place.")
 .D BMES^XPDUTL("Installation of this patch will not occur.")
 .D BMES^XPDUTL("Please allow **MOCK** conversions to complete.")
 .D BMES^XPDUTL("No data or files will be affected.")
 S ^RA("IHSPATCH10","VA_FILE200_CONVERSION",0)="DONE"
 ;
 D SPACE Q:$G(XPDABORT)
 D STPJRNL,COPYRA,COPYGMR
 ;
 D BMES^XPDUTL("look for screen messages stating that **MOCK** CONTRAST MEDIA ALLERGY conversion has completed")
 D BMES^XPDUTL("Please call for RADIOLGY support if you do not think the MOCK conversion completed: 1-888-830-7280.")
 D MES^XPDUTL("No data is affected by MOCK conversions.")
 ;
 D MOCKATS
 ;
 I 'RASKPHL7 D BMES^XPDUTL("**Radiology HL7 data has been found!**"),MES^XPDUTL("Please contact Radiology support at (505)248-4404"),BMES^XPDUTL("We need to schedule this install to be sure HL7 data is not lost"),SORRY Q
 I RASKPHL7 D BMES^XPDUTL("No HL7 data to convert.") S ^RA("IHSPATCH10","MOCK","HL7",0)="DONE"
 D RMSG
 D:'$G(XPDABORT) BMES^XPDUTL("Preparing to start actual conversions...")
 Q
 ;
RMSG ;
 S DIR(0)="Y",DIR("B")="YES",DIR("A")="Has **MOCK** CONTRAST MEDIA ALLERGY conversion completed?"
 D ^DIR
 Q:Y
 G:$D(DTOUT) RMSG
 I $D(DUOUT) D STRTJN^RA410CNV,SORRY Q
 D BMES^XPDUTL("Message should have been printed to screen. There might have been a problem with the MOCK conversion")
 D BMES^XPDUTL("Please call for RADIOLOGY support: 1-888-830-7280")
 D BMES^XPDUTL("Enter '^' at the prompt if you want to abort install now")
 D MES^XPDUTL("You will have to enable any options that have been disabled")
 G RMSG
 Q
 ;
SPACE ;
 ;Determine if there is enough space to perform install
 ;
 D BMES^XPDUTL("Determining space available for conversion process...")
 D BMES^XPDUTL("...This might take a while...")
 D INT^%SP
 S ^RA("IHSPATCH10","MOCK","FREEBLOCKS")=%FTOTBLK
 S ^RA("IHSPATCH10","MOCK","TOTALBLOCKS")=%TOTBLK
 I %FTOTBLK/%TOTBLK*100<10 D  Q
 .D BMES^XPDUTL("YOU HAVE LESS THAN 10% FREE SPACE.  PLEASE ALLOCATE MORE SPACE FOR THIS INSTALL.")
 .D SORRY
 ;
 S RAGMRBYT=0
 F RAGLOB="^RADPT","^GMR(120.8)" D  Q:$G(XPDABORT)
 .F  S RAGLOB=$Q(@RAGLOB) Q:RAGLOB=""  S RAGMRBYT=RAGMRBYT+$L(RAGLOB)+$L(@RAGLOB)
 .I RAGMRBYT/1024>%FTOTBLK D  Q
 ..D BMES^XPDUTL("YOU DO NOT HAVE ENOUGH SPACE TO RUN THIS INSTALL.")
 ..D SORRY
 W !!,"For the GMR conversion you will need ",RAGMRBYT," bytes or ",$FN((RAGMRBYT*2/1024),"",4)," BLOCKS.",!,"You currently have ",$FN(%FTOTBLK,"",4)," BLOCKS of free space"
 S ^RA("IHSPATCH10","MOCK","NEEDED_ATS_BYTES")=RAGMRBYT
 ;
 ;The following code looks for evidence of HL7 data. There is no "mock"
 ;conversion developed for this conversion at this time, and no data to
 ;test the conversion. So, we go ahead if no data, but if data is found
 ;we abort the install and work with the individual site.
 ;
 S (RASKP771,RASKP770,RASKPCLN,RASKPHL7)=0
 I '$D(^RAH(77.1)) S RASKP771=1
 I '$D(^RAH(77.2)) S RASKP770=1
 I '$D(^RAH(77)) S RASKPCLN=1
 I RASKP771,RASKP770,RASKPCLN S RASKPHL7=1
 Q
 ;
STPJRNL ;
 ;Want to establish top nodes of NEW globals and stop journaling on 
 ;all affected globals
 S ^RADTMP(0)="",^GMRTMP(0)=""
 S G=$$NOJOURN^ZIBGCHAR("RADTMP")
 S G=$$NOJOURN^ZIBGCHAR("GMRTMP")
 S G=$$NOJOURN^ZIBGCHAR("RADPT") I G S ^RA("IHSPATCH10","JRNLERROR","RADPT")=$$ERR^ZIBGCHAR(G)
 S G=$$NOJOURN^ZIBGCHAR("GMR") I G S ^RA("IHSPATCH10","JRNLERROR","GMR")=$$ERR^ZIBGCHAR(G)
 D BMES^XPDUTL("Journaling of ^RADPT and ^GMR has been stopped for this install.")
 Q
 ;
COPYRA ;
 ;I only need the zero node of each patient to run the conversion.
 ;So I will make a global that contains only these nodes...
 ;
 N RAIEN
 S RAIEN=0
 D BMES^XPDUTL("Starting global copy")
 F  S RAIEN=$O(^RADPT(RAIEN)) Q:+RAIEN=0  S ^RADTMP(RAIEN,0)=^RADPT(RAIEN,0) W "."
 K RAIEN
 D BMES^XPDUTL("Zero nodes of ^RADPT have been copied into ^RADTMP for mock conversion.")
 Q
 ;
COPYGMR ;
 ;Need to copy the whole global since "B" is used
 ;But first want to check the zero node of ^GMR(120.8) to number
 ;of entries and the definition 
 ;
 S RAREINDX=0
 S XBCFIXFL=120.8
 D XBCFIXFL^XBCFIX
 S ^RA("IHSPATCH10","VA_ATS_CONVERSION","HIIEN")=XBCFIXHI
 S ^RA("IHSPATCH10","VA_ATS_CONVERSION","COUNT")=XBCFIXC
 ;
 I $P(^GMR(120.8,0),U)'="PATIENT ALLERGIES" S ^RA("IHSPATCH10","VA_ATS_CONVERSION","OLDPIECE1")=$P(^GMR(120.8,0),U),$P(^GMR(120.8,0),U)="PATIENT ALLERGIES",RAREINDX=1
 ;
 I $P(^GMR(120.8,0),U,2)'="120.8IPs" S ^RA("IHSPATCH10","VA_ATS_CONVERSION","OLDPIECE2")=$P(^GMR(120.8,0),U,2),$P(^GMR(120.8,0),U,2)="120.8IPs",RAREINX=1
 ;
 I $P(^GMR(120.8,0),U,3)'=XBCFIXHI S ^RA("IHSPATCH10","VA_ATS_CONVERSION","OLDHI")=$P(^GMR(120.8,0),U,3),$P(^GMR(120.8,0),U,3)=XBCFIXHI,RAREINDX=1
 ;
 I $P(^GMR(120.8,0),U,4)'=XBCFIXC S ^RA("IHSPATCH10","VA_ATS_CONVERSION","OLDCOUNT")=$P(^GMR(120.8,0),U,4),$P(^GMR(120.8,0),U,4)=XBCFIXC,RAREINX=1
 ;
 ;If there were problems, reindex the file before copying
 I RAREINDX S DIK="^GMR(120.8" D IXALL^DIK
 ;
 ;NOW merge the ^GMR(120.8 file into ^GMRTMP
 M ^GMRTMP=^GMR(120.8)
 ;
 D BMES^XPDUTL("^GMR(120.8) has been copied into ^GMRTMP for mock conversion")
 Q
 ;
MOCKATS ;
 ;here we do a "mock" routine to run the conversion on copied globals
 ;
 S X="GMRARAD" X ^%ZOSF("TEST") I '$T K DIFQ D  Q
 .S ^RA("IHSPATCH10","MOCK","ATS_CONVERSION")="NO ROUTINE"
 .S ^RA("IHSPATCH10","MOCK","ATS_CONVERSION")="FAILED"
 .D BMES^XPDUTL("Missing routine GMRARAD from GMRA*3*5. Can not install RADIOLOGY v4.0 patch 10")
 .D MES^XPDUTL("**NO DATA HAS BEEN AFFECTED BY THIS INSTALL**")
 .D CLEAN,SORRY
 D BMES^XPDUTL("Allergy Tracking routines are in place. Proceding with **MOCK** conversion")
 D BMES^XPDUTL("Starting  **MOCK** conversion of Radiology Contrast Media allergy data to the Allergy Tracking System.")
 D BMES^XPDUTL("You will receive a screen bulletin at completion")
 S RADUZ=DUZ
 D ENQ
 Q
 ;
ENQ ;
 ;Entry point for **MOCK** ATS conversion
 S GMRACAUS="RADIOLOGICAL/CONTRAST MEDIA",GMRADRCL=$O(^PS(50.605,"B","DX100",0))_";PS(50.605,"
 S DFN=0,RATSCNT=0
 F  S DFN=$O(^RADTMP(DFN)) Q:DFN'>0  D  
 .Q:$D(^RA("IHSPATCH10","MOCK","ATS_CONVERSION",DFN))
 .S RAX1=-1,RAX=$G(^RADTMP(DFN,0)) I $E($P(RAX,U,5),U,1)="Y" S RAX1=$$RADDMCK(DFN,"h","Y",1)  ;MOCK conversion routine to work on mock globals
 .S GMRADA=0 I $D(^GMRTMP(GMRADA,"B"))&(RAX1'>0) F  S GMRADA=$O(^GMRTMP("B",DFN,GMRADA)) Q:GMRADA'>0  I $$RALLG(GMRADA)  Q  ;find radiology allergies in **MOCK** ATS global
 .I GMRADA>0 D MCKUTL3(DFN,"Y")
 .S ^RA("IHSPATCH10","MOCK","ATS_CONVERSION",DFN)="",RATSCNT=RATSCNT+1
 .W:(RATSCNT#100=0) "."
 .S $P(^RA("IHSPATCH10","MOCK","ATS_CONVERSION",DFN),U,1)=$G(RAX1)
 S ^RA("IHSPATCH10","MOCK","ATS_CONVERSION",0)="DONE"_"^"_RATSCNT
 D MCKBULL
 Q
 ;
RALLG(DA,ERR)  ;This function is a **MOCK** copy of GMRARAD^RALLG and
 ;will determine if entry DA in GMRTMP represents a contrast media 
 ;allergy that is not entered in error.
 ;   INput variable: DA=entry in file ^GMRTMP
 ;                  ERR(optional)=if set to 0 do not check for E/E
 ;   return value: 1 if entry is contrast media allergy, 0 if not
 ;
 N FXN,ZERO,DRCL,DRCL1
 S FXN=0,ZERO=$G(^GMRTMP(DA,0)) I '$D(ERR) S ERR=1
 I 'ERR!(ERR&'+$G(^GMRTMP(DA,"ER"))) D  
 .F DRCL="DX100","DX101","DX102" S DRCL1=$O(^PS(50.605,"B",DRCL,0))_";PS(50.605," I $P(ZERO,U,3)=DRCL1!$D(^GMRTMP(DA,3,"B",+DRCL1)) S FXN=1 Q
 .I 'FXN,$P(ZERO,U,3)["GMRD(120.82"&$D(^GMRD(120.82,"D","RADIOLOGICAL/CONTRAST MEDIA",+$P(ZERO,U,3))) S FXN=1
 .I 'FXN,$$PSCHK^GMRARAD1($P(ZERO,U,3)) S FXN=1
 Q FXN
 ;
MCKUTL3(DFN,YN) ;EP
 ;This subroutine mimics ALLERGY^RAUTL3
 ;INPUT VARIABLES:
 ;  DFN=IEN of File 2
 ;  YN="Y" if ATS user is adding a contrast media allergy
 ;    ="N" if ATS user adds or enters in error 
 ;OUTPUT VARIABLES:
 ; none
 Q:'$D(DFN)  Q:'$D(^RADTMP(DFN,0))  Q:$E(YN,1)=$E($P(^RADTMP(DFN,0),U,5),1)
 ;
MCKA1 ;
 L +^RADTMP(DFN):2 I '$T G MCKA1
 N X,DA
 S DA=DFN,X=$P(^RADTMP(DFN,0),U,5)
 I X'="" D
 . S $P(^RADTMP(DFN,0),U,5)=$E(YN,1)
 . S X=$E(YN,1) I X'="" D  
 ..;the following code "mocks" the SET logic in ^DD(70,.05,1 which
 ..;does not exist before the conversion
 ..Q:$D(DIU(0))
 ..S RAMCKX93=$$RADDMCK(DA,"p",X)
 ..S $P(^RA("IHSPATCH10","MOCK","ATS_CONVERSION",DFN),U,2)=RAMCKX93
 ..K RAMCKX93
 L -^RADTMP(DFN)
 Q
 ;
RADDMCK(DFN,OH,YN,VER) ;
 ;this subroutine mimics $$RADD^GMRARAD
 ;THIS EXTRINSIC FUNCTION WILL ADD A CONTRAST MEDIA ALLERGY TO FILE
 ;^GMRTMP FOR A PATIENT WITH IEN DFN. 
 ;  INPUT VARIABLES:
 ;       DFN = IEN IN ^RADTMP FOR A RADIOLOGY PATIENT
 ;       OH = 'o' FOR OBSERVED, 'h' FOR HISTORICAL
 ;       YN = 'Y' MEANS CONTRAST RXN, 'N' MEANS NO CONTRAST RXN,
 ;            'U' MEANS UNKNOWN CONTRAST RXN
 ;       VER(optional) = '1' MEANS DATA WILL BE AUTOVERIFIED
 ;                       '0' MEANS DATA WILL NOT BE VERIFIED
 ;                       '$D' MEANS USE ATS AUTOVERIFICATION CHECKS
 ; FUNCTION RETURNS THE IEN OF NEW ^GMRTMP ENTRY OR -1 IF NOT ADDED
 ;
 N DA,DIK,GMRA,GMRACAUS,GMRADRCL,GMRAL,BMRACLS,GMRANEW,GMRANOW,GMRAX,GMRAY,GMRAER,X,Y
 I YN'="YES",YN'="Y" S DA=-1 G RETRA  ;if no rxn, then no need to add
 I DFN'>0 S DAY=-1 G RETRA ;if bad DFN, then quit
 S GMRACAUS="RADIOLOGICAL/CONTRAST MEDIA",GMRADRCL=$O(^PS(50.605,"B","DX100",0))_";PS(50.605," I +GMRADRCL'>0 S DAY=-1 G RETRA ;is DX100 in file 50.605
 S DA=0 F  S DA=$O(^GMRTMP("B",DFN,DA)) Q:DA'>0  I $$RALLGMCK(DA) Q  ;check to see if RAD allergy present
 I DA>0 G RETRA  ;if RAD allergy present, then quit
 I OH'="o",OH'="h" S DA=-1 G RETRA  ; is OH set up right
 S GMRANOW=$$HTFM^XLFDT($H),GMRAL=DFN_"^"_GMRACAUS_"^"_GMRADRCL_"^"_GMRANOW_"^"_$S('$G(RAAF18):DUZ,1:"")_"^"_OH_"^^^^^^1^^U^^^^^^D",GMRACLS=+GMRADRCL ; 120.9 RECORD 0th node
 I '$D(VER) D  ; need to check sites' autoverify parameters
 .  S GMRAY="",GMRAY(0)=GMRAL,VER=$$VFY^GMRASIGN(.GMRAY)
 .  K GMRASITE,GMRATYPE,GMRAY
 I VER'=0,VER'=1 S DA=-1 G RETRA ; is VER set up correctly
 S $P(GMRAL,U,16)=VER I VER S $P(GMRAL,U,17)=GMRANOW ; set up verify data in 0th node
 S GMRANEW=$P($G(^GMRTMP(0)),U,3,4)  ;get ^GMRTMP 0th node
 F DA=1+GMRANEW:1 L +^GMRTMP(DA,0):0 Q:$T&'$D(^GMRTMP(DA,0))  L:$T&$D(^GMRTMP(DA,0)) -^GMRTMP(DA,0)  ;find IEN for new record
 S ^GMRTMP(DA,0)=GMRAL  ;set 0th node for new record
 S ^GMRTMP(DA,3,0)="^120.803PA^1^1",GMRTMP(DA,3,1,0)=GMRACLS ;set drug class multiple for new record
 ;
 ;Don't want to x-ref a mock entry IHS/HQW/SCR 11/15/01
 ;S DIK="^GMRTMP(" D IX1^DIK L -^GMRTMP(DA,0) ;xref new record
 ;
 S $P(^GMRTMP(0),U,3,4)=DA_"^"_($P(GMRANEW,U,2)+1)  ;update ^GMRTMP 0th nod
 D    ;add NKA entry if necessary
 .; This entry point will add the NKA entry in file ^GMRTMP if needed.
 .N GMRATMP,GMRAPA,GMRA,GMRAY,GMRAX,DA,DFN,DIK
 .S GMRA(0)=GMRAL
 .Q:$D(^GMRTMP("ANKA",+GMRA(0),"y"))
 .S GMRATMP=GMRA(0) F DA=0:0 S:'$D(GMRA(0)) GMRA(0)=GMRATMP S DA=$O(^GMRTMP("ANKA",+GMRA(0),"n",DA)) Q:DA'>0  S DIK="^GMRTMP(" D ^DIK
 .S GMRAPA(0)=GMRA(0)
 .S GMRANEW=$P($G(^GMRTMP(0)),"^",3,4) ; get ^GMRTMP 0th node
 .F DA=1+GMRANEW:1 L +^GMRTMP(DA,0):0 Q:$T&'$D(^GMRTMP(DA,0))  ;find EN for new record
 .S GMRATMP=$P(GMRAPA(0),U)_"^^^"_$P(GMRAPA(0),U,4,5),$P(GMRATMP,U,22)="y",^GMRTMP(DA,0)=GMRATMP
 .;
 .;Don't want to x-reference a **mock** entry IHS/HQW/SCR 11/15/01
 .;.S DIK="^GMRTMP(" D IX1^DIK L -^GMRTMP(DA,0) ; xref new record
 .;
 .S $P(^GMRTMP(0),"^",3,4)=DA_"^"_($P(GMRANEW,"^",2)+1) ; update 0 node
 .Q
RETRA ;
 Q DA ;exit returning entry number of new record
 ;
RALLGMCK(DA,ERR) ;This function will determine if entry DA in ^GMRTMP represents a contrast media allergy that is not entered in error.
 ;       INPUT variable:  DA=entry in file ^GMRTMP
 ;                        ERR(optional)=if set to 0, don't check for E/E
 ;       RETURN value:  1 if entry is contrast medium allergy, 0 if not
 ;
 N FXN,ZERO,DRCL,DRCL1
 S FXN=0,ZERO=$G(^GMRTMP(DA,0)) I '$D(ERR) S ERR=1
 I 'ERR!(ERR&'$G(^GMRTMP(DA,"ER"))) D  
 .F DRCL="DX100","DX101","DX102" S DRCL1=$O(^PS(50.605,"B",DRCL,0))_";PS(50.605," I $P(ZERO,U,3)=DRCL1!$D(^GMRTMP(DA,3,"B",+DRCL1)) S FXN=1 Q
 .I 'FXN,$P(ZERO,U,3)["GMRD(120.92"&$D(^GMRD(120.82,"D","RADIOLOGICAL/CONTRAST MEDIA",+$P(ZERO,U,3))) S FXN=1
 .I 'FXN,$$PSCHK^GMRARAD1($P(ZERO,U,3)) S FXN=1
 Q FXN
 ;
MCKBULL ;
 ;Send a Mail message AND write to screen
 ;
 D BMES^XPDUTL("**MOCK** CONTRAST MEDIA ALLERGY data conversion completed successfully.")
 ;
 N DIFROM
 S XMY(RADUZ)="",XMDUZ=.5,XMSUB="MOCK Radiology Allergy Data Conversion"
 S R(1)="**MOCK** CONTRAST MEDIA ALLERGY data conversion completed successfully."
 S XMTEXT="R("
 D ^XMD
 Q
 ;
CLEAN ;
 K ^RADTMP,^GMRTMP
 Q
SORRY ;
 W !,"Can not continue. Installation will be aborted"
 S XPDABORT=1
 Q
