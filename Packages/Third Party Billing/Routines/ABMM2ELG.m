ABMM2ELG ;IHS/SD/SDR - Meaningful Use Report - count patients/eligibility ;
 ;;2.6;IHS 3P BILLING SYSTEM;**11,12,32**;NOV 12, 2009;Build 621
 ;IHS/SD/SDR 2.6*32 CR9862 Split routine to ABMM2EL2; Updated Medicare/Railroad for MBI, default to HICN, with <NO MBI/HICN> if neither present
 W !!,"The date range selected will be used for: "
 W !,?3,"1. Was the patient's record active during that range"
 W !,?3,"2. Did the patient have eligibility in that range"
 W !,?3,"3. How many encounters they had during that time"
 W !!,"Detail information will be supplied for validation purposes but once validated"
 W !,"the summary option should be used."
 K ABMY,ABMP
 K ^TMP($J,"ABM-M2RPT")
DT ;
 W !!," ============ Entry of Date Range =============",!
 D ^XBFMK
 S DIR("A")="Enter STARTING Date"
 S DIR(0)="DO^::EP"
 D ^DIR
 Q:$D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)
 S ABMY("DT",1)=Y
 W !
 S DIR("A")="Enter ENDING Date"
 D ^DIR
 K DIR
 G DT:$D(DIRUT)
 S ABMY("DT",2)=Y
 I ABMY("DT",1)>ABMY("DT",2) W !!,*7,"INPUT ERROR: Start Date is Greater than than the End Date, TRY AGAIN!",!! G DT
RTYPE ;summary or detail?
 W !
 K DIC,DIE,DIR,X,Y,DA
 S DIR(0)="S^S:SUMMARY;D:DETAIL (will include Summary)"
 S DIR("A")="SUMMARY OR DETAIL"
 S DIR("B")="SUMMARY"
 D ^DIR K DIR
 S ABMSUMDT=Y
 ;
SEL ;
 ;Select device
 I ABMSUMDT="D" D
 .W !!,"There will be two outputs, one for SUMMARY and one for DETAIL."
 .W !,"The first one should be a terminal or a printer."
 .W !,"The second forces an HFS file because it could be a large file",!
 S %ZIS="NQ"
 S %ZIS("A")="Enter DEVICE: "
 D ^%ZIS Q:POP
 U IO(0) W !!,"Searching...."
 I IO=IO(0) D TOTALS S DIR(0)="E" D ^DIR K DIR
 I IO'=IO(0) D QUE^ABMM2ELG,HOME^%ZIS S DIR(0)="E" D ^DIR K DIR Q
 I $D(IO("S")) S IOP=ION D ^%ZIS
 D ^%ZISC
 D HOME^%ZIS
 ;
 I ABMSUMDT="D" D
 .W !!,"Will now write detail to file",!!
 .D ^XBFMK
 .S DIR(0)="F"
 .S DIR("A")="Enter Path"
 .S DIR("B")=$P($G(^ABMDPARM(DUZ(2),1,4)),"^",7)
 .D ^DIR K DIR
 .Q:$D(DIRUT)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .S ABMPATH=Y
 .S DIR(0)="F",DIR("A")="Enter File Name"
 .D ^DIR K DIR
 .Q:$D(DIRUT)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .S ABMFN=Y
 .W !!,"Creating file..."
 .D OPEN^%ZISH("ABM",ABMPATH,ABMFN,"W")
 .Q:POP
 .U IO
 .D WRTPTS
 .D WRTELIG
 .D WRTVSTS
 .D CLOSE^%ZISH("ABM")
 .W "DONE"
XIT ;
 K ^TMP($J,"ABM-M2RPT")
 K ABMP,ABMY,ABMPTINA,ABMPT,ABMMFLG
 Q
QUE ;QUE TO TASKMAN
 S ZTRTN="TOTALS^ABMM2ELG"
 S ZTDESC="3P MEANINGFUL USE ELIGIBILITY REPORT"
 S ZTSAVE("ABM*")=""
 K ZTSK
 D ^%ZTLOAD
 W:$G(ZTSK) !,"Task # ",ZTSK," queued.",!
 Q
TOTALS ;
 ;# of Patient
 ;Encounters/Year
 ;# of Unique Patients/Year
 S ABM("HD",0)="Meaningful Use Eligibility Report"
 S ABM("PG")=1
 D GETPTS^ABMM2EL2
 D GETELIG^ABMM2EL2
 D GETVSTS^ABMM2EL2
 D WHD
 W !!,"Practice Demographics"
 W !?2,$J(+$G(^TMP($J,"ABM-M2RPT","CNT","PTS")),7)_" Patients"
 W !?2,$J(+$G(^TMP($J,"ABM-M2RPT","CNT","ENC")),7)_" Encounters"
 W !?2,$J(+$G(^TMP($J,"ABM-M2RPT","CNT","UNQ")),7)_" Unique Patients"
 ;
 ;Patient Demographics
 ;% of Patients on Medicaid
 ;% of Patients on Medicare
 ;% of Patients on Private Insurance
 ;% of Patients Uninsured
 ;% of Patients on Managed Care
 I +$G(^TMP($J,"ABM-M2RPT","CNT","PTS"))=0 W !!,"(REPORT COMPLETE)" Q  ;no pts found so it causes DIVIDE error if we continue
 W !!,"Patient Demographics"
 ;medicaid
 W !?2,$J(+$G(^TMP($J,"ABM-M2RPT","CNT","MCD")),7)_" Patients with Medicaid ( "_$J($FN((+$G(^TMP($J,"ABM-M2RPT","CNT","MCD"))/(+$G(^TMP($J,"ABM-M2RPT","CNT","PTS")))*100),",",2),5)_"% )"
 ;medicare
 W !?2,$J(+$G(^TMP($J,"ABM-M2RPT","CNT","MCR")),7)_" Patients with Medicare ( "_$J($FN((+$G(^TMP($J,"ABM-M2RPT","CNT","MCR"))/(+$G(^TMP($J,"ABM-M2RPT","CNT","PTS")))*100),",",2),5)_"% )"
 ;railroad
 W !?2,$J(+$G(^TMP($J,"ABM-M2RPT","CNT","RR")),7)_" Patients with Railroad ( "_$J($FN((+$G(^TMP($J,"ABM-M2RPT","CNT","RR"))/(+$G(^TMP($J,"ABM-M2RPT","CNT","PTS")))*100),",",2),5)_"% )"
 ;private
 W !?2,$J(+$G(^TMP($J,"ABM-M2RPT","CNT","PI")),7)_" Patients with Private  ( "_$J($FN((+$G(^TMP($J,"ABM-M2RPT","CNT","PI"))/(+$G(^TMP($J,"ABM-M2RPT","CNT","PTS")))*100),",",2),5)_"% )"
 ;no eligibility
 W !?2,$J(+$G(^TMP($J,"ABM-M2RPT","CNT","NO")),7)_" Patients Uninsured     ( "_$J($FN((+$G(^TMP($J,"ABM-M2RPT","CNT","NO"))/(+$G(^TMP($J,"ABM-M2RPT","CNT","PTS")))*100),",",2),5)_"% )"
 ;vmbp
 W !?2,$J(+$G(^TMP($J,"ABM-M2RPT","CNT","VMBP")),7)_" Patients with VA Med B ( "_$J($FN((+$G(^TMP($J,"ABM-M2RPT","CNT","VMBP"))/(+$G(^TMP($J,"ABM-M2RPT","CNT","PTS")))*100),",",2),5)_"% )"
 W !!,"(REPORT COMPLETE)"
 Q
 ;
WRTPTS ;^TMP($J,"ABM-M2RPT","PTS",ABMP("PDFN"))
 W !!!,"PATIENTS PATIENTS PATIENTS PATIENTS PATIENTS"
 W !?3,"PDFN",?15,"NAME",?50,"HRN",?60,"DATE INACTIVE"
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-M2RPT","PTS",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .W !?3,ABMP("PDFN"),?15,$P($G(^DPT(ABMP("PDFN"),0)),U),?50,$P($G(^AUPNPAT(ABMP("PDFN"),41,DUZ(2),0)),U,2),?60,$$SDT^ABMDUTL($P($G(^AUPNPAT(ABMP("PDFN"),41,DUZ(2),0)),U,3))
 ;
 ;^TMP($J,"ABM-M2RPT","UNQ",ABMPT)
 W !!!,"UNIQUE PATIENTS UNIQUE PATIENTS UNIQUE PATIENTS UNIQUE PATIENTS UNIQUE PATIENTS"
 W !?3,"PDFN",?15,"NAME",?50,"HRN"
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-M2RPT","UNQ",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .W !?3,ABMP("PDFN"),?15,$P($G(^DPT(ABMP("PDFN"),0)),U),?50,$P($G(^AUPNPAT(ABMP("PDFN"),41,DUZ(2),0)),U,2)
 Q
 ;
WRTELIG ;
 ;^TMP($J,"ABM-M2RPT","MCD",ABMP("PDFN"),ABMP("MDFN"))
 W !!!,"MEDICAID MEDICAID MEDICAID MEDICAID MEDICAID MEDICAID MEDICAID "
 W !?3,"PDFN",?15,"NAME",?50,"MCD#",?62,"PLAN"
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-M2RPT","MCD",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .S ABMP("MDFN")=0
 .F  S ABMP("MDFN")=$O(^TMP($J,"ABM-M2RPT","MCD",ABMP("PDFN"),ABMP("MDFN"))) Q:'ABMP("MDFN")  D
 ..W !?3,ABMP("PDFN"),?15,$P($G(^DPT(ABMP("PDFN"),0)),U),?50,$P($G(^AUPNMCD(ABMP("MDFN"),0)),U,3),?62,$P($G(^AUPNMCD(ABMP("MDFN"),0)),U,10)
 ;
 ;^TMP($J,"ABM-M2RPT","MCR",ABMP("PDFN"),ABMP("MDFN"))
 W !!!,"MEDICARE MEDICARE MEDICARE MEDICARE MEDICARE MEDICARE MEDICARE MEDICARE "
 W !?3,"PDFN",?15,"NAME",?50,"MCR#"
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-M2RPT","MCR",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .S ABMP("MDFN")=0
 .F  S ABMP("MDFN")=$O(^TMP($J,"ABM-M2RPT","MCR",ABMP("PDFN"),ABMP("MDFN"))) Q:'ABMP("MDFN")  D
 ..;W !?3,ABMP("PDFN"),?15,$P($G(^DPT(ABMP("PDFN"),0)),U),?50,$P($G(^AUPNMCR(ABMP("PDFN"),0)),U,3)  ;abm*2.6*32 IHS/SD/SDR CR9862
 ..;start new abm*2.6*32 IHS/SD/SDR CR9862
 ..K ABMMBI,ABMPNUM
 ..S ABMMBI=""
 ..S ABMMBI=$$HISTMBI^AUPNMBI(ABMP("PDFN"),.ABMMBI)
 ..S ABMMBI=+$O(ABMMBI(999999999),-1)
 ..S:(ABMMBI'=0) ABMPNUM=$P(ABMMBI(ABMMBI),U)
 ..I $G(ABMPNUM)="" D
 ...S ABMSUFX=$P($G(^AUPNMCR(ABMP("PDFN"),0)),U,4),ABMHIC=$P($G(^(0)),U,3)
 ...S ABMSUFX=$P($G(^AUTTMCS(+ABMSUFX,0)),U)
 ...S ABMPNUM=ABMHIC_ABMSUFX
 ...K ABMSUFX,ABMHIC
 ..W !?3,ABMP("PDFN"),?15,$P($G(^DPT(ABMP("PDFN"),0)),U),?50,$S($G(ABMPNUM)'="":ABMPNUM,1:"<NO MBI/HICN>")
 ..;end new abm*2.6*32 IHS/SD/SDR CR9862
 ;
 ;^TMP($J,"ABM-M2RPT","RR",ABMP("PDFN"),ABMP("MDFN"))
 W !!!,"RAILROAD RAILROAD RAILROAD RAILROAD RAILROAD RAILROAD RAILROAD RAILROAD "
 W !?3,"PDFN",?15,"NAME",?50,"RR#"
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-M2RPT","RR",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .S ABMP("MDFN")=0
 .F  S ABMP("MDFN")=$O(^TMP($J,"ABM-M2RPT","RR",ABMP("PDFN"),ABMP("MDFN"))) Q:'ABMP("MDFN")  D
 ..;W !?3,ABMP("PDFN"),?15,$P($G(^DPT(ABMP("PDFN"),0)),U),?50,$P($G(^AUPNRRE(ABMP("PDFN"),0)),U,3)  ;abm*2.6*32 IHS/SD/SDR CR9862
 ..;start new abm*2.6*32 IHS/SD/SDR CR9862
 ..K ABMMBI,ABMPNUM
 ..S ABMMBI=""
 ..S ABMMBI=$$HISTMBI^AUPNMBI(ABMP("PDFN"),.ABMMBI)
 ..S ABMMBI=+$O(ABMMBI(999999999),-1)
 ..S:(ABMMBI'=0) ABMPNUM=$P(ABMMBI(ABMMBI),U)
 ..I $G(ABMPNUM)="" D
 ...S ABMPRFX=$P($G(^AUPNRRE(ABMP("PDFN"),0)),U,3),ABMHIC=$P($G(^(0)),U,4)
 ...S ABMPRFX=$P($G(^AUTTRRP(+ABMPRFX,0)),U)
 ...S ABMPNUM=ABMPRFX_ABMHIC
 ...K ABMPRFX,ABMHIC
 ..W !?3,ABMP("PDFN"),?15,$P($G(^DPT(ABMP("PDFN"),0)),U),?50,$S($G(ABMPNUM)'="":ABMPNUM,1:"<NO MBI/HICN>")
 ..;end new abm*2.6*32 IHS/SD/SDR CR9862
 ;
 W !!!,"VMBP VMBP VMBP VMBP VMBP VMBP VMBP VMBP VMBP VMBP VMBP VMBP VMBP VMBP "
 W !?3,"PDFN",?15,"NAME",?50,"HRN"
 ;
 ;^TMP($J,"ABM-M2RPT","PI",ABMP("PDFN"),ABMP("MDFN"))
 W !!!,"PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE "
 W !?3,"PDFN",?15,"NAME",?50,"INS",?62,"MEM#"
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-M2RPT","PI",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .S ABMP("MDFN")=0
 .F  S ABMP("MDFN")=$O(^TMP($J,"ABM-M2RPT","PI",ABMP("PDFN"),ABMP("MDFN"))) Q:'ABMP("MDFN")  D
 ..W !?3,ABMP("PDFN"),?15,$P($G(^DPT(ABMP("PDFN"),0)),U),?50,$P($G(^AUPNPRVT(ABMP("PDFN"),11,ABMP("MDFN"),0)),U),?62,$P($G(^AUPNPRVT(ABMP("PDFN"),11,ABMP("MDFN"),2)),U)
 ;
 ;^TMP($J,"ABM-M2RPT","NO",ABMP("PDFN"))
 W !!!,"NOT INSURED NOT INSURED NOT INSURED NOT INSURED NOT INSURED NOT INSURED "
 W !?3,"PDFN",?15,"NAME"
 S ABMP("PDFN")=0
 F  S ABMP("PDFN")=$O(^TMP($J,"ABM-M2RPT","NO",ABMP("PDFN"))) Q:'ABMP("PDFN")  D
 .W !?3,ABMP("PDFN"),?15,$P($G(^DPT(ABMP("PDFN"),0)),U)
 Q
 ;
WRTVSTS ;^TMP($J,"ABM-M2RPT","ENC",ABMP("VDFN"))
 W !!!,"VISITS VISITS VISITS VISITS VISITS VISITS VISITS VISITS VISITS "
 W !?3,"VDFN",?13,"VISIT",?30,"PDFN",?40,"PATIENT"
 S ABMP("VDFN")=0
 F  S ABMP("VDFN")=$O(^TMP($J,"ABM-M2RPT","ENC",ABMP("VDFN"))) Q:'ABMP("VDFN")  D
 .W !?3,ABMP("VDFN"),?13,$P($G(^AUPNVSIT(ABMP("VDFN"),0)),U),?30,$P($G(^AUPNVSIT(ABMP("VDFN"),0)),U,5),?40,$P($G(^DPT($P($G(^AUPNVSIT(ABMP("VDFN"),0)),U,5),0)),U)
 Q
WHD ;EP for writing Report Header
 W $$EN^ABMVDF("IOF"),!
 K ABM("LINE") S $P(ABM("LINE"),"=",$S($D(ABM(132)):132,1:80))="" W ABM("LINE"),!
 D NOW^%DTC  ;abm*2.6*1 NO HEAT
 W ABM("HD",0),?$S($D(ABM(132)):103,1:48) S Y=% X ^DD("DD") W Y,"   Page ",ABM("PG")
 S ABM("HD",1)="For date range: "_$$SDT^ABMDUTL(ABMY("DT",1))_" to "_$$SDT^ABMDUTL(ABMY("DT",2))
 W:$G(ABM("HD",1))]"" !,ABM("HD",1)
 W:$G(ABM("HD",2))]"" !,ABM("HD",2)
 W !,"Billing Location: ",$P($G(^AUTTLOC(DUZ(2),0)),U,2)
 W !,ABM("LINE") K ABM("LINE")
 Q
