APCDCAF4 ; IHS/CMI/LAB - MENTAL HLTH ROUTINE 16-AUG-1994 ;
 ;;2.0;IHS PCC SUITE;**7,11,26**;MAY 14, 2009;Build 48
 ;; ;
 ;
GREC ;EP - called from coding queue listman to select visit
 ;sensitive patient tracking
 NEW APCDV,APCDP,APCDI
 S APCDVSIT=""
 K DIR
 S DIR(0)="NO^1:"_APCDRCNT,DIR("A")=APCDALAB
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" Q
 I $D(DIRUT) Q
 S APCDV=^TMP("APCDCAF",$J,"IDX",Y,Y)
 S APCDP=$$VALI^XBDIQ1(9000010,APCDV,.05)
 D PTSEC^DGSEC4(.APCDI,APCDP,1)
 I '$G(APCDI(1)) G GRECE
 I $G(APCDI(1))=3!($G(APCDI(1))=4)!($G(APCDI(1))=5) D DISPDG,PAUSE^APCDALV1 Q
 D DISPDG
 W ! K DIR S DIR(0)="Y",DIR("A")="Do you want to continue to edit this record",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I 'Y Q
 K APCDI
 D NOTICE^DGSEC4(.APCDI,APCDP,,3)
GRECE ;
 S APCDVSIT=APCDV
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
DISPDG ;EP
 W !!,"You are processing a record for the following sensitive patient:",!
 W !?5,$P(^DPT(APCDP,0),U,1),?40,"DOB: ",$$FMTE^XLFDT($$DOB^AUPNPAT(APCDP)),?65,"HRN: ",$$HRN^AUPNPAT(APCDP,DUZ(2))
 S X=1 F  S X=$O(APCDI(X)) Q:X'=+X  W !,$$CTR(APCDI(X))
 Q
DISP ;EP
 D FULL^VALM1
 D EN^XBNEW("DISP1^APCDCAF4","VALM*;APCDCAFP;APCDCAFO;APCDDFN")
 ;
 ;
DISPX ;
 K DIR,DIRUT,DUOUT,Y,APCDVSIT,APCDCAF,APCDCAFV
 D KILL^AUPNPAT
 D BACK^APCDCAF
 Q
DISP1 ;
 I $G(APCDCAFO) S APCDPAT=APCDDFN D  Q
 .D GETVISIT^APCDDISP
 .I '$G(APCDVSIT) W !!,"No visit selected." D PAUSE^APCDALV1 Q
 .D DSPLY^APCDDISP
 .D PAUSE^APCDALV1 Q
 D ^APCDDISP
 D PAUSE^APCDALV1
 Q
DISPO ;EP
 NEW APCDCAFO
 S APCDCAFO=1
 D DISP
 Q
RN ;EP
 D FULL^VALM1
 W !!,"You will be prompted to enter a Patient Name and visit date and then"
 W !,"will be given the opportunity to edit the chart audit note or completely"
 W !,"delete the note.",!
 D EN^XBNEW("RN1^APCDCAF4","VALM*;APCDCAFP;APCDCAFO;APCDDFN")
 ;
 ;
RNX ;
 K DIR,DIRUT,DUOUT,Y,APCDVSIT,APCDCAF,APCDCAFV
 D KILL^AUPNPAT
 D BACK^APCDCAF
 Q
RN1 ;
 I $G(APCDCAFO) S APCDPAT=APCDDFN D  Q
 .D GETVISIT^APCDDISP
 .I '$G(APCDVSIT) W !!,"No visit selected." D PAUSE^APCDALV1 Q
 .D DSPLY^APCDDISP
 .D PAUSE^APCDALV1 Q
 D GETPAT^APCDDISP
 I APCDPAT="" W !!,"No PATIENT selected!" Q
 D GETVISIT^APCDDISP
 I APCDVSIT="" W !!,"No VISIT selected!" Q
 Q
RNU ;EP 
 ;edit note or remove note
 I '$D(^AUPNCANT("B",APCDVSIT)) Q
 W !!,"Chart Audit Notes for this visit: ",!
 I '$D(^AUPNCANT("B",APCDVSIT)) W !!?4,"There are no Chart Audit Notes on file for this visit.",! D PAUSE^APCDALV1 Q
 S X=0 F  S X=$O(^AUPNCANT(APCDVSIT,11,X)) Q:X'=+X  W !,^AUPNCANT(APCDVSIT,11,X,0)
 W !
 D PAUSE^APCDALV1
 S DIR(0)="S^D:Delete the Chart Audit Notes from this visit;E:Edit the Chart Audit Notes;Q:No Audit Note Change",DIR("A")="Choose Action",DIR("B")="Q" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D PAUSE^APCDALV1 Q
 I Y="E" S DIE="^AUPNCANT(",DR=1100,DA=APCDVSIT D ^DIE K DIE,DA,DR D PAUSE^APCDALV1 Q
 I Y="D" K ^AUPNCANT(APCDVSIT,11) W !!,"Notes removed." D PAUSE^APCDALV1 Q  ;kill off word processing field
 Q
RNO ;EP
 NEW APCDCAFO
 S APCDCAFO=1
 D RN
 Q
ALERT(PRV,VISIT,IENS) ;EP  - called from APCDCAF6
 NEW DIR,DA,Y,X,XQA,XQAFLG,XQATEXT
 W !!
 W !!,"The following notification can be sent to provider "_$$VAL^XBDIQ1(200,PRV,.01),":"
 S XQATEXT(1,0)="VISIT Date: "_$$VAL^XBDIQ1(9000010,VISIT,.01)_"  HRN: "_$$HRN^AUPNPAT($P(^AUPNVSIT(VISIT,0),U,5),DUZ(2))
 S XQATEXT(2,0)="  Deficiency: "_$$GET1^DIQ(9000095.12,IENS,.02,"E") ;_"  (See "_$$GET1^DIQ(9000095.12,IENS,.05,"E")_" for detail.)"
 S XQAMSG="VISIT Date: "_$$VAL^XBDIQ1(9000010,VISIT,.01)_"  HRN: "_$$HRN^AUPNPAT($P(^AUPNVSIT(VISIT,0),U,5),DUZ(2))_"  has a chart deficiency"
 W !!,XQAMSG,!,XQATEXT(1,0),!,XQATEXT(2,0),!!
 S DIR(0)="Y",DIR("A")="Send this chart deficiency notification to "_$$VAL^XBDIQ1(200,PRV,.01)_"(Y/N)",DIR("B")="No" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I 'Y Q
 W !,"You can add up to 80 characters of additional information (Press enter to bypass)",!
 S DIR(0)="FO^1:80",DIR("A")="Additional text" KILL DA D ^DIR KILL DIR
 I Y]"" S XQATEXT(3,0)=Y
 ;
 ;create and send alert
 S XQA(PRV)=""
 S XQAOPT=""
 S XQAROU=""
 S XQAFLG="D"
 S XQAID="OR,"_$P(^AUPNVSIT(VISIT,0),U,5)_",46"
 ;S XQATEXT(1,0)="VISIT Date: "_$$VAL^XBDIQ1(9000010,VISIT,.01)_"  HRN: "_$$HRN^AUPNPAT($P(^AUPNVSIT(VISIT,0),U,5),DUZ(2))
 ;S XQATEXT(2,0)="  Deficiency: "_$$GET1^DIQ(9000095.12,IENS,.02,"E")_"  (See "_$$GET1^DIQ(9000095.12,IENS,.05,"E")_" for detail.)"
 ;S XQAMSG="VISIT Date: "_$$VAL^XBDIQ1(9000010,VISIT,.01)_"  HRN: "_$$HRN^AUPNPAT($P(^AUPNVSIT(VISIT,0),U,5),DUZ(2))_"  has a chart deficiency"
 D SETUP^XQALERT
 W !!
 Q
