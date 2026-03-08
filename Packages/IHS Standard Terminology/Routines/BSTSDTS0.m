BSTSDTS0 ;GDIT/HS/BEE-Standard Terminology DTS Calls/Processing ; 5 Nov 2012  9:53 AM
 ;;2.0;IHS STANDARD TERMINOLOGY;**3,4,5,8**;Dec 01, 2016;Build 27
 ;
 Q
 ;
CNCSR(OUT,BSTSWS) ;EP - Search Call - Conc Lookup
 ;
 N II,STS,SEARCH,STYPE,MAX,DTSID,NMID
 N BSTRT,BSCNT,SLIST,DLIST,RES,RCNT,CNT,ST
 ;
 S SEARCH=$G(BSTSWS("SEARCH"))
 S STYPE=$G(BSTSWS("STYPE"))
 S SLIST=$NA(^TMP("BSTSPDET",$J)) ;Sort List
 S DLIST=$NA(^TMP("BSTSCMCL",$J)) ;DTS Ret List
 K @SLIST,@DLIST,@OUT
 ;
 ;Determine max to ret
 S MAX=$G(BSTSWS("MAXRECS")) S:MAX="" MAX=25
 S BSTRT=+$G(BSTSWS("BCTCHRC")) S:BSTRT=0 BSTRT=1
 S BSCNT=+$G(BSTSWS("BCTCHCT")) S:BSCNT=0 BSCNT=MAX
 S NMID=$G(BSTSWS("NAMESPACEID")) S:NMID="" NMID=36 S:NMID=30 NMID=36
 ;
 ;Lookup on Conc Id
 S STS=$$CNCSR^BSTSCMCL(.BSTSWS,.RES) I $G(BSTSWS("DEBUG")) W !!,STS
 ;
 ;Sort results (should be one)
 S DTSID="" F  S DTSID=$O(@DLIST@(DTSID)) Q:DTSID=""  S @SLIST@(@DLIST@(DTSID),DTSID)=""
 ;
 ;Loop through res and retrieve det
 S II="",RCNT=0 F  S II=$O(@SLIST@(II),-1) Q:II=""  D  Q:RCNT
 . S DTSID="" F  S DTSID=$O(@SLIST@(II,DTSID)) Q:DTSID=""  D  Q:RCNT
 .. ;
 .. N STATUS,CONC,ERSLT,SNAPDT
 .. ;
 .. ;Upd entry
 .. S BSTSWS("DTSID")=DTSID
 .. ;
 .. ;Change snapshot dt
 .. S SNAPDT=$$DTCHG^BSTSUTIL(DT,2)_".0001"
 .. S SNAPDT=$$FMTE^BSTSUTIL(SNAPDT)
 .. S BSTSWS("SNAPDT")=SNAPDT
 .. ;
 .. ;Clear res file
 .. K @DLIST
 .. ;
 .. ;Get Det for conc
 .. S STATUS=$$DETAIL^BSTSCMCL(.BSTSWS,.ERSLT)
 .. I $G(BSTSWS("DEBUG")) W !!,"Detail Call Status: ",STATUS
 .. ;
 .. ;File Det
 .. S STATUS=$$UPDATE(NMID)
 .. I $G(BSTSWS("DEBUG")) W !!,"Update Call Status: ",STATUS
 .. ;
 .. ;Look again to see if conc logged
 .. S CONC=$$CONC(DTSID,.BSTSWS,1,1)
 .. I CONC]"" D  Q
 ... I CONC'=BSTSWS("SEARCH") Q
 ... S RCNT=$G(RCNT)+1,@OUT@(RCNT)=CONC_U_DTSID
 ;
 Q STS
 ;
UPDATE(NMID,ROUT) ;EP - Add/Upd Conc and Term(s)
 ;
 ;Update UNII
 I $G(NMID)=5180 Q $$UUPDATE^BSTSDTS1(NMID,$G(ROUT))
 ;
 ;Update RxNorm
 I $G(NMID)=1552 Q $$RUPDATE^BSTSDTS1(NMID,$G(ROUT))
 ;
 ;GDIT/HS/BEE;FEATURE#123647;Check for new CVX version
 ;Update CVX
 I $G(NMID)=5190 Q $$CUPDATE^BSTSDTS7(NMID,$G(ROUT))
 ;
 ;Section only applies to SNOMED
 I $G(NMID)'=36 Q $$SUPDATE^BSTSDTS3(NMID,$G(ROUT))
 ;
 N GL,CONCDA,BSTSC,INMID,ERROR,TCNT,I,CVRSN,ST,NROUT,TLIST,STYPE,RTR,SVOUT,TUPDT
 ;
 S GL=$NA(^TMP("BSTSCMCL",$J,1))
 S ROUT=$G(ROUT,"")
 ;
 ;Look for Conc Id
 I $P($G(@GL@("CONCEPTID")),U)="" Q 0
 ;
 ;Look for existing ent
 I $G(@GL@("DTSID"))="" Q 0
 S CONCDA=$O(^BSTS(9002318.4,"D",NMID,@GL@("DTSID"),""))
 ;
 ;Pull int Code Set ID
 S INMID=$O(^BSTS(9002318.1,"B",NMID,"")) Q:INMID="" "0"
 ;
 ;Pull current ver
 S CVRSN=$$GET1^DIQ(9002318.1,INMID_",",.04,"I")
 ;
 D REPL^BSTSRPT(CONCDA,GL)
 ;
 ;GDIT/HS/BEE;12/1/2022;FEATURE#76919;Handle inactives - No longer retiring
 ;Handle retired concepts
 ;I CONCDA]"",'$$RET^BSTSDTS3(CONCDA,CVRSN,GL) Q 0
 ;
 ;None found - create
 I CONCDA="" S CONCDA=$$NEWC()
 ;
 ;Verify found/created
 I +CONCDA<0 Q 0
 ;
 ;Pull int Code Set ID
 S INMID=$O(^BSTS(9002318.1,"B",NMID,"")) Q:INMID="" "0"
 ;
 ;Pull current vrsn
 S CVRSN=$$GET1^DIQ(9002318.1,INMID_",",.04,"I")
 ;
 ;Get Rev Out
 S NROUT=$P(@GL@("CONCEPTID"),U,3) S:NROUT="" NROUT=ROUT
 S SVOUT=NROUT S SVOUT=$S(SVOUT]"":$$DTS2FMDT^BSTSUTIL(NROUT,1),1:"@")
 ;
 ;Set up top level concept fields
 S BSTSC(9002318.4,CONCDA_",",.02)=$P(@GL@("CONCEPTID"),U) ;Concept ID
 S BSTSC(9002318.4,CONCDA_",",.08)=@GL@("DTSID") ;DTS ID
 S BSTSC(9002318.4,CONCDA_",",.07)=INMID ;Code Set
 S BSTSC(9002318.4,CONCDA_",",.03)="N"
 S BSTSC(9002318.4,CONCDA_",",.05)=$$DTS2FMDT^BSTSUTIL($P(@GL@("CONCEPTID"),U,2),1)
 S BSTSC(9002318.4,CONCDA_",",.06)=SVOUT
 S BSTSC(9002318.4,CONCDA_",",.11)="N"
 S BSTSC(9002318.4,CONCDA_",",.13)="N"
 S BSTSC(9002318.4,CONCDA_",",.04)=CVRSN
 S BSTSC(9002318.4,CONCDA_",",.12)=DT
 S BSTSC(9002318.4,CONCDA_",",.15)="@"
 ;
 ;GDIT/HS/BEE;12/1/2022;FEATURE#76919;Handle inactives - concept status
 S BSTSC(9002318.4,CONCDA_",",.16)=$S($G(@GL@("STS"))="I":1,1:0)
 S BSTSC(9002318.4,CONCDA_",",1)=$G(@GL@("FSN",1))
 ;
 ;Save ISA
 D ISA^BSTSDTS6(GL,NMID,CVRSN,CONCDA,.BSTSC,INMID)
 ;
 ;Save Children (subconcepts)
 D CHILD^BSTSDTS6(GL,NMID,CVRSN,CONCDA,.BSTSC,INMID)
 ;
 ;Need to interim save because subsets look at .07
 I $D(BSTSC) D FILE^DIE("","BSTSC","ERROR")
 ;
 ;Save Subsets
 D SUB^BSTSDTS4(CONCDA,GL,.BSTSC)
 ;
 ;Save ICD Mapping
 ;
 ;Clear out existing
 D
 . NEW IC
 . S IC=0 F  S IC=$O(^BSTS(9002318.4,CONCDA,3,IC)) Q:'IC  D
 .. NEW DA,DIK
 .. S DA(1)=CONCDA,DA=IC
 .. S DIK="^BSTS(9002318.4,"_DA(1)_",3," D ^DIK
 ;
 ;Save ICD9 first
 I $D(@GL@("ICD9"))>1 D
 . N ICD
 . S ICD="" F  S ICD=$O(@GL@("ICD9",ICD)) Q:ICD=""  D
 .. N DA,IENS,ICDCD
 .. ;
 .. ;Look up entry
 .. S DA(1)=CONCDA
 .. S ICDCD=$P($G(@GL@("ICD9",ICD)),U) Q:ICDCD=""
 .. S DA=$O(^BSTS(9002318.4,DA(1),3,"C",ICDCD,""))
 .. ;
 .. ;Create new
 .. I DA="" S DA=$$NEWI(CONCDA)
 .. Q:DA<0
 .. ;
 .. ;Add additional fields
 .. S IENS=$$IENS^DILF(.DA)
 .. S BSTSC(9002318.43,IENS,".02")=ICDCD
 .. S BSTSC(9002318.43,IENS,".03")="IC9"
 .. S BSTSC(9002318.43,IENS,".04")=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("ICD9",ICD)),U,2))
 .. S BSTSC(9002318.43,IENS,".05")=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("ICD9",ICD)),U,3))
 ;
 ;Save ICD10 Mapping Next
 I $D(@GL@("A10"))>1 D
 . N ICD,MG
 . ;GDIT/HS/BEE;03/27/2024;FEATURE#86669;Handle unconditional map groups
 . ;S ICD="" F  S ICD=$O(@GL@("A10",ICD)) Q:ICD=""  D
 . S MG="" F  S MG=$O(@GL@("A10",MG)) Q:MG=""  S ICD="" F  S ICD=$O(@GL@("A10",MG,ICD)) Q:ICD=""  D
 .. N DA,IENS,ICDCD
 .. ;
 .. ;Look up
 .. S DA(1)=CONCDA
 .. S ICDCD=$P($G(@GL@("A10",MG,ICD)),U) Q:ICDCD=""
 .. S DA=$O(^BSTS(9002318.4,DA(1),3,"C",ICDCD,""))
 .. ;
 .. ;Create new
 .. I DA="" S DA=$$NEWI(CONCDA)
 .. Q:DA<0
 .. ;
 .. ;Add additional fields
 .. S IENS=$$IENS^DILF(.DA)
 .. S BSTSC(9002318.43,IENS,".02")=ICDCD
 .. S BSTSC(9002318.43,IENS,".03")="10D"
 .. S BSTSC(9002318.43,IENS,".04")=$$DTS2FMDT^BSTSUTIL($P($P($G(@GL@("A10",ICD)),U,5)," "))
 .. S BSTSC(9002318.43,IENS,".05")=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("A10",ICD)),U,6))
 ;
 ;GDIT/HS/BEE;12/1/2022;FEATURE#76919;Handle inactives - moved code to free up space
 ;Save ICD9 to SNOMED Mapping
 D ICD9^BSTSDTS4(CONCDA,GL)
 ;
 ;Save Conditional Mappings
 D SAVEMAP^BSTSMAP1(CONCDA,.BSTSC,GL)
 ;
 D EQLAT^BSTSDTS4(CONCDA,.BSTSC,GL)
 ;
 I $D(BSTSC) D FILE^DIE("","BSTSC","ERROR")
 ;
 ;Now save Terminology entries
 ;
 ;Syn/Pref/FSN
 ;
 S STYPE="" F  S STYPE=$O(@GL@("SYN",STYPE)) Q:STYPE=""  S TCNT="" F  S TCNT=$O(@GL@("SYN",STYPE,TCNT)) Q:TCNT=""  D
 . ;
 . N TERM,TYPE,DESC,BSTST,ERROR,TMIEN,AIN,AOUT,ITERM,TERMNSP,TERMSTS,TIEN
 . ;
 . ;Pull values
 . S TERM=$G(@GL@("SYN",STYPE,TCNT,1)) Q:TERM=""
 . ;
 . ;GDIT/HS/BEE;12/1/2022;FEATURE#76919;Handle inactives - don't quit if inactive
 . ;Quit if found
 . S TERMSTS=$P($G(@GL@("SYN",STYPE,TCNT,0)),U,7)
 . ;I $D(TLIST(TERM)),'TERMSTS Q
 . ;I 'TERMSTS S TLIST(TERM)=""
 . ;
 . S TYPE=$P($G(@GL@("SYN",STYPE,TCNT,0)),U,2)
 . S TYPE=$S(TYPE=1:"P",1:"S")
 . I TERM=$G(@GL@("FSN",1)) S TYPE="F"
 . S DESC=$P($G(@GL@("SYN",STYPE,TCNT,0)),U) Q:DESC=""
 . S AIN=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("SYN",STYPE,TCNT,0)),U,3))
 . S AOUT=$$DTS2FMDT^BSTSUTIL($P($G(@GL@("SYN",STYPE,TCNT,0)),U,4))
 . ;GDIT/HS/BEE;12/1/2022;FEATURE#76919;Handle inactives - Namespace and status
 . S TERMNSP=$P($G(@GL@("SYN",STYPE,TCNT,0)),U,6)
 . ;S ITERM=$P($G(@GL@("SYN",STYPE,TCNT,0)),U,5) S ITERM=$S(ITERM=32768:1,1:"")
 . S ITERM=$S(TERMNSP=32768:1,1:"@")
 . S:AOUT="" AOUT="@"
 . ;
 . ;Look up entry
 . S TMIEN=$O(^BSTS(9002318.3,"D",INMID,DESC,""))
 . ;
 . ;Entry not found - create
 . I TMIEN="" S TMIEN=$$NEWT()
 . I TMIEN<0 Q
 . ;
 . ;Save that it was created/upd, skip if already updated and active
 . Q:$G(TUPDT(TMIEN))
 . S TUPDT(TMIEN)='TERMSTS
 . ;
 . ;Save/update other fields
 . S BSTST(9002318.3,TMIEN_",",.02)=DESC
 . S BSTST(9002318.3,TMIEN_",",.09)=TYPE
 . S BSTST(9002318.3,TMIEN_",",.04)="N"
 . S BSTST(9002318.3,TMIEN_",",.05)=CVRSN
 . S BSTST(9002318.3,TMIEN_",",.08)=INMID
 . S BSTST(9002318.3,TMIEN_",",.03)=CONCDA
 . S BSTST(9002318.3,TMIEN_",",.06)=AIN
 . S BSTST(9002318.3,TMIEN_",",.07)=AOUT
 . S BSTST(9002318.3,TMIEN_",",.1)=DT
 . S BSTST(9002318.3,TMIEN_",",.11)="N"
 . S BSTST(9002318.3,TMIEN_",",.12)=ITERM
 . ;GDIT/HS/BEE;12/1/2022;FEATURE#76919;Handle inactives - Namespace and status
 . S BSTST(9002318.3,TMIEN_",",.13)=TERMSTS
 . S BSTST(9002318.3,TMIEN_",",.14)=TERMNSP
 . S BSTST(9002318.3,TMIEN_",",1)=TERM
 . D FILE^DIE("","BSTST","ERROR")
 . ;
 . ;Reindex
 . D
 .. NEW DIK,DA
 .. S DIK="^BSTS(9002318.3,",DA=TMIEN
 .. D IX^DIK
 ;
 ;Mark any existing that weren't touched as inactive
 S TIEN="" F  S TIEN=$O(^BSTS(9002318.3,"C",36,CONCDA,TIEN)) Q:'TIEN  I '$D(TUPDT(TIEN)) D
 . NEW TUPD,TERR,TCONC
 . ;
 . ;If term isn't linked to current concept, remove index
 . S TCONC=$$GET1^DIQ(9002318.3,TIEN_",",.03,"I")
 . I TCONC'=CONCDA D  Q
 .. K ^BSTS(9002318.3,"C",36,CONCDA,TIEN)
 . ;
 . S TUPD(9002318.3,TIEN_",",.13)=1
 . D FILE^DIE("","TUPD","TERR")
 ;
 ;Save ICD Map info
 I '$D(ERROR) S STS=$$ICDMAP^BSTSDTS2(CONCDA,GL)
 I '$D(ERROR) S STS=$$ICDMAP^BSTSDTSM(CONCDA,GL)
 ;
 ;GDIT/HS/BEE;12/1/2022;FEATURE#76919;Handle inactives - No longer retiring
 ;Need to check for retired concepts again since it may have just been added
 ;S RTR=$$RET^BSTSDTS3(CONCDA,CVRSN,GL)
 ;
 Q $S($D(ERROR):"0^Update Failed",1:1)
 ;
CONC(DTSID,BSTSWS,SKPOD,SKPDT) ;EP - Determine if Code on File (and up to date)
 ;
 NEW CONC,CIEN,CONC,SNAPDT,NMID,BEGDT,ENDDT
 ;
 S SKPOD=$G(SKPOD) ;Set to 1 to skip out of date checking
 S SKPDT=$G(SKPDT) ;Set to 1 to skip date checking
 ;
 ;Get namespace
 S NMID=$G(BSTSWS("NAMESPACEID")) S:NMID="" NMID=36 S:NMID=30 NMID=36
 ;
 ;Pull conc IEN
 S CIEN=$O(^BSTS(9002318.4,"D",NMID,DTSID,"")) Q:CIEN="" ""
 ;
 ;Quit if out of date
 I 'SKPOD,$$GET1^DIQ(9002318.4,CIEN_",",".11","I")="Y" Q ""
 ;
 ;Look in date range
 S SNAPDT=$G(BSTSWS("SNAPDT")) S:SNAPDT]"" SNAPDT=$$DATE^BSTSUTIL(SNAPDT)
 S:SNAPDT="" SNAPDT=DT
 ;
 I 'SKPDT S BEGDT=$$GET1^DIQ(9002318.4,CIEN_",",".05","I") I BEGDT]"",SNAPDT<BEGDT Q ""
 I 'SKPDT S ENDDT=$$GET1^DIQ(9002318.4,CIEN_",",".06","I") I ENDDT]"",SNAPDT>ENDDT Q ""
 ;
 S CONC=$$GET1^DIQ(9002318.4,CIEN_",",".02","E")
 ;
 Q CONC
 ;
GCDSDTS4(BSTSWS) ;EP - update codeset
 ;
 N RESULT,STS,II,BSTSUP,ERROR
 ;
 S STS=$$GCDSDTS4^BSTSCMCL(.BSTSWS,.RESULT)
 ;
 ;Update Local BSTS CODESET file
 S II="" F  S II=$O(RESULT(II),-1) Q:II=""  D
 . ;
 . N DIC,X,Y,DLAYGO,DIC
 . S X=$G(RESULT(II,"NAMESPACE","ID")) Q:'X
 . S DIC(0)="XL",DIC="^BSTS(9002318.1,",DLAYGO=9002318.1 D ^DIC
 . I +Y<0 Q
 . S BSTSUP(9002318.1,+Y_",",.02)=$G(RESULT(II,"NAMESPACE","CODE"))
 . S BSTSUP(9002318.1,+Y_",",.03)=$G(RESULT(II,"NAMESPACE","NAME"))
 I $D(BSTSUP) D FILE^DIE("","BSTSUP","ERROR")
 ;
 Q STS
 ;
GVRDTS4(BSTSWS) ;EP - update vrsns
 ;
 NEW RESULT,STS
 ;
 ;Reset Scratch gbl and make DTS call
 S RESULT=$NA(^TMP("BSTSCMCL",$J))
 K @RESULT
 S STS=$$GVRDTS4^BSTSCMCL(.BSTSWS)
 ;
 ;Upd file with results
 I STS D
 . NEW NMID,NMIEN,VDT,CNT,VRID,CVID,BSTS,ERR
 . S NMID=$G(BSTSWS("NAMESPACEID"))
 . S NMIEN=$O(^BSTS(9002318.1,"B",NMID,""),-1) Q:NMIEN=""
 . S (VRID,CNT)="" F  S CNT=$O(@RESULT@(CNT),-1) Q:'CNT  D
 .. S VDT="" F  S VDT=$O(@RESULT@(CNT,"VERSION",VDT)) Q:VDT=""  D
 ... NEW RDT,NAME,DA,IENS,BSTSUP,ERROR
 ... S RDT=$G(@RESULT@(CNT,"VERSION",VDT,"RELEASEDATE"))
 ... S NAME=$G(@RESULT@(CNT,"VERSION",VDT,"NAME"))
 ... ;
 ... ;Look for existing entry
 ... S DA=$O(^BSTS(9002318.1,NMIEN,1,"B",VDT,""))
 ... ;
 ... ;Create record
 ... S:DA="" DA=$$NEWV(NMIEN,VDT)
 ... I +DA<0 Q
 ... S VRID=VDT
 ... S DA(1)=NMIEN,IENS=$$IENS^DILF(.DA)
 ... ;
 ... ;Add/Upd remaining fields
 ... S BSTSUP(9002318.11,IENS,".02")=NAME
 ... S BSTSUP(9002318.11,IENS,".03")=$$DTS2FMDT^BSTSUTIL($P(RDT,"."))
 ... D FILE^DIE("","BSTSUP","ERROR")
 . ;
 Q STS
 ;
NEWV(NMIEN,VDT) ;Create ICD Mapping entry
 N DIC,X,Y,DA,DLAYGO
 S DIC(0)="L",DA(1)=NMIEN
 S DLAYGO=9002318.11,DIC="^BSTS(9002318.1,"_DA(1)_",1,"
 S X=VDT
 D ^DIC
 Q +Y
 ;
 ;
NEWC() ;Create concept entry
 N DIC,X,Y,DLAYGO
 S DIC(0)="L",DIC=9002318.4
 L +^BSTS(9002318.4,0):1 E  Q ""
 S X=$P($G(^BSTS(9002318.4,0)),U,3)+1
 S DLAYGO=9002318.4 D ^DIC
 L -^BSTS(9002318.4,0)
 Q +Y
 ;
NEWT() ;Create terminology entry
 N DIC,X,Y,DLAYGO
 S DIC(0)="L",DIC=9002318.3
 L +^BSTS(9002318.3,0):1 E  Q ""
 S X=$P($G(^BSTS(9002318.3,0)),U,3)+1
 S DLAYGO=9002318.3 D ^DIC
 L -^BSTS(9002318.3,0)
 Q +Y
 ;
NEWI(CIEN) ;Create ICD Mapping entry
 N DIC,X,Y,DA,DLAYGO
 S DIC(0)="L",DA(1)=CIEN
 S DIC="^BSTS(9002318.4,"_DA(1)_",3,"
 L +^BSTS(9002318.4,CIEN,3,0):1 E  Q ""
 S X=$P($G(^BSTS(9002318.4,CIEN,3,0)),U,3)+1
 S DLAYGO=9002318.43 D ^DIC
 L -^BSTS(9002318.4,CIEN,3,0)
 Q +Y
