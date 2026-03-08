PSOKI003 ;IHS/DSD/ENM - ; 12-MAY-1998 [ 05/13/1998  5:24 PM ]
 ;;6.0;OUTPATIENT PATCH (PSO*6.0*1);**1**;MAY 12, 1998
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"PKG",2328,0)
 ;;=OUTPATIENT PATCH (PSO*6*1)^PSOK^This is for IHS patch pso*6*1
 ;;^UTILITY(U,$J,"PKG",2328,1,0)
 ;;=^^1^1^2980512^^^
 ;;^UTILITY(U,$J,"PKG",2328,1,1,0)
 ;;=This is for IHS patch pso*6*1
 ;;^UTILITY(U,$J,"PKG",2328,4,0)
 ;;=^9.44PA^1^1
 ;;^UTILITY(U,$J,"PKG",2328,4,1,0)
 ;;=52
 ;;^UTILITY(U,$J,"PKG",2328,4,1,1,0)
 ;;=^9.45A^1^1
 ;;^UTILITY(U,$J,"PKG",2328,4,1,1,1,0)
 ;;=ACTIVITY LOG
 ;;^UTILITY(U,$J,"PKG",2328,4,1,1,"B","ACTIVITY LOG",1)
 ;;=
 ;;^UTILITY(U,$J,"PKG",2328,4,1,222)
 ;;=y^n^^n^^^n
 ;;^UTILITY(U,$J,"PKG",2328,4,"B",52,1)
 ;;=
 ;;^UTILITY(U,$J,"PKG",2328,5)
 ;;=IHS/DSD/ENM
 ;;^UTILITY(U,$J,"PKG",2328,7)
 ;;=IHS/DSD
 ;;^UTILITY(U,$J,"PKG",2328,22,0)
 ;;=^9.49I^1^1
 ;;^UTILITY(U,$J,"PKG",2328,22,1,0)
 ;;=6^2980512
 ;;^UTILITY(U,$J,"PKG",2328,22,1,1,0)
 ;;=^^2^2^2980512^
 ;;^UTILITY(U,$J,"PKG",2328,22,1,1,1,0)
 ;;=The Rx Reference field contained a set of codes from 0 to 6.  Additional
 ;;^UTILITY(U,$J,"PKG",2328,22,1,1,2,0)
 ;;=sets had to be created to allow 11 refills and/or partials.
 ;;^UTILITY(U,$J,"PKG",2328,22,"B",6,1)
 ;;=
 ;;^UTILITY(U,$J,"PKG",2328,"DEV")
 ;;=ENM/DSD
 ;;^UTILITY(U,$J,"SBF",52,52)
 ;;=
 ;;^UTILITY(U,$J,"SBF",52,52.3)
 ;;=
