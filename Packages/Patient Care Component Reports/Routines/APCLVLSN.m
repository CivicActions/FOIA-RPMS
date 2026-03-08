APCLVLSN ; IHS/CMI/LAB - DISPLAY IND LISTS ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**26**;MAY 14, 2009;Build 48
 ;; ;
EP ;EP - CALLED FROM OPTION
 ;GET AUDIT YEAR
 ;select year
 NEW APCLX,APCLHIGH,APCLVLSN
 D EN
 Q
EOJ ;EP
 Q
 ;; ;
EN ;EP -- main entry point for 
 D EN^VALM("APCLVL SNOMED VIEW")
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
 S VALMHDR(1)="SNOMED SUBSETS"
 Q
 ;
INIT ;EP -- init variables and list array
 K APCLVLSN,APCLX
 S APCLHIGH="",C=0,J=0
 S Y=$$SUBSET^BSTSAPI("APCLX")
 S X="" F  S X=$O(APCLX(X)) Q:X=""  D
 .S J=J+1
 .S APCLVLSN(J,0)=J_")  "_APCLX(X) I $D(APCLSNL(APCLX(X))) S APCLVLSN(J,0)="*"_APCLVLSN(J,0)
 .S APCLVLSN("IDX",J,J)=APCLX(X)
 .S C=C+1
 S (VALMCNT,APCLHIGH)=C
 K APCLX
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
REM ;
 W ! S DIR(0)="LO^1:"_APCLHIGH,DIR("A")="Which item(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G REMX
 I $D(DIRUT) W !,"No items selected." G REMX
 D FULL^VALM1 W:$D(IOF) @IOF
 S A=Y,C="" F I=1:1 S C=$P(A,",",I) Q:C=""  S J=APCLVLSN("IDX",C,C) K APCLSNL(J)
 ;S BGPGANS=Y,BGPGC="" F BGPGI=1:1 S BGPGC=$P(BGPGANS,",",BGPGI) Q:BGPGC=""  S I=$G(BGPGLIST("IDX",BGPGC,BGPGC)) K BGPLIST(I)
REMX ;
 D BACK
 Q
 ;
DISP ;EP - add an item to the selected list - called from a protocol
 NEW A,C,I,O
 W !
 S DIR(0)="L^1:"_APCLHIGH,DIR("A")="Which SNOMED List(s)" KILL DA D ^DIR KILL DIR
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No list selected." G DISPX
 I $D(DIRUT) W !,"no list selected." G DISPX
 S A=Y,C="" F I=1:1 S C=$P(A,",",I) Q:C=""  S APCLSNL(APCLVLSN("IDX",C,C))=""
 D DISPX
 Q
DISPX ;
 D BACK
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
