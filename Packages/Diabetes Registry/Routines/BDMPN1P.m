BDMPN1P ; IHS/CMI/LAB - 2024 DIABETES AUDIT PRINT 15 Dec 2016 3:05 PM ; 24 Oct 2019  3:42 PM
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**17**;JUN 14, 2007;Build 138
 ;
 ;
 D LOG^BUSAAPI("O","P","P",$S($G(XQY0)]"":$P(XQY0,U),1:"BDMDN1P"),"DM 2024 PREDIABETES REPORT")
 S BDMQUIT=0,BDMPG=0,BDMIOSL=$S($G(BDMGUI):57,1:IOSL)
 I BDMPREP=2 G CUML
 ;print ind audits first
 S BDMPD=0,BDMGUIC=0 F  S BDMPD=$O(^XTMP("BDMPN1",BDMJOB,BDMBTH,"AUDIT",BDMPD)) Q:BDMPD'=+BDMPD!(BDMQUIT)  D
 .I $G(BDMGUI),BDMGUIC W !,"ZZZZZZZ",!  ;maw
 .I BDMGUIC W:$D(IOF) @IOF
 .S BDMGUIC=1
 .S BDMPG=BDMPG+1 W:$G(BDMGUI) !! W "IHS Prediabetes Assessment of Care, 2024    DATE RUN: "_$$DATE^BDMS9B1(DT)_"   Page: "_BDMPG
 .W !!,"Report Period Ending Date: ",$$DATE^BDMS9B1(BDMRED),?40,"Facility Name: ",$E($P(^DIC(4,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U),1,24)
 .W !,"Reviewer initials: ",$$I(14),?40,"Community: ",$P($$I(122),U,2)
 .W !,"State of Residence: ",$P($$I(121),U)
 .S N=$$GETPREF^AUPNSOGI(BDMPD,"E",1)
 .W !,$S($G(BDMPPN):"Name: "_N,1:"") S J=$S($G(BDMPPN):$L(N)+10,1:0)
 .W ?J,"Chart #: ",$$I(16)
 .W !,"DOB: ",$$DATE^BDMS9B1($$DOB^AUPNPAT(BDMPD)),"    Birth Sex: ",$$I(20)
 .W !,"Primary Care Provider:  ",$$I(15)
 .S (BDMIFG,BDMIGT,BDMPREDM)=""
 .S X="Diagnosis" W !!,X
 .S X=" Problem List (Date of Diagnosis)" W !,X
 .S X="",(Y,BDMIFG)=$$I(200) I $P(Y,U) S $E(X,3)="Impaired Fasting Glucose " S:$P(Y,U)=1 $E(X,30)=$S($P(Y,U,2):"("_$$FMTE^XLFDT($P(Y,U,2))_")",1:"(Date of Onset not recorded)") W !,X
 .S X="",(Y,BDMIGT)=$$I(210) I $P(Y,U) S $E(X,3)="Impaired Glucose Tolerance " S:$P(Y,U)=1 $E(X,30)=$S($P(Y,U,2):"("_$$FMTE^XLFDT($P(Y,U,2))_")",1:"(Date of Onset not recorded)") W !,X
 .S X="",(Y,BDMPREDM)=$$I(220) I $P(Y,U) S $E(X,3)="Prediabetes " S:$P(Y,U)=1 $E(X,30)=$S($P(Y,U,2):"("_$$FMTE^XLFDT($P(Y,U,2))_")",1:"(Date of Onset not recorded)") W !,X
 .S X=" Diagnosis first recorded in PCC (Used as POV):" W !!,X
 .S X="" I $P(BDMIFG,U,3) S X="  Impaired Fasting Glucose",$E(X,32)=$$FMTE^XLFDT($P(BDMIFG,U,3)) W !,X
 .S X="" I $P(BDMIGT,U,3) S X="  Impaired Glucose Tolerance",$E(X,32)=$$FMTE^XLFDT($P(BDMIGT,U,3)) W !,X
 .S X="" I $P(BDMPREDM,U,3) S X="  Prediabetes",$E(X,32)=$$FMTE^XLFDT($P(BDMPREDM,U,3)) W !,X
 .W !!,"Tobacco/Nicotine Use (during Report period)"
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?4,"Screened for tobacco use: " S %=$$I(215) W $S($P(%,U,1)=2:"2  No",1:"1  Yes") ;_" "_$P($P(%,U,2),"  ",2,999)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?6,"If screened, tobacco user: " S %=$$I(215) I $P(%,U,1)=1 W $P($$I(215),U,2)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?8,"If screened and current user, tobacco cessation counseling/education",!?8,"received: ",$E($$I(28),1,50)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"Vital Statistics"
 .S X=$$I(30)
 .W !!?2,"Height (last ever): ",X  ;$J($P(X," "),2,0)_" "_$P(X," ",2,99)  ;ROUND HT KS 1208 2 DECIMALS THROUGHOUT 2024 PER K SHEFF
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .S %=$P($$I(32)," ",1) I %]"" S %=$$STRIP^XLFSTR($J(%,4,0)," ")
 .W !?2,"Weight (last in Report period): ",%," ",$P($$I(32)," ",2,99),"     BMI: ",$$I(112)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!?2,"Hypertension (documented diagnosis ever): ",$$I(34)
 .I $Y>(BDMIOSL-3) D PAGE Q:BDMQUIT
 .W !?2,"Blood pressure (last 3 during Report period): ",?48,$P($$I(36),";",1)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?48,$P($$I(36),";",2)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?48,$P($$I(36),";",3)
 .W !!,"Education (during Report period)"
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"Nutrition: ",?36,$P($$I(44),U) I $P($$I(44),U,2)]"" W !?10,$P($$I(44),U,2)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"Physical activity: ",?36,$$I(46)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"Other education: ",?36,$$I(48)
 .I $Y>(BDMIOSL-14) D PAGE Q:BDMQUIT
 .W !!,"Medication Therapy prescribed (as of the end of the Report period):"
 .W !?3,$$I(51),?6,"1 None of the following"
 .W !?3,$$I(54),?6,"2 Metformin [Glucophage, others]"
 .W !?3,$P($$I(103),U),?6,"3 SGLT-2 inhibitor [bexagliflozin (Brenzavvy), canagliflozin (Invokana),",!?8,"dapagliflozin (Farxiga), empagliflozin (Jardiance),",!?8,"ertugliflozin (Steglatro), sotagliflozin (Inpefa)]"
 .W !?3,$$I(100),?6,"4 GLP-1 receptor agonist [dulaglutide (Trulicity), exenatide (Byetta, ",!?8,"Bydureon), liraglutide (Victoza, Saxenda), lixisenatide (Adlyxin), ",!?8,"semaglutide (Ozempic, Rybelsus, Wegovy)]"
 .W !?3,$$I(58),?6,"5 Tirzepatide [Mounjaro]"
 .W !?3,$$I(56),?6,"6 Pioglitazone [Actos] or rosiglitazone [Avandia]"
 .W !?3,$$I(55),?6,"7 Acarbose [Precose] or miglitol [Glyset]"
 .I $Y>(BDMIOSL-2) D PAGE Q:BDMQUIT
 .W !!,"Statin Therapy"
 .W !?2,"Prescribed (as of the end of the Report period): " W:$E($$I(300))=1 !?10 W $$I(300)
 .I $Y>(BDMIOSL-10) D PAGE Q:BDMQUIT
 .;lab
 .W !!,"Laboratory Data (most recent result during Report period)" ;
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?2,"A1C: ",?28,$P($$I(78),U,2)," ",$$VAL^XBDIQ1(9000010.09,+$P($$I(78),U,4),1101),?43,$$DATE^BDMS9B1($P($$I(78),U,1)),?60,$E($$VAL^XBDIQ1(9000010.09,+$P($$I(78),U,4),.01),1,19)
 .W !?2,"Next most recent A1C:",?28,$P($$I(79),U,2)," ",$$VAL^XBDIQ1(9000010.09,+$P($$I(79),U,4),1101),?43,$$DATE^BDMS9B1($P($$I(79),U,1)),?60,$E($$VAL^XBDIQ1(9000010.09,+$P($$I(79),U,4),.01),1,19)
 .W !?2,"Fasting Glucose: ",?28,$P($$I(98),U,1),?43,$P($$I(98),U,2),?60,$E($P($$I(98),U,3),1,19)
 .W !?2,"75 Gm 2 hour Glucose: ",?28,$P($$I(99),U,1),?43,$P($$I(99),U,2),?60,$E($P($$I(99),U,3),1,19)
 .W !!?2,"Total Cholesterol: ",?28,$P($$I(86),U,1),?43,$P($$I(86),U,2),?60,$E($P($$I(86),U,3),1,19)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?2,"LDL Cholesterol: ",?28,$P($$I(88),U,1),?43,$P($$I(88),U,2),?60,$E($P($$I(88),U,3),1,19)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?2,"HDL Cholesterol: ",?28,$P($$I(89),U,1),?43,$P($$I(89),U,2),?60,$E($P($$I(89),U,3),1,19)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?2,"Triglycerides: ",?28,$P($$I(90),U,1),?43,$P($$I(90),U,2),?60,$E($P($$I(90),U,3),1,19)
 .S BDMUTT=$P($$I(92),U,5)
 .I $Y>(BDMIOSL-2) D PAGE Q:BDMQUIT
 .W !?2,"Quantitative UACR: " I BDMUTT=1 W ?28,$P($$I(92),U,2)_" "_$P($$I(92),U,12),?43,$P($$I(92),U,3),?60,$E($P($$I(92),U,4),1,19)
 .W !!,"Local Questions ",$$LOCN^BDMDN10(BDMPD,BDMDMRG)
 .W !!?2,"Select one:"
 .W !?2,"Text: ",$$LOCT^BDMDN10(BDMPD,BDMDMRG)
 .I $E(IOST,1,2)'="P-" W !! S DIR(0)="E" D ^DIR K DIR
CUML ;
 I BDMPREP=2!(BDMPREP=3) D CUML^BDMPN14
DONE ;
 K ^TMP($J)
 K ^XTMP("BDMTAX",BDMJOB,BDMBTH)
 K ^XTMP("BDMPN1",BDMJOB,BDMBTH),BDMJOB,BDMBTH
 Q
I(I) ;
 Q $G(^XTMP("BDMPN1",BDMJOB,BDMBTH,"AUDIT",BDMPD,I))
 ;
PAGE ;
 Q:$G(BDMDSP)
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQUIT=1 Q
 I BDMPG W:$D(IOF) @IOF
 I $G(BDMGUI),BDMGUIC,'$G(BDMDSP) W !,"ZZZZZZZ",!  ;maw
 I $G(BDMGUI) W !!
 S BDMPG=BDMPG+1
 W "IHS Assessment of Prediabetes Care, 2024    DATE RUN: "_$$DATE^BDMS9B1(DT)_"   Page: "_BDMPG
 W !,"Audit Period Ending Date: ",$$DATE^BDMS9B1(BDMRED)
 W !,$S($G(BDMPPN):"NAME: "_$P($G(^DPT(BDMPD,0)),U),1:"") S J=$S($G(BDMPPN):$L($P(^DPT(BDMPD,0),U))+10,1:0)
 W ?J,"CHART #: ",$$I(16),"    DOB: ",$$I(18),"    SEX: ",$$I(20)
 W !,$$REPEAT^XLFSTR("-",79)
 Q
 ;
ACPCOQ() ;-- return none if no UACR, UPCR, Quant
 I $P($$I(91),U)="X" Q ""
 I $P($$I(93),U)="X" Q ""
 I $P($$I(95),U)="X" Q ""
 Q "X"
 ;
ACPCRES() ;-- return result from UACR UPCR
 I $P($$I(91),U)="X" Q $P($$I(91),U,2)
 I $P($$I(93),U)="X" Q $P($$I(93),U,2)
 Q ""
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
QUANCHK() ;--check quantitative
 I $P($$I(91),U)]"" Q ""
 I $P($$I(93),U)]"" Q ""
 Q $$I(95)
 ;
