DINIT00R ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,9027,5,1,0)
 ;;=DIU0^6
 ;;^UTILITY(U,$J,.84,9028,0)
 ;;=9028^3^^11
 ;;^UTILITY(U,$J,.84,9028,1,0)
 ;;=^^3^3^2931109^
 ;;^UTILITY(U,$J,.84,9028,1,1,0)
 ;;=Help prompt for CROSS-REFERENCE ROUTINE name when editing file attributes.
 ;;^UTILITY(U,$J,.84,9028,1,2,0)
 ;;= If the user does not changes the name of the CROSS-REFERENCE ROUTINE,
 ;;^UTILITY(U,$J,.84,9028,1,3,0)
 ;;=then recompilation is not required, and they will see this help prompt.
 ;;^UTILITY(U,$J,.84,9028,2,0)
 ;;=^^2^2^2931109^
 ;;^UTILITY(U,$J,.84,9028,2,1,0)
 ;;=It is not necessary to recompile the cross-references, since the name of
 ;;^UTILITY(U,$J,.84,9028,2,2,0)
 ;;=the CROSS-REFERENCE ROUTINE was not changed.
 ;;^UTILITY(U,$J,.84,9028,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,9028,5,1,0)
 ;;=DIU0^6
 ;;^UTILITY(U,$J,.84,9029,0)
 ;;=9029^3^^11
 ;;^UTILITY(U,$J,.84,9029,1,0)
 ;;=^^5^5^2931109^
 ;;^UTILITY(U,$J,.84,9029,1,1,0)
 ;;=Help prompt for CROSS-REFERENCE ROUTINE name when editing file attributes.
 ;;^UTILITY(U,$J,.84,9029,1,2,0)
 ;;= If the user changes the name of the CROSS-REFERENCE ROUTINE, or enters a
 ;;^UTILITY(U,$J,.84,9029,1,3,0)
 ;;=name for the first time, they must also compile the routines at this time.
 ;;^UTILITY(U,$J,.84,9029,1,4,0)
 ;;= If they don't the routine name they just entered will be deleted from the
 ;;^UTILITY(U,$J,.84,9029,1,5,0)
 ;;=DD.
 ;;^UTILITY(U,$J,.84,9029,2,0)
 ;;=^^2^2^2931109^
 ;;^UTILITY(U,$J,.84,9029,2,1,0)
 ;;=If the cross-references are not recompiled at this time, the
 ;;^UTILITY(U,$J,.84,9029,2,2,0)
 ;;=CROSS-REFERENCE ROUTINE name will NOT be saved in the data dictionary.
 ;;^UTILITY(U,$J,.84,9029,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,9029,5,1,0)
 ;;=DIU0^6
 ;;^UTILITY(U,$J,.84,9030,0)
 ;;=9030^3^^11^
 ;;^UTILITY(U,$J,.84,9030,1,0)
 ;;=^^2^2^2931109^^^^
 ;;^UTILITY(U,$J,.84,9030,1,1,0)
 ;;=Help for prompting for compiled routine name, when compiling templates
 ;;^UTILITY(U,$J,.84,9030,1,2,0)
 ;;=or cross-references.
 ;;^UTILITY(U,$J,.84,9030,2,0)
 ;;=^^1^1^2931109^
 ;;^UTILITY(U,$J,.84,9030,2,1,0)
 ;;=This will become the namespace of the compiled routine(s).
 ;;^UTILITY(U,$J,.84,9030,3,0)
 ;;=^.845^^0
 ;;^UTILITY(U,$J,.84,9030,5,0)
 ;;=^.841^4^4
 ;;^UTILITY(U,$J,.84,9030,5,1,0)
 ;;=DIU0^6
 ;;^UTILITY(U,$J,.84,9030,5,2,0)
 ;;=DIKZ^ 
 ;;^UTILITY(U,$J,.84,9030,5,3,0)
 ;;=DIPZ^ 
 ;;^UTILITY(U,$J,.84,9030,5,4,0)
 ;;=DIEZ^ 
 ;;^UTILITY(U,$J,.84,9031,0)
 ;;=9031^2^^11
 ;;^UTILITY(U,$J,.84,9031,1,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,9031,1,1,0)
 ;;=Help for the reader: Freetext
 ;;^UTILITY(U,$J,.84,9031,2,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,9031,2,1,0)
 ;;=This response can be free text
 ;;^UTILITY(U,$J,.84,9031,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,9032,0)
 ;;=9032^2^^11
 ;;^UTILITY(U,$J,.84,9032,1,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,9032,1,1,0)
 ;;=Help for the reader: Set of codes
 ;;^UTILITY(U,$J,.84,9032,2,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,9032,2,1,0)
 ;;=Enter a code from the list.
 ;;^UTILITY(U,$J,.84,9032,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,9033,0)
 ;;=9033^2^^11
 ;;^UTILITY(U,$J,.84,9033,1,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,9033,1,1,0)
 ;;=Help for the reader: End of page
 ;;^UTILITY(U,$J,.84,9033,2,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,9033,2,1,0)
 ;;=Enter either RETURN or '^'
 ;;^UTILITY(U,$J,.84,9033,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,9034,0)
 ;;=9034^2^^11
 ;;^UTILITY(U,$J,.84,9034,1,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,9034,1,1,0)
 ;;=Help for the reader: Numbers
 ;;^UTILITY(U,$J,.84,9034,2,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,9034,2,1,0)
 ;;=This response must be a number
 ;;^UTILITY(U,$J,.84,9034,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,9035,0)
 ;;=9035^2^^11
 ;;^UTILITY(U,$J,.84,9035,1,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,9035,1,1,0)
 ;;=Help for the reader: dates
 ;;^UTILITY(U,$J,.84,9035,2,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,9035,2,1,0)
 ;;=This response must be a date
 ;;^UTILITY(U,$J,.84,9035,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,9036,0)
 ;;=9036^2^^11
 ;;^UTILITY(U,$J,.84,9036,1,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,9036,1,1,0)
 ;;=Help for the reader: List
 ;;^UTILITY(U,$J,.84,9036,2,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,9036,2,1,0)
 ;;=This response must be a list or range, e.g., 1,3,5 or 2-4,8
 ;;^UTILITY(U,$J,.84,9036,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,9037,0)
 ;;=9037^3^^11
