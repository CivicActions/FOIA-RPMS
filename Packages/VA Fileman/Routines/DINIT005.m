DINIT005 ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,202,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,202,5,1,0)
 ;;=DIT^TRNMRG
 ;;^UTILITY(U,$J,.84,203,0)
 ;;=203^1^y^11^
 ;;^UTILITY(U,$J,.84,203,1,0)
 ;;=^^3^3^2940426^
 ;;^UTILITY(U,$J,.84,203,1,1,0)
 ;;=An incorrect subscript is present in an array that is passed to FileMan.
 ;;^UTILITY(U,$J,.84,203,1,2,0)
 ;;=For example, one of the subscripts in the FDA which identifies FILE, IENS,
 ;;^UTILITY(U,$J,.84,203,1,3,0)
 ;;=or FIELD is incorrectly formatted.
 ;;^UTILITY(U,$J,.84,203,2,0)
 ;;=^^1^1^2940426^^^
 ;;^UTILITY(U,$J,.84,203,2,1,0)
 ;;=The subscript that identifies the |1| is missing or invalid.
 ;;^UTILITY(U,$J,.84,203,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,203,3,1,0)
 ;;=1^The data element incorrectly specified by a subscript.
 ;;^UTILITY(U,$J,.84,203,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,203,5,1,0)
 ;;=DIE^FILE
 ;;^UTILITY(U,$J,.84,204,0)
 ;;=204^1^^11
 ;;^UTILITY(U,$J,.84,204,1,0)
 ;;=^^1^1^2940316^
 ;;^UTILITY(U,$J,.84,204,1,1,0)
 ;;=Control characters are not permitted in the database.
 ;;^UTILITY(U,$J,.84,204,2,0)
 ;;=^^1^1^2940316^
 ;;^UTILITY(U,$J,.84,204,2,1,0)
 ;;=The input value contains control characters.
 ;;^UTILITY(U,$J,.84,204,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,204,3,1,0)
 ;;=1^INPUT VALUE
 ;;^UTILITY(U,$J,.84,205,0)
 ;;=205^1^y^11^
 ;;^UTILITY(U,$J,.84,205,1,0)
 ;;=^^4^4^2941017^^^^
 ;;^UTILITY(U,$J,.84,205,1,1,0)
 ;;=Error message output when a file or subfile number, and its associated IEN
 ;;^UTILITY(U,$J,.84,205,1,2,0)
 ;;=string are not in sync.  (I.E., the number of comma pieces represented by
 ;;^UTILITY(U,$J,.84,205,1,3,0)
 ;;=the IEN string do not match the file/subfile level according to the "UP"
 ;;^UTILITY(U,$J,.84,205,1,4,0)
 ;;=nodes.
 ;;^UTILITY(U,$J,.84,205,2,0)
 ;;=^^1^1^2941018^^
 ;;^UTILITY(U,$J,.84,205,2,1,0)
 ;;=File# |1| and IEN string |IENS| represent different subfile levels.
 ;;^UTILITY(U,$J,.84,205,3,0)
 ;;=^.845^2^2
 ;;^UTILITY(U,$J,.84,205,3,1,0)
 ;;=1^File or subfile number
 ;;^UTILITY(U,$J,.84,205,3,2,0)
 ;;=IENS^IEN string
 ;;^UTILITY(U,$J,.84,205,5,0)
 ;;=^.841^2^2
 ;;^UTILITY(U,$J,.84,205,5,1,0)
 ;;=DIT3^IENCHK
 ;;^UTILITY(U,$J,.84,205,5,2,0)
 ;;=DICA3^ERR
 ;;^UTILITY(U,$J,.84,299,0)
 ;;=299^1^y^11^
 ;;^UTILITY(U,$J,.84,299,1,0)
 ;;=^^2^2^2940401^^
 ;;^UTILITY(U,$J,.84,299,1,1,0)
 ;;=A lookup that was restricted to finding a single entry found more than
 ;;^UTILITY(U,$J,.84,299,1,2,0)
 ;;=one.
 ;;^UTILITY(U,$J,.84,299,2,0)
 ;;=^^1^1^2940401^^^
 ;;^UTILITY(U,$J,.84,299,2,1,0)
 ;;=More than one entry matches the value '|1|'.
 ;;^UTILITY(U,$J,.84,299,3,0)
 ;;=^.845^3^3
 ;;^UTILITY(U,$J,.84,299,3,1,0)
 ;;=1^Lookup Value.
 ;;^UTILITY(U,$J,.84,299,3,2,0)
 ;;=FILE^File #.
 ;;^UTILITY(U,$J,.84,299,3,3,0)
 ;;=IENS^IEN String.
 ;;^UTILITY(U,$J,.84,301,0)
 ;;=301^1^y^11^
 ;;^UTILITY(U,$J,.84,301,1,0)
 ;;=^^1^1^2931110^^
 ;;^UTILITY(U,$J,.84,301,1,1,0)
 ;;=Flags passed in a variable (like DIC(0)) or in a parameter are incorrect.
 ;;^UTILITY(U,$J,.84,301,2,0)
 ;;=^^1^1^2931110^^
 ;;^UTILITY(U,$J,.84,301,2,1,0)
 ;;=The passed flag(s) '|1|' are unknown or inconsistent.
 ;;^UTILITY(U,$J,.84,301,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,301,3,1,0)
 ;;=1^Letter(s) from flag.
 ;;^UTILITY(U,$J,.84,302,0)
 ;;=302^1^y^11^
 ;;^UTILITY(U,$J,.84,302,1,0)
 ;;=^^2^2^2940215^
 ;;^UTILITY(U,$J,.84,302,1,1,0)
 ;;=The calling application has asked us to add a new record, and has supplied
 ;;^UTILITY(U,$J,.84,302,1,2,0)
 ;;=a record number, but a record already exists at that number.
 ;;^UTILITY(U,$J,.84,302,2,0)
 ;;=^^1^1^2941018^
 ;;^UTILITY(U,$J,.84,302,2,1,0)
 ;;=Entry '|IENS|' already exists.
 ;;^UTILITY(U,$J,.84,302,3,0)
 ;;=^.845^2^2
 ;;^UTILITY(U,$J,.84,302,3,1,0)
 ;;=FILE^File #.
 ;;^UTILITY(U,$J,.84,302,3,2,0)
 ;;=IENS^IEN String.
 ;;^UTILITY(U,$J,.84,304,0)
 ;;=304^1^y^11
 ;;^UTILITY(U,$J,.84,304,1,0)
 ;;=^^2^2^2940628^^^^
 ;;^UTILITY(U,$J,.84,304,1,1,0)
 ;;=The problem with this IEN string is that it lacks the final ','. This is a
 ;;^UTILITY(U,$J,.84,304,1,2,0)
 ;;=common mistake for beginners.
 ;;^UTILITY(U,$J,.84,304,2,0)
 ;;=^^1^1^2941018^
 ;;^UTILITY(U,$J,.84,304,2,1,0)
 ;;=The IENS '|IENS|' lacks a final comma.
 ;;^UTILITY(U,$J,.84,304,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,304,3,1,0)
 ;;=IENS^IENS.
 ;;^UTILITY(U,$J,.84,305,0)
 ;;=305^1^y^11^
 ;;^UTILITY(U,$J,.84,305,1,0)
 ;;=^^1^1^2931109^
 ;;^UTILITY(U,$J,.84,305,1,1,0)
 ;;=A root is used to identify an input array.  But the array is empty.
