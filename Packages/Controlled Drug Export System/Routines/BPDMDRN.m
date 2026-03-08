BPDMDRN ; IHS/CMI/LAB - MAIN DRIVER FOR PDM REPORT ;
 ;;2.0;CONTROLLED DRUG EXPORT SYSTEM;**1,4,6,7**;NOV 15, 2011;Build 51
 ;
START ;
 D EN^XBVK("BPDM")
 S BPDMPTYP="P"
START1 ;
 D HOME^%ZIS S BPDMBS=$S('$D(ZTQUEUED):IOBS,1:"")
 S BPDMQFLG=0
 S (BPDMERRC,BPDMCNT,BPDMRCNT)=0
 S BPDMRTYP=2  ;DATE RANGE export
 D BEGIN
 I $G(BPDMQFLG) D:$D(ZTQUEUED) BULL D EOJ Q
 I $G(BPDM("RUN BEGIN"))="" D EOJ Q
 I $G(BPDM("RUN END"))="" D EOJ Q
 ;
DRIVER ;called from TSKMN+2
 S BPDM("BT")=$H
 D NOW^%DTC S BPDM("RUN START")=%,BPDM("MAIN TX DATE")=$P(%,".") K %,%H,%I
 S BPDMCNT=$S('$D(ZTQUEUED):"X BPDMCNT1  X BPDMCNT2",1:"S BPDMCNTR=BPDMCNTR+1"),BPDMCNT1="F BPDMCNTL=1:1:$L(BPDMCNTR)+1 W @BPDMBS",BPDMCNT2="S BPDMCNTR=BPDMCNTR+1 W BPDMCNTR,"")"""
 D PROCESS^BPDMDR1N ;            Generate transactions
 ;
 I BPDMQFLG D BULL,EOJ Q
 ;
 I '$D(^TMP($J,"EXPORT")) D  ;run zero report if no exportable prescriptions
 . Q:'$$GET1^DIQ(9002315.01,BPDMSITE,1106,"I")  ;quit if not generating zero report
 . Q:$P(BPDM("RUN BEGIN"),".")=DT
 . S BPDMZRO=1
 . W:'$D(ZTQUEUED) !,"There are no prescriptions for this date range."
 . K ^BPDMLOG("ABF",(9999999.999999-BPDM("RUN BEGIN")),BPDMOSIT,BPDMRTYP,BPDM("RUN LOG"))
 . S X1=$P(BPDM("RUN END"),"."),X2=-1 D C^%DTC S BPDMZND=X
 . D ZEROSET^BPDMZERO($P(BPDM("RUN BEGIN"),"."),$S($P(BPDM("RUN END"),".")=DT:BPDMZND,1:$P(BPDM("RUN END"),".")))
 . D UPLOG^BPDMRDRN(4)
 W !!,"Writing out transaction file...."
 I '$G(BPDMZRO),'$D(^TMP($J,"EXPORT")) D  Q
 . W:'$D(ZTQUEUED) !,"No prescriptions to export, file and log not created."
 . D DELLOG^BPDMDR
 . D EOJ
 I '$G(BPDMZRO) D
 . D TAPE^BPDMDR1N
 I $G(BPDMZRO) D
 . D RPT^BPDMZERO  ;do zero report
 . S BPDM("REC COUNT")=0
 I BPDMQFLG D BULL,EOJ Q
 W !!,"Updating Log Entry...."
 D LOG^BPDMDR1N  ;20230614 p7 87521
 I $G(BPDMNOFI) D  Q  ;20220223 patch 6 73211
 . ;I '$D(ZTQUEUED) W !,"Error in file export, failed to create export file"
 . D EOJ
 ;add code here to change verbiage if autosend 1107 field is set to yes, no autosend on date range export, but leave code in for future
 ;S BPDMAUUP=$$GET1^DIQ(9002315.01,BPDMSITE,1107,"I")
 I $G(BPDMZRO) D
 . W !!,"No reportable prescriptions processed during export period. Zero report created."
 . ;I $G(BPDMAUUP) W !,"The file ",BPDMFILE," will auto upload to the state.",!
 . I '$G(BPDMAUUP) W !,"You must now send the file ",BPDMFILE," to the state.",!
 I '$G(BPDMAUUP),'$G(BPDMZRO) W !!,"Successfully completed...you must now send the file ",BPDMFILE," to the state.",!
 ;I $G(BPDMAUUP),'$G(BPDMZRO) W !!,"Successfully completed...the file ",BPDMFILE," will auto upload to the state.",!
 D EOJ
 Q
 ;
TEST ;EP
 D EN^XBVK("BPDM")
 S BPDMPTYP="T"
 G START1
DATE(D) ;EP
 I $G(D)="" Q ""
 Q (1700+$E(D,1,3))_$E(D,4,5)_$E(D,6,7)
LZERO(V,L) ;EP - left zero fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
EOJ ; EOJ
 D ^XBFMK
 D EN^XBVK("BPDM")
 K ^TMP($J)
PAUSE ;EP
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
CALLDIE ;EP
 Q:'$D(DA)
 Q:'$D(DIE)
 Q:'$D(DR)
 D ^DIE
 D ^XBFMK
 K DLAYGO,DIADD
 Q
 ;;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
BEGIN ;
 S BPDMQFLG=""
 D INFORM ;      Let operator know what is going on.
 D GETSITE^BPDMCHKN
 Q:BPDMSITE=""  ;get site to do the export for
 D CHECK^BPDMCHKN
 I BPDMQFLG D BULL Q
GETDATES ;
 W !!!,"Please enter the date range of prescription release dates.",!
BD ;
 S DIR(0)="D^::EP",DIR("A")="Enter Beginning Date to export",DIR("?")="Enter the beginning prescription release date." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 S BPDM("RUN BEGIN")=Y
ED ;
 S DIR(0)="DA^::EP",DIR("A")="Enter Ending Date to export:  " D ^DIR K DIR,DA S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 I Y<BPDM("RUN BEGIN") W !,"Ending date must be greater than or equal to beginning date!" G ED
 S BPDM("RUN END")=Y
 S X1=BPDM("RUN BEGIN"),X2=-1 D C^%DTC S BPDMSD=X
 ;D CHKAL^BPDMCHKN ;    Check FILE 52  xref for date range
 ;I BPDMQFLG D  Q
 ;. S BPDMQFLG=""
 ;. S BPDMZRO=1
 ;. S BPDMRTYP=4
 ;. D GENLOG^BPDMCHKN
 ;. D ZEROSET^BPDMZERO(BPDM("RUN BEGIN"),BPDM("RUN END"))
 ;. D ZERO^BPDMRDRN
 D CONFIRM^BPDMCHKN ;     Get ok from operator.
 I BPDMQFLG D BULL Q
 S BPDM("RUN BEGIN")=BPDM("RUN BEGIN")_".000001",BPDM("RUN END")=BPDM("RUN END")_".235959"
 I $$GET1^DIQ(9002315.01,BPDMSITE,1108,"I") S BPDMPTYP="T"  ;maw beta testing
 D GENLOG^BPDMCHKN ;      Generate new log entry.
 Q
 ;
INFORM ;
 W !!,"Create Prescription Monitoring System transaction file for a DATE RANGE.",!!
 W !,"This option is used to create an export file of Prescription data."
 W !,"This option will allow you to create transaction file for date range you enter.",!
 W !,"This file will be sent as a ",$S(BPDMPTYP="T":"TEST",1:"PRODUCTION")," set of transactions.",!!
 Q
BULL ;EP - send bulletin to contact person
 ;write out errors or send bulletin with what is in ^TMP($J,"ERRORS"
 I $D(ZTQUEUED) D BULLT,DELLOG Q
 I $G(BPDMQMSG)="*** No reportable prescriptions processed during export period. File not created. ***" W !,BPDMQMSG,! Q  ;no need to display error, not really an error
 I $G(BPDMQMSG)["Date range not valid" W !,BPDMQMSG,! Q  ;no need to display errors
 W !!,"The following errors occurred in the data so the file cannot be sent."
 W !,"You must fix this data before sending a file."
 W !,"Please enter the device for printing the list of errors."
 S BPDMJ=$J
 S BPDMH=$H
 I $D(^TMP($J,"ERROR")) M ^XTMP("BPDMDR",BPDMJ,BPDMH,"ERROR")=^TMP($J,"ERROR")
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) Q
 I $G(Y)="B" D BROWSE Q
 S XBRP="PRINT^BPDMDR",XBRC="",XBNS="BPDM",XBRX=""
 D ^XBDBQUE
 I '$G(BPDMREDO) D DELLOG
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^BPDMDR"")"
 S XBNS="BPDM",XBRC="",XBRX="",XBIOP=0 D ^XBDBQUE
 D DELLOG
 Q
DELLOG ;
 Q:$G(BPDMREDO)  ;don't do this if in a redo IHS/CMI/LAB - patch 4
 Q:'$G(BPDM("RUN LOG"))  ;no log to delete
 S DA=BPDM("RUN LOG"),DIK="^BPDMLOG(" D ^DIK K DIK,DA
 Q
PRINT ;
 NEW BPDMPG,BPDMR,BPDMQUIT,BPDMY,BPDMRF
 S BPDMPG=0
 K BPDMQUIT
 D HEADER
 I $D(BPDMQMSG) W !!,BPDMQMSG,!
 I '$D(^XTMP("BPDMDR",BPDMJ,BPDMH,"ERROR")) W !!,"No Individual Prescription errors to Report." G END
 S BPDMR=0 F  S BPDMR=$O(^XTMP("BPDMDR",BPDMJ,BPDMH,"ERROR",BPDMR)) Q:BPDMR=""!($D(BPDMQUIT))  D
 .I $Y>(IOSL-4) D HEADER Q:$D(BPDMQUIT)
 .S BPDMY=^XTMP("BPDMDR",BPDMJ,BPDMH,"ERROR",BPDMR)
 .S BPDMRF=$P(BPDMY,U,3)
 .W !,$$VAL^XBDIQ1(52,BPDMR,.01),?14,$$HRN^AUPNPAT($P(^PSRX(BPDMR,0),U,2),DUZ(2),2),?27,$P(BPDMY,U,3)
 .W ?35,$$FMTE^XLFDT($S(BPDMRF:$P($G(^PSRX(BPDMR,1,BPDMRF,0)),U,1),1:$P($G(^PSRX(BPDMR,2)),U,2)))
 .W ?55,$$VAL^XBDIQ1(52,BPDMR,4)
 .W !?3,"DRUG: ",$$VAL^XBDIQ1(52,BPDMR,6),?43,"PHARMACIST: ",$$PHARM^BPDMUTL(BPDMR,BPDMRF)
 .W !?3,"ERROR: ",$P(BPDMY,U,2)
END K ^XTMP("BPDMDR",BPDMJ,BPDMH),BPDMJ,BPDMH
 Q
PER(N,D) ;return % of n/d
 I 'D Q "0%"
 NEW Z
 S Z=N/D,Z=Z*100,Z=$J(Z,3,0)
 Q $$STRIP^XLFSTR(Z," ")_"%"
C(X,X2,X3) ;
 D COMMA^%DTC
 Q $J($$STRIP^XLFSTR(X," "),7)
HEADER ;
 I 'BPDMPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BPDMQUIT="" Q
HEAD1 ;
 I BPDMPG W:$D(IOF) @IOF
 S BPDMPG=BPDMPG+1
 W !,$$CTR($$FMTE^XLFDT(DT),80),?70,"Page ",BPDMPG,!
 W $$CTR($$VAL^XBDIQ1(59,BPDMOSIT,.01),80),!
 W $$CTR("ERRORS ON CONTROLLED SUBSTANCE MONITORING EXPORT",80),!
 W $$CTR("Prescription Dates: "_$$FMTE^XLFDT($G(BPDM("RUN BEGIN")))_" - "_$$FMTE^XLFDT($G(BPDM("RUN END"))),80),!
 W !,$$CTR("THESE ERRORS MUST BE CORRECTED BEFORE AN EXPORT CAN BE DONE",80),!
 W "Prescription",?14,"HRN",?27,"Refill",?35,"Fill Date",?55,"PROVIDER",!
 W $$REPEAT^XLFSTR("-",79),!
 Q
BULLT ;EP - send bulletin with 
 ;
 I $G(BPDMQMSG)="*** No reportable prescriptions processed during export period. File not created. ***" Q  ;no need to display error, not really an error
 I $G(BPDMQMSG)["Date range not valid" D MSGNOERR Q  ;no need to display errors
 NEW XMSUB,XMDUZ,XMTEXT,XMY,DIFROM,BPDMJ,BPDMH,BPDMTEXT,C,X,XQA,XQAOPT,XQAROU,XQAFLG,XQATEXT,XQAMSG,XQAID
 KILL ^TMP($J,"BPDMBUL")
 S BPDMJ=$J
 S BPDMH=$H
 M ^XTMP("BPDMDR",BPDMJ,BPDMH)=^TMP($J)
 D WRITEMSG,GETRECIP
 ;Change following lines as desired
SUBJECT S XMSUB="PDM Export Failed - see this message for a list of errors"
SENDER S XMDUZ="Controlled Substance Monitoring System"
 S XMTEXT="^TMP($J,""BPDMBUL"",",XMY(DUZ)=""
 D ^XMD
 ;now send an alert
 ;S XQA(DUZ)=""
 ;I $$VALI^XBDIQ1(9002315.01,BPDMSITE,.11) S XQA($$VALI^XBDIQ1(9002315.01,BPDMSITE,.11))=""
 ;S XQAOPT=""
 ;S XQAROU=""
 ;S XQAFLG="D"
 ;K BPDMTEXT
 ;S (X,C)=0 F  S X=$O(^TMP($J,"BPDMBUL",X)) Q:X'=+X  S C=C+1,BPDMTEXT(C)=^TMP($J,"BPDMBUL",X)
 ;S XQATEXT="BPDMTEXT("
 ;S XQAMSG="Prescription Data Monitoring System Export FAILED. See Mailman Message errors."
 ;S XQAID="BPDM;"_DUZ_";"_$$NOW^XLFDT()
 ;D SETUP^XQALERT
 KILL ^TMP($J,"BPDMBUL"),BPDMTEXT
 Q
 ;
WRITEMSG ;
 D GUIR^XBLM("PRINT^BPDMDR","^TMP($J,""BPDMBUL"",")
 Q
 ;
GETRECIP ;
 ;* * * Define key below to identify recipients * * *
 ;
 NEW X,Y
 Q:'$P(^BPDMSITE(BPDMSITE,0),U,14)
 S Y=$P(^BPDMSITE(BPDMSITE,0),U,14)
 S X=0 F  S X=$O(^XMB(3.8,Y,1,X)) Q:X'=+X  D
 .S XMY($P(^XMB(3.8,Y,1,X,0),U,1))=""
 Q
MSGNOERR ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY,DIFROM,BPDMJ,BPDMH,BPDMTEXT,C,X,XQA,XQAOPT,XQAROU,XQAFLG,XQATEXT,XQAMSG,XQAID
 KILL ^TMP($J,"BPDMBUL")
 D GETRECIP
 ;Change following lines as desired
 S XMSUB="PDM Export - No export - "_BPDMQMSG
 S XMDUZ="Controlled Substance Monitoring System"
 S BPDMTEXT(1)="The Prescription Drug Monitoring System Export ran to completion."
 S BPDMTEXT(2)="No file was generated due to:  "_BPDMQMSG
 S XMTEXT="BPDMTEXT(",XMY(DUZ)=""
 D ^XMD
 ;now send an alert
 ;S XQA(DUZ)=""
 ;I $$VALI^XBDIQ1(9002315.01,BPDMSITE,.11) S XQA($$VALI^XBDIQ1(9002315.01,BPDMSITE,.11))=""
 ;S XQAOPT=""
 ;S XQAROU=""
 ;S XQAFLG="D"
 ;K BPDMTEXT
 ;S BPDMTEXT(1)="The Prescription Drug Monitoring System Export ran to completion."
 ;S BPDMTEXT(2)="No file was generated due to:  "_BPDMQMSG
 ;S XQATEXT="BPDMTEXT("
 ;S XQAMSG="Prescription Data Monitoring System Export ran to completion.  Message: "_$G(BPDMQMSG)_". "
 ;S XQAID="BPDM;"_DUZ_";"_$$NOW^XLFDT()
 ;D SETUP^XQALERT
 KILL ^TMP($J,"BPDMBUL"),BPDMTEXT
 Q
