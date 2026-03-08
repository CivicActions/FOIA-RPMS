BSTS2P03 ;GDIT/HS/BEE-Version 2.0 Patch 3 Post (and Pre) Install ; 19 Nov 2012  9:41 AM
 ;;2.0;IHS STANDARD TERMINOLOGY;**3**;Dec 01, 2016;Build 46
 ;
ENV ;EP - Environmental Checking Routine
 ;
 N VERSION,EXEC,BMWDT
 ;
 ;Check for BSTS v2.0 Patch 2
 I '$$INSTALLD("BSTS*2.0*2") D BMES^XPDUTL("Version 2.0 Patch 2 of BSTS is required!") S XPDQUIT=2 Q
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
 D LOG^BSTSAPIL("INST","","PATCH","BSTS*2.0*3")
 ;
 ;Unlock installation entry
 L -^TMP("BSTSINSTALL")
 ;
 ;Load the classes
 ;
 NEW ICONC,ICIEN,INALL,CNT
 N TRIEN,EXEC,ERR,X,VAR,STS,PROC,II
 ;
 ;Verify update isn't running
 S ^XTMP("BSTSLCMP","QUIT")=1 H 15
 ;
 ;For each build, set this to the 9002318.5 entry to load
 S TRIEN=1
 ;
 ;Delete existing BSTS Classes
 S EXEC="DO $SYSTEM.OBJ.DeletePackage(""BSTS"")" X EXEC
 ;
 ; Import BSTS classes
 K ERR
 I $G(TRIEN)'="" D IMPORT^BSTSCLAS(TRIEN,.ERR)
 I $G(ERR) Q
 ;
 ;Clear out queue
 NEW PROC
 S PROC="" F  S PROC=$O(^XTMP("BSTSPROCQ","B",PROC)) Q:PROC=""  D
 . NEW TPROC
 . S TPROC="" F  S TPROC=$O(^XTMP("BSTSPROCQ","B",PROC,TPROC)) Q:TPROC=""  D
 .. K ^XTMP("BSTSPROCQ","B",PROC,TPROC)
 .. K ^XTMP("BSTSPROCQ",TPROC)
 K ^XTMP("BSTSLCMP")
 ;
 ;Kick off RxNorm update
 D QUEUE^BSTSVOFL("S1552")
 ;
 ;Kick off update to pull down SNOMED information
 D QUEUE^BSTSVOFL(32777) ;Put it on the queue
 ;
 ;Queue custom codesets (allergies and med routes)
 D QUEUE^BSTSVOFL(32771)
 D QUEUE^BSTSVOFL(32772)
 D QUEUE^BSTSVOFL(32773)
 D QUEUE^BSTSVOFL(32774)
 ;
 ;Run daily checks to find additional needed updates
 D DAYCHK^BSTSVOF1(1)
 ;
 D JOBNOW^BSTSVOFL  ;Kick off now
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
INSTALLD(BSTSSTAL) ;EP - Determine if patch BSTSSTAL was installed, where
 ; BSTSSTAL is the name of the INSTALL.  E.g "BSTS*1.0*1".
 ;
 NEW DIC,X,Y,D
 S X=$P(BSTSSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",22,",X=$P(BSTSSTAL,"*",2)
 D ^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(BSTSSTAL,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
