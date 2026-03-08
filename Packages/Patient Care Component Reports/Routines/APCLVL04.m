APCLVL04 ; IHS/CMI/LAB - SCREEN LOGIC ; 
 ;;2.0;IHS PCC SUITE;**2,4,7,26**;MAY 14, 2009;Build 48
 ;
EDDSEL ;EP - measurements and values
 ;get measurement type and value range and store as T_U_RANGE
 W !,"With this selection item you will be prompted to enter the date range"
 W !,"to search for Estimated Date of Delivery.  You will then be prompted"
 W !,"to select the Type of EDD estimation (LMP, Ultrasound or Clinical"
 W !,"Parameters).",!
GETEDD ;
 K APCLEDD
EDDDATE ;GET VALUE RANGE
BD ;
 W ! S DIR(0)="D^::EP",DIR("A")="Enter beginning EDD Date for Search" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"No date selected.  Choose again." K APCLMSR(0) G GETEDD
 S APCLBDAT=Y
ED ;get ending date
 W ! S DIR(0)="D^"_APCLBDAT_"::EP",DIR("A")="Enter ending EDD Date for Search" S Y=APCLBDAT D DD^%DT S DIR("B")=Y,Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCLEDAT=Y
 ;S APCLEDD(0)=APCLBDAT_":"_APCLEDAT
GETEDD1 ;
 W !,"Please choose the type of EDD Determination.  You will be given the"
 W !,"chance to choose more than one."
 S DIR(0)="SO^L:LMP;U:ULTRASOUND;C:CLINICAL PARAMETERS;A:ANY TYPE",DIR("A")="Select EDD Types",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT),'$D(APCLEDD) W !,"No Types Selected.  EDD not used as a selection item." K APCLEDD Q
 I Y="A" F X="U","L","C" S APCLEDD(X)=APCLBDAT_U_APCLEDAT G SETRPT
 ;
SETRPT ;
 S (X,Y)=0 F  S X=$O(APCLEDD(X)) Q:X'=+X  D
 .S Y=Y+1
 .S ^APCLVRPT(APCLRPT,11,APCLCRIT,0)=APCLCRIT,^APCLVRPT(APCLRPT,11,"B",APCLCRIT,APCLCRIT)=""
 .S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,Y,0)=X_"^"_APCLEDD(X)
 .S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,"B",X,Y)=""
 .S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,0)="^9001003.8110101A^"_Y_"^"_Y
 Q
EDDSCR ;EP - CALLED FROM EDD (ALL TYPES)
 ;S X(1)="" IF ANY ARE IN DATE RANGE
 Q:'$D(^AUPNREP(DFN,0))
 NEW G,Y,B,E,D
 S APCLSPEC=""
 S G=0
 K X
 S Y=$O(^APCLVRPT(APCLRPT,11,APCLI,11,0))
 S B=$P(^APCLVRPT(APCLRPT,11,APCLI,11,Y,0),U),E=$P(^APCLVRPT(APCLRPT,11,APCLI,11,Y,0),U,2)
 S D=$P($G(^AUPNREP(DFN,13)),U,2) D EDDCD I G S X(1)="",X=1 Q
 S D=$P($G(^AUPNREP(DFN,13)),U,5) D EDDCD I G S X(1)="",X=1 Q
 S D=$P($G(^AUPNREP(DFN,13)),U,8) D EDDCD I G S X(1)="",X=1 Q
 S D=$P($G(^AUPNREP(DFN,13)),U,14) D EDDCD I G S X(1)="",X=1 Q
 S D=$P($G(^AUPNREP(DFN,13)),U,11) D EDDCD I G S X(1)="",X=1 Q
 Q
EDDCD ;
 Q:D<B
 Q:D>E
 S G=1
 Q
 ;
EDDAPRT ;EP
 ;GET ALL EDD'S FOR PRINTING
 NEW C,D
 S C=0
 S D=$P($G(^AUPNREP(DFN,13)),U,2) I D S C=C+1,APCLPRNM(C)=$$DATE^APCLVLU(D)_" (BY LMP)"
 S D=$P($G(^AUPNREP(DFN,13)),U,5) I D S C=C+1,APCLPRNM(C)=$$DATE^APCLVLU(D)_" (BY ULTRASOUND)"
 S D=$P($G(^AUPNREP(DFN,13)),U,8) I D S C=C+1,APCLPRNM(C)=$$DATE^APCLVLU(D)_" (BY CLINICAL PARAMETERS)"
 S D=$P($G(^AUPNREP(DFN,13)),U,14) I D S C=C+1,APCLPRNM(C)=$$DATE^APCLVLU(D)_" (BY UNKNOWN METHOD)"
 S D=$P($G(^AUPNREP(DFN,13)),U,11) I D S C=C+1,APCLPRNM(C)=$$DATE^APCLVLU(D)_" (DEFINITIVE EDD)"
 Q
EDDSORT ;EP
 ;get earliest one for this patient
 NEW C,E,D
 S C=0,E=""
 S D=$P($G(^AUPNREP(DFN,13)),U,2) I D S E=D
 S D=$P($G(^AUPNREP(DFN,13)),U,5) I D,D<E S E=D
 S D=$P($G(^AUPNREP(DFN,13)),U,8) I D,D<E S E=D
 S D=$P($G(^AUPNREP(DFN,13)),U,14) I D,D<E S E=D
 S APCLPRNT=E
 Q
CMPRT ;EP - called from pgen item
 NEW A,B,C,D,E
 S (A,B,C,D,E)=""
 S A=0 F  S A=$O(^AUPNREP(DFN,2101,A)) Q:A'=+A  D
 .S B=$P(^AUPNREP(DFN,2101,A,0),U,1)
 .S B=$P(^AUTTCM(B,0),U,1)
 .I B="OTHER" S B=B_$S($P(^AUPNREP(DFN,2101,A,0),U,6)]"":"-"_$P(^AUPNREP(DFN,2101,A,0),U,6),1:"")
 .S D=$$DATE^APCLVLU1($P(^AUPNREP(DFN,2101,A,0),U,2))
 .S E=$$DATE^APCLVLU1($P(^AUPNREP(DFN,2101,A,0),U,3))
 .S C="",C=B_" "_D_"/"_E
 .S APCLPCNT=APCLPCNT+1
 .S APCLPRNM(APCLPCNT)=C
 .Q
 Q
I(%) ;
 I %="C" Q "SNOMED Concept ID"
 I %="D" Q "SNOMED Description ID"
 Q ""
SNOCI ;EP - SNOMED CONCEPT ID/DESCRIPTION LOOKUP VGEN
 W !!,"You will be prompted as to whether you want to search for a "_$$I(APCLIDC)
 W !,"or an SNOMED Subset.  You will be asked to enter a valid "_$$I(APCLIDC),","
 W !,"if you choose to search by subset you will be presented with a list of subsets"
 W !,"from which to choose.",!
 NEW APCLA ;,APCLSNO
 K ^TMP($J,"SNOMED")
 K APCLSNL
SNOCI1 ;
 W !
 S DIR(0)="SO^S:Subset of "_$$I(APCLIDC)_"s;C:"_$$I(APCLIDC),DIR("A")="Choose code selection method" KILL DA D ^DIR KILL DIR
 I $D(DIRUT),'$D(^TMP($J,"SNOMED")) W !!,"No SNOMEDs Selected." D PAUSE^APCLVL01 Q
 I Y="",'$D(^TMP($J,"SNOMED")) W !!,"No SNOMEDs Selected" D PAUSE^APCLVL01 Q
 I $D(DIRUT)!(Y=""),$D(^TMP($J,"SNOMED")) D SNOCSET Q
 I Y="S" D SNOCISUB G SNOCI1
IC ;GET SNOMED CONCEPT ID
 S DIR(0)="FO^1:60",DIR("A")="Enter "_$$I(APCLIDC) KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G SNOCI1
 I Y="" G SNOCI1
 I APCLIDC="C" S %=$$CONC^BSTSAPI(Y)
 I APCLIDC="D" S %=$$DESC^BSTSAPI(Y)
 I $P(%,U)="" W !!,"That is not a valid "_$$I(APCLIDC)_".",! D PAUSE^APCLVL01 G IC
 S ^TMP($J,"SNOMED",Y)=""
 G IC
SNOCISUB ;get snomed subsets
 W !!,"You will presented with a list of all SNOMED Subsets.  You can choose"
 W !,"any number of subsets to include in your search.  To select more than one"
 W !,"subset enter the #s associated with those subsets separated by commas,"
 W !,"e.g  3,20,30"
 D PAUSE^APCLVL01
 ;GET SUBSET LISTS AND SET INTO ^TMP($J,"SNOMED")
 K APCLSNL
 D EN^APCLVLSN
 I '$D(APCLSNL) W !!,"No subsets selected." D PAUSE^APCLVL01 Q
 S N="" F  S N=$O(APCLSNL(N)) Q:N=""  K Z S X=$$SUBLST^BSTSAPI("Z",N) S X=0 F  S X=$O(Z(X)) Q:X'=+X  S ^TMP($J,"SNOMED",$P(Z(X),U,$S(APCLIDC="D":2,1:1)))=""
 Q
SNOCSET ;
 K APCLSNL
 S (X,Y)=0 F  S X=$O(^TMP($J,"SNOMED",X)) Q:X'=+X  D
 .S Y=Y+1
 .S ^APCLVRPT(APCLRPT,11,APCLCRIT,0)=APCLCRIT,^APCLVRPT(APCLRPT,11,"B",APCLCRIT,APCLCRIT)=""
 .S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,Y,0)=X
 .S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,"B",X,Y)=""
 .S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,0)="^9001003.8110101A^"_Y_"^"_Y
 K ^TMP($J,"SNOMED")
 Q
PRIMSNO(V,D,T) ;
 NEW %,Y,P,C,Z
 S D=$G(D)
 S T=$G(T)
 S (Z,P)="",(Y,C)=0
 I $P(^AUPNVSIT(V,0),U,7)="H" F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y  I $P(^AUPNVPOV(Y,0),U,12)="P" S Z=Y
 I $P(^AUPNVSIT(V,0),U,7)'="H" S Y=$O(^AUPNVPOV("AD",V,0)) I Y S Z=Y
 I Z="" Q ""
 I D="C" S V=$$VAL^XBDIQ1(9000010.07,Z,1101)
 I D="D" S V=$$VAL^XBDIQ1(9000010.07,Z,1102)
 I D="C",V]"" Q $S(T="S":V,T="P":V_" - "_$$VAL^XBDIQ1(9000010.07,Z,1101.019),1:"")
 I D="D",V]"" Q $S(T="S":V,T="P":V_" - "_$$VAL^XBDIQ1(9000010.07,Z,1102.019),1:"")
 Q ""
