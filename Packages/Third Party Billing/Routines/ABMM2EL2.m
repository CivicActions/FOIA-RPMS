ABMM2EL2 ;IHS/SD/SDR - Meaningful Use Report - count patients/eligibility ;
 ;;2.6;IHS 3P BILLING SYSTEM;**11,12,32**;NOV 12, 2009;Build 621
 ;IHS/SD/SDR 2.6*32 CR9862 Split from ABMM2ELG; Updated Medicare/Railroad for MBI, default to HICN, with <NO MBI/HICN> if neither present
 ;
GETPTS ;
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^AUPNPAT(ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .I $D(^AUPNPAT(ABMP("PDFN"),41,DUZ(2))) D
 ..S ABMPTINA=$P($G(^AUPNPAT(ABMP("PDFN"),41,DUZ(2),0)),U,3)  ;dt inactive/deleted
 ..I ABMPTINA'=""&((ABMPTINA<ABMY("DT",1))!(ABMPTINA>ABMY("DT",2))) Q  ;pt inactive prior to or after range
 ..S ^TMP($J,"ABM-M2RPT","PTS",ABMP("PDFN"))=""
 ..S ^TMP($J,"ABM-M2RPT","CNT","PTS")=+$G(^TMP($J,"ABM-M2RPT","CNT","PTS"))+1  ;count pts
 Q
 ;
GETELIG ;
 ;medicaid
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-M2RPT","PTS",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .I $D(^AUPNMCD("B",ABMP("PDFN"))) D  ;pt has medicaid entry
 ..S ABMP("MDFN")=0
 ..F  S ABMP("MDFN")=$O(^AUPNMCD("B",ABMP("PDFN"),ABMP("MDFN"))) Q:'ABMP("MDFN")  D
 ...S ABMP("EFFDT")=0,ABMMFLG=0
 ...F  S ABMP("EFFDT")=$O(^AUPNMCD(ABMP("MDFN"),11,ABMP("EFFDT"))) Q:'ABMP("EFFDT")  D  Q:(ABMMFLG=1)
 ....S ABMP("ENDDT")=$P($G(^AUPNMCD(ABMP("MDFN"),11,ABMP("EFFDT"),0)),U,2)  ;end dt
 ....;eff dt after end of range or end dt before start of range
 ....I (ABMP("EFFDT")>ABMY("DT",2))!((ABMP("ENDDT")'="")&(ABMP("ENDDT")<ABMY("DT",1))) Q
 ....S ABMMFLG=1  ;if it gets here pt has elig in our window
 ...I ABMMFLG=1 D  ;pt has at least one entry that's what we want
 ....S ^TMP($J,"ABM-M2RPT","MCD",ABMP("PDFN"),ABMP("MDFN"))=""
 ....S ^TMP($J,"ABM-M2RPT","CNT","MCD")=+$G(^TMP($J,"ABM-M2RPT","CNT","MCD"))+1  ;cnt medicaid pts
 ;
 ;medicare
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-M2RPT","PTS",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .I $D(^AUPNMCR(ABMP("PDFN"))) D  ;pt had medicare entry
 ..S ABMP("MDFN")=0,ABMMFLG=0
 ..F  S ABMP("MDFN")=$O(^AUPNMCR(ABMP("PDFN"),11,ABMP("MDFN"))) Q:'ABMP("MDFN")  D  Q:(ABMMFLG=1)
 ...S ABMP("EFFDT")=$P($G(^AUPNMCR(ABMP("PDFN"),11,ABMP("MDFN"),0)),U)  ;eff dt
 ...S ABMP("ENDDT")=$P($G(^AUPNMCR(ABMP("PDFN"),11,ABMP("MDFN"),0)),U,2)  ;end dt
 ...;eff dt after end of range or end dt before start of range
 ...I (ABMP("EFFDT")>ABMY("DT",2))!((ABMP("ENDDT")'="")&(ABMP("ENDDT")<ABMY("DT",1))) Q
 ...S ABMMFLG=1  ;if it gets here pt has elig in our window
 ..I ABMMFLG=1 D  ;pt has at least one entry that's what we want
 ...S ^TMP($J,"ABM-M2RPT","MCR",ABMP("PDFN"),ABMP("MDFN"))=""
 ...S ^TMP($J,"ABM-M2RPT","CNT","MCR")=+$G(^TMP($J,"ABM-M2RPT","CNT","MCR"))+1  ;cnt medicare pts
 ;
 ;railroad
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-M2RPT","PTS",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .I $D(^AUPNRRE(ABMP("PDFN"))) D  ;pt had medicare entry
 ..S ABMP("MDFN")=0,ABMMFLG=0
 ..F  S ABMP("MDFN")=$O(^AUPNRRE(ABMP("PDFN"),11,ABMP("MDFN"))) Q:'ABMP("MDFN")  D  Q:(ABMMFLG=1)
 ...S ABMP("EFFDT")=$P($G(^AUPNRRE(ABMP("PDFN"),11,ABMP("MDFN"),0)),U)  ;eff dt
 ...S ABMP("ENDDT")=$P($G(^AUPNRRE(ABMP("PDFN"),11,ABMP("MDFN"),0)),U,2)  ;end dt
 ...;eff dt after end of range or end dt before start of range
 ...I (ABMP("EFFDT")>ABMY("DT",2))!((ABMP("ENDDT")'="")&(ABMP("ENDDT")<ABMY("DT",1))) Q
 ...S ABMMFLG=1  ;if it gets here pt has elig in our window
 ..I ABMMFLG=1 D  ;pt has at least one entry that's what we want
 ...S ^TMP($J,"ABM-M2RPT","RR",ABMP("PDFN"),ABMP("MDFN"))=""
 ...S ^TMP($J,"ABM-M2RPT","CNT","RR")=+$G(^TMP($J,"ABM-M2RPT","CNT","RR"))+1  ;cnt railroad pts
 ;
 ;private
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-M2RPT","PTS",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .I $D(^AUPNPRVT(ABMP("PDFN"))) D  ;pt has private entry
 ..S ABMP("MDFN")=0,ABMMFLG=0
 ..F  S ABMP("MDFN")=$O(^AUPNPRVT(ABMP("PDFN"),11,ABMP("MDFN"))) Q:'ABMP("MDFN")  D  Q:(ABMMFLG=1)
 ...S ABMP("EFFDT")=$P($G(^AUPNPRVT(ABMP("PDFN"),11,ABMP("MDFN"),0)),U,6)  ;eff dt
 ...S ABMP("ENDDT")=$P($G(^AUPNPRVT(ABMP("PDFN"),11,ABMP("MDFN"),0)),U,7)  ;end dt
 ...;eff dt after end of range or end dt before start of range
 ...I (ABMP("EFFDT")>ABMY("DT",2))!((ABMP("ENDDT")'="")&(ABMP("ENDDT")<ABMY("DT",1))) Q
 ...S ABMMFLG=1  ;if it gets here pt has eligibility in our window
 ..I ABMMFLG=1 D  ;pt has at least one entry that's what we want
 ...S ^TMP($J,"ABM-M2RPT","PI",ABMP("PDFN"),ABMP("MDFN"))=""
 ...S ^TMP($J,"ABM-M2RPT","CNT","PI")=+$G(^TMP($J,"ABM-M2RPT","CNT","PI"))+1  ;cnt private pts
 ;
 ;no insurance
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-M2RPT","PTS",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .I '$D(^TMP($J,"ABM-M2RPT","PI",ABMP("PDFN")))&'$D(^TMP($J,"ABM-M2RPT","MCD",ABMP("PDFN")))&'$D(^TMP($J,"ABM-M2RPT","MCR",ABMP("PDFN")))&'$D(^TMP($J,"ABM-M2RPT","RR",ABMP("PDFN"))) D
 ..S ^TMP($J,"ABM-M2RPT","CNT","NO")=+$G(^TMP($J,"ABM-M2RPT","CNT","NO"))+1  ;cnt no insurance pts
 ..S ^TMP($J,"ABM-M2RPT","NO",ABMP("PDFN"))=""
 ;
 Q
 ;
GETVSTS ;
 S ABMP("SDT")=ABMY("DT",1)-.5
 S ABMP("EDT")=ABMY("DT",2)+.999999
 F  S ABMP("SDT")=$O(^AUPNVSIT("B",ABMP("SDT"))) Q:('ABMP("SDT")!(ABMP("SDT")>ABMP("EDT")))  D
 .S ABMP("VDFN")=0
 .F  S ABMP("VDFN")=$O(^AUPNVSIT("B",ABMP("SDT"),ABMP("VDFN"))) Q:'ABMP("VDFN")  D
 ..S ABMPT=$P($G(^AUPNVSIT(ABMP("VDFN"),0)),U,5)  ;pt
 ..Q:ABMPT=""  ;no pt on visit
 ..I '$D(^TMP($J,"ABM-M2RPT","PTS",ABMPT)) Q  ;not one of our pts
 ..S ^TMP($J,"ABM-M2RPT","ENC",ABMP("VDFN"))=""
 ..S ^TMP($J,"ABM-M2RPT","CNT","ENC")=+$G(^TMP($J,"ABM-M2RPT","CNT","ENC"))+1  ;cnt encounters
 ..I '$D(^TMP($J,"ABM-M2RPT","UNQ",ABMPT)) D
 ...S ^TMP($J,"ABM-M2RPT","UNQ",ABMPT)=""
 ...S ^TMP($J,"ABM-M2RPT","CNT","UNQ")=+$G(^TMP($J,"ABM-M2RPT","CNT","UNQ"))+1  ;cnt unique pts
 Q
