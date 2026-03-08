ABSPCORR ; /IHS/SD/SDR - ABSP CORRUPTED REPORT ; 12/18/2024 ;
 ;;1.0;PHARMACY POINT OF SALE;**55,56**;01 JUN 2001;Build 131
 ;IHS/SD/SDR 1.0*55 ADO115325 New routine
 ;IHS/SD/SDR 1.0*56 ADO120125 Fix <NOLINE>QUE^ABSPCORR error when printing to printer
 Q
EN ;
 K ^XTMP("ABSP-CRPT",$J)
 K ABSPY
 D ^XBFMK
 S U="^"
 D DT  ;prompt for date range
 Q:$D(DIRUT)
 D OUTPUT  ;prompt for simple or delimited output
 Q:$D(DIRUT)
 D DEVICE  ;prompt for either device OR path,filename
 Q:$D(DIRUT)
 Q:$G(POP)
 ;D COMPUTE  ;figure entries  ;absp*1.0*56 IHS/SD/SDR ADO120125
 ;D PRINT  ;print selected output  ;absp*1.0*56 IHS/SD/SDR ADO120125
 Q
DT ;
 Q:$D(DIRUT)
 W !!," ============ Entry of TRANSACTION LAST UPDATED Range =============",!
 S DIR("A")="Enter STARTING TRANSACTION LAST UPDATED for the Report"
 S DIR(0)="DO^:DT:EP"
 D ^DIR
 G DT:$D(DIRUT)
 S ABSPY("DT",1)=Y
 W !
 S DIR("A")="Enter ENDING DATE for the Report"
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
 ;start old absp*1.0*56 IHS/SD/SDR ADO120125
 ;I ABSPY("RTYP")=1 D  Q  ;simple
 ;.S %ZIS("A")="Output DEVICE: "
 ;.S %ZIS="PQ"
 ;.D ^%ZIS
 ;.G XIT:POP
 ;.I IO'=IO(0),IOT'="HFS" D  Q
 ;..D QUE2
 ;..D HOME^%ZIS
 ;.U IO(0)
 ;.W:'$D(IO("S")) !!,"Printing..."
 ;end old absp*1.0*56 IHS/SD/SDR ADO120125
 U IO
 ;I ABSPY("RTYP")=2 D  ;delimited  ;absp*1.0*56 IHS/SD/SDR ADO120125
 I ABSPY("RTYP")=2 D  Q  ;delimited  ;absp*1.0*56 IHS/SD/SDR ADO120125
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
 .D COMPUTE  ;absp*1.0*56 IHS/SD/SDR ADO120125
 ;start new absp*1.0*56 IHS/SD/SDR ADO120125
 ;simple
 S %ZIS("A")="Output DEVICE: "
 S %ZIS="PQ"
 D ^%ZIS
 G XIT:POP
 I IO'=IO(0),IOT'="HFS" D  Q
 .D QUE
 .D HOME^%ZIS
 .;U IO(0)
 W:'$D(IO("S")) !!,"Printing..."
 D COMPUTE
 ;end new absp*1.0*56 IHS/SD/SDR ADO120125
 Q
 ;start new absp*1.0*56 IHS/SD/SDR ADO120125
QUE ;
 I IO=IO(0) W !,"Cannot Queue to Screen or Slave Printer!",! G DEVICE
 S ZTRTN="TSK^ABSPCORR"
 S ZTDESC="ABSP Corrupted Report"
 F ABSP="ZTRTN","ZTDESC","ABSPY(" S ZTSAVE(ABSP)=""
 D ^%ZTLOAD
 D ^%ZISC
 I $D(ZTSK) W !,"(Job Queued, Task Number: ",ZTSK,")"
 G XIT
 Q
TSK ;
 S ABMP("Q")=""
 D COMPUTE
 Q
 ;end new absp*1.0*56 IHS/SD/SDR ADO120125
COMPUTE ;  ^ABSPT( - ABSP Transaction file
 S ABSPSDT=ABSPY("DT",1)-.000001
 S ABSPEDT=ABSPY("DT",2)+.999999
 F  S ABSPSDT=$O(^ABSPT("AH",ABSPSDT)) Q:'ABSPSDT!(ABSPSDT'<ABSPEDT)  D
 .S ABSPIEN=0
 .F  S ABSPIEN=$O(^ABSPT("AH",ABSPSDT,ABSPIEN)) Q:'ABSPIEN  D
 ..I "^12^6501^"'[("^"_$P($G(^ABSPT(ABSPIEN,2)),U)_"^") Q  ;only want result code 12 OR 6501
 ..S ABSPBUSA(1)=$P($G(^ABSPT(ABSPIEN,0)),U,6)
 ..S ABSP("BUSA")=$$LOG^BUSAAPI("A","P","P","ABSPCORR","ABSP: Corrupt Response/Broken PCC Link Report","ABSPBUSA")
 ..S ABSP("NM")=$P($G(^DPT($P($G(^ABSPT(ABSPIEN,0)),U,6),0)),U)  ;patient name
 ..S ^XTMP("ABSP-CRPT",$J,ABSPSDT,ABSP("NM"),ABSPIEN)=""
 D PRINT  ;print selected output  ;absp*1.0*56 IHS/SD/SDR ADO120125
 Q
PRINT ;
 I ABSPY("RTYP")=2 D DELIMIT Q  ;delimited output
 S ABSPY("PG")=1
 S ABSP("BUSA")=$$LOG^BUSAAPI("A","S","","ABSPCORR","ABSP: Corrupt Response/Broken PCC Link Report","")
 W $$EN^ABSPVDF("IOF")
 D WHDR
 S ABSPSDT=0
 F  S ABSPSDT=$O(^XTMP("ABSP-CRPT",$J,ABSPSDT)) Q:'ABSPSDT  D  Q:$D(DIRUT)
 .S ABSPNM=""
 .F  S ABSPNM=$O(^XTMP("ABSP-CRPT",$J,ABSPSDT,ABSPNM)) Q:ABSPNM=""  D  Q:$D(DIRUT)
 ..S ABSPIEN=0
 ..F  S ABSPIEN=$O(^XTMP("ABSP-CRPT",$J,ABSPSDT,ABSPNM,ABSPIEN)) Q:'ABSPIEN  D  Q:$D(DIRUT)
 ...I $Y>(IOSL-5) D PAZ Q:$D(DIRUT)  D WHDR Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W !," (cont.)",!
 ...W !,"Patient: "_ABSPNM
 ...W !,"Chart Number: "_$P($G(^AUPNPAT($P($G(^ABSPT(ABSPIEN,0)),U,6),41,DUZ(2),0)),U,2)
 ...W !,"Drug: "_$P($G(^PSDRUG($P($G(^PSRX($P($G(^ABSPT(ABSPIEN,1)),U,11),0)),U,6),0)),U)  ;DRUG
 ...W !,"Transaction Last Updated: "_$$HUMDTIME^ABSPUTL($P($G(^ABSPT(ABSPIEN,0)),U,8))  ;date and time
 ...W !,"Transaction Text: "_$E($P($G(^ABSPT(ABSPIEN,2)),U,2),1,60)
 ...W !,"Transaction Code: "_$P($G(^ABSPT(ABSPIEN,2)),U)
 ...W !
 ...F ABSP=1:1:50 W "-"
 W !!,"E N D   O F   R E P O R T",!
 ;D ^%ZISC  ;absp*1.0*56 IHS/SD/SDR ADO120125
 ;U 0  ;absp*1.0*56 IHS/SD/SDR ADO120125
 Q
WHDR ;
 ;W $$EN^ABSPVDF("IOF")  ;absp*1.0*56 IHS/SD/SDR ADO120125
 W !,"WARNING: Confidential Patient Information, Privacy Act Applies",!
 D NOW^%DTC
HDR ;
 W !,"Corrupted Response/Broken PCC Link Report",?50 S Y=% X ^DD("DD") W Y,$S($G(ABSPY("RTYP"))=1:"  Page "_ABSPY("PG"),1:""),!
 S ABSPY("PG")=+$G(ABSPY("PG"))+1
 I $G(ABSPY("RTYP"))=1 F ABSP=1:1:50 W "-"
 Q
DELIMIT ;
 D OPEN^%ZISH("ABSP",ABSP("RPATH"),ABSP("RFN"),"W")
 Q:POP
 U IO  ;absp*1.0*56 IHS/SD/SDR ADO120125
 D WHDR
 W !,"Patient^Chart Number^DOB^RX#^Drug^Transaction Last Updated^Transaction Text^Transaction Code"
 S ABSPSDT=0
 F  S ABSPSDT=$O(^XTMP("ABSP-CRPT",$J,ABSPSDT)) Q:'ABSPSDT  D
 .S ABSPNM=""
 .F  S ABSPNM=$O(^XTMP("ABSP-CRPT",$J,ABSPSDT,ABSPNM)) Q:ABSPNM=""  D
 ..S ABSPIEN=0
 ..F  S ABSPIEN=$O(^XTMP("ABSP-CRPT",$J,ABSPSDT,ABSPNM,ABSPIEN)) Q:'ABSPIEN  D
 ...W !,ABSPNM_U  ;patient name
 ...W $P($G(^AUPNPAT($P($G(^ABSPT(ABSPIEN,0)),U,6),41,DUZ(2),0)),U,2)_U  ;HRN
 ...W $$Y2KDT^ABSPUTL($P($G(^DPT($P($G(^ABSPT(ABSPIEN,0)),U,6),0)),U,3))_U  ;DOB
 ...W $P($G(^PSRX($P($G(^ABSPT(ABSPIEN,1)),U,11),0)),U)_U  ;RX#
 ...W $P($G(^PSDRUG($P($G(^PSRX($P($G(^ABSPT(ABSPIEN,1)),U,11),0)),U,6),0)),U)_U  ;DRUG
 ...W $$Y2KDT^ABSPUTL(ABSPSDT)_U  ;transaction last updated
 ...W $E($P($G(^ABSPT(ABSPIEN,2)),U,2),1,60)_U  ;transaction text
 ...W $P($G(^ABSPT(ABSPIEN,2)),U)  ;Transaction Code
 W !!,"E N D   O F   R E P O R T",!
 D CLOSE^%ZISH("ABSP")
 U 0  ;absp*1.0*56 IHS/SD/SDR ADO120125
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
 K ABSP,DIQ  ;absp*1.0*56 IHS/SD/SDR ADO120125
 Q
