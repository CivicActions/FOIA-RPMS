DIPKI00A ; ; 22-DEC-1994 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 Q:'DIFQ(9.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(9.47,.01,21,1,0)
 ;;=The name of an Input Template being sent with this Package.
 ;;^DD(9.47,.01,21,2,0)
 ;;=This multiple is used to send non-namespaced templates in an INIT.
 ;;^DD(9.47,.01,21,3,0)
 ;;=Namespaced templates are sent automatically and need not be listed
 ;;^DD(9.47,.01,21,4,0)
 ;;=separately.
 ;;^DD(9.47,.01,"DT")
 ;;=2821117
 ;;^DD(9.47,2,0)
 ;;=FILE^RP1'^DIC(^0;2^Q
 ;;^DD(9.47,2,21,0)
 ;;=^^1^1^2920513^^
 ;;^DD(9.47,2,21,1,0)
 ;;=The name of the FileMan file for this Input Template.
 ;;^DD(9.47,2,"DT")
 ;;=2821126
 ;;^DD(9.48,0)
 ;;=*SORT TEMPLATE SUB-FIELD^NL^2^2
 ;;^DD(9.48,0,"NM","*SORT TEMPLATE")
 ;;=
 ;;^DD(9.48,0,"UP")
 ;;=9.4
 ;;^DD(9.48,.01,0)
 ;;=SORT TEMPLATE^MF^^0;1^K:$L(X)>50!($L(X)<2) X
 ;;^DD(9.48,.01,1,0)
 ;;=^.1^^0
 ;;^DD(9.48,.01,3)
 ;;=Please enter the name of a Sort Template (2-50 characters).
 ;;^DD(9.48,.01,21,0)
 ;;=^^4^4^2920513^^^
 ;;^DD(9.48,.01,21,1,0)
 ;;=The name of a Sort Template being sent with this Package.
 ;;^DD(9.48,.01,21,2,0)
 ;;=This multiple is used to send non-namespaced templates in an INIT.
 ;;^DD(9.48,.01,21,3,0)
 ;;=Namespaced templates are sent automatically and need not be listed
 ;;^DD(9.48,.01,21,4,0)
 ;;=separately.
 ;;^DD(9.48,.01,"DT")
 ;;=2821117
 ;;^DD(9.48,2,0)
 ;;=FILE^RP1'^DIC(^0;2^Q
 ;;^DD(9.48,2,21,0)
 ;;=^^1^1^2920513^^
 ;;^DD(9.48,2,21,1,0)
 ;;=The FileMan file for this Sort Template.
 ;;^DD(9.485,0)
 ;;=*SCREEN TEMPLATE (FORM) SUB-FIELD^^2^2
 ;;^DD(9.485,0,"DT")
 ;;=2910320
 ;;^DD(9.485,0,"NM","*SCREEN TEMPLATE (FORM)")
 ;;=
 ;;^DD(9.485,0,"UP")
 ;;=9.4
 ;;^DD(9.485,.01,0)
 ;;=SCREEN TEMPLATE (FORM)^MF^^0;1^K:$L(X)>50!($L(X)<2) X
 ;;^DD(9.485,.01,1,0)
 ;;=^.1^^0
 ;;^DD(9.485,.01,3)
 ;;=Please enter the name of a Screen Template (Form), (2-50 characters).
 ;;^DD(9.485,.01,21,0)
 ;;=^^2^2^2920513^^^^
 ;;^DD(9.485,.01,21,1,0)
 ;;=The name of a Screen Template (from the FORM file) associated with
 ;;^DD(9.485,.01,21,2,0)
 ;;=this Package.
 ;;^DD(9.485,.01,23,0)
 ;;=^^3^3^2910320^^^^
 ;;^DD(9.485,.01,23,1,0)
 ;;=This list is originally created by the user for building an INIT, and allows
 ;;^DD(9.485,.01,23,2,0)
 ;;=the user to send FORMS on an INIT that are outside the Package namespace.
 ;;^DD(9.485,.01,23,3,0)
 ;;=All BLOCKS associated with the FORMS are also sent automatically.
 ;;^DD(9.485,.01,"DT")
 ;;=2910320
 ;;^DD(9.485,2,0)
 ;;=FILE^RP1'^DIC(^0;2^Q
 ;;^DD(9.485,2,21,0)
 ;;=^^1^1^2920513^^
 ;;^DD(9.485,2,21,1,0)
 ;;=The name of the FileMan file for this Screen Template (FORM).
 ;;^DD(9.485,2,23,0)
 ;;=^^1^1^2910320^
 ;;^DD(9.485,2,23,1,0)
 ;;=This field must match the PRIMARY FILE field on the FORM file.
 ;;^DD(9.485,2,"DT")
 ;;=2910320
 ;;^DD(9.49,0)
 ;;=VERSION SUB-FIELD^NL^1105^10
 ;;^DD(9.49,0,"DT")
 ;;=2940607
 ;;^DD(9.49,0,"ID",1)
 ;;=W:$D(^("0")) "   ",$E($P(^("0"),U,2),4,5)_"-"_$E($P(^("0"),U,2),6,7)_"-"_$E($P(^("0"),U,2),2,3)
 ;;^DD(9.49,0,"IX","B",9.49,.01)
 ;;=
 ;;^DD(9.49,0,"NM","VERSION")
 ;;=
 ;;^DD(9.49,0,"UP")
 ;;=9.4
 ;;^DD(9.49,.01,0)
 ;;=VERSION^FX^^0;1^K:'(X?1.3N.1".".2N.1A.2N)!(X>999)!(X'>0) X
 ;;^DD(9.49,.01,1,0)
 ;;=^.1
 ;;^DD(9.49,.01,1,1,0)
 ;;=9.49^B
 ;;^DD(9.49,.01,1,1,1)
 ;;=S ^DIC(9.4,DA(1),22,"B",$E(X,1,30),DA)=""
 ;;^DD(9.49,.01,1,1,2)
 ;;=K ^DIC(9.4,DA(1),22,"B",$E(X,1,30),DA)
 ;;^DD(9.49,.01,3)
 ;;=Please enter the Version Number of this release.  This can be either the old method (1.0, 16.04, etc.) or the new (17T1, 6.0V2, etc.).
 ;;^DD(9.49,.01,21,0)
 ;;=^^2^2^2930415^^^^
 ;;^DD(9.49,.01,21,1,0)
 ;;=The version number of this Package.  This number is updated automatically
 ;;^DD(9.49,.01,21,2,0)
 ;;=when an INIT is built for this package.
 ;;^DD(9.49,.01,"DT")
 ;;=2910322
 ;;^DD(9.49,1,0)
 ;;=DATE DISTRIBUTED^D^^0;2^S %DT="E" D ^%DT S X=Y K:Y<1 X
 ;;^DD(9.49,1,21,0)
 ;;=^^2^2^2911209^^^
 ;;^DD(9.49,1,21,1,0)
 ;;=The date this release was distributed.  This field is updated automatically
 ;;^DD(9.49,1,21,2,0)
 ;;=when an INIT is built for this package.
 ;;^DD(9.49,1,"DT")
 ;;=2840227
 ;;^DD(9.49,2,0)
 ;;=DATE INSTALLED AT THIS SITE^D^^0;3^S %DT="ET" D ^%DT S X=Y K:Y<1 X
 ;;^DD(9.49,2,21,0)
 ;;=^^2^2^2911209^^^
 ;;^DD(9.49,2,21,1,0)
 ;;=The date this release was installed at this site.  This field is updated
 ;;^DD(9.49,2,21,2,0)
 ;;=automatically when an INIT is installed for this package.
 ;;^DD(9.49,2,"DT")
 ;;=2840302
 ;;^DD(9.49,3,0)
 ;;=INSTALLED BY^P200'^VA(200,^0;4^Q
 ;;^DD(9.49,3,21,0)
 ;;=^^1^1^2940607^
