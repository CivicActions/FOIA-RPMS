BDWHDDR ;IHS/CMI/LAB - Main Driver EXPORT DATE RANGE; ; 29 Jan 2019  12:46 PM
 ;;1.0;IHS DATA WAREHOUSE;**6,9,11**;JAN 24, 2006;Build 14
 ;
 ;
 ;
START ;Begin processing
 D EN^XBVK("BDW"),^XBFMK K DIADD,DLAYGO
 S BDW("QFLG")=0
 ;W:$D(IOF) @IOF
 W !,$$CTR($$LOC(),80),!
 S X="*****  IHS DATA WAREHOUSE PRESCRIPTION EXPORT IN A DATE RANGE  *****" W !,$$CTR(X,80),!
 S T="INTRO" F J=1:1 S X=$T(@T+J),X=$P(X,";;",2) Q:X="END"  W !,X
 K J,X,T
 ;
 S BDWERR=0
 D CHECK
 D CHKSITE^BDWHRDRI
 I BDW("QFLG") D XIT Q
 I BDWERR D XIT Q
GETDATES ;
 W !,"Please enter the date range for which the Prescription HL7 messages",!,"should be generated.",!
 W !,"Please NOTE:  Only controlled substances will be exported for any fill dates"
 W !,"prior to 2019.  All prescriptions after 2019 will be exported."
 ;S (BDWDDRBD,X)=$E(DT,1,3)_"0101" W $$UP^XLFSTR($$FMTE^XLFDT(X)),"." W !,"All prescriptions (all drugs) filled after ",$$UP^XLFSTR($$FMTE^XLFDT(X))," will be exported.",!
BD ;
 S DIR(0)="D^3130101:"_$$FMADD^XLFDT(DT,-1)_":EP",DIR("A")="Enter Beginning Fill Date",DIR("?")="Enter the beginning fill/refill date." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 S BDW("RUN BEGIN")=Y
 S T=$P(Y(0),",",2)
 S BDWNDA=364
 I $$LEAP^%DTC(T),($E(Y,4,5)="01"!($E(Y,4,5)="02")) S BDWNDA=365
ED ;
 S DIR(0)="D^3130101:"_$$FMADD^XLFDT(DT,-1)_":EP",DIR("A")="Enter Ending Fill Date" D ^DIR K DIR,DA S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 I Y<BDW("RUN BEGIN") W !,"Ending date must be greater than or equal to beginning date!" G ED
 S T=$P(Y(0),",",2)
 I $$LEAP^%DTC(T),$E(+T,4,5)>2 S BDWNDA=365
 I $$FMDIFF^XLFDT(Y,BDW("RUN BEGIN"))>BDWNDA W !!,"Please limit the date range to no more than 1 year.",! G BD
 S BDW("RUN END")=Y
 S BDWERR=0
 W !!,"Log entry ",$$NLOG," will be created and messages generated for fill",!,"date range ",$$UP^XLFSTR($$FMTE^XLFDT(BDW("RUN BEGIN")))," to ",$$UP^XLFSTR($$FMTE^XLFDT(BDW("RUN END"))),".",!
CONT ;continue or not
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"Goodbye" D XIT Q
 I 'Y W !!,"Goodbye" D XIT Q
 S BDWRUN="NEW",BDWERR=0
 D HOME^%ZIS S BDWBS=$S('$D(ZTQUEUED):IOBS,1:"")
 D GENLOG ;generate new log entry
 I $G(BDWERR) D XIT Q
 D QUEUE
 I $G(BDWERR) W !!,"Goodbye, no processing will occur.",! D XIT Q
 I $D(BDWQUE) D XIT Q
 ;
PROCESS ;EP - process new run
 S BDWDDR=1,BDWCNTR=0
 S BDWTOTF=0
 D HOME^%ZIS S BDWBS=$S('$D(ZTQUEUED):IOBS,1:"")
 S BDW("RUN LOCATION")=$P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,10),BDW("QFLG")=0
 S (BDWSKIP,BDW("TXS"),BDW("FPROC"),BDW("COUNT"),BDWERRC,BDW("DEL"),BDWTOTF)=0
 S BDWIEDST=$O(^INRHD("B","HL IHS DW1HOPE IE",0))
 S BDW("RUN LOG")=BDWLOG
 D NOW^%DTC S BDW("RUN START")=%,BDW("MAIN TX DATE")=$P(%,".") K %,%H,%I
 S BDW("BT")=$H
 S BDWT=$$PROD^XUPROD()
 S DIE="^BDWHLOG(",DA=BDWLOG,DR=".15///R;.1////"_BDW("RUN START")_";1108///"_$S(BDWT:"P",1:"T") D ^DIE K DA,DIE,DR
 S BDWCNT=$S('$D(ZTQUEUED):"X BDWCNT1  X BDWCNT2",1:"S BDWCNTR=BDWCNTR+1"),BDWCNT1="F BDWCNTL=1:1:$L(BDWCNTR)+1 W @BDWBS",BDWCNT2="S BDWCNTR=BDWCNTR+1 W BDWCNTR,"")"""
 D PROCESS^BDWHRDR
 I BDW("QFLG") D ABORT^BDWHRDR Q
 D LOG^BDWHRDR ;                Update Log
 I BDW("QFLG") D ABORT^BDWHRDR Q
 S BDWMSGT=""
 S BDWMSGT=$$DW1HTRLR^BDWHEVNT(BDWLOG)
 S ^BDWHTMP(BDWIEDST,BDWMSGT)=""
 D RUNTIME^BDWHRDR
 S DA=BDWLOG,DIE="^BDWHLOG(",DR=".13////"_BDWRUN_";.12////"_BDWMSGT_";.15////C" D ^DIE
 S DA=BDWLOG,DIK="^BDWHLOG(" D IX^DIK K DA,DIK
 D ^XBFMK
 D XIT
 Q
C(X,X2,X3) ;
 I X="" Q ""
 D COMMA^%DTC
 Q X
CHECK ;
 I '$P($G(^AUTTSITE(1,0)),U) W !!,"RPMS Site file not SET UP" S BDWERR=1 Q
 Q
QUEUE ;EP
 K ZTSK
 S DIR(0)="Y",DIR("A")="Do you want to QUEUE this to run at a later time",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y=1 D QUEUE1 Q
 I BDWRUN="NEW",$D(DIRUT) S BDWERR=1 S DA=BDWLOG,DIK="^BDWHLOG(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA
 Q
QUEUE1 ;
 S ZTRTN="PROCESS^BDWHDDR"
 S ZTIO="",ZTDTH="",ZTDESC="PRESC DATA WAREHOUSE DATE RANGE" S ZTSAVE("BDW*")=""
 D ^%ZTLOAD
 W !!,$S($D(ZTSK):"Request Queued!!",1:"Request cancelled")
 I '$D(ZTSK),BDWRUN="NEW" S BDWERR=1 S DA=BDWLOG,DIK="^BDWHLOG(" W !,"Okay, you '^'ed out or timed out so I'm deleting the Log entry and quitting.",! D ^DIK K DIK,DA Q
 S BDWQUE=""
 S DIE="^BDWHLOG(",DA=BDWLOG,DR=".15///Q" D ^DIE K DIE,DA,DR
 K ZTSK
 Q
GENLOG ;generate new log entry
 D ^XBFMK K DIADD
 W:'$D(ZTQUEUED) !,"Generating New Log entry."
 S Y=DT X ^DD("DD") S X=""""_Y_"""",DIC="^BDWHLOG(",DIC(0)="L",DLAYGO=90213.1,DIC("DR")=".02////"_BDW("RUN BEGIN")_";.03////"_BDW("RUN END")_";.07////D;.09///`"_DUZ(2)_";8801////"_DUZ_";.23///PRDR",DIADD=1
 D ^DIC K DIC,DLAYGO,DR,DIADD
 I Y<0 S BDW("QFLG")=23 D ^XBFMK Q
 S BDWLOG=+Y
 D ^XBFMK
 Q
XIT ;exit, eoj cleanup
 D EOP
 D ^XBFMK
 D EN^XBVK("BDW")
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="End of Job.  Press ENTER.",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
DATE(D) ;EP ;IHS/CMI/LAB - new date format - format date in YYYYMMDD format
 I $G(D)="" Q ""
 Q $E(D,1,3)+1700_$E(D,4,7)
 ;
 ;
NLOG() ;get next log
 NEW X,L S (X,L)=0 F  S X=$O(^BDWHLOG(X)) Q:X'=+X  S L=X
 Q L+1
INTRO ;introductory text
 ;;
 ;;ATTENTION:
 ;;
 ;;Please do not run this export without checking with NPIRS first.
 ;;PRDR exports cannot be loaded into the NDW without first making
 ;;special arrangements.
 ;;
 ;;You should use the PRGT and PRRX options for all regularly scheduled 
 ;;exports.
 ;;
 ;;This program will generate Prescription transactions for a fill
 ;;date range that you enter.  A log entry will be created which will log
 ;;the number of fills processed and the number of Prescription HL7 messages
 ;;generated.  
 ;;
 ;;END
