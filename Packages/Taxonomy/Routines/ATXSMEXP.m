ATXSMEXP ; IHS/CMI/LAB - DISPLAY IND LISTS ; 22 Feb 2023  12:45 PM
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
 D EN^VALM("ATXSMEX SNOMED EXPORT")
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
 S VALMHDR(1)="* Export a SNOMED subset to an Excel CSV file"
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
EXPORT ;EP - add an item to the selected list - called from a protocol
 W !
 S DIR(0)="NO^1:"_ATXHIGH,DIR("A")="Which SNOMED Subset would you like to export"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No subset selected." G EXX
 I $D(DIRUT) W !,"No subset selected." G EXX
 S ATXSMTAI=$P(^TMP($J,"ATXSMTAX","IDX",Y,Y),U,1),ATXTAXN=$P(^TMP($J,"ATXSMTAX","IDX",Y,Y),U,2)
 ;GET DIRECTORY
 S ATXEDIR=$$GETEDIR()
 D FULL^VALM1
 I ATXEDIR="" W !!,"I can't find the export directory.  Notify IT." G EXX
 S ATXFILE=ATXTAXN_"_"_$$D(DT)_".csv"
 W !!,"A file called ",ATXFILE," will be created.",!,"It will reside in the ",ATXEDIR," directory.",!
 K DIR
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G EXX
 I 'Y G EXX
 ;write out subset
 K ATXSML
 S X=$$SUBLST^BSTSAPI("ATXSML",ATXTAXN)
 S Y=$$OPEN^%ZISH(ATXEDIR,ATXFILE,"W")
 I Y=1 W !!,"Cannot open host file to write out DELIMITED data.  Notify IT." D CONT G EXX
 U IO
 W "SNOMED CODE,PREFERRED TERM",!
 S Y=0 F  S Y=$O(ATXSML(Y)) Q:Y=""  D
 .W $$Q($P(ATXSML(Y),U,1)),",",$$Q($P(ATXSML(Y),U,3)),!
 D ^%ZISC
 X ^%ZIS("C")
 D HOME^%ZIS
 U IO
 W !!,"File ",ATXFILE," has been created.",!,"It can be found in the ",ATXEDIR," directory.",!
 D CONT
 D EXX
 Q
 ;
Q(%) ;
 I $G(%)="" Q ""
 Q """"_%_""""
 ;
CONT ;
 K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
 Q
EXX ;
 D BACK
 Q
D(D) ;
 Q $E(D,4,5)_$E(D,6,7)_$E(D,2,3)
XIT ;
 K ^TMP($J,"ATXSMTDSP")
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
GETEDIR() ;EP - get default directory
 NEW D
 S D=""
 S D=$P($G(^AUTTSITE(1,1)),"^",2)
 I D]"" Q D
 S D=$P($G(^XTV(8989.3,1,"DEV")),"^",1)
 I D]"" Q D
 I $P(^AUTTSITE(1,0),U,21)=1 S D="/usr/spool/uucppublic/"
 Q D
