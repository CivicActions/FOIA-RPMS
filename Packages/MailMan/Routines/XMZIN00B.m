XMZIN00B ; ; 05-NOV-1996
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;Mailman 7.1;;NOV 05, 1996
 Q:'DIFQ(4.2999)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(4.29992,0)
 ;;=XMIT AUDIT SUB-FIELD^^1^2
 ;;^DD(4.29992,0,"DT")
 ;;=2960614
 ;;^DD(4.29992,0,"NM","XMIT AUDIT")
 ;;=
 ;;^DD(4.29992,0,"UP")
 ;;=4.2999
 ;;^DD(4.29992,.01,0)
 ;;=XMIT AUDIT DATE/TIME^MD^^0;1^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
 ;;^DD(4.29992,.01,1,0)
 ;;=^.1^^0
 ;;^DD(4.29992,.01,21,0)
 ;;=^^1^1^2960614^^
 ;;^DD(4.29992,.01,21,1,0)
 ;;=This is the date/time of the start of this attempt.
 ;;^DD(4.29992,.01,"DT")
 ;;=2960614
 ;;^DD(4.29992,1,0)
 ;;=XMIT AUDIT SCRIPT NAME^F^^0;2^K:$L(X)>10!($L(X)<1) X
 ;;^DD(4.29992,1,3)
 ;;=Answer must be 1-10 characters in length.
 ;;^DD(4.29992,1,21,0)
 ;;=^^1^1^2960614^
 ;;^DD(4.29992,1,21,1,0)
 ;;=This is the name of the script being used for this attempt.
 ;;^DD(4.29992,1,"DT")
 ;;=2960614
