XMZIN00C ; ; 05-NOV-1996
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;Mailman 7.1;;NOV 05, 1996
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"SBF",4.2,4.2)
 ;;=
 ;;^UTILITY(U,$J,"SBF",4.2,4.21)
 ;;=
 ;;^UTILITY(U,$J,"SBF",4.2,4.22)
 ;;=
 ;;^UTILITY(U,$J,"SBF",4.2,4.23)
 ;;=
 ;;^UTILITY(U,$J,"SBF",4.2,4.24)
 ;;=
 ;;^UTILITY(U,$J,"SBF",4.2,4.25)
 ;;=
 ;;^UTILITY(U,$J,"SBF",4.2,4.299)
 ;;=
 ;;^UTILITY(U,$J,"SBF",4.2999,4.2999)
 ;;=
 ;;^UTILITY(U,$J,"SBF",4.2999,4.29991)
 ;;=
 ;;^UTILITY(U,$J,"SBF",4.2999,4.29992)
 ;;=
