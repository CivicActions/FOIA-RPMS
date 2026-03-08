BEHOEPAD ; IHS/MSC/MGH - CONTROLLED SUBSTANCE AD HOC REPORT ;07-Feb-2019 14:07;DU
 ;;1.1;BEH COMPONENTS;**070001**;Sep 23, 2004;Build 74
 ;
 ; IHS/MSC/MGH - 06/O1/2018^ - New report
EN ;EP
 N BEHBD,BEHED,BEHBDF,BEHEDF,BEHDIV,BEHRTYP,BEHQ,BEHDSUB,BEHOUT
 N BEHDCT,BEHDCTN,BEHDRG,BEHDET,BEHDOSE,BEHPROV,BEHPRV
 N BEHPAT,BEHRTOT,BEHCMOP,BEHERX,PRV,CNT
 S BEHDIV="",BEHDRG="",BEHQ=0,BEHDSUB=0,BEHDOSE=0,BEHPRV=""
 S BEHPAT=""
 S CNT=0
 W @IOF
 W !!,"Controlled Substance Ad Hoc Report"
 W !,"The printed report can be printed or sent to an HFS file."
 W !,"The data export will be created in XML format."
 W !!,"   *** Provider Selection ***"
 S BEHPROV=+$$GETIEN1^BEHOEPUT(200,"Select Prescriber: ","-1","B")
 I BEHPROV<1 S BEHQ=1 Q
 D ASKDATES^BEHOEPUT(.BEHBD,.BEHED,.BEHQ,$$FMADD^XLFDT(DT,-1),$$FMADD^XLFDT(DT,-1))
 Q:BEHQ
 S BEHBDF=$P($TR($$FMTE^XLFDT(BEHBD,"5Z"),"@"," "),":",1,2)
 S BEHEDF=$P($TR($$FMTE^XLFDT(BEHED,"5Z"),"@"," "),":",1,2)
 S BEHBD=BEHBD-.01,BEHED=BEHED+.99
 S BEHOUT=+$$DIR^BEHOEPUT("S^1:Printed Report;2:Data Export","Output Mode",1,,.BEHQ)
 Q:BEHQ
 D DEV
 Q
DEV ;
 N XBRP,XBNS
 S XBRP="OUT^BEHOEPAD"
 S XBNS="BEH*"
 D ^XBDBQUE
 Q
OUT ;EP
 U IO
 D FIND(BEHBD,BEHED,BEHPROV)
 I BEHOUT=1 D PRINT^BEHOEPAD
 I BEHOUT=2 D DELIM^BEHOEPAD
 D END
 Q
END K ^TMP("CSOUT",$J),^TMP("CS"),^TMP("STOUT",$J),BEHRTOT
 Q
 ;
FIND(SDT,EDT,PROV) ;EP
 N ORIEN,ORPROV,ACTIEN,RTSDT,FILLDT,PRVNAME,A0,FDTLP,IEN,CMOP,RXNUM,LOOP
 S FDTLP=SDT-.01
 S PRVNAME=$$GET1^DIQ(200,PROV,.01)
 I +$D(^ORPA(101.52,"C",PROV)) D DATES(PROV)
 E  S ^TMP("CS","PT",$J,PRVNAME)=""
 Q
DATES(ORPROV) ;Get the selected dates
 N S1,S3,DATA0,DATA1,DATA3,DATA4,ORRX,ORDTE,PRV,ORPT,ORDEA,ORQTY,ORPNM,ORDRUG,DRGCT,DRCL,BACKDOOR
 N DA,DIC,DR,DIQ,DATA5,DIROUT,ORIFN,ORS,PRVNME,STR,IND,HARDCPY,BACKDOOR
 S S1=BEHBD
 F  S S1=$O(^ORPA(101.52,"C",ORPROV,S1)) Q:'S1!(S1>BEHED)  D
 .S PRVNME=$$GET1^DIQ(200,ORPROV,.01)
 .S S3=0
 .F  S S3=$O(^ORPA(101.52,"C",ORPROV,S1,S3)) Q:'S3  D
 ..S DATA0=$G(^ORPA(101.52,S3,0)),DATA1=$G(^ORPA(101.52,S3,1)),DATA3=$G(^ORPA(101.52,S3,3)),DATA5=$G(^ORPA(101.52,S3,5))
 ..S ORIFN=$P(DATA0,"^"),ORRX=$P(DATA0,"^",2)
 ..Q:'+ORIFN
 ..S IND=""
 ..I +ORRX D
 ...S BACKDOOR=$P($G(^PSRX(ORRX,"PKI")),U,2)
 ...I BACKDOOR=1 S IND="B"
 ...S HARDCPY=$P($G(^PSRX(ORRX,999999941)),U,2)
 ...I HARDCPY=1 S IND="H"
 ..I ORRX="" S DA=$P($G(^OR(100,ORIFN,3)),"^",3) I +DA S DIC=100.01,DR=.01,DIQ="ORS" D EN^DIQ1 S ORRX=ORS(100.01,DA,.01)
 ..S ORRX=ORRX,ORPNM=$P(DATA5,"^"),ORDRUG=$E($P(DATA1,"^",2),1,22),ORDEA=$E($P(DATA1,"^",4)),ORQTY=$P(DATA1,"^",5)
 ..S ORDTE=$P(DATA1,U,1),PRV=$P(DATA3,U,4),ORPT=$P(DATA5,U,2),DRG=$P(DATA1,U,3)
 ..S DRCL=+$P($G(^PSDRUG(DRG,0)),U,3)
 ..S STR=ORIFN_U_ORDTE_U_PRV_U_ORPT_U_DRG_U_ORDRUG_U_DRCL_U_PRVNME_U_ORPNM_U_ORDEA_U_ORQTY_U_IND
 ..S CNT=CNT+1
 ..S ^TMP("CS","PT",$J,PRVNME,ORPNM,ORDRUG,CNT)=STR
 I CNT=0 S ^TMP("CS","PT",$J,PRVNAME)=""
 Q
 ;
PRINT ;Print out the results
 N LCNT,PAGES,DRG,PT,SDATE,LINE,PRVNME,DATA,PCNT,OLDPRV,PAGE,DRG
 K ^TMP("CSOUT",$J)
 S LCNT=0,PAGES=0,PCNT=5
 D HDR(.LCNT,.PAGES)
 S PRVNME=$O(^TMP("CS","PT",$J,""))
 S LCNT=LCNT+2,PCNT=PCNT+2,^TMP("CSOUT",$J,LCNT)="D^Provider: "_PRVNME
 I $D(^TMP("CS","PT",$J,PRVNME))<10 D
 .S LCNT=LCNT+1,PCNT=PCNT+1,^TMP("CSOUT",$J,LCNT)="D1"_U_"**No Data Found for Requested Date Range**"
 .I PCNT+3>IOSL S PAGES=PAGES+1 S PCNT=3
 S PT="" F  S PT=$O(^TMP("CS","PT",$J,PRVNME,PT)) Q:PT=""  D
 .S DRG="" F  S DRG=$O(^TMP("CS","PT",$J,PRVNME,PT,DRG)) Q:DRG=""  D
 ..S LINE="" F  S LINE=$O(^TMP("CS","PT",$J,PRVNME,PT,DRG,LINE)) Q:'+LINE  D
 ...S DATA=$G(^TMP("CS","PT",$J,PRVNME,PT,DRG,LINE))
 ...D SET(DATA,.LCNT,.PCNT)
 S PAGES=PAGES+1 ;Count the last page
 Q:+BEHQ
 D OUTPUT(.PAGES,.PAGE)
 Q
SET(NODE,LCNT,PCNT) ;Set the data into an array
 N SDTE,PTNM,HRCN,DOB,DFN,ORIEN,PHARM,QUANT,DEA,DRUG
 S SDTE=$P($TR($$FMTE^XLFDT($P(NODE,U,2),"5Z"),"@"," "),":",1,2)
 S PTNM=$P(NODE,U,9)
 S DFN=$P(NODE,U,4)
 S DRUG=$P(NODE,U,6)
 S ORIEN=$P(NODE,U,1)
 S DEA=$P(NODE,U,10)
 S QUANT=$P(NODE,U,11)
 S IND=$P(NODE,U,12)
 S LCNT=LCNT+1,PCNT=PCNT+1,^TMP("CSOUT",$J,LCNT)="P1"_U_PTNM_U_DRUG_U_QUANT_U_DEA_U_SDTE_U_IND
 I PCNT+3>IOSL D
 .S ^TMP("MGH",PAGES)=$G(^TMP("CSOUT",$J,LCNT))_U_IOSL_U_PCNT
 .S PAGES=PAGES+1 S PCNT=3
 Q
HDR(LCNT,PAGES) ;Create the header
 S LCNT=LCNT+1,^TMP("CSOUT",$J,LCNT)="H^Provider Controlled Substances Ad Hoc Report. Run:"_$P($TR($$FMTE^XLFDT($$NOW^XLFDT,"5Z"),"@"," "),":",1,2)
 S LCNT=LCNT+1,^TMP("CSOUT",$J,LCNT)="H^Report Criteria:"
 S LCNT=LCNT_1,^TMP("CSOUT",$J,LCNT)="H^  Inclusive Dates: "_BEHBDF_" to "_BEHEDF
 S LCNT=LCNT+1,^TMP("CSOUT",$J,LCNT)="H^  Provider: "_$$GET1^DIQ(200,BEHPROV,.01)
 S LCNT=LCNT+1,^TMP("CSOUT",$J,LCNT)="H^  Sorted by: Patient"
 S LCNT=LCNT+1,^TMP("CSOUT",$J,LCNT)="H^  Type of Data: SENSITIVE (CUI:PRVCY),(CUI:HLTH)"
 S PAGES=1,PCNT=5
 Q
OUTPUT(PAGES,PAGE) ;Output the data
 N IEN,DATA
 S PAGE=1
 S IEN="" F  S IEN=$O(^TMP("CSOUT",$J,IEN)) Q:'+IEN!(+BEHQ)  D
 .S DATA=$G(^TMP("CSOUT",$J,IEN))
 .I $P(DATA,U,1)="D"  W !,?1,$P(DATA,U,2)
 .I $P(DATA,U,1)="D1" W !!,?1,$P(DATA,U,2)
 .I $P(DATA,U,1)="H" D
 ..W !,$P(DATA,U,2)
 ..I $P(DATA,U,2)["Type of Data:" D  Q:+BEHQ
 ...W !,"Report contains "_PAGES_" pages"
 ...D PAUS(.PAGE)
 ...Q:+BEHQ
 ...S $Y=0
 ...D HEAD    ; do a page header
 .I $P(DATA,U,1)="P1" D
 ..W !,?2,$E($P(DATA,U,2),1,22),?25,$E($P(DATA,U,3),1,20),?48,$P(DATA,U,4),?55,$P(DATA,U,5),?60,$P(DATA,U,6),?72,$P(DATA,U,7)
 .I $Y+3>IOSL D  Q:+BEHQ
 ..D PAUS(.PAGE)
 ..I $G(IOT)["HFS" S $Y=0
 ..Q:+BEHQ
 ..D HEAD
 W !,?40,PAGE_" of "_PAGES
 Q
HEAD ;OUTPUT PAGE HEADER
 W !,?35,"SENSITIVE INFORMATION"
 W !,?3,"PATIENT NAME",?25,"DRUG NAME",?48,"QTY",?55,"SCH",?60,"ISSUE DATE",?72,"ORD"
 W !
 Q
PAUS(PAGE) ;EP
 D PGBRK
 Q:+BEHQ
 S PAGE=PAGE+1
 S $Y=0
 Q
PGBRK ;Call for page break
 N I,X,DUOUT,DTOUT,DIR
 I $D(IOST),$E(IOST)["C" F I=$Y:1:IOSL-3 W !
 W !,?40,"Page "_PAGE_" of "_PAGES
 I $S($D(IOST):$E(IOST)["C",1:1) D
 .S DIR("?")="Enter '^' to Halt or Press Return to continue"
 .S DIR(0)="FO",DIR("A")="Press Return to continue or '^' to Halt"
 .D ^DIR
 .I $D(DUOUT) S BEHQ=1
 Q
DELIM ;Print out the results
 N LCNT,PAGES,DRG,PT,SDATE,LINE,PRVNME,DATA,PCNT,OLDPRV,PAGE,DRG
 K ^TMP("CSOUT",$J)
 S LCNT=0
 D HDRXML
 S PRVNME=$O(^TMP("CS","PT",$J,""))
 S PT="" F  S PT=$O(^TMP("CS","PT",$J,PRVNME,PT)) Q:PT=""  D
 .S DRG="" F  S DRG=$O(^TMP("CS","PT",$J,PRVNME,PT,DRG)) Q:DRG=""  D
 ..S LINE="" F  S LINE=$O(^TMP("CS","PT",$J,PRVNME,PT,DRG,LINE)) Q:'+LINE  D
 ...S DATA=$G(^TMP("CS","PT",$J,PRVNME,PT,DRG,LINE))
 ...D SET2(DATA,.LCNT)
 Q:+BEHQ
 D OUTPUT2
 W !,$$TAG("AdHoc",1)
 W !,$$TAG("Report",1)
 Q
SET2(NODE,LCNT) ;Set the data into an array
 N SDTE,PTNM,HRCN,DOB,DFN,ORIEN,PHARM,QUANT,DEA
 S SDTE=$P($TR($$FMTE^XLFDT($P(NODE,U,2),"5Z"),"@"," "),":",1,2)
 S PTNM=$P(NODE,U,9)
 S DFN=$P(NODE,U,4)
 S DRUG=$P(NODE,U,6)
 S ORIEN=$P(NODE,U,1)
 S DEA=$P(NODE,U,10)
 S QUANT=$P(NODE,U,11)
 S IND=$P(NODE,U,12)
 S LCNT=LCNT+1,^TMP("CSOUT",$J,LCNT)="P1"_U_PTNM_U_DRUG_U_QUANT_U_DEA_U_SDTE_U_IND
 Q
OUTPUT2 ;Output the data
 N IEN,DATA
 S IEN="" F  S IEN=$O(^TMP("CSOUT",$J,IEN)) Q:'+IEN!(+BEHQ)  D
 .S DATA=$G(^TMP("CSOUT",$J,IEN))
 .I $P(DATA,U,1)="P1" D
 .W !,$$TAG("Order")
 .W !,$$TAG("Patient",2,$P(DATA,U,2))
 .W !,$$TAG("Drug",2,$P(DATA,U,3))
 .W !,$$TAG("Quantity",2,$P(DATA,U,4))
 .W !,$$TAG("DEASchedule",2,$P(DATA,U,5))
 .W !,$$TAG("IssueDate",2,$P(DATA,U,6))
 .W !,$$TAG("NotDigSig",2,$P(DATA,U,7))
 .W !,$$TAG("Order",1)
 Q
HDRXML ;EP - XML Header
 N S
 W $$XMLHDR^MXMLUTL()  ;"<?xml version='1.0'?>"
 W !,$$TAG("Report")
 W !,$$TAG("ReportName",2,"Provider Controlled Substance Ad Hoc Report.")
 W !,$$TAG("ReportDate",2,$P($TR($$FMTE^XLFDT($$NOW^XLFDT,"5Z"),"@"," "),":",1,2))
 W !,$$TAG("ReportCriteria")
 W !,$$TAG("InclusiveDates",2,BEHBDF_" to "_BEHEDF)
 W !,$$TAG("Prescriber",2,"Provider: "_$$GET1^DIQ(200,BEHPROV,.01))
 W !,$$TAG("TypeData",2,"Type of Data: SENSITIVE (CUI:PRVCY),(CUI:HLTH)")
 W !,$$TAG("ReportCriteria",1)
 W !,$$TAG("AdHoc")
 Q
 ; Returns formatted tag
 ; Input: TAG - Name of Tag
 ;        TYPE - (-1) = empty 0 =start <tag>   1 =end </tag>  2 = start -VAL - end
 ;        VAL - data value
TAG(TAG,TYPE,VAL) ;EP
 S TYPE=$G(TYPE,0)
 S:$L($G(VAL)) VAL=$$SYMENC^MXMLUTL(VAL)
 I TYPE<0 Q "<"_TAG_"/>"  ;empty
 E  I TYPE=1 Q "</"_TAG_">"
 E  I TYPE=2 Q "<"_TAG_">"_$G(VAL)_"</"_TAG_">"
 Q "<"_TAG_">"
