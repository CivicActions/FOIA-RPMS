APSPEPR3 ;GDIT/HS/TJB - Pharmacy Audit Summary Report;08-Nov-2022 15:12;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1023,1028,1032**;Sep 23, 2004;Build 26
 ;
 ; Utility items moved here to reduce the size of the routine
 Q
 ;
TRIP(ARRAY,RPTDT) ; Check the array for any tripped thresholds
 ; Check ARRAY to see if there are any thresholds tripped
 N XX,VAR,ZDT,ZR,ZZ,ZY,ZS,ZCOM,ZBUSA,ZLN,ZCNT,ZPRO,TWOYRS
 S:$G(RPTDT)="" RPTDT=$$NOW^XLFDT
 D GETVARS^APSPEPR2("VAR")
 K ZPRO D GETEPCS^APSPEPR2("ZPRO")
 S XX=""
 S XX=$S(+$G(@ARRAY@("L"))>0:$$ROUND^APSPEPR2(((+$G(@ARRAY@("L","F"))/@ARRAY@("L"))*100),2),1:"-")
 I XX'<VAR("LOGIN") S @ARRAY@("THR","LOGIN",0)="*** Excessive Failed verify code attempts. This could indicate an attempt to",@ARRAY@("THR","LOGIN",1)="***  brute force verify codes."
 S XX=""
 S XX=$S(+$G(@ARRAY@("E"))>0:$$ROUND^APSPEPR2(((+$G(@ARRAY@("E","F"))/@ARRAY@("E"))*100),2),1:"-")
 I +XX'<VAR("ESIGN") S @ARRAY@("THR","ESIGN",0)="*** Excessive Failed electronic signature code attempts. This could indicate an",@ARRAY@("THR","ESIGN",1)="***  attempt to brute force Electronic Signature Code accounts."
 S XX=""
 S XX=$S(+$G(@ARRAY@("ECP"))>0:$$ROUND^APSPEPR2(((+$G(@ARRAY@("ECP","A1"))/@ARRAY@("ECP"))*100),2),1:"-")
 I +XX'<VAR("EAPHARM") S @ARRAY@("THR","EAPHARM",0)="*** Large percentage of pharmacists added. This could indicate an attempt to",@ARRAY@("THR","EAPHARM",1)="***  tamper with system."
 S XX=""
 S XX=$S(+$G(@ARRAY@("ECP"))>0:$$ROUND^APSPEPR2(((+$G(@ARRAY@("ECP","R1"))/@ARRAY@("ECP"))*100),2),1:"-")
 I +XX'<VAR("ERPHARM") S @ARRAY@("THR","ERPHARM",0)="*** Large percentage of pharmacists removed. This could indicate an attempt to",@ARRAY@("THR","ERPHARM",1)="***  tamper with system."
 S XX=""
 S XX=$S(+$G(@ARRAY@("PPK"))>0:$$ROUND^APSPEPR2(((+$G(@ARRAY@("ECP","A"))/@ARRAY@("PPK"))*100),2),1:"-")
 I +XX'<VAR("PPK") S @ARRAY@("THR","PPKA",0)="*** Large percentage of pharmacists had EPCS related keys added. This could",@ARRAY@("THR","PPKA",1)="***  indicate potential tampering with system."
 S XX=""
 S XX=$S(+$G(@ARRAY@("PPK"))>0:$$ROUND^APSPEPR2(((+$G(@ARRAY@("ECP","R"))/@ARRAY@("PPK"))*100),2),1:"-")
 I +XX'<VAR("PPKR") S @ARRAY@("THR","PPKR",0)="*** Large percentage of pharmacists had EPCS related keys removed. This could",@ARRAY@("THR","PPKR",1)="***  indicate potential tampering with system."
 S XX=""
 S XX=$S(+$G(@ARRAY@("PHN","CSx"))>0:$$ROUND^APSPEPR2((+$G(@ARRAY@("PHN","CSx"))/@ARRAY@("PHN","Rx")),2),1:"-")
 I +XX'<VAR("POCD") S @ARRAY@("THR","POCD",0)="*** Large number of Prescriptions were dispensed by pharmacists. This could",@ARRAY@("THR","POCD",1)="***  indicate potential tampering with system."
 S XX=""
 S XX=$S(+$G(@ARRAY@("POH"))>0:$$ROUND^APSPEPR2(((+$G(@ARRAY@("POH","F"))/@ARRAY@("POH"))*100),2),1:"-")
 I +XX'<VAR("PRO") S @ARRAY@("THR","POH",0)="*** Large percentage of Received Order Integrity checks failed. This could",@ARRAY@("THR","POH",1)="***  indicate potential tampering with system."
 S XX=""
 S XX=$S(+$G(@ARRAY@("POH"))>0:$$ROUND^APSPEPR2(((+$G(@ARRAY@("PHN","PDO"))/@ARRAY@("POH"))*100),2),1:"-")
 I +XX'<VAR("PDO") S @ARRAY@("THR","PDO",0)="*** Large percentage of Received Orders were discontinued. This could",@ARRAY@("THR","PDO",1)="***  indicate potential tampering with system."
 S XX=""
 S XX=$S(+$G(@ARRAY@("EST","F"))>0:$$ROUND^APSPEPR2(((+$G(@ARRAY@("EST","F"))/@ARRAY@("EST","T"))*100),2),1:"-")
 I +XX'<VAR("ESTF") S @ARRAY@("THR","ESTF",0)="*** Excessive number of failed time synchronization checks. Indicates a possible",@ARRAY@("THR","ESTF",1)="***  configuration issue with time checks."
 I +$G(@ARRAY@("EST","F3"))>0 S @ARRAY@("THR","EST3",0)="*** Time drift is exceeding +/- 3 minutes. Indicates a possible",@ARRAY@("THR","EST3",1)="***  issue with time synchronization."
 I +$G(@ARRAY@("EST","F5"))>0 S @ARRAY@("THR","EST5",0)="*** Time drift is exceeding +/- 5 minutes. Indicates system may",@ARRAY@("THR","EST5",1)="***  no longer be in compliance with DEA time synchronization regulations."
 I +$G(@ARRAY@("SIAH","M"))>0 S @ARRAY@("THR","SIAM",0)="*** HASH code mismatch detected, possible system compromise:" D
 . N QQ S QQ=""
 . F  S QQ=$O(@ARRAY@("SIAH","M",QQ)) Q:QQ=""  S @ARRAY@("THR","SIAM",QQ)="***  "_@ARRAY@("SIAH","M",QQ)
 . Q
 I ($G(@ARRAY@("GST","EPCS100"))="")!($G(@ARRAY@("GST","EPCS101"))="") D  ; We don't have a matched pair for the nightly task
 . N ZG S ZG=0 S @ARRAY@("THR","ZGST0",0)="*** Mismatch detected in daily integrity check, possible system problem."
 . S:$G(@ARRAY@("GST","EPCS100"))="" ZG=ZG+1,@ARRAY@("THR","ZGST0",ZG)="***  missing EPCS100 indicator for starting the nightly BUSA compile check."
 . S:$G(@ARRAY@("GST","EPCS101"))="" ZG=ZG+1,@ARRAY@("THR","ZGST0",ZG)="***  missing EPCS101 indicator for completing the nightly BUSA compile check."
 . Q
 I ($G(@ARRAY@("GST","EPCS106"))="")!($G(@ARRAY@("GST","EPCS107"))="") D  ; We don't have a matched pair for the nightly task
 . N ZG S ZG=0 S @ARRAY@("THR","ZGST6",0)="*** Mismatch detected Pharmacy Order Integrity Compile, possible system problem."
 . S:$G(@ARRAY@("GST","EPCS106"))="" ZG=ZG+1,@ARRAY@("THR","ZGST6",ZG)="***  missing EPCS106 indicator for Pharmacy Order Integrity Compile check."
 . S:$G(@ARRAY@("GST","EPCS107"))="" ZG=ZG+1,@ARRAY@("THR","ZGST6",ZG)="***  missing EPCS107 indicator for Pharmacy Order Integrity Compile check."
 . Q
 I ($G(@ARRAY@("GST","EPCS108"))="")!($G(@ARRAY@("GST","EPCS109"))="") D  ; We don't have a matched pair for the nightly task
 . N ZG S ZG=0 S @ARRAY@("THR","ZGST8",0)="*** Mismatch detected in BUSA Integrity Compile, possible system problem."
 . S:$G(@ARRAY@("GST","EPCS108"))="" ZG=ZG+1,@ARRAY@("THR","ZGST8",ZG)="***  missing EPCS108 indicator for BUSA Integrity Compile check."
 . S:$G(@ARRAY@("GST","EPCS109"))="" ZG=ZG+1,@ARRAY@("THR","ZGST8",ZG)="***  missing EPCS109 indicator for completing BUSA Integrity Compile check."
 . Q
 ;
 ;GDIT/HS/BEE;FEATURE#84694;APSP*7*1032;Only count last 2 years in totals
 ;Get 2 years in past or first BUSAp1 Install
 S TWOYRS=0 D
 . NEW X1,X2,X
 . S X1=DT,X2=-731
 . D C^%DTC
 . S TWOYRS=X
 ;
 ; Walk ^XTMP("BEHOEPIC", global looking for possible tampering issues
 S ZDT="",ZR="",ZCNT=0 K ZCOM
 S ZBUSA=$NA(^XTMP("BEHOEPIC","B"))
 S @ARRAY@("SIA")=$P($G(^XTMP("BEHOEPIC","B")),U,6)
 ;GDIT/HS/BEE;FEATURE#84694;APSP*7*1032;Only count last 2 years in totals
 ;F  S ZDT=$O(@ZBUSA@(ZDT)) Q:ZDT=""  S ZCNT=ZCNT+$P($G(@ZBUSA@(ZDT)),U,4) D:$D(@ZBUSA@(ZDT))>1
 F  S ZDT=$O(@ZBUSA@(ZDT)) Q:ZDT=""  D:$D(@ZBUSA@(ZDT))>1  I ZDT>TWOYRS S ZCNT=ZCNT+$P($G(@ZBUSA@(ZDT)),U,4)
 . S ZR="" F  S ZR=$O(@ZBUSA@(ZDT,ZR)) Q:ZR=""  D:ZR["P"
 . . S ZZ="" F  S ZZ=$O(@ZBUSA@(ZDT,ZR,ZZ)) Q:ZZ=""  S ZLN=$G(@ZBUSA@(ZDT,ZR,ZZ)) D:ZLN]""
 . . . I $P(ZLN,U,2)'=""  S ZCOM($P(ZLN,U,2))=$G(ZCOM($P(ZLN,U,2)))+1,ZCOM($P(ZLN,U,2),ZCOM($P(ZLN,U,2)))=$P(@ZBUSA@(ZDT,ZR,ZZ),U,1)_U_ZDT
 . . Q
 . Q
 I $G(@ARRAY@("SIA"))'=ZCNT S ZCOM("B")=1,ZCOM("B",1)=$G(@ARRAY@("SIA"))_U_ZCNT
 I $D(ZCOM)>1 D
 . S ZR=""  F  S ZR=$O(ZCOM(ZR)) Q:ZR=""  S:ZR="H" @ARRAY@("SIA","M")=ZCOM(ZR) S:ZR="D" @ARRAY@("SIA","D")=ZCOM(ZR)
 . S @ARRAY@("THR","ZZBUSA",0)="*** Issue found in BUSA integrity check process, possible system problem."
 . S ZZ="",ZG=0 F  S ZZ=$O(ZCOM(ZZ)) Q:ZZ=""  D
 . . S ZS=$S(ZCOM(ZZ)>1:"s",1:"")
 . . I ZZ="H" D
 . . . S ZG=ZG+1,@ARRAY@("THR","ZZBUSA",ZG)="***     HASH Mismatch found in "_ZCOM(ZZ)_" BUSAS IEN"_ZS_":"
 . . . S ZY="" F  S ZY=$O(ZCOM(ZZ,ZY)) Q:ZY=""  S ZG=ZG+1,@ARRAY@("THR","ZZBUSA",ZG)="***"_$J(" ",10)_$P(ZCOM(ZZ,ZY),U,1)_"  on: "_$$FMTE^XLFDT($P(ZCOM(ZZ,ZY),U,2),"5P")
 . . I ZZ="E" D
 . . . S ZG=ZG+1,@ARRAY@("THR","ZZBUSA",ZG)="***     Missing Timestamp in "_ZCOM(ZZ)_" BUSAS IEN"_ZS_":"
 . . . S ZY="" F  S ZY=$O(ZCOM(ZZ,ZY)) Q:ZY=""  S ZG=ZG+1,@ARRAY@("THR","ZZBUSA",ZG)="***"_$J(" ",10)_$P(ZCOM(ZZ,ZY),U,1)
 . . I ZZ="D" D
 . . . S ZG=ZG+1,@ARRAY@("THR","ZZBUSA",ZG)="***     Missing "_ZCOM(ZZ)_" BUSAS IEN"_ZS_":"
 . . . S ZY="" F  S ZY=$O(ZCOM(ZZ,ZY)) Q:ZY=""  S ZG=ZG+1,@ARRAY@("THR","ZZBUSA",ZG)="***"_$J(" ",10)_$P(ZCOM(ZZ,ZY),U,1)
 . . I ZZ="B" D
 . . . S ZG=ZG+1,@ARRAY@("THR","ZZBUSA",ZG)="***     Number of records is incorrect in BUSA integrity check process"
 . . . S ZY="" F  S ZY=$O(ZCOM(ZZ,ZY)) Q:ZY=""  S ZG=ZG+1,@ARRAY@("THR","ZZBUSA",ZG)="*** Integrity Check Count: "_$J($P(ZCOM(ZZ,ZY),U,1),10)_" Calculated count: "_$J($P(ZCOM(ZZ,ZY),U,2),10)
 . Q
 ;
 S ZDT="",ZR="" K ZCOM
 S ZBUSA=$NA(^XTMP("BEHOEPIC","P"))
 S @ARRAY@("PAF")=$P($G(^XTMP("BEHOEPIC","P")),U,6)
 F  S ZDT=$O(@ZBUSA@(ZDT)) Q:ZDT=""  D:$D(@ZBUSA@(ZDT))>1
 . S ZR="" F  S ZR=$O(@ZBUSA@(ZDT,ZR)) Q:ZR=""  D:ZR["P"
 . . S ZZ="" F  S ZZ=$O(@ZBUSA@(ZDT,ZR,ZZ)) Q:ZZ=""  S ZLN=$G(@ZBUSA@(ZDT,ZR,ZZ)) D:ZLN]""
 . . . I $P(ZLN,U,2)'="" S ZCOM($P(ZLN,U,2))=$G(ZCOM($P(ZLN,U,2)))+1,ZCOM($P(ZLN,U,2),ZCOM($P(ZLN,U,2)))=$P(@ZBUSA@(ZDT,ZR,ZZ),U,3)
 . . Q
 . Q
 ;
 I $D(ZCOM)>9 D
 . S ZR=""  F  S ZR=$O(ZCOM(ZR)) Q:ZR=""  S:ZR="H" @ARRAY@("PAF","M")=ZCOM(ZR) S:ZR="D" @ARRAY@("PAF","D")=ZCOM(ZR)
 . S ZG="",ZG=$O(@ARRAY@("THR","ZZBUSA",ZG),-1),ZG=$S(ZG'="":ZG+1,1:0)
 . S @ARRAY@("THR","ZZBUSA",ZG)="*** Issue found in Pharmacy Order Integrity process, possible system problem."
 . S ZZ="" F  S ZZ=$O(ZCOM(ZZ)) Q:ZZ=""  D
 . . S ZS=$S(ZCOM(ZZ)>1:"s",1:"")
 . . I ZZ="H" D
 . . . S ZG=ZG+1,@ARRAY@("THR","ZZBUSA",ZG)="***     HASH Mismatch found: "
 . . . S ZY="" F  S ZY=$O(ZCOM(ZZ,ZY)) Q:ZY=""  S ZG=ZG+1,@ARRAY@("THR","ZZBUSA",ZG)="***"_$J(" ",10)_ZCOM(ZZ,ZY)
 . . I ZZ="D" D
 . . . S ZG=ZG+1,@ARRAY@("THR","ZZBUSA",ZG)="***     Missing IEN identified:"
 . . . S ZY="" F  S ZY=$O(ZCOM(ZZ,ZY)) Q:ZY=""  S ZG=ZG+1,@ARRAY@("THR","ZZBUSA",ZG)="***"_$J(" ",10)_ZCOM(ZZ,ZY)
 . . Q
 . Q
 Q
 ;
