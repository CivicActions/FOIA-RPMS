BEHOEPR2 ;GDIT/HS/TJB - EPCS Audit Summary Report;26-Jan-2023 13:39;PLS
 ;;1.1;BEH COMPONENTS;**070001,070003,070005**;Mar 20, 2007;Build 12
 ;
 ; Utility items moved here to reduce the size of the routine
 Q
 ;
 ;GDIT/HS/BEE 04192021;Remediation handling
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
 S @MSG@("SIA")=$G(@MSG@("SIA"))+1
 ;GDIT/HS/BEE 04192021;Remediation handling
 ;I OH'=NH S @MSG@("SIA","M")=$G(@MSG@("SIA","M"))+1,@MSG@("SIA","M",@MSG@("SIA","M"))=ZTIME_U_USER_U_CALL_U_DESC
 I OH'=NH,'$S($L($T(CHECK^BUSAAPIR)):$$CHECK^BUSAAPIR("BUSAS Entry - HASH Mismatch",$g(REC),.BUSAR),1:"0") S @MSG@("SIA","M")=$G(@MSG@("SIA","M"))+1,@MSG@("SIA","M",@MSG@("SIA","M"))=ZTIME_U_USER_U_CALL_U_DESC
 Q
 ;
 ;GDIT/HS/BEE 04192021;Remediation handling
 ;CHKNTP(STR,OFF,RTN) ; Check the time and see if it is over the threshold
CHKNTP(STR,OFF,RTN,REC,BUSAR) ; Check the time and see if it is over the threshold
 N ZT,XX
 I ($G(STR)=""),($G(OFF)="") Q  ; nothing to check
 S XX=$S($G(OFF)'="":$G(OFF),1:$P(STR,"offset: ",2)) Q:XX=""
 S ZT=+XX
 ;GDIT/HS/BEE 04192021;Remediation handling
 ;I ZT'<300000 S @RTN@("EST","F5")=$G(@RTN@("EST","F5"))+1 ; offset greater than 5 minutes
 ;I ZT'<180000 S @RTN@("EST","F3")=$G(@RTN@("EST","F3"))+1 ; offset greater than 3 minutes
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
GETEPCS(RTN) ; Get data out of File 100.7 for EPCS sites and EPCS Enabled Providers
 ;
 N XX,YY,ZZ,ISEPCS,OUT,ERR S XX=0
 F  S XX=$O(^ORD(100.7,XX)) Q:XX'=+XX  D
 . S ISEPCS=$$GET1^DIQ(100.7,XX_",",.02,"I") ;.02 ENABLE EPCS?
 . I +ISEPCS S @RTN@("ECD")=$G(@RTN@("ECD"))+1 D  ; "ECD" is the parent division
 . . D GETS^DIQ(100.7,XX_",","1*","I","OUT","ERR")
 . . S YY="OUT(100.71)"
 . . F  S YY=$Q(@YY) Q:YY=""  S ZZ=$$ACTIVE^XUSER(@YY) D
 . . . I +ZZ=1 S @RTN@("ECP")=$G(@RTN@("ECP"))+1 ; Verify that we have an active user
 . . . I +ZZ=0 S @RTN@("ECPI")=$G(@RTN@("ECPI"))+1 ; Inactive user
 . . . Q
 . . ; Get related institutions
 . . K OUT,ERR,YY
 . . D GETS^DIQ(100.7,XX_",","9999999.11*","I","OUT","ERR")
 . . S YY="OUT(100.79999999)"
 . . F  S YY=$Q(@YY) Q:YY=""  S @RTN@("ECD")=$G(@RTN@("ECD"))+1 ; add related divisions to division total
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
 S STARTDT=Y
 S ENDDT=Y
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
COMPILE ; Compile items and log to BUSAS for use in next daily incident report
 N F,E,G,Z,DAT,STS,KEY,OUT,ERR,TOT,RVK S F=0,E=0
 K DAT
 F KEY="PSORPH","PSDRPH" D
 . I $D(^XUSEC(KEY))'>9 S:'$D(DAT("ECC")) DAT("ECC")=0 Q  ; nothing to return for this key
 . S Z=""
 . F  S Z=$O(^XUSEC(KEY,Z)) Q:Z=""  D
 . . N ZACT S ZACT=$$ACTIVE^XUSER(Z)
 . . I +ZACT=0 S DAT("ECC","I",Z)="" ; Gather list of TERMINATED and DISUSER users
 . . I +ZACT=1 S DAT("ECC","U",Z)="" ; Gather list of ACTIVE users
 . . Q
 . Q
 S Z="" ; Count the union of users with one or both keys
 F  S Z=$O(DAT("ECC","U",Z)) Q:Z=""  S DAT("ECC")=$G(DAT("ECC"))+1
 F  S Z=$O(DAT("ECC","I",Z)) Q:Z=""  S DAT("ECCI")=$G(DAT("ECCI"))+1
 ;W !,"Pharmacy workers, with PSORPH & PSDRPH Keys Active: ",($G(DAT("ECC")))," Inactive: ",($G(DAT("ECCI"))),!
 S STS=$$LOG^XUSBUSA("A","O","","BEHOEPR2","Count of Active EPCS Pharmacists: "_+$G(DAT("ECC"))_" ; Inactive Pharmacists: "_+$G(DAT("ECCI"))_"|TYPE~G|RSLT~S|||EP~P|EPCS164|"_+$G(DAT("ECC"))_"|","","")
 K DAT D GETEPCS("DAT") S F=$G(DAT("ECD")),E=+$G(DAT("ECP")),G=+$G(DAT("ECPI"))
 ;W !,"EPCS Divisions: ",F," Found",!!,"Active EPCS Providers: ",E," Found",!,"Inactive EPCS Providers: ",G," Found",!
 S STS=$$LOG^XUSBUSA("A","O","","BEHOEPR2","Count of EPCS Divisions: "_F_"|TYPE~G|RSLT~S|||EP~E|EPCS162|"_F_"|","","")
 S STS=$$LOG^XUSBUSA("A","O","","BEHOEPR2","Count of Active EPCS Providers: "_E_" ; Inactive EPCS Providers: "_G_"|TYPE~G|RSLT~S|||EP~E|EPCS163|"_E_"|","","")
 ; Check file 90460.12 (BEH EPCS CERTIFICATE STATUS) to find total and revoked certificates.
 K ERR,OUT D LIST^DIC(90460.12,"",";.01;.04","PI",,,,,,,"OUT","ERR")
 ; Error in FileMan call
 I $D(ERR) S STS=$$LOG^XUSBUSA("A","O","","BEHOEPR2","ERROR: "_ERR("DIERR",1,"TEXT",1)_"|TYPE~G|RSLT~F|||EP~E|EPCS165|"_ERR("DIERR",1)_"|","","") G CQ
 ; Get revoked & total number of certificates
 S TOT=0,RVK=0
 S Z=0 F  S Z=$O(OUT("DILIST",Z)) Q:Z'>0  S TOT=TOT+1 S:$P(OUT("DILIST",Z,0),U,4)="R" RVK=RVK+1
 S STS=$$LOG^XUSBUSA("A","O","","BEHOEPR2","Count of Certificates: "_TOT_"; Revoked: "_RVK_"|TYPE~G|RSLT~S|||EP~E|EPCS165|"_TOT_"~"_RVK_"|","","")
CQ ;
 Q
 ;
EPK(P7,P8,RES,DATA0,DATA,ARR) ; Check the "Type~K" events
 S @ARR@("ECK")=$G(@ARR@("ECK"))+1 ; Number of Key events
 S:RES]"" @ARR@("ECK",RES)=$G(@ARR@("ECK",RES))+1 ; RES will be an "S" or "F"
 I ",EPCS120,EPCS121,EPCS122,EPCS123,EPCS124,EPCS125,EPCS126,EPCS127,"[P7 D  Q
 . ;I ",EPCS120,EPCS122,EPCS124,EPCS126,"[P7 D  Q  ;; Original code
 . I ",EPCS120,EPCS121,EPCS124,EPCS125,"[P7 D  Q
 . . Q:$G(P8)=""  ; This should be defined
 . . I +$G(@ARR@("ECK","A",P8))=0 S @ARR@("ECK","A")=$G(@ARR@("ECK","A"))+1,@ARR@("ECK","A",P8)=$G(@ARR@("ECK","A",P8))+1 Q
 . . S @ARR@("ECK","A",P8)=$G(@ARR@("ECK","A",P8))+1
 . . Q
 . ;I ",EPCS121,EPCS123,EPCS125,EPCS127,"[P7 D  Q  ;; Original code
 . I ",EPCS122,EPCS123,EPCS126,EPCS127,"[P7 D  Q
 . . Q:$G(P8)=""  ; This should be defined
 . . I +$G(@ARR@("ECK","R",P8))=0 S @ARR@("ECK","R")=$G(@ARR@("ECK","R"))+1,@ARR@("ECK","R",P8)=$G(@ARR@("ECK","R",P8))+1 Q
 . . S @ARR@("ECK","R",P8)=$G(@ARR@("ECK","R",P8))+1
 . . Q
 . Q
 Q
PPX(P7,P8,RES,DATA0,DATA,ARR) ; Check the "Type~PP" events
 I ",EPCS30,EPCS31,EPCS32,EPCS33,EPCS34,EPCS35,"[P7 D  Q
 . S @ARR@("ECPP")=$G(@ARR@("ECPP"))+1
 . I RES'="" S @ARR@("ECPP",RES)=$G(@ARR@("ECPP",RES))+1  ; Successes (EPCS30, EPCS32, EPCS34)/Failures (EPCS31, EPCS33, EPCS35)
 . I ",EPCS30,EPCS34,"[P7 S @ARR@("ECPP","C")=$G(@ARR@("ECPP","C"))+1 Q  ; Provider Profile Create
 . I ",EPCS32,"=P7 S @ARR@("ECPP","R")=$G(@ARR@("ECPP","R"))+1 Q  ; Provider Profile Removed/Revoked
 . S @ARR@("ECPP","S","O")=$G(@ARR@("ECPP","S","O"))+1,@ARR@("ECPP","S","O","LE")=$P(DATA,"|",1) ; Other Provider Profile events
 . Q
 ;
 I ",EPCS40,EPCS41,"[P7 D  Q  ; Verify Provider Profile & EPCS Enabled Providers
 . N ZG,ZP S @ARR@("ECV")=$G(@ARR@("ECV"))+1
 . I P7=",EPCS40," S @ARR@("ECV","A")=$G(@ARR@("ECV","A"))+1 ; For Verify Provider Profile
 . I P7=",EPCS41," S @ARR@("ECV","F")=$G(@ARR@("ECV","F"))+1 ; For Verify Provider Profile
 . S ZG=$P($G(P8),"~",2) Q:ZG=""  ; From here count for # EPCS Enabled Provider based on IEN & 2nd piece of "|" piece 8
 . ; Do Dedup count on EPCS40
 . S ZP=$P($G(P8),"~",1) Q:ZP=""  ; Get Provider IEN
 . I P7=",EPCS40," D
 . . I ZG="Activated" S:$G(@ARR@("ECP","A",ZP))="" @ARR@("ECP","A")=$G(@ARR@("ECP","A"))+1 S @ARR@("ECP","A",ZP)=$G(@ARR@("ECP","A",ZP))+1
 . . I ZG="Inactivated" S:$G(@ARR@("ECP","R",ZP))="" @ARR@("ECP","R")=$G(@ARR@("ECP","R"))+1 S @ARR@("ECP","R",ZP)=$G(@ARR@("ECP","R",ZP))+1
 . I P7=",EPCS41," S @ARR@("ECP","F")=$G(@ARR@("ECP","F"))+1
 . Q
 ; Any "Type~PP" that didn't match above
 I $E($P(DATA,"|",1),1,20)="EPCS Monitoring Hash" S @ARR@("SIP","ZZ",$P(DATA0,U,1))=$P(DATA,"|",1)
 S @ARR@("EXPP")=$G(@ARR@("EXPP"))+1,@ARR@("EXPP","LE")=$P(DATA0,U,1)_" ;; "_DATA
 S:RES'="" @ARR@("EXPP",RES)=$G(@ARR@("EXPP",RES))+1
 ;W $P(DATA0,U,1)_" ;; "_DATA,!
 Q
 ;
PRX(P7,P8,RES,DATA0,DATA,ARRAY) ; Check the "Type~X" events
 I ",EPCS60,EPCS61,EPCS62,EPCS67,EPCS68,EPCS71,EPCS77,"[P7 D  Q
 . I ",EPCS71,"[P7 S @ARRAY@("EPX","TR")=$G(@ARRAY@("EPX","TR"))+1 Q  ; Transmitted doesn't have a P8 component
 . I P7=",EPCS68," S @ARRAY@("EPX","DF")=$G(@ARRAY@("EPX","DF"))+1 Q  ; Digitally Signed Failure doesn't have a P8 component
 . Q:P8=""  ; Problem, we should have Prescriber or Agent IEN
 . I ",EPCS60,EPCS62,EPCS67,EPCS77,"[P7 D
 . . I +$G(@ARRAY@("EPX",P8))=0 S @ARRAY@("EPX")=$G(@ARRAY@("EPX"))+1 ; Do we have a new provider to count
 . . S @ARRAY@("EPX",P8)=$G(@ARRAY@("EPX",P8))+1
 . . Q
 . ;
 . ;GDIT/HS/BEE;FEATURE#76005;EHR*1.1*35;New formula for section
 . ;I P7=",EPCS60," S @ARRAY@("EPX","I")=$G(@ARRAY@("EPX","I"))+1 Q
 . I P7=",EPCS60," D  Q
 .. S @ARRAY@("EPX","I")=$G(@ARRAY@("EPX","I"))+1
 .. S @ARRAY@("EPX","T")=$G(@ARRAY@("EPX","T"))+1  ; Denominator
 . I ",EPCS61,"[P7 S @ARRAY@("EPX","ED")=$G(@ARRAY@("EPX","ED"))+1 Q  ; Edits
 . ;GDIT/HS/BEE;FEATURE#76005;EHR*1.1*35;New formula for section
 . ;I ",EPCS62,EPCS77,"[P7 S @ARRAY@("EPX","C")=$G(@ARRAY@("EPX","C"))+1 Q  ; Cancelled
 . I ",EPCS62,EPCS77,"[P7 D  Q
 .. S @ARRAY@("EPX","C")=$G(@ARRAY@("EPX","C"))+1  ; Cancelled (Numerator)
 .. S @ARRAY@("EPX","T")=$G(@ARRAY@("EPX","T"))+1  ; Denominator
 . I P7=",EPCS67," S @ARRAY@("EPX","D")=$G(@ARRAY@("EPX","D"))+1 Q  ; Digitally Signed Success
 . Q
 I ",EPCS64,EPCS65,"[P7 D  Q  ; Electronic signature events
 . S @ARRAY@("MFA")=$G(@ARRAY@("MFA"))+1,@ARRAY@("MFA",RES)=$G(@ARRAY@("MFA",RES))+1 ; Part of the Multi-Factor Authentication accounting
 . I (",EPCS64,"=P7) S @ARRAY@("EPX","AU","S")=$G(@ARRAY@("EPX","AU","S"))+1 Q  ; Signed event
 . I (",EPCS65,"=P7) S:RES]"" @ARRAY@("CD",RES)=$G(@ARRAY@("CD",RES))+1,@ARRAY@("EPX","AU","F")=$G(@ARRAY@("EPX","AU","F"))+1 Q  ; Signed event
 . Q
 S @ARRAY@("EPX","O")=$G(@ARRAY@("EPX","O"))+1 ; Other Prescribing ("X") type events
 I RES]"" S @ARRAY@("EPX","O",RES)=$G(@ARRAY@("EPX","O",RES))+1,@ARRAY@("EPX","O","LE")=$P(DATA0,U,1)_" ;; "_DATA ; Success/Failures
 Q
GEN(P7,P8,RES,DATA0,DATA,ARRAY) ; Check the "Type~G" events
 I P7=",EPCS160," S @ARRAY@("ECD","A")=$G(@ARRAY@("ECD","A"))+1 Q  ; Count of EPCS enable Division events
 I P7=",EPCS161," S @ARRAY@("ECD","R")=$G(@ARRAY@("ECD","R"))+1 Q  ; Count of EPCS Division removed events
 I P7=",EPCS162," S @ARRAY@("ECD")=$S($G(P8)'="":+$G(P8),1:0) Q  ; Count of EPCS enabled Divisions
 I P7=",EPCS163," S @ARRAY@("ECP")=$S($G(P8)'="":+$G(P8),1:0) Q  ; Count of EPCS enabled Providers
 I P7=",EPCS165," Q:$G(P8)=""  D
 . N XT,XR S XT=$P(P8,"~",1),XR=$P(P8,"~",2)
 . S @ARRAY@("EDC")=+XT  ; Count of total Certificates
 . S @ARRAY@("EDC","R")=+XR  ; Count of Revoked Certificates
 . Q
 I P7=",EPCS100," S @ARRAY@("GST","NIGHT")=$P(DATA0,U,1),@ARRAY@("SIA","BUSA")=$G(@ARRAY@("SIA","BUSA"))+1 Q  ; Start of nightly report need EPCS101 to complete
 I P7=",EPCS101," S @ARRAY@("GST","NIGHT")=$G(@ARRAY@("GST","NIGHT"))_U_$P(DATA0,U,1),@ARRAY@("SIA","BUSA")=$G(@ARRAY@("SIA","BUSA"))-1 Q  ; End of nightly report
 I P7=",EPCS102," S @ARRAY@("GST","PRPI")=$P(DATA0,U,1),@ARRAY@("SIP","F")=$G(@ARRAY@("SIP","F"))+1 Q  ; Start of Provider Profile need EPCS103 to complete
 I P7=",EPCS103," S @ARRAY@("GST","PRPI")=$G(@ARRAY@("GST","PRPI"))_U_$P(DATA0,U,1),@ARRAY@("SIP","F")=$G(@ARRAY@("SIP","F"))-1 S:P8]"" @ARRAY@("SIP")=+$P(P8,"~",2),@ARRAY@("SIP","M")=+$P(P8,"~",1) Q  ; End of nightly report
 I P7=",EPCS104," S @ARRAY@("GST","CSOI")=$P(DATA0,U,1),@ARRAY@("SIO","F")=$G(@ARRAY@("SIO","F"))+1 Q  ; Start of CS Order need EPCS105 to complete
 I P7=",EPCS105," S @ARRAY@("GST","CSOI")=$G(@ARRAY@("GST","CSOI"))_U_$P(DATA0,U,1),@ARRAY@("SIO","F")=$G(@ARRAY@("SIO","F"))-1 Q  ; End of nightly report
 I P7=",EPCS106," S @ARRAY@("GST","PHOI")=$P(DATA0,U,1) Q  ; Start of Pharmacy Order need EPCS107 to complete
 I P7=",EPCS107," S @ARRAY@("GST","PHOI")=$G(@ARRAY@("GST","PHOI"))_U_$P(DATA0,U,1) Q  ; End of nightly report
 I P7=",EPCS108," S @ARRAY@("GST","BUSA")=$P(DATA0,U,1),@ARRAY@("SIA","F")=$G(@ARRAY@("SIA","F"))+1 Q  ; Start of BUSA Integrity need EPCS109 to complete
 I P7=",EPCS109," S @ARRAY@("GST","BUSA")=$G(@ARRAY@("GST","BUSA"))_U_$P(DATA0,U,1),@ARRAY@("SIA","F")=$G(@ARRAY@("SIA","F"))-1 Q  ; End of nightly report
 S @ARRAY@("GEN")=$G(@ARRAY@("GEN"))+1,@ARRAY@("GEN","LE")=$P(DATA0,U,1)_";;"_$P(DATA,"|",1)_";;"_P7
 Q
 ;
GETVARS(ARR) ; Get Default values for the threshold variables from file 90460.13
 N SCRN,ZOUT,ZZ,LN
 S SCRN="I $P(^(0),U,4)=""E""" ; Screen to grab only EPCS variables
 K ZOUT D LIST^DIC(90460.13,"",".02;.05;.06","P",,,,,SCRN,"","ZOUT")
 S ZZ=0 F  S ZZ=$O(ZOUT("DILIST",ZZ)) Q:ZZ=""  D
 . S LN=ZOUT("DILIST",ZZ,0)
 . S @ARR@($P(LN,U,3))=$S($P(LN,U,5)'="":$P(LN,U,5),1:$P(LN,U,4))
 . Q
 Q
 ;
ROUND(VAL,SD) ; Round an integer
 Q:VAL'=+VAL!($G(SD)=0) VAL
 Q +$J(VAL,0,$S($D(SD):SD,VAL<1:2,VAL<10:2,1:2))
 ;
