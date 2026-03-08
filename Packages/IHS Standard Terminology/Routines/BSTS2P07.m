BSTS2P07 ;GDIT/HS/BEE-Version 2.0 Patch 7 Post Install ; 19 Nov 2012  9:41 AM
 ;;2.0;IHS STANDARD TERMINOLOGY;**7**;Dec 01, 2016;Build 8
 ;
ENV ;EP - Environmental Checking Routine
 ;
 N VERSION,EXEC,BMWDT
 ;
 ;Check for BSTS v2.0 Patch 6
 I '$$INSTALLD("BSTS*2.0*6") D BMES^XPDUTL("Version 2.0 Patch 6 of BSTS is required!") S XPDQUIT=2 Q
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
PRE ;Pre-Install Front End
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
PST ;EP
 ;
 ;Unlock installation entry
 L -^TMP("BSTSINSTALL")
 ;
 NEW TRIEN,EXEC,ERR,WIEN,WSIEN,PATCH,SIEN,STS,TR,CDST
 NEW SSLNAME,SSLFND,SYSXREF,SYSGL,CPORT,TWSIEN,PWSIEN
 ;
 ;Make a log entry
 D LOG^BSTSAPIL("INST","","PATCH","BSTS*2.0*7")
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
INSTALLD(BSTSSTAL) ;EP - Determine if patch BSTSSTAL was installed, where
 ; BSTSSTAL is the name of the INSTALL.  E.g "BSTS*2.0*7"
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
 W *7,!,$$CJ^XLFSTR("This patch must be installed prior to the installation of BEDD*2.0*7",IOM)
 Q
