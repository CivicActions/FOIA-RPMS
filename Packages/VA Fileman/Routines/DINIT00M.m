DINIT00M ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,8044,2,0)
 ;;=^^1^1^2940314^^
 ;;^UTILITY(U,$J,.84,8044,2,1,0)
 ;;= and optional time
 ;;^UTILITY(U,$J,.84,8044,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8045,0)
 ;;=8045^2^y^11^
 ;;^UTILITY(U,$J,.84,8045,1,0)
 ;;=^^3^3^2940310^^^^
 ;;^UTILITY(U,$J,.84,8045,1,1,0)
 ;;=This prompt is used by the reader when he is building prompts for
 ;;^UTILITY(U,$J,.84,8045,1,2,0)
 ;;=Set-of-codes type data.
 ;;^UTILITY(U,$J,.84,8045,1,3,0)
 ;;=Note: Dialog will be used with $$EZBLD^DIALOG call, only one text line!!
 ;;^UTILITY(U,$J,.84,8045,2,0)
 ;;=^^1^1^2940310^^^
 ;;^UTILITY(U,$J,.84,8045,2,1,0)
 ;;=Enter |1|: 
 ;;^UTILITY(U,$J,.84,8045,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,8045,3,1,0)
 ;;=1^Default Prompt from DIR("A")
 ;;^UTILITY(U,$J,.84,8045,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8046,0)
 ;;=8046^2^^11
 ;;^UTILITY(U,$J,.84,8046,1,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,8046,1,1,0)
 ;;=Reader prompt for choices from a list
 ;;^UTILITY(U,$J,.84,8046,2,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,8046,2,1,0)
 ;;=Select one of the following: 
 ;;^UTILITY(U,$J,.84,8046,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8047,0)
 ;;=8047^2^^11
 ;;^UTILITY(U,$J,.84,8047,1,0)
 ;;=^^1^1^2940315^^^^
 ;;^UTILITY(U,$J,.84,8047,1,1,0)
 ;;=Part one of the Replace with prompt (including spaces).
 ;;^UTILITY(U,$J,.84,8047,2,0)
 ;;=^^1^1^2940315^^^^
 ;;^UTILITY(U,$J,.84,8047,2,1,0)
 ;;=  Replace 
 ;;^UTILITY(U,$J,.84,8047,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8048,0)
 ;;=8048^2^^11
 ;;^UTILITY(U,$J,.84,8048,1,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,8048,1,1,0)
 ;;=Part two of the Replace With editor (including spaces).
 ;;^UTILITY(U,$J,.84,8048,2,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,8048,2,1,0)
 ;;= With 
 ;;^UTILITY(U,$J,.84,8048,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8051,0)
 ;;=8051^2^^11
 ;;^UTILITY(U,$J,.84,8051,1,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,8051,1,1,0)
 ;;=Reader prompt
 ;;^UTILITY(U,$J,.84,8051,2,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,8051,2,1,0)
 ;;=Enter response: 
 ;;^UTILITY(U,$J,.84,8051,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8052,0)
 ;;=8052^2^^11
 ;;^UTILITY(U,$J,.84,8052,1,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,8052,1,1,0)
 ;;=Prompt for the reader
 ;;^UTILITY(U,$J,.84,8052,2,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,8052,2,1,0)
 ;;=Enter Yes or No: 
 ;;^UTILITY(U,$J,.84,8052,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8053,0)
 ;;=8053^2^^11
 ;;^UTILITY(U,$J,.84,8053,1,0)
 ;;=^^1^1^2940316^^
 ;;^UTILITY(U,$J,.84,8053,1,1,0)
 ;;=Prompt for the reader: End of page
 ;;^UTILITY(U,$J,.84,8053,2,0)
 ;;=^^1^1^2940316^^
 ;;^UTILITY(U,$J,.84,8053,2,1,0)
 ;;=Enter RETURN to continue or '^' to exit: 
 ;;^UTILITY(U,$J,.84,8053,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8054,0)
 ;;=8054^2^^11
 ;;^UTILITY(U,$J,.84,8054,1,0)
 ;;=^^1^1^2940310^^
 ;;^UTILITY(U,$J,.84,8054,1,1,0)
 ;;=Prompt for the reader: numbers
 ;;^UTILITY(U,$J,.84,8054,2,0)
 ;;=^^1^1^2940310^^
 ;;^UTILITY(U,$J,.84,8054,2,1,0)
 ;;=Enter a number
 ;;^UTILITY(U,$J,.84,8054,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8055,0)
 ;;=8055^2^^11
 ;;^UTILITY(U,$J,.84,8055,1,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,8055,1,1,0)
 ;;=Prompt for the reader: date
 ;;^UTILITY(U,$J,.84,8055,2,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,8055,2,1,0)
 ;;=Enter a date
 ;;^UTILITY(U,$J,.84,8055,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8056,0)
 ;;=8056^2^^11
 ;;^UTILITY(U,$J,.84,8056,1,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,8056,1,1,0)
 ;;=Prompt for the reader: List
 ;;^UTILITY(U,$J,.84,8056,2,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,8056,2,1,0)
 ;;=Enter a list or range of numbers
 ;;^UTILITY(U,$J,.84,8056,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8057,0)
 ;;=8057^2^^11
 ;;^UTILITY(U,$J,.84,8057,1,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,8057,1,1,0)
 ;;=Prompt for the Reader: Pointers
 ;;^UTILITY(U,$J,.84,8057,2,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,8057,2,1,0)
 ;;=Select: 
 ;;^UTILITY(U,$J,.84,8057,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8058,0)
 ;;=8058^2^y^11^
 ;;^UTILITY(U,$J,.84,8058,1,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8058,1,1,0)
 ;;=Part II of the 'Are you adding a new...' question
 ;;^UTILITY(U,$J,.84,8058,2,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8058,2,1,0)
 ;;= (the |1|
 ;;^UTILITY(U,$J,.84,8058,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,8058,3,1,0)
 ;;=1^Ordinal number of new entry
 ;;^UTILITY(U,$J,.84,8058,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8059,0)
 ;;=8059^2^y^11^
