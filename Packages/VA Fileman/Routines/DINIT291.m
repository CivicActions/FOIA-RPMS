DINIT291 ;SFISC/MKO-SCREENMAN FILES ;11/28/94  11:42 AM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) G:X="" ^DINIT292 S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^DD(.403,3,21,1,0)
 ;;=This is the DUZ of the person who created the form.  The ScreenMan
 ;;^DD(.403,3,21,2,0)
 ;;=options to create the form automatically put a value into this field.
 ;;^DD(.403,4,0)
 ;;=DATE CREATED^D^^0;5^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
 ;;^DD(.403,4,3)
 ;;=Enter the date the form was created.
 ;;^DD(.403,4,21,0)
 ;;=^^2^2^2941018^^
 ;;^DD(.403,4,21,1,0)
 ;;=This is the date the form was created.  The ScreenMan options to create
 ;;^DD(.403,4,21,2,0)
 ;;=the form automatically put a value into this field.
 ;;^DD(.403,4,"DT")
 ;;=2941018
 ;;^DD(.403,5,0)
 ;;=DATE LAST USED^D^^0;6^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
 ;;^DD(.403,5,3)
 ;;=Enter the date and time the form was last used.
 ;;^DD(.403,5,21,0)
 ;;=^^2^2^2941018^^
 ;;^DD(.403,5,21,1,0)
 ;;=This is the date the form was last used.  ScreenMan automatically
 ;;^DD(.403,5,21,2,0)
 ;;=puts a value into this field when the form is invoked.
 ;;^DD(.403,5,"DT")
 ;;=2941018
 ;;^DD(.403,6,0)
 ;;=TITLE^F^^0;7^K:$L(X)>50!($L(X)<1) X
 ;;^DD(.403,6,1,0)
 ;;=^.1
 ;;^DD(.403,6,1,1,0)
 ;;=.403^C
 ;;^DD(.403,6,1,1,1)
 ;;=S ^DIST(.403,"C",$E(X,1,30),DA)=""
 ;;^DD(.403,6,1,1,2)
 ;;=K ^DIST(.403,"C",$E(X,1,30),DA)
 ;;^DD(.403,6,1,1,"DT")
 ;;=2940908
 ;;^DD(.403,6,3)
 ;;=Answer must be 1-50 characters in length.
 ;;^DD(.403,6,21,0)
 ;;=^^4^4^2940908^
 ;;^DD(.403,6,21,1,0)
 ;;=The TITLE property can be used by the form designer to help identify a
 ;;^DD(.403,6,21,2,0)
 ;;=form.  It is cross referenced and need not be unique.  ScreenMan does not
 ;;^DD(.403,6,21,3,0)
 ;;=automatically display the TITLE to the user, but the form designer can
 ;;^DD(.403,6,21,4,0)
 ;;=choose to define a caption-only field that displays the title to the user.
 ;;^DD(.403,6,22)
 ;;=
 ;;^DD(.403,6,"DT")
 ;;=2940908
 ;;^DD(.403,7,0)
 ;;=PRIMARY FILE^RFX^^0;8^K:X'=+$P(X,"E")!(X<2)!($L(X)>16)!'$D(^DIC(X)) X
 ;;^DD(.403,7,1,0)
 ;;=^.1
 ;;^DD(.403,7,1,1,0)
 ;;=.403^F^MUMPS
 ;;^DD(.403,7,1,1,1)
 ;;=X "S %=$P("_DIC_"DA,0),U) S "_DIC_"""F""_X,%,DA)=1"
 ;;^DD(.403,7,1,1,2)
 ;;=X "S %=$P("_DIC_"DA,0),U) K "_DIC_"""F""_X,%,DA)"
 ;;^DD(.403,7,1,1,3)
 ;;=Programmer only
 ;;^DD(.403,7,1,1,"%D",0)
 ;;=^^2^2^2900911^
 ;;^DD(.403,7,1,1,"%D",0,"LE")
 ;;=1
 ;;^DD(.403,7,1,1,"%D",1,0)
 ;;=This cross-reference is used to quickly find all ScreenMan templates
 ;;^DD(.403,7,1,1,"%D",2,0)
 ;;=associated with a file.
 ;;^DD(.403,7,1,1,"DT")
 ;;=2900911
 ;;^DD(.403,7,3)
 ;;=Answer must be 1-16 characters in length.
 ;;^DD(.403,7,21,0)
 ;;=^^2^2^2920407^
 ;;^DD(.403,7,21,1,0)
 ;;=Enter a file number, greater than or equal to 2, which represents the data
 ;;^DD(.403,7,21,2,0)
 ;;=dictionary number of the primary file for this form.
 ;;^DD(.403,7,"DT")
 ;;=2920407
 ;;^DD(.403,8,0)
 ;;=DISPLAY ONLY^SI^0:NO;1:YES;^0;9^Q
 ;;^DD(.403,8,21,0)
 ;;=^^2^2^2931027^^^^
 ;;^DD(.403,8,21,1,0)
 ;;=This is a flag that indicates none of the blocks on the form are edit
 ;;^DD(.403,8,21,2,0)
 ;;=blocks.  This flag is set during form compilation.
 ;;^DD(.403,8,"DT")
 ;;=2931028
 ;;^DD(.403,9,0)
 ;;=FORM ONLY^SI^0:NO;1:YES;^0;10^Q
 ;;^DD(.403,9,21,0)
 ;;=^^2^2^2931027^
 ;;^DD(.403,9,21,1,0)
 ;;=This is a flag that indicates none of the fields on the form are data
 ;;^DD(.403,9,21,2,0)
 ;;=dictionary fields.  This flag is set during form compilation.
 ;;^DD(.403,9,"DT")
 ;;=2931028
 ;;^DD(.403,10,0)
 ;;=COMPILED^SI^0:NO;1:YES;^0;11^Q
 ;;^DD(.403,10,1,0)
 ;;=^.1^^0
 ;;^DD(.403,10,21,0)
 ;;=^^2^2^2940908^
 ;;^DD(.403,10,21,1,0)
 ;;=This is a flag that indicates that the form is compiled.  This flag is
 ;;^DD(.403,10,21,2,0)
 ;;=set during form compilation.
 ;;^DD(.403,10,"DT")
 ;;=2940701
 ;;^DD(.403,11,0)
 ;;=PRE ACTION^K^^11;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.403,11,3)
 ;;=Enter standard MUMPS code which will be executed at the beginning of the form.
 ;;^DD(.403,11,9)
 ;;=@
 ;;^DD(.403,11,21,0)
 ;;=^^2^2^2940906^
 ;;^DD(.403,11,21,1,0)
 ;;=This is MUMPS code that is executed when the form is first invoked,
 ;;^DD(.403,11,21,2,0)
 ;;=before any of the pages are loaded and displayed.
 ;;^DD(.403,12,0)
 ;;=POST ACTION^K^^12;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.403,12,3)
 ;;=Enter standard MUMPS code which will be executed at the end of the form.
 ;;^DD(.403,12,9)
 ;;=@
 ;;^DD(.403,12,21,0)
 ;;=^^2^2^2940906^^
 ;;^DD(.403,12,21,1,0)
 ;;=This is MUMPS code that is executed before ScreenMan returns to the
 ;;^DD(.403,12,21,2,0)
 ;;=calling application.
