DINIT05 ;SFISC/DPC-BLOCK FOR FOREIGN FORMAT ;12/1/92  10:59 AM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(ENTRY+I) G:X="" ^DINIT06 S Y=$E($T(ENTRY+I+1),5,999),X=$E(X,4,999),@X=Y
 Q
ENTRY ;
 ;;^DIST(.404,.442,0)
 ;;=DDXP FF BLK2^.44^0
 ;;^DIST(.404,.442,15,0)
 ;;=^^2^2^2920925^^^
 ;;^DIST(.404,.442,15,1,0)
 ;;=Contains fields for page 2 of form used to define Foreign Formats.
 ;;^DIST(.404,.442,15,2,0)
 ;;=Primarily used to document the format.
 ;;^DIST(.404,.442,40,0)
 ;;=^.4044I^7^7
 ;;^DIST(.404,.442,40,1,0)
 ;;=1^FOREIGN FILE FORMAT: ^1^
 ;;^DIST(.404,.442,40,1,2)
 ;;=^^1,21^
 ;;^DIST(.404,.442,40,2,0)
 ;;=2^^0
 ;;^DIST(.404,.442,40,2,1)
 ;;=.01
 ;;^DIST(.404,.442,40,2,2)
 ;;=1,42^30
 ;;^DIST(.404,.442,40,2,4)
 ;;=^^^1
 ;;^DIST(.404,.442,40,3,0)
 ;;=2.5^PAGE 2^1^
 ;;^DIST(.404,.442,40,3,2)
 ;;=^^1,74^
 ;;^DIST(.404,.442,40,4,0)
 ;;=3^!M^1^
 ;;^DIST(.404,.442,40,4,.1)
 ;;=N I S Y="" F I=1:1:21+$L($G(DDXPFMNM)) S Y=Y_"="
 ;;^DIST(.404,.442,40,4,2)
 ;;=^^2,21^
 ;;^DIST(.404,.442,40,5,0)
 ;;=4^DESCRIPTION (WP)^0
 ;;^DIST(.404,.442,40,5,1)
 ;;=30
 ;;^DIST(.404,.442,40,5,2)
 ;;=4,44^1^4,26^0
 ;;^DIST(.404,.442,40,6,0)
 ;;=5^USAGE NOTES (WP)^0
 ;;^DIST(.404,.442,40,6,1)
 ;;=31
 ;;^DIST(.404,.442,40,6,2)
 ;;=6,44^1^6,26^0
 ;;^DIST(.404,.442,40,7,0)
 ;;=6^Select OTHER NAME FOR FORMAT^0
 ;;^DIST(.404,.442,40,7,1)
 ;;=50
 ;;^DIST(.404,.442,40,7,2)
 ;;=10,44^22^10,14^0
 ;;^DIST(.404,.442,40,7,4)
 ;;=^^^^0
 ;;^DIST(.404,.442,40,7,7)
 ;;=^3
 ;;^DIST(.404,.442,40,"B",1,1)
 ;;=
 ;;^DIST(.404,.442,40,"B",2,2)
 ;;=
 ;;^DIST(.404,.442,40,"B",2.5,3)
 ;;=
 ;;^DIST(.404,.442,40,"B",3,4)
 ;;=
 ;;^DIST(.404,.442,40,"B",4,5)
 ;;=
 ;;^DIST(.404,.442,40,"B",5,6)
 ;;=
 ;;^DIST(.404,.442,40,"B",6,7)
 ;;=
 ;;^DIST(.404,.442,40,"C","DESCRIPTION (WP)",5)
 ;;=
 ;;^DIST(.404,.442,40,"C","FOREIGN FILE FORMAT: ",1)
 ;;=
 ;;^DIST(.404,.442,40,"C","OTHER NAME FOR FORMAT",7)
 ;;=
 ;;^DIST(.404,.442,40,"C","PAGE 2",3)
 ;;=
 ;;^DIST(.404,.442,40,"C","USAGE NOTES (WP)",6)
 ;;=
