RAEDCN ; IHS/ADC/PDW -Edit Exams by Case Number 17:13 ;  [ 12/04/2001  2:40 PM ]
 ;;4.0;RADIOLOGY;**4,11**;NOV 20, 1997
START ;
 D SET^RAPSET1 I $D(XQUIT) K XQUIT Q
START1 ;
 D ^RACNLU G Q:X=U I $D(^RA(72,"C",9,+RAST)),'$D(^XUSEC("RA MGR",DUZ)) W !!?3,*7,"You do not have the appropriate access privileges to edit completed exams." G START1
 I $D(^RA(72,"C",0,+RAST)) W !!?3,*7,"Exam has been 'cancelled' therefore it cannot be edited." G START1
 I RADR="[RA DIAGNOSTIC BY CASE]",$D(^RARPT(RARPT,0)),$P(^(0),U,5)="V" W !!?3,*7,"A report has been verified for this exam, therefore it cannot be edited.",! G START
 W !                                              ;IHS/ANMC/MWR 06/03/92
 ;
 ;The following code determines the current status and the default
 ;next status so that site required fields can be determined for
 ;use in the input template RA EXAM EDIT
 ;IHS/HQW/SCR -12/4/01 **11**
 ;
 I RADR="[RA EXAM EDIT]" D       ;IHS/HQW/SCR 12/4/01 **11**
 .S RASTAT=$P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),U,3)  ;IHS/HQW/SCR 12/4/01 **11**
 .S RANXSTAT=$P(^RA(72,RASTAT,0),U,2)  ;IHS/HQW/SCR 12/4/01 **11**
 .F RAI2=1:1:6 S @$P("RAREQTEC^RAREQRAD^RAREQDTL^RAREQFLM^RAREQDGN^RAREQRM",U,RAI2)=$P(^RA(72,RANXSTAT,.1),U,RAI2)   ;IHS/HQW/SCR 12/4/01 **11**
 .Q    ;IHS/HQW/SCR 12/4/01 **11**
 ;
 ;S DA=RADFN,DIE("NO^")="OUTOK",DIE="^RADPT(",DR=RADR D ^DIE K DIE("NO^"),DE,DQ,DIE,DR D UP1^RAUTL1 K RADUZ,RAZZ W ! G START1
 ;
 ;Above line commented out to include lock before ^DIE
 ; IHS/HQW/SCR 12/4/01 **11**
 ;
 S DA=RADFN,DIE("NO^")="OUTOK",DIE="^RADPT(",DR=RADR      ;IHS/HQW/SCR 12/4/01 **11**
 L +^RADPT(RADFN):0 I '$T W !,"Another user is editing this record." G START1      ;IHS/HQW/SCR -12/04/01 **11**
 D ^DIE L -^RADPT(RADFN)     ;IHS/HQW/SCR - 12/04/01 **11**
 K DIE("NO^"),DE,DQ,DIE,DR D UP1^RAUTL1 K RADUZ,RAZZ W ! G START1   ;IHS/HQW/SCR - 12/04/01 **11**
Q ;
 K %,%DT,%X,%Y,A,C,D0,D1,D2,DA,DIC,DIE,DIV,DK,POP,RADIV,RAFIN,RAHEAD,RAOR,RAPOP,RASN,RASSN,RASTI,RADATE,RAST,RACT,RACN,RACNI,RADFN,RADR,RADTE,RADTI,RAPRI,XQUIT,VAINDT,VADMVT,X,Y
 K RALOCFLG                                       ;IHS/ANMC/MWR 06/03/92
 ;K RAEXFM,RAEXLBLS,RAFL,RAFLH,RAFLHFL,RAMES,RANME,RANUM,RAOIFN,RAOREA,RAOSEL,RAOSTS,RAPRC,RAQUICK,RACS,RAPRIT,RARPTZ,RARPT,RAVW,^TMP($J,"RAEX") Q
 ;
 ;Above line commented out to include variables that indicate site
 ;required fields so input template requires those fields
 ;IHS/HQW/SCR -- 12/04/01  **11**
 ;
 K RAEXFM,RAEXLBLS,RAFL,RAFLH,RAFLHFL,RAMES,RANME,RANUM,RAOIFN,RAOREA,RAOSEL,RAOSTS,RAPRC,RAQUICK,RACS,RAPRIT,RARPTZ,RARPT,RAVW,^TMP($J,"RAEX"),RAREQTEC,RAREQRAD,RAREQDTL,RAREQFLM,RAREQDGN,RAREQRM,RAI2 Q
 ;
DIAG ;
 S RADR="[RA DIAGNOSTIC BY CASE]" G START
 ;
SAVE ;
 S RADR="[RA NO PURGE SPECIFICATION]" G START
 ;
EDIT ;
 ;S RAQUICK=1,RADR="[RA EXAM EDIT]" G START       ;IHS/ANMC/MWR 06/03/92
 S RAQUICK=1,RADR="[RA EXAM EDIT]"               ;IHS/ANMC/MWR 06/03/92
 I $D(^RA(79,+RAMDIV,.1)),$P(^(.1),U,21)="y" S RALOCFLG=""   ;IHS/ANMC/MWR 06/03/92
 G START                                          ;IHS/ANMC/MWR 06/03/92
 ;
CANCEL ;
 D SET^RAPSET1 I $D(XQUIT) K XQUIT Q
 D ^RACNLU G Q:X=U I $D(^RA(72,"C",0,+RAST)) W !?3,*7,"This exam has already been cancelled!" G Q
 I $D(^RA(72,+RAST,0)),$P(^(0),U,6)'="y" W !?3,*7,"This exam is in the '",$P(^(0),U),"' status and cannot be 'CANCELLED'." G Q
 I RARPT W !?3,*7,"A report has been filed for this case. Therefore cancellation is not allowed!" G Q
ASKCAN ;
 R !!,"Do you wish to cancel this exam? NO// ",X:DTIME S:'$T!(X="")!(X[U) X="N" G Q:"Nn"[$E(X) I "Yy"'[$E(X) W:X'["?" *7 W !!?3,"Enter 'YES' to canel this exam, or 'NO' not to." G ASKCAN
 S DA=RADFN,DR="[RA CANCEL]",DIE="^RADPT(" D ^DIE K DE,DQ,DIE,DR
 I '$D(Y),$D(RAFIN) W !?10,"...cancellation complete." D ^RAORDC
 G Q
 ;
DEL ;
 D ^RACNLU G Q:X=U I RARPT W !?3,*7,"A report has been filed for this case. Therefore deletion is not allowed!" G DEL
ASKDEL ;
 R !!,"Do you wish to delete this exam? NO// ",X:DTIME S:'$T!(X="")!(X[U) X="N" G DEL:"Nn"[$E(X) I "Yy"'[$E(X) W:X'["?" *7 W !!,"Enter 'YES' to delete this exam, or 'NO' not to." G ASKDEL
 I +$G(^RA(79,RAMDIV,9999999)) D
 .D DELETE^RAZPCC,DELETE^RAZWH(RADFN,RADTI,RACNI) ;IHS/HQW/JDH may have gone to PCC at EXAMINED
 S RADELFLG="" D ^RAORDC S RABULL="",DA(2)=RADFN,DA(1)=RADTI,DA=RACNI,DIK="^RADPT(DA(2),""DT"",DA(1),""P""," D ^DIK W !?10,"...deletion of exam complete."
 K %,D,D0,D1,D2,DA,DIC,DIK,RADELFLG,RABULL,RAPRTZ G DEL
 ;
VIEW ;
 S RAVW="" D ^RACNLU G Q:X=U K RAFL D ^RAPROD D Q G VIEW
 ;
DUPEXAM ;EP - CALLED FROM OPTION                           IHS/ISD/EDE 02/13/97
DUP ;
 D SET^RAPSET1 I $D(XQUIT) K XQUIT Q
DUP1 ;
 D ^RACNLU G Q:X=U S ION=$P(RAMLC,U,3) I ION="" S %ZIS="NQ",IOP="Q" W ! D ^%ZIS K IOP G DUP1:POP
 G Q:'$D(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0)) S Y=^(0),Y=$S($D(^RAMIS(71,+$P(Y,U,2),0)):$P(^(0),U,3),1:"") I Y]"",$D(^%ZIS(1,+$O(^%ZIS(1,"B",Y,0)),0)),Y'=$P(RAMLC,U,3) S ION=Y
 S RAMES="W !!,""Duplicates queued to print on "",ION,"".""",RAFLH=$S($P(RAMLC,U,7):$P(RAMLC,U,7),1:1),RAEXFM=$S($P(RAMLC,U,9):$P(RAMLC,U,9),1:1),RAFLHFL=RACNI
FLH ;
 R !,"How many flash cards? 1// ",X:DTIME G DUP1:'$T!(X[U) S:X="" X=1 S RANUM=X I '(RANUM?.N)!(RANUM>20) W !?3,*7,"Must be a whole number less than 21!" G FLH
 ;
 ;
EXM ;
 ;R !,"How many exam labels? 1// ",X:DTIME G DUP1:'$T!(X[U) S:X="" X=1 S RAEXLBLS=X I '(RAEXLBLS?.N)!(RAEXLBLS>20) W !?3,*7,"Must be a whole number less than 21!" G EXM  ;COMMENTED                            ;IHS/ANMC/MWR 06/03/92
 S RAEXLBLS=0  ;PRINT NO EXAM LABELS              ;IHS/ANMC/MWR 06/03/92
 ;---> RAD SITE PARAMS DO NOT ALLOW DEFINING OF AN "EXAM LABEL"  ;IHS/ANMC/MWR 06/03/92
 ;---> PRINTER.  THE ABOVE SENDS IT TO THE FLASHCARD PRINTER.  ;IHS/ANMC/MWR 06/03/92
 ;
 ;
 ;I $D(ION),ION]"" S IOP="Q;"_ION  ;CMT'D OUT     ;IHS/ANMC/MWR 06/03/92
 ;K RAFL D Q^RAFLH,CLOSE^RAUTL,Q,KILLVAR^RAUTL2 G DUP1    ;IHS/ANMC/MWR
 ;
 I '$D(ION) D  Q                                  ;IHS/ANMC/MWR 06/03/92
 .W !!,"FLASHCARD PRINTER NOT DEFINED!"           ;IHS/ANMC/MWR 06/03/92
 .W !,"NOTIFY YOUR SITE MANAGER.",!!              ;IHS/ANMC/MWR 06/03/92
 ;---> NEED TO KILL IOP SO DEVICE WILL BE PROMPTED.  ;IHS/ANMC/MWR 06/03/92
 S RAZPRT=ION K IOP                               ;IHS/ANMC/MWR 06/03/92
 ;
ZIS ;
 ;---> ALLOW PRINT NOW OR QUEUING                 ;IHS/ANMC/MWR 06/03/92
 S %ZIS("A")="Select DEVICE to print flashcards:" ;IHS/ANMC/MWR 06/03/92
 S %ZIS="Q",%ZIS("B")=RAZPRT                      ;IHS/ANMC/MWR 06/03/92
 D ^%ZIS I POP D  D Q G DUP1                      ;IHS/ANMC/MWR 06/03/92
 .W !,"*NO flashcards printed."                   ;IHS/ANMC/MWR 06/03/92
 ;---> NOT QUEUED, PRINT IMMEDIATELY              ;IHS/ANMC/MWR 06/03/92
 I '$D(IO("Q")) D  G DUP1                         ;IHS/ANMC/MWR 06/03/92
 .K RAFL U IO D ^RAFLH,^%ZISC,Q,KILLVAR^RAUTL2    ;IHS/ANMC/MWR 06/03/92
 ;
 ;---> QUEUED TO SCREEN OR SLAVE -- NO GO         ;IHS/ANMC/MWR 06/03/92
 I IO=IO(0) D  G ZIS                              ;IHS/ANMC/MWR 06/03/92
 .W !,"Cannot queue to screen or slave printer!"  ;IHS/ANMC/MWR 06/03/92
 .D ^%ZISC ;                                      IHS/ISD/EDE 12/29/96
 ;.K IO("Q"),IO("S")                              ;IHS/ANMC/MWR 06/03/92
 ;---> LEGITIMATELY QUEUED                        ;IHS/ANMC/MWR 06/03/92
 K RAFL D  G DUP1                                 ;IHS/ANMC/MWR 06/03/92
 .D Q^RAFLH,CLOSE^RAUTL,Q,KILLVAR^RAUTL2          ;IHS/ANMC/MWR 06/03/92
 Q                                                ;IHS/ANMC/MWR 06/03/92
