DINIT016 ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,99000,3,1,0)
 ;;=1^first parameter
 ;;^UTILITY(U,$J,.84,99000,3,2,0)
 ;;=2^second parameter
 ;;^UTILITY(U,$J,.84,99000,3,3,0)
 ;;=A^a non-print parameter
 ;;^UTILITY(U,$J,.84,99000,6)
 ;;=D:ZZGO MSG^DIALOG("SWATEHM",.ZZCOPY,"",20)
 ;;^UTILITY(U,$J,.84,99001,0)
 ;;=99001^3^y^11
 ;;^UTILITY(U,$J,.84,99001,1,0)
 ;;=^^1^1^2940915^
 ;;^UTILITY(U,$J,.84,99001,1,1,0)
 ;;=A help test message.
 ;;^UTILITY(U,$J,.84,99001,2,0)
 ;;=^^1^1^2940915^
 ;;^UTILITY(U,$J,.84,99001,2,1,0)
 ;;=Help |1|!!
 ;;^UTILITY(U,$J,.84,99002,0)
 ;;=99002^2^^11
 ;;^UTILITY(U,$J,.84,99002,1,0)
 ;;=^^1^1^2940915^
 ;;^UTILITY(U,$J,.84,99002,1,1,0)
 ;;=A general message testing message.
 ;;^UTILITY(U,$J,.84,99002,2,0)
 ;;=^^1^1^2940915^
 ;;^UTILITY(U,$J,.84,99002,2,1,0)
 ;;=A message.
