DIFROMSL(DIFRDD) ;SFISC/DCL-DIFROM SELECT FIELD FROM DD;08:37 AM  6 Sep 1994; [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ;Select field from DD
 N D0,D1,D2,D3,DA,DIC,DO,DIE,%,C,DC,DH,DI,DIA,DR,DIEL,DILK,DIOV,DIP,DK,DL,DM,DP,DQ,DSC,DV,DW,DXS,Y
 S DIC="^DD("_DIFRDD_",",DIC(0)="AEMQ"
 D ^DIC
 S X=+Y
