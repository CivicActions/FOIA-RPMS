BUSA1P04 ;GDIT/HS/BEE-BUSA*1.0*4 Environmental Checking and Post Install ; 06 Mar 2013  9:52 AM
 ;;1.0;IHS USER SECURITY AUDIT;**4**;Nov 05, 2013;Build 71
 ;
ENV ;EP - Environmental Checking Routine
 ;
 N VERSION,EXEC,HSV,BMWVSN
 ;
 ; Verify that BMW classes exist and we have the correct version.
 S BMWVSN=$G(^BMW("Version"))
 I BMWVSN="" D BMES^XPDUTL($$CJ^XLFSTR("Cannot retrieve BMW version",IOM)) S XPDQUIT=2 I 1
 E  I BMWVSN<2020.3 D BMES^XPDUTL($$CJ^XLFSTR("BMW version 2020.3 or higher required - installation aborted",IOM)) S XPDQUIT=2
 E  D BMES^XPDUTL($$CJ^XLFSTR("BMW version "_BMWVSN_" installed - *PASS*",IOM))
 ;
 ;Require HealthShare 2017.2.2 or later
 S HSV=0,VERSION=$$VERSION^%ZOSV D
 . NEW V1,V2,V3
 . S V1=$P(VERSION,".")
 . I V1>2017 Q
 . I V1<2017 D FIX(1) S HSV=1 Q
 . S V2=$P(VERSION,".",2)
 . I V2>2 Q
 . I V2<2 D FIX(1) S HSV=1 Q
 . S V3=$P(VERSION,".",3)
 . I V3>1 Q
 . D FIX(1) S HSV=1
 ;
 I HSV=0 D BMES^XPDUTL($$CJ^XLFSTR("Health Share v2017.2.2 or greater has been installed - *PASS*",IOM)) I 1
 E  S XPDQUIT=2
 ;
 ;Check for EHR patch 31
 I '$$INSTALLD("BEHO*1.1*070003","EHR*1.1*31") D BMES^XPDUTL("Version 1.1 Patch 31 of EHR is required!") S XPDQUIT=2 Q
 ;
 ;Check for XU*8.0*1020
 I '$$INSTALLD("XU*8.0*1020") D BMES^XPDUTL("Version 8.0 Patch 1020 of XU is required!") S XPDQUIT=2 Q
 ;
 ;Check for DI*2.2*1020
 I '$$INSTALLD("DI*22.0*1020") D BMES^XPDUTL("Version 22.0 Patch 1020 of DI is required!") S XPDQUIT=2 Q
 ;
 ;Check for XT*7.3*1019
 I '$$INSTALLD("XT*7.3*1019") D BMES^XPDUTL("Version 7.3 Patch 1019 of XT is required!") S XPDQUIT=2 Q
 ;
 ;Check for BUSA*1.0*3
 I '$$INSTALLD("BUSA*1.0*3") D FIX(2) S XPDQUIT=2
 ;
 Q
 ;
PRE ;EP - Preinstallation
 ;
 ;Reset some transport files data
 NEW II,DA,DIK
 ;
 S II=0 F  S II=$O(^BUSACLS(II)) Q:'II  S DA=II,DIK="^BUSACLS(" D ^DIK
 ;
 Q
 ;
POS ;EP - Post Installation Code
 ;
 ;Compile class process
 ;
 N TRIEN,EXEC,ERR,CURR,TYP,ZTDTH,ZTDESC,ZTRTN,ZTIO,ZTSAVE,ZTSK,X1,X2,X,%,Y,DIR,DTOUT,DUOUT,DIRUT,DIROUT
 ;
 ;For each build, set this to the 9002319.05 entry to load
 S TRIEN=1
 ;
 ; Import BUSA classes
 K ERR
 I $G(TRIEN)'="" D IMPORT^BUSACLAS(TRIEN,.ERR)
 I $G(ERR) Q
 ;
 ;Get future date
 S X1=DT,X2=60 D C^%DTC
 ;
 ;Get NOW
 D NOW^%DTC
 ;
 ;Set up temporary global
 S ^XTMP("BUSAAGMP",0)=X_U_DT_U_"BUSA Version 1.0 Patch 4 AGMP Remediation"
 ;
 ;Prompt for approved reporting tool users
 D RUSER^BUSAOPT
 ;
 ;Check for AGMP (MPI) cleanup
 W !!,"Special process to clean up invalid ADT/HL7 PIVOT (#391.71) file entries"
 W !!,"At a number of sites a problem within AGMP logic has caused an extensive"
 W !,"number of invalid BUSA Summary file records to be created because of"
 W !,"invalid entries in the ADT/HL7 PIVOT (#391.71) file. This problem has"
 W !,"often caused the BUSA cache.dat database size to grow at an exponential"
 W !,"rate. BSTS version 1.0 Patch 4 contains a utility that will search"
 W !,"through the BUSA AUDIT LOG SUMMARY file, locate the invalid records"
 W !,"and remove them. It will then create a new BUSA Remediation entry so"
 W !,"that the removed records will not show up as missing in the EPCS incident"
 W !,"reports. If enough records are removed, you may want to consider compacting"
 W !,"and truncating your BUSA cache.dat database to free up space. It is"
 W !,"recommended that you contact the help desk for assistance in completing the"
 W !,"compact and truncate process.",!
 W !,"When the process completes, any user holding the BUSAZMGR key will receive"
 W !,"a MailMan message detailing the results of the operation."
 W !!,"SINCE THIS PROCESS HAS THE POTENTIAL TO REMOVE A LARGE NUMBER OF RECORDS"
 W !,"FROM THE SYSTEM, A CONSIDERABLE AMOUNT OF JOURNAL SPACE MAY BE REQUIRED"
 W !,"TO PERFORM THIS OPERATION. BEFORE RUNNING THIS PROCESS, PLEASE MAKE SURE"
 W !,"THAT ADEQUATE FREE JOURNAL SPACE IS AVAILABLE. IN ADDITION, WHILE THE"
 W !,"PROCESS IS RUNNING, THE AVAILABLE JOURNAL FREE SPACE SHOULD BE PERIODICALLY"
 W !,"MONITORED. AS AN ADDED SAFEGUARD, TO PREVENT JOURNAL FREE SPACE FROM"
 W !,"BECOMING TOO LOW, IF A RUNNING BACKGROUND PROCESS CONSUMES TOO MUCH JOURNAL"
 W !,"FREE SPACE, IT WILL STOP THE PROCESS AND RESCHEDULE IT TO CONTINUE AT 6:00"
 W !,"AM THE FOLLOWING DAY. THE PROCESS WILL CONTINUE TO RESCHEDULE ITSELF DAILY"
 W !,"UNTIL ALL OF THE INVALID BUSA ENTRIES HAVE BEEN REMOVED."
 W !!,"*Note - if you do not wish to run the process now, it can be run in the"
 W !,"future by going to the programmers prompt and entering the following:"
 W !,"D TSKAGMP^BUSA1P04",!
 S DIR("A")="Would you like to kick off the background process now to clean up the invalid AGMP entries"
 S DIR(0)="Y",DIR("B")="NO"
 D ^DIR
 ;
 ;Job off task to remove AGMP entries and set up remediation entry
 I $G(Y)=1 D
 . D BMES^XPDUTL("Kicking off background process to clean up BUSA Summary AGMPI records")
 . ;
 . D TSKAGMP
 E  D
 . W !!,"*You have chosen not to run the AGMP background cleanup process at this time*"
 . W !!,"Remember that the process can still be run (as often as desired) by going"
 . W !,"into programmer mode and typing the following:"
 . W !,"D TSKAGMP^BUSA1P04" H 5
 ;
 Q
 ;
TSKAGMP(RESCHED) ;
 N %
 ;
 S RESCHED=+$G(RESCHED)
 ;
 D NOW^%DTC
 S ZTIO=""
 S ZTRTN="AGMP^BUSA1P04",ZTDESC="BUSA - Remediate AGMP entries"
 I RESCHED S ZTDTH=$$FMADD^XLFDT($P($$NOW^XLFDT,".")_".0600",1) ;Retask for 6:00 AM tomorrow
 ;I RESCHED S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,5) ;For testing - RETASK FOR 5 MINUTES FROM NOW
 I 'RESCHED S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,1)
 D ^%ZTLOAD
 ;
 ;Set the task
 I $G(ZTSK)]"" S ^XTMP("BUSAAGMP","TASK",ZTSK)=DUZ_U_%
 ;
 Q
 ;
AGMP ;Remove AGMP entries and set up remediation entry
 ;
 NEW BUSASIEN,X,X1,X2,FAGMP,LAGMP,ID,DATEH,AGMPCT,RECS
 NEW EXEC,JSIZE,MSIZE,SMAX,CJSIZE
 ;
 ;Get the journal size
 S JSIZE="" S EXEC="S JSIZE=##CLASS(%SYS.Journal.System).GetFreeSpace()" X EXEC
 ;
 ;Minimum Size - Only use up to 50% of the available journal space
 S MSIZE=(JSIZE*.5)\1 Q:'MSIZE
 ;S MSIZE=(JSIZE*.999)\1 Q:'MSIZE  ;For testing - Quit if 99.9% free space reached
 ;
 ;Get future date
 S X1=DT,X2=60 D C^%DTC
 ;
 ;Set up temporary global
 S ^XTMP("BUSAAGMP",0)=X_U_DT_U_"BUSA Version 1.0 Patch 4 AGMP Remediation"
 ;
 S (FAGMP,LAGMP)=""
 S (SMAX,RECS,AGMPCT)=0
 S BUSASIEN=0 F  S BUSASIEN=$O(^BUSAS(BUSASIEN)) Q:'BUSASIEN  D  Q:SMAX
 . ;
 . NEW DESC,DA,DIK
 . ;
 . ;Pull description
 . S DESC=$G(^BUSAS(BUSASIEN,1))
 . ;
 . ;Check for AGMP
 . I DESC["AGMP MPI ERROR PTS" D
 .. ;
 .. ;Update first/last entry
 .. S:FAGMP="" FAGMP=BUSASIEN
 .. S LAGMP=BUSASIEN
 .. ;
 .. ;Save entry
 .. S ^XTMP("BUSAAGMP",+$G(ZTSK),BUSASIEN)=$G(ZTSK)
 .. ;
 .. ;Remove entry
 .. S DIK="^BUSAS(",DA=BUSASIEN D ^DIK
 .. ;
 .. ;Increment counter
 .. S AGMPCT=AGMPCT+1
 .. ;
 .. ;Check journal size to see if minimum journal has been reached
 .. I AGMPCT#100000=0 D
 ... S CJSIZE="" S EXEC="S CJSIZE=##CLASS(%SYS.Journal.System).GetFreeSpace()" X EXEC
 ... I CJSIZE<MSIZE S SMAX=1
 ;
 ;Set up BUSA Remediation entry
 I FAGMP'="",LAGMP'="" D
 . ;
 . NEW EXEC,RM,USER,STS
 . ;
 . ;Get now
 . S EXEC="S DATEH=$ZDT($H,3,1)" X EXEC
 . ;
 . ;Create new entry
 . S EXEC="S RM=##CLASS(BUSA.Remediation.Records).%New()" X EXEC
 . ;
 . ;Get user
 . S USER=$P($G(^XTMP("BUSAAGMP","TASK",+$G(ZTSK))),U)
 . S:USER="" USER=DUZ
 . S USER=$$GET1^DIQ(200,USER_",",.01)
 . ;
 . ;Type
 . S EXEC="I $ISOBJECT(RM) S RM.Type=""BUSAS Entry - Missing""" X EXEC
 . ;
 . ;RemediatedRecords
 . S EXEC="I $ISOBJECT(RM) S RM.RemediatedRecords=FAGMP_"":""_LAGMP" X EXEC
 . ;
 . ;Reason
 . S EXEC="I $ISOBJECT(RM) S RM.Reason=""BUSA v1.0 Patch 4 post install - Remediation for invalid AGMP entries""" X EXEC
 . ;
 . ;Save
 . S STS=0
 . S EXEC="I $ISOBJECT(RM) S STS=RM.%Save()" X EXEC
 . ;
 . ;Create Record History
 . S ID=""
 . I STS S EXEC="S ID=RM.%Id()" X EXEC
 . I STS,ID S EXEC="S STSH=##CLASS(BUSA.RemediationUtility).UpdateRecord(ID,DATEH,USER,0,"""",1)" X EXEC
 . I STS,ID S EXEC="S STSH=##CLASS(BUSA.RemediationUtility).VerifyRecord(ID,DATEH,USER,1)" X EXEC
 . ;
 . ;Create BUSA entry
 . I STS,ID D
 .. NEW TYPE,REAS
 .. S (TYPE,REAS,RECS)=""
 .. S EXEC="I $ISOBJECT(RM) S TYPE=RM.Type,REAS=RM.Reason,RECS=RM.RemediatedRecords" X EXEC
 .. I TYPE]"" D LOG^BUSAUTL1(DUZ,"S","","BUSA1P04","BUSA: Created remediation entry - Type: "_TYPE_" Record: "_RECS_" Reason: "_REAS_"|TYPE~L|RSLT~S||||BUSA200","")
 ;
 ;Generate notification email
 D EMAIL($G(RECS),$G(AGMPCT))
 ;
 ;Define entry
 I $G(ZTSK)]"" S $P(^XTMP("BUSAAGMP","TASK",ZTSK),U,3,7)=FAGMP_U_LAGMP_U_$G(ID)_U_$G(DATEH)_U_AGMPCT_U_$G(JSIZE)_U_$G(MSIZE)_U_$G(CJSIZE)_U_$G(SMAX)
 ;
 ;If minimum journal space reached, reschedule
 I $G(SMAX)=1 D TSKAGMP(1)
 ;
 Q
 ;
CHECK ;This tag will count the number of invalid BUSA AGMP records present
 ;
 NEW BUSASIEN,DESC,COUNT,CT
 ;
 W !!,"Counting the number of invalid BUSA AGMP records in the database"
 W !!,"This process might take some time to run",!
 ;
 S (CT,COUNT,BUSASIEN)=0 F  S BUSASIEN=$O(^BUSAS(BUSASIEN)) Q:'BUSASIEN  D
 . ;
 . ;Pull description
 . S DESC=$G(^BUSAS(BUSASIEN,1))
 . ;
 . ;Check for AGMP
 . I DESC["AGMP MPI ERROR PTS" S COUNT=COUNT+1
 . ;
 . ;Display progress
 . S CT=CT+1 I CT#100000=0 W "."
 ;
 W !!,"Number of invalid BUSA AGMP records located: ",COUNT
 ;
 Q
 ;
EMAIL(RECS,AGMPCT) ;Generate notification email
 ;
 NEW NOW,XLINE,BODY,XMTEXT,XMSUB,XMY,TO,NAME
 ;
 S NOW=$$UP^XLFSTR($$HTE^XLFDT($H)),NOW=$P(NOW,"@",1)_"  "_$P($P(NOW,"@",2),":",1,2)
 ;
 S XLINE=0
 S XLINE=XLINE+1,BODY(XLINE)="The background process kicked off by the BUSA version 1.0 patch 4 post"
 S XLINE=XLINE+1,BODY(XLINE)="installation has completed. The process looked for entries in the BUSA"
 S XLINE=XLINE+1,BODY(XLINE)="AUDIT LOG SUMMARY file which were created because of invalid entries"
 S XLINE=XLINE+1,BODY(XLINE)="in the ADT/HL7 PIVOT (#391.71) file. These entries were added because"
 S XLINE=XLINE+1,BODY(XLINE)="of an issue with the AGMP logic. For any such entries found, the"
 S XLINE=XLINE+1,BODY(XLINE)="entries were removed from the BUSA file and a BUSA Remediation"
 S XLINE=XLINE+1,BODY(XLINE)="was created to document the removed entries. If a significant number"
 S XLINE=XLINE+1,BODY(XLINE)="of entries were found and there is an interest in reducing the size"
 S XLINE=XLINE+1,BODY(XLINE)="the database can then be compacted and truncated to free up space."
 S XLINE=XLINE+1,BODY(XLINE)="It is recommended that the help desk is contacted for assistance"
 S XLINE=XLINE+1,BODY(XLINE)="on completing this process."
 S XLINE=XLINE+1,BODY(XLINE)=" "
 S XLINE=XLINE+1,BODY(XLINE)="The background process found and removed "_+$G(AGMPCT)_" records."
 I +$G(AGMPCT)>0 S XLINE=XLINE+1,BODY(XLINE)="A BUSA remediation entry was set up for the range: "_$G(RECS)
 S XMTEXT="BODY("
 ;
 ;Assemble TO list
 S TO="" F  S TO=$O(^XUSEC("BUSAZMGR",TO)) Q:TO=""  S NAME=$$GET1^DIQ(200,TO_",",.01),XMY(NAME)=""
 ;
 ;Subject Line
 S XMSUB="BUSA v1.0 Patch 4 post installation background process summary"
 ;
 ;Send message
 D ^XMD
 ;
 Q
 ;
INSTALLD(BUSASTAL,PATCH) ;EP - Determine if patch BUSASTAL was installed, where
 ; BUSASTAL is the name of the INSTALL.  E.g "BUSA*1.0*3"
 ;
 NEW BUSAY,INST
 ;
 S BUSAY=$O(^XPD(9.7,"B",BUSASTAL,""))
 S INST=$S(BUSAY>0:1,1:0)
 D IMES(BUSASTAL,INST)
 Q INST
 ;
IMES(BUSASTAL,Y) ;Display message to screen
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_$S($G(PATCH)]"":PATCH,1:BUSASTAL)_""" is"_$S(Y<1:" *NOT*",1:"")_" installed"_$S(Y<1:"",1:" - *PASS*"),IOM))
 Q
 ;
FIX(X) ;
 NEW MSG
 KILL DIFQ
 ;
 S MSG="HealthShare 2017.2.2 or later is required - installation aborted"
 I X=2 S MSG="This patch must be installed prior to the installation of BUSA*1.0*3"
 W *7,!,$$CJ^XLFSTR(MSG,IOM)
 Q
