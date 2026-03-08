DINIT121 ;SFISC/TKW - INITIALIZE V21 SORT TEMPLATE DD NODES ;6/24/94  11:05 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^DD(.401,1816,3)
 ;;=Entry must be 'DISZ'.
 ;;^DD(.401,1816,21,0)
 ;;=^^4^4^2930331^^
 ;;^DD(.401,1816,21,1,0)
 ;;=This node is present only to be consistant with other sort templates.
 ;;^DD(.401,1816,21,2,0)
 ;;=It's presence will indicate that at some time the SORT template was
 ;;^DD(.401,1816,21,3,0)
 ;;=compiled and will contain the beginning characters used to create the
 ;;^DD(.401,1816,21,4,0)
 ;;=name of the compiled routine.
 ;;^DD(.401,1816,"DT")
 ;;=2930416
 ;;^DD(.401,1819,0)
 ;;=COMPILED^CJ3^^ ; ^S X=$S($G(^DIBT(D0,"ROU"))]"":"YES",1:"NO")
 ;;^DD(.401,1819,9)
 ;;=^
 ;;^DD(.401,1819,9.01)
 ;;=
 ;;^DD(.401,1819,9.1)
 ;;=S X=$S($G(^DIBT(D0,"ROU"))]"":"YES",1:"NO")
 ;;^DD(.4014,0)
 ;;=SORT FIELD DATA SUB-FIELD^^9.5^27
 ;;^DD(.4014,0,"DT")
 ;;=2931221
 ;;^DD(.4014,0,"IX","B",.4014,.01)
 ;;=
 ;;^DD(.4014,0,"NM","SORT FIELD DATA")
 ;;=
 ;;^DD(.4014,0,"UP")
 ;;=.401
 ;;^DD(.4014,.01,0)
 ;;=FILE OR SUBFILE NO.^MRNJ13,5^^0;1^K:+X'=X!(X>9999999.99999)!(X<0)!(X?.E1"."6N.N) X
 ;;^DD(.4014,.01,1,0)
 ;;=^.1
 ;;^DD(.4014,.01,1,1,0)
 ;;=.4014^B
 ;;^DD(.4014,.01,1,1,1)
 ;;=S ^DIBT(DA(1),2,"B",$E(X,1,30),DA)=""
 ;;^DD(.4014,.01,1,1,2)
 ;;=K ^DIBT(DA(1),2,"B",$E(X,1,30),DA)
 ;;^DD(.4014,.01,3)
 ;;=Type a Number between 0 and 9999999.99999, 5 Decimal Digits.  File or subfile number on which sort field resides.
 ;;^DD(.4014,.01,21,0)
 ;;=^^3^3^2930125^^
 ;;^DD(.4014,.01,21,1,0)
 ;;=This is the number of the file or subfile on which the sort field
 ;;^DD(.4014,.01,21,2,0)
 ;;=resides.  It is created automatically during the SORT FIELDS dialogue
 ;;^DD(.4014,.01,21,3,0)
 ;;=with the user in the sort/print option.
 ;;^DD(.4014,.01,23,0)
 ;;=^^1^1^2930125^^
 ;;^DD(.4014,.01,23,1,0)
 ;;=This number is automatically assigned by the print routine DIP.
 ;;^DD(.4014,.01,"DT")
 ;;=2930125
 ;;^DD(.4014,2,0)
 ;;=FIELD NO.^NJ13,5^^0;2^K:+X'=X!(X>9999999.99999)!(X<0)!(X?.E1"."6N.N) X
 ;;^DD(.4014,2,3)
 ;;=Type a Number between 0 and 9999999.99999, 5 Decimal Digits.  Sort field number, except for pointers, variable pointers and computed fields.
 ;;^DD(.4014,2,21,0)
 ;;=^^4^4^2930125^
 ;;^DD(.4014,2,21,1,0)
 ;;=On most sort fields, this piece will contain the field number.  If sorting
 ;;^DD(.4014,2,21,2,0)
 ;;=on a pointer, variable pointer or computed field, the piece will be null.
 ;;^DD(.4014,2,21,3,0)
 ;;=If sorting on the record number (NUMBER or .001), the piece will contain
 ;;^DD(.4014,2,21,4,0)
 ;;=a 0.
 ;;^DD(.4014,2,23,0)
 ;;=^^1^1^2930125^
 ;;^DD(.4014,2,23,1,0)
 ;;=Created by FileMan during the print option (in the DIP* routines).
 ;;^DD(.4014,2,"DT")
 ;;=2930125
 ;;^DD(.4014,3,0)
 ;;=FIELD NAME^F^^0;3^K:$L(X)>100!($L(X)<1) X
 ;;^DD(.4014,3,3)
 ;;=Answer must be 1-100 characters in length.
 ;;^DD(.4014,3,21,0)
 ;;=^^2^2^2930125^
 ;;^DD(.4014,3,21,1,0)
 ;;=This piece contains the sort field name, or the user entry if sorting by
 ;;^DD(.4014,3,21,2,0)
 ;;=an on-the-fly computed field.
 ;;^DD(.4014,3,23,0)
 ;;=^^1^1^2930125^
 ;;^DD(.4014,3,23,1,0)
 ;;=Created by FileMan during the print option (DIP* routines).
 ;;^DD(.4014,3,"DT")
 ;;=2930125
 ;;^DD(.4014,4,0)
 ;;=SORT QUALIFIERS BEFORE FIELD^F^^0;4^K:$L(X)>20!($L(X)<1) X
 ;;^DD(.4014,4,3)
 ;;=Answer must be 1-20 characters in length.  Sort qualifiers that normally precede the field number in the user dialogue (like !,@,#,+)
 ;;^DD(.4014,4,21,0)
 ;;=^^5^5^2930125^^^
 ;;^DD(.4014,4,21,1,0)
 ;;=This contains all of the sort qualifiers that normally precede the field
 ;;^DD(.4014,4,21,2,0)
 ;;=number in the user dialogue during the sort option.  It includes things
 ;;^DD(.4014,4,21,3,0)
 ;;=like # (Page break when sort value changes), @ (suppress printing of
 ;;^DD(.4014,4,21,4,0)
 ;;=subheader).  These qualifiers are listed out with no delimiters, as they
 ;;^DD(.4014,4,21,5,0)
 ;;=are found during the user dialogue.  (So you might see something like #@).
 ;;^DD(.4014,4,23,0)
 ;;=^^2^2^2930125^^
 ;;^DD(.4014,4,23,1,0)
 ;;=This information is parsed from the user dialogue or from the BY
 ;;^DD(.4014,4,23,2,0)
 ;;=input variable, by the FileMan print routines DIP*.
 ;;^DD(.4014,4,"DT")
 ;;=2930125
 ;;^DD(.4014,4.1,0)
 ;;=SORT QUALIFIERS AFTER FIELD^F^^0;5^K:$L(X)>70!($L(X)<1) X
 ;;^DD(.4014,4.1,3)
 ;;=Answer must be 1-70 characters in length.  Sort qualifiers that normally come after the field in the user dialogue (such as ;Cn, ;Ln, ;"Literal Subheader")
