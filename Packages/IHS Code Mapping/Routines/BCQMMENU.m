BCQMMENU ; GDIT/IHS/FS - MAGIC MAPPER POST-INSTALL ;09/11/24 07:53;FS
 ;;1.0;IHS CODE MAPPING;**12,13**;OCT 01, 2025;Build 91
V ; GET VERSION
 S BCQM("VERSION")="1 (Patch 12)"
 I $G(BCQMTEXT)="" S BCQMTEXT="TEXT",BCQMLINE=3 G PRINT
 S BCQMTEXT="TEXT"_BCQMTEXT
 F BCQMJ=1:1 S BCQMX=$T(@BCQMTEXT+BCQMJ),BCQMX=$P(BCQMX,";;",2) Q:BCQMX="QUIT"!(BCQMX="")  S BCQMLINE=BCQMJ
PRINT W:$D(IOF) @IOF
 F BCQMJ=1:1:BCQMLINE S BCQMX=$T(@BCQMTEXT+BCQMJ),BCQMX=$P(BCQMX,";;",2) W !?80-$L(BCQMX)\2,BCQMX K BCQMX
 W !?80-(8+$L(BCQM("VERSION")))/2,"Version ",BCQM("VERSION")
SITE G XIT:'$D(DUZ(2)) G:'DUZ(2) XIT S BCQM("SITE")=$P(^DIC(4,DUZ(2),0),"^") W !!?80-$L(BCQM("SITE"))\2,BCQM("SITE")
XIT ;
 K DIC,DA,X,Y,%Y,%,BCQMJ,BCQMX,BCQMTEXT,BCQMLINE
 Q
TEXT ;
 ;;*********************************************************************
 ;;** BCQM: Associating Hospital Location with NHSN Location Codes  **
 ;;*********************************************************************
 Q
 ;
TEXTM ;
 ;;*************************************************************
 ;;** BCQM: Associating Hospital Location with NHSN Location Codes  **
 ;;*************************************************************
 Q
 ;
START ;EP - called from option
 W !!,"This option is used to map a Hospital Location (HL) to a NHSN Location Code."
 W !,"Each hospital location can be assigned an appropriate NHSN location code for"
 W !,"ECQM reporting purposes."
 W !!
CONT ;
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I 'Y G EOJ
 ;GET SITE PARAMETER ENTRY
 W !!
 W !!,"The next screen will present all HL and associated NHSN codes."
 K DIR
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I 'Y G EOJ
 ;populate locations
 D ADDLOCS
 D EN
EOJ ;
 K DIR,DIRUT,DA
 D EN^XBVK("BCQM")
 Q
 ;
ADDLOC ;
 K DIC,DR,DIADD,DLAYGO
 W !
 S DIC="^BCQM(9002025,",DIC("DR")=".01;1;",DIC(0)="QEALMS"
 ;S DIC("S")="I $P(^(I),U,1)<"_DT
 ;W !,DT
 D ^DIC
 K DIC,DR
 ;W !,Y H 5
 ;D EN
 ;D INIT
 D ADDX
 ;
ADDLOCS ;
 Q
 S X=0 F  S X=$O(^SC(X)) Q:X'=+X  D
 .;Q:$$VALI^XBDIQ1(9009016.5,X,.03)="I"
 .Q:$D(^BCQM(9002025,"B",X,1))  ;already there
 .S ^BCQM(9002025,X,0)=X
 .S ^BCQM(9002025,"B",X,1)=""
 .Q
 S (C,X)=0 F  S X=$O(^BCQM(9002025,X)) Q:X'=+X  S C=C+1,L=X
 S ^BCQM(9002025,0)="CQM NHSN HL MAPPING^9002025P^"_C_U_L
 Q
EN ;EP -- main entry point 
 S VALMCNT=0
 D EN^VALM("BCQM LOCATION UPDATE")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="  Location Name",$E(VALMHDR(1),35)="TYPE OF LOC.",$E(VALMHDR(1),48)="NHSN Code",$E(VALMHDR(1),58)="NHSN Description"
 Q
 ;
INIT ; -- init variables and list array
 K BCQMLOC S BCQMHIGH=""
 S (X,Y,Z,C)=0 F  S X=$O(^BCQM(9002025,X)) Q:X'=+X  D
 .S C=C+1,BCQMLOC(C,0)=C_")"
 .S $E(BCQMLOC(C,0),3)=$$VAL^XBDIQ1(9002025,X,.01)
 .S Y=$P(^BCQM(9002025,X,0),U,1)
 .W !,"----->",X,"<----"
 .I Y S $E(BCQMLOC(C,0),35)=$$VAL^XBDIQ1(44,Y,2.1),$E(BCQMLOC(C,0),48)=$$VAL^XBDIQ1(9002025,X,1)
 .I $G(^BCQM(9002025,X,0))'="",$P(^BCQM(9002025,X,0),U,2)'="" S $E(BCQMLOC(C,0),55)=$$VAL^XBDIQ1(9002024,$P(^BCQM(9002025,X,0),U,2),4)
 .S BCQMLOC(C,C)=X
 .Q
 S (VALMCNT,BCQMHIGH)=C
 Q
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
 D CLEAR^VALM1
 S VALMBCK="R"
 D INIT
 D HDR
 K DIR
 K X,Y,Z,I
 Q
 ;
ADD ;EP - add an item to the selected list - called from a protocol
 NEW BCQMX,BCQMY,BCQMIND
 K DIR,DIE,DR,DA
 W !
 S DIR(0)="LO^1:"_BCQMHIGH,DIR("A")="Which item(s)"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W !! ;W:$D(IOF) @IOF
 S BCQMANS=Y,BCQMC="" F BCQMI=1:1 S BCQMC=$P(BCQMANS,",",BCQMI) Q:BCQMC=""  S BCQMIND(BCQMLOC(BCQMC,BCQMC))=""
 D FULL^VALM1 W !
 S BCQMX=0 F  S BCQMX=$O(BCQMIND(BCQMX)) Q:BCQMX'=+BCQMX  D
 .;W !!,$$VAL^XBDIQ1(44,BCQMX,.01)
 .S DIE="^BCQM("_9002025_",",DR=".01;1",DA=BCQMX D ^DIE K DA,DR,DIE
 ;
ADDX ;
 W !
 K DIR
 S DIR(0)="E"
 S DIR("A")="Press <ENTER> to continue "
 D ^DIR
 K DIR
 D BACK
 Q
