APSPEPR2 ;GDIT/HS/TJB - Pharmacy Audit Summary Report;15-Dec-2022 13:59;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1023,1028,1031,1032**;Sep 23, 2004;Build 26
 ;
 ; Utility items moved here to reduce the size of the routine
 Q
 ;
 ;GDIT/HS/BEE 08012022;FEATURE#84723;Remediation handling;Allow for specific EPCS record type mediation
 ;CKHASH(Z0,Z1,Z2,MSG) ;
CKHASH(Z0,Z1,Z2,MSG,REC,BUSAR) ;
 N ZTIME,USER,TYPE,ACTION,CAT,CALL,DESC,NH,OH
 ;I $G(Z2)="" W !,"ERROR-- No HASH:",Z0,!,"     ",Z1
 S ZTIME=$P(Z0,U,1),USER=$P(Z0,U,2)
 S TYPE=$P(Z0,U,4),CAT=$P(Z0,U,3),ACTION=$P(Z0,U,5),CALL=$P(Z0,U,6),DESC=Z1
 S OH=$P(Z2,U,1) ; HASH code stored in the log
 ; S HVAL=LDTTM_U_DUZ_U_CAT_U_TYPE_U_ACTION_U_$E(CALL,1,200)_U_$E(DESC,1,250)
 S NH=$$HASH^BUSAAPI(ZTIME_U_USER_U_CAT_U_TYPE_U_ACTION_U_CALL_U_DESC)
 ;W !,"OLD = ",OH,!,"NEW = ",NH,!
 S @MSG@("SIAH")=$G(@MSG@("SIAH"))+1
 ;GDIT/HS/BEE 08012022;FEATURE#84723;Remediation handling;Allow for specific EPCS record type mediation
 ;I OH'=NH S @MSG@("SIAH","M")=$G(@MSG@("SIAH","M"))+1,@MSG@("SIAH","M",@MSG@("SIAH","M"))=ZTIME_U_USER_U_CALL_U_DESC
 I OH'=NH,'$S($L($T(CHECK^BUSAAPIR)):$$CHECK^BUSAAPIR("BUSAS Entry - HASH Mismatch",$g(REC),.BUSAR),1:"0") S @MSG@("SIAH","M")=$G(@MSG@("SIAH","M"))+1,@MSG@("SIAH","M",@MSG@("SIAH","M"))=ZTIME_U_USER_U_CALL_U_DESC
 Q
 ;
CHKNTP(STR,OFF,RTN,REC,BUSAR) ; Check the time and see if it is over the threshold
 N ZT,XX
 I ($G(STR)=""),($G(OFF)="") Q  ; nothing to check
 ; STR = "Time sync check success. offset: 4447 ms"
 S XX=$S($G(OFF)'="":$G(OFF),1:$P(STR,"offset: ",2)) Q:XX=""
 S ZT=+XX
 ;GDIT/HS/BEE 120622;FEATURE#88916;Remediation handling
 ;I ZT'<300000 S @RTN@("EST","F5")=$G(@RTN@("EST","F5"))+1 ; offset greater than 5 minutes
 ;I ZT'<180000 S @RTN@("EST","F3")=$G(@RTN@("EST","F3"))+1 ; offset greater than 5 minutes
 I ZT'<300000,'$S($L($T(CHECK^BUSAAPIR)):$$CHECK^BUSAAPIR("EPCS System Time Drift - 5 minutes",$g(REC),.BUSAR),1:"0") S @RTN@("EST","F5")=$G(@RTN@("EST","F5"))+1 ; offset greater than 5 minutes
 I ZT'<180000,'$S($L($T(CHECK^BUSAAPIR)):$$CHECK^BUSAAPIR("EPCS System Time Drift - 3 minutes",$g(REC),.BUSAR),1:"0") S @RTN@("EST","F3")=$G(@RTN@("EST","F3"))+1 ; offset greater than 3 minutes
 Q
 ;
GETU(S,E,IEN,KEY,RETURN) ; Get users with "KEY" and count them
 ; S = Start date
 ; E = End date
 ; IEN = IEN of security key
 ; KEY = Text of the security key
 ; RETURN = Array to return
 N Z,ZZ,ERROR S Z=""
 I $D(^XUSEC(KEY))'>9 S:'$D(@RETURN@("ECC")) @RETURN@("ECC")=0 Q  ; nothing to return for this key
 F  S Z=$O(^XUSEC(KEY,Z)) Q:Z=""  S @RETURN@("ECC")=$G(@RETURN@("ECC"))+1 ; Count of number of users for "credentialing"
 Q
 ;
GETEPCS(RTN) ; Get data out of File 100.7 for EPCS sites ("ECD") and EPCS Enabled Providers ("ECP")
 ;
 N XX,YY,ZZ,ISEPCS,OUT,ERR S XX=0
 F  S XX=$O(^ORD(100.7,XX)) Q:XX'=+XX  D
 . S ISEPCS=$$GET1^DIQ(100.7,XX_",",.02,"I") ;.02 ENABLE EPCS?
 . I +ISEPCS S @RTN@("ECD")=$G(@RTN@("ECD"))+1 D
 . . D GETS^DIQ(100.7,XX_",","1*","I","OUT","ERR")
 . . S YY="OUT(100.71)"
 . . F  S YY=$Q(@YY) Q:YY=""  S @RTN@("ECP")=$G(@RTN@("ECP"))+1
 . . ; Get related institutions
 . . K OUT,ERR,YY
 . . D GETS^DIQ(100.7,XX_",","9999999.11*","I","OUT","ERR")
 . . S YY="OUT(100.79999999)"
 . . F  S YY=$Q(@YY) Q:YY=""  S @RTN@("ECD")=$G(@RTN@("ECD"))+1
 . . Q
 . Q
 Q
 ;
 ; CER = Certificate to check
 ; INDT = Date of the report - if regenerating report this will give the expiration based on the report date
CHKCERT(CER,INDT) ; Check the certificate expiration date and get the number of days until it expires
 N ZEN,ZDT,ZIDT,DIFF
 S:$G(INDT)="" INDT=$$NOW^XLFDT
 S ZEN=$$FIND1^DIC(90460.12,,,CER,,,"ERROR")
 S ZDT=$$GET1^DIQ(90460.12,ZEN_",",.04)
 D DT^DILF("TS",ZDT,.ZIDT,,"") ; Get external date into internal format to perform date checks.
 S DIFF=$$FMDIFF^XLFDT(ZIDT,INDT,1) ; number of days between dates
 Q DIFF
 ;
DTRANGE(STARTDT,ENDDT,EXIT,DORNG) ;EP - Select Date for the report
 N %DT,Y,X
 G:+$G(DORNG)'=0 DTR1
 W ! S %DT="AEXP",%DT(0)=-DT S %DT("A")="Report DATE: " D ^%DT
 I (Y=-1)&((X=U)!(X="")) S EXIT=1 Q
 G:Y<0 DTRANGE
 S STARTDT=Y,ENDDT=Y
 Q
 ; Do Date Range
DTR1 I +$G(DORNG)'=0 D  Q:EXIT=1  G:Y<0 DTR1
 . W ! S %DT="AEXP",%DT(0)=-DT S %DT("A")="Start DATE: " D ^%DT
 . I (Y=-1)&((X=U)!(X="")) S EXIT=1 Q
 . G:Y<0 DTRANGE
 . S STARTDT=Y
 . S %DT("A")="  End DATE: ",%DT="AEXP",%DT(0)=STARTDT D ^%DT
 . I (Y=-1)&((X=U)!(X="")) S EXIT=1 Q
 . G:Y<0 DTRANGE
 . S ENDDT=Y
 Q
 ;
GETVARS(ARR) ; Get Default values for the threshold variables from file 90460.13
 N SCRN,ZOUT,ZZ,LN
 S SCRN="I $P(^(0),U,4)=""P""" ; Screen to grab only Pharmacy variables
 K ZOUT D LIST^DIC(90460.13,"",".02;.05;.06","P",,,,,SCRN,"","ZOUT")
 S ZZ=0 F  S ZZ=$O(ZOUT("DILIST",ZZ)) Q:ZZ=""  D
 . S LN=ZOUT("DILIST",ZZ,0),@ARR@($P(LN,U,3))=$S($P(LN,U,5)'="":$P(LN,U,5),1:$P(LN,U,4))
 Q
 ;
ROUND(VAL,SD) ; Round an integer
 Q:VAL'=+VAL!($G(SD)=0) VAL
 Q +$J(VAL,0,$S($D(SD):SD,VAL<1:2,VAL<10:2,1:2))
 ;
PRX(P7,P8,RES,D0,DATA,ARR) ; Check the "Type~P" events
 I ",EPCS80,EPCS81,"[P7 D  Q
 . S @ARR@("POH")=$G(@ARR@("POH"))+1
 . S:P7=",EPCS81," @ARR@("POH","F")=$G(@ARR@("POH","F"))+1
 . Q
 I ",EPCS88,EPCS91,EPCS97,"[P7 D  Q  ; Pharmacy Orders
 . I P7=",EPCS88," D  Q
 . . S @ARR@("PHN","CSx")=$G(@ARR@("PHN","CSx"))+1 ; Total events
 . . Q:P8=""  ; Problem because P8 should have a value
 . . I $G(@ARR@("PHN","Rx",P8))="" S @ARR@("PHN","Rx")=$G(@ARR@("PHN","Rx"))+1
 . . S @ARR@("PHN","Rx",P8)=$G(@ARR@("PHN","Rx",P8))+1 ; Number of pharmacists despensing today
 . . Q
 . I ",EPCS91,EPCS97,"[P7 D  Q  ; Pharmacy Discontinued Orders
 . . S @ARR@("PHN","PDO")=$G(@ARR@("PHN","PDO"))+1
 . . Q
 . S @ARR@("PHN")=$G(@ARR@("PHN"))+1
 . Q
 I ",EPCS96,EPCS98,"[P7 D  Q  ; Count paper prescribing events
 . S @ARR@("E")=$G(@ARR@("E"))+1 ; Total Count for paper
 . S:RES]"" @ARR@("E",RES)=$G(@ARR@("E",RES))+1 ; Success(S)/Failures(F)
 . Q
 S:RES'="" @ARR@("POHO",RES)=$G(@ARR@("POHO",RES))+1 ; Success,Failures
 S @ARR@("POHO","LE")=$P(DATA,"|",1)
 Q
 ;
PE ;;PHARMACY ENABLED PROVIDER AUTHENTICATION
 ;;Failed RPMS Login Attempts^Number of Failed Events~S X=+$G(RESULT("L","F"))^Total Logon Events~S X=+$G(RESULT("L"))^Ratio~S X=$S(+$G(RESULT("L"))>0:$$ROUND(((+$G(RESULT("L","F"))/RESULT("L"))*100),2),1:"-")
 ;;Electronic Signature - Paper Prescription^Number of Failed Events~S X=+$G(RESULT("E","F"))^Total Events~S X=+$G(RESULT("E"))^Ratio~S X=$S(+$G(RESULT("E"))>0:$$ROUND(((+$G(RESULT("E","F"))/RESULT("E"))*100),2),1:"-")
 ;;
PP ;;PHARMACY PROVISIONING
 ;;Number of EPCS Enabled Pharmacists^Total~S X=+$G(RESULT("ECP"))^Assigned~S X=+$G(RESULT("ECP","A1"))^Removed~S X=+$G(RESULT("ECP","R1"))
 ;;Provision Pharmacy Keys^Total~S X=+$G(RESULT("PPK"))^Assigned~S X=+$G(RESULT("ECP","A"))^Removed~S X=+$G(RESULT("ECP","R"))
 ;;
PS ;;PHARMACY SYSTEM STATUS
 ;;Time Synchronization^Total Events~S X=+$G(RESULT("EST","T"))^Failed Checks~S X=+$G(RESULT("EST","F"))^Events Over 3 Minutes~S X=+$G(RESULT("EST","F3"))^Events Over 5 Minutes~S X=+$G(RESULT("EST","F5"))^Last Event~S X=$G(RESULT("EST","LE"))
 ;
OH ;;ORDER HANDLING
 ;;Received Orders^Total~S X=+$G(RESULT("POH"))^Failed Integrity~S X=+$G(RESULT("POH","F"))
 ;;Pharmacy Orders^Number of Pharmacists~S X=+$G(RESULT("PHN","Rx"))^CS Rx Dispense~S X=+$G(RESULT("PHN","CSx"))^Pharmacy Discontinued Order~S X=+$G(RESULT("PHN","PDO"))
 ;;
SI ;;SYSTEM INTEGRITY
 ;;Audit Log^Number of Records~S X=+$G(RESULT("SIA"))^Number of Mismatches~S X=+$G(RESULT("SIA","M"))^Number of Deletions~S X=+$G(RESULT("SIA","D"))
 ;;Prescription Archive File^Number of Records~S X=+$G(RESULT("PAF"))^Number of Mismatches~S X=+$G(RESULT("PAF","M"))^Number of Deletions~S X=+$G(RESULT("PAF","D"))
 ;;
TS ;;THRESHOLD SUMMARY
 ;;Please initiate appropriate incident response to look into identified issues.
 ;;
