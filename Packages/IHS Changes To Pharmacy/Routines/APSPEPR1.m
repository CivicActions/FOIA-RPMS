APSPEPR1 ;GDIT/HS/TJB - Pharmacy Audit Summary Report;15-Dec-2022 13:59;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1023,1028,1031,1032**;Sep 23, 2004;Build 26
 ;
 Q
 ;Entry point for the Roll and Scroll for the Pharmacy Report
EN(RNG) ;EP - Pharmacy Ad hoc Audit Summary Report
 ;REP IS HANDLED BY REPORTS^ORDEA01
 N STARTDT,ENDDT,SAVE,ABORT,PRINT,ASTDT,AENDT S PRINT=1,ABORT=0,RNG=$S(+$G(RNG)>0:1,1:0)
 W !!,"Report is available in Roll and scroll only!",!
 W "The report can be exported to the HFS host system or sent through MailMan. ",!
 W "A site has the ability to assign a user (i.e. security officer) to access",!
 W "the report.",!
 D DTRANGE^APSPEPR2(.STARTDT,.ENDDT,.ABORT,RNG)
 Q:ABORT
 ;
 S ASTDT=STARTDT,AENDT=ENDDT
 S SAVE=("DISINC")=""
 D DEVICE^ORUTL("INQ^APSPEPR1","Pharmacy Audit Summary Report","Q",.SAVE)
 ;D INQ
 Q
 ;
 ; INSTART - Input start date in FileMan format
 ; INEND   - Input end date in FileMan format
 ; GLOBAL  - Variable passed to recieve global for report, make sure GLOBAL is defined
INQ(INSTART,INEND,GLOBAL) ; EP - TASKMAN ENTRY POINT
 ;CBUFFER IS HANDLED BY DEVICE^ORUTL OR TASKMAN
 N DATA,ERROR,INDEX,PGNUM,COL,STOP,COVERCOL,ASTDT,AENDT,LNUM,GBL,RCNT,P7,P8,TYP,RES
 N ACTION,TITLE,NOW,I,J,KEY,TAG,SHD,SHD1,LN,RESULT,REC,INIT,D0,D2,XX,BUSAR
 S TITLE="Pharmacy Audit Summary Report",LNUM=0
 I $G(INSTART)]"" S STARTDT=INSTART
 I $G(INEND)]"" S ENDDT=INEND
 S AENDT=ENDDT+.9,ASTDT=STARTDT-.01
 S INIT=STARTDT-.01
 ; Get IENs for the Security keys
 S KEY(1)=$$FIND1^DIC(19.1,,,"XUZEPCSVERIFY")
 S KEY(2)=$$FIND1^DIC(19.1,,,"XUEPCSEDIT")
 ; Find Users with the security keys and if they are in the report range
 D GETU^APSPEPR2(STARTDT,ENDDT,KEY(1),"XUZEPCSVERIFY","RESULT")
 D GETU^APSPEPR2(STARTDT,ENDDT,KEY(2),"XUEPCSEDIT","RESULT")
 ; Work through the BUSA Audit logs
 F  S INIT=$O(^BUSAS("B",INIT)) Q:(INIT>AENDT)!(INIT="")  D
 . S REC="" F  S REC=$O(^BUSAS("B",INIT,REC)) Q:REC=""  D
 . . S DATA=$G(^BUSAS(REC,1))
 . . ;GDIT/HS/BEE 08012022;FEATURE#84723;Remediation handling;Allow for specific EPCS record type mediation
 . . I $P(DATA,"|",7)]"",$S($L($T(CHECK^BUSAAPIR)):$$CHECK^BUSAAPIR($P(DATA,"|",7),REC,.BUSAR),1:"0") Q
 . . ;
 . . Q:$P($P(DATA,"|",6),"~",2)'["P"  ; Ignore non-pharmacy records
 . . S D0=$G(^BUSAS(REC,0)),D2=$G(^BUSAS(REC,2)) ; Now pick up the 0 and 2 node
 . . S P7=","_$P(DATA,"|",7)_",",P8=$P(DATA,"|",8),TYP=$P($P(DATA,"|",2),"~",2),RES=$P($P(DATA,"|",3),"~",2)
 . . ;GDIT/HS/BEE 08012022;FEATURE#84723;Remediation handling;Allow for specific EPCS record type mediation
 . . ;D CKHASH^APSPEPR2(D0,DATA,D2,"RESULT") ; Check hash for this entry
 . . D CKHASH^APSPEPR2(D0,DATA,D2,"RESULT",REC,.BUSAR) ; Check hash for this entry
 . . I TYP="L" D  Q  ; Login/logout events
 . . . S RESULT("L")=$G(RESULT("L"))+1
 . . . S:RES]"" RESULT("L",RES)=$G(RESULT("L",RES))+1
 . . . Q
 . . I TYP="K" D  Q  ; Count Key "K" credential events for this report period
 . . . Q:",EPCS130,EPCS131,EPCS132,EPCS133,EPCS134,EPCS135,EPCS136,EPCS137,"'[P7
 . . . S RESULT("PPK")=$G(RESULT("PPK"))+1,RESULT("PPK","LE")=$P(DATA,"|",1) ; Number of Key events and last event
 . . . I ",EPCS130,EPCS131,EPCS132,EPCS133,"[P7 D  Q  ; Count Key allocated/delegated events
 . . . . S RESULT("ECP","A")=+$G(RESULT("ECP","A"))+1
 . . . . I P8="" Q  ; Issue because P8 should be the provider IEN
 . . . . I $G(RESULT("ECP","A1",P8))="" S RESULT("ECP","A1")=$G(RESULT("ECP","A1"))+1 ; Count if new provider
 . . . . S RESULT("ECP","A1",P8)=$G(RESULT("ECP","A1",P8))+1
 . . . . Q
 . . . I ",EPCS134,EPCS135,EPCS136,EPCS137,"[P7 D  Q  ; Count Key deallocated/removed events
 . . . . S RESULT("ECP","R")=+$G(RESULT("ECP","R"))+1
 . . . . I P8="" Q  ; Issue because P8 should be the provider IEN
 . . . . I $G(RESULT("ECP","R1",P8))="" S RESULT("ECP","R1")=$G(RESULT("ECP","R1"))+1 ; Count if new provider
 . . . . S RESULT("ECP","R1",P8)=$G(RESULT("ECP","R1",P8))+1
 . . . . Q
 . . . I RES]"" S RESULT("PPK",RES)=$G(RESULT("PPK",RES))+1,RESULT("PPK",RES,"LE")=$P(D0,U,1)_";;"_$P(DATA,U,1) ; Will be an "S" or "F" and last event
 . . . Q
 . . I TYP="G" D  Q  ; Count General calculated events
 . . . I P7=",EPCS164," S RESULT("ECP")=$S($G(P8)'="":+$G(P8),1:0) Q  ; Count of EPCS enabled Pharmacists
 . . . I P7=",EPCS100," S RESULT("GST","EPCS100")=$P(D0,U,1),RESULT("SIA","F")=$G(RESULT("SIA","F"))+1 Q  ; Start of nightly report need EPCS101 to complete
 . . . I P7=",EPCS101," S RESULT("GST","EPCS101")=$P(D0,U,1),RESULT("SIA","F")=$G(RESULT("SIA","F"))-1 Q  ; End of nightly report
 . . . I P7=",EPCS106," S RESULT("GST","EPCS106")=$P(D0,U,1),RESULT("PAF","F")=$G(RESULT("PAF","F"))+1 Q  ; Start of Pharmacy Order need EPCS107 to complete
 . . . I P7=",EPCS107," S RESULT("GST","EPCS107")=$P(D0,U,1),RESULT("PAF","F")=$G(RESULT("PAF","F"))-1 Q  ; End of nightly report
 . . . I P7=",EPCS108," S RESULT("GST","EPCS108")=$P(D0,U,1) Q  ; Start of BUSAS compile need EPCS109 to complete
 . . . I P7=",EPCS109," S RESULT("GST","EPCS109")=$P(D0,U,1) Q  ; End of nightly report
 . . . S RESULT("GEN")=$G(RESULT("GEN"))+1,RESULT("GEN","LE")=$P(D0,U,1)_";;"_$P(DATA,"|",1)_";;"_P7 S:$G(RES)'="" RESULT("GEN",RES)=$G(RESULT("GEN",RES))+1
 . . . Q
 . . I TYP="M" D  Q  ; Count Menu events
 . . . S RESULT("PPM")=$G(RESULT("PPM"))+1,RESULT("PPM","LE")=$P(DATA,"|",1)
 . . . S:RES]"" RESULT("PPM",RES)=$G(RESULT("PPM",RES))+1 ; Failures
 . . . S:$P(DATA,"|",1)["XU: Assigned" RESULT("PPM","S","A")=$G(RESULT("PPM","S","A"))+1 ; Successes assigned menu
 . . . S:$P(DATA,"|",1)["XU: Removed" RESULT("PPM","S","R")=$G(RESULT("PPM","S","R"))+1 ; Successes removed menu
 . . . Q
 . . I TYP="P" D PRX^APSPEPR2(P7,P8,RES,D0,DATA,"RESULT")  Q  ; Count Pharmacy events
 . . I TYP="S" D  Q  ; Count system events
 . . . I ",EPCS01,EPCS02,"[P7 D  Q  ; Count the time check events
 . . . . S RESULT("EST","T")=$G(RESULT("EST","T"))+1,RESULT("EST","LE")=$P(DATA,"|",1)
 . . . . S RESULT("EST",RES)=$G(RESULT("EST",RES))+1
 . . . . ;GDIT/HS/BEE 12062022;FEATURE#88916;Remediation handling
 . . . . ;D CHKNTP^BEHOEPR2($P(DATA,"|",1),P8,"RESULT")
 . . . . D CHKNTP^APSPEPR2($P(DATA,"|",1),P8,"RESULT",REC,.BUSAR)
 . . . . Q
 . . . I ",EPCS20,EPCS21,EPCS23,EPCS24,EPCS25,EPCS26,"[P7 D  Q  ; Count Digital Signing Certificate checks
 . . . . I P8="" Q  ; Problem, there should be a certificate
 . . . . S:'$D(RESULT("EDC","COUNT",P8)) RESULT("EDC")=$G(RESULT("EDC"))+1,RESULT("EDC","COUNT",P8)=$G(RESULT("EDC","COUNT",P8))+1
 . . . . I (P7=",EPCS21,") D  Q  ; Revoked Certs
 . . . . . I (+$G(RESULT("EDC","R",P8))=0) S RESULT("EDC","R")=$G(RESULT("EDC","R"))+1,RESULT("EDC","R",P8)=$G(RESULT("EDC","R",P8))+1 Q
 . . . . . S RESULT("EDC","R",P8)=$G(RESULT("EDC","R",P8))+1
 . . . . . Q
 . . . . I (P7=",EPCS26,") D  Q  ; Expired Certs
 . . . . . I (+$G(RESULT("EDC","E",P8))=0) S RESULT("EDC","E")=$G(RESULT("EDC","E"))+1,RESULT("EDC","E",P8)=$G(RESULT("EDC","E",P8))+1 Q
 . . . . . S RESULT("EDC","E",P8)=$G(RESULT("EDC","E",P8))+1
 . . . . . Q
 . . . . I (P7=",EPCS23,") D  Q  ; Expire in 90 days
 . . . . . I (+$G(RESULT("EDC","E9",P8))=0) S RESULT("EDC","E9")=$G(RESULT("EDC","E9"))+1,RESULT("EDC","E9",P8)=$G(RESULT("EDC","E9",P8))+1 Q
 . . . . . S RESULT("EDC","E9",P8)=$G(RESULT("EDC","E9",P8))+1
 . . . . . Q
 . . . . I (P7=",EPCS24,") D  Q  ; Expire in 60 days
 . . . . . I (+$G(RESULT("EDC","E6",P8))=0) S RESULT("EDC","E6")=$G(RESULT("EDC","E6"))+1,RESULT("EDC","E6",P8)=$G(RESULT("EDC","E6",P8))+1 Q
 . . . . . S RESULT("EDC","E6",P8)=$G(RESULT("EDC","E6",P8))+1
 . . . . . Q
 . . . . I (P7=",EPCS25,") D  Q  ; Expire in 30 days
 . . . . . I (+$G(RESULT("EDC","E3",P8))=0) S RESULT("EDC","E3")=$G(RESULT("EDC","E3"))+1,RESULT("EDC","E3",P8)=$G(RESULT("EDC","E3",P8))+1 Q
 . . . . . S RESULT("EDC","E3",P8)=$G(RESULT("EDC","E3",P8))+1
 . . . . . Q
 . . . . Q
 . . . I ",EPCS22,EPCS27,"[P7 D  Q  ; Count the Pharmacy Certificate check events
 . . . . S RESULT("PCC")=$G(RESULT("PCC"))+1,RESULT("PCC","LE")=$P(DATA,"|",1)
 . . . . S:P7=",EPCS22," RESULT("PCC","F")=$G(RESULT("PCC","F"))+1
 . . . . Q
 . . . ; Other unaccounted system checks
 . . . S RESULT("S")=$G(RESULT("S"))+1,RESULT("S","LE")=$P(D0,U,1)_";;"_$P(DATA,"|",1)
 . . . S:RES]"" RESULT("S",RES)=$G(RESULT("S",RES))+1 ; Successes/Failures
 . . . Q
 . . I TYP="X" D  Q  ; Count Prescribing events
 . . . S RESULT("EPX")=$G(RESULT("EPX"))+1
 . . . I ",EPCS96,EPCS97,"[P7 D  Q  ; Count paper prescribing events
 . . . . S RESULT("E")=$G(RESULT("E"))+1 ; Total Count for paper
 . . . . S:RES]"" RESULT("E",RES)=$G(RESULT("E",RES))+1 ; Success(S)/Failures(F)
 . . . . Q
 . . . I RES]"" S RESULT("EPX",RES)=$G(RESULT("EPX",RES))+1 ; Success/Failures
 . . . I $E($P(DATA,"|",1),1,17)="DIGITALLY SIGNED " S RESULT("EPX","S","T")=$G(RESULT("EPX","S","T"))+1 Q  ; Signed event
 . . . I $E($P(DATA,"|",1),1,7)="CREATE " S RESULT("EPX","S","C")=$G(RESULT("EPX","S","C"))+1,RESULT("EPX","S","C","LE")=$P(DATA,"|",1) Q  ; Create event
 . . . I $E($P(DATA,"|",1),1,14)="CHANGE STATUS " S RESULT("EPX","S","CH")=$G(RESULT("EPX","S","CH"))+1,RESULT("EPX","S","CH","LE")=$P(DATA,"|",1) Q  ; Create event
 . . . I $E($P(DATA,"|",1),1,16)="TRANSMITTED OUT " S RESULT("EPX","S","TR")=$G(RESULT("EPX","S","TR"))+1,RESULT("EPX","S","TR","LE")=$P(DATA,"|",1) Q  ; Transmitted event
 . . . S RESULT("EPX","S","O")=$G(RESULT("EPX","S","O"))+1,RESULT("EPX","S","O","LE")=$P(DATA,"|",1) ; Other Prescribing Event
 . . . ;W $P(D0,U,1)_" ;; "_DATA,!
 . . . Q
 . . I TYP'="" D  Q  ; Log any Type events not accounted for above
 . . . S RESULT(TYP)=$G(RESULT(TYP))+1,RESULT(TYP,"LE")=$P(D0,U,1)_";;"_$P(DATA,"|",1)
 . . . S:RES]"" RESULT(TYP,RES)=$G(RESULT(TYP,RES))+1
 . . . ; W DATA,! ; This is to see any accounted BUSA logged events for Pharmacy
 . . Q
 . Q
 ;
 ; Check the RESULT Array to see if there are any thresholds tripped
 D TRIP^APSPEPR3("RESULT",ENDDT)
 ;
 ; Collect Report into ^TMP global
 K ^TMP("APSPEPR1",$J) S GBL=$NA(^TMP("APSPEPR1",$J)) S:$D(GLOBAL) GLOBAL=$NA(^TMP("APSPEPR1",$J))
 F TAG="PE","PP","PS","OH","SI" D
 . S SHD=$TEXT(@(TAG_"^APSPEPR2"))
 . S LNUM=LNUM+1,@GBL@(LNUM)="     "_$P(SHD,";;",2),LNUM=LNUM+1,@GBL@(LNUM)=$$REPEAT^XLFSTR("=",50)
 . ; Walk the lines
 . S I=0
 . F  S I=I+1,LN=$TEXT(@(TAG_"+"_I_"^APSPEPR2")) Q:$P(LN,";;",2)=""  S LN=$P(LN,";;",2) D
 . . N TX,CD,N,HD,LN1,ZLN,X S X=""
 . . ; Kludge to take into account XINDEX line length limitation of less than 245 characters
 . . S ZLN=$TEXT(@(TAG_"+"_(I+1)_"^APSPEPR2")) I $P(ZLN,";;",2)="~~C" S LN=LN_U_$P(ZLN,";;",3),I=I+1
 . . F N=1:1 S TX=$P(LN,"^",N) Q:TX=""  D
 . . . I N=1 S HD=TX,LNUM=LNUM+1,@GBL@(LNUM)=TX Q
 . . . S LN1=$P(TX,"~",1),CD=$P(TX,"~",2) I CD'="" X CD
 . . . I (+X=X)!($L(X)<9) S LNUM=LNUM+1,@GBL@(LNUM)="    "_LN1_$E("                                    ",1,36-$L(LN1))_$JUSTIFY(X,10)
 . . . E  N SP S $P(SP," ",76)=" ",LNUM=LNUM+1,@GBL@(LNUM)="    "_LN1_$E(SP,1,$L(SP)-$L(LN1)-$L(X))_$JUSTIFY(X,$L(X))
 . . . Q
 . . S LNUM=LNUM+1,@GBL@(LNUM)=$P(LN,";;",2)
 . . Q
 . Q
 ; If we have any thresholds tripped they will show here
 I $D(RESULT("THR"))>1 D
 . S TAG="TS"
 . S SHD=$TEXT(@(TAG_"^APSPEPR2")),SHD1=$TEXT(@(TAG_"+1^APSPEPR2"))
 . S LNUM=LNUM+1,@GBL@(LNUM)="     "_$P(SHD,";;",2),LNUM=LNUM+1,@GBL@(LNUM)=$$REPEAT^XLFSTR("=",50),LNUM=LNUM+1,@GBL@(LNUM)=$P(SHD1,";;",2),LNUM=LNUM+1,@GBL@(LNUM)=" "
 . ; Walk the RESULT("THR") array lines
 . S I="" F  S I=$O(RESULT("THR",I)) Q:I=""  D
 . . S J="" F  S J=$O(RESULT("THR",I,J)) Q:J=""  S LNUM=LNUM+1,@GBL@(LNUM)=RESULT("THR",I,J)
 . S LNUM=LNUM+1,@GBL@(LNUM)=" "
 . S LNUM=LNUM+1,@GBL@(LNUM)=$$REPEAT^XLFSTR("=",50)
 . S LNUM=LNUM+1,@GBL@(LNUM)="Please initiate appropriate incident response to look into identified issues."
 . Q
 ;
 ; If we have any missing IENs report them here
 I +$G(RESULT("BUSAS","MISS"))>0 D
 . N LAST S LAST=""
 . S LNUM=LNUM+1,@GBL@(LNUM)=" "
 . S LNUM=LNUM+1,@GBL@(LNUM)="*** Missing IENs identified in ^BUSAS log files. This could indicate an attempt",LNUM=LNUM+1,@GBL@(LNUM)="***  to compromise audit logging, please investigate."
 . S LNUM=LNUM+1,@GBL@(LNUM)="         Total IENs for reporting period: "_$JUSTIFY(RESULT("BUSAS","TOTAL"),10)
 . S LNUM=LNUM+1,@GBL@(LNUM)="       Missing IENs for reporting period: "_$JUSTIFY(RESULT("BUSAS","MISS"),10)
 . S LNUM=LNUM+1,@GBL@(LNUM)=" "
 . S LAST=$O(RESULT("BUSAS","MISS",LAST),-1)
 . S LNUM=LNUM+1,@GBL@(LNUM)="       Last Missing IEN: "_LAST_"  Date Before missing IEN: "_RESULT("BUSAS","MISS",LAST)
 . Q
 ;
 ; Print out the text if needed
 I $G(PRINT)=1 S $Y=0 W @IOF D
 . S PGNUM=0
 . S COL(1)=" "
 . S COL(2)="Report Date Range: "_$$FMTE^XLFDT(STARTDT,5)_" through "_$$FMTE^XLFDT(ENDDT,5)
 . S COVERCOL(1)=" "
 . S COVERCOL(2)="Report Date Range: "_$$FMTE^XLFDT(STARTDT,5)_" through "_$$FMTE^XLFDT(ENDDT,5)
 . S I=0
 . F  S I=$O(@GBL@(I)) Q:I=""  D  Q:$G(STOP)
 . . I ($Y+4)>IOSL!($Y=0) D  Q:$G(STOP)
 . . . S STOP=$$HEADER(TITLE,.PGNUM,.COL,.COVERCOL)
 . . W @GBL@(I),!
 . Q
 ;
 Q
 ;
ROUND(VAL,SD) ; Round an integer
 Q:VAL'=+VAL!($G(SD)=0) VAL
 Q +$J(VAL,0,$S($D(SD):SD,VAL<1:2,VAL<10:2,1:2))
 ;
HEADER(TITLE,PAGE,HEADER,HEADER2) ;EP - OUTPUT THE REPORT'S HEADER
 ;PARAMETERS: TITLE  => THE TITLE OF THE REPORT
 ;            PAGE   => (REFERENCE) PAGE NUMBER
 ;            HEADER => (REFERENCE) COLUMN NAMES, FORMATTED AS:
 ;                      COLUMN(LINE_NUMBER)=TEXT
 ;                      NOTE: LINE_NUMBER STARTS AT ONE
 ;RETURNS: 0 => USER WANTS TO CONTINUE PRINTING
 ;         1 => USER DOES NOT WANT TO CONTINUE PRINTING
 I $D(ZTQUEUED),($$S^%ZTLOAD) D  Q 1
 .S ZTSTOP=$$S^%ZTLOAD("Received stop request"),ZTSTOP=1
 N X,END,DIR,DUOUT
 S PAGE=+$G(PAGE)+1
 I PAGE>1 D  Q:$G(END) 1
 . S DIR(0)="FO",DIR("A")="Press Return to continue or '^' to exit"
 . D ^DIR I $D(DUOUT) S END=1 Q
 . W @IOF
 N NOW,INDEX
 S NOW=$$UP^XLFSTR($$HTE^XLFDT($H)),NOW=$P(NOW,"@",1)_"  "_$P($P(NOW,"@",2),":",1,2)
 W $$LJ^XLFSTR($E(TITLE,1,46),47," ")_NOW_"   PAGE "_PAGE,!
 I $G(PAGE)'=1 S INDEX=0 F  S INDEX=$O(HEADER(INDEX)) Q:'INDEX  W HEADER(INDEX),!
 I $G(PAGE)=1 S INDEX=0 F  S INDEX=$O(HEADER2(INDEX)) Q:'INDEX  W HEADER2(INDEX),!
 W $$REPEAT^XLFSTR("-",(IOM-1)),!
 Q 0
