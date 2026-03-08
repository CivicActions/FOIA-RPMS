BEHOEP2 ; GDIT/IHS/FS - Common - Writing Provider Profile & Logical Access into 200 & 100.7;24-May-2019 14:53;PLS
 ;;1.1;BEH COMPONENTS;**070001**;Mar 20, 2007;Build 12
 ;
 ;Ref. to ^UTILITY via IA 10061
 ;
PROVPRFV(RSLT,PROV,EVENTT,THRSHLD) ;EP - RemoteProcedure: BEHOEP2 PROVPRFV
 ;INPUT: ProviderIEN, OUTPUT: 0/1 or Message (String)
 ;RPC will save the pending profile to NEW PERSON(200) and profile will be marked as Verified.
 S THRSHLD=+$G(THRSHLD)
 I $G(PROV)'>0,$G(DUZ)'>0 S RSLT="0^Provider IEN is Mandatory!" Q
 N OUT,SCR,INDEX,FDA,MSG,NOW,XUIEN,INDX,HASH,FDAXU,MSGXU,DED,RESPONSE,SIEN,SERIAL,BCRL,AUDIDS,AUDIDF,ADDINFO
 S NOW=$P($$HTE^XLFDT($H),":",1,2),HASH="",RSLT=1
 I $G(EVENTT)="V" S AUDIDS="EPCS42",AUDIDF="EPCS43"
 E  S AUDIDS="EPCS40",AUDIDF="EPCS41"
 S SCR="I 1"
 S SCR=SCR_" & (($P($G("_"^"_"(""IHSEPCS1"")),""^"",1))'>"_"0"_")"
 S SCR=SCR_" & (($P($G("_"^"_"(0)),""^"",1))="_PROV_")"
 D LIST^DIC(8991.6,"","@;.01I;.02I;.03;.03I;.05","B","*",,,,SCR,"","OUT")
 S INDEX=$O(OUT("DILIST","ID","")),INDX=$O(OUT("DILIST","ID",""))
 I +INDEX>0 F  D  Q:(+INDEX'>0)
 .I $G(OUT("DILIST","ID",INDEX,.01))'="",$G(OUT("DILIST","ID",INDEX,.03,"I"))'=""  D
 .. I $G(OUT("DILIST","ID",INDEX,.03,"I"))="53.1"  D
 ... I $G(OUT("DILIST","ID",INDEX,.05))="0"  D
 .... S FDA(200,PROV_",",53.1)="@"
 ... I $G(OUT("DILIST","ID",INDEX,.05))="1" D
 .... S FDA(200,PROV_",",53.1)="1"
 .. I $G(OUT("DILIST","ID",INDEX,.03,"I"))="747.44" D
 ... N DED
 ... D DT^DILF("TS",$G(OUT("DILIST","ID",INDEX,.05)),.DED,,"")
 ... S:$G(DED)'="" FDA(200,PROV_",",747.44)=$G(DED)
 ... S:$G(DED)="" FDA(200,PROV_",",747.44)="@"
 .. I $G(OUT("DILIST","ID",INDEX,.03,"I"))'="747.44",$G(OUT("DILIST","ID",INDEX,.03,"I"))'="53.1" D
 ... S FDA(200,PROV_",",$G(OUT("DILIST","ID",INDEX,.03,"I")))=$G(OUT("DILIST","ID",INDEX,.05))
 ... I $D(MSG("DIERR")) S RESPONSE=$$AUDCONF^BEHOEP3($G(AUDIDF),$G(PROV),$$GET1^DIQ(200,PROV_",",.01),"")
 ... I $D(MSG("DIERR")) S RSLT="0^Error updating Verification in NEW PERSON, Field: "_$G(OUT("DILIST","ID",INDEX,.03,"I"))_" "_$G(MSG("DIERR","1","TEXT",1)) Q
 .. N FDAXU,MSGXU,XUIEN
 .. S XUIEN=OUT("DILIST",2,INDEX)
 .. S FDAXU(8991.6,XUIEN_",",9999999.01)=DUZ,FDAXU(8991.6,XUIEN_",",9999999.02)=NOW
 .. D FILE^DIE("","FDAXU","MSGXU")
 .. I $D(MSGXU("DIERR")) S RESPONSE=$$AUDCONF^BEHOEP3($G(AUDIDF),$G(PROV),$$GET1^DIQ(200,PROV_",",.01),"")
 .. I $D(MSGXU("DIERR")) S RSLT="0^Error updating Verification in Audit, Field: "_$G(OUT("DILIST","ID",INDEX,.03,"I"))_" "_$G(MSGXU("DIERR","1","TEXT",1)) Q
 .S INDEX=$O(OUT("DILIST","ID",INDEX))
 I $G(INDX)>0  D
 .D FILE^DIE("","FDA","MSG")
 .I $D(MSG("DIERR")) S RESPONSE=$$AUDCONF^BEHOEP3($G(AUDIDF),$G(PROV),$$GET1^DIQ(200,PROV_",",.01),"")
 .I $D(MSG("DIERR")) S RSLT="0^Error updating New Person(200) file, "_$G(MSG("DIERR","1","TEXT",1)) Q
 S RTN=$$LOACVERF(PROV)
 I $P($G(RTN),"^",1)'=1 S RSLT=$G(RTN)
 I $G(RSLT)'=1 Q
 ;Recaluclate hash for a provider
 S HASH=$$HASHNP(PROV) ;HASH calculation and saving in EPCS PROFILE HASH field in 200 file
 I $G(HASH)'="" D
 .N FDA,MSG
 .S FDA(200,PROV_",",9999999.19)=$G(HASH)
 .D FILE^DIE("","FDA","MSG")
 .I $D(MSG("DIERR")) S RESPONSE=$$AUDCONF^BEHOEP3($G(AUDIDF),$G(PROV),$$GET1^DIQ(200,PROV_",",.01),"")
 .I $D(MSG("DIERR")) S RSLT="0^Error updating hash in New Person, "_$G(MSG("DIERR","1","TEXT",1)) Q
 ; CAll LOG BUSA - Activate Provider Profile (Action: Copy) Discussed in a standup
 ; ONLY LOG BUSA CALL from backend (All others are from GUI)
 I $G(EVENTT)="V" S ADDINFO=""
 E  S ADDINFO="~"_$P($G(RTN),"^",2)
 S RESPONSE=$$AUDCONF^BEHOEP3($G(AUDIDS),$G(PROV)_$G(ADDINFO),$$GET1^DIQ(200,PROV_",",.01),$P($G(ADDINFO),"~",2))
 S RSLT=1
 ;
 ;Make proposed entry as active
 S SIEN=$O(^BEHOEP(90460.12,"E",PROV,"P","")) I SIEN]"" D
 . NEW CRTUPD,ERROR,MXTHRESH,OSIEN
 . S CRTUPD(90460.12,SIEN_",",.02)="A"
 . ;
 . ;Mark any current entry as retired
 . S OSIEN="" F  S OSIEN=$O(^BEHOEP(90460.12,"E",PROV,"A",OSIEN)) Q:OSIEN=""  D
 .. S CRTUPD(90460.12,OSIEN_",",.02)="R"
 . ;
 . ;Save retired and active statuses
 . I $D(CRTUPD) D FILE^DIE("","CRTUPD","ERROR")
 . I $D(ERROR("DIERR")) S RSLT="0^Error updating status to retired in 90460.12, "_$G(ERROR("DIERR","1","TEXT",1))
 . ;
 . ; ;THRSHLD - Threshold name match value
 . ;
 . ;Get threshold value from XPAR
 . D GETPAR^CIAVMRPC(.MXTHRESH,"BEHO EPCS CERT NAME THRESHOLD","",1,"I",DUZ)
 . S MXTHRESH=$G(MXTHRESH)
 . S:'MXTHRESH MXTHRESH=3   ;Default to 3
 . ;
 . ;Check against input value
 . I THRSHLD>MXTHRESH D TMAIL^BEHOEP7(+$G(SIEN),+$G(THRSHLD),+$G(MXTHRESH))
 ;
 ;Broadcast event
 S SIEN=$O(^BEHOEP(90460.12,"E",PROV,"A",""))
 I SIEN]"" D
 . S SERIAL=$$GET1^DIQ(90460.12,SIEN_",",.01,"E")
 . S BCRL=$$GETCRL^BEHOEP7(SIEN)
 . ;BMX uses ^ for metainfo, so delimit with a control char
 . D EVENT^BMXMEVN("EPCS.MON.NEWCERT",SERIAL_$C(29)_BCRL,"DUMMY_SESSION","")
 ;
 ;Clear Fields only if provider is revoked and not verifier.
 I '$D(^ORD(100.7,"C",+PROV)),EVENTT="P" S RSLT=$$CLEARFL^BEHOEP6(PROV)
 Q:$G(RSLT)'="" RSLT
 S RSLT=1
 Q
 ;
PENDPROF(RSLT,PROV) ;EP - Pending Provider Profile
 ;INPUT: Profile IEN, OUTPUT: ProviderIEN^ModifiedByName^FieldNumber^OldData^NewData^DateModified^ModifiedByIEN (ARRAY)
 ;RPC will return pending profile for verification
 I $G(PROV)'>0,$G(DUZ)'>0 S RSLT="0^Provider IEN is Mandatory!" Q
 N SCR,INDEX,OUT,I,MODIFYBY,MODBYIEN
 S SCR="I 1"
 S SCR=SCR_" & (($P($G("_"^"_"(""IHSEPCS1"")),""^"",1))="_""""""_")"
 S SCR=SCR_" & (($P($G("_"^"_"(0)),""^"",1))="_PROV_")"
 D LIST^DIC(8991.6,"","@;.01I;.02;.03I;.04;.05;.06;.02I","B","*",,,,SCR,"","OUT")
 S I=0
 S INDEX=$O(OUT("DILIST","ID",""))
 I +INDEX>0 F  D  Q:(+INDEX'>0)
 .I $G(OUT("DILIST","ID",INDEX,.01))'="",$G(OUT("DILIST","ID",INDEX,.03))'=""  D
 ..S MODIFYBY=$G(OUT("DILIST","ID",INDEX,.02,"E")),MODBYIEN=$G(OUT("DILIST","ID",INDEX,.02,"I"))
 ..S I=I+1,RSLT(I)=$G(OUT("DILIST","ID",INDEX,.01))_"^"_$G(MODIFYBY)_"^"_$G(OUT("DILIST","ID",INDEX,.03))_"^"_$G(OUT("DILIST","ID",INDEX,.04))_"^"_$G(OUT("DILIST","ID",INDEX,.05))_"^"_$G(OUT("DILIST","ID",INDEX,.06))_"^"_$G(MODBYIEN)
 .S INDEX=$O(OUT("DILIST","ID",INDEX))
 Q
 ;
ENTRYLA(RSLT,INPUT) ;EP - Requests for Logical Access in 90460.09
 ;INPUT: Provider IEN^DUZ^Facility IEN^ENABLE USER (YES/NO) (String) RETURN: 0/1 or Message (String)
 ;RPC will save logical access controls into BEHOEP EPCS OE/RR PARAMETERS DATA (90460.09) File. Audit entries for EPCS logical access data (OE/RR EPCS PARAMETERS (100.7) Fields)
 ;Test Call
 I $G(INPUT)'="",$G(DUZ)'>0 S RSLT="0^No data to update!" Q
 N EMSG
 S EMSG=$$EPCSLADT(INPUT)
 I $G(EMSG)'="1" S RSLT=$G(EMSG) Q
 S RSLT=1
 Q
 ;
EPCSLADT(LINE) ; EP - Called form ENTRYLA^BEHOEP1
 N FDA,FDAIEN,FDAMSG,I,ERR,NOW
 S NOW=$P($$HTE^XLFDT($H),":",1,2)
 D DT^DILF("TS",NOW,.NOW,,"")
 S LINE=LINE_U_NOW
 F I=1:1:5 S FDA(90460.09,"+1,",(I/100))=$P(LINE,"^",I) ;BEHOEP EPCS OE/RR PARAMETERS DATA
 D UPDATE^DIE("","FDA","FDAIEN","FDAMSG")
 I $D(FDAMSG("DIERR")) S ERR="0^Error Saving Logical Access! "_$G(FDAMSG("DIERR","1","TEXT",1))
 I $G(ERR)'="" Q $G(ERR)
 Q 1
 ;
LDPNDGLA(RSLT,PROV) ;EP - Provider Pending Logical Access Requests
 ;INPUT: No Parameter; OUTPUT: Facility IEN^Facility name^leave this empty^Enabled^modified by name^date/time modified
 ;RPC will load all Pending Logical Access Verifications.
 I $G(PROV)'>0,$G(DUZ)'>0 S RSLT="0^Provider IEN is Mandatory!" Q
 N SCR,INDEX,OUT,MSG
 S SCR="I 1"
 S SCR=SCR_" & (($P($G("_"^"_"(0)),""^"",6))'>"_"0"_")"
 S SCR=SCR_" & (($P($G("_"^"_"(0)),""^"",1))="_$G(PROV)_")"
 D LIST^DIC(90460.09,"","@;.01I;.02;.03;.03I;.04;.05","B","*",,,,SCR,"","OUT","MSG")
 S INDEX=$O(OUT("DILIST","ID",""),"-1")
 I +INDEX>0  D
 .S RSLT(INDEX)=$G(OUT("DILIST","ID",INDEX,.03,"I"))_"^"_$G(OUT("DILIST","ID",INDEX,.03,"E"))_"^"_"^"_$G(OUT("DILIST","ID",INDEX,.04))_"^"_$G(OUT("DILIST","ID",INDEX,.02))_"^"_$G(OUT("DILIST","ID",INDEX,.05))
 .S INDEX=$O(OUT("DILIST","ID",INDEX))
 Q
 ;
LOACVERF(PROV) ;EP - Provider Logical Access Verification
 ;INPUT: Provider IEN, OUTPUT: 0/1 or Message
 ;RPC will save the pending logical access to OE/RR EPCS PARAMETERS(100.7) and logical access will be marked as Verified.
 I $G(PROV)'>0,$G(DUZ)'>0 Q "0^Provider IEN is Mandatory!"
 N SCR,INDEX,FDA,MSG,NOW,ENUSER,OEIEN,INDX,ERREN,OUT,ENUSR,LAIEN,RCRD,RTN
 S OEIEN=$O(^ORD(100.7,0))
 I +$G(OEIEN)'>0 Q "-1~You must first run the ePCS Site Enable/Disable [OR EPCS SITE PARAMETER] option"
 S NOW=$P($$HTE^XLFDT($H),":",1,2)
 S SCR="I 1"
 S SCR=SCR_" & (($P($G("_"^"_"(""IHSEPCS1"")),""^"",1))'>"_"0"_")"
 S SCR=SCR_" & (($P($G("_"^"_"(0)),""^"",1))="_PROV_")"
 ;S SCR=SCR_" & (($P($G("_"^"_"(0)),""^"",2))="_DUZ_")"
 D LIST^DIC(90460.09,"","@;.01I;.03I;.04I","B","*",,,,SCR,"","OUT","MSG")
 D GETS^DIQ(100.7,OEIEN_",","1*","I","ENUSR","ERREN")
 S INDEX=$O(OUT("DILIST","ID",""))
 I +INDEX'>0 Q 1
 I +INDEX>0 F  D  Q:(+INDEX'>0)
 .S ENUSR=$G(OUT("DILIST","ID",INDEX,.04))
 .S LAIEN=$G(OUT("DILIST",2,INDEX)) ;Hardcode First Entry
 .S INDX=$O(ENUSR(100.71,"")),ENUSER=0
 .N FDA,MSG
 .S FDA(90460.09,LAIEN_",",.06)=DUZ,FDA(90460.09,LAIEN_",",.07)=NOW
 .D FILE^DIE("","FDA","MSG")
 .I $D(MSG("DIERR")) S RTN="0^Error updating Verification in Audit Logical Access, "_$G(MSG("DIERR","1","TEXT",1)) Q
 .I +INDX>0 F  D  Q:(INDX="")
 ..I $G(ENUSR(100.71,INDX,.01,"I"))=$G(PROV) S ENUSER=1,RCRD=INDX ;ENABLED USER CHECK
 ..S INDX=$O(ENUSR(100.71,INDX))
 .S INDEX=$O(OUT("DILIST","ID",INDEX))
 Q:$G(RTN)'="" $G(RTN)
 S RTN=1
 I '$G(ENUSER),$G(ENUSR),$G(OEIEN)>0 S RTN=$$CRUSRENT^BEHOEP6(OEIEN,PROV)
 Q:$G(RTN)'=1 $G(RTN)
 I $G(ENUSER),'$G(ENUSR),$G(OEIEN)>0,$G(RCRD)'="" S RTN=$$DLUSRENT^BEHOEP6(OEIEN,PROV,$G(RCRD))
 Q:$G(RTN)'=1 $G(RTN)
 I '$G(ENUSER),$G(ENUSR) Q "1^Activated"
 I $G(ENUSER),'$G(ENUSR) Q "1^Inactivated"
 Q 1
 ;
INPTRANS(RSLT,CONTROL) ;EP - INPUT TRANSFORM on 200, Credentialing GUI checks
 ;INPUT: IEN^DEA^VA OUTPUT: 0^Message,1
 ;RPC will return DEA# and VA# Fields Validation (Input Transform Checks).
 N TXT
 I CONTROL="" S RSLT=1 Q
 I $P(CONTROL,"^",2)'="" S TXT=$$VALDEA^BEHOEP2($P(CONTROL,"^",1),$P(CONTROL,"^",2))
 I $G(TXT)="1" S TXT=""
 I $G(TXT)'="" S TXT=$G(TXT)
 I $P(CONTROL,"^",1)'="",$P(CONTROL,"^",3)'="" S TXT=$G(TXT)_$$VANUM^BEHOEP2($P(CONTROL,"^",1),$P(CONTROL,"^",3))
 I $G(TXT)'="" S RSLT="0^"_$G(TXT)
 I $G(TXT)="" S RSLT=1
 Q
 ;
VANUM(DA,X) ;EP - Check that the VA# is not Active for anybody else. Called from ^DD(200,53.3,0)
 N TXT2
 I $D(X) I $L(X)>10!($L(X)<3) S TXT2="VA# MUST BE 3 to 10 CHARACTERS WITH NO SPACES. ~"
 I $G(TXT2)'="" Q $G(TXT2)
 I '$D(X)!'$D(DA) Q ""
 N %
 I $D(^VA(200,"PS2",X)) D
 . S %=0
 . F  S %=$O(^VA(200,"PS2",X,%)) Q:'%  I %'=DA,$S('$P($G(^VA(200,%,"PS")),"^",4):1,1:$P(^("PS"),"^",4)'<DT) K X Q
 . Q
 I '$D(X) S TXT2="VA# IS NOT UNIQUE. ~"
 Q $G(TXT2)
 ;
VALDEA(DA,X,F) ;EP - Check for a valid DEA#
 ;Returns 0 for NOT Valid, 1 for Valid
 ;F = 1 for Facility DEA check.
 N TXT3
 I $D(X) I $L(X)>9!($L(X)<9)!'(X?2U7N) S TXT3="DEA# MUST BE TWO UPPER CASE LETTERS FOLLOWED BY 7 DIGITS. ~"
 I $G(TXT3)'="" Q $G(TXT3)
 S F=$G(F)
 I $D(X),'F,$D(DA),$D(^VA(200,"PS1",X)),$O(^(X,0))'=DA S TXT3="DEA# IS NOT UNIQUE. ~"
 ;I $D(X),'F,$D(DA),$E(X,2)'=$E($P(^VA(200,DA,0),"^")) S TXT3=$G(TXT3)_"DEA# FORMAT MISMATCH -- CHECK SECOND LETTER. ~"
 ;I $D(X),'$$DEANUM(X) S TXT3=$G(TXT3)_"DEA# FORMAT MISMATCH -- NUMERIC ALGORITHM FAILED. ~"
 Q $G(TXT3)
 ;
DEANUM(X) ;EP - Check DEA # part
 N VA1,VA2
 S VA1=$E(X,3)+$E(X,5)+$E(X,7)+(2*($E(X,4)+$E(X,6)+$E(X,8)))
 S VA1=VA1#10,VA2=$E(X,9)
 Q VA1=VA2
 ;
DELPNDVF(RSLT,PROV) ;EP - Delete Pending Verification for a Provider
 ;INPUT: Provider IEN, OUTPUT: 0^Message,1
 ;RPC will delete all pending verification from Logical Access (100.7) and Profile (8991.6) files.
 I $G(PROV)'>0,$G(DUZ)'>0 S RSLT="0^Provider IEN is Mandatory!" Q
 N SCR,INDEX,LISTPROF,MSG,OUT,PIEN
 S SCR="I 1",MSG=1
 S SCR=SCR_" & (($P($G("_"^"_"(""IHSEPCS1"")),""^"",1))="_""""""_")"
 S SCR=SCR_" & (($P($G("_"^"_"(0)),""^"",1))="_$G(PROV)_")"
 D LIST^DIC(8991.6,"","@;.01I;.01E;.02I;.02E;.06","B","*",,,,SCR,"","OUT")
 S INDEX=$O(OUT("DILIST","ID",""))
 I +INDEX>0 F  D  Q:(+INDEX'>0)
 .S MSG=$$DELPROVE(OUT("DILIST",2,INDEX),PROV,8991.6)
 .I $G(MSG)'=1 Q
 .S INDEX=$O(OUT("DILIST","ID",INDEX))
 I $G(MSG)'="1" S RSLT="0^"_$G(MSG) Q
 N SCR,INDEX,OUT,MSG
 S SCR="I 1",MSG=1
 S SCR=SCR_" & (($P($G("_"^"_"(0)),""^"",6))="_""""""_")"
 S SCR=SCR_" & (($P($G("_"^"_"(0)),""^"",1))="_$G(PROV)_")"
 D LIST^DIC(90460.09,"","@;.01I;.01E;.02I;.02E;.05;.06","","*",,,"B",SCR,"","OUT")
 S INDEX=$O(OUT("DILIST","ID",""))
 I +INDEX>0 F  D  Q:(+INDEX'>0)
 .S MSG=$$DELPROVE(OUT("DILIST",2,INDEX),PROV,90460.09)
 .I $G(MSG)'=1 Q
 .S INDEX=$O(OUT("DILIST","ID",INDEX))
 ;
 ;Mark any certificates as retired
 S PIEN="" F  S PIEN=$O(^BEHOEP(90460.12,"C",PROV,PIEN)) Q:PIEN=""  D
 . NEW BUPD,ERROR,STS
 . S STS=$$GET1^DIQ(90460.12,PIEN_",",.02,"I") Q:STS'="P"
 . S BUPD(90460.12,PIEN_",",.02)="R"
 . D FILE^DIE("","BUPD","ERROR")
 ;
 I $G(MSG)'="1" S RSLT="0^"_$G(MSG) Q
 S RSLT=1
 Q
DELPROVE(RECORD,PROV,FILE) ; EP - Delete entry in 100.7 and 8991.6 (OE/RR EPCS PARAMETER and XUPECS EIDT) files
 ; OEIEN = Facility Entry IEN
 ; PROV = Provider IEN
 ; RSLT=IEN of entry created in  100.71 (ENABLED USER) multiple
 I $G(RECORD)="",$G(PROV)="",$G(FILE)="" Q 1
 N FDA,FDAMSG,FDADA,MSG
 S FDA(42,FILE,RECORD_",",.01)="@"
 D FILE^DIE("","FDA(42)","FDAMSG")
 ;S FDADA=+$G(FDAIEN(1))
 I $D(FDAMSG("DIERR")) S MSG="Error deleting pending verification in file# "_$G(FILE)_". "_$G(FDAMSG("DIERR","1","TEXT",1))
 ;S FDAMSG="" F  S FDAMSG=$O(FDAMSG("DIERR",1,"TEXT",FDAMSG)) Q:FDAMSG=""  S MSG=$G(MSG)_" "_FDAMSG("DIERR",1,"TEXT",FDAMSG)
 I $G(MSG)'=""  Q $G(MSG)
 Q 1
 ;
HASHNP(PROV) ;EP - Provider Profile Hash Calculation
 ;Hash Method
 N HASH,STR,RTN,EXEC
 D READP200^BEHOEP1(.STR,PROV,"0",1)
 S EXEC="S HASH=##class(%SYSTEM.Encryption).SHAHash(256,STR)" X EXEC
 S EXEC="S RTN=$System.Encryption.Base64Encode(HASH)" X EXEC
 Q $G(RTN)
