DINIT00L ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,8031,5,1,0)
 ;;=DIPZ^ 
 ;;^UTILITY(U,$J,.84,8031,5,2,0)
 ;;=DIEZ^ 
 ;;^UTILITY(U,$J,.84,8031,5,3,0)
 ;;=DIKZ^ 
 ;;^UTILITY(U,$J,.84,8032,0)
 ;;=8032^2^^11
 ;;^UTILITY(U,$J,.84,8032,1,0)
 ;;=^^1^1^2930702^
 ;;^UTILITY(U,$J,.84,8032,1,1,0)
 ;;=Words SEARCH TEMPLATE
 ;;^UTILITY(U,$J,.84,8032,2,0)
 ;;=^^1^1^2931110^
 ;;^UTILITY(U,$J,.84,8032,2,1,0)
 ;;=Search Template
 ;;^UTILITY(U,$J,.84,8032,5,0)
 ;;=^.841^^0
 ;;^UTILITY(U,$J,.84,8033,0)
 ;;=8033^2^^11
 ;;^UTILITY(U,$J,.84,8033,1,0)
 ;;=^^1^1^2930701^^
 ;;^UTILITY(U,$J,.84,8033,1,1,0)
 ;;=the words INPUT TEMPLATE to use in any FileMan dialog.
 ;;^UTILITY(U,$J,.84,8033,2,0)
 ;;=^^1^1^2931110^
 ;;^UTILITY(U,$J,.84,8033,2,1,0)
 ;;=Input Template
 ;;^UTILITY(U,$J,.84,8033,5,0)
 ;;=^.841^2^2
 ;;^UTILITY(U,$J,.84,8033,5,1,0)
 ;;=DIEZ^ 
 ;;^UTILITY(U,$J,.84,8033,5,2,0)
 ;;=DIEZ^EN
 ;;^UTILITY(U,$J,.84,8034,0)
 ;;=8034^2^^11
 ;;^UTILITY(U,$J,.84,8034,1,0)
 ;;=^^1^1^2930701^^
 ;;^UTILITY(U,$J,.84,8034,1,1,0)
 ;;=The words PRINT TEMPLATE to use in any FileMan dialog.
 ;;^UTILITY(U,$J,.84,8034,2,0)
 ;;=^^1^1^2931110^
 ;;^UTILITY(U,$J,.84,8034,2,1,0)
 ;;=Print Template
 ;;^UTILITY(U,$J,.84,8034,5,0)
 ;;=^.841^2^2
 ;;^UTILITY(U,$J,.84,8034,5,1,0)
 ;;=DIPZ^ 
 ;;^UTILITY(U,$J,.84,8034,5,2,0)
 ;;=DIPZ^EN
 ;;^UTILITY(U,$J,.84,8035,0)
 ;;=8035^2^^11
 ;;^UTILITY(U,$J,.84,8035,1,0)
 ;;=^^1^1^2930701^
 ;;^UTILITY(U,$J,.84,8035,1,1,0)
 ;;=The words SORT TEMPLATE to use in any FileMan dialog.
 ;;^UTILITY(U,$J,.84,8035,2,0)
 ;;=^^1^1^2931110^
 ;;^UTILITY(U,$J,.84,8035,2,1,0)
 ;;=Sort Template
 ;;^UTILITY(U,$J,.84,8035,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,8035,5,1,0)
 ;;=DIOZ^ENCU
 ;;^UTILITY(U,$J,.84,8036,0)
 ;;=8036^2^^11
 ;;^UTILITY(U,$J,.84,8036,1,0)
 ;;=^^1^1^2930702^^
 ;;^UTILITY(U,$J,.84,8036,1,1,0)
 ;;=The words CROSS-REFERENCE(S) to use in any FileMan Dialog.
 ;;^UTILITY(U,$J,.84,8036,2,0)
 ;;=^^1^1^2931110^
 ;;^UTILITY(U,$J,.84,8036,2,1,0)
 ;;=Cross-Reference(s)
 ;;^UTILITY(U,$J,.84,8036,5,0)
 ;;=^.841^2^2
 ;;^UTILITY(U,$J,.84,8036,5,1,0)
 ;;=DIKZ^ 
 ;;^UTILITY(U,$J,.84,8036,5,2,0)
 ;;=DIKZ^EN
 ;;^UTILITY(U,$J,.84,8037,0)
 ;;=8037^2^^11
 ;;^UTILITY(U,$J,.84,8037,1,0)
 ;;=^^1^1^2931110^
 ;;^UTILITY(U,$J,.84,8037,1,1,0)
 ;;=The word SORT to use in any FileMan dialog.
 ;;^UTILITY(U,$J,.84,8037,2,0)
 ;;=^^1^1^2940526^
 ;;^UTILITY(U,$J,.84,8037,2,1,0)
 ;;=sort
 ;;^UTILITY(U,$J,.84,8037,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,8037,5,1,0)
 ;;=DIP^EN1
 ;;^UTILITY(U,$J,.84,8038,0)
 ;;=8038^2^^11
 ;;^UTILITY(U,$J,.84,8038,1,0)
 ;;=^^1^1^2931110^
 ;;^UTILITY(U,$J,.84,8038,1,1,0)
 ;;=The word SEARCH to use in any FileMan dialog.
 ;;^UTILITY(U,$J,.84,8038,2,0)
 ;;=^^1^1^2940526^
 ;;^UTILITY(U,$J,.84,8038,2,1,0)
 ;;=search
 ;;^UTILITY(U,$J,.84,8038,5,0)
 ;;=^.841^2^2
 ;;^UTILITY(U,$J,.84,8038,5,1,0)
 ;;=DIP^EN1
 ;;^UTILITY(U,$J,.84,8038,5,2,0)
 ;;=DIS^ENS
 ;;^UTILITY(U,$J,.84,8040,0)
 ;;=8040^2^^11
 ;;^UTILITY(U,$J,.84,8040,1,0)
 ;;=^^1^1^2940314^^^
 ;;^UTILITY(U,$J,.84,8040,1,1,0)
 ;;=Advice for the Yes/No question
 ;;^UTILITY(U,$J,.84,8040,2,0)
 ;;=^^1^1^2940314^^^
 ;;^UTILITY(U,$J,.84,8040,2,1,0)
 ;;=Answer with 'Yes' or 'No'
 ;;^UTILITY(U,$J,.84,8040,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8041,0)
 ;;=8041^2^^11
 ;;^UTILITY(U,$J,.84,8041,2,0)
 ;;=^^1^1^2940310^
 ;;^UTILITY(U,$J,.84,8041,2,1,0)
 ;;=This is a required response. Enter '^' to exit
 ;;^UTILITY(U,$J,.84,8041,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8042,0)
 ;;=8042^2^y^11^
 ;;^UTILITY(U,$J,.84,8042,1,0)
 ;;=^^2^2^2940315^^^^
 ;;^UTILITY(U,$J,.84,8042,1,1,0)
 ;;=This 'Select' prompt may be used for dialogs with filenames.
 ;;^UTILITY(U,$J,.84,8042,1,2,0)
 ;;=Note: Dialog will be used with $$EZBLD^DIALOG call, only one text line!!
 ;;^UTILITY(U,$J,.84,8042,2,0)
 ;;=1
 ;;^UTILITY(U,$J,.84,8042,2,1,0)
 ;;=Select |1|: 
 ;;^UTILITY(U,$J,.84,8042,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,8042,3,1,0)
 ;;=1^Name of the file
 ;;^UTILITY(U,$J,.84,8042,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8043,0)
 ;;=8043^2^^11
 ;;^UTILITY(U,$J,.84,8043,1,0)
 ;;=^^1^1^2940314^^
 ;;^UTILITY(U,$J,.84,8043,1,1,0)
 ;;=Used for date time input to the reader.
 ;;^UTILITY(U,$J,.84,8043,2,0)
 ;;=^^1^1^2940314^^
 ;;^UTILITY(U,$J,.84,8043,2,1,0)
 ;;= and time
 ;;^UTILITY(U,$J,.84,8043,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8044,0)
 ;;=8044^2^^11
 ;;^UTILITY(U,$J,.84,8044,1,0)
 ;;=^^1^1^2940314^^
 ;;^UTILITY(U,$J,.84,8044,1,1,0)
 ;;=Used for time input to the reader.
