DINIT06 ;SFISC/DPC-BLOCK FOR FOREIGN FORMAT ;1/11/93  14:13 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(ENTRY+I) G:X="" ^DINIT07 S Y=$E($T(ENTRY+I+1),5,999),X=$E(X,4,999),@X=Y
 Q
ENTRY ;
 ;;^DIST(.404,.443,0)
 ;;=DDXP FF BLK3^.441^0
 ;;^DIST(.404,.443,15,0)
 ;;=^^2^2^2920925^^
 ;;^DIST(.404,.443,15,1,0)
 ;;=Block for subpage containing fields from the OTHER NAME FOR FORMAT
 ;;^DIST(.404,.443,15,2,0)
 ;;=multiple.  Used in defining a foreign file format.
 ;;^DIST(.404,.443,40,0)
 ;;=^.4044I^2^2
 ;;^DIST(.404,.443,40,1,0)
 ;;=1^OTHER NAME^0
 ;;^DIST(.404,.443,40,1,1)
 ;;=.01
 ;;^DIST(.404,.443,40,1,2)
 ;;=2,20^15^2,8^0
 ;;^DIST(.404,.443,40,2,0)
 ;;=2^DESCRIPTION (WP)^0
 ;;^DIST(.404,.443,40,2,1)
 ;;=1
 ;;^DIST(.404,.443,40,2,2)
 ;;=4,20^1^4,2^0
 ;;^DIST(.404,.443,40,"B",1,1)
 ;;=
 ;;^DIST(.404,.443,40,"B",2,2)
 ;;=
 ;;^DIST(.404,.443,40,"C","DESCRIPTION (WP)",2)
 ;;=
 ;;^DIST(.404,.443,40,"C","OTHER NAME",1)
 ;;=
