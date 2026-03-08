BDWHRDI2 ; IHS/CMI/LAB - INIT FOR DW EXPORT ; 19 Nov 2018  8:41 AM
 ;;1.0;IHS DATA WAREHOUSE;**6,9**;JAN 24, 2006;Build 103
 ;
 ;
START ;
 D INFORM ;      Let operator know what is going on.
 D GETLOG ;      Get last log entry and display data.
 Q:BDW("QFLG")
 D CURRUN ;      Compute run dates for current run.
 Q:BDW("QFLG")
 D ANYBACK
 ;
 D CONFIRM ;     Get ok from operator.
 Q:BDW("QFLG")
 D GENLOG ;      Generate new log entry.
 Q
ANYBACK ;
 S (BDWBLBD,BDWBLED)=""
 W !
 S X=0 F  S X=$O(BDWHOPE(X)) Q:X'=+X  I BDWHOPE(X)=""  D
 .S BDWBLBD=3130101,BDWBLED=BDW("RUN BEGIN"),BDWBLED=$$FMADD^XLFDT(BDWBLED,-1)
 .W !!,"NOTE:  PHARMACY DIVISION ",$$VAL^XBDIQ1(59,X,.01)," backload has not been completed."
 .W !,"Controlled substances from ",$$UP^XLFSTR($$FMTE^XLFDT(BDWBLBD))," through Dec 31, 2018 will be exported."
 .;W !,"All fills/refills for all drugs from ",$$FMTE^XLFDT(BDW("RUN BEGIN"))," through ",$$FMTE^XLFDT(BDW("RUN END")),!,"will be exported.",!
 .W !!,"All fills/refills for all drugs from Jan 1, 2019 through ",$$UP^XLFSTR($$FMTE^XLFDT(BDW("RUN END")))," will be exported.",!
 Q
 ;
GETLOG ;EP GET LAST LOG ENTRY
 S (X,BDW("LAST LOG"))=0 F  S X=$O(^BDWHLOG(X)) Q:X'=+X  I $P(^BDWHLOG(X,0),U,7)="R" S BDW("LAST LOG")=X
 Q:'BDW("LAST LOG")
 D DISPLOG
 Q:$P(^BDWHLOG(BDW("LAST LOG"),0),U,15)="C"
 D ERROR
 Q
ERROR ;
 S BDW("QFLG")=12
 S BDW("PREV STATUS")=$P(^BDWHLOG(BDW("LAST LOG"),0),U,15)
 I BDW("PREV STATUS")="" D EERR Q
 D @(BDW("PREV STATUS")_"ERR") Q
 Q
EERR ;
 S BDW("QFLG")=13
 ;
 Q:$D(ZTQUEUED)
 W $C(7),$C(7),!!,"*****ERROR ENCOUNTERED*****",!,"The last Prescription Data Export never successfully completed to end of job!!!",!,"This must be resolved before any other exports can be done.",!
 Q
RERR ;
 S BDW("QFLG")=15
 ;
 Q:$D(ZTQUEUED)
 W $C(7),$C(7),!!,"Data Warehouse Prescription Transmission is currently running!!"
 Q
QERR ;
 S BDW("QFLG")=16
 ;
 Q:$D(ZTQUEUED)
 W !!,$C(7),$C(7),"Data Warehouse Prescription Transmission is already queued to run!!"
 Q
FERR ;
 S BDW("QFLG")=17
 ;
 Q:$D(ZTQUEUED)
 W !!,$C(7),$C(7),"The last Prescription DATA WAREHOUSE Export failed and has never been reset.",!,"See your site manager for assistence",!
 Q
 ;
DISPLOG ; DISPLAY LAST LOG DATA
 S Y=$P(^BDWHLOG(BDW("LAST LOG"),0),U,2) S BDW("LAST BEGIN")=$$UP^XLFSTR($$FMTE^XLFDT(Y)) S Y=$P(^BDWHLOG(BDW("LAST LOG"),0),U,3) S BDW("LAST END")=$$UP^XLFSTR($$FMTE^XLFDT(Y))
 Q:$D(ZTQUEUED)
 W !!,"Last run was for Prescription Fill dates ",BDW("LAST BEGIN")," through ",BDW("LAST END"),"."
 Q
 ;
CONFIRM ;EP SEE IF THEY REALLY WANT TO DO THIS
 Q:$D(ZTQUEUED)
 W !,"The computer database location for this run is ",$P(^DIC(4,DUZ(2),0),U),".",!
CFLP  ;
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="N" K DA D ^DIR K DIR
 I 'Y S BDW("QFLG")=99
 Q
 ;
GENLOG ; GENERATE NEW LOG ENTRY
 D ^XBFMK K DIADD
 W:'$D(ZTQUEUED) !,"Generating New Log entry."
 S Y=BDW("RUN DATE") X ^DD("DD") S X=""""_Y_"""",DIC="^BDWHLOG(",DIC(0)="L",DLAYGO=90213.1
 S DIC("DR")=".02////"_BDW("RUN BEGIN")_";.03////"_BDW("RUN END")_";.07////R;.09///`"_DUZ(2)_";8801////"_DUZ_";.23///PRGT"_";1102////"_$G(BDWBLBD)_";1103////"_$G(BDWBLED),DIADD=1
 D ^DIC K DIC,DLAYGO,DR,DIADD
 I Y<0 S BDW("QFLG")=23 D ^XBFMK Q
 S BDWLOG=+Y
 D ^XBFMK
 Q
INFORM ;EP - INFORM OPERATOR WHAT IS GOING TO HAPPEN
 Q:$D(ZTQUEUED)
 W !!,"This option will generate Pharmacy Prescription Data Warehouse HL7 messages"
 W !,"for prescriptions filled between a specified range of dates.  "
 W !,"You may ""^"" out at any prompt and will be asked to confirm your entries ",!,"prior to generating the HL7 messages.",!
 Q
 ;
CURRUN ;EP - COMPUTE DATES FOR CURRENT RUN
 S BDW("RUN BEGIN")=""
 I BDW("LAST LOG") S X1=$P(^BDWHLOG(BDW("LAST LOG"),0),U,3),X2=1 D C^%DTC S BDW("RUN BEGIN")=X,Y=X D DD^%DT
 I BDW("RUN BEGIN")="" D FIRSTRUN
 Q:BDW("QFLG")
 S Y=$$FMADD^XLFDT(DT,-1)
 I Y<BDW("RUN BEGIN") W:'$D(ZTQUEUED) !!,"  Ending date cannot be before beginning date!  There is no new data to send.",$C(7) S BDW("QFLG")=18 Q
 S BDW("RUN END")=Y
 W:'$D(ZTQUEUED) !!,"The inclusive dates for this run are ",$$FMTE^XLFDT(BDW("RUN BEGIN"))," through ",$$FMTE^XLFDT(BDW("RUN END")),"."
 K %,%H,%I,BDW("RDFN"),BDW("X"),BDW("Y"),BDW("LAST LOG"),BDW("LAST BEGIN"),BDW("Z"),BDW("DATE")
 Q
 ;
FIRSTRUN ; FIRST RUN EVER (NO LOG ENTRY)
 I $D(ZTQUEUED),$D(BDWO("SCHEDULED")) S BDW("QFLG")=12 Q
 W !!,"No log entry.  First run ever assumed (excluding date range re-exports).",!
 I BDW("RUN BEGIN")="" S BDW("RUN BEGIN")=$E(DT,1,3)_"0101"
 S BDW("FIRST RUN")=1
 Q
 ;
ERRBULL ;ENTRY POINT - ERROR BULLETIN
 S BDW("QFLG1")=$O(^BDWERRC("B",BDW("QFLG"),"")),BDW("QFLG DES")=$P(^BDWERRC(BDW("QFLG1"),0),U,2)
 S XMB(2)=BDW("QFLG"),XMB(3)=BDW("QFLG DES")
 S XMB(4)=$S($D(BDWLOG):BDWLOG,1:"< NONE >")
 I '$D(BDW("RUN BEGIN")) S XMB(5)="<UNKNOWN>" G ERRBULL1
 S Y=BDW("RUN BEGIN") D DD^%DT S XMB(5)=Y
ERRBULL1 S Y=DT D DD^%DT S XMB(1)=Y,XMB="BDW DW TRANSMISSION ERROR"
 S XMDUZ=.5 D ^XMB
 K XMB,XM1,XMA,XMDT,XMM,BDW("QFLG1"),BDW("QFLG DES"),XMDUZ
 Q
