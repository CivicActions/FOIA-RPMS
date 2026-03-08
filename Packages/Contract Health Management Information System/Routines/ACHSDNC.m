ACHSDNC ; IHS/ITSC/PMF - CANCEL DENIAL ;   [ 10/31/2003  11:43 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**6,30,31**;JUNE 11, 2001;Build 39
 ;ACHS*3.1*3  allow reversal as well as cancel  WHOLE ROUTINE IS NEW
 ;ACHS*3.1*6 IHS/SET/JVK Added section to add office notes
 ;ACHS*3.1*30 5.20.2022 IHS.OIT.FCJ MOD FOR ESIG
 ;ACHS*3.1*31 7.11.2022 IHS.OIT.FCJ Prompt not display correct action for Can or Rev
 ;                                  and do not allow a Can or Rev Denial to be esigned
 ;
 D VIDEO^ACHS
LOOK ; --- Select the Denial
 W !!
 ;
 K DFN S ACHDOCT="denial"
 D ^ACHSDLK
 I $D(ACHDLKER) D RTRN^ACHS Q
 S DA=ACHSA
 ;
 I $P(^ACHSDEN(DUZ(2),"D",DA,0),U,11)?1N.N S Y=$P(^(0),U,11) X ^DD("DD") W !!,"This DENIAL cannot be Cancelled/Reversed because it was Electronically Signed.",!,"Signature Date: ",Y,!! G LOOK
 I $P($G(^ACHSDEN(DUZ(2),"D",DA,0)),U,8)="Y" W !!,*7,*7,IORVON,"THIS DENIAL HAS ALREADY BEEN CANCELLED",IORVOFF,!! G LOOK
 ;
 I $P($G(^ACHSDEN(DUZ(2),"D",DA,0)),U,8)="R" W !!,*7,*7,IORVON,"THIS DENIAL HAS ALREADY BEEN REVERSED",IORVOFF,!! G LOOK
 ;
WHICH ;
 S ACHSRSP="RrCc"      ;ACHS*3.1*31
 W !!,"Cancel or Reverse this denial? (C/R):  "
 D READ^ACHSFU
 ;
 I $G(ACHSQUIT)=1 K ACHSQUIT Q
 I Y="?" W !,"Enter ""^"" to Exit or ""C"" or ""c"" to Cancel or ""R"" or ""r"" to Reverse." G WHICH ;ACHS*3.1*31
 I ACHSRSP'[Y W !,"Enter ""^"" to Exit or ""C"" or ""c"" to Cancel or ""R"" or ""r"" to Reverse." G WHICH ;ACHS*3.1*31
 ;
 N STATUS
 ;S STATUS=Y I STATUS="C" S STATUS="Y"  ;ACHS*3.1*31
 S STATUS=Y I (STATUS="C")!(STATUS="c") S STATUS="Y"  ;ACHS*3.1*31
 ;
SURE ;
 N MSG S MSG="Are You Sure You Want To "_$S(STATUS="Y":"Cancel",1:"Reverse")_" This Denial?"
 W !!,*7,*7,IORVON,MSG,!!,"Once This Happens It Can Never Be Applied Again",IORVOFF,!!
 S %=$$DIR^ACHS("Y",MSG_" (Y/N)","NO","Once This Happens It Can Never Be Applied Again","",2)
 ;
 I ('%)!$D(DUOUT) W !!,*7,*7,"DENIAL LEFT UNCHANGED",!! Q
 ;
 I $D(DTOUT) D RTRN^ACHS Q
 ;
SET ;
 W !!,IORVON,"Now ",$S(STATUS="Y":"Cancelling",1:"Reversing")," Denial Number ",$P($G(^ACHSDEN(DUZ(2),"D",DA,0)),U),IORVOFF
 I '$$DIE^ACHSDN("8///"_STATUS) K ACHSA,DIC,DFN Q
 ;test ESIG Parm and substract 1 for total denials waiting to be printed ;ACHS*3.1*30 ST OF CHG
 I ACHSDESG D
 .Q:($$DN^ACHS(0,12)="P")!($$DN^ACHS(0,12)="")
 .S DIE="^ACHSDENR(",DA=DUZ(2)
 .I $$DN^ACHS(0,11)?1N.N S ACHSSGCT=$P(^ACHSDENR(DUZ(2),0),U,15)-1,DR=".15////"_ACHSSGCT  ;IF SIGNED BUT NOT PRINTED
 .E  S ACHSSGCT=$P(^ACHSDENR(DUZ(2),0),U,14)-1,DR=".14////"_ACHSSGCT                      ;NOT PRINTED AND NOT SIGNED
 .D ^DIE
 .K DIC,DIE,DA,DR,D
 ;ACHS*3.1*30 End OF CHG
 W !!,"Completed",!!
 ;IHS/SET/JVK ACHS*3.1*6 ADD NEXT TWO LINES
 W !,"Enter Notes",!
 I '$$DIE^ACHSDN(900,2) Q
 Q
