AGSSRD ; IHS/ASDS/EFG - REPORT WRITER #2 ;  
 ;;7.0;IHS PATIENT REGISTRATION;**2**;MAR 28, 2003
 ;
 ; report 'D' SSA SSNs match but patient data differs
 K AGSSDT
 Q:'$D(AGSSP("D"))  ;this report not indicated
 ;crossreferences used
LOAD ;EP load crossreference into ^AGSTEMP
 ;gather dfns from "AS" cross reference(s)
 K ^AGSTEMP(AGSS("JOBID"),"RD")
 S DFN=0,AGSSC("D")=0 F  S DFN=$O(^AUPNPAT("AS",4,DFN)) Q:'DFN  I $D(^DPT(DFN)) S AGSSC("D")=AGSSC("D")+1 I AGSSP("D")="C" D
 .S AGSCREC=$G(^AGSSTEMP(AGSSITE,"RD",DFN)),^AGSTEMP(AGSS("JOBID"),"RD",$P(^DPT(DFN,0),U),DFN)=AGSCREC
 S ^AGSTEMP(AGSS("JOBID"),"RD")=AGSSC("D")
 Q
PRINT ;EP
 Q:'$D(AGSSP("D"))
 ;S AGSSITE=$P(^AUTTSITE(1,0),U)  ; IHS/SD/EFG  AG*7*2  #17
 I '$D(AGSSC("D")) S AGSSC("D")=$G(^AGSTEMP(AGSS("JOBID"),"RD"))
 S AGSLVC="D",AGSSPG=1,AGSGLO="RD"
 S AGSSHDR="'SSA Patient Data Differs but SSNs Match'" D AGSSHDR^AGSSPRT
SPRINT ;W !!,"The number of ",AGSSHDR,"  is  ",AGSSC("D"),!  ; IHS/SD/EFG  AG*7*2  #17
 W !!,"The number of ",AGSSHDR,"  is  ",$G(^AGSSTEMP(AGSSITE,"TOT","RD")),!  ; IHS/SD/EFG  AG*7*2  #17
 Q:(AGSSP("D")'="C")!(AGSSC("D")=0)  ;----
 D AGSSHD^AGSSPRT
 D ^AGSSPRT
 Q
