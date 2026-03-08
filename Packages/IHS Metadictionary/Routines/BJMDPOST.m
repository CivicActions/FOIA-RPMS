BJMDPOST ;VNGT/HS/ALA-Post Install ; 18 Nov 2009  12:51 PM
 ;;1.0;CDA/C32;**1,2,3**;May 27, 2011
 ;
BFMC ;
 S LOAD="BFMC" G EN
BJMD ;
 S LOAD="BJMD"
EN ;
 ; Set up C32 taxonomies
 NEW DIRUT,DIR,DEFDIR,HOST,FILE,DATE,GLOB,Y,USER,STATUS  ; 6/11/12 GCD SCCB-P04144 Added USER and STATUS.
 I $G(DT)="" D DT^DICRW
 I LOAD="BJMD" D ^BJMDTX
 ; The code below removes the BJMD NO LIMIT TAX taxonomy and is currently commented out
 I LOAD="BJMD",0 D
 . NEW X,DIC,DLAYGO,DA,DR,DIE,Y,LTAX,D0,DINUM
 . S DIC="^ATXLAB(",DIC(0)=""
 . S X="BJMD NO LIMIT TAX"
 . D ^DIC
 . I Y'=-1 S DA=+Y,DIK="^ATXLAB(" D ^DIK
 ; 
 ; Set the C Messaging Enabled flag to NO to stop the C Messaging background job.  
 ; Also, clear the "last install" date to let the software know the install is happening
 K DA,DIC,DIE,DR
 S DIE=90607,DA=1,DR=".01///1;.07///N;.08///@"
 ; The BFMC load also clears the "Last Date FM Classes Loaded" field.
 I LOAD="BFMC" S DR=DR_";.1///@"
 D ^DIE
 ; Clear old error text
 S IEN=0 F  S IEN=$O(^BJMDS(90607,1,2,IEN)) Q:'IEN  D
 . K DA S DA=IEN,DA(1)=1,DIK="^BJMDS(90607,1,2," D ^DIK
 ; delete any 90607 records except IEN 1
 S CIEN=1 F  S CIEN=$O(^BJMDS(90607,CIEN)) Q:'CIEN  S DIK="^BJMDS(90607,",DA=CIEN D ^DIK
 ; "Enabled" was set to NO, so make sure that BJMDPUSH and BJMDTSK are not running
 S PRUN=1,CRUN=1
 F I=1:1:121 D  I 'PRUN,'CRUN Q
 . I I=10 W !,"Waiting for current C32 tasks to stop"
 . I 'PRUN,'CRUN Q
 . I PRUN S PRUN=$$CKOPTSCH("BJMD NHIE PUSH JOB")
 . I CRUN S CRUN=$$CKOPTSCH("BJMD BACKGROUND JOB")
 . H 1
 I I=121 D MES^XPDUTL("Could not stop C32 jobs.  Install Aborted") S XPDABORT=1 Q
 ; Check for locks as well if BJMDPAT exists
 S X="BJMDPAT" X ^%ZOSF("TEST")
 I $T I $$LOCK^BJMDPAT("^BJMDTSK")!$$LOCK^BJMDPAT("^BJMDPUSH") D MES^XPDUTL("Could not stop C32 jobs.  Install Aborted") S XPDABORT=1 Q
 ; If possible, stop the production in the Ensemble namespace
 ; First, see if the _SYSTEM user account is active. 6/11/12 GCD SCCB-P04144
 S EXEC="S USER=$Username" X EXEC
 S EXEC="S STATUS=##class(%SYSTEM.Security).Login(""_SYSTEM"")" X EXEC
 S EXEC="D ##class(%SYSTEM.Security).Login(USER)" X EXEC  ; Restore the user's original login.
 I STATUS D  I 1
 . ; 6/08/12 GCD SCCB-P03400 Changed to use CompiledClass.
 . S EXEC="I ##class(%Dictionary.CompiledClass).%ExistsId(""BJMD.Install.PreInstallTask""),$IsObject(##class(%Dictionary.CompiledClass).%OpenId(""BJMD.Install.PreInstallTask"")) S SC=##class(BJMD.Install.PreInstallTask).RunTask()" X EXEC
 E  D
 . D MES^XPDUTL("Could not run pre-install task. Please follow the pre-installation steps in the installation manual before continuing.")
 . W ! S DIR(0)="E",DIR("A")="Press RETURN to continue",DIR("T")=86400 D ^DIR
 S ZTDTH=$G(XPDQUES("POSTDATE"))
 S TRNM=@XPDGREF@("SENT REC"),TRIEN=$O(^BJMDCLS("B",TRNM,""))
 ; If loading BJMD, then load the classes in the foreground
 I LOAD="BJMD" G BKGRND
 ; this should never happen because we are checking this in BJMDENV.  Still...
 ; Job off FM2C conversion, etc
 S ZTRTN="BKGRND^BJMDPOST",ZTDESC="PostProcessing of the KIDS install"
 S ZTIO="" S ZTSAVE("TRIEN")="",ZTSAVE("LOAD")=""
 D ^%ZTLOAD
 Q
CKOPTSCH(OPT) ;
 S OPTIEN=$O(^DIC(19,"B",OPT,"")) I 'OPTIEN Q 0
 S SCHED=$O(^DIC(19.2,"B",OPTIEN,"")) I 'SCHED Q 0
 S TASK=$G(^DIC(19.2,SCHED,1)) I 'TASK Q 0
 I '$D(^%ZTSCH("TASK",TASK)) Q 0
 Q 1
BKGRND ;
 ; Don't run the BFMC post-install job if it is already running. 6/08/12 GCD SCCB-P03213
 ; Don't log an error, because we only care if the one that runs gets an error.
 I LOAD="BFMC" L +^BJMDPOST:1 E  S ERR="BFMC post-installation job is already running" G Q
 ;
 ; Disable transaction processing to avoid filling up the journal when deleting old data. 6/14/12 GCD SCCB-P03205
 I LOAD="BFMC" D
 . S EXEC="S TRNSFUNC=$S($System.Version.GetMajor()<2010:""$$SetTransactionMode^%apiOBJ"",1:""$System.OBJ.SetTransactionMode"")" X EXEC
 . S EXEC="S TRNSMODE="_TRNSFUNC_"(0)" X EXEC
 ;
 ; Delete all BFMC* or BJMD* classes first in case we are regenerating
 ; them after an aborted run
 I $G(LOAD)="" G Q  ; 6/08/12 GCD SCCB-P03213 Added goto.
 ; make sure BFMC is loaded before proceeding with BJMD load.  This should never happen
 ; since we check for this in BJMDECK first.  
 I LOAD="BJMD",'$P(^BJMDS(90607,1,0),U,10) D  G Q  ; 6/08/12 GCD SCCB-P03213 Added goto.
 . S ERR="Fileman classes were not completely loaded when loading C Messaging software" D FGERROR^BJMDCLAS  ; 6/08/12 GCD SCCB-P03461 Report BJMD errors in foreground.
 ;
 ; Delete all the existing Queue records in case the structure has changed,
 ; and clear any existing cached queries for the Queue table.
 ; Do this in the BFMC load so it runs in the background.
 I LOAD="BFMC" D
 . ; 6/08/12 GCD SCCB-P03400 Changed to use CompiledClass.
 . S EXEC="I ##class(%Dictionary.CompiledClass).%ExistsId(""BJMD.Xfer.Queue""),$IsObject(##class(%Dictionary.CompiledClass).%OpenId(""BJMD.Xfer.Queue"")) D ##class(BJMD.Xfer.Queue).%DeleteExtent(0)" X EXEC
 . S EXEC="D $System.SQL.PurgeForTable(""BJMD_Xfer.Queue"")" X EXEC
BKGRND1 ;
 I LOAD="BFMC" S EXEC="DO $SYSTEM.OBJ.DeletePackage(""BFMC"")" X EXEC
 I LOAD="BJMD" S EXEC="DO $SYSTEM.OBJ.DeletePackage(""BJMD"")" X EXEC
 ;
 ; Import BFMC or BJMD classes
 K ERR
 I $G(TRIEN)'="" D IMPORT^BJMDCLAS(TRIEN,.ERR)
 I $G(ERR) G Q  ; 6/08/12 GCD SCCB-P03213 Added goto.
 ;
 ; Run TuneTable to optimize newly generated classes.
 ; 6/13/12 GCD SCCB-P03399 Run TuneTable for BFMC only.
 ; 7/26/12 DMB SCCB-P04984 Some of the FM2C 1.18-generated classes are not being tuned propoerly by 
 ;                         Ensemble 2012 so we are disabling this functionality for now.  The issue
 ;                         seems related to calculated fields which is why it does not impact all tables
 I 0,LOAD="BFMC" D
 . S EXEC="S RS=##class(%ResultSet).%New()" X EXEC
 . S EXEC="S RS.ClassName=""%Dictionary.ClassDefinitionQuery""" X EXEC
 . S EXEC="S RS.QueryName=""ClassIndex""" X EXEC
 . S EXEC="D RS.Execute()" X EXEC
 . S EXEC="F  Q:'(RS.Next(.SC))  I RS.Data(""ClassName"")?1.""BFMC"".E,RS.Data(""SqlTableName"")'="""" D $System.SQL.TuneTable(""BFMC.""_RS.Data(""SqlTableName""),1,1,.MESSAGE)" X EXEC
 ; For now, error messages from TuneTable are not considered real errors,
 ; so the checks are bypassed.
 ; 6/13/12 GCD SCCB-P03399 Added check for error in SC.
 I 0,'SC D
 . S EXEC="D $System.Status.DecomposeStatus(SC,.ERR,""-d"")" X EXEC
 . S ERRTXT="",MESSAGE=$G(MESSAGE)
 . F I=1:1:ERR S ERRTXT=ERRTXT_ERR(I)_" "
 . S ERRTXT=$E(ERRTXT,1,*-1)  ; Strip the trailing space
 . I MESSAGE="" S MESSAGE="ERROR: "_ERRTXT
 . E  S MESSAGE=MESSAGE_" "_ERRTXT
 I 0,$G(MESSAGE)["ERR" D
 . S DIE="^BJMDS(90607,"
 . K DA S DA=1
 . S DR="2////"_$E(MESSAGE,1,239)
 . D ^DIE
 ;
 ; Update the C32 Parameters file with Date/Time Stamp when install completed.
 ; If only BFMC is complete, leave the overall data .08 blank and put BFMC-specific date in .1
 D NOW^%DTC
 S DIE=90607,DA=1,DR=$S(LOAD="BFMC":.1,1:.08)_"////"_%
 D ^DIE
 ;
 ; Clear the Last Push Date/Time Stamp in the C32 Messaging file so the nightly push will regenerate C32s for all patients.
 ; Leave this commented out unless the patch requires re-uploading every patient. 9/06/12 GCD SCCB-5102
 I 0,LOAD="BJMD" S DIE=90606,DA=$O(^BJMDS(90606,"B","C32","")),DR=".02///@" D ^DIE
 ;
 ; BJMD also runs tasks in the Ensemble namespace
 ; If the _SYSTEM account is not active, then the user will have to perform the post-install task's steps manually. 6/11/12 GCD SCCB-P04144
 I LOAD="BJMD" D
 . S EXEC="S USER=$Username" X EXEC
 . S EXEC="S STATUS=##class(%SYSTEM.Security).Login(""_SYSTEM"")" X EXEC
 . S EXEC="D ##class(%SYSTEM.Security).Login(USER)" X EXEC  ; Restore the user's original login.
 . I STATUS S EXEC="S SC=##class(BJMD.Install.PostInstallTask).RunTask()" X EXEC I 1
 . E  D
 . . W !,"Could not run post-install task. Please follow the post-installation steps in the installation manual."
 . . W ! S DIR(0)="E",DIR("A")="Press RETURN to continue",DIR("T")=86400 D ^DIR
Q ;
 I LOAD="BFMC" L -^BJMDPOST  ; 6/08/12 GCD SCCB-P03213 Added unlock.
 ; Restore transaction processing mode. 6/14/12 GCD SCCB-P03205
 I $D(TRNSFUNC),$D(TRNSMODE) S EXEC="I "_TRNSFUNC_"(TRNSMODE)" X EXEC
 Q
