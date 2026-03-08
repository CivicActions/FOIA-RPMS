BYIMRWT ;IHS/CIM/THL - IMMUNIZATION DATA EXCHANGE;
 ;;3.0;BYIM IMMUNIZATION DATA EXCHANGE;**5**;AUG 20, 2020;Build 644
 ;
 ;----
EN ;EP;PROCESS RWT
 N QUIT,SCNT,RCNT,QBP,RSP,QDTS,QDTE,QDT,QDA,Q0
 N FN,SDA,SDA0,TYPE,SLAST,RLAST
 N FILE,APATH,DEL,SPATH,RPATH,NOW,QDTS,QDTE
 N TYPE,LIST,SCNT,LX,FN,FDT,RCNT
 D STAT
 S QUIT=0
 F  D EN1 Q:QUIT
 Q
 ;=====
 ;
EN1 ;EP;SETUP RWT REPORT
 S BYIMDUZ=$$DUZ^BYIMIMM()
 S ASUFAC=$P($G(^AUTTLOC(BYIMDUZ,0)),U,10)
 D PATH^BYIMIMM
 I $D(ZTQUEUED),'BYIMDUZ!'ASUFAC S QUIT=1 Q
 I '$D(ZTQUEUED),'BYIMDUZ!'ASUFAC D  Q
 .W:'BYIMDUZ !!,"The BYIM setup for the primary facility could not be found."
 .W:'ASUFAC !!,"The ASUFAC for ",$P($G(^DIC(BYIMDUZ,0)),U)," could not be found."
 .W !,"Check the BYIM setup for the Primary data exchange facility."
 .H 2
 .S QUIT=1
 S QUIT=0
 S (YR,QT)=""
 D QT
 I '$G(QT)!'$G(YR)!QUIT S QUIT=1 Q
 S Y=0
 S RERUN=""
 S ST=+$O(^BYIMRWT("SENT",YR,QT,0))
 I '$G(^BYIMRWT("SENT",YR,QT,ST,"TOTAL")) S RERUN=1
 I '$D(ZTQUEUED),$G(^BYIMRWT("SENT",YR,QT,ST,"TOTAL")) D
 .D DISPLAY(ST)
 .S QUIT=0
 .S DIR(0)="Y0"
 .S DIR("A")="Re-run report for the "_QTD_" again"
 .S DIR("B")="NO"
 .W !!
 .D ^DIR
 .S:Y RERUN=1
 .D NOW^%DTC
 .S NOW=%
 S ZTIO=""
 S ZTDTC=$H
 S BYIMYR=YR
 S BYIMQRT=QT
 F X="BYIMQRT","BYIMYR","NOW","RERUN" S ZTSAVE(X)=@X
 S BYIMRTN="RWTP^BYIMRWT"
 D ZIS^BYIMXIS
 Q
 ;=====
 ;
RWTP ;EP;TO PRINT RWT
 S NOW=$G(ZTSAVE("NOW"))
 S YR=$G(ZTSAVE("BYIMYR"))
 S QT=$G(ZTSAVE("BYIMQRT"))
 Q:'NOW!'YR!'QT
 D LISTS
 Q:$D(ZTQUEUED)
 W !!
 D PAUSE^BYIMIMM6
 Q
 ;=====
 ;
QT ;GET YEAR AND QUARTER
 W @IOF
 W !?10,"Enter the YEAR and Quarter for the RWT"
 W !!?10,"Please enter the YEAR in 4 character 'YYYY' format"
 K DIR
 S DIR(0)="NO:4"
 S DIR("A")="Year for RWT report"
 W !
 D ^DIR
 K DIR
 I X="" S QUIT=1 Q
 I X'?4N D  G QT
 .W !!,"Specify the year for the report in 4 number format."
 S YR=X
 S DIR(0)="SO^1:First Quarter  Jan 1 to Mar 31;2:Second Quarter Apr 1 to Jun 30;3:Third quarter  Jul 1 to Sep 30;4:Fourth quarter Oct 1 to Dec 31"
 S DIR("A")="Which quarter"
 W !
 D ^DIR
 K DIR
 Q:'Y
 S QT=Y
 D NOW^%DTC
 S NOW=%
 Q
 ;=====
 ;
LISTS ;GET LISTS
 D PATH^BYIMIMM
 S BYIMDUZ=$$DUZ^BYIMIMM()
 S ASUFAC=$P($G(^AUTTLOC(BYIMDUZ,0)),U,10)
 S FILE="izdata_"_ASUFAC_"_"_YR_"*"
 Q:'ASUFAC
 S ST=0
 F  S ST=$O(OPATH(ST)) Q:'ST  I ST'=56 D L1(ST)
 Q
 ;=====
 ;
L1(ST) ;STATE SPECIFIC
 S APATH=$G(OPATH(ST))
 Q:APATH=""!(APATH["COVID")!(APATH["covid")
 S DEL=$S(APATH["\":"\",1:"/")
 S SPATH=$P(APATH,DEL,1,$L(APATH,DEL)-2)
 S SPATH=SPATH_DEL_"sent"_DEL
 S RPATH=$G(IPATH(ST))
 S QDTS=YR_$S(QT=1:"01",QT=2:"04",QT=3:"07",1:10)_"00"
 S QDTE=YR_$S(QT=1:"03",QT=2:"06",QT=3:"09",1:12)_"31.99"
 D SLIST(SPATH,YR,QT,ST)
 D RLIST(RPATH,YR,QT,ST)
 D DISPLAY(ST)
 D PAUSE^BYIMIMM6
 Q
 ;=====
 ;
DISPLAY(ST) ;DISPLAY STATE SPECIFIC RWT SUMMARY
 D STATS(ST)
 W @IOF
 W !?5,"Real World Summary for : ",$P($G(^DIC(5,+ST,0)),U)
 S QTD=$S(QT=1:"First Quarter",QT=2:"Second Quarter",QT=3:"Third Quarter",1:"Fourth Quarter")_" of "_YR
 W !!?10,QTD
 W:$G(RUND)]"" RUND
 W !!?10,"Total number of daily exports sent...: ",SCNT
 W !?10,"Total number of daily responses rec'd: ",RCNT
 W !?10,"Percent responses rec'd/exports sent.: "
 W:RCNT&SCNT $P((RCNT/SCNT)*100,".")," %"
 W !!?10,"Total number of queries sent.........: ",QBP
 W !?10,"Total number of responses rec'd......: ",RSP
 W !?10,"Percent responses rec'd/queries sent.: "
 W:QBP&RSP $P((QBP/RSP)*100,".")," %"
 Q:'$O(STAT(ST,0))
 W !!?10,"Current data exchange status:"
 W !?15,"Most recent daily export..: ",$G(STAT(ST,1))
 W !?15,"Most recent daily response: ",$G(STAT(ST,2))
 W !?15,"Most recent query.........: ",$G(STAT(ST,3))
 W !?15,"Most recent query response: ",$G(STAT(ST,4))
 Q
 ;=====
 ;
SLIST(SPATH,YR,QT,ST) ;GET LIST OF EXPORTS SENT
 K LIST
 S TYPE=1
 S LIST=$$LIST^%ZISH(SPATH,FILE,.LIST)
 S SCNT=0
 S LX=0
 F  S LX=$O(LIST(LX)) Q:'LX  S FN=LIST(LX) D:FN'["_test"
 .S FDT=$P(FN,"_",3)
 .I FDT>QDTS,FDT<QDTE D
 ..S SCNT=SCNT+1
 ..S ^BYIMRWT("SENT",YR,QT,ST,SCNT,NOW)=FN
 ..S SLAST=FN
 ..D:RERUN FILE(FN,TYPE,ST)
 S ^BYIMRWT("SENT",YR,QT,ST,"TOTAL")=SCNT_U_NOW
 Q
 ;====
 ;
RLIST(RPATH,YR,QT,ST) ;GET LIST OF EXPORTS SENT
 K LIST
 S TYPE=2
 S LIST=$$LIST^%ZISH(RPATH,FILE,.LIST)
 S RCNT=0
 S LX=0
 F  S LX=$O(LIST(LX)) Q:'LX  S FN=LIST(LX) D:FN'["_test"
 .S FDT=$P(FN,"_",3)
 .I FDT>QDTS,FDT<QDTE D
 ..S RCNT=RCNT+1
 ..S ^BYIMRWT("RESP",YR,QT,ST,RCNT,NOW)=FN
 ..S RLAST=FN
 ..D:RERUN FILE(FN,TYPE,ST)
 S ^BYIMRWT("RESP",YR,QT,ST,"TOTAL")=RCNT_U_NOW
 Q
 ;====
 ;
STATS(ST) ;CALCULATED DAILY EXPORT/RESPONSE AND QUERY/RESPONSE
 S SCNT=+$G(^BYIMRWT("SENT",YR,QT,ST,"TOTAL"))
 S RCNT=+$G(^BYIMRWT("RESP",YR,QT,ST,"TOTAL"))
 S RUND=$P($G(^BYIMRWT("SENT",YR,QT,ST,"TOTAL")),U,2)
 D:RUND["."
 .S RUNT=$P(RUND,".",2)
 .S RUNT=RUNT_$E("000000",1,6-($L(RUNT)))
 .S RUND=$P(RUND,".")+17000000
 .S RUND=$E(RUND,5,6)_"/"_$E(RUND,7,8)_"/"_$E(RUND,1,4)
 .S RUND=" (Last run on: "_RUND_" at "_RUNT_" hours)"
 S (QBP,RSP)=0
 S QDTS=(YR-1700)_$S(QT=1:"01",QT=2:"04",QT=3:"07",1:10)_"00"
 S QDTE=(YR-1700)_$S(QT=1:"03",QT=2:"06",QT=3:"09",1:12)_"31.99"
 S QDT=QDTS
 F  S QDT=$O(^BYIMRT("DT",QDT)) Q:'QDT!(QDT>QDTE)  D
 .S QDA=0
 .F  S QDA=$O(^BYIMRT("DT",QDT,QDA)) Q:'QDA  D
 ..S Q0=$G(^BYIMRT(QDA,0))
 ..Q:$P(Q0,U,10)'=ST
 ..I Q0["qbp",Q0["QBP" D
 ...S QBP=QBP+1
 ...S FN=$P(Q0,U)
 ...Q:'RERUN
 ...S TYPE=1
 ...D FILE(FN,TYPE,ST)
 ..I Q0["qbp",Q0["RSP" D
 ...S RSP=RSP+1
 ...S FN=$P(Q0,U)
 ...Q:'RERUN
 ...S TYPE=2
 ...D FILE(FN,TYPE,ST)
 Q
 ;=====
 ;
FILE(FN,TYPE,ST) ;FILE ENTRIES
 S X=FN
 S DIC(0)="L"
 S DIC="^BYIMRWT("
 S DIC("DR")=".02///"_NOW_";.03////"_YR_";.04////"_QT_";.05////"_TYPE_";.06////"_ST
 D FILE^DICN
 Q
 ;=====
 ;
STAT ;EP;CURRENT EXPORT STATUS
 D PATH^BYIMIMM
 S BYIMDUZ=$$DUZ^BYIMIMM()
 S ASUFAC=$P($G(^AUTTLOC(BYIMDUZ,0)),U,10)
 S YR=$E(DT,1,3)+1700
 S FILE="izdata_"_ASUFAC_"_"_YR_"*"
 Q:'ASUFAC
 S ST=0
 F  S ST=$O(OPATH(ST)) Q:'ST  I ST'=56 D S1(ST)
 Q
 ;=====
 Q
S1(ST) ;STATE SPECIFIC STATS
 N SLIST,RLIST
 N APATH,DEL,SPATH,RPATH,QDTS,QDTE
 S APATH=$G(OPATH(ST))
 Q:APATH=""!(APATH["COVID")!(APATH["covid")
 S DEL=$S(APATH["\":"\",1:"/")
 S SPATH=$P(APATH,DEL,1,$L(APATH,DEL)-2)
 S SPATH=SPATH_DEL_"sent"_DEL
 S RPATH=$G(IPATH(ST))
 S SLIST=$$LIST^%ZISH(SPATH,FILE,.SLIST)
 S RLIST=$$LIST^%ZISH(RPATH,FILE,.RLIST)
 S SLAST=+$O(SLIST(9999999999),-1)
 S SFILE=$G(SLIST(SLAST))
 S RLAST=+$O(RLIST(9999999999),-1)
 S RFILE=$G(RLIST(SLAST))
 S STAT(ST,1)=SFILE
 S STAT(ST,2)=RFILE
 S (RT1,RT2)=""
 S RT=9999999999
 F  S RT=$O(^BYIMRT(RT),-1) Q:'RT!(RT1]""&(RT2]""))  S R0=$G(^(RT,0)) D
 .I $P(R0,"_",4)=ST,$P(R0,"_",2)="qbp",$P(R0,U,2)="QBP" S RT1=$P(R0,U),STAT(ST,3)=RT1
 .I $P(R0,"_",4)=ST,$P(R0,"_",2)="qbp",$P(R0,U,2)="RSP" S RT2=$P(R0,U),STAT(ST,4)=RT2
 Q
 ;=====
 ;
