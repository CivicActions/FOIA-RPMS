DINIT292 ;SFISC/MKO-SCREENMAN FILES ;11/28/94  11:42 AM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) G:X="" ^DINIT293 S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^DD(.403,14,0)
 ;;=POST SAVE^K^^14;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.403,14,3)
 ;;=This is Standard MUMPS code.
 ;;^DD(.403,14,9)
 ;;=@
 ;;^DD(.403,14,21,0)
 ;;=^^2^2^2940906^
 ;;^DD(.403,14,21,1,0)
 ;;=This is MUMPS code that is executed when the user saves changes.  It is 
 ;;^DD(.403,14,21,2,0)
 ;;=executed only if all data is valid, and after all data has been filed.
 ;;^DD(.403,14,"DT")
 ;;=2930813
 ;;^DD(.403,15,0)
 ;;=DESCRIPTION^.40315^^15;0
 ;;^DD(.403,20,0)
 ;;=DATA VALIDATION^K^^20;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.403,20,3)
 ;;=Enter standard MUMPS code.
 ;;^DD(.403,20,9)
 ;;=@
 ;;^DD(.403,20,21,0)
 ;;=^^8^8^2940906^
 ;;^DD(.403,20,21,1,0)
 ;;=This is MUMPS code that is executed when the user attempts to save changes
 ;;^DD(.403,20,21,2,0)
 ;;=to the form.  If the code sets DDSERROR, the user is unable to save
 ;;^DD(.403,20,21,3,0)
 ;;=changes.  If the code sets DDSBR, the user is taken to the specified
 ;;^DD(.403,20,21,4,0)
 ;;=field.
 ;;^DD(.403,20,21,5,0)
 ;;= 
 ;;^DD(.403,20,21,6,0)
 ;;=In addition to $$GET^DDSVAL, PUT^DDSVAL, and HLP^DDSUTL, you 
 ;;^DD(.403,20,21,7,0)
 ;;=can use MSG^DDSUTL to print on a separate screen messages to the user 
 ;;^DD(.403,20,21,8,0)
 ;;=about the validity of the data.
 ;;^DD(.403,21,0)
 ;;=RECORD SELECTION PAGE^NJ5,1^^21;1^K:+X'=X!(X>999.9)!(X<1)!(X?.E1"."2N.N) X
 ;;^DD(.403,21,3)
 ;;=Type a Number between 1 and 999.9, 1 Decimal Digit
 ;;^DD(.403,21,21,0)
 ;;=^^12^12^2940906^
 ;;^DD(.403,21,21,1,0)
 ;;=Enter the page number of the page that is used for record selection.
 ;;^DD(.403,21,21,2,0)
 ;;= 
 ;;^DD(.403,21,21,3,0)
 ;;=If you define a Record Selection Page, the user can select another entry
 ;;^DD(.403,21,21,4,0)
 ;;=in the file, and, if LAYGO is allowed, add another entry into the file
 ;;^DD(.403,21,21,5,0)
 ;;=without exiting the form.  The Record Selection Page should be a pop-up
 ;;^DD(.403,21,21,6,0)
 ;;=page that contains one form-only field that performs a pointer-type read
 ;;^DD(.403,21,21,7,0)
 ;;=into the Primary File of the form.  The Record Selection Page property
 ;;^DD(.403,21,21,8,0)
 ;;=should be set equal to the Page Number of the Record Selection Page.
 ;;^DD(.403,21,21,9,0)
 ;;= 
 ;;^DD(.403,21,21,10,0)
 ;;=The user can open the Record Selection Page by pressing <PF1>L.  After the
 ;;^DD(.403,21,21,11,0)
 ;;=user selects a record and closes the Record Selection Page, the data for
 ;;^DD(.403,21,21,12,0)
 ;;=the selected record is displayed.
 ;;^DD(.403,21,"DT")
 ;;=2930225
 ;;^DD(.403,40,0)
 ;;=PAGE^.4031I^^40;0
 ;;^DD(.403,40,"DT")
 ;;=2930218
 ;;^DD(.4031,0)
 ;;=PAGE SUB-FIELD^^40^13
 ;;^DD(.4031,0,"DT")
 ;;=2940506
 ;;^DD(.4031,0,"ID","WRITE")
 ;;=D:$D(^(1))#2 EN^DDIOL($P(^(1),U),"","?12")
 ;;^DD(.4031,0,"IX","AC",.4031,5)
 ;;=
 ;;^DD(.4031,0,"IX","B",.4031,.01)
 ;;=
 ;;^DD(.4031,0,"IX","C",.4031,7)
 ;;=
 ;;^DD(.4031,0,"NM","PAGE")
 ;;=
 ;;^DD(.4031,0,"UP")
 ;;=.403
 ;;^DD(.4031,.01,0)
 ;;=PAGE NUMBER^MNJ5,1X^^0;1^K:+X'=X!(X>999.9)!(X<1)!(X?.E1"."2N.N)!$D(^DIST(.403,DA(1),40,"B",X)) X
 ;;^DD(.4031,.01,1,0)
 ;;=^.1
 ;;^DD(.4031,.01,1,1,0)
 ;;=.4031^B
 ;;^DD(.4031,.01,1,1,1)
 ;;=S ^DIST(.403,DA(1),40,"B",$E(X,1,30),DA)=""
 ;;^DD(.4031,.01,1,1,2)
 ;;=K ^DIST(.403,DA(1),40,"B",$E(X,1,30),DA)
 ;;^DD(.4031,.01,3)
 ;;=Enter a number between 1 and 999.9, up to 1 Decimal Digit, that identifies the page.
 ;;^DD(.4031,.01,21,0)
 ;;=^^2^2^2940907^^^
 ;;^DD(.4031,.01,21,1,0)
 ;;=This is the unique page number of the page.  You can use this number to
 ;;^DD(.4031,.01,21,2,0)
 ;;=refer to the page in ScreenMan functions and utilities.
 ;;^DD(.4031,1,0)
 ;;=HEADER BLOCK^P.404^DIST(.404,^0;2^Q
 ;;^DD(.4031,1,1,0)
 ;;=^.1
 ;;^DD(.4031,1,1,1,0)
 ;;=.403^AC
 ;;^DD(.4031,1,1,1,1)
 ;;=S ^DIST(.403,"AC",$E(X,1,30),DA(1),DA)=""
 ;;^DD(.4031,1,1,1,2)
 ;;=K ^DIST(.403,"AC",$E(X,1,30),DA(1),DA)
 ;;^DD(.4031,1,1,1,"DT")
 ;;=2930702
 ;;^DD(.4031,1,3)
 ;;=Enter the block which will be used as a header for this page.
 ;;^DD(.4031,1,21,0)
 ;;=^^7^7^2940907^^^
 ;;^DD(.4031,1,21,1,0)
 ;;=The header block always appears at row 1, column 1 relative to the page
 ;;^DD(.4031,1,21,2,0)
 ;;=on which it is defined.  It is for display purposes only -- the user
 ;;^DD(.4031,1,21,3,0)
 ;;=is unable to navigate to any of the fields on the header block.
 ;;^DD(.4031,1,21,4,0)
 ;;= 
 ;;^DD(.4031,1,21,5,0)
 ;;=Starting with Version 21 of FileMan, there is no need to use header
