PSSPOIZ0 ;BIR/RTR/WRT-Edit Orderable Item Name and Inactive date-cont ;07-Nov-2022 10:11;DU
 ;;1.0;PHARMACY DATA MANAGEMENT;**1023,1032**;9/30/97;Build 26
 ;---------------------------------------------------------------------
 ;IHS/MSC/MGH Moved from PSSPOIMO due to size issues
 ;IHS/MSC/MGH added from patch 166 for EPCS
DFR(PSDOSE) ; dosage form med routes - called by DR string at DIR+20^PSSPOIMO
 D SETF
 N MR,MRNODE,XX K ^TMP("PSSDMR",$J)
 S (MCT,MR)=0 F  S MR=$O(^PS(50.606,PSDOSE,"MR",MR)) Q:'MR  D
 .S XX=+$G(^PS(50.606,PSDOSE,"MR",MR,0)) Q:'XX  S MRNODE=$G(^PS(51.2,XX,0)) I $P($G(MRNODE),"^",4)'=1 Q
 .S MCT=MCT+1,^TMP("PSSDMR",$J,MCT)=$P(MRNODE,U),^TMP("PSSDMR",$J,"B",XX)=""
 ;IHS/MSC/PLS - 2/16/2018 - P1023 - P1032
 D DFRL
 Q
 ;IHS/MSC/MGH added from patch 166 for EPCS
DFRL W !!," List of med routes associated with the DOSAGE FORM of the orderable item:",!
 S MCT=0 I '$O(^TMP("PSSDMR",$J,MCT)) W !,?3,"NO MED ROUTE DEFINED"
 F  S MCT=$O(^TMP("PSSDMR",$J,MCT)) Q:'MCT  W !,?3,$G(^(MCT))
 D EN^DDIOL(" If you answer YES to the next prompt, the DEFAULT MED ROUTE (if populated)",,"!!")
 D EN^DDIOL(" and this list (if populated) will be displayed as selectable med routes",,"!")
 D EN^DDIOL(" during medication ordering dialog. If you answer NO, the DEFAULT MED ROUTE",,"!")
 D EN^DDIOL(" (if populated) and POSSIBLE MED ROUTES list will be displayed instead.",,"!") W !
 ;K ^TMP("PSSMR",$J)
 Q
 ;IHS/MSC/MGH added from patch 166 for EPCS
PDR ; possible med routes - called by DR string at DIR+20^PSSPOIMO
 N MCT,MR,MRNODE,XX K ^TMP("PSSMR",$J)
 S (XX,MCT)=0 F  S XX=$O(^PS(50.7,$S($G(PSVAR):PSVAR,1:PSOIEN),3,"B",XX)) Q:'XX  S MRNODE=$G(^PS(51.2,XX,0)),MCT=MCT+1,^TMP("PSSMR",$J,MCT)=$P(MRNODE,U)
 I $O(^TMP("PSSMR",$J,0)) D
 .W !!," List of Possible Med Routes associated with the orderable item:",!
 .S MCT=0 F  S MCT=$O(^TMP("PSSMR",$J,MCT)) Q:'MCT  W !,?3,$G(^(MCT))
 W ! K ^TMP("PSSMR",$J)
 Q
 ;IHS/MSC/MGH added from patch 166 for EPCS
PDCHK ; called by DR string at DIR+20^PSSPOIMO
 N ANS,D,DIC,DIE,DO,DICR,DR,DIR,PSOUT,PSSDA,PSSX,PSSXA,PSSY,Q,X,Y,Z
 S DIR(0)="PO^51.2:EMZ",DIR("A")="POSSIBLE MED ROUTES",DIR("S")="I $P(^(0),U,4)" S PSOUT=0
 S DIR("PRE")="I X=""?"" D MRTHLP^PSSPOIMO"
 F  D PDR,^DIR D  I PSOUT Q
 .I (X="")!$D(DTOUT)!$D(DUOUT) S PSOUT=1 Q
 .I X="@",$D(PSSY) S ANS=DA D:$$DASK^PSSPOIMO  Q
 ..N DIK,DA S DA(1)=ANS,DIK="^PS(50.7,"_DA(1)_",3,"
 ..S DA=$O(^PS(50.7,DA(1),3,"B",PSSY,"")) I DA="" Q
 ..D ^DIK K PSSY,DIR("B")
 .I Y="" W "  ??" Q
 .I $D(^PS(50.7,DA,3,"B",+Y)) D  Q
 ..I $D(DIR("B")) K PSSY,DIR("B") Q
 ..S DIR("B")=Y(0,0),PSSY=+Y Q
 .S PSSXA=Y(0,0),PSSX=+Y D DFR(+$P(^PS(50.7,DA,0),"^",2))
 .I $G(PSSX) S ANS=$$ASK^PSSPOIMO() I 'ANS Q
 .S PSSDA(50.711,"+1,"_DA_",",.01)=+PSSX
 .D UPDATE^DIE("","PSSDA")
 .K ^TMP("PSSMR",$J)
 D DP
 Q
 ;IHS/MSC/MGH added from patch 166 for EPCS
MRTHLP ; help of possible med route
 N DIC,RTE,D
 S RTE=0 F  S RTE=$O(^PS(50.7,DA,3,"B",RTE)) Q:'RTE   D EN^DDIOL($P($G(^PS(51.2,RTE,0)),"^"),,"!,?4")
 W ! D EN^DDIOL("Enter the most common MED ROUTE associated with this Orderable Item.",,"!,?5")
 D EN^DDIOL("ONLY MED ROUTES MARKED FOR USE BY ALL PACKAGES ARE SELECTABLE.",,"!,?5")
 Q
 ;IHS/MSC/MGH added from patch 166 for EPCS
DP ; check the existence of Default Med Route & Possible Med Routes
 N D,DIC,DIE,DO,DICR,DR,DIR,Q,X,Y,Z
 I '$P($G(^PS(50.7,$S($G(PSVAR):PSVAR,1:PSOIEN),0)),"^",6)&('$O(^PS(50.7,$S($G(PSVAR):PSVAR,1:PSOIEN),3,0))) D
 .S PSR(1)=" You have not selected ANY med routes to display during order entry. In"
 .S PSR(2)=" order to have med routes displayed during order entry, you must either"
 .S PSR(3)=" define a DEFAULT MED ROUTE and/or at least one POSSIBLE MED ROUTE, or"
 .S PSR(4)=" answer YES to the USE DOSAGE FORM MED ROUTE LIST prompt."
 .S PSR(5)=" **WITH THE CURRENT SETTINGS, NO MED ROUTES WILL DISPLAY FOR SELECTION ",PSR(5,"F")="!!"
 .S PSR(6)=" DURING ORDER ENTRY FOR THIS ORDERABLE ITEM**"
 .D EN^DDIOL(.PSR),EN^DDIOL(" ","","!")
 .K DIR S DIR(0)="Y",DIR("?",1)="If you select NO, you will continue to loop back to the Default Med Route"
 .S DIR("?")="prompt until either a selection is made or you answer YES to this prompt to proceed."
 .S DIR("A",1)="",DIR("A",2)="The current setting is usually only appropriate for supply items."
 .S DIR("A")="Continue with NO med route displaying for selection during order entry",DIR("B")="NO"
 .D ^DIR K DIR W ! I 'Y!($D(DTOUT))!($D(DUOUT)) S PSSFG=1
 .S:Y PSSFG=0
 E  S PSSFG=0
 Q
 ;IHS/MSC/MGH added from patch 166 for EPCS
SETF ;
 S PSSOU=0 K ^TMP("PSJMR",$J) D MEDRT^PSSJORDF($S($G(PSVAR):PSVAR,1:PSOIEN))
 I '$D(^TMP("PSJMR",$J)) S DIE("NO^")="",PSSFG=1
 E  S PSSFG=0 K DIE("NO^")
 Q
 ;IHS/MSC/MGH added from patch 166 for EPCS
MRSEL ;
 K ^TMP("PSJMR",$J) D MEDRT^PSSJORDF($S($G(PSVAR):PSVAR,1:PSOIEN))
 W !,"The following Med Routes will now be displayed during order entry:"
 N I S (PSSOU,I)=0 F  S I=$O(^TMP("PSJMR",$J,I)) Q:'I   W !,$P(^(I),"^",2) S PSSOU=1
 W:'PSSOU !,"(None)"
 W ! S PSSOU=1
 Q
 ;
