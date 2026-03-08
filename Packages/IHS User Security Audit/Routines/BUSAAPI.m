BUSAAPI ;GDIT/HS/BEE-IHS USER SECURITY AUDIT Utility API Program ; 31 Jan 2013  9:53 AM
 ;;1.0;IHS USER SECURITY AUDIT;**1,3,4,5**;Nov 05, 2013;Build 42
 ;
 Q
 ;
 ;BUSA*1.0*1;GDIT/HS/BEE 02/05/18 - Added HASH
 ;
 ;GDIT/HS/BEE 02/05/18 - BUSA*1.0*1 Added HASH input parameter
LOG(TYPE,CAT,ACTION,CALL,DESC,DETAIL,HASH) ;PEP - Log Security Audit Entries
 ;
 ; Required variables:
 ;   DUZ - Pointer to NEW PERSON (#200) file
 ;
 ;Input Parameters:
 ;   TYPE - (Optional) - The type of entry to log (R:RPC Call;W:Web Service
 ;                       Call;A:API Call;O:Other)
 ;                       (Default - A)
 ;    CAT - (Required) - The category of the event to log (S:System Event;
 ;                       P:Patient Related;D:Definition Change;
 ;                       O:Other Event)
 ; ACTION - (Required for CAT="P") - The action of the event to log
 ;                       (A:Additions;D:Deletions;Q:Queries;P:Print;
 ;                       E:Changes;C:Copy;AC:Access to patient information;
 ;                       EA:Emergency access to patient information;U:Change
 ;                       to user privilege;AL:Change to audit log status;ES:
 ;                       Change to encryption status)
 ;   CALL - (Required) - Free text entry describing the call which 
 ;                       originated the audit request (Maximum length
 ;                       200 characters)
 ;                       Examples could be an RPC value or calling
 ;                       routine
 ;   DESC - (Required) - Free text entry describing the call action
 ;                       (Maximum length 250 characters)
 ;                       Examples could be 'Patient demographic update',
 ;                       'Copied iCare panel to clipboard' or 'POV Entry'
 ;
 ; DETAIL - Array of patient/visit records to log. Required for patient 
 ;          related events. Optional for other event types
 ;
 ; Format: DETAIL(#)=DFN^VIEN^EVENT DESCRIPTION^NEW VALUE^ORIGINAL VALUE
 ;
 ; Where:
 ; # - Record counter (1,2,3...)
 ; DFN - (Optional for non-patient related calls) - Pointer to VA PATIENT file (#2)
 ; VIEN - (Optional for non-visit related calls) - Pointer to VISIT file (#9000010)
 ; EVENT DESCRIPTION -(Optional) - Additional detail to log for this entry
 ; NEW VALUE - (Optional) - New value after call completion, if applicable
 ; ORIGINAL VALUE - (Optional) - Original value prior to call execution, if applicable
 ;
 ; HASH - (Optional) - 1 to save hash value for record
 ;
 NEW STS,SIEN,BUSAUPD,ERROR,BUSAII
 S STS=""
 ;
 ;Make sure logging switch is on
 I '$D(^BUSA(9002319.04,"S","M",1)) S STS="0^Master audit logging switch is off" G XLOG
 ;
ALTENT ;Entry point from bypass call
 ;
 ;Check for DUZ (USER filed)
 I '$G(DUZ) S STS="0^Invalid DUZ value" G XLOG
 ;
 ;GDIT/HS/BEE 02/05/18 - BUSA*1.0*1 Added HASH input parameter definition (next line)
 ;GDIT/HS/BEE 02/05/18 - BUSA*1.0*3 Default to HASH
 ;S HASH=+$G(HASH)
 S HASH=$S($G(HASH)=0:0,1:1)
 ;
 ;Check for TYPE (ENTRY TYPE field)
 S TYPE=$G(TYPE,"") S:TYPE="" TYPE="A"
 ;
 ;Check for CAT (CATEGORY field)
 I $G(CAT)="" S STS="0^Invalid CAT value" G XLOG
 ;
 ;Action
 S ACTION=$G(ACTION,"") I ACTION="",CAT="P" S STS="0^Action required if Patient Category" G XLOG
 ;
 ;Check for CALL (ORIGINATING CALL field)
 I $G(CALL)="" S STS="0^Invalid CALL value" G XLOG
 ;
 ;Check for DESC (ENTRY DESCRIPTION field)
 I $G(DESC)="" S STS="0^Invalid DESC value" G XLOG
 ;
 ;Log new BUSA AUDIT LOG SUMMARY entry
 S SIEN=$$NEWS() I 'SIEN S STS="0^Unable to create summary entry" G XLOG
 ;
 ;Log remaining summary fields
 S BUSAUPD(9002319.01,SIEN_",",.02)=DUZ  ;USER
 S BUSAUPD(9002319.01,SIEN_",",.03)=CAT  ;CATEGORY
 S BUSAUPD(9002319.01,SIEN_",",.04)=TYPE ;ENTRY TYPE
 S BUSAUPD(9002319.01,SIEN_",",.05)=ACTION  ;ACTION
 S BUSAUPD(9002319.01,SIEN_",",.06)=$E(CALL,1,200)  ;ORIGINATING CALL
 S BUSAUPD(9002319.01,SIEN_",",1)=$E(DESC,1,250)  ;ENTRY DESCRIPTION
 ;GDIT/HS/BEE 02/05/18 - BUSA*1.0*1 Added HASH save
 I HASH=1 D
 . NEW LDTTM,HVAL
 . S LDTTM=$$GET1^DIQ(9002319.01,SIEN_",",.01,"I")
 . S HVAL=LDTTM_U_DUZ_U_CAT_U_TYPE_U_ACTION_U_$E(CALL,1,200)_U_$E(DESC,1,250)
 . S HVAL=$$HASH(HVAL)
 . S BUSAUPD(9002319.01,SIEN_",",2)=HVAL ;Record Hash
 ;End of BUSA*1.0*1 Changes
 D FILE^DIE("","BUSAUPD","ERROR") I $D(ERROR) S STS="0^"_$G(ERROR) G XLOG
 ;
 ;Log BUSA AUDIT LOG DETAIL entries
 I $G(DETAIL)]"" S BUSAII=0 F  S BUSAII=$O(@DETAIL@(BUSAII)) Q:BUSAII=""  D  Q:STS]""
 . NEW DIEN,BUSADET,ND
 . ;
 . ;Log detail entry
 . S ND=$G(@DETAIL@(BUSAII))
 . S DIEN=$$NEWD(SIEN) I 'DIEN S STS="0^Unable to create detail entry" Q
 . ;
 . ;Plug in DFN using VIEN (if DFN is blank)
 . I $P(ND,U)="",$P(ND,U,2)]"" S $P(ND,U)=$$GET1^DIQ(9000010,$P(ND,U,2)_",",".05","I")
 . ;
 . ;Log remaining detail fields
 . S:$P(ND,U)]"" BUSADET(9002319.02,DIEN_",",.02)=$P(ND,U)
 . S:$P(ND,U,2)]"" BUSADET(9002319.02,DIEN_",",.03)=$P(ND,U,2)
 . S:$P(ND,U,3)]"" BUSADET(9002319.02,DIEN_",",.04)=$E($P(ND,U,3),1,200)
 . ;
 . ;New value
 . I $P(ND,U,4)]"" D
 .. N TXT,VAR
 .. D WRAP^BUSAUTIL(.TXT,$P(ND,U,4),220)
 .. S VAR="TXT"
 .. D WP^DIE(9002319.02,DIEN_",",1,"",VAR)
 . ;
 . ;Original value
 . I $P(ND,U,5)]"" D
 .. N TXT,VAR
 .. D WRAP^BUSAUTIL(.TXT,$P(ND,U,5),220)
 .. S VAR="TXT"
 .. D WP^DIE(9002319.02,DIEN_",",2,"",VAR)
 . D FILE^DIE("","BUSADET","ERROR") I $D(ERROR) S STS="0^"_$G(ERROR) Q
 . ;
 . ;Save the detailed hash
 . I HASH=1 D
 .. NEW DHASH,BUSAHSH,ERROR
 .. S DHASH=$$DHASH(DIEN)
 .. S BUSAHSH(9002319.02,DIEN_",",3)=DHASH
 .. D FILE^DIE("","BUSAHSH","ERROR") I $D(ERROR) S STS="0^"_$G(ERROR) Q
 ;
 I STS]"" G XLOG
 ;
 ;Successful log
 S STS=1
 ;
 ;Log Exit Point
XLOG Q STS
 ;
BYPSLOG(TYPE,CAT,ACTION,CALL,DESC,DETAIL,HASH) ;EP - Log Security Audit Entries
 ;
 ;This API makes the call to log an audit entry but bypasses the check
 ;to see if the master audit is turned on
 ;
 NEW STS,SIEN,BUSAUPD,ERROR,BUSAII
 S STS=""
 ;
 G ALTENT
 ;
NEWS() ;EP - Create new BUSA AUDIT LOG SUMMARY entry stub
 N DIC,X,Y,DA,DLAYGO,%,DINUM,DO,DD
 S DIC(0)="L",DIC="^BUSAS(",DLAYGO=DIC
 D NOW^%DTC
 S X=%
 K DO,DD D FILE^DICN
 Q +Y
 ;
NEWD(SIEN) ;EP - Create new BUSA AUDIT LOG DETAIL entry stub
 N DIC,X,Y,DA,DLAYGO,DO,DD
 S DIC(0)="L",DIC="^BUSAD(",DLAYGO=DIC
 S X=SIEN
 K DO,DD D FILE^DICN
 Q +Y
 ;
 ;GDIT/HS/BEE 02/05/18 - BUSA*1.0*1 Added HASH tag
HASH(STR) ;EP - Calculate the HASH value
 ;
 N HASH,RTN,EXEC
 ;
 S EXEC="S HASH=##class(%SYSTEM.Encryption).SHAHash(256,STR)" X EXEC
 S EXEC="S RTN=$System.Encryption.Base64Encode(HASH)" X EXEC
 Q $G(RTN)
 ;
 ;GDIT/HS/BEE 03/31/20 - BUSA*1.0*3 Added DHASH tag
DHASH(DIEN,ARCH) ;Calculate the HASH value of a given detail entry
 ;
 ;Determine if from archive
 S ARCH=$G(ARCH)
 ;
 NEW HASH,QGBL,ESTR
 ;
 ;Validate the entry
 I ARCH S DREF="^BUSADA"
 E  S DREF="^BUSAD"
 I +$G(DIEN)=0 Q ""
 I '$D(@DREF@(DIEN,0)) Q ""
 ;
 ;Assemble string
 S ESTR="",QGBL=DREF_"("_DIEN_")" F  S QGBL=$Q(@QGBL) Q:(QGBL'[DIEN)!(QGBL[(DIEN_",3"))  S ESTR=ESTR_@QGBL
 ;
 ;Get the hash
 S HASH=$$HASH(ESTR)
 ;
 Q HASH
 ;
 ;GDIT/HS/BEE 02/05/18 - BUSA*1.0*1 Added HASHCK tag
HASHCK(IEN,DIEN,ARCH) ;EP - Calculate whether there is a Hash Mismatch for the summary entry
 ;
 ;Determine if from archive call
 S ARCH=$G(ARCH)
 ;
 NEW RSLT,LDT,USR,CAT,TYP,ACT,CAL,DSC,HASH,CHASH,N0,N1,DFND,CFND,SREF,DREF,BUSAR
 ;
 S RSLT=""
 ;
 ;For efficiency doing direct global reads
 I ARCH S SREF="^BUSASA"
 E  S SREF="^BUSAS"
 S HASH=$P($G(@SREF@(IEN,2)),"^") Q:HASH="" ""   ;Quit if no hash recorded
 S N0=$G(@SREF@(IEN,0))
 S N1=$G(@SREF@(IEN,1))
 ;
 S LDT=$P(N0,"^")
 S USR=$P(N0,"^",2)
 S CAT=$P(N0,"^",3)
 S TYP=$P(N0,"^",4)
 S ACT=$P(N0,"^",5)
 S CAL=$P(N0,"^",6)
 S DSC=$P(N1,"^")
 ;
 S CHASH=$$HASH(LDT_"^"_USR_"^"_CAT_"^"_TYP_"^"_ACT_"^"_CAL_"^"_DSC)
 ;
 ;Look for detail hash mismatch
 S DFND="" I $G(DIEN)]"" D
 . NEW ODHASH,DHASH
 . I ARCH S DREF="^BUSADA"
 . E  S DREF="^BUSAD"
 . S ODHASH=$$DHASH(DIEN,ARCH)
 . S DHASH=$P($G(@DREF@(DIEN,3)),"^")
 . I ODHASH="" Q
 . I ODHASH'=DHASH S DFND=1
 ;
 S CFND="" I CHASH'=HASH S CFND=1
 ;
 ;GDIT/HS/BEE 06/10/21 - BUSA*1.0*4 Feature 60284;Remediation handling
 I CFND=1,$$CHECK^BUSAAPIR("BUSAS Entry - HASH Mismatch",IEN,.BUSAR) S CFND=""
 I DFND=1,$G(DIEN)]"",$$CHECK^BUSAAPIR("BUSAD Entry - HASH Mismatch",DIEN,.BUSAR) S DFND=""
 ;
 I CFND!DFND S RSLT="Yes "_"("_$S(CFND:IEN_"(S)",1:"")_$S((CFND&DFND):",",1:"")_$S(DFND:DIEN_"(D)",1:"")_")"
 Q RSLT
 ;
 ;GDIT/HS/BEE 01/22/20 - BUSA*1.0*3 Added FHASHCK tag
FHASHCK(BIEN,ARCH) ;EP - Calculate whether there is a Hash Mismatch for the FileMan entry
 ;
 ;Determine if from archive
 S ARCH=$G(ARCH)
 ;
 NEW FHASH,BII,BFILE,BAIEN,BSUB,PCSUB,PVSUB,SREF
 ;
 ;Retrieve the entry description
 I ARCH S SREF="^BUSASA"
 E  S SREF="^BUSAS"
 S BDESC=$P($G(@SREF@(BIEN,1)),"^")
 S BFILE=$P($P(BDESC,"|",8),"~")
 S BAIEN=$P($P(BDESC,"|",8),"~",2)
 I (BFILE="")!(BAIEN="")!(BFILE=0)!(BAIEN=0) Q ""
 S BSUB=$P(BDESC,"|",10)
 ;
 ;Calculate the hash
 S (FHASH,BII)=""
 I BSUB="" F  S BII=$O(^DIA(BFILE,BAIEN,BII)) Q:BII=""  S FHASH=FHASH_$G(^DIA(BFILE,BAIEN,BII))
 I BSUB]"" F PCSUB=1:1:$L(BSUB,"~") S PVSUB=$P(BSUB,"~",PCSUB) I PVSUB]"" S FHASH=FHASH_$G(^DIA(BFILE,BAIEN,PVSUB))
 S FHASH=$$HASH(FHASH)
 ;
 ;Return mismatch or not
 I FHASH'=$P(BDESC,"|",9) Q "Yes"
 Q ""
 ;
 ;GDIT/HS/BEE 02/14/18 - BUSA*1.0*1 Added FDATE tag
FDATE() ;EP - Return 12:00 AM of the previous day
 ;
 NEW X1,X2,X,%
 ;
 D NOW^%DTC
 ;
 S X1=$P(%,"."),X2=-1 D C^%DTC
 Q "20"_$E(X,2,3)_"-"_$E(X,4,5)_"-"_$E(X,6,7)_"T00:00.000Z"
 Q $TR($$FMTE^XLFDT(X,"5M"),"@"," ")
 Q $$FMTE^XLFDT(X_".0001")
 ;
 ;GDIT/HS/BEE 10/09/19 - BUSA*1.0*3 Added FAUD tag
FAUD(BFILE) ;PEP - Return whether to FileMan audit
 ;
 ;This public API call returns whether a FileMan audit should be performed
 ;*If no file number is passed in, only the status of the BUSA FileMan switch
 ; will be used in determining whether to audit.
 ;*If a file number is passed in, checks on both the BUSA FileMan switch
 ; status and whether the file is included to be audited in the BUSA FILEMAN 
 ; AUDIT INCLUSIONS file will be performed.
 ;
 ;Input:
 ; BFILE - FileMan file number to review
 ;
 ;Output:
 ; 1 - Audit
 ; 0 - Do not Audit
 ;
 ;GDIT/HS/BEE;FEATURE#76061;Reworked section to handle partial auditing
 NEW BIEN,BPARTIAL,RET
 ;
 ;Check the FileMan Audit Switch - Quit if not on
 S BIEN=$O(^BUSA(9002319.04,"S","F",1,"")) I 'BIEN Q 0
 ;
 ;Check the input file number
 I '$G(BFILE) Q 1  ;No file - audit
 ;
 ;Get partial auditing flag
 S BPARTIAL=$P($G(^BUSA(9002319.04,BIEN,0)),U,6)
 ;
 ;Determine if full auditing is on
 S RET=0 I 'BPARTIAL D  Q RET
 . I '$D(^BUSAFMAN("F",BFILE,1)) S RET=0 Q  ;File not audited
 . S RET=1  ;File is being audited
 ;
 ;Partial auditing not defined for file
 I '$D(^BUSAPFMN("FREF",BFILE)),'$D(^BUSAPFMN("FULL",1,BFILE)) Q 0
 ;
 ;Audit the entry
 Q 1
 ;
 ;GDIT/HS/BEE 10/09/19 - BUSA*1.0*3 Added FMENT tag
FMENT(BFILE,BAIEN,BCALL) ;PEP - Create BUSA entry of FileMan audit entry
 ;
 ;This public API call accepts information from a FileMan audit entry and
 ;creates a BUSA API for the entry.
 ;
 ;Input:
 ; BFILE - The FileMan file number
 ; BAIEN - The FileMan audit IEN pointer
 ; BCALL - The calling routine
 ;
 ;Check for needed values
 I '$G(BFILE) Q   ;Missing FileMan file number
 I '$G(BAIEN) Q   ;Missing FileMan auditing pointer
 I $G(BCALL)="" Q   ;Missing calling routine
 ;
 D EN^XBNEW("TGFMENT^BUSAAPI","BFILE;BAIEN;BCALL;BFIELD;BADD")
 ;
 Q
 ;
 ;GDIT/HS/BEE;FEATURE#76061;Reworked section to handle partial auditing
TGFMENT ;Called by tag FMENT using EN^XBNEW
 ;
 ;Variables BFILE, BAIEN, BCALL passed in by EN^XBNEW
 ;
 NEW BSTATUS,BDET,BDESC,BII,BHASH,BADD,BFIELD,UREL,UIEN,USIEN,BUSADFN,BUSAVIEN,XD,XV,BIEN,BSUB,BANODE
 NEW PIEN,BPARTIAL,SFILE,SFIELD,QUIT
 ;
 S BSTATUS=0
 ;
 ;Pull data from FMan audit entry
 S BANODE=$G(^DIA(BFILE,BAIEN,0))
 S BFIELD=$P(BANODE,U,3)
 ;
 ;If partial auditing, quit if field is not audited
 S PIEN=$O(^BUSA(9002319.04,"S","F",1,"")) I 'PIEN Q
 S BPARTIAL=$P($G(^BUSA(9002319.04,PIEN,0)),U,6)
 S QUIT=0 I BPARTIAL D  Q:QUIT
 . I $D(^BUSAPFMN("FULL",1,BFILE)) Q
 . I $D(^BUSAPFMN("FREF",BFILE,BFIELD)) Q
 . S QUIT=1
 ;
 ;Pull remaining data
 S BIEN=$P($P(BANODE,U),",")
 S BADD=$P(BANODE,U,5)
 ;
 ;Calculate the hash
 S (BHASH,BII,BSUB)="" F  S BII=$O(^DIA(BFILE,BAIEN,BII)) Q:BII=""  S BHASH=BHASH_^DIA(BFILE,BAIEN,BII),BSUB=BSUB_$S(BSUB]"":"~",1:"")_BII
 S BHASH=$$HASH(BHASH)
 ;
 ;Assemble description
 S BDESC=BFILE_";"_BAIEN_";"_BFIELD
 S BDESC="FMAN AUDIT: "_BDESC_"|TYPE~F|RSLT~S||||BUSA01|"_BFILE_"~"_BAIEN_"~"_BIEN_"|"_BHASH_"|"_BSUB
 ;
 ;Determine if user related
 S UREL="P"
 S UIEN=$O(^BUSAFMAN("B",BFILE,""))
 I UIEN]"" S USIEN=$$GET1^DIQ(9002319.08,UIEN_",",.03,"I") S:USIEN UREL="S"
 ;
 ;Attempt to locate DFN or VIEN
 S (BUSADFN,BUSAVIEN)=""
 I UIEN]"" D
 . S XD=$G(^BUSAFMAN(UIEN,1)),XD=$TR(XD,"~","^") X:XD]"" XD
 . S XV=$G(^BUSAFMAN(UIEN,2)),XV=$TR(XV,"~","^") X:XV]"" XV
 . I BUSADFN="",BUSAVIEN]"" S BUSADFN=$$GET1^DIQ(9000010,BUSAVIEN_",",.05,"I")
 . I (BUSADFN]"")!(BUSAVIEN]"") S BDET(1)=BUSADFN_U_BUSAVIEN
 ;
 ;Log the entry
 S BSTATUS=$$BYPSLOG^BUSAAPI("A",UREL,$S(BCALL["DIK1":"D",BADD]"":"A",1:"E"),BCALL,BDESC,"BDET",1)
 ;
 Q
