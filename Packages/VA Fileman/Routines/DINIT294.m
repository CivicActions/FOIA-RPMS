DINIT294 ;SFISC/MKO-SCREENMAN FILES ;11/28/94  11:42 AM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) G:X="" ^DINIT295 S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^DD(.4031,6,21,1,0)
 ;;=The existence of a lower right coordinate implies that the page is a
 ;;^DD(.4031,6,21,2,0)
 ;;=pop-up page.  The lower right coordinate and the page coordinate define
 ;;^DD(.4031,6,21,3,0)
 ;;=the position of the border ScreenMan displays when it paints a pop-up
 ;;^DD(.4031,6,21,4,0)
 ;;=page.
 ;;^DD(.4031,6,"DT")
 ;;=2940908
 ;;^DD(.4031,7,0)
 ;;=PAGE NAME^FX^^1;1^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<3)!(X=+$P(X,"E")) X
 ;;^DD(.4031,7,1,0)
 ;;=^.1
 ;;^DD(.4031,7,1,1,0)
 ;;=.4031^C^MUMPS
 ;;^DD(.4031,7,1,1,1)
 ;;=S ^DIST(.403,DA(1),40,"C",$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ"),DA)=""
 ;;^DD(.4031,7,1,1,2)
 ;;=K ^DIST(.403,DA(1),40,"C",$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ"),DA)
 ;;^DD(.4031,7,1,1,3)
 ;;=Programmer only
 ;;^DD(.4031,7,1,1,"%D",0)
 ;;=^^2^2^2930816^
 ;;^DD(.4031,7,1,1,"%D",1,0)
 ;;=This cross reference is a regular index of the page name converted to all
 ;;^DD(.4031,7,1,1,"%D",2,0)
 ;;=upper case characters.
 ;;^DD(.4031,7,1,1,"DT")
 ;;=2930816
 ;;^DD(.4031,7,3)
 ;;=Enter the name of the page, 3-30 characters in length.
 ;;^DD(.4031,7,21,0)
 ;;=^^5^5^2940907^^
 ;;^DD(.4031,7,21,1,0)
 ;;=Like the Page Number, you can use the Page Name to refer to a page in
 ;;^DD(.4031,7,21,2,0)
 ;;=ScreenMan functions and utilities.  ScreenMan displays the Page Name to
 ;;^DD(.4031,7,21,3,0)
 ;;=the user if, during an attempt to file data, ScreenMan finds required
 ;;^DD(.4031,7,21,4,0)
 ;;=fields with null values.  ScreenMan uses the Caption of the field and the
 ;;^DD(.4031,7,21,5,0)
 ;;=Page Name to inform the user of the location of the required field.
 ;;^DD(.4031,7,"DT")
 ;;=2931020
 ;;^DD(.4031,8,0)
 ;;=PARENT FIELD^FX^^1;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>92!($L(X)<5)!'(X?1.E1","1.E1","1.E) X I $D(X) D PFIELD^DDSIT
 ;;^DD(.4031,8,1,0)
 ;;=^.1^^0
 ;;^DD(.4031,8,3)
 ;;=Answer must be 5-92 characters in length.
 ;;^DD(.4031,8,21,0)
 ;;=^^25^25^2940907^
 ;;^DD(.4031,8,21,1,0)
 ;;=This property can be used instead of Subpage Link to link a subpage to a
 ;;^DD(.4031,8,21,2,0)
 ;;=field.
 ;;^DD(.4031,8,21,3,0)
 ;;= 
 ;;^DD(.4031,8,21,4,0)
 ;;=Parent Field has the following format:
 ;;^DD(.4031,8,21,5,0)
 ;;= 
 ;;^DD(.4031,8,21,6,0)
 ;;=       Field id,Block id,Page id
 ;;^DD(.4031,8,21,7,0)
 ;;= 
 ;;^DD(.4031,8,21,8,0)
 ;;=where,
 ;;^DD(.4031,8,21,9,0)
 ;;= 
 ;;^DD(.4031,8,21,10,0)
 ;;=       Field id  =  Field Order number; or
 ;;^DD(.4031,8,21,11,0)
 ;;=                    Caption of the field; or
 ;;^DD(.4031,8,21,12,0)
 ;;=                    Unique Name of the field
 ;;^DD(.4031,8,21,13,0)
 ;;= 
 ;;^DD(.4031,8,21,14,0)
 ;;=       Block id  =  Block Order number; or
 ;;^DD(.4031,8,21,15,0)
 ;;=                    Block Name
 ;;^DD(.4031,8,21,16,0)
 ;;= 
 ;;^DD(.4031,8,21,17,0)
 ;;=       Page id   =  Page Number; or
 ;;^DD(.4031,8,21,18,0)
 ;;=                    Page Name
 ;;^DD(.4031,8,21,19,0)
 ;;= 
 ;;^DD(.4031,8,21,20,0)
 ;;=For example:
 ;;^DD(.4031,8,21,21,0)
 ;;= 
 ;;^DD(.4031,8,21,22,0)
 ;;=       ZZFIELD 1,ZZBLOCK 1,ZZPAGE 1
 ;;^DD(.4031,8,21,23,0)
 ;;= 
 ;;^DD(.4031,8,21,24,0)
 ;;=identifies the field with Caption or Unique Name "ZZFIELD 1," on the block
 ;;^DD(.4031,8,21,25,0)
 ;;=named "ZZBLOCK 1," on the page named "ZZPAGE 1".
 ;;^DD(.4031,8,"DT")
 ;;=2931201
 ;;^DD(.4031,11,0)
 ;;=PRE ACTION^K^^11;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.4031,11,3)
 ;;=Enter Standard MUMPS code that will be executed before the user reaches a page.
 ;;^DD(.4031,11,9)
 ;;=@
 ;;^DD(.4031,11,21,0)
 ;;=^^1^1^2940907^^^^
 ;;^DD(.4031,11,21,1,0)
 ;;=This MUMPS code is executed when the user reaches a page.
 ;;^DD(.4031,11,22)
 ;;=
 ;;^DD(.4031,12,0)
 ;;=POST ACTION^K^^12;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.4031,12,3)
 ;;=Enter Standard MUMPS code that will be executed after the user leaves a page.
 ;;^DD(.4031,12,9)
 ;;=@
 ;;^DD(.4031,12,21,0)
 ;;=^^1^1^2940907^^^
 ;;^DD(.4031,12,21,1,0)
 ;;=This MUMPS code is executed when the user leaves the page.
 ;;^DD(.4031,15,0)
 ;;=DESCRIPTION^.403115^^15;0
 ;;^DD(.4031,40,0)
 ;;=BLOCK^.4032IP^^40;0
 ;;^DD(.403115,0)
 ;;=DESCRIPTION SUB-FIELD^^.01^1
 ;;^DD(.403115,0,"DT")
 ;;=2910204
 ;;^DD(.403115,0,"NM","DESCRIPTION")
 ;;=
 ;;^DD(.403115,0,"UP")
 ;;=.4031
 ;;^DD(.403115,.01,0)
 ;;=DESCRIPTION^W^^0;1^Q
 ;;^DD(.403115,.01,3)
 ;;=Enter text which describes the page.
