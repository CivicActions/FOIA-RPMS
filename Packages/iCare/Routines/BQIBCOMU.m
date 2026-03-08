BQIBCOMU ;GDIT/HCSD/ALA-BCOM Setup ; 04 Feb 2022  4:45 PM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**3**;Mar 01, 2021;Build 32
 ;
 ;
EN ;
 ; Determine the BCOM namespace
 S PORD=$$PROD^XUPROD()
 ;S FILESPEC=$S('PORD:"CANEZ",1:"CANES")_"*"_$S($P(^BQI(90508,1,0),"^",6)="":".txt",1:".zip")
 S FILESPEC="CANE*.txt;CASE*.zip;CASE*.txt"
 S FILEPATH=$P($G(^AUTTSITE(1,1)),"^",2)
 I FILEPATH="" S FILEPATH=$P($G(^XTV(8989.3,1,"DEV")),"^",1)
 D SERVER^ADSRPT
 S BQIWHO=$S($G(ARRAY(1.01))["rpmsedo":1,1:0)
 K ARRAY
 ; Get password and verify from ZISH if exists
 S PASS="anonymous",VER="guest@"
 S ZSN=$O(^%ZIB(9888888.93,"B","CANE SURVEILLANCE SEND","")) I ZSN'="" D
 . S PASS=$P(^%ZIB(9888888.93,ZSN,0),"^",3),VER=$P(^%ZIB(9888888.93,ZSN,0),"^",4)
 ;
 S @("BCOMNS=""BCOM""_$namespace")
 I @("'##class(%SYS.Namespace).Exists(BCOMNS)") S OK="" F  D  Q:X="^"!OK
 . S DIR(0)="F"
 . S DIR("A")="Enter the name of the BCOM Ensemble namespace"
 . D ^DIR
 . I X="^" Q
 . S BCOMNS=Y
 . I @("##class(%SYS.Namespace).Exists(BCOMNS)") S OK=1 Q
 . W !!,"Namespace '"_BCOMNS_"' does not exist",!
 Q:$G(X)="^"
 ;
 ; Switch to BCOM namespace. Using New causes the namespace to return 
 ; to the current namespace when this subroutine quits
 N @("$namespace")
 S @("$namespace=BCOMNS")
 ;
 W !!,"Checking production..."
 ; Verify production exists
 S PROD="BCOM.SFTP"
 I @("'##class(%Dictionary.CompiledClass).%ExistsId(PROD)") D ERR("Production '"_PROD_"' does not exist. Please install the production and try again") Q
 ; Open production object
 S @("POBJ=##class(Ens.Config.Production).%OpenId(PROD)")
 I @("'$IsObject(POBJ)") D ERR("Production '"_PROD_"' cannot be opened") Q
 ;
 ; Get existing hosts
 D @("##class(Ens.Director).getProductionItems(POBJ,.ITEMS)")
 ;
 ; Add BS to production
 S BSNAME="GetCANES",TSC=1
 W !,"Adding '"_BSNAME_"' business service..."
 I $D(ITEMS(BSNAME)) W " already exists"
 E  D
 . S @("HOST=##class(Ens.Config.Item).%New()")
 . S HOST.PoolSize=1
 . S HOST.Name=BSNAME
 . S HOST.ClassName="EnsLib.File.PassthroughService"
 . S HOST.Enabled=1
 . S @("TSC=POBJ.Items.Insert(HOST)")
 . I 'TSC D ERR("Unable to add '"_BSNAME_"' to the production",$$GETERR(TSC)) Q
 I 'TSC Q
 ;
 ; Add BO to production
 S BONAME="SendCANES"
 W !,"Adding '"_BONAME_"' business operation..."
 I $D(ITEMS(BONAME)) W " already exists"
 E  D
 . S @("HOST=##class(Ens.Config.Item).%New()")
 . S HOST.PoolSize=1
 . S HOST.Name=BONAME
 . S HOST.ClassName="EnsLib.FTP.PassthroughOperation"
 . S HOST.Enabled=1
 . S @("TSC=POBJ.Items.Insert(HOST)")
 . I 'TSC D ERR("Unable to add '"_BONAME_"' to the production") Q
 I 'TSC Q
 ;
 ; Save production
 S @("TSC=POBJ.%Save()")
 I 'TSC D ERR("Unable to save production changes") Q
 ;
 ; Apply CANES production settings
 W !,"Applying CANES production settings..."
 I $G(FILEPATH)'="" D
 . S SETTINGS(BSNAME,"Adapter","FilePath")=FILEPATH
 . ; The archive directory is up one level then in the 'archive' subdirectory (a peer of the file directory)
 . S @("SETTINGS(BSNAME,""Adapter"",""ArchivePath"")=##class(%File).SubDirectoryName(##class(%File).ParentDirectoryName(FILEPATH),""archive"")")
 S SETTINGS(BSNAME,"Adapter","FileSpec")=FILESPEC
 S SETTINGS(BSNAME,"Adapter","CallInterval")="3600"
 S SETTINGS(BSNAME,"Host","TargetConfigNames")=BONAME
 S SETTINGS(BONAME,"Adapter","SSLConfig")=""
 S SETTINGS(BONAME,"Host","Filename")="%f"
 S SETTINGS(BONAME,"Host","FailureTimeout")=35
 S SETTINGS(BONAME,"Adapter","ConnectTimeout")=45
 ;
 I 'BQIWHO D
 . S SETTINGS(BONAME,"Adapter","FTPServer")="QUOVADX-IE.IHS.GOV"
 . S SETTINGS(BONAME,"Adapter","FTPPort")="21"
 . ;X "do ##class(Ens.Config.Credentials).SetCredential(""CANES_Cred"",""fludata"",""etgx7h"")"
 . X "do ##class(Ens.Config.Credentials).SetCredential(""CANES_Cred"",PASS,VER)"
 . S SETTINGS(BONAME,"Adapter","Credentials")="CANES_Cred"
 I BQIWHO D
 . S SETTINGS(BONAME,"Adapter","FTPServer")="10.76.5.4"
 . S SETTINGS(BONAME,"Adapter","FTPPort")="21"
 . S SETTINGS(BONAME,"Adapter","FilePath")="uploads\CANES"
 . ;X "do ##class(Ens.Config.Credentials).SetCredential(""ANON_Cred"",""anonymous"",""guest@"")"
 . X "do ##class(Ens.Config.Credentials).SetCredential(""ANON_Cred"",PASS,VER)"
 . S SETTINGS(BONAME,"Adapter","Credentials")="ANON_Cred"
 ;
 S @("TSC=##class(Ens.Production).ApplySettings(PROD,.SETTINGS)")
 I 'TSC D ERR("Unable to apply production settings",$$GETERR(TSC)) Q
 ;
 ; Configure BCOM production
 W !,"Configuring BCOM production..."
 ; Set a schedule if needed
 ;S HN=BSNAME W !,"  ...",HN S TSC=$$SETSCHED(HN,SCHED) I 'TSC D ERR("Unable to configure '"_HN_"'",$$GETERR(TSC))
 ;S HN="HashCHIT" W !,"  ...",HN S TSC=$$UPDHOST(HN,0,0) I 'TSC D ERR("Unable to configure '"_HN_"'",$$GETERR(TSC))
 ;F HN="GetCHIT","SendCHIT","SendCHITHash" W !,"  ...",HN S TSC=$$UPDHOST(HN,0) I 'TSC D ERR("Unable to configure '"_HN_"'",$$GETERR(TSC))
 ;
 ; Update production if necessary
 S @("TSC=##class(Ens.Director).GetProductionStatus(.X,.PS)")
 ; If stopped
 I $G(PS)=2 D  I 'TSC D ERR("Unable to start production",$$GETERR(TSC))
 . W !,"Starting BCOM production..."
 . S @("TSC=##class(Ens.Director).StartProduction(PROD)")
 ; If needs updating
 S @("PS=##class(Ens.Director).ProductionNeedsUpdate()")
 I PS D  I 'TSC D ERR("Unable to update production",$$GETERR(TSC))
 . W !,"Updating production..."
 . S @("TSC=##class(Ens.Director).UpdateProduction(120,1)")
 ;
 Q
 ;
UPDHOST(HOST,ENABLED,FG) ;
 I $G(HOST)="" Q 1
 I $G(ENABLED)="",$G(FG)="" Q 1
 N PCOBJ,IOBJ,TSC
 S @("PCOBJ=##class(Ens.Config.Production).%OpenId(""BCOM.SFTP"")")
 I PCOBJ="" Q 1
 S @("IOBJ=PCOBJ.FindItemByConfigName(HOST)")
 I IOBJ="" Q 1
 I $G(ENABLED)'="" S IOBJ.Enabled=ENABLED
 I $G(FG)'="" S IOBJ.Foreground=FG
 S @("TSC=IOBJ.%Save()")
 Q TSC
 ;
ERR(MSG,ERR) ;
 I $G(MSG)="" Q
 W !!,"** Error: "_MSG
 I $G(ERR)'="" W !,ERR
 W !!
 Q
 ;
GETERR(TSC) ;
 N ERR,TXT,I
 I TSC Q ""
 D @("##class(%SYSTEM.Status).DecomposeStatus(TSC,.ERR,""-d"")")
 S TXT=""
 F I=1:1:ERR S TXT=TXT_ERR(I)_" "
 S TXT=$E(TXT,1,*-1) ; Strip the final space
 Q TXT
 ;
SETSCHED(HOST,SCHED) ;
 I $G(HOST)="" Q 1
 N PCOBJ,IOBJ,TSC
 S @("PCOBJ=##class(Ens.Config.Production).%OpenId(""BCOM.SFTP"")")
 I PCOBJ="" Q 1
 S @("IOBJ=PCOBJ.FindItemByConfigName(HOST)")
 I IOBJ="" Q 1
 S IOBJ.Schedule=$G(SCHED)
 S @("TSC=IOBJ.%Save()")
 Q TSC
