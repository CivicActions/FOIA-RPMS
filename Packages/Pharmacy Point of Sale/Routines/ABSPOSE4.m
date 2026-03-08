ABSPOSE4 ; IHS/GDIT/AEF - E1 generation routine for private insurance ; 30 Dec 2024  1:29 PM
 ;;1.0;PHARMACY POINT OF SALE;**52,54,55,57**;JUN 01, 2001;Build 131
 ;
 ;New routine with Patch 54
 ;  Prompt subroutines were moved to here from ABSPOSE3 because the
 ;  ABSPOSE3 routine exceeded 15k bytes
 ;IHS/SD/SDR 1.0*55 ADO115915 Changed U 0 to U $P for display cut off/incomplete
 ;IHS/SD/SDR 1.0*57 ADO114910 Changed so it doesn't require Private Insurance Eligible entry; it will check for an SSN first and use that
 ;  if there is one, followed by the MEMBER NUMBER, and then the POLICY NUMBER
 ;
 Q
 ;
GETPAT() ; Prompt for patient.
 ;
 N ABSPDUZ2,PATDONE,Y,DIC,I,I2,I3,J,J2,J3
 N ABSPNAM,MEMNUM,ABSPPRVT,ABSPMINS,PATNAME
 N START,END,INSURER,COVERAGE,NUMCOUNT,ALLINS,PATIEN,INSNAME,SSN
 N X,DIR,DTOUT,DUOUT,DIRUT S X=""
 I '$D(U) N U S U="^"  ;ABSP*1.0*54
 ;
 S PATDONE=0   ;set to one when done prompting
 S Y=0
 S ABSPDUZ2=+$G(DUZ(2)),DUZ(2)=0
 ;
 ;U 0 W !!!   ;ABSP*1.0*54  ;absp*1.0*55 IHS/SD/SDR ADO115915
 U $P W !!!   ;ABSP*1.0*54  ;absp*1.0*55 IHS/SD/SDR ADO115915
 ;
 S DIC=2,DIC(0)="AEMQZ"
 S DIC("A")="Generate eligibility chk (Private Insurance) for which patient? "
 F  D  Q:PATDONE
 .D ^DIC
 .;U 0 W !   ;ABSP*1.0*54  ;absp*1.0*55 IHS/SD/SDR ADO115915
 .U 0 W !   ;ABSP*1.0*54  ;absp*1.0*55 IHS/SD/SDR ADO115915
 .S:(($G(DUOUT))!($G(DTOUT))!(Y>0)!(X="")) PATDONE=1
 I $G(ABSPDUZ2) S DUZ(2)=ABSPDUZ2   ;ABSP*1.0*54
 S PATIEN=+Y,PATNAME=$P(Y,U,2) ; W "PATIEN: ",PATIEN,!   ;ABSP*1.0*54
 I PATIEN=0 Q 0
 K DIC,Y
 ; =-=-=-=
 ;IHS/OIT/RAM ABSP*1.0*54 FID82469 RETRIEVE LAST 4 OF SSN FIRST
 S SSN=$$GET1^DIQ(9000001,PATIEN,1107.2),J2=$L(SSN)
 S MEMNUM=$E(SSN,J2-3,J2)
 ;
 S (I,I2)=0 ; COUNT NUMBER OF ELIGIBLE INSURERS, NUMBER OF UNIQUE RETRIEVED MEMBER NUMBERS.
 S ABSPPRVT=+$O(^AUPNPRVT("B",PATIEN,0)) ; Private Eligible record
 ;I ABSPPRVT=0 W "That individual does not have a Private Insurance Eligible entry. ",! Q 0  ;absp*1.0*57 IHS/SD/SDR ADO114910
 ;RETRIEVE THE "CARDHOLDER ID" - I THOUGHT IT WAS "MEMBER NUMBER" BUT IT COULD BE THE INSURANCE POLICY NUMBER.
 S ABSPMINS=0 F  S ABSPMINS=$O(^AUPNPRVT(ABSPPRVT,11,ABSPMINS)) Q:+ABSPMINS=0  D    ;W "ABSPMINS: ",ABSPMINS,!
 .S START=$P($G(^AUPNPRVT(ABSPPRVT,11,ABSPMINS,0)),U,6) ; /IHS/OIT/RAM ; P52 ; GET THE START DATE FOR COVERAGE.
 .Q:START=""   ;QUIT IF START OF COVERAGE IS EMPTY; ASSUME TO MEAN "NO COVERAGE." ;ABSP*1.0*54 
 .S END=$P($G(^AUPNPRVT(ABSPPRVT,11,ABSPMINS,0)),U,7) S:+END=0 END=9999999 ; /IHS/OIT/RAM ; P52 ; GET THE END DATE FOR COVERAGE, IF NONE, SET TO SUPERHUGE #.
 .S INSURER=$P($G(^AUPNPRVT(ABSPPRVT,11,ABSPMINS,0)),U,1),COVERAGE=$P($G(^AUPNPRVT(ABSPPRVT,11,ABSPMINS,0)),U,3) ; /IHS/OIT/RAM ; P52 ; GET THE INSURER EIN & COVERAGE TYPE.
 .S INSNAME=$P($G(^AUPNPRVT(ABSPPRVT,11,ABSPMINS,0)),U,4)  ;GET THE INSURER NAME
 .;
 .;S MEMNUM=$P($G(^AUPNPRVT(ABSPPRVT,11,ABSPMINS,2)),U,1)  ;/IHS/OIT/RAM P52 GET THE MEMBER NUMBER
 .;I +MEMNUM=0 S MEMNUM=$P($G(^AUPNPRVT(ABSPPRVT,11,ABSPMINS,0)),U,2) ;/IHS/OIT/RAM P52 GET THE POLICY NUMBER  ;absp*1.0*57 IHS/SD/SDR ADO114910
 .;start new absp*1.0*57 IHS/SD/SDR ADO114910
 .I +MEMNUM=0 S MEMNUM=$P($G(^AUPNPRVT(ABSPPRVT,11,ABSPMINS,2)),U,1)  ;member number
 .I +MEMNUM=0 S MEMNUM=$P($G(^AUPN3PPH($P($G(^AUPNPRVT(ABSPPRVT,11,ABSPMINS,0)),U,8),0)),U,4)  ;policy number from the Policy Holder file
 .;end new absp*1.0*57 IHS/SD/SDR ADO114910
 .;
 .;/IHS/OIT/RAM/ P52 NEXT LINE VERIFIES THAT THE E1 DATE IS VALID, AND ALSO DOESN'T ALLOW DUPLICATE MEMBER NUMBERS
 .Q:MEMNUM=""  ;MEMBER NUMBER IS REQUIRED, MOVE ON TO NEXT INSURER IF NOT POPULATED
 .Q:$D(ALLINS(MEMNUM))  ;MEMBER NUMBER IS ALREADY IN TEMP LIST, SKIP TO NEXT RECORD
 .I START<E1DATE&(E1DATE<END) S I=I+1,ALLINS(I)=INSURER_U_MEMNUM_U_COVERAGE_U_INSNAME,ALLINS(MEMNUM)=""
 .;
 ;
 ;BEGIN MODIFICATION - ABSP*1.0*54 FID 82469 IHS/OIT/RAM
 ;S I3=0 ;;AT THIS POINT, NO ELIGIBLE INSURERS, LET'S GET THE LAST 4 OF THE SSN
 ;I I=0 W "Patient does not have any eligible Private Insurers or SSN. Exiting.",! Q 0  ;absp*1.0*57 IHS/SD/SDR ADO114910
 I (I=0&(MEMNUM="")) W "Patient does not have any eligible Private Insurers or SSN. Exiting.",! Q 0  ;absp*1.0*57 IHS/SD/SDR ADO114910
 I MEMNUM'="" Q PATIEN_U_PATNAME_U_MEMNUM_U_"0"  ;absp*1.0*57 IHS/SD/SDR ADO114910
 ;E  Q PATIEN_U_PATNAME_U_MEMNUM_U_"0"
 ;END MODIFICATION - ABSP*1.0*54 FID 82469 IHS/OIT/RAM
 I I=1 Q PATIEN_U_PATNAME_U_$P(ALLINS(1),U,2)_U_$P(ALLINS(1),U)
 W "More than one insurer found. Which insurer should we use for the check?",!!
 W "#:",?4,"Member Number:",?20,"Coverage Type:",?40,"Insurer:",!
 F J=1:1:I D
 .W J,?4,$P(ALLINS(J),U,2),?20
 .S I2=$$GET1^DIQ(9999999.65,$P(ALLINS(J),U,3)_",",.01) W $S(I2'="":I2,1:$P(ALLINS(J),U,3)),?40
 .W $$GET1^DIQ(9999999.18,$P(ALLINS(J),U)_",",.01),!
 W !
 S DIR(0)="NA"_"^1:"_I,DIR("A")="Please enter the # of the insurer to use: "
 D ^DIR
 Q:$D(DTOUT)!($D(DIROUT))!($D(DUOUT)) 0
 Q PATIEN_U_PATNAME_U_$P(ALLINS(Y),U,2)_U_$P(ALLINS(Y),U)
 ;
GETPHARM() ; Prompt for pharmacy.
 ;
 N PHARM,HLDPHARM,Y,PDONE,PHMCNT,DIC
 ;
 S (PHMCNT,PDONE,PHARM,Y)=0
 ;
 F  S PHARM=$O(^ABSP(9002313.56,PHARM)) Q:'+PHARM  D
 .S PHMCNT=PHMCNT+1
 .S:PHMCNT=1 HLDPHARM=PHARM
 Q:PHMCNT=1 HLDPHARM
 ;
 W !!
 S DIC=9002313.56,DIC(0)="AEMQZ"
 S DIC("B")=$P($G(^ABSP(9002313.56,HLDPHARM,0)),U)
 S DIC("A")="Please specify the pharmacy: "
 F  D  Q:PDONE
 .D ^DIC
 .;U 0 W !   ;ABSP*1.0*54  ;absp*1.0*55 IHS/SD/SDR ADO115915
 .U $P W !   ;ABSP*1.0*54  ;absp*1.0*55 IHS/SD/SDR ADO115915
 .S:(($G(DUOUT))!($G(DTOUT))!(Y>0)) PDONE=1
 ;
 Q +Y
 ;
GETNPI(PHARM) ; /IHS/OIT/RAM ; P51 ; Get NPI(s) for Outpatient Site. If none, warn user & exit.
 ;         If one, use it and return. If more than one, prompt user for clarification.
 ;
 N I,I2,I3,J,J2,J3,K,K2,K3,NPI,NPITMP,OPS,Y,PDONE,OPSCNT,DIC,DIR
 ;
 S (OPS,OPSCNT,PDONE,NPI,Y)=0
 ;
 F  S OPS=$O(^ABSP(9002313.56,PHARM,"OPSITE",OPS)) Q:'+OPS  D
 .S NPITMP=$$GET1^DIQ(9002313.5601,OPS_","_PHARM,.02)
 .I NPITMP'="" S OPSCNT=OPSCNT+1 S NPI(OPSCNT)=NPITMP
 I OPSCNT=0 D NPIWARN^ABSPOSE3 Q 0
 I OPSCNT=1 Q NPI(OPSCNT)
 ;
 W !,"For the Pharmacy: ",$$GET1^DIQ(9002313.56,PHARM,.01)," there are ",OPSCNT," Outpatient Sites:",!!
 F I=1:1:OPSCNT D
 .W I,") Site: ",$$GET1^DIQ(9002313.5601,I_","_PHARM,.01),?43,"NPI: ",NPI(I),!
 S DIR(0)="N^1:"_OPSCNT
 S DIR("A")="Which NPI would you like to send? "
 S DIR("B")="1"
 D ^DIR  W !
 I $D(DTOUT)!($D(DUOUT))!($D(DIRUT)) W "User Aborted. Exiting. ",! Q 0
 Q NPI(+Y)
 ;
GETDATE() ; Prompt for service date.
 N CURDISP,X1,X2,BEGDT,ENDDT,E1DT
 ;
 S Y=DT
 D DD^%DT
 S CURDISP=Y
 ;
 S X1=DT,X2=-90
 D C^%DTC
 S BEGDT=X
 S Y=X
 D DD^%DT
 S BEGDISP=Y
 ;
 S X1=DT,X2=+90
 D C^%DTC
 S ENDDT=X
 S Y=X
 D DD^%DT
 S ENDDISP=Y
 ;
 W !,"Accept the default current date of ",CURDISP," or"
 W !,"Enter a date between ",BEGDISP," and ",ENDDISP,!
 S E1DT=$$DATE^ABSPOSU1("Enter Service Date: ",DT,0,BEGDT,ENDDT,"EX")
 S:E1DT="^"!(E1DT="^^")!(E1DT=-1) E1DT=""
 Q E1DT
 ;
GETABSPE() ; If E1 previously sent, find it and prompt to send again.
 ; If doesn't exist, create new one.
 ;
 N X,DIC,DLAYGO,Y,NEWE1,CRTNWE1,E1IEN
 S DIC="^ABSPE(",DIC(0)="XZ"
 S X="`"_E1PIEN
 S (NEWE1,CRTNWE1)=0
 ;
 ;look for old E1
 D ^DIC
 K DIC
 S E1IEN=+Y
 S:E1IEN<1 CRTNWE1=1   ;doesn't exist - add
 S:E1IEN>0 NEWE1=$$PRMPT^ABSPOSE3(E1IEN)  ;exist - send again?
 ;
 ; Yes, send again - delete old entry
 I NEWE1 D
 .N DIK,DA
 .S DIK="^ABSPE("
 .S DA=E1IEN
 .D ^DIK
 .K DIK,DA
 .S CRTNWE1=1
 ;
 ; create new entry
 I CRTNWE1 D
 .S DIC="^ABSPE("
 .S X="`"_E1PIEN
 .S DLAYGO=9002313.7,DIC(0)="LXZ"
 .D ^DIC
 ;
 Q +Y
 ;
