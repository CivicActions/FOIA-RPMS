XUCMXUTL ;SFISC/SO,HVB - XUCMX UTILITIES ;2/7/96  10:39 [ 04/02/2003   8:47 AM ]
 ;;7.3;TOOLKIT;**1001**;APR 1, 2003
 ;;7.3;TOOLKIT;**25**;Aug 01, 1997
A3 ; Get Date Range of Report
 ; XUCMBD = Beginning Date
 ; XUCMED = Ending Date
 S X1=DT,X2=-1 D C^%DTC S DD1=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3),DD2=X
A3A ; Get Beginning Date
 K DIR S DIR(0)="D^:"_DD2_":EPX",DIR("A")="Enter Beginning Date",DIR("B")=DD1
 D ^DIR K DIR I $D(DIRUT) K DIRUT S XUCMEND=1 G A3XIT
 S XUCMBD=$P(Y,".")
A3B ; Get Ending Date
 K DIR S DIR(0)="D^"_XUCMBD_":"_DD2_":EPX",DIR("A")="   Enter Ending Date",DIR("B")=DD1
 D ^DIR K DIR I $D(DIRUT) K DIRUT S XUCMEND=1 G A3XIT
 S XUCMED=$P(Y,".")
 I XUCMBD'=XUCMED,XUCMED']XUCMBD W $C(7),!,"Ending Date must be Greater than Beginning date." G A3
A3XIT K DD1,DD2 I XUCMEND K XUCMBD,XUCMED
 Q
