BEHOEPR4 ;GDIT/HS/TJB - EPCS Audit Summary Report;26-Jan-2023 13:39;PLS
 ;;1.1;BEH COMPONENTS;**070001,070003,070005**;Mar 20, 2007;Build 10
 ;
 ; Utility items moved here to reduce the size of the routine
 Q
 ;
TRIP(ARRAY,RPTDT) ; Check the array for any tripped thresholds
 N XX,VAR,ZDT,ZR,ZZ,ZY,ZS,ZCOM,ZCNT,ZBUSA,ZLN,TWOYRS S XX=""
 S:$G(RPTDT)="" RPTDT=$$NOW^XLFDT
 D GETVARS^BEHOEPR2("VAR")
 S XX=$S(+$G(@ARRAY@("L"))>0:$$ROUND^BEHOEPR2(((+$G(@ARRAY@("L","F"))/@ARRAY@("L"))*100),2),1:"-")
 I XX'<VAR("LOGIN") S @ARRAY@("THR","LOGIN",0)="*** Excessive Failed verify code attempts. This could indicate an attempt to",@ARRAY@("THR","LOGIN",1)="***  brute force verify codes."
 S XX=""
 S XX=$S(+$G(@ARRAY@("MFA"))>0:$$ROUND^BEHOEPR2(((+$G(@ARRAY@("MFA","F"))/@ARRAY@("MFA"))*100),2),1:"-")
 I +XX'<VAR("ESIGN") S @ARRAY@("THR","ESIGN",0)="*** Excessive number of failed multifactor authentication attempts. This could",@ARRAY@("THR","ESIGN",1)="***  indicate an attempt to brute force verify Electronic Signature Code."
 S XX=""
 S XX=$S(+$G(@ARRAY@("ECP"))>0:$$ROUND^BEHOEPR2(((+$G(@ARRAY@("ECP","A"))/@ARRAY@("ECP"))*100),2),1:"-")
 I +XX'<VAR("EAKEY") S @ARRAY@("THR","EAKEY",0)="*** Large percentage of providers added. This could indicate an attempt to",@ARRAY@("THR","EAKEY",1)="***  tamper with system."
 S XX=""
 S XX=$S(+$G(@ARRAY@("ECP"))>0:$$ROUND^BEHOEPR2(((+$G(@ARRAY@("ECP","R"))/@ARRAY@("ECP"))*100),2),1:"-")
 I +XX'<VAR("ECPR") S @ARRAY@("THR","ECPR",0)="*** Large percentage of providers removed. This could indicate an attempt to",@ARRAY@("THR","ECPR",1)="***  tamper with system."
 S XX=""
 S XX=$S(+$G(@ARRAY@("ECK","A"))+$G(@ARRAY@("ECK","R"))>0:$$ROUND^BEHOEPR2(((+$G(@ARRAY@("ECK","A"))/(+$G(@ARRAY@("ECK","A"))+$G(@ARRAY@("ECK","R"))))*100),2),1:"-")
 I +XX'<VAR("EDKEY") S @ARRAY@("THR","EDKEY",0)="*** Large percentage of pharmacists added. This could indicate an attempt to",@ARRAY@("THR","EDKEY",1)="***  tamper with system."
 S XX=""
 S XX=$S(+$G(@ARRAY@("ECV"))>0:$$ROUND^BEHOEPR2(((+$G(@ARRAY@("ECV","A"))/@ARRAY@("ECV"))*100),2),1:"-")
 I +XX'<VAR("ECVA") S @ARRAY@("THR","ECVA",0)="*** Large percentage of assigned/verified provider profiles events. This could",@ARRAY@("THR","ECVA",1)="***  indicate an attempt to tamper with system."
 S XX=""
 S XX=$S(+$G(@ARRAY@("ECV"))>0:$$ROUND^BEHOEPR2(((+$G(@ARRAY@("ECV","F"))/@ARRAY@("ECV"))*100),2),1:"-")
 I +XX'<VAR("ECVF") S @ARRAY@("THR","ECVF",0)="*** Large percentage of failed verify provider profiles events. This could",@ARRAY@("THR","ECVF",1)="***  indicate an attempt to tamper with system."
 S XX=""
 ;GDIT/HS/BEE;FEATURE#76005;EHR*1.1*35;Change formula
 ;S XX=$S(+$G(@ARRAY@("EPX","I"))>0:$$ROUND^BEHOEPR2(((+$G(@ARRAY@("EPX","C"))/@ARRAY@("EPX","I"))*100),2),1:"-")
 S XX=$S(+$G(@ARRAY@("EPX","T"))>0:$$ROUND^BEHOEPR2(((+$G(@ARRAY@("EPX","C"))/@ARRAY@("EPX","T"))*100),2),1:"-")
 S ^BXE("EPXC")=XX
 I +XX'<VAR("EPXC") S @ARRAY@("THR","EPXC",0)="*** Large percentage of cancelled order events. This could indicate",@ARRAY@("THR","EPXC",1)="***  an attempt to tamper with system."
 S XX=""
 S XX=$S(+$G(@ARRAY@("EST","F"))>0:$$ROUND^BEHOEPR2(((+$G(@ARRAY@("EST","F"))/@ARRAY@("EST","T"))*100),2),1:"-")
 I +XX'<VAR("ESTF") S @ARRAY@("THR","ESTF",0)="*** Excessive number of failed time synchronization checks. Indicates a possible",@ARRAY@("THR","ESTF",1)="***  configuration issue with time checks."
 I +$G(@ARRAY@("EST","F3"))>0 S @ARRAY@("THR","EST3",0)="*** Time drift is exceeding +/- 3 minutes. Indicates a possible",@ARRAY@("THR","EST3",1)="***  issue with time synchronization."
 I +$G(@ARRAY@("EST","F5"))>0 S @ARRAY@("THR","EST5",0)="*** Time drift is exceeding +/- 5 minutes. Indicates system may",@ARRAY@("THR","EST5",1)="***  no longer be in compliance with DEA time synchronization regulations."
 S XX=""
 S XX=$S(+$G(@ARRAY@("ECPP"))>0:$$ROUND^BEHOEPR2(((+$G(@ARRAY@("ECPP","C"))/@ARRAY@("ECPP"))*100),2),1:"-")
 I +XX'<VAR("ECPPC") S @ARRAY@("THR","ECPPC",0)="*** Large percentage of created provider profile events. This could indicate",@ARRAY@("THR","ECPPC",1)="***  an attempt to tamper with system."
 S XX=""
 S XX=$S(+$G(@ARRAY@("ECPP"))>0:$$ROUND^BEHOEPR2(((+$G(@ARRAY@("ECPP","R"))/@ARRAY@("ECPP"))*100),2),1:"-")
 I +XX'<VAR("ECPPR") S @ARRAY@("THR","ECPPR",0)="*** Large percentage of removed provider profile events. This could indicate",@ARRAY@("THR","ECPPR",1)="***  an attempt to tamper with system."
 S XX=""
 S XX=$S(+$G(@ARRAY@("ECPP"))>0:$$ROUND^BEHOEPR2(((+$G(@ARRAY@("ECPP","F"))/@ARRAY@("ECPP"))*100),2),1:"-")
 I +XX'<VAR("ECPPF") S @ARRAY@("THR","ECPPF",0)="*** Large percentage of failed provider profile events. This could indicate",@ARRAY@("THR","ECPPF",1)="***  an attempt to tamper with system."
 ; This is an integer value so don't convert to "percentage" by multiplying by 100
 S XX=""
 S XX=$S(+$G(@ARRAY@("ECP"))>0:$$ROUND^BEHOEPR2((+$G(@ARRAY@("ECP","A"))/@ARRAY@("ECP")),2),1:"-")
 I +XX'<VAR("ECKA") S @ARRAY@("THR","ECKA",0)="*** Large number of providers assigned EPCS access. This could indicate",@ARRAY@("THR","ECKA",1)="***  an attempt to tamper with system."
 ; This is an integer value so don't convert to "percentage" by multiplying by 100
 S XX=""
 S XX=$S(+$G(@ARRAY@("ECP"))>0:$$ROUND^BEHOEPR2((+$G(@ARRAY@("ECP","R"))/@ARRAY@("ECP")),2),1:"-")
 I +XX'<VAR("ECKR") S @ARRAY@("THR","ECKR",0)="*** Large number of providers had EPCS access removed. This could indicate",@ARRAY@("THR","ECKR",1)="***  an attempt to tamper with system."
 ; This is an integer value so don't convert to "percentage" by multiplying by 100
 S XX=""
 S XX=$S(+$G(@ARRAY@("EPX","I"))>0:$$ROUND^BEHOEPR2((($G(@ARRAY@("EPX","D"))-$G(@ARRAY@("EPX","I"))))/@ARRAY@("EPX","I"),2),1:"-")
 I +XX'<VAR("EPXDI") S @ARRAY@("THR","EPXDI",0)="*** Excessive number of signed orders as compared to number of orders attempted.",@ARRAY@("THR","EPXDI",1)="***  This could indicate orders are being signed through unauthorized channels."
 ; This is an integer value so don't convert to "percentage" by multiplying by 100
 S XX=""
 S XX=$S(+$G(@ARRAY@("EPX"))>0:$$ROUND^BEHOEPR2((+$G(@ARRAY@("EPX","I"))/@ARRAY@("EPX")),2),1:"-")
 I +XX'<VAR("EPXP") S @ARRAY@("THR","EPXP",0)="*** Large number of created orders per prescribing provider. This could",@ARRAY@("THR","EPXP",1)="***  indicate an attempt to tamper with system."
 S XX=""
 S XX=$S(+$G(@ARRAY@("ESC","U"))>0:$$ROUND^BEHOEPR2(((+$G(@ARRAY@("ESC","U"))/@ARRAY@("ESC"))*100),2),1:"-")
 I +XX'<VAR("ESCU") S @ARRAY@("THR","ESCU",0)="*** Excessive number of failed certificate revocation checks. This could",@ARRAY@("THR","ESCU",1)="*** indicate a configuration issue or possible attempt to tamper with system."
 ;
 I +$G(@ARRAY@("SIA","M"))>0 S @ARRAY@("THR","SIAM",0)="*** HASH code mismatch detected, possible system compromise:" D
 . N QQ S QQ=""
 . F  S QQ=$O(@ARRAY@("SIA","M",QQ)) Q:QQ=""  S @ARRAY@("THR","SIAM",QQ)="***  "_@ARRAY@("SIA","M",QQ)
 . Q
 I ($P($G(@ARRAY@("GST","NIGHT")),U,1)="")!($P($G(@ARRAY@("GST","NIGHT")),U,2)="") D  ; We don't have a matched pair for the nightly task
 . N ZG S ZG=0 S @ARRAY@("THR","ZGST0",0)="*** Mismatch detected in daily integrity check process, possible system problem."
 . S:$P($G(@ARRAY@("GST","NIGHT")),U,1)="" ZG=ZG+1,@ARRAY@("THR","ZGST0",ZG)="***  missing EPCS100 indicator for starting the nightly BUSA compile check."
 . S:$P($G(@ARRAY@("GST","NIGHT")),U,2)="" ZG=ZG+1,@ARRAY@("THR","ZGST0",ZG)="***  missing EPCS101 indicator for completing the nightly BUSA compile check."
 . Q
 I ($P($G(@ARRAY@("GST","BUSA")),U,1)="")!($P($G(@ARRAY@("GST","BUSA")),U,2)="") D  ; We don't have a matched pair for the nightly task
 . N ZG S ZG=0 S @ARRAY@("THR","ZGST8",0)="*** Mismatch detected BUSA audit integrity check, possible system problem."
 . S:$P($G(@ARRAY@("GST","BUSA")),U,1)="" ZG=ZG+1,@ARRAY@("THR","ZGST8",ZG)="***  missing EPCS108 indicator for starting the nightly BUSA compile check."
 . S:$P($G(@ARRAY@("GST","BUSA")),U,2)="" ZG=ZG+1,@ARRAY@("THR","ZGST8",ZG)="***  missing EPCS109 indicator for completing the nightly BUSA compile check."
 . Q
 ;
 ;GDIT/HS/BEE;FEATURE#80147;EHR*1.1*35;Only count last 2 years in totals
 ;Get 2 years in past or first BUSAp1 Install
 S TWOYRS=0 D
 . NEW X1,X2,X
 . S X1=DT,X2=-731
 . D C^%DTC
 . S TWOYRS=X
 ;
 ; Walk ^XTMP("BEHOEPIC", global looking for possible tampering issues
 ;
 S ZDT="",ZR="",ZCNT=0 K ZCOM
 S ZBUSA=$NA(^XTMP("BEHOEPIC","B"))
 S @ARRAY@("SIA")=$P($G(^XTMP("BEHOEPIC","B")),U,6)
 ;GDIT/HS/BEE 04192021;Added $G()
 ;GDIT/HS/BEE;FEATURE#80147;EHR*1.1*35;Only count last 2 years in totals
 ;F  S ZDT=$O(@ZBUSA@(ZDT)) Q:ZDT=""  S ZCNT=ZCNT+$P($G(@ZBUSA@(ZDT)),U,4) D:$D(@ZBUSA@(ZDT))>1
 F  S ZDT=$O(@ZBUSA@(ZDT)) Q:ZDT=""  D:$D(@ZBUSA@(ZDT))>1  I ZDT>TWOYRS S ZCNT=ZCNT+$P($G(@ZBUSA@(ZDT)),U,4)
 . S ZR="" F  S ZR=$O(@ZBUSA@(ZDT,ZR)) Q:ZR=""  D:ZR["E"
 . . S ZZ="" F  S ZZ=$O(@ZBUSA@(ZDT,ZR,ZZ)) Q:ZZ=""  S ZLN=$G(@ZBUSA@(ZDT,ZR,ZZ)) D:ZLN]""
 . . . I $P(ZLN,U,2)'=""  S ZCOM($P(ZLN,U,2))=$G(ZCOM($P(ZLN,U,2)))+1,ZCOM($P(ZLN,U,2),ZCOM($P(ZLN,U,2)))=$P(@ZBUSA@(ZDT,ZR,ZZ),U,1)_U_ZDT
 . . Q
 . Q
 ;
 ;BUSA Integrity Check
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
 . . . S ZY="" F  S ZY=$O(ZCOM(ZZ,ZY)) Q:ZY=""  S ZG=ZG+1,@ARRAY@("THR","ZZBUSA",ZG)="*** Integrity Check Count: "_$J($P(ZCOM(ZZ,ZY),U,1),10)_" Caclulated count: "_$J($P(ZCOM(ZZ,ZY),U,2),10)
 . Q
 ;
 ; EPCS Monitoring Hash Check
 S ZDT="",ZR="",ZCNT=0 K ZCOM
 ;S ZBUSA=$NA(^XTMP("BEHOEPIC","E"))
 S ZBUSA=$NA(@ARRAY@("SIP","ZZ"))
 F  S ZDT=$O(@ZBUSA@(ZDT)) Q:ZDT=""  S ZCOM("E")=$G(ZCOM("E"))+1,ZCOM("E",ZCOM("E"))=ZDT_U_@ZBUSA@(ZDT)
 ;
 I $D(ZCOM("E"))>1 D
 . S ZG="",ZG=$O(@ARRAY@("THR","ZZBUSA",ZG),-1),ZG=$S(ZG'="":ZG+1,1:0)
 . S @ARRAY@("THR","ZZBUSA",ZG)="*** Issue found in EPCS Monitoring Hash Check process, possible system problem."
 . S ZZ="" F  S ZZ=$O(ZCOM("E",ZZ)) Q:ZZ=""  D
 . . S ZR=ZCOM("E",ZZ),ZG=ZG+1,@ARRAY@("THR","ZZBUSA",ZG)="***     Hash Check failed on "_$$FMTE^XLFDT($P(ZR,U,1),"5P")_" for: "_$P($P(ZR,U,2),": ",2)
 . . Q
 . Q
 ;
 ; CS Order Integrity Compile
 S ZDT="",ZR="",ZCNT=0 K ZCOM
 S ZBUSA=$NA(^XTMP("BEHOEPIC","O"))
 ;GDIT/HS/BEE 04192021;Added $G()
 F  S ZDT=$O(@ZBUSA@(ZDT)) Q:ZDT=""  S ZCNT=ZCNT+$P($G(@ZBUSA@(ZDT)),U,4) D:$D(@ZBUSA@(ZDT))>1
 . S ZR="" F  S ZR=$O(@ZBUSA@(ZDT,ZR)) Q:ZR=""  D:ZR["E"
 . . S ZZ="" F  S ZZ=$O(@ZBUSA@(ZDT,ZR,ZZ)) Q:ZZ=""  S ZLN=$G(@ZBUSA@(ZDT,ZR,ZZ)) D:ZLN]""
 . . . I $P(ZLN,U,2)'=""  S ZCOM($P(ZLN,U,2))=$G(ZCOM($P(ZLN,U,2)))+1,ZCOM($P(ZLN,U,2),ZCOM($P(ZLN,U,2)))=$P(@ZBUSA@(ZDT,ZR,ZZ),U,3)
 . . Q
 . Q
 ;
 S @ARRAY@("SIO")=ZCNT
 I $D(ZCOM)>9 D
 . S ZR=""  F  S ZR=$O(ZCOM(ZR)) Q:ZR=""  S:ZR="H" @ARRAY@("SIO","M")=ZCOM(ZR) S:ZR="D" @ARRAY@("SIO","D")=ZCOM(ZR)
 . S ZG="",ZG=$O(@ARRAY@("THR","ZZBUSA",ZG),-1),ZG=$S(ZG'="":ZG+1,1:0)
 . S @ARRAY@("THR","ZZBUSA",ZG)="*** Issue found in CS Order Integrity Compile process, possible system problem."
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
 ;
 Q
 ;
