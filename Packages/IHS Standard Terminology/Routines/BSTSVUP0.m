BSTSVUP0 ;GDIT/HS/BEE-Standard Terminology - Version update routine 0 ; 5 Nov 2012  9:53 AM
 ;;2.0;IHS STANDARD TERMINOLOGY;**3**;Dec 01, 2016;Build 46
 ;
 Q
 ;
 NEW FWAIT,MFAIL
 ;
UPSKP(BIPROG) ;Update skipped entries
 ;
 NEW ABORT,STS,ICONC,CIEN,X1,X2,X,FUT,MFAIL,FWAIT
 ;
 S X1=DT,X2=60 D C^%DTC S FUT=X
 ;
 ;Retrieve Failover Variables
 S MFAIL=$$FPARMS^BSTSVOFL()
 S FWAIT=$P(MFAIL,U,2)
 S MFAIL=$P(MFAIL,U)
 ;
 ;Look for restart - get last completed
 S ICONC=$P(BIPROG,U,7)
 ;
 ;Update tracker
 S $P(^XTMP("BSTSLCMP","UPD"),U,4,5)="UPSKP^BSTSVUP0"
 ;
 ;Loop through again and proc skipped entries (no longer mapped)
 S ^XTMP("BSTSLCMP","STS")="Looking for skipped entries (no longer mapped)"
 S STS=1,ABORT=0 F  S ICONC=$O(^BSTS(9002318.4,"C",36,ICONC)) Q:ICONC=""  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 . S CIEN="" F  S CIEN=$O(^BSTS(9002318.4,"C",36,ICONC,CIEN)) Q:CIEN=""  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 .. NEW DTSID,VAR
 .. ;
 .. ;Skip partials
 .. I $$GET1^DIQ(9002318.4,CIEN_",",.03,"I")="P" D TRK(ICONC) Q
 .. ;
 .. ;Quit if entry updated
 .. I $$GET1^DIQ(9002318.4,CIEN_",",".12","I")'="" D TRK(ICONC) Q
 .. ;
 .. ;Update monitor
 .. S ^XTMP("BSTSLCMP","STS")="Updating skipped entry "_CIEN
 .. ;
 .. ;Get DTSID
 .. S DTSID=$$GET1^DIQ(9002318.4,CIEN_",",.08,"I") I DTSID="" D TRK(ICONC) Q
 .. ;
 .. ;Refresh entry - Hang max of 12 times
 .. S (FCNT,STS)=0 F TRY=1:1:(12*MFAIL) D  I +STS=2!(STS="0^") Q
 ... D RESET^BSTSWSV1  ;Reset the DTS link to on
 ... S STS=$$DTSLKP^BSTSAPI("VAR",DTSID_"^36^"_FUT) I +STS=2!(STS="0^") Q
 ... S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 .... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"UPSKP^BSTSVUP0 - Getting update for entry: "_DTSID)
 .... I ABORT=1 S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("ICD10 MAPPING REFRESH FAILED ON DETAIL ENTRY: "_DTSID)
 .... S FCNT=0
 .. ;
 .. I '$D(^XTMP("BSTSLCMP","QUIT")) D TRK(ICONC)
 ;
 ;Mark as error or complete
 I 'STS S ^XTMP("BSTSLCMP","QUIT")=1
 E  I '$D(^XTMP("BSTSLCMP","QUIT")) S $P(^XTMP("BSTSLCMP","UPD"),U,6,7)="300^"
 ;
 Q STS
 ;
UCSKP(BIPROG) ;Update skipped custom codeset entries
 ;
 NEW ICONC,CIEN
 ;
 ;Look for restart - get last completed
 S ICONC=$P(BIPROG,U,7)
 ;
 ;Update tracker
 S $P(^XTMP("BSTSLCMP","UPD"),U,4,5)="UCSKP^BSTSVUP0"
 ;
 ;Now refresh entries for codeset that have not been updated (to handle deletes)
 S ICONC="" F  S ICONC=$O(^BSTS(9002318.4,"C",NMID,ICONC)) Q:ICONC=""  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 . S CIEN="" F  S CIEN=$O(^BSTS(9002318.4,"C",NMID,ICONC,CIEN)) Q:CIEN=""  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 .. NEW BSTS,ERR,TIEN,DA,DIK
 .. ;
 .. ;Quit if updated
 .. I $$GET1^DIQ(9002318.4,CIEN_",",".12","I")]"" Q
 .. ;
 .. ;Update monitor
 .. S ^XTMP("BSTSLCMP","STS")="Updating skipped entry "_CIEN
 .. ;
 .. ;First remove terms
 .. S TIEN="" F  S TIEN=$O(^BSTS(9002318.3,"C",NMID,CIEN,TIEN)) Q:TIEN=""  D
 ... NEW DA,DIK
 ... S DA=TIEN,DIK="^BSTS(9002318.3," D ^DIK
 .. ;
 .. ;Remove concept
 .. S DA=CIEN,DIK="^BSTS(9002318.4," D ^DIK
 .. ;
 .. ;Track progress
 .. D TRK(ICONC)
 ;
 ;Mark as error or complete
 I 'STS S ^XTMP("BSTSLCMP","QUIT")=1
 E  I '$D(^XTMP("BSTSLCMP","QUIT")) S $P(^XTMP("BSTSLCMP","UPD"),U,6,7)="300^"
 ;
 Q STS
 ;
SBSKP(BIPROG,NMID) ;
 ;
 NEW ABORT,ICONC,SSCIEN,MFAIL,FWAIT
 ;
 ;Retrieve Failover Variables
 S MFAIL=$$FPARMS^BSTSVOFL()
 S FWAIT=$P(MFAIL,U,2)
 S MFAIL=$P(MFAIL,U)
 ;
 S ICONC=$P(BIPROG,U,7)
 ;
 S ^XTMP("BSTSLCMP","STS")="Looking for entries removed from subsets"
 S ABORT=0 F  S ICONC=$O(^BSTS(9002318.4,"C",NMID,ICONC)) Q:ICONC=""  Q:$D(^XTMP("BSTSLCMP","QUIT"))  S SSCIEN="" F  S SSCIEN=$O(^BSTS(9002318.4,"C",NMID,ICONC,SSCIEN)) Q:SSCIEN=""  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 . ;
 . NEW DTSID,SBVAR,CDSET,X1,X2,X,%H,FCNT,TRY,LMOD
 . ;
 . ;Skip partial entries
 . I $$GET1^DIQ(9002318.4,SSCIEN_",",.03,"I")="P" Q
 . ;
 . ;Get last modified date for concept
 . S LMOD=$$GET1^DIQ(9002318.4,SSCIEN_",",".12","I") I LMOD]"" Q
 . ;
 . ;Get DTSId
 . S DTSID=$$GET1^DIQ(9002318.4,SSCIEN_",",".08","I") Q:DTSID=""
 . S ^XTMP("BSTSLCMP","STS")="Refreshing removed entry: "_SSCIEN_" DTSID: "_DTSID
 . ;
 . ;If Out of Date, retrieve detail from server - Hang max of 12 times
 . S (FCNT,STS)=0 F TRY=1:1:(12*MFAIL) D  I +STS=2!(STS="0^") Q
 .. D RESET^BSTSWSV1 ;Make sure the link is on
 .. S STS=$$DTSLKP^BSTSAPI("SBVAR",DTSID_"^"_NMID) I +STS=2!(STS="0^") Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"SUB^BSTSVRSN - Refreshing entry: "_DTSID)
 ... I ABORT=1 S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("SUBSET REFRESH FAILED ON DETAIL ENTRY: "_DTSID)
 ... S FCNT=0
 . ;
 . ;Track progress
 . I '$D(^XTMP("BSTSLCMP","QUIT")) D TRK(ICONC)
 ;
 ;Mark as error or complete
 I 'STS S ^XTMP("BSTSLCMP","QUIT")=1 Q 0
 E  I '$D(^XTMP("BSTSLCMP","QUIT")) S $P(^XTMP("BSTSLCMP","UPD"),U,6,7)="300^" Q 1
 ;
 Q 0
 ;
TRK(IEN) ;Track last processed update
 ;
 S $P(^XTMP("BSTSLCMP","UPD"),U,7)=IEN
 Q
 ;
EPURGE ;Purge BSTS WEB SERVICE ENDPOINT Error Responses
 ;
 ;From BSTSVOFL
 ;
 NEW SITE,SIEN
 ;
 S SITE=0 F  S SITE=$O(^BSTS(9002318,SITE)) Q:'SITE  S SIEN=0 F  S SIEN=$O(^BSTS(9002318,SITE,1,SIEN)) Q:'SIEN  D
 . NEW WIEN,IENS,DA,EDATE,QUIT,KPDATE,X1,X2,X,DAYS
 . ;
 . ;Get the pointer to the web service entry
 . S DA(1)=SITE,DA=SIEN,IENS=$$IENS^DILF(.DA)
 . S WIEN=$$GET1^DIQ(9002318.01,IENS,".01","I") Q:WIEN=""
 . ;
 . ;Get the days to keep on file
 . S DAYS=$$GET1^DIQ(9002318.01,IENS,".03","I") S:DAYS="" DAYS=14
 . S X1=DT,X2=-DAYS D C^%DTC S KPDATE=X
 . ;
 . ;Loop through response errors
 . S QUIT=0,EDATE="" F  S EDATE=$O(^BSTS(9002318.2,WIEN,5,"B",EDATE)) Q:'EDATE!QUIT  D
 .. ;
 .. NEW PIEN,DA,DIK
 .. ;
 .. ;Check date
 .. I EDATE>KPDATE S QUIT=1 Q
 .. ;
 .. ;Purge
 .. S PIEN="" F  S PIEN=$O(^BSTS(9002318.2,WIEN,5,"B",EDATE,PIEN)) Q:PIEN=""  D
 ... S DA(1)=WIEN,DA=PIEN,DIK="^BSTS(9002318.2,"_DA(1)_",5," D ^DIK
 . ;
 . ;Also clean out these calls from background log
 . S IENS="" F  S IENS=$O(^XTMP("BSTSPROCQ","PP","EPURGE^BSTSVOFL",IENS)) Q:IENS=""  D
 .. NEW END
 .. S END=$G(^XTMP("BSTSPROCQ","P",IENS,"START")) Q:END=""
 .. I END>KPDATE Q
 .. ;
 .. ;Purge
 .. K ^XTMP("BSTSPROCQ","PP","EPURGE^BSTSVOFL",IENS)
 .. K ^XTMP("BSTSPROCQ","PD",END,IENS)
 .. K ^XTMP("BSTSPROCQ","P",IENS)
 ;
 Q
 ;
DNDC(DITEM,FWAIT,MFAIL) ;Loop through ORDERABLE ITEMS file and look up NDCs
 ;
 NEW STS,ITEM
 ;
 S STS=1,ITEM=+$G(DITEM) F  S ITEM=$O(^ORD(101.43,ITEM)) Q:'ITEM  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 . NEW PSOI,DIEN
 . ;
 . ;Retrieve the ID
 . S PSOI=+$P($G(^ORD(101.43,+ITEM,0)),U,2)
 . S DIEN=0 F  S DIEN=$O(^PSDRUG("ASP",PSOI,DIEN)) Q:'DIEN  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 .. NEW NDC,VAR,FCNT,TRY,ABORT
 .. ;
 .. ;Retrieve the NDC
 .. S NDC=$$VANDC^PSSDEE(DIEN) I NDC="" D TRK^BSTSVOFL("D",ITEM) Q
 .. ;
 .. ;Format the NDC
 .. I $L(NDC)>11,$E(NDC,1)="0" S NDC=$E(NDC,2,99)
 .. S ^XTMP("BSTSLCMP","STS")="Refreshing ORDERABLE ITEM NDC entry: "_NDC
 .. ;
 .. ;Retrieve from server - Hang max 12 times
 .. S (FCNT,STS)=0 F TRY=1:1:(12*MFAIL) D  I +STS=2!(STS="0^")!($D(^XTMP("BSTSLCMP","QUIT"))) Q
 ... D RESET^BSTSWSV1 ;Make sure link is on
 ... S STS=$$DILKP^BSTSAPI("VAR",NDC_"^N^2^^1") I +STS=2!(STS="0^")!($D(^XTMP("BSTSLCMP","QUIT"))) Q
 ... S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 .... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"DNDC^BSTSVUP0 - NDC: "_NDC)
 .... S ABORT=1 S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("REFRESH FAILED ON ORD ITEM NDC LOOKUP: "_NDC)
 .... S FCNT=0 ;Fail handling
 .. I '$D(^XTMP("BSTSLCMP","QUIT")) D TRK^BSTSVOFL("D",ITEM)
 ;
 ;Check for failure
 I $D(^XTMP("BSTSLCMP","QUIT")) Q 0
 ;
 Q 1
