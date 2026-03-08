BDMPO14 ; IHS/CMI/LAB -IHS -CUMULATIVE REPORT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**18**;JUN 14, 2007;Build 147
 ;
D(D) ;
 I $G(D)="" Q ""
 Q $S($E(D,4,5)="00":"07",1:$E(D,4,5))_"/"_$S($E(D,6,7)="00":"15",1:$E(D,6,7))_"/"_$E(D,2,3)
OB(BDMPG,BMI,D) ;EP obese
 I $G(BMI)="" Q ""
 NEW S S S=$P(^DPT(BDMPG,0),U,2)
 I S="" Q ""
 NEW A S A=$$AGE^AUPNPAT(BDMPG,D)
 NEW R S R=$O(^BDMBMI("H",S,A)) I R S R=$O(^BDMBMI("H",S,R,""))
 I R="" Q ""
 I BMI>$P(^BDMBMI(R,0),U,7)!(BMI<$P(^BDMBMI(R,0),U,6)) Q ""
 I BMI'<$P(^BDMBMI(R,0),U,5) Q 1
 Q ""
OW(BDMPG,BMI,D) ;EP overweight
 I $G(BMI)="" Q ""
 NEW S S S=$P(^DPT(BDMPG,0),U,2)
 I S="" Q ""
 NEW A S A=$$AGE^AUPNPAT(BDMPG,D)
 NEW R S R=$O(^BDMBMI("H",S,A)) I R S R=$O(^BDMBMI("H",S,R,""))
 I R="" Q ""
 I BMI>$P(^BDMBMI(R,0),U,7)!(BMI<$P(^BDMBMI(R,0),U,6)) Q ""
 I BMI'<$P(^BDMBMI(R,0),U,4) Q 1
 Q ""
CUML ;EP
 Q:'$D(BDMCUML)
 ;print aggregate audit
 ;
 ;
PRINT ;
 S BDMPG=0
 S BDMQUIT=0
 D HEADER
 D PRINT1 ;print each indicator
 D EXIT
 Q
 ;
PRINT1 ;
 W !,$P(BDMCUML(10),U),!?3,"Male",?49,$$C($P(BDMCUML(10),U,4)),?61,$$C($P(BDMCUML(10),U,2)),?73,$$P($P(BDMCUML(10),U,2),$P(BDMCUML(10),U,4))
 W !?3,"Female",?49,$$C($P(BDMCUML(10),U,3)),?61,$$C($P(BDMCUML(10),U,2)),?73,$$P($P(BDMCUML(10),U,2),$P(BDMCUML(10),U,3))
 W !?3,"Unknown",?49,$$C($P(BDMCUML(10),U,5)),?61,$$C($P(BDMCUML(10),U,2)),?73,$$P($P(BDMCUML(10),U,2),$P(BDMCUML(10),U,5))
 ;
AGE ;
 I $Y>(BDMIOSL-4) D HEADER Q:BDMQUIT
 W !!,"Age" S V=$G(BDMCUML(20))
 W !?3,"<15 yrs",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?3,"15-44 yrs",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?3,"45-64 yrs",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !?3,"65 yrs and older",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
CLASS ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(25))
 W !!,"Classification"
 W !?3,"Prediabetes",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?3,"Impaired Fasting Glucose",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?3,"Impaired Glucose Tolerance",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 ;
DMDUR ;
 I $Y>(BDMIOSL-6) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(30)) W !!,$P(V,U)
 W !?3,"<1 year",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 W !?3,"<10 years",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?3,">=10 years",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?3,"Diagnosis date not recorded",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
BMI ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(40)) W !!,$P(V,U)
 W !?3,"Normal (BMI<25.0)",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 W !?3,"Overweight (BMI 25.0-29.9)",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?3,"Obese (BMI >=30.0)",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?3,"Height or weight missing",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !?3,"----------------------------------"
 W !?3,"Severely obese (BMI >=40.0)",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,7))
BSC ;
 I $Y>(BDMIOSL-10) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(50)) W !!,$P(V,U)
 W !?3,"A1C <5.7",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?3,"A1C 5.7-6.4",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?3,"A1C >=6.5",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !!?3,"Not tested or no valid result",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 ;
BPC ;
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(60)) W !!,$P(V,U)
 W !?3,"<120/<70",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?3,"120/70 - <130/80",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?3,"130/80 - <140/90",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !?3,"140/90 or higher",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 W !?3,"BP category Undetermined",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,7))
HTN ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(70))
 W !!,"Hypertension"
 W !?3,"Diagnosed ever",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
TOB ;
TOBSCR ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(80)) W !!,"Tobacco and Nicotine Use" ;,!?3,$P(V,U)
 W !,"Tobacco use"
 W !?3,"Screened",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?6,"If screened, user",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,3)),?73,$$P($P(V,U,3),$P(V,U,4))
 W !?8,"If user, counseled",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,4)),?73,$$P($P(V,U,4),$P(V,U,5))
TX ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(90)) W !!,$P(V,U)
 W !?3,"Metformin [Glucophage, others]",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !!?3,"GLP-1 receptor agonist [dulaglutide  ",!?3,"(Trulicity), exenatide (Byetta, Bydureon), ",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4)),!?3,"liraglutide (Victoza, Saxenda),",!?3,"lixisenatide (Adlyxin),"
 W !?3,"semaglutide (Ozempic, Rybelsus, Wegovy)]"
 W !!?3,"SGLT-2 inhibitor ",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5)),!?3,"[bexagliflozin (Brenzavvy),",!?3,"canagliflozin,(Invokana), ",!?3,"dapagliflozin (Farxiga),",!?3,"empagliflozin (Jardiance), "
 W !?3,"ertugliflozin (Steglatro), ",!?3,"sotagliflozin (Inpefa)]"
 W !!?3,"Pioglitazone [Actos] or rosiglitazone",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6)),!?3,"[Avandia]"
 W !!?3,"Tirzepatide [Mounjaro, Zepbound]",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,7))
 W !!?3,"Acarbose [Precose] or miglitol [Glyset]",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,8))
 ;
STAT ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(95)) W !!,$P(V,U)
 W !?3,"Yes*",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,5)),?73,$$P($P(V,U,5),$P(V,U,3))
 W !?3,"Allergy, intolerance, or contraindication",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !!?2,"*Denominator excludes patients with an allergy, intolerance,",!?3,"or contraindication."
 ;
LIPID ;
 I $Y>(BDMIOSL-2) D HEADER Q:BDMQUIT
 W !!,"Lipid Evaluation - Note these results are presented as population level CVD"
 W !,"risk markers and should not be considered treatment targets for individual"
 W !,"patients."
 ;
LDL ;
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(190))
 S T=$P(V,U,3)+$P(V,U,4)+$P(V,U,5)+$P(V,U,6)
 W !!?3,"LDL cholesterol",?49,$$C(T),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),T)
 W !?6,"LDL <100 mg/dL",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?6,"LDL 100-189 mg/dL",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?6,"LDL >=190 mg/dL",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 W !?6,"Not tested or no valid result",?49,$$C($P(V,U,7)+$P(V,U,8)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,7)+$P(V,U,8))
HDL ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(195))
 S T=$P(V,U,2)+$P(V,U,6)  ;TOTAL PTS
 S S=$P(V,U,3)+$P(V,U,4)+$P(V,U,7)+$P(V,U,8)
 W !!?3,"HDL cholesterol",?49,$$C(S),?61,$$C(T),?73,$$P(T,S)
 W !?6,"In females"
 W !?9,"HDL <50 mg/dL",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?9,"HDL >=50 mg/dL",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?9,"Not tested or no valid result",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !!?6,"In males"
 W !?9,"HDL <40 mg/dL",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,6)),?73,$$P($P(V,U,6),$P(V,U,7))
 W !?9,"HDL >=40 mg/dL",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,6)),?73,$$P($P(V,U,6),$P(V,U,8))
 W !?9,"Not tested or no valid result",?49,$$C($P(V,U,9)),?61,$$C($P(V,U,6)),?73,$$P($P(V,U,6),$P(V,U,9))
TRIG ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(200))
 S T=$P(V,U,3)+$P(V,U,4)+$P(V,U,8)+$P(V,U,9)
 W !!?3,"Triglycerides [1]",?49,$$C(T),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),T)
 W !?6,"Trig <150 mg/dL",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?6,"Trig 150-499 mg/dL",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,8))
 W !?6,"Trig 500-999 mg/dL",?49,$$C($P(V,U,9)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,9))
 W !?6,"Trig >=1000 mg/dL",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?6,"Not tested or no valid result",?49,$$C($P(V,U,5)+$P(V,U,7)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5)+$P(V,U,7))
 ;
QUAN ;
 I $Y>(BDMIOSL-15) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(145))
 W !!?3,"Quantitative Urine Albumin-to-Creatinine ",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?3,"Ratio (UACR) to assess kidney damage"
 W !?6,"UACR - normal: <30 mg/g",?49,$$C($P(V,U,12)),?61,$$C($P(V,U,3)),?73,$$P($P(V,U,3),$P(V,U,12))
 W !?6,"UACR increased:",!?9,"30-300 mg/g",?49,$$C($P(V,U,13)),?61,$$C($P(V,U,3)),?73,$$P($P(V,U,3),$P(V,U,13))
 W !?9,">300 mg/g",?49,$$C($P(V,U,14)),?61,$$C($P(V,U,3)),?73,$$P($P(V,U,3),$P(V,U,14))
 W !?6,"Not tested or no valid result",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 I $Y>(BDMIOSL-4) D HEADER Q:BDMQUIT
 W !!,"Footnotes"
 W !?3,"[1] For triglycerides: >150 is a marker of CVD risk, not a treatment",!,"target; >1000 is a risk marker for pancreatitis."
 Q
EXIT ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO",DIR("A")="End of report.  Press ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
CALC(N,O) ;ENTRY POINT
 ;N is new
 ;O is old
 NEW Z
 I O=0!(N=0) Q "**"
 NEW X,X2,X3
 S X=N,X2=1,X3=0 D COMMA^%DTC S N=X
 S X=O,X2=1,X3=0 D COMMA^%DTC S O=X
 S Z=(((N-O)/O)*100),Z=$FN(Z,"+,",1)
 Q Z
P(D,N) ;return %
 I 'D Q ""
 I 'N Q "  0%"
 NEW X S X=N/D,X=X*100,X=$J(X,3,0)
 Q X_"%"
C(X,X2,X3) ;
 I '$G(X2) S X2=0
 I '$G(X3) S X3=6
 D COMMA^%DTC
 Q X
HEADER ;EP
 G:'BDMPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S BDMPG=BDMPG+1
 I $G(BDMGUI),BDMPG'=1 W !,"ZZZZZZZ"
 I $G(BDMGUI) W !!
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BDMPG,!
 W !,$$CTR("***  PREDIABETES HEALTH STATUS OF PATIENTS - RPMS  ***",80),!
 S X="(Report Period: "_$$FMTE^XLFDT(BDMBDAT)_" to "_$$FMTE^XLFDT(BDMADAT)_")" W $$CTR(X,80),!
 W $$CTR($P(^DIC(4,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U)),!
 W !!,$P(BDMCUML(10),U,2)," patients were reviewed",!
 S X="Unless otherwise specified, time period for each item is the 12-month Audit " W X,!
 W "Period",!
 W $TR($J("",80)," ","-"),!
 W ?45,"# of ",?57,"#",?70,"Percent",!
 W ?45,"Patients",?57,"Considered",!
 W ?45,"(Numerator)",?57,"(Denominator)",!
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
