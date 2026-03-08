DINIT29P ;SFISC/MKO-SCREENMAN POSTINIT ;11:29 AM  7 Sep 1994 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;Updated Field Type field of fields on old blocks.
 ;Convert 0 or null to 3 (data dictionary field)
 N B,F
 S B=0 F  S B=$O(^DIST(.404,B)) Q:B'=+B  D
 . Q:$P($G(^DIST(.404,B,0)),U)?1"DDGF".E
 . S F=0 F  S F=$O(^DIST(.404,B,40,F)) Q:F'=+F  D
 .. Q:$D(^DIST(.404,B,40,F,0))[0
 .. S:'$P(^DIST(.404,B,40,F,0),U,3) $P(^(0),U,3)=3
 ;
 ;Rename two version 19 options
 I $P($G(^DIC(19,0)),U)="OPTION" D
 . D:$D(^DIC(19,"B","DDS CREATE FORM")) RENAME("DDS CREATE FORM","DDS EDIT/CREATE A FORM")
 . D:$D(^DIC(19,"B","DDS CREATE BLOCK")) RENAME("DDS CREATE BLOCK","DDS RUN A FORM")
 ;
 G ^DINIT3
 ;
RENAME(DDSOLD,DDSNEW) ;Rename options
 N DIC,X,Y
 S DIC="^DIC(19,",DIC(0)="Z",X=DDSOLD
 D ^DIC Q:Y<0
 ;
 N DIE,DA,DR
 S DIE=DIC,DA=+Y,DR=".01///"_DDSNEW
 D ^DIE
 Q
 ;
PRE ;ScreenMan pre-init
 ;Delete old forms and blocks used by the Form Editor
 F I=1:1:6 K ^DIST(.403,".4030"_I)
 F I=1:1:8 K ^DIST(.403,".4040"_I)
 F I=11:1:13,21,22,31,41,51,61 K ^DIST(.404,".4030"_I)
 F I=11,21,31:1:34,41,42,51,52,61:1:63,71,81 K ^DIST(.404,".4040"_I)
 Q
