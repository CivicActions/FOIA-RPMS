BEHOEP1 ; GDIT/IHS/FS - Reading Provider Profile & Logical Access;11-Feb-2019 15:36;PLS
 ;;1.1;BEH COMPONENTS;**070001**;Mar 20, 2007;Build 9
 ;
 ;Ref. to ^UTILITY via IA 10061
 ;
 ;GDIT/IHS/BEE - Added UPCERT
GETPUBKY(RSLT,SERIAL) ; EP - RPC will return the User Public Cert
 ; RPC: BEHOEP1 UPCERT
 ;
 ;Input - Serial Number from 90460.12
 ;
 ;Returns the User Public Cert
 ;
 NEW IEN,SIEN,CERT,II
 ;
 I $G(SERIAL)="" S RSLT="-1"_U_"The Serial Number input parameter is required. Please contact your credentialing administrator." Q
 ;
 ;Find entry
 S (IEN,SIEN)="" F  S IEN=$O(^BEHOEP(90460.12,"B",$E(SERIAL,1,30),IEN)) Q:IEN=""  D  Q:SIEN]""
 . I $$GET1^DIQ(90460.12,IEN_",",.01,"E")'=SERIAL Q
 . ;
 . ;Found it
 . S SIEN=IEN
 I SIEN="" S RSLT="-2"_U_"Your signing certificate could not be located in the credentialing database. Please contact your credentialing administrator." Q
 ;
 ;Assemble the User Public Cert
 S CERT="",II=0 F  S II=$O(^BEHOEP(90460.12,SIEN,3,II)) Q:'II  D
 . S CERT=CERT_$S(CERT]"":$C(13,10),1:"")_$TR($G(^BEHOEP(90460.12,SIEN,3,II,0)),$C(10))
 ;
 S RSLT="1"_U_CERT
 Q
 ;
PROV(RSLT,SRCH) ;EP - Remote Procedure: BEHOEP1 PROV
 ;INPUT: PROVIDER NAME SEARCH, RETURN: Provider IEN^Provider NAME (ARRAY)
 ;RETURN LIST OF PROVIDERS
 ;Test Call: D PROV^BEHOEP1(.Y) ZW Y
 N I,IEN,NAME,SORT
 S SRCH=$G(SRCH)
 S I=1
 ;
 K RSLT
 ;
 ;If search string passed in return applicable providers with names following after string
 ;
 S NAME=SRCH
 I NAME]"" F  S NAME=$O(^VA(200,"B",NAME)) Q:NAME=""  S IEN=0,IEN=$O(^(NAME,IEN))  D
 .Q:$E(NAME)="*"
 .I $D(^XUSEC("ORES",IEN)),$$ACTIVE^XUSER(IEN) S RSLT(I)=IEN_U_NAME,I=I+1
 ;
 ;If no search string passed in return all applicable providers
 ;
 I SRCH="" D
 . S IEN="" F  S IEN=$O(^XUSEC("ORES",IEN)) Q:'IEN  D
 .. Q:'$$ACTIVE^XUSER(IEN)  ;Skip if not active
 .. S NAME=$$GET1^DIQ(200,IEN_",",.01,"I") Q:NAME=""
 .. S SORT(NAME_I)=IEN_U_NAME
 . ;
 . ;Assemble output in alphabetical order
 . S NAME="",I=1 F  S NAME=$O(SORT(NAME)) Q:NAME=""  S RSLT(I)=SORT(NAME),I=I+1
 ;
 Q
 ;
READP200(RSLT,PROVIEN,WRMEDORD,HASH) ;EP - RemoteProcedure: BEHOEP1 READ200
 ;INPUT: Provider Ien, RETURN: 53.1^53.2^53.3^53.11^55.1^55.2^55.3^55.4^55.5^55.6^501.2^747.44 (String)
 ;Reading Profile fields from NEW PERSON (200)
 ;Calling this method with WRMEDORD=0 will exclude AUTHORIZED TO WRITE MED ORDERS from response.
 ;Test Call: D READP200^BEHOEP1(.Y,"7") ZW Y
 S HASH=+$G(HASH)
 I $G(PROVIEN)'>0,$G(DUZ)'>0 S RSLT="0^Provider IEN is Mandatory!" Q
 N AUTH,DEA,INSTDEA,DETOX,SCH2NAR,SCH2NNAR,SCH3NAR,SCH3NNAR,SCHEDUL4,SCHEDUL5,DEAEXPDT,SUBALTNM,INCLUDE,PIVIDTFR,PNAME
 S AUTH=$$GET1^DIQ(200,PROVIEN_",",53.1,"I") ;AUTHORIZED TO WRITE MED ORDERS
 I $G(AUTH)="" S AUTH="0"
 S DEA=$$GET1^DIQ(200,PROVIEN_",",53.2) ;DEA #
 S INSTDEA=$$GET1^DIQ(200,PROVIEN_",",53.3) ; VA# or Institution DEA #
 S DETOX=$$GET1^DIQ(200,PROVIEN_",",53.11) ; DETOX Number or DETOX/MAINTENANCE ID NUMBER
 S SCH2NAR=$$GET1^DIQ(200,PROVIEN_",",55.1,"I") ;SCHEDULE II NARCOTIC
 I $G(SCH2NAR)="" S SCH2NAR="0"
 S SCH2NNAR=$$GET1^DIQ(200,PROVIEN_",",55.2,"I") ;SCHEDULE II NON-NARCOTIC
 I $G(SCH2NNAR)="" S SCH2NNAR="0"
 S SCH3NAR=$$GET1^DIQ(200,PROVIEN_",",55.3,"I") ;SCHEDULE III NARCOTIC
 I $G(SCH3NAR)="" S SCH3NAR="0"
 S SCH3NNAR=$$GET1^DIQ(200,PROVIEN_",",55.4,"I") ;SCHEDULE III NON-NARCOTIC
 I $G(SCH3NNAR)="" S SCH3NNAR="0"
 S SCHEDUL4=$$GET1^DIQ(200,PROVIEN_",",55.5,"I") ;SCHEDULE IV
 I $G(SCHEDUL4)="" S SCHEDUL4="0"
 S SCHEDUL5=$$GET1^DIQ(200,PROVIEN_",",55.6,"I") ;SCHEDULE V
 I $G(SCHEDUL5)="" S SCHEDUL5="0"
 S SUBALTNM=$$GET1^DIQ(200,PROVIEN_",",501.2) ;SUBJECT ALTERNATIVE NAME
 S DEAEXPDT=$$GET1^DIQ(200,PROVIEN_",",747.44) ;DEA# EXPIRATION DATE
 S PIVIDTFR="" S:+HASH PIVIDTFR=$$GET1^DIQ(200,PROVIEN_",",9999999.2) ;THUMBPRINT - Include in HASH
 S PNAME=$$GET1^DIQ(200,PROVIEN_",",.01) ;.01 - NAME
 I +HASH S RSLT=$G(DEA)_"^"_$G(INSTDEA)_"^"_$G(DETOX)_"^"_$G(SCH2NAR)_"^"_$G(SCH2NNAR)_"^"_$G(SCH3NAR)_"^"_$G(SCH3NNAR)_"^"_$G(SCHEDUL4)_"^"_$G(SCHEDUL5)_"^"_$G(DEAEXPDT)_"^"_$G(PIVIDTFR) Q  ;Assemble for HASH
 ; WRMEDORD PBI 1398: Remove "Write to med orders" field from hash (Passing 0 in WRMEDORD will satisfy this request)
 S:$G(WRMEDORD)="0" RSLT=$G(DEA)_"^"_$G(INSTDEA)_"^"_$G(DETOX)_"^"_$G(SCH2NAR)_"^"_$G(SCH2NNAR)_"^"_$G(SCH3NAR)_"^"_$G(SCH3NNAR)_"^"_$G(SCHEDUL4)_"^"_$G(SCHEDUL5)_"^"_$G(DEAEXPDT) ;_"^"_$G(PIVIDTFR) We hide this from the GUI
 S:$G(WRMEDORD)="" RSLT=$G(AUTH)_"^"_$G(DEA)_"^"_$G(INSTDEA)_"^"_$G(DETOX)_"^"_$G(SCH2NAR)_"^"_$G(SCH2NNAR)_"^"_$G(SCH3NAR)_"^"_$G(SCH3NNAR)_"^"_$G(SCHEDUL4)_"^"_$G(SCHEDUL5)_"^"_$G(DEAEXPDT)_"^"_$G(SUBALTNM)_"^"_$G(PIVIDTFR)_"^"_$G(PNAME)
 Q
 ;
ENTRYEP(RSLT,INPUT) ;EP - RemoteProcedure: BEHOEP1 ENTRYEP
 ;INPUT: Provider IEN^DUZ^Field Number^Old^New (ARRAY) RETURN: 0/1
 ;Saving into XUEPCS Edit File. Audit entries for EPCS Profile data (NEW PERSON (200) Fields)
 ;Test Call
 ;S INPUT="2526^2511^55.1^0^1~2526^2511^55.2^0^1~2526^2511^55.3^0^1~"
 ;D ENTRYEP^BEHOEP1(.Y,.INPUT) ZW Y
 N INDEX,MSG
 I '$G(INPUT) S RSLT="0^Please resend the data!" Q
 F INDEX=1:1:$L(INPUT,"~") S MSG=$$EPCSDATA($P(INPUT,"~",INDEX)) I $G(MSG)'="" Q
 I $G(MSG)'="" S RSLT=$G(MSG) Q
 S RSLT=1
 Q
 ;
EPCSDATA(LINE) ;EP - Called from ENTRYEP^BEHOEP1
 ;S LINE="2512^2505^55.6^0^1"
 ;D EPCSDATA^BEHOEP1(LINE)
 N FDA,IEN,MSG,FDAMSG,I,NOW
 I $G(LINE)="" Q ""
 S NOW=$P($$HTE^XLFDT($H),":",1,2)
 D DT^DILF("TS",NOW,.NOW,,"")
 S LINE=LINE_U_NOW
 F I=1:1:6 S FDA(8991.6,"+1,",(I/100))=$P(LINE,"^",I)
 D UPDATE^DIE("","FDA","IEN","FDAMSG")
 I $D(FDAMSG("DIERR")) S MSG="0^Error Saving Profile Data in File# 8991.6. "_$G(FDAMSG("DIERR","1","TEXT",1))
 ;S MSG="" F  S MSG=$O(FDAMSG("DIERR",1,"TEXT",MSG)) Q:MSG=""  S MSG=$G(MSG)_" "_FDAMSG("DIERR",1,"TEXT",MSG)
 I $G(MSG)'="" Q $G(MSG)
 Q ""
 ;
LOACREAD(RSLT,PROV) ;EP - RemoteProcedure: BEHOEP1 LOACREAD
 ;INPUT: Provider IEN, OUTPUT: Facility IEN^Facility Name^Facility DEA^ENABLED EPCS^ENABLED USER (0/1)
 ;RPC will read Logical Access Controls from OE/RR EPCS PARAMETERS (100.7) File
 ;Test Call: D LOACREAD^BEHOEP1(.R,1) ZW R
 I $G(PROV)'>0,$G(DUZ)'>0 S RSLT="0^Provider IEN is Mandatory!" Q
 N INDEX,OUT,OERRFIEN,OERREPCS,FACIEN,FACNAME,FACDEA
 S OERRFIEN=$O(^ORD(100.7,0))
 I +$G(OERRFIEN)'>0 S RSLT="-1~You must first run the ePCS Site Enable/Disable [OR EPCS SITE PARAMETER] option" Q
 S OERREPCS=$$GET1^DIQ(100.7,OERRFIEN_",",.02,"I") ;.02 ENABLE EPCS?
 S FACIEN=$$GET1^DIQ(100.7,OERRFIEN_",",.01,"I") ;.01 SITE IEN
 S FACNAME=$$GET1^DIQ(100.7,OERRFIEN_",",.01) ;.01 SITE NAME
 S FACDEA=$$GET1^DIQ(4,FACIEN_",",52) ;52 FACILITY DEA# of INSTITUTION(4)
 S RSLT=$G(FACIEN)_"^"_$G(FACNAME)_"^"_$G(FACDEA)_"^"
 N INDEX,ENUSER,OUT,ERR
 D GETS^DIQ(100.7,OERRFIEN_",","1*","I","OUT","ERR") ;FIRST & ONLY ENTRY of 100.7
 S INDEX=$O(OUT(100.71,"")),ENUSER=0
 I +INDEX>0 F  D  Q:(INDEX="")
 .I $G(OUT(100.71,INDEX,.01,"I"))=$G(PROV) S ENUSER=1 ;ENABLED USER CHECK
 .S INDEX=$O(OUT(100.71,INDEX))
 S RSLT=RSLT_$G(ENUSER)
 Q
 ;
LDPNDNGV(RSLT) ;EP - RemoteProcedure: BEHOEP1 LDPNDNGV
 ;INPUT: No Parameter; OUTPUT: PROVIDER IEN^PROVIDER NAME^MODIFIED BY IEN^MODIFIED BY NAME^MODIFIED ON
 ;RPC will load all Pending Profile and Logical Accesss Verifications.
 ;Test Call: D LDPNDNGV^BEHOEP1(.R) ZW R
 N SCR,INDEX,I,LISTPROF,OUT
 S SCR="I 1"
 ;S SCR=SCR_" & (($P($G("_"^"_"(0)),""^"",7))="_""""""_")"
 S SCR=SCR_" & (($P($G("_"^"_"(""IHSEPCS1"")),""^"",1))="_""""""_")"
 D LIST^DIC(8991.6,"","@;.01I;.01E;.02I;.02E;.06","B","*",,,,SCR,"","OUT")
 S I=0
 S INDEX=$O(OUT("DILIST","ID",""))
 I +INDEX>0 F  D  Q:(+INDEX'>0)
 .S I=I+1,LISTPROF(I)=$G(OUT("DILIST","ID",INDEX,.01,"I"))_"^"_$G(OUT("DILIST","ID",INDEX,.01,"E"))_"^"_$G(OUT("DILIST","ID",INDEX,.02,"I"))_"^"_$G(OUT("DILIST","ID",INDEX,.02,"E"))_"^"_$G(OUT("DILIST","ID",INDEX,.06))
 .S INDEX=$O(OUT("DILIST","ID",INDEX))
 N SCR,INDEX,I,LISTLA,OUT,TRUE
 S SCR="I 1"
 S SCR=SCR_" & (($P($G("_"^"_"(0)),""^"",6))="_""""""_")"
 D LIST^DIC(90460.09,"","@;.01I;.01E;.02I;.02E;.05","B","*",,,,SCR,"","OUT")
 S I=0
 S INDEX=$O(OUT("DILIST","ID",""))
 I +INDEX>0 F  D  Q:(+INDEX'>0)
 .S I=I+1,LISTLA(I)=$G(OUT("DILIST","ID",INDEX,.01,"I"))_"^"_$G(OUT("DILIST","ID",INDEX,.01,"E"))_"^"_$G(OUT("DILIST","ID",INDEX,.02,"I"))_"^"_$G(OUT("DILIST","ID",INDEX,.02,"E"))_"^"_$G(OUT("DILIST","ID",INDEX,.05))
 .S INDEX=$O(OUT("DILIST","ID",INDEX))
 N INDEX,INDEX2
 S I=0
 S INDEX=$O(LISTPROF(""))
 I +INDEX>0 F  D  Q:(+INDEX'>0)
 .S INDEX2=$O(RSLT(""))
 .S TRUE=1
 .I +INDEX2>0 F  D  Q:(+INDEX2'>0)
 ..I $P(RSLT(INDEX2),"^",1)=$P(LISTPROF(INDEX),"^",1) S RSLT(INDEX2)=LISTPROF(INDEX),TRUE=0
 ..S INDEX2=$O(RSLT(INDEX2))
 .I TRUE S I=I+1,RSLT(I)=$G(LISTPROF(INDEX))
 .S INDEX=$O(LISTPROF(INDEX))
 N INDEX,INDEX2
 S INDEX=$O(LISTLA(""))
 I +INDEX>0 F  D  Q:(+INDEX'>0)
 .S INDEX2=$O(RSLT(""))
 .S TRUE=1
 .I +INDEX2>0 F  D  Q:(+INDEX2'>0)
 ..I $P(RSLT(INDEX2),"^",1)=$P(LISTLA(INDEX),"^",1) D
 ...NEW X,Y,%DT,T1,T2
 ...S X=$P(RSLT(INDEX2),"^",5),%DT="T" D ^%DT S T1=Y
 ...S X=$P(LISTLA(INDEX),"^",5),%DT="T" D ^%DT S T2=Y
 ...S TRUE=0
 ...I T1>T2 Q  ;Return the latest date last updated
 ...S RSLT(INDEX2)=LISTLA(INDEX)
 ..S INDEX2=$O(RSLT(INDEX2))
 .I TRUE S I=I+1,RSLT(I)=$G(LISTLA(INDEX))
 .S INDEX=$O(LISTLA(INDEX))
 Q
 ;
