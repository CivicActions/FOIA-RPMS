DINIT00B ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,710,3,1,0)
 ;;=FIELD^Field number.
 ;;^UTILITY(U,$J,.84,710,3,2,0)
 ;;=FILE^File number.
 ;;^UTILITY(U,$J,.84,712,0)
 ;;=712^1^y^11^
 ;;^UTILITY(U,$J,.84,712,1,0)
 ;;=^^3^3^2931109^
 ;;^UTILITY(U,$J,.84,712,1,1,0)
 ;;=The value of a field cannot be deleted either because it is a required 
 ;;^UTILITY(U,$J,.84,712,1,2,0)
 ;;=field, because it is the .01 of a file, or because the test in the "DEL"
 ;;^UTILITY(U,$J,.84,712,1,3,0)
 ;;=node was not passed.
 ;;^UTILITY(U,$J,.84,712,2,0)
 ;;=^^1^1^2931109^
 ;;^UTILITY(U,$J,.84,712,2,1,0)
 ;;=The value of field |1| in file |2| cannot be deleted.
 ;;^UTILITY(U,$J,.84,712,3,0)
 ;;=^.845^4^4
 ;;^UTILITY(U,$J,.84,712,3,1,0)
 ;;=1^Field name.
 ;;^UTILITY(U,$J,.84,712,3,2,0)
 ;;=2^File name.
 ;;^UTILITY(U,$J,.84,712,3,3,0)
 ;;=FIELD^Field number.  (external only)
 ;;^UTILITY(U,$J,.84,712,3,4,0)
 ;;=FILE^File number.  (external only)
 ;;^UTILITY(U,$J,.84,712,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,712,5,1,0)
 ;;=DIE^FILE
 ;;^UTILITY(U,$J,.84,714,0)
 ;;=714^1^y^11^
 ;;^UTILITY(U,$J,.84,714,1,0)
 ;;=^^2^2^2931109^^
 ;;^UTILITY(U,$J,.84,714,1,1,0)
 ;;=The field uses $Piece storage and the data contains an '^'.  The data
 ;;^UTILITY(U,$J,.84,714,1,2,0)
 ;;=cannot be filed.
 ;;^UTILITY(U,$J,.84,714,2,0)
 ;;=^^1^1^2931109^^
 ;;^UTILITY(U,$J,.84,714,2,1,0)
 ;;=Data for Field |1| in File |2| contains an '^'.
 ;;^UTILITY(U,$J,.84,714,3,0)
 ;;=^.845^4^4
 ;;^UTILITY(U,$J,.84,714,3,1,0)
 ;;=1^Field name.
 ;;^UTILITY(U,$J,.84,714,3,2,0)
 ;;=2^File name.
 ;;^UTILITY(U,$J,.84,714,3,3,0)
 ;;=FILE^File number.  (external only)
 ;;^UTILITY(U,$J,.84,714,3,4,0)
 ;;=FIELD^Field number. (external only)
 ;;^UTILITY(U,$J,.84,714,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,714,5,1,0)
 ;;=DIE^FILE
 ;;^UTILITY(U,$J,.84,716,0)
 ;;=716^1^y^11^
 ;;^UTILITY(U,$J,.84,716,1,0)
 ;;=^^2^2^2931109^
 ;;^UTILITY(U,$J,.84,716,1,1,0)
 ;;=Data being filed is too long for the field.  Specifically, this occurs 
 ;;^UTILITY(U,$J,.84,716,1,2,0)
 ;;=when data of the wrong length is being filed in a $Extract (Em,n) field.
 ;;^UTILITY(U,$J,.84,716,2,0)
 ;;=^^1^1^2931109^
 ;;^UTILITY(U,$J,.84,716,2,1,0)
 ;;=Data for field |1| in file |2| is too long.
 ;;^UTILITY(U,$J,.84,716,3,0)
 ;;=^.845^4^4
 ;;^UTILITY(U,$J,.84,716,3,1,0)
 ;;=1^Field name.
 ;;^UTILITY(U,$J,.84,716,3,2,0)
 ;;=2^File name.
 ;;^UTILITY(U,$J,.84,716,3,3,0)
 ;;=FIELD^Field number. (external only)
 ;;^UTILITY(U,$J,.84,716,3,4,0)
 ;;=FILE^File number.  (external only)
 ;;^UTILITY(U,$J,.84,716,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,716,5,1,0)
 ;;=DIE^FILE
 ;;^UTILITY(U,$J,.84,720,0)
 ;;=720^1^^11
 ;;^UTILITY(U,$J,.84,720,1,0)
 ;;=^^2^2^2931110^^
 ;;^UTILITY(U,$J,.84,720,1,1,0)
 ;;=The lookup for a pointer fails.  This is an error only when
 ;;^UTILITY(U,$J,.84,720,1,2,0)
 ;;=LAYGO is not allowed.
 ;;^UTILITY(U,$J,.84,720,2,0)
 ;;=^^1^1^2931109^
 ;;^UTILITY(U,$J,.84,720,2,1,0)
 ;;=The value cannot be found in the pointed-to file.
 ;;^UTILITY(U,$J,.84,720,3,0)
 ;;=^.845^2^2
 ;;^UTILITY(U,$J,.84,720,3,1,0)
 ;;=FILE^File number -- the number of the file in which the pointer field exists.
 ;;^UTILITY(U,$J,.84,720,3,2,0)
 ;;=FIELD^Field number of the pointer field.
 ;;^UTILITY(U,$J,.84,726,0)
 ;;=726^1^y^11^
 ;;^UTILITY(U,$J,.84,726,1,0)
 ;;=^^2^2^2931110^
 ;;^UTILITY(U,$J,.84,726,1,1,0)
 ;;=There is an attempt to take an action with word processing data, but
 ;;^UTILITY(U,$J,.84,726,1,2,0)
 ;;=the specified field is not a word processing field.
 ;;^UTILITY(U,$J,.84,726,2,0)
 ;;=^^1^1^2931110^
 ;;^UTILITY(U,$J,.84,726,2,1,0)
 ;;=Field #|FIELD| in File #|FILE| is not a word processing field.
 ;;^UTILITY(U,$J,.84,726,3,0)
 ;;=^.845^2^2
 ;;^UTILITY(U,$J,.84,726,3,1,0)
 ;;=FIELD^Field number.
 ;;^UTILITY(U,$J,.84,726,3,2,0)
 ;;=FILE^File number.
 ;;^UTILITY(U,$J,.84,730,0)
 ;;=730^1^y^11^
 ;;^UTILITY(U,$J,.84,730,1,0)
 ;;=^^2^2^2941128^
 ;;^UTILITY(U,$J,.84,730,1,1,0)
 ;;=Based on how the data type is defined by a specific field in a specific
 ;;^UTILITY(U,$J,.84,730,1,2,0)
 ;;=file, the passed value is not valid.
 ;;^UTILITY(U,$J,.84,730,2,0)
 ;;=^^2^2^2941128^
 ;;^UTILITY(U,$J,.84,730,2,1,0)
 ;;=The value '|1|' is not a valid |2| according to the definition in Field
 ;;^UTILITY(U,$J,.84,730,2,2,0)
 ;;=#|FIELD| of File #|FILE|.
 ;;^UTILITY(U,$J,.84,730,3,0)
 ;;=^.845^4^4
 ;;^UTILITY(U,$J,.84,730,3,1,0)
 ;;=1^Passed Value.
 ;;^UTILITY(U,$J,.84,730,3,2,0)
 ;;=2^Data Type.
