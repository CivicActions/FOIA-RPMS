ABSPASLP ; IHS/SD/SDR - Wake up sleeping insurers
 ;;1.0;PHARMACY POINT OF SALE;**56**;JUN 01, 2001;Build 131
 ;IHS/SD/SDR 1.0*56 ADO119420 New routine/option to check for asleep insurers and give user ability to
 ;   wake them all at once and not using FM.
EN(ABSPINS) ;EP
 W !!?3,"This option will go thru the ABSP Insurer file and look for asleep"
 W !?3,"insurers. It will automatically wake the insurers up, and then you"
 W !?3,"will be given the option to POK the queue."
 D PAZ^ABSPCORR
 I $D(DTOUT)!$D(DIRUT)!$D(DIROUT)!$D(DUOUT) Q
 W $$EN^ABSPVDF("IOF")
 W !,"Searching...." H 1
 K ABSP("ASLP")
 S ABSPINS=0
 S ABSPCNT=1
 F  S ABSPINS=$O(^ABSPEI(ABSPINS)) Q:'ABSPINS  D
 .S ABSPIREC=$G(^ABSPEI(ABSPINS,101))  ;this contains all the RX SLEEP fields
 .S ABSPC=0
 .F ABSPPCE=1:1:7 D
 ..I $P(ABSPIREC,U,ABSPPCE)'="" S ABSPC=1
 .I ABSPC=1 S ABSP("ASLP",ABSPCNT,ABSPINS)="",ABSPCNT=ABSPCNT+1
 .I ABSPC=1 D
 ..D ^XBFMK
 ..S DIE="^ABSPEI("
 ..S DA=ABSPINS
 ..S DR="101.01////@;101.02////@;101.03////@;101.04////@;101.05////@;101.06////@;101.07////@"
 ..D ^DIE
 ;
 I '$D(ABSP("ASLP")) D  Q  ;no asleep insurers, write message, quit
 .W !!,"There are no asleep insurers right now."
 .D PAZ^ABSPCORR  ;this is just for the Press <ENTER> to continue
 ;
 ;if it gets here insurers were asleep but aren't anymore
 W !!,"The following insurers were asleep but have been woken up:"
 W !!,?6,"Insurer (IEN)"
 S ABSPCNT=0
 F  S ABSPCNT=$O(ABSP("ASLP",ABSPCNT)) Q:'ABSPCNT  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .S ABSPINS=0
 .F  S ABSPINS=$O(ABSP("ASLP",ABSPCNT,ABSPINS)) Q:'ABSPINS  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 ..I $Y>(IOSL-5) W !,"(Cont.)" D PAZ Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)  W $$EN^ABSPVDF("IOF")
 ..W !?1,$J(ABSPCNT,3)_". ",$$GET1^DIQ(9002313.4,ABSPINS,".01","E")_" ("_ABSPINS_")"
 W !!
 ;
 D ^XBFMK
 S DIR(0)="YO"
 S DIR("A")="Do you want to poke the queue now"
 S DIR("B")="YES"
 D ^DIR
 I Y<1 Q
 I $D(DTOUT)!$D(DIRUT)!$D(DIROUT)!$D(DUOUT) Q
 D POK^ABSPOS2A  ;poke the queue (using MGR option logic)
 D PAZ^ABSPCORR
 Q
PAZ ;
 I '$D(IO("Q")),$E(IOST)="C",'$D(IO("S")) D
 .F  W ! Q:$Y+3>IOSL
 .K DIR
 .S DIR(0)="E"
 .S DIR("A")="Enter RETURN to continue:"
 .D ^DIR
 .K DIR
 Q
