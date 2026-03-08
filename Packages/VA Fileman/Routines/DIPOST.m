DIPOST ;IRMFO-SF/FM STAFF-POST INSTALL ROUTINE;7/26/96  15:00 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**8**;Dec 28,1994
 ;Per VHA Directive 10-93-142, this routine should not be modified
 Q
 ;
V21P8 ;21*8
 N DIK,DA S DIK="^DD(1.14,",DA(1)=1.14 D IXALL^DIK
 K ^DD(.4,8,1,2),^DD(.4,0,"IX","EX",.4,8),^DIPT("EX")
 Q
 ;
