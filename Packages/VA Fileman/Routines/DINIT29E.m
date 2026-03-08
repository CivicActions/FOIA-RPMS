DINIT29E ;SFISC/MKO-SCREENMAN FILES ;11/28/94  11:42 AM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) G:X="" ^DINIT29P S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^DD(.4044,30,21,0)
 ;;=^^13^13^2940908^
 ;;^DD(.4044,30,21,1,0)
 ;;=You can enter MUMPS code that sets the variable Y equal to the value of
 ;;^DD(.4044,30,21,2,0)
 ;;=the computed field.  Alternatively, you can precede the computed
 ;;^DD(.4044,30,21,3,0)
 ;;=expression with an equal sign (=).
 ;;^DD(.4044,30,21,4,0)
 ;;= 
 ;;^DD(.4044,30,21,5,0)
 ;;=For example,
 ;;^DD(.4044,30,21,6,0)
 ;;= 
 ;;^DD(.4044,30,21,7,0)
 ;;=       S:$D(var)#2 Y="The value is: "_{NUMERIC}
 ;;^DD(.4044,30,21,8,0)
 ;;=       ={FIRST NAME}_" "_{LAST NAME}
 ;;^DD(.4044,30,21,9,0)
 ;;=       ={FO(PRICE)}*1.085
 ;;^DD(.4044,30,21,10,0)
 ;;= 
 ;;^DD(.4044,30,21,11,0)
 ;;=NUMERIC, FIRST NAME, and LAST NAME are the name of FileMan fields used on
 ;;^DD(.4044,30,21,12,0)
 ;;=the form, and PRICE is the caption of a form-only field found on the
 ;;^DD(.4044,30,21,13,0)
 ;;=current page and block of the form.
 ;;^DD(.4044,30,"DT")
 ;;=2931201
 ;;^DD(.404421,0)
 ;;=HELP SUB-FIELD^^.01^1
 ;;^DD(.404421,0,"DT")
 ;;=2930218
 ;;^DD(.404421,0,"NM","HELP")
 ;;=
 ;;^DD(.404421,0,"UP")
 ;;=.4044
 ;;^DD(.404421,.01,0)
 ;;=HELP^W^^0;1^Q
 ;;^DD(.404421,.01,21,0)
 ;;=^^3^3^2940908^
 ;;^DD(.404421,.01,21,1,0)
 ;;=This text is displayed when the user enters ? at this form-only field.
 ;;^DD(.404421,.01,21,2,0)
 ;;=The lines in this word processing field correspond to the nodes in the
 ;;^DD(.404421,.01,21,3,0)
 ;;=DIR("?",#) input array to ^DIR.
 ;;^DD(.404421,.01,"DT")
 ;;=2930812
