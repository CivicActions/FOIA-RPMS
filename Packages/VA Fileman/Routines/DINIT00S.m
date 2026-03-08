DINIT00S ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,9037,1,0)
 ;;=^^1^1^2940316^^
 ;;^UTILITY(U,$J,.84,9037,1,1,0)
 ;;=Help for leaving form
 ;;^UTILITY(U,$J,.84,9037,2,0)
 ;;=^^3^3^2940316^^
 ;;^UTILITY(U,$J,.84,9037,2,1,0)
 ;;=Enter 'Y' to save before exiting.
 ;;^UTILITY(U,$J,.84,9037,2,2,0)
 ;;=Enter 'N' or '^' to exit without saving.
 ;;^UTILITY(U,$J,.84,9037,2,3,0)
 ;;=Press 'RETURN' to return to form
 ;;^UTILITY(U,$J,.84,9038,0)
 ;;=9038^3^^11
 ;;^UTILITY(U,$J,.84,9038,1,0)
 ;;=^^1^1^2940316^
 ;;^UTILITY(U,$J,.84,9038,1,1,0)
 ;;=Help for (Sub)record delete in forms
 ;;^UTILITY(U,$J,.84,9038,2,0)
 ;;=^^2^2^2940316^
 ;;^UTILITY(U,$J,.84,9038,2,1,0)
 ;;=Enter 'Y' to delete.
 ;;^UTILITY(U,$J,.84,9038,2,2,0)
 ;;=Enter 'N' or 'RETURN' to return to form.
 ;;^UTILITY(U,$J,.84,9038,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,9040,0)
 ;;=9040^2^^11
 ;;^UTILITY(U,$J,.84,9040,1,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,9040,1,1,0)
 ;;=Reader Help for Yes/No question
 ;;^UTILITY(U,$J,.84,9040,2,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,9040,2,1,0)
 ;;=Enter either 'Y' or 'N'.
 ;;^UTILITY(U,$J,.84,9040,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,9041,0)
 ;;=9041^3^^11
 ;;^UTILITY(U,$J,.84,9041,1,0)
 ;;=^^2^2^2940608^^^^
 ;;^UTILITY(U,$J,.84,9041,1,1,0)
 ;;=Help message for why the Compare/Merge options should be run during
 ;;^UTILITY(U,$J,.84,9041,1,2,0)
 ;;=non-peak hours.
 ;;^UTILITY(U,$J,.84,9041,2,0)
 ;;=^^8^8^2940608^
 ;;^UTILITY(U,$J,.84,9041,2,1,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9041,2,2,0)
 ;;=Enter 'NO' to compare and display the two entries.
 ;;^UTILITY(U,$J,.84,9041,2,3,0)
 ;;=Enter 'YES' to choose valid fields from each entry then merge into the
 ;;^UTILITY(U,$J,.84,9041,2,4,0)
 ;;=record selected as the default.
 ;;^UTILITY(U,$J,.84,9041,2,5,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9041,2,6,0)
 ;;=If you merge two entries within a file that is pointed-to by many other
 ;;^UTILITY(U,$J,.84,9041,2,7,0)
 ;;=files (such as the PATIENT file), then the re-pointing process can be time
 ;;^UTILITY(U,$J,.84,9041,2,8,0)
 ;;=consuming and can create many tasked jobs.
 ;;^UTILITY(U,$J,.84,9101,0)
 ;;=9101^3^^11
 ;;^UTILITY(U,$J,.84,9101,1,0)
 ;;=^^1^1^2930810^
 ;;^UTILITY(U,$J,.84,9101,1,1,0)
 ;;=The "CHOOSE FROM:" prompt.
 ;;^UTILITY(U,$J,.84,9101,2,0)
 ;;=^^1^1^2930908^^
 ;;^UTILITY(U,$J,.84,9101,2,1,0)
 ;;=Choose from:
 ;;^UTILITY(U,$J,.84,9103,0)
 ;;=9103^3^^11
 ;;^UTILITY(U,$J,.84,9103,1,0)
 ;;=^^2^2^2930810^^
 ;;^UTILITY(U,$J,.84,9103,1,1,0)
 ;;=First line of Variable Pointer help that shows the Prefixes and Messages
 ;;^UTILITY(U,$J,.84,9103,1,2,0)
 ;;=for a field.
 ;;^UTILITY(U,$J,.84,9103,2,0)
 ;;=^^1^1^2930810^
 ;;^UTILITY(U,$J,.84,9103,2,1,0)
 ;;=Enter one of the following:
 ;;^UTILITY(U,$J,.84,9105,0)
 ;;=9105^3^y^11^
 ;;^UTILITY(U,$J,.84,9105,1,0)
 ;;=^^2^2^2931229^
 ;;^UTILITY(U,$J,.84,9105,1,1,0)
 ;;=The beginning of the help text used to give list of fields that can
 ;;^UTILITY(U,$J,.84,9105,1,2,0)
 ;;=be used for a look-up.
 ;;^UTILITY(U,$J,.84,9105,2,0)
 ;;=^^1^1^2931229^
 ;;^UTILITY(U,$J,.84,9105,2,1,0)
 ;;=Answer with |1|.
 ;;^UTILITY(U,$J,.84,9105,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,9105,3,1,0)
 ;;=1^File name and list of fields that can be used for look-up.
 ;;^UTILITY(U,$J,.84,9105,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,9105,5,1,0)
 ;;=DIE^HELP
 ;;^UTILITY(U,$J,.84,9107,0)
 ;;=9107^3^y^11^
 ;;^UTILITY(U,$J,.84,9107,1,0)
 ;;=^^1^1^2940513^
 ;;^UTILITY(U,$J,.84,9107,1,1,0)
 ;;=LAYGO allowed.
 ;;^UTILITY(U,$J,.84,9107,2,0)
 ;;=^^1^1^2940513^
 ;;^UTILITY(U,$J,.84,9107,2,1,0)
 ;;=You may enter a new |1| if you wish.
 ;;^UTILITY(U,$J,.84,9107,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,9107,3,1,0)
 ;;=1^File Name.
 ;;^UTILITY(U,$J,.84,9110,0)
 ;;=9110^3^y^11^
 ;;^UTILITY(U,$J,.84,9110,1,0)
 ;;=^^1^1^2940223^^
 ;;^UTILITY(U,$J,.84,9110,1,1,0)
 ;;=Instructions for entering date data.
 ;;^UTILITY(U,$J,.84,9110,2,0)
 ;;=^^6^6^2940223^^^
 ;;^UTILITY(U,$J,.84,9110,2,1,0)
 ;;=Examples of Valid Dates:
 ;;^UTILITY(U,$J,.84,9110,2,2,0)
 ;;=   JAN 20 1957 or JAN 57 or 1/20/57 |1|
 ;;^UTILITY(U,$J,.84,9110,2,3,0)
 ;;=   T   (for TODAY), T+1 (for TOMORROW), T+2, T+7, etc.
 ;;^UTILITY(U,$J,.84,9110,2,4,0)
 ;;=T-1 (for YESTERDAY), T-3W (for 3 WEEKS AGO), etc.
 ;;^UTILITY(U,$J,.84,9110,2,5,0)
 ;;=If the year is omitted, the computer |2|.
 ;;^UTILITY(U,$J,.84,9110,2,6,0)
 ;;=|3|
 ;;^UTILITY(U,$J,.84,9110,3,0)
 ;;=^.845^3^3
 ;;^UTILITY(U,$J,.84,9110,3,1,0)
 ;;=1^If numeric dates are allowed, " or 012057" is written.
