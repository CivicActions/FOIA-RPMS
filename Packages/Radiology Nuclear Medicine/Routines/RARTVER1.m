RARTVER1 ; IHS/ADC/PDW -On-Line Verify List/Select Radiology Reports 11:43 ;    [ 07/25/2001  8:43 AM ]
 ;;4.0;RADIOLOGY;**8**;NOV 20, 1997
 ;
 ;
 ;===> BEGIN CHANGES TO PRINT HEADER CHART# INSTEAD OF SSN   ;IHS/ANMC/MWR 06/03/92
HDR ;
 ;K RAOUT,RARSEL S RACNT=0 W !!,"Choice",?8,"Case No.",?18,"Procedure",?40,"Ex Date",?50,"Name",?72,"PtID",!,"------",?8,"--------",?18,"---------",?40,"--------",?50,"-----------------",?72,"-------"  ;CMT'D OUT   ;IHS/ANMC/MWR 06/03/92
 ;
 ;---> START CHART# AT $X=71                      ;IHS/ANMC/MWR 06/03/92
 K RAOUT,RARSEL S RACNT=0
 W !!,"Choice",?8,"Case No.",?18,"Procedure",?40,"Ex Date",?50
 W "Name",?71,"Chart#",!,"------",?8,"--------",?18,"---------"
 W ?40,"--------",?50,"-----------------",?71,"--------"
 ;===> END CHANGES                                ;IHS/ANMC/MWR 06/03/92
 ;
RPTLP ;
 ;F RARTDT=0:0 S RARTDT=$O(RA("DT",RARTDT)) Q:'RARTDT!($D(RARSEL))  D GETRPT
 ;
 ;Above line commented out to change local array to global array to
 ;avoid partition overflow--IHS/HQW/SCR - 05/15/01
 ;
 F RARTDT=0:0 S RARTDT=$O(^TMP("RARTVER",$J,"DT",RARTDT)) Q:'RARTDT!($D(RARSEL))  D GETRPT
 ;
Q ;
 ;K I,RACN,RACNT,RADASH,RADUP,RA("DT"),RAFST,RALST,RAI,RANME,RAPAR,RAPRC,RARTDT,RARPT,RARSEL,RASEL,RASSN
 ;
 ;Above line commented out to change local array to global array to
 ;avoid partition overflow -- IHS/HQW/SCR - 05/15/01
 ;
 K I,RACN,RACNT,RADASH,RADUP,^TMP("RARTVER",$J,"DT"),RAFST,RALST,RAI,RANME,RAPAR,RAPRC,RARTDT,RARPT,RARSEL,RASEL,RASSN
 Q
 ;
GETRPT ;
 ;F RARPT=0:0 S RARPT=$O(RA("DT",RARTDT,RARPT)) Q:'RARPT!($D(RARSEL))  D RASET^RARTVER S:'Y RARSEL=0 Q:'Y  S RASSN=$$SSN^RAUTL(RADFN,1) D WRT
 ;
 ;Above line commented out to change local array to global array to
 ;avoid partition overflow -- IHS/HQW/SCR - 05/15/01
 ;
 F RARPT=0:0 S RARPT=$O(^TMP("RARTVER",$J,"DT",RARTDT,RARPT)) Q:'RARPT!($D(RARSEL))  D RASET^RARTVER S:'Y RARSEL=0 Q:'Y  S RASSN=$$SSN^RAUTL(RADFN,1) D WRT
 Q
 ;
 ;
 ;===> BEGIN CHANGES TO PRINT CHART# INSTEAD OF SSN  ;IHS/ANMC/MWR 06/03/92
WRT ;
 ;S RACNT=RACNT+1 W !?1,RACNT,?10,RACN,?18,$E(RAPRC,1,20),?40,$E(RADTE,4,5),"-",$E(RADTE,6,7),"-",$E(RADTE,2,3),?50,$E(RANME,1,20),?72,RASSN S RA("XREF",RACNT)=RARPT D ASK:'(RACNT#15)!(RACNT=RATOT)
 ;
 ;---> PRINT ONLY 19 CHARS OF NAME, THEN CHART#   ;IHS/ANMC/MWR 06/03/92
 S RACNT=RACNT+1
 W !?1,RACNT,?10,RACN,?18,$E(RAPRC,1,20),?40,$E(RADTE,4,5)
 W "-",$E(RADTE,6,7),"-",$E(RADTE,2,3),?50,$E(RANME,1,19)
 W ?71,$$HRCN^RAZUTL
 ;S RA("XREF",RACNT)=RARPT D ASK:'(RACNT#15)!(RACNT=RATOT)
 ;
 ;Above line commented out to change local array to global array to
 ;avoid partition overflow -- IHS/HQW/SCR - 05/15/01
 ;
 S ^TMP("RARTVER",$J,"XREF",RACNT)=RARPT D ASK:'(RACNT#15)!(RACNT=RATOT)
 ;===> END CHANGES                                ;IHS/ANMC/MWR 06/03/92
 ;
 Q
ASK ;
 K RADUP,RARPTX S (RAERR,RAI,RANUM)=0 W !,"Type '^' to STOP, or",!,"CHOOSE FROM 1-",RACNT,": " R X:DTIME S:'$T X="^" S:X["^" RAOUT="",RARSEL=0 Q:X["^"!(X="")
 I X["?" W !!?3,"Please enter a single number, individual numbers separated by commas,",!?3,"a range of numbers separated by a dash, or numbers separated by a",!?3,"combination of commas and dashes.",! G ASK
PARSE ;
 S RAI=RAI+1,RAPAR=$P(X,",",RAI) Q:RAPAR=""  I RAPAR?.N1"-".N S RADASH="" F RASEL=$P(RAPAR,"-"):1:$P(RAPAR,"-",2) D CHK Q:RAERR
 I '$D(RADASH) S RASEL=RAPAR D CHK
 K RADASH G ASK:RAERR,PARSE
 ;
CHK ;
 I $D(RADASH),+$P(RAPAR,"-",2)<+$P(RAPAR,"-") S RAERR=1 Q
 I RASEL'?.N W !?3,*7,"Item ",RASEL," is not a valid selection.",! S RAERR=1 Q
 ;I '$D(RA("XREF",RASEL)) W !?3,*7,"Item ",RASEL," is not a valid selection.",! S RAERR=1 Q
 ;
 ;Above line commented out to change local array to global array to
 ;avoid partition overflow -- IHS/HQW/SCR - 05/15/01
 ;
 I '$D(^TMP("RARTVER",$J,"XREF",RASEL)) W !?3,*7,"Item ",RASEL," is not a valid selection.",! S RAERR=1 Q
 I $D(RADUP(RASEL)) W !?3,*7,"Item ",RASEL," was already selected.",! S RAERR=1 Q
 ;S RANUM=RANUM+1,RADUP(RASEL)="",$P(RARPTX,",",RANUM)=$S(RA("XREF",RASEL):RA("XREF",RASEL),1:0),RARSEL=RANUM
 ;
 ;Above line commented out to change local array to global array to
 ;avoid partition overflow -- IHS/HQW/SCR - 05/15/01
 ;
 S RANUM=RANUM+1,RADUP(RASEL)="",$P(RARPTX,",",RANUM)=$S(^TMP("RARTVER",$J,"XREF",RASEL):^TMP("RARTVER",$J,"XREF",RASEL),1:0),RARSEL=RANUM
 Q
