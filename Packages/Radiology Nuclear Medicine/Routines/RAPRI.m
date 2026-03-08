RAPRI ; IHS/ADC/PDW -DISPLAY COMMON PROCEDURES 17:33 ;    [ 01/17/2002  8:16 AM ]
 ;;4.0;RADIOLOGY;**11**;NOV 20, 1997
 ;
DISP ;EP
 ;Display list of common procedures - called from RAORD1
 I '$O(^RAMIS(71.3,"AA",0)) S RACNT=0 Q
 D HOME^%ZIS W @IOF
 W !?24,"COMMON RADIOLOGY PROCEDURES",!?23,"-----------------------------"
 S II=0 F I=1:1:40 S RAPRC(I)=""
 D TOTAL
 F I=1:1:RASEQ W:RAPRC(I)]"" !?1,I,") ",$P(RAPRC(I),U) I RAPRC(I+RASEQ)]"" W ?44,(I+RASEQ),") ",$P(RAPRC(I+RASEQ),U)
 K I,II,RASEQ
 Q
LOOKUP ;EP
 ;Lookup procedure - called from RAORD1
 ;
 ;Next two lines modified for VA patches IHS/HQW/SCR 9/18/01 **11**
 ;I X?1.2N,X'>RACNT S RAPRI=$P(RAPRC(X),U,2) G Q 
 ;N DIC,Y W ! S DIC(0)="EQM",DIC="^RAMIS(71,",DIC("S")="I $S('$D(^(""I"")):1,'^(""I""):1,DT'>^(""I""):1,1:0)" D ^DIC K DIC("S") S:X=""!(X=U) Y=-1 S RAPRI=+Y
 I X?1.2N,+X=X,X'>RACNT S Y=$P(RAPRC(X),U,2) G Q ;IHS/HQW/SCR 9/18/01 **11**
 N DIC,Y W ! S DIC(0)="EQM",DIC="^RAMIS(71,",DIC("S")="I $S('$D(^(""I"")):1,'^(""I""):1,DT'>^(""I""):1,1:0)" S:$P(RAMDV,U,7) DIC("S")=DIC("S")_",$P(^(0),""^"",6)'=""B""" D ^DIC K DIC("S") S:X=""!(X=U) Y=-1 ;IHS/HQW/SCR 9/18/01 **11**
Q ;
 S (RAPRI,X)=+Y I X>0 S RAS3=RADFN D ORDPRC1^RAUTL2 Q:RAPRI'>0  ;IHS/HQW/SCR 9/5/01 **11**
 ;---> ALWAYS DISPLAY PROCEDURE MESSAGE IF IT EXISTS.  ;IHS/ANMC/MWR 06/03/92
 I $D(^RAMIS(71,RAPRI,3,0)),$O(^(0)) D EN2        ;IHS/ANMC/MWR 06/03/92
 ;
 ;
 ;Q:RAPRI>0  W !!,*7,"Unable to process this request due to an invalid procedure.",! S DIR(0)="Y",DIR("A")="Continue processing remaining input" D ^DIR K DIR S:Y'=1 RAOUT=1 Q
 ;
 ;Above line modified for VA patches IHS/HQW/SCR - 9/5/01 **11**
 Q:RAPRI>0  S RAEASK=1 W !!,*7,"Unable to process this request due to an  invalid procedure.",! I $P(RARX,",",(RAJ+1))="" H 3 Q  ;IHS/HQW/SCR-9/5/01**11**
 S DIR(0)="Y",DIR("A")="Continue processing remaining input" D ^DIR K DIR S:Y'=1 RAOUT=1 Q  ;IHS/HQW/SCR - 9/5/01 **11**
HELP ;
 W !!?2,"To select a commonly ordered procedure, enter a number from the display above."
 W !!?2,"To select procedures other than those listed above, enter the procedure name,",!?2,"synonym, or CPT number.",!!?2,"You may enter a single procedure or multiple procedures separated by commas.",!
 S DIR(0)="E" D ^DIR K DIR Q
EN2 ;
 ;Radiology Procedure Message Display
 W !!,*7,"NOTE: The following special requirements apply to this procedure:",! F I=0:0 S I=$O(^RAMIS(71,RAPRI,3,I)) Q:I'>0  I $D(^(I,0)) S X=^(0) I $D(^RAMIS(71.4,+X,0)) W !,^(0)
 W ! Q
 ;
TOTAL ;
 N I,J,K,L
 S (I,K,L,RACNT)=0
 F  S I=$O(^RAMIS(71.3,"AA",I)) Q:I>40!('I)  S RACNT=I F  S K=$O(^(I,K)) Q:'K  I $D(^RAMIS(71.3,K,0)) S RAPRC(I)=$E($P($G(^RAMIS(71,+^(0),0)),U),1,32)_U_$P(^RAMIS(71.3,K,0),U)
 S RASEQ=$S(RACNT<40:(RACNT\2),1:20)
 I RACNT#2 S RASEQ=RASEQ+1
 Q
