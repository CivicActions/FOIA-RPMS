APSPPAL1 ;IHS/MSC/PLS - Pickup Activity Log Support ;12-Sep-2024 14:13;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1034,1035**;Sep 23, 2004;Build 39
 ;IHS/MSC/PLS - 07/12/2023 - Original routine
 ;              01/31/2024 - List Template view for menu option added  FID 99319
PLOG ;
 N PK,L1,DTT,LN,DATA,IENS,MSG,FDT,PHN,PNAME,PDOB
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)=" "
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="Pickup Log:"
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="Date              Type       #    Staff                    "
 S IEN=IEN+1,$P(^TMP("PSOAL",$J,IEN,0),"=",79)="="
 I '$O(^PSRX(DA,"ZPAL",0)) D  Q
 .S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="There is no Pickup Activity recorded."
 F L1=0:0 S L1=$O(^PSRX(DA,"ZPAL",L1)) Q:'L1  D
 .S IENS=L1_","_DA_","
 .K DATA
 .D GETS^DIQ(52.999999951,IENS,"**","IE","DATA","MSG")
 .S FDT=$P($TR($$FMTE^XLFDT($G(DATA(52.999999951,IENS,.01,"I")),"5Z"),"@"," "),":",1,2)
 .S LN=FDT_"  "_$G(DATA(52.999999951,IENS,.03,"E"))_$S($L($G(DATA(52.999999951,IENS,.03,"E")))=8:"   ",1:"     ")_$J($G(DATA(52.999999951,IENS,.02,"I")),2)_"   "_$G(DATA(52.999999951,IENS,1.02,"E"))
 .S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)=LN
 .S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="Pickup Person: "_$G(DATA(52.999999951,IENS,.04,"E"))_$S($G(DATA(52.999999951,IENS,.04,"I"))="R":"  "_$G(DATA(52.999999951,IENS,.05,"E")),1:"")
 .S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)=" Identification:"
 .S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="  "_$G(DATA(52.999999951,IENS,.07,"E"))_"  "_$G(DATA(52.999999951,IENS,.06,"E"))_"  "_$G(DATA(52.999999951,IENS,.08,"E"))
 .I $G(DATA(52.999999951,IENS,.04,"I"))="P" S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)=" " Q
 .S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)=" Contact Information:"
 .S PNAME=$G(DATA(52.999999951,IENS,2.01,"E"))_$S($L($G(DATA(52.999999951,IENS,2.01,"E")))&($L($G(DATA(52.999999951,IENS,2.02,"E")))):", ",1:"")_$G(DATA(52.999999951,IENS,2.02,"E"))
 .S PDOB=$P($TR($$FMTE^XLFDT($G(DATA(52.999999951,IENS,2.03,"I")),"5Z"),"@"," "),":",1)
 .S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="     Name: "_PNAME
 .S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="      DOB: "_PDOB
 .S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="  Address: "_$G(DATA(52.999999951,IENS,3.01,"E"))
 .I $L($G(DATA(52.999999951,IENS,3.02,"E"))) S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="           "_$G(DATA(52.999999951,IENS,3.02,"E"))
 .S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="           "_$G(DATA(52.999999951,IENS,4.01,"E"))_$S($L($G(DATA(52.999999951,IENS,4.01,"E"))):", ",1:"")_$G(DATA(52.999999951,IENS,4.02,"E"))_"  "_$G(DATA(52.999999951,IENS,4.03,"E"))
 .S PHN=$G(DATA(52.999999951,IENS,4.04,"E"))
 .S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="    Phone: "_$S($L(PHN):$E(PHN,1,3)_"-"_$E(PHN,4,6)_"-"_$E(PHN,7,10),1:"")
 .S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)=" "
 Q
 ;
RXPLOG ;Called from APSP PRESCRIPTION PICKUP LOG option
 I '$D(PSOPAR) D ^PSOLSET I '$D(PSOPAR) W !!,"Outpatient Pharmacy Site Parameters are required!" Q
BC ;
 W !!
 N DIC,Y,DTOUT,DUOUT,DIRUT
 S DIC="^PSRX(",DIC("A")="Select Prescription: ",DIC(0)="QEAZ" D ^DIC
 Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))
BC1 Q:Y<0
 ;G:Y<0 BC
 D RXPLOG1(Y)
 Q
RXPLOG1(RX) ;
 N PK,L1,DTT,LN,DATA,IENS,MSG,FDT,PHN,PNAME,PDOB,DA,DFN,IDX,APSPIDX
 S DA=+RX
 S DFN=+$P(^PSRX(DA,0),U,2)
 D BLDHDR
 D EN^APSPPAL3
 Q
 D DISPLAY(Y)
 Q
DISPLAY(RX,ZPALIEN) ;
 N PK,L1,DTT,LN,DATA,IENS,MSG,FDT,PHN,PNAME,PDOB,DA,DFN,IDX,APSPIDX,EDT
 S ZPALIEN=$G(ZPALIEN,0)
 S DA=+RX
 S DFN=+$P(^PSRX(DA,0),U,2)
 D BLDHDR
 D BLDINFO
 S APSPIDX=IDX
 D EN^APSPPAL2
 Q
 ;
BLDHDR ;
 N GMRAL,GMRA,VADM,VAPA
 K ^TMP("PSOHDR",$J)
 D ^VADPT,ADD^VADPT
 S ^TMP("PSOHDR",$J,1,0)=$$GETPREF^AUPNSOGI(DFN,"E",1)
 N PSOBADR,PSOTEMP
 S PSOBADR=$$BADADR^DGUTL3(DFN) I PSOBADR S PSOTEMP=$$CHKTEMP^PSOBAI(DFN) D
 .S ^TMP("PSOHDR",$J,1,0)=^TMP("PSOHDR",$J,1,0)_" ** BAD ADDRESS INDICATED-("_$S(PSOBADR=1:"UNDELIVERABLE",PSOBADR=2:"HOMELESS",1:"OTHER")_")"_$S(PSOTEMP:" Active Temporary Address",1:"")
 S ^TMP("PSOHDR",$J,2,0)=$P(VADM(2),"^",2)
 S ^TMP("PSOHDR",$J,3,0)=$P(VADM(3),"^",2)
 S ^TMP("PSOHDR",$J,4,0)=VADM(4)
 S ^TMP("PSOHDR",$J,5,0)=$P(VADM(5),"^",2)
 S POERR=1 D RE^PSODEM K PSOERR
 S ^TMP("PSOHDR",$J,6,0)=$S(+$P(WT,"^",8):$P(WT,"^",9)_" ("_$P(WT,"^")_")",1:"_______ (______)")
 S ^TMP("PSOHDR",$J,7,0)=$S($P(HT,"^",8):$P(HT,"^",9)_" ("_$P(HT,"^")_")",1:"_______ (______)") K VM,WT,HT S PSOHD=7
 S GMRA="0^0^111" D EN1^GMRADPT S ^TMP("PSOHDR",$J,8,0)=+$G(GMRAL)
 Q
 ;
BLDINFO ;
 K ^TMP("APSPPKL")
 S ^TMP("APSPPKL",$J,$$NXTIDX(),0)="Prescription #: "_$P($G(^PSRX(+RX,0)),U)
 S ^TMP("APSPPKL",$J,$$NXTIDX(),0)=" "
 I '$O(^PSRX(+RX,"ZPAL",0)) D  Q
 .S ^TMP("APSPPKL",$J,$$NXTIDX(),0)="There is no Pickup Activity recorded."
 F L1=0:0 S L1=$O(^PSRX(DA,"ZPAL",L1)) Q:'L1  D
 .I $G(ZPALIEN),(ZPALIEN'=L1) Q
 .S IENS=L1_","_+RX_","
 .K DATA
 .D GETS^DIQ(52.999999951,IENS,"**","IE","DATA","MSG")
 .S FDT=$P($TR($$FMTE^XLFDT($G(DATA(52.999999951,IENS,.01,"I")),"5Z"),"@"," "),":",1,2)
 .S LN="Pickup Date:    "_FDT_"  "_$G(DATA(52.999999951,IENS,.03,"E"))_$S($L($G(DATA(52.999999951,IENS,.03,"E")))=8:"   ",1:"     ")_$J($G(DATA(52.999999951,IENS,.02,"I")),2)
 .S ^TMP("APSPPKL",$J,$$NXTIDX(),0)=LN
 .S EDT=$P($TR($$FMTE^XLFDT($G(DATA(52.999999951,IENS,1.01,"I")),"5Z"),"@"," "),":",1,2)
 .S ^TMP("APSPPKL",$J,$$NXTIDX(),0)="Documented by:  "_$G(DATA(52.999999951,IENS,1.02,"E"))_$S($L(EDT):"   at "_EDT,1:"")
 .S ^TMP("APSPPKL",$J,$$NXTIDX(),0)="Pickup Person:  "_$G(DATA(52.999999951,IENS,.04,"E"))_$S($G(DATA(52.999999951,IENS,.04,"I"))="R":"  "_$G(DATA(52.999999951,IENS,.05,"E")),1:"")
 .S PNAME=$G(DATA(52.999999951,IENS,2.01,"E"))_$S($L($G(DATA(52.999999951,IENS,2.01,"E")))&($L($G(DATA(52.999999951,IENS,2.02,"E")))):", ",1:"")_$G(DATA(52.999999951,IENS,2.02,"E"))
 .S PDOB=$P($TR($$FMTE^XLFDT($G(DATA(52.999999951,IENS,2.03,"I")),"5Z"),"@"," "),":",1)
 .I $G(DATA(52.999999951,IENS,.04,"I"))="R" D
 ..S ^TMP("APSPPKL",$J,$$NXTIDX(),0)="                "_PNAME
 ..S ^TMP("APSPPKL",$J,$$NXTIDX(),0)="                "_$G(DATA(52.999999951,IENS,3.01,"E"))
 ..I $L($G(DATA(52.999999951,IENS,3.02,"E"))) S ^TMP("APSPPKL",$J,$$NXTIDX(),0)="                "_$G(DATA(52.999999951,IENS,3.02,"E"))
 ..S ^TMP("APSPPKL",$J,$$NXTIDX(),0)="                "_$G(DATA(52.999999951,IENS,4.01,"E"))_$S($L($G(DATA(52.999999951,IENS,4.01,"E"))):", ",1:"")_$G(DATA(52.999999951,IENS,4.02,"E"))_"  "_$G(DATA(52.999999951,IENS,4.03,"E"))
 ..S PHN=$G(DATA(52.999999951,IENS,4.04,"E"))
 ..S ^TMP("APSPPKL",$J,$$NXTIDX(),0)="                "_$S($L(PHN):$E(PHN,1,3)_"-"_$E(PHN,4,6)_"-"_$E(PHN,7,10),1:"")
 .S ^TMP("APSPPKL",$J,$$NXTIDX(),0)="Identification: "_$G(DATA(52.999999951,IENS,.07,"E"))_"  "_$G(DATA(52.999999951,IENS,.06,"E"))_"  "_$G(DATA(52.999999951,IENS,.08,"E"))
 .I $G(DATA(52.999999951,IENS,.04,"I"))="R" D
 ..S ^TMP("APSPPKL",$J,$$NXTIDX(),0)="DOB:            "_PDOB
 .S ^TMP("APSPPKL",$J,$$NXTIDX(),0)=" "
 Q
 ;
NXTIDX() ;
 S IDX=$G(IDX)+1
 Q IDX
 ;
HP W !!,"Wand the barcode number of the Rx or manually key in",!,"the number below the barcode or the Rx number."
 W !,"The barcode number format is - 'NNN-NNNNNNN'",!!,"Press 'ENTER' to process Rx or ""^"" to quit"
 Q
