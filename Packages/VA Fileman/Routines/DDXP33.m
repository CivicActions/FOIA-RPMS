DDXP33 ;SFISC/DPC - CREATE EXPORT TEMPLATE (CONT);1/8/93  09:18 [ 09/10/1998  11:17 AM ]
 ;;21.0;VA Fileman;**1007**;SEP 08, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
FLDTEMP ;
 S DDXPOUT=0
 S DIC="^DIPT(",DIC(0)="QEAS",DIC("S")="I $P(^(0),U,8)=7",DIC("A")="Enter SELECTED EXPORT FIELDS Template: ",D="F"_DDXPFINO W ! D IX^DIC K DIC,D
 I Y=-1 S DDXPOUT=1 Q
 S DDXPFDTM=+Y,DDXPFDNM=$P(Y,U,2)
 D SHOWFLD G:DDXPOUT FLDTEMP
 Q
SHOWFLD ;
 W !!,"Do you want to see the fields stored in the "_DDXPFDNM_" template?"
 S DIR(0)="Y",DIR("B")="NO" D ^DIR K DIR
 I $D(DIRUT) S DDXPOUT=1 Q
 I Y D  Q:DDXPOUT
 . W ! S D0=DDXPFDTM D ^DIPT K D0
 . W !,"Do you want to use this template?"
 . S DIR(0)="Y",DIR("B")="YES" D ^DIR K DIR W !
 . I 'Y!$D(DIRUT) S DDXPOUT=1
 . Q
 S DDXPTMDL=0
 W !!,"Do you want to delete the "_DDXPFDNM_" template"
 W !,"after the export template is created?"
 S DIR(0)="Y",DIR("B")="NO" D ^DIR K DIR W !
 I $D(DIRUT) S DDXPOUT=1 Q
 S:Y DDXPTMDL=1
 Q
