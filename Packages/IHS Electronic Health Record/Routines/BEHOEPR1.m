BEHOEPR1 ;GDIT/HS/TJB - EPCS Audit Summary Report;30-Nov-2018 08:04;PLS
 ;;1.1;BEH COMPONENTS;**070001,070003**;Mar 20, 2007;Build 10
 ;
 Q
EN(RNG) ;EP - EPCS Ad hoc Audit Summary Audit Report
 ;REP IS HANDLED BY REPORTS^ORDEA01
 N ABORT,STARTDT,ENDDT,SAVE,PRINT,NOCHK,X,Y S PRINT=1,ABORT=0,NOCHK=1,RNG=$S(+$G(RNG)>0:1,1:0)
 W !!,"Report is available in Roll and scroll only!",!
 W "The report can be exported to the HFS host system or mailed from MailMan. ",!
 W "A site has the ability to assign a user (i.e. security officer) to access",!
 W "the report.",!
 ;
 D DTRANGE^BEHOEPR2(.STARTDT,.ENDDT,.ABORT,RNG)
 Q:ABORT
 S SAVE=("DISINC")=""
 D DEVICE^ORUTL("INQ^BEHOEPR1","EPCS Audit Summary Report","Q",.SAVE)
 Q
 ;
 ; INSTART - Input start date in FileMan format
 ; INEND   - Input end date in FileMan format
 ; GLOBAL  - Variable passed to recieve global for report
INQ(INSTART,INEND,GLOBAL) ; EP - TASKMAN ENTRY POINT
 ; STARTDT and ENDDT need to be set for the report period.
 ;
 ;CBUFFER IS HANDLED BY DEVICE^ORUTL OR TASKMAN
 N DATA,ERROR,PGNUM,COL,STOP,COVERCOL,REC,SHD,SHD1,LN,TAG,LNUM,P7,P8,TYP,RES
 N ACTION,TITLE,NOW,I,INIT,J,DATA0,DATA2,RESULT,X,KEY,GBL,RCNT,AENDT,ASTDT,BUSAR
 S TITLE="EPCS Audit Summary Report",LNUM=0
 I $G(INSTART)]"" S STARTDT=INSTART
 I $G(INEND)]"" S ENDDT=INEND
 S AENDT=ENDDT+.9,ASTDT=STARTDT-.01,INIT=STARTDT-.01
 ; Run compilation for items if this is kicked off from taskman if from ad hoc NOCHK=1
 I +$G(NOCHK)=0 D COMPILE^BEHOEPR2
 ; Get IENs for the Security keys
 S KEY(1)=$$FIND1^DIC(19.1,,,"XUZEPCSVERIFY")
 S KEY(2)=$$FIND1^DIC(19.1,,,"XUEPCSEDIT")
 ; Find Users with the security keys and if they are in the report range
 D GETU^BEHOEPR2(STARTDT,ENDDT,KEY(1),"XUZEPCSVERIFY","RESULT")
 D GETU^BEHOEPR2(STARTDT,ENDDT,KEY(2),"XUEPCSEDIT","RESULT")
 ; Work through the BUSA Audit logs
 S RCNT=0
 F  S INIT=$O(^BUSAS("B",INIT)) Q:(INIT>AENDT)!(INIT="")  D
 . S REC="" F  S REC=$O(^BUSAS("B",INIT,REC)) Q:REC=""  D
 . . S DATA=$G(^BUSAS(REC,1)),RCNT=RCNT+1
 . . ;GDIT/HS/BEE 04192021;Remediation handling;Allow for specific EPCS record type mediation
 . . I $P(DATA,"|",7)]"",$S($L($T(CHECK^BUSAAPIR)):$$CHECK^BUSAAPIR($P(DATA,"|",7),REC,.BUSAR),1:"0") Q
 . . ;
 . . Q:$P($P(DATA,"|",6),"~",2)'["E"  ; Ignore non-EPCS records
 . . S DATA0=$G(^BUSAS(REC,0)),DATA2=$G(^BUSAS(REC,2)) ; Pick up the 0 and 2 nodes
 . . ;GDIT/HS/BEE 04192021;Remediation handling
 . . ;D CKHASH^BEHOEPR2(DATA0,DATA,DATA2,"RESULT") ; Check hash for this entry
 . . D CKHASH^BEHOEPR2(DATA0,DATA,DATA2,"RESULT",REC,.BUSAR) ; Check hash for this entry
 . . S P7=","_$P(DATA,"|",7)_",",P8=$P(DATA,"|",8),TYP=$P($P(DATA,"|",2),"~",2),RES=$P($P(DATA,"|",3),"~",2)
 . . I TYP="L" D  Q  ; Count login events
 . . . S RESULT("L")=$G(RESULT("L"))+1
 . . . S RESULT("L",RES)=$G(RESULT("L",RES))+1 ; Success/Failures
 . . . Q
 . . I TYP="K" D EPK^BEHOEPR2(P7,P8,RES,DATA0,DATA,"RESULT") Q  ; Count Key "K" credential events for this report period
 . . I TYP="S" D  Q  ; Count system events
 . . . I ",EPCS01,EPCS02,"[P7 D  Q  ; Count the time check events
 . . . . S RESULT("EST","T")=$G(RESULT("EST","T"))+1,RESULT("EST","LE")=$P(DATA,"|",1)
 . . . . S RESULT("EST",RES)=$G(RESULT("EST",RES))+1
 . . . . ;GDIT/HS/BEE 04192021;Remediation handling
 . . . . ;D CHKNTP^BEHOEPR2($P(DATA,"|",1),P8,"RESULT")
 . . . . D CHKNTP^BEHOEPR2($P(DATA,"|",1),P8,"RESULT",REC,.BUSAR)
 . . . . Q
 . . . I ",EPCS13,EPCS18,"[P7 D  Q  ; Count the Certificate check events
 . . . . S RESULT("ESC")=$G(RESULT("ESC"))+1,RESULT("ESC","LE")=$P(DATA,"|",1)
 . . . . I P7=",EPCS18," S RESULT("ESC","V")=$G(RESULT("ESC","V"))+1 Q
 . . . . I P7=",EPCS13," S RESULT("ESC","U")=$G(RESULT("ESC","U"))+1 Q
 . . . . Q
 . . . I ",EPCS51,EPCS52,EPCS53,EPCS54,EPCS64,EPCS65,"[P7 D  Q  ; Count Multifactor Authentication events
 . . . . S RESULT("MFA")=$G(RESULT("MFA"))+1,RESULT("MFA","LE")=$P(DATA,"|",1)
 . . . . S:RES]"" RESULT("MFA",RES)=$G(RESULT("MFA",RES))+1 ; Success/Failure
 . . . . I ",EPCS52,"=P7 S:RES]"" RESULT("OT",RES)=$G(RESULT("OT",RES))+1 ; Success/Failure
 . . . . I ",EPCS54,"=P7 S:RES]"" RESULT("AU",RES)=$G(RESULT("AU",RES))+1 ; Success/Failure
 . . . . I ",EPCS65,"=P7 S:RES]"" RESULT("CD",RES)=$G(RESULT("CD",RES))+1 ; Success/Failure
 . . . . Q
 . . . ; Other unaccounted system checks
 . . . S RESULT("S")=$G(RESULT("S"))+1,RESULT("S","LE")=$P(DATA0,U,1)_";;"_$P(DATA,"|",1)
 . . . S:RES]"" RESULT("S",RES)=$G(RESULT("S",RES))+1 ; Failures/Successes
 . . . Q
 . . I TYP="G" D GEN^BEHOEPR2(P7,P8,RES,DATA0,DATA,"RESULT") Q  ; Count General calculated events
 . . I TYP="O" D  Q  ; Count "Option" events for this report period
 . . . S RESULT("O")=$G(RESULT("O"))+1,RESULT("O","LE")=$P(DATA,"|",1) ; Number of events and last event
 . . . S:RES]"" RESULT("O",RES)=$G(RESULT("O",RES))+1 ; Successes/Failures
 . . . I $P(DATA,"|",5)="IHS CS AUDIT LOG" D  Q
 . . . . S RESULT("SIO")=$G(RESULT("SIO"))+1 ; Count CS AUDIT LOG
 . . . . S:RES]"" RESULT("SIO",RES)=$G(RESULT("SIO",RES))+1 ; Successes/Failures
 . . . . Q
 . . . Q
 . . I TYP="P" D  Q  ; Count Pharmacy events
 . . . S RESULT("EPP")=$G(RESULT("EPP"))+1 S:RES'="" RESULT("EPP",RES)=$G(RESULT("EPP",RES))+1
 . . . I ",EPCS76,"[P7 S RESULT("EPX","F")=$G(RESULT("EPX","F"))+1 Q  ; Failed Events
 . . . I ",EPCS78,"[P7 S RESULT("EPX","ED")=$G(RESULT("EPX","ED"))+1 ; Edits & edits don't add to the provider count
 . . . Q
 . . I TYP="PP" D PPX^BEHOEPR2(P7,P8,RES,DATA0,DATA,"RESULT") Q  ; Count Provider Profile events
 . . I TYP="X" D PRX^BEHOEPR2(P7,P8,RES,DATA0,DATA,"RESULT") Q  ; Count Prescribing events
 . . I TYP'="" D  Q
 . . . S RESULT(TYP)=$G(RESULT(TYP))+1,RESULT(TYP,"LE")=$P(DATA,"|",1)
 . . . S:RES]"" RESULT(TYP,RES)=$G(RESULT(TYP,RES))+1
 . . Q
 . Q
 ;
 ; Walk the BUSA logs looking for missing IENs
 N ZIEN
 S INIT=$O(^BUSAS("B",ASTDT)) I $D(^BUSAS("B",INIT))>0 S ZIEN="",ZIEN=$O(^BUSAS("B",INIT,ZIEN))
 I ZIEN]"" D
 . N XIEN,LIEN,Z0,X0,A0
 . S XIEN=ZIEN,A0=0,LIEN=$P(^BUSAS(0),U,3),X0=$P(^BUSAS(ZIEN,0),U,1)
 . F  S XIEN=XIEN+1,Z0=$G(^BUSAS(XIEN,0)) Q:XIEN'<LIEN  D  Q:A0=1
 . . S RESULT("BUSAS","TOTAL")=$G(RESULT("BUSAS","TOTAL"))+1
 . . ;GDIT/HS/BEE 04192021;Remediation handling
 . . ;I Z0="" S RESULT("BUSAS","MISS")=$G(RESULT("BUSAS","MISS"))+1,RESULT("BUSAS","MISS",XIEN)=X0 Q
 . . I Z0="",'$S($L($T(CHECK^BUSAAPIR)):$$CHECK^BUSAAPIR("BUSAS Entry - Missing",XIEN,.BUSAR),1:"0") S RESULT("BUSAS","MISS")=$G(RESULT("BUSAS","MISS"))+1,RESULT("BUSAS","MISS",XIEN)=X0 Q
 . . I ($P(Z0,U,1)>AENDT) S A0=1
 . . S X0=$P(Z0,U,1) ; Set the last date time if we have a miss
 . . Q
 . Q
 ;
 ; Check the RESULT Array to see if there are any thresholds tripped
 D TRIP^BEHOEPR4("RESULT",ENDDT)
 ;
 ; Collect Report into ^TMP global
 K ^TMP("BEHOEPR1",$J) S GBL=$NA(^TMP("BEHOEPR1",$J)) S:$D(GLOBAL) GLOBAL=$NA(^TMP("BEHOEPR1",$J))
 F TAG="EE","EC","ED","ES","EO","SI" D
 . S SHD=$TEXT(@TAG)
 . S LNUM=LNUM+1,@GBL@(LNUM)="     "_$P(SHD,";;",2),LNUM=LNUM+1,@GBL@(LNUM)=$$REPEAT^XLFSTR("=",50)
 . ; Walk the lines
 . F I=1:1 S LN=$TEXT(@TAG+I) Q:$P(LN,";;",2)=""  S LN=$P(LN,";;",2) D
 . . N TX,CD,N,HD,LN1,ZLN,X S X=""
 . . ; Kludge to take into account XINDEX line length limitation of less than 245 characters
 . . S ZLN=$TEXT(@TAG+(I+1)) I $P(ZLN,";;",2)="~~C" S LN=LN_U_$P(ZLN,";;",3),I=I+1
 . . F N=1:1 S TX=$P(LN,"^",N) Q:TX=""  D
 . . . I N=1 S HD=TX S LNUM=LNUM+1,@GBL@(LNUM)=TX Q
 . . . S LN1=$P(TX,"~",1),CD=$P(TX,"~",2) I CD'="" X CD
 . . . I (+X=X)!($L(X)<9) S LNUM=LNUM+1,@GBL@(LNUM)="    "_LN1_$E("                                    ",1,36-$L(LN1))_$JUSTIFY(X,10)
 . . . E  N SP S $P(SP," ",76)=" ",LNUM=LNUM+1,@GBL@(LNUM)="    "_LN1_$E(SP,1,$L(SP)-$L(LN1)-$L(X))_$JUSTIFY(X,$L(X))
 . . . ;I TAG="ED" W @GBL@(LNUM),"  ",CD,!
 . . . Q
 . . S LNUM=LNUM+1,@GBL@(LNUM)=$P(LN,";;",2)
 . . Q
 . Q
 ; If we have any thresholds tripped they will show here
 I $D(RESULT("THR"))>1 D
 . S TAG="TS"
 . S SHD=$TEXT(@TAG),SHD1=$TEXT(@TAG+1)
 . S LNUM=LNUM+1,@GBL@(LNUM)="     "_$P(SHD,";;",2),LNUM=LNUM+1,@GBL@(LNUM)=$$REPEAT^XLFSTR("=",50),LNUM=LNUM+1,@GBL@(LNUM)=$P(SHD1,";;",2),LNUM=LNUM+1,@GBL@(LNUM)=" "
 . ; Walk the RESULT("THR") array lines
 . S I="" F  S I=$O(RESULT("THR",I)) Q:I=""  D
 . . S J="" F  S J=$O(RESULT("THR",I,J)) Q:J=""  S LNUM=LNUM+1,@GBL@(LNUM)=RESULT("THR",I,J)
 . S LNUM=LNUM+1,@GBL@(LNUM)=" "
 . S LNUM=LNUM+1,@GBL@(LNUM)=$$REPEAT^XLFSTR("=",50)
 . S LNUM=LNUM+1,@GBL@(LNUM)="Please initiate appropriate incident response to look into identified issues."
 . Q
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
 . . . S STOP=$$HEADER^BEHOEP3(TITLE,.PGNUM,.COL,.COVERCOL)
 . . W @GBL@(I),!
 . Q
 ;
 Q
 ;
ROUND(VAL,SD) ; Round an integer
 Q:VAL'=+VAL!($G(SD)=0) VAL
 Q +$J(VAL,0,$S($D(SD):SD,VAL<1:2,VAL<10:2,1:2))
 ;
HEAD(PAGE) ;
 S NOW=$$UP^XLFSTR($$HTE^XLFDT($H)),NOW=$P(NOW,"@",1)_"  "_$P($P(NOW,"@",2),":",1,2)
 W $$LJ^XLFSTR($E(TITLE,1,46),47," ")_NOW_"   PAGE "_PAGE,!!
 Q
 ;
EE ;;EPCS ENABLED PROVIDER AUTHENTICATION
 ;;RPMS Login Attempts^Number of Failed Events~S X=+$G(RESULT("L","F"))^Total Logon Events~S X=+$G(RESULT("L"))^Ratio~S X=$S(+$G(RESULT("L"))>0:$$ROUND(((+$G(RESULT("L","F"))/RESULT("L"))*100),2),1:"-")
 ;;MFA Authentication Number Attempts^Number of Failed Events~S X=+$G(RESULT("MFA","F"))^Total Events~S X=+$G(RESULT("MFA"))^Ratio~S X=$S($G(RESULT("MFA"))>0:$$ROUND(((+$G(RESULT("MFA","F"))/RESULT("MFA"))*100),2),1:"-")
 ;;Electronic Signature Code^Number of Failed Events~S X=+$G(RESULT("CD","F"))
 ;;Token PIN^Number of Failed Events~S X=+$G(RESULT("OT","F"))
 ;;Unable to Complete Authentication^Number of Failed Events~S X=+$G(RESULT("AU","F"))
 ;;
EC ;; EPCS CREDENTIALING AND PROVISIONING
 ;;Number of EPCS Enabled Divisions^Total~S X=+$G(RESULT("ECD"))^Assigned~S X=+$G(RESULT("ECD","A"))^Removed~S X=+$G(RESULT("ECD","R"))
 ;;Number of EPCS Enabled Providers^Total~S X=+$G(RESULT("ECP"))^Assigned~S X=+$G(RESULT("ECP","A"))^Removed~S X=+$G(RESULT("ECP","R"))
 ;;Number of Credentials^Total~S X=+$G(RESULT("ECK","A"))+$G(RESULT("ECK","R"))^Assigned~S X=+$G(RESULT("ECK","A"))^Removed~S X=+$G(RESULT("ECK","R"))
 ;;Edit Provider Profile^Total~S X=+$G(RESULT("ECPP"))^Created~S X=+$G(RESULT("ECPP","C"))^Removed~S X=+$G(RESULT("ECPP","R"))^Failed~S X=+$G(RESULT("ECPP","F"))
 ;;Verify/Activate Provider Profile^Total~S X=+$G(RESULT("ECV"))^Assigned~S X=+$G(RESULT("ECV","A"))^Failed~S X=+$G(RESULT("ECV","F"))
 ;
ED ;; EPCS DIGITAL SIGNING CERTIFICATE
 ;;Number of Certificates^Total~S X=+$G(RESULT("EDC"))^Revoked~S X=+$G(RESULT("EDC","R"))
 ;;
 ;; Removed from ED when moving to new distributed 2FA
 ;;^Expired~S X=+$G(RESULT("EDC","E"))^Expire in 90 days~S X=+$G(RESULT("EDC","E9"))^Expire in 60 days~S X=+$G(RESULT("EDC","E6"))
 ;;~~C;;Expire in 30 days~S X=+$G(RESULT("EDC","E3"))
 ;;
ES ;; EPCS SYSTEM STATUS
 ;;Time Synchronization^Total Events~S X=+$G(RESULT("EST","T"))^Failed Checks~S X=+$G(RESULT("EST","F"))^Events Over 3 Minutes~S X=+$G(RESULT("EST","F3"))^Events Over 5 Minutes~S X=+$G(RESULT("EST","F5"))^Last Event~S X=$G(RESULT("EST","LE"))
 ;;EPCS Certificate Checks^Total Checks~S X=+$G(RESULT("ESC"))^Unsuccessful Checks~S X=+$G(RESULT("ESC","U"))
 ;;
EO ;; EPCS ORDERS
 ;;Prescribing Events^Number of EPCS Providers~S X=+$G(RESULT("EPX"))^Created~S X=+$G(RESULT("EPX","I"))^Edits~S X=+$G(RESULT("EPX","ED"))^Canceled~S X=+$G(RESULT("EPX","C"))
 ;;~~C;;Digitally Signed~S X=+$G(RESULT("EPX","D"))^Transmitted~S X=+$G(RESULT("EPX","TR"))^Failed Events~S X=+$G(RESULT("EPX","F"))
 ;;
SI ;; SYSTEM INTEGRITY
 ;;Provider Profile^Number of Records~S X=+$G(RESULT("SIP"))^Number of Mismatches~S X=+$G(RESULT("SIP","M"))^Number of Deletions~S X=+$G(RESULT("SIP","D"))^Number of Failed Checks~S X=+$G(RESULT("SIP","F"))
 ;;CS Order Integrity Check^Number of Records~S X=+$G(RESULT("SIO"))^Number of Mismatches~S X=+$G(RESULT("SIO","M"))^Number of Deletions~S X=+$G(RESULT("SIO","D"))^Number of Failed Checks~S X=+$G(RESULT("SIO","F"))
 ;;Audit Log^Number of Records~S X=+$G(RESULT("SIA"))^Number of Mismatches~S X=+$G(RESULT("SIA","M"))^Number of Deletions~S X=+$G(RESULT("SIA","D"))^Number of Failed Checks~S X=+$G(RESULT("SIA","BUSA"))
 ;;Unaccounted System Type Events^Total Events~S X=+$G(RESULT("S"))^Successful Events~S X=+$G(RESULT("S","S"))^Failed Events~S X=+$G(RESULT("S","F"))^Last Event~S X=$G(RESULT("S","LE"))
 ;;
TS ;; THRESHOLD SUMMARY
 ;;Please initiate appropriate incident response to look into identified issues.
 ;;
 Q
 ;
