BEHOEP7 ; GDIT/IHS/FS - EPCS Certificates Validations and Checks;28-Jan-2021 10:21;PLS
 ;;1.1;BEH COMPONENTS;**071001,071003**;Mar 20, 2007;Build 13
 ;
KEYHLDRS(RSLT,KEY) ; EP - RPC - Return all the active holders of a specified key
 ;RPC: BEHOEP7 KEYHLDRS
 ;
 ;Input - Security Key
 ;
 K ^TMP($J)
 NEW IEN,II,I,NAME
 ;
 S RSLT=$$TMPGBL
 I $G(KEY)="" Q
 ;
 S IEN=0 F  S IEN=$O(^XUSEC(KEY,IEN)) Q:IEN=""  D
 . ;
 . ;Skip inactive
 . Q:'$$ACTIVE^XUSER(IEN)
 . ;
 . S ^TMP($J,$P(^VA(200,+IEN,0),U))=IEN
 ;
 ;Ascending Order
 S NAME="",II=0 F I=1:1 S NAME=$O(^TMP($J,NAME)) Q:NAME=""  S II=II+1,@RSLT@(II)=^TMP($J,NAME)_U_NAME_$C(30)
 ;
 Q
 ;
CHKCRTST(RSLT,SERIAL) ; EP - RPC - Return current status of Certificate.
 ;RPC: BEHOEP7 CHKCRTST
 ;
 ;Input - Serial Number from 90460.12
 ;
 ;Returns status and last checked date for certificate
 ;Piece 1 - R (Revoked), V (Valid)
 ;Piece 2 - Last checked date/time
 ;Piece 3 - Error Message
 ;
 NEW SIEN,CHKDAT,EMSG,IEN,HASH
 ;
 I $G(SERIAL)="" S RSLT="-1"_U_"Your signing certificate could not be located in the credentialing database. Please contact your credentialing administrator." Q
 ;
 ;Find entry
 S (IEN,SIEN)="" F  S IEN=$O(^BEHOEP(90460.12,"B",$E(SERIAL,1,30),IEN)) Q:IEN=""  D  Q:SIEN]""
 . I $$GET1^DIQ(90460.12,IEN_",",.01,"E")'=SERIAL Q
 . ;
 . ;Return only active one
 . I $$GET1^DIQ(90460.12,IEN_",",.02,"I")'="A" Q
 . ;
 . ;Found it
 . S SIEN=IEN
 I SIEN="" S RSLT="-2"_U_"Your signing certificate could not be located in the credentialing database. Please contact your credentialing administrator." Q
 ;
 I $$GET1^DIQ(90460.12,SIEN_",",.04,"I")'="V" S RSLT="-3"_U_"Your signing certificate is not currently valid. Please contact your credentialing administrator." Q
 ;
 ;8 Hour Check
 S CHKDAT=$$GET1^DIQ(90460.12,SIEN_",",.05,"I")
 I $$LCRTCHKD($G(CHKDAT))'=1 S RSLT="-4"_U_"The EPCS Monitoring service is unable to check your certificate status at this time. Please contact your site administrators to ensure both BMXNet and the EPCS Monitoring service are running." Q
 ;
 ;Comparing Security Hash
 S HASH=$$CALCRSTH^BEHOEP6(SIEN)
 I HASH'=$$GET1^DIQ(90460.12,SIEN_",",.07,"E") S RSLT="-5"_U_"Your signing certificate may have been tampered in the credentialing database or the EPCS Monitoring Service is not running. Please contact your credentialing administrator." Q
 S RSLT="1"_U_"Success"
 Q
 ;
LCRTCHKD(CDT) ;EP - Verify the Certificate Last Checked (8 Hours) Status from BEH EPCS CERTIFICATE STATUS
 N %
 I $G(CDT)="" Q 0
 ;
 D NOW^%DTC
 ;I $$FMDIFF^XLFDT(%,CDT)>0 Q 0
 ;I $E($PIECE(%,".",2),0,2)-$E($PIECE(CDT,".",2),0,2)>=8 Q 0
 I $$FMDIFF^XLFDT(%,CDT,2)>28800 Q 0 ; IHS/OCA/JTC - 2020.10.13 ? difference in seconds - 8 HOURS * 60 MIN * 60 SEC = 28800
 Q 1
 ;
LISTCERT(RET) ;EP - Return array of certificates on system for enabled EPCS users
 ;RPC: BEHOEP7 LISTCERT()
 ;
 ;Input - None
 ;
 ;Returns Array of Certificates
 ;Piece 1 - Serial Number
 ;Piece 2 - CRL value
 ;
 S RET=$$TMPGBL
 ;
 NEW SIEN,CNT,PVIEN
 ;
 S (CNT,PVIEN)=0 F  S PVIEN=$O(^BEHOEP(90460.12,"E",PVIEN)) Q:'PVIEN  S SIEN="" F  S SIEN=$O(^BEHOEP(90460.12,"E",PVIEN,"A",SIEN)) Q:SIEN=""  D
 . ;
 . NEW SERIAL,CRL
 . ;
 . ;Retrieve SERIAL number
 . S SERIAL=$$GET1^DIQ(90460.12,SIEN_",",.01,"I") Q:SERIAL=""
 . ;
 . ;Assemble CRL
 . S CRL=$$GETCRL(SIEN)
 . ;
 . ;Assemble output
 . S CNT=CNT+1,@RET@(CNT)=SERIAL_U_CRL_$C(30)
 ;
 Q
 ;
GETCRL(SIEN) ;Retrieve CRL
 ;
 I $G(SIEN)="" Q ""
 ;
 NEW CRL,CRLP
 ;
 S (CRL,CRLP)="" F  S CRLP=$O(^BEHOEP(90460.12,SIEN,1,"B",CRLP)) Q:'CRLP  S CRLN="" F  S CRLN=$O(^BEHOEP(90460.12,SIEN,1,"B",CRLP,CRLN)) Q:'CRLN  D
 . NEW CRLS,DA,IENS
 . S DA(1)=SIEN,DA=CRLN,IENS=$$IENS^DILF(.DA)
 . S CRLS=$$GET1^DIQ(90460.121,IENS,.02,"E") Q:CRLS=""
 . S CRL=CRL_$S(CRL]"":$C(28),1:"")_"http://"_CRLS
 ;
 Q CRL
 ;
CERTSTAT(RSLT,SERIAL,STATUS) ;EP - Update Certificate Status in BEH EPCS CERTIFICATE STATUS
 ;
 ;Input:
 ;SERIAL - Serial number of entry in 90460.12
 ;STATUS - R (Revoked), V (Valid)
 ;
 ;Returns (1 - Success, 0 - Failure)^Error Message
 ;
 NEW SIEN,CRTUPD,EMSG,%,IEN,PROVIDER,CSTATUS,CRL
 ;
 I $G(SERIAL)="" S RSLT="0^Missing Serial Number" Q
 I $G(STATUS)="" S RSLT="0^Missing Status" Q
 ;
 ;Find entry
 S (IEN,SIEN)="" F  S IEN=$O(^BEHOEP(90460.12,"B",$E(SERIAL,1,30),IEN)) Q:IEN=""  D  Q:SIEN]""
 . I $$GET1^DIQ(90460.12,IEN_",",.01,"E")'=SERIAL Q
 . ;
 . ;Return only active one
 . I $$GET1^DIQ(90460.12,IEN_",",.02,"I")'="A" Q
 . ;
 . ;Found it
 . S SIEN=IEN
 I SIEN="" S RSLT="0^Could not locate (ACTIVE) entry" Q
 ;
 S PROVIDER=$$GET1^DIQ(90460.12,SIEN_",",.03,"E")
 S CSTATUS=$$GET1^DIQ(90460.12,SIEN_",",.04,"E")
 S CRL=$$GETCRL(SIEN)
 ;
 D NOW^%DTC
 ;
 ;Update
 S CRTUPD(90460.12,SIEN_",",.04)=$G(STATUS)  ;Status
 S CRTUPD(90460.12,SIEN_",",.05)=%  ;Last checked
 ;
 ;Update entry
 D FILE^DIE("","CRTUPD","EMSG")
 ;
 I $G(EMSG(1))]"" S RSLT="0^"_EMSG(1) Q
 ;
 ;Compiling certificate information and applying Hash
 N CRTUPD,EMSG
 S CRTUPD(90460.12,SIEN_",",.07)=$$CALCRSTH^BEHOEP6(SIEN)
 D FILE^DIE("","CRTUPD","EMSG")
 I $G(EMSG(1))]"" S RSLT="0^Error updating Security Hash in Certificate Status, "_EMSG(1) Q
 ;
 S RSLT=1
 Q
 ;
TMPGBL(X) ;Define scratch global
 K ^TMP("BEHO"_$G(X),$J) Q $NA(^($J))
 ;
DELCERT(RSLT,PVIEN) ;EP - Delete certificates for provider
 ;RPC: BEHOEP7 DELCERT
 ;
 ;Input - PVIEN - Provider DUZ
 ;
 ;Returns 1 (Successful Deletion), 0 (Deletion Failure)
 ;
 NEW SIEN,DA,DIK,FND
 ;
 I '$G(PVIEN)!('$D(^VA(200,+$G(PVIEN),0))) S RSLT=0 Q
 ;
 ;Find entry
 S (FND,SIEN)="" F  S SIEN=$O(^BEHOEP(90460.12,"C",PVIEN,"")) Q:SIEN=""  D
 . ;
 . ;Delete entry
 . S DA=SIEN,DIK="^BEHOEP(90460.12," D ^DIK
 . S FND=1
 ;
 I 'FND S RSLT=0 Q
 ;
 S RSLT=1
 Q
 ;
GETCERT(RSLT,PVIEN,NEW) ;EP - Retrieve certificate registered to provider
 ;RPC: BEHOEP7 GETCERT
 ;
 ;Input
 ;PVIEN - Provider DUZ
 ;NEW - '1' - Return proposed value
 ;      null - Return current value
 ;
 ;Returns SERIAL^THUMB
 ;Where:
 ;SERIAL - Serial Number of Assigned Token
 ;THUMB - Thumbprint (blank for proposed)
 ;EDATE - Expiration Date
 ;
 NEW SERIAL,THUMB,SIEN,STS,EDATE
 ;
 S NEW=$G(NEW)
 I '$G(PVIEN)!('$D(^VA(200,+$G(PVIEN),0))) S RSLT="" Q
 ;
 ;Find entry
 S STS=$S(NEW=1:"P",1:"A")
 S SIEN=$O(^BEHOEP(90460.12,"E",PVIEN,STS,"")) I SIEN="" S RSLT="" Q
 ;
 S SERIAL=$$GET1^DIQ(90460.12,SIEN_",",".01","I")
 S EDATE=$$GET1^DIQ(90460.12,SIEN_",",".06","I")
 S THUMB="" S:'NEW THUMB=$$GET1^DIQ(200,PVIEN_",","9999999.2","I")
 ;
 S RSLT=SERIAL_U_THUMB_U_EDATE
 Q
 ;
SETCERT(RSLT,PVIEN,SERIAL,CRL,EDATE,CNAME,CISSUER,PCERT) ;EP - Create/Update Certificate in BEH EPCS CERTIFICATE STATUS
 ;RPC: BEHOEP7 SETCERT
 ;
 ;Input
 ;PVIEN - Provider IEN (pointer to #200)
 ;SERIAL - Serial Number
 ;CRL - CRL entries
 ;EDATE - Expiration Date
 ;CNAME - Certificate Name
 ;CISSUER - Certificate Issue
 ;PCERT - User Public Cert
 ;
 ;Returns STS^EMSG
 ;Where:
 ;STS = (1 - Success, 0 - Failure)
 ;EMSG = (Error Message on Failure)
 ;
 NEW SIEN,EMSG,CRTUPD,DA,DIK,II,BCRL,CSTS
 ;
 I '$G(PVIEN)!('$D(^VA(200,+$G(PVIEN),0))) S RSLT="0^Invalid Provider DUZ" Q
 I $G(SERIAL)="" S RSLT="0^Missing Serial Number" Q
 I $G(CRL)="" S RSLT="0^Missing CRL Distribution Point Value" Q
 I $G(PCERT)="" S RSLT="0^Missing User Public Cert" Q
 I $G(CNAME)="" S RSLT="0^Missing Certificate Name" Q
 I $G(CISSUER)="" S RSLT="0^Missing Certificate Issuer" Q
 S EDATE=$G(EDATE)
 ;
 ;Check if certificate in use
 D CRTSETCK^BEHOEP6(.CSTS,SERIAL,PVIEN) I $P(CSTS,U)'=1 S RSLT=CSTS Q
 ;
 ;Save CRL entry
 S CRL=$$UPDCRL(CRL) I $P(CRL,U)=0 S RSLT=CRL Q
 ;
 ;Look for existing proposed entry
 S EMSG="",SIEN=$O(^BEHOEP(90460.12,"E",PVIEN,"P",""))
 I SIEN="" D  I EMSG]"" S RSLT=EMSG Q
 . ;
 . ;Create new entry
 . NEW DIC,X,Y,DLAYGO,DA
 . S DIC(0)="L",X=SERIAL
 . S DIC="^BEHOEP(90460.12,"
 . L +^BEHOEP(90460.12,0):1 E  S EMSG="0^Could not lock file to create new file entry" Q
 . S DLAYGO=90460.12
 . K DO,DD D FILE^DICN
 . L -^BEHOEP(90460.12,0)
 . I +Y'>0 S EMSG="0^Could not create new certificate file entry" Q
 . S SIEN=+Y
 ;
 ;File remaining fields
 S CRTUPD(90460.12,SIEN_",",.01)=SERIAL  ;Serial Number
 S CRTUPD(90460.12,SIEN_",",.02)="P"  ;Verified Status - set to proposed
 S CRTUPD(90460.12,SIEN_",",.04)="@"  ;Reset Status
 S CRTUPD(90460.12,SIEN_",",.05)="@"  ;Clear last checked
 S CRTUPD(90460.12,SIEN_",",.03)=PVIEN  ;Provider IEN
 S CRTUPD(90460.12,SIEN_",",.06)=$S(EDATE="":"@",1:EDATE)
 S CRTUPD(90460.12,SIEN_",",4.01)=CNAME  ;Certificate Name
 S CRTUPD(90460.12,SIEN_",",4.02)=CISSUER  ;Certificate Issuer
 ;
 ;Update entry
 D FILE^DIE("","CRTUPD","EMSG")
 I $G(EMSG(1))]"" S RSLT="0^"_EMSG(1) Q
 ;
 ;File CRL Values
 ;
 ;First clear existing
 S II=0 F  S II=$O(^BEHOEP(90460.12,SIEN,1,II)) Q:'II  S DA(1)=SIEN,DA=II,DIK="^BEHOEP(90460.12,SIEN,1," D ^DIK
 ;
 ;Loop through and add new ones
 F II=1:1:$L(CRL,U) D  I EMSG]"" S RSLT="0^"_EMSG Q
 . NEW CRLP,AI,DA,DIC,X,Y,DLAYGO,IENS,UPD
 . ;
 . S CRLP=$P(CRL,U,II)
 . S DA(1)=SIEN,DIC(0)="L"
 . S DIC="^BEHOEP(90460.12,"_SIEN_",1,"
 . S X=II,DLAYGO="90460.121"
 . D ^DIC
 . I +Y=-1 S EMSG="0^Could not save new CRL entry to multiple" Q
 . S DA=+Y,IENS=$$IENS^DILF(.DA)
 . S UPD(90460.121,IENS,.02)=CRLP
 . D FILE^DIE("","UPD","EMSG")
 . I $G(EMSG(1))]"" S EMSG=EMSG(1)
 ;
 ;Saving User Public Cert
 ;
 N RET
 ;
 I SIEN>0,$G(PCERT)'="" S RET=$$SETWP^BEHOEP6(90460.12,2,SIEN,PCERT,0,0)
 I $G(RET)'=1 S RSLT="0^Error adding User Public Cert: "_$G(RET) Q
 ;
 S RSLT=1
 ;
 Q
 ;
TMAIL(CIEN,THRSHLD,MXTHRESH) ;Send RPMS/Cert Name Mismatch Message
 ;
 NEW %,XLINE,BODY,XMY,XMSUB,XMTEXT
 ;
 D NOW^%DTC
 ;
 S XLINE=0,BODY(XLINE)="An EPCS user verification was completed on "_$$FMTE^XLFDT(%)_"."
 S XLINE=XLINE+1,BODY(XLINE)="The RPMS user name has been found to be different from the name found on the"
 S XLINE=XLINE+1,BODY(XLINE)="user's certificate."
 S XLINE=XLINE+1,BODY(XLINE)=""
 S XLINE=XLINE+1,BODY(XLINE)="RPMS user name: "_$$GET1^DIQ(90460.12,CIEN_",",.03,"E")
 S XLINE=XLINE+1,BODY(XLINE)="Certificate user name: "_$$GET1^DIQ(90460.12,CIEN_",",4.01,"E")
 S XLINE=XLINE+1,BODY(XLINE)="Issuer: "_$$GET1^DIQ(90460.12,CIEN_",",4.02,"E")
 S XLINE=XLINE+1,BODY(XLINE)="Levenshtein edit distance score: "_THRSHLD
 S XLINE=XLINE+1,BODY(XLINE)="Maximum distance score permitted (as defined in the BEHO EPCS CERT NAME"
 S XLINE=XLINE+1,BODY(XLINE)="THRESHOLD XPAR parameter): "_MXTHRESH
 S XMTEXT="BODY("
 ;
 ;Assemble TO list
 S XMY("G.BEHO EPCS INCIDENT RESPONSE")=""
 ;
 ;Subject Line
 S XMSUB="EPCS User Verification Name Mismatch"
 ;
 ;Send message
 D ^XMD
 ;
 Q
 ;
UPDCRL(CRL) ;Add/Retrieve CRL entry
 ;
 I $G(CRL)="" Q "0^No CRL passed in"
 ;
 NEW AIEN,CRLN,CRLP,EMSG
 ;
 S (AIEN,EMSG)="" F CRLP=1:1:$L(CRL,$C(28)) S CRLN=$P(CRL,$C(28),CRLP) I CRLN]"" D  I EMSG]"" Q
 . NEW IEN,FIEN,DIC,X,Y,DLAYGO
 . ;
 . ;Strip off http://
 . S CRLN=$$STRHTTP(CRLN) I $P(CRLN,U)=0 S EMSG=CRLN Q
 . I CRLN?1P.E S EMSG="0^Invalid CRL Value" Q
 . ;
 . ;Look for existing entry
 . S (FIEN,IEN)="" F  S IEN=$O(^BEHOEP(90460.15,"B",$E(CRLN,1,30),IEN)) Q:IEN=""  D  Q:FIEN
 .. NEW II,CCRL
 .. S CCRL=$$GET1^DIQ(90460.15,IEN_",",.01,"E") Q:CCRL=""
 .. I CCRL'=CRLN Q
 .. S FIEN=IEN
 . ;
 . ;If match found add to list and quit
 . I FIEN S AIEN=AIEN_$S(AIEN]"":U,1:"")_FIEN Q
 . ;
 . ;Not found, log entry
 . ;Log new entry
 . S DIC(0)="L",X=CRLN
 . S DIC="^BEHOEP(90460.15,"
 . L +^BEHOEP(90460.15,0):1 E  S EMSG="0^Could not lock CRL file to create entry" Q
 . S DLAYGO="90460.15" D ^DIC
 . L -^BEHOEP(90460.15,0)
 . I '+Y S EMSG="0^Unable to create new CRL entry" Q
 . S AIEN=AIEN_$S(AIEN]"":U,1:"")_+Y
 ;
 ;Handle errors
 I EMSG]"" Q EMSG
 ;
 ;Return entry
 Q AIEN
 ;
STRHTTP(CRLN) ;Strip off http://
 ;
 NEW UCRLN,II,C,STR
 ;
 S UCRLN=$$UP^XLFSTR(CRLN)
 ;
 S STR="" F II=1:1:$L(UCRLN) I $E(UCRLN,II,II+6)="HTTP://" S STR=II Q
 ;
 ;Found the http:// filter out
 I STR Q $E(CRLN,STR+7,9999)
 ;
 ;Not found
 Q "0^CRL entry did not contain http://"
 ;
UTC(RSLT) ; EP - RPC will return UTC.
 ;RPC is being called in EPCS Certificate Check Service
 N EXEC,NOW
 S EXEC="S NOW=##class(%Library.UTC).NowLocal()" X EXEC
 S EXEC="S RSLT=##class(%Library.UTC).ConvertLocaltoUTC(NOW)" X EXEC
 Q
 ;
UTCNOW() ; EP - Return UTC NOW DATE
 N EXEC,NW
 S EXEC="S NW=##class(%Library.UTC).ConvertTimeStampToHorolog(##class(%Library.UTC).NowUTC())" X EXEC
 S EXEC="S NW=$ZDATETIME(NW)" X EXEC
 D DT^DILF("TS",$TR(NW," ","@"),.NW,,"")
 Q NW
 ;
MAILMAN(BGUARRAY,BGUDATA,BGUSBJ,BGUGROUP) ;EP - REMOTE PROCEDURE BEHOEP7 MAILMAN
 I $G(BGUDATA)="",$G(BGUSBJ)="",$G(BGUGROUP)="" S BGUARRAY=0 Q
CTL ;
 D MAIL,KILL
 S BGUARRAY(1)=1,BGUARRAY(2)="OK"
 Q
 ;
MAIL ;EP - Mailman Call
 N XMSUB
 S XMSUB=BGUSBJ,XMTEXT="BGUMLMSG(",XMDUZ=DUZ,XMY("G."_BGUGROUP)="",XMCHAN=1
 F BGUN=1:1:$L(BGUDATA,$C(175)) S BGUMLMSG(BGUN)=$P(BGUDATA,$C(175),BGUN)
 D ^XMD
 Q
 ;
KILL ;EP - Kill Variables
 K BGUMLMSG,BGUN,XMCHAN,XMDUZ,XMTEXT,XMY
 Q
 ;
HASHSVC(RSLT) ;EP - EPCS Monitoring Service will call this RPC.
 ;Background Service for Hash Monitoring
 N SCR,OUT,ERR,INDEX,RET,RESPONSE,COUNT,TOTAL
 S SCR="I 1",COUNT=0,TOTAL=0
 S SCR=SCR_" & (($P($G("_"^"_"(""IHSEPCS1"")),""^"",1))'="_""""""_")"
 D LIST^DIC(200,"","@;.01","B","*",,,,SCR,"","OUT","ERR")
 I $D(ERR("DIERR")) D LOGBUSA^BEHOEP3(.RESPONSE,"Q^EPCS CREDENTIALING^EPCS Monitoring Hash Check Incomplete.^F")
 S INDEX=$O(OUT("DILIST",2,""))
 I +INDEX>0 F  D  Q:(+INDEX'>0)
 .D VRFYPHSH^BEHOEP3(.RET,OUT("DILIST",2,INDEX))
 .I '$G(RET) D LOGBUSA^BEHOEP3(.RESPONSE,"Q^EPCS CREDENTIALING^EPCS Monitoring Hash Check Fail: "_$G(INDEX)_"-"_OUT("DILIST","ID",INDEX,.01)_"^F")
 .I '$G(RET) S COUNT=COUNT+1
 .S INDEX=$O(OUT("DILIST",2,INDEX)),TOTAL=TOTAL+1
 D LOGBUSA^BEHOEP3(.RESPONSE,"Q^EPCS CREDENTIALING^EPCS Monitoring Hash Check Complete. "_$G(COUNT)_" out of "_$G(TOTAL)_" logged in BUSA!^S")
 S RSLT=1
 Q
 ;
BUSASVC(RSLT,ACTION,CALL,MSG,STATUS,EVENT) ;EP - BUSA Logs for Background Service
 ;BMXNET expecting parameters. This RPC will only save "Service" Typ=S is hardcoded.
 N TYPE,CAT,DESC,TYP
 I $G(ACTION)="",$G(CALL)="",$G(MSG)="" S RSLT=0 Q
 S RSLT=0,TYPE="R",CAT="O",TYP="S" ;TYP here is for Service and TYPE for RPC Call
 S DESC=MSG_"|TYPE~"_$G(TYP)_"|RSLT~"_$G(STATUS)_"|||EP~"_$G(EVENT)_"|"
 I $G(DUZ)>0 D
 .S RSLT=$$LOG^XUSBUSA(TYPE,CAT,ACTION,CALL,DESC)
 .K TYPE,CAT,DESC
 .I +$G(RSLT)>0 S RSLT=1
 Q
 ;
AUDITSVC(RSLT,LOGID,P1,P2,P3) ;EP - Audit Log Events
 ;Loads Audit Log Configuration and perform actions as in configuration.
 I $G(LOGID)="" S RSLT=0 Q
 S RSLT=$$AUDCONF^BEHOEP3(LOGID,P1,P2,P3)
 I RSLT'=1 S RSLT=0 Q
 S RSLT=1
 Q
