BSTSVRSC ;GDIT/HS/BEE-Standard Terminology - Compile Custom Codeset ; 5 Nov 2012  9:53 AM
 ;;2.0;IHS STANDARD TERMINOLOGY;**1,3,4,5,8**;Dec 01, 2016;Build 27
 ;
 Q
 ;
CCHK(NMID,BKGND) ;EP - Check for custom codeset updates
 ;
 I $G(NMID)="" Q
 I $G(NMID)=36 Q
 I $G(NMID)=1552 Q
 I $G(NMID)=5180 Q
 I $G(NMID)=32777 Q
 I $G(NMID)=32778 Q
 ;
 ;Only one SNOMED proc at a time
 I '$G(BKGND)  L +^BSTS(9002318.1,0):0 E  W !!,"A Local Cache Refresh is Already Running. Please Try Later" H 3 Q
 L -^BSTS(9002318.1,0)
 ;
 ;Check for ICD92SNOMED proc
 I '$G(BKGND) L +^TMP("BSTSICD2SMD"):0 E  W !!,"An ICD9 to SNOMED Background Process is Already Running. Please Try Later" H 3 Q
 L -^TMP("BSTSICD2SMD")
 ;
 NEW LMDT,STS,BSTS,ERROR,ZTRTN,ZTSAVE,ZTDESC,ZTDTH,NMIEN,ZTQUEUED
 NEW VAR,ZTIO,VRSN,TRY
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSVRSC D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Get codeset
 S NMIEN=$O(^BSTS(9002318.1,"B",NMID,"")) Q:NMIEN=""
 ;
 ;Check if online
 S STS="" F TRY=1:1:5 D  I +STS=2 Q
 . D RESET^BSTSWSV1  ;Reset the DTS link to on
 . S STS=$$VERSIONS^BSTSAPI("VRSN") ;Try
 ;
 ;Queue proc
 I +STS=2 D CDJOB^BSTSUTIL(NMIEN,"CCD")
 ;
 Q
 ;
CDST ;EP - Update IHS Standard Terminology Codeset
 ;
 ;Tasked by above.  Var NMIEN should be set
 ;
 S NMIEN=$G(NMIEN) I NMIEN="" Q
 ;
 ;Lock
 L +^BSTS(9002318.1,0):0 E  S ^XTMP("BSTSLCMP","QUIT")=1 Q
 ;
 NEW BSTSWS,RESULT,NMID,STS,VRSN,BSTS,ICONC,CIEN,X1,X2,X,NVIEN,NVLCL,MFAIL,FWAIT,TRY,FCNT,ABORT,TRY,CVRSN
 NEW BIPROG
 ;
 ;GDIT/HS/BEE 06/06/19;BSTS*2.0*3;CR#8841;Retrieve progress
 S BIPROG=$G(^XTMP("BSTSLCMP","UPD"))
 I BIPROG,($P(BIPROG,U,2)'="CDST")!($P(BIPROG,U,3)'="BSTSVRSC") S ^XTMP("BSTSLCMP","QUIT")=1 G XCDST
 ;
 ;Get ext codeset Id
 S NMID=$$GET1^DIQ(9002318.1,NMIEN_",",.01,"I") I NMID="" G XCDST
 ;
 ;Update LAST VERSION CHECK so proc won't keep getting called
 S BSTS(9002318.1,NMIEN_",",.05)=DT
 D FILE^DIE("","BSTS","ERROR")
 ;
 ;Online?
 S STS="" F TRY=1:1:5 D  I +STS=2 Q
 . D RESET^BSTSWSV1  ;Reset the DTS link to on
 . S STS=$$VERSIONS^BSTSAPI("VRSN") ;Try
 I +STS'=2 S ^XTMP("BSTSLCMP","QUIT")=1 G XCDST
 ;
 ;Reset Monitoring GBL
 I 'BIPROG K ^XTMP("BSTSLCMP")
 ;
 ;Get later date
 S X1=DT,X2=60 D C^%DTC
 ;
 ;Get current version
 S CVRSN=$$GET1^DIQ(9002318.1,NMIEN_",",.04,"I")
 ;
 ;Make a log entry
 ;GDIT/HS/BEE;02/29/2024;FEATURE#60482;Status of DTS Update Monitor - send any log entries
 ;D LOG^BSTSAPIL("UPDS",NMID,"CURRENT",CVRSN)
 D LOG^BSTSAPIL("UPDS",NMID,"CURRENT",CVRSN),PLOG^BSTSAPIL
 ;
 ;Set Monitoring GBL
 S ^XTMP("BSTSLCMP",0)=X_U_DT_U_"Cache refresh running for "_NMID
 ;
 ;Mark as OOD
 I 'BIPROG D
 . D CSTMDT^BSTSVOF1(NMID)
 . S ^XTMP("BSTSLCMP","UPD")="1^CDST^BSTSVRSC"
 ;
 ;Make call to proc
 S ^XTMP("BSTSLCMP","STS")="Performing "_NMID_" Refresh from DTS"
 S BSTSWS("NAMESPACEID")=NMID
 S BSTSWS("REVIN")=$$FMTE^XLFDT(DT,"7")
 S BSTSWS("BIPROG")=BIPROG
 S STS=1
 I $P($G(^XTMP("BSTSLCMP","UPD")),U,6)<200 S STS=$$CSTMCDST^BSTSWSV1("RESULT",.BSTSWS)
 I +STS=0 G XCDST  ;Quit if update failed
 I $D(^XTMP("BSTSLCMP","QUIT")) G XCDST
 ;
 ;Retrieve Failover Vars
 S MFAIL=$$FPARMS^BSTSVOFL()
 S FWAIT=$P(MFAIL,U,2)
 S MFAIL=$P(MFAIL,U)
 ;
 ;Loop through again and proc skipped entries (no longer mapped)
 S STS=1 I $P($G(^XTMP("BSTSLCMP","UPD")),U,6)<300 S STS=$$UCSKP^BSTSVUP0(BIPROG)
 ;
 ;Failure check
 I +STS=0 S ^XTMP("BSTSLCMP","QUIT")=1 G XCDST
 I $D(^XTMP("BSTSLCMP","QUIT")) G XCDST
 ;
 ;Loop through, grab concept that mappings linked to
 S STS=1 I $P($G(^XTMP("BSTSLCMP","UPD")),U,6)<400 D
 . ;
 . ;Retrieve progress
 . S ICONC=$P(BIPROG,U,7)
 . ;
 . S ABORT=0 F  S ICONC=$O(^BSTS(9002318.4,"C",NMID,ICONC)) Q:ICONC=""  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 .. NEW IEN
 .. S IEN="" F  S IEN=$O(^BSTS(9002318.4,"C",NMID,ICONC,IEN)) Q:IEN=""  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 ... NEW AS
 ... S AS=0 F  S AS=$O(^BSTS(9002318.4,IEN,9,AS)) Q:'AS  D
 .... NEW NODE,NM,DTS,VAR,FCNT,TRY
 .... S NODE=$G(^BSTS(9002318.4,IEN,9,AS,0))
 .... S ^XTMP("BSTSLCMP","STS")="Getting Association details for entry: "_ICONC
 .... S NM=$P(NODE,U,2) Q:NM=""
 .... S DTS=$P(NODE,U,3) Q:DTS=""
 .... ;
 .... ;Update entry-Hang max of 12 times
 .... S (FCNT,STS)=0 F TRY=1:1:(12*MFAIL) D  I +STS=2!(STS="0^") Q
 ..... D RESET^BSTSWSV1  ;Reset the DTS link to on
 ..... S STS=$$DTSLKP^BSTSAPI("VAR",DTS_"^"_NM) I +STS=2!(STS="0^") Q
 ..... S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ...... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"CDST^BSTSVRSC - Getting Assoc for entry: "_DTS)
 ...... I ABORT=1 S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("CUSTOM CODESET REFRESH FAILED ON DETAIL ENTRY: "_DTS)
 ...... S FCNT=0
 .... ;
 .... ;Log progress
 .... S $P(^XTMP("BSTSLCMP","UPD"),U,7)=ICONC
 . I '$D(^XTMP("BSTSLCMP","QUIT")) S $P(^XTMP("BSTSLCMP","UPD"),U,6,7)="400^"
 ;
 ;Check for failure
 I +STS=0 G XCDST
 I $D(^XTMP("BSTSLCMP","QUIT")) G XCDST
 ;
 ;Get current version from mult
 S NVIEN=$O(^BSTS(9002318.1,NMIEN,1,"A"),-1)
 S NVLCL="" I +NVIEN>0 D
 . NEW DA,IENS
 . S DA(1)=NMIEN,DA=+NVIEN,IENS=$$IENS^DILF(.DA)
 . S NVLCL=$$GET1^DIQ(9002318.11,IENS,".01","I")
 ;
 ;Save CURRENT VERSION
 I NVLCL]"" D
 . NEW BSTS,ERROR
 . S BSTS(9002318.1,NMIEN_",",.04)=NVLCL
 . D FILE^DIE("","BSTS","ERROR")
 ;
 ;Get new current version
 S CVRSN=$$GET1^DIQ(9002318.1,NMIEN_",",.04,"I")
 ;
 ;Queue med route refresh
 I NMID=32774 D
 . NEW PSTART,%
 . D NOW^%DTC
 . S PSTART=%
 . ;GDIT/HS/BEE 03/26/20;BSTS*2.0*3;CR#9773;Update med routes in file
 . ;Call med route update process
 . S ^XTMP("BSTSLCMP","STS")="Running process to update local medication routes that are mapped"
 . D UPROUTE^APSPRCUI
 . D NOW^%DTC
 . D PRLOG^BSTSAPIL("UPROUTE^APSPRCUI",PSTART,PSTART,32774,%,32774,"")
 ;
 I (NMID=32771)!(NMID=32772)!(NMID=32773) D
 . NEW PSTART,%
 . D NOW^%DTC
 . S PSTART=%
 . ;GDIT/HS/BEE 04/29/19;BSTS*2.0*3;CR#9395,9216,8642,9773;Update allergy and APSP files
 . S ^XTMP("BSTSLCMP","STS")="Running process to update allergy entries with new RxNorm values"
 . D BACKLOAD^GMRAZRXU
 . D NOW^%DTC
 . D PRLOG^BSTSAPIL("BACKLOAD^GMRAZRXU",PSTART,PSTART,NMID,%,NMID,"")
 ;
 ;Process finished
 K ^XTMP("BSTSLCMP","UPD")
 ;
 ;Make a log entry
 ;GDIT/HS/BEE;02/29/2024;FEATURE#60482;Status of DTS Update Monitor - send any log entries
 ;D LOG^BSTSAPIL("UPDE",NMID,"CURRENT",CVRSN)
 D LOG^BSTSAPIL("UPDE",NMID,"CURRENT",CVRSN),PLOG^BSTSAPIL
 ;
 ;Reset Monitoring GBL
XCDST NEW FAIL
 S FAIL=$S($D(^XTMP("BSTSLCMP","QUIT")):1,1:0)
 I '$G(^XTMP("BSTSLCMP","UPD")) K ^XTMP("BSTSLCMP")
 S:FAIL ^XTMP("BSTSLCMP","QUIT")=1
 ;
 ;Unlock
 L -^BSTS(9002318.1,0)
 ;
 Q
 ;
ACHK(NMID,BKGND) ;EP - Check for '36' auto-codable ICD-10s
 ;
 ;Only one SNOMED proc at a time
 I '$G(BKGND)  L +^BSTS(9002318.1,0):0 E  W !!,"A Local Cache Refresh is Already Running. Please Try Later" H 3 Q
 L -^BSTS(9002318.1,0)
 ;
 ;Make sure ICD92SNOMED process isn't running
 I '$G(BKGND) L +^TMP("BSTSICD2SMD"):0 E  W !!,"An ICD9 to SNOMED Background Process is Already Running. Please Try Later" H 3 Q
 L -^TMP("BSTSICD2SMD")
 ;
 ;Validate input
 I $G(NMID)="" Q
 I $G(NMID)'=32777 Q
 ;
 NEW LMDT,STS,BSTS,ERROR,NMIEN
 NEW VAR,SITE,VRSN,TRY
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSVRSC D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Get codeset
 S NMIEN=$O(^BSTS(9002318.1,"B",NMID,"")) Q:NMIEN=""
 ;
 ;Online?
 S STS="" F TRY=1:1:5 D  I +STS=2 Q
 . D RESET^BSTSWSV1  ;Reset the DTS link to on
 . S STS=$$VERSIONS^BSTSAPI("VRSN") ;Try
 ;
 ;Queue process
 I +STS=2 D CDJOB^BSTSUTIL(NMIEN,"I10")
 ;
 Q
 ;
ACODE ;EP - Update SNOMED '36' auto-codable ICD-10 mappings
 ;
 ;Tasked above.  Variable NMIEN should be set
 ;
 S NMIEN=$G(NMIEN) I NMIEN="" Q
 ;
 ;Lock
 L +^BSTS(9002318.1,0):0 E  S ^XTMP("BSTSLCMP","QUIT")=1 Q
 ;
 NEW BSTSWS,RESULT,NMID,STS,VRSN,BSTS,ICONC,CIEN,X1,X2,X,RUNDT,DEBUG,NVIEN,NVLCL,FWAIT,TRY,FCNT,ABORT,TRY,CVRSN
 NEW CDST,FUT,BIPROG,SVAR
 ;
 ;GDIT/HS/BEE 06/06/19;BSTS*2.0*3;CR#8841;Retrieve progress
 S BIPROG=$G(^XTMP("BSTSLCMP","UPD"))
 I BIPROG,($P(BIPROG,U,2)'="ACODE")!($P(BIPROG,U,3)'="BSTSVRSC") S ^XTMP("BSTSLCMP","QUIT")=1 G XACODE
 ;
 ;Get run date
 S RUNDT=DT
 ;
 ;Get external codeset Id
 S NMID=$$GET1^DIQ(9002318.1,NMIEN_",",.01,"I") I NMID="" G XACODE
 ;
 ;Update LAST VERSION CHECK now so proc won't keep getting called
 S BSTS(9002318.1,NMIEN_",",.05)=DT
 D FILE^DIE("","BSTS","ERROR")
 ;
 ;Online?
 S STS="" F TRY=1:1:5 D  I +STS=2 Q
 . D RESET^BSTSWSV1  ;Reset the DTS link to on
 . S STS=$$VERSIONS^BSTSAPI("VRSN") ;Try
 I +STS'=2 S ^XTMP("BSTSLCMP","QUIT")=1 G XACODE
 ;
 ;Pull down 32783 version
 S STS=$$VERSIONS^BSTSAPI("SVAR","32783")
 ;
 ;Reset Monitoring GBL
 I 'BIPROG K ^XTMP("BSTSLCMP")
 ;
 ;Get later date - Added FUT set
 S X1=DT,X2=60 D C^%DTC S FUT=X
 ;
 ;Log updates
 F CDST=32777,32779,32780,32783 D
 . NEW CVRSN,NM
 . ;
 . S NM=$O(^BSTS(9002318.1,"B",CDST,"")) Q:NM=""
 . ;
 . ;Get current version
 . S CVRSN=$$GET1^DIQ(9002318.1,NM_",",.04,"I")
 . ;
 . ;Make a log entry
 . ;GDIT/HS/BEE;02/29/2024;FEATURE#60482;Status of DTS Update Monitor - send any log entries
 . ;D LOG^BSTSAPIL("UPDS",CDST,"CURRENT",CVRSN)
 . D LOG^BSTSAPIL("UPDS",CDST,"CURRENT",CVRSN),PLOG^BSTSAPIL
 ;
 ;Make a log entry
 ;GDIT/HS/BEE;02/29/2024;FEATURE#60482;Status of DTS Update Monitor - send any log entries
 ;D LOG^BSTSAPIL("UPDS",36,"SUBSET","")
 ;GDIT/HS/BEE;FEATURE#125580;10/14/2025;No using subset version
 ;D LOG^BSTSAPIL("UPDS",36,"SUBSET",""),PLOG^BSTSAPIL
 ;
 ;Set up Monitoring GBL
 S ^XTMP("BSTSLCMP",0)=X_U_DT_U_"SNOMED '36' auto-codable ICD-10 mapping running"
 ;
 ;Mark entries as out of date and log status
 I 'BIPROG D  I $D(^XTMP("BSTSLCMP","QUIT")) G XACODE
 . D CLLMDT^BSTSVOF1(36)  ;Mark entries as out of date
 . Q:$D(^XTMP("BSTSLCMP","QUIT"))
 . S ^XTMP("BSTSLCMP","UPD")="1^ACODE^BSTSVRSC"
 ;
 ;Handle duplicate concepts
 S ^XTMP("BSTSLCMP","STS")="Searching local cache to address duplicate concepts. "
 D DUP^BSTSDCLN(1)
 ;
 ;Make call to proc custom codeset
 S ^XTMP("BSTSLCMP","STS")="Performing Refresh from DTS"
 S DEBUG=""
 S BSTSWS("REVIN")=$$FMTE^XLFDT(DT,"7")
 S BSTSWS("BIPROG")=BIPROG
 S STS=1
 I $P($G(^XTMP("BSTSLCMP","UPD")),U,6)<200 S STS=$$ACODE^BSTSWSV1("RESULT",.BSTSWS,DEBUG)
 ;
 ;Failure check
 I +STS=0 S ^XTMP("BSTSLCMP","QUIT")=1 G XACODE
 I $D(^XTMP("BSTSLCMP","QUIT")) G XACODE
 ;
 ;Retrieve Failover Vars
 S MFAIL=$$FPARMS^BSTSVOFL()
 S FWAIT=$P(MFAIL,U,2)
 S MFAIL=$P(MFAIL,U)
 ;
 ;Loop through again and proc skipped entries (no longer mapped)
 S STS=1 I $P($G(^XTMP("BSTSLCMP","UPD")),U,6)<300 S STS=$$UPSKP^BSTSVUP0(BIPROG)
 ;
 ;Failure check
 I +STS=0 S ^XTMP("BSTSLCMP","QUIT")=1 G XACODE
 I $D(^XTMP("BSTSLCMP","QUIT")) G XACODE
 ;
 D
 . NEW BSTS,ERROR,NMID36
 . S NMID36=$O(^BSTS(9002318.1,"B",36,"")) Q:NMID36=""
 . S BSTS(9002318.1,NMID36_",",.1)=DT
 . D FILE^DIE("","BSTS","ERROR")
 ;
 F NMID=32777,32779,32780,32783 D
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
 ;Remap IPL entries
 I $P($G(^XTMP("BSTSLCMP","UPD")),U,6)<400 D
 . NEW PSTART,%
 . D NOW^%DTC
 . S PSTART=%
 . D UIFS^BSTSVOF1(.ZTQUEUED)
 . D NOW^%DTC
 . D PRLOG^BSTSAPIL("UIFS^BSTSVOF1",PSTART,PSTART,36,%,36,"")
 ;
 ;Proc VUID and NDC
 S STS=1 I $P($G(^XTMP("BSTSLCMP","UPD")),U,6)<500 D
 . S STS=$$NVLKP^BSTSVOFL(MFAIL,FWAIT)
 I +STS=0 S ^XTMP("BSTSLCMP","QUIT")=1 G XACODE
 ;
 ;Log updates
 F CDST=32777,32779,32780,32783 D
 . NEW CVRSN,NM
 . ;
 . S NM=$O(^BSTS(9002318.1,"B",CDST,"")) Q:NM=""
 . ;
 . ;Get current version
 . S CVRSN=$$GET1^DIQ(9002318.1,NM_",",.04,"I")
 . ;
 . ;Make a log entry
 . ;GDIT/HS/BEE;02/29/2024;FEATURE#60482;Status of DTS Update Monitor - send any log entries
 . ;D LOG^BSTSAPIL("UPDE",CDST,"CURRENT",CVRSN)
 . D LOG^BSTSAPIL("UPDE",CDST,"CURRENT",CVRSN),PLOG^BSTSAPIL
 ;
 ;Process finished
 K ^XTMP("BSTSLCMP","UPD")
 ;
 ;Make a log entry
 ;GDIT/HS/BEE;02/29/2024;FEATURE#60482;Status of DTS Update Monitor - send any log entries
 ;D LOG^BSTSAPIL("UPDE",36,"SUBSET","")
 ;GDIT/HS/BEE;FEATURE#125580;10/14/2025;Now using subset version
 ;D LOG^BSTSAPIL("UPDE",36,"SUBSET",""),PLOG^BSTSAPIL
 ;
 ;Reset Monitoring GBL
XACODE NEW FAIL
 S FAIL=$S($D(^XTMP("BSTSLCMP","QUIT")):1,1:0)
 I '$G(^XTMP("BSTSLCMP","UPD")) K ^XTMP("BSTSLCMP")
 S:FAIL ^XTMP("BSTSLCMP","QUIT")=1
 ;
 ;Unlock
 L -^BSTS(9002318.1,0)
 ;
 Q
 ;
A9CHK(NMID,BKGND) ;EP - Check for '36' auto-codable ICD-9s
 ;
 ;ICD9 updates no longer supported
 Q
 ;
A9CODE ;EP - Update SNOMED '36' auto-codable ICD-9 mappings
 ;
 ;ICD9 updates no longer supported
 Q
 ;
ERR ;
 D ^%ZTER
 Q
