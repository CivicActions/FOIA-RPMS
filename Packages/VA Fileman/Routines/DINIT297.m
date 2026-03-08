DINIT297 ;SFISC/MKO-SCREENMAN FILES ;11/28/94  11:42 AM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) G:X="" ^DINIT298 S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^DD(.4032,12,21,2,0)
 ;;= 
 ;;^DD(.4032,12,21,3,0)
 ;;=This post-action is a characteristic of the block only as it is used on
 ;;^DD(.4032,12,21,4,0)
 ;;=this form.  If you place this block on another form, you can define a
 ;;^DD(.4032,12,21,5,0)
 ;;=different post-action.
 ;;^DD(.4032,12,"DT")
 ;;=2930610
