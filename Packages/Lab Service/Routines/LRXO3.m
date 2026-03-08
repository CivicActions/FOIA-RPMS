LRXO3 ; IHS/DIR/AAB - Lab Order Cont. ;
 ;;5.2;LR;**1002**;JUN 01, 1998
 ;
 ;;5.2;LAB SERVICE;**165**;Sep 27, 1994
EN ;Schedule
 I $D(LRASK),LRASK S LRSCH="" Q
 Q:'$D(^PS(51.1,"APLR"))  D CLEAN
 I $D(LRFSCH) S LRSCH=LRFSCH Q
 I $L(LRECUR),'LROSON W !,$C(7),ORL(0)_" not set-up to allow continuous lab orders." Q
 Q:'LROSON
 I $L(LRECUR) S X=LRECUR,D="APLR",DIC(0)="M",DIC=51.1 D IX^DIC S PSJX=$P(Y,"^",2) S:Y'<1 LROSMAX=$S($L($P(^PS(51.1,$P(Y,"^",1),0),"^",7)):$P(^(0),"^",7),1:LROSMAX) G:Y'<1 1 W !!,LRECUR_" is an invalid schedule.",!
 I $O(^PS(51.1,"AC","LR","ONE TIME",0)) S DIC("B")="ONE TIME"
 W !,"For "_LRTSTNM
 S PSJX="ONE TIME" S DIC=51.1,DIC("S")="I ""CDO""[$P(^(0),""^"",5)",DIC("A")="HOW OFTEN: ",D="APLR",DIC(0)="AEQZ" D IX^DIC K DIC Q:Y<1  Q:"CD"'[$P(Y(0),"^",5)  S PSJX=$P(Y,"^",2),LROSMAX=$S($L($P(Y(0),"^",7)):$P(Y(0),"^",7),1:LROSMAX)
1 I $D(^PS(51.1,$P(Y,"^"),2,+OROLOC,0)) S LROSMAX=$S($L($P(^(0),"^",4)):$P(^(0),"^",4),1:LROSMAX)
 S X1=LROST,X2=LROSMAX-1 D C^%DTC S (PSJFD,Y)=X D DD^%DT K %DT S %DT("B")=Y,%DT(0)=-PSJFD
ST S X="" I LROSMAX>1 W !!,"Maximum number of continuous orders is "_LROSMAX,! D STOP
 I X["^" W !!,"INCOMPLETE REQUEST, ORDER DELETED",! S LREND=1 G END
 S PSJPP="LR",PSJNE="" D ENSV^PSJEEU G END:'$D(PSJX)
 S PSJSCH=PSJX,PSJSD=LROST D ENSPU^PSJEEU S LRSCH=PSJX
 Q
CLEAN ;Clean-up
 K PSJPP,PSJX,PSJPP,PSJW,PSJNE,PSJSCH,PSJAT,PSJM,PSJSD,PSJFD,PSJOSD,PSJOFD,PSJC,DIC,LROSX,LRM,LRMM,LRDTX,LRCK,LRSZX,Z,X1,X2
 Q
END ;End
 D CLEAN S LREND=1
 Q
STOP S %DT="AEFXT",%DT("A")="Please enter a STOP DATE: " D ^%DT Q:X["^"  S:'$P(Y,".",2) Y=Y_"."_$P(LROST,".",2) S PSJFD=Y+.00001 G:X'["^"&(Y=-1) STOP
 I Y'>LROST S Y=LROST D DD^%DT W " ??",$C(7),!,"STOP DATE must be after START DATE of: "_Y,! G STOP
 Q
CLEANR ;Package clean-up
 K LREK,LROT,LRO,LROUTINE,LRZX,TT,LRORD,LROST
 Q
