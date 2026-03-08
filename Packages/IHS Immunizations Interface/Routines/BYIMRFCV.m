BYIMRFCV ; IHS/CMI/LAB - Flag covid vaccines for export by cvx;
 ;;3.0;BYIM IMMUNIZATION DATA EXCHANGE;**2,3,6**;AUG 20, 2020;Build 739
 ;
 ;
 Q  ;NOT AT TOP
 ;
START ;EP
 I '$G(DUZ(2))!('$G(IOM)) W !!,"Please log in to kernel prior to running this utility.  (D ^XUP)" Q
 W:$D(IOF) @IOF
 W !,$$CTR("Flag COVID Immunizations to send to CAS by CVX Code",80),!
 W !,"This option is used to flag all COVID immunizations for user specified CVX",!
 W "code(s) to be sent to CAS on the next export.",!!
 S BYIMOK=1  ;all okay
 S BYIMDUZ=$$DUZ^BYIMIMM()
 I '$G(BYIMDUZ) G CVX  ;NO PARAMETERS TO CHECK
 S CVDDA=0
 K BYIMFIX
 S X=""
 F  S X=$O(^BYIMPARA(BYIMDUZ,3,"B",X)) Q:X=""!CVDDA  D:X["COVID"
 .S CVDDA=$O(^BYIMPARA(BYIMDUZ,3,"B",X,0))
 I '$G(CVDDA) G CVX  ;NO COVID STATE TO CHECK
 S X=0 F  S X=$O(^BYIMPARA(BYIMDUZ,3,CVDDA,5,X)) Q:X'=+X  I $P(^BYIMPARA(BYIMDUZ,3,CVDDA,5,X,0),U,2)="" S BYIMFIX(X)="",BYIMOK=0
 I BYIMOK=1 G CVX
 W !!,"The following locations in the COVID State entry in the IZ PARAMETERS file"
 W !,"have a missing STATE IIS FACILITY CODE.  This resend option cannot be run"
 W !,"until the missing code(s) have been entered. For the COVID state entry, the"
 W !,"ASUFAC associated with the inventory should be used as the "
 W !,"STATE IIS FACILITY CODE.  The option to use is on the "
 W !,"BYIM main menu ==> SET  ==> IZAD ==> Edit the COVID State entry"
 W !,"==> Add COVID specific IIS code(s)."
 W !,"You will need the BYIMZ IZ ADDITIONAL STATES security key to perform"
 W !,"this action.",!
 S X=0 F  S X=$O(BYIMFIX(X)) Q:X'=+X  W !?5,$P($G(^DIC(4,X,0)),U,1),"  ("_X_")"
 W !!
 K DIR S DIR(0)="EO",DIR("A")="Press Enter to continue." D ^DIR K DIR
 D EXIT
 Q
CVX ;
 K BYIMCVX
CVX1 ;
 S DIR(0)="S^A:ALL COVID Vaccines;S:Selected COVID Vaccines (by CVX Code)",DIR("A")="Select which Vaccines to export",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 S BYIMEXT=Y
 I Y="A" S X=0 F  S X=$O(^AUTTIMM(X)) Q:X'=+X  I $$VAL^XBDIQ1(9999999.14,X,.09)="COVID" S BYIMCVX(X)=$$VAL^XBDIQ1(9999999.14,X,.03)
 I Y="A" G CONT
CVX2 ;
 S BYIMC="",BYIM15P=""
 S X=0 F  S X=$O(^AUTTIMM(X)) Q:X'=+X  I $$VAL^XBDIQ1(9999999.14,X,.09)="COVID" S BYIMPCVX($$VAL^XBDIQ1(9999999.14,X,.03))=X
 F  S BYIMC=$O(BYIMPCVX(BYIMC)) Q:BYIMC=""  D
 .W ! S DIR(0)="Y",DIR("A")="Flag CVX "_BYIMC_" Immunizations for export",DIR("B")="N" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) Q
 .I 'Y Q
 .I Y S BYIMCVX(BYIMPCVX(BYIMC))=BYIMC S:BYIM15P]"" BYIM15P=BYIM15P_"," S BYIM15P=BYIM15P_BYIMC
 I '$D(BYIMCVX) W !!,"No CVX codes selected.",! G CVX
CONT ;
 W !!,"Immunization entries with the following CVX codes will be flagged for export:",!
 S BYIMX=0 F  S BYIMX=$O(BYIMCVX(BYIMX)) Q:BYIMX=""  W !?5,"CVX: ",BYIMCVX(BYIMX),?15,$$VAL^XBDIQ1(9999999.14,BYIMX,.02),?30,"(",$$CNT(BYIMX)," Immunizations)"
 W !!
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G EXIT
 I 'Y G EXIT
 ;V3.0 PATCH 6 - FID 83363 EXPORT FOR SELECTED STATES
 W !!?5,"If you want to restrict this export so it is only sent to COVID/CAS"
 W !?5,"please go back to the BYIM main menu, and select:"
 W !!?10,"'IZDE  Start Immunization Data Export"
 W !!?5,"Set the '...given since' date as at least one date before 'today'"
 W !?5,"and set the '...given after' date as 'today's' date."
 W !!?5,"You will then have the opportunity to select the state(s) to which"
 W !?5,"to send the export and only send to the 'COVID' state."
 ;V3.0 PATCH 6 - FID 83363 END
 D SENDIMM
EXIT ;clean up and exit
 D EN^XBVK("BYIM")
 D ^XBFMK
 Q
 ;
CNT(X) ;
 NEW Y,C
 S C=0
 S Y=0 F  S Y=$O(^AUPNVIMM("B",X,Y)) Q:Y'=+Y  I $$ACT(Y) S C=C+1
 Q C
SENDIMM ;EP - CALLED WHEN ALL LOT ISSUES HAVE BEEN CORRECTED.
SEND ;EP;SEND/RE-SEND COVID IMM's
 ;
 ;PATCH 3 - CR-12421 CORRECT ISSUE WITH COVID EXPORT
 D NOW^%DTC
 S NOW=%
 ;
 ;SET XX ARRAY OF COVID IMMUNIZATION IEN's
 ;
 ;S IDA=0 S IDA=$O(BYIMCVX(IDA)) Q:'IDA  D
 S IDA=0 F  S IDA=$O(BYIMCVX(IDA)) Q:'IDA  D
 .S IMDA=0
 .F  S IMDA=$O(^AUPNVIMM("B",IDA,IMDA)) Q:'IMDA  D SIMM(IMDA)
 ;PATCH 3 - C4-12421 END
 ;
SENDE ;
 ;SET .15 OF COVID STATE
 S BYIMDUZ=$$DUZ^BYIMIMM()
 Q:'$G(BYIMDUZ)
 S CVDDA=0
 S X=""
 F  S X=$O(^BYIMPARA(BYIMDUZ,3,"B",X)) Q:X=""!CVDDA  D:X["COVID"
 .S CVDDA=$O(^BYIMPARA(BYIMDUZ,3,"B",X,0))
 Q:'$G(CVDDA)
 I BYIMEXT="A" S $P(^BYIMPARA(BYIMDUZ,3,CVDDA,0),U,15)=$P($$FMTHL7^XLFDT($$NOW^XLFDT),"-")_":All"
 ;PATCH 3 - CR-12421 CORRECT ISSUE WITH COVID EXPORT
 I BYIMEXT'="A" S $P(^BYIMPARA(BYIMDUZ,3,CVDDA,0),U,15)=$P($$FMTHL7^XLFDT($$NOW^XLFDT),"-")_":"_BYIM15P_":U"
 ;PATCH 3 - C4-12421 END
 W !!
 K DIR S DIR(0)="EO",DIR("A")="Process complete. Press Enter to continue." D ^DIR K DIR Q
 Q
 ;=====
 ;
SIMM(IMDA) ;SET 1218 TO 'NOW' FOR V IMM IDENTIFIED AS NEEDING TO BE SENT/RE-SENT
 ;
 Q:'$$ACT(IMDA)
 S VDA=$P($G(^AUPNVIMM(IMDA,0)),U,3),P=$P(^(0),U,2)
 Q:'VDA!'P
 S ^AUPNVSIT("APCIS",$P(NOW,"."),VDA)=""
 S $P(^AUPNVIMM(IMDA,12),U,18)=NOW
 S $P(^AUPNVIMM(IMDA,12),U,19)=.5
 S ^BYIMTMP("RE-SEND",NOW,P,VDA,IMDA)=""
 Q
 ;=====
 ;
ACT(IMDA) ;
 ;VDA = AUPNVSIT IEN
 N X,ACT,IO,VO,DFN
 S X=0
 S I0=$G(^AUPNVIMM(IMDA,0))
 S V0=$G(^AUPNVSIT(+$P(I0,U,3),0))
 S DFN=$P(I0,U,2)
 S ACT=$P(V0,U,7)
 I ACT]"","AHIOSR"[ACT S X=1
 I DFN,$$DEMO^BYIMIMM2(DFN) S X=0
 Q X
 ;=====
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;
STATREP ;EP;DISPLAY EXPORT STATS
 N QUIT
 S QUIT=0
 F  D SR Q:QUIT
 K QUIT
 Q
 ;=====
 ;
SR ;SETUP AND RUN STAT REPORT
 D HEADER
 D DATES
 Q:'$G(START)!'$G(END)
 S BYIMRTN="PRINT^BYIMRFCV"
 D ZIS^BYIMXIS
 Q
 ;=====
 ;
PRINT ;EP;PRINT STAT REPORT
 D IZDATA
 D IZRT
 Q
 ;=====
 ;
IZDATA D PATH^BYIMIMM
 S ST=+$P($G(^BYIMPARA($$DUZ^BYIMIMM(),0)),U,14)
 S OPATH=$G(OPATH(ST))
 Q:OPATH=""
 S LM=$S(OPATH["\":"\",1:"/")
 S LN=$L(OPATH,LM)-1
 S SPATH=$P(OPATH,LM,1,LN)_LM_"backup"_LM
 S RPATH=$P(OPATH,LM,1,LN)_LM_"response"_LM
 S ST=START+17000000
 S ED=END+17000000
 K SDIR
 S SDIR=$$LIST^%ZISH(SPATH,"izdata*"_$E(ST,1,4)_"*",.SDIR)
 K RDIR
 S RDIR=$$LIST^%ZISH(RPATH,"izdata*"_$E(ST,1,4)_"*",.RDIR)
 S SJ=0
 S SDIR=0
 F  S SDIR=$O(SDIR(SDIR)) Q:'SDIR  D
 .S SN=SDIR(SDIR)
 .S X=$P(SN,"_",3)
 .Q:X<ST
 .Q:X>EN
 .S SJ=SJ+1
 .S SN(SN)=""
 S RJ=0
 S RDIR=0
 F  S RDIR=$O(RDIR(RDIR)) Q:'RDIR  D
 .S RN=RDIR(RDIR)
 .S X=$P(RN,"_",3)
 .Q:X<ST
 .Q:X>EN
 .S RJ=RJ+1
 .S RN(RN)=""
 .I $D(SN(RN)) K RN(RN),SN(RN)
 W !,"Batch Files sent....: ",SN
 W !,"Batch File responses: ",RN
 I $O(SN(""))]"" D
 .W !!?5,"Files sent for which no response received: ",!
 .S X=""
 .F  S X=$O(SN(X)) Q:X=""  W !?10,X
 D PAUSE^BYIMIMM6
 Q
 ;=====
 ;
IZRT ;QUERY/RESPONSE COUNTS
 N QBP,RSP,MISS1,MISS2,ST,EN,STX,RTDA,R0,T,SQ,XX
 S (QBP,RSP)=0
 S (MISS1,MISS2)=0
 S ST=START-.001
 S EN=END+.9999
 S STX=START
 F  S STX=$O(^BYIMRT("DT",STX)) Q:'STX!(STX>END)  D
 .S RTDA=0
 .F  S RTDA=$O(^BYIMRT("DT",STX,RTDA)) Q:'RTDA  D
 ..S R0=$G(^BYIMRT(RTDA,0))
 ..S T=$P(R0,U,2)
 ..Q:"QBPRSP"'[T
 ..S SQ=$S(T="QBP":1,1:2)
 ..S ^BYIMTMP("BYIM STRP",$P(R0,U),SQ)=""
 ..S @T=@T+1
 S XX=""
 F  S XX=$O(^BYIMTMP("BYIM STRP",XX)) Q:XX=""  D
 .I $D(^BYIMTMP("BYIM STRP",XX,1)),'$D(^BYIMTMP("BYIM STRP",XX,2)) S MISS2=MISS2+1
 .I '$D(^BYIMTMP("BYIM STRP",XX,1)),$D(^BYIMTMP("BYIM STRP",XX,2)) S MISS1=MISS1+1
 .I $D(^BYIMTMP("BYIM STRP",XX,1)),$D(^BYIMTMP("BYIM STRP",XX,2)) K ^BYIMTMP("BYIM STRP",XX)
 W !,"Queries sent......: ",QBP
 W !,"Responses received: ",RSP
 I $D(^BYIMTMP("BYIM STRP")) D
 .W !!?5,"Queries sent for which no response was received: ",!
 .S X=""
 ;.F  S X=$O(^BYIMTMP("BYIM STRP",X)) D
 D PAUSE^BYIMIMM6
 K ^BYIMTMP("BYIM STRP")
 Q
 ;=====
 ;
HEADER ;STAT REPORT HEADER
 W @IOF
 W !?10,"Data Exchange Batch and Query/Response Transmission Stats"
 W !!?10,"Select the beginning and ending dates for the report"
 Q
 ;=====
 ;
DATES ;SELECT BEGIN AND END DATES
 K DIR
 S DIR(0)="DO^::EP"
 S DIR("A")="     Start date for report"
 W !!
 D ^DIR
 K DIR
 I Y'?7N D  Q
 .W !!,"No start date selected."
 .D PAUSE^BYIMIMM6
 .S QUIT=1
 S START=Y
 S DIR(0)="DO^::EP"
 S DIR("A")="       End date for report"
 W !!
 D ^DIR
 K DIR
 I Y'?7N D  Q
 .W !!,"No end date selected."
 .D PAUSE^BYIMIMM6
 .S QUIT=1
 S END=Y
 I $E(START,1,3)'=$E(END,1,3) D
 .W !!?10,"For the data exchange integrity report,"
 .W !?10,"the beginning and ending dates must be within the same year."
 .D PAUSE^BYIMIMM
 .K START,END
 Q
 ;=====
 ;
