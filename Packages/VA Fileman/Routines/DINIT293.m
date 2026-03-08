DINIT293 ;SFISC/MKO-SCREENMAN FILES ;11/28/94  11:42 AM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) G:X="" ^DINIT294 S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^DD(.4031,1,21,6,0)
 ;;=blocks.  Display-type blocks, with a coordinate of '1,1' relative to the
 ;;^DD(.4031,1,21,7,0)
 ;;=page, provide the same functionality as header blocks.
 ;;^DD(.4031,1,"DT")
 ;;=2930702
 ;;^DD(.4031,2,0)
 ;;=PAGE COORDINATE^F^^0;3^K:$L(X)>7!($L(X)<1)!'(X?.N1",".N) X
 ;;^DD(.4031,2,3)
 ;;=Enter the coordinate of the upper left corner of the page.  Answer must be two positive integers separated by a comma (,), as follows:  'Upper left row,Upper left column'.
 ;;^DD(.4031,2,21,0)
 ;;=^^13^13^2940908^
 ;;^DD(.4031,2,21,1,0)
 ;;=The Page Coordinate property defines the location of the top left corner
 ;;^DD(.4031,2,21,2,0)
 ;;=of the page on the screen.  The format of a coordinate is:  Row,Column.
 ;;^DD(.4031,2,21,3,0)
 ;;=Regular pages normally have a Page Coordinate of  "1,1".  They do not have
 ;;^DD(.4031,2,21,4,0)
 ;;=a Lower Right Coordinate.
 ;;^DD(.4031,2,21,5,0)
 ;;= 
 ;;^DD(.4031,2,21,6,0)
 ;;=The Page Coordinate of pop-up pages defines the position of the top left
 ;;^DD(.4031,2,21,7,0)
 ;;=corner of the border of the pop-up page.  Pop-up pages must have a Lower
 ;;^DD(.4031,2,21,8,0)
 ;;=Right Coordinate, which defines the position of the bottom right corner of
 ;;^DD(.4031,2,21,9,0)
 ;;=the border of the pop-up page.
 ;;^DD(.4031,2,21,10,0)
 ;;= 
 ;;^DD(.4031,2,21,11,0)
 ;;=All blocks on the page are positioned relative to the page on which they
 ;;^DD(.4031,2,21,12,0)
 ;;=are defined.  If a page is moved -- that is, if the Page Coordinate is
 ;;^DD(.4031,2,21,13,0)
 ;;=changed -- all blocks and all fields on that page move with it.
 ;;^DD(.4031,2,"DT")
 ;;=2940908
 ;;^DD(.4031,3,0)
 ;;=NEXT PAGE^NJ5,1^^0;4^K:+X'=X!(X>999.9)!(X<1)!(X?.E1"."2N.N) X
 ;;^DD(.4031,3,3)
 ;;=Answer must be a Number between 1 and 999.9, 1 Decimal Digit.
 ;;^DD(.4031,3,21,0)
 ;;=^^9^9^2940908^
 ;;^DD(.4031,3,21,1,0)
 ;;=Enter the page to go to when the user presses <PF1><Down> or selects the
 ;;^DD(.4031,3,21,2,0)
 ;;=NEXT PAGE command from the Command Line.
 ;;^DD(.4031,3,21,3,0)
 ;;= 
 ;;^DD(.4031,3,21,4,0)
 ;;=When the user attempts a Save, ScreenMan follows the Next Page links
 ;;^DD(.4031,3,21,5,0)
 ;;=starting with the first page displayed to the user.  ScreenMan loads all
 ;;^DD(.4031,3,21,6,0)
 ;;=those pages, including any defaults, and checks that all required fields
 ;;^DD(.4031,3,21,7,0)
 ;;=have values.  If any of the required fields have null values, no Save
 ;;^DD(.4031,3,21,8,0)
 ;;=occurs.  If all required field have values, Screenman Saves the data,
 ;;^DD(.4031,3,21,9,0)
 ;;=including all defaults.
 ;;^DD(.4031,4,0)
 ;;=PREVIOUS PAGE^NJ5,1^^0;5^K:+X'=X!(X>999.9)!(X<1)!(X?.E1"."2N.N) X
 ;;^DD(.4031,4,3)
 ;;=Answer must be a Number between 1 and 999.9, 1 Decimal Digit.
 ;;^DD(.4031,4,21,0)
 ;;=^^1^1^2940907^
 ;;^DD(.4031,4,21,1,0)
 ;;=Enter the page to go to when the user presses <PF1><Up>.
 ;;^DD(.4031,5,0)
 ;;=IS THIS A POP UP PAGE?^S^0:NO;1:YES;^0;6^Q
 ;;^DD(.4031,5,1,0)
 ;;=^.1
 ;;^DD(.4031,5,1,1,0)
 ;;=.4031^AC^MUMPS
 ;;^DD(.4031,5,1,1,1)
 ;;=S:X $P(^DIST(.403,DA(1),40,DA,0),U,2)=""
 ;;^DD(.4031,5,1,1,2)
 ;;=Q
 ;;^DD(.4031,5,1,1,3)
 ;;=Programmer only
 ;;^DD(.4031,5,1,1,"%D",0)
 ;;=^^1^1^2940627^
 ;;^DD(.4031,5,1,1,"%D",1,0)
 ;;=If this is a pop up page, there can be no header block.
 ;;^DD(.4031,5,1,1,"DT")
 ;;=2940627
 ;;^DD(.4031,5,3)
 ;;=
 ;;^DD(.4031,5,21,0)
 ;;=^^8^8^2940908^
 ;;^DD(.4031,5,21,1,0)
 ;;=If the page is a pop-up page rather than a regular page, set this property
 ;;^DD(.4031,5,21,2,0)
 ;;=to 'YES'.
 ;;^DD(.4031,5,21,3,0)
 ;;= 
 ;;^DD(.4031,5,21,4,0)
 ;;=ScreenMan displays pop-up pages with a border, on top of what is
 ;;^DD(.4031,5,21,5,0)
 ;;=already on the screen.  The top left coordinate of the pop-up page
 ;;^DD(.4031,5,21,6,0)
 ;;=defines the location of the top left corner of the border.  Pop-up
 ;;^DD(.4031,5,21,7,0)
 ;;=pages must also have a lower right coordinate, which defines the location
 ;;^DD(.4031,5,21,8,0)
 ;;=of the bottom left corner of the border.
 ;;^DD(.4031,5,"DT")
 ;;=2940627
 ;;^DD(.4031,6,0)
 ;;=LOWER RIGHT COORDINATE^F^^0;7^K:$L(X)>7!($L(X)<1)!'(X?.N1",".N) X
 ;;^DD(.4031,6,3)
 ;;=Enter the coordinate of the bottom right corner of the pop up page.  Answer must be two positive integers separated by a comma (,), as follows:  'Lower right row,Lower right column'.
 ;;^DD(.4031,6,21,0)
 ;;=^^4^4^2940908^
