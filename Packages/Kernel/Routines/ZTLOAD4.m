%ZTLOAD4 ;SEA/RDS-TaskMan: P I: Is Queued? ;7/26/91  11:55 ; [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1005,1007**;APR 1, 2003 
 ;;8.0;KERNEL;;JUL 10, 1995
 ;;7.0;
 ;
INPUT ;check input parameters for error conditions
 I $D(ZTSK)[0 S ZTSK=""
 I $D(ZTSK)>1 S ZTLOAD=ZTSK K ZTSK S ZTSK=ZTLOAD K ZTLOAD
 I ZTSK<1!(ZTSK\1'=ZTSK) S ZTSK="",ZTSK(0)="",ZTSK("E")="IT" G QUIT
 S ZTSK(0)="",ZTSK("E")="U",X="QUIT^%ZTLOAD3",@^%ZOSF("TRAP")
 S %ZTVOL=^%ZOSF("VOL")
 I $D(ZTCPU)[0 S ZTCPU=%ZTVOL
 I ZTCPU="" S ZTCPU=%ZTVOL
 I ZTCPU'=%ZTVOL G THERE
 ;
HERE ;lookup task's status on current volume set
 L +^%ZTSK(ZTSK) I $D(^%ZTSK(ZTSK,0))[0 S ZTSK("E")="I" G QUIT
 S ZTREC=^%ZTSK(ZTSK,0),ZTD=$P(ZTREC,U,6)
 S ZTSK("DUZ")=$P(ZTREC,U,3),ZTSK("D")=ZTD
 I ZTD]"",$D(^%ZTSCH(ZTD,ZTSK))#2 S ZTSK(0)=1 G QUIT
 I ZTD]"",$D(^%ZTSCH("JOB",ZTD,ZTSK))#2 S ZTSK(0)=1 G QUIT
 ;
 S ZT1="" F ZT=0:0 S ZT1=$O(^%ZTSCH(ZT1)) Q:'ZT1  I $D(^(ZT1,ZTSK))#2 S ZTSK(0)=1 G QUIT
 S ZT1="IO",ZT2="" F ZT=0:0 S ZT2=$O(^%ZTSCH(ZT1,ZT2)),ZT3="" Q:ZT2=""  F ZT=0:0 S ZT3=$O(^%ZTSCH(ZT1,ZT2,ZT3)) Q:ZT3=""  I $D(^(ZT3,ZTSK))#2 S ZTSK(0)=1 G QUIT
 S ZT1="JOB",ZT2="" F ZT=0:0 S ZT2=$O(^%ZTSCH(ZT1,ZT2)) Q:ZT2=""  I $D(^(ZT2,ZTSK))#2 S ZTSK(0)=1 G QUIT
 S ZT1="LINK",ZT2="" F ZT=0:0 S ZT2=$O(^%ZTSCH(ZT1,ZT2)),ZT3="" Q:ZT2=""  F ZT=0:0 S ZT3=$O(^%ZTSCH(ZT1,ZT2,ZT3)) Q:ZT3=""  I $D(^(ZT3,ZTSK))#2 S ZTSK(0)=1 G QUIT
 S ZTSK(0)=0
 ;
QUIT ;cleanup and quit
 L:ZTSK -^%ZTSK(ZTSK) K %ZTCPU,%ZTM,%ZTM1,%ZTM2,%ZTMAST,%ZTVOL,X,Y,ZT,ZT1,ZT2,ZT3,ZTCPU,ZTD,ZTREC
 I ZTSK(0)]"" K ZTSK("E") Q
 I ZTSK("E")'="U" Q
 S ZTSK("E",0)=$$EC^%ZOSV
 Q
 ;
THERE ;rest of code looks up task's status on some other volume set
 ;
FILES ;find TaskMan files on the volume set to be searched
 S %ZTCPU=$O(^%ZIS(14.5,"B",ZTCPU,""))
 I %ZTCPU="" S ZTSK("E")="IS" G QUIT
 S %ZTM=$P(^%ZOSF("MGR"),",")
 S %ZTM=$S($D(^%ZIS(14.5,%ZTCPU,0))[0:%ZTM,$P(^(0),U,6)="":%ZTM,1:$P(^(0),U,6))
 S X=%ZTM,Y=ZTCPU
 S ZTSK("E")="LS",ZT=$D(^[X,Y]%ZTSK(0)),ZTSK("E")="U" ; check link
 ;
SEARCH ;find out if task is queued on that volume set
 I $D(^[X,Y]%ZTSK(ZTSK,0))[0 S ZTSK("E")="I" G QUIT
 S ZTREC=^[X,Y]%ZTSK(ZTSK,0),ZTD=$P(ZTREC,U,6)
 S ZTSK("DUZ")=$P(ZTREC,U,3),ZTSK("D")=ZTD
 I ZTD]"",$D(^[X,Y]%ZTSCH(ZTD,ZTSK))#2 S ZTSK(0)=1 G QUIT
 I ZTD]"",$D(^[X,Y]%ZTSCH("JOB",ZTD,ZTSK))#2 S ZTSK(0)=1 G QUIT
 ;
 S ZT1="" F ZT=0:0 S ZT1=$O(^[X,Y]%ZTSCH(ZT1)) Q:'ZT1  I $D(^(ZT1,ZTSK))#2 S ZTSK(0)=1 G QUIT
 S ZT1="IO",ZT2="" F ZT=0:0 S ZT2=$O(^[X,Y]%ZTSCH(ZT1,ZT2)),ZT3="" Q:ZT2=""  F ZT=0:0 S ZT3=$O(^[X,Y]%ZTSCH(ZT1,ZT2,ZT3)) Q:ZT3=""  I $D(^(ZT3,ZTSK))#2 S ZTSK(0)=1 G QUIT
 S ZT1="JOB",ZT2="" F ZT=0:0 S ZT2=$O(^[X,Y]%ZTSCH(ZT1,ZT2)) Q:ZT2=""  I $D(^(ZT2,ZTSK))#2 S ZTSK(0)=1 G QUIT
 S ZT1="LINK",ZT2="" F ZT=0:0 S ZT2=$O(^[X,Y]%ZTSCH(ZT1,ZT2)),ZT3="" Q:ZT2=""  F ZT=0:0 S ZT3=$O(^[X,Y]%ZTSCH(ZT1,ZT2,ZT3)) Q:ZT3=""  I $D(^(ZT3,ZTSK))#2 S ZTSK(0)=1 G QUIT
 S ZTSK(0)=0 G QUIT
 ;
