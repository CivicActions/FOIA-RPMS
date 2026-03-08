ADESPRV ; IHS/OIT/GAB - Provider/Dentist Report
 ;;6.0;ADE;**38**;MAR 25, 1999;Build 158
 ;;IHS/OIT/GAB 2.2023 File 3,6,16 Removal/File 200 Update - ADE Patch 38
 ;
 ;
EP ;EP - called from SUPERVISOR/LPRO option
 W:$D(IOF) @IOF
 ;N IEN,PROV,X,EXP,PIEN,PRV,TITLE,ADETYP,ADENUM,ADETERM,ADENAME,ADECNT
 N IEN,PROV,X,EXP,PIEN,PRV,TITLE,ADETYP,ADENUM,ADENAME,ADECNT,ADEPAUSE,ADETERM
 S (X,ADETYP)=""
 S (ADECNT,ADEPAUSE)=0
 U IO
 D HDR
 ; search through File 200 for Providers=Dentists, with Provider Key and Provider Title=Dentist
 S IEN=0 F  S IEN=$O(^VA(200,IEN)) Q:IEN=""!('+IEN)  D
 .S (X,TITLE,ADETERM,PROV,ADETERM,AFFIL,MNEM,INACT)=""
 .S X=$$PROVKEY(IEN) Q:X=0
 .I X=1 S TITLE=$$DISC(IEN) I TITLE=0 Q  ;if they have a Provider Key & if they are a Dentist continue
 .I TITLE=2  D
 ..S ADETERM=$$GET1^DIQ(200,IEN,9.2,,"I")
 ..I (ADETERM=""!(ADETERM>DT))  D  ;ck for termination date, continue if null or greater than today
 ...S PROV=$$GET1^DIQ(200,IEN,.01) I $G(PROV)="" Q  ;get Provider NAME
 ...S AFFIL=$$GET1^DIQ(200,IEN,9999999.01) ;Affiliation
 ...S MNEM=$P($G(^VA(200,IEN,0)),U,2) ; Mnemonic
 ...S INACT=$$GET1^DIQ(200,IEN,53.4)  ; Inactive Date
 ...D PRINT
 ...Q
 D DONE
 Q
 ;
PROVKEY(ADIEN) ;  Check for PROVIDER KEY (c): 1 for Providers  File 200, Field:8932.001=1  OR ^VA(200,"AK.PROVIDER",PROV,3040)
 K PROKEY,ADEPKY,KY
 S (PROKEY,ADEPKY,KY)=""
 S ADEPKY=$O(^DIC(19.1,"B","PROVIDER",0)) I $G(ADEPKY)="" Q 0
 S PROKEY=$G(^VA(200,ADIEN,51,ADEPKY,0)) I $G(PROKEY)="" Q 0
 S KY=$P(PROKEY,U,1)
 I $G(KY) S KY=$$GET1^DIQ(200,ADIEN,8932.001)
 I KY=1 Q 1
 Q 0
DISC(ADIEN) ;   Check for Provider Class/Title = Dentist / Discipline
 K ADEDISC S ADEDISC=""
 S ADEDISC=$$GET1^DIQ(200,ADIEN,53.5)
 I ADEDISC["DENTIST" Q 2
 Q 0
PRINT ;print Provider Name; Affiliation ; MNEMONIC
 I $L(PROV)>30 S PROV=$E(PROV,1,30)
 W !,PROV,?32,$G(AFFIL),?45,$G(MNEM),?55,$G(INACT)
 Q
HDR ;
 N LIN
 I IOST["C-" W @IOF
 W !,"DENTIST LIST ",!
 W !,"Provider Name ",?32,"Affiliation",?45,"MNEMONIC",?55,"INACTIVE DATE"
 W ! F LIN=1:1:72 W "-"
 W !
 Q
DONE ;
 W !!
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 K PROV,MNEM,INACT,ADEYYY ;/IHS/OIT/GAB ADD MORE IF NECESSARY
 Q
 ;
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
ASORT ;
 S R=$$VAL^XBDIQ1(200,P,9999999.01)
 Q
NSORT ;
 S R=$$VAL^XBDIQ1(200,P,.01)
 Q
DSORT ;
 S R=$$VAL^XBDIQ1(200,P,53.5)
 Q
PAUS ;
 N DTOUT,DUOUT,DIR
 S DIR("?")="Enter '^' to Halt or Press Return to continue"
 S DIR(0)="FO",DIR("A")="Press Return to continue or '^' to Halt"
 D ^DIR
 I $D(DUOUT) S ADEPAUSE=1
 Q
