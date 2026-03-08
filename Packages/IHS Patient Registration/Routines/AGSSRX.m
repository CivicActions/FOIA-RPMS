AGSSRX ; IHS/ASDS/EFG - REPORT WRITER #2 ;  
 ;;7.0;IHS PATIENT REGISTRATION;**2**;MAR 28, 2003
 ;
 ; report SSNs POTENTIAL/PENDING
 K AGSSDT
 Q:'$D(AGSSP("P"))  ;this report not indicated
 ;crossreferences used 5:P
LOAD ;EP load crossreference into ^AGSTEMP
 ;gather dfns from "AS" cross reference(s)
 K ^AGSTEMP(AGSS("JOBID"),"RP")
 S DFN=0,AGSSC("P")=0 F  S DFN=$O(^AUPNPAT("AS",5,DFN)) Q:'DFN  I $D(^DPT(DFN)) S AGSSCREC="" D
 .S AGSSC("P")=AGSSC("P")+1
 .I AGSSP("P")="C" S AGSSCREC=$G(^AGSSTEMP(AGSSITE,"RP",DFN)),^AGSTEMP(AGSS("JOBID"),"RP",$P(^DPT(DFN,0),U),DFN)=AGSSCREC
 S ^AGSTEMP(AGSS("JOBID"),"RP")=AGSSC("P")
 Q
PRINT ;EP
 Q:'$D(AGSSP("P"))
 ;S AGSSITE=$P(^AUTTSITE(1,0),U)  ; IHS/SD/EFG  AG*7*2  #17
 I '$D(AGSSC("P")) S AGSSC("P")=$G(^AGSTEMP(AGSS("JOBID"),"RP"))
 S AGSLVC="P",AGSSPG=1,AGSGLO="RP"
 S AGSSHDR="SSNs POTENTIAL and/or PENDING " D AGSSHDR^AGSSPRT
SPRINT ;W !!,"The number of ",AGSSHDR,"  is  ",AGSSC("P"),!  ; IHS/SD/EFG  AG*7*2  #17
 W !!,"The number of ",AGSSHDR,"  is  ",$G(^AGSSTEMP(AGSSITE,"TOT","RX")),!  ; IHS/SD/EFG  AG*7*2  #17
 Q:(AGSSP("P")'="C")!(AGSSC("P")=0)  ;----
 D AGSSHD^AGSSPRT
 D ^AGSSPRT
 Q
