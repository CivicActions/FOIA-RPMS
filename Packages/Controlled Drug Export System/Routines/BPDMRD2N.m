BPDMRD2N ; IHS/CMI/LAB - Export initialization 14 Mar 2011 3:41 PM ;
 ;;2.0;CONTROLLED DRUG EXPORT SYSTEM;**1,4,5**;NOV 15, 2011;Build 11
 ;
 ;
START ;
 S BPDMQFLG=""
 D INFORM ;      Let operator know what is going on.
 ;D HEADER
 D GETSITE^BPDMCHKN
 Q:BPDMSITE=""  ;get site to do the export for
 Q:BPDMQFLG
 D CHECK^BPDMCHKN
 Q:BPDMQFLG
 I $$GET1^DIQ(9002315.01,BPDMSITE,1108,"I") S BPDMPTYP="T"  ;maw beta testing
 D GETLOG ;      Get last log entry and display data.
 Q:BPDMQFLG
 ;S BPDMFSTR=0
 ;I $$ZEROCHK^BPDMCHKN() D  Q  ;lets do the zero report if no transactions since last run over 24 hours
 ;. S BPDMZRO=1
 ;. S BPDMRTYP=4
 ;. D GENLOG^BPDMCHKN
 D CURRUN ;      Compute run dates for current run.
 Q:BPDMQFLG
 ;D CHKAL^BPDMCHKN ;    Check FILE 52  xref for date range
 ;Q:BPDMQFLG
 D CONFIRM^BPDMCHKN ;     Get ok from operator.
 Q:BPDMQFLG
 I $$GET1^DIQ(9002315.01,BPDMSITE,1108,"I") S BPDMPTYP="T"  ;maw beta testing
 D GENLOG^BPDMCHKN ;      Generate new log entry.
 Q
GETLOG ;EP GET LAST LOG ENTRY
 S BPDM("LAST LOG")=0
 S BPDM("LAST ZERO LOG")=0
 ;S X=0 F  S X=$O(^BPDMLOG(X)) Q:X'=+X  I $P(^BPDMLOG(X,0),U,8)=""!($P(^BPDMLOG(X,0),U,8)=1),$P(^BPDMLOG(X,0),U,10)=BPDMOSIT S BPDM("LAST LOG")=X
 S BPDM("LAST LOG")=$$FNDLST^BPDMDR1N(BPDMOSIT,1)
 S BPDM("LAST ZERO LOG")=$$FNDLST^BPDMDR1N(BPDMOSIT,4)  ;maw added 12142018
 Q:'BPDM("LAST LOG")
 ;maw added 12142018
 I $G(BPDM("LAST ZERO LOG")),$P(^BPDMLOG(BPDM("LAST ZERO LOG"),0),U)>$P(^BPDMLOG(BPDM("LAST LOG"),0),U) D
 . S BPDM("LAST LOG")=BPDM("LAST ZERO LOG")
 ;end mods
 D DISPLOG
 Q
DISPLOG ; DISPLAY LAST LOG DATA
 S Y=$P(^BPDMLOG(BPDM("LAST LOG"),0),U,2) X ^DD("DD") S BPDM("LAST BEGIN")=Y S Y=$P(^BPDMLOG(BPDM("LAST LOG"),0),U,3) X ^DD("DD") S BPDM("LAST END")=Y
 Q:$D(ZTQUEUED)
 W !!,"Last run was for ",BPDM("LAST BEGIN")," through ",BPDM("LAST END"),"."
 Q
INFORM ;EP - INFORM OPERATOR WHAT IS GOING TO HAPPEN
 Q:$D(ZTQUEUED)
 Q:$D(BPDM("SCHEDULED"))
 W !!,"Create Prescription Monitoring System transaction file.",!!
 W !,"This option is used to create an export file of Prescription data."
 W !,"This file will be sent as a ",$S(BPDMPTYP="T":"TEST",1:"PRODUCTION")," set of transactions.",!!
 Q
 ;
CURRUN ;EP - COMPUTE DATES FOR CURRENT RUN
 S BPDM("RUN BEGIN")=""
 ;I BPDM("LAST LOG") S X1=$P(^BPDMLOG(BPDM("LAST LOG"),0),U,3),X2=1 D C^%DTC S BPDM("RUN BEGIN")=X,Y=X D DD^%DT
 ;I BPDM("LAST LOG") S BPDMLLB=$P(^BPDMLOG(BPDM("LAST LOG"),0),U,3),BPDM("RUN BEGIN")=$S($P(BPDMLLB,".",2)="":BPDMLLB-.764041,1:BPDMLLB)  ;-.000001) ;cmi/maw 10/04/2018 p4 CR10306
 I BPDM("LAST LOG") S BPDMLLB=$P(^BPDMLOG(BPDM("LAST LOG"),0),U,3),BPDM("RUN BEGIN")=$S($P(BPDMLLB,".",2)="":BPDMLLB+.000001,1:BPDMLLB)  ;-.000001) ;cmi/maw 10/04/2018 p4 CR10306
 I BPDM("RUN BEGIN")="" D FIRSTRUN
 Q:BPDMQFLG
 ;S BPDM("RUN END")=$O(^PSRX("AL",""),-1)+.000001  ;cmi/maw 10042018 p4 CR10306 use the last released prescription as the end date
 S BPDM("RUN END")=$O(^PSRX("AL",$$NOW^XLFDT()),-1)+.000001
 ;S BPDM("RUN END")=$$NOW^XLFDT()  ;always make run end date when option is run
 I BPDM("RUN END")<BPDM("RUN BEGIN") S BPDM("RUN END")=BPDM("RUN BEGIN")  ;maw p4
 I BPDM("RUN END")=BPDM("RUN BEGIN") S BPDM("RUN END")=BPDM("RUN END")+.000001  ;p5 CR76084 run end can't be the same as run begin
 S Y=BPDM("RUN BEGIN") X ^DD("DD") S BPDM("X")=Y
 I $G(BPDMZRO) S Y=BPDM("RUN END") X ^DD("DD") S BPDM("Y")=Y
 I '$G(BPDMZRO) S Y=$$NOW^XLFDT() X ^DD("DD") S BPDM("Y")=Y
 W:'$D(ZTQUEUED) !!,"The inclusive dates for this run are ",BPDM("X")," through ",BPDM("Y"),"."
 K %,%H,%I,BPDM("RDFN"),BPDM("X"),BPDM("Y"),BPDM("LAST LOG"),BPDM("LAST BEGIN"),BPDM("Z"),BPDM("DATE")
 Q
 ;
FIRSTRUN ; FIRST RUN EVER (NO LOG ENTRY)
 ;I $D(ZTQUEUED),$D(BPDMO("SCHEDULED")) S BPDM("RUN BEGIN")=3110101,BPDM("FIRST RUN")=1 Q
 W !!,"No log entry.  First run ever assumed.",!
FRLP ;
 K DIR W ! S DIR(0)="D^::EP",DIR("A")="Enter Beginning Date for this Run" K DA D ^DIR K DIR
 I $D(DIRUT) S BPDMQFLG=99 Q
 I Y="" S BPDMQFLG=99 Q
 S BPDM("X")=Y
 D DATECHK Q:BPDMQFLG  G:Y="" FRLP
 S BPDM("RUN BEGIN")=Y
 S BPDM("FIRST RUN")=1
 Q
 ;
DATECHK ;
 I BPDM("X")="^" S BPDMQFLG=99 Q
 S %DT="PX",X=BPDM("X") D ^%DT I X="?" S Y="" Q
 I Y<0!(Y>DT)!(Y=DT) W !!,$S(Y>DT!(Y=DT):"  Current or future date not allowed!",1:"  Invalid date!") S Y=""
 Q
 ;
