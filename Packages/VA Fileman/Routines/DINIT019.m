DINIT019 ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.85)
 ;;=^DI(.85,
 ;;^UTILITY(U,$J,.85,0)
 ;;=LANGUAGE^.85I^4^4
 ;;^UTILITY(U,$J,.85,1,0)
 ;;=1^ENGLISH
 ;;^UTILITY(U,$J,.85,1,"CRD")
 ;;=I Y S Y=$FN(Y,",")
 ;;^UTILITY(U,$J,.85,1,"DD")
 ;;=S:Y Y=$S($E(Y,4,5):$P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC","^",+$E(Y,4,5))_" ",1:"")_$S($E(Y,6,7):+$E(Y,6,7)_",",1:"")_($E(Y,1,3)+1700)_$P("@"_$E(Y_0,9,10)_":"_$E(Y_"000",11,12)_$S($E(Y,13,14):":"_$E(Y_0,13,14),1:""),"^",Y[".")
 ;;^UTILITY(U,$J,.85,1,"FMTE")
 ;;=N RTN,%T S %T="."_$E($P(Y,".",2)_"000000",1,7),%F=$G(%F),RTN="F"_$S(%F<1:1,%F>7:1,1:+%F\1)_"^DILIBF" D @RTN S Y=%R
 ;;^UTILITY(U,$J,.85,1,"LC")
 ;;=S Y=$TR(Y,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
 ;;^UTILITY(U,$J,.85,1,"ORD")
 ;;=I $G(Y) S Y=Y_$S(Y#10=1&(Y#100-11):"ST",Y#10=2&(Y#100-12):"ND",Y#10=3&(Y#100-13):"RD",1:"TH")
 ;;^UTILITY(U,$J,.85,1,"UC")
 ;;=S Y=$TR(Y,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 ;;^UTILITY(U,$J,.85,2,0)
 ;;=2^GERMAN
 ;;^UTILITY(U,$J,.85,3,0)
 ;;=3^SPANISH
 ;;^UTILITY(U,$J,.85,4,0)
 ;;=4^FRENCH
