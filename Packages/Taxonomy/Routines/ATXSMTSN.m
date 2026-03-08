ATXSMTSN ; IHS/CMI/LAB - DISPLAY IND LISTS ; 22 Feb 2023  12:45 PM
 ;;5.1;TAXONOMY;**61**;FEB 04, 1997;Build 133
 ;; ;
EP ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 D EN^XBVK("ATX")
 K ^TMP($J)
 Q
 ;; ;
EN ;EP -- main entry point for 
 D EN^VALM("ATXSM SNOMED VIEW")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
PAUSE ;EP
 Q:$E(IOST)'="C"!(IO'=IO(0))
 W ! S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
HDR ; -- header code
 S VALMHDR(1)="* List a SNOMED subset"
 Q
 ;
INIT ;EP -- init variables and list array
 K ^TMP($J)
 K ATXSMTAX,ATXSMLST
 S ATXHIGH="",C=0
 S X=$$SUBSET^BSTSAPI("^TMP("_$J_","_"""ATXSMLST"""_")")
 S ATXSMN=0,J=0 F  S ATXSMN=$O(^TMP($J,"ATXSMLST",ATXSMN)) Q:ATXSMN=""  D
 .S ATXSMX=^TMP($J,"ATXSMLST",ATXSMN)
 .S ^TMP($J,"ATXSMTAX",ATXSMN,0)=ATXSMN_")  "_ATXSMX
 .S ^TMP($J,"ATXSMTAX","IDX",ATXSMN,ATXSMN)=ATXSMN_U_ATXSMX
 .S C=C+1
 .Q
 S (VALMCNT,ATXHIGH)=C
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
 ;
BACK ;go back to listman
 D TERM^VALM0
 S VALMBCK="R"
 D INIT
 D HDR
 K DIR
 K X,Y,Z,I
 Q
 ;
DISP ;EP - add an item to the selected list - called from a protocol
 W !
 S DIR(0)="NO^1:"_ATXHIGH,DIR("A")="Which SNOMED Subset"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No list selected." G DISPX
 I $D(DIRUT) W !,"No list selected." G DISPX
 S ATXSMTAI=$P(^TMP($J,"ATXSMTAX","IDX",Y,Y),U,1),ATXTAXN=$P(^TMP($J,"ATXSMTAX","IDX",Y,Y),U,2)
 ;BROWSE OR PRINT
 D FULL^VALM1
 W ! S DIR(0)="S^P:PRINT SNOMED Subset Output;B:BROWSE SNOMED Subset Output on Screen",DIR("A")="Do you wish to",DIR("B")="B" K DA D ^DIR K DIR
 I $D(DIRUT) D XIT Q
 S ATXSMOPT=Y
 I Y="B" D BROWSE,XIT Q
ZIS ;call to XBDBQUE
 K IOP,%ZIS W !! S %ZIS="PM" D ^%ZIS
 I POP W !,"Report Aborted"
 U IO
 D PRINT
 D ^%ZISC
 X ^%ZIS("C")
 D HOME^%ZIS
 U IO
 D DISPX
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^ATXSMTSN"")"
 S XBRC="",XBRX="XIT^ATXSMTSN",XBIOP=0 D ^XBDBQUE
 Q
PHDR ;
 I 'ATXSMPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S ATXSMQ=1 Q
HEAD1 ;
 W:$D(IOF) @IOF S ATXSMPG=ATXSMPG+1
 W !,$P(^VA(200,DUZ,0),U,2),?72,"Page ",ATXSMPG,!
 W ?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),!
 W $$CTR("Listing of the "_ATXTAXN_" SNOMED Subset",80),!,ATXSM80D,!
 Q
PRINT ;
 S ATXSMPG=0
 S ATXSMQ=""
 S ATXSM80D="-------------------------------------------------------------------------------"
 D PHDR
P1 ;
 K ATXSMLST
 S X=$$SUBLST^BSTSAPI("ATXSMLST",ATXTAXN)
 S Y=0 F  S Y=$O(ATXSMLST(Y)) Q:Y=""!(ATXSMQ)  D
 .I $Y>(IOSL-3) D PHDR Q:ATXSMQ
 .S ATXSMX=$P(ATXSMLST(Y),U,1)
 .I $T(CONC^BSTSAPI)="" Q
 .NEW D,B,E,V,A,B
 .W ATXSMX,?25,$P($$CONC^BSTSAPI(ATXSMX_"^^^1"),U,4),!
 D XIT
 Q
DISPX ;
 D BACK
 Q
XIT ;
 K ^TMP($J,"ATXSMTDSP")
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
