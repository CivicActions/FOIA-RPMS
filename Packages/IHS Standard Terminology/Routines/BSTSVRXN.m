BSTSVRXN ;GDIT/HS/BEE-Standard Terminology - RxNorm Subset Updates ; 5 Nov 2012  9:53 AM
 ;;2.0;IHS STANDARD TERMINOLOGY;**3,5,7,8**;Dec 01, 2016;Build 27
 ;
 Q
 ;
SCHK(NMID,BKGND) ;EP - Check for periodic RxNorm subset updates
 ;
 NEW LMDT,STS,BSTS,ERROR,ZTRTN,ZTSAVE,ZTDESC,ZTDTH,NMIEN
 NEW VAR,SITE,SDAYS,ZTIO,SUBLST,X1,X2,X,%H,TR
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSVRXN D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Only one SNOMED background process can be running at a time
 I '$G(BKGND)  L +^BSTS(9002318.1,0):0 E  W !!,"A Local Cache Refresh is Already Running. Please Try Later" H 3 Q
 L -^BSTS(9002318.1,0)
 ;
 ;Make sure ICD9 to SNOMED background process isn't running
 I '$G(BKGND) L +^TMP("BSTSICD2SMD"):0 E  W !!,"An ICD9 to SNOMED Background Process is Already Running. Please Try Later" H 3 Q
 L -^TMP("BSTSICD2SMD")
 ;
 S NMID=$G(NMID,"") S:NMID="" NMID=1552
 ;
 ;Only run it for codeset 1552
 I NMID'=1552 Q
 ;
 ;Get Site Parameter IEN
 S SITE=$O(^BSTS(9002318,0)) Q:'SITE
 ;
 ;Get subset update days
 S SDAYS=$$GET1^DIQ(9002318,SITE_",",.02,"I") S:SDAYS="" SDAYS=60
 ;
 ;Make sure we have a codeset (namespace)
 S NMIEN=$O(^BSTS(9002318.1,"B",NMID,"")) Q:NMIEN=""
 ;
 ;Update LAST SUBSET CHECK as completed today
 D
 . NEW BSTS,ERROR
 . S BSTS(9002318.1,NMIEN_",",.06)=DT
 . D FILE^DIE("","BSTS","ERROR")
 ;
 ;Check if refresh needs run
 S LMDT=$$GET1^DIQ(9002318.1,NMIEN,".1","I")
 I LMDT>0 S X1=LMDT,X2=SDAYS D C^%DTC S LMDT=X
 I LMDT>DT Q
 ;
 ;Only run if server set up
 S STS="" F TR=1:1:60 D  I +STS=2 Q
 . D RESET^BSTSWSV1  ;Reset the DTS link to on
 . S STS=$$VERSIONS^BSTSAPI("VAR") ;Try a quick call to see if call works
 . I +STS'=2 H TR
 I +STS'=2 G XSCHK
 ;
 ;Queue the process off in the background
 I +$G(BKGND) D QUEUE^BSTSVOFL("S1552") Q  ;Daily check - queue
 D CDJOB^BSTSUTIL(NMIEN,"S1552","")  ;Manual - run now
 ;
XSCHK Q
 ;
SUB ;EP - Update IHS Standard Terminology RxNorm Subsets
 ;
 ;Perform lock so only one process is allowed
 L +^BSTS(9002318.1,0):1 E  Q
 ;
 NEW NMID,SDAYS,SITE
 ;
 ;Retrieve passed in variable
 S NMIEN=$G(NMIEN) I NMIEN="" Q
 ;
 ;Get NMID
 S NMID=$$GET1^DIQ(9002318.1,NMIEN_",",.01,"I") I NMID="" Q
 ;
 ;Get Site Parameter IEN
 S SITE=$O(^BSTS(9002318,0)) Q:'SITE
 ;
 ;Get subset update days
 S SDAYS=$$GET1^DIQ(9002318,SITE_",",.02,"I") S:SDAYS="" SDAYS=60
 ;
 NEW BSTS,ERROR,CIEN,BSTSSB,STS,CNC,SUBLST,SSCIEN,ICONC,X,X1,X2,ITEM,%H
 NEW MFAIL,FWAIT,FCNT,ABORT,RUNSTRT,TR,BIPROG,BSTSWS,CDST,RVAR
 ;
 ;Note the run date
 S RUNSTRT=DT
 ;
 ;Only run if server up
 S STS="" F TR=1:1:60 D  I +STS=2 Q
 . D RESET^BSTSWSV1  ;Reset DTS to on
 . S STS=$$VERSIONS^BSTSAPI("VRSN") ;Try quick call
 . I +STS'=2 H TR
 I +STS'=2 G XSUB
 ;
 ;Pull down 32781 version
 S STS=$$VERSIONS^BSTSAPI("RVAR","32781")
 ;
 ;GDIT/HS/BEE 04/29/19;BSTS*2.0*3;CR#8841;Retrieve progress
 S BIPROG=$G(^XTMP("BSTSLCMP","UPD"))
 I BIPROG,($P(BIPROG,U,2)'="SUB")!($P(BIPROG,U,3)'="BSTSVRXN") S ^XTMP("BSTSLCMP","QUIT")=1 G XSUB
 ;
 ;Reset Monitoring Global
 I 'BIPROG K ^XTMP("BSTSLCMP")
 ;
 ;Get a later date
 S X1=DT,X2=60 D C^%DTC
 ;
 ;Log updates
 S CDST=32781 D
 . NEW CVRSN,NM
 . ;
 . S NM=$O(^BSTS(9002318.1,"B",CDST,"")) Q:NM=""
 . ;
 . ;Get current version
 . S CVRSN=$$GET1^DIQ(9002318.1,NM_",",.04,"I")
 . ;
 . ;Make a log entry
 . D LOG^BSTSAPIL("UPDS",CDST,"CURRENT",CVRSN),PLOG^BSTSAPIL
 ;
 ;Retrieve Failover Variables
 S MFAIL=$$FPARMS^BSTSVOFL()
 S FWAIT=$P(MFAIL,U,2)
 S MFAIL=$P(MFAIL,U)
 ;
 ;Update SUBSET TASK NUMBER
 I +$G(ZTSK)>0 D
 . NEW BSTS,ERROR
 . S BSTS(9002318.1,NMIEN_",",.08)=ZTSK
 . D FILE^DIE("","BSTS","ERROR")
 ;
 ;Set up Monitoring Global
 S ^XTMP("BSTSLCMP",0)=X_U_DT_U_"RxNorm Cache subset refresh running for "_NMID
 ;
 ;Mark entries as out of date and log status
 I 'BIPROG D  I $D(^XTMP("BSTSLCMP","QUIT")) G XSUB
 . D SUBMDT^BSTSVOF1(NMID)
 . Q:$D(^XTMP("BSTSLCMP","QUIT"))
 . S ^XTMP("BSTSLCMP","UPD")="1^SUB^BSTSVRXN"
 ;
 ;Make the call to update the subset entries
 S ^XTMP("BSTSLCMP","STS")="Performing subset refresh from DTS"
 S STS=1
 S BSTSWS("BIPROG")=BIPROG
 I $P($G(^XTMP("BSTSLCMP","UPD")),U,6)<200 S STS=$$SCODE^BSTSWSV1(1552,.BSTSWS)
 ;
 ;Quit on failure
 I +STS=0 S ^XTMP("BSTSLCMP","QUIT")=1 G XSUB
 I $D(^XTMP("BSTSLCMP","QUIT")) G XSUB
 ;
 ;Need to loop through list again to catch any deletes
 S STS=1 I $P($G(^XTMP("BSTSLCMP","UPD")),U,6)<300 S STS=$$SBSKP^BSTSVUP0(BIPROG,NMID)
 ;
 ;Check for failure
 I $D(^XTMP("BSTSLCMP","QUIT")) G XSUB
 ;
 ;Update the subset multiple
 D
 . NEW VAR,STS
 . S VAR=$$SUBSET^BSTSAPI("VAR",NMID_"^2")
 ;
 ;Run allergy and APSP file updates
 D
 . NEW PSTART,%
 . D NOW^%DTC
 . S PSTART=%
 . S ^XTMP("BSTSLCMP","STS")="Running process to update allergy entries with new RxNorm values"
 . D BACKLOAD^GMRAZRXU
 . D NOW^%DTC
 . D PRLOG^BSTSAPIL("BACKLOAD^GMRAZRXU",PSTART,PSTART,1552,%,1552,"")
 . S PSTART=%
 . S ^XTMP("BSTSLCMP","STS")="Running process to update APSP information"
 . D DQ^APSPRCUI
 . D NOW^%DTC
 . D PRLOG^BSTSAPIL("DQ^APSPRCUI",PSTART,PSTART,1552,%,1552,"")
 ;
 ;Process finished
 K ^XTMP("BSTSLCMP","UPD")
 ;
 ;Update the RxNorm subset version
 S NMID=32781 D
 . NEW NMIEN,NVIEN,NVLCL
 . ;
 . S NMIEN=$O(^BSTS(9002318.1,"B",NMID,"")) Q:NMIEN=""
 . ;
 . ;Update current version
 . ;
 . ;Get current version from codeset multiple
 . S NVIEN=$O(^BSTS(9002318.1,NMIEN,1,"A"),-1)
 . S NVLCL="" I +NVIEN>0 D
 .. NEW DA,IENS
 .. S DA(1)=NMIEN,DA=+NVIEN,IENS=$$IENS^DILF(.DA)
 .. S NVLCL=$$GET1^DIQ(9002318.11,IENS,".01","I")
 . ;
 . ;Now save CURRENT VERSION
 . I NVLCL]"" D
 .. NEW BSTS,ERROR
 .. S BSTS(9002318.1,NMIEN_",",.04)=NVLCL
 .. D FILE^DIE("","BSTS","ERROR")
 ;
 ;Make a log entry
 S CDST=32781 D
 . NEW CVRSN,NM
 . ;
 . S NM=$O(^BSTS(9002318.1,"B",CDST,"")) Q:NM=""
 . ;
 . ;Get current version
 . S CVRSN=$$GET1^DIQ(9002318.1,NM_",",.04,"I")
 . ;
 . ;Make a log entry
 . D LOG^BSTSAPIL("UPDE",CDST,"CURRENT",CVRSN),PLOG^BSTSAPIL
 ;
XSUB NEW FAIL
 S FAIL=$S($D(^XTMP("BSTSLCMP","QUIT")):1,1:0)
 I '$G(^XTMP("BSTSLCMP","UPD")) K ^XTMP("BSTSLCMP")
 S:FAIL ^XTMP("BSTSLCMP","QUIT")=1
 ;
 ;Unlock entry
 L -^BSTS(9002318.1,0)
 ;
 Q
 ;
SBRSET ;EP - BSTS REFRESH SUBSETS option
 ;
 ;Moved to overflow routine because of size issues
 D SBRSET^BSTSVOFL Q
 ;
ERR ;
 D ^%ZTER
 Q
