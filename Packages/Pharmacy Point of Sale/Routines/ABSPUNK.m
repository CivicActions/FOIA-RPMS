ABSPUNK ; /IHS/SD/SDR - ABSP Unknown PAY STATUS claim REPORT ; 12/18/2024 ;
 ;;1.0;PHARMACY POINT OF SALE;**56**;01 JUN 2001;Build 131
 ;IHS/SD/SDR 1.0*56 ADO122824 New routine
 Q
EN ;
 K ^XTMP("ABSP-UNKC",$J)
 K ABSPY
 D ^XBFMK
 S U="^"
 ;
 W $$EN^ABSPVDF("IOF")
 W !!,?2,"This option is an effort to create a Pharmacy Point of Sale claim for"
 W !?2,"prescriptions within a selected date range that have a PAY STATUS of"
 W !?2,"'Unknown Claim Status'."
 W !!,"This option will do two things:"
 W !,"1. Based on the selected date range (maximum of T-365 thru Today), report all"
 W !?3,"prescriptions that have a PAY STATUS of 'Unknown Claim Status'. The user"
 W !?3,"will be able to print the report to either a printer or create a delimited"
 W !?3,"file."
 W !!,"2. You will be prompted if you want to continue to the second step, creating"
 W !?3,"Pharmacy Point of Sale claims for the reported prescriptions. If you"
 W !?3,"continue, the above identified prescriptions will be reprocessed and attempt"
 W !?3,"to create Pharmacy Point of Sale claims."
 W !!!,$$EN^ABSPVDF("RVN")
 W "NOTE: "
 W $$EN^ABSPVDF("RVF")
 W "The second step of this option should be run during "
 W $$EN^ABSPVDF("RVN")
 W "NON-PEAK HOURS"
 W $$EN^ABSPVDF("RVF")
 W !?6,"Running it during peak hours may slow down the system and could cause"
 W !?6,"new entries to fall onto this report."
 W !!?2,"Step #2 can only be run once a day, to minimize the effect on daily"
 W !?2,"operations as much as possible, since it could slow the system down for"
 W !?2,"the person filling prescriptions and printing labels."
 D PAZ^ABSPCORR
 ;
 I $P($G(^ABSP(9002313.99,1,0)),U,5)=DT D
 .W !!?2,"Processing these Unknown PAY STATUS prescriptions has already run today"
 .W !?2,"for date range "_$$Y2KDT^ABSPUTL($P($G(^ABSP(9002313.99,1,0)),U,6))
 .W " to "_$$Y2KDT^ABSPUTL($P($G(^ABSP(9002313.99,1,0)),U,7))_", and can NOT be run again today."
 ;
 D DT  ;prompt for date range
 Q:$D(DIRUT)
 ;
 W !!,"Searching..."
 D COMPUTE
 ;
 D OUTPUT  ;prompt for simple or delimited output
 Q:$D(DIRUT)
 D DEVICE  ;prompt for either device OR path,filename
 Q:$D(DIRUT)
 Q:$G(POP)
 D PROCESS  ;this will send the found prescriptions back to ABSP
 Q
DT ;
 Q:$D(DIRUT)
 W !!," ============ Entry of PRESCRIPTION FILL DATE Range =============",!
 S DIR("A")="Enter STARTING FILL DATE for the Report"
 ;only allow them to go back 365 days from today
 S X1=DT
 S X2=-365
 D C^%DTC
 S ABSPTM=X
 S DIR(0)="DO^"_ABSPTM_":DT:EP"
 D ^DIR
 G DT:$D(DIRUT)
 S ABSPY("DT",1)=Y
 W !
 S DIR("A")="Enter ENDING FILL DATE for the Report"
 S DIR(0)="DO^:DT:EP"
 D ^DIR
 K DIR
 G DT:$D(DIRUT)
 S ABSPY("DT",2)=Y
 I ABSPY("DT",1)>ABSPY("DT",2) W !!,*7,"INPUT ERROR: Start Date is Greater than than the End Date, TRY AGAIN!",!! G DT
 Q
OUTPUT ;EP
 K DIR
 S DIR(0)="SO^1:Simple Output;2:Delimited Output"
 S DIR("A")="Select TYPE of LISTING"
 D ^DIR
 K DIR
 Q:$D(DIRUT)
 S ABSPY("RTYP")=Y
 S ABSPY("RTYP","NM")=Y(0)
 Q
DEVICE ;
 U IO
 I ABSPY("RTYP")=2 D  Q  ;delimited
 .;ask path and filename
 .K DIR
 .S DIR(0)="F"
 .S DIR("A")="Path"
 .D ^DIR
 .K DIR
 .Q:$D(DIRUT)
 .S ABSP("RPATH")=Y
 .K DIR
 .S DIR(0)="F"
 .S DIR("A")="Filename"
 .D ^DIR
 .K DIR
 .Q:$D(DIRUT)
 .S ABSP("RFN")=Y
 .;D COMPUTE
 .D PRINT
 ;
 ;simple
 S %ZIS("A")="Output DEVICE: "
 S %ZIS="PQ"
 D ^%ZIS
 G XIT:POP
 I IO'=IO(0),IOT'="HFS" D  Q
 .D QUE
 .D HOME^%ZIS
 W:'$D(IO("S")) !!,"Printing..."
 ;D COMPUTE
 D PRINT
 Q
QUE ;
 I IO=IO(0) W !,"Cannot Queue to Screen or Slave Printer!",! G DEVICE
 S ZTRTN="TSK^ABSPUNK"
 S ZTDESC="ABSP Unknown Pay Status Claims Report"
 S ZTSAVE("ABSP*")=""
 K ZTSK
 D ^%ZTLOAD
 D ^%ZISC
 I $D(ZTSK) W !,"(Job Queued, Task Number: ",ZTSK,")"
 G XIT
 Q
TSK ;
 S ABSP("Q")=""
 D COMPUTE
 D PRINT
 Q
COMPUTE ;  ^ABSPT( - ABSP Transaction file
 S ABSPSDT=ABSPY("DT",1)-.000001
 S ABSPEDT=ABSPY("DT",2)+.999999
 S ABSPY("CNT")=0
 F  S ABSPSDT=$O(^PSRX("AD",ABSPSDT)) Q:'ABSPSDT!(ABSPSDT'<ABSPEDT)  D
 .S ABSPIEN=0
 .F  S ABSPIEN=$O(^PSRX("AD",ABSPSDT,ABSPIEN)) Q:(ABSPIEN="")  D
 ..S ABSPIEN("RF")=-1  ;start at -1 because '0' is for the initial prescription
 ..F  S ABSPIEN("RF")=$O(^PSRX("AD",ABSPSDT,ABSPIEN,ABSPIEN("RF"))) Q:(ABSPIEN("RF")="")  D
 ...;only want UNKNOWN CLAIM STATUS
 ...S ABSPUNK=0
 ...I ($P($G(^PSRX(ABSPIEN,9999999)),U,8)["UNKNOWN CLAIM STATUS") S ABSPUNK=1
 ...I ($P($G(^PSRX(ABSPIEN,1,ABSPIEN("RF"),9999999)),U,8)["UNKNOWN CLAIM STATUS") S ABSPUNK=1
 ...Q:ABSPUNK=0  ;stop if neither have UNKNOWN
 ...S ABSPBUSA(1)=$P($G(^PSRX(ABSPIEN,0)),U,2)
 ...S ABSP("BUSA")=$$LOG^BUSAAPI("A","P","P","ABSPUNK","ABSP: Unknown Pay Status Claims Report","ABSPBUSA")
 ...S ABSP("NM")=$P($G(^DPT($P($G(^PSRX(ABSPIEN,0)),U,2),0)),U)  ;patient name
 ...S ^XTMP("ABSP-UNKC",$J,ABSP("NM"),ABSPSDT,ABSPIEN,ABSPIEN("RF"))=""
 ...S ABSPY("CNT")=ABSPY("CNT")+1
 ...D DOTS^ABSPUTL(ABSPY("CNT"))
 ;D PRINT  ;print selected output
 Q
PRINT ;
 I ABSPY("RTYP")=2 D DELIMIT Q  ;delimited output
 S ABSPY("PG")=1
 S ABSP("BUSA")=$$LOG^BUSAAPI("A","S","","ABSPUNK","ABSP: Unknown Pay Status Claims Report","")
 D WHDR
 S ABSPNM=""
 F  S ABSPNM=$O(^XTMP("ABSP-UNKC",$J,ABSPNM)) Q:($G(ABSPNM)="")  D
 .S ABSPSDT=0
 .F  S ABSPSDT=$O(^XTMP("ABSP-UNKC",$J,ABSPNM,ABSPSDT)) Q:'ABSPSDT  D  Q:$D(DIRUT)
 ..S ABSPIEN=0
 ..F  S ABSPIEN=$O(^XTMP("ABSP-UNKC",$J,ABSPNM,ABSPSDT,ABSPIEN)) Q:ABSPIEN=""  D  Q:$D(DIRUT)
 ...S ABSPIEN("RF")=-1
 ...F  S ABSPIEN("RF")=$O(^XTMP("ABSP-UNKC",$J,ABSPNM,ABSPSDT,ABSPIEN,ABSPIEN("RF"))) Q:(ABSPIEN("RF")="")  D  Q:$D(DIRUT)
 ....I $Y>(IOSL-5) D PAZ Q:$D(DIRUT)  D WHDR Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W !," (cont.)",!
 ....W !,"Patient: "_ABSPNM
 ....W !,"Chart Number: "_$P($G(^AUPNPAT($P($G(^PSRX(ABSPIEN,0)),U,2),41,DUZ(2),0)),U,2)
 ....W !,"RX Number:"_$P($G(^PSRX(ABSPIEN,0)),U) ;RX Number
 ....W !,"RX IEN: "_ABSPIEN  ;RX IEN
 ....W !,"Drug: "_$P($G(^PSDRUG($P($G(^PSRX(ABSPIEN,0)),U,6),0)),U)  ;DRUG
 ....W !,"Fill Date: "_$$HUMDTIME^ABSPUTL(ABSPSDT)  ;date and time
 ....W !,"Error Message: "_$S($P($G(^PSRX(ABSPIEN,1,ABSPIEN("RF"),9999999)),U,8)'="":$P(^(9999999),U,8),1:$P($G(^PSRX(ABSPIEN,9999999)),U,8))
 ....W !
 ....F ABSP=1:1:50 W "-"
 W !!,"TOTAL Prescriptions found: "_+$G(ABSPY("CNT"))
 W !!,"E N D   O F   R E P O R T",!
 D PAZ
 Q
WHDR ;
 W $$EN^ABSPVDF("IOF")
 W !,"WARNING: Confidential Patient Information, Privacy Act Applies",!
 D NOW^%DTC
HDR ;
 W !,"Unknown Pay Status Claims Report",?50 S Y=% X ^DD("DD") W Y,$S($G(ABSPY("RTYP"))=1:"  Page "_ABSPY("PG"),1:""),!
 S ABSPY("PG")=+$G(ABSPY("PG"))+1
 I $G(ABSPY("RTYP"))=1 F ABSP=1:1:50 W "-"
 Q
DELIMIT ;
 D OPEN^%ZISH("ABSP",ABSP("RPATH"),ABSP("RFN"),"W")
 Q:POP
 U IO
 D WHDR
 W !,"Patient^Chart Number^RX#^RXIEN^Drug^Fill Date^Error Message"
 S ABSPNM=""
 F  S ABSPNM=$O(^XTMP("ABSP-UNKC",$J,ABSPNM)) Q:($G(ABSPNM)="")  D
 .S ABSPSDT=0
 .F  S ABSPSDT=$O(^XTMP("ABSP-UNKC",$J,ABSPNM,ABSPSDT)) Q:'ABSPSDT  D
 ..S ABSPIEN=0
 ..F  S ABSPIEN=$O(^XTMP("ABSP-UNKC",$J,ABSPNM,ABSPSDT,ABSPIEN)) Q:ABSPIEN=""  D
 ...S ABSPIEN("RF")=-1
 ...F  S ABSPIEN("RF")=$O(^XTMP("ABSP-UNKC",$J,ABSPNM,ABSPSDT,ABSPIEN,ABSPIEN("RF"))) Q:(ABSPIEN("RF")="")  D
 ....W !,ABSPNM_U  ;patient name
 ....W $P($G(^AUPNPAT($P($G(^PSRX(ABSPIEN,0)),U,2),41,DUZ(2),0)),U,2)_U  ;HRN
 ....W $P($G(^PSRX(ABSPIEN,0)),U)_U  ;RX#
 ....W ABSPIEN_U   ;RXIEN
 ....W $P($G(^PSDRUG($P($G(^PSRX(ABSPIEN,0)),U,6),0)),U)_U  ;DRUG
 ....W $$Y2KDT^ABSPUTL(ABSPSDT)_U  ;FILL DATE
 ....W $S($P($G(^PSRX(ABSPIEN,1,ABSPIEN("RF"),9999999)),U,8)'="":$P(^(9999999),U,8),1:$P($G(^PSRX(ABSPIEN,9999999)),U,8))  ;Error Message
 W !!,"E N D   O F   R E P O R T",!
 D CLOSE^%ZISH("ABSP")
 U 0
 Q
PROCESS ;
 I $P($G(^ABSP(9002313.99,1,0)),U,5)[DT D  Q  ;if it is today, write message and quit
 .W !!,"Reprocessing of prescriptions has already run today. Please try again tomorrow."
 .D PAZ
 ;
 I +$G(ABSPY("CNT"))=0 D  Q  ;no claims were found in selected date range
 .W !!?2,"No presriptions were found with UNKNOWN PAY STATUS for date range selected"
 .W !?2,"so there is nothing to process....Exiting..."
 .D PAZ
 ;
 W $$EN^ABSPVDF("IOF")
 W !!?2,"It is now going to create Pharmacy Point of Sale claims for all prescriptions"
 W !?2,"identified on this report. It could take a few minutes, depending on how many"
 W !?2,"were identified. You will not have the option to exit until it is complete."
 W !!
 D ^XBFMK
 S ABSPANS=$$YESNO^ABSPOSU3("ARE YOU SURE YOU WANT TO CONTINUE WITH THIS PROCESS (YES/NO)","",0,DTIME)
 I ABSPANS<1 W !!,"Exiting..." Q  ;User either say NO or it timed out
 ;
 ;if it gets here we are going to process the claims found
 W !!,"Ok, processing claims..."
 ;
 ;Set UNKC dates for this run
 D ^XBFMK
 S DIE="^ABSP(9002313.99,"
 S DA=1
 D NOW^%DTC
 S DR="6001////"_%_";6002////"_ABSPY("DT",1)_";6003////"_ABSPY("DT",2)
 D ^DIE
 ;
 ;this is to keep a log of what was processed, in case they don't save the rpt so we can look at the last seven processes
 S ABSPCNT=+$G(^ABSPTMP("CNT"))  ;there will only be seven entries at most
 I ABSPCNT=7 S ABSPCNT=0  ;this is so it will only keep the last seven times, so the 8th will be the new 1st
 S ABSPCNT=ABSPCNT+1
 S ^ABSPTMP("CNT")=ABSPCNT
 K ^ABSPTMP(ABSPCNT)  ;delete whatever was at this counter before
 S ^ABSPTMP(ABSPCNT)=DUZ_U_DT
 M ^ABSPTMP(ABSPCNT,"ABSP-UNKC")=^XTMP("ABSP-UNKC",$J)
 ;
 S ABSPNM="",ABSPCNT=0
 F  S ABSPNM=$O(^XTMP("ABSP-UNKC",$J,ABSPNM)) Q:($G(ABSPNM)="")  D
 .S ABSPSDT=0
 .F  S ABSPSDT=$O(^XTMP("ABSP-UNKC",$J,ABSPNM,ABSPSDT)) Q:'ABSPSDT  D
 ..S ABSPIEN=0
 ..F  S ABSPIEN=$O(^XTMP("ABSP-UNKC",$J,ABSPNM,ABSPSDT,ABSPIEN)) Q:ABSPIEN=""  D
 ...S ABSPIEN("RF")=-1
 ...F  S ABSPIEN("RF")=$O(^XTMP("ABSP-UNKC",$J,ABSPNM,ABSPSDT,ABSPIEN,ABSPIEN("RF"))) Q:(ABSPIEN("RF")="")  D
 ....S ABSPCNT=ABSPCNT+1
 ....D DOTS^ABSPUTL(ABSPCNT)
 ....;clear the PAY STATUS in the Prescription file to make sure it updates w/whatever new status is
 ....D ^XBFMK
 ....S DIE="^PSRX("
 ....S DA=ABSPIEN
 ....S DR="9999999.08////@"
 ....D ^DIE
 ....I ABSPIEN("RF")'=0 D  ;this means it is a refill, not the initial RX
 .....D ^XBFMK
 .....S DA(1)=ABSPIEN
 .....S DA=ABSPIEN("RF")
 .....S DIE="^PSRX("_DA(1)_",1,"
 .....S DR="9999999.08////@"
 .....D ^DIE
 ....;
 ....;set vars and call ABSP entry point to create claim
 ....S RXI=ABSPIEN
 ....S RXR=ABSPIEN("RF")
 ....D CLAIM^ABSPOSRX(RXI,RXR,"")
 W !!,"Done."
 Q
PAZ ;
 I '$D(IO("Q")),$E(IOST)="C",'$D(IO("S")) D
 .F  W ! Q:$Y+3>IOSL
 .K DIR
 .S DIR(0)="E"
 .D ^DIR
 .K DIR
 Q
 ;
XIT ;
 K ABSP,DIQ
 Q
