BSTSVCVN ;GDIT/HS/BEE-Standard Terminology - CVX Subset Updates ; 5 Nov 2012  9:53 AM
 ;;2.0;IHS STANDARD TERMINOLOGY;**8**;Dec 01, 2016;Build 27
 ;
 Q
 ;
SUB ;EP - Update IHS Standard Terminology CVX Subsets
 ;
 ;Perform lock so only one process is allowed
 L +^BSTS(9002318.1,0):1 E  Q
 ;
 NEW NMID,SITE
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
 NEW BSTS,ERROR,CIEN,BSTSSB,STS,CNC,SUBLST,SSCIEN,ICONC,X,X1,X2,ITEM,%H
 NEW MFAIL,FWAIT,FCNT,ABORT,RUNSTRT,TR,BIPROG,BSTSWS,CDST,CVAR
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
 ;Pull down 32782 version
 S STS=$$VERSIONS^BSTSAPI("CVAR","32782")
 ;
 ;GDIT/HS/BEE 04/29/19;BSTS*2.0*3;CR#8841;Retrieve progress
 S BIPROG=$G(^XTMP("BSTSLCMP","UPD"))
 I BIPROG,($P(BIPROG,U,2)'="SUB")!($P(BIPROG,U,3)'="BSTSVCVN") S ^XTMP("BSTSLCMP","QUIT")=1 G XSUB
 ;
 ;Reset Monitoring Global
 I 'BIPROG K ^XTMP("BSTSLCMP")
 ;
 ;Get a later date
 S X1=DT,X2=60 D C^%DTC
 ;
 ;Log updates
 S CDST=32782 D
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
 S ^XTMP("BSTSLCMP",0)=X_U_DT_U_"CVX Cache subset refresh running for "_NMID
 ;
 ;Mark entries as out of date and log status
 I 'BIPROG D  I $D(^XTMP("BSTSLCMP","QUIT")) G XSUB
 . D SUBMDT^BSTSVOF1(NMID)
 . Q:$D(^XTMP("BSTSLCMP","QUIT"))
 . S ^XTMP("BSTSLCMP","UPD")="1^SUB^BSTSVCVN"
 ;
 ;Make the call to update the subset entries
 S ^XTMP("BSTSLCMP","STS")="Performing subset refresh from DTS"
 S STS=1
 S BSTSWS("BIPROG")=BIPROG
 I $P($G(^XTMP("BSTSLCMP","UPD")),U,6)<200 S STS=$$SCODE^BSTSWSV1(5190,.BSTSWS)
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
 ;Process finished
 K ^XTMP("BSTSLCMP","UPD")
 ;
 ;Update the CVX subset version
 S NMID=32782 D
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
 S CDST=32782 D
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
