BSTSVOFL ;GDIT/HS/BEE-Standard Terminology Version/Update Overflow Routine ; 5 Nov 2012  9:53 AM
 ;;2.0;IHS STANDARD TERMINOLOGY;**1,3,8**;Dec 01, 2016;Build 27
 ;
 Q
 ;
FPARMS() ;Return the version/update failover parameters
 ;
 ;This tag returns failover parameter values for the web service call
 ;with the highest priority in BSTS SITE PARAMETERS file
 ;
 NEW SITE,SIEN,MFAIL,FWAIT,FOUND,BSTSWS
 ;
 ;Start with defaults
 S MFAIL=10,FWAIT=7200
 S (FOUND,SITE)=0 F  S SITE=$O(^BSTS(9002318,SITE)) Q:'SITE  S SIEN=0 F  S SIEN=$O(^BSTS(9002318,SITE,1,SIEN)) Q:'SIEN  D  I FOUND Q
 . NEW WIEN,IENS,DA
 . ;
 . ;Get pointer to web service entry
 . S DA(1)=SITE,DA=SIEN,IENS=$$IENS^DILF(.DA)
 . S WIEN=$$GET1^DIQ(9002318.01,IENS,".01","I") Q:WIEN=""
 . ;
 . ;Pull parameter values
 . S MFAIL=$$GET1^DIQ(9002318.2,WIEN_",","4.02","E") S:MFAIL="" MFAIL=10
 . S FWAIT=$$GET1^DIQ(9002318.2,WIEN_",","4.03","E") S:FWAIT="" FWAIT=7200
 . S FOUND=1
 ;
 Q MFAIL_U_FWAIT
 ;
NVLKP(MFAIL,FWAIT) ;Process NDC and VUID lookups - called by BSTSVRSN
 ;
 NEW ITEM,STS,ABORT,ENTRY,NV,NITEM,VITEM,DITEM
 ;
 S (NITEM,VITEM,DITEM)=0
 S STS=1
 ;
 S ENTRY=$P($G(^XTMP("BSTSLCMP","UPD")),U,7)
 S NV=$S(ENTRY]"":$E(ENTRY,1),1:"")
 S:NV="V" VITEM=+$E(ENTRY,2,999)
 S:NV="N" NITEM=+$E(ENTRY,2,999)
 S:NV="D" DITEM=+$E(ENTRY,2,999)
 ;
 ;ReLoad VUID
 I (NV="V")!(NV="") S ABORT=0,ITEM=VITEM F  S ITEM=$O(^PSNDF(50.68,ITEM)) Q:'ITEM  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 . NEW VUID,VAR,FCNT,TRY
 . S VUID=$P($G(^PSNDF(50.68,ITEM,"VUID")),U) I VUID="" D TRK("V",ITEM) Q
 . S ^XTMP("BSTSLCMP","STS")="Refreshing VUID entry: "_VUID
 . ;
 . ;Retrieve from server - Hang max of 12 times
 . S (FCNT,STS)=0 F TRY=1:1:(12*MFAIL) D  I +STS=2!(STS="0^")!($D(^XTMP("BSTSLCMP","QUIT"))) Q
 .. D RESET^BSTSWSV1 ;Make sure link is on
 .. S STS=$$DILKP^BSTSAPI("VAR",VUID_"^V^2^^1") I +STS=2!(STS="0^")!($D(^XTMP("BSTSLCMP","QUIT"))) Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL(MFAIL,FWAIT,TRY,"NVLKP^BSTSVOFL - VUID: "_VUID)
 ... I ABORT=1 S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("SUBSET REFRESH FAILED ON VUID LOOKUP: "_VUID)
 ... S FCNT=0
 . I '$D(^XTMP("BSTSLCMP","QUIT")) D TRK("V",ITEM)
 ;
 ;Check for failure
 I $D(^XTMP("BSTSLCMP","QUIT")) Q 0
 ;
 ;Load NDC values
 I (NV'="D") S STS=1,ITEM=NITEM F  S ITEM=$O(^PSNDF(50.68,ITEM)) Q:'ITEM  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 . NEW NDC,VAR,FCNT,TRY
 . S NDC=$P($G(^PSNDF(50.68,ITEM,1)),U,7) I NDC="" D TRK("N",ITEM) Q
 . I $L(NDC)>11,$E(NDC,1)="0" S NDC=$E(NDC,2,99)
 . S ^XTMP("BSTSLCMP","STS")="Refreshing NDC entry: "_NDC
 . ;
 . ;Retrieve from server - Hang max 12 times
 . S (FCNT,STS)=0 F TRY=1:1:(12*MFAIL) D  I +STS=2!(STS="0^")!($D(^XTMP("BSTSLCMP","QUIT"))) Q
 .. D RESET^BSTSWSV1 ;Make sure link is on
 .. S STS=$$DILKP^BSTSAPI("VAR",NDC_"^N^2^^1") I +STS=2!(STS="0^")!($D(^XTMP("BSTSLCMP","QUIT"))) Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL(MFAIL,FWAIT,TRY,"NVLKP^BSTSVOFL - NDC: "_NDC)
 ... S ABORT=1 S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("SUBSET REFRESH FAILED ON NDC LOOKUP: "_NDC)
 ... S FCNT=0 ;Fail handling
 . I '$D(^XTMP("BSTSLCMP","QUIT")) D TRK("N",ITEM)
 ;
 ;Check for failure
 I $D(^XTMP("BSTSLCMP","QUIT")) Q 0
 ;
 ;Process ORDERABLE ITEM
 S STS=$$DNDC^BSTSVUP0(DITEM,FWAIT,MFAIL)
 ;
 ;Check for failure
 I $D(^XTMP("BSTSLCMP","QUIT"))!(STS=0) Q 0
 ;
 Q 1
 ;
TRK(TYPE,IEN) ;
 ;
 S $P(^XTMP("BSTSLCMP","UPD"),U,7)=TYPE_IEN
 ;
 Q
 ;
SBRSET ;EP - BSTS REFRESH SUBSETS option
 ;
 ;Called from BSTSVRSN
 ;
 NEW II,NMID,NMIEN,BSTS,ERR,DIR,X,Y,DIC,CONC,CNT,DLAYGO,DTOUT,DUOUT,DIROUT,DIRUT,SBNAME
 ;
 W !!,"This option allows sites to manually refresh IHS Standard Terminology (BSTS)"
 W !,"information cached locally at the site. Using this option, the subsets"
 W !,"associated with the 'SNOMED with US Extensions' codeset can be refreshed with"
 W !,"up to date information retrieved from the Apelon DTS server. This option also"
 W !,"allows custom codeset mappings to be refreshed with current mappings available"
 W !,"through DTS."
 ;
 I +$O(^XTMP("BSTSPROCQ",0)) D
 . W !!,"There are currently update processes queued to run. These processes will run"
 . W !,"before this process starts.",!
 ;
 S DIR("A")="Are you sure you want to do this"
 S DIR("B")="NO"
 S DIR(0)="Y"
 D ^DIR I $D(DIRUT) Q
 I '+Y Q
 ;
 S DIR("A")="Select the subset/mapping to refresh"
 S DIR(0)="SO^"
 S DIR(0)=DIR(0)_"36:SNOMED CT US Extension Subsets"
 S DIR(0)=DIR(0)_";1552:RxNorm Subsets"
 S DIR(0)=DIR(0)_";32771:IHS VANDF"
 S DIR(0)=DIR(0)_";32772:GMRA Signs Symptoms"
 S DIR(0)=DIR(0)_";32773:GMRA Allergies with Maps"
 S DIR(0)=DIR(0)_";32774:IHS Med Route"
 S DIR(0)=DIR(0)_";32775:CPT Meds with Maps"
 S DIR(0)=DIR(0)_";32777:SNOMED CT ICD-10 Auto and Conditional Mappings and Equivalencies"
 ;S DIR(0)=DIR(0)_";32778:SNOMED CT to ICD-9-CM Auto-Codeables"
 ;
 S DIR("B")="SNOMED CT US Extension Subsets"
 ;
 D ^DIR I $D(DIRUT) Q
 S NMID=+Y
 ;
 ;Retrieve codeset
 S NMIEN=$O(^BSTS(9002318.1,"B",NMID,"")) Q:NMIEN=""
 ;
 ;Only one SNOMED background process can be running at a time
 L +^BSTS(9002318.1,0):0 E  W !!,"A Local Cache Refresh is Already Running. Please Try Later" H 3 Q
 L -^BSTS(9002318.1,0)
 ;
 ;Make sure ICD9 to SNOMED background process isn't running
 L +^TMP("BSTSICD2SMD"):0 E  W !!,"An ICD9 to SNOMED Background Process is Already Running. Please Try Later" H 3 Q
 L -^TMP("BSTSICD2SMD")
 ;
 S SBNAME=""
 I NMID=36 S SBNAME=$$ASKSB^BSTSVOF1() I SBNAME="-1" W !!,"Process aborted!" H 3 Q
 ;
 S DIR("A")="Start the process"
 S DIR("B")="NO"
 S DIR(0)="Y"
 D ^DIR I $D(DIRUT) Q
 I '+Y Q
 ;
 ;Remove LAST SUBSET CHECK date or LAST VERSION CHECK date
CALL I (NMID=1552)!(NMID=36) S:((SBNAME="")!(SBNAME="ALL")) BSTS(9002318.1,NMIEN_",",.1)="@" I 1
 E  S BSTS(9002318.1,NMIEN_",",.05)="@"
 I $D(BSTS)'<10 D FILE^DIE("","BSTS","ERR")
 ;
 I NMID=36 D  I 1  ;Subsets
 . I SBNAME="ALL" D QUEUE^BSTSVOFL(NMID) ;D SCHK^BSTSVRSN(NMID) Q  ;Process all
 . D ISCHK^BSTSVOF1(SBNAME) ;Process one subset
 E  I NMID=1552 D QUEUE^BSTSVOFL(NMID) I 1 ;D SCHK^BSTSVRXN(NMID) I 1
 E  I NMID=32777 D QUEUE^BSTSVOFL(NMID) I 1 ;D ACHK^BSTSVRSC(NMID) I 1 ;'36' Auto-codeable ICD-10s
 E  I NMID=32778 ;D A9CHK^BSTSVRSC(NMID) I 1 ;'36' Auto-codeable ICD-9s - Not in use
 E  D QUEUE^BSTSVOFL(NMID) ;D CCHK^BSTSVRSC(NMID) ;Custom codesets
 H 2
 ;
 ;Log call
 NEW QUEUE,%
 D NOW^%DTC
 L +^XTMP("BSTSPROCQ","M"):1 E  Q
 S (QUEUE,^XTMP("BSTSPROCQ","M"))=$G(^XTMP("BSTSPROCQ","M"))+1
 S ^XTMP("BSTSPROCQ","M",QUEUE)=%_U_$$GET1^DIQ(200,DUZ_",",.01,"E")_U_"Kicked off manual refresh of: "_NMID
 S ^XTMP("BSTSPROCQ","M","B",NMID,QUEUE)=""
 S ^XTMP("BSTSPROCQ","M","D",%,QUEUE)=""
 L -^XTMP("BSTSPROCQ","M")
 ;
 ;Kick off the call
 D START^BSTSSTA
 ;
 Q
 ;
FAIL(MFAIL,FWAIT,TRY,MESSAGE) ;DTS Connection/Error Handling
 ;
 I $G(TRY)<1 Q 0
 I +$G(MFAIL)=0 S MFAIL=10
 I +$G(FWAIT)=0 S FWAIT=7200
 S MESSAGE=$G(MESSAGE)
 ;
 NEW HFATMPT,EXEC
 ;
 S HFATMPT=TRY\MFAIL
 ;
 ;If reached maximum log error
 I HFATMPT'<12 D  Q 1
 . NEW %ERROR,%MESSAGE,IEN,IENS,DA
 . S EXEC="S $"_"ZE=""<DTS CONNECTION ERROR - Contact BSTS Support>""" X EXEC
 . S %ERROR="Your DTS Connection is not working properly. Please log a HEAT ticket with the BSTS Support Group"
 . S %MESSAGE=MESSAGE
 . D ^ZTER
 ;
 ;Log entry
 D ELOG(MESSAGE)
 ;
 ;For first 6 tries-only hang for 5 minutes
 I HFATMPT<7 H 300
 E  H FWAIT
 ;
 Q 0
 ;
ELOG(MSG) ;Log entry in web service log
 ;
 ;Input: MSG
 ;       BSTSWS Array may also be defined
 ;
 S MSG=$G(MSG)
 ;
 NEW IEN,DA,X,BSTSUP,ERROR,Y,DLAYGO,DIC,%
 ;
 ;Get IEN of web service entry
 S IEN=$G(BSTSWS("IEN"))
 I IEN="" D
 . NEW SITE,SIEN
 . S SITE=0 F  S SITE=$O(^BSTS(9002318,SITE)) Q:'SITE  S SIEN=0 F  S SIEN=$O(^BSTS(9002318,SITE,1,SIEN)) Q:'SIEN  D  Q:IEN
 .. NEW IENS,DA
 .. ;
 .. ;Get pointer to web service entry
 .. S DA(1)=SITE,DA=SIEN,IENS=$$IENS^DILF(.DA)
 .. S IEN=$$GET1^DIQ(9002318.01,IENS,".01","I")
 I IEN="" Q
 ;
 ;Create new
 D NOW^%DTC
 S DIC(0)="L",DA(1)=IEN
 S DIC="^BSTS(9002318.2,"_DA(1)_",5,"
 L +^BSTS(9002318.2,IEN,5,0):1 E  Q
 S X=%
 S DLAYGO=9002318.25
 K DO,DD D FILE^DICN
 L -^BSTS(9002318.2,IEN,5,0)
 I +Y<0 Q
 ;
 ;File
 I MSG="" Q
 S MSG=$TR(MSG,"^","~")
 S DA=+Y,IENS=$$IENS^DILF(.DA)
 S BSTSUP(9002318.25,IENS,".02")=$E(MSG,1,229)
 D FILE^DIE("","BSTSUP","ERROR")
 ;
 Q
 ;
 ;Background processing
QUEUE(TYPE) ;Schedule Background process
 ;
 NEW TAGRTN,NMIEN,NMID,ZTSK,FIELD,ONMIEN
 ;
 ;Determine process
 S ONMIEN=""
 ;GDIT/HS/BEE;FEATURE#123647;Added CVX
 I TYPE=32778 S TAGRTN="A9CODE^BSTSVRSC",NMID=32778
 E  I TYPE=32777 S TAGRTN="ACODE^BSTSVRSC",NMID=32777
 E  I TYPE=32779 S TAGRTN="ACODE^BSTSVRSC",NMID=32777,ONMIEN=32779  ;BSTS*1.0*6;Added conditionals
 E  I TYPE=32780 S TAGRTN="ACODE^BSTSVRSC",NMID=32777,ONMIEN=32780  ;BSTS*1.0*7;Added equivalents
 E  I TYPE="S36" S TAGRTN="SUB^BSTSVRSN",NMID=36
 E  I TYPE="S1552" S TAGRTN="SUB^BSTSVRXN",NMID=1552
 E  I TYPE=36 S TAGRTN="RES^BSTSVRSN:"_TYPE,NMID=36
 E  I TYPE=5180 S TAGRTN="RES^BSTSVRSN:"_TYPE,NMID=5180
 E  I TYPE=1552 S TAGRTN="RES^BSTSVRSN:"_TYPE,NMID=1552
 E  I TYPE=5190 S TAGRTN="RES^BSTSVRSN:"_TYPE,NMID=5190
 E  I TYPE="ICD" S TAGRTN="JOB^BSTSUTIL",NMID=36
 E  I TYPE="PRG" S TAGRTN="EPURGE^BSTSVOFL",NMID=36
 E  I TYPE="STS" S TAGRTN="STATUS^BSTSAPIL",NMID=36
 E  I TYPE=32781 S TAGRTN="RES^BSTSVRSN:1552",NMID=1552,ONMIEN=32781
 E  I TYPE=32782 S TAGRTN="RES^BSTSVRSN:5190",NMID=5190,ONMIEN=32782
 E  I TYPE=32783 S TAGRTN="RES^BSTSVRSN:36",NMID=36,ONMIEN=32783
 E  I TYPE'="PRG",TYPE'="S36",TYPE'="S1552",TYPE'="ICD",TYPE'=32779,TYPE'=32780,TYPE'=32778,TYPE'=32777,TYPE'=36,TYPE'=5180,TYPE'=1552,TYPE'=5190 S TAGRTN="CDST^BSTSVRSC:"_TYPE,NMID=TYPE
 E  Q
 ;
 ;Get NMIEN,ONMIEN
 S NMIEN=$O(^BSTS(9002318.1,"B",NMID,"")) Q:NMIEN=""
 I ONMIEN]"" S ONMIEN=$O(^BSTS(9002318.1,"B",ONMIEN,"")) Q:ONMIEN=""
 ;
 ;Update LAST VERSION CHECK now so process won't keep getting called
 S FIELD=$S(TYPE="S1552":".06",TYPE="S36":".06",TYPE="PRG":"",TYPE="ICD":"",1:".05") I FIELD]"" D
 . NEW BSTS,ERROR
 . S ONMIEN=$S(ONMIEN]"":ONMIEN,1:NMIEN)
 . S BSTS(9002318.1,ONMIEN_",",FIELD)=DT
 . D FILE^DIE("","BSTS","ERROR")
 ;
 ;Quit if already scheduled
 I $D(^XTMP("BSTSPROCQ","B",TAGRTN)) Q
 I TAGRTN="RES^BSTSVRSN:36",$D(^XTMP("BSTSPROCQ","B","ACODE^BSTSVRSC")) Q
 I TAGRTN="ACODE^BSTSVRSC",$D(^XTMP("BSTSPROCQ","B","RES^BSTSVRSN:36")) Q
 ;
 ;Put entry in queue
 D QENTRY(TAGRTN,NMIEN,TYPE)
 ;
 ;Job off process (if not already scheduled)
 I '$$PSCHD^BSTSVOF1("BSTSVOFL") S ZTSK=$$JOB()
 ;
 ;Update SMD2ICD9 with task
 I TYPE="ICD",+$G(ZTSK)>0 D
 . NEW BSTS,ERROR
 . S BSTS(9002318.1,NMIEN_",",".09")=$G(ZTSK)
 . D FILE^DIE("","BSTS","ERROR")
 ;
 Q
 ;
QENTRY(TAGRTN,NMIEN,TYPE) ;Put entry in queue
 ;
 NEW NEXT,X1,X2,X,%
 ;
 ;Get future date for ^XTMP
 S X1=DT,X2=60 D C^%DTC
 ;
 ;Update top level
 S ^XTMP("BSTSPROCQ",0)=X_U_DT_U_"BSTS Background Process Queue"
 ;
 D NOW^%DTC
 ;
 ;Get next pointer
 L +^XTMP("BSTSPROCQ","CTR"):1 E  Q
 S (NEXT,^XTMP("BSTSPROCQ","CTR"))=$G(^XTMP("BSTSPROCQ","CTR"))+1
 S ^XTMP("BSTSPROCQ",NEXT,"RTN")=TAGRTN
 S ^XTMP("BSTSPROCQ",NEXT,"NMIEN")=NMIEN
 S ^XTMP("BSTSPROCQ",NEXT,"TYPE")=TYPE
 S ^XTMP("BSTSPROCQ",NEXT,"SCHED")=%
 S ^XTMP("BSTSPROCQ","B",TAGRTN,NEXT)=""
 L -^XTMP("BSTSPROCQ","CTR")
 Q
 ;
JOB(DTIME,OVR) ;Job off background process
 NEW ZTDTH,ZTDESC,ZTRTN,ZTIO,ZTSAVE,ZTSK,BSTSOVR
 ;
 ;Handle start override
 I +$G(OVR) S BSTSOVR=1,ZTSAVE("BSTSOVR")=""
 ;
 S ZTIO=""
 S ZTRTN="PROC^BSTSVOFL",ZTDESC="BSTS - Background Process Handling"
 I $G(DTIME)]"" S ZTDTH=DTIME
 I $G(DTIME)="" D
 . S ZTDTH=$$JBTIME^BSTSUTL0(1)  ;Job off the process
 D ^%ZTLOAD
 ;
 Q $G(ZTSK)
 ;
JOBNOW ;Job off background process now
 NEW ZTSK
 S ZTSK=$$JOB($$FMADD^XLFDT($$NOW^XLFDT(),,,1),1)
 Q
 ;
PROC ;BSTS Background Process Front End
 ;
 ;Perform lock
 L +^XTMP("BSTSPROCQ",1):60 E  Q
 ;
 ;Reset quit flags
 K ^XTMP("BSTSPROCQ","QUIT")
 K ^XTMP("BSTSLCMP","QUIT")
 ;
 NEW QUEUE
 ;
 S QUEUE=0 F  S QUEUE=$O(^XTMP("BSTSPROCQ",QUEUE)) Q:'QUEUE  D  I $D(^XTMP("BSTSLCMP","QUIT"))!$D(^XTMP("BSTSPROCQ","QUIT")) Q
 . ;
 . ;Wait until process is ok to run
 . NEW CANRUN,OTAGRTN,TAGRTN,NMIEN,%,QIEN
 . S CANRUN=0 F  D  Q:CANRUN=1  H 300 Q:$D(^XTMP("BSTSPROCQ","QUIT"))
 .. ;
 .. NEW TIME
 .. ;
 .. ;Check for background processes
 .. L +^BSTS(9002318.1,0):1 E  Q
 .. L -^BSTS(9002318.1,0)
 .. L +^TMP("BSTSICD2SMD"):1 E  Q
 .. L -^TMP("BSTSICD2SMD")
 .. ;
 .. ;BSTS*2.0*3;Always run the process now
 .. ;Check time, only start between 6 PM and 3 AM
 .. ;I +$G(BSTSOVR) S CANRUN=1 Q  ;Look for override (defined in job call)
 .. ;D NOW^%DTC
 .. ;S TIME=+$E($P(%,".",2),1,2)
 .. ;I TIME>3,TIME<18 Q
 .. S CANRUN=1
 . ;
 . ;Handle quits
 . Q:$D(^XTMP("BSTSPROCQ","QUIT"))
 . ;
 . ;Get Routine/NMIEN
 . S (OTAGRTN,TAGRTN)=$G(^XTMP("BSTSPROCQ",QUEUE,"RTN"))
 . S TAGRTN=$P(TAGRTN,":")
 . S NMIEN=$G(^XTMP("BSTSPROCQ",QUEUE,"NMIEN"))
 . ;
 . ;Log entries
 . D NOW^%DTC
 . S ^XTMP("BSTSPROCQ",QUEUE,"START")=%
 . S ^XTMP("BSTSPROCQ",QUEUE,"TASK")=$G(ZTSK)
 . K ^XTMP("BSTSPROCQ",QUEUE,"ABORT")  ;Reset abort flag
 . ;
 . ;Make call
 . D DT^DICRW ;Refresh DT since could be run overnight
 . I TAGRTN="" S ^XTMP("BSTSPROCQ",QUEUE,"ERROR")="NO TAG/RTN"
 . E  D EN^XBNEW(TAGRTN,"NMIEN")
 . ;
 . D NOW^%DTC
 . L -^BSTS(9002318.1,0) ;Make sure locks released
 . L -^TMP("BSTSICD2SMD")
 . ;
 . ;Check for failure
 . I $D(^XTMP("BSTSLCMP","QUIT")) D  Q
 .. NEW ZTSK,X1,X2,X
 .. S ^XTMP("BSTSPROCQ",QUEUE,"ABORT")=%
 .. S X1=DT,X2=1 D C^%DTC
 .. S ZTSK=$$JOB($$JBTIME^BSTSUTL0(1))  ;On fail reschedule
 . ;
 . ;Log success
 . D NOW^%DTC
 . S ^XTMP("BSTSPROCQ",QUEUE,"END")=%
 . S ^XTMP("BSTSPROCQ","PD",%,QUEUE)=""
 . M ^XTMP("BSTSPROCQ","P",QUEUE)=^XTMP("BSTSPROCQ",QUEUE)
 . I $G(OTAGRTN)]"" D
 .. S QIEN="" F  S QIEN=$O(^XTMP("BSTSPROCQ","B",OTAGRTN,QIEN)) Q:QIEN=""  K ^XTMP("BSTSPROCQ",QIEN)
 .. K ^XTMP("BSTSPROCQ","B",OTAGRTN)
 .. S ^XTMP("BSTSPROCQ","PP",OTAGRTN,QUEUE)=""
 ;
 ;Look for concepts that need updated
 I '$D(^XTMP("BSTSLCMP","QUIT")),'$D(^XTMP("BSTSPROCQ","QUIT")),$O(^XTMP("BSTSPROCQ","C",""))]"" D UPCNC^BSTSVOF1
 ;
 ;Perform daily logging
 I '$D(^XTMP("BSTSLCMP","QUIT")),'$D(^XTMP("BSTSPROCQ","QUIT")),$O(^XTMP("BSTSPROCQ","L",""))]"" D PLOG^BSTSAPIL()
 ;
 ;Clear out quit flags
 K ^XTMP("BSTSLCMP","QUIT")
 K ^XTMP("BSTSPROCQ","QUIT")
 ;
 ;Release lock
 L -^XTMP("BSTSPROCQ",1)
 ;
 Q
 ;
EPURGE ;Purge BSTS WEB SERVICE ENDPOINT Error Responses
 ;
 D EPURGE^BSTSVUP0
 ;
 Q
