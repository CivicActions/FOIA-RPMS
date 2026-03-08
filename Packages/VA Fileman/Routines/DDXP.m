DDXP ;SFISC/DPC-EXPORT MENU DRIVER ;12/17/92  10:13 ;10/30/92  10:01 [ 09/10/1998  11:17 AM ]
 ;;21.0;VA Fileman;**1007**;SEP 08, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
NOKL ;
 I ($G(^DIC(.44,0,"GL"))'="^DIST(.44,")!($G(^DIC(.81,0,"GL"))'="^DI(.81,") W !!,$C(7),"SORRY. You cannot use the Data Export options",!,"because you do not have the necessary files on your system." G Q^DII1
 S DIK="^DOPT(""DDXP"","
 I $D(^DOPT("DDXP",5)) G CHOOSE
 S ^DOPT("DDXP",0)="DATA EXPORT TO FOREIGN FORMAT OPTION^1.01^" K ^("B")
 F I=1:1:5 S ^DOPT("DDXP",I,0)=$P($T(@I),";;",2)
 K I D IXALL^DIK
CHOOSE ;
 W ! S DIC=DIK,DIC(0)="AEQI" D ^DIC K DIC,DIK
 I Y'<0 S X=+Y K Y D @X G NOKL
 W !
 G Q^DII1
 ;
1 ;;DEFINE FOREIGN FILE FORMAT
 S DDXP=1 D EN1^DDXP1
 D Q
 Q
 ;
2 ;;SELECT FIELDS FOR EXPORT
 S DDXP=2 D EN1^DDXP2
 D Q
 Q
 ;
3 ;;CREATE EXPORT TEMPLATE
 S DDXP=3 D EN1^DDXP3
 D Q
 Q
 ;
4 ;;EXPORT DATA
 S DDXP=4 D EN1^DDXP4
 D Q
 Q
 ;
5 ;;PRINT FORMAT DOCUMENTATION
 S DDXP=5 D EN1^DDXP5
 D Q
 Q
Q ;
 K DDXP,X,DIRUT,DUOUT,DTOUT Q
