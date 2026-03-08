BSTSDTS7 ;GDIT/HS/BEE-Standard Terminology DTS Calls/Processing - Update CVX; 5 Nov 2012  9:53 AM
 ;;2.0;IHS STANDARD TERMINOLOGY;**3,4,7,8**;Dec 01, 2016;Build 27
 ;
 Q
 ;
CCODE(BSTSWS,ACODE) ;Retrieve list of concepts in CVX subsets and refresh
 ;
 ;Input
 ;BSTSWS - Array of connection settings
 ;ACODE - If 1 do no process items here
 ;
 NEW SLIST,DLIST,SBCNT,MFAIL,FWAIT,TRY,FCNT,STS,ABORT,ERSLT,LENTRY,REVIN,X1,X2,X,RUNSTRT,TR,BIPROG
 ;
 S ACODE=$G(ACODE)
 ;
 ;Retrieve restart information
 S BIPROG=$G(BSTSWS("BIPROG"))
 I BIPROG,($P(BIPROG,U,4)'="CCODE")!($P(BIPROG,U,5)'="BSTSDTS7") S ^XTMP("BSTSLCMP","QUIT")=1,STS=0 Q 0
 ;
 ;Update tracker
 S $P(^XTMP("BSTSLCMP","UPD"),U,4,5)="CCODE^BSTSDTS7"
 ;
 ;Get the current date
 S RUNSTRT=DT
 ;
 ;Get future date and set up revision in
 S X1=DT,X2=2 D C^%DTC
 S BSTSWS("REVIN")=$$FMTE^XLFDT(X,"7")
 ;
 S SLIST=$NA(^XTMP("BSTSLCMP")) ;Returned List
 S DLIST=$NA(^TMP("BSTSCMCL",$J))
 I $P(BIPROG,U,6)<10 D
 . K @DLIST
 . S $P(^XTMP("BSTSLCMP","UPD"),U,6)="10"
 ;
 ;Retrieve Failover Variables
 S MFAIL=$$FPARMS^BSTSVOFL()
 S FWAIT=$P(MFAIL,U,2)
 S MFAIL=$P(MFAIL,U)
 ;
 ;Get later date
 S X1=DT,X2=60 D C^%DTC
 ;
 ;Set up Monitoring Global
 I 'ACODE D
 . S ^XTMP("BSTSLCMP",0)=X_U_DT_U_"CVX subset refresh update running - Getting list"
 . K ^XTMP("BSTSLCMP","STS")
 ;
 ;Get list of concepts in subsets
 I $P(BIPROG,U,6)<20 S ^XTMP("BSTSLCMP","STS")="Generating a list of concepts in subsets"
 S STS=1 I $P(BIPROG,U,6)<20 F TR=10:10:60 D  I +STS Q
 .S (ABORT,FCNT,STS)=0 F TRY=1:1:(12*MFAIL) D  I +STS!(STS="0^") Q
 .. D RESET^BSTSWSV1  ;Reset the DTS link to on
 .. S STS=$$CCODE^BSTSCMCL(.BSTSWS,.ERSLT) I +STS!(STS="0^") Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL H FWAIT S FCNT=0 ;Fail handling
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"CCODE^BSTSDTS7 - Call to $$CCODE^BSTSCMCL")
 ... I ABORT=1 S STS="0^" S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("CVX SUBSET REFRESH LOOKUP FAILED")
 ... S FCNT=0
 . I '+STS H TR
 ;
 ;Quit on failure
 I +STS=0 Q 0
 ;
 ;Merge results to second scratch global
 I $P(BIPROG,U,6)<20 D
 . S SBCNT=0 F  S SBCNT=$O(@DLIST@(SBCNT)) Q:'SBCNT  D
 .. NEW DTSID,LAST
 .. S DTSID=$P(@DLIST@(SBCNT),U) Q:DTSID=""
 .. I $D(@SLIST@("DTS",DTSID)) Q
 .. S LAST=$O(@SLIST@("A"),-1)+1
 .. S @SLIST@(LAST)=@DLIST@(SBCNT)
 .. S @SLIST@("DTS",DTSID)=LAST
 ;
 ;Do not process if part of main update
 I ACODE Q 1
 ;
 S $P(^XTMP("BSTSLCMP","UPD"),U,6)="20"
 ;
 ;Get last entry
 S LENTRY=$O(@SLIST@("A"),-1)
 ;
 ;Now process each entry
 S (ABORT,SBCNT)=0 F  S SBCNT=$O(@SLIST@(SBCNT)) Q:'SBCNT  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 . NEW DTSID,VAR,TRY,FCNT,CIEN,SKIP
 . ;
 . ;Get DTSId
 . S DTSID=$P(@SLIST@(SBCNT),U) Q:DTSID=""
 . ;
 . S ^XTMP("BSTSLCMP","STS")="Getting concept details for DTSID: "_DTSID_" (Entry "_SBCNT_" of "_LENTRY_")"
 . ;
 . ;Pull detail from DTS - Hang max of 12 times
 . S (ABORT,FCNT)=0 F TRY=1:1:(12*MFAIL) D  I +STS=2!(STS="0^") K @SLIST@(SBCNT) Q
 .. D RESET^BSTSWSV1  ;Reset the DTS link to on
 .. S STS=$$DTSLKP^BSTSAPI("VAR",DTSID_"^5190^^^^1") I +STS=2!(STS="0^") Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"CCODE^BSTSDTS7 - Getting Update for entry: "_DTSID)
 ... I ABORT=1 S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("CVX SUBSET REFRESH FAILED ON DETAIL LOOKUP: "_DTSID)
 ... S FCNT=0
 ;
 ;Mark as error or complete
 I 'STS S ^XTMP("BSTSLCMP","QUIT")=1
 S:'$D(^XTMP("BSTSLCMP","QUIT")) $P(^XTMP("BSTSLCMP","UPD"),U,6)=200
 ;
 I 'STS Q 0
 Q 1
 ;
CUPDATE(NMID,ROUT) ;EP-Add/Update CVX
 ;
 ;CVX Only
 I $G(NMID)'=5190 Q 1
 ;
 N GL,CONCDA,BSTSC,INMID,ERROR,TCNT,I,CVRSN,ST,NROUT,TLIST,STYPE,RTR,TERMNSP,TERMSTS
 ;
 S GL=$NA(^TMP("BSTSCMCL",$J,1))
 S ROUT=$G(ROUT,"")
 ;
 ;Look for Concept Id
 I $P($G(@GL@("CONCEPTID")),U)="" Q 0
 ;
 ;Look for existing
 I $G(@GL@("DTSID"))="" Q 0
 S CONCDA=$O(^BSTS(9002318.4,"D",NMID,@GL@("DTSID"),""))
 ;
 ;Pull internal Code Set ID
 S INMID=$O(^BSTS(9002318.1,"B",NMID,"")) Q:INMID="" "0"
 ;
 ;Pull the current version
 S CVRSN=$$GET1^DIQ(9002318.1,INMID_",",.04,"I")
 ;
 ;None found - create new
 I CONCDA="" S CONCDA=$$NEWC^BSTSDTS0()
 ;
 ;Verify entry found/created
 I +CONCDA<0 Q 0
 ;
 ;Get Revision Out
 S NROUT=$P(@GL@("CONCEPTID"),U,3) S:NROUT="" NROUT=ROUT
 ;
 ;Set up top level
 S BSTSC(9002318.4,CONCDA_",",.02)=$P(@GL@("CONCEPTID"),U) ;Conc ID
 S BSTSC(9002318.4,CONCDA_",",.08)=@GL@("DTSID") ;DTSID
 S BSTSC(9002318.4,CONCDA_",",.07)=INMID ;Code Set
 S BSTSC(9002318.4,CONCDA_",",.03)="N"
 S BSTSC(9002318.4,CONCDA_",",.05)=$$EP2FMDT^BSTSUTIL($P(@GL@("CONCEPTID"),U,2),1)
 S BSTSC(9002318.4,CONCDA_",",.06)=$$EP2FMDT^BSTSUTIL(NROUT,1)
 S BSTSC(9002318.4,CONCDA_",",.11)="N"
 S BSTSC(9002318.4,CONCDA_",",.04)=CVRSN
 S BSTSC(9002318.4,CONCDA_",",.12)=DT
 S BSTSC(9002318.4,CONCDA_",",1)=$G(@GL@("FSN",1))
 ;
 S BSTSC(9002318.4,CONCDA_",",.16)=$S($G(@GL@("STS"))="I":1,1:0)
 ;
 ;Update additional RxNorm fields
 D UPCSUB(GL,CONCDA,.BSTSC)
 ;
 ;Save the entry
 I $D(BSTSC) D FILE^DIE("","BSTSC","ERROR")
 ;
 ;Reindex - needed for custom indices
 D
 . NEW DIK,DA
 . S DIK="^BSTS(9002318.4,",DA=CONCDA
 . D IX^DIK
 ;
 ;Save Terminology entries
 ;
 ;Synonyms/Preferred/FSN
 ;
 S STYPE="" F  S STYPE=$O(@GL@("SYN",STYPE)) Q:STYPE=""  S TCNT="" F  S TCNT=$O(@GL@("SYN",STYPE,TCNT)) Q:TCNT=""  D
 . ;
 . N TERM,TYPE,DESC,BSTST,ERROR,TMIEN,AIN,TRMSTS,TRMNSP
 . ;
 . ;Pull values
 . S TERM=$G(@GL@("SYN",STYPE,TCNT,1)) Q:TERM=""
 . ;
 . ;Limit to 244
 . S TERM=$E(TERM,1,244)
 . ;
 . S TERMSTS=$P($G(@GL@("SYN",STYPE,TCNT,0)),U,7)
 . ;
 . S TYPE=$P($G(@GL@("SYN",STYPE,TCNT,0)),U,2)
 . S TYPE=$S(TYPE=1:"P",1:"S")
 . I TERM=$G(@GL@("FSN",1)) S TYPE="F"
 . S DESC=$P($G(@GL@("SYN",STYPE,TCNT,0)),U) Q:DESC=""
 . S TERMNSP=$P($G(@GL@("SYN",STYPE,TCNT,0)),U,6)
 . S AIN=$$EP2FMDT^BSTSUTIL($P($G(@GL@("SYN",STYPE,TCNT,0)),U,3))
 . ;
 . ;Look up entry
 . S TMIEN=$O(^BSTS(9002318.3,"D",INMID,DESC,""))
 . ;
 . ;Entry not found - create new
 . I TMIEN="" S TMIEN=$$NEWT^BSTSDTS0()
 . I TMIEN<0 Q
 . ;
 . ;Save/update other fields
 . S BSTST(9002318.3,TMIEN_",",.02)=DESC
 . S BSTST(9002318.3,TMIEN_",",.09)=TYPE
 . S BSTST(9002318.3,TMIEN_",",1)=TERM
 . S BSTST(9002318.3,TMIEN_",",.04)="N"
 . S BSTST(9002318.3,TMIEN_",",.05)=CVRSN
 . S BSTST(9002318.3,TMIEN_",",.08)=INMID
 . S BSTST(9002318.3,TMIEN_",",.03)=CONCDA
 . S BSTST(9002318.3,TMIEN_",",.06)=AIN
 . S BSTST(9002318.3,TMIEN_",",.1)=DT
 . S BSTST(9002318.3,TMIEN_",",.11)="N"
 . S BSTST(9002318.3,TMIEN_",",.13)=TERMSTS
 . S BSTST(9002318.3,TMIEN_",",.14)=TERMNSP
 . D FILE^DIE("","BSTST","ERROR")
 . ;
 . ;Reindex - needed for custom indices
 . D
 .. NEW DIK,DA
 .. S DIK="^BSTS(9002318.3,",DA=TMIEN
 .. D IX^DIK
 ;
 Q $S($D(ERROR):"0^Update Failed",1:1)
 ;
UPCSUB(GL,CONCDA,BSTSC) ;Update CVX subsets
 ;
 ;Save Subsets
 ;
 ;Clear out existing entries
 NEW SB
 S SB=0 F  S SB=$O(^BSTS(9002318.4,CONCDA,4,SB)) Q:'SB  D
 . NEW DA,DIK
 . S DA(1)=CONCDA,DA=SB
 . S DIK="^BSTS(9002318.4,"_DA(1)_",4," D ^DIK
 ;
 I $D(@GL@("SUB"))>1 D
 . ;
 . NEW SB
 . S SB="" F  S SB=$O(@GL@("SUB",SB)) Q:SB=""  D
 .. ;
 .. NEW DIC,X,Y,DA,X,Y,IENS,DLAYGO,STYP,SID
 .. S DA(1)=CONCDA
 .. S DIC(0)="LX",DIC="^BSTS(9002318.4,"_DA(1)_",4,"
 .. S X=$P($G(@GL@("SUB",SB)),U) Q:X=""
 .. S DLAYGO=9002318.44 D ^DIC
 .. I +Y<0 Q
 .. S DA=+Y
 .. S IENS=$$IENS^DILF(.DA)
 .. S STYP=$P($G(@GL@("SUB",SB)),U,4)
 .. S SID=$P($G(@GL@("SUB",SB)),U,5)
 .. S BSTSC(9002318.44,IENS,".02")=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("SUB",SB)),U,2))
 .. S BSTSC(9002318.44,IENS,".04")=$S(STYP]"":STYP,1:"@")
 .. S BSTSC(9002318.44,IENS,".05")=$S(SID]"":SID,1:"@")
 ;
 Q
