BDMDR7 ; IHS/CMI/LAB - patients w/o dm on problem list ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**18,19**;JUN 14, 2007;Build 159
 ;
 ;
START ;
 D INFORM
 K DIR
 S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
 D EXIT
R ;
 S BDMREG=""
 D REG^BDMFUTIL
 I $G(BDMRDA)="" D EXIT Q
 S BDMREG=BDMRDA
 ;
YOB ;get YOB
 W !!
 S BDMYOB=""
 S %=$E(DT,1,3)+1700
 S DIR(0)="N^1900:"_%_":0",DIR("A")="Enter the Patient's Year of Birth" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 S BDMYOB=Y
MOB ;get MOB
 W !
 S BDMMOB=""
 S DIR(0)="N^1:12:0",DIR("A")="Enter the Patient's Month of Birth" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D YOB Q
 I $L(Y)=1 S Y="0"_Y
 S BDMMOB=Y
SEX ;
 W !
 S BDMSEX=""
 S DIR(0)="2,.02",DIR("A")="Enter the Patient's Birth Sex" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G MOB
 S BDMSEX=Y
PROCESS ;
 W !!,"Searching the register...."
 S BDMP=0 F  S BDMP=$O(^ACM(41,"B",BDMREG,BDMP)) Q:BDMP'=+BDMP  D
 .Q:'$D(^ACM(41,BDMP))
 .S BDMPAT=$P(^ACM(41,BDMP,0),U,2)
 .Q:$$VALI^XBDIQ1(2,BDMPAT,.02)'=BDMSEX  ;not correct sex
 .S D=$$DOB^AUPNPAT(BDMPAT)
 .Q:$E(D,4,5)'=BDMMOB
 .S Y=$E(D,1,3)+1700
 .I Y'=BDMYOB Q
 .S BDMP(BDMPAT)=""
 I '$O(BDMP(0)) W !!,"No patients were found with YOB: ",BDMYOB,"  MOB: ",BDMMOB,"  BIRTH SEX: ",BDMSEX D PAUSE Q
 W !!,"NAME",?32,"DOB",?46,"SEX",?50,"HRN",?59,"COMMUNITY RESIDENCE",!,"-------------------------------------------------------------------------------"
 S BDMP=0 F  S BDMP=$O(BDMP(BDMP)) Q:BDMP'=+BDMP  D
 .W !,$$VAL^XBDIQ1(2,BDMP,.01),?32,$$FMTE^XLFDT($$DOB^AUPNPAT(BDMP)),?46,$$VALI^XBDIQ1(2,BDMP,.02),?50,$$HRN^AUPNPAT(BDMP,DUZ(2)),?59,$E($$COMMRES^AUPNPAT(BDMP,"E"),1,20)
 .S Y=$$DODX^BDMDL16(BDMP,BDMREG,"I",$G(BDMMULTR),.BDMREGLT)
 .I Y="" S Y="Not Recorded"
 .I Y S Y=$$FMTE^XLFDT(Y)
 .W !?5,"Date of Diabetes Onset: ",Y,!
 W !! D PAUSE
 D EXIT
 Q
EXIT ;clean up and exit
 I '$D(BDMGUI) D EN^XBVK("BDM")
 D ^XBFMK
 D KILL^AUPNPAT
 Q
INFORM ;
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC)
 W !,$$CTR($$USR)
 W !!,"This option can be used to find a patient on a register by using month and"
 W !,"year of birth and birth sex.  This option can assist you in finding a patient"
 W !,"who has been flagged with an error in the WEB Audit.",!!
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
PAUSE ;
 K DIR
 S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
 Q
