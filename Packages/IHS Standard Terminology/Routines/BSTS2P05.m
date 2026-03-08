BSTS2P05 ;GDIT/HS/BEE-Version 2.0 Patch 5 Pre and Post Installs ; 19 Nov 2012  9:41 AM
 ;;2.0;IHS STANDARD TERMINOLOGY;**5**;Dec 01, 2016;Build 22
 ;
ENV ;EP - Environmental Checking Routine
 ;
 N VERSION,EXEC,BMWDT
 ;
 ;Check for BSTS v2.0 Patch 4
 I '$$INSTALLD("BSTS*2.0*4") D BMES^XPDUTL("Version 2.0 Patch 4 of BSTS is required!") S XPDQUIT=2 Q
 ;
 ;Check for XU*8.0*1020
 I '$$INSTALLD("XU*8.0*1020") D FIX(2)
 ;
 ;Check for DI*2.2*1020
 I '$$INSTALLD("DI*22.0*1020") D FIX(2)
 ; 
 ;Make sure a refresh is not running already
 L +^BSTS(9002318.1,0):0 E  D BMES^XPDUTL("A Local BSTS Cache Refresh is Already Running. Please Try Later") S XPDQUIT=2 Q
 L -^BSTS(9002318.1,0)
 ;
 ;Make sure an Description Id fix compile isn't running
 L +^XTMP("BSTSCFIX"):0 E  D BMES^XPDUTL("A Description Id Population Utility Process is Running.  Please Try later") S XPDQUIT=2 Q
 L -^XTMP("BSTSCFIX")
 ;
 ;Make sure another install isn't running
 L +^TMP("BSTSINSTALL"):3 E  D BMES^XPDUTL("A BSTS Install is Already Running") S XPDQUIT=2 Q
 L -^TMP("BSTSINSTALL")
 ;
 Q
 ;
EN ;EP
 ;
 ;Make a log entry
 ;GDIT/HS/BEE;02/27/2024;FEATURE#60482;Status of DTS Update Monitor - send any log entries
 D LOG^BSTSAPIL("INST","","PATCH","BSTS*2.0*5"),PLOG^BSTSAPIL
 ;
 ;Unlock installation entry
 L -^TMP("BSTSINSTALL")
 ;
 NEW TRIEN,EXEC,ERR,WIEN,WSIEN,PATCH,SIEN,STS,TR,CDST
 NEW SSLNAME,SSLFND,SYSXREF,SYSGL,CPORT,TWSIEN,PWSIEN
 ;
 ;Load the classes
 ;
 ;For each build, set this to the 9002318.5 entry to load
 S TRIEN=1
 ;
 ;Delete existing BSTS Classes
 S EXEC="DO $SYSTEM.OBJ.DeletePackage(""BSTS"")" X EXEC
 ;
 ; Import BSTS classes
 ;
 K ERR
 I $G(TRIEN)'="" D IMPORT^BSTSCLAS(TRIEN,.ERR)
 ;
 ;Make sure a SSL entry is defined
 ;
 ;Look for an SSL server
 S SYSXREF="^[""%SYS""]SYS",SYSGL=$NA(@SYSXREF)
 S (SSLFND,SSLNAME)="" F  S SSLNAME=$O(@SYSGL@("Security","SSLConfigsD",SSLNAME)) Q:SSLNAME=""  D  Q:SSLFND]""
 . NEW UPNAME
 . S UPNAME=$$UP^XLFSTR(SSLNAME)
 . I UPNAME["SNOMED" S SSLFND=SSLNAME
 I SSLFND="" D  G XEN
 . D BMES^XPDUTL("No SSL SNOMEDServer entry was found. Please set up the entry and re-install the build") H 10 S XPDABORT=1
 . ;
 . ;Unlock installation entry
 . L -^TMP("BSTSINSTALL")
 . ;
 . ;Allow logins again
 . NEW LIEN,LOG,ERR
 . S LIEN=$O(^%ZIS(14.5,0)) Q:'+LIEN
 . S LOG(14.5,LIEN_",",1)="N"
 . D FILE^DIE("","LOG","ERR")
 ;
 ;Set up or update BSTS WEB SERVICE ENDPOINT entries
 ;
 ;Make sure a PRODUCTION entry is defined
 I '$O(^BSTS(9002318.2,0)) D
 . ;
 . NEW DIC,DLAYGO,X,Y
 . ;
 . S DIC(0)="LNZ",DIC="^BSTS(9002318.2,",DLAYGO=9002318.2,X="PRODUCTION"
 . D ^DIC
 ;
 ;Make sure a TEST PRODUCTION entry is defined
 I '$O(^BSTS(9002318.2,0)) D
 . ;
 . NEW DIC,DLAYGO,X,Y
 . ;
 . S DIC(0)="LNZ",DIC="^BSTS(9002318.2,",DLAYGO=9002318.2,X="TEST PRODUCTION"
 . D ^DIC
 ;
 ;Loop through entries and update
 S (TWSIEN,PWSIEN,WSIEN)="",WIEN=0 F  S WIEN=$O(^BSTS(9002318.2,WIEN)) Q:'WIEN  D
 . ;
 . NEW PORT,NAME,NWPORT,BSTSWEB,URL,SSL,SSLCT
 . ;
 . S NAME=$$GET1^DIQ(9002318.2,WIEN_",",.01,"E")
 . S (URL,NWPORT)=""
 . ;
 . ;Production
 . S (SSLCT,NWPORT)="",PORT=$$GET1^DIQ(9002318.2,WIEN_",",.03,"E")
 . I ((PORT="")&(NAME="PRODUCTION"))!(PORT=44200)!(PORT=48200) D
 .. S NWPORT=48200
 .. S URL="https://dtsservices.ihs.gov"
 .. S WSIEN=WIEN,SSLCT=1,PWSIEN=WIEN
 . ;
 . ;Test Production
 . I ((PORT="")&(NAME="TEST PRODUCTION"))!(PORT=44299)!(PORT=48299) D
 .. S NWPORT=48299
 .. S URL="https://dtsservices.ihs.gov"
 .. S SSLCT=1,TWSIEN=WIEN
 . ;
 . ;GDIT DTS 4.4 Server - Switch to DTS 4.8
 . I (PORT=8083)!(PORT=8080)!(PORT=8180) D
 .. S NWPORT=8180
 .. S URL="http://rpmsdevditdts01.rpmsedo.ihs"
 .. S SSLCT=1
 . ;
 . ;Port
 . I NWPORT]"" S BSTSWEB(9002318.2,WIEN_",",.03)=NWPORT
 . ;
 . ;URL
 . I URL]"" S BSTSWEB(9002318.2,WIEN_",",.02)=URL
 . ;
 . ;Update the service path
 . S BSTSWEB(9002318.2,WIEN_",",.11)="/soap"
 . ;
 . ;SSL/TLS Configuration
 . S SSL=$$GET1^DIQ(9002318.2,WIEN_",",2.01,"E")
 . I SSL="" S BSTSWEB(9002318.2,WIEN_",",2.01)=$S(SSLCT:SSLNAME,1:"@")
 . ;
 . ;Username
 . S BSTSWEB(9002318.2,WIEN_",",.07)="DTSUser"
 . ;
 . ;Password
 . S BSTSWEB(9002318.2,WIEN_",",.08)="DTSPW!"
 . ;
 . ;Type
 . S BSTSWEB(9002318.2,WIEN_",",.04)="D"
 . ;
 . ;Update the entry
 . D FILE^DIE("","BSTSWEB","ERR")
 ;
 ;Set up BSTS SITE PARAMETERS entry
 ;
 I '$O(^BSTS(9002318,0)) D
 . ;
 . NEW DIC,DLAYGO,X,Y
 . ;
 . ;Set up the site parameter entry if necessary
 . S DIC(0)="LNZ",DIC="^BSTS(9002318,",DLAYGO=9002318,X=$P($G(^AUTTSITE(1,0)),U,1)
 . I X="" S X=$O(^BGPSITE(0))
 . I X'="" S X=$P(^DIC(4,X,0),U,1)
 . D ^DIC
 S SIEN=$O(^BSTS(9002318,0))
 ;
 ;Set up the Web Service entry if not found
 I SIEN]"" D
 . NEW DIC,DLAYGO,X,Y,DA
 . I $O(^BSTS(9002318,SIEN,1,0)) Q
 . I WSIEN="" Q
 . S DA(1)=SIEN,DIC(0)="XLNZ",DIC="^BSTS(9002318,"_SIEN_",1,",DLAYGO="9002318.01"
 . S X=WSIEN
 . K DO,DD D FILE^DICN
 ;
 ;Update the Web Service entry
 I SIEN]"" D
 . NEW WIEN,DA,IENS,BSTSSITE,ERROR,WSPTR
 . S WIEN=$O(^BSTS(9002318,SIEN,1,0)) Q:'+WIEN
 . S WSPTR=$P($G(^BSTS(9002318,SIEN,1,WIEN,0)),U) Q:WSPTR=""
 . S DA(1)=SIEN,DA=WIEN,IENS=$$IENS^DILF(.DA)
 . S BSTSSITE(9002318.01,IENS,.02)=1  ;Priority
 . ;
 . ;BEE;01/12/24;Based on conversation with Toni - do not switch to test production
 . ;If set to PRODUCTION and a test environment switch to TEST PRODUCTION
 . ;I WSPTR=PWSIEN,'$$PROD^XUPROD() D
 . ;. S BSTSSITE(9002318.01,IENS,.01)=TWSIEN
 . ;
 . D FILE^DIE("","BSTSSITE","ERROR")
 ;
 ;Display status to screen
 D BMES^XPDUTL("Verifying connection to DTS server is working. This may take several minutes to complete ")
 ;
 ;Verify that the server connects, if not quit
 S STS="" F TR=1:1:20 D  I +STS=2 Q
 . NEW VAR
 . D RESET^BSTSWSV1  ;Reset DTS to on
 . S STS=$$CODESETS^BSTSAPI("VAR") ;Try quick call
 . I +STS'=2 H 1
 ;
 ;Quit on failure
 I (+STS'=2) D  D BMES^XPDUTL("DTS is not working properly. Please get the BSTS connection working and then re-install the build") H 10 S XPDABORT=1 G XEN
 . ;
 . ;Unlock installation entry
 . L -^TMP("BSTSINSTALL")
 . ;
 . ;Allow logins again
 . NEW LIEN,LOG,ERR
 . S LIEN=$O(^%ZIS(14.5,0)) Q:'+LIEN
 . S LOG(14.5,LIEN_",",1)="N"
 . D FILE^DIE("","LOG","ERR")
 ;
 ;Kick off update to pull down SNOMED information
 D QUEUE^BSTSVOFL(32777) ;Put it on the queue
 ;
 ;Kick off RxNorm update
 D QUEUE^BSTSVOFL("S1552")
 ;
 D JOBNOW^BSTSVOFL  ;Kick off now
 ;
 ;Unlock installation entry
 L -^TMP("BSTSINSTALL")
 ;
XEN      Q
 ;
PRE      ;Pre-Install Front End
 ;
 ;Perform Lock so only one install can run and DTS calls will be switched to local
 L +^TMP("BSTSINSTALL"):3 E  D BMES^XPDUTL("A BSTS Install is Already Running - Aborting Installation") S XPDABORT=1 Q
 ;
 N DIU
 ;
 ;Clear out existing transport global and new conversion file
 S DIU="^BSTSCLS(",DIU(0)="DST" D EN^DIU2
 ;
 Q
 ;
INSTALLD(BSTSSTAL) ;EP - Determine if patch BSTSSTAL was installed, where
 ; BSTSSTAL is the name of the INSTALL.  E.g "BSTS*2.0*3"
 ;
 NEW BSTSY,INST
 ;
 S BSTSY=$O(^XPD(9.7,"B",BSTSSTAL,""))
 S INST=$S(BSTSY>0:1,1:0)
 D IMES(BSTSSTAL,INST)
 Q INST
 ;
IMES(BSTSSTAL,Y) ;Display message to screen
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_BSTSSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
 ;
FIX(X)     ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("This patch must be installed prior to the installation of BEDD*2.0*5",IOM)
 Q
