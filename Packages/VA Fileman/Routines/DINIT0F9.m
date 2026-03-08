DINIT0F9 ;SFISC/MKO-FORMS AND BLOCKS FOR FORM EDITOR ;11/23/94  1:24 PM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(ENTRY+I) G:X="" ^DINIT02 S Y=$E($T(ENTRY+I+1),5,999),X=$E(X,4,999),@X=Y
 Q
ENTRY ;
 ;;^DIST(.404,.404063,40,1,0)
 ;;=1^!M^1
 ;;^DIST(.404,.404063,40,1,.1)
 ;;=S Y="Block "_DDGFBNAM
 ;;^DIST(.404,.404063,40,1,2)
 ;;=^^3,3
 ;;^DIST(.404,.404063,40,2,0)
 ;;=2^already exists on this page!^1
 ;;^DIST(.404,.404063,40,2,2)
 ;;=^^4,3
 ;;^DIST(.404,.404063,40,3,0)
 ;;=3^OK^2
 ;;^DIST(.404,.404063,40,3,2)
 ;;=6,18^1^6,15^1
 ;;^DIST(.404,.404063,40,3,12)
 ;;=S DDACT="EX"
 ;;^DIST(.404,.404063,40,3,20)
 ;;=F^^0:0
 ;;^DIST(.404,.404063,40,3,21,0)
 ;;=^^1^1^2940928^
 ;;^DIST(.404,.404063,40,3,21,1,0)
 ;;=Press <RET> to close this page
 ;;^DIST(.404,.404071,0)
 ;;=DDGF BLOCK DELETE
 ;;^DIST(.404,.404071,40,0)
 ;;=^.4044I^4^4
 ;;^DIST(.404,.404071,40,1,0)
 ;;=1^Block^1
 ;;^DIST(.404,.404071,40,1,2)
 ;;=^^1,1
 ;;^DIST(.404,.404071,40,2,0)
 ;;=4^Do you want to delete it from the BLOCK file?^2
 ;;^DIST(.404,.404071,40,2,2)
 ;;=3,47^3^3,1^1
 ;;^DIST(.404,.404071,40,2,12)
 ;;=S:X]"" DDACT="EX" I X="" D HLP^DDSUTL($C(7)_"A response is required.  Enter either YES or NO.") S DDSBR=2
 ;;^DIST(.404,.404071,40,2,20)
 ;;=Y
 ;;^DIST(.404,.404071,40,2,23)
 ;;=S DDGFANS=X
 ;;^DIST(.404,.404071,40,3,0)
 ;;=2^!M^1
 ;;^DIST(.404,.404071,40,3,.1)
 ;;=S Y=DDGFBK
 ;;^DIST(.404,.404071,40,3,2)
 ;;=^^1,7
 ;;^DIST(.404,.404071,40,4,0)
 ;;=3^is not used on any other forms.^1
 ;;^DIST(.404,.404071,40,4,2)
 ;;=^^2,1
 ;;^DIST(.404,.404081,0)
 ;;=DDGF HEADER BLOCK SELECT
 ;;^DIST(.404,.404081,40,0)
 ;;=^.4044I^2^2
 ;;^DIST(.404,.404081,40,1,0)
 ;;=1^ Add a New Header Block ^1
 ;;^DIST(.404,.404081,40,1,2)
 ;;=^^1,20
 ;;^DIST(.404,.404081,40,2,0)
 ;;=2^Select New Header Block Name^2
 ;;^DIST(.404,.404081,40,2,2)
 ;;=3,33^30^3,3
 ;;^DIST(.404,.404081,40,2,12)
 ;;=S DDACT="EX"
 ;;^DIST(.404,.404081,40,2,20)
 ;;=P^^DIST(.404,:QEALMZF
 ;;^DIST(.404,.404081,40,2,23)
 ;;=S DDGFBNUM=X,DDGFBNAM=DDSEXT
