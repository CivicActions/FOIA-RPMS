DIFG7 ;SFISC/DG(OHPRD)-CALLS TO DIC,DIE,DIK ;1/7/92  2:47 PM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;IHS/TUCSON/LAB - 3/13/96 - modified this routine to pass back to
 ;the caller, an array, DIFGYFE(file,da) of all entries that were
 ;either added or edited during the filegram install
 ;it is the responsibility of the caller to kill DIFGYFE
CALLDIC ;
 I $D(^UTILITY("DIFG",$J,DIFGORDR,DIFGFILE,"DINUM")) S DINUM=^("DINUM")
 S DIADD=1,DIC(0)="FLI" I $P(^UTILITY("DIFG",$J,DIFGORDR,DIFGFILE,"X"),U,2)]"" S X="`"_X
 S DLAYGO=DIFGFILE
 S DITC=""
 D ^DIC
 K DITC
 I Y<1 S DIFGER=16_U_$P(^UTILITY("DIFG",$J,DIFGORDR,DIFGFILE,"MODE"),U,2) D ERROR^DIFG,K Q  ;IHS/TUCSON/LAB - 3/13/96 - added ,K Q so that if there is an error vars will get killed and then Q
 S DIFGYFE(DIFGFILE,+Y)=$P(Y,U,3) ;IHS/TUCSON/LAB - 3/14/96 - added this line to pass back to the caller, the ien,file of the entry added
K K DIADD,DLAYGO,DR,DINUM ;IHS/TUCSON/LAB - 3/13/96 - added line label K so this could be called
 Q
 ;
CALLDIE ;
 I DR[".01///"&($P(^DD(DIFGFILE,.01,0),U,5,99)["DINUM"!$D(^UTILITY("DIFG",$J,DIFGORDR,DIFGFILE,"DINUM"))) S DIFGDRVL=$P($P(DR,".01///",2),";"),DR=$P(DR,".01///"_DIFGDRVL)_$P(DR,".01///"_DIFGDRVL_";",2)
 NEW I F I=0:1 Q:'$D(@("D"_I))  K @("D"_I)
 S DITC=""
 D ^DIE K DITC
 I $G(DA),'$D(DIFGYFE(DIFGFILE,DA)) S DIFGYFE(DIFGFILE,DA)="" ;IHS/TUCSON/LAB - 03/13/96 - added this line to pass back ien,file that was edited
 Q
 ;
WP ;PROCESS WORD PROCESSING FIELD
 S DIFG("FIELD")=^UTILITY("DIFG",$J,DIFGORDR,DIFGFILE,"WP",0)
 F DIFGI=1:1 Q:'$D(^UTILITY("DIFG",$J,DIFGORDR,DIFGFILE,"WP",DIFGI))  D:^(DIFGI)[";" CHANGE S DR=DIFG("FIELD")_"///+"_^(DIFGI) D ^DIE
 K DR
 Q
 ;
CHANGE ;TEXT CONTAINS A ";"
 S DIFGSECP=^UTILITY("DIFG",$J,DIFGORDR,DIFGFILE,"WP",DIFGI) D PARSE^DIFG1 S ^UTILITY("DIFG",$J,DIFGORDR,DIFGFILE,"WP",DIFGI)="^S X="_DIFGSECP
 Q
 ;
CALLDIK ;
 D ^DIK
 Q
 ;
