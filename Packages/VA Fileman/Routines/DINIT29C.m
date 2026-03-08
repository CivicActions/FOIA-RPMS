DINIT29C ;SFISC/MKO-SCREENMAN FILES ;11/28/94  11:42 AM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) G:X="" ^DINIT29D S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^DD(.4044,8,21,3,0)
 ;;=pop-up page, ScreenMan will automatically take them to the field following
 ;;^DD(.4044,8,21,4,0)
 ;;=this field.
 ;;^DD(.4044,8,21,5,0)
 ;;= 
 ;;^DD(.4044,8,21,6,0)
 ;;=You can also use the Parent Field property of the pop-up page to link a
 ;;^DD(.4044,8,21,7,0)
 ;;=field to the pop-up page.
 ;;^DD(.4044,10,0)
 ;;=BRANCHING LOGIC^K^^10;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.4044,10,3)
 ;;=Enter Standard MUMPS code, 1-245 characters in length.
 ;;^DD(.4044,10,9)
 ;;=@
 ;;^DD(.4044,10,21,0)
 ;;=^^18^18^2940907^
 ;;^DD(.4044,10,21,1,0)
 ;;=This MUMPS code is executed whenever the user presses <RET> at the
 ;;^DD(.4044,10,21,2,0)
 ;;=field.  Here you can set DDSBR equal to the field, block, and page,
 ;;^DD(.4044,10,21,3,0)
 ;;=separated by up-arrow delimiters, of the field to which you wish to take
 ;;^DD(.4044,10,21,4,0)
 ;;=users when they press <RET>.  For example,
 ;;^DD(.4044,10,21,5,0)
 ;;= 
 ;;^DD(.4044,10,21,6,0)
 ;;=     S:X="Y" DDSBR="TEST FIELD 1^TEST BLOCK 1^TEST PAGE 2"
 ;;^DD(.4044,10,21,7,0)
 ;;= 
 ;;^DD(.4044,10,21,8,0)
 ;;=would take the user to the field with unique name or caption "TEST FIELD
 ;;^DD(.4044,10,21,9,0)
 ;;=1" on the block named "TEST BLOCK 1" on a page named "TEST PAGE 2".
 ;;^DD(.4044,10,21,10,0)
 ;;= 
 ;;^DD(.4044,10,21,11,0)
 ;;=Alternatively, if you wish to take users to another page when they press
 ;;^DD(.4044,10,21,12,0)
 ;;=<RET> at this field, and then when they close that page, automatically
 ;;^DD(.4044,10,21,13,0)
 ;;=take them to the field immediately following this field, you can set
 ;;^DD(.4044,10,21,14,0)
 ;;=DDSSTACK equal to the page name or number of that page.
 ;;^DD(.4044,10,21,15,0)
 ;;= 
 ;;^DD(.4044,10,21,16,0)
 ;;=The variable X contains the current internal value of the field, DDSEXT
 ;;^DD(.4044,10,21,17,0)
 ;;=contains the current external value of the field, and DDSOLD contains the
 ;;^DD(.4044,10,21,18,0)
 ;;=previous internal value of the field.
 ;;^DD(.4044,11,0)
 ;;=PRE ACTION^K^^11;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.4044,11,3)
 ;;=Enter standard MUMPS code that will be executed when the user navigates to this field.
 ;;^DD(.4044,11,9)
 ;;=@
 ;;^DD(.4044,11,21,0)
 ;;=^^2^2^2940629^
 ;;^DD(.4044,11,21,1,0)
 ;;=This MUMPS code is executed when the user reaches the field.  The variable
 ;;^DD(.4044,11,21,2,0)
 ;;=X contains the current value of the field.
 ;;^DD(.4044,12,0)
 ;;=POST ACTION^K^^12;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.4044,12,3)
 ;;=Enter standard MUMPS code that will be executed when the user leaves this field.
 ;;^DD(.4044,12,9)
 ;;=@
 ;;^DD(.4044,12,21,0)
 ;;=^^5^5^2940629^
 ;;^DD(.4044,12,21,1,0)
 ;;=This MUMPS code is executed when the user leaves the field.
 ;;^DD(.4044,12,21,2,0)
 ;;= 
 ;;^DD(.4044,12,21,3,0)
 ;;=The variable X contains the current internal value of the field, DDSEXT
 ;;^DD(.4044,12,21,4,0)
 ;;=contains the current external value of the field, and DDSOLD contains
 ;;^DD(.4044,12,21,5,0)
 ;;=the previous internal value of the field.
 ;;^DD(.4044,13,0)
 ;;=POST ACTION ON CHANGE^K^^13;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.4044,13,3)
 ;;=Enter standard MUMPS code that will be executed when the user changes the value of this field.
 ;;^DD(.4044,13,9)
 ;;=@
 ;;^DD(.4044,13,21,0)
 ;;=^^4^4^2940629^
 ;;^DD(.4044,13,21,1,0)
 ;;=This MUMPS code is executed only if the user changed the value of the
 ;;^DD(.4044,13,21,2,0)
 ;;=field.  The variables X and DDSEXT contain the new internal and external
 ;;^DD(.4044,13,21,3,0)
 ;;=values of the field, and DDSOLD contains the original internal value of
 ;;^DD(.4044,13,21,4,0)
 ;;=the field.
 ;;^DD(.4044,13,"DT")
 ;;=2931029
 ;;^DD(.4044,14,0)
 ;;=DATA VALIDATION^K^^14;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.4044,14,3)
 ;;=This is Standard MUMPS code.
 ;;^DD(.4044,14,9)
 ;;=@
 ;;^DD(.4044,14,21,0)
 ;;=^^5^5^2940907^
 ;;^DD(.4044,14,21,1,0)
 ;;=Enter MUMPS code that will be executed after the user enters a new
 ;;^DD(.4044,14,21,2,0)
 ;;=value for this field.  If the code sets DDSERROR, the value will
 ;;^DD(.4044,14,21,3,0)
 ;;=be rejected.  You might also want to ring the bell and make a call to
 ;;^DD(.4044,14,21,4,0)
 ;;=HLP^DDSUTL to display a message to the user that indicates the reason the
 ;;^DD(.4044,14,21,5,0)
 ;;=value was rejected.
 ;;^DD(.4044,14,"DT")
 ;;=2930820
 ;;^DD(.4044,20.1,0)
 ;;=READ TYPE^S^D:DATE;F:FREE TEXT;L:LIST OR RANGE;N:NUMERIC;P:POINTER;S:SET OF CODES;Y:YES OR NO;DD:DATA DICTIONARY;^20;1^Q
