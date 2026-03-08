DINIT29A ;SFISC/MKO-SCREENMAN FILES ;11/28/94  11:42 AM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) G:X="" ^DINIT29B S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^DD(.4044,3,21,0)
 ;;=^^10^10^2940907^
 ;;^DD(.4044,3,21,1,0)
 ;;=Display group helps users resolve ambiguity when they attempt to ^-jump to
 ;;^DD(.4044,3,21,2,0)
 ;;=a field that has a caption that is not unique.  If more than one field has
 ;;^DD(.4044,3,21,3,0)
 ;;=the same caption, when users try to ^-jump to a field with that caption,
 ;;^DD(.4044,3,21,4,0)
 ;;=they are presented with a list of fields to choose from.  The text in the
 ;;^DD(.4044,3,21,5,0)
 ;;=Display Group property is displayed in parentheses after the caption to
 ;;^DD(.4044,3,21,6,0)
 ;;=help the user identify the correct field.
 ;;^DD(.4044,3,21,7,0)
 ;;= 
 ;;^DD(.4044,3,21,8,0)
 ;;=For example, if two fields have the caption 'NAME:', but one of those
 ;;^DD(.4044,3,21,9,0)
 ;;=fields has a Display Group 'Next of Kin', when users enter ^NAME, they
 ;;^DD(.4044,3,21,10,0)
 ;;=will be asked to choose between 'NAME' and 'NAME (Next of Kin)'.
 ;;^DD(.4044,3.1,0)
 ;;=UNIQUE NAME^FX^^0;5^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>50!($L(X)<3)!$D(^DIST(.404,DA(1),40,"D",X)) X
 ;;^DD(.4044,3.1,1,0)
 ;;=^.1
 ;;^DD(.4044,3.1,1,1,0)
 ;;=.4044^D^MUMPS
 ;;^DD(.4044,3.1,1,1,1)
 ;;=S ^DIST(.404,DA(1),40,"D",$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ"),DA)=""
 ;;^DD(.4044,3.1,1,1,2)
 ;;=K ^DIST(.404,DA(1),40,"D",$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ"),DA)
 ;;^DD(.4044,3.1,1,1,3)
 ;;=Programmer only
 ;;^DD(.4044,3.1,1,1,"%D",0)
 ;;=^^1^1^2930816^
 ;;^DD(.4044,3.1,1,1,"%D",1,0)
 ;;=This is a regular index of the Unique Name converted to uppercase.
 ;;^DD(.4044,3.1,1,1,"DT")
 ;;=2930816
 ;;^DD(.4044,3.1,3)
 ;;=Answer must be 1-50 characters in length.
 ;;^DD(.4044,3.1,21,0)
 ;;=^^5^5^2940907^
 ;;^DD(.4044,3.1,21,1,0)
 ;;=This is the unique name of the element on the block.  No two elements on
 ;;^DD(.4044,3.1,21,2,0)
 ;;=the block can have the same Unique Name.  Unique Names are never seen by
 ;;^DD(.4044,3.1,21,3,0)
 ;;=the user.  You can refer to an element on a block by its Unique Name in
 ;;^DD(.4044,3.1,21,4,0)
 ;;=some of the ScreenMan utilities such as PUT^DDSVAL and $$GET^DDSVAL, and
 ;;^DD(.4044,3.1,21,5,0)
 ;;=in the computed expressions of computed fields.
 ;;^DD(.4044,3.1,"DT")
 ;;=2930816
 ;;^DD(.4044,4,0)
 ;;=FIELD^FX^^1;1^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>245!($L(X)<1) X I $D(X),$D(DDGFDD) D IXF^DDS0
 ;;^DD(.4044,4,1,0)
 ;;=^.1^^0
 ;;^DD(.4044,4,3)
 ;;=Answer must be 1-245 characters in length.
 ;;^DD(.4044,4,4)
 ;;=I $D(DDGFDD) N D0,DA,DIC,D,DZ S DIC="^DD("_DDGFDD_",",DIC(0)="",D="B" S:$G(X)="??" DZ=X D DQ^DICQ
 ;;^DD(.4044,4,21,0)
 ;;=^^2^2^2940907^
 ;;^DD(.4044,4,21,1,0)
 ;;=Enter the number or name of a field in the file defined by the data
 ;;^DD(.4044,4,21,2,0)
 ;;=dictionary number for this block.
 ;;^DD(.4044,4,"DT")
 ;;=2940823
 ;;^DD(.4044,4.1,0)
 ;;=DATA COORDINATE^F^^2;1^K:$L(X)>7!($L(X)<1)!'(X?.N1",".N) X
 ;;^DD(.4044,4.1,3)
 ;;=Enter the field coordinate relative to the block.  Answer must be two positive integers separated by a comma (,), as follows:  'Row,Column'.
 ;;^DD(.4044,4.1,21,0)
 ;;=^^2^2^2940907^
 ;;^DD(.4044,4.1,21,1,0)
 ;;=Data coordinate is relative to the position of the block.  The top left
 ;;^DD(.4044,4.1,21,2,0)
 ;;=corner of the block has a coordinate of 1,1.
 ;;^DD(.4044,4.1,"DT")
 ;;=2940908
 ;;^DD(.4044,4.2,0)
 ;;=DATA LENGTH^NJ3,0^^2;2^K:+X'=X!(X>245)!(X<1)!(X?.E1"."1N.N) X
 ;;^DD(.4044,4.2,3)
 ;;=Enter a Number between 1 and 245, inclusive, which represents the maximum length of the data to be displayed on the screen.
 ;;^DD(.4044,4.2,21,0)
 ;;=^^4^4^2940907^^
 ;;^DD(.4044,4.2,21,1,0)
 ;;=The data length defines the size of the editing window.  The editing
 ;;^DD(.4044,4.2,21,2,0)
 ;;=window is a single line and must not extend into or beyond the rightmost
 ;;^DD(.4044,4.2,21,3,0)
 ;;=column on the screen.  On an 80 column screen, the editing window
 ;;^DD(.4044,4.2,21,4,0)
 ;;=must not extend beyond column 79.
 ;;^DD(.4044,5.1,0)
 ;;=CAPTION COORDINATE^F^^2;3^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>7!($L(X)<1)!'(X?.N1",".N) X
 ;;^DD(.4044,5.1,1,0)
 ;;=^.1^^0
 ;;^DD(.4044,5.1,3)
 ;;=Enter the caption coordinate relative to the block.  Answer must be two positive integers separated by a comma (,), as follows:  'Row,Column'.
 ;;^DD(.4044,5.1,21,0)
 ;;=^^2^2^2940907^^
 ;;^DD(.4044,5.1,21,1,0)
 ;;=Caption coordinate is relative to the position of the block.  The
