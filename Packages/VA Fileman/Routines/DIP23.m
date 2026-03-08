DIP23 ;SFISC/XAK-PRINT TEMPLATE ;5/10/90  1:36 PM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
ED S DA=+Y,DRK=DK K Y
 S DRK=DK,DIE="^DIPT(",DR=".01;3;6" D ^DIE K DR G Q^DIP:$D(Y)
 S DC=0,DI=I(0) I $D(DA),'$D(^DIPT(DA,1)) S D9="",DC(0)=DA,DC(1)=-1 D ^DIP22 S DA=DC(0)
 I $D(DA),$D(^DIPT(DA,1)) D ^DIFGA G Q^DIP:$D(DTOUT),H^DIP3
 S DALL(1)=1 G ^DIP2
