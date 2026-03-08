BDWHREDO ; IHS/CMI/LAB - REDO A RUN ;
 ;;1.0;IHS DATA WAREHOUSE;**6,9,11**;JAN 24, 2006;Build 14
START ;
 D EN^XBVK("BDW")
 I $D(^BDWHTMP) W !!,"Previous run not completed." D  D EOJ Q
 .S DIR(0)="EO",DIR("A")="Press ENTER to continue" K DA D ^DIR K DIR
 S BDWO("RUN")="REDO" ;     Let ^BDWHRDRI know this is a 'REDO'
 S BDWO("RUN TYPE")="REX"
 D ^BDWHRDRI ;           
 I BDW("QFLG")=66 W:'$D(ZTQUEUED) !,"Contact your site manager.  ^BDWHTMP still exists." D  D EOJ Q
 .S DIR(0)="EO",DIR("A")="Press ENTER to continue" K DA D ^DIR K DIR
 I BDW("QFLG") D  D EOJ W !!,"Bye",!! Q
 .S DIR(0)="EO",DIR("A")="Press ENTER to continue" K DA D ^DIR K DIR
 D INIT ;               Get Log entry to redo
 I BDW("QFLG") D  D EOJ W !!,"Bye",!! Q
 .S DIR(0)="EO",DIR("A")="Press ENTER to continue" K DA D ^DIR K DIR
 D QUEUE^BDWHRDRI
 I BDW("QFLG") D EOJ W !!,"Bye",!! Q
 I $D(BDWO("QUEUE")) D EOJ W !!,"Okay your request is queued!",!! Q
 ;
EN ;EP FROM TASKMAN
 S BDWLOG=BDW("RUN LOG")
 S BDWCNT=$S('$D(ZTQUEUED):"X BDWCNT1  X BDWCNT2",1:"S BDWCNTR=BDWCNTR+1"),BDWCNT1="F BDWCNTL=1:1:$L(BDWCNTR)+1 W @BDWBS",BDWCNT2="S BDWCNTR=BDWCNTR+1 W BDWCNTR,"")"""
 D NOW^%DTC S BDW("RUN START")=%,BDW("MAIN TX DATE")=$P(%,".") K %,%H,%I
 S BDWT=$$PROD^XUPROD()
 D ^XBFMK S DA=BDWLOG,DIE="^BDWHLOG(",DR=".1////"_BDW("RUN START")_";.15///R"_";.22///1;.11///@"";1108///"_$S(BDWT:"P",1:"T") D ^DIE,^XBFMK
 S BDW("BT")=$HOROLOG
 D PROCESS ;            Generate transactions
 I BDW("QFLG") D:$D(ZTQUEUED) ABORT D EOJ Q
 D LOG^BDWHRDR ;                Update Log entry
 I BDW("QFLG") W:'$D(ZTQUEUED) !!,"Log error! ",BDW("QFLG") D:$D(ZTQUEUED) ABORT D EOJ Q
 ;I 'BDWTRXC,'$G(BDWTBLC) D  Q   ;NO PRESCRIPTIONS TO EXPORT
 ;.K ^BDWHTMP
 ;.D RUNTIME^BDWHRDR
 ;.S DA=BDWLOG,DIE="^BDWHLOG(",DR=".13////"_BDWRUN_";.11///@;.15////C" D ^DIE
 ;.S DA=BDWLOG,DIK="^BDWHLOG(" D IX^DIK K DA,DIK
 ;.D ^XBFMK
 ;.D EOJ
 D RUNTIME^BDWHRDR
 S BDWMSGT=""
 S BDWMSGT=$$DW1HTRLR^BDWHEVNT(BDWLOG)
 S ^BDWHTMP(BDWIEDST,BDWMSGT)=""
 S DA=BDW("RUN LOG"),DIE="^BDWHLOG(",DR=".13////"_BDWRUN_";.12////"_BDWMSGT_";.15///C" D ^DIE K DIE,DA,DR
 S DA=BDWLOG,DIK="^BDWHLOG(" D IX^DIK K DA,DIK
 I '$D(ZTQUEUED) S DIR(0)="EO",DIR("A")="DONE -- Press ENTER to Continue" K DA D ^DIR K DIR
 D EOJ
 Q
 ;
PROCESS ;
 ;clean out AEXP
 S X=0 F  S X=$O(^BDWHLOG("AEXP",X)) Q:X'=+X  D
 .S R="" F  S R=$O(^BDWHLOG("AEXP",X,R)) Q:R=""  D
 ..S I=0 F  S I=$O(^BDWHLOG("AEXP",X,R,BDW("RUN LOG"),I)) Q:I'=+I  D
 ...K ^BDWHLOG("AEXP",X,R,BDW("RUN LOG"),I)
 .Q
 K ^BDWHLOG(BDW("RUN LOG"),21)  ;clean out old data
 K ^BDWHLOG(BDW("RUN LOG"),41)
 ;GET BEGIN AND END DATES FOR RUN
 S BDW("RUN BEGIN")=$P(^BDWHLOG(BDWLOG,0),U,2)
 S BDW("RUN END")=$P(^BDWHLOG(BDWLOG,0),U,3)
 S BDWBLBD=$P($G(^BDWHLOG(BDW("RUN LOG"),11)),U,2)
 S BDWBLED=$P($G(^BDWHLOG(BDW("RUN LOG"),11)),U,3)
 D PROCESS^BDWHRDR
 Q
 ;
 ;
LOG ;
 W:'$D(ZTQUEUED) !!,BDWTOTHL," HL7 Messages were generated."
 W:'$D(ZTQUEUED) !,"Updating log entry."
 D NOW^%DTC S BDW("RUN STOP")=%
 S DA=BDWLOG,DIE="^BDWHLOG("
 S DR=".04////"_BDW("RUN STOP")_";.05////"_BDW("FPROC")_";.06////"_BDWSKIP_";.08///"_BDW("COUNT")_";1104////"_$G(BDWTBLC)_";1105///"_$S(BDWTOTHL:($G(BDWTOTHL)+2),1:BDWTOTHL) D ^DIE I $D(Y) S BDW("QFLG")=26 Q
 K DIE,DA,DR
 D AUDIT(BDWLOG)
 ;S DA=BDWLOG,DIE="^BDWHLOG(",DR=".13////"_BDWRUN D ^DIE I $D(Y) S BDW("QFLG")=26 Q
 K DR,DIE,DA,DIV,DIU
 S X=0 F  S X=$O(BDWHOPE(X)) Q:X'=+X  I BDWHOPE(X)="" S $P(^BDWSITE(1,21,X,0),U,3)=DT
 Q
AUDIT(LOG) ;-- lets put the audit in place
 N FDA,FERR,FIENS
 S FIENS="+2,"_LOG_","
 S FDA(90213.131,FIENS,.01)=$$NOW^XLFDT()
 S FDA(90213.131,FIENS,.02)=$G(DUZ)
 S FDA(90213.131,FIENS,.03)=$G(XQY)
 S FDA(90213.131,FIENS,.04)=$S('BDW("QFLG"):"S",1:"F")
 D UPDATE^DIE("","FDA","FIENS","FERR(1)")
 Q
INIT ;
 Q:BDW("QFLG")
 W !,"Type a ?? and press enter at the following prompt to view a list of ORIGINAL RUN DATES.",!,"Or, if you know the original run date you can enter it in the format MM/DD/YY:  e.g. 2/26/19",!
 S DIC="^BDWHLOG(",DIC(0)="AEQ",DIC("S")="I $P(^(0),U,9)=DUZ(2),$P(^(0),U,15)=""C""" D ^DIC K DIC
 I Y<0 S BDW("QFLG")=99 Q
 S (BDW("RUN LOG"),BDWLOG)=+Y
 ;
 S X=^BDWHLOG(BDW("RUN LOG"),0),BDW("RUN BEGIN")=$P(X,U,2),BDW("RUN END")=$P(X,U,3),BDW("COUNT")=$P(X,U,8)
 S Y=BDW("RUN BEGIN") S BDW("PRINT BEGIN")=$$UP^XLFSTR($$FMTE^XLFDT(Y))
 S Y=BDW("RUN END") S BDW("PRINT END")=$$UP^XLFSTR($$FMTE^XLFDT(Y))
 W !!,"Log entry ",BDW("RUN LOG")," was for date range ",BDW("PRINT BEGIN")," through",!,BDW("PRINT END")," and exported ",BDW("COUNT")," prescription fills/refills."
 S BDWBLBD=$P($G(^BDWHLOG(BDW("RUN LOG"),11)),U,2)
 S BDWBLED=$P($G(^BDWHLOG(BDW("RUN LOG"),11)),U,3)
 S X=$P($G(^BDWHLOG(BDW("RUN LOG"),11)),U,4)
 K BDWHOPE S Y=0,G=0 F  S Y=$O(^BDWSITE(1,21,Y)) Q:Y'=+Y  D
 .I $P(^BDWSITE(1,21,Y,0),U,3)=$P(^BDWHLOG(BDW("RUN LOG"),0),U,1),$P(^BDWSITE(1,21,Y,0),U,2) S BDWHOPE(Y)="",G=1 Q
 .I $P(^BDWSITE(1,21,Y,0),U,3)="",$P(^BDWSITE(1,21,Y,0),U,2) S BDWHOPE(Y)="",G=1 Q
 .I $P(^BDWSITE(1,21,Y,0),U,2) S BDWHOPE(Y)=$P(^BDWSITE(1,21,Y,0),U,3)
 I BDWBLBD,G D
 .W !!,"In addition, a backload of controlled substances for ",$$UP^XLFSTR($$FMTE^XLFDT(BDWBLBD))," through ",!,$$UP^XLFSTR($$FMTE^XLFDT(BDWBLED))," will be performed for the following pharmacies:"
 .S X=0 F  S X=$O(BDWHOPE(X)) Q:X'=+X  I BDWHOPE(X)="" W !?10,$P(^PS(59,X,0),U,1)
 ;
 ;W !!,"This option will re-generate the Data Warehouse Records."
RDD ;
 S DIR(0)="Y",DIR("A")="Do you want to regenerate the HL7 messages for this run",DIR("B")="N" K DA D ^DIR K DIR
 I $D(DIRUT)!'Y S BDW("QFLG")=99 Q
 S BDW("COUNT")=0
 Q
ABORT ; ABNORMAL TERMINATION
 I $D(BDW("RUN LOG")) S BDW("QFLG1")=$O(^BDWERRC("B",BDW("QFLG"),"")),DA=BDW("RUN LOG"),DIE="^BDWHLOG(",DR=".15///F;.16////"_BDW("QFLG1")
 I $D(ZTQUEUED) D ERRBULL^BDWRDRI3,EOJ Q
 ;W !!,"Abnormal termination!!  QFLG=",BDW("QFLG")
 S DIR(0)="EO",DIR("A")="Press ENTER to continue" K DA D ^DIR K DIR
 Q
 ;
EOJ ;
 D EN^XBVK("BDW")
 I $D(ZTQUEUED) S ZTREQ="@"
 Q
