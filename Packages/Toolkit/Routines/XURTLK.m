XURTLK ;SFISC/HVB - RESPONSE TIME LOG FILE AND KILL ;03/16/2001  13:20 [ 04/02/2003   8:47 AM ]
 ;;7.3;TOOLKIT;**1001**;APR 1, 2003
 ;;7.3;TOOLKIT;**53,19**;September 6, 2001
 ;
 W !!,"This option will queue a background job that will save the Means into the",!
 W "RESPONSE TIME (#3.091) file.  The background job will also purge the",!
 W "System Response Time (RT) raw data which is stored in the ^%ZRTL(3 global",!
 W "node.",!!
 W "If this option is scheduled to run nightly through TaskManager, the",!
 W "default purge through date will be T-1.",!
 ;
 N %DT,DIR,X,Y
 ;
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="NO"
 D ^DIR
 Q:'Y
 ;
 S %DT="AEPX",%DT("A")="Purge through Date: "
 D ^%DT Q:Y<0
 S X=Y D H^%DTC S LASTDATE=%H
 D
 .N ZTDESC,ZTIO,ZTRTN,ZTSAVE,ZTSK
 .S ZTDESC="STORE AND PURGE RT DATA",ZTIO="",ZTRTN="DQ^XURTLK",ZTSAVE("LASTDATE")=""
 .D ^%ZTLOAD
 .I $D(ZTSK) W !!,"Option queued successfully as Task #",ZTSK,"."
 .I '$D(ZTSK) W !!,"ERROR: TaskManager was not able to queue this option.",!
 Q
 ;
DQ ;
 N %H,ACTJ,DA,DA2,DATE,DZ,HF,I,JF,MJ,MT,NJ,NMT,NT,RTN,SJ,SMT,ST,T0,T1,TIME,VOL,X0,XD,XMJ,XMT
 ;
 S:'$D(^%ZRTL(1,0))#2 ^(0)="RESPONSE TIME^3.091P^^"
 S:'$D(^%ZRTL(2,0))#2 ^(0)="RT DATE_UCI,VOL^3.092^^"
 ;
 S U="^",(DA2,JF)=0
 S LASTDATE=$S('$D(LASTDATE):+$H-1,LASTDATE>(+$H-1):+$H-1,1:LASTDATE)
 S VOL=""
 F  S VOL=$O(^%ZRTL(3,VOL)) Q:VOL=""  D DATE
 ;
 K LASTDATE
 Q
 ;
DATE F I=1:1:24 S (SMT(I),NMT(I),SJ(I),NJ(I),ST(I),NT(I))=0
 S DATE="",HF=0
 F  S DATE=$O(^%ZRTL(3,VOL,DATE)) Q:DATE=""!(DATE>LASTDATE)  D RTN
 Q
 ;
RTN S HF=1,XD=DATE,(RTN,TIME)=""
 F  S RTN=$O(^%ZRTL(3,VOL,DATE,RTN)) Q:RTN=""  D TIME
 S XMJ=U
 I JF F I=1:1:24 S MJ(I)=$S(NJ(I)>0:SJ(I)/NJ(I)*10+.5\1/10,1:""),XMJ=XMJ_U_MJ(I)
 S ^%ZRTL(2,DA2,0)=DZ_XMJ,DA2=0
 Q
 ;
TIME F  S TIME=$O(^%ZRTL(3,VOL,DATE,RTN,TIME)) Q:TIME=""  S T0=$P(^%ZRTL(3,VOL,DATE,RTN,TIME),",",2),T1=TIME Q:T1<T0  D
 .S I=T1\3600+1
 .S:I>24 I=24
 .S NT(I)=NT(I)+1,ST(I)=ST(I)+(T1-T0),ACTJ=$P(^%ZRTL(3,VOL,DATE,RTN,TIME),U,2)
 .S:ACTJ JF=1,SJ(I)=SJ(I)+ACTJ,NJ(I)=NJ(I)+1
 Q:'HF
 S XMT=""
 F I=1:1:24 D
 .S MT(I)=$S(NT(I)>0:ST(I)/NT(I)*10+.5\1/10,1:""),XMT=XMT_U_MT(I)
 .S:MT(I)>0 SMT(I)=SMT(I)+MT(I),NMT(I)=NMT(I)+1
 S %H=XD D YMD^%DTC
 S DZ=X_"_"_VOL,X0=^%ZRTL(1,0),DA=$P(X0,U,3)+1,N=$P(X0,U,4)+1
 D F:'DA2
 S ^%ZRTL(1,DA,0)=DA2_U_RTN_XMT,$P(^%ZRTL(1,0),U,3,4)=DA_U_N,^("B",DA2,DA)="",^%ZRTL(1,"C",VOL,DA)=""
 F I=1:1:24 S (SJ(I),NJ(I),ST(I),NT(I))=0
 K ^%ZRTL(3,VOL,XD,RTN)
 Q
 ;
F S X0=^%ZRTL(2,0),DA2=$P(X0,U,3)+1,N=$P(X0,U,4)+1
 S ^%ZRTL(2,DA2,0)=DZ
 S $P(^%ZRTL(2,0),U,3,4)=DA2_U_N,^("B",DZ,DA2)=""
 S $P(^%ZRTL(1,DA,0),U)=DA2
 Q
