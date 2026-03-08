BIVWSOAP  ; GPL/RCR MSC/DKA - Web Service utilities;07/07/16 13:30
 ;;8.5;IMMUNIZATION;**18,29,30**;OCT 24,2011;Build 125
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**216**;Aug 12, 1996;Build 4
 ;
 ; Modified by Chris Richardson, November, 2010.
 ; Code has been modified to accept very large XML documents and block them logically.
 ; 3101208 - RCR - Correct end of buffer condition, BF=">"
 ;
 ;
 ;  ==========
SOAP(BIFDT,C0RTN,BIPARMS,C0DETAIL,BIH,BIF,BIXMLV,BIERR) ;
 ;V8.5 PATCH 29 - FID-
 ; MAKES A SOAP CALL FOR BASED ON BIPARMS passed by reference
 ;     1 - BIFDT  (opt) Forecast Date (date used for forecast).
 ;     5 - BIH    (ret) Patient Imm History Evaluation from ICE.
 ;     6 - BIF    (ret) Patient Imm Forecast from ICE.
 ;     7 - BIXMLV (ret) ICE Version Number.
 ;     8 - BIERR  (ret) Error Number.
 ;
 ; BIPARMS("xml")=location of ready to go xml (skip encoding and soap envelop buildling)
 ; BIPARMS("url")=url string for the SOAP call
 ; BIPARMS("payload")=name of location of the xml payload
 ; BIPARMS("envelop")=name of the location of the xml soap envelop
 ; BIPARMS("payloadVarOut")=variable for outgoing payload; default "outPayload"
 ; BIPARMS("payloadVarIn")=incoming tag for payload; default "base64EncodedPayload"
 ; BIPARMS("format")=format of the output: xml,outline,global - default global
 ;
 N C0URL,PAYLOAD,ENVELOP,PLVAR,C0RSLT,HEADER,C0RHDR,C0MIME,XML,XMLLOC,C0MIME,RXML,IOT
 S:('$G(BIFDT)) BIFDT=DT
 ;--> Seed ICE Version#.
 S BIXMLV="Unknown"
 ;
 S RXML=$NA(^TMP("BIICE",$J,"RETURNXML"))
 ;K @RXML  ;maw PUT BACK IN AFTER TESTING
 ;
 ;K @C0RTN
 S C0URL=$G(BIPARMS("url"))
 N C0IP,C0PORT,C0SVC
 S C0IP=$G(BIPARMS("ip"))
 S C0PORT=$G(BIPARMS("port"))
 ; If the value has not been set, then see if there is only one
 ;
 N BICHK,BISRV
 S BICHK=1 S BISRV=$G(^BISITE(DUZ(2),3)) F I=1:1:5 I $P(BISRV,U,I)="" S BICHK=0
 ;---> * * * SET PROPER BIERR HERE * * *
 ;I 'BICHK S @RET@(RCOUNT)="-1^Unable to determine default ICE SERVER" Q
 ;I 'BICHK S BIERR=SOMETHING SOMETHING Q
 ;
 ;
 S C0SVC="/"_$P(BISRV,U,3)_"/"_$P(BISRV,U,4)
 S PAYLOAD=$G(BIPARMS("payload"))
 S OUTPLV=$G(BIPARMS("payloadVarOut"),"outPayload") ; payload variable outgoing
 S INPLV=$G(BIPARMS("payloadVarIn"),"base64EncodedPayload") ; payload tag incoming
 S ENVELOP=$G(BIPARMS("envelop"))
 S C0MIME="content-type: text/soap+xml; charset=utf-8"
 S HEADER(1)="User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; MS Web Services Client Protocol 2.0.50727.3074)"
 S HEADER(2)="Expect: 100-continue"
 S HEADER(3)="Connection: Keep-Alive"
 S XMLLOC=$G(BIPARMS("xml")) ; only set as an override - means skipping payload building
 I XMLLOC'="" M XML=@XMLLOC
 ;
 I XMLLOC="" D  ; no complete xml supplied, build the payload
 . S XMLLOC=$NA(^TMP("BIICE",$J,"XML"))
 . K @XMLLOC
 . N C0IV
 . S C0IV(OUTPLV)=$$ENCODE(PAYLOAD)
 . ;
 . S C0IV("hl7OutTime")=$$FMDTOUTC^BIVWUTIL($S($G(BIFDT):BIFDT,1:DT))
 . ;
 . ;D GETNMAP^C0IUTIL("XML","TENVOUT^C0ITEST","C0IV")
 . D GETNMAP^BIVWUTIL("XML","TENVOUT^BIVWVMR","C0IV") ; MSC/DKA
 . K XML(0)
 . M @XMLLOC=XML
 . I $G(BITEST)=1 S OK=$$GTF^%ZISH($NA(@XMLLOC@(1)),4,$$DEFDIR^%ZISH,$$FMDTOUTC^BIVWUTIL($$NOW^XLFDT)_"ice-sending"_BIDFN_".xml") ; MSC/DKA
 ;
 ;M XML=@XMLLOC
 K C0RSLT,C0RHDR
 N C0RXML
 ;
 ; make the soap call
 ;
 ;S ok=$$httpPOST^C0IEWD(C0URL,.XML,C0MIME,.C0RXML,.HEADER) ;,,1) ;for test
 ;S ok=$$httpPOST^%zewdGTM(C0URL,.XML,C0MIME,.C0RSLT,.HEADER,"",.PARM5,.C0RHDR)
 N DATA S DATA=""
 N II S II=""
 F  S II=$O(XML(II)) Q:II=""  S DATA=DATA_XML(II)
 ;N % S %=$$POST1^XUSBSE2(.C0RSLT,C0IP,C0PORT,C0SVC,.DATA)
 N % S %=$$POST1^BIVWXICE(.C0RSLT,C0IP,C0PORT,C0SVC,.DATA)
 S C0RXML(1)=% ; the return xml is in % .. go figure
 ;
 ;---> Null result will return BIERR 127=" No response from ICE. Check Tomcat/ICE installation"
 I ($G(C0RXML(1))="DIDN'T OPEN CONNECTION")!($G(C0RXML(1))="") S BIERR=127 Q
 ;
 ;I $G(C0RXML(2))="" D  Q ;
 ;. K @C0RTN
 ;. M @C0RTN=C0RXML
 ;
 ; locate and decode the embedded xml
 ;
 N %BEG,%END
 S %BEG="<"_INPLV_">"
 S %END="</"_INPLV_">"
 N ALLXML S ALLXML=""
 N ZI
 S ZI=""
 F  S ZI=$O(C0RXML(ZI)) Q:ZI=""  D  ;
 . S ALLXML=ALLXML_C0RXML(ZI)
 . ;W !,ZI
 ;I ALLXML'[%BEG D  B  Q  ;
 I ALLXML'[%BEG D  Q  ;
 . ;W !,"ERROR DETECTED",!
 . ;ZWR C0RXML
 . M @RXML=C0RXML
 . S @RXML=0
 . ; S @C0RTN=C0RXML
 . S:$D(C0RXML)#10 @C0RTN=C0RXML ; MSC/DKA Prevent <UNDEFINED> error if SOAP call didn't succeed
 ;
 N XMLBASE64
 S XMLBASE64=$P($P(ALLXML,%END,1),%BEG,2)
 N RTNXML
 S RTNXML(1)=$$DECODER(XMLBASE64)
 S OK=$$REDUCRCR(.RTNXML,1)
 ;N RXML S RXML=$NA(^TMP("BIICE",$J,"RETURNXML"))
 ;K @RXML
 ;
 ;---> If BITEST, write the ICE Output XML to a host file.
 ;S BITEST=1  ;20220109 maw for getting output
 I $G(BITEST)=1 D
 .M @RXML=RTNXML
 .S @RXML=1
 .;X ^O  RXML="^TMP("BIICE",$J,"RETURNXML")=1,  ;MWRZZZ
 .;            ^TMP("BIICE",$J,"RETURNXML",1)=unencoded data
 .N BID S BID=$$FMDTOUTC^BIVWUTIL($$NOW^XLFDT)
 .S OK=$$GTF^%ZISH($NA(@RXML@(1)),4,$$DEFDIR^%ZISH,BID_"ice-return"_BIDFN_".xml")
 ;
 ;---> STOP old parsing code here, call new parsing routine BIEXTR.
 ;---> Return History, Forecast, and ICE Version Number.
 D PARSE^BIVWPAR(.RTNXML,.BIH,.BIF,.BIXMLV,.BIERR)
 Q
 ;
 ;
 M @RXML=RTNXML
 S @RXML=1
 ;X ^O  RXML="^TMP("BIICE",18768,"RETURNXML")=1,  ;MWRZZZ
 ;            ^TMP("BIICE",18768,"RETURNXML",1)=unencoded data
 ;
 ;
 I $G(BITEST)=1 S OK=$$GTF^%ZISH($NA(@RXML@(1)),4,$$DEFDIR^%ZISH,$$FMDTOUTC^BIVWUTIL($$NOW^XLFDT)_"ice-return"_BIDFN_".xml") ; MSC/DKA
 ;B  ;---> Look at ^TMP nodes that hold return XML
 ;---> DO ^BIEXTR HERE! ;MWRZZZ
 ;
 I $G(BIPARMS("format"))="xml" D  Q  ;
 . M @C0RTN=RTNXML
 ;
 ;
 ;
 ; call the parser
 N C0IDOCID
 S C0IDOCID=$$PARSE^BIVWEXTR(RXML,"C0IDOC"_$J)
 ;
 I $G(BIPARMS("format"))="outline" D  Q  ;
 . D SHOW^BIVWUTIL(1,C0IDOCID,C0RTN)
 ;
 ; convert the MXML DOM into a mumps array to return
 ;X ^O
 ;---> YIELDS C0RLST(1...) C0RSLT(6)=ENCODED STUFF, C0RTN="ARR1", C0RXML=ENVELOPE+ENCODED STUFF,
 ;---> C0SVC="/opencds-ICE/evaluate"
 ;---> C0URL="http://127.0.0.1:8080/opencds-ICE/evaluate"
 ;
 ;
 D DOMO3^BIVWEXTR(C0RTN) ; MSC/DKA
 ;B  ;---> Events and Event have no number between them.  MWRZZZ
 ;
 ; return all the artifacts here
 ;
 Q
 ;
EXTRACT(C0RXML) ;
 I $G(INPLV)="" S INPLV="base64EncodedPayload"
 N %BEG,%END
 S %BEG="<"_INPLV_">"
 S %END="</"_INPLV_">"
 N ALLXML S ALLXML=""
 N ZI
 S ZI=""
 F  S ZI=$O(C0RXML(ZI)) Q:ZI=""  D  ;
 . S ALLXML=ALLXML_C0RXML(ZI)
 . ;W !,ZI
 I ALLXML'[%BEG D  Q  ;
 . W !,"ERROR DETECTED",!
 . D ZWR^BIVWUTIL($NA(C0RXML)) ; MSC/DKA
 ;
 N XMLBASE64
 S XMLBASE64=$P($P(ALLXML,%END,1),%BEG,2)
 N RTNXML
 S RTNXML(1)=$$DECODER(XMLBASE64)
 S OK=$$REDUCRCR(.RTNXML,1)
 N RXML S RXML=$NA(^TMP("BIICE",$J,"RETURNXML"))
 K @RXML
 M @RXML=RTNXML
 I $G(BITEST)=1 S OK=$$GTF^%ZISH($NA(@RXML@(1)),4,$$DEFDIR^%ZISH,$$FMDTOUTC^BIVWUTIL($$NOW^XLFDT)_"ice-unwrap"_DFN_".xml") ; MSC/DKA
 Q
 ;
ENCODE(ZXML) ; extrinsic which returns a base64 encoding of the XML, which
 ; is passsed by name
 N ZI,ZS
 S ZI="" S ZS=""
 F  S ZI=$O(@ZXML@(ZI)) Q:ZI=""  D  ;
 . S ZS=ZS_@ZXML@(ZI)
 Q $$ENCODE^BIVWUUCD(ZS)
 ;
 ; ===================
NORMAL(OUTXML,INXML) ;NORMALIZES AN XML STRING PASSED BY NAME IN INXML
 ; INTO AN XML ARRAY RETURNED IN OUTXML, ALSO PASSED BY NAME
 ;
 N INBF,ZI,ZN,ZTMP
 S ZN=1,INBF=@INXML
 S @OUTXML@(ZN)=$P(INBF,"><",ZN)_">"
 ; S ZN=ZN+1
 ; F  S @OUTXML@(ZN)="<"_$P(@INXML,"><",ZN) Q:$P(@INXML,"><",ZN+1)=""  D  ;
 ; Should speed up, and not leave a dangling node, and doesn't stop at first NULL
 F ZN=2:1:$L(INBF,"><") S @OUTXML@(ZN)="<"_$P(INBF,"><",ZN)_">"
 ; . ; S ZN=ZN+1
 ; .QUIT
 QUIT
 ;  ================
 ; The goal of this block has changed a little bit.  Most modern MUMPS engines can
 ; handle a 1,000,000 byte string.  We will use BF to hold hunks that big so that
 ; we can logically suck up a big hunk of the input to supply the reblocking of the XML
 ; into more logical blocks less than 2000 bytes in length blocks.
 ; A series of signals will be needed, Source (INXML) is exhausted (INEND),
 ; BF is less than 2200 bytes (BFLD, BuFfer reLoaD)
 ; BF is Full (BF contains 998,000 bytes or more, BFULL)
 ; BF and Process is Complete (BFEND)
 ; ZSIZE defaults to 2,000 now, but can be set lower or higher
 ;
CHUNK(OUTXML,INXML,ZSIZE) ; BREAKS INXML INTO ZSIZE BLOCKS
 ; INXML IS AN ARRAY PASSED BY NAME OF STRINGS
 ; OUTXML IS ALSO PASSED BY NAME
 ; IF ZSIZE IS NOT PASSED, 2000 IS USED
 I '$D(ZSIZE) S ZSIZE=2000 ; DEFAULT BLOCK SIZE
 N BF,BFEND,BFLD,BFMAX,BFULL,INEND,ZB,ZI,ZJ,ZK,ZL,ZN
 ; S ZB=ZSIZE-1
 S ZN=1
 S BFMAX=998000
 S ZI=0 ; BEGINNING OF INDEX TO INXML
 S (BFLD,BFEND,BFULL,INEND)=0,BF=""
 ; Major loop loads the buffer, BF, and unloads it into the Output Array
 ;  in
 F  D  Q:BFEND
 . ; Input LOADER
 . D:'INEND
 . . F  S ZI=$O(@INXML@(ZI)) S INEND=(ZI="")  Q:INEND!BFULL  D   ; LOAD EACH STRING IN INXML
 . . . S BF=BF_@INXML@(ZI)                                       ; ADD TO THE BF STRING
 . . . S BFULL=($L(BF)>BFMAX)
 . . .QUIT
 . .QUIT
 . ;  Full Buffer, BF, now check for Encryption and Unpack
 . D TEST4COD(.BF,"C0RSLT(""RELOC"")")
 . ; Output BREAKER
 . F  Q:BFLD  D   ; ZJ=1:ZSIZE:ZL D  ;
 . . ; ZK=$S(ZJ+ZB<ZL:ZJ+ZB,1:ZL) ; END FOR EXTRACT
 . . F ZK=ZSIZE:-1:0  Q:$E(BF,ZK)=">"
 . . I ZK=0 S ZK=ZSIZE
 . . S @OUTXML@(ZN)=$E(BF,1,ZK) ; PULL OUT THE PIECE
 . . S ZN=ZN+1 ; INCREMENT OUT ARRAY INDEX
 . . S BF=$E(BF,ZK+1,BFMAX)
 . . S BFLD=($L(BF)<(ZSIZE*2))
 . .QUIT
 . S BFEND=(INEND&BFLD)!(">"[BF)
 . I $L(BF)&BFEND S @OUTXML@(ZN)=BF,BF=""
 .QUIT
 QUIT
 ;  ==============
 ; Test for Encryption, extract it and decode it.
TEST4COD(INBF,RELOC) ;
 N DBF,I,MSK,TBF,TRG,RCNT
 S RCNT=0
 ;  Segments expected <seg 1>DATA</seg 1><seg 2>DATA</seg 2>
 ;                           ^   ^
 S MSK=""   ; It turns out that some of the characters used were not reliable
 F I=32:1:42,44:1:47,62:1:64,91:1:96 S MSK=MSK_$C(I)
 F I=1:1:$L(INBF,"</")-1 D
 . S TBF=$RE($P($RE($P(INBF,"</",I)),">"))
 . ; Remove sample for testing
 . ; Set the trigger, mostly included to show intent and associated code
 . ;  this could be refined later if determined already obvious enough
 . S TRG=0
 . DO:$L(TBF)>20  ; If $TR doesn't remove anything, then these characters are not there
 . . I (TBF=$TR(TBF,MSK))   S TRG=1
 . . ; I (TBF=$TR(TBF," <->@*!?.,:;#$%&[/|\]={}~")) S TRG=1
 . . ;   <>!"#$%&'()*,-./67:;<>?@[\]^_`fqr{|}~  <<= Ignore 6,7,f,q, and r
 . . ; Now we set up for the DECODE and replacement in INBF
 . . DO:TRG
 . . . N A,C,CC,CV,CCX,K,XBF,T,V
 . . . DO
 . . . . N I
 . . . . S DBF=$$DECODER(TBF)
 . . . .QUIT
 . . . ;
 . . . S CCX=""
 . . . F K=1:1:$L(DBF) S CC=$E(DBF,K) S:CC?1C C=$A(CC),A(C)=$G(A(C))+1
 . . . S C="",V=""
 . . . F  S C=$O(A(C)) Q:C=""  S CCX=CCX_$C(C) S:A(C)>V V=A(C),CV=C
 . . . S CC=$C(CV)
 . . . ;  The "_$C(13,10)_" may need to be generalized, tested and set earlier
 . . . ;    Expand embedded XML in XBF
 . . . F K=1:1:$L(DBF,CC) S T=$P(DBF,CC,K),XBF(K)=$TR(T,CCX)
 . . . S RCNT=RCNT+1
 . . . M @RELOC@(RCNT)=XBF
 . . . ;   Curley braces and = makes it so it won't trigger a second time by retest.
 . . . S INBF=$P(INBF,TBF)_"<{REPLACED}="_RCNT_$P(INBF,TBF,2,999)
 . . .QUIT
 . .QUIT
 .QUIT
 ;  Now shorten the INBF so it gets smaller
 ;S INBF=$P(INBF,">",I+1,99999)
 QUIT
 ;  ===================
DECODER(BF) ; Decrypts the Encrypted Strings
 QUIT $$DECODE^BIVWUUCD(BF)
 ;  ===================
NORMAL2(OUTXML,INXML) ;NORMALIZES AN ARRAY OF XML STRINGS PASSED BY NAME INXML
 ; AS @INXML@(1) TO @INXML@(x) ALL NUMERIC
 ; INTO AN XML ARRAY RETURNED IN OUTXML, ALSO PASSED BY NAME
 ; this routine doesn't work unless the blocks are on xml tag boundaries - gpl
 ; which is hard to do... this routine is left here awaiting future development
 N ZI,ZN,ZJ
 S ZJ=0
 S ZN=1
 F  S ZJ=$O(@INXML@(ZJ)) Q:+ZJ=0  D  ; FOR EACH XML STRING IN ARRAY
 . S @OUTXML@(ZN)=$P(@INXML@(ZJ),"><",ZN)_">"
 . S ZN=ZN+1
 . F  S @OUTXML@(ZN)="<"_$P(@INXML@(ZJ),"><",ZN) Q:$P(@INXML@(ZJ),"><",ZN+1)=""  D  ;
 . . S @OUTXML@(ZN)=@OUTXML@(ZN)_">"
 . . S ZN=ZN+1
 . .QUIT
 .QUIT
 QUIT
 ;  ===============
 ;
REDUCE(ZARY,ZN) ; WILL REDUCE ZARY(ZN) BY CHOPPING IT TO 4000 CHARS
 ; AND PUTTING THE REST IN ZARY(ZN+1)
 ; ZARY IS PASSED BY REFERENCE
 ; EXTRINSIC WHICH RETURNS FALSE IF THERE IS NOTHING TO REDUCE
 I $L(ZARY(ZN))<4001   QUIT 0 ;NOTHING TO REDUCE
 ;
 S ZARY(ZN+1)=$E(ZARY(ZN),4001,$L(ZZ(ZN))) ;BREAK IT UP
 S ZARY(ZN)=$E(ZARY(ZN),1,4000) ;
 QUIT 1  ;ACTUALLY REDUCED
 ;  ===========
REDUCRCR(ZARY,ZN) ; RECURSIVE VERSION OF REDUCE ABOVE
 ; WILL REDUCE ZARY(ZN) BY CHOPPING IT TO 4000 CHARS
 ; AND PUTTING THE REST IN ZARY(ZN+1)
 ; ZARY IS PASSED BY REFERENCE
 ; EXTRINSIC WHICH RETURNS FALSE IF THERE IS NOTHING TO REDUCE
 I $L(ZARY(ZN))<4001 Q 0 ;NOTHING TO REDUCE
 ;
 S ZARY(ZN+1)=$E(ZARY(ZN),4001,$L(ZARY(ZN))) ;BREAK IT UP
 S ZARY(ZN)=$E(ZARY(ZN),1,4000) ;
 I '$$REDUCRCR(.ZARY,ZN+1) Q 1 ; CALL RECURSIVELY
 ;
 QUIT 1  ;ACTUALLY REDUCED
 ;  ===========
 ; MSC/DKA Commented out DEMUXARY subroutine that calls non-existent routine, ^C0CMXP.
 ;DEMUXARY(OARY,IARY) ;CONVERT AN XPATH ARRAY PASSED AS IARY TO
 ; ; FORMAT @OARY@(x,xpath) where x is the first multiple
 ;N ZI,ZJ,ZK,ZL S ZI=""
 ;F  S ZI=$O(@IARY@(ZI)) Q:ZI=""  D  ;
 ;. D DEMUX^C0CMXP("ZJ",ZI)
 ;. S ZK=$P(ZJ,"^",3)
 ;. S ZK=$RE($P($RE(ZK),"/",1))
 ;. S ZL=$P(ZJ,"^",1)
 ;. I ZL="" S ZL=1
 ;. S @OARY@(ZL,ZK)=@IARY@(ZI)
 ;.QUIT
 ;QUIT
 ;
