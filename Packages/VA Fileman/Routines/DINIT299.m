DINIT299 ;SFISC/MKO-SCREENMAN FILES ;11/28/94  11:42 AM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) G:X="" ^DINIT29A S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^DD(.4044,0,"ID","WRITE1")
 ;;=D EN^DDIOL($S($P($G(^(7)),U,2):"  (Sub Page Link defined)",1:"")_$S($G(^(1)):"   (Field #"_^(1)_")",1:"")_$S($P(^(0),U,5)]"":"  ("_$P(^(0),U,5)_")",1:""),"","?0")
 ;;^DD(.4044,0,"IX","B",.4044,.01)
 ;;=
 ;;^DD(.4044,0,"IX","C",.4044,1)
 ;;=
 ;;^DD(.4044,0,"IX","D",.4044,3.1)
 ;;=
 ;;^DD(.4044,0,"NM","FIELD")
 ;;=
 ;;^DD(.4044,0,"UP")
 ;;=.404
 ;;^DD(.4044,.01,0)
 ;;=FIELD ORDER^MNJ4,1X^^0;1^K:X'=+$P(X,"E")!(X>99.9)!(X<0)!(X?.E1"."2N.N) X I $D(X),$D(^DIST(.404,DA(1),40,"B",X)) K X
 ;;^DD(.4044,.01,1,0)
 ;;=^.1
 ;;^DD(.4044,.01,1,1,0)
 ;;=.4044^B
 ;;^DD(.4044,.01,1,1,1)
 ;;=S ^DIST(.404,DA(1),40,"B",$E(X,1,30),DA)=""
 ;;^DD(.4044,.01,1,1,2)
 ;;=K ^DIST(.404,DA(1),40,"B",$E(X,1,30),DA)
 ;;^DD(.4044,.01,3)
 ;;=Enter a unique number between 0 and 99.9, inclusive, which represents the order in which the fields will be edited.
 ;;^DD(.4044,.01,21,0)
 ;;=^^2^2^2940907^
 ;;^DD(.4044,.01,21,1,0)
 ;;=The Field Order number determines the order in which users traverse the
 ;;^DD(.4044,.01,21,2,0)
 ;;=fields in the block as they press <RET>.
 ;;^DD(.4044,1,0)
 ;;=CAPTION^FX^^0;2^K:$L(X)>80!($L(X)<1) X S:$E($G(X))="!"&($G(X)'="!M") X=$$FUNC^DDSCAP(X)
 ;;^DD(.4044,1,1,0)
 ;;=^.1^^-1
 ;;^DD(.4044,1,1,2,0)
 ;;=.4044^C^MUMPS
 ;;^DD(.4044,1,1,2,1)
 ;;=S:X'="!M" ^DIST(.404,DA(1),40,"C",$TR($E($S(X?1"Select "1.E:$P(X,"Select ",2,99),1:X),1,63),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ"),DA)=""
 ;;^DD(.4044,1,1,2,2)
 ;;=K:X'="!M" ^DIST(.404,DA(1),40,"C",$TR($E($S(X?1"Select "1.E:$P(X,"Select ",2,99),1:X),1,63),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ"),DA)
 ;;^DD(.4044,1,1,2,3)
 ;;=Programmer only
 ;;^DD(.4044,1,1,2,"%D",0)
 ;;=^^2^2^2931029^^^^
 ;;^DD(.4044,1,1,2,"%D",1,0)
 ;;=This cross referenced is used to allow selection of fields by caption name
 ;;^DD(.4044,1,1,2,"%D",2,0)
 ;;=as well as by order number when entering new fields in the block.
 ;;^DD(.4044,1,1,2,"DT")
 ;;=2920214
 ;;^DD(.4044,1,3)
 ;;=Answer must be 1-80 characters in length.
 ;;^DD(.4044,1,21,0)
 ;;=^^6^6^2940907^
 ;;^DD(.4044,1,21,1,0)
 ;;=A caption is uneditable text that appears on the screen.  Captions of
 ;;^DD(.4044,1,21,2,0)
 ;;=data dictionary, form-only, and computed fields serve to identify for
 ;;^DD(.4044,1,21,3,0)
 ;;=the user the data portion of the fields.  Captions for these types of
 ;;^DD(.4044,1,21,4,0)
 ;;=fields are automatically followed by a colon, unless the Suppress Colon
 ;;^DD(.4044,1,21,5,0)
 ;;=After Caption property is set to 'YES.'  A field with an Executable
 ;;^DD(.4044,1,21,6,0)
 ;;=Caption must have '!M' as a Caption.
 ;;^DD(.4044,1,"DT")
 ;;=2940629
 ;;^DD(.4044,1.1,0)
 ;;=EXECUTABLE CAPTION^K^^.1;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.4044,1.1,3)
 ;;=Enter standard MUMPS code that sets the variable Y.
 ;;^DD(.4044,1.1,9)
 ;;=@
 ;;^DD(.4044,1.1,21,0)
 ;;=^^3^3^2940907^^
 ;;^DD(.4044,1.1,21,1,0)
 ;;=Enter MUMPS code that sets the variable Y equal to the caption you
 ;;^DD(.4044,1.1,21,2,0)
 ;;=want displayed.  This code is executed and the caption evaluated whenever
 ;;^DD(.4044,1.1,21,3,0)
 ;;=the page on which this caption is located is painted.
 ;;^DD(.4044,1.1,"DT")
 ;;=2920218
 ;;^DD(.4044,2,0)
 ;;=FIELD TYPE^*S^0:UNKNOWN;1:CAPTION ONLY;2:FORM ONLY;3:DATA DICTIONARY FIELD;4:COMPUTED;^0;3^Q
 ;;^DD(.4044,2,1,0)
 ;;=^.1^^0
 ;;^DD(.4044,2,3)
 ;;=
 ;;^DD(.4044,2,12)
 ;;=Enter the field type.
 ;;^DD(.4044,2,12.1)
 ;;=S DIC("S")="I Y"
 ;;^DD(.4044,2,21,0)
 ;;=^^11^11^2940907^
 ;;^DD(.4044,2,21,1,0)
 ;;=Enter the field type.
 ;;^DD(.4044,2,21,2,0)
 ;;= 
 ;;^DD(.4044,2,21,3,0)
 ;;=CAPTION ONLY fields are for displaying text on the screen.
 ;;^DD(.4044,2,21,4,0)
 ;;= 
 ;;^DD(.4044,2,21,5,0)
 ;;=FORM ONLY fields are fields defined only on the form and are not tied to a
 ;;^DD(.4044,2,21,6,0)
 ;;=field in a FileMan file.
 ;;^DD(.4044,2,21,7,0)
 ;;= 
 ;;^DD(.4044,2,21,8,0)
 ;;=DATA DICTIONARY fields are fields from a FileMan file.
 ;;^DD(.4044,2,21,9,0)
 ;;= 
 ;;^DD(.4044,2,21,10,0)
 ;;=COMPUTED fields, like form-only fields, are fields that are defined only
 ;;^DD(.4044,2,21,11,0)
 ;;=on the form.  Associated with a COMPUTED field is a computed expression.
 ;;^DD(.4044,2,"DT")
 ;;=2940907
 ;;^DD(.4044,3,0)
 ;;=DISPLAY GROUP^F^^0;4^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>20!($L(X)<1) X
 ;;^DD(.4044,3,3)
 ;;=Enter text, 1-20 characters in length, which represents the group to which this field belongs.
