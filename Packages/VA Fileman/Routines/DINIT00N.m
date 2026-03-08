DINIT00N ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,8059,1,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8059,1,1,0)
 ;;=Part III of the 'Are you adding a new...' question
 ;;^UTILITY(U,$J,.84,8059,2,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8059,2,1,0)
 ;;= for this |1|
 ;;^UTILITY(U,$J,.84,8059,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,8059,3,1,0)
 ;;=1^Filename
 ;;^UTILITY(U,$J,.84,8059,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8060,0)
 ;;=8060^2^^11
 ;;^UTILITY(U,$J,.84,8060,1,0)
 ;;=^^1^1^2940314^^
 ;;^UTILITY(U,$J,.84,8060,1,1,0)
 ;;=Part Ia of the 'Are you adding...' message
 ;;^UTILITY(U,$J,.84,8060,2,0)
 ;;=^^1^1^2940314^^
 ;;^UTILITY(U,$J,.84,8060,2,1,0)
 ;;=  Are you adding 
 ;;^UTILITY(U,$J,.84,8060,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8061,0)
 ;;=8061^2^y^11^
 ;;^UTILITY(U,$J,.84,8061,1,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8061,1,1,0)
 ;;=Part Ib of the 'Are you adding...' question
 ;;^UTILITY(U,$J,.84,8061,2,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8061,2,1,0)
 ;;='|1|' as 
 ;;^UTILITY(U,$J,.84,8061,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,8061,3,1,0)
 ;;=1^Input value for .01 field
 ;;^UTILITY(U,$J,.84,8061,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8062,0)
 ;;=8062^2^y^11^
 ;;^UTILITY(U,$J,.84,8062,1,0)
 ;;=^^1^1^2940314^^^
 ;;^UTILITY(U,$J,.84,8062,1,1,0)
 ;;=Part Ic of the "Are you adding..." message
 ;;^UTILITY(U,$J,.84,8062,2,0)
 ;;=^^1^1^2940314^^^^
 ;;^UTILITY(U,$J,.84,8062,2,1,0)
 ;;=a new |1|
 ;;^UTILITY(U,$J,.84,8062,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,8062,3,1,0)
 ;;=1^Filename
 ;;^UTILITY(U,$J,.84,8062,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8063,0)
 ;;=8063^2^y^11^
 ;;^UTILITY(U,$J,.84,8063,1,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8063,1,1,0)
 ;;=Lookup Part I
 ;;^UTILITY(U,$J,.84,8063,2,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8063,2,1,0)
 ;;= Answer with |1|
 ;;^UTILITY(U,$J,.84,8063,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,8063,3,1,0)
 ;;=1^Filename
 ;;^UTILITY(U,$J,.84,8063,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8064,0)
 ;;=8064^2^^11
 ;;^UTILITY(U,$J,.84,8064,1,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8064,1,1,0)
 ;;=Lookup Part II
 ;;^UTILITY(U,$J,.84,8064,2,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8064,2,1,0)
 ;;= Do you want the entire 
 ;;^UTILITY(U,$J,.84,8064,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8065,0)
 ;;=8065^2^y^11^
 ;;^UTILITY(U,$J,.84,8065,1,0)
 ;;=^^1^1^2940314^^
 ;;^UTILITY(U,$J,.84,8065,1,1,0)
 ;;=Lookup Part III
 ;;^UTILITY(U,$J,.84,8065,2,0)
 ;;=^^1^1^2940314^^^
 ;;^UTILITY(U,$J,.84,8065,2,1,0)
 ;;=|1|-Entry 
 ;;^UTILITY(U,$J,.84,8065,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,8065,3,1,0)
 ;;=1^Number of entries in list
 ;;^UTILITY(U,$J,.84,8065,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8066,0)
 ;;=8066^2^y^11^
 ;;^UTILITY(U,$J,.84,8066,1,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8066,1,1,0)
 ;;=Lookup Part IV
 ;;^UTILITY(U,$J,.84,8066,2,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8066,2,1,0)
 ;;=|1| List
 ;;^UTILITY(U,$J,.84,8066,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,8066,3,1,0)
 ;;=1^Filename
 ;;^UTILITY(U,$J,.84,8066,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8067,0)
 ;;=8067^2^^11
 ;;^UTILITY(U,$J,.84,8067,1,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8067,1,1,0)
 ;;=For list of Fields on Lookup
 ;;^UTILITY(U,$J,.84,8067,2,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8067,2,1,0)
 ;;=, or
 ;;^UTILITY(U,$J,.84,8067,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8068,0)
 ;;=8068^2^^11
 ;;^UTILITY(U,$J,.84,8068,1,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8068,1,1,0)
 ;;=The Chooser
 ;;^UTILITY(U,$J,.84,8068,2,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8068,2,1,0)
 ;;=Choose from:
 ;;^UTILITY(U,$J,.84,8068,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8069,0)
 ;;=8069^2^y^11^
 ;;^UTILITY(U,$J,.84,8069,1,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8069,1,1,0)
 ;;=New entry allowed message
 ;;^UTILITY(U,$J,.84,8069,2,0)
 ;;=^^1^1^2940315^^
 ;;^UTILITY(U,$J,.84,8069,2,1,0)
 ;;=You may enter a new |1|, if you wish
 ;;^UTILITY(U,$J,.84,8069,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,8069,3,1,0)
 ;;=1^Filename
 ;;^UTILITY(U,$J,.84,8069,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8070,0)
 ;;=8070^2^y^11^
 ;;^UTILITY(U,$J,.84,8070,1,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8070,1,1,0)
 ;;=Variable Pointer Lookup
 ;;^UTILITY(U,$J,.84,8070,2,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8070,2,1,0)
 ;;=     Searching for a |1|
 ;;^UTILITY(U,$J,.84,8070,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,8070,3,1,0)
 ;;=1^Filename
 ;;^UTILITY(U,$J,.84,8070,4,0)
 ;;=^.847P^^0
