BEHOEP6 ; GDIT/IHS/FS - Credentialing and 2FA Common APIs, Options;30-May-2019 16:07;PLS
 ;;1.1;BEH COMPONENTS;**070001**;Mar 20, 2007;Build 13
 ;
 ;
HASHSTR(STR) ;EP - Returns SHA-256 Base64 Encode hash
 ;INPUT: String
 ;D HASHSTR^BEHOEP6("")
 N HASH,RTN,EXEC
 S EXEC="S HASH=##class(%SYSTEM.Encryption).SHAHash(256,STR)" X EXEC
 S EXEC="S RTN=$System.Encryption.Base64Encode(HASH)" X EXEC
 Q $G(RTN)
 ;
 ;
HASH ;EP - Create Hash for the field "System User Password"
 Q:'$D(X)
 S X=$$ENCRYP^XUSRB1(X)
 ;W $$DECRYP^XUSRB1
 Q
 ;
SITES ;EP - INPUT TRANSFORM on .01 of 90460.1 and 90460.11
 Q:'$D(X)
 I $O(^ORD(100.7,$O(^ORD(100.7,0)),9999999.11,"B",X,"")) Q
 I $O(^ORD(100.7,"B",X,"")) Q
 S X=""
 N X
 Q
 ;
CERTCHK(KEY) ;EP - It will check the Certificate Status from BEH EPCS CERTIFICATE STATUS (90460.12)
 ;W $$CERTCHK^BEHOEP7("DEVEPCSSign")
 N SCR,INDEX,OUT,LASTCHKD,NW,ERRMSG,EXPDT
 S ERRMSG="-15^Certificate Status is not valid."
 I $G(KEY)="" Q ERRMSG
 S SCR="I 1"
 S SCR=SCR_" & (($P($G("_"^"_"(0)),""^"",1))="_""""_KEY_""""_")"
 D LIST^DIC(90460.12,"","@;.01;.02I;.03;.04","B","*",,,,SCR,"","OUT")
 S INDEX=$O(OUT("DILIST","ID",""))
 I INDEX="" Q ERRMSG
 I $$GET1^DIQ(90460.12,$G(OUT("DILIST",2,INDEX))_",",.02,"I")'="A" Q ERRMSG
 S LASTCHKD=$$GET1^DIQ(90460.12,$G(OUT("DILIST",2,INDEX))_",",.03)
 S EXPDT=$$GET1^DIQ(90460.12,$G(OUT("DILIST",2,INDEX))_",",.04)
 D DT^DILF("RS",LASTCHKD,.LASTCHKD,,"")
 D DT^DILF("RS",EXPDT,.EXPDT,,"")
 S NW=$$UTCNOW^BEHOEP7
 I $$FMDIFF^XLFDT(NW,EXPDT)>0 Q ERRMSG
 I $$FMDIFF^XLFDT(NW,LASTCHKD,2)>14400 Q ERRMSG ;4 Hours = 14400 Seconds
 I $E($PIECE(NW,".",2),0,2)-$E($PIECE(LASTCHKD,".",2),0,2)>=8 Q ERRMSG
 Q 1
 ;
 ;GDIT/IHS/FS - Added
UPDATENP(PROV) ;Recalculate and Update Hash in NEW PERSON (200)
 ;
 I PROV="" Q "0^Error updating hash in New Person"
 N RTN,HASH
 S RTN=1
 S HASH=$$HASHNP^BEHOEP2(PROV) ;HASH calculation and saving in EPCS PROFILE HASH field in 200 file
 I $G(HASH)'="" D
 .N FDA,MSG
 .S FDA(200,PROV_",",9999999.19)=$G(HASH)
 .D FILE^DIE("","FDA","MSG")
 .;I $D(MSG("DIERR")) S RESPONSE=$$AUDCONF^BEHOEP3($G(AUDIDF),$G(PROV),$$GET1^DIQ(200,PROV_",",.01),"")
 .I $D(MSG("DIERR")) S RTN="0^Error updating hash in New Person, "_$G(MSG("DIERR","1","TEXT",1))
 Q $G(RTN)
 ;
CLEARFL(PROV) ;Revoked providers should clear out fields
 ;
 N SCR,INDEX,OUT,RTN
 I $G(PROV)="" Q "0^Error clearing out fields."
 S SCR="I 1"
 S SCR=SCR_" & (($P($G("_"^"_"(0)),""^"",3))="_""_PROV_""_")"
 D LIST^DIC(90460.12,"","@","B","*",,,,SCR,"","OUT")
 S INDEX=$O(OUT("DILIST","2",""))
 I $G(INDEX)="" Q 1
 I +INDEX>0 F  D  Q:(+INDEX'>0)
 .N RVKUPD,MSG
 .S RVKUPD(90460.12,$G(OUT("DILIST",2,INDEX))_",",.02)="R"
 .D FILE^DIE("","RVKUPD","MSG")
 .I $G(MSG(1))]"" S RTN="0^Error updating Verification Status in Certificate Status, "_MSG(1) Q
 .N RVKUPD,MSG
 .S RVKUPD(90460.12,$G(OUT("DILIST",2,INDEX))_",",.07)=$$CALCRSTH(INDEX)
 .D FILE^DIE("","RVKUPD","MSG")
 .I $G(MSG(1))]"" S RTN="0^Error updating Security Hash in Certificate Status, "_MSG(1) Q
 .S INDEX=$O(OUT("DILIST","2",INDEX))
 Q:$G(RTN)'="" $G(RTN)
 N RVKUPD,MSG
 S RVKUPD(200,PROV_",",9999999.19)="@"
 S RVKUPD(200,PROV_",",9999999.2)="@"
 D FILE^DIE("","RVKUPD","MSG")
 I $G(MSG(1))]"" Q "0^Error updating hash or thumbprint in New Person, "_MSG(1)
 Q 1
 ;
CALCRSTH(SIEN) ;Calculate and generate Certificate Status Hash. Reading Certificate Status (90460.12) File.
 ;
 I $G(SIEN)="" Q "0^Certificate Serial IEN required."
 N HASH,SERIAL,VSTATUS,PROVIDER,STATUS,CHKDAT,CRL,CNAME,CISSUER
 S SERIAL=$$GET1^DIQ(90460.12,SIEN_",",.01,"E") ;Certificate Serial
 S VSTATUS=$$GET1^DIQ(90460.12,SIEN_",",.02,"E") ;Verified Status
 S PROVIDER=$$GET1^DIQ(90460.12,SIEN_",",.03,"E") ;Provider
 S STATUS=$$GET1^DIQ(90460.12,SIEN_",",.04,"E") ;Status
 S CHKDAT=$$GET1^DIQ(90460.12,SIEN_",",.05,"I") ;Last Check Date
 S CNAME=$$GET1^DIQ(90460.12,SIEN_",",4.01,"E")  ;Certificate Name
 S CISSUER=$$GET1^DIQ(90460.12,SIEN_",",4.02,"E")  ;Certificate Issuer
 S CRL=$$GETCRL^BEHOEP7(SIEN) ;CRL Information
 ;
 ;Compiling '^' separated Certificate information and applying SHA 256
 S HASH=$G(SERIAL)_U_$G(VSTATUS)_U_$G(PROVIDER)_U_$G(STATUS)_U_$G(CHKDAT)_U_$G(CRL)_U_$G(CNAME)_U_$G(CISSUER)
 S HASH=$$HASHSTR^BEHOEP6($G(HASH))
 Q $G(HASH)
 ;
CRUSRENT(OEIEN,PROV) ; EP - Create entry in 100.71 (ENABLED USER) multiple of OE/RR EPCS PARAMETER (100.7) file
 ; D CRENSCT^CRUSRENT("113255","23") W @R
 ; OEIEN = Facility Entry IEN
 ; PROV = Provider IEN
 ; RSLT=IEN of entry created in  100.71 (ENABLED USER) multiple
 N FDADA,FDA,FDAMSG,FDAIEN
 S FDA(42,100.71,"+1,"_OEIEN_",",.01)=$G(PROV)
 D UPDATE^DIE("","FDA(42)","FDAIEN","FDAMSG")
 ;S FDADA=+$G(FDAIEN(1))
 I $D(FDAMSG("DIERR")) Q "0^Error creating logical access in File: 100.7 "_$G(FDAMSG("DIERR","1","TEXT",1))
 Q 1
 ;
DLUSRENT(OEIEN,PROV,R) ; EP - Delete entry in 100.71 (ENABLED USER) multiple of OE/RR EPCS PARAMETER (100.7) file
 ; D DLUSRENT^DLUSRENT("113255","371530004","") W @R
 ; OEIEN = Facility Entry IEN
 ; PROV = Provider IEN
 ; RSLT=Success or Failure (0^Message,1)
 N FDADA,FDA,FDAMSG
 S FDA(42,100.71,R,.01)="@"
 D FILE^DIE("","FDA(42)","FDAMSG")
 ;S FDADA=+$G(FDAIEN(1))
 I $D(FDAMSG("DIERR")) Q "0^Error deleting logical access in File: 100.7 "_$G(FDAMSG("DIERR","1","TEXT",1))
 Q 1
 ;
SETWP(FN,WPFN,IEN,TEXT,ISAPPEND,ISDELETE) ;Set WordProcessing Data based on file, field and IEN information!
 ; FN - File Number
 ; WPFN - Word Processing Field Number
 ; IEN - Record IEN
 ; ISAPPEND - 1/0
 ; ISDELETE - 1/0
 ;
 I +$G(IEN)<1,+$G(FN)<1,+$G(WPFN)<1,$L($G(TEXT))<1 Q "0^Required Data missing"
 I $G(TEXT)["2@%Library.GlobalBinaryStream" Q "-2^GlobalBinaryStream error"
 N ERR,WPROOT,WP,I,ORGCHCNT,RUNCHCNT ;Original Character Count, Running Character Count
 S ORGCHCNT=$L($G(TEXT))
 I ISDELETE S WPROOT="@"
 I 'ISDELETE  D
 .S TEXT=$LISTFROMSTRING(TEXT,$c(13))
 .S WPROOT="WP",I=0,RUNCHCNT=0
 .F I=1:1:$ll(TEXT) S WP(I)=$lg(TEXT,I)
 I ISAPPEND D WP^DIE(FN,IEN_",",WPFN,"AK",WPROOT,"ERR")
 I 'ISAPPEND D WP^DIE(FN,IEN_",",WPFN,"K",WPROOT,"ERR")
 I $D(ERR) Q "-1^"_$G(ERR("DIERR",1,"TEXT",1))
 K ERR,WPROOT,WP,I,ORGCHCNT,RUNCHCNT
 Q "1"
 ;
CRTSETCK(RSLT,SERIAL,PROV) ;EP - Return whether serial number is in use
 ;RPC: BEHOEP6 CRTSETCK
 ;
 ;Input
 ;SERIAL - Serial Number of Certificate
 ;PROV - Provider DUZ
 ;
 ;Returns 1 - Serial number not in use
 ;        0^Error Message - Certificate already in use
 ;
 I '$G(PROV)!('$D(^VA(200,+$G(PROV),0))) S RSLT="0^Invalid Provider DUZ passed in" Q
 I $G(SERIAL)="" S RSLT="0^Missing Serial Number" Q
 ;
 NEW SIEN,IEN
 ;
 ;Look for active or proposed entry
 S (SIEN,IEN)="" F  S IEN=$O(^BEHOEP(90460.12,"B",$E(SERIAL,1,30),IEN)) Q:IEN=""  D  Q:SIEN]""
 . NEW PRV
 . ;
 . I $$GET1^DIQ(90460.12,IEN_",",.01,"E")'=SERIAL Q
 . ;
 . ;Return non-retired ones
 . I $$GET1^DIQ(90460.12,IEN_",",.02,"I")="R" Q
 . ;
 . ;Skip if same provider
 . S PRV=$$GET1^DIQ(90460.12,IEN_",",.03,"I") Q:PRV=PROV
 . ;
 . ;Found it
 . S SIEN=IEN_U_$$GET1^DIQ(200,PRV_",",.01,"I")
 ;
 ;If found, pull the provider
 I SIEN]"" S RSLT="0^The selected certificate is already assigned to user "_$P(SIEN,U,2)_". Please check the certificate assignments."
 E  S RSLT=1  ;Return success
 ;
 Q
