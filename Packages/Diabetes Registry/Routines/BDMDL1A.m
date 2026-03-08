BDMDL1A ; IHS/CMI/LAB -IHS -CUMULATIVE REPORT 
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**19**;JUN 14, 2007;Build 159
 ;
EXAMS ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(120)) W !!,$P(V,U)
 W !?3,"Foot exam - comprehensive or complete",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?3,"Eye exam - dilated exam or retinal imaging",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?3,"Dental exam",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 ;
EDUC ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(130)) W !!,$P(V,U)
 W !?3,"Nutrition - by any provider (RD and/or other)",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?3,"Nutrition - by RD",?49,$$C($P(V,U,10)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,10))
 W !?3,"Physical activity",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?3,"Other diabetes education",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !?3,"----------------------------------"
 W !?3,"Any of above",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
IMM ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(140)) W !!,$P(V,U)
 W !?3,"Influenza vaccine during Audit period",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?3,"Pneumococcal vaccine (PCV15, PCV20,",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4)),!?9,"PCV21 or PPSV23) - ever"
 W !?3,"Td/Tdap/DTap/DT - past 10 years",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !?3,"Tdap - ever",?49,$$C($P(V,U,12)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,12))
 S C=$P(V,U,2)-$P(V,U,11)
 W !?3,"If not immune, hepatitis B complete",?49,$$C($P(V,U,9)),?61,$$C(C),?73,$$P(C,$P(V,U,9)),!?9,"series - ever"
 W !?6,"Immune - hepatitis B",?49,$$C($P(V,U,11)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,11))
 W !?3,"Hepatitis B complete series ever or",?49,$$C($P(V,U,10)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,10)),!?3,"immune to hepatitis B"
 ;p14 add shringrix
 W !?3,"In patients age >=50 years ",?49,$$C($P(V,U,14)),?61,$$C($P(V,U,15)),?73,$$P($P(V,U,15),$P(V,U,14)),!?3,"Shingrix/recombinant zoster vaccine",!?9,"(RZV) series - ever"
 ;P19 ADD RSV
 W !?3,"In patients age >=50 years at increased ",?49,$$C($P(V,U,16)),?61,$$C($P(V,U,15)),?73,$$P($P(V,U,15),$P(V,U,16)),!?3,"risk Respiratory syncytial virus (RSV)",!?3,"vaccine - ever"
DEP ;
 I $Y>(BDMIOSL-6) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(300)) W !!,"Depression" ;,!?3,"Active problem/diagnosis"
 W !?3,"Screened during Audit period",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?3,"Active diagnosis during Audit period",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?3,"Screened and/or active diagnosis",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5)),!?9,"during Audit period"
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
GFR ;
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(175)) S T=$P(V,U,5)
 W !!,"Kidney Evaluation"
 W !?3,"Estimated Glomerular Filtration Rate (eGFR)",?49,$$C($P(V,U,5)),?61,$$C($P(BDMCUML(175),U,2)),?73,$$P($P(BDMCUML(175),U,2),$P(V,U,5)),!?3,"to assess kidney function",!?3,"(In age >=18 years)"
 W !,?6,"eGFR >=60 mL/min",?49,$$C($P(V,U,6)),?61,$$C($P(BDMCUML(175),U,2)),?73,$$P($P(BDMCUML(175),U,2),$P(V,U,6))
 W !,?6,"eGFR 30-59 mL/min",?49,$$C($P(V,U,7)),?61,$$C($P(BDMCUML(175),U,2)),?73,$$P($P(BDMCUML(175),U,2),$P(V,U,7))
 W !,?6,"eGFR 15-29 mL/min",?49,$$C($P(V,U,8)),?61,$$C($P(BDMCUML(175),U,2)),?73,$$P($P(BDMCUML(175),U,2),$P(V,U,8))
 W !,?6,"eGFR < 15 mL/min",?49,$$C($P(V,U,9)),?61,$$C($P(BDMCUML(175),U,2)),?73,$$P($P(BDMCUML(175),U,2),$P(V,U,9))
 W !,?6,"eGFR Not tested or no valid result",?49,$$C($P(V,U,10)),?61,$$C($P(BDMCUML(175),U,2)),?73,$$P($P(BDMCUML(175),U,2),$P(V,U,10))
URIN ;
 I $Y>(BDMIOSL-15) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(145))
 W !!?3,"Quantitative Urine Albumin-to-Creatinine ",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?3,"Ratio (UACR) to assess kidney damage"
 W !?6,"UACR - normal: <30 mg/g",?49,$$C($P(V,U,12)),?61,$$C($P(V,U,3)),?73,$$P($P(V,U,3),$P(V,U,12))
 W !?6,"UACR increased:",!?9,"30-300 mg/g",?49,$$C($P(V,U,13)),?61,$$C($P(V,U,3)),?73,$$P($P(V,U,3),$P(V,U,13))
 W !?9,">300 mg/g",?49,$$C($P(V,U,14)),?61,$$C($P(V,U,3)),?73,$$P($P(V,U,3),$P(V,U,14))
 W !?6,"Not tested or no valid result",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 I $Y>(BDMIOSL-4) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(270))
 W !!?3,"In patients age >=18 years, eGFR and UACR",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 ;
CKD ;
 I $Y>(BDMIOSL-14) D HEADER Q:BDMQUIT
 S V=BDMCUML(400)
 W !!,"Chronic Kidney Disease (CKD) (In age >=18 years)"
 W !?3,"CKD [2]",?49,$$C($P(V,U,14)),?61,$$C($P(V,U,13)),?73,$$P($P(V,U,13),$P(V,U,14))
 W !?6,"CKD [2] and mean BP <130/<80",?49,$$C($P(V,U,24)),?61,$$C($P(V,U,14)),?73,$$P($P(V,U,14),$P(V,U,24))
 W !?6,"CKD [2] and mean BP <140/<90",?49,$$C($P(V,U,15)),?61,$$C($P(V,U,14)),?73,$$P($P(V,U,14),$P(V,U,15))
 W !?6,"CKD [2] and ACE inhibitor or ARB",?49,$$C($P(V,U,16)),?61,$$C($P(V,U,14)),?73,$$P($P(V,U,14),$P(V,U,16)),!?9,"currently prescribed"
 W !?6,"CKD [2] and GLP-1 receptor agonist",?49,$$C($P(V,U,43)),?61,$$C($P(V,U,14)),?73,$$P($P(V,U,14),$P(V,U,43)),!?9,"currently prescribed"
 W !?6,"CKD [2] and SGLT-2 inhibitor",?49,$$C($P(V,U,44)),?61,$$C($P(V,U,14)),?73,$$P($P(V,U,14),$P(V,U,44)),!?9,"currently prescribed"
 W !?6,"CKD [2] and GLP-1 receptor agonist and/or ",?49,$$C($P(V,U,47)),?61,$$C($P(V,U,14)),?73,$$P($P(V,U,14),$P(V,U,47)),!?9,"SGLT-2 inhibitor currently prescribed"
GU ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 W !!?3,"CKD Stage"
 W !?6,"Normal: eGFR >=60 mL/min",?49,$$C($P(V,U,18)),?61,$$C($P(V,U,13)),?73,$$P($P(V,U,13),$P(V,U,18)),!?9,"and UACR <30 mg/g"
 W !?6,"Stages 1 and 2: eGFR >=60 mL/min",?49,$$C($P(V,U,19)),?61,$$C($P(V,U,13)),?73,$$P($P(V,U,13),$P(V,U,19)),!?9,"and UACR >=30 mg/g"
 W !?6,"Stage 3: eGFR 30-59 mL/min",?49,$$C($P(V,U,20)),?61,$$C($P(V,U,13)),?73,$$P($P(V,U,13),$P(V,U,20))
 W !?6,"Stage 4: eGFR 15-29 mL/min",?49,$$C($P(V,U,21)),?61,$$C($P(V,U,13)),?73,$$P($P(V,U,13),$P(V,U,21))
 W !?6,"Stage 5: eGFR <15 mL/min",?49,$$C($P(V,U,22)),?61,$$C($P(V,U,13)),?73,$$P($P(V,U,13),$P(V,U,22))
 W !?6,"Undetermined",?49,$$C($P(V,U,23)),?61,$$C($P(V,U,13)),?73,$$P($P(V,U,13),$P(V,U,23))
TBC ;
 I $Y>(BDMIOSL-10) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(70)) W !!,$P(V,U)
 W !?3,"TB diagnosis documented ever and/or ",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3)),!?3,"positive test result ever"
 S J=$P(V,U,2)-$P(V,U,8)
 W !?3,"If not diagnosed, TB test done ever",?49,$$C($P(V,U,4)),?61,$$C(J),?73,$$P(J,$P(V,U,4)),!?3,"(skin test or blood test)"
 W !?3,"TB test done ever or TB diagnosed ",?49,$$C($P(V,U,10)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,10)),!?3,"ever"
 W !?3,"If TB diagnosis documented and/or ",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,3)),?73,$$P($P(V,U,3),$P(V,U,5)),!?3,"positive test result, treatment ",!?3,"initiated ever"
 W !?3,"If most recent TB test result was",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,6)),?73,$$P($P(V,U,6),$P(V,U,7)),!?3,"negative, was test done after",!?3,"diabetes diagnosis"
 ;
HEPC ;P11
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=BDMCUML(400)
 W !!,"Hepatitis C (HCV)"
 W !,?3,"Diagnosed HCV ever",?49,$$C($P(V,U,35)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,35))
 W !!,?3,"In patients not diagnosed with HCV and",!?3,"age >= 18 years, screened ever",?49,$$C($P(V,U,37)),?61,$$C($P(V,U,40)),?73,$$P($P(V,U,40),$P(V,U,37))
 W !,?3,"In age >= 18 years, screened for HCV ever",!?3,"or HCV diagnosed ever",?49,$$C($P(V,U,45)),?61,$$C($P(V,U,50)),?73,$$P($P(V,U,50),$P(V,U,45))
 ;W !,?3,"HCV diagnosed ever"
 ;W !?6,"If born 1945-1965, screened ever",?49,$$C($P(V,U,39)),?61,$$C($P(V,U,36)),?73,$$P($P(V,U,36),$P(V,U,39))
COMBINED ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(260)) W !!,$P(V,U)
 W !?3,"Patients age >= 40 years meeting ALL of the ",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?3,"following criteria:  A1C <8.0, Statin currently ",!?3,"prescribed* and mean BP <130/<80"
 W !?3,"*Denominator excludes patients with a statin allergy, intolerance,",!?3," or contraindication"
 ;
COMOR ;
 I $Y>(BDMIOSL-11) D HEADER Q:BDMQUIT
 S V=BDMCUML(500)
 W !!,"Diabetes Related Conditions (In age >=18 years)"
 W !?3,"Severely obese (BMI >=40)",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !?3,"Hypertension diagnosed ever",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 ;
 W !?3,"CVD diagnosed ever",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,8))
 W !?3,"Retinopathy diagnosed ever",?49,$$C($P(V,U,38)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,38))
 W !?3,"Lower extremity amputation ever (any",?49,$$C($P(V,U,39)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,39)),!?6,"type (e.g., toe, partial foot, above",!?6,"or below knee)"
 W !?3,"Active depression diagnosis during ",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3)),!?6,"Audit period"
 W !?3,"CKD stage 3-5",?49,$$C($P(V,U,22)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,22))
COM ;
 I $Y>(BDMIOSL-10) D HEADER Q:BDMQUIT
 W !!?3,"Number of diabetes related conditions"
 W !?6,"Diabetes only",?49,$$C($P(V,U,25)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,25))
 W !?6,"Diabetes plus:"
 W !?8,"One",?49,$$C($P(V,U,26)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,26))
 W !?8,"Two",?49,$$C($P(V,U,27)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,27))
 W !?8,"Three",?49,$$C($P(V,U,28)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,28))
 W !?8,"Four",?49,$$C($P(V,U,29)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,29))
 W !?8,"Five or more",?49,$$C($P(V,U,30)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,30))
SDM ;
 I $Y>(BDMIOSL-4) D HEADER Q:BDMQUIT
 W !!,"Footnotes"
 W !?3,"[1] For triglycerides: >150 is a marker of CVD risk, not a treatment",!,"target; >1000 is a risk marker for pancreatitis."
 W !?3,"[2] Chronic Kidney Disease (CKD): eGFR <60 or Quantitative UACR >=30"
 D HEADER Q:BDMQUIT
 W !!,"Abbreviations"
 W !?3,"A1C = hemoglobin A1c (HbA1c)"
 W !?3,"ACE inhibitor = angiotensin converting enzyme inhibitor"
 I $Y>(BDMIOSL-3) D HEADER Q:BDMQUIT
 W !?3,"ARB = angiotensin receptor blocker"
 W !?3,"BMI = body mass index"
 W !?3,"BP = blood pressure"
 I $Y>(BDMIOSL-4) D HEADER Q:BDMQUIT
 W !?3,"DPP-4 inhibitor = dipeptidyl peptidase 4 inhibitor"
 W !?3,"DT = diphtheria and tetanus"
 W !?3,"DTaP = diphtheria, tetanus, and acellular pertussis"
 W !?3,"CKD = chronic kidney disease"
 I $Y>(BDMIOSL-3) D HEADER Q:BDMQUIT
 W !?3,"CVD = cardiovascular disease"
 W !?3,"eGFR = estimated glomerular filtration rate"
 W !?3,"ENDS = electronic nicotine delivery systems"
 I $Y>(BDMIOSL-4) D HEADER Q:BDMQUIT
 W !?3,"GLP-1 receptor agonist = glucagon-like peptide-1 receptor agonist"
 W !?3,"HCV = hepatitis C virus"
 W !?3,"HDL = high-density lipoprotein"
 W !?3,"LDL = low-density lipoprotein"
 I $Y>(BDMIOSL-4) D HEADER Q:BDMQUIT
 W !?3,"RD = registered dietitian"
 W !?3,"SGLT-2 inhibitor = sodium-glucose co-transporter-2 inhibitor"
 W !?3,"TB = tuberculosis"
 W !?3,"Td = tetanus and diphtheria"
 I $Y>(BDMIOSL-3) D HEADER Q:BDMQUIT
 W !?3,"Tdap = tetanus, diphtheria, and acellular pertussis"
 W !?3,"Trig = triglycerides"
 W !?3,"UACR = urine albumin-to-creatinine ratio"
 Q
EXIT ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO",DIR("A")="End of report.  Press ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
CALC(N,O) ;ENTRY POINT
 ;O is old
 NEW Z
 I O=0!(N=0) Q "**"
 NEW X,X2,X3
 S X=N,X2=1,X3=0 D COMMA^%DTC S N=X
 S X=O,X2=1,X3=0 D COMMA^%DTC S O=X
 S Z=(((N-O)/O)*100),Z=$FN(Z,"+,",1)
 Q Z
P(D,N) ;return %
 I 'D Q "  0%"
 I 'N Q "  0%"
 NEW X S X=N/D,X=X*100,X=$J(X,3,0)
 Q X_"%"
C(X,X2,X3) ;
 I '$G(X2) S X2=0
 I '$G(X3) S X3=6
 D COMMA^%DTC
 Q X
HEADER ;EP
 D HEADER^BDMDL14
 Q
