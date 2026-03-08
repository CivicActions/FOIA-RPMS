APSPESR2 ; IHS/MSC/MGH/PLS - EXTERNAL PHARMACY PRESCRIPTIONS REPORT ;09-Jul-2025 07:37;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1011,1024,1032,1036**;Sep 23, 2004;Build 17
 ; FID 74766 Changes - 3/24/2025
 ; FID 122888,124251,124252,125019
EN ;EP
 N APSPBD,APSPED,APSPDIV,APSPRTYP,APSPQ,APSPDSUB,APSPDCLS,APSPSRT,APSPSRT2
 N APSPDCT,APSPDCTN,APSPDRG,APSPBDF,APSPEDF,APSPFIL,APSPGRP,APSPOUT,APSPDEMO
 S APSPDIV="",APSPDRG="",APSPQ=0,APSPDSUB=0
 W @IOF
 W !!,"External Pharmacy Prescriptions Report"
 D ASKDATES^APSPUTIL(.APSPBD,.APSPED,.APSPQ,DT,DT)
 Q:APSPQ
 S APSPBDF=$P($TR($$FMTE^XLFDT(APSPBD,"5Z"),"@"," "),":",1,2)
 S APSPEDF=$P($TR($$FMTE^XLFDT(APSPED,"5Z"),"@"," "),":",1,2)
 S APSPBD=APSPBD-.01,APSPED=APSPED+.99
 S APSPDIV=$$DIR^APSPUTIL("Y","Would you like all pharmacy divisions","Yes",,.APSPQ)
 Q:APSPQ
 S APSPDEMO=$$DIR^APSPUTIL("Y","Include Demo Patients","No",,.APSPQ)
 Q:APSPQ
 ;FID 74766 - Support of Drug Class
 S APSPDCLS=$$DIR^APSPUTIL("S^1:C-II;2:C-II through C-V;3:C-III through C-V;4:Non-controlled schedules;5:All schedules","Drug Class Types",5,,.APSPQ)
 Q:APSPQ
 S APSPDCT=$S(APSPDCLS=1:2,APSPDCLS=2:"2345",APSPDCLS=3:"345",APSPDCLS=4:"'",APSPDCLS=5:"*")
 S APSPDCTN(1)="C-II",APSPDCTN(2)="C-II through C-V",APSPDCTN(3)="C-III through C-V",APSPDCTN(4)="Non-controlled schedules",APSPDCTN(5)="All schedules"
 I APSPDIV D
 .S APSPDIV="*"
 E  D  Q:APSPQ
 .S APSPDIV=$$GETIEN^APSPUTIL(59,"Select Pharmacy Division: ",.APSPQ)
 ;Get filter criteria
 S APSPFIL=$$DIR^APSPUTIL("S^T:Transmitted;F:Failed Transmission;X:Retransmitted;P:Printed;R:Reprinted;A:All","Filter by","A",,.APSPQ)
 Q:APSPQ
 ;Get primary sort criteria
 S APSPSRT=+$$DIR^APSPUTIL("S^1:Print Date;2:DEA Schedule;3:Prescriber;4:User who printed/transmitted","Primary sort",,,.APSPQ)
 Q:APSPQ
 I APSPSRT=1 D
 .S APSPSRT2=+$$DIR^APSPUTIL("S^1:DEA Schedule;2:Prescriber;3:User","Within Date,sort by",,,.APSPQ)
 Q:APSPQ
 I APSPSRT=2 D
 .S APSPSRT2=1  ;Drug name
 Q:APSPQ
 I APSPSRT=3 D
 .S APSPSRT2=+$$DIR^APSPUTIL("S^1:DEA Schedule;2:Print Date","Within Prescriber,sort by",,,.APSPQ)
 Q:APSPQ
 I APSPSRT=4 D
 .S APSPSRT2=+$$DIR^APSPUTIL("S^1:DEA Schedule;2:Print Date","Within User,sort by",,,.APSPQ)
 Q:APSPQ
 ;Ask about divisions
 S APSPGRP=0
 I APSPDIV="*" S APSPGRP=+$$DIR^APSPUTIL("S^1:Yes;0:No","Display by division?",,,.APSPQ)
 Q:APSPQ
 ;Ask about output
 S APSPOUT=0
 S APSPOUT=+$$DIR^APSPUTIL("S^1:Detailed;2:Columnar;3:Delimited","Output format: ",,,.APSPQ)
 Q:APSPQ
 D DEV
 Q
DEV ;
 N XBRP,XBNS
 S XBRP="OUT^APSPESR2"
 S XBNS="APS*"
 D ^XBDBQUE
 Q
OUT ;EP
 N TYPE
 K ^TMP("APSPERS",$J)
 D FIND($G(APSPBD),$G(APSPED),$G(APSPFIL),$G(APSPSRT),$G(APSPSRT2))
 D PRINT
 K ^TMP("APSPESR",$J)
 Q
 ;
FIND(APSPBD,APSPED,APSPFIL,APSPSRT,APSPSRT2) ;EP
 N RXIEN,ACTIEN,RTSDT,DIV,ACT,CNT,AUTO
 K ^TMP("APSPESR",$J)
 S CNT=0
 S RXIEN=0,RTSDT=APSPBD
 F  S RTSDT=$O(^PSRX("AC",RTSDT)) Q:'+RTSDT!(RTSDT>APSPED)  D
 .F  S RXIEN=$O(^PSRX("AC",RTSDT,RXIEN)) Q:'+RXIEN  D
 ..Q:'$D(^PSRX(RXIEN,0))       ; Prescription must have a zero node
 ..;Only want autofinished meds
 ..S AUTO=$P($G(^PSRX(RXIEN,999999921)),U,3)
 ..Q:'+AUTO
 ..S DIV=$$DIVVRY(RXIEN,APSPDIV)  ;check division
 ..Q:'DIV
 ..Q:$$DEMOPT(RXIEN,APSPDEMO)  ;check for demo patient
 ..Q:'$P(^PSRX(RXIEN,0),U,6)   ;Prescription must have a drug
 ..Q:'$$DCVRY(APSPDCLS,RXIEN)  ;Quit if drug class doesn't match requirement
 ..;Now let's check the activity log of this prescription
 ..S ACT=0 F  S ACT=$O(^PSRX(RXIEN,"A",ACT)) Q:'+ACT  D
 ...S TYPE=$P($G(^PSRX(RXIEN,"A",ACT,9999999)),U,2)
 ...I TYPE="X" D
 ....I APSPFIL="X"!(APSPFIL="A") D SET(RXIEN,ACT,TYPE)
 ...I TYPE="R" D
 ....I APSPFIL="R"!(APSPFIL="A") D SET(RXIEN,ACT,TYPE)
 ...I TYPE="P" D
 ....I APSPFIL="P"!(APSPFIL="A") D SET(RXIEN,ACT,TYPE)
 ...I TYPE="T" D
 ....I APSPFIL="T"!(APSPFIL="A") D SET(RXIEN,ACT,TYPE)
 ...I TYPE="F" D
 ....I APSPFIL="F"!(APSPFIL="A") D SET(RXIEN,ACT,TYPE)
 Q
 ;
 ; Return boolean flag indicating prescription drug matches selected report drug class
 ; Input:  DCLS - Drug Class based on input selected by user
 ;         RX - Prescription IEN
DCVRY(DCLS,RX) ;EP
 Q:APSPDCT="*" 1  ;User requested all schedules
 N RXRTSDT,DRGIEN,DCLSVAL
 S DRGIEN=$P(^PSRX(RX,0),U,6)
 Q:'$D(^PSDRUG(DRGIEN,0)) 0  ;Check for missing drug entry
 S DCLSVAL=+$P(^PSDRUG(DRGIEN,0),U,3)
 Q $S(APSPDCT="'":'("2345"[DCLSVAL),1:APSPDCT[DCLSVAL)
 ;
PRINT ;EP
 N APSPPG,DFLG,APSPQ
 S (APSPPG,DFLG,APSPQ)=0
 D HDR
 Q:APSPQ
 D PRINT1
 W:'DFLG !,"No data found..."
 Q
 ;
PRINT1 ;EP
 ;This EP makes use of the MUMPS naked reference syntax.
 N DIV,SUB1,SUB2,SUB3,SUB4,VAL
 I APSPDIV="*"&(APSPGRP=1) D PRINT2
 E  D PRINT3
 Q
PRINT2 ;Print out by division
 N DIV,SUB1,SUB2,VAL,DIVCT,TOT,NUM
 S TOT=0
 S DIV=0 F  S DIV=$O(^TMP("APSPESR",$J,DIV)) Q:DIV=""!APSPQ  D
 .S DIVCT=0
 .I APSPDIV="*" W !,"Division: "_$$GET1^DIQ(59,DIV,.01) D PRINT5
 .S SUB1=0 F  S SUB1=$O(^TMP("APSPESR",$J,DIV,SUB1)) Q:SUB1=""!APSPQ  D
 ..D HDR1(SUB1)
 ..S SUB2=0 F  S SUB2=$O(^TMP("APSPESR",$J,DIV,SUB1,SUB2)) Q:SUB2=""!APSPQ  D
 ...D HDR2(SUB2)
 ...S NUM=0 F  S NUM=$O(^TMP("APSPESR",$J,DIV,SUB1,SUB2,NUM)) Q:'NUM!APSPQ  D
 ....S VAL=$G(^TMP("APSPESR",$J,DIV,SUB1,SUB2,NUM))
 ....D PRINT4(VAL,DIV)
 ....S DFLG=1
 ....S TOT=TOT+1,DIVCT=DIVCT+1
 .W !,"Division Count: "_DIVCT
 W !,"TOTAL Count: "_TOT
 Q
PRINT3 ;No divisional counts
 N SUB1,SUB2,VAL,TOT,DIV,NUM
 S TOT=0
 S SUB1=0 F  S SUB1=$O(^TMP("APSPESR",$J,SUB1)) Q:SUB1=""!APSPQ  D
 .D HDR1(SUB1)
 .S SUB2=0 F  S SUB2=$O(^TMP("APSPESR",$J,SUB1,SUB2)) Q:SUB2=""!APSPQ  D
 ..D HDR2(SUB2)
 ..S DIV=0 F  S DIV=$O(^TMP("APSPESR",$J,SUB1,SUB2,DIV)) Q:DIV=""!APSPQ  D
 ...S NUM=0 F  S NUM=$O(^TMP("APSPESR",$J,SUB1,SUB2,DIV,NUM)) Q:'NUM!APSPQ  D
 ....S DFLG=1
 ....S VAL=$G(^TMP("APSPESR",$J,SUB1,SUB2,DIV,NUM))
 ....D PRINT4(VAL,DIV)
 ....S TOT=TOT+1
 W !,"TOTAL Count: "_TOT
 ; Print the line
PRINT4(DATA,DIV) ;EP
 Q:APSPQ
 N RXIEN,NODE0,NODE6,AIEN,IENS,QTY,SCH,DAYS,X,CLINIC,HRN,DRUG,DEA,CLASS,PAT,PRV,COM,USER,TYP
 S RXIEN=$P(DATA,U,1),AIEN=$P(DATA,U,3)
 S HRN=$P(DATA,U,4),DRUG=$P(DATA,U,5),DEA=$P(DATA,U,6),CLASS=$P(DATA,U,7)
 S PDAT=$P(DATA,U,8),PAT=$P(DATA,U,9),PRV=$P(DATA,U,10)
 S PDAT=$TR($P($$FMTE^XLFDT(PDAT,"5Z"),":",1,2),"@"," ")
 S USER=$P(DATA,U,11),USER=$$GET1^DIQ(200,USER,.01,"E")
 S COM=$P(DATA,U,12)
 S QTY=$$GET1^DIQ(52,RXIEN,7,"E")
 S DAYS=$$GET1^DIQ(52,RXIEN,8,"E")
 S SCH=""
 S X=0 F  S X=$O(^PSRX(RXIEN,6,X)) Q:'X  D
 .S Y=$P($G(^PSRX(RXIEN,6,X,0)),U,8)
 .I SCH="" S SCH=Y
 .E  S SCH=SCH_","_Y
 S RXNO=$P(DATA,U,2)
 S DIV=$$GET1^DIQ(59,DIV,.01)
 S PRV=$$GET1^DIQ(200,PRV,.01)
 S CLINIC=$$GET1^DIQ(44,$P(DATA,U,14),.01,"E")
 S TYPE=$P(DATA,U,13)
 S TYP=$S(TYPE="T":"Transmitted",TYPE="P":"Printed",TYPE="F":"Failed",TYPE="X":"Retransmitted",TYPE="R":"Reprinted",TYPE="U":"Updated",1:"")
 I APSPOUT=1 D
 .W !,?6,"RX Number: "_RXNO,?27,"Type: "_TYP,?50,"Division: "_DIV
 .D PRINT5
 .W !,?6,"Patient: "_$E(PAT,1,25),?40,"HRN: "_HRN,?55,"Location: :"_CLINIC
 .D PRINT5
 .W !,?6,"Action Date: "_PDAT
 .D PRINT5
 .W !,?6,"Drug: "_$E(DRUG,1,25),?40,"CLASS: "_CLASS,?60,"DEA Class: "_DEA
 .D PRINT5
 .W !,?6,"Quantity: "_QTY,?40,"Days Supply: "_DAYS,?60,"Schedule: "_SCH
 .D PRINT5
 .W !,?6,"Provider: "_$E(PRV,1,25),?40,"Action Person: "_$E(USER,1,25)
 .D PRINT5
 .W !,?6,"Comment: "_$E(COM,1,65),!
 I APSPOUT=2 D
 .;W !,?8,RXNO,?18,HRN,?28,$E(TYP,1,1),?32,$E(DRUG,1,15),?48,DEA,?54,$E(USER,1,14),?70,$P(PDAT,"@",1)
 .W !,?2,RXNO,?13,HRN,?20,TYPE,?25,$E(DRUG,1,15),?42,DEA,?46,$E(USER,1,16),?63,$P(PDAT,"@",1)
 .D PRINT5 ;check page length
 I APSPOUT=3 D
 .W !
 .W RXNO_U_DIV_U_HRN_U_PAT_U_DRUG_U_CLASS_U_DEA_U_PRV_U_TYP_U_USER_U_PDAT_U_QTY_U_DAYS_U_SCH_U_COM_U_CLINIC
 Q
 ; Check page length
PRINT5 ;EP
 N DIR
 Q:$E(IOST)'="C"
 I $Y+4>IOSL D
 .K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 .S DIR(0)="E" D ^DIR
 .I $D(DUOUT) S APSPQ=1
 .D HDR
 Q
 ; Set data into ^TMP global for output
SET(RX,IEN,TYPE) ;EP
 N LSTDSPDT,NODE0,NODE2,NODE3,ANODE,X,Y,IENS,PDAT,USER,COM
 N PDAT,DEACLASS,DRUG,PRV,DIV,RXNO,PRINT,DRCLASS,DRGNM
 N DEACLS
 S NODE0=$G(^PSRX(RX,0))
 S NODE2=$G(^PSRX(RX,2))
 S NODE3=$G(^PSRX(RX,3))
 S ANODE=$G(^PSRX(RX,"A",IEN,0))
 S DIV=$P(NODE2,U,9)
 S PRV=$P(NODE0,U,4),CLINIC=$P(NODE0,U,5)
 S DRUG=$P(NODE0,U,6),DRGNM=$P(^PSDRUG(DRUG,0),U)
 S DEACLASS=$P($G(^PSDRUG(DRUG,0)),U,3)
 S DEACLS=$S($L(DEACLASS):DEACLASS_$C(1),1:"Not specified")
 S DEACLS=$$CVTDCLS(DEACLASS)
 S PDAT=$P(ANODE,U,1)
 S DRCLASS=$$GET1^DIQ(50,DRUG,2,"E")
 S USER=$P(ANODE,U,3)
 S HRN=$$HRN^AUPNPAT($P(NODE0,U,2),$$GET1^DIQ(59,DIV,100,"I"))
 S PAT=$$GET1^DIQ(2,$P(NODE0,U,2),.01,"E")
 S RXNO=$P(NODE0,U,1)
 S IENS=IEN_","_RXIEN
 S USER=$$GET1^DIQ(52.3,IENS,.03,"I")
 S COM=$$GET1^DIQ(52.3,IENS,.05,"E")
 N A,B,C
 S A=DIV
 I APSPSRT=1 D
 .I APSPSRT2=1 S B=PDAT,C=DEACLS
 .I APSPSRT2=2 S B=PDAT,C=PRV
 .I APSPSRT2=3 S B=PDAT,C=USER
 I APSPSRT=2 D
 .I APSPSRT2=1 S B=DEACLS,C=DRGNM_U_DRUG  ;sorts by drug name
 I APSPSRT=3 D
 .I APSPSRT2=1 S B=PRV,C=DEACLS
 .I APSPSRT2=2 S B=PRV,C=PDAT
 I APSPSRT=4 D
 .I APSPSRT2=1 S B=USER,C=DEACLS
 .I APSPSRT2=2 S B=USER,C=PDAT
 S CNT=CNT+1
 I APSPDIV="*"&(APSPGRP=1) D
 .S ^TMP("APSPESR",$J,A,B,C,CNT)=RX_U_RXNO_U_IEN_U_HRN_U_DRGNM_U_DEACLASS_U_DRCLASS_U_PDAT_U_PAT_U_PRV_U_USER_U_COM_U_TYPE_U_CLINIC
 E  D
 .S ^TMP("APSPESR",$J,B,C,A,CNT)=RX_U_RXNO_U_IEN_U_HRN_U_DRGNM_U_DEACLASS_U_DRCLASS_U_PDAT_U_PAT_U_PRV_U_USER_U_COM_U_TYPE_U_CLINIC
 Q
 ; Return boolean flag indicating valid pharmacy division
DIVVRY(RX,DIV) ;EP
 Q:DIV="*" 1
 Q DIV=+$P($G(^PSRX(RX,2)),U,9)  ; IHS/MSC/PLS -06/20/08 - Added $G
 ;
 ; Return '*' flag indicated prescription has been deleted
DELFLG(RX) ;EP
 Q $S($G(^PSRX(RX,"STA"))=13:"*",1:" ")
HDR ;EP
 W @IOF
 S APSPPG=APSPPG+1
 W !,"External Pharmacy Prescriptions Report",?40,$P($TR($$FMTE^XLFDT($$NOW^XLFDT,"5Z"),"@"," "),":",1,2),?(IOM-10),"Page: "_APSPPG
 W !,"Report Criteria: (Prescriptions which are marked as auto-finished)"
 W !,?2,"Inclusive Dates: "_APSPBDF_" to "_APSPEDF
 W !,?2,"Drug Class Type: "_APSPDCTN(APSPDCLS)
 W !,?2,"Filtered by: "_$S(APSPFIL=1:"Electronic",APSPFIL=2:"Printed",APSPFIL=3:"Reprinted",1:"All")
 W !,?2,"Pharmacy Division: "_$S(APSPDIV:$$GET1^DIQ(59,APSPDIV,.01),1:"All")
 W !,?2,"Primary Sort: "_$S(APSPSRT=1:"Print Date",APSPSRT=2:"DEA schedule",APSPSRT=3:"Prescriber",APSPSRT=4:"User",1:"")
 W !,$TR($J("",80)," ","-")
 I APSPOUT=2 D HDR3
 Q
 ;
HDR1(SRT1) ;EP
 N LINE
 I APSPSRT=1 S LINE="Print Date: "_$TR($P($$FMTE^XLFDT(SRT1,"5Z"),":",1,2),"@"," ")
 I APSPSRT=2 S LINE="DEA Class: "_SRT1
 I APSPSRT=3 S LINE="Prescriber: "_$$GET1^DIQ(200,SRT1,.01,"E")
 I APSPSRT=4 S LINE="User: "_$$GET1^DIQ(200,SRT1,.01,"E")
 W !,LINE
 Q
HDR2(SRT2) ;EP
 I APSPSRT=1 D
 .I APSPSRT2=1 D
 ..S LINE=SRT2
 ..W !,?1,"DEA Schedule: "_LINE
 .I APSPSRT2=2 D
 ..S LINE=$$GET1^DIQ(200,SRT2,.01,"E")
 ..W !,?1,"Prescriber: "_LINE
 .I APSPSRT2=3 D
 ..S LINE=$$GET1^DIQ(200,SRT2,.01,"E")
 ..W !,?1,"User: "_LINE
 I APSPSRT=2 D
 .;S LINE=$$GET1^DIQ(50,SRT2,.01,"E")
 .S LINE=$P(SRT2,U)
 .W !,?1,"Drug Name: "_LINE
 I APSPSRT=3 D
 .I APSPSRT2=1 D
 ..S LINE=SRT2
 ..W !,?1,"DEA Schedule: "_LINE
 .I APSPSRT2=2 D
 ..S LINE=$TR($P($$FMTE^XLFDT(SRT2,"5Z"),":",1,2),"@"," ")
 ..W !,?1,"Print Date: "_LINE
 I APSPSRT=4 D
 .I APSPSRT2=1 D
 ..S LINE=SRT2
 ..W !,?1,"DEA Schedule: "_LINE
 .I APSPSRT2=2 D
 ..S LINE=$TR($P($$FMTE^XLFDT(SRT2,"5Z"),":",1,2),"@"," ")
 ..W !,?1,"Print Date: "_LINE
 Q
HDR3 ;PRINT OUT COLUMNS
 I APSPOUT=1 Q
 I APSPOUT=2 D
 .W !,?2,"RX",?13,"HRN",?20,"Type",?25,"Drug Name",?42,"DEA",?46,"Action by",?63,"Print Dt"
 .D DASH
 E  D
 .W !,"RX"_U_"Division"_U_"HRN"_U_"Patient"_U_"Drug Name"_U_"Classification"_U_"DEA Class"_U_"Provider"_U_"Type"_U_"User"_U_"Print Date"_U_"Quantity"_U_"Days"_U_"Schedule"_U_"Comments"_U_"Location"
 Q
 ;
DASH ;EP
 N DASH
 W ! F DASH=1:1:IOM W "-"
 Q
CVTDCLS(DCLS) ; EP
 Q:+DCLS=2!(+DCLS=20) "C-II"
 Q:+DCLS=3!(+DCLS=30) "C-III"
 Q:+DCLS=4!(+DCLS=40) "C-IV"
 Q:+DCLS=5!(+DCLS=50) "C-V"
 Q:$L(DCLS)>0 "Non-CS"
 Q "Not Specified"
 ;
DEMOPT(RX,FLG) ;Quit if demo pts excluded
 N IND,PAT,SSN,NAME,RES
 Q:FLG 0
 S RES=0
 S PAT=+$P($G(^PSRX(RX,0)),U,2)
 S IND=$$GET1^DIQ(2,PAT,.6)
 S SSN=$$GET1^DIQ(2,PAT,.09)
 S NAME=$$GET1^DIQ(2,PAT,.01)
 I (IND="YES")!(SSN?5"0".E)!(NAME?1"DEMO,PATIENT".E)!(NAME?1"DEMO,GIMC".E) S RES=1
 Q RES
