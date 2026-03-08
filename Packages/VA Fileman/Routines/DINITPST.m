DINITPST ;SFISC/MKO-POST INIT FOR DINIT ;12/21/94  12:47 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;Deleted unneeded Dialog file entry
 N %,%Y,C,D,D0,DI,DIV,DQ
 ;
 ;Delete templates .001 and .002
 I $D(^DIE(.001)) D
 . N DIK,DA
 . S DIK="^DIE("
 . F DA=.001,.002 D ^DIK
 ;
 ;Recompile all forms
 W !
 S DDSQUIET=1 D DELALL^DDSZ K DDSQUIET
 D ALL^DDSZ
 W !!
 Q
