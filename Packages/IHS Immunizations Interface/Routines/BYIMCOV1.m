BYIMCOV1 ;GDIT/HS/GCD - IMMUNIZATION DATA EXCHANGE; [ 03/13/2021  11:10 PM ]
 ;;3.0;BYIM IMMUNIZATION DATA EXCHANGE;**1,2**;MAR 15, 2021;Build 493
 ;
 Q
 ;
 ; Sets up BYIM business hosts in BCOM production
BCOM(FILEPATH) ;
 N BCOMNS,DIR,X,Y,OK,PROD,POBJ,ITEMS,HOST,BSNAME,BONAME,TSC,SETTINGS,SSLCFG,HN,PS,SCHED
 ;
 ; Get the schedule before changing namespace
 S SCHED=$$GETSCHED()
 ;
 ; Determine the BCOM namespace
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
 S BSNAME="GetBYIM",TSC=1
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
 S BONAME="SendBYIM"
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
 ; Apply BYIM production settings
 W !,"Applying BYIM production settings..."
 I $G(FILEPATH)'="" D
 . S SETTINGS(BSNAME,"Adapter","FilePath")=FILEPATH
 . ; The archive directory is up one level then in the 'archive' subdirectory (a peer of the file directory)
 . S @("SETTINGS(BSNAME,""Adapter"",""ArchivePath"")=##class(%File).SubDirectoryName(##class(%File).ParentDirectoryName(FILEPATH),""archive"")")
 S SETTINGS(BSNAME,"Adapter","FileSpec")="izdata*.dat"
 S SETTINGS(BSNAME,"Adapter","CallInterval")="3600"
 S SETTINGS(BSNAME,"Host","TargetConfigNames")=BONAME
 S SETTINGS(BONAME,"Adapter","FTPServer")="cit.ihs.gov"
 S SETTINGS(BONAME,"Adapter","FTPPort")=""  ; Leave as default
 S SETTINGS(BONAME,"Adapter","FilePath")="BYIM\inbound"
 S SETTINGS(BONAME,"Adapter","SSLConfig")="!SFTP"
 S SETTINGS(BONAME,"Host","Filename")="%f"
 S @("TSC=##class(Ens.Production).ApplySettings(PROD,.SETTINGS)")
 I 'TSC D ERR("Unable to apply production settings",$$GETERR(TSC)) Q
 ;
 ; Configure BCOM production
 W !,"Configuring BCOM production..."
 S HN=BSNAME W !,"  ...",HN S TSC=$$SETSCHED(HN,SCHED) I 'TSC D ERR("Unable to configure '"_HN_"'",$$GETERR(TSC))
 S HN="HashCHIT" W !,"  ...",HN S TSC=$$UPDHOST(HN,0,0) I 'TSC D ERR("Unable to configure '"_HN_"'",$$GETERR(TSC))
 F HN="GetCHIT","SendCHIT","SendCHITHash" W !,"  ...",HN S TSC=$$UPDHOST(HN,0) I 'TSC D ERR("Unable to configure '"_HN_"'",$$GETERR(TSC))
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
 ;
 ; Returns a schedule that starts two hours after the task time and
 ; stops one hour before
GETSCHED() ;
 N X,SCHED,FREQ,START,STOP
 S X=$O(^DIC(19,"B","BYIM IZ AUTO EXPORT",0))
 I X="" Q ""
 S X=$O(^DIC(19.2,"B",+X,0))
 I X="" Q ""
 S X=$G(^DIC(19.2,+X,0))
 I X="" Q ""
 S SCHED=$P(X,U,2),FREQ=$P(X,U,6)
 I SCHED="" Q ""
 S SCHED=$P(SCHED,".",2)
 ; Handle imprecise times, including 123 = 12:30, not 12:03 or 1:23
 S SCHED=$E(SCHED_"000000",1,6)
 I FREQ="" S FREQ="1D"
 ; If more frequent than every 4 hours, "start two hours after/stop one hour after"
 ; won't work, so just do the daily schedule
 I FREQ?.N1"H",$P(FREQ,"H")<4 S FREQ="1D"
 S START=SCHED+20000
 S STOP=SCHED-10000
 I FREQ?.N1"H" S STOP=SCHED+($P(FREQ,"H")_"0000")-10000
 F  Q:START<240000  S START=START-240000
 F  Q:STOP'<0  S STOP=STOP+240000
 F  Q:$L(START)>5  S START="0"_START
 F  Q:$L(STOP)>5  S STOP="0"_STOP
 S START=$E(START,1,2)_":"_$E(START,3,4)_":"_$E(START,5,6)
 S STOP=$E(STOP,1,2)_":"_$E(STOP,3,4)_":"_$E(STOP,5,6)
 Q "START:*-*-*T"_START_",STOP:*-*-*T"_STOP
