BIVWUTIL ; GPL/NEA MSC/DKA - Immunizations Forecasting Utilities ; 26 Jul 2016  8:22 AM
 ;;8.5;IMMUNIZATION;**18**;JUN 15,2020;Build 28
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**216**;Aug 12, 1996;Build 4
 ;
 Q
 ;
GETNMAP(OUTXML,INXML,IARY) ; Retrieves XML stored in Mumps routines and maps
 ; them using IARY, passed by name. Maps use @@var@@ protocol
 ; with @IARY@("var")=value for the map values
 ; OUTXML is passed by name and will hold the result
 ; INXML is the name of the storage place ie "HEADER^JJOHPPC2"
 N GTAG,GRT,GI
 S GTAG=$P(INXML,"^",1)
 S GRT=$P(INXML,"^",2)
 ; first get all of the lines of the XML
 N TXML ; temp var for xml
 S GX=1
 S GN=1
 F  S GI=GTAG_"+"_GX_"^"_GRT  Q:$T(@GI)'[";;"  D  ;
 . S GX=GX+1
 . N LN S LN=$P($T(@GI),";;",2)
 . I $E(LN,1)=";" Q  ; skip over comments
 . S TXML(GN)=LN
 . I $G(CCDADEBUG) W !,GN," ",TXML(GN)
 . S GN=GN+1
 ; next call MAP to resolve mappings and place result directly in OUTXML
 ; if OUTXML has contents already, add the result to the end and update the count (0)
 I $D(@OUTXML@(1)) D  ;
 . N TXML2
 . D MAP^BIVWXMLL("TXML",IARY,"TXML2") ; MSC/DKA
 . S GI=0
 . F  S GI=$O(TXML2(GI)) Q:+GI=0  S @OUTXML@($O(@OUTXML@(""),-1)+1)=TXML2(GI)
 . S @OUTXML@(0)=$O(@OUTXML@(""),-1)
 E  D MAP^BIVWXMLL("TXML",IARY,OUTXML) ; MSC/DKA
 Q
 ;
GET(OUTXML,INXML) ; GET ONLY Retrieves XML stored in Mumps routines
 ; OUTXML is passed by name and will hold the result
 ; INXML is the name of the storage place ie "HEADER^JJOHPPC2"
 N GTAG,GRT,GI
 S GTAG=$P(INXML,"^",1)
 S GRT=$P(INXML,"^",2)
 ; get all of the lines of the XML
 S GX=1
 S GN=1
 F  S GI=GTAG_"+"_GX_"^"_GRT  Q:$T(@GI)'[";;"  D  ;
 . S GX=GX+1
 . N LN S LN=$P($T(@GI),";;",2)
 . I $E(LN,1)=";" Q  ; skip over comments
 . S @OUTXML@($O(@OUTXML@(""),-1)+1)=LN
 . S @OUTXML@(0)=$O(@OUTXML@(""),-1)
 . I $G(CCDADEBUG) W !,GN," ",@OUTXML@(GN)
 . S GN=GN+1
 Q
 ;
TEST ;
 N GV S GV("hl7OutTime")=$$FMDTOUTC^BIVWUTIL(DT)
 K G
 D GETNMAP("G","TENVOUT^BIVWVMR","GV") ; MSC/DKA
 D ZWR^BIVWUTIL($NA(G)) ; MSC/DKA
 Q
 ;
OUTLOG(ZTXT) ; add text to the log
 I '$D(C0LOGLOC) S C0LOGLOC=$NA(^TMP("BI_C0I",$J,"LOG"))
 N LN S LN=$O(@C0LOGLOC@(""),-1)+1
 S @C0LOGLOC@(LN)=ZTXT
 Q
 ;
LOGARY(ARY) ; LOG AN ARRAY
 N II S II=""
 F  S II=$O(@ARY@(II)) Q:II=""  D  ;
 . D OUTLOG(ARY_" "_II_" = "_$G(@ARY@(II)))
 Q
 ;
UUID()  ; thanks to Wally for this.
 N R,I,J,N
 S N="",R="" F  S N=N_$R(100000) Q:$L(N)>64
 F I=1:2:64 S R=R_$E("0123456789abcdef",($E(N,I,I+1)#16+1))
 Q $E(R,1,8)_"-"_$E(R,9,12)_"-4"_$E(R,14,16)_"-"_$E("89ab",$E(N,17)#4+1)_$E(R,18,20)_"-"_$E(R,21,32)
 ;
 ; the following was borrowed from the C0CUTIL and adapted
 ;
FMDTOCDA(DATE,FORMAT) ; Convert Fileman Date to UTC Date Format; PUBLIC; Extrinsic
 ; FORMAT is Format of Date. Can be either D (Day) or DT (Date and Time)
 ; If not passed, or passed incorrectly, it's assumed that it is D.
 ; FM Date format is "YYYMMDD.HHMMSS" HHMMSS may not be supplied.
 ; UTC date is formatted as follows: YYYY-MM-DDThh:mm:ss_offsetfromUTC
 ; UTC, Year, Month, Day, Hours, Minutes, Seconds, Time offset (obtained from Mailman Site Parameters)
 N UTC,Y,M,D,H,MM,S,OFF
 S Y=1700+$E(DATE,1,3)
 S M=$E(DATE,4,5)
 S D=$E(DATE,6,7)
 S H=$E(DATE,9,10)
 I $L(H)=1 S H="0"_H
 S MM=$E(DATE,11,12)
 I $L(MM)=1 S MM="0"_MM
 S S=$E(DATE,13,14)
 I $L(S)=1 S S="0"_S
 S OFF=$$TZ^XLFDT ; See Kernel Manual for documentation.
 S OFFS=$E(OFF,1,1)
 S OFF0=$TR(OFF,"+-")
 S OFF1=$E(OFF0+10000,2,3)
 S OFF2=$E(OFF0+10000,4,5)
 S OFF=OFFS_OFF1_OFF2
 S:'$L(H) H="00"
 S:'$L(MM) MM="00"
 S:'$L(S) S="00"
 S UTC=Y_M_D_H_MM_$S(S="":"00",1:S)_OFF ; Skip's code to fix hanging colon if no seconds
 ;S UTC=Y_"-"_M_"-"_D_"T"_H_":"_MM_$S(S="":":00",1:":"_S)_OFF ; Skip's code to fix hanging colon if no seconds
 I $E(UTC,9,14)="000000" S UTC=$E(UTC,1,8) ; admit our precision gpl 9/2013
 S UTC=$E(UTC,1,8) ; admit our precision gpl 6/2014 only date no time
 I $L($G(FORMAT)),FORMAT="DT" Q UTC ; Date with time.
 E  Q $P(UTC,"T")
 ;
FMDTOUT2(DATE,FORMAT) ; Convert Fileman Date to UTC Date Format; PUBLIC; Extrinsic
 ; FORMAT is Format of Date. Can be either D (Day) or DT (Date and Time)
 ; If not passed, or passed incorrectly, it's assumed that it is D.
 ; FM Date format is "YYYMMDD.HHMMSS" HHMMSS may not be supplied.
 ; UTC date is formatted as follows: YYYY-MM-DDThh:mm:ss_offsetfromUTC
 ; UTC, Year, Month, Day, Hours, Minutes, Seconds, Time offset (obtained from Mailman Site Parameters)
 N UTC,Y,M,D,H,MM,S,OFF
 S Y=1700+$E(DATE,1,3)
 S M=$E(DATE,4,5)
 S D=$E(DATE,6,7)
 S H=$E(DATE,9,10)
 I $L(H)=1 S H="0"_H
 S MM=$E(DATE,11,12)
 I $L(MM)=1 S MM="0"_MM
 S S=$E(DATE,13,14)
 I $L(S)=1 S S="0"_S
 S OFF=$$TZ^XLFDT ; See Kernel Manual for documentation.
 S OFFS=$E(OFF,1,1)
 S OFF0=$TR(OFF,"+-")
 S OFF1=$E(OFF0+10000,2,3)
 S OFF2=$E(OFF0+10000,4,5)
 S OFF=OFFS_OFF1_OFF2
 ; If H, MM and S are empty, it means that the FM date didn't supply the time.
 ; In this case, set H, MM and S to "00"
 S:'$L(H) H="00"
 S:'$L(MM) MM="00"
 S:'$L(S) S="00"
 S UTC=Y_M_D_H_MM_$S(S="":"00",1:S)_OFF ; Skip's code to fix hanging colon if no seconds
 I $E(UTC,9,14)="000000" S UTC=$E(UTC,1,8) ; admit our precision gpl 9/2013
 I $L($G(FORMAT)),FORMAT="DT" Q UTC ; Date with time.
 E  Q $P(UTC,"T")
 ;
FMDTOUTC(DATE,FORMAT) ; Convert Fileman Date to UTC Date Format; PUBLIC; Extrinsic
 ; FORMAT is Format of Date. Can be either D (Day) or DT (Date and Time)
 ; If not passed, or passed incorrectly, it's assumed that it is D.
 ; FM Date format is "YYYMMDD.HHMMSS" HHMMSS may not be supplied.
 ; UTC date is formatted as follows: YYYY-MM-DDThh:mm:ss_offsetfromUTC
 ; UTC, Year, Month, Day, Hours, Minutes, Seconds, Time offset (obtained from Mailman Site Parameters)
 N UTC,Y,M,D,H,MM,S,OFF
 S Y=1700+$E(DATE,1,3)
 S M=$E(DATE,4,5)
 S D=$E(DATE,6,7)
 S H=$E(DATE,9,10)
 I $L(H)=1 S H="0"_H
 S MM=$E(DATE,11,12)
 I $L(MM)=1 S MM="0"_MM
 S S=$E(DATE,13,14)
 I $L(S)=1 S S="0"_S
 S OFF=$$TZ^XLFDT ; See Kernel Manual for documentation.
 S OFFS=$E(OFF,1,1)
 S OFF0=$TR(OFF,"+-")
 S OFF1=$E(OFF0+10000,2,3)
 S OFF2=$E(OFF0+10000,4,5)
 S OFF=OFFS_OFF1_":"_OFF2
 ; If H, MM and S are empty, it means that the FM date didn't supply the time.
 ; In this case, set H, MM and S to "00"
 S:'$L(H) H="00"
 S:'$L(MM) MM="00"
 S:'$L(S) S="00"
 S UTC=Y_"-"_M_"-"_D_"T"_H_":"_MM_$S(S="":":00",1:":"_S)_OFF ; Skip's code to fix hanging colon if no seconds
 I $L($G(FORMAT)),FORMAT="DT" Q UTC ; Date with time.
 E  Q $P(UTC,"T")
 ;
HTMLDT2(FMDT) ; extrinsic which produces mm/dd/yyyy no time from fileman date
 N TMP,TMP2
 S TMP=$$FMDTOCDA(FMDT)
 N M,D,Y
 S M=$E(TMP,5,6)
 S D=$E(TMP,7,8)
 S Y=$E(TMP,1,4)
 I +M=0 Q Y
 I +D=0 Q M_"/"_Y
 Q M_"/"_D_"/"_Y
 ;
HTMLDT(FMDT) ; extrinsic returns date format MM/DD/YYYY for display in html
 ;
 N TMP,TMP2
 S TMP=$$FMDTOUTC(FMDT)
 S TMP2=$E(TMP,5,6)_"/"_$E(TMP,7,8)_"/"_$E(TMP,1,4)
 I $E(TMP,9,14)'="000000" D  ;
 . I $L(TMP)=8 Q  ; no time
 . S TMP2=TMP2_" "_$E(TMP,9,10)_":"
 . S TMP2=TMP2_$E(TMP,11,12)_":"
 . S TMP2=TMP2_$E(TMP,13,19)
 Q TMP2
 ;
TESTDATE ; test the above transform
 N GT
 S GT=$$FMDTOUTC($$NOW^XLFDT,"DT")
 W !,GT
 Q
 ;
GENHTML(HOUT,HARY) ; generate an HTML table from array HARY
 ; HOUT AND HARY are passed by name
 ;
 ; format of the table:
 ;  HARY("TITLE")="Problem List"
 ;  HARY("HEADER",1)="column 1 header"
 ;  HARY("HEADER",2)="col 2 header"
 ;  HARY(1,1)="row 1 col1 value"
 ;  HARY(1,2)="row 1 col2 value"
 ;  HARY(1,2,"ID")="the ID of the element"
 ;  etc...
 ;
 N C0I,C0J
 D ADDTO(HOUT,"<div align=""center"">")
 D ADDTO(HOUT,"<text>")
 D ADDTO(HOUT,"<table border=""1"" style=""width:80%"">")
 I $D(@HARY@("TITLE")) D  ;
 . N X
 . S X="<caption><b>"_@HARY@("TITLE")_"</b></caption>"
 . D ADDTO(HOUT,X)
 I $D(@HARY@("HEADER")) D  ;
 . D ADDTO(HOUT,"<thead>")
 . D ADDTO(HOUT,"<tr>")
 . S C0I=0
 . F  S C0I=$O(@HARY@("HEADER",C0I)) Q:+C0I=0  D  ;
 . . D ADDTO(HOUT,"<th>"_@HARY@("HEADER",C0I)_"</th>")
 . D ADDTO(HOUT,"</tr>")
 . D ADDTO(HOUT,"</thead>")
 D ADDTO(HOUT,"<tbody>")
 I $D(@HARY@(1)) D  ;
 . S C0I=0 S C0J=0
 . F  S C0I=$O(@HARY@(C0I)) Q:+C0I=0  D  ;
 . . D ADDTO(HOUT,"<tr>")
 . . F  S C0J=$O(@HARY@(C0I,C0J)) Q:+C0J=0  D  ;
 . . . N UID S UID=$G(@HARY@(C0I,C0J,"ID"))
 . . . I UID'="" D ADDTO(HOUT,"<td style=""padding:5px;"" ID="""_UID_""">"_@HARY@(C0I,C0J)_"</td>")
 . . . E  D ADDTO(HOUT,"<td style=""padding:5px;"">"_@HARY@(C0I,C0J)_"</td>")
 . . D ADDTO(HOUT,"</tr>")
 D ADDTO(HOUT,"</tbody>")
 D ADDTO(HOUT,"</table>")
 D ADDTO(HOUT,"</text>")
 D ADDTO(HOUT,"</div>")
 Q
 ;
GENVHTML(HOUT,HARY) ; generate a vertical HTML table from array HARY
 ; headers are in the first row
 ; HOUT AND HARY are passed by name
 ;
 ; format of the table:
 ;  HARY("TITLE")="Problem List"
 ;  HARY("HEADER",1)="row 1 column 1 header"
 ;  HARY("HEADER",2)="row 2 col 2 header"
 ;  HARY(1,1)="row 1 col2 value"
 ;  HARY(2,1)="row 2 col2 value"
 ;  etc...
 ;
 N C0I,C0J
 D ADDTO(HOUT,"<div align=""center"">")
 D ADDTO(HOUT,"<text>")
 D ADDTO(HOUT,"<table border=""1"" style=""width:40%"">")
 I $D(@HARY@("TITLE")) D  ;
 . N X
 . S X="<caption><b>"_@HARY@("TITLE")_"</b></caption>"
 . D ADDTO(HOUT,X)
 I $D(@HARY@("HEADER")) D  ;
 . D ADDTO(HOUT,"<tr>")
 . S C0I=0
 . F  S C0I=$O(@HARY@("HEADER",C0I)) Q:+C0I=0  D  ;
 . . D ADDTO(HOUT,"<th style=""padding:5px;"">"_@HARY@("HEADER",C0I)_"</th>")
 . . D ADDTO(HOUT,"<td style=""padding:5px;"">"_@HARY@(C0I,1)_"</td>")
 . D ADDTO(HOUT,"</tr>")
 D ADDTO(HOUT,"</table>")
 D ADDTO(HOUT,"</text>")
 D ADDTO(HOUT,"</div>")
 Q
 ;
TSTYLE1 ; table style template
 ;;<style>
 ;;table, th, td
 ;;{
 ;;border-collapse:collapse;
 ;;border:1px solid black;
 ;;}
 ;;th, td
 ;;{
 ;;padding:5px;
 ;;}
 ;;</style>
 Q
 ;
TESTHTML ;
 N HTML
 S HTML("TITLE")="Problem List"
 S HTML("HEADER",1)="column 1 header"
 S HTML("HEADER",2)="col 2 header"
 S HTML(1,1)="row 1 col1 value"
 S HTML(1,2)="row 1 col2 value"
 N GHTML
 D GENHTML("GHTML","HTML")
 D ZWR^BIVWUTIL($NA(GHTML)) ; MSC/DKA
 Q
 ;
ADDTO(DEST,WHAT) ; adds string WHAT to list DEST
 ; DEST is passed by name
 N GN
 S GN=$O(@DEST@("AAAAAA"),-1)+1
 S @DEST@(GN)=WHAT
 S @DEST@(0)=GN ; count
 Q
 ;
TREE(WHERE,PREFIX,DOCID,ZOUT) ; show a tree starting at a node in MXML.
 ; node is passed by name
 ;
 I $G(PREFIX)="" S PREFIX="|--" ; starting prefix
 I '$D(KBAIJOB) S KBAIJOB=$J
 N NODE S NODE=$NA(^TMP("MXMLDOM",KBAIJOB,DOCID,WHERE))
 N TXT S TXT=$$CLEAN($$ALLTXT(NODE))
 W:'$G(DIQUIET) !,PREFIX_@NODE_" "_TXT
 D ONEOUT(ZOUT,PREFIX_@NODE_" "_TXT)
 N BIZI S BIZI=""
 F  S BIZI=$O(@NODE@("A",BIZI)) Q:BIZI=""  D  ;
 . W:'$G(DIQUIET) !,PREFIX_"  : "_BIZI_"^"_$G(@NODE@("A",BIZI))
 . D ONEOUT(ZOUT,PREFIX_"  : "_BIZI_"^"_$G(@NODE@("A",BIZI)))
 F  S BIZI=$O(@NODE@("C",BIZI)) Q:BIZI=""  D  ;
 . D TREE(BIZI,"|  "_PREFIX,DOCID,ZOUT)
 Q
 ;
ONEOUT(ZBUF,ZTXT) ; adds a line to zbuf
 N BIZI S BIZI=$O(@ZBUF@(""),-1)+1
 S @ZBUF@(BIZI)=ZTXT
 Q
 ;
ALLTXT(WHERE) ; extrinsic which returns all text lines from the node .. concatinated
 ; together
 N ZTI S ZTI=""
 N ZTR S ZTR=""
 F  S ZTI=$O(@WHERE@("T",ZTI)) Q:ZTI=""  D  ;
 . S ZTR=ZTR_$G(@WHERE@("T",ZTI))
 Q ZTR
 ;
CLEAN(STR) ; extrinsic function; returns string - gpl borrowed from the CCR package
 ;; Removes all non printable characters from a string.
 ;; STR by Value
 N TR,I
 F I=0:1:31 S TR=$G(TR)_$C(I)
 S TR=TR_$C(127)
 N BIZR S BIZR=$TR(STR,TR)
 S BIZR=$$LDBLNKS(BIZR) ; get rid of leading blanks
 QUIT BIZR
 ;
LDBLNKS(ST) ; extrinsic which removes leading blanks from a string
 N POS F POS=1:1:$L(ST)  Q:$E(ST,POS)'=" "
 Q $E(ST,POS,$L(ST))
 ;
SHOW(WHAT,DOCID,ZOUT) ;
 I '$D(C0XJOB) S C0XJOB=$J
 D TREE(WHAT,,DOCID,ZOUT)
 Q
 ;
LISTM(OUT,IN) ; out is passed by name in is passed by reference
 N I S I=$Q(@IN@(""))
 F  S I=$Q(@I) Q:I=""  D ONEOUT(OUT,I_"="_@I)
 Q
 ;
PEEL(OUT,IN) ; compress a complex global into something simpler
 NEW TSB
 N I S I=$Q(@IN@(""))
 S TCNT=0
 ;---> I is the next ARR1 node.
 F  S I=$Q(@I) Q:I=""  D  ;
 . S TCNT=$G(TCNT)+1
 . N J,K,L,M,N,M1,SUB
 . S (L,M)=""
 . ;---> TSB is the number of subscripts for this ARR1 node.
 . S TSB=$L(I,",")
 . ;W !!,"TSB:",TSB,!,"I: ",I,!,$P(I,",",TSB),!  ;MWRZZZ
 . S N=$$SHRINK($P($P(I,",",TSB),")"))
 . ;---> N is the last subscript of I.
 . S:TSB=1 N=$P(N,"(",2)
 . ;---> N is the last subscript stripped of ) and ".
 . S N=$TR(N,$C(34))
 . ;W !,"N: ",N  ;MWRZZZ
 . S K=$P(I,"(")_"("
 . F J=1:1:TSB-1  D
 . . NEW SUB
 . . I +$P(I,",",J)>0 D  ;
 . . . I M'="" Q
 . . . S M=$TR($P(I,",",J),$C(34))
 . . . S M1=J
 . . . I J>1 S L=$P(I,",",J-1)
 . . . E  S L=$P(I,",",J)
 . . . S L=$TR(L,$C(34))
 . . . ;W !,"FIRST L:",L  ;MWRZZZ
 . . . I L["substanceAdministration" S L=$P(L,"substanceAdministration",2)
 . . S SUB=$TR($P(I,",",J),$C(34)) S:J=1 SUB=$P(SUB,"(",2) S SUB=$C(34)_SUB_$C(34)
 . . S K=K_SUB_","
 . . W:$G(DEBUG) !,J," ",K
 . S LSUB=$TR($P($P(I,",",TSB),")"),$C(34)) S:TSB=1 LSUB=$P(LSUB,"(",2)
 . S K=K_$C(34)_LSUB_$C(34)_")"
 . W:$G(DEBUG) !,K,"=",@K
 . ;W !,"SECOND L:",L," ",M  ;MWRZZZ
 . I L'="" D  Q  ;
 . . D:$G(@OUT@(L,M,N))'=""
 . . . S N=$$MKXPATH(I,M1)
 . . . I $G(@OUT@(L,M,N))'="" D APPERROR^%ZTER("<DEBUG-PEEL-OUT>"),UNWIND^%ZTER ; MSC/DKA Avoid use of Break
 . . ;W !,L,M
 . . ;B  ;**********
 . . S @OUT@(L,M,N)=@K
 . I @K'="" D  ;
 . . I TSB>1 D  Q  ;
 . . . NEW LN
 . . . ;S L=$$SHRINK($QS(I,$QL(I)-1))
 . . . S LN=$P(I,",",(TSB-1)) S:((TSB-1)=1) LN=$P(LN,"(",2) S LN=$TR(LN,$C(34)),L=$$SHRINK(LN)
 . . . D:$G(@OUT@(L,N))'=""
 . . . . S N=$$SHRINK(LN)_"_"_N
 . . . ;B  ;**********
 . . . S @OUT@(L,N)=@K
 . . S @OUT@(N)=@K
 ;
 ;B
 ;
 Q
 ;
 ;
SHRINK(X) ; reduce strings
 N Y,Z
 S Y=X
 S Z="substanceAdministration"
 I X[Z S Y=$P(X,Z,2)
 Q Y
 ;
MKXPATH(ZQ,ZM) ; extrinsic which returns the xpath derived from the $query value
 ;passed by value. zm is the index to begin with
 ;
 NEW BIZR,BIZI,NL,SUB
 ;
 S BIZR=""
 S BIZI=""
 S NL=$L(ZQ,",")
 F BIZI=1:1:NL S SUB=$TR($P(ZQ,",",BIZI),$C(34)) S:BIZI=1 SUB=$P(SUB,"(",2) S:BIZI=NL SUB=$P(SUB,")") S BIZR=BIZR_"/"_SUB
 Q BIZR
 ;
ZWR(VAR) ; Write out variable passed by reference to avoid use of invalid ZWRITE command
 I $D(@VAR)#10 WRITE $NA(@VAR),"=",$G(@VAR),!
 N REF,REF0,REFLEN
 S (REF0,REF)=$NA(@VAR),REFLEN=$L(REF,",")
 F  S REF=$Q(@REF) Q:REF=""  Q:$NA(@REF,REFLEN)'=REF0  W REF,"=",@REF,!
 Q
