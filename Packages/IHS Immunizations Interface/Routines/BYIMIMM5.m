BYIMIMM5 ;IHS/CIM/THL - IMMUNIZATION DATA EXCHANGE;
 ;;3.0;BYIM IMMUNIZATION DATA EXCHANGE;**4,5,6**;AUG 20, 2020;Build 739
 ;
RXA ;EP;TO SET THE IIS CODE FOR RXA-11.4
 S BYIMDUZ=$$DUZ^BYIMIMM()
 Q:'BYIMDUZ
 N BYIMRXA,DISP,BYIMQUIT
 I '$G(BYIMAS),$O(^BYIMPARA(BYIMDUZ,5,0)) D RXA1 Q
 I $G(BYIMAS),$O(^BYIMPARA(BYIMDUZ,3,BYIMAS,5,0)) D RXA1 Q
 W !!,"Some state Immunization Information Systems (IIS) require facilities to send"
 W !,"a code to identify the facility at which the immunization was administered or"
 W !,"identify the vaccine inventory location instead of the facility name."
 W !!,"If you need to add state IIS assigned code(s) please enter 'Y' below."
 W !,"You will be prompted to select the name of your facility and then"
 W !,"enter the state assigned code."
 K DIR
 S DIR(0)="YO"
 S DIR("A")="Add State IIS Assigned Facility Codes"
 S DIR("B")="NO"
 W !!
 D ^DIR
 K DIR
 Q:'Y
RXA1 N BYIMX
 S BYIMQUIT=0
 F  D RXAACT Q:BYIMQUIT
 Q
 ;=====
RXAACT ;ADDITIONAL SITE ACTION
 I '$G(BYIMAS),'$O(^BYIMPARA(BYIMDUZ,5,0)) D RXAADD
 I $G(BYIMAS),'$O(^BYIMPARA(BYIMDUZ,3,BYIMAS,5,0)) D RXAADD
 I '$G(BYIMAS),'$O(^BYIMPARA(BYIMDUZ,5,0)) S BYIMQUIT=1 Q
 I $G(BYIMAS),'$O(^BYIMPARA(BYIMDUZ,3,BYIMAS,5,0)) S BYIMQUIT=1 Q
 D RXADISP
 K DIR
 S DIR(0)="SO^1:Edit a listed Code;2:Add IIS Code for another Facility;3:Delete IIS Code for a Facility"
 W !!
 D ^DIR
 K DIR
 I 'Y S BYIMQUIT=1 Q
 I Y=1 D RXAEDIT Q
 I Y=2 D RXAADD Q
 I Y=3 D RXADEL
 Q
 ;=====
RXAADD ;SELECT FACILITIES FOR STATE RXA CODE
 N BYIMX,BYIMY
 S DIC="^DIC(4,"
 S DIC(0)="AEMQZ"
 S DIC("A")="Select Facility for the IIS assigned Code: "
 W !
 D ^DIC
 I Y<1 S BYIMQUIT=1 Q
 S BYIMX=+Y
 S BYIMY=$P(^DIC(4,+Y,0),U)
 K DIR
 S DIR(0)="FO^1:50"
 S DIR("A")="Enter State IIS Code assigned for **"_BYIMY_"**"
 W !
 D ^DIR
 K DIR
 I X="" S BYIMQUIT=1 Q
 S BYIMY=X
 S X=BYIMX
 S DA(1)=BYIMDUZ
 S DIC="^BYIMPARA("_DA(1)_",5,"
 I $G(BYIMAS) D
 .S DA(2)=DA(1)
 .S DA(1)=BYIMAS
 .S DIC="^BYIMPARA("_DA(2)_",3,"_DA(1)_",5,"
 S DIC(0)="L"
 S DIC("DR")=".02////"_BYIMY
 S DINUM=X
 D FILE^DICN
 I Y<1 S BYIMQUIT=1 Q
 Q
 ;=====
RXADISP ;DISPLAY EXISTING IIS RXA CODES
 K BYIMRXA
 N DISP,J,X,Y,Z
 S J=0
 S X=0
 D:'$G(BYIMAS)
 .F  S X=$O(^BYIMPARA(BYIMDUZ,5,X)) Q:'X  S Y=$G(^(X,0)) D:Y DISPA
 D:$G(BYIMAS)
 .F  S X=$O(^BYIMPARA(BYIMDUZ,3,BYIMAS,5,X)) Q:'X  S Y=$G(^(X,0)) D:Y DISPA
 S J=0
 S X=""
 F  S X=$O(X(X)) Q:X=""  D
 .S J=J+1
 .S $E(DISP(J),11)=J
 .S $E(DISP(J),16)=X
 .S $E(DISP(J),60)=$P(X(X),U,2)
 .S BYIMRXA(J)=+X(X)
 S BYIMJ=J
 W @IOF
 W !?5,$S($G(ASNAM)]"":ASNAM,$G(BYIMPES):$P($G(^DIC(5,BYIMPES,0)),U),1:"State")
 W " IIS Assigned Vaccine Inventory Location Code"
 W !!?10,"NO."
 W ?15,"Facility"
 W ?59,"IIS Code"
 W !?10,"---",?15,"------------------------------",?59,"--------------------"
 S J=0
 F  S J=$O(DISP(J)) Q:'J  D
 .W !,DISP(J)
 Q
 ;=====
DISPA ;SET DISPLAY ARRAY   
 S Z=$P($G(^DIC(4,X,0)),U)
 Q:Z=""
 S Z=Z_" (IEN "_X_")"
 S J=J+1
 S X(Z)=Y
 Q
 ;=====
RXAEDIT ;EDIT SITE
 N DA
 D RXASEL
 Q:'$G(DA)
 D RXAE1(DA)
 Q
 ;=====
RXAE1(DA) ;EP;CALLED TO EDIT IIS 'DA' DEFINED
 S DA(1)=BYIMDUZ
 S DR=".02T"
 S DIE="^BYIMPARA("_DA(1)_",5,"
 D:$G(BYIMAS)
 .S DA(2)=BYIMDUZ
 .S DA(1)=BYIMAS
 .S DIE="^BYIMPARA("_DA(2)_",3,"_BYIMAS_",5,"
 W !!,"Edit IIS Facility Code for: ",$P($G(^DIC(4,DA,0)),U)
 D ^DIE
 K DA,DR,DIE
 Q
 ;=====
RXADEL ;DELETE SITE
 N DA
 D RXASEL
 Q:'$G(DA)
 I '$G(BYIMAS) S X=+^BYIMPARA(BYIMDUZ,5,DA,0)
 I $G(BYIMAS) S X=+^BYIMPARA(BYIMDUZ,3,BYIMAS,5,DA,0)
 S X=$P($G(^DIC(4,X,0)),U)
 W ?40,X
 K DIR
 S DIR(0)="YO"
 S DIR("A")="Delete IIS Assigned code for: "_X
 S DIR("B")="NO"
 W !
 D ^DIR
 K DIR
 Q:Y'=1
 S DA(1)=BYIMDUZ
 S DIK="^BYIMPARA("_BYIMDUZ_",5,"
 D:$G(BYIMAS)
 .S DA(2)=DA(1)
 .S DA(1)=BYIMAS
 .S DIK="^BYIMPARA("_BYIMDUZ_",3,"_BYIMAS_",5,"
 D ^DIK
 K DA,DIK
 Q
 ;=====
RXASEL ;SELECT ADDITION SITE
 I BYIMJ=1 S Y=1 D RXASEL1 Q
 K DIR
 S DIR(0)="NO^1:"_BYIMJ
 S DIR("A")="Select Facility number"
 W !!
 D ^DIR
 K DIR
RXASEL1 I 'Y S (DA,Y)="" Q
 Q:'$G(BYIMRXA(Y))
 S DA=BYIMRXA(Y)
 Q
 ;=====
TEST ;EP;CREATE & SEND TEST MESSAGES
 ;V3.0 PATCH 5 - FID-84367 FIX TEST EXPORT UNDEF
 K ^BYIMTMP($J,"BYIM EXP")
 K DIR,BYIMFILE
 W @IOF
 W !!?10,"Select group of patients for TEST export"
 S DIR(0)="SO^1:Random group of patients;2:Select patient(s) for test export"
 S DIR("A")="Which group of patients"
 S DIR("B")="Random group of patients"
 W !!
 D ^DIR
 K DIR
 Q:'Y
 I Y=1 D RAND I 1
 E  D SPAT^BYIMIMM3 S BYIMTEST=BYIMJ,BYIMALL=2,BYIMADM=2
 Q:'$D(^BYIMTMP($J,"BYIM EXP"))
 ;V3.0 PATCH 6 - FID-83363 EXPORT FOR SELECTED STATES
 D EXPST^BYIMRT3
 K DIR
 S DIR(0)="YO"
 S DIR("A")="Proceed with test export of "_BYIMTEST_" patient(s)"
 S DIR("B")="NO"
 W !!
 D ^DIR
 K DIR
 Q:'Y
 S MSGCNT=BYIMTEST+1
 S XX=$P($H,",",2)
 N DDATE
 D FN^BYIMIMM
 S (DDATE,BYIMLEDT)=$O(^BYIMPARA($$DUZ^BYIMIMM(),"LAST EXPORT",9999999999),-1)
 D DEX^BYIMIMM
 ;V3.0 PATCH 5 - FID-84367 END
 Q
 ;=====
CLEAN ;EP;CLEAN UP AFTER TEST EXPORT
 N IMM
 S IMM=0
 F  S IMM=$O(^BYIMTMP("TEST",IMM)) Q:'IMM  D
 .;REMOVE 'D' WHEN SET BY TEST
 .K ^BYIMEXP("D",IMM),^BYIMTMP("TEST",IMM)
 S IMM=0
 F  S IMM=$O(^BYIMTMP("TEST ALL",IMM)) Q:'IMM  D
 .;RESET 'D' WHEN REMOVED BY TEST
 .S ^BYIMEXP("D",IMM,+$O(^BYIMTMP("TEST ALL",IMM,"")))=""
 .K ^BYIMTMP("TEST ALL",IMM)
 Q
 ;=====
TSPEC ;SELECT SPECIFICATIONS FOR TEST EXPORT
 K BYIMEDAT,BYIMADM,BYIMALL
 W @IOF
 W !!?10,"Default TEST export criteria"
 S BYIMEDAT=""
 S BYIMEDAT(0)=""
 S BYIMADM=2
 S BYIMALL=2
 D TSHOW
 K DIR
 S DIR(0)="LO^1:3"
 S DIR("A",1)="   1.  Specify start date for immunizations to include"
 S DIR("A",2)="   2.  Exclude HISTORIC immunizations"
 S DIR("A",3)="   3.  Exclude PREVIOUSLY EXPORTED immunizations"
 S DIR("A",4)="         "
 S DIR("A")="Select all criteria you want to set"
 W !!
 D ^DIR
 K DIR
 Q:'Y
 S BYIMY=Y
 F J=1:1:$L(BYIMY,",")-1 S SR="T"_$P(BYIMY,",",J) D @SR
 Q:'BYIMEDAT&'BYIMADM&'BYIMALL
 D TSHOW
 Q
TSHOW ;SHOW TEST EXPORT CRITERIA
 W !!!?10,"TEST Export Criteria:"
 W !!,"Start date: ",BYIMEDAT(0)
 W !!
 I BYIMADM=2 D  I 1
 .W "Administered and historic"
 E  W "Only administered"
 W " and ",!
 I BYIMALL=2 D  I 1
 .W "new and previously exported"
 E  W "never exported"
 W !,"immunizations will be included in the test export."
 Q
 ;=====
T1 ;SELECT TEST EXPORT DATE
 K DIR
 S DIR(0)="DO^::EP"
 S DIR("A")="Select start date for the TEST export"
 W !!
 D ^DIR
 K DIR
 Q:'X
 S BYIMEDAT=Y,BYIMEDAT(0)=Y(0)
 Q
 ;=====
T2 ;INCLUDE ONLY ADMINISTERED IMMUNIZATIONS
 S BYIMADM=2
 K DIR
 S DIR(0)="YO"
 S DIR("A")="Exclude HISTORIC immunizations"
 S DIR("B")="YES"
 W !
 D ^DIR
 K DIR
 Q:X[U
 I 'Y S BYIMADM=2 Q
 S BYIMADM=1
 Q
 ;=====
T3 ;EXCLUDE PREVIOUSLY EXPORTED IMMUNIZATIONS
 ;BYIMALL=1 EXPORT ONLY NEW, NOT YET EXPORTED IMMS
 ;BYIMALL=2 EXPORT NEW AND PREVIOUSLY EXPORTED IMMS
 S BYIMALL=2
 K DIR
 S DIR(0)="YO"
 S DIR("A")="Exclude PREVIOUSLY EXPORTED immunizations"
 S DIR("B")="YES"
 W !
 D ^DIR
 K DIR
 Q:X[U
 I 'Y S BYIMALL=2 Q
 S BYIMALL=1
 Q
 ;=====
COMPSPEC ;EP;TO SPECIFY MESSAGE COMPONENT CONTENT
 ;N X,Y,Z,XX,SEG,COMP,SCOMP,VAL,BYIMQUIT
 S BYIMQUIT=0
 F  D CS Q:BYIMQUIT
 Q
 ;=====
CS ;REPEAT
 D CDISP
 I '$O(COMP(0)) S QUIT=1 Q
 D CSEL
 Q
 ;=====
CDISP ;EP;DISPLAY COMPONENTS FOR PRIMARY SITE
 S SITE=$P(^DIC(4,$$DUZ^BYIMIMM(),0),U)
 D CHDR(SITE)
 S X=0
 F  S X=$O(^BYIMPARA($$DUZ^BYIMIMM(),7,X)) Q:'X  S Y=^(X,0) D
 .S SEG=$P(Y,U)
 .S COMP=$P(Y,U,2)
 .S SCOMP=$P(Y,U,3)
 .Q:'COMP!'SCOMP
 .S VAL=$P(Y,U,4)_U_X
 .S:SEG="MSH" SEG="1-MSH"
 .S:SEG="PID" SEG="2-PID"
 .S:SEG="PD1" SEG="3-PD1"
 .S:SEG="NK1" SEG="4-NK1"
 .S:SEG="PV1" SEG="5-PV1"
 .S:SEG="ORC" SEG="6-ORC"
 .S:SEG="RXA" SEG="7-RXA"
 .S XX(SEG,COMP,SCOMP)=VAL
 D CD
 Q
 ;=====
CAS(AS) ;EP;DISPLAY COMPONENTS FOR ADDITIONAL EXPORT SITES
 S SITE=$P(^BYIMPARA($$DUZ^BYIMIMM(),3,AS,0),U)
 D CHDR(SITE)
 N X,Y,Z,XX,SEG,SCOMP,VAL
 S X=0
 F  S X=$O(^BYIMPARA($$DUZ^BYIMIMM(),3,AS,7,X)) Q:'X  S Y=^(X,0) D
 .S SEG=$P(Y,U)
 .S COMP=$P(Y,U,2)
 .S SCOMP=$P(Y,U,3)
 .S VAL=$P(Y,U,4)
 .S:SEG="MSH" SEG="1-MSH"
 .S:SEG="PID" SEG="2-PID"
 .S:SEG="PD1" SEG="3-PD1"
 .S:SEG="NK1" SEG="4-NK1"
 .S:SEG="PV1" SEG="5-PV1"
 .S:SEG="ORC" SEG="6-ORC"
 .S:SEG="RXA" SEG="7-RXA"
 .S XX(SEG,COMP,SCOMP)=X_U_VAL
 D CD
 Q
 ;=====
CD ;
 S JJ=0
 S X=""
 F  S X=$O(XX(X)) Q:X=""  D
 .S Y=0
 .F  S Y=$O(XX(X,Y)) Q:'Y  D
 ..S Z=0
 ..F  S Z=$O(XX(X,Y,Z)) Q:'Z  S VAL=XX(X,Y,Z) D
 ...S JJ=JJ+1
 ...W !,JJ,?5,$P(X,"-",2),?18,Y,?30,Z,?39,$P(VAL,U)
 ...S COMP(JJ)=+VAL_U_$P(X,"-",2)
 S BYIMJ=JJ
 Q
 ;
CHDR(SITE) ;DISPLAY COMPONENT HEADER
 W @IOF
 W !!?15,"HL7 State Specified Message Components"
 W !?15,"For: ",SITE
 W !!?27,"Sub-"
 W !,"NO",?5,"Segment",?15,"Component",?27,"Component",?39,"Value"
 W !,"--",?5,"-------",?15,"---------",?27,"---------",?39,"--------------------------"
 Q
 ;=====
CADD ;ADD ADDITIONAL COMPONENTS
 S DIR(0)="SO^1:MSH;2:PID;3:PD1;4:NK1;5:PV1;6:ORC;7:RXA"
 S DIR("A")="Select a segment for component specification"
 W !!
 D ^DIR
 K DIR
 Q:'Y
 S SEG=Y(0)
 I $D(^BYIMPARA($$DUZ^BYIMIMM(),7,"SEG",X)) D
 .S DIR(0)="YO"
 .S DIR("A")="ADD another "_SEG_" component"
 .W !!
 .D ^DIR
 Q:'Y
 S X=SEG
 S DA(1)=$$DUZ^BYIMIMM()
 S DIC="^BYIMPARA("_DA(1)_",7,"
 S DIC(0)="L"
 D FILE^DICN
 Q:'Y
 D CE(+Y,SEG)
 Q
 ;=====
CEDIT ;EDIT COMPONENTS
 K DIR
 S DIR(0)="NO^1:"_BYIMJ
 S DIR("A")="Select Component to edit"
 W !!
 D ^DIR
 K DIR
 Q:'Y
 S SEG=$P(COMP(Y),U,2)
 D CE(Y)
 Q
 ;=====
CE(DA,SEG) S DIE="^BYIMPARA("_$$DUZ^BYIMIMM()_",7,"
 S DA(1)=$$DUZ^BYIMIMM()
 S DA=DA
 S DR=".02;.03;.04"
 W !!,"Edit ",SEG," info",!
 D ^DIE
 Q
 ;=====
CDEL ;DELETE COMPONENTS    
 Q
 ;=====
CSEL ;EP;TO DISPLAY AND ADD/EDIT COMPONENTS
 D CDISP
 K DIR
 S DIR(0)="SO^1:Edit Message Components;2:Add Message Components;3:Delete Message Components"
 W !!
 D ^DIR
 K DIR
 I 'Y S BYIMQUIT=1 Q
 I Y=1 D CEDIT Q
 I Y=2 D CADD Q
 I Y=3 D CDEL
 Q
 ;=====
AGECHK(DFN,STATE) ;EP;
 ;TO CHECK EXPORT AGE OF ADD. EXPORT STATES AS WELL AS PRIMARY SITE
 ;RETURN '1' IF AGE APPROPRIATE FOR EXPORT
 ;RETURN '0' IF AGE APPROPRIATE NOT FOR EXPORT
 Q:'$G(DFN) 0
 N X,Y,Z,BYIMDUZ,AGE,D19,D65,DOB
 S Z=0
 S BYIMDUZ=$$DUZ^BYIMIMM()
 S:'$G(STATE) STATE=BYIMDUZ
 S:STATE=BYIMDUZ AGE=+$P($G(^BYIMPARA(BYIMDUZ,0)),U,6)
 S:STATE'=BYIMDUZ AGE=+$P($G(^BYIMPARA(BYIMDUZ,3,+$G(STATE),0)),U,6)
 S DOB=$P($G(^DPT(DFN,0)),U,3)
 ;PATCH 4 - FID-82411
 ;Mass. Immunization Exchange send 19 and older only
 S:AGE="" AGE=2
 S D19=(DT-190001) ;CHANGE TO FM DATE FORMAT AND 19 YEARS
 S D18=(DT-179999) ;CHANGE TO FM DATE FORMAT AND 18 YEARS
 S D65=(DT-650000) ;CHANGE TO FM DATE FORMAT AND 65 YEARS
 ;INCLUDE IF AGE = ALL
 I AGE=2 S Z=1
 ;No longer applicable - INCLUDE IF AGE <19 OR >65
 ;I AGE=1,DOB>D19!(DOB<D65) S Z=1
 ;INCLUDE IF AGE <19
 I AGE=0,DOB>D19 S Z=1
 ;INCLUDE IF AGE >18 S Z=1
 I AGE=1,DOB<D18 S Z=1
 ;PATCH 4 - FID-82411 END
 Q Z
 ;=====
ASSET(AS) ;EP;SITE STATE VARIABLES
 D ASSET^BYIMIMM7(AS)
 Q
 ;=====
BRIDGE ;EP;
 Q
 ;=====
STEST(INDA) ;EP;TEST OF SCRN IN BYIMIMM6 TO SEE IF PATIENT/IMMUNIZATION BEING
 ;SCREENED OUT OF EXPORT
 ;INDA = IEN FROM V IMM
 S INDA("BYIMALL")=1
 S INDA("BYIMADM")=1
 S INDA("BYIMLEDT")=$G(BYIMLEDT)
 S INDA("BYIMLEDT")=$G(BYIMLEDS)
 S INDA("BYIMLEDT")=$G(BYIMLEDE)
 S INDA("BYIMLEDT")=$G(BYIMHX)
 S INDA("NOW")=$G(NOW)
 Q $$SCRN^BYIMIMM6(.INDA)
 ;=====
 ;
RAND ;SELECT RANDOM PATIENTS
 S BYIMDUZ=$$DUZ^BYIMIMM()
 S Y=+$P(^BYIMPARA(BYIMDUZ,0),U,6)
 S D19=(DT-190001) ;CHANGE TO FM DATE FORMAT AND 19 YEARS
 S D65=(DT-650000) ;CHANGE TO FM DATE FORMAT AND 65 YEARS
 K DIR
 I $O(^BYIMPARA(BYIMDUZ,3,0)) S Y=2
 E  D  Q:"012"'[Y
 .W !!?10,"The site parameter for age is set to "
 .W $S(Y=0:"18 AND UNDER",1:"UNDER 19 AND OVER 65",1:"ALL AGES")
 .S DIR(0)="SO^0:18 AND UNDER;1:UNDER 19 AND OVER 64;2:ALL AGES"
 .S DIR("B")=$S(Y=0:"18 AND UNDER",Y=1:"UNDER 19 AND OVER 64",1:"ALL AGES")
 .D ^DIR
 .K DIR
 S YEARS=$S('Y:19,Y=1:65,1:99)
 S CHILD=$S('Y:"Children",1:"Patients")
 W @IOF
 W !!?10,"TEST export option"
 W !!?10,"An export file will be created for"
 W !?10,CHILD," ",$S(YEARS=19:"18 years of age or under.",YEARS=65:"18 and under and over 65",1:"of all ages.")
 W !!
 K DIR
 S DIR(0)="NO^1:1000"
 S DIR("A",1)="Enter the number of patients"
 S DIR("A")="to include in the test export"
 S DIR("B")="10"
 D ^DIR
 K DIR
 Q:'Y
 S BYIMTEST=Y
 D TSPEC
 K ^BYIMTMP($J,"BYIM EXP")
 N XX,X,Y,Z,DOB,DFN,VIS,J
 S J=0
 S VIS=$O(^AUPNVSIT(9999999999),-1)-$R(999)
 F  S VIS=$O(^AUPNVIMM("AD",VIS),-1) Q:'VIS!(J>(BYIMTEST-1))  D
 .N DAT
 .S DAT=+$P($G(^AUPNVSIT(VIS,0)),".")
 .Q:$L(DAT)'=7
 .I BYIMEDAT Q:DAT<BYIMEDAT
 .I BYIMADM=1 Q:"CTNOEDXM"[$P(^AUPNVSIT(VIS,0),U,7)
 .S X=$O(^AUPNVIMM("AD",VIS,0))
 .Q:'X
 .S X=$G(^AUPNVIMM(X,0))
 .S DFN=+$P(X,U,2)
 .Q:'DFN
 .Q:$G(^DPT(DFN,.35))
 .Q:'$G(^AUPNPAT(DFN,0))
 .Q:$D(^BYIMTMP($J,"BYIM EXP",DFN))
 .I BYIMALL'=2!(BYIMADM'=2) Q:'$$NEW^BYIMIMM6(DFN,BYIMALL,BYIMADM,BYIMEDAT)
 .S DOB=$P($G(^DPT(DFN,0)),U,3)
 .I YEARS=19,DOB<D19 Q
 .I YEARS=65,DOB<D19!(DOB>D65) Q
 .S ^BYIMTMP($J,"BYIM EXP",DFN,VIS)=""
 .S J=J+1
 .S JX=0
 .S JY=0
 .N IMM
 .S IMM=0
 .F  S IMM=$O(^AUPNVIMM("AC",DFN,IMM)) Q:'IMM  D
 ..S JX=JX+1
 ..N IVIS
 ..S IVIS=$P($G(^AUPNVIMM(IMM,0)),U,3)
 ..Q:'IVIS
 S BYIMTEST=J
 Q
 ;=====
 ;
