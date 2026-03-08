APSPCAR1 ; IHS/MSC/PLS - EPCS AUDIT REPORT ;14-Mar-2019 17:51;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1023**;Sep 23, 2004;Build 121
 ;=====================================================================
 Q
PRINT ;EP
 N APSPPG,DFLG,NEWPG
 S (APSPPG,DFLG,NEWPG)=0
 I APSPXML D
 .D HDRXML
 .D PRINT1
 .W !,$$TAG("Audits",1)
 .W !,$$TAG("Report",1)
 E  D
 .D HDR
 .D PRINT1
 .W:'DFLG !,"No data found..."
 Q
 ;
PRINT1 ;EP
 N DIV,SUB1,SUB2,SUB3,SUB4,SUB5,VAL,LP,LSTFDT
 S LSTFDT=0
 I APSPXML W !,$$TAG("Divisions",0)
 S DIV="" F  S DIV=$O(^TMP($J,"XREF",DIV)) Q:DIV=""  D
 .I APSPDIV="*",'APSPXML W !!,"Division: "_$$GET1^DIQ(4,DIV,.01),!
 .I APSPRTYP=1 D  ; Summary report
 ..W:APSPXML !,$$TAG("Division",0)
 ..W:APSPXML !,$$TAG("DivisionName",2,$$GET1^DIQ(4,DIV,.01))
 ..I APSPSORT=2 D  ; Event Date/Drug Name
 ...S SUB1=0 F  S SUB1=$O(^TMP($J,"XREF",DIV,"AUDDT",SUB1)) Q:'SUB1  D
 ....S SUB2="" F  S SUB2=$O(^TMP($J,"XREF",DIV,"AUDDT",SUB1,SUB2)) Q:'$L(SUB2)  D
 .....S SUB3="" F  S SUB3=$O(^TMP($J,"XREF",DIV,"AUDDT",SUB1,SUB2,SUB3)) Q:'SUB3  D
 ......D STATS(^TMP($J,"DATA",SUB3))
 .....D PRINTSUM(APSPSORT,SUB2,.STATS,SUB1)
 .....K STATS
 .....S DFLG=1
 ....W !
 ..E  D  ; Drug Name
 ...S SUB1="" F  S SUB1=$O(^TMP($J,"XREF",DIV,"S-DRUG",SUB1)) Q:'$L(SUB1)  D
 ....S SUB2=0 F  S SUB2=$O(^TMP($J,"XREF",DIV,"S-DRUG",SUB1,SUB2)) Q:'SUB2  D
 .....D STATS(^TMP($J,"DATA",SUB2))
 ....D PRINTSUM(APSPSORT,SUB1,.STATS)
 ....K STATS
 ....S DFLG=1
 ..W:APSPXML !,$$TAG("Division",1)
 .E  D  ; Detailed report
 ..I APSPXML D
 ...W !,$$TAG("Division",0)
 ...W !,$$TAG("DivisionName",2,$$GET1^DIQ(4,DIV,.01))
 ..I APSPSORT=1 D  ; Drug Name
 ...S SUB1="" F  S SUB1=$O(^TMP($J,"XREF",DIV,"DRUG",SUB1)) Q:SUB1=""  D  ; Drug Name
 ....S SUB2=0 F  S SUB2=$O(^TMP($J,"XREF",DIV,"DRUG",SUB1,SUB2)) Q:'SUB2  D  ; Audit Date
 .....S SUB3=0 F  S SUB3=$O(^TMP($J,"XREF",DIV,"DRUG",SUB1,SUB2,SUB3)) Q:'SUB3  D  ; Data node
 ......D PRINT2(^TMP($J,"DATA",SUB3))
 ......S DFLG=1
 ..I APSPSORT=2 D  ; Event Date
 ...S SUB1=0 F  S SUB1=$O(^TMP($J,"XREF",DIV,"AUDDT",SUB1)) Q:'SUB1  D  ; Event Date
 ....S SUB2="" F  S SUB2=$O(^TMP($J,"XREF",DIV,"AUDDT",SUB1,SUB2)) Q:SUB2=""  D  ; Drug Name
 .....S SUB3=0 F  S SUB3=$O(^TMP($J,"XREF",DIV,"AUDDT",SUB1,SUB2,SUB3)) Q:'SUB3  D  ; Data node
 ......D PRINT2(^TMP($J,"DATA",SUB3))
 ......S DFLG=1
 ..I APSPSORT=3 D  ; Drug Class
 ...S SUB1="" F  S SUB1=$O(^TMP($J,"XREF",DIV,"DCLS",SUB1)) Q:'$L(SUB1)  D  ; Drug Class
 ....S SUB2="" F  S SUB2=$O(^TMP($J,"XREF",DIV,"DCLS",SUB1,SUB2)) Q:'$L(SUB2)  D  ; Drug Name
 .....S SUB3=0 F  S SUB3=$O(^TMP($J,"XREF",DIV,"DCLS",SUB1,SUB2,SUB3)) Q:'SUB3  D  ; Audit Date
 ......S SUB4=0 F  S SUB4=$O(^TMP($J,"XREF",DIV,"DCLS",SUB1,SUB2,SUB3,SUB4)) Q:'SUB4  D  ; Data node
 .......D PRINT2(^TMP($J,"DATA",SUB4))
 .......S DFLG=1
 ..I APSPSORT=4 D  ; Patient Name
 ...S SUB1="" F  S SUB1=$O(^TMP($J,"XREF",DIV,"PAT",SUB1)) Q:'$L(SUB1)  D  ; Patient Name
 ....S SUB2=0 F  S SUB2=$O(^TMP($J,"XREF",DIV,"PAT",SUB1,SUB2)) Q:'SUB2  D  ; Audit Date
 .....S SUB3="" F  S SUB3=$O(^TMP($J,"XREF",DIV,"PAT",SUB1,SUB2,SUB3)) Q:'$L(SUB3)  D  ; Drug Name
 ......S SUB4=0 F  S SUB4=$O(^TMP($J,"XREF",DIV,"PAT",SUB1,SUB2,SUB3,SUB4)) Q:'SUB4  D  ; Data node
 .......D PRINT2(^TMP($J,"DATA",SUB4))
 .......S DFLG=1
 ..I APSPSORT=5 D  ; Provider
 ...S SUB1="" F  S SUB1=$O(^TMP($J,"XREF",DIV,"PRV",SUB1)) Q:'$L(SUB1)  D  ; Provider
 ....S SUB2="" F  S SUB2=$O(^TMP($J,"XREF",DIV,"PRV",SUB1,SUB2)) Q:'$L(SUB2)  D  ; Drug Name
 .....S SUB3=0 F  S SUB3=$O(^TMP($J,"XREF",DIV,"PRV",SUB1,SUB2,SUB3)) Q:'SUB3  D  ; Audit Date
 ......S SUB4=0 F  S SUB4=$O(^TMP($J,"XREF",DIV,"PRV",SUB1,SUB2,SUB3,SUB4)) Q:'SUB4  D  ; Data node
 .......D PRINT2(^TMP($J,"DATA",SUB4))
 .......S DFLG=1
 ...I APSPDET,APSPPRV'="*" D PRTDSUM
 ..I APSPSORT=6 D  ; Event Actor
 ...S SUB1="" F  S SUB1=$O(^TMP($J,"XREF",DIV,"USR",SUB1)) Q:SUB1=""  D  ; Event Actor
 ....S SUB2="" F  S SUB2=$O(^TMP($J,"XREF",DIV,"USR",SUB1,SUB2)) Q:'SUB2  D  ; Audit Date
 .....S SUB3=0 F  S SUB3=$O(^TMP($J,"XREF",DIV,"USR",SUB1,SUB2,SUB3)) Q:'$L(SUB3)  D  ; Drug Name
 ......S SUB4=0 F  S SUB4=$O(^TMP($J,"XREF",DIV,"USR",SUB1,SUB2,SUB3,SUB4)) Q:'SUB4  D  ; Data node
 .......D PRINT2(^TMP($J,"DATA",SUB4))
 .......S DFLG=1
 ...I APSPDET,APSPUSR'="*" D PRTDSUM
 ..W:APSPXML !,$$TAG("Division",1)
 .K STATS
 D:APSPDET PRTRTOT
 I APSPXML W !,$$TAG("Divisions",1)
 Q
 ; Print Summary report line
PRINTSUM(RPTTYP,DRGNM,STATS,AUDDT) ;EP -
 N DAT
 S DAT=$G(STATS("DRUGN",DRGNM))
 I APSPXML D
 .W !,$$TAG("AuditSummary")
 .W:$G(AUDDT) !,$$TAG("EventDate",2,$P($TR($$FMTE^XLFDT(AUDDT,"5Z"),"@"," "),":",1,2))
 .W !,$$TAG("DrugName",2,DRGNM)
 .W !,$$TAG("AuditCount",2,$J(STATS("ENTRIES"),6))
 .W !,$$TAG("Events",2,$J(STATS("EVENTS"),8))
 .W !,$$TAG("AvgEventsPerAuditRecord",2,$J(STATS("EVENTS")\STATS("ENTRIES"),6,1))
 .W !,$$TAG("AuditSummary",1)
 E  D
 .I $G(AUDDT),((AUDDT'=LSTFDT)!NEWPG) D
 ..W "Event Date: ",$$FMTE^XLFDT(AUDDT,"5Z"),!
 ..S LSTFDT=AUDDT
 .W DRGNM,?44,$J(STATS("ENTRIES"),6),?51,$J(STATS("EVENTS"),8),?64,$J(STATS("EVENTS")\STATS("ENTRIES"),6,1),!
 .S NEWPG=0
 .D PRINT3  ; check page length
 Q
 ; Output summary for detail report
PRTDSUM ; EP -
 N DRUGN,RX,RXCNT
 Q:'APSPETOT  ; User didn't ask for totals
 I APSPXML D
 .W !,$$TAG("ReportSubTotals")
 .S DRUGN="" F  S DRUGN=$O(STATS("DRUGN",DRUGN)) Q:DRUGN=""  D
 ..W !,$$TAG("DrugName",2,$P(STATS("DRUGN",DRUGN),U,3))
 ..W !,$$TAG("AuditCount",2,$J(STATS("DRUGN",DRUGN),6,0))
 .W !,$$TAG("ReportSubTotals",1)
 E  D
 .D PRINT3
 .W !,"Report sub-totals",!
 .W !,?5,"Drug Name",?47,"Audit Count",!
 .S DRUGN="" F  S DRUGN=$O(STATS("DRUGN",DRUGN))  Q:DRUGN=""  D
 ..W ?5,DRUGN,?47,$J(STATS("DRUGN",DRUGN),6,0),!
 ..D PRINT3
 .W !,"Total audit entries: ",+$G(STATS("ENTRIES"))
 Q
 ; Output totals for report
PRTRTOT ; EP -
 N DRUGN,RX,AUCNT
 Q:'APSPETOT  ; User didn't ask for totals
 I APSPXML D
 .W !,$$TAG("ReportTotals")
 .S DRUGN="" F  S DRUGN=$O(APSPRTOT("DRUGN",DRUGN)) Q:DRUGN=""  D
 ..W !,$$TAG("DrugName",2,DRUGN)
 ..W !,$$TAG("AuditCount",2,$J(APSPRTOT("DRUGN",DRUGN),6,0))
 ..S RX=0 F  S RX=$O(APSPRTOT("RXS",RX)) Q:'RX  D
 ...S AUCNT=$G(AUCNT)+1
 ..W:$G(AUCNT) !,$$TAG("TotalAuditCount",2,AUCNT)
 .W !,$$TAG("TotalAuditCount",2,$G(APSPRTOT("ENTRIES")))
 .W !,$$TAG("ReportTotals",1)
 E  D
 .D PRINT3
 .W !!,"Report Totals",!
 .W !,?5,"Drug Name",?47,"Audit Count",!
 .S DRUGN="" F  S DRUGN=$O(APSPRTOT("DRUGN",DRUGN))  Q:DRUGN=""  D
 ..W ?5,DRUGN,?47,$J(APSPRTOT("DRUGN",DRUGN),6,0),!
 ..D PRINT3
 .W !,"Total audit entries: ",+$G(APSPRTOT("ENTRIES"))
 Q
 ; Print the line
PRINT2(DATA) ; EP -
 N RX,DFN,HRN,ORIEN
 S ORIEN=$P(DATA,U,3)
 S RX=$P(DATA,U,4)
 S DFN=$P(DATA,U,5)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 D STATS(DATA)
 I APSPXML D
 .W !,$$TAG("Audit")
 .W !,$$TAG("EventDate",2,$P($TR($$FMTE^XLFDT($P(DATA,U,2),"5Z"),"@"," "),":",1,2))
 .W !,$$TAG("AuditIEN",2,$P(DATA,U))
 .W !,$$TAG("Type",2,$P(DATA,U,7))
 .W !,$$TAG("PatientName",2,$$GET1^DIQ(2,DFN,.01))
 .W !,$$TAG("PatientHRN",2,HRN)
 .W !,$$TAG("OrderNumber",2,$P(DATA,U,3))
 .W !,$$TAG("PrescriptionNumber",2,$$GET1^DIQ(52,RX,.01))
 .W !,$$TAG("DrugName",2,$P(DATA,U,8))
 .W !,$$TAG("DrugSchedule",2,$P(DATA,U,7))
 .W !,$$TAG("Prescriber",2,$$GET1^DIQ(200,$P(DATA,U,6),.01))
 .W !,$$TAG("PrescriberDEA",2,$$GET1^DIQ(200,$P(DATA,U,6),53.2))
 .W !,$$TAG("AuditUser",2,$$GET1^DIQ(200,$P(DATA,U,13),.01))
 .W !,$$TAG("Result",2,$S($P(DATA,U,14):"FAILURE",1:"SUCCESS"))
 .D:APSPEACT BLDACTVY($P(DATA,U))
 .W !,$$TAG("Audit",1)
 E  D
 .W !,$P($TR($$FMTE^XLFDT($P(DATA,U,2),"5Z"),"@"," "),":",1,2),?18,$E($$GET1^DIQ(2,DFN,.01),1,16),?40,HRN,?48,$$GET1^DIQ(52,RX,.01),?60,$P(DATA,U,8),?107,$P(DATA,U,7),?115,ORIEN,?128,$S($P(DATA,U,14):"FAIL",1:"SUCC")
 .W !,?5,$$GET1^DIQ(200,$P(DATA,U,6),.01),?35,$$GET1^DIQ(200,$P(DATA,U,6),53.2),?47,$$GET1^DIQ(200,$P(DATA,U,13),.01),?78,$P(DATA,U)
 .D PRINT3 ;check page length
 Q
 ; Check page length and optionally print blank line
 ;
PRINT3 ;EP
 D:$Y+8>IOSL HDR
 Q
 ;
HDR ;EP
 N S
 S S=APSPSORT
 W:APSPPG @IOF
 S APSPPG=APSPPG+1,NEWPG=1
 W !,"EPCS Audit Report ("_$S(APSPRTYP=1:"Summary",1:"Detail")_")",?(IOM-28),$P($TR($$FMTE^XLFDT($$NOW^XLFDT,"5Z"),"@"," "),":",1,2),?(IOM-10),"Page: "_APSPPG
 W !,"Report Criteria:"
 W !,?5,"Inclusive Event Dates: "_APSPBDF_" to "_APSPEDF
 W !,?5,"Division: "_$S(APSPDIV:$$GET1^DIQ(4,APSPDIV,.01),1:"All")
 W !,?5,"Drug Class: "_APSPDCTN(APSPDCLS)
 W !,?5,"Order Attempts: "_$S(APSPATMP=3:"Exclusive",$$ISEXCLU^APSPCAR()!(APSPATMP=2):"Excluded",1:"Included")
 W !,?5,"Tampered: "_$S(APSPTMR=3:"Exclusive",$$ISEXCLU^APSPCAR()!(APSPTMR=2):"Excluded",1:"Included")
 W !,?5,"Pharmacy Initiated: "_$S(APSPBAK=3:"Exclusive",$$ISEXCLU^APSPCAR()!(APSPBAK=2):"Excluded",1:"Included")
 I APSPRTYP=2 D
 .W !,?5,"Sorted by: "_$S(S=1:"Drug Name, Event Date",S=3:"Drug Schedule, Drug Name then Event Date",S=2:"Event Date then Drug Name",S=4:"Patient then Event Date",S>4:$S(S=5:"Prescriber",1:"Actor")_" then Drug Name, Event Date",1:"Unknown")
 E  D
 .W !,?5,"Sorted by: "_$S(S=1:"Drug Name",1:"Event Date then Drug Name")
 I APSPDET,APSPSORT=4,APSPPAT W !,?7,"Patient sort restricted to ",$$GET1^DIQ(2,APSPPAT,.01)
 I APSPDET,APSPSORT=5,APSPPRV W !,?7,"Prescriber sort restricted to ",$$GET1^DIQ(200,APSPPRV,.01)
 I APSPDET,APSPSORT=6,APSPUSR W !,?7,"Actor sort restricted to ",$$GET1^DIQ(200,APSPUSR,.01)
 D HDR1:APSPRTYP=2,HDR2:APSPRTYP=1
 Q
 ;
HDR1 ;EP
 D DASH()
 W "Event Date",?18,"Patient",?40,"HRN",?48,"Rx Number",?60,"Drug Name",?107,"Drg Sch",?115,"Order Num",?125,"Result"
 W !,?5,"Prescriber",?35,"DEA Number",?47,"Event Actor",?78,"Audit IEN"
 D DASH()
 Q
HDR2 ;EP - Summary Report Header
 D DASH()
 D PRINT3
 W ?44,"# AUDIT",?55,"#Event",?68,"Avg",!
 W "Drug Name",?44,"Records",?55,"Records",?64,"Event/Audit"
 D DASH()
 Q
 ;
HDRXML ;EP - XML Header
 N S
 S S=APSPSORT
 W $$XMLHDR^MXMLUTL()  ;"<?xml version='1.0'?>"
 W !,$$TAG("Report")
 W !,$$TAG("ReportName",2,"EPCS Audit Report ("_$S(APSPRTYP=1:"Summary",1:"Detail")_")")
 W !,$$TAG("ReportDate",2,$P($TR($$FMTE^XLFDT($$NOW^XLFDT,"5Z"),"@"," "),":",1,2))
 W !,$$TAG("ReportCriteria")
 W !,$$TAG("InclusiveDates",2,APSPBDF_" to "_APSPEDF)
 W !,$$TAG("Division",2,$S(APSPDIV:$$GET1^DIQ(4,APSPDIV,.01),1:"All"))
 W !,$$TAG("DrugClass",2,APSPDCTN(APSPDCLS))
 W !,$$TAG("OrderAttempts",2,$S(APSPATMP=3:"Only order attempts",APSPATMP=2:"Exluded",1:"Included"))
 W !,$$TAG("Tampered",2,$S(APSPTMR=3:"Only tampered entries",APSPTMR=2:"Excluded",1:"Included"))
 W !,$$TAG("Pharmacyorderentry",2,$S(APSPBAK=3:"Only Pharmacy orders",APSPBAK=2:"Excluded",1:"Included"))
 W:APSPDET !,$$TAG("SortBy",2,$S(S=1:"Drug Name, Event Date",S=3:"Drug Schedule, Drug Name then Event Date",S=2:"Event Date, Drug Name",S=4:"Patient, Event Date",S>4:$S(S=5:"Prescriber",1:"Actor")_", Drug Name then Event Date",1:"Unknown"))
 I APSPDET,S=4,APSPPAT W !,$$TAG("Patient",2,$S(APSPPAT:$$GET1^DIQ(2,APSPPAT,.01),1:"All"))
 I APSPDET,S=5,APSPPRV W !,$$TAG("Prescriber",2,$S(APSPPRV:$$GET1^DIQ(200,APSPPRV,.01),1:"All"))
 I APSPDET,S=6,APSPUSR W !,$$TAG("Actor",2,$S(APSPUSR:$$GET1^DIQ(200,APSPUSR,.01),1:"All"))
 W !,$$TAG("ReportCriteria",1)
 W !,$$TAG("Audits")
 Q
 ;
DASH(LEN) ;EP-
 N DASH
 S LEN=$G(LEN,IOM)
 W ! F DASH=1:1:LEN W "-"
 W !
 Q
 ;
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
 ; Calculate statistics
STATS(DAT) ;EP -
 N LP,RX,DRUG,DRUGN,QTY,FDT,RXCNT,DRUGNU,EVCNT,AUDDT,AIEN
 S AIEN=$P(DAT,U)
 S RX=$P(DAT,U,4)
 S DRUG=$P(DAT,U,11)
 S DRUGN=$P(DAT,U,8)
 S DRUGNU=$$UP^XLFSTR(DRUGN)
 S AUDDT=$P(DAT,U,2)
 S DIV=+$P(DAT,U,12)
 S STATS("ENTRIES")=+$G(STATS("ENTRIES"))+1
 S APSPRTOT("ENTRIES")=$G(APSPRTOT("ENTRIES"))+1
 S STATS("EVENTS")=+$G(STATS("EVENTS"))+$$EVTPREC(+DAT)
 S APSPRTOT("EVENTS")=+$G(STATS("EVENTS"))+$$EVTPREC(+DAT)
 S STATS("DRUGN",DRUGNU)=+$G(STATS("DRUGN",DRUGNU))+1
 S APSPRTOT("DRUGN",DRUGNU)=+$G(APSPRTOT("DRUGN",DRUGNU))+1
 Q
 ;Return events for a record
EVTPREC(AIEN) ;EP-
 N CNT,LP
 S CNT=0
 S LP=0 F  S LP=$O(^APSPCSA(AIEN,1,LP)) Q:'LP  S CNT=CNT+1
 Q CNT
 ;Build XML data tags for STATUS multiple of Audit record
BLDACTVY(AIEN) ;EP-
 N LP,N0,N2,ORDTXT
 W !,$$TAG("Activities")
 S LP=0 F  S LP=$O(^APSPCSA(AIEN,1,LP)) Q:'LP  D
 .W !,$$TAG("Activity")
 .S N0=$G(^APSPCSA(AIEN,1,LP,0)),N2=$G(^APSPCSA(AIEN,1,LP,2))
 .W !,$$TAG("ActivityIEN",2,LP)
 .W !,$$TAG("DEAStatus",2,$$GET1^DIQ(9009036.01,LP_","_AIEN_",",.06))
 .W !,$$TAG("Date",2,$P($TR($$FMTE^XLFDT($P(N0,U,2),"5Z"),"@"," "),":",1,2))
 .W !,$$TAG("Drug",2,$$GET1^DIQ(50,$P(N0,U,3),.01))
 .W !,$$TAG("Reason",2,$P(N0,U,4))
 .W !,$$TAG("DrugSchedule",2,$P(N0,U,5))
 .W !,$$TAG("OrderText",2,$$BLDORDTX(AIEN,LP))
 .W !,$$TAG("Checksum",2,$P(N2,U))
 .W !,$$TAG("Orderable",2,$$GET1^DIQ(101.43,$P(N2,U,2),.01))
 .W !,$$TAG("Activity",1)
 W !,$$TAG("Activities",1)
 Q
 ;Return a string containing order text. Lines are separated by a space.
BLDORDTX(AIEN,EIEN) ;EP-
 N LP
 S TXT=""
 S LP=0 F  S LP=$O(^APSPCSA(AIEN,1,EIEN,1,LP)) Q:'LP  D
 .S TXT=TXT_$S($L(TXT):" ",1:"")_^APSPCSA(AIEN,1,EIEN,1,LP,0)
 Q TXT
