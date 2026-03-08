APSPREP ; IHS/MSC/MIR - PRINTS A REPORT OF PENDING ORDERS WITH EARLIEST FILL DATE ;20-Jul-2023 14:11;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1034**;Sep 23, 2004;Build 37
EP ;
 W !,"Pending Orders with earliest Fill Date",!
 K ^TMP($J)
 N APSPSTRT,APSPEND,APSPPOP,APSPPMT,APSPDFL,APSPHLP,DIR,DIRUT,APSRT
 N APSPTST,POP,%ZIS,QFLG,APSPDIV,APSPQ
 S APSPPOP=0,APSPQ=0
 W !!,"Earliest Fill Date Report"
DTS D ASKDATES^APSPUTIL(.APSPSTRT,.APSPEND,.APSPQ,DT,$$FMADD^XLFDT(DT,30)) Q:$G(APSPQ)  ; DEFAULT T+1
DIV S APSPPMT="Would you like all divisions",APSPDFL="YES",APSPHLP="Please enter Y or N only"
 S APSPDIV=$$DIRYNR^APSPUTIL(APSPPMT,APSPDFL,APSPHLP,.APSPQ)
 Q:$G(APSPQ)
 I APSPDIV D
 .S APSPDIV="*"
 E  D
 .F  D  Q:QFLG
 ..N DV
 ..S DV=$$GETIEN1^APSPUTIL(4,"Enter Division: ",-1,"B")
 ..I DV<1 S QFLG=1 Q
 ..S APSPDIV(DV)=""
 ..S QFLG='$$DIRYN^APSPUTIL("Want to Select Another Division","No","Enter a 'Y' or 'YES' to include more divisions in your search",.APSPQ)
 ..S:'QFLG QFLG=APSPQ
 I $D(APSPDIV)<11 S APSPDIV="*"
 Q:APSPQ
SRT S DIR(0)="SA^1:MEDICATION;2:DATE;3:PATIENT"
 S DIR("A")="  Sort report by: ",DIR("A",1)="  Select one of the following:"
 S DIR("A",2)="     1   Drug Name",DIR("A",3)="     2   Earliest Fill Date",DIR("A",4)="     3   Patient"
 S DIR("B")=2
 S DIR("?")="Enter 1, 2 or 3 to determine the order" D ^DIR Q:$G(DUOUT)!$G(DIRUT)  S APSRT=Y K DIR
 S APSPPMT="Include TEST Patients",APSPDFL="N",APSPHLP="Please enter Y or N only"
 S Y=$$DIRYNR^APSPUTIL(APSPPMT,APSPDFL,APSPHLP,.APSPQ) Q:$G(APSPQ)  S APSPTST=Y
 D DEV
 Q
DEV ;-
 N XBRP,XBNS
 S XBRP="P^APSPREP"
 S XBNS="APS*"
 D ^XBDBQUE
 Q
 ;
P ; Actual print
 K ^TMP($J) D LOOP
 U IO N PG,LN,UN,SORT,LP,QFLG S PG=0,$P(UN,"-",81)="",QFLG=0 D HDR
 S SORT="" F  S SORT=$O(^TMP($J,SORT)) Q:SORT=""!QFLG  F LP=1:1 Q:'$D(^TMP($J,SORT,LP))  D  Q:QFLG
 .I $Y+3>IOSL,IOST["C-" D  Q:QFLG
 ..N DIR S DIR("A")="ENTER '^' TO HALT",DIR(0)="E" D ^DIR I $D(DTOUT)!($D(DUOUT))!($D(DIROUT)) S QFLG=1 Q
 ..W @IOF D HDR
 .S LN=^TMP($J,SORT,LP) W $P(LN,U),?12,$E($P(LN,U,2),1,21),?34,$P(LN,U,3),?41,$E($P(LN,U,4),1,38)
 .W !,?3,$P(LN,U,5),?8,$P(LN,U,6),?20,$E($P(LN,U,7),1,23)
 .W !,?2,"Sig:" D OUTSIG($$GETSIG(+$P(LN,U,8)),IOM,7)
 .W !
 I '$D(^TMP($J)) W "No Data Found"
 E  W !,"End of Report"
 ;
Q ;-
 K ^TMP($J)
 Q
LOOP ;
 N LDT,EIN,ORDA,FILLDT,APSPDFN,HRN,PATNAME,DRUGNM,QTY,DAYS,PROV,SIG,SORT,IN,RI
 N LPSTRDT S LPSTRDT=$$FMADD^XLFDT(APSPSTRT,-180)
 S LDT="" F  S LDT=$O(^PS(52.41,"AD",LDT),-1)  Q:LDT<LPSTRDT!'LDT  D
 .S RI=0 F  S RI=$O(^PS(52.41,"AD",LDT,RI)) Q:'RI  D
 ..Q:(APSPDIV'="*")&('$D(APSPDIV(RI)))
 ..S EIN="" F  S EIN=$O(^PS(52.41,"AD",LDT,RI,EIN)) Q:'EIN  D:$G(^PS(52.41,EIN,0))
 ...S ORDA=+^PS(52.41,EIN,0)
 ...S FILLDT=$$VALUE^ORCSAVE2(ORDA,"EARLIEST") I FILLDT<APSPSTRT!(FILLDT>APSPEND) Q  ;out of Range
 ...S APSPDFN=$$GET1^DIQ(52.41,EIN,1,"I")
 ...I 'APSPTST,$$GET1^DIQ(2,APSPDFN,.6,"I") Q                                        ;no Test Patients
 ...S HRN=$$HRC^APSPFUNC(APSPDFN)
 ...N ARR,EIN1 D GETS^DIQ(52.41,EIN,".01;1;5;11;12;101",,"ARR") S EIN1=EIN_","
 ...S PATNAME=ARR(52.41,EIN1,1),DRUGNM=ARR(52.41,EIN1,11),QTY=ARR(52.41,EIN1,12),DAYS=ARR(52.41,EIN1,101)
 ...S PROV=ARR(52.41,EIN1,5)
 ...S SORT=$S(APSRT=1:DRUGNM,APSRT=2:FILLDT,1:PATNAME),IN=$O(^TMP($J,SORT,""),-1)+1
 ...S ^TMP($J,SORT,IN)=$$FMTE^XLFDT(FILLDT,"5Z")_U_PATNAME_U_HRN_U_DRUGNM_U_QTY_U_DAYS_U_PROV_U_EIN1_U_ARR(52.41,EIN1,.01)
 Q
HDR ; Print Header
 S PG=PG+1
 W !,"Earliest Fill Date Report",?55,$P($TR($$FMTE^XLFDT($$NOW^XLFDT,"5Z"),"@"," "),":",1,2)," Page: ",PG,!
 W "Report Criteria:",!
 W ?5,"Inclusive Dates  : ",$$FMTE^XLFDT(APSPSTRT,"5Z")," to ",$$FMTE^XLFDT(APSPEND,"5Z"),!
 W ?5,"Division(s)      : "
 I APSPDIV="*" D
 .W ?24,"All",!
 E  D
 .N APSPQ,I,SDIV
 .S SDIV=0 F  S SDIV=$O(APSPDIV(SDIV)) Q:'SDIV  W ?24,$$GET1^DIQ(4,SDIV,.01),!
 W ?5,"Sorted by        : ",$S(APSRT=1:"Drug Name",APSRT=2:"Fill Date",1:"Patient Name"),!
 W ?5,"Test Patients    : ",$S(APSPTST:"Included",1:"Excluded"),!
 W UN,!,"Fill Date",?12,"Patient",?34,"HRN",?41,"Drug Name"
 W !,?3,"Qty",?8,"Supply",?20,"Prescriber"
 W !,UN,!
 Q
 ;
 ; Return SIG as a single string
GETSIG(RX) ;EP
 N LP,RET
 S RET=""
 S LP=0 F  S LP=$O(^PS(52.41,RX,"SIG",LP)) Q:'LP  D
 .S RET=RET_^PS(52.41,RX,"SIG",LP,0)
 Q RET
 ; Output SIG
 ; Input:  X - Data to output
 ;          RM - Right Margin
 ;          LI - Left Indent
OUTSIG(X,RM,LI) ;EP - Output SIG
 Q:'$L(X)
 K ^UTILITY($J,"W")
 N DIWL,DIWR,DIWF,LP,I
 S DIWL=0,DIWR=RM-LI,DIWF=""
 D ^DIWP
 I $D(^UTILITY($J,"W")) D
 .S LP=0 F  S LP=$O(^UTILITY($J,"W",DIWL,LP)) Q:'LP  W ?LI,^(LP,0),!
 K ^UTILITY($J,"W")
 Q
