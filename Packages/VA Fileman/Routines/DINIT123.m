DINIT123 ;SFISC/TKW - INITIALIZE V21 SORT TEMPLATE DD NODES ;6/24/94  11:15 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^DD(.4014,7,3)
 ;;=Answer must be 1-63 characters in length.  The ending point for the sort, derived by FileMan.
 ;;^DD(.4014,7,21,0)
 ;;=^^3^3^2930115^
 ;;^DD(.4014,7,21,1,0)
 ;;=FileMan usually uses the TO value as entered by the user, but in the
 ;;^DD(.4014,7,21,2,0)
 ;;=case of dates and sets of codes, the internal value is used.  This field
 ;;^DD(.4014,7,21,3,0)
 ;;=tells FileMan the ending point for the sort.
 ;;^DD(.4014,7,"DT")
 ;;=2930119
 ;;^DD(.4014,8,0)
 ;;=TO VALUE EXTERNAL^F^^T;2^K:$L(X)>63!($L(X)<1) X
 ;;^DD(.4014,8,3)
 ;;=Answer must be 1-63 characters in length.  The ending point for the sort, as entered by the user.
 ;;^DD(.4014,8,21,0)
 ;;=^^1^1^2930115^
 ;;^DD(.4014,8,21,1,0)
 ;;=The ending value for the sort, as entered by the user.
 ;;^DD(.4014,8,"DT")
 ;;=2930119
 ;;^DD(.4014,8.5,0)
 ;;=TO VALUE PRINTABLE^F^^T;3^K:$L(X)>40!($L(X)<1) X
 ;;^DD(.4014,8.5,3)
 ;;=Answer must be 1-40 characters in length.  Used for storing printable form of date and set values.
 ;;^DD(.4014,8.5,21,0)
 ;;=^^3^3^2930216^
 ;;^DD(.4014,8.5,21,1,0)
 ;;=This field is used to store a printable representation of the TO value
 ;;^DD(.4014,8.5,21,2,0)
 ;;=entered by the user during the sort/print dialogue.  Used for date and
 ;;^DD(.4014,8.5,21,3,0)
 ;;=set-of-code data types.
 ;;^DD(.4014,8.5,23,0)
 ;;=^^1^1^2930216^
 ;;^DD(.4014,8.5,23,1,0)
 ;;=Created in CK^DIP12.
 ;;^DD(.4014,8.5,"DT")
 ;;=2930216
 ;;^DD(.4014,9,0)
 ;;=CROSS REFERENCE DATA^F^^IX;E1,245^K:$L(X)>245!($L(X)<1) X
 ;;^DD(.4014,9,3)
 ;;=First ^ piece null, second piece=static part of cross-reference, third piece=global reference, 4th piece=number of variable subscripts to get to (and including) record number.
 ;;^DD(.4014,9,21,0)
 ;;=^^8^8^2930115^
 ;;^DD(.4014,9,21,1,0)
 ;;= Piece 1 is always null
 ;;^DD(.4014,9,21,2,0)
 ;;= Piece 2 is the static part of the cross-reference: ex. DIZ(662001,"B",
 ;;^DD(.4014,9,21,3,0)
 ;;= Piece 3 is the global reference: ex. DIZ(662001,
 ;;^DD(.4014,9,21,4,0)
 ;;= Piece 4 tells FileMan how many variable subscripts must be sorted
 ;;^DD(.4014,9,21,5,0)
 ;;=through to get to the record number, plus 1 for the record number
 ;;^DD(.4014,9,21,6,0)
 ;;=itself.  ex. for a regular cross-reference, ^DIZ(662001,"B",X,DA),
 ;;^DD(.4014,9,21,7,0)
 ;;=the number is 2.  One for the value of the X subscript, and one for the
 ;;^DD(.4014,9,21,8,0)
 ;;=record number itself (DA).
 ;;^DD(.4014,9,23,0)
 ;;=^^6^6^2930115^
 ;;^DD(.4014,9,23,1,0)
 ;;=The IX nodes are normally derived by FileMan during the entry of sort
 ;;^DD(.4014,9,23,2,0)
 ;;=fields (in routine XR^DIP).  However, they can also be passed to the
 ;;^DD(.4014,9,23,3,0)
 ;;=print (^DIP) in the BY(0) variable to cause FileMan to either use a MUMPS
 ;;^DD(.4014,9,23,4,0)
 ;;=type cross-reference, or a previously sorted list of record numbers.
 ;;^DD(.4014,9,23,5,0)
 ;;=Fileman sometimes builds the IX node prior to calling the print, as in
 ;;^DD(.4014,9,23,6,0)
 ;;=the INQUIRE option, where the user then goes on to print the records.
 ;;^DD(.4014,9,"DT")
 ;;=2930115
 ;;^DD(.4014,9.5,0)
 ;;=POINT TO CROSS REFERENCE^F^^PTRIX;E1,245^K:$L(X)>245!($L(X)<1) X
 ;;^DD(.4014,9.5,3)
 ;;=Enter global reference for "B" index of .01 field on pointed-to file.  Answer must be 1-245 characters in length.
 ;;^DD(.4014,9.5,21,0)
 ;;=^^7^7^2931221^
 ;;^DD(.4014,9.5,21,1,0)
 ;;=This node will exist only if the sort field is a pointer, if the sort
 ;;^DD(.4014,9.5,21,2,0)
 ;;=field has a regular cross-reference, if the .01 field on the pointed-to
 ;;^DD(.4014,9.5,21,3,0)
 ;;=file has a "B" index, and if the .01 field on the pointed-to file is
 ;;^DD(.4014,9.5,21,4,0)
 ;;=either a numeric, date, set-of-codes or free-text field, and does not have
 ;;^DD(.4014,9.5,21,5,0)
 ;;=an output transform.  If this node exists, it will be set to the static
 ;;^DD(.4014,9.5,21,6,0)
 ;;=part of the global reference of the "B" index on the pointed-to file. (ex.
 ;;^DD(.4014,9.5,21,7,0)
 ;;=^DIZ(662001,"B",).
 ;;^DD(.4014,9.5,"DT")
 ;;=2931221
 ;;^DD(.4014,10,0)
 ;;=GET CODE^K^^GET;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.4014,10,3)
 ;;=This is Standard MUMPS code used to extract the sort field from a record.
 ;;^DD(.4014,10,9)
 ;;=@
 ;;^DD(.4014,10,21,0)
 ;;=^^3^3^2930115^
 ;;^DD(.4014,10,21,1,0)
 ;;=The GET CODE is MUMPS code that is executed after a record (or sub-record)
