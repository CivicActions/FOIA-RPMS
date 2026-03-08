AGSSRV ; IHS/ASDS/EFG - REPORT WRITER #2 ; 
 ;;7.0;IHS PATIENT REGISTRATION;**2**;MAR 28, 2003
 ;
 ; report SSNs verified
 K AGSSDT
 Q:'$D(AGSSP("V"))  ;this report not indicated
 ;crossreferences used
LOAD ;EP load crossreference into ^AGSTEMP
 ;gather dfns from "AS" cross reference(s)
 K ^AGSTEMP(AGSS("JOBID"),"RV")
 S AGSDFN=0,AGSSC("V")=0 F  S AGSDFN=$O(^AUPNPAT("AS",1,AGSDFN)) Q:'AGSDFN  Q:$G(DUOUT)  I $D(^DPT(AGSDFN)) S AGSSC("V")=AGSSC("V")+1 I AGSSP("V")="C" S ^AGSTEMP(AGSS("JOBID"),"RV",$P(^DPT(AGSDFN,0),U),AGSDFN)=""
 S ^AGSTEMP(AGSS("JOBID"),"RV")=AGSSC("V")
 Q
PRINT ;EP
 Q:'$D(AGSSP("V"))
 I '$D(AGSSC("V")) S AGSSC("V")=$G(^AGSTEMP(AGSS("JOBID"),"RV"))
 ;S AGSSITE=$P(^AUTTSITE(1,0),U)  ; IHS/SD/EFG  AG*7*2  #17
 S AGSLVC="V",AGSSPG=1,AGSCREC="",AGSGLO="RV"
 S AGSSHDR="SSNs VERIFIED " D AGSSHDR^AGSSPRT
 ;W !!,"The number of ",AGSSHDR,"  is  ",AGSSC("V"),!  ; IHS/SD/EFG  AG*7*2  #17
 W !!,"The number of ",AGSSHDR,"  is  ",$G(^AGSSTEMP(AGSSITE,"TOT","RV")),!  ; IHS/SD/EFG  AG*7*2  #17
 Q:(AGSSP("V")'="C")!(AGSSC("V")=0)  ;----
 D AGSSHD^AGSSPRT
 D ^AGSSPRT
 Q
