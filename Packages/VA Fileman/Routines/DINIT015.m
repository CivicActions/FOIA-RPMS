DINIT015 ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,9532,0)
 ;;=9532^1^^11
 ;;^UTILITY(U,$J,.84,9532,1,0)
 ;;=^^1^1^2940909^
 ;;^UTILITY(U,$J,.84,9532,1,1,0)
 ;;=No IEN(s) in array.  (KIDS)
 ;;^UTILITY(U,$J,.84,9532,2,0)
 ;;=^^1^1^2940909^
 ;;^UTILITY(U,$J,.84,9532,2,1,0)
 ;;=No IEN(s) in list.
 ;;^UTILITY(U,$J,.84,9533,0)
 ;;=9533^1^^11
 ;;^UTILITY(U,$J,.84,9533,1,0)
 ;;=^^1^1^2940909^
 ;;^UTILITY(U,$J,.84,9533,1,1,0)
 ;;=Source array root missing.
 ;;^UTILITY(U,$J,.84,9533,2,0)
 ;;=^^1^1^2940909^
 ;;^UTILITY(U,$J,.84,9533,2,1,0)
 ;;=Source array root missing.
 ;;^UTILITY(U,$J,.84,9534,0)
 ;;=9534^1^y^11
 ;;^UTILITY(U,$J,.84,9534,1,0)
 ;;=^^1^1^2940909^^^
 ;;^UTILITY(U,$J,.84,9534,1,1,0)
 ;;=Resolved value data link missing.
 ;;^UTILITY(U,$J,.84,9534,2,0)
 ;;=^^1^1^2940909^^^
 ;;^UTILITY(U,$J,.84,9534,2,1,0)
 ;;=Resolved Value Data Link missing |1|.
 ;;^UTILITY(U,$J,.84,9535,0)
 ;;=9535^1^y^11
 ;;^UTILITY(U,$J,.84,9535,1,0)
 ;;=^^1^1^2940909^^^
 ;;^UTILITY(U,$J,.84,9535,1,1,0)
 ;;=Pointer file missing.
 ;;^UTILITY(U,$J,.84,9535,2,0)
 ;;=^^1^1^2940909^^^
 ;;^UTILITY(U,$J,.84,9535,2,1,0)
 ;;=Pointer file missing |1|.
 ;;^UTILITY(U,$J,.84,9536,0)
 ;;=9536^1^y^11
 ;;^UTILITY(U,$J,.84,9536,1,0)
 ;;=^^1^1^2940909^^
 ;;^UTILITY(U,$J,.84,9536,1,1,0)
 ;;=Pointed too file not on target system.
 ;;^UTILITY(U,$J,.84,9536,2,0)
 ;;=^^1^1^2940909^^
 ;;^UTILITY(U,$J,.84,9536,2,1,0)
 ;;=Pointed too file not on target system |1|.
 ;;^UTILITY(U,$J,.84,9537,0)
 ;;=9537^1^y^11
 ;;^UTILITY(U,$J,.84,9537,1,0)
 ;;=^^1^1^2940909^^^
 ;;^UTILITY(U,$J,.84,9537,1,1,0)
 ;;=Unable to find exact match and resolve pointer.
 ;;^UTILITY(U,$J,.84,9537,2,0)
 ;;=^^1^1^2940909^^^
 ;;^UTILITY(U,$J,.84,9537,2,1,0)
 ;;=Unable to find exact match and resolve pointer |1|.
 ;;^UTILITY(U,$J,.84,9538,0)
 ;;=9538^1^y^11
 ;;^UTILITY(U,$J,.84,9538,1,0)
 ;;=^^1^1^2940909^^
 ;;^UTILITY(U,$J,.84,9538,1,1,0)
 ;;=Pointer resolved value is missing.
 ;;^UTILITY(U,$J,.84,9538,2,0)
 ;;=^^1^1^2940909^^
 ;;^UTILITY(U,$J,.84,9538,2,1,0)
 ;;=Pointer resolved value is missing |1|.
 ;;^UTILITY(U,$J,.84,9539,0)
 ;;=9539^1^y^11
 ;;^UTILITY(U,$J,.84,9539,1,0)
 ;;=^^1^1^2940914^
 ;;^UTILITY(U,$J,.84,9539,1,1,0)
 ;;=File not on this system.
 ;;^UTILITY(U,$J,.84,9539,2,0)
 ;;=^^1^1^2940914^
 ;;^UTILITY(U,$J,.84,9539,2,1,0)
 ;;=File #|1| not on this system.
 ;;^UTILITY(U,$J,.84,9540,0)
 ;;=9540^1^y^11
 ;;^UTILITY(U,$J,.84,9540,1,0)
 ;;=^^1^1^2940914^^
 ;;^UTILITY(U,$J,.84,9540,1,1,0)
 ;;=DD not on this system.
 ;;^UTILITY(U,$J,.84,9540,2,0)
 ;;=^^1^1^2940914^^
 ;;^UTILITY(U,$J,.84,9540,2,1,0)
 ;;=DD #|1| not on this system.
 ;;^UTILITY(U,$J,.84,9541,0)
 ;;=9541^1^y^11
 ;;^UTILITY(U,$J,.84,9541,1,0)
 ;;=^^1^1^2940914^^
 ;;^UTILITY(U,$J,.84,9541,1,1,0)
 ;;=Field not on this system.
 ;;^UTILITY(U,$J,.84,9541,2,0)
 ;;=^^1^1^2940914^^
 ;;^UTILITY(U,$J,.84,9541,2,1,0)
 ;;=Field #|1|, DD #|2|, not on this system.
 ;;^UTILITY(U,$J,.84,9542,0)
 ;;=9542^1^^11
 ;;^UTILITY(U,$J,.84,9542,1,0)
 ;;=^^1^1^2940914^
 ;;^UTILITY(U,$J,.84,9542,1,1,0)
 ;;=File number missing or invalid for FIA structure.
 ;;^UTILITY(U,$J,.84,9542,2,0)
 ;;=^^1^1^2940914^
 ;;^UTILITY(U,$J,.84,9542,2,1,0)
 ;;=File number missing or invalid to build FIA structure.
 ;;^UTILITY(U,$J,.84,10001,0)
 ;;=10001^3^y^11
 ;;^UTILITY(U,$J,.84,10001,1,0)
 ;;=^^2^2^2941121^^
 ;;^UTILITY(U,$J,.84,10001,1,1,0)
 ;;=Here we enter a description of the help message itself.  This
 ;;^UTILITY(U,$J,.84,10001,1,2,0)
 ;;=description is for our own documentation.
 ;;^UTILITY(U,$J,.84,10001,2,0)
 ;;=^^3^3^2941121^^
 ;;^UTILITY(U,$J,.84,10001,2,1,0)
 ;;=Here we enter the actual text of the help messages, with
 ;;^UTILITY(U,$J,.84,10001,2,2,0)
 ;;=parameters designated by vertical bars |1
 ;;^UTILITY(U,$J,.84,10001,2,3,0)
 ;;=| as shown.
 ;;^UTILITY(U,$J,.84,10001,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,10001,3,1,0)
 ;;=1^Brief description of parameter 1 goes here.  For documentation only.
 ;;^UTILITY(U,$J,.84,10001,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,10001,6)
 ;;=S MYVAR="HELP #10001 WAS REQUESTED"
 ;;^UTILITY(U,$J,.84,99000,0)
 ;;=99000^1^y^11
 ;;^UTILITY(U,$J,.84,99000,1,0)
 ;;=^^1^1^2940915^
 ;;^UTILITY(U,$J,.84,99000,1,1,0)
 ;;=FOR TESTING ONLY.
 ;;^UTILITY(U,$J,.84,99000,2,0)
 ;;=^^2^2^2940915^
 ;;^UTILITY(U,$J,.84,99000,2,1,0)
 ;;=TESTING ERROR MESSAGE
 ;;^UTILITY(U,$J,.84,99000,2,2,0)
 ;;=parameter |1|;  parameter |2|.
 ;;^UTILITY(U,$J,.84,99000,3,0)
 ;;=^.845^3^3
