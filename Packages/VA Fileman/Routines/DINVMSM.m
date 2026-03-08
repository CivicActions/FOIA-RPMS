%ZOSV ;SFISC/AC-$View commands for MSM-UNIX ;11/17/97  10:28 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**44**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
ACTJ() ;
 Q $S($$V3:$V($V(44)+168,-3,2),1:$V(168,-4,2))
AVJ() ;
 Q $S($$V3:$V($V(44)+94,-3,2)+1-$V($V(44)+168,-3,2),1:$V($V(3,-5),-3,0)-$V(168,-4,2))
T0 ; start RT clock
 S XRT0=$H Q
T1 ; store RT datum
 S ^%ZRTL(3,XRTL,+$H,XRTN,$P($H,",",2))=XRT0 K XRT0 Q
JOBPAR ;
 S Y=$V(2,X,2) Q:'Y
 S Y=$ZU(Y#32,Y\32) Q
PROGMODE() ;
 Q $V(0,$J,2)#2
PRGMODE ;
 W ! S ZTPAC=$S('$D(^VA(200,+DUZ,.1)):"",1:$P(^(.1),U,5)),XUVOL=^%ZOSF("VOL")
 ;I ZTPAC="" W *7,"YOU HAVE NO PROGRAMMER ACCESS CODE!",! Q
 I ZTPAC]"" X ^%ZOSF("EOFF") R !,"PAC: ",X:60 X ^%ZOSF("EON") I X'=ZTPAC W "??",*7 Q
 S XMB="XUPROGMODE",XMB(1)=DUZ,XMB(2)=$I D ^XMB:$D(^XMB(3.7,0)) K ^XMB(3.7,+DUZ,100,$I),^XUSEC(0,"CUR",DUZ,+^XUTL("XQ",$J,0)),ZTPAC,X,XMB
 S ZOSVER='$ZB($V(140,$J,2),512,1) ; 1 if V 2.1+ err trapping in effect
 X ^%ZOSF("UCI") S XUCI=Y,XQZ="PRGM^ZUA[MGR]",XUSLNT=1 D DO^%XUCI B:ZOSVER 2 V 0:$J:$ZB($V(0,$J,2),1,7):2 S $ZE="PRGMODEX^%ZOSV" ABORT
PRGMODEX W !,"YOU ARE NOW IN PROGRAMMING MODE!",! S $ZE="" B:ZOSVER -2 K ZOSVER Q
 ;
SIGNOFF ;
 I 0
 ;I $V($V(44)+4,-3,2)\32768#2 Q
UCI ;
 S Y=$ZU(0) Q  ;X ^%ZOSF("UCI") Q
 ;
UCICHECK(X) ;
 N Y,I S Y="",$ZT="BADUCI^%ZOSV"
 I X["," S Y=$ZU($P(X,","),$P(X,",",2)),(X,Y)=$ZU($P(Y,","),$P(Y,",",2)) Q:Y]"" Y
 F I=1:1:64 G:$ZU(I)="" BADUCI Q:$ZU(I)=X!($P($ZU(I),",")=X)!(I=X)
 Q $ZU(I)
 ;
BADUCI Q ""
 ;
BAUD ;S Y=^%ZOSF("MGR"),X=$S($D(^%ZIS(1,D0,0)):$P(^(0),"^",2),1:"")
 ;Q:X=""  I '$D(^[Y]SYS(0,"DDB",+X)) S X="" Q
 ;S X=$P(^(+X),",",3)#100 Q:'X
 ;S X=$P("50,75,110,134.5,150,300,600,1200,1800,2400,3600,4800,9600",",",X) Q
 Q
 ;
LGR() Q $ZR ;Last global ref.
 ;
EC() Q $ZE ;Error code
 ;
DOLRO ;SAVE ENTIRE SYMBOL TABLE IN LOCATION SPECIFIED BY X
 S Y="%" F %=0:0 S Y=$O(@Y) Q:Y=""  S %=$D(@Y) S:%#2 @(X_"Y)="_Y) I %>9 S %X=Y_"(",%Y=X_"Y," D %XY^%RCR
 Q
 ;
ORDER ;SAVE PART OF SYMBOL TABLE IN LOCATION SPECIFIED BY X
 S (Y,Y1)=$P(Y,"*",1) I $D(@Y)=0 F %=0:0 S Y=$O(@Y) Q:Y=""!(Y[Y1)
 Q:Y=""  S %=$D(@Y) S:%#2 @(X_"Y)="_Y) I %>9 S %X=Y_"(",%Y=X_"Y," D %XY^%RCR
 F %=0:0 S Y=$O(@Y) Q:Y=""!(Y'[Y1)  S %=$D(@Y) S:%#2 @(X_"Y)="_Y) I %>9 S %X=Y_"(",%Y=X_"Y," D %XY^%RCR
 K %,X,Y,Y1 Q
 ;
PRIORITY ;
 N %D,%P S %P=(X>5) D INT^%HL Q
 ;
PRIINQ() ;
 Q $S($V(20,$J,2):10,1:1)
PARSIZ ;
 S X=3 Q
 ;
NOLOG ;
 S Y=$S($$V3:"$V($V(44)+4,-3,2)",1:"$V(4,-4,2)")_"\64#2" Q
 ;
DEVOPN ;
 ;X=$J,Y=List of devices separated by a comma
 N %,%1,%I,%X
 S Y=""
 I $$V3 S %=$V($V(44)+10,-3,2),%1=$V($V(44)+8,-3,2)+$V(44),%=$V(%*5+%1)
 E  S %=$V(5,-5,0)
 F %I=1:1:255 S %X=$V(%+%I+%I,-3,2) I %X,%X#4=0,%X/4=X S Y=Y_%I_","
 Q
DEVOK ;
 ;X=Device $I, Y=0 if available, Y=Job # if owned,
 ;Y=-1 if device is undefined.
 G RES:$G(X1)="RES" I $E(X)="/"!($E(X)="\") S Y=0 Q
 I X=2 S Y=0 Q
 I X'?1.N!(X'>0!(X'<1024)) S Y=-1 Q
 N %
 I $$V3 S %=$V($V(44)+8,-3,2)+$V(44),%=$V($V($V(44)+10,-3,2)*5+%),Y=$V(%+X+X,-3,2),Y=$S(Y=0:0,Y#4=0:Y/4,1:-1)
 E  S %=$V(5,-5,0),Y=$V(%+X+X,-3,2),Y=$S(Y=0:0,Y#4=0:Y/4+$V(272,-4),1:-1)
 I 'Y D DVOPN Q
 S:Y=$J Y=0 Q
DVOPN S $ZT="DVERR",Y=0 Q:$D(%ZTIO)
 L:$D(%ZISLOCK) +@%ZISLOCK:60
 O X::$S($D(%ZISTO):%ZISTO,1:0) E  S Y=999 L:$D(%ZISLOCK) -@%ZISLOCK Q
 L:$D(%ZISLOCK) -@%ZISLOCK
 S Y=0 I '$D(%ZISCHK)!$S($D(%ZIS)#2:(%ZIS["T"),1:0) C X Q
 S:X]"" IO(1,X)="" Q
DVERR I $ZE["OPENERR" S Y=-1 Q
 ZQ
RES S Y=0,%ZISD0=$O(^%ZISL(3.54,"B",X,0))
 I '%ZISD0 S Y=-1,%ZISD0=%O(^%ZIS(1,"C",X)) Q:'%ZISD0  Q:'$D(^%ZIS(1,+%ZISD0,0))  Q:$P(^(0),"^")'=X  Q:'$D(^("TYPE"))  Q:^("TYPE")'="RES"  S Y=0 Q
 S X1=$S($D(^%ZISL(3.54,+%ZISD0,0)):^(0),1:"")
 I $P(X1,"^",2)&(X=$P(X1,"^")) S Y=0 Q
 S Y=999 F %ZISD1=0:0 S %ZISD1=$O(^%ZISL(3.54,%ZISD0,1,%ZISD1)) Q:%ZISD1'>0  I $D(^(%ZISD1,0)) S Y=$P(^(0),"^",3) Q
 K %ZISD0,%ZISD1
 Q
V2CL1 F %=0:0 Q:$ZA<0  R %X:5 Q:%X']""  F %1=0:0 S %1=$L(%Y),%Y=%Y_$E(%X,1,255-%1),%X=$E(%X,256-%1,$L(%X)),%1=$F(%Y,%ZCR) Q:%1'>0  S %2=$E(%Y,$A(%Y)=10+1,%1-2),%Y=$E(%Y,%1,$L(%Y)) D V2CL2
 C 2:256 K IO(1,2) D CLOSE^ZISPL1 K %Y,%X,%1,ZOSFV
 Q
V2CL2 S %1=$F(%2,$C(12)) I %1>0 S %=%+1 D LIMIT:%Z1<% Q:%Z1<%  S ^XMBS(3.519,XS,2,%,0)="|TOP|",%2=$E(%2,1,%1-2)_$E(%2,%1,$L(%2))
 S %=%+1,^XMBS(3.519,XS,2,%,0)=%2 Q
 ;
LIMIT S ^XMBS(3.519,XS,2,%,0)="*** INCOMPLETE REPORT  -- SPOOL DOCUMENT LINE LIMIT EXCEEDED ***",$P(^XMB(3.51,%ZDA,0),"^",11)=1 Q
 ;
SET ;SET SPECIAL VARIABLES
 S DT=$$HTFM^DILIBF($H,1)
 Q
GETENV ;Get enviroment  (UCI^VOL^NODE)
 S Y=$P($ZU(0),",",1)_"^"_$P($ZU(0),",",2)_"^^"_$P($ZU(0),",",2) Q
SETENV ;Set enviroment
 Q
LOGRSRC(OPT) ;record resource usage in ^XUCP
 Q
V3() ;returns 1=version 3, 0=version 4
 Q $P($ZV,"Version ",2)<4
SETTRM(X) ;Set specified terminators.
 U $I:(::::::::X)
 Q 1
