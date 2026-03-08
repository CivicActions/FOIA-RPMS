RAWKL1 ; IHS/ISD/PDW -Radiology Workload Reports 11:58 ;  [ 03/30/98  10:56 PM ]
 ;;4.0;RADIOLOGY;**2**;MAR 22, 1998
 ;Mod to pause at end of screen & allow ^ out **2** IHS/ISD/EDE 03/22/98
 NEW RAZQ S RAZQ=0 ; Added for **2** IHS/ISD/EDE 03/22/98
 S PAGE=0 I $O(^TMP($J,"RA",0))'>0 W @IOF,!!?5,"No exams registered for time period " S Y=BEGDATE D D^RAUTL W Y," to " S Y=ENDDATE D D^RAUTL W Y,".",! G Q
 ;Mod following line to quit if RAZQ for **2** IHS/ISD/EDE 03/22/98
 F RADIV=0:0 Q:RAZQ  S RADIV=$O(^TMP($J,"RA",RADIV)) Q:RADIV'>0  S RAZ=^(RADIV),RAY=$S($D(^DIC(4,RADIV,0)):$P(^(0),"^"),1:"UNKNOWN") D:$D(RAFL1) RAFLD Q:RAZQ  S RASUM="",Z=RAZ,ZZ=")",ZZZ="RAFLD" D HD,PRT D:'RAZQ TOT K RASUM
Q K ^TMP($J,"RA"),A,BEGDATE,C,ENDDATE,I,IN,J,OUT,PAGE,POP,RABEG,RACNI,RAD0,RADFN,RADIV,RADTE,RADTI,RAEND,RAFILE,RAFL,RAFL1,RAFL3,RAFLD,RAI,RAIN,RAMIS,RAMUL,RAOR,RAOUT,RAP0,RAPCE,RAPORT,RAPRC,RAPRI,RAQI,RASUM,RATITLE,RATOT
 ;Added next line to pause before exit **2** IHS/ISD/EDE 03/22/98
 D:'RAZQ PAUSE ; **2** IHS/ISD/EDE 03/22/98
 K RACRT,RASTAT,RANUM,RAWT,RAWWU,RAY,RAZ,RACPT,RAPIFN,RASV,RATCI,TOT,WWU,X,Y,Z,ZZ,ZZZ W ! D CLOSE^RAUTL Q
 ;
 ;Mod following line to quit if RAZQ for **2** IHS/ISD/EDE 03/22/98
RAFLD S RAFLD="" F J=0:0 Q:RAZQ  S RAFLD=$O(^TMP($J,"RA",RADIV,"FLD",RAFLD)) Q:RAFLD=""  S Z=^(RAFLD) D HD,RAMIS
 Q
 ;
 ;Mod following line to quit if RAZQ for **2** IHS/ISD/EDE 03/22/98
RAMIS F RAMIS=0:0 Q:RAZQ  S RAMIS=$O(^TMP($J,"RA",RADIV,"FLD",RAFLD,"A",RAMIS)) D:RAMIS'>0 TOT Q:RAMIS'>0  S ZZ=",""A"",RAMIS,""P"",RAPRC)",ZZZ="RAPRC" D:RAMIS<25!(RAMIS=99) PRT
 Q
 ;
PRT S IN=$P(Z,"^"),OUT=$P(Z,"^",2),TOT=IN+OUT,WWU=$P(Z,"^",3)
 ;Mod following line to quit if RAZQ for **2** IHS/ISD/EDE 03/22/98
 S @ZZZ="" F I=0:0 Q:RAZQ  S @ZZZ=$O(@("^TMP($J,""RA"",RADIV,""FLD"",RAFLD"_ZZ)) Q:@ZZZ=""  S Y=^(@ZZZ),RAIN=$P(Y,"^"),RAOUT=$P(Y,"^",2),RAWWU=$P(Y,"^",3),RATOT=RAIN+RAOUT D PRT1
 Q
 ;
TOT W !!?2,$S($D(RASUM):"Division",1:RATITLE)," Total",?40,$J(IN,5),?47,$J(OUT,5),?54,$J(TOT,5) W:$D(RAFL) ?68,$J(WWU,5)
 I '$D(RASUM) W ! F I=1:1:79 W "-"
 I $D(RASUM),'RAPCE W !!!?2,"NOTE: Since a procedure can be performed by more than one technologist,",!?8,"the total number of exams and weighted work units by division is",!?8,"likely to be higher than the other workload reports."
 Q
 ;W !,?5,"*** Portables and Operating Room Exams ***"
 ;F RAMIS=25,26 I $D(^TMP($J,"RA",RADIV,"FLD",RAFLD,"A",RAMIS)) S ZZ=",""A"",RAMIS,""P"",RAPRC)",ZZZ="RAPRC" D PRT S RAFL3=""
 ;W:'$D(RAFL3) !?10,"None" K RAFL3 S RAMIS=-1 Q
 ;
 ;Mod following line to quit if RAZQ for **2** IHS/ISD/EDE 03/22/98
PRT1 D HD:($Y+4)>IOSL Q:RAZQ  W !,@ZZZ,?40,$J(RAIN,5),?47,$J(RAOUT,5),?54,$J(RATOT,5),?61,$J($S(TOT:(100*RATOT)/TOT,1:0),5,1) W:$D(RAFL) ?68,$J(RAWWU,5),?75,$J($S(WWU:(RAWWU*100)/WWU,1:0),5,1)
 Q
 ;
 ;Mod HD line to pause at end of screen for **2** IHS/ISD/EDE 03/22/98
 ;Mod HD line to quit if RAZQ for **2** IHS/ISD/EDE 03/22/98
HD D:PAGE PAUSE Q:RAZQ  W @IOF,!?5,">>>>> Diagnostic Radiology ",RATITLE," Workload Report <<<<<" S PAGE=PAGE+1 W ?70,"Page: ",PAGE
 W !!?1,"Division: ",RAY,?52,"For period: " S Y=BEGDATE D D^RAUTL W ?64,Y,?76,"to"
 S X="NOW",%DT="T" D ^%DT K %DT D D^RAUTL W !?1,"Run Date: ",Y S Y=ENDDATE D D^RAUTL W ?64,Y
 W !!?45,"Examinations",?61,"Percent" W:$D(RAFL) ?73,"Percent"
 W !?2,$S('$D(RASUM):"Procedure (CPT)",1:RATITLE),?40,"   In",?47,"  Out",?54,"Total",?61," Exams" W:$D(RAFL) ?67,"  WWU",?73,"  WWU"
 W ! F I=1:1:80 W "-"
 W:$D(RASUM) !?10,"(Division Summary)" W:'$D(RASUM) !?10,RATITLE,": ",RAFLD
 Q
 ;Added following 7 lines for **2** IHS/ISD/EDE 03/22/98
PAUSE ; EP - PAUSE FOR USER
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 S DIR(0)="E",DIR("A")="Press any key to continue" D ^DIR K DIR
 W !
 I $D(DIRUT) K DIRUT S RAZQ=1
 Q
