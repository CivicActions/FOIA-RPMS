PSODSPL ;IHS/DSD/JCM - DISPLAY RX PROFILE TO SCREEN  [ 02/20/2001  1:57 PM ]
 ;;6.0;OUTPATIENT PHARMACY;**1,3**;09/03/97
 ;;6.0;OUTPATIENT PHARMACY;**128**;09/03/97
 ; Input Variables: PSOSD(,
 ; Optional Inupt Variables: PSOOPT
 ;
 ; display profiles needs PSOOPT=3 from new PSOOPT=4 from refill, 
 ; or PSOOPT=0 from anywhere
 ; PSOOPT=-1 to get numbered list but no refill/renew message
 ;---------------------------------------------------------------
START ;
 ;I $D(PSOSD)'>1 W !,"This patient has no prescriptions",! G END
 D EOJ
 D HD
 D SHOW
END D EOJ
 Q
 ;-----------------------------------------------------------------
SHOW ;
 S PSODRUG="",PSOQFLG=0
 F PSOCNT=1:1 S PSODRUG=$O(PSOSD(PSODRUG)) Q:PSODRUG=""  Q:PSOCNT>1000!PSOQFLG  S PSODATA=PSOSD(PSODRUG) S:'$D(^PSRX(+PSODATA,0)) PSOCNT=PSOCNT-1 D:$D(^(0)) DISPL
 I PSOQFLG G SHOWX
 S X="APSQSHOW" X ^%ZOSF("TEST") I $T S EN="SHOW" D ^APSQSHOW ;IHS/OKCAO/POC FOR OUTSIDE RXS DISPLAYED 3/30/98
 I $D(PSOOPT),(PSOOPT>2) W !,?10,"* indicates prescription is not ",$P("^^renewable^refillable","^",PSOOPT)
 W !,?10,"(R) indicates last fill returned to stock"
 ;W !,?10,"(%) indicates this is a free text drug name not in drug file"
 S X="APSQSHOW" X ^%ZOSF("TEST") I $T W !,?10,"(%) indicates this is a free text drug name not in drug file" ;IHS/OKCAO/POC 12/3/2000
 K DIR S DIR(0)="EA",DIR("A")="Press RETURN to continue: " D ^DIR S:'$D(DFN) DFN=PSODFN D GMRA^PSODEM
SHOWX W ! K DIRUT,DTOUT,DUOUT,DIROUT
 S PSOCNT=PSOCNT-1
 K PSODRUG
 Q
 ;
HD ;
 I $Y+5>IOSL S (DX,DY)=0 X ^%ZOSF("XY") K DX,DY
 W !!!," #    RX #    DRUG",?44,"STAT QTY ISS-DT LST-FL REF-RM DAYS",!
 Q
 ;
DISPL W ! I $D(PSOOPT),PSOOPT W $J(PSOCNT,2)
 W ?6,$P(^PSRX(+PSODATA,0),"^")
 I $G(^PSRX(+PSODATA,"IB")) W ?11,"$"
 W ?13," ",$E($P(PSODRUG,"^",1),1,30)
 W ?45,$E("ANRHPSR   DECD",$P(PSODATA,"^",2)+1)
 I $D(PSOOPT),PSOOPT>2 W $S($L($P(PSODATA,"^",PSOOPT)):"*",1:"")
 W ?49,$J($P(^PSRX(+PSODATA,0),"^",7),3) S PSOID=$P(^(0),"^",13),PSOLF=+^(3)
 S APSPZDT(PSOLF,PSOCNT)=+PSODATA ;IHS/DSD/ENM 4.28.95 USED BY SUM L
 F PSOX=0:0 S PSOX=$O(^PSRX(+PSODATA,1,PSOX)) Q:'PSOX  I +^PSRX(+PSODATA,1,PSOX,0)=PSOLF,$P(^PSRX(+PSODATA,1,PSOX,0),"^",16) S PSOLF=PSOLF_"^(R)"
 K PSOX
 I '$O(^PSRX(+PSODATA,1,0)),$P(^PSRX(+PSODATA,2),"^",15) S PSOLF=PSOLF_"^(R)"
 W ?53,$E(PSOID,4,5),"-",$E(PSOID,6,7),?60,$E(PSOLF,4,5),"-",$E(PSOLF,6,7),$P(PSOLF,"^",2),?68,$J($P(PSODATA,"^",6),2),?74,$J($P(PSODATA,"^",8),3)
 K PSODATA,PSOID,PSOLF
 ;
 I $Y+5>IOSL K DIR S DIR(0)="E" D ^DIR K DIR S:$D(DUOUT) PSOQFLG=1 K DIRUT,DTOUT,DUOUT,DIROUT D:'PSOQFLG HD
 ;
 Q
 ;
EOJ ;
 K PSODRUG,PSODATA,PSOID,PSOLF,PSOCNT
 Q
