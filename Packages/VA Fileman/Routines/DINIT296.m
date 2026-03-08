DINIT296 ;SFISC/MKO-SCREENMAN FILES ;11/28/94  11:42 AM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) G:X="" ^DINIT297 S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^DD(.4032,4,3)
 ;;=Answer must be 1-245 characters in length.
 ;;^DD(.4032,4,21,0)
 ;;=^^9^9^2940907^^
 ;;^DD(.4032,4,21,1,0)
 ;;=If the fields displayed in this block are reached through a relational
 ;;^DD(.4032,4,21,2,0)
 ;;=jump from the primary file of the form, enter the relational expression
 ;;^DD(.4032,4,21,3,0)
 ;;=that describes this jump.  Your frame of reference is the primary file of
 ;;^DD(.4032,4,21,4,0)
 ;;=the form.
 ;;^DD(.4032,4,21,5,0)
 ;;= 
 ;;^DD(.4032,4,21,6,0)
 ;;=For example, if the primary file has a field #999 called TEST that points
 ;;^DD(.4032,4,21,7,0)
 ;;=to the file associated with this block, enter
 ;;^DD(.4032,4,21,8,0)
 ;;= 
 ;;^DD(.4032,4,21,9,0)
 ;;=     999 or TEST
 ;;^DD(.4032,4,"DT")
 ;;=2931201
 ;;^DD(.4032,5,0)
 ;;=REPLICATION^NJ3,0^^2;1^K:+X'=X!(X>999)!(X<2)!(X?.E1"."1N.N) X
 ;;^DD(.4032,5,3)
 ;;=Type a Number between 2 and 999, 0 Decimal Digits
 ;;^DD(.4032,5,21,0)
 ;;=^^3^3^2940907^^
 ;;^DD(.4032,5,21,1,0)
 ;;=If this is a repeating block, enter the number of times the fields
 ;;^DD(.4032,5,21,2,0)
 ;;=defined in this block should be replicated.  If used, this number must
 ;;^DD(.4032,5,21,3,0)
 ;;=be greater than 1.
 ;;^DD(.4032,5,"DT")
 ;;=2940503
 ;;^DD(.4032,6,0)
 ;;=INDEX^F^^2;2^K:$L(X)>63!($L(X)<1) X
 ;;^DD(.4032,6,3)
 ;;=Answer must be 1-63 characters in length.
 ;;^DD(.4032,6,21,0)
 ;;=^^7^7^2941020^
 ;;^DD(.4032,6,21,1,0)
 ;;=Enter the name of the cross reference that should be used to pick up the
 ;;^DD(.4032,6,21,2,0)
 ;;=subentries in the multiple.  ScreenMan will initially display the
 ;;^DD(.4032,6,21,3,0)
 ;;=subentries to the user sorted in the order defined by this index.  The
 ;;^DD(.4032,6,21,4,0)
 ;;=default INDEX is B.
 ;;^DD(.4032,6,21,5,0)
 ;;= 
 ;;^DD(.4032,6,21,6,0)
 ;;=If the multiple has no index, or you wish to display the subentries
 ;;^DD(.4032,6,21,7,0)
 ;;=in record number order, enter !IEN.
 ;;^DD(.4032,6,"DT")
 ;;=2940503
 ;;^DD(.4032,7,0)
 ;;=INITIAL POSITION^S^f:FIRST;l:LAST;n:NEW;^2;3^Q
 ;;^DD(.4032,7,21,0)
 ;;=^^5^5^2940908^
 ;;^DD(.4032,7,21,1,0)
 ;;=This is the position in the list where the cursor should initially rest
 ;;^DD(.4032,7,21,2,0)
 ;;=when the user first navigates to the repeating block.  Possible values are
 ;;^DD(.4032,7,21,3,0)
 ;;=FIRST, LAST, and NEW, where NEW indicates that the cursor should initially
 ;;^DD(.4032,7,21,4,0)
 ;;=rest on the blank line at the end of the list.  The default INITIAL
 ;;^DD(.4032,7,21,5,0)
 ;;=POSITION is FIRST.
 ;;^DD(.4032,7,"DT")
 ;;=2940503
 ;;^DD(.4032,8,0)
 ;;=DISALLOW LAYGO^S^0:NO;1:YES;^2;4^Q
 ;;^DD(.4032,8,21,0)
 ;;=^^3^3^2940907^^
 ;;^DD(.4032,8,21,1,0)
 ;;=If set to YES, this prohibits the user from entering new subentries into
 ;;^DD(.4032,8,21,2,0)
 ;;=the multiple.  If null or set to NO, the setting in the data dictionary
 ;;^DD(.4032,8,21,3,0)
 ;;=determines whether LAYGO is allowed.
 ;;^DD(.4032,8,"DT")
 ;;=2940505
 ;;^DD(.4032,9,0)
 ;;=FIELD FOR SELECTION^F^^2;5^K:$L(X)>30!($L(X)<1) X
 ;;^DD(.4032,9,3)
 ;;=Answer must be 1-30 characters in length.
 ;;^DD(.4032,9,21,0)
 ;;=^^5^5^2940907^^
 ;;^DD(.4032,9,21,1,0)
 ;;=This is the field order of the field that defines the column position of
 ;;^DD(.4032,9,21,2,0)
 ;;=the blank line at the end of the list.  The default is the first editable
 ;;^DD(.4032,9,21,3,0)
 ;;=field in the block.  This is also the field before which ScreenMan prints
 ;;^DD(.4032,9,21,4,0)
 ;;=the plus sign (+) to indicate there are more entries above or below the
 ;;^DD(.4032,9,21,5,0)
 ;;=displayed list.
 ;;^DD(.4032,9,"DT")
 ;;=2940506
 ;;^DD(.4032,11,0)
 ;;=PRE ACTION^K^^11;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.4032,11,3)
 ;;=This is Standard MUMPS code.
 ;;^DD(.4032,11,9)
 ;;=@
 ;;^DD(.4032,11,21,0)
 ;;=^^5^5^2940907^
 ;;^DD(.4032,11,21,1,0)
 ;;=Enter MUMPS code that is executed whenever the user reaches this block.
 ;;^DD(.4032,11,21,2,0)
 ;;= 
 ;;^DD(.4032,11,21,3,0)
 ;;=This pre-action is a characteristic of the block only as it is used on
 ;;^DD(.4032,11,21,4,0)
 ;;=this form.  If you place this block on another form, you can define a
 ;;^DD(.4032,11,21,5,0)
 ;;=different pre-action.
 ;;^DD(.4032,11,"DT")
 ;;=2930610
 ;;^DD(.4032,12,0)
 ;;=POST ACTION^K^^12;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.4032,12,3)
 ;;=This is Standard MUMPS code.
 ;;^DD(.4032,12,9)
 ;;=@
 ;;^DD(.4032,12,21,0)
 ;;=^^5^5^2940907^
 ;;^DD(.4032,12,21,1,0)
 ;;=Enter MUMPS code that is executed whenever the user leaves this block.
