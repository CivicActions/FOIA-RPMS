DIPKI002 ; ; 22-DEC-1994 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 Q:'DIFQ(9.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(9.4,5,"DT")
 ;;=2940603
 ;;^DD(9.4,6,0)
 ;;=*FILE^9.44PA^^4;0
 ;;^DD(9.4,6,21,0)
 ;;=^^3^3^2920513^^^^
 ;;^DD(9.4,6,21,1,0)
 ;;=Any FileMan files which are part of this Package are documented
 ;;^DD(9.4,6,21,2,0)
 ;;=here.  This multiple controls what files (Data Dictionaries and
 ;;^DD(9.4,6,21,3,0)
 ;;=Data) are sent in an INIT built from this Package entry.
 ;;^DD(9.4,6,"DT")
 ;;=2940603
 ;;^DD(9.4,7,0)
 ;;=*PRINT TEMPLATE^9.46^^DIPT;0
 ;;^DD(9.4,7,21,0)
 ;;=^^4^4^2921202^^^^
 ;;^DD(9.4,7,21,1,0)
 ;;=The names of Print Templates being sent with this Package.
 ;;^DD(9.4,7,21,2,0)
 ;;=This multiple is used to send non-namespaced templates in an INIT.
 ;;^DD(9.4,7,21,3,0)
 ;;=Namespaced templates are sent automatically and need not be listed
 ;;^DD(9.4,7,21,4,0)
 ;;=separately.
 ;;^DD(9.4,7,"DT")
 ;;=2940603
 ;;^DD(9.4,8,0)
 ;;=*INPUT TEMPLATE^9.47^^DIE;0
 ;;^DD(9.4,8,21,0)
 ;;=^^4^4^2920513^^^
 ;;^DD(9.4,8,21,1,0)
 ;;=The names of the Input Templates being sent with this Package
 ;;^DD(9.4,8,21,2,0)
 ;;=This multiple is used to send non-namespaced templates in an INIT.
 ;;^DD(9.4,8,21,3,0)
 ;;=Namespaced templates are sent automatically and need not be listed
 ;;^DD(9.4,8,21,4,0)
 ;;=separately.
 ;;^DD(9.4,8,"DT")
 ;;=2940603
 ;;^DD(9.4,9,0)
 ;;=*SORT TEMPLATE^9.48^^DIBT;0
 ;;^DD(9.4,9,21,0)
 ;;=^^4^4^2920513^^^
 ;;^DD(9.4,9,21,1,0)
 ;;=The names of the Sort Templates being sent with this Package.
 ;;^DD(9.4,9,21,2,0)
 ;;=This multiple is used to send non-namespaced templates in an INIT.
 ;;^DD(9.4,9,21,3,0)
 ;;=Namespaced templates are sent automatically and need not be listed
 ;;^DD(9.4,9,21,4,0)
 ;;=separately.
 ;;^DD(9.4,9,"DT")
 ;;=2940603
 ;;^DD(9.4,9.1,0)
 ;;=*SCREEN TEMPLATE (FORM)^9.485^^DIST;0
 ;;^DD(9.4,9.1,21,0)
 ;;=^^2^2^2920513^^^
 ;;^DD(9.4,9.1,21,1,0)
 ;;=The names of Screen Templates (from the FORM file) associated with
 ;;^DD(9.4,9.1,21,2,0)
 ;;=this package.
 ;;^DD(9.4,9.1,"DT")
 ;;=2940603
 ;;^DD(9.4,9.5,0)
 ;;=*MENU^9.495^^M;0
 ;;^DD(9.4,9.5,21,0)
 ;;=^^1^1^2920513^^^
 ;;^DD(9.4,9.5,21,1,0)
 ;;=This is the name of a menu-type option in another namespace.
 ;;^DD(9.4,9.5,"DT")
 ;;=2940603
 ;;^DD(9.4,10,0)
 ;;=DEVELOPER (PERSON/SITE)^F^^DEV;1^K:$L(X)>50!($L(X)<2) X
 ;;^DD(9.4,10,3)
 ;;=Please enter the name of the principal Developer and Site (2-50 characters).
 ;;^DD(9.4,10,21,0)
 ;;=^^1^1^2920513^^
 ;;^DD(9.4,10,21,1,0)
 ;;=The name of the principal Developer and Site for this Package.
 ;;^DD(9.4,10.6,0)
 ;;=*LOWEST FILE NUMBER^NJ12,2^^11;1^K:+X'=X!(X>999999999)!(X<0)!(X?.E1"."3N.N) X
 ;;^DD(9.4,10.6,3)
 ;;=Type a Number between 0 and 999999999, 2 Decimal Digits
 ;;^DD(9.4,10.6,21,0)
 ;;=^^1^1^2920513^^^^
 ;;^DD(9.4,10.6,21,1,0)
 ;;=Inclusive lower bound of the range of file numbers allocated to this package.
 ;;^DD(9.4,10.6,"DT")
 ;;=2940603
 ;;^DD(9.4,11,0)
 ;;=*HIGHEST FILE NUMBER^NJ12,2^^11;2^K:+X'=X!(X>999999999)!(X<0)!(X?.E1"."3N.N) X
 ;;^DD(9.4,11,3)
 ;;=Type a Number between 0 and 999999999, 2 Decimal Digits
 ;;^DD(9.4,11,21,0)
 ;;=^^1^1^2920513^^^
 ;;^DD(9.4,11,21,1,0)
 ;;=Inclusive upper bound of the range of file numbers assigned to this package.
 ;;^DD(9.4,11,"DT")
 ;;=2940603
 ;;^DD(9.4,11.01,0)
 ;;=DEVELOPMENT ISC^F^^5;1^K:$L(X)>20!($L(X)<3) X
 ;;^DD(9.4,11.01,3)
 ;;=Please enter the name of the ISC (3-20 characters).
 ;;^DD(9.4,11.01,21,0)
 ;;=^^1^1^2920513^^^
 ;;^DD(9.4,11.01,21,1,0)
 ;;=The ISC responsible for the development and management of this Package.
 ;;^DD(9.4,11.01,"DT")
 ;;=2840815
 ;;^DD(9.4,11.1,0)
 ;;=*MAINTENANCE ISC^F^^7;1^K:$L(X)>20!($L(X)<3) X
 ;;^DD(9.4,11.1,3)
 ;;=Please enter the name of the ISC (3-20 characters).
 ;;^DD(9.4,11.1,21,0)
 ;;=^^1^1^2920513^^^
 ;;^DD(9.4,11.1,21,1,0)
 ;;=The ISC responsible for the support and maintenance of this Package.
 ;;^DD(9.4,11.1,"DT")
 ;;=2940603
 ;;^DD(9.4,11.3,0)
 ;;=CLASS^S^I:National;II:Inactive;III:Local;^7;3^Q
 ;;^DD(9.4,11.3,21,0)
 ;;=^^1^1^2920513^^
 ;;^DD(9.4,11.3,21,1,0)
 ;;=The ranking Class of this software Package.
 ;;^DD(9.4,11.3,"DT")
 ;;=2940325
 ;;^DD(9.4,11.4,0)
 ;;=*VERIFICATION^9.404ID^^8;0
 ;;^DD(9.4,11.4,21,0)
 ;;=^^1^1^2920513^^^
 ;;^DD(9.4,11.4,21,1,0)
 ;;=Information about the verification(s) of this Package.
 ;;^DD(9.4,11.4,"DT")
 ;;=2940603
 ;;^DD(9.4,11.5,0)
 ;;=*ALPHA^P4'^DIC(4,^9;1^Q
 ;;^DD(9.4,11.5,3)
 ;;=Please enter the name of the Alpha Test site.
 ;;^DD(9.4,11.5,21,0)
 ;;=^^1^1^2920513^^^
