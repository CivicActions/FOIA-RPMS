DINIT29D ;SFISC/MKO-SCREENMAN FILES ;11/28/94  11:42 AM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) G:X="" ^DINIT29E S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^DD(.4044,20.1,21,0)
 ;;=^^1^1^2930812^^
 ;;^DD(.4044,20.1,21,1,0)
 ;;=Enter the data type of this form-only field.
 ;;^DD(.4044,20.1,"DT")
 ;;=2930812
 ;;^DD(.4044,20.2,0)
 ;;=PARAMETERS^F^^20;2^K:$L(X)>2!($L(X)<1) X
 ;;^DD(.4044,20.2,3)
 ;;=Answer must be 1-2 characters in length.
 ;;^DD(.4044,20.2,21,0)
 ;;=^^8^8^2940907^
 ;;^DD(.4044,20.2,21,1,0)
 ;;=This property coressponds to the parameters that can be used in the first
 ;;^DD(.4044,20.2,21,2,0)
 ;;=^-piece of the DIR(0) input variable to ^DIR.  The "O" parameter has no
 ;;^DD(.4044,20.2,21,3,0)
 ;;=effect, since the Required property can be used to make a field required.
 ;;^DD(.4044,20.2,21,4,0)
 ;;=The "A" and "B" parameters also have no effect.
 ;;^DD(.4044,20.2,21,5,0)
 ;;= 
 ;;^DD(.4044,20.2,21,6,0)
 ;;=Free text fields can use the "U" parameter.
 ;;^DD(.4044,20.2,21,7,0)
 ;;=List or Range fields can use the "C" parameter.
 ;;^DD(.4044,20.2,21,8,0)
 ;;=Set of Codes fields can use the "X" and "M" parameters.
 ;;^DD(.4044,20.2,"DT")
 ;;=2930812
 ;;^DD(.4044,20.3,0)
 ;;=QUALIFIERS^F^^20;3^K:$L(X)>100!($L(X)<1) X
 ;;^DD(.4044,20.3,3)
 ;;=Answer must be 1-100 characters in length.
 ;;^DD(.4044,20.3,21,0)
 ;;=^^14^14^2940908^^
 ;;^DD(.4044,20.3,21,1,0)
 ;;=This property corresponds to the second ^-piece of the DIR(0) input
 ;;^DD(.4044,20.3,21,2,0)
 ;;=variable to ^DIR.  For Data Dictionary type form only fields, it
 ;;^DD(.4044,20.3,21,3,0)
 ;;=identifies the file and field.
 ;;^DD(.4044,20.3,21,4,0)
 ;;= 
 ;;^DD(.4044,20.3,21,5,0)
 ;;=Valid qualifiers are:
 ;;^DD(.4044,20.3,21,6,0)
 ;;= 
 ;;^DD(.4044,20.3,21,7,0)
 ;;=  Date             Minimum date:Maximum date:%DT
 ;;^DD(.4044,20.3,21,8,0)
 ;;=  Free Text        Minimum length:Maximum length
 ;;^DD(.4044,20.3,21,9,0)
 ;;=  List or Range    Minimum:Maximum:Maximum decimals
 ;;^DD(.4044,20.3,21,10,0)
 ;;=  Numeric          Minimum:Maximum:Maximum decimals
 ;;^DD(.4044,20.3,21,11,0)
 ;;=  Pointer          Global root or #:DIC(0)
 ;;^DD(.4044,20.3,21,12,0)
 ;;=  Set of Codes     Code:Stands for;Code:Stands for;
 ;;^DD(.4044,20.3,21,13,0)
 ;;=  Yes or No
 ;;^DD(.4044,20.3,21,14,0)
 ;;=  Data Dictionary  file#,field#
 ;;^DD(.4044,20.3,"DT")
 ;;=2930812
 ;;^DD(.4044,21,0)
 ;;=HELP^.404421^^21;0
 ;;^DD(.4044,21,"DT")
 ;;=2930812
 ;;^DD(.4044,22,0)
 ;;=INPUT TRANSFORM^K^^22;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.4044,22,3)
 ;;=Enter standard MUMPS code.
 ;;^DD(.4044,22,9)
 ;;=@
 ;;^DD(.4044,22,21,0)
 ;;=^^3^3^2940908^
 ;;^DD(.4044,22,21,1,0)
 ;;=This is MUMPS code that can examine X, the value entered by the user, and
 ;;^DD(.4044,22,21,2,0)
 ;;=kill X if it is invalid.  It corresponds to the third ^-piece of the
 ;;^DD(.4044,22,21,3,0)
 ;;=DIR(0) input variable to ^DIR.
 ;;^DD(.4044,22,"DT")
 ;;=2930812
 ;;^DD(.4044,23,0)
 ;;=SAVE CODE^K^^23;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.4044,23,3)
 ;;=Enter Standard MUMPS code.
 ;;^DD(.4044,23,9)
 ;;=@
 ;;^DD(.4044,23,21,0)
 ;;=^^8^8^2930920^^
 ;;^DD(.4044,23,21,1,0)
 ;;=This is MUMPS code that is executed when the user issues a Save command
 ;;^DD(.4044,23,21,2,0)
 ;;=and the value of this field changed since the last Save.  You can use this
 ;;^DD(.4044,23,21,3,0)
 ;;=field to save in global or local variables the value the user enters into
 ;;^DD(.4044,23,21,4,0)
 ;;=this field.  The following variables are available:
 ;;^DD(.4044,23,21,5,0)
 ;;= 
 ;;^DD(.4044,23,21,6,0)
 ;;=     X      = The new value of the field in internal form
 ;;^DD(.4044,23,21,7,0)
 ;;=     DDSEXT = The new value of the field in external form
 ;;^DD(.4044,23,21,8,0)
 ;;=     DDSOLD = The original (pre-save) value of the field in internal form
 ;;^DD(.4044,23,"DT")
 ;;=2930812
 ;;^DD(.4044,24,0)
 ;;=SCREEN^K^^24;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.4044,24,3)
 ;;=Enter standard MUMPS code that sets the variable DIR("S").
 ;;^DD(.4044,24,9)
 ;;=@
 ;;^DD(.4044,24,21,0)
 ;;=^^4^4^2940908^
 ;;^DD(.4044,24,21,1,0)
 ;;=This screen is valid only for pointer and set-type form-only fields.
 ;;^DD(.4044,24,21,2,0)
 ;;= 
 ;;^DD(.4044,24,21,3,0)
 ;;=You can enter MUMPS code that sets the variable DIR("S"), to screen the
 ;;^DD(.4044,24,21,4,0)
 ;;=the values that can be selected.
 ;;^DD(.4044,24,"DT")
 ;;=2930812
 ;;^DD(.4044,30,0)
 ;;=COMPUTED EXPRESSION^FX^^30;E1,245^K:$L(X)>245!($L(X)<1) X I $D(X) D CEXPR^DDSIT
 ;;^DD(.4044,30,3)
 ;;=Answer must be 1-245 characters in length.
